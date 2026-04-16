
wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
   9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
  10:	be 00 00 00 00       	mov    $0x0,%esi
  15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  23:	83 ec 04             	sub    $0x4,%esp
  26:	68 00 02 00 00       	push   $0x200
  2b:	68 c0 08 00 00       	push   $0x8c0
  30:	ff 75 08             	push   0x8(%ebp)
  33:	e8 d7 02 00 00       	call   30f <read>
  38:	89 c7                	mov    %eax,%edi
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	85 c0                	test   %eax,%eax
  3f:	7e 4d                	jle    8e <wc+0x8e>
    for(i=0; i<n; i++){
  41:	bb 00 00 00 00       	mov    $0x0,%ebx
  46:	eb 20                	jmp    68 <wc+0x68>
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	0f be c0             	movsbl %al,%eax
  4e:	50                   	push   %eax
  4f:	68 ac 05 00 00       	push   $0x5ac
  54:	e8 8b 01 00 00       	call   1e4 <strchr>
  59:	83 c4 10             	add    $0x10,%esp
  5c:	85 c0                	test   %eax,%eax
  5e:	74 1c                	je     7c <wc+0x7c>
        inword = 0;
  60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(i=0; i<n; i++){
  67:	43                   	inc    %ebx
  68:	39 fb                	cmp    %edi,%ebx
  6a:	7d b7                	jge    23 <wc+0x23>
      c++;
  6c:	46                   	inc    %esi
      if(buf[i] == '\n')
  6d:	8a 83 c0 08 00 00    	mov    0x8c0(%ebx),%al
  73:	3c 0a                	cmp    $0xa,%al
  75:	75 d1                	jne    48 <wc+0x48>
        l++;
  77:	ff 45 e0             	incl   -0x20(%ebp)
  7a:	eb cc                	jmp    48 <wc+0x48>
      else if(!inword){
  7c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80:	75 e5                	jne    67 <wc+0x67>
        w++;
  82:	ff 45 dc             	incl   -0x24(%ebp)
        inword = 1;
  85:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  8c:	eb d9                	jmp    67 <wc+0x67>
      }
    }
  }
  if(n < 0){
  8e:	78 24                	js     b4 <wc+0xb4>
    printf(1, "wc: read error\n");
    exit(0);
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  90:	83 ec 08             	sub    $0x8,%esp
  93:	ff 75 0c             	push   0xc(%ebp)
  96:	56                   	push   %esi
  97:	ff 75 dc             	push   -0x24(%ebp)
  9a:	ff 75 e0             	push   -0x20(%ebp)
  9d:	68 c2 05 00 00       	push   $0x5c2
  a2:	6a 01                	push   $0x1
  a4:	e8 a1 03 00 00       	call   44a <printf>
}
  a9:	83 c4 20             	add    $0x20,%esp
  ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  af:	5b                   	pop    %ebx
  b0:	5e                   	pop    %esi
  b1:	5f                   	pop    %edi
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret
    printf(1, "wc: read error\n");
  b4:	83 ec 08             	sub    $0x8,%esp
  b7:	68 b2 05 00 00       	push   $0x5b2
  bc:	6a 01                	push   $0x1
  be:	e8 87 03 00 00       	call   44a <printf>
    exit(0);
  c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  ca:	e8 28 02 00 00       	call   2f7 <exit>

000000cf <main>:

