
tprio:     file format elf32-i386


Disassembly of section .text:

00000000 <burn_cpu>:
#define PRIO_MID 5
#define PRIO_LOW 9

// Función que mantiene la CPU ocupada
void burn_cpu(char *symbol)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int acc = 0;

  for (int i = 0; i < 2500; ++i)
   c:	be 00 00 00 00       	mov    $0x0,%esi
  int acc = 0;
  11:	bb 00 00 00 00       	mov    $0x0,%ebx
  for (int i = 0; i < 2500; ++i)
  16:	eb 29                	jmp    41 <burn_cpu+0x41>
  {
    printf(1, "%s", symbol);

    // Salto de línea cada 64 caracteres para que el patrón visual sea distinto
    if ((i % 64) == 63)
  18:	48                   	dec    %eax
  19:	83 c8 c0             	or     $0xffffffc0,%eax
  1c:	40                   	inc    %eax
  1d:	eb 46                	jmp    65 <burn_cpu+0x65>
    {
      printf(1, "\n");
  1f:	83 ec 08             	sub    $0x8,%esp
  22:	68 5f 05 00 00       	push   $0x55f
  27:	6a 01                	push   $0x1
  29:	e8 cb 03 00 00       	call   3f9 <printf>
  2e:	83 c4 10             	add    $0x10,%esp
  31:	eb 37                	jmp    6a <burn_cpu+0x6a>
    }

    // Bucle pesado para consumir tiempo de procesador
    for (int j = 0; j < 1200000; ++j)
    {
      acc ^= (i + j); // Usamos XOR en lugar de suma para variar la operación
  33:	8d 14 06             	lea    (%esi,%eax,1),%edx
  36:	31 d3                	xor    %edx,%ebx
    for (int j = 0; j < 1200000; ++j)
  38:	40                   	inc    %eax
  39:	3d 7f 4f 12 00       	cmp    $0x124f7f,%eax
  3e:	7e f3                	jle    33 <burn_cpu+0x33>
  for (int i = 0; i < 2500; ++i)
  40:	46                   	inc    %esi
  41:	81 fe c3 09 00 00    	cmp    $0x9c3,%esi
  47:	7f 28                	jg     71 <burn_cpu+0x71>
    printf(1, "%s", symbol);
  49:	83 ec 04             	sub    $0x4,%esp
  4c:	57                   	push   %edi
  4d:	68 5c 05 00 00       	push   $0x55c
  52:	6a 01                	push   $0x1
  54:	e8 a0 03 00 00       	call   3f9 <printf>
    if ((i % 64) == 63)
  59:	83 c4 10             	add    $0x10,%esp
  5c:	89 f0                	mov    %esi,%eax
  5e:	25 3f 00 00 80       	and    $0x8000003f,%eax
  63:	78 b3                	js     18 <burn_cpu+0x18>
  65:	83 f8 3f             	cmp    $0x3f,%eax
  68:	74 b5                	je     1f <burn_cpu+0x1f>
    for (int j = 0; j < 1200000; ++j)
  6a:	b8 00 00 00 00       	mov    $0x0,%eax
  6f:	eb c8                	jmp    39 <burn_cpu+0x39>
    }
  }

  // Imprime el resultado y confirma su prioridad
  printf(1, "\n\n>>> Proceso [%s] FINALIZADO | Resultado op: %d | Prioridad actual: %d <<<\n\n",
  71:	e8 b0 02 00 00       	call   326 <getpid>
  76:	83 ec 0c             	sub    $0xc,%esp
  79:	50                   	push   %eax
  7a:	e8 d7 02 00 00       	call   356 <getprio>
  7f:	89 04 24             	mov    %eax,(%esp)
  82:	53                   	push   %ebx
  83:	57                   	push   %edi
  84:	68 74 05 00 00       	push   $0x574
  89:	6a 01                	push   $0x1
  8b:	e8 69 03 00 00       	call   3f9 <printf>
         symbol, acc, getprio(getpid()));
}
  90:	83 c4 20             	add    $0x20,%esp
  93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  96:	5b                   	pop    %ebx
  97:	5e                   	pop    %esi
  98:	5f                   	pop    %edi
  99:	5d                   	pop    %ebp
  9a:	c3                   	ret

0000009b <main>:

int main(int argc, char *argv[])
{
  9b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  9f:	83 e4 f0             	and    $0xfffffff0,%esp
  a2:	ff 71 fc             	push   -0x4(%ecx)
  a5:	55                   	push   %ebp
  a6:	89 e5                	mov    %esp,%ebp
  a8:	51                   	push   %ecx
  a9:	83 ec 14             	sub    $0x14,%esp
  int pid = fork();
  ac:	e8 ed 01 00 00       	call   29e <fork>

  // El padre original termina para que toda la prueba corra en segundo plano
  if (pid > 0)
  b1:	85 c0                	test   %eax,%eax
  b3:	7e 0a                	jle    bf <main+0x24>
  {
    exit(0);
  b5:	83 ec 0c             	sub    $0xc,%esp
  b8:	6a 00                	push   $0x0
  ba:	e8 e7 01 00 00       	call   2a6 <exit>
  }

  printf(1, "[Fase 1] Lanzando procesos de prueba.\n");
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	68 c4 05 00 00       	push   $0x5c4
  c7:	6a 01                	push   $0x1
  c9:	e8 2b 03 00 00       	call   3f9 <printf>
  printf(1, "Hay 4 procesos ejecutandose: 3 de baja prioridad (9) y 1 normal (5).\n");
  ce:	83 c4 08             	add    $0x8,%esp
  d1:	68 ec 05 00 00       	push   $0x5ec
  d6:	6a 01                	push   $0x1
  d8:	e8 1c 03 00 00       	call   3f9 <printf>
  printf(1, "Deberian verse los caracteres intercalados por el Round-Robin.\n");
  dd:	83 c4 08             	add    $0x8,%esp
  e0:	68 34 06 00 00       	push   $0x634
  e5:	6a 01                	push   $0x1
  e7:	e8 0d 03 00 00       	call   3f9 <printf>

  // Lanzamos los procesos secuencialmente de forma más limpia
  if (fork() == 0)
  ec:	e8 ad 01 00 00       	call   29e <fork>
  f1:	83 c4 10             	add    $0x10,%esp
  f4:	85 c0                	test   %eax,%eax
  f6:	75 28                	jne    120 <main+0x85>
  {
    setprio(getpid(), PRIO_LOW);
  f8:	e8 29 02 00 00       	call   326 <getpid>
  fd:	83 ec 08             	sub    $0x8,%esp
 100:	6a 09                	push   $0x9
 102:	50                   	push   %eax
 103:	e8 56 02 00 00       	call   35e <setprio>
    burn_cpu(".");
 108:	c7 04 24 61 05 00 00 	movl   $0x561,(%esp)
 10f:	e8 ec fe ff ff       	call   0 <burn_cpu>
    exit(0);
 114:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11b:	e8 86 01 00 00       	call   2a6 <exit>
  }
  if (fork() == 0)
 120:	e8 79 01 00 00       	call   29e <fork>
 125:	85 c0                	test   %eax,%eax
 127:	75 28                	jne    151 <main+0xb6>
  {
    setprio(getpid(), PRIO_LOW);
 129:	e8 f8 01 00 00       	call   326 <getpid>
 12e:	83 ec 08             	sub    $0x8,%esp
 131:	6a 09                	push   $0x9
 133:	50                   	push   %eax
 134:	e8 25 02 00 00       	call   35e <setprio>
    burn_cpu("~");
 139:	c7 04 24 63 05 00 00 	movl   $0x563,(%esp)
 140:	e8 bb fe ff ff       	call   0 <burn_cpu>
    exit(0);
 145:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 14c:	e8 55 01 00 00       	call   2a6 <exit>
  }
  if (fork() == 0)
 151:	e8 48 01 00 00       	call   29e <fork>
 156:	85 c0                	test   %eax,%eax
 158:	75 28                	jne    182 <main+0xe7>
  {
    setprio(getpid(), PRIO_MID); // Prioridad 5 (competirá con el shell)
 15a:	e8 c7 01 00 00       	call   326 <getpid>
 15f:	83 ec 08             	sub    $0x8,%esp
 162:	6a 05                	push   $0x5
 164:	50                   	push   %eax
 165:	e8 f4 01 00 00       	call   35e <setprio>
    burn_cpu("#");
 16a:	c7 04 24 65 05 00 00 	movl   $0x565,(%esp)
 171:	e8 8a fe ff ff       	call   0 <burn_cpu>
    exit(0);
 176:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 17d:	e8 24 01 00 00       	call   2a6 <exit>
  }
  if (fork() == 0)
 182:	e8 17 01 00 00       	call   29e <fork>
 187:	85 c0                	test   %eax,%eax
 189:	75 28                	jne    1b3 <main+0x118>
  {
    setprio(getpid(), PRIO_LOW);
 18b:	e8 96 01 00 00       	call   326 <getpid>
 190:	83 ec 08             	sub    $0x8,%esp
 193:	6a 09                	push   $0x9
 195:	50                   	push   %eax
 196:	e8 c3 01 00 00       	call   35e <setprio>
    burn_cpu("@");
 19b:	c7 04 24 67 05 00 00 	movl   $0x567,(%esp)
 1a2:	e8 59 fe ff ff       	call   0 <burn_cpu>
    exit(0);
 1a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1ae:	e8 f3 00 00 00       	call   2a6 <exit>
  }

  printf(1, "\n[Fase 2] El proceso despachador duerme 5 segundos (aprox).\n");
 1b3:	83 ec 08             	sub    $0x8,%esp
 1b6:	68 74 06 00 00       	push   $0x674
 1bb:	6a 01                	push   $0x1
 1bd:	e8 37 02 00 00       	call   3f9 <printf>
  printf(1, "Prueba a interactuar con el shell ahora. Deberia responder bien al tener prioridad 5.\n");
 1c2:	83 c4 08             	add    $0x8,%esp
 1c5:	68 b4 06 00 00       	push   $0x6b4
 1ca:	6a 01                	push   $0x1
 1cc:	e8 28 02 00 00       	call   3f9 <printf>

  // 500 ticks equivalen aproximadamente a 5 segundos
  sleep(500);
 1d1:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
 1d8:	e8 59 01 00 00       	call   336 <sleep>

  printf(1, "\n[Fase 3] Despertando y lanzando 2 procesos de ALTA prioridad (0 y 1).\n");
 1dd:	83 c4 08             	add    $0x8,%esp
 1e0:	68 0c 07 00 00       	push   $0x70c
 1e5:	6a 01                	push   $0x1
 1e7:	e8 0d 02 00 00       	call   3f9 <printf>
  printf(1, "Ahora el shell quedara bloqueado hasta que estos dos terminen.\n");
 1ec:	83 c4 08             	add    $0x8,%esp
 1ef:	68 54 07 00 00       	push   $0x754
 1f4:	6a 01                	push   $0x1
 1f6:	e8 fe 01 00 00       	call   3f9 <printf>
  printf(1, "Luego deberian seguir los de baja prioridad que aun no han terminado.\n");
 1fb:	83 c4 08             	add    $0x8,%esp
 1fe:	68 94 07 00 00       	push   $0x794
 203:	6a 01                	push   $0x1
 205:	e8 ef 01 00 00       	call   3f9 <printf>

  if (fork() == 0)
 20a:	e8 8f 00 00 00       	call   29e <fork>
 20f:	83 c4 10             	add    $0x10,%esp
 212:	85 c0                	test   %eax,%eax
 214:	75 28                	jne    23e <main+0x1a3>
  {
    setprio(getpid(), PRIO_HIGH); // Prioridad 0 (absoluta)
 216:	e8 0b 01 00 00       	call   326 <getpid>
 21b:	83 ec 08             	sub    $0x8,%esp
 21e:	6a 00                	push   $0x0
 220:	50                   	push   %eax
 221:	e8 38 01 00 00       	call   35e <setprio>
    burn_cpu("!");
 226:	c7 04 24 69 05 00 00 	movl   $0x569,(%esp)
 22d:	e8 ce fd ff ff       	call   0 <burn_cpu>
    exit(0);
 232:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 239:	e8 68 00 00 00       	call   2a6 <exit>
  }
  if (fork() == 0)
 23e:	e8 5b 00 00 00       	call   29e <fork>
 243:	85 c0                	test   %eax,%eax
 245:	74 2f                	je     276 <main+0x1db>
    exit(0);
  }

  // Esperar pacientemente a que todos los hijos terminen antes de salir
  int status;
  while (wait(&status) != -1)
 247:	83 ec 0c             	sub    $0xc,%esp
 24a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 24d:	50                   	push   %eax
 24e:	e8 5b 00 00 00       	call   2ae <wait>
 253:	83 c4 10             	add    $0x10,%esp
 256:	83 f8 ff             	cmp    $0xffffffff,%eax
 259:	75 ec                	jne    247 <main+0x1ac>
    ;

  printf(1, "\n[Fin] Todos los procesos de la prueba tprio han terminado.\n");
 25b:	83 ec 08             	sub    $0x8,%esp
 25e:	68 dc 07 00 00       	push   $0x7dc
 263:	6a 01                	push   $0x1
 265:	e8 8f 01 00 00       	call   3f9 <printf>
  exit(0);
 26a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 271:	e8 30 00 00 00       	call   2a6 <exit>
    setprio(getpid(), PRIO_HIGH + 1); // Prioridad 1
 276:	e8 ab 00 00 00       	call   326 <getpid>
 27b:	83 ec 08             	sub    $0x8,%esp
 27e:	6a 01                	push   $0x1
 280:	50                   	push   %eax
 281:	e8 d8 00 00 00       	call   35e <setprio>
    burn_cpu("$");
 286:	c7 04 24 6b 05 00 00 	movl   $0x56b,(%esp)
 28d:	e8 6e fd ff ff       	call   0 <burn_cpu>
    exit(0);
 292:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 299:	e8 08 00 00 00       	call   2a6 <exit>

