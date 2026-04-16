
cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   8:	83 ec 04             	sub    $0x4,%esp
   b:	68 00 02 00 00       	push   $0x200
  10:	68 80 05 00 00       	push   $0x580
  15:	56                   	push   %esi
  16:	e8 1e 01 00 00       	call   139 <read>
  1b:	89 c3                	mov    %eax,%ebx
  1d:	83 c4 10             	add    $0x10,%esp
  20:	85 c0                	test   %eax,%eax
  22:	7e 32                	jle    56 <cat+0x56>
    if (write(1, buf, n) != n) {
  24:	83 ec 04             	sub    $0x4,%esp
  27:	53                   	push   %ebx
  28:	68 80 05 00 00       	push   $0x580
  2d:	6a 01                	push   $0x1
  2f:	e8 0d 01 00 00       	call   141 <write>
  34:	83 c4 10             	add    $0x10,%esp
  37:	39 d8                	cmp    %ebx,%eax
  39:	74 cd                	je     8 <cat+0x8>
      printf(1, "cat: write error\n");
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	68 d4 03 00 00       	push   $0x3d4
  43:	6a 01                	push   $0x1
  45:	e8 2a 02 00 00       	call   274 <printf>
      exit(0);
  4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  51:	e8 cb 00 00 00       	call   121 <exit>
    }
  }
  if(n < 0){
  56:	78 07                	js     5f <cat+0x5f>
    printf(1, "cat: read error\n");
    exit(0);
  }
}
  58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  5b:	5b                   	pop    %ebx
  5c:	5e                   	pop    %esi
  5d:	5d                   	pop    %ebp
  5e:	c3                   	ret
    printf(1, "cat: read error\n");
  5f:	83 ec 08             	sub    $0x8,%esp
  62:	68 e6 03 00 00       	push   $0x3e6
  67:	6a 01                	push   $0x1
  69:	e8 06 02 00 00       	call   274 <printf>
    exit(0);
  6e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  75:	e8 a7 00 00 00       	call   121 <exit>

0000007a <main>:

int
main(int argc, char *argv[])
{
  7a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  7e:	83 e4 f0             	and    $0xfffffff0,%esp
  81:	ff 71 fc             	push   -0x4(%ecx)
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	57                   	push   %edi
  88:	56                   	push   %esi
  89:	53                   	push   %ebx
  8a:	51                   	push   %ecx
  8b:	83 ec 18             	sub    $0x18,%esp
  8e:	8b 01                	mov    (%ecx),%eax
  90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  93:	8b 51 04             	mov    0x4(%ecx),%edx
  96:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  99:	83 f8 01             	cmp    $0x1,%eax
  9c:	7e 07                	jle    a5 <main+0x2b>
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
  9e:	be 01 00 00 00       	mov    $0x1,%esi
  a3:	eb 2b                	jmp    d0 <main+0x56>
    cat(0);
  a5:	83 ec 0c             	sub    $0xc,%esp
  a8:	6a 00                	push   $0x0
  aa:	e8 51 ff ff ff       	call   0 <cat>
    exit(0);
  af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  b6:	e8 66 00 00 00       	call   121 <exit>
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit(0);
    }
    cat(fd);
  bb:	83 ec 0c             	sub    $0xc,%esp
  be:	50                   	push   %eax
  bf:	e8 3c ff ff ff       	call   0 <cat>
    close(fd);
  c4:	89 1c 24             	mov    %ebx,(%esp)
  c7:	e8 7d 00 00 00       	call   149 <close>
  for(i = 1; i < argc; i++){
  cc:	46                   	inc    %esi
  cd:	83 c4 10             	add    $0x10,%esp
  d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  d3:	39 c6                	cmp    %eax,%esi
  d5:	7d 38                	jge    10f <main+0x95>
    if((fd = open(argv[i], 0)) < 0){
  d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  da:	8d 3c b0             	lea    (%eax,%esi,4),%edi
  dd:	83 ec 08             	sub    $0x8,%esp
  e0:	6a 00                	push   $0x0
  e2:	ff 37                	push   (%edi)
  e4:	e8 78 00 00 00       	call   161 <open>
  e9:	89 c3                	mov    %eax,%ebx
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	85 c0                	test   %eax,%eax
  f0:	79 c9                	jns    bb <main+0x41>
      printf(1, "cat: cannot open %s\n", argv[i]);
  f2:	83 ec 04             	sub    $0x4,%esp
  f5:	ff 37                	push   (%edi)
  f7:	68 f7 03 00 00       	push   $0x3f7
  fc:	6a 01                	push   $0x1
  fe:	e8 71 01 00 00       	call   274 <printf>
      exit(0);
 103:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 10a:	e8 12 00 00 00       	call   121 <exit>
  }
  exit(0);
 10f:	83 ec 0c             	sub    $0xc,%esp
 112:	6a 00                	push   $0x0
 114:	e8 08 00 00 00       	call   121 <exit>

00000119 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 119:	b8 01 00 00 00       	mov    $0x1,%eax
 11e:	cd 40                	int    $0x40
 120:	c3                   	ret

00000121 <exit>:
SYSCALL(exit)
 121:	b8 02 00 00 00       	mov    $0x2,%eax
 126:	cd 40                	int    $0x40
 128:	c3                   	ret

00000129 <wait>:
SYSCALL(wait)
 129:	b8 03 00 00 00       	mov    $0x3,%eax
 12e:	cd 40                	int    $0x40
 130:	c3                   	ret

00000131 <pipe>:
SYSCALL(pipe)
 131:	b8 04 00 00 00       	mov    $0x4,%eax
 136:	cd 40                	int    $0x40
 138:	c3                   	ret

00000139 <read>:
SYSCALL(read)
 139:	b8 05 00 00 00       	mov    $0x5,%eax
 13e:	cd 40                	int    $0x40
 140:	c3                   	ret

00000141 <write>:
SYSCALL(write)
 141:	b8 10 00 00 00       	mov    $0x10,%eax
 146:	cd 40                	int    $0x40
 148:	c3                   	ret

00000149 <close>:
SYSCALL(close)
 149:	b8 15 00 00 00       	mov    $0x15,%eax
 14e:	cd 40                	int    $0x40
 150:	c3                   	ret

00000151 <kill>:
SYSCALL(kill)
 151:	b8 06 00 00 00       	mov    $0x6,%eax
 156:	cd 40                	int    $0x40
 158:	c3                   	ret

00000159 <exec>:
SYSCALL(exec)
 159:	b8 07 00 00 00       	mov    $0x7,%eax
 15e:	cd 40                	int    $0x40
 160:	c3                   	ret

00000161 <open>:
SYSCALL(open)
 161:	b8 0f 00 00 00       	mov    $0xf,%eax
 166:	cd 40                	int    $0x40
 168:	c3                   	ret

00000169 <mknod>:
SYSCALL(mknod)
 169:	b8 11 00 00 00       	mov    $0x11,%eax
 16e:	cd 40                	int    $0x40
 170:	c3                   	ret

00000171 <unlink>:
SYSCALL(unlink)
 171:	b8 12 00 00 00       	mov    $0x12,%eax
 176:	cd 40                	int    $0x40
 178:	c3                   	ret

00000179 <fstat>:
SYSCALL(fstat)
 179:	b8 08 00 00 00       	mov    $0x8,%eax
 17e:	cd 40                	int    $0x40
 180:	c3                   	ret

00000181 <link>:
SYSCALL(link)
 181:	b8 13 00 00 00       	mov    $0x13,%eax
 186:	cd 40                	int    $0x40
 188:	c3                   	ret

00000189 <mkdir>:
SYSCALL(mkdir)
 189:	b8 14 00 00 00       	mov    $0x14,%eax
 18e:	cd 40                	int    $0x40
 190:	c3                   	ret

00000191 <chdir>:
SYSCALL(chdir)
 191:	b8 09 00 00 00       	mov    $0x9,%eax
 196:	cd 40                	int    $0x40
 198:	c3                   	ret

00000199 <dup>:
SYSCALL(dup)
 199:	b8 0a 00 00 00       	mov    $0xa,%eax
 19e:	cd 40                	int    $0x40
 1a0:	c3                   	ret

000001a1 <getpid>:
SYSCALL(getpid)
 1a1:	b8 0b 00 00 00       	mov    $0xb,%eax
 1a6:	cd 40                	int    $0x40
 1a8:	c3                   	ret

000001a9 <sbrk>:
SYSCALL(sbrk)
 1a9:	b8 0c 00 00 00       	mov    $0xc,%eax
 1ae:	cd 40                	int    $0x40
 1b0:	c3                   	ret

000001b1 <sleep>:
SYSCALL(sleep)
 1b1:	b8 0d 00 00 00       	mov    $0xd,%eax
 1b6:	cd 40                	int    $0x40
 1b8:	c3                   	ret

000001b9 <uptime>:
SYSCALL(uptime)
 1b9:	b8 0e 00 00 00       	mov    $0xe,%eax
 1be:	cd 40                	int    $0x40
 1c0:	c3                   	ret

000001c1 <date>:
SYSCALL(date)
 1c1:	b8 16 00 00 00       	mov    $0x16,%eax
 1c6:	cd 40                	int    $0x40
 1c8:	c3                   	ret

000001c9 <dup2>:
SYSCALL(dup2)
 1c9:	b8 17 00 00 00       	mov    $0x17,%eax
 1ce:	cd 40                	int    $0x40
 1d0:	c3                   	ret

000001d1 <getprio>:
SYSCALL(getprio)
 1d1:	b8 18 00 00 00       	mov    $0x18,%eax
 1d6:	cd 40                	int    $0x40
 1d8:	c3                   	ret

000001d9 <setprio>:
 1d9:	b8 19 00 00 00       	mov    $0x19,%eax
 1de:	cd 40                	int    $0x40
 1e0:	c3                   	ret

000001e1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	83 ec 1c             	sub    $0x1c,%esp
 1e7:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 1ea:	6a 01                	push   $0x1
 1ec:	8d 55 f4             	lea    -0xc(%ebp),%edx
 1ef:	52                   	push   %edx
 1f0:	50                   	push   %eax
 1f1:	e8 4b ff ff ff       	call   141 <write>
}
 1f6:	83 c4 10             	add    $0x10,%esp
 1f9:	c9                   	leave
 1fa:	c3                   	ret