int
main(int argc, char *argv[])
{
  cf:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  d3:	83 e4 f0             	and    $0xfffffff0,%esp
  d6:	ff 71 fc             	push   -0x4(%ecx)
  d9:	55                   	push   %ebp
  da:	89 e5                	mov    %esp,%ebp
  dc:	57                   	push   %edi
  dd:	56                   	push   %esi
  de:	53                   	push   %ebx
  df:	51                   	push   %ecx
  e0:	83 ec 18             	sub    $0x18,%esp
  e3:	8b 01                	mov    (%ecx),%eax
  e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  e8:	8b 51 04             	mov    0x4(%ecx),%edx
  eb:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  ee:	83 f8 01             	cmp    $0x1,%eax
  f1:	7e 07                	jle    fa <main+0x2b>
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
  f3:	be 01 00 00 00       	mov    $0x1,%esi
  f8:	eb 32                	jmp    12c <main+0x5d>
    wc(0, "");
  fa:	83 ec 08             	sub    $0x8,%esp
  fd:	68 c1 05 00 00       	push   $0x5c1
 102:	6a 00                	push   $0x0
 104:	e8 f7 fe ff ff       	call   0 <wc>
    exit(0);
 109:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 110:	e8 e2 01 00 00       	call   2f7 <exit>
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit(0);
    }
    wc(fd, argv[i]);
 115:	83 ec 08             	sub    $0x8,%esp
 118:	ff 37                	push   (%edi)
 11a:	50                   	push   %eax
 11b:	e8 e0 fe ff ff       	call   0 <wc>
    close(fd);
 120:	89 1c 24             	mov    %ebx,(%esp)
 123:	e8 f7 01 00 00       	call   31f <close>
  for(i = 1; i < argc; i++){
 128:	46                   	inc    %esi
 129:	83 c4 10             	add    $0x10,%esp
 12c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12f:	39 c6                	cmp    %eax,%esi
 131:	7d 38                	jge    16b <main+0x9c>
    if((fd = open(argv[i], 0)) < 0){
 133:	8b 45 e0             	mov    -0x20(%ebp),%eax
 136:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 139:	83 ec 08             	sub    $0x8,%esp
 13c:	6a 00                	push   $0x0
 13e:	ff 37                	push   (%edi)
 140:	e8 f2 01 00 00       	call   337 <open>
 145:	89 c3                	mov    %eax,%ebx
 147:	83 c4 10             	add    $0x10,%esp
 14a:	85 c0                	test   %eax,%eax
 14c:	79 c7                	jns    115 <main+0x46>
      printf(1, "wc: cannot open %s\n", argv[i]);
 14e:	83 ec 04             	sub    $0x4,%esp
 151:	ff 37                	push   (%edi)
 153:	68 cf 05 00 00       	push   $0x5cf
 158:	6a 01                	push   $0x1
 15a:	e8 eb 02 00 00       	call   44a <printf>
      exit(0);
 15f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 166:	e8 8c 01 00 00       	call   2f7 <exit>
  }
  exit(0);
 16b:	83 ec 0c             	sub    $0xc,%esp
 16e:	6a 00                	push   $0x0
 170:	e8 82 01 00 00       	call   2f7 <exit>

00000175 <start>:

// Entry point of the library	
void
start()
{
}
 175:	c3                   	ret

00000176 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 176:	55                   	push   %ebp
 177:	89 e5                	mov    %esp,%ebp
 179:	56                   	push   %esi
 17a:	53                   	push   %ebx
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 181:	89 c2                	mov    %eax,%edx
 183:	89 cb                	mov    %ecx,%ebx
 185:	41                   	inc    %ecx
 186:	89 d6                	mov    %edx,%esi
 188:	42                   	inc    %edx
 189:	8a 1b                	mov    (%ebx),%bl
 18b:	88 1e                	mov    %bl,(%esi)
 18d:	84 db                	test   %bl,%bl
 18f:	75 f2                	jne    183 <strcpy+0xd>
    ;
  return os;
}
 191:	5b                   	pop    %ebx
 192:	5e                   	pop    %esi
 193:	5d                   	pop    %ebp
 194:	c3                   	ret

