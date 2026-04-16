#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct
{
  struct spinlock lock;
  struct proc proc[NPROC];

  // Boletín 4: Colas de prioridad
  struct proc *q_head[NPRIO]; // Punteros al PRIMER proceso de cada cola
  struct proc *q_tail[NPRIO]; // Punteros al ÚLTIMO proceso de cada cola
} ptable;

// BOLETÍN 4: Operaciones de colas de prioridad

// Inserta un proceso al final de su cola de prioridad
void prio_enqueue(struct proc *p)
{
  int prio = p->priority;
  p->next = 0; // Como va al final, no tiene a nadie detrás

  if (ptable.q_head[prio] == 0)
  {
    // Si la cola estaba vacía, él es el primero y el último
    ptable.q_head[prio] = p;
    ptable.q_tail[prio] = p;
  }
  else
  {
    // Si ya hay gente, se pone detrás del último
    ptable.q_tail[prio]->next = p;
    // Y ahora él es el nuevo último
    ptable.q_tail[prio] = p;
  }
}

// Elimina un proceso de su cola de prioridad
void prio_remove(struct proc *p)
{
  int prio = p->priority;
  struct proc *curr = ptable.q_head[prio];
  struct proc *prev = 0;

  // Buscamos el proceso en la cola
  while (curr != 0)
  {
    // Lo encontramos
    if (curr == p)
    {

      if (prev == 0)
      {
        // Era el primero de la fila
        ptable.q_head[prio] = curr->next;
      }
      else
      {
        // Estaba en el medio o al final
        prev->next = curr->next;
      }

      // Si resulta que era el último, actualizamos el puntero q_tail
      if (ptable.q_tail[prio] == curr)
      {
        ptable.q_tail[prio] = prev;
      }

      p->next = 0; // Lo desconectamos totalmente de la fila
      break;
    }
    prev = curr;
    curr = curr->next;
  }
}

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int cpuid()
{
  return mycpu() - cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void)
{
  int apicid, i;

  if (readeflags() & FL_IF)
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i)
  {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void)
{
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

// PAGEBREAK: 32
//  Look in the process table for an UNUSED proc.
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
  {
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe *)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  p->priority = DEFAULT_PRIO; // Boletín 4: Todos los procesos empiezan con prioridad media (5)

  return p;
}