0000029e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 29e:	b8 01 00 00 00       	mov    $0x1,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret

000002a6 <exit>:
SYSCALL(exit)
 2a6:	b8 02 00 00 00       	mov    $0x2,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret

000002ae <wait>:
SYSCALL(wait)
 2ae:	b8 03 00 00 00       	mov    $0x3,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret

000002b6 <pipe>:
SYSCALL(pipe)
 2b6:	b8 04 00 00 00       	mov    $0x4,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret

000002be <read>:
SYSCALL(read)
 2be:	b8 05 00 00 00       	mov    $0x5,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret

000002c6 <write>:
SYSCALL(write)
 2c6:	b8 10 00 00 00       	mov    $0x10,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret

000002ce <close>:
SYSCALL(close)
 2ce:	b8 15 00 00 00       	mov    $0x15,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret

000002d6 <kill>:
SYSCALL(kill)
 2d6:	b8 06 00 00 00       	mov    $0x6,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret

000002de <exec>:
SYSCALL(exec)
 2de:	b8 07 00 00 00       	mov    $0x7,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret

000002e6 <open>:
SYSCALL(open)
 2e6:	b8 0f 00 00 00       	mov    $0xf,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret

000002ee <mknod>:
SYSCALL(mknod)
 2ee:	b8 11 00 00 00       	mov    $0x11,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret

000002f6 <unlink>:
SYSCALL(unlink)
 2f6:	b8 12 00 00 00       	mov    $0x12,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret

000002fe <fstat>:
SYSCALL(fstat)
 2fe:	b8 08 00 00 00       	mov    $0x8,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret

00000306 <link>:
SYSCALL(link)
 306:	b8 13 00 00 00       	mov    $0x13,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret

0000030e <mkdir>:
SYSCALL(mkdir)
 30e:	b8 14 00 00 00       	mov    $0x14,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret

00000316 <chdir>:
SYSCALL(chdir)
 316:	b8 09 00 00 00       	mov    $0x9,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret

0000031e <dup>:
SYSCALL(dup)
 31e:	b8 0a 00 00 00       	mov    $0xa,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret

00000326 <getpid>:
SYSCALL(getpid)
 326:	b8 0b 00 00 00       	mov    $0xb,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret

0000032e <sbrk>:
SYSCALL(sbrk)
 32e:	b8 0c 00 00 00       	mov    $0xc,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret

00000336 <sleep>:
SYSCALL(sleep)
 336:	b8 0d 00 00 00       	mov    $0xd,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret

0000033e <uptime>:
SYSCALL(uptime)
 33e:	b8 0e 00 00 00       	mov    $0xe,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret

00000346 <date>:
SYSCALL(date)
 346:	b8 16 00 00 00       	mov    $0x16,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret

0000034e <dup2>:
SYSCALL(dup2)
 34e:	b8 17 00 00 00       	mov    $0x17,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret

00000356 <getprio>:
SYSCALL(getprio)
 356:	b8 18 00 00 00       	mov    $0x18,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret

0000035e <setprio>:
 35e:	b8 19 00 00 00       	mov    $0x19,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret

00000366 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 366:	55                   	push   %ebp
 367:	89 e5                	mov    %esp,%ebp
 369:	83 ec 1c             	sub    $0x1c,%esp
 36c:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 36f:	6a 01                	push   $0x1
 371:	8d 55 f4             	lea    -0xc(%ebp),%edx
 374:	52                   	push   %edx
 375:	50                   	push   %eax
 376:	e8 4b ff ff ff       	call   2c6 <write>
}
 37b:	83 c4 10             	add    $0x10,%esp
 37e:	c9                   	leave
 37f:	c3                   	ret