00000195 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
 198:	8b 4d 08             	mov    0x8(%ebp),%ecx
 19b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 19e:	eb 02                	jmp    1a2 <strcmp+0xd>
    p++, q++;
 1a0:	41                   	inc    %ecx
 1a1:	42                   	inc    %edx
  while(*p && *p == *q)
 1a2:	8a 01                	mov    (%ecx),%al
 1a4:	84 c0                	test   %al,%al
 1a6:	74 04                	je     1ac <strcmp+0x17>
 1a8:	3a 02                	cmp    (%edx),%al
 1aa:	74 f4                	je     1a0 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 1ac:	0f b6 c0             	movzbl %al,%eax
 1af:	0f b6 12             	movzbl (%edx),%edx
 1b2:	29 d0                	sub    %edx,%eax
}
 1b4:	5d                   	pop    %ebp
 1b5:	c3                   	ret

000001b6 <strlen>:

uint
strlen(const char *s)
{
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1bc:	b8 00 00 00 00       	mov    $0x0,%eax
 1c1:	eb 01                	jmp    1c4 <strlen+0xe>
 1c3:	40                   	inc    %eax
 1c4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1c8:	75 f9                	jne    1c3 <strlen+0xd>
    ;
  return n;
}
 1ca:	5d                   	pop    %ebp
 1cb:	c3                   	ret

000001cc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1d0:	8b 7d 08             	mov    0x8(%ebp),%edi
 1d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d9:	fc                   	cld
 1da:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1e2:	c9                   	leave
 1e3:	c3                   	ret

000001e4 <strchr>:

char*
strchr(const char *s, char c)
{
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1ed:	eb 01                	jmp    1f0 <strchr+0xc>
 1ef:	40                   	inc    %eax
 1f0:	8a 10                	mov    (%eax),%dl
 1f2:	84 d2                	test   %dl,%dl
 1f4:	74 06                	je     1fc <strchr+0x18>
    if(*s == c)
 1f6:	38 ca                	cmp    %cl,%dl
 1f8:	75 f5                	jne    1ef <strchr+0xb>
 1fa:	eb 05                	jmp    201 <strchr+0x1d>
      return (char*)s;
  return 0;
 1fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
 201:	5d                   	pop    %ebp
 202:	c3                   	ret

00000203 <gets>:

char*
gets(char *buf, int max)
{
 203:	55                   	push   %ebp
 204:	89 e5                	mov    %esp,%ebp
 206:	57                   	push   %edi
 207:	56                   	push   %esi
 208:	53                   	push   %ebx
 209:	83 ec 1c             	sub    $0x1c,%esp
 20c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20f:	bb 00 00 00 00       	mov    $0x0,%ebx
 214:	89 de                	mov    %ebx,%esi
 216:	43                   	inc    %ebx
 217:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 21a:	7d 2b                	jge    247 <gets+0x44>
    cc = read(0, &c, 1);
 21c:	83 ec 04             	sub    $0x4,%esp
 21f:	6a 01                	push   $0x1
 221:	8d 45 e7             	lea    -0x19(%ebp),%eax
 224:	50                   	push   %eax
 225:	6a 00                	push   $0x0
 227:	e8 e3 00 00 00       	call   30f <read>
    if(cc < 1)
 22c:	83 c4 10             	add    $0x10,%esp
 22f:	85 c0                	test   %eax,%eax
 231:	7e 14                	jle    247 <gets+0x44>
      break;
    buf[i++] = c;
 233:	8a 45 e7             	mov    -0x19(%ebp),%al
 236:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 239:	3c 0a                	cmp    $0xa,%al
 23b:	74 08                	je     245 <gets+0x42>
 23d:	3c 0d                	cmp    $0xd,%al
 23f:	75 d3                	jne    214 <gets+0x11>
    buf[i++] = c;
 241:	89 de                	mov    %ebx,%esi
 243:	eb 02                	jmp    247 <gets+0x44>
 245:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 247:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 24b:	89 f8                	mov    %edi,%eax
 24d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 250:	5b                   	pop    %ebx
 251:	5e                   	pop    %esi
 252:	5f                   	pop    %edi
 253:	5d                   	pop    %ebp
 254:	c3                   	ret

00000255 <stat>:

int
stat(const char *n, struct stat *st)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	56                   	push   %esi
 259:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25a:	83 ec 08             	sub    $0x8,%esp
 25d:	6a 00                	push   $0x0
 25f:	ff 75 08             	push   0x8(%ebp)
 262:	e8 d0 00 00 00       	call   337 <open>
  if(fd < 0)
 267:	83 c4 10             	add    $0x10,%esp
 26a:	85 c0                	test   %eax,%eax
 26c:	78 24                	js     292 <stat+0x3d>
 26e:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 270:	83 ec 08             	sub    $0x8,%esp
 273:	ff 75 0c             	push   0xc(%ebp)
 276:	50                   	push   %eax
 277:	e8 d3 00 00 00       	call   34f <fstat>
 27c:	89 c6                	mov    %eax,%esi
  close(fd);
 27e:	89 1c 24             	mov    %ebx,(%esp)
 281:	e8 99 00 00 00       	call   31f <close>
  return r;
 286:	83 c4 10             	add    $0x10,%esp
}
 289:	89 f0                	mov    %esi,%eax
 28b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 28e:	5b                   	pop    %ebx
 28f:	5e                   	pop    %esi
 290:	5d                   	pop    %ebp
 291:	c3                   	ret
    return -1;
 292:	be ff ff ff ff       	mov    $0xffffffff,%esi
 297:	eb f0                	jmp    289 <stat+0x34>

00000299 <atoi>:

int
atoi(const char *s)
{
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
 29c:	53                   	push   %ebx
 29d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 2a0:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2a5:	eb 0e                	jmp    2b5 <atoi+0x1c>
    n = n*10 + *s++ - '0';
 2a7:	8d 14 92             	lea    (%edx,%edx,4),%edx
 2aa:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 2ad:	41                   	inc    %ecx
 2ae:	0f be c0             	movsbl %al,%eax
 2b1:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 2b5:	8a 01                	mov    (%ecx),%al
 2b7:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2ba:	80 fb 09             	cmp    $0x9,%bl
 2bd:	76 e8                	jbe    2a7 <atoi+0xe>
  return n;
}
 2bf:	89 d0                	mov    %edx,%eax
 2c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2c4:	c9                   	leave
 2c5:	c3                   	ret

000002c6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	56                   	push   %esi
 2ca:	53                   	push   %ebx
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2d1:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 2d4:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 2d6:	eb 0c                	jmp    2e4 <memmove+0x1e>
    *dst++ = *src++;
 2d8:	8a 13                	mov    (%ebx),%dl
 2da:	88 11                	mov    %dl,(%ecx)
 2dc:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2df:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 2e2:	89 f2                	mov    %esi,%edx
 2e4:	8d 72 ff             	lea    -0x1(%edx),%esi
 2e7:	85 d2                	test   %edx,%edx
 2e9:	7f ed                	jg     2d8 <memmove+0x12>
  return vdst;
}
 2eb:	5b                   	pop    %ebx
 2ec:	5e                   	pop    %esi
 2ed:	5d                   	pop    %ebp
 2ee:	c3                   	ret

000002ef <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ef:	b8 01 00 00 00       	mov    $0x1,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret

000002f7 <exit>:
SYSCALL(exit)
 2f7:	b8 02 00 00 00       	mov    $0x2,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret

000002ff <wait>:
SYSCALL(wait)
 2ff:	b8 03 00 00 00       	mov    $0x3,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret

00000307 <pipe>:
SYSCALL(pipe)
 307:	b8 04 00 00 00       	mov    $0x4,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret

0000030f <read>:
SYSCALL(read)
 30f:	b8 05 00 00 00       	mov    $0x5,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret

00000317 <write>:
SYSCALL(write)
 317:	b8 10 00 00 00       	mov    $0x10,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret

0000031f <close>:
SYSCALL(close)
 31f:	b8 15 00 00 00       	mov    $0x15,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret

00000327 <kill>:
SYSCALL(kill)
 327:	b8 06 00 00 00       	mov    $0x6,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret

0000032f <exec>:
SYSCALL(exec)
 32f:	b8 07 00 00 00       	mov    $0x7,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret

00000337 <open>:
SYSCALL(open)
 337:	b8 0f 00 00 00       	mov    $0xf,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret

0000033f <mknod>:
SYSCALL(mknod)
 33f:	b8 11 00 00 00       	mov    $0x11,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret

00000347 <unlink>:
SYSCALL(unlink)
 347:	b8 12 00 00 00       	mov    $0x12,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret

0000034f <fstat>:
SYSCALL(fstat)
 34f:	b8 08 00 00 00       	mov    $0x8,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret

00000357 <link>:
SYSCALL(link)
 357:	b8 13 00 00 00       	mov    $0x13,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret

0000035f <mkdir>:
SYSCALL(mkdir)
 35f:	b8 14 00 00 00       	mov    $0x14,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret

00000367 <chdir>:
SYSCALL(chdir)
 367:	b8 09 00 00 00       	mov    $0x9,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret

0000036f <dup>:
SYSCALL(dup)
 36f:	b8 0a 00 00 00       	mov    $0xa,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret

00000377 <getpid>:
SYSCALL(getpid)
 377:	b8 0b 00 00 00       	mov    $0xb,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret

0000037f <sbrk>:
SYSCALL(sbrk)
 37f:	b8 0c 00 00 00       	mov    $0xc,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret

00000387 <sleep>:
SYSCALL(sleep)
 387:	b8 0d 00 00 00       	mov    $0xd,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret

0000038f <uptime>:
SYSCALL(uptime)
 38f:	b8 0e 00 00 00       	mov    $0xe,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret

00000397 <date>:
SYSCALL(date)
 397:	b8 16 00 00 00       	mov    $0x16,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret

0000039f <dup2>:
SYSCALL(dup2)
 39f:	b8 17 00 00 00       	mov    $0x17,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret

000003a7 <getprio>:
SYSCALL(getprio)
 3a7:	b8 18 00 00 00       	mov    $0x18,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret

000003af <setprio>:
 3af:	b8 19 00 00 00       	mov    $0x19,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret

000003b7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b7:	55                   	push   %ebp
 3b8:	89 e5                	mov    %esp,%ebp
 3ba:	83 ec 1c             	sub    $0x1c,%esp
 3bd:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3c0:	6a 01                	push   $0x1
 3c2:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3c5:	52                   	push   %edx
 3c6:	50                   	push   %eax
 3c7:	e8 4b ff ff ff       	call   317 <write>
}
 3cc:	83 c4 10             	add    $0x10,%esp
 3cf:	c9                   	leave
 3d0:	c3                   	ret

