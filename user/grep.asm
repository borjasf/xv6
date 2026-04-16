
grep:     file format elf32-i386


Disassembly of section .text:

00000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	8b 75 08             	mov    0x8(%ebp),%esi
   c:	8b 7d 0c             	mov    0xc(%ebp),%edi
   f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  12:	83 ec 08             	sub    $0x8,%esp
  15:	53                   	push   %ebx
  16:	57                   	push   %edi
  17:	e8 29 00 00 00       	call   45 <matchhere>
  1c:	83 c4 10             	add    $0x10,%esp
  1f:	85 c0                	test   %eax,%eax
  21:	75 15                	jne    38 <matchstar+0x38>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  23:	8a 13                	mov    (%ebx),%dl
  25:	84 d2                	test   %dl,%dl
  27:	74 14                	je     3d <matchstar+0x3d>
  29:	43                   	inc    %ebx
  2a:	0f be d2             	movsbl %dl,%edx
  2d:	39 f2                	cmp    %esi,%edx
  2f:	74 e1                	je     12 <matchstar+0x12>
  31:	83 fe 2e             	cmp    $0x2e,%esi
  34:	74 dc                	je     12 <matchstar+0x12>
  36:	eb 05                	jmp    3d <matchstar+0x3d>
      return 1;
  38:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
  3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  40:	5b                   	pop    %ebx
  41:	5e                   	pop    %esi
  42:	5f                   	pop    %edi
  43:	5d                   	pop    %ebp
  44:	c3                   	ret

00000045 <matchhere>:
{
  45:	55                   	push   %ebp
  46:	89 e5                	mov    %esp,%ebp
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	8b 55 08             	mov    0x8(%ebp),%edx
  if(re[0] == '\0')
  4e:	8a 02                	mov    (%edx),%al
  50:	84 c0                	test   %al,%al
  52:	74 62                	je     b6 <matchhere+0x71>
  if(re[1] == '*')
  54:	8a 4a 01             	mov    0x1(%edx),%cl
  57:	80 f9 2a             	cmp    $0x2a,%cl
  5a:	74 1c                	je     78 <matchhere+0x33>
  if(re[0] == '$' && re[1] == '\0')
  5c:	3c 24                	cmp    $0x24,%al
  5e:	74 30                	je     90 <matchhere+0x4b>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  63:	8a 09                	mov    (%ecx),%cl
  65:	84 c9                	test   %cl,%cl
  67:	74 54                	je     bd <matchhere+0x78>
  69:	3c 2e                	cmp    $0x2e,%al
  6b:	74 35                	je     a2 <matchhere+0x5d>
  6d:	38 c8                	cmp    %cl,%al
  6f:	74 31                	je     a2 <matchhere+0x5d>
  return 0;
  71:	b8 00 00 00 00       	mov    $0x0,%eax
  76:	eb 43                	jmp    bb <matchhere+0x76>
    return matchstar(re[0], re+2, text);
  78:	83 ec 04             	sub    $0x4,%esp
  7b:	ff 75 0c             	push   0xc(%ebp)
  7e:	83 c2 02             	add    $0x2,%edx
  81:	52                   	push   %edx
  82:	0f be c0             	movsbl %al,%eax
  85:	50                   	push   %eax
  86:	e8 75 ff ff ff       	call   0 <matchstar>
  8b:	83 c4 10             	add    $0x10,%esp
  8e:	eb 2b                	jmp    bb <matchhere+0x76>
  if(re[0] == '$' && re[1] == '\0')
  90:	84 c9                	test   %cl,%cl
  92:	75 cc                	jne    60 <matchhere+0x1b>
    return *text == '\0';
  94:	8b 45 0c             	mov    0xc(%ebp),%eax
  97:	80 38 00             	cmpb   $0x0,(%eax)
  9a:	0f 94 c0             	sete   %al
  9d:	0f b6 c0             	movzbl %al,%eax
  a0:	eb 19                	jmp    bb <matchhere+0x76>
    return matchhere(re+1, text+1);
  a2:	83 ec 08             	sub    $0x8,%esp
  a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  a8:	40                   	inc    %eax
  a9:	50                   	push   %eax
  aa:	42                   	inc    %edx
  ab:	52                   	push   %edx
  ac:	e8 94 ff ff ff       	call   45 <matchhere>
  b1:	83 c4 10             	add    $0x10,%esp
  b4:	eb 05                	jmp    bb <matchhere+0x76>
    return 1;
  b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  bb:	c9                   	leave
  bc:	c3                   	ret
  return 0;
  bd:	b8 00 00 00 00       	mov    $0x0,%eax
  c2:	eb f7                	jmp    bb <matchhere+0x76>

000000c4 <match>:
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	56                   	push   %esi
  c8:	53                   	push   %ebx
  c9:	8b 75 08             	mov    0x8(%ebp),%esi
  cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
  cf:	80 3e 5e             	cmpb   $0x5e,(%esi)
  d2:	75 12                	jne    e6 <match+0x22>
    return matchhere(re+1, text);
  d4:	83 ec 08             	sub    $0x8,%esp
  d7:	53                   	push   %ebx
  d8:	46                   	inc    %esi
  d9:	56                   	push   %esi
  da:	e8 66 ff ff ff       	call   45 <matchhere>
  df:	83 c4 10             	add    $0x10,%esp
  e2:	eb 22                	jmp    106 <match+0x42>
  }while(*text++ != '\0');
  e4:	89 d3                	mov    %edx,%ebx
    if(matchhere(re, text))
  e6:	83 ec 08             	sub    $0x8,%esp
  e9:	53                   	push   %ebx
  ea:	56                   	push   %esi
  eb:	e8 55 ff ff ff       	call   45 <matchhere>
  f0:	83 c4 10             	add    $0x10,%esp
  f3:	85 c0                	test   %eax,%eax
  f5:	75 0a                	jne    101 <match+0x3d>
  }while(*text++ != '\0');
  f7:	8d 53 01             	lea    0x1(%ebx),%edx
  fa:	80 3b 00             	cmpb   $0x0,(%ebx)
  fd:	75 e5                	jne    e4 <match+0x20>
  ff:	eb 05                	jmp    106 <match+0x42>
      return 1;
 101:	b8 01 00 00 00       	mov    $0x1,%eax
}
 106:	8d 65 f8             	lea    -0x8(%ebp),%esp
 109:	5b                   	pop    %ebx
 10a:	5e                   	pop    %esi
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret

0000010d <grep>:
{
 10d:	55                   	push   %ebp
 10e:	89 e5                	mov    %esp,%ebp
 110:	57                   	push   %edi
 111:	56                   	push   %esi
 112:	53                   	push   %ebx
 113:	83 ec 1c             	sub    $0x1c,%esp
 116:	8b 7d 08             	mov    0x8(%ebp),%edi
  m = 0;
 119:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 120:	eb 52                	jmp    174 <grep+0x67>
      p = q+1;
 122:	8d 73 01             	lea    0x1(%ebx),%esi
    while((q = strchr(p, '\n')) != 0){
 125:	83 ec 08             	sub    $0x8,%esp
 128:	6a 0a                	push   $0xa
 12a:	56                   	push   %esi
 12b:	e8 f1 01 00 00       	call   321 <strchr>
 130:	89 c3                	mov    %eax,%ebx
 132:	83 c4 10             	add    $0x10,%esp
 135:	85 c0                	test   %eax,%eax
 137:	74 2d                	je     166 <grep+0x59>
      *q = 0;
 139:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	56                   	push   %esi
 140:	57                   	push   %edi
 141:	e8 7e ff ff ff       	call   c4 <match>
 146:	83 c4 10             	add    $0x10,%esp
 149:	85 c0                	test   %eax,%eax
 14b:	74 d5                	je     122 <grep+0x15>
        *q = '\n';
 14d:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 150:	8d 43 01             	lea    0x1(%ebx),%eax
 153:	83 ec 04             	sub    $0x4,%esp
 156:	29 f0                	sub    %esi,%eax
 158:	50                   	push   %eax
 159:	56                   	push   %esi
 15a:	6a 01                	push   $0x1
 15c:	e8 f3 02 00 00       	call   454 <write>
 161:	83 c4 10             	add    $0x10,%esp
 164:	eb bc                	jmp    122 <grep+0x15>
    if(p == buf)
 166:	81 fe 60 0a 00 00    	cmp    $0xa60,%esi
 16c:	74 41                	je     1af <grep+0xa2>
    if(m > 0){
 16e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 172:	7f 44                	jg     1b8 <grep+0xab>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 174:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 179:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 17c:	29 c8                	sub    %ecx,%eax
 17e:	83 ec 04             	sub    $0x4,%esp
 181:	50                   	push   %eax
 182:	8d 81 60 0a 00 00    	lea    0xa60(%ecx),%eax
 188:	50                   	push   %eax
 189:	ff 75 0c             	push   0xc(%ebp)
 18c:	e8 bb 02 00 00       	call   44c <read>
 191:	83 c4 10             	add    $0x10,%esp
 194:	85 c0                	test   %eax,%eax
 196:	7e 41                	jle    1d9 <grep+0xcc>
    m += n;
 198:	01 45 e4             	add    %eax,-0x1c(%ebp)
 19b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    buf[m] = '\0';
 19e:	c6 82 60 0a 00 00 00 	movb   $0x0,0xa60(%edx)
    p = buf;
 1a5:	be 60 0a 00 00       	mov    $0xa60,%esi
    while((q = strchr(p, '\n')) != 0){
 1aa:	e9 76 ff ff ff       	jmp    125 <grep+0x18>
      m = 0;
 1af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1b6:	eb b6                	jmp    16e <grep+0x61>
      m -= p - buf;
 1b8:	89 f0                	mov    %esi,%eax
 1ba:	2d 60 0a 00 00       	sub    $0xa60,%eax
 1bf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
 1c2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
      memmove(buf, p, m);
 1c5:	83 ec 04             	sub    $0x4,%esp
 1c8:	51                   	push   %ecx
 1c9:	56                   	push   %esi
 1ca:	68 60 0a 00 00       	push   $0xa60
 1cf:	e8 2f 02 00 00       	call   403 <memmove>
 1d4:	83 c4 10             	add    $0x10,%esp
 1d7:	eb 9b                	jmp    174 <grep+0x67>
}
 1d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1dc:	5b                   	pop    %ebx
 1dd:	5e                   	pop    %esi
 1de:	5f                   	pop    %edi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret

000001e1 <main>:
{
 1e1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 1e5:	83 e4 f0             	and    $0xfffffff0,%esp
 1e8:	ff 71 fc             	push   -0x4(%ecx)
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	57                   	push   %edi
 1ef:	56                   	push   %esi
 1f0:	53                   	push   %ebx
 1f1:	51                   	push   %ecx
 1f2:	83 ec 18             	sub    $0x18,%esp
 1f5:	8b 01                	mov    (%ecx),%eax
 1f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 1fa:	8b 51 04             	mov    0x4(%ecx),%edx
 1fd:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(argc <= 1){
 200:	83 f8 01             	cmp    $0x1,%eax
 203:	7e 54                	jle    259 <main+0x78>
  pattern = argv[1];
 205:	8b 45 e0             	mov    -0x20(%ebp),%eax
 208:	8b 40 04             	mov    0x4(%eax),%eax
 20b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(argc <= 2){
 20e:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
 212:	7e 60                	jle    274 <main+0x93>
  for(i = 2; i < argc; i++){
 214:	be 02 00 00 00       	mov    $0x2,%esi
 219:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 21c:	39 c6                	cmp    %eax,%esi
 21e:	0f 8d 84 00 00 00    	jge    2a8 <main+0xc7>
    if((fd = open(argv[i], 0)) < 0){
 224:	8b 45 e0             	mov    -0x20(%ebp),%eax
 227:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 22a:	83 ec 08             	sub    $0x8,%esp
 22d:	6a 00                	push   $0x0
 22f:	ff 37                	push   (%edi)
 231:	e8 3e 02 00 00       	call   474 <open>
 236:	89 c3                	mov    %eax,%ebx
 238:	83 c4 10             	add    $0x10,%esp
 23b:	85 c0                	test   %eax,%eax
 23d:	78 4c                	js     28b <main+0xaa>
    grep(pattern, fd);
 23f:	83 ec 08             	sub    $0x8,%esp
 242:	50                   	push   %eax
 243:	ff 75 dc             	push   -0x24(%ebp)
 246:	e8 c2 fe ff ff       	call   10d <grep>
    close(fd);
 24b:	89 1c 24             	mov    %ebx,(%esp)
 24e:	e8 09 02 00 00       	call   45c <close>
  for(i = 2; i < argc; i++){
 253:	46                   	inc    %esi
 254:	83 c4 10             	add    $0x10,%esp
 257:	eb c0                	jmp    219 <main+0x38>
    printf(2, "usage: grep pattern [file ...]\n");
 259:	83 ec 08             	sub    $0x8,%esp
 25c:	68 e8 06 00 00       	push   $0x6e8
 261:	6a 02                	push   $0x2
 263:	e8 1f 03 00 00       	call   587 <printf>
    exit(0);
 268:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 26f:	e8 c0 01 00 00       	call   434 <exit>
    grep(pattern, 0);
 274:	83 ec 08             	sub    $0x8,%esp
 277:	6a 00                	push   $0x0
 279:	50                   	push   %eax
 27a:	e8 8e fe ff ff       	call   10d <grep>
    exit(0);
 27f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 286:	e8 a9 01 00 00       	call   434 <exit>
      printf(1, "grep: cannot open %s\n", argv[i]);
 28b:	83 ec 04             	sub    $0x4,%esp
 28e:	ff 37                	push   (%edi)
 290:	68 08 07 00 00       	push   $0x708
 295:	6a 01                	push   $0x1
 297:	e8 eb 02 00 00       	call   587 <printf>
      exit(0);
 29c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2a3:	e8 8c 01 00 00       	call   434 <exit>
  exit(0);
 2a8:	83 ec 0c             	sub    $0xc,%esp
 2ab:	6a 00                	push   $0x0
 2ad:	e8 82 01 00 00       	call   434 <exit>

000002b2 <start>:

// Entry point of the library	
void
start()
{
}
 2b2:	c3                   	ret

000002b3 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 2b3:	55                   	push   %ebp
 2b4:	89 e5                	mov    %esp,%ebp
 2b6:	56                   	push   %esi
 2b7:	53                   	push   %ebx
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2be:	89 c2                	mov    %eax,%edx
 2c0:	89 cb                	mov    %ecx,%ebx
 2c2:	41                   	inc    %ecx
 2c3:	89 d6                	mov    %edx,%esi
 2c5:	42                   	inc    %edx
 2c6:	8a 1b                	mov    (%ebx),%bl
 2c8:	88 1e                	mov    %bl,(%esi)
 2ca:	84 db                	test   %bl,%bl
 2cc:	75 f2                	jne    2c0 <strcpy+0xd>
    ;
  return os;
}
 2ce:	5b                   	pop    %ebx
 2cf:	5e                   	pop    %esi
 2d0:	5d                   	pop    %ebp
 2d1:	c3                   	ret

000002d2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2d2:	55                   	push   %ebp
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 2db:	eb 02                	jmp    2df <strcmp+0xd>
    p++, q++;
 2dd:	41                   	inc    %ecx
 2de:	42                   	inc    %edx
  while(*p && *p == *q)
 2df:	8a 01                	mov    (%ecx),%al
 2e1:	84 c0                	test   %al,%al
 2e3:	74 04                	je     2e9 <strcmp+0x17>
 2e5:	3a 02                	cmp    (%edx),%al
 2e7:	74 f4                	je     2dd <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 2e9:	0f b6 c0             	movzbl %al,%eax
 2ec:	0f b6 12             	movzbl (%edx),%edx
 2ef:	29 d0                	sub    %edx,%eax
}
 2f1:	5d                   	pop    %ebp
 2f2:	c3                   	ret

000002f3 <strlen>:

uint
strlen(const char *s)
{
 2f3:	55                   	push   %ebp
 2f4:	89 e5                	mov    %esp,%ebp
 2f6:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2f9:	b8 00 00 00 00       	mov    $0x0,%eax
 2fe:	eb 01                	jmp    301 <strlen+0xe>
 300:	40                   	inc    %eax
 301:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 305:	75 f9                	jne    300 <strlen+0xd>
    ;
  return n;
}
 307:	5d                   	pop    %ebp
 308:	c3                   	ret

00000309 <memset>:

void*
memset(void *dst, int c, uint n)
{
 309:	55                   	push   %ebp
 30a:	89 e5                	mov    %esp,%ebp
 30c:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 30d:	8b 7d 08             	mov    0x8(%ebp),%edi
 310:	8b 4d 10             	mov    0x10(%ebp),%ecx
 313:	8b 45 0c             	mov    0xc(%ebp),%eax
 316:	fc                   	cld
 317:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	8b 7d fc             	mov    -0x4(%ebp),%edi
 31f:	c9                   	leave
 320:	c3                   	ret

00000321 <strchr>:

char*
strchr(const char *s, char c)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 32a:	eb 01                	jmp    32d <strchr+0xc>
 32c:	40                   	inc    %eax
 32d:	8a 10                	mov    (%eax),%dl
 32f:	84 d2                	test   %dl,%dl
 331:	74 06                	je     339 <strchr+0x18>
    if(*s == c)
 333:	38 ca                	cmp    %cl,%dl
 335:	75 f5                	jne    32c <strchr+0xb>
 337:	eb 05                	jmp    33e <strchr+0x1d>
      return (char*)s;
  return 0;
 339:	b8 00 00 00 00       	mov    $0x0,%eax
}
 33e:	5d                   	pop    %ebp
 33f:	c3                   	ret

00000340 <gets>:

char*
gets(char *buf, int max)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	56                   	push   %esi
 345:	53                   	push   %ebx
 346:	83 ec 1c             	sub    $0x1c,%esp
 349:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34c:	bb 00 00 00 00       	mov    $0x0,%ebx
 351:	89 de                	mov    %ebx,%esi
 353:	43                   	inc    %ebx
 354:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 357:	7d 2b                	jge    384 <gets+0x44>
    cc = read(0, &c, 1);
 359:	83 ec 04             	sub    $0x4,%esp
 35c:	6a 01                	push   $0x1
 35e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 361:	50                   	push   %eax
 362:	6a 00                	push   $0x0
 364:	e8 e3 00 00 00       	call   44c <read>
    if(cc < 1)
 369:	83 c4 10             	add    $0x10,%esp
 36c:	85 c0                	test   %eax,%eax
 36e:	7e 14                	jle    384 <gets+0x44>
      break;
    buf[i++] = c;
 370:	8a 45 e7             	mov    -0x19(%ebp),%al
 373:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 376:	3c 0a                	cmp    $0xa,%al
 378:	74 08                	je     382 <gets+0x42>
 37a:	3c 0d                	cmp    $0xd,%al
 37c:	75 d3                	jne    351 <gets+0x11>
    buf[i++] = c;
 37e:	89 de                	mov    %ebx,%esi
 380:	eb 02                	jmp    384 <gets+0x44>
 382:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 384:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 388:	89 f8                	mov    %edi,%eax
 38a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 38d:	5b                   	pop    %ebx
 38e:	5e                   	pop    %esi
 38f:	5f                   	pop    %edi
 390:	5d                   	pop    %ebp
 391:	c3                   	ret

00000392 <stat>:

int
stat(const char *n, struct stat *st)
{
 392:	55                   	push   %ebp
 393:	89 e5                	mov    %esp,%ebp
 395:	56                   	push   %esi
 396:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 397:	83 ec 08             	sub    $0x8,%esp
 39a:	6a 00                	push   $0x0
 39c:	ff 75 08             	push   0x8(%ebp)
 39f:	e8 d0 00 00 00       	call   474 <open>
  if(fd < 0)
 3a4:	83 c4 10             	add    $0x10,%esp
 3a7:	85 c0                	test   %eax,%eax
 3a9:	78 24                	js     3cf <stat+0x3d>
 3ab:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 3ad:	83 ec 08             	sub    $0x8,%esp
 3b0:	ff 75 0c             	push   0xc(%ebp)
 3b3:	50                   	push   %eax
 3b4:	e8 d3 00 00 00       	call   48c <fstat>
 3b9:	89 c6                	mov    %eax,%esi
  close(fd);
 3bb:	89 1c 24             	mov    %ebx,(%esp)
 3be:	e8 99 00 00 00       	call   45c <close>
  return r;
 3c3:	83 c4 10             	add    $0x10,%esp
}
 3c6:	89 f0                	mov    %esi,%eax
 3c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3cb:	5b                   	pop    %ebx
 3cc:	5e                   	pop    %esi
 3cd:	5d                   	pop    %ebp
 3ce:	c3                   	ret
    return -1;
 3cf:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3d4:	eb f0                	jmp    3c6 <stat+0x34>

000003d6 <atoi>:

int
atoi(const char *s)
{
 3d6:	55                   	push   %ebp
 3d7:	89 e5                	mov    %esp,%ebp
 3d9:	53                   	push   %ebx
 3da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 3dd:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 3e2:	eb 0e                	jmp    3f2 <atoi+0x1c>
    n = n*10 + *s++ - '0';
 3e4:	8d 14 92             	lea    (%edx,%edx,4),%edx
 3e7:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 3ea:	41                   	inc    %ecx
 3eb:	0f be c0             	movsbl %al,%eax
 3ee:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 3f2:	8a 01                	mov    (%ecx),%al
 3f4:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3f7:	80 fb 09             	cmp    $0x9,%bl
 3fa:	76 e8                	jbe    3e4 <atoi+0xe>
  return n;
}
 3fc:	89 d0                	mov    %edx,%eax
 3fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 401:	c9                   	leave
 402:	c3                   	ret

00000403 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 403:	55                   	push   %ebp
 404:	89 e5                	mov    %esp,%ebp
 406:	56                   	push   %esi
 407:	53                   	push   %ebx
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 40e:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 411:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 413:	eb 0c                	jmp    421 <memmove+0x1e>
    *dst++ = *src++;
 415:	8a 13                	mov    (%ebx),%dl
 417:	88 11                	mov    %dl,(%ecx)
 419:	8d 5b 01             	lea    0x1(%ebx),%ebx
 41c:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 41f:	89 f2                	mov    %esi,%edx
 421:	8d 72 ff             	lea    -0x1(%edx),%esi
 424:	85 d2                	test   %edx,%edx
 426:	7f ed                	jg     415 <memmove+0x12>
  return vdst;
}
 428:	5b                   	pop    %ebx
 429:	5e                   	pop    %esi
 42a:	5d                   	pop    %ebp
 42b:	c3                   	ret

0000042c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42c:	b8 01 00 00 00       	mov    $0x1,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret

00000434 <exit>:
SYSCALL(exit)
 434:	b8 02 00 00 00       	mov    $0x2,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret

0000043c <wait>:
SYSCALL(wait)
 43c:	b8 03 00 00 00       	mov    $0x3,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret

00000444 <pipe>:
SYSCALL(pipe)
 444:	b8 04 00 00 00       	mov    $0x4,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret

0000044c <read>:
SYSCALL(read)
 44c:	b8 05 00 00 00       	mov    $0x5,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret

00000454 <write>:
SYSCALL(write)
 454:	b8 10 00 00 00       	mov    $0x10,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret

0000045c <close>:
SYSCALL(close)
 45c:	b8 15 00 00 00       	mov    $0x15,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret

00000464 <kill>:
SYSCALL(kill)
 464:	b8 06 00 00 00       	mov    $0x6,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret

0000046c <exec>:
SYSCALL(exec)
 46c:	b8 07 00 00 00       	mov    $0x7,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret

00000474 <open>:
SYSCALL(open)
 474:	b8 0f 00 00 00       	mov    $0xf,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret

0000047c <mknod>:
SYSCALL(mknod)
 47c:	b8 11 00 00 00       	mov    $0x11,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret

00000484 <unlink>:
SYSCALL(unlink)
 484:	b8 12 00 00 00       	mov    $0x12,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret

0000048c <fstat>:
SYSCALL(fstat)
 48c:	b8 08 00 00 00       	mov    $0x8,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret

00000494 <link>:
SYSCALL(link)
 494:	b8 13 00 00 00       	mov    $0x13,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret

0000049c <mkdir>:
SYSCALL(mkdir)
 49c:	b8 14 00 00 00       	mov    $0x14,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret

000004a4 <chdir>:
SYSCALL(chdir)
 4a4:	b8 09 00 00 00       	mov    $0x9,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret

000004ac <dup>:
SYSCALL(dup)
 4ac:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret

000004b4 <getpid>:
SYSCALL(getpid)
 4b4:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret

000004bc <sbrk>:
SYSCALL(sbrk)
 4bc:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret

000004c4 <sleep>:
SYSCALL(sleep)
 4c4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret

000004cc <uptime>:
SYSCALL(uptime)
 4cc:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret

000004d4 <date>:
SYSCALL(date)
 4d4:	b8 16 00 00 00       	mov    $0x16,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret

000004dc <dup2>:
SYSCALL(dup2)
 4dc:	b8 17 00 00 00       	mov    $0x17,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret

000004e4 <getprio>:
SYSCALL(getprio)
 4e4:	b8 18 00 00 00       	mov    $0x18,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret

000004ec <setprio>:
 4ec:	b8 19 00 00 00       	mov    $0x19,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret

000004f4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4f4:	55                   	push   %ebp
 4f5:	89 e5                	mov    %esp,%ebp
 4f7:	83 ec 1c             	sub    $0x1c,%esp
 4fa:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 4fd:	6a 01                	push   $0x1
 4ff:	8d 55 f4             	lea    -0xc(%ebp),%edx
 502:	52                   	push   %edx
 503:	50                   	push   %eax
 504:	e8 4b ff ff ff       	call   454 <write>
}
 509:	83 c4 10             	add    $0x10,%esp
 50c:	c9                   	leave
 50d:	c3                   	ret

0000050e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 50e:	55                   	push   %ebp
 50f:	89 e5                	mov    %esp,%ebp
 511:	57                   	push   %edi
 512:	56                   	push   %esi
 513:	53                   	push   %ebx
 514:	83 ec 2c             	sub    $0x2c,%esp
 517:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 51a:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 51c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 520:	74 04                	je     526 <printint+0x18>
 522:	85 d2                	test   %edx,%edx
 524:	78 3c                	js     562 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 526:	89 d1                	mov    %edx,%ecx
  neg = 0;
 528:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 52f:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 534:	89 c8                	mov    %ecx,%eax
 536:	ba 00 00 00 00       	mov    $0x0,%edx
 53b:	f7 f6                	div    %esi
 53d:	89 df                	mov    %ebx,%edi
 53f:	43                   	inc    %ebx
 540:	8a 92 80 07 00 00    	mov    0x780(%edx),%dl
 546:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 54a:	89 ca                	mov    %ecx,%edx
 54c:	89 c1                	mov    %eax,%ecx
 54e:	39 f2                	cmp    %esi,%edx
 550:	73 e2                	jae    534 <printint+0x26>
  if(neg)
 552:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 556:	74 24                	je     57c <printint+0x6e>
    buf[i++] = '-';
 558:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 55d:	8d 5f 02             	lea    0x2(%edi),%ebx
 560:	eb 1a                	jmp    57c <printint+0x6e>
    x = -xx;
 562:	89 d1                	mov    %edx,%ecx
 564:	f7 d9                	neg    %ecx
    neg = 1;
 566:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 56d:	eb c0                	jmp    52f <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 56f:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 574:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 577:	e8 78 ff ff ff       	call   4f4 <putc>
  while(--i >= 0)
 57c:	4b                   	dec    %ebx
 57d:	79 f0                	jns    56f <printint+0x61>
}
 57f:	83 c4 2c             	add    $0x2c,%esp
 582:	5b                   	pop    %ebx
 583:	5e                   	pop    %esi
 584:	5f                   	pop    %edi
 585:	5d                   	pop    %ebp
 586:	c3                   	ret

00000587 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 587:	55                   	push   %ebp
 588:	89 e5                	mov    %esp,%ebp
 58a:	57                   	push   %edi
 58b:	56                   	push   %esi
 58c:	53                   	push   %ebx
 58d:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 590:	8d 45 10             	lea    0x10(%ebp),%eax
 593:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 596:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 59b:	bb 00 00 00 00       	mov    $0x0,%ebx
 5a0:	eb 12                	jmp    5b4 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5a2:	89 fa                	mov    %edi,%edx
 5a4:	8b 45 08             	mov    0x8(%ebp),%eax
 5a7:	e8 48 ff ff ff       	call   4f4 <putc>
 5ac:	eb 05                	jmp    5b3 <printf+0x2c>
      }
    } else if(state == '%'){
 5ae:	83 fe 25             	cmp    $0x25,%esi
 5b1:	74 22                	je     5d5 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 5b3:	43                   	inc    %ebx
 5b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b7:	8a 04 18             	mov    (%eax,%ebx,1),%al
 5ba:	84 c0                	test   %al,%al
 5bc:	0f 84 1d 01 00 00    	je     6df <printf+0x158>
    c = fmt[i] & 0xff;
 5c2:	0f be f8             	movsbl %al,%edi
 5c5:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 5c8:	85 f6                	test   %esi,%esi
 5ca:	75 e2                	jne    5ae <printf+0x27>
      if(c == '%'){
 5cc:	83 f8 25             	cmp    $0x25,%eax
 5cf:	75 d1                	jne    5a2 <printf+0x1b>
        state = '%';
 5d1:	89 c6                	mov    %eax,%esi
 5d3:	eb de                	jmp    5b3 <printf+0x2c>
      if(c == 'd'){
 5d5:	83 f8 25             	cmp    $0x25,%eax
 5d8:	0f 84 cc 00 00 00    	je     6aa <printf+0x123>
 5de:	0f 8c da 00 00 00    	jl     6be <printf+0x137>
 5e4:	83 f8 78             	cmp    $0x78,%eax
 5e7:	0f 8f d1 00 00 00    	jg     6be <printf+0x137>
 5ed:	83 f8 63             	cmp    $0x63,%eax
 5f0:	0f 8c c8 00 00 00    	jl     6be <printf+0x137>
 5f6:	83 e8 63             	sub    $0x63,%eax
 5f9:	83 f8 15             	cmp    $0x15,%eax
 5fc:	0f 87 bc 00 00 00    	ja     6be <printf+0x137>
 602:	ff 24 85 28 07 00 00 	jmp    *0x728(,%eax,4)
        printint(fd, *ap, 10, 1);
 609:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 60c:	8b 17                	mov    (%edi),%edx
 60e:	83 ec 0c             	sub    $0xc,%esp
 611:	6a 01                	push   $0x1
 613:	b9 0a 00 00 00       	mov    $0xa,%ecx
 618:	8b 45 08             	mov    0x8(%ebp),%eax
 61b:	e8 ee fe ff ff       	call   50e <printint>
        ap++;
 620:	83 c7 04             	add    $0x4,%edi
 623:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 626:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 629:	be 00 00 00 00       	mov    $0x0,%esi
 62e:	eb 83                	jmp    5b3 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 630:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 633:	8b 17                	mov    (%edi),%edx
 635:	83 ec 0c             	sub    $0xc,%esp
 638:	6a 00                	push   $0x0
 63a:	b9 10 00 00 00       	mov    $0x10,%ecx
 63f:	8b 45 08             	mov    0x8(%ebp),%eax
 642:	e8 c7 fe ff ff       	call   50e <printint>
        ap++;
 647:	83 c7 04             	add    $0x4,%edi
 64a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 64d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 650:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 655:	e9 59 ff ff ff       	jmp    5b3 <printf+0x2c>
        s = (char*)*ap;
 65a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65d:	8b 30                	mov    (%eax),%esi
        ap++;
 65f:	83 c0 04             	add    $0x4,%eax
 662:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 665:	85 f6                	test   %esi,%esi
 667:	75 13                	jne    67c <printf+0xf5>
          s = "(null)";
 669:	be 1e 07 00 00       	mov    $0x71e,%esi
 66e:	eb 0c                	jmp    67c <printf+0xf5>
          putc(fd, *s);
 670:	0f be d2             	movsbl %dl,%edx
 673:	8b 45 08             	mov    0x8(%ebp),%eax
 676:	e8 79 fe ff ff       	call   4f4 <putc>
          s++;
 67b:	46                   	inc    %esi
        while(*s != 0){
 67c:	8a 16                	mov    (%esi),%dl
 67e:	84 d2                	test   %dl,%dl
 680:	75 ee                	jne    670 <printf+0xe9>
      state = 0;
 682:	be 00 00 00 00       	mov    $0x0,%esi
 687:	e9 27 ff ff ff       	jmp    5b3 <printf+0x2c>
        putc(fd, *ap);
 68c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 68f:	0f be 17             	movsbl (%edi),%edx
 692:	8b 45 08             	mov    0x8(%ebp),%eax
 695:	e8 5a fe ff ff       	call   4f4 <putc>
        ap++;
 69a:	83 c7 04             	add    $0x4,%edi
 69d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 6a0:	be 00 00 00 00       	mov    $0x0,%esi
 6a5:	e9 09 ff ff ff       	jmp    5b3 <printf+0x2c>
        putc(fd, c);
 6aa:	89 fa                	mov    %edi,%edx
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
 6af:	e8 40 fe ff ff       	call   4f4 <putc>
      state = 0;
 6b4:	be 00 00 00 00       	mov    $0x0,%esi
 6b9:	e9 f5 fe ff ff       	jmp    5b3 <printf+0x2c>
        putc(fd, '%');
 6be:	ba 25 00 00 00       	mov    $0x25,%edx
 6c3:	8b 45 08             	mov    0x8(%ebp),%eax
 6c6:	e8 29 fe ff ff       	call   4f4 <putc>
        putc(fd, c);
 6cb:	89 fa                	mov    %edi,%edx
 6cd:	8b 45 08             	mov    0x8(%ebp),%eax
 6d0:	e8 1f fe ff ff       	call   4f4 <putc>
      state = 0;
 6d5:	be 00 00 00 00       	mov    $0x0,%esi
 6da:	e9 d4 fe ff ff       	jmp    5b3 <printf+0x2c>
    }
  }
}
 6df:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6e2:	5b                   	pop    %ebx
 6e3:	5e                   	pop    %esi
 6e4:	5f                   	pop    %edi
 6e5:	5d                   	pop    %ebp
 6e6:	c3                   	ret