00000380 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	53                   	push   %ebx
 386:	83 ec 2c             	sub    $0x2c,%esp
 389:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 38c:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 392:	74 04                	je     398 <printint+0x18>
 394:	85 d2                	test   %edx,%edx
 396:	78 3c                	js     3d4 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 398:	89 d1                	mov    %edx,%ecx
  neg = 0;
 39a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 3a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3a6:	89 c8                	mov    %ecx,%eax
 3a8:	ba 00 00 00 00       	mov    $0x0,%edx
 3ad:	f7 f6                	div    %esi
 3af:	89 df                	mov    %ebx,%edi
 3b1:	43                   	inc    %ebx
 3b2:	8a 92 74 08 00 00    	mov    0x874(%edx),%dl
 3b8:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3bc:	89 ca                	mov    %ecx,%edx
 3be:	89 c1                	mov    %eax,%ecx
 3c0:	39 f2                	cmp    %esi,%edx
 3c2:	73 e2                	jae    3a6 <printint+0x26>
  if(neg)
 3c4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 3c8:	74 24                	je     3ee <printint+0x6e>
    buf[i++] = '-';
 3ca:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3cf:	8d 5f 02             	lea    0x2(%edi),%ebx
 3d2:	eb 1a                	jmp    3ee <printint+0x6e>
    x = -xx;
 3d4:	89 d1                	mov    %edx,%ecx
 3d6:	f7 d9                	neg    %ecx
    neg = 1;
 3d8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 3df:	eb c0                	jmp    3a1 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 3e1:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 3e9:	e8 78 ff ff ff       	call   366 <putc>
  while(--i >= 0)
 3ee:	4b                   	dec    %ebx
 3ef:	79 f0                	jns    3e1 <printint+0x61>
}
 3f1:	83 c4 2c             	add    $0x2c,%esp
 3f4:	5b                   	pop    %ebx
 3f5:	5e                   	pop    %esi
 3f6:	5f                   	pop    %edi
 3f7:	5d                   	pop    %ebp
 3f8:	c3                   	ret