000003d1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d1:	55                   	push   %ebp
 3d2:	89 e5                	mov    %esp,%ebp
 3d4:	57                   	push   %edi
 3d5:	56                   	push   %esi
 3d6:	53                   	push   %ebx
 3d7:	83 ec 2c             	sub    $0x2c,%esp
 3da:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3dd:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3e3:	74 04                	je     3e9 <printint+0x18>
 3e5:	85 d2                	test   %edx,%edx
 3e7:	78 3c                	js     425 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e9:	89 d1                	mov    %edx,%ecx
  neg = 0;
 3eb:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 3f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3f7:	89 c8                	mov    %ecx,%eax
 3f9:	ba 00 00 00 00       	mov    $0x0,%edx
 3fe:	f7 f6                	div    %esi
 400:	89 df                	mov    %ebx,%edi
 402:	43                   	inc    %ebx
 403:	8a 92 44 06 00 00    	mov    0x644(%edx),%dl
 409:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 40d:	89 ca                	mov    %ecx,%edx
 40f:	89 c1                	mov    %eax,%ecx
 411:	39 f2                	cmp    %esi,%edx
 413:	73 e2                	jae    3f7 <printint+0x26>
  if(neg)
 415:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 419:	74 24                	je     43f <printint+0x6e>
    buf[i++] = '-';
 41b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 420:	8d 5f 02             	lea    0x2(%edi),%ebx
 423:	eb 1a                	jmp    43f <printint+0x6e>
    x = -xx;
 425:	89 d1                	mov    %edx,%ecx
 427:	f7 d9                	neg    %ecx
    neg = 1;
 429:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 430:	eb c0                	jmp    3f2 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 432:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 437:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 43a:	e8 78 ff ff ff       	call   3b7 <putc>
  while(--i >= 0)
 43f:	4b                   	dec    %ebx
 440:	79 f0                	jns    432 <printint+0x61>
}
 442:	83 c4 2c             	add    $0x2c,%esp
 445:	5b                   	pop    %ebx
 446:	5e                   	pop    %esi
 447:	5f                   	pop    %edi
 448:	5d                   	pop    %ebp
 449:	c3                   	ret

