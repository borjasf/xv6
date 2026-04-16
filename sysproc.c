#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
  return fork();
}

int sys_exit(void)
{
  int status;
  // Se intenta leer el primer entero (posición 0) de la pila de argumentos del sistema.
  // Si no se puede, se devuelve -1 indicando error.
  if (argint(0, &status) < 0)
    return -1;

  exit(status); // Se llama a la lógica real pasando el estado de salida como argumento.
  return 0;
}

int sys_wait(void)
{
  int *p;
  // Se intenta leer el puntero (posición 0) de la pila de argumentos del sistema.
  // argptr se asegura de que el puntero sea válido para el tamaño de un entero.
  if (argptr(0, (void *)&p, sizeof(*p)) < 0)
    return -1;

  return wait(p); // Se llama a la lógica real pasando el puntero para almacenar el estado de salida del hijo.
}

int sys_kill(void)
{
  int pid;

  if (argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int sys_getpid(void)
{
  return myproc()->pid;
}

int sys_sbrk(void)
{
  int addr;
  int n;
  struct proc *curproc = myproc();

  if (argint(0, &n) < 0)
    return -1;
  addr = curproc->sz;

  if (n > 0)
  { /*RESERVA PEREZOSA: EN LUGAR DE LLAMAR A growproc,
simplemente aumentamos el tamaño del proceso en n bytes.
No reservamos memoria física.
if (growproc(n) < 0)
return -1;*/
    if (curproc->sz + n >= KERNBASE || curproc->sz + n < curproc->sz)
      return -1;

    curproc->sz += n; // Lazy allocation
  }
  else if (n < 0)
  {
    if (growproc(n) < 0)
      return -1;
  }
  return addr;
}

int sys_sleep(void)
{
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_date(void)
{
  struct rtcdate *d;

  if (argptr(0, (void *)&d, sizeof(*d)) < 0)
    return -1;

  cmostime(d);

  return 0;
}

// BOLETIN 4:Declaramos las funciones reales que vivirán en proc.c
int getprio(int pid);
int setprio(int pid, int priority);

int sys_getprio(void)
{
  int pid;
  // Solo recoge el argumento PID
  if (argint(0, &pid) < 0)
    return -1;

  return getprio(pid);
}

int sys_setprio(void)
{
  int pid, priority;
  // Recoge los dos argumentos: PID y la nueva prioridad
  if (argint(0, &pid) < 0)
    return -1;
  if (argint(1, &priority) < 0)
    return -1;

  return setprio(pid, priority);
}