000001fb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	57                   	push   %edi
 1ff:	56                   	push   %esi
 200:	53                   	push   %ebx
 201:	83 ec 2c             	sub    $0x2c,%esp
 204:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 207:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 209:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 20d:	74 04                	je     213 <printint+0x18>
 20f:	85 d2                	test   %edx,%edx
 211:	78 3c                	js     24f <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 213:	89 d1                	mov    %edx,%ecx
  neg = 0;
 215:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 21c:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 221:	89 c8                	mov    %ecx,%eax
 223:	ba 00 00 00 00       	mov    $0x0,%edx
 228:	f7 f6                	div    %esi
 22a:	89 df                	mov    %ebx,%edi
 22c:	43                   	inc    %ebx
 22d:	8a 92 6c 04 00 00    	mov    0x46c(%edx),%dl
 233:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 237:	89 ca                	mov    %ecx,%edx
 239:	89 c1                	mov    %eax,%ecx
 23b:	39 f2                	cmp    %esi,%edx
 23d:	73 e2                	jae    221 <printint+0x26>
  if(neg)
 23f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 243:	74 24                	je     269 <printint+0x6e>
    buf[i++] = '-';
 245:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 24a:	8d 5f 02             	lea    0x2(%edi),%ebx
 24d:	eb 1a                	jmp    269 <printint+0x6e>
    x = -xx;
 24f:	89 d1                	mov    %edx,%ecx
 251:	f7 d9                	neg    %ecx
    neg = 1;
 253:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 25a:	eb c0                	jmp    21c <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 25c:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 261:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 264:	e8 78 ff ff ff       	call   1e1 <putc>
  while(--i >= 0)
 269:	4b                   	dec    %ebx
 26a:	79 f0                	jns    25c <printint+0x61>
}
 26c:	83 c4 2c             	add    $0x2c,%esp
 26f:	5b                   	pop    %ebx
 270:	5e                   	pop    %esi
 271:	5f                   	pop    %edi
 272:	5d                   	pop    %ebp
 273:	c3                   	ret