0000044a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 44a:	55                   	push   %ebp
 44b:	89 e5                	mov    %esp,%ebp
 44d:	57                   	push   %edi
 44e:	56                   	push   %esi
 44f:	53                   	push   %ebx
 450:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 453:	8d 45 10             	lea    0x10(%ebp),%eax
 456:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 459:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 45e:	bb 00 00 00 00       	mov    $0x0,%ebx
 463:	eb 12                	jmp    477 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 465:	89 fa                	mov    %edi,%edx
 467:	8b 45 08             	mov    0x8(%ebp),%eax
 46a:	e8 48 ff ff ff       	call   3b7 <putc>
 46f:	eb 05                	jmp    476 <printf+0x2c>
      }
    } else if(state == '%'){
 471:	83 fe 25             	cmp    $0x25,%esi
 474:	74 22                	je     498 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 476:	43                   	inc    %ebx
 477:	8b 45 0c             	mov    0xc(%ebp),%eax
 47a:	8a 04 18             	mov    (%eax,%ebx,1),%al
 47d:	84 c0                	test   %al,%al
 47f:	0f 84 1d 01 00 00    	je     5a2 <printf+0x158>
    c = fmt[i] & 0xff;
 485:	0f be f8             	movsbl %al,%edi
 488:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 48b:	85 f6                	test   %esi,%esi
 48d:	75 e2                	jne    471 <printf+0x27>
      if(c == '%'){
 48f:	83 f8 25             	cmp    $0x25,%eax
 492:	75 d1                	jne    465 <printf+0x1b>
        state = '%';
 494:	89 c6                	mov    %eax,%esi
 496:	eb de                	jmp    476 <printf+0x2c>
      if(c == 'd'){
 498:	83 f8 25             	cmp    $0x25,%eax
 49b:	0f 84 cc 00 00 00    	je     56d <printf+0x123>
 4a1:	0f 8c da 00 00 00    	jl     581 <printf+0x137>
 4a7:	83 f8 78             	cmp    $0x78,%eax
 4aa:	0f 8f d1 00 00 00    	jg     581 <printf+0x137>
 4b0:	83 f8 63             	cmp    $0x63,%eax
 4b3:	0f 8c c8 00 00 00    	jl     581 <printf+0x137>
 4b9:	83 e8 63             	sub    $0x63,%eax
 4bc:	83 f8 15             	cmp    $0x15,%eax
 4bf:	0f 87 bc 00 00 00    	ja     581 <printf+0x137>
 4c5:	ff 24 85 ec 05 00 00 	jmp    *0x5ec(,%eax,4)
        printint(fd, *ap, 10, 1);
 4cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4cf:	8b 17                	mov    (%edi),%edx
 4d1:	83 ec 0c             	sub    $0xc,%esp
 4d4:	6a 01                	push   $0x1
 4d6:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	e8 ee fe ff ff       	call   3d1 <printint>
        ap++;
 4e3:	83 c7 04             	add    $0x4,%edi
 4e6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4e9:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ec:	be 00 00 00 00       	mov    $0x0,%esi
 4f1:	eb 83                	jmp    476 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4f6:	8b 17                	mov    (%edi),%edx
 4f8:	83 ec 0c             	sub    $0xc,%esp
 4fb:	6a 00                	push   $0x0
 4fd:	b9 10 00 00 00       	mov    $0x10,%ecx
 502:	8b 45 08             	mov    0x8(%ebp),%eax
 505:	e8 c7 fe ff ff       	call   3d1 <printint>
        ap++;
 50a:	83 c7 04             	add    $0x4,%edi
 50d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 510:	83 c4 10             	add    $0x10,%esp
      state = 0;
 513:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 518:	e9 59 ff ff ff       	jmp    476 <printf+0x2c>
        s = (char*)*ap;
 51d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 520:	8b 30                	mov    (%eax),%esi
        ap++;
 522:	83 c0 04             	add    $0x4,%eax
 525:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 528:	85 f6                	test   %esi,%esi
 52a:	75 13                	jne    53f <printf+0xf5>
          s = "(null)";
 52c:	be e3 05 00 00       	mov    $0x5e3,%esi
 531:	eb 0c                	jmp    53f <printf+0xf5>
          putc(fd, *s);
 533:	0f be d2             	movsbl %dl,%edx
 536:	8b 45 08             	mov    0x8(%ebp),%eax
 539:	e8 79 fe ff ff       	call   3b7 <putc>
          s++;
 53e:	46                   	inc    %esi
        while(*s != 0){
 53f:	8a 16                	mov    (%esi),%dl
 541:	84 d2                	test   %dl,%dl
 543:	75 ee                	jne    533 <printf+0xe9>
      state = 0;
 545:	be 00 00 00 00       	mov    $0x0,%esi
 54a:	e9 27 ff ff ff       	jmp    476 <printf+0x2c>
        putc(fd, *ap);
 54f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 552:	0f be 17             	movsbl (%edi),%edx
 555:	8b 45 08             	mov    0x8(%ebp),%eax
 558:	e8 5a fe ff ff       	call   3b7 <putc>
        ap++;
 55d:	83 c7 04             	add    $0x4,%edi
 560:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 563:	be 00 00 00 00       	mov    $0x0,%esi
 568:	e9 09 ff ff ff       	jmp    476 <printf+0x2c>
        putc(fd, c);
 56d:	89 fa                	mov    %edi,%edx
 56f:	8b 45 08             	mov    0x8(%ebp),%eax
 572:	e8 40 fe ff ff       	call   3b7 <putc>
      state = 0;
 577:	be 00 00 00 00       	mov    $0x0,%esi
 57c:	e9 f5 fe ff ff       	jmp    476 <printf+0x2c>
        putc(fd, '%');
 581:	ba 25 00 00 00       	mov    $0x25,%edx
 586:	8b 45 08             	mov    0x8(%ebp),%eax
 589:	e8 29 fe ff ff       	call   3b7 <putc>
        putc(fd, c);
 58e:	89 fa                	mov    %edi,%edx
 590:	8b 45 08             	mov    0x8(%ebp),%eax
 593:	e8 1f fe ff ff       	call   3b7 <putc>
      state = 0;
 598:	be 00 00 00 00       	mov    $0x0,%esi
 59d:	e9 d4 fe ff ff       	jmp    476 <printf+0x2c>
    }
  }
}
 5a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5a5:	5b                   	pop    %ebx
 5a6:	5e                   	pop    %esi
 5a7:	5f                   	pop    %edi
 5a8:	5d                   	pop    %ebp
 5a9:	c3                   	ret
