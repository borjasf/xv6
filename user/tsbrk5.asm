
tsbrk5:     file format elf32-i386


Disassembly of section .text:

00000000 <test1>:
#include "user.h"

int i = 1;

void test1()
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 10             	sub    $0x10,%esp
  char* a = sbrk (0);
   7:	6a 00                	push   $0x0
   9:	e8 35 01 00 00       	call   143 <sbrk>
   e:	89 c3                	mov    %eax,%ebx

  printf (1, "Debe fallar ahora:\n");
  10:	83 c4 08             	add    $0x8,%esp
  13:	68 70 03 00 00       	push   $0x370
  18:	6a 01                	push   $0x1
  1a:	e8 ef 01 00 00       	call   20e <printf>
  *(a+1) = 1;  // Debe fallar
  1f:	c6 43 01 01          	movb   $0x1,0x1(%ebx)
}
  23:	83 c4 10             	add    $0x10,%esp
  26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  29:	c9                   	leave
  2a:	c3                   	ret

0000002b <test2>:

void test2()
{
  2b:	55                   	push   %ebp
  2c:	89 e5                	mov    %esp,%ebp
  2e:	83 ec 10             	sub    $0x10,%esp
  // Página de guarda:
  printf (1, "Si no fallo antes (mal), ahora tambien debe fallar:\n");
  31:	68 90 03 00 00       	push   $0x390
  36:	6a 01                	push   $0x1
  38:	e8 d1 01 00 00       	call   20e <printf>
  char* a = (char*)((int)&i + 4095);
  printf (1, "%d\n", a);
  3d:	83 c4 0c             	add    $0xc,%esp
  40:	68 87 15 00 00       	push   $0x1587
  45:	68 84 03 00 00       	push   $0x384
  4a:	6a 01                	push   $0x1
  4c:	e8 bd 01 00 00       	call   20e <printf>
  *a = 1;
  51:	c6 05 87 15 00 00 01 	movb   $0x1,0x1587
}
  58:	83 c4 10             	add    $0x10,%esp
  5b:	c9                   	leave
  5c:	c3                   	ret

0000005d <test3>:

void test3()
{
  5d:	55                   	push   %ebp
  5e:	89 e5                	mov    %esp,%ebp
  60:	83 ec 10             	sub    $0x10,%esp
  // Acceder al núcleo
  printf (1, "Si no fallo antes (mal), ahora tambien debe fallar:\n");
  63:	68 90 03 00 00       	push   $0x390
  68:	6a 01                	push   $0x1
  6a:	e8 9f 01 00 00       	call   20e <printf>
  char* a = (char*)0x80000001;
  *(a+1) = 1;  // Debe fallar (si lo anterior no ha fallado)
  6f:	c6 05 02 00 00 80 01 	movb   $0x1,0x80000002
}
  76:	83 c4 10             	add    $0x10,%esp
  79:	c9                   	leave
  7a:	c3                   	ret

0000007b <main>:


int
main(int argc, char *argv[])
{
  7b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  7f:	83 e4 f0             	and    $0xfffffff0,%esp
  82:	ff 71 fc             	push   -0x4(%ecx)
  85:	55                   	push   %ebp
  86:	89 e5                	mov    %esp,%ebp
  88:	51                   	push   %ecx
  89:	83 ec 0c             	sub    $0xc,%esp
  printf (1, "Este programa primero intenta acceder mas alla de sz.\n");
  8c:	68 c8 03 00 00       	push   $0x3c8
  91:	6a 01                	push   $0x1
  93:	e8 76 01 00 00       	call   20e <printf>

  // Más allá de sz
  test1();
  98:	e8 63 ff ff ff       	call   0 <test1>

  // Guarda
  test2();
  9d:	e8 89 ff ff ff       	call   2b <test2>

  // Núcleo
  test3();
  a2:	e8 b6 ff ff ff       	call   5d <test3>

  exit (0);
  a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  ae:	e8 08 00 00 00       	call   bb <exit>

000000b3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  b3:	b8 01 00 00 00       	mov    $0x1,%eax
  b8:	cd 40                	int    $0x40
  ba:	c3                   	ret

000000bb <exit>:
SYSCALL(exit)
  bb:	b8 02 00 00 00       	mov    $0x2,%eax
  c0:	cd 40                	int    $0x40
  c2:	c3                   	ret

000000c3 <wait>:
SYSCALL(wait)
  c3:	b8 03 00 00 00       	mov    $0x3,%eax
  c8:	cd 40                	int    $0x40
  ca:	c3                   	ret

000000cb <pipe>:
SYSCALL(pipe)
  cb:	b8 04 00 00 00       	mov    $0x4,%eax
  d0:	cd 40                	int    $0x40
  d2:	c3                   	ret

000000d3 <read>:
SYSCALL(read)
  d3:	b8 05 00 00 00       	mov    $0x5,%eax
  d8:	cd 40                	int    $0x40
  da:	c3                   	ret

000000db <write>:
SYSCALL(write)
  db:	b8 10 00 00 00       	mov    $0x10,%eax
  e0:	cd 40                	int    $0x40
  e2:	c3                   	ret

000000e3 <close>:
SYSCALL(close)
  e3:	b8 15 00 00 00       	mov    $0x15,%eax
  e8:	cd 40                	int    $0x40
  ea:	c3                   	ret

000000eb <kill>:
SYSCALL(kill)
  eb:	b8 06 00 00 00       	mov    $0x6,%eax
  f0:	cd 40                	int    $0x40
  f2:	c3                   	ret

000000f3 <exec>:
SYSCALL(exec)
  f3:	b8 07 00 00 00       	mov    $0x7,%eax
  f8:	cd 40                	int    $0x40
  fa:	c3                   	ret

000000fb <open>:
SYSCALL(open)
  fb:	b8 0f 00 00 00       	mov    $0xf,%eax
 100:	cd 40                	int    $0x40
 102:	c3                   	ret

00000103 <mknod>:
SYSCALL(mknod)
 103:	b8 11 00 00 00       	mov    $0x11,%eax
 108:	cd 40                	int    $0x40
 10a:	c3                   	ret

0000010b <unlink>:
SYSCALL(unlink)
 10b:	b8 12 00 00 00       	mov    $0x12,%eax
 110:	cd 40                	int    $0x40
 112:	c3                   	ret

00000113 <fstat>:
SYSCALL(fstat)
 113:	b8 08 00 00 00       	mov    $0x8,%eax
 118:	cd 40                	int    $0x40
 11a:	c3                   	ret

0000011b <link>:
SYSCALL(link)
 11b:	b8 13 00 00 00       	mov    $0x13,%eax
 120:	cd 40                	int    $0x40
 122:	c3                   	ret

00000123 <mkdir>:
SYSCALL(mkdir)
 123:	b8 14 00 00 00       	mov    $0x14,%eax
 128:	cd 40                	int    $0x40
 12a:	c3                   	ret

0000012b <chdir>:
SYSCALL(chdir)
 12b:	b8 09 00 00 00       	mov    $0x9,%eax
 130:	cd 40                	int    $0x40
 132:	c3                   	ret

00000133 <dup>:
SYSCALL(dup)
 133:	b8 0a 00 00 00       	mov    $0xa,%eax
 138:	cd 40                	int    $0x40
 13a:	c3                   	ret

0000013b <getpid>:
SYSCALL(getpid)
 13b:	b8 0b 00 00 00       	mov    $0xb,%eax
 140:	cd 40                	int    $0x40
 142:	c3                   	ret

00000143 <sbrk>:
SYSCALL(sbrk)
 143:	b8 0c 00 00 00       	mov    $0xc,%eax
 148:	cd 40                	int    $0x40
 14a:	c3                   	ret

0000014b <sleep>:
SYSCALL(sleep)
 14b:	b8 0d 00 00 00       	mov    $0xd,%eax
 150:	cd 40                	int    $0x40
 152:	c3                   	ret

00000153 <uptime>:
SYSCALL(uptime)
 153:	b8 0e 00 00 00       	mov    $0xe,%eax
 158:	cd 40                	int    $0x40
 15a:	c3                   	ret

0000015b <date>:
SYSCALL(date)
 15b:	b8 16 00 00 00       	mov    $0x16,%eax
 160:	cd 40                	int    $0x40
 162:	c3                   	ret

00000163 <dup2>:
SYSCALL(dup2)
 163:	b8 17 00 00 00       	mov    $0x17,%eax
 168:	cd 40                	int    $0x40
 16a:	c3                   	ret

0000016b <getprio>:
SYSCALL(getprio)
 16b:	b8 18 00 00 00       	mov    $0x18,%eax
 170:	cd 40                	int    $0x40
 172:	c3                   	ret

00000173 <setprio>:
 173:	b8 19 00 00 00       	mov    $0x19,%eax
 178:	cd 40                	int    $0x40
 17a:	c3                   	ret

0000017b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 1c             	sub    $0x1c,%esp
 181:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 184:	6a 01                	push   $0x1
 186:	8d 55 f4             	lea    -0xc(%ebp),%edx
 189:	52                   	push   %edx
 18a:	50                   	push   %eax
 18b:	e8 4b ff ff ff       	call   db <write>
}
 190:	83 c4 10             	add    $0x10,%esp
 193:	c9                   	leave
 194:	c3                   	ret