000003f9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3f9:	55                   	push   %ebp
 3fa:	89 e5                	mov    %esp,%ebp
 3fc:	57                   	push   %edi
 3fd:	56                   	push   %esi
 3fe:	53                   	push   %ebx
 3ff:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 402:	8d 45 10             	lea    0x10(%ebp),%eax
 405:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 408:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 40d:	bb 00 00 00 00       	mov    $0x0,%ebx
 412:	eb 12                	jmp    426 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 414:	89 fa                	mov    %edi,%edx
 416:	8b 45 08             	mov    0x8(%ebp),%eax
 419:	e8 48 ff ff ff       	call   366 <putc>
 41e:	eb 05                	jmp    425 <printf+0x2c>
      }
    } else if(state == '%'){
 420:	83 fe 25             	cmp    $0x25,%esi
 423:	74 22                	je     447 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 425:	43                   	inc    %ebx
 426:	8b 45 0c             	mov    0xc(%ebp),%eax
 429:	8a 04 18             	mov    (%eax,%ebx,1),%al
 42c:	84 c0                	test   %al,%al
 42e:	0f 84 1d 01 00 00    	je     551 <printf+0x158>
    c = fmt[i] & 0xff;
 434:	0f be f8             	movsbl %al,%edi
 437:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 43a:	85 f6                	test   %esi,%esi
 43c:	75 e2                	jne    420 <printf+0x27>
      if(c == '%'){
 43e:	83 f8 25             	cmp    $0x25,%eax
 441:	75 d1                	jne    414 <printf+0x1b>
        state = '%';
 443:	89 c6                	mov    %eax,%esi
 445:	eb de                	jmp    425 <printf+0x2c>
      if(c == 'd'){
 447:	83 f8 25             	cmp    $0x25,%eax
 44a:	0f 84 cc 00 00 00    	je     51c <printf+0x123>
 450:	0f 8c da 00 00 00    	jl     530 <printf+0x137>
 456:	83 f8 78             	cmp    $0x78,%eax
 459:	0f 8f d1 00 00 00    	jg     530 <printf+0x137>
 45f:	83 f8 63             	cmp    $0x63,%eax
 462:	0f 8c c8 00 00 00    	jl     530 <printf+0x137>
 468:	83 e8 63             	sub    $0x63,%eax
 46b:	83 f8 15             	cmp    $0x15,%eax
 46e:	0f 87 bc 00 00 00    	ja     530 <printf+0x137>
 474:	ff 24 85 1c 08 00 00 	jmp    *0x81c(,%eax,4)
        printint(fd, *ap, 10, 1);
 47b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 47e:	8b 17                	mov    (%edi),%edx
 480:	83 ec 0c             	sub    $0xc,%esp
 483:	6a 01                	push   $0x1
 485:	b9 0a 00 00 00       	mov    $0xa,%ecx
 48a:	8b 45 08             	mov    0x8(%ebp),%eax
 48d:	e8 ee fe ff ff       	call   380 <printint>
        ap++;
 492:	83 c7 04             	add    $0x4,%edi
 495:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 498:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 49b:	be 00 00 00 00       	mov    $0x0,%esi
 4a0:	eb 83                	jmp    425 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4a5:	8b 17                	mov    (%edi),%edx
 4a7:	83 ec 0c             	sub    $0xc,%esp
 4aa:	6a 00                	push   $0x0
 4ac:	b9 10 00 00 00       	mov    $0x10,%ecx
 4b1:	8b 45 08             	mov    0x8(%ebp),%eax
 4b4:	e8 c7 fe ff ff       	call   380 <printint>
        ap++;
 4b9:	83 c7 04             	add    $0x4,%edi
 4bc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4bf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c2:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 4c7:	e9 59 ff ff ff       	jmp    425 <printf+0x2c>
        s = (char*)*ap;
 4cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4cf:	8b 30                	mov    (%eax),%esi
        ap++;
 4d1:	83 c0 04             	add    $0x4,%eax
 4d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4d7:	85 f6                	test   %esi,%esi
 4d9:	75 13                	jne    4ee <printf+0xf5>
          s = "(null)";
 4db:	be 6d 05 00 00       	mov    $0x56d,%esi
 4e0:	eb 0c                	jmp    4ee <printf+0xf5>
          putc(fd, *s);
 4e2:	0f be d2             	movsbl %dl,%edx
 4e5:	8b 45 08             	mov    0x8(%ebp),%eax
 4e8:	e8 79 fe ff ff       	call   366 <putc>
          s++;
 4ed:	46                   	inc    %esi
        while(*s != 0){
 4ee:	8a 16                	mov    (%esi),%dl
 4f0:	84 d2                	test   %dl,%dl
 4f2:	75 ee                	jne    4e2 <printf+0xe9>
      state = 0;
 4f4:	be 00 00 00 00       	mov    $0x0,%esi
 4f9:	e9 27 ff ff ff       	jmp    425 <printf+0x2c>
        putc(fd, *ap);
 4fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 501:	0f be 17             	movsbl (%edi),%edx
 504:	8b 45 08             	mov    0x8(%ebp),%eax
 507:	e8 5a fe ff ff       	call   366 <putc>
        ap++;
 50c:	83 c7 04             	add    $0x4,%edi
 50f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 512:	be 00 00 00 00       	mov    $0x0,%esi
 517:	e9 09 ff ff ff       	jmp    425 <printf+0x2c>
        putc(fd, c);
 51c:	89 fa                	mov    %edi,%edx
 51e:	8b 45 08             	mov    0x8(%ebp),%eax
 521:	e8 40 fe ff ff       	call   366 <putc>
      state = 0;
 526:	be 00 00 00 00       	mov    $0x0,%esi
 52b:	e9 f5 fe ff ff       	jmp    425 <printf+0x2c>
        putc(fd, '%');
 530:	ba 25 00 00 00       	mov    $0x25,%edx
 535:	8b 45 08             	mov    0x8(%ebp),%eax
 538:	e8 29 fe ff ff       	call   366 <putc>
        putc(fd, c);
 53d:	89 fa                	mov    %edi,%edx
 53f:	8b 45 08             	mov    0x8(%ebp),%eax
 542:	e8 1f fe ff ff       	call   366 <putc>
      state = 0;
 547:	be 00 00 00 00       	mov    $0x0,%esi
 54c:	e9 d4 fe ff ff       	jmp    425 <printf+0x2c>
    }
  }
}
 551:	8d 65 f4             	lea    -0xc(%ebp),%esp
 554:	5b                   	pop    %ebx
 555:	5e                   	pop    %esi
 556:	5f                   	pop    %edi
 557:	5d                   	pop    %ebp
 558:	c3                   	ret