00000274 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 274:	55                   	push   %ebp
 275:	89 e5                	mov    %esp,%ebp
 277:	57                   	push   %edi
 278:	56                   	push   %esi
 279:	53                   	push   %ebx
 27a:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 27d:	8d 45 10             	lea    0x10(%ebp),%eax
 280:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 283:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 288:	bb 00 00 00 00       	mov    $0x0,%ebx
 28d:	eb 12                	jmp    2a1 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 28f:	89 fa                	mov    %edi,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	e8 48 ff ff ff       	call   1e1 <putc>
 299:	eb 05                	jmp    2a0 <printf+0x2c>
      }
    } else if(state == '%'){
 29b:	83 fe 25             	cmp    $0x25,%esi
 29e:	74 22                	je     2c2 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 2a0:	43                   	inc    %ebx
 2a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a4:	8a 04 18             	mov    (%eax,%ebx,1),%al
 2a7:	84 c0                	test   %al,%al
 2a9:	0f 84 1d 01 00 00    	je     3cc <printf+0x158>
    c = fmt[i] & 0xff;
 2af:	0f be f8             	movsbl %al,%edi
 2b2:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 2b5:	85 f6                	test   %esi,%esi
 2b7:	75 e2                	jne    29b <printf+0x27>
      if(c == '%'){
 2b9:	83 f8 25             	cmp    $0x25,%eax
 2bc:	75 d1                	jne    28f <printf+0x1b>
        state = '%';
 2be:	89 c6                	mov    %eax,%esi
 2c0:	eb de                	jmp    2a0 <printf+0x2c>
      if(c == 'd'){
 2c2:	83 f8 25             	cmp    $0x25,%eax
 2c5:	0f 84 cc 00 00 00    	je     397 <printf+0x123>
 2cb:	0f 8c da 00 00 00    	jl     3ab <printf+0x137>
 2d1:	83 f8 78             	cmp    $0x78,%eax
 2d4:	0f 8f d1 00 00 00    	jg     3ab <printf+0x137>
 2da:	83 f8 63             	cmp    $0x63,%eax
 2dd:	0f 8c c8 00 00 00    	jl     3ab <printf+0x137>
 2e3:	83 e8 63             	sub    $0x63,%eax
 2e6:	83 f8 15             	cmp    $0x15,%eax
 2e9:	0f 87 bc 00 00 00    	ja     3ab <printf+0x137>
 2ef:	ff 24 85 14 04 00 00 	jmp    *0x414(,%eax,4)
        printint(fd, *ap, 10, 1);
 2f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2f9:	8b 17                	mov    (%edi),%edx
 2fb:	83 ec 0c             	sub    $0xc,%esp
 2fe:	6a 01                	push   $0x1
 300:	b9 0a 00 00 00       	mov    $0xa,%ecx
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	e8 ee fe ff ff       	call   1fb <printint>
        ap++;
 30d:	83 c7 04             	add    $0x4,%edi
 310:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 313:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 316:	be 00 00 00 00       	mov    $0x0,%esi
 31b:	eb 83                	jmp    2a0 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 31d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 320:	8b 17                	mov    (%edi),%edx
 322:	83 ec 0c             	sub    $0xc,%esp
 325:	6a 00                	push   $0x0
 327:	b9 10 00 00 00       	mov    $0x10,%ecx
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	e8 c7 fe ff ff       	call   1fb <printint>
        ap++;
 334:	83 c7 04             	add    $0x4,%edi
 337:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 33a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 33d:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 342:	e9 59 ff ff ff       	jmp    2a0 <printf+0x2c>
        s = (char*)*ap;
 347:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 34a:	8b 30                	mov    (%eax),%esi
        ap++;
 34c:	83 c0 04             	add    $0x4,%eax
 34f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 352:	85 f6                	test   %esi,%esi
 354:	75 13                	jne    369 <printf+0xf5>
          s = "(null)";
 356:	be 0c 04 00 00       	mov    $0x40c,%esi
 35b:	eb 0c                	jmp    369 <printf+0xf5>
          putc(fd, *s);
 35d:	0f be d2             	movsbl %dl,%edx
 360:	8b 45 08             	mov    0x8(%ebp),%eax
 363:	e8 79 fe ff ff       	call   1e1 <putc>
          s++;
 368:	46                   	inc    %esi
        while(*s != 0){
 369:	8a 16                	mov    (%esi),%dl
 36b:	84 d2                	test   %dl,%dl
 36d:	75 ee                	jne    35d <printf+0xe9>
      state = 0;
 36f:	be 00 00 00 00       	mov    $0x0,%esi
 374:	e9 27 ff ff ff       	jmp    2a0 <printf+0x2c>
        putc(fd, *ap);
 379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 37c:	0f be 17             	movsbl (%edi),%edx
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	e8 5a fe ff ff       	call   1e1 <putc>
        ap++;
 387:	83 c7 04             	add    $0x4,%edi
 38a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 38d:	be 00 00 00 00       	mov    $0x0,%esi
 392:	e9 09 ff ff ff       	jmp    2a0 <printf+0x2c>
        putc(fd, c);
 397:	89 fa                	mov    %edi,%edx
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	e8 40 fe ff ff       	call   1e1 <putc>
      state = 0;
 3a1:	be 00 00 00 00       	mov    $0x0,%esi
 3a6:	e9 f5 fe ff ff       	jmp    2a0 <printf+0x2c>
        putc(fd, '%');
 3ab:	ba 25 00 00 00       	mov    $0x25,%edx
 3b0:	8b 45 08             	mov    0x8(%ebp),%eax
 3b3:	e8 29 fe ff ff       	call   1e1 <putc>
        putc(fd, c);
 3b8:	89 fa                	mov    %edi,%edx
 3ba:	8b 45 08             	mov    0x8(%ebp),%eax
 3bd:	e8 1f fe ff ff       	call   1e1 <putc>
      state = 0;
 3c2:	be 00 00 00 00       	mov    $0x0,%esi
 3c7:	e9 d4 fe ff ff       	jmp    2a0 <printf+0x2c>
    }
  }
}
 3cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3cf:	5b                   	pop    %ebx
 3d0:	5e                   	pop    %esi
 3d1:	5f                   	pop    %edi
 3d2:	5d                   	pop    %ebp
 3d3:	c3                   	ret