// PAGEBREAK: 32
//  Set up first user process.
void userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();

  initproc = p;
  if ((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0; // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  prio_enqueue(p); // Boletín 4: El proceso inicial se encola en su nivel de prioridad

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if (n > 0)
  {
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  else if (n < 0)
  {
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  lcr3(V2P(curproc->pgdir)); // Invalidate TLB.
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if ((np = allocproc()) == 0)
  {
    return -1;
  }

  // Copy process state from proc.
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
  {
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for (i = 0; i < NOFILE; i++)
    if (curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  np->priority = curproc->priority; // Boletín 4: El hijo hereda la prioridad del padre

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  prio_enqueue(np); // Boletín 4: El proceso recién creado se encola en su nivel de prioridad

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(int status)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if (curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++)
  {
    if (curproc->ofile[fd])
    {
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->parent == curproc)
    {
      p->parent = initproc;
      if (p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Optimize by removing user part
  deallocuvm(curproc->pgdir, KERNBASE, 0);

  curproc->xstatus = status; // Guardamos el regalo para el padre.
  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(int *status)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->parent != curproc)
        continue;
      havekids = 1;
      if (p->state == ZOMBIE)
      {
        // Found one.
        pid = p->pid;

        // SI EL PADRE PASÓ UN PUNTERO VÁLIDO, LE GUARDA EL ESTADO DE SALIDA DEL HIJO.
        if (status != 0)
        {
          *status = p->xstatus;
        }

        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir, 0); // User zone deleted before
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || curproc->killed)
    {
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
  }
}

// PAGEBREAK: 42
//  Per-CPU process scheduler.
//  Each CPU calls scheduler() after setting itself up.
//  Scheduler never returns.  It loops, doing:
//   - choose a process to run
//   - swtch to start running that process
//   - eventually that process transfers control
//       via swtch back to the scheduler.

// Boletin 4: El scheduler ahora se itera sobre las prioridades y no sobre el número de colas.
void scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu(); // Obtenemos la CPU actual
  int prio;

  c->proc = 0;

  for (;;)
  {
    // Habilitar interrupciones en este procesador.
    sti();

    acquire(&ptable.lock);

    // Planificador basado en colas de prioridad estricta.
    // Itera desde la prioridad más alta (0) hasta la más baja (NPRIO - 1).
    for (prio = 0; prio < NPRIO; prio++)
    {

      // Comprobar si hay algún proceso RUNNABLE en la cola de prioridad actual.
      if (ptable.q_head[prio] != 0)
      {

        // Seleccionar el proceso en la cabeza de la cola.
        p = ptable.q_head[prio];

        // Extraer el proceso de la cola de listos antes de su ejecución.
        prio_remove(p);

        // Configurar el espacio de direcciones y ceder la CPU al proceso.
        c->proc = p;
        switchuvm(p);
        p->state = RUNNING;
        swtch(&(c->scheduler), p->context);
        switchkvm();

        // El proceso ha terminado su turno de ejecución por ahora y ha cedido la CPU.
        c->proc = 0;

        // Interrumpir la iteración actual de prioridades.
        // Al salir del bucle 'for', la siguiente iteración comenzará de nuevo en prio = 0,
        // garantizando que siempre se evalúen primero las colas de mayor prioridad.
        break;
      }
    }

    release(&ptable.lock);
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
  int intena;
  struct proc *p = myproc();

  if (!holding(&ptable.lock))
    panic("sched ptable.lock");
  if (mycpu()->ncli != 1)
    panic("sched locks");
  if (p->state == RUNNING)
    panic("sched running");
  if (readeflags() & FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void yield(void)
{
  acquire(&ptable.lock); // DOC: yieldlock
  myproc()->state = RUNNABLE;
  prio_enqueue(myproc()); // Boletín 4: El proceso que cede el CPU se vuelve a encolar en su nivel de prioridad
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first)
  {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if (p == 0)
    panic("sleep");

  if (lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if (lk != &ptable.lock)
  {                        // DOC: sleeplock0
    acquire(&ptable.lock); // DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if (lk != &ptable.lock)
  { // DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

// PAGEBREAK!
//  Wake up all processes sleeping on chan.
//  The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == SLEEPING && p->chan == chan)
    {
      p->state = RUNNABLE;
      prio_enqueue(p); // Boletín 4: El proceso que se despierta se encola en su nivel de prioridad
    }
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
      {
        p->state = RUNNABLE;
        prio_enqueue(p); // Boletín 4: El proceso que se mata se encola en su nivel de prioridad
      }
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
  static char *states[] = {
      [UNUSED] "unused",
      [EMBRYO] "embryo",
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if (p->state == SLEEPING)
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

// BOLETÍN 4: Funciones para obtener y establecer la prioridad de un proceso
//  Devuelve la prioridad de un proceso dado su PID
int getprio(int pid)
{
  struct proc *p;
  int prio = -1;

  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      prio = p->priority;
      break;
    }
  }
  release(&ptable.lock);

  return prio;
}

// Establece una nueva prioridad para un proceso dado su PID
int setprio(int pid, int priority)
{
  struct proc *p;

  // Validar rango de prioridad (0 a NPRIO-1)
  if (priority < 0 || priority >= NPRIO)
    return -1;

  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {

      // Si el proceso ya estaba en una cola de listos (RUNNABLE)
      // hay que sacarlo de la cola vieja y meterlo en la nueva
      if (p->state == RUNNABLE)
      {
        prio_remove(p);
        p->priority = priority;
        prio_enqueue(p);
      }
      else
      {
        // Si está durmiendo o corriendo, solo le cambiamos la etiqueta.
        // Cuando despierte o ceda la CPU, entrará en la cola correcta.
        p->priority = priority;
      }

      release(&ptable.lock);
      return 0; // Éxito
    }
  }
  release(&ptable.lock);

  return -1; // PID no encontrado
}