00000195 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
 198:	57                   	push   %edi
 199:	56                   	push   %esi
 19a:	53                   	push   %ebx
 19b:	83 ec 2c             	sub    $0x2c,%esp
 19e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1a1:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1a7:	74 04                	je     1ad <printint+0x18>
 1a9:	85 d2                	test   %edx,%edx
 1ab:	78 3c                	js     1e9 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 1ad:	89 d1                	mov    %edx,%ecx
  neg = 0;
 1af:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 1b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1bb:	89 c8                	mov    %ecx,%eax
 1bd:	ba 00 00 00 00       	mov    $0x0,%edx
 1c2:	f7 f6                	div    %esi
 1c4:	89 df                	mov    %ebx,%edi
 1c6:	43                   	inc    %ebx
 1c7:	8a 92 58 04 00 00    	mov    0x458(%edx),%dl
 1cd:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1d1:	89 ca                	mov    %ecx,%edx
 1d3:	89 c1                	mov    %eax,%ecx
 1d5:	39 f2                	cmp    %esi,%edx
 1d7:	73 e2                	jae    1bb <printint+0x26>
  if(neg)
 1d9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1dd:	74 24                	je     203 <printint+0x6e>
    buf[i++] = '-';
 1df:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1e4:	8d 5f 02             	lea    0x2(%edi),%ebx
 1e7:	eb 1a                	jmp    203 <printint+0x6e>
    x = -xx;
 1e9:	89 d1                	mov    %edx,%ecx
 1eb:	f7 d9                	neg    %ecx
    neg = 1;
 1ed:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1f4:	eb c0                	jmp    1b6 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 1f6:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1fe:	e8 78 ff ff ff       	call   17b <putc>
  while(--i >= 0)
 203:	4b                   	dec    %ebx
 204:	79 f0                	jns    1f6 <printint+0x61>
}
 206:	83 c4 2c             	add    $0x2c,%esp
 209:	5b                   	pop    %ebx
 20a:	5e                   	pop    %esi
 20b:	5f                   	pop    %edi
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret

0000020e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
 211:	57                   	push   %edi
 212:	56                   	push   %esi
 213:	53                   	push   %ebx
 214:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 217:	8d 45 10             	lea    0x10(%ebp),%eax
 21a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 21d:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 222:	bb 00 00 00 00       	mov    $0x0,%ebx
 227:	eb 12                	jmp    23b <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 229:	89 fa                	mov    %edi,%edx
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	e8 48 ff ff ff       	call   17b <putc>
 233:	eb 05                	jmp    23a <printf+0x2c>
      }
    } else if(state == '%'){
 235:	83 fe 25             	cmp    $0x25,%esi
 238:	74 22                	je     25c <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 23a:	43                   	inc    %ebx
 23b:	8b 45 0c             	mov    0xc(%ebp),%eax
 23e:	8a 04 18             	mov    (%eax,%ebx,1),%al
 241:	84 c0                	test   %al,%al
 243:	0f 84 1d 01 00 00    	je     366 <printf+0x158>
    c = fmt[i] & 0xff;
 249:	0f be f8             	movsbl %al,%edi
 24c:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 24f:	85 f6                	test   %esi,%esi
 251:	75 e2                	jne    235 <printf+0x27>
      if(c == '%'){
 253:	83 f8 25             	cmp    $0x25,%eax
 256:	75 d1                	jne    229 <printf+0x1b>
        state = '%';
 258:	89 c6                	mov    %eax,%esi
 25a:	eb de                	jmp    23a <printf+0x2c>
      if(c == 'd'){
 25c:	83 f8 25             	cmp    $0x25,%eax
 25f:	0f 84 cc 00 00 00    	je     331 <printf+0x123>
 265:	0f 8c da 00 00 00    	jl     345 <printf+0x137>
 26b:	83 f8 78             	cmp    $0x78,%eax
 26e:	0f 8f d1 00 00 00    	jg     345 <printf+0x137>
 274:	83 f8 63             	cmp    $0x63,%eax
 277:	0f 8c c8 00 00 00    	jl     345 <printf+0x137>
 27d:	83 e8 63             	sub    $0x63,%eax
 280:	83 f8 15             	cmp    $0x15,%eax
 283:	0f 87 bc 00 00 00    	ja     345 <printf+0x137>
 289:	ff 24 85 00 04 00 00 	jmp    *0x400(,%eax,4)
        printint(fd, *ap, 10, 1);
 290:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 293:	8b 17                	mov    (%edi),%edx
 295:	83 ec 0c             	sub    $0xc,%esp
 298:	6a 01                	push   $0x1
 29a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	e8 ee fe ff ff       	call   195 <printint>
        ap++;
 2a7:	83 c7 04             	add    $0x4,%edi
 2aa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2ad:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 2b0:	be 00 00 00 00       	mov    $0x0,%esi
 2b5:	eb 83                	jmp    23a <printf+0x2c>
        printint(fd, *ap, 16, 0);
 2b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2ba:	8b 17                	mov    (%edi),%edx
 2bc:	83 ec 0c             	sub    $0xc,%esp
 2bf:	6a 00                	push   $0x0
 2c1:	b9 10 00 00 00       	mov    $0x10,%ecx
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	e8 c7 fe ff ff       	call   195 <printint>
        ap++;
 2ce:	83 c7 04             	add    $0x4,%edi
 2d1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2d4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2d7:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2dc:	e9 59 ff ff ff       	jmp    23a <printf+0x2c>
        s = (char*)*ap;
 2e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2e4:	8b 30                	mov    (%eax),%esi
        ap++;
 2e6:	83 c0 04             	add    $0x4,%eax
 2e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2ec:	85 f6                	test   %esi,%esi
 2ee:	75 13                	jne    303 <printf+0xf5>
          s = "(null)";
 2f0:	be 88 03 00 00       	mov    $0x388,%esi
 2f5:	eb 0c                	jmp    303 <printf+0xf5>
          putc(fd, *s);
 2f7:	0f be d2             	movsbl %dl,%edx
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	e8 79 fe ff ff       	call   17b <putc>
          s++;
 302:	46                   	inc    %esi
        while(*s != 0){
 303:	8a 16                	mov    (%esi),%dl
 305:	84 d2                	test   %dl,%dl
 307:	75 ee                	jne    2f7 <printf+0xe9>
      state = 0;
 309:	be 00 00 00 00       	mov    $0x0,%esi
 30e:	e9 27 ff ff ff       	jmp    23a <printf+0x2c>
        putc(fd, *ap);
 313:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 316:	0f be 17             	movsbl (%edi),%edx
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	e8 5a fe ff ff       	call   17b <putc>
        ap++;
 321:	83 c7 04             	add    $0x4,%edi
 324:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 327:	be 00 00 00 00       	mov    $0x0,%esi
 32c:	e9 09 ff ff ff       	jmp    23a <printf+0x2c>
        putc(fd, c);
 331:	89 fa                	mov    %edi,%edx
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	e8 40 fe ff ff       	call   17b <putc>
      state = 0;
 33b:	be 00 00 00 00       	mov    $0x0,%esi
 340:	e9 f5 fe ff ff       	jmp    23a <printf+0x2c>
        putc(fd, '%');
 345:	ba 25 00 00 00       	mov    $0x25,%edx
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	e8 29 fe ff ff       	call   17b <putc>
        putc(fd, c);
 352:	89 fa                	mov    %edi,%edx
 354:	8b 45 08             	mov    0x8(%ebp),%eax
 357:	e8 1f fe ff ff       	call   17b <putc>
      state = 0;
 35c:	be 00 00 00 00       	mov    $0x0,%esi
 361:	e9 d4 fe ff ff       	jmp    23a <printf+0x2c>
    }
  }
}
 366:	8d 65 f4             	lea    -0xc(%ebp),%esp
 369:	5b                   	pop    %ebx
 36a:	5e                   	pop    %esi
 36b:	5f                   	pop    %edi
 36c:	5d                   	pop    %ebp
 36d:	c3                   	ret
