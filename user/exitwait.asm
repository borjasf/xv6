
exitwait:     file format elf32-i386


Disassembly of section .text:

00000000 <forktest>:

#define N  1000

void
forktest(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 1c             	sub    $0x1c,%esp
  int n, pid;
  int status;

  printf(1, "exit/wait with status test\n");
   7:	68 08 04 00 00       	push   $0x408
   c:	6a 01                	push   $0x1
   e:	e8 94 02 00 00       	call   2a7 <printf>

  for(n=0; n<N; n++){
  13:	83 c4 10             	add    $0x10,%esp
  16:	bb 00 00 00 00       	mov    $0x0,%ebx
  1b:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
  21:	7f 38                	jg     5b <forktest+0x5b>
    pid = fork();
  23:	e8 24 01 00 00       	call   14c <fork>
    if(pid < 0)
  28:	85 c0                	test   %eax,%eax
  2a:	78 2f                	js     5b <forktest+0x5b>
      break;
    if(pid == 0)
  2c:	74 03                	je     31 <forktest+0x31>
  for(n=0; n<N; n++){
  2e:	43                   	inc    %ebx
  2f:	eb ea                	jmp    1b <forktest+0x1b>
      exit(n - 1/(n/40));  // Some process will fail with divide by 0
  31:	b8 67 66 66 66       	mov    $0x66666667,%eax
  36:	f7 eb                	imul   %ebx
  38:	89 d1                	mov    %edx,%ecx
  3a:	c1 f9 04             	sar    $0x4,%ecx
  3d:	89 d8                	mov    %ebx,%eax
  3f:	c1 f8 1f             	sar    $0x1f,%eax
  42:	29 c1                	sub    %eax,%ecx
  44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  49:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  4e:	f7 f9                	idiv   %ecx
  50:	83 ec 0c             	sub    $0xc,%esp
  53:	01 d8                	add    %ebx,%eax
  55:	50                   	push   %eax
  56:	e8 f9 00 00 00       	call   154 <exit>
  }

  if(n == N)
  5b:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  61:	75 4e                	jne    b1 <forktest+0xb1>
  {
    printf(1, "fork claimed to work %d times!\n", N);
  63:	83 ec 04             	sub    $0x4,%esp
  66:	68 e8 03 00 00       	push   $0x3e8
  6b:	68 80 04 00 00       	push   $0x480
  70:	6a 01                	push   $0x1
  72:	e8 30 02 00 00       	call   2a7 <printf>
    exit(N);
  77:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
  7e:	e8 d1 00 00 00       	call   154 <exit>

  for(; n > 0; n--)
  {
    if((pid = wait(&status)) < 0)
    {
      printf(1, "wait stopped early\n");
  83:	83 ec 08             	sub    $0x8,%esp
  86:	68 24 04 00 00       	push   $0x424
  8b:	6a 01                	push   $0x1
  8d:	e8 15 02 00 00       	call   2a7 <printf>
      exit(-1);
  92:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  99:	e8 b6 00 00 00       	call   154 <exit>
    }
    if (WIFEXITED (status))
      printf (1, "Exited child %d, exitcode %d\n", pid, WEXITSTATUS (status));
    else if (WIFSIGNALED(status))
      printf (1, "Exited child (failure) %d, trap %d\n", pid, WEXITTRAP (status));
  9e:	49                   	dec    %ecx
  9f:	51                   	push   %ecx
  a0:	50                   	push   %eax
  a1:	68 a0 04 00 00       	push   $0x4a0
  a6:	6a 01                	push   $0x1
  a8:	e8 fa 01 00 00       	call   2a7 <printf>
  ad:	83 c4 10             	add    $0x10,%esp
  for(; n > 0; n--)
  b0:	4b                   	dec    %ebx
  b1:	85 db                	test   %ebx,%ebx
  b3:	7e 33                	jle    e8 <forktest+0xe8>
    if((pid = wait(&status)) < 0)
  b5:	83 ec 0c             	sub    $0xc,%esp
  b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  bb:	50                   	push   %eax
  bc:	e8 9b 00 00 00       	call   15c <wait>
  c1:	83 c4 10             	add    $0x10,%esp
  c4:	85 c0                	test   %eax,%eax
  c6:	78 bb                	js     83 <forktest+0x83>
    if (WIFEXITED (status))
  c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  cb:	89 d1                	mov    %edx,%ecx
  cd:	83 e1 7f             	and    $0x7f,%ecx
  d0:	75 cc                	jne    9e <forktest+0x9e>
      printf (1, "Exited child %d, exitcode %d\n", pid, WEXITSTATUS (status));
  d2:	0f b6 d6             	movzbl %dh,%edx
  d5:	52                   	push   %edx
  d6:	50                   	push   %eax
  d7:	68 38 04 00 00       	push   $0x438
  dc:	6a 01                	push   $0x1
  de:	e8 c4 01 00 00       	call   2a7 <printf>
  e3:	83 c4 10             	add    $0x10,%esp
  e6:	eb c8                	jmp    b0 <forktest+0xb0>
  }

  if(wait(0) != -1){
  e8:	83 ec 0c             	sub    $0xc,%esp
  eb:	6a 00                	push   $0x0
  ed:	e8 6a 00 00 00       	call   15c <wait>
  f2:	83 c4 10             	add    $0x10,%esp
  f5:	83 f8 ff             	cmp    $0xffffffff,%eax
  f8:	75 17                	jne    111 <forktest+0x111>
    printf(1, "wait got too many\n");
    exit(-1);
  }

  printf(1, "fork test OK\n");
  fa:	83 ec 08             	sub    $0x8,%esp
  fd:	68 69 04 00 00       	push   $0x469
 102:	6a 01                	push   $0x1
 104:	e8 9e 01 00 00       	call   2a7 <printf>
}
 109:	83 c4 10             	add    $0x10,%esp
 10c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 10f:	c9                   	leave
 110:	c3                   	ret
    printf(1, "wait got too many\n");
 111:	83 ec 08             	sub    $0x8,%esp
 114:	68 56 04 00 00       	push   $0x456
 119:	6a 01                	push   $0x1
 11b:	e8 87 01 00 00       	call   2a7 <printf>
    exit(-1);
 120:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 127:	e8 28 00 00 00       	call   154 <exit>

0000012c <main>:

int
main(void)
{
 12c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 130:	83 e4 f0             	and    $0xfffffff0,%esp
 133:	ff 71 fc             	push   -0x4(%ecx)
 136:	55                   	push   %ebp
 137:	89 e5                	mov    %esp,%ebp
 139:	51                   	push   %ecx
 13a:	83 ec 04             	sub    $0x4,%esp
  forktest();
 13d:	e8 be fe ff ff       	call   0 <forktest>
  exit(0);
 142:	83 ec 0c             	sub    $0xc,%esp
 145:	6a 00                	push   $0x0
 147:	e8 08 00 00 00       	call   154 <exit>

0000014c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 14c:	b8 01 00 00 00       	mov    $0x1,%eax
 151:	cd 40                	int    $0x40
 153:	c3                   	ret

00000154 <exit>:
SYSCALL(exit)
 154:	b8 02 00 00 00       	mov    $0x2,%eax
 159:	cd 40                	int    $0x40
 15b:	c3                   	ret

0000015c <wait>:
SYSCALL(wait)
 15c:	b8 03 00 00 00       	mov    $0x3,%eax
 161:	cd 40                	int    $0x40
 163:	c3                   	ret

00000164 <pipe>:
SYSCALL(pipe)
 164:	b8 04 00 00 00       	mov    $0x4,%eax
 169:	cd 40                	int    $0x40
 16b:	c3                   	ret

0000016c <read>:
SYSCALL(read)
 16c:	b8 05 00 00 00       	mov    $0x5,%eax
 171:	cd 40                	int    $0x40
 173:	c3                   	ret

00000174 <write>:
SYSCALL(write)
 174:	b8 10 00 00 00       	mov    $0x10,%eax
 179:	cd 40                	int    $0x40
 17b:	c3                   	ret

0000017c <close>:
SYSCALL(close)
 17c:	b8 15 00 00 00       	mov    $0x15,%eax
 181:	cd 40                	int    $0x40
 183:	c3                   	ret

00000184 <kill>:
SYSCALL(kill)
 184:	b8 06 00 00 00       	mov    $0x6,%eax
 189:	cd 40                	int    $0x40
 18b:	c3                   	ret

0000018c <exec>:
SYSCALL(exec)
 18c:	b8 07 00 00 00       	mov    $0x7,%eax
 191:	cd 40                	int    $0x40
 193:	c3                   	ret

00000194 <open>:
SYSCALL(open)
 194:	b8 0f 00 00 00       	mov    $0xf,%eax
 199:	cd 40                	int    $0x40
 19b:	c3                   	ret

0000019c <mknod>:
SYSCALL(mknod)
 19c:	b8 11 00 00 00       	mov    $0x11,%eax
 1a1:	cd 40                	int    $0x40
 1a3:	c3                   	ret

000001a4 <unlink>:
SYSCALL(unlink)
 1a4:	b8 12 00 00 00       	mov    $0x12,%eax
 1a9:	cd 40                	int    $0x40
 1ab:	c3                   	ret

000001ac <fstat>:
SYSCALL(fstat)
 1ac:	b8 08 00 00 00       	mov    $0x8,%eax
 1b1:	cd 40                	int    $0x40
 1b3:	c3                   	ret

000001b4 <link>:
SYSCALL(link)
 1b4:	b8 13 00 00 00       	mov    $0x13,%eax
 1b9:	cd 40                	int    $0x40
 1bb:	c3                   	ret

000001bc <mkdir>:
SYSCALL(mkdir)
 1bc:	b8 14 00 00 00       	mov    $0x14,%eax
 1c1:	cd 40                	int    $0x40
 1c3:	c3                   	ret

000001c4 <chdir>:
SYSCALL(chdir)
 1c4:	b8 09 00 00 00       	mov    $0x9,%eax
 1c9:	cd 40                	int    $0x40
 1cb:	c3                   	ret

000001cc <dup>:
SYSCALL(dup)
 1cc:	b8 0a 00 00 00       	mov    $0xa,%eax
 1d1:	cd 40                	int    $0x40
 1d3:	c3                   	ret

000001d4 <getpid>:
SYSCALL(getpid)
 1d4:	b8 0b 00 00 00       	mov    $0xb,%eax
 1d9:	cd 40                	int    $0x40
 1db:	c3                   	ret

000001dc <sbrk>:
SYSCALL(sbrk)
 1dc:	b8 0c 00 00 00       	mov    $0xc,%eax
 1e1:	cd 40                	int    $0x40
 1e3:	c3                   	ret

000001e4 <sleep>:
SYSCALL(sleep)
 1e4:	b8 0d 00 00 00       	mov    $0xd,%eax
 1e9:	cd 40                	int    $0x40
 1eb:	c3                   	ret

000001ec <uptime>:
SYSCALL(uptime)
 1ec:	b8 0e 00 00 00       	mov    $0xe,%eax
 1f1:	cd 40                	int    $0x40
 1f3:	c3                   	ret

000001f4 <date>:
SYSCALL(date)
 1f4:	b8 16 00 00 00       	mov    $0x16,%eax
 1f9:	cd 40                	int    $0x40
 1fb:	c3                   	ret

000001fc <dup2>:
SYSCALL(dup2)
 1fc:	b8 17 00 00 00       	mov    $0x17,%eax
 201:	cd 40                	int    $0x40
 203:	c3                   	ret

00000204 <getprio>:
SYSCALL(getprio)
 204:	b8 18 00 00 00       	mov    $0x18,%eax
 209:	cd 40                	int    $0x40
 20b:	c3                   	ret

0000020c <setprio>:
 20c:	b8 19 00 00 00       	mov    $0x19,%eax
 211:	cd 40                	int    $0x40
 213:	c3                   	ret

00000214 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	83 ec 1c             	sub    $0x1c,%esp
 21a:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 21d:	6a 01                	push   $0x1
 21f:	8d 55 f4             	lea    -0xc(%ebp),%edx
 222:	52                   	push   %edx
 223:	50                   	push   %eax
 224:	e8 4b ff ff ff       	call   174 <write>
}
 229:	83 c4 10             	add    $0x10,%esp
 22c:	c9                   	leave
 22d:	c3                   	ret

0000022e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
 231:	57                   	push   %edi
 232:	56                   	push   %esi
 233:	53                   	push   %ebx
 234:	83 ec 2c             	sub    $0x2c,%esp
 237:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 23a:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 23c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 240:	74 04                	je     246 <printint+0x18>
 242:	85 d2                	test   %edx,%edx
 244:	78 3c                	js     282 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 246:	89 d1                	mov    %edx,%ecx
  neg = 0;
 248:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 24f:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 254:	89 c8                	mov    %ecx,%eax
 256:	ba 00 00 00 00       	mov    $0x0,%edx
 25b:	f7 f6                	div    %esi
 25d:	89 df                	mov    %ebx,%edi
 25f:	43                   	inc    %ebx
 260:	8a 92 1c 05 00 00    	mov    0x51c(%edx),%dl
 266:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 26a:	89 ca                	mov    %ecx,%edx
 26c:	89 c1                	mov    %eax,%ecx
 26e:	39 f2                	cmp    %esi,%edx
 270:	73 e2                	jae    254 <printint+0x26>
  if(neg)
 272:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 276:	74 24                	je     29c <printint+0x6e>
    buf[i++] = '-';
 278:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 27d:	8d 5f 02             	lea    0x2(%edi),%ebx
 280:	eb 1a                	jmp    29c <printint+0x6e>
    x = -xx;
 282:	89 d1                	mov    %edx,%ecx
 284:	f7 d9                	neg    %ecx
    neg = 1;
 286:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 28d:	eb c0                	jmp    24f <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 28f:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 294:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 297:	e8 78 ff ff ff       	call   214 <putc>
  while(--i >= 0)
 29c:	4b                   	dec    %ebx
 29d:	79 f0                	jns    28f <printint+0x61>
}
 29f:	83 c4 2c             	add    $0x2c,%esp
 2a2:	5b                   	pop    %ebx
 2a3:	5e                   	pop    %esi
 2a4:	5f                   	pop    %edi
 2a5:	5d                   	pop    %ebp
 2a6:	c3                   	ret

000002a7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 2a7:	55                   	push   %ebp
 2a8:	89 e5                	mov    %esp,%ebp
 2aa:	57                   	push   %edi
 2ab:	56                   	push   %esi
 2ac:	53                   	push   %ebx
 2ad:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 2b0:	8d 45 10             	lea    0x10(%ebp),%eax
 2b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 2b6:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 2bb:	bb 00 00 00 00       	mov    $0x0,%ebx
 2c0:	eb 12                	jmp    2d4 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 2c2:	89 fa                	mov    %edi,%edx
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	e8 48 ff ff ff       	call   214 <putc>
 2cc:	eb 05                	jmp    2d3 <printf+0x2c>
      }
    } else if(state == '%'){
 2ce:	83 fe 25             	cmp    $0x25,%esi
 2d1:	74 22                	je     2f5 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 2d3:	43                   	inc    %ebx
 2d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d7:	8a 04 18             	mov    (%eax,%ebx,1),%al
 2da:	84 c0                	test   %al,%al
 2dc:	0f 84 1d 01 00 00    	je     3ff <printf+0x158>
    c = fmt[i] & 0xff;
 2e2:	0f be f8             	movsbl %al,%edi
 2e5:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 2e8:	85 f6                	test   %esi,%esi
 2ea:	75 e2                	jne    2ce <printf+0x27>
      if(c == '%'){
 2ec:	83 f8 25             	cmp    $0x25,%eax
 2ef:	75 d1                	jne    2c2 <printf+0x1b>
        state = '%';
 2f1:	89 c6                	mov    %eax,%esi
 2f3:	eb de                	jmp    2d3 <printf+0x2c>
      if(c == 'd'){
 2f5:	83 f8 25             	cmp    $0x25,%eax
 2f8:	0f 84 cc 00 00 00    	je     3ca <printf+0x123>
 2fe:	0f 8c da 00 00 00    	jl     3de <printf+0x137>
 304:	83 f8 78             	cmp    $0x78,%eax
 307:	0f 8f d1 00 00 00    	jg     3de <printf+0x137>
 30d:	83 f8 63             	cmp    $0x63,%eax
 310:	0f 8c c8 00 00 00    	jl     3de <printf+0x137>
 316:	83 e8 63             	sub    $0x63,%eax
 319:	83 f8 15             	cmp    $0x15,%eax
 31c:	0f 87 bc 00 00 00    	ja     3de <printf+0x137>
 322:	ff 24 85 c4 04 00 00 	jmp    *0x4c4(,%eax,4)
        printint(fd, *ap, 10, 1);
 329:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 32c:	8b 17                	mov    (%edi),%edx
 32e:	83 ec 0c             	sub    $0xc,%esp
 331:	6a 01                	push   $0x1
 333:	b9 0a 00 00 00       	mov    $0xa,%ecx
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	e8 ee fe ff ff       	call   22e <printint>
        ap++;
 340:	83 c7 04             	add    $0x4,%edi
 343:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 346:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 349:	be 00 00 00 00       	mov    $0x0,%esi
 34e:	eb 83                	jmp    2d3 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 350:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 353:	8b 17                	mov    (%edi),%edx
 355:	83 ec 0c             	sub    $0xc,%esp
 358:	6a 00                	push   $0x0
 35a:	b9 10 00 00 00       	mov    $0x10,%ecx
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
 362:	e8 c7 fe ff ff       	call   22e <printint>
        ap++;
 367:	83 c7 04             	add    $0x4,%edi
 36a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 36d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 370:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 375:	e9 59 ff ff ff       	jmp    2d3 <printf+0x2c>
        s = (char*)*ap;
 37a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 37d:	8b 30                	mov    (%eax),%esi
        ap++;
 37f:	83 c0 04             	add    $0x4,%eax
 382:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 385:	85 f6                	test   %esi,%esi
 387:	75 13                	jne    39c <printf+0xf5>
          s = "(null)";
 389:	be 77 04 00 00       	mov    $0x477,%esi
 38e:	eb 0c                	jmp    39c <printf+0xf5>
          putc(fd, *s);
 390:	0f be d2             	movsbl %dl,%edx
 393:	8b 45 08             	mov    0x8(%ebp),%eax
 396:	e8 79 fe ff ff       	call   214 <putc>
          s++;
 39b:	46                   	inc    %esi
        while(*s != 0){
 39c:	8a 16                	mov    (%esi),%dl
 39e:	84 d2                	test   %dl,%dl
 3a0:	75 ee                	jne    390 <printf+0xe9>
      state = 0;
 3a2:	be 00 00 00 00       	mov    $0x0,%esi
 3a7:	e9 27 ff ff ff       	jmp    2d3 <printf+0x2c>
        putc(fd, *ap);
 3ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3af:	0f be 17             	movsbl (%edi),%edx
 3b2:	8b 45 08             	mov    0x8(%ebp),%eax
 3b5:	e8 5a fe ff ff       	call   214 <putc>
        ap++;
 3ba:	83 c7 04             	add    $0x4,%edi
 3bd:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 3c0:	be 00 00 00 00       	mov    $0x0,%esi
 3c5:	e9 09 ff ff ff       	jmp    2d3 <printf+0x2c>
        putc(fd, c);
 3ca:	89 fa                	mov    %edi,%edx
 3cc:	8b 45 08             	mov    0x8(%ebp),%eax
 3cf:	e8 40 fe ff ff       	call   214 <putc>
      state = 0;
 3d4:	be 00 00 00 00       	mov    $0x0,%esi
 3d9:	e9 f5 fe ff ff       	jmp    2d3 <printf+0x2c>
        putc(fd, '%');
 3de:	ba 25 00 00 00       	mov    $0x25,%edx
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	e8 29 fe ff ff       	call   214 <putc>
        putc(fd, c);
 3eb:	89 fa                	mov    %edi,%edx
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
 3f0:	e8 1f fe ff ff       	call   214 <putc>
      state = 0;
 3f5:	be 00 00 00 00       	mov    $0x0,%esi
 3fa:	e9 d4 fe ff ff       	jmp    2d3 <printf+0x2c>
    }
  }
}
 3ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
 402:	5b                   	pop    %ebx
 403:	5e                   	pop    %esi
 404:	5f                   	pop    %edi
 405:	5d                   	pop    %ebp
 406:	c3                   	ret
