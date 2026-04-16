
rm:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 39                	mov    (%ecx),%edi
  16:	8b 41 04             	mov    0x4(%ecx),%eax
  19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int i;

  if(argc < 2){
  1c:	83 ff 01             	cmp    $0x1,%edi
  1f:	7e 07                	jle    28 <main+0x28>
    printf(2, "Usage: rm files...\n");
    exit(0);
  }

  for(i = 1; i < argc; i++){
  21:	bb 01 00 00 00       	mov    $0x1,%ebx
  26:	eb 1c                	jmp    44 <main+0x44>
    printf(2, "Usage: rm files...\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 38 03 00 00       	push   $0x338
  30:	6a 02                	push   $0x2
  32:	e8 a1 01 00 00       	call   1d8 <printf>
    exit(0);
  37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3e:	e8 42 00 00 00       	call   85 <exit>
  for(i = 1; i < argc; i++){
  43:	43                   	inc    %ebx
  44:	39 fb                	cmp    %edi,%ebx
  46:	7d 2b                	jge    73 <main+0x73>
    if(unlink(argv[i]) < 0){
  48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  4b:	8d 34 98             	lea    (%eax,%ebx,4),%esi
  4e:	83 ec 0c             	sub    $0xc,%esp
  51:	ff 36                	push   (%esi)
  53:	e8 7d 00 00 00       	call   d5 <unlink>
  58:	83 c4 10             	add    $0x10,%esp
  5b:	85 c0                	test   %eax,%eax
  5d:	79 e4                	jns    43 <main+0x43>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5f:	83 ec 04             	sub    $0x4,%esp
  62:	ff 36                	push   (%esi)
  64:	68 4c 03 00 00       	push   $0x34c
  69:	6a 02                	push   $0x2
  6b:	e8 68 01 00 00       	call   1d8 <printf>
      break;
  70:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit(0);
  73:	83 ec 0c             	sub    $0xc,%esp
  76:	6a 00                	push   $0x0
  78:	e8 08 00 00 00       	call   85 <exit>

0000007d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  7d:	b8 01 00 00 00       	mov    $0x1,%eax
  82:	cd 40                	int    $0x40
  84:	c3                   	ret

00000085 <exit>:
SYSCALL(exit)
  85:	b8 02 00 00 00       	mov    $0x2,%eax
  8a:	cd 40                	int    $0x40
  8c:	c3                   	ret

0000008d <wait>:
SYSCALL(wait)
  8d:	b8 03 00 00 00       	mov    $0x3,%eax
  92:	cd 40                	int    $0x40
  94:	c3                   	ret

00000095 <pipe>:
SYSCALL(pipe)
  95:	b8 04 00 00 00       	mov    $0x4,%eax
  9a:	cd 40                	int    $0x40
  9c:	c3                   	ret

0000009d <read>:
SYSCALL(read)
  9d:	b8 05 00 00 00       	mov    $0x5,%eax
  a2:	cd 40                	int    $0x40
  a4:	c3                   	ret

000000a5 <write>:
SYSCALL(write)
  a5:	b8 10 00 00 00       	mov    $0x10,%eax
  aa:	cd 40                	int    $0x40
  ac:	c3                   	ret

000000ad <close>:
SYSCALL(close)
  ad:	b8 15 00 00 00       	mov    $0x15,%eax
  b2:	cd 40                	int    $0x40
  b4:	c3                   	ret

000000b5 <kill>:
SYSCALL(kill)
  b5:	b8 06 00 00 00       	mov    $0x6,%eax
  ba:	cd 40                	int    $0x40
  bc:	c3                   	ret

000000bd <exec>:
SYSCALL(exec)
  bd:	b8 07 00 00 00       	mov    $0x7,%eax
  c2:	cd 40                	int    $0x40
  c4:	c3                   	ret

000000c5 <open>:
SYSCALL(open)
  c5:	b8 0f 00 00 00       	mov    $0xf,%eax
  ca:	cd 40                	int    $0x40
  cc:	c3                   	ret

000000cd <mknod>:
SYSCALL(mknod)
  cd:	b8 11 00 00 00       	mov    $0x11,%eax
  d2:	cd 40                	int    $0x40
  d4:	c3                   	ret

000000d5 <unlink>:
SYSCALL(unlink)
  d5:	b8 12 00 00 00       	mov    $0x12,%eax
  da:	cd 40                	int    $0x40
  dc:	c3                   	ret

000000dd <fstat>:
SYSCALL(fstat)
  dd:	b8 08 00 00 00       	mov    $0x8,%eax
  e2:	cd 40                	int    $0x40
  e4:	c3                   	ret

000000e5 <link>:
SYSCALL(link)
  e5:	b8 13 00 00 00       	mov    $0x13,%eax
  ea:	cd 40                	int    $0x40
  ec:	c3                   	ret

000000ed <mkdir>:
SYSCALL(mkdir)
  ed:	b8 14 00 00 00       	mov    $0x14,%eax
  f2:	cd 40                	int    $0x40
  f4:	c3                   	ret

000000f5 <chdir>:
SYSCALL(chdir)
  f5:	b8 09 00 00 00       	mov    $0x9,%eax
  fa:	cd 40                	int    $0x40
  fc:	c3                   	ret

000000fd <dup>:
SYSCALL(dup)
  fd:	b8 0a 00 00 00       	mov    $0xa,%eax
 102:	cd 40                	int    $0x40
 104:	c3                   	ret

00000105 <getpid>:
SYSCALL(getpid)
 105:	b8 0b 00 00 00       	mov    $0xb,%eax
 10a:	cd 40                	int    $0x40
 10c:	c3                   	ret

0000010d <sbrk>:
SYSCALL(sbrk)
 10d:	b8 0c 00 00 00       	mov    $0xc,%eax
 112:	cd 40                	int    $0x40
 114:	c3                   	ret

00000115 <sleep>:
SYSCALL(sleep)
 115:	b8 0d 00 00 00       	mov    $0xd,%eax
 11a:	cd 40                	int    $0x40
 11c:	c3                   	ret

0000011d <uptime>:
SYSCALL(uptime)
 11d:	b8 0e 00 00 00       	mov    $0xe,%eax
 122:	cd 40                	int    $0x40
 124:	c3                   	ret

00000125 <date>:
SYSCALL(date)
 125:	b8 16 00 00 00       	mov    $0x16,%eax
 12a:	cd 40                	int    $0x40
 12c:	c3                   	ret

0000012d <dup2>:
SYSCALL(dup2)
 12d:	b8 17 00 00 00       	mov    $0x17,%eax
 132:	cd 40                	int    $0x40
 134:	c3                   	ret

00000135 <getprio>:
SYSCALL(getprio)
 135:	b8 18 00 00 00       	mov    $0x18,%eax
 13a:	cd 40                	int    $0x40
 13c:	c3                   	ret

0000013d <setprio>:
 13d:	b8 19 00 00 00       	mov    $0x19,%eax
 142:	cd 40                	int    $0x40
 144:	c3                   	ret

00000145 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 145:	55                   	push   %ebp
 146:	89 e5                	mov    %esp,%ebp
 148:	83 ec 1c             	sub    $0x1c,%esp
 14b:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 14e:	6a 01                	push   $0x1
 150:	8d 55 f4             	lea    -0xc(%ebp),%edx
 153:	52                   	push   %edx
 154:	50                   	push   %eax
 155:	e8 4b ff ff ff       	call   a5 <write>
}
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	c9                   	leave
 15e:	c3                   	ret

0000015f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 15f:	55                   	push   %ebp
 160:	89 e5                	mov    %esp,%ebp
 162:	57                   	push   %edi
 163:	56                   	push   %esi
 164:	53                   	push   %ebx
 165:	83 ec 2c             	sub    $0x2c,%esp
 168:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 16b:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 16d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 171:	74 04                	je     177 <printint+0x18>
 173:	85 d2                	test   %edx,%edx
 175:	78 3c                	js     1b3 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 177:	89 d1                	mov    %edx,%ecx
  neg = 0;
 179:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 180:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 185:	89 c8                	mov    %ecx,%eax
 187:	ba 00 00 00 00       	mov    $0x0,%edx
 18c:	f7 f6                	div    %esi
 18e:	89 df                	mov    %ebx,%edi
 190:	43                   	inc    %ebx
 191:	8a 92 c4 03 00 00    	mov    0x3c4(%edx),%dl
 197:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 19b:	89 ca                	mov    %ecx,%edx
 19d:	89 c1                	mov    %eax,%ecx
 19f:	39 f2                	cmp    %esi,%edx
 1a1:	73 e2                	jae    185 <printint+0x26>
  if(neg)
 1a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1a7:	74 24                	je     1cd <printint+0x6e>
    buf[i++] = '-';
 1a9:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1ae:	8d 5f 02             	lea    0x2(%edi),%ebx
 1b1:	eb 1a                	jmp    1cd <printint+0x6e>
    x = -xx;
 1b3:	89 d1                	mov    %edx,%ecx
 1b5:	f7 d9                	neg    %ecx
    neg = 1;
 1b7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1be:	eb c0                	jmp    180 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 1c0:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1c8:	e8 78 ff ff ff       	call   145 <putc>
  while(--i >= 0)
 1cd:	4b                   	dec    %ebx
 1ce:	79 f0                	jns    1c0 <printint+0x61>
}
 1d0:	83 c4 2c             	add    $0x2c,%esp
 1d3:	5b                   	pop    %ebx
 1d4:	5e                   	pop    %esi
 1d5:	5f                   	pop    %edi
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret

000001d8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	57                   	push   %edi
 1dc:	56                   	push   %esi
 1dd:	53                   	push   %ebx
 1de:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1e1:	8d 45 10             	lea    0x10(%ebp),%eax
 1e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1e7:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1ec:	bb 00 00 00 00       	mov    $0x0,%ebx
 1f1:	eb 12                	jmp    205 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1f3:	89 fa                	mov    %edi,%edx
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	e8 48 ff ff ff       	call   145 <putc>
 1fd:	eb 05                	jmp    204 <printf+0x2c>
      }
    } else if(state == '%'){
 1ff:	83 fe 25             	cmp    $0x25,%esi
 202:	74 22                	je     226 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 204:	43                   	inc    %ebx
 205:	8b 45 0c             	mov    0xc(%ebp),%eax
 208:	8a 04 18             	mov    (%eax,%ebx,1),%al
 20b:	84 c0                	test   %al,%al
 20d:	0f 84 1d 01 00 00    	je     330 <printf+0x158>
    c = fmt[i] & 0xff;
 213:	0f be f8             	movsbl %al,%edi
 216:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 219:	85 f6                	test   %esi,%esi
 21b:	75 e2                	jne    1ff <printf+0x27>
      if(c == '%'){
 21d:	83 f8 25             	cmp    $0x25,%eax
 220:	75 d1                	jne    1f3 <printf+0x1b>
        state = '%';
 222:	89 c6                	mov    %eax,%esi
 224:	eb de                	jmp    204 <printf+0x2c>
      if(c == 'd'){
 226:	83 f8 25             	cmp    $0x25,%eax
 229:	0f 84 cc 00 00 00    	je     2fb <printf+0x123>
 22f:	0f 8c da 00 00 00    	jl     30f <printf+0x137>
 235:	83 f8 78             	cmp    $0x78,%eax
 238:	0f 8f d1 00 00 00    	jg     30f <printf+0x137>
 23e:	83 f8 63             	cmp    $0x63,%eax
 241:	0f 8c c8 00 00 00    	jl     30f <printf+0x137>
 247:	83 e8 63             	sub    $0x63,%eax
 24a:	83 f8 15             	cmp    $0x15,%eax
 24d:	0f 87 bc 00 00 00    	ja     30f <printf+0x137>
 253:	ff 24 85 6c 03 00 00 	jmp    *0x36c(,%eax,4)
        printint(fd, *ap, 10, 1);
 25a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 25d:	8b 17                	mov    (%edi),%edx
 25f:	83 ec 0c             	sub    $0xc,%esp
 262:	6a 01                	push   $0x1
 264:	b9 0a 00 00 00       	mov    $0xa,%ecx
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	e8 ee fe ff ff       	call   15f <printint>
        ap++;
 271:	83 c7 04             	add    $0x4,%edi
 274:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 277:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 27a:	be 00 00 00 00       	mov    $0x0,%esi
 27f:	eb 83                	jmp    204 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 281:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 284:	8b 17                	mov    (%edi),%edx
 286:	83 ec 0c             	sub    $0xc,%esp
 289:	6a 00                	push   $0x0
 28b:	b9 10 00 00 00       	mov    $0x10,%ecx
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	e8 c7 fe ff ff       	call   15f <printint>
        ap++;
 298:	83 c7 04             	add    $0x4,%edi
 29b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 29e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2a1:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2a6:	e9 59 ff ff ff       	jmp    204 <printf+0x2c>
        s = (char*)*ap;
 2ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2ae:	8b 30                	mov    (%eax),%esi
        ap++;
 2b0:	83 c0 04             	add    $0x4,%eax
 2b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2b6:	85 f6                	test   %esi,%esi
 2b8:	75 13                	jne    2cd <printf+0xf5>
          s = "(null)";
 2ba:	be 65 03 00 00       	mov    $0x365,%esi
 2bf:	eb 0c                	jmp    2cd <printf+0xf5>
          putc(fd, *s);
 2c1:	0f be d2             	movsbl %dl,%edx
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	e8 79 fe ff ff       	call   145 <putc>
          s++;
 2cc:	46                   	inc    %esi
        while(*s != 0){
 2cd:	8a 16                	mov    (%esi),%dl
 2cf:	84 d2                	test   %dl,%dl
 2d1:	75 ee                	jne    2c1 <printf+0xe9>
      state = 0;
 2d3:	be 00 00 00 00       	mov    $0x0,%esi
 2d8:	e9 27 ff ff ff       	jmp    204 <printf+0x2c>
        putc(fd, *ap);
 2dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2e0:	0f be 17             	movsbl (%edi),%edx
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	e8 5a fe ff ff       	call   145 <putc>
        ap++;
 2eb:	83 c7 04             	add    $0x4,%edi
 2ee:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2f1:	be 00 00 00 00       	mov    $0x0,%esi
 2f6:	e9 09 ff ff ff       	jmp    204 <printf+0x2c>
        putc(fd, c);
 2fb:	89 fa                	mov    %edi,%edx
 2fd:	8b 45 08             	mov    0x8(%ebp),%eax
 300:	e8 40 fe ff ff       	call   145 <putc>
      state = 0;
 305:	be 00 00 00 00       	mov    $0x0,%esi
 30a:	e9 f5 fe ff ff       	jmp    204 <printf+0x2c>
        putc(fd, '%');
 30f:	ba 25 00 00 00       	mov    $0x25,%edx
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	e8 29 fe ff ff       	call   145 <putc>
        putc(fd, c);
 31c:	89 fa                	mov    %edi,%edx
 31e:	8b 45 08             	mov    0x8(%ebp),%eax
 321:	e8 1f fe ff ff       	call   145 <putc>
      state = 0;
 326:	be 00 00 00 00       	mov    $0x0,%esi
 32b:	e9 d4 fe ff ff       	jmp    204 <printf+0x2c>
    }
  }
}
 330:	8d 65 f4             	lea    -0xc(%ebp),%esp
 333:	5b                   	pop    %ebx
 334:	5e                   	pop    %esi
 335:	5f                   	pop    %edi
 336:	5d                   	pop    %ebp
 337:	c3                   	ret
