
usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
       6:	68 c4 40 00 00       	push   $0x40c4
       b:	ff 35 d8 60 00 00    	push   0x60d8
      11:	e8 72 3d 00 00       	call   3d88 <printf>

  if(mkdir("iputdir") < 0){
      16:	c7 04 24 57 40 00 00 	movl   $0x4057,(%esp)
      1d:	e8 7b 3c 00 00       	call   3c9d <mkdir>
      22:	83 c4 10             	add    $0x10,%esp
      25:	85 c0                	test   %eax,%eax
      27:	78 54                	js     7d <iputtest+0x7d>
    printf(stdout, "mkdir failed\n");
    exit(0);
  }
  if(chdir("iputdir") < 0){
      29:	83 ec 0c             	sub    $0xc,%esp
      2c:	68 57 40 00 00       	push   $0x4057
      31:	e8 6f 3c 00 00       	call   3ca5 <chdir>
      36:	83 c4 10             	add    $0x10,%esp
      39:	85 c0                	test   %eax,%eax
      3b:	78 5f                	js     9c <iputtest+0x9c>
    printf(stdout, "chdir iputdir failed\n");
    exit(0);
  }
  if(unlink("../iputdir") < 0){
      3d:	83 ec 0c             	sub    $0xc,%esp
      40:	68 54 40 00 00       	push   $0x4054
      45:	e8 3b 3c 00 00       	call   3c85 <unlink>
      4a:	83 c4 10             	add    $0x10,%esp
      4d:	85 c0                	test   %eax,%eax
      4f:	78 6a                	js     bb <iputtest+0xbb>
    printf(stdout, "unlink ../iputdir failed\n");
    exit(0);
  }
  if(chdir("/") < 0){
      51:	83 ec 0c             	sub    $0xc,%esp
      54:	68 79 40 00 00       	push   $0x4079
      59:	e8 47 3c 00 00       	call   3ca5 <chdir>
      5e:	83 c4 10             	add    $0x10,%esp
      61:	85 c0                	test   %eax,%eax
      63:	78 75                	js     da <iputtest+0xda>
    printf(stdout, "chdir / failed\n");
    exit(0);
  }
  printf(stdout, "iput test ok\n");
      65:	83 ec 08             	sub    $0x8,%esp
      68:	68 fc 40 00 00       	push   $0x40fc
      6d:	ff 35 d8 60 00 00    	push   0x60d8
      73:	e8 10 3d 00 00       	call   3d88 <printf>
}
      78:	83 c4 10             	add    $0x10,%esp
      7b:	c9                   	leave
      7c:	c3                   	ret
    printf(stdout, "mkdir failed\n");
      7d:	83 ec 08             	sub    $0x8,%esp
      80:	68 30 40 00 00       	push   $0x4030
      85:	ff 35 d8 60 00 00    	push   0x60d8
      8b:	e8 f8 3c 00 00       	call   3d88 <printf>
    exit(0);
      90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      97:	e8 99 3b 00 00       	call   3c35 <exit>
    printf(stdout, "chdir iputdir failed\n");
      9c:	83 ec 08             	sub    $0x8,%esp
      9f:	68 3e 40 00 00       	push   $0x403e
      a4:	ff 35 d8 60 00 00    	push   0x60d8
      aa:	e8 d9 3c 00 00       	call   3d88 <printf>
    exit(0);
      af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      b6:	e8 7a 3b 00 00       	call   3c35 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
      bb:	83 ec 08             	sub    $0x8,%esp
      be:	68 5f 40 00 00       	push   $0x405f
      c3:	ff 35 d8 60 00 00    	push   0x60d8
      c9:	e8 ba 3c 00 00       	call   3d88 <printf>
    exit(0);
      ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      d5:	e8 5b 3b 00 00       	call   3c35 <exit>
    printf(stdout, "chdir / failed\n");
      da:	83 ec 08             	sub    $0x8,%esp
      dd:	68 7b 40 00 00       	push   $0x407b
      e2:	ff 35 d8 60 00 00    	push   0x60d8
      e8:	e8 9b 3c 00 00       	call   3d88 <printf>
    exit(0);
      ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      f4:	e8 3c 3b 00 00       	call   3c35 <exit>

000000f9 <exitiputtest>:

// does exit(0) call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      f9:	55                   	push   %ebp
      fa:	89 e5                	mov    %esp,%ebp
      fc:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      ff:	68 8b 40 00 00       	push   $0x408b
     104:	ff 35 d8 60 00 00    	push   0x60d8
     10a:	e8 79 3c 00 00       	call   3d88 <printf>

  pid = fork();
     10f:	e8 19 3b 00 00       	call   3c2d <fork>
  if(pid < 0){
     114:	83 c4 10             	add    $0x10,%esp
     117:	85 c0                	test   %eax,%eax
     119:	78 4c                	js     167 <exitiputtest+0x6e>
    printf(stdout, "fork failed\n");
    exit(0);
  }
  if(pid == 0){
     11b:	0f 85 c2 00 00 00    	jne    1e3 <exitiputtest+0xea>
    if(mkdir("iputdir") < 0){
     121:	83 ec 0c             	sub    $0xc,%esp
     124:	68 57 40 00 00       	push   $0x4057
     129:	e8 6f 3b 00 00       	call   3c9d <mkdir>
     12e:	83 c4 10             	add    $0x10,%esp
     131:	85 c0                	test   %eax,%eax
     133:	78 51                	js     186 <exitiputtest+0x8d>
      printf(stdout, "mkdir failed\n");
      exit(0);
    }
    if(chdir("iputdir") < 0){
     135:	83 ec 0c             	sub    $0xc,%esp
     138:	68 57 40 00 00       	push   $0x4057
     13d:	e8 63 3b 00 00       	call   3ca5 <chdir>
     142:	83 c4 10             	add    $0x10,%esp
     145:	85 c0                	test   %eax,%eax
     147:	78 5c                	js     1a5 <exitiputtest+0xac>
      printf(stdout, "child chdir failed\n");
      exit(0);
    }
    if(unlink("../iputdir") < 0){
     149:	83 ec 0c             	sub    $0xc,%esp
     14c:	68 54 40 00 00       	push   $0x4054
     151:	e8 2f 3b 00 00       	call   3c85 <unlink>
     156:	83 c4 10             	add    $0x10,%esp
     159:	85 c0                	test   %eax,%eax
     15b:	78 67                	js     1c4 <exitiputtest+0xcb>
      printf(stdout, "unlink ../iputdir failed\n");
      exit(0);
    }
    exit(0);
     15d:	83 ec 0c             	sub    $0xc,%esp
     160:	6a 00                	push   $0x0
     162:	e8 ce 3a 00 00       	call   3c35 <exit>
    printf(stdout, "fork failed\n");
     167:	83 ec 08             	sub    $0x8,%esp
     16a:	68 71 4f 00 00       	push   $0x4f71
     16f:	ff 35 d8 60 00 00    	push   0x60d8
     175:	e8 0e 3c 00 00       	call   3d88 <printf>
    exit(0);
     17a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     181:	e8 af 3a 00 00       	call   3c35 <exit>
      printf(stdout, "mkdir failed\n");
     186:	83 ec 08             	sub    $0x8,%esp
     189:	68 30 40 00 00       	push   $0x4030
     18e:	ff 35 d8 60 00 00    	push   0x60d8
     194:	e8 ef 3b 00 00       	call   3d88 <printf>
      exit(0);
     199:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1a0:	e8 90 3a 00 00       	call   3c35 <exit>
      printf(stdout, "child chdir failed\n");
     1a5:	83 ec 08             	sub    $0x8,%esp
     1a8:	68 9a 40 00 00       	push   $0x409a
     1ad:	ff 35 d8 60 00 00    	push   0x60d8
     1b3:	e8 d0 3b 00 00       	call   3d88 <printf>
      exit(0);
     1b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1bf:	e8 71 3a 00 00       	call   3c35 <exit>
      printf(stdout, "unlink ../iputdir failed\n");
     1c4:	83 ec 08             	sub    $0x8,%esp
     1c7:	68 5f 40 00 00       	push   $0x405f
     1cc:	ff 35 d8 60 00 00    	push   0x60d8
     1d2:	e8 b1 3b 00 00       	call   3d88 <printf>
      exit(0);
     1d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1de:	e8 52 3a 00 00       	call   3c35 <exit>
  }
  wait(NULL);
     1e3:	83 ec 0c             	sub    $0xc,%esp
     1e6:	6a 00                	push   $0x0
     1e8:	e8 50 3a 00 00       	call   3c3d <wait>
  printf(stdout, "exitiput test ok\n");
     1ed:	83 c4 08             	add    $0x8,%esp
     1f0:	68 ae 40 00 00       	push   $0x40ae
     1f5:	ff 35 d8 60 00 00    	push   0x60d8
     1fb:	e8 88 3b 00 00       	call   3d88 <printf>
}
     200:	83 c4 10             	add    $0x10,%esp
     203:	c9                   	leave
     204:	c3                   	ret

00000205 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     205:	55                   	push   %ebp
     206:	89 e5                	mov    %esp,%ebp
     208:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "openiput test\n");
     20b:	68 c0 40 00 00       	push   $0x40c0
     210:	ff 35 d8 60 00 00    	push   0x60d8
     216:	e8 6d 3b 00 00       	call   3d88 <printf>
  if(mkdir("oidir") < 0){
     21b:	c7 04 24 cf 40 00 00 	movl   $0x40cf,(%esp)
     222:	e8 76 3a 00 00       	call   3c9d <mkdir>
     227:	83 c4 10             	add    $0x10,%esp
     22a:	85 c0                	test   %eax,%eax
     22c:	78 40                	js     26e <openiputtest+0x69>
    printf(stdout, "mkdir oidir failed\n");
    exit(0);
  }
  pid = fork();
     22e:	e8 fa 39 00 00       	call   3c2d <fork>
  if(pid < 0){
     233:	85 c0                	test   %eax,%eax
     235:	78 56                	js     28d <openiputtest+0x88>
    printf(stdout, "fork failed\n");
    exit(0);
  }
  if(pid == 0){
     237:	75 7d                	jne    2b6 <openiputtest+0xb1>
    int fd = open("oidir", O_RDWR);
     239:	83 ec 08             	sub    $0x8,%esp
     23c:	6a 02                	push   $0x2
     23e:	68 cf 40 00 00       	push   $0x40cf
     243:	e8 2d 3a 00 00       	call   3c75 <open>
    if(fd >= 0){
     248:	83 c4 10             	add    $0x10,%esp
     24b:	85 c0                	test   %eax,%eax
     24d:	78 5d                	js     2ac <openiputtest+0xa7>
      printf(stdout, "open directory for write succeeded\n");
     24f:	83 ec 08             	sub    $0x8,%esp
     252:	68 58 50 00 00       	push   $0x5058
     257:	ff 35 d8 60 00 00    	push   0x60d8
     25d:	e8 26 3b 00 00       	call   3d88 <printf>
      exit(0);
     262:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     269:	e8 c7 39 00 00       	call   3c35 <exit>
    printf(stdout, "mkdir oidir failed\n");
     26e:	83 ec 08             	sub    $0x8,%esp
     271:	68 d5 40 00 00       	push   $0x40d5
     276:	ff 35 d8 60 00 00    	push   0x60d8
     27c:	e8 07 3b 00 00       	call   3d88 <printf>
    exit(0);
     281:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     288:	e8 a8 39 00 00       	call   3c35 <exit>
    printf(stdout, "fork failed\n");
     28d:	83 ec 08             	sub    $0x8,%esp
     290:	68 71 4f 00 00       	push   $0x4f71
     295:	ff 35 d8 60 00 00    	push   0x60d8
     29b:	e8 e8 3a 00 00       	call   3d88 <printf>
    exit(0);
     2a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     2a7:	e8 89 39 00 00       	call   3c35 <exit>
    }
    exit(0);
     2ac:	83 ec 0c             	sub    $0xc,%esp
     2af:	6a 00                	push   $0x0
     2b1:	e8 7f 39 00 00       	call   3c35 <exit>
  }
  sleep(1);
     2b6:	83 ec 0c             	sub    $0xc,%esp
     2b9:	6a 01                	push   $0x1
     2bb:	e8 05 3a 00 00       	call   3cc5 <sleep>
  if(unlink("oidir") != 0){
     2c0:	c7 04 24 cf 40 00 00 	movl   $0x40cf,(%esp)
     2c7:	e8 b9 39 00 00       	call   3c85 <unlink>
     2cc:	83 c4 10             	add    $0x10,%esp
     2cf:	85 c0                	test   %eax,%eax
     2d1:	75 22                	jne    2f5 <openiputtest+0xf0>
    printf(stdout, "unlink failed\n");
    exit(0);
  }
  wait(NULL);
     2d3:	83 ec 0c             	sub    $0xc,%esp
     2d6:	6a 00                	push   $0x0
     2d8:	e8 60 39 00 00       	call   3c3d <wait>
  printf(stdout, "openiput test ok\n");
     2dd:	83 c4 08             	add    $0x8,%esp
     2e0:	68 f8 40 00 00       	push   $0x40f8
     2e5:	ff 35 d8 60 00 00    	push   0x60d8
     2eb:	e8 98 3a 00 00       	call   3d88 <printf>
}
     2f0:	83 c4 10             	add    $0x10,%esp
     2f3:	c9                   	leave
     2f4:	c3                   	ret
    printf(stdout, "unlink failed\n");
     2f5:	83 ec 08             	sub    $0x8,%esp
     2f8:	68 e9 40 00 00       	push   $0x40e9
     2fd:	ff 35 d8 60 00 00    	push   0x60d8
     303:	e8 80 3a 00 00       	call   3d88 <printf>
    exit(0);
     308:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     30f:	e8 21 39 00 00       	call   3c35 <exit>

00000314 <opentest>:

// simple file system tests

void
opentest(void)
{
     314:	55                   	push   %ebp
     315:	89 e5                	mov    %esp,%ebp
     317:	83 ec 10             	sub    $0x10,%esp
  int fd;

  printf(stdout, "open test\n");
     31a:	68 0a 41 00 00       	push   $0x410a
     31f:	ff 35 d8 60 00 00    	push   0x60d8
     325:	e8 5e 3a 00 00       	call   3d88 <printf>
  fd = open("echo", 0);
     32a:	83 c4 08             	add    $0x8,%esp
     32d:	6a 00                	push   $0x0
     32f:	68 15 41 00 00       	push   $0x4115
     334:	e8 3c 39 00 00       	call   3c75 <open>
  if(fd < 0){
     339:	83 c4 10             	add    $0x10,%esp
     33c:	85 c0                	test   %eax,%eax
     33e:	78 37                	js     377 <opentest+0x63>
    printf(stdout, "open echo failed!\n");
    exit(0);
  }
  close(fd);
     340:	83 ec 0c             	sub    $0xc,%esp
     343:	50                   	push   %eax
     344:	e8 14 39 00 00       	call   3c5d <close>
  fd = open("doesnotexist", 0);
     349:	83 c4 08             	add    $0x8,%esp
     34c:	6a 00                	push   $0x0
     34e:	68 2d 41 00 00       	push   $0x412d
     353:	e8 1d 39 00 00       	call   3c75 <open>
  if(fd >= 0){
     358:	83 c4 10             	add    $0x10,%esp
     35b:	85 c0                	test   %eax,%eax
     35d:	79 37                	jns    396 <opentest+0x82>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit(0);
  }
  printf(stdout, "open test ok\n");
     35f:	83 ec 08             	sub    $0x8,%esp
     362:	68 58 41 00 00       	push   $0x4158
     367:	ff 35 d8 60 00 00    	push   0x60d8
     36d:	e8 16 3a 00 00       	call   3d88 <printf>
}
     372:	83 c4 10             	add    $0x10,%esp
     375:	c9                   	leave
     376:	c3                   	ret
    printf(stdout, "open echo failed!\n");
     377:	83 ec 08             	sub    $0x8,%esp
     37a:	68 1a 41 00 00       	push   $0x411a
     37f:	ff 35 d8 60 00 00    	push   0x60d8
     385:	e8 fe 39 00 00       	call   3d88 <printf>
    exit(0);
     38a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     391:	e8 9f 38 00 00       	call   3c35 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     396:	83 ec 08             	sub    $0x8,%esp
     399:	68 3a 41 00 00       	push   $0x413a
     39e:	ff 35 d8 60 00 00    	push   0x60d8
     3a4:	e8 df 39 00 00       	call   3d88 <printf>
    exit(0);
     3a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     3b0:	e8 80 38 00 00       	call   3c35 <exit>

000003b5 <writetest>:

void
writetest(void)
{
     3b5:	55                   	push   %ebp
     3b6:	89 e5                	mov    %esp,%ebp
     3b8:	56                   	push   %esi
     3b9:	53                   	push   %ebx
  int fd;
  int i;

  printf(stdout, "small file test\n");
     3ba:	83 ec 08             	sub    $0x8,%esp
     3bd:	68 66 41 00 00       	push   $0x4166
     3c2:	ff 35 d8 60 00 00    	push   0x60d8
     3c8:	e8 bb 39 00 00       	call   3d88 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     3cd:	83 c4 08             	add    $0x8,%esp
     3d0:	68 02 02 00 00       	push   $0x202
     3d5:	68 77 41 00 00       	push   $0x4177
     3da:	e8 96 38 00 00       	call   3c75 <open>
  if(fd >= 0){
     3df:	83 c4 10             	add    $0x10,%esp
     3e2:	85 c0                	test   %eax,%eax
     3e4:	78 59                	js     43f <writetest+0x8a>
     3e6:	89 c6                	mov    %eax,%esi
    printf(stdout, "creat small succeeded; ok\n");
     3e8:	83 ec 08             	sub    $0x8,%esp
     3eb:	68 7d 41 00 00       	push   $0x417d
     3f0:	ff 35 d8 60 00 00    	push   0x60d8
     3f6:	e8 8d 39 00 00       	call   3d88 <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit(0);
  }
  for(i = 0; i < 100; i++){
     3fb:	83 c4 10             	add    $0x10,%esp
     3fe:	bb 00 00 00 00       	mov    $0x0,%ebx
     403:	83 fb 63             	cmp    $0x63,%ebx
     406:	0f 8f 92 00 00 00    	jg     49e <writetest+0xe9>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     40c:	83 ec 04             	sub    $0x4,%esp
     40f:	6a 0a                	push   $0xa
     411:	68 b4 41 00 00       	push   $0x41b4
     416:	56                   	push   %esi
     417:	e8 39 38 00 00       	call   3c55 <write>
     41c:	83 c4 10             	add    $0x10,%esp
     41f:	83 f8 0a             	cmp    $0xa,%eax
     422:	75 3a                	jne    45e <writetest+0xa9>
      printf(stdout, "error: write aa %d new file failed\n", i);
      exit(0);
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     424:	83 ec 04             	sub    $0x4,%esp
     427:	6a 0a                	push   $0xa
     429:	68 bf 41 00 00       	push   $0x41bf
     42e:	56                   	push   %esi
     42f:	e8 21 38 00 00       	call   3c55 <write>
     434:	83 c4 10             	add    $0x10,%esp
     437:	83 f8 0a             	cmp    $0xa,%eax
     43a:	75 42                	jne    47e <writetest+0xc9>
  for(i = 0; i < 100; i++){
     43c:	43                   	inc    %ebx
     43d:	eb c4                	jmp    403 <writetest+0x4e>
    printf(stdout, "error: creat small failed!\n");
     43f:	83 ec 08             	sub    $0x8,%esp
     442:	68 98 41 00 00       	push   $0x4198
     447:	ff 35 d8 60 00 00    	push   0x60d8
     44d:	e8 36 39 00 00       	call   3d88 <printf>
    exit(0);
     452:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     459:	e8 d7 37 00 00       	call   3c35 <exit>
      printf(stdout, "error: write aa %d new file failed\n", i);
     45e:	83 ec 04             	sub    $0x4,%esp
     461:	53                   	push   %ebx
     462:	68 7c 50 00 00       	push   $0x507c
     467:	ff 35 d8 60 00 00    	push   0x60d8
     46d:	e8 16 39 00 00       	call   3d88 <printf>
      exit(0);
     472:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     479:	e8 b7 37 00 00       	call   3c35 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     47e:	83 ec 04             	sub    $0x4,%esp
     481:	53                   	push   %ebx
     482:	68 a0 50 00 00       	push   $0x50a0
     487:	ff 35 d8 60 00 00    	push   0x60d8
     48d:	e8 f6 38 00 00       	call   3d88 <printf>
      exit(0);
     492:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     499:	e8 97 37 00 00       	call   3c35 <exit>
    }
  }
  printf(stdout, "writes ok\n");
     49e:	83 ec 08             	sub    $0x8,%esp
     4a1:	68 ca 41 00 00       	push   $0x41ca
     4a6:	ff 35 d8 60 00 00    	push   0x60d8
     4ac:	e8 d7 38 00 00       	call   3d88 <printf>
  close(fd);
     4b1:	89 34 24             	mov    %esi,(%esp)
     4b4:	e8 a4 37 00 00       	call   3c5d <close>
  fd = open("small", O_RDONLY);
     4b9:	83 c4 08             	add    $0x8,%esp
     4bc:	6a 00                	push   $0x0
     4be:	68 77 41 00 00       	push   $0x4177
     4c3:	e8 ad 37 00 00       	call   3c75 <open>
     4c8:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     4ca:	83 c4 10             	add    $0x10,%esp
     4cd:	85 c0                	test   %eax,%eax
     4cf:	78 7b                	js     54c <writetest+0x197>
    printf(stdout, "open small succeeded ok\n");
     4d1:	83 ec 08             	sub    $0x8,%esp
     4d4:	68 d5 41 00 00       	push   $0x41d5
     4d9:	ff 35 d8 60 00 00    	push   0x60d8
     4df:	e8 a4 38 00 00       	call   3d88 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit(0);
  }
  i = read(fd, buf, 2000);
     4e4:	83 c4 0c             	add    $0xc,%esp
     4e7:	68 d0 07 00 00       	push   $0x7d0
     4ec:	68 20 88 00 00       	push   $0x8820
     4f1:	53                   	push   %ebx
     4f2:	e8 56 37 00 00       	call   3c4d <read>
  if(i == 2000){
     4f7:	83 c4 10             	add    $0x10,%esp
     4fa:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     4ff:	75 6a                	jne    56b <writetest+0x1b6>
    printf(stdout, "read succeeded ok\n");
     501:	83 ec 08             	sub    $0x8,%esp
     504:	68 09 42 00 00       	push   $0x4209
     509:	ff 35 d8 60 00 00    	push   0x60d8
     50f:	e8 74 38 00 00       	call   3d88 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit(0);
  }
  close(fd);
     514:	89 1c 24             	mov    %ebx,(%esp)
     517:	e8 41 37 00 00       	call   3c5d <close>

  if(unlink("small") < 0){
     51c:	c7 04 24 77 41 00 00 	movl   $0x4177,(%esp)
     523:	e8 5d 37 00 00       	call   3c85 <unlink>
     528:	83 c4 10             	add    $0x10,%esp
     52b:	85 c0                	test   %eax,%eax
     52d:	78 5b                	js     58a <writetest+0x1d5>
    printf(stdout, "unlink small failed\n");
    exit(0);
  }
  printf(stdout, "small file test ok\n");
     52f:	83 ec 08             	sub    $0x8,%esp
     532:	68 31 42 00 00       	push   $0x4231
     537:	ff 35 d8 60 00 00    	push   0x60d8
     53d:	e8 46 38 00 00       	call   3d88 <printf>
}
     542:	83 c4 10             	add    $0x10,%esp
     545:	8d 65 f8             	lea    -0x8(%ebp),%esp
     548:	5b                   	pop    %ebx
     549:	5e                   	pop    %esi
     54a:	5d                   	pop    %ebp
     54b:	c3                   	ret
    printf(stdout, "error: open small failed!\n");
     54c:	83 ec 08             	sub    $0x8,%esp
     54f:	68 ee 41 00 00       	push   $0x41ee
     554:	ff 35 d8 60 00 00    	push   0x60d8
     55a:	e8 29 38 00 00       	call   3d88 <printf>
    exit(0);
     55f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     566:	e8 ca 36 00 00       	call   3c35 <exit>
    printf(stdout, "read failed\n");
     56b:	83 ec 08             	sub    $0x8,%esp
     56e:	68 35 45 00 00       	push   $0x4535
     573:	ff 35 d8 60 00 00    	push   0x60d8
     579:	e8 0a 38 00 00       	call   3d88 <printf>
    exit(0);
     57e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     585:	e8 ab 36 00 00       	call   3c35 <exit>
    printf(stdout, "unlink small failed\n");
     58a:	83 ec 08             	sub    $0x8,%esp
     58d:	68 1c 42 00 00       	push   $0x421c
     592:	ff 35 d8 60 00 00    	push   0x60d8
     598:	e8 eb 37 00 00       	call   3d88 <printf>
    exit(0);
     59d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     5a4:	e8 8c 36 00 00       	call   3c35 <exit>

000005a9 <writetest1>:

void
writetest1(void)
{
     5a9:	55                   	push   %ebp
     5aa:	89 e5                	mov    %esp,%ebp
     5ac:	56                   	push   %esi
     5ad:	53                   	push   %ebx
  int i, fd, n;

  printf(stdout, "big files test\n");
     5ae:	83 ec 08             	sub    $0x8,%esp
     5b1:	68 45 42 00 00       	push   $0x4245
     5b6:	ff 35 d8 60 00 00    	push   0x60d8
     5bc:	e8 c7 37 00 00       	call   3d88 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     5c1:	83 c4 08             	add    $0x8,%esp
     5c4:	68 02 02 00 00       	push   $0x202
     5c9:	68 bf 42 00 00       	push   $0x42bf
     5ce:	e8 a2 36 00 00       	call   3c75 <open>
  if(fd < 0){
     5d3:	83 c4 10             	add    $0x10,%esp
     5d6:	85 c0                	test   %eax,%eax
     5d8:	78 35                	js     60f <writetest1+0x66>
     5da:	89 c6                	mov    %eax,%esi
    printf(stdout, "error: creat big failed!\n");
    exit(0);
  }

  for(i = 0; i < MAXFILE; i++){
     5dc:	bb 00 00 00 00       	mov    $0x0,%ebx
     5e1:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     5e7:	77 65                	ja     64e <writetest1+0xa5>
    ((int*)buf)[0] = i;
     5e9:	89 1d 20 88 00 00    	mov    %ebx,0x8820
    if(write(fd, buf, 512) != 512){
     5ef:	83 ec 04             	sub    $0x4,%esp
     5f2:	68 00 02 00 00       	push   $0x200
     5f7:	68 20 88 00 00       	push   $0x8820
     5fc:	56                   	push   %esi
     5fd:	e8 53 36 00 00       	call   3c55 <write>
     602:	83 c4 10             	add    $0x10,%esp
     605:	3d 00 02 00 00       	cmp    $0x200,%eax
     60a:	75 22                	jne    62e <writetest1+0x85>
  for(i = 0; i < MAXFILE; i++){
     60c:	43                   	inc    %ebx
     60d:	eb d2                	jmp    5e1 <writetest1+0x38>
    printf(stdout, "error: creat big failed!\n");
     60f:	83 ec 08             	sub    $0x8,%esp
     612:	68 55 42 00 00       	push   $0x4255
     617:	ff 35 d8 60 00 00    	push   0x60d8
     61d:	e8 66 37 00 00       	call   3d88 <printf>
    exit(0);
     622:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     629:	e8 07 36 00 00       	call   3c35 <exit>
      printf(stdout, "error: write big file failed\n", i);
     62e:	83 ec 04             	sub    $0x4,%esp
     631:	53                   	push   %ebx
     632:	68 6f 42 00 00       	push   $0x426f
     637:	ff 35 d8 60 00 00    	push   0x60d8
     63d:	e8 46 37 00 00       	call   3d88 <printf>
      exit(0);
     642:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     649:	e8 e7 35 00 00       	call   3c35 <exit>
    }
  }

  close(fd);
     64e:	83 ec 0c             	sub    $0xc,%esp
     651:	56                   	push   %esi
     652:	e8 06 36 00 00       	call   3c5d <close>

  fd = open("big", O_RDONLY);
     657:	83 c4 08             	add    $0x8,%esp
     65a:	6a 00                	push   $0x0
     65c:	68 bf 42 00 00       	push   $0x42bf
     661:	e8 0f 36 00 00       	call   3c75 <open>
     666:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     668:	83 c4 10             	add    $0x10,%esp
     66b:	85 c0                	test   %eax,%eax
     66d:	78 3a                	js     6a9 <writetest1+0x100>
    printf(stdout, "error: open big failed!\n");
    exit(0);
  }

  n = 0;
     66f:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(;;){
    i = read(fd, buf, 512);
     674:	83 ec 04             	sub    $0x4,%esp
     677:	68 00 02 00 00       	push   $0x200
     67c:	68 20 88 00 00       	push   $0x8820
     681:	56                   	push   %esi
     682:	e8 c6 35 00 00       	call   3c4d <read>
    if(i == 0){
     687:	83 c4 10             	add    $0x10,%esp
     68a:	85 c0                	test   %eax,%eax
     68c:	74 3a                	je     6c8 <writetest1+0x11f>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit(0);
      }
      break;
    } else if(i != 512){
     68e:	3d 00 02 00 00       	cmp    $0x200,%eax
     693:	0f 85 90 00 00 00    	jne    729 <writetest1+0x180>
      printf(stdout, "read failed %d\n", i);
      exit(0);
    }
    if(((int*)buf)[0] != n){
     699:	a1 20 88 00 00       	mov    0x8820,%eax
     69e:	39 d8                	cmp    %ebx,%eax
     6a0:	0f 85 a3 00 00 00    	jne    749 <writetest1+0x1a0>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit(0);
    }
    n++;
     6a6:	43                   	inc    %ebx
    i = read(fd, buf, 512);
     6a7:	eb cb                	jmp    674 <writetest1+0xcb>
    printf(stdout, "error: open big failed!\n");
     6a9:	83 ec 08             	sub    $0x8,%esp
     6ac:	68 8d 42 00 00       	push   $0x428d
     6b1:	ff 35 d8 60 00 00    	push   0x60d8
     6b7:	e8 cc 36 00 00       	call   3d88 <printf>
    exit(0);
     6bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     6c3:	e8 6d 35 00 00       	call   3c35 <exit>
      if(n == MAXFILE - 1){
     6c8:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     6ce:	74 39                	je     709 <writetest1+0x160>
  }
  close(fd);
     6d0:	83 ec 0c             	sub    $0xc,%esp
     6d3:	56                   	push   %esi
     6d4:	e8 84 35 00 00       	call   3c5d <close>
  if(unlink("big") < 0){
     6d9:	c7 04 24 bf 42 00 00 	movl   $0x42bf,(%esp)
     6e0:	e8 a0 35 00 00       	call   3c85 <unlink>
     6e5:	83 c4 10             	add    $0x10,%esp
     6e8:	85 c0                	test   %eax,%eax
     6ea:	78 7b                	js     767 <writetest1+0x1be>
    printf(stdout, "unlink big failed\n");
    exit(0);
  }
  printf(stdout, "big files ok\n");
     6ec:	83 ec 08             	sub    $0x8,%esp
     6ef:	68 e6 42 00 00       	push   $0x42e6
     6f4:	ff 35 d8 60 00 00    	push   0x60d8
     6fa:	e8 89 36 00 00       	call   3d88 <printf>
}
     6ff:	83 c4 10             	add    $0x10,%esp
     702:	8d 65 f8             	lea    -0x8(%ebp),%esp
     705:	5b                   	pop    %ebx
     706:	5e                   	pop    %esi
     707:	5d                   	pop    %ebp
     708:	c3                   	ret
        printf(stdout, "read only %d blocks from big", n);
     709:	83 ec 04             	sub    $0x4,%esp
     70c:	53                   	push   %ebx
     70d:	68 a6 42 00 00       	push   $0x42a6
     712:	ff 35 d8 60 00 00    	push   0x60d8
     718:	e8 6b 36 00 00       	call   3d88 <printf>
        exit(0);
     71d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     724:	e8 0c 35 00 00       	call   3c35 <exit>
      printf(stdout, "read failed %d\n", i);
     729:	83 ec 04             	sub    $0x4,%esp
     72c:	50                   	push   %eax
     72d:	68 c3 42 00 00       	push   $0x42c3
     732:	ff 35 d8 60 00 00    	push   0x60d8
     738:	e8 4b 36 00 00       	call   3d88 <printf>
      exit(0);
     73d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     744:	e8 ec 34 00 00       	call   3c35 <exit>
      printf(stdout, "read content of block %d is %d\n",
     749:	50                   	push   %eax
     74a:	53                   	push   %ebx
     74b:	68 c4 50 00 00       	push   $0x50c4
     750:	ff 35 d8 60 00 00    	push   0x60d8
     756:	e8 2d 36 00 00       	call   3d88 <printf>
      exit(0);
     75b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     762:	e8 ce 34 00 00       	call   3c35 <exit>
    printf(stdout, "unlink big failed\n");
     767:	83 ec 08             	sub    $0x8,%esp
     76a:	68 d3 42 00 00       	push   $0x42d3
     76f:	ff 35 d8 60 00 00    	push   0x60d8
     775:	e8 0e 36 00 00       	call   3d88 <printf>
    exit(0);
     77a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     781:	e8 af 34 00 00       	call   3c35 <exit>

00000786 <createtest>:

void
createtest(void)
{
     786:	55                   	push   %ebp
     787:	89 e5                	mov    %esp,%ebp
     789:	53                   	push   %ebx
     78a:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     78d:	68 e4 50 00 00       	push   $0x50e4
     792:	ff 35 d8 60 00 00    	push   0x60d8
     798:	e8 eb 35 00 00       	call   3d88 <printf>

  name[0] = 'a';
     79d:	c6 05 10 88 00 00 61 	movb   $0x61,0x8810
  name[2] = '\0';
     7a4:	c6 05 12 88 00 00 00 	movb   $0x0,0x8812
  for(i = 0; i < 52; i++){
     7ab:	83 c4 10             	add    $0x10,%esp
     7ae:	bb 00 00 00 00       	mov    $0x0,%ebx
     7b3:	eb 26                	jmp    7db <createtest+0x55>
    name[1] = '0' + i;
     7b5:	8d 43 30             	lea    0x30(%ebx),%eax
     7b8:	a2 11 88 00 00       	mov    %al,0x8811
    fd = open(name, O_CREATE|O_RDWR);
     7bd:	83 ec 08             	sub    $0x8,%esp
     7c0:	68 02 02 00 00       	push   $0x202
     7c5:	68 10 88 00 00       	push   $0x8810
     7ca:	e8 a6 34 00 00       	call   3c75 <open>
    close(fd);
     7cf:	89 04 24             	mov    %eax,(%esp)
     7d2:	e8 86 34 00 00       	call   3c5d <close>
  for(i = 0; i < 52; i++){
     7d7:	43                   	inc    %ebx
     7d8:	83 c4 10             	add    $0x10,%esp
     7db:	83 fb 33             	cmp    $0x33,%ebx
     7de:	7e d5                	jle    7b5 <createtest+0x2f>
  }
  name[0] = 'a';
     7e0:	c6 05 10 88 00 00 61 	movb   $0x61,0x8810
  name[2] = '\0';
     7e7:	c6 05 12 88 00 00 00 	movb   $0x0,0x8812
  for(i = 0; i < 52; i++){
     7ee:	bb 00 00 00 00       	mov    $0x0,%ebx
     7f3:	eb 19                	jmp    80e <createtest+0x88>
    name[1] = '0' + i;
     7f5:	8d 43 30             	lea    0x30(%ebx),%eax
     7f8:	a2 11 88 00 00       	mov    %al,0x8811
    unlink(name);
     7fd:	83 ec 0c             	sub    $0xc,%esp
     800:	68 10 88 00 00       	push   $0x8810
     805:	e8 7b 34 00 00       	call   3c85 <unlink>
  for(i = 0; i < 52; i++){
     80a:	43                   	inc    %ebx
     80b:	83 c4 10             	add    $0x10,%esp
     80e:	83 fb 33             	cmp    $0x33,%ebx
     811:	7e e2                	jle    7f5 <createtest+0x6f>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     813:	83 ec 08             	sub    $0x8,%esp
     816:	68 10 51 00 00       	push   $0x5110
     81b:	ff 35 d8 60 00 00    	push   0x60d8
     821:	e8 62 35 00 00       	call   3d88 <printf>
}
     826:	83 c4 10             	add    $0x10,%esp
     829:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     82c:	c9                   	leave
     82d:	c3                   	ret

0000082e <dirtest>:

void dirtest(void)
{
     82e:	55                   	push   %ebp
     82f:	89 e5                	mov    %esp,%ebp
     831:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     834:	68 f4 42 00 00       	push   $0x42f4
     839:	ff 35 d8 60 00 00    	push   0x60d8
     83f:	e8 44 35 00 00       	call   3d88 <printf>

  if(mkdir("dir0") < 0){
     844:	c7 04 24 00 43 00 00 	movl   $0x4300,(%esp)
     84b:	e8 4d 34 00 00       	call   3c9d <mkdir>
     850:	83 c4 10             	add    $0x10,%esp
     853:	85 c0                	test   %eax,%eax
     855:	78 54                	js     8ab <dirtest+0x7d>
    printf(stdout, "mkdir failed\n");
    exit(0);
  }

  if(chdir("dir0") < 0){
     857:	83 ec 0c             	sub    $0xc,%esp
     85a:	68 00 43 00 00       	push   $0x4300
     85f:	e8 41 34 00 00       	call   3ca5 <chdir>
     864:	83 c4 10             	add    $0x10,%esp
     867:	85 c0                	test   %eax,%eax
     869:	78 5f                	js     8ca <dirtest+0x9c>
    printf(stdout, "chdir dir0 failed\n");
    exit(0);
  }

  if(chdir("..") < 0){
     86b:	83 ec 0c             	sub    $0xc,%esp
     86e:	68 a5 48 00 00       	push   $0x48a5
     873:	e8 2d 34 00 00       	call   3ca5 <chdir>
     878:	83 c4 10             	add    $0x10,%esp
     87b:	85 c0                	test   %eax,%eax
     87d:	78 6a                	js     8e9 <dirtest+0xbb>
    printf(stdout, "chdir .. failed\n");
    exit(0);
  }

  if(unlink("dir0") < 0){
     87f:	83 ec 0c             	sub    $0xc,%esp
     882:	68 00 43 00 00       	push   $0x4300
     887:	e8 f9 33 00 00       	call   3c85 <unlink>
     88c:	83 c4 10             	add    $0x10,%esp
     88f:	85 c0                	test   %eax,%eax
     891:	78 75                	js     908 <dirtest+0xda>
    printf(stdout, "unlink dir0 failed\n");
    exit(0);
  }
  printf(stdout, "mkdir test ok\n");
     893:	83 ec 08             	sub    $0x8,%esp
     896:	68 3d 43 00 00       	push   $0x433d
     89b:	ff 35 d8 60 00 00    	push   0x60d8
     8a1:	e8 e2 34 00 00       	call   3d88 <printf>
}
     8a6:	83 c4 10             	add    $0x10,%esp
     8a9:	c9                   	leave
     8aa:	c3                   	ret
    printf(stdout, "mkdir failed\n");
     8ab:	83 ec 08             	sub    $0x8,%esp
     8ae:	68 30 40 00 00       	push   $0x4030
     8b3:	ff 35 d8 60 00 00    	push   0x60d8
     8b9:	e8 ca 34 00 00       	call   3d88 <printf>
    exit(0);
     8be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     8c5:	e8 6b 33 00 00       	call   3c35 <exit>
    printf(stdout, "chdir dir0 failed\n");
     8ca:	83 ec 08             	sub    $0x8,%esp
     8cd:	68 05 43 00 00       	push   $0x4305
     8d2:	ff 35 d8 60 00 00    	push   0x60d8
     8d8:	e8 ab 34 00 00       	call   3d88 <printf>
    exit(0);
     8dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     8e4:	e8 4c 33 00 00       	call   3c35 <exit>
    printf(stdout, "chdir .. failed\n");
     8e9:	83 ec 08             	sub    $0x8,%esp
     8ec:	68 18 43 00 00       	push   $0x4318
     8f1:	ff 35 d8 60 00 00    	push   0x60d8
     8f7:	e8 8c 34 00 00       	call   3d88 <printf>
    exit(0);
     8fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     903:	e8 2d 33 00 00       	call   3c35 <exit>
    printf(stdout, "unlink dir0 failed\n");
     908:	83 ec 08             	sub    $0x8,%esp
     90b:	68 29 43 00 00       	push   $0x4329
     910:	ff 35 d8 60 00 00    	push   0x60d8
     916:	e8 6d 34 00 00       	call   3d88 <printf>
    exit(0);
     91b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     922:	e8 0e 33 00 00       	call   3c35 <exit>

00000927 <exectest>:

void
exectest(void)
{
     927:	55                   	push   %ebp
     928:	89 e5                	mov    %esp,%ebp
     92a:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     92d:	68 4c 43 00 00       	push   $0x434c
     932:	ff 35 d8 60 00 00    	push   0x60d8
     938:	e8 4b 34 00 00       	call   3d88 <printf>
  if(exec("echo", echoargv) < 0){
     93d:	83 c4 08             	add    $0x8,%esp
     940:	68 dc 60 00 00       	push   $0x60dc
     945:	68 15 41 00 00       	push   $0x4115
     94a:	e8 1e 33 00 00       	call   3c6d <exec>
     94f:	83 c4 10             	add    $0x10,%esp
     952:	85 c0                	test   %eax,%eax
     954:	78 02                	js     958 <exectest+0x31>
    printf(stdout, "exec echo failed\n");
    exit(0);
  }
}
     956:	c9                   	leave
     957:	c3                   	ret
    printf(stdout, "exec echo failed\n");
     958:	83 ec 08             	sub    $0x8,%esp
     95b:	68 57 43 00 00       	push   $0x4357
     960:	ff 35 d8 60 00 00    	push   0x60d8
     966:	e8 1d 34 00 00       	call   3d88 <printf>
    exit(0);
     96b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     972:	e8 be 32 00 00       	call   3c35 <exit>

00000977 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     977:	55                   	push   %ebp
     978:	89 e5                	mov    %esp,%ebp
     97a:	57                   	push   %edi
     97b:	56                   	push   %esi
     97c:	53                   	push   %ebx
     97d:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     980:	8d 45 e0             	lea    -0x20(%ebp),%eax
     983:	50                   	push   %eax
     984:	e8 bc 32 00 00       	call   3c45 <pipe>
     989:	83 c4 10             	add    $0x10,%esp
     98c:	85 c0                	test   %eax,%eax
     98e:	75 76                	jne    a06 <pipe1+0x8f>
     990:	89 c6                	mov    %eax,%esi
    printf(1, "pipe() failed\n");
    exit(0);
  }
  pid = fork();
     992:	e8 96 32 00 00       	call   3c2d <fork>
     997:	89 c7                	mov    %eax,%edi
  seq = 0;
  if(pid == 0){
     999:	85 c0                	test   %eax,%eax
     99b:	0f 84 80 00 00 00    	je     a21 <pipe1+0xaa>
        printf(1, "pipe1 oops 1\n");
        exit(0);
      }
    }
    exit(0);
  } else if(pid > 0){
     9a1:	0f 8e 7d 01 00 00    	jle    b24 <pipe1+0x1ad>
    close(fds[1]);
     9a7:	83 ec 0c             	sub    $0xc,%esp
     9aa:	ff 75 e4             	push   -0x1c(%ebp)
     9ad:	e8 ab 32 00 00       	call   3c5d <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     9b2:	83 c4 10             	add    $0x10,%esp
    total = 0;
     9b5:	89 75 d0             	mov    %esi,-0x30(%ebp)
  seq = 0;
     9b8:	89 f3                	mov    %esi,%ebx
    cc = 1;
     9ba:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     9c1:	83 ec 04             	sub    $0x4,%esp
     9c4:	ff 75 d4             	push   -0x2c(%ebp)
     9c7:	68 20 88 00 00       	push   $0x8820
     9cc:	ff 75 e0             	push   -0x20(%ebp)
     9cf:	e8 79 32 00 00       	call   3c4d <read>
     9d4:	89 c7                	mov    %eax,%edi
     9d6:	83 c4 10             	add    $0x10,%esp
     9d9:	85 c0                	test   %eax,%eax
     9db:	0f 8e f1 00 00 00    	jle    ad2 <pipe1+0x15b>
      for(i = 0; i < n; i++){
     9e1:	89 f0                	mov    %esi,%eax
     9e3:	89 d9                	mov    %ebx,%ecx
     9e5:	39 f8                	cmp    %edi,%eax
     9e7:	0f 8d c1 00 00 00    	jge    aae <pipe1+0x137>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     9ed:	0f be 98 20 88 00 00 	movsbl 0x8820(%eax),%ebx
     9f4:	8d 51 01             	lea    0x1(%ecx),%edx
     9f7:	31 cb                	xor    %ecx,%ebx
     9f9:	84 db                	test   %bl,%bl
     9fb:	0f 85 93 00 00 00    	jne    a94 <pipe1+0x11d>
      for(i = 0; i < n; i++){
     a01:	40                   	inc    %eax
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     a02:	89 d1                	mov    %edx,%ecx
     a04:	eb df                	jmp    9e5 <pipe1+0x6e>
    printf(1, "pipe() failed\n");
     a06:	83 ec 08             	sub    $0x8,%esp
     a09:	68 69 43 00 00       	push   $0x4369
     a0e:	6a 01                	push   $0x1
     a10:	e8 73 33 00 00       	call   3d88 <printf>
    exit(0);
     a15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     a1c:	e8 14 32 00 00       	call   3c35 <exit>
    close(fds[0]);
     a21:	83 ec 0c             	sub    $0xc,%esp
     a24:	ff 75 e0             	push   -0x20(%ebp)
     a27:	e8 31 32 00 00       	call   3c5d <close>
    for(n = 0; n < 5; n++){
     a2c:	83 c4 10             	add    $0x10,%esp
     a2f:	89 fe                	mov    %edi,%esi
  seq = 0;
     a31:	89 fb                	mov    %edi,%ebx
    for(n = 0; n < 5; n++){
     a33:	eb 31                	jmp    a66 <pipe1+0xef>
        buf[i] = seq++;
     a35:	88 98 20 88 00 00    	mov    %bl,0x8820(%eax)
      for(i = 0; i < 1033; i++)
     a3b:	40                   	inc    %eax
        buf[i] = seq++;
     a3c:	8d 5b 01             	lea    0x1(%ebx),%ebx
      for(i = 0; i < 1033; i++)
     a3f:	3d 08 04 00 00       	cmp    $0x408,%eax
     a44:	7e ef                	jle    a35 <pipe1+0xbe>
      if(write(fds[1], buf, 1033) != 1033){
     a46:	83 ec 04             	sub    $0x4,%esp
     a49:	68 09 04 00 00       	push   $0x409
     a4e:	68 20 88 00 00       	push   $0x8820
     a53:	ff 75 e4             	push   -0x1c(%ebp)
     a56:	e8 fa 31 00 00       	call   3c55 <write>
     a5b:	83 c4 10             	add    $0x10,%esp
     a5e:	3d 09 04 00 00       	cmp    $0x409,%eax
     a63:	75 0a                	jne    a6f <pipe1+0xf8>
    for(n = 0; n < 5; n++){
     a65:	46                   	inc    %esi
     a66:	83 fe 04             	cmp    $0x4,%esi
     a69:	7f 1f                	jg     a8a <pipe1+0x113>
      for(i = 0; i < 1033; i++)
     a6b:	89 f8                	mov    %edi,%eax
     a6d:	eb d0                	jmp    a3f <pipe1+0xc8>
        printf(1, "pipe1 oops 1\n");
     a6f:	83 ec 08             	sub    $0x8,%esp
     a72:	68 78 43 00 00       	push   $0x4378
     a77:	6a 01                	push   $0x1
     a79:	e8 0a 33 00 00       	call   3d88 <printf>
        exit(0);
     a7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     a85:	e8 ab 31 00 00       	call   3c35 <exit>
    exit(0);
     a8a:	83 ec 0c             	sub    $0xc,%esp
     a8d:	6a 00                	push   $0x0
     a8f:	e8 a1 31 00 00       	call   3c35 <exit>
          printf(1, "pipe1 oops 2\n");
     a94:	83 ec 08             	sub    $0x8,%esp
     a97:	68 86 43 00 00       	push   $0x4386
     a9c:	6a 01                	push   $0x1
     a9e:	e8 e5 32 00 00       	call   3d88 <printf>
          return;
     aa3:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "fork() failed\n");
    exit(0);
  }
  printf(1, "pipe1 ok\n");
}
     aa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
     aa9:	5b                   	pop    %ebx
     aaa:	5e                   	pop    %esi
     aab:	5f                   	pop    %edi
     aac:	5d                   	pop    %ebp
     aad:	c3                   	ret
      total += n;
     aae:	89 cb                	mov    %ecx,%ebx
     ab0:	01 7d d0             	add    %edi,-0x30(%ebp)
      cc = cc * 2;
     ab3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     ab6:	01 c0                	add    %eax,%eax
     ab8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if(cc > sizeof(buf))
     abb:	3d 00 20 00 00       	cmp    $0x2000,%eax
     ac0:	0f 86 fb fe ff ff    	jbe    9c1 <pipe1+0x4a>
        cc = sizeof(buf);
     ac6:	c7 45 d4 00 20 00 00 	movl   $0x2000,-0x2c(%ebp)
     acd:	e9 ef fe ff ff       	jmp    9c1 <pipe1+0x4a>
    if(total != 5 * 1033){
     ad2:	81 7d d0 2d 14 00 00 	cmpl   $0x142d,-0x30(%ebp)
     ad9:	75 2b                	jne    b06 <pipe1+0x18f>
    close(fds[0]);
     adb:	83 ec 0c             	sub    $0xc,%esp
     ade:	ff 75 e0             	push   -0x20(%ebp)
     ae1:	e8 77 31 00 00       	call   3c5d <close>
    wait(NULL);
     ae6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     aed:	e8 4b 31 00 00       	call   3c3d <wait>
  printf(1, "pipe1 ok\n");
     af2:	83 c4 08             	add    $0x8,%esp
     af5:	68 ab 43 00 00       	push   $0x43ab
     afa:	6a 01                	push   $0x1
     afc:	e8 87 32 00 00       	call   3d88 <printf>
     b01:	83 c4 10             	add    $0x10,%esp
     b04:	eb a0                	jmp    aa6 <pipe1+0x12f>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b06:	83 ec 04             	sub    $0x4,%esp
     b09:	ff 75 d0             	push   -0x30(%ebp)
     b0c:	68 94 43 00 00       	push   $0x4394
     b11:	6a 01                	push   $0x1
     b13:	e8 70 32 00 00       	call   3d88 <printf>
      exit(0);
     b18:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     b1f:	e8 11 31 00 00       	call   3c35 <exit>
    printf(1, "fork() failed\n");
     b24:	83 ec 08             	sub    $0x8,%esp
     b27:	68 b5 43 00 00       	push   $0x43b5
     b2c:	6a 01                	push   $0x1
     b2e:	e8 55 32 00 00       	call   3d88 <printf>
    exit(0);
     b33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     b3a:	e8 f6 30 00 00       	call   3c35 <exit>

00000b3f <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     b3f:	55                   	push   %ebp
     b40:	89 e5                	mov    %esp,%ebp
     b42:	57                   	push   %edi
     b43:	56                   	push   %esi
     b44:	53                   	push   %ebx
     b45:	83 ec 24             	sub    $0x24,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     b48:	68 c4 43 00 00       	push   $0x43c4
     b4d:	6a 01                	push   $0x1
     b4f:	e8 34 32 00 00       	call   3d88 <printf>
  pid1 = fork();
     b54:	e8 d4 30 00 00       	call   3c2d <fork>
  if(pid1 == 0)
     b59:	83 c4 10             	add    $0x10,%esp
     b5c:	85 c0                	test   %eax,%eax
     b5e:	75 02                	jne    b62 <preempt+0x23>
    for(;;)
     b60:	eb fe                	jmp    b60 <preempt+0x21>
     b62:	89 c3                	mov    %eax,%ebx
      ;

  pid2 = fork();
     b64:	e8 c4 30 00 00       	call   3c2d <fork>
     b69:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     b6b:	85 c0                	test   %eax,%eax
     b6d:	75 02                	jne    b71 <preempt+0x32>
    for(;;)
     b6f:	eb fe                	jmp    b6f <preempt+0x30>
      ;

  pipe(pfds);
     b71:	83 ec 0c             	sub    $0xc,%esp
     b74:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b77:	50                   	push   %eax
     b78:	e8 c8 30 00 00       	call   3c45 <pipe>
  pid3 = fork();
     b7d:	e8 ab 30 00 00       	call   3c2d <fork>
     b82:	89 c7                	mov    %eax,%edi
  if(pid3 == 0){
     b84:	83 c4 10             	add    $0x10,%esp
     b87:	85 c0                	test   %eax,%eax
     b89:	75 49                	jne    bd4 <preempt+0x95>
    close(pfds[0]);
     b8b:	83 ec 0c             	sub    $0xc,%esp
     b8e:	ff 75 e0             	push   -0x20(%ebp)
     b91:	e8 c7 30 00 00       	call   3c5d <close>
    if(write(pfds[1], "x", 1) != 1)
     b96:	83 c4 0c             	add    $0xc,%esp
     b99:	6a 01                	push   $0x1
     b9b:	68 89 49 00 00       	push   $0x4989
     ba0:	ff 75 e4             	push   -0x1c(%ebp)
     ba3:	e8 ad 30 00 00       	call   3c55 <write>
     ba8:	83 c4 10             	add    $0x10,%esp
     bab:	83 f8 01             	cmp    $0x1,%eax
     bae:	75 10                	jne    bc0 <preempt+0x81>
      printf(1, "preempt write error");
    close(pfds[1]);
     bb0:	83 ec 0c             	sub    $0xc,%esp
     bb3:	ff 75 e4             	push   -0x1c(%ebp)
     bb6:	e8 a2 30 00 00       	call   3c5d <close>
     bbb:	83 c4 10             	add    $0x10,%esp
    for(;;)
     bbe:	eb fe                	jmp    bbe <preempt+0x7f>
      printf(1, "preempt write error");
     bc0:	83 ec 08             	sub    $0x8,%esp
     bc3:	68 ce 43 00 00       	push   $0x43ce
     bc8:	6a 01                	push   $0x1
     bca:	e8 b9 31 00 00       	call   3d88 <printf>
     bcf:	83 c4 10             	add    $0x10,%esp
     bd2:	eb dc                	jmp    bb0 <preempt+0x71>
      ;
  }

  close(pfds[1]);
     bd4:	83 ec 0c             	sub    $0xc,%esp
     bd7:	ff 75 e4             	push   -0x1c(%ebp)
     bda:	e8 7e 30 00 00       	call   3c5d <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     bdf:	83 c4 0c             	add    $0xc,%esp
     be2:	68 00 20 00 00       	push   $0x2000
     be7:	68 20 88 00 00       	push   $0x8820
     bec:	ff 75 e0             	push   -0x20(%ebp)
     bef:	e8 59 30 00 00       	call   3c4d <read>
     bf4:	83 c4 10             	add    $0x10,%esp
     bf7:	83 f8 01             	cmp    $0x1,%eax
     bfa:	74 1a                	je     c16 <preempt+0xd7>
    printf(1, "preempt read error");
     bfc:	83 ec 08             	sub    $0x8,%esp
     bff:	68 e2 43 00 00       	push   $0x43e2
     c04:	6a 01                	push   $0x1
     c06:	e8 7d 31 00 00       	call   3d88 <printf>
    return;
     c0b:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
  wait(NULL);
  wait(NULL);
  wait(NULL);
  printf(1, "preempt ok\n");
}
     c0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c11:	5b                   	pop    %ebx
     c12:	5e                   	pop    %esi
     c13:	5f                   	pop    %edi
     c14:	5d                   	pop    %ebp
     c15:	c3                   	ret
  close(pfds[0]);
     c16:	83 ec 0c             	sub    $0xc,%esp
     c19:	ff 75 e0             	push   -0x20(%ebp)
     c1c:	e8 3c 30 00 00       	call   3c5d <close>
  printf(1, "kill... ");
     c21:	83 c4 08             	add    $0x8,%esp
     c24:	68 f5 43 00 00       	push   $0x43f5
     c29:	6a 01                	push   $0x1
     c2b:	e8 58 31 00 00       	call   3d88 <printf>
  kill(pid1);
     c30:	89 1c 24             	mov    %ebx,(%esp)
     c33:	e8 2d 30 00 00       	call   3c65 <kill>
  kill(pid2);
     c38:	89 34 24             	mov    %esi,(%esp)
     c3b:	e8 25 30 00 00       	call   3c65 <kill>
  kill(pid3);
     c40:	89 3c 24             	mov    %edi,(%esp)
     c43:	e8 1d 30 00 00       	call   3c65 <kill>
  printf(1, "wait... ");
     c48:	83 c4 08             	add    $0x8,%esp
     c4b:	68 fe 43 00 00       	push   $0x43fe
     c50:	6a 01                	push   $0x1
     c52:	e8 31 31 00 00       	call   3d88 <printf>
  wait(NULL);
     c57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c5e:	e8 da 2f 00 00       	call   3c3d <wait>
  wait(NULL);
     c63:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c6a:	e8 ce 2f 00 00       	call   3c3d <wait>
  wait(NULL);
     c6f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c76:	e8 c2 2f 00 00       	call   3c3d <wait>
  printf(1, "preempt ok\n");
     c7b:	83 c4 08             	add    $0x8,%esp
     c7e:	68 07 44 00 00       	push   $0x4407
     c83:	6a 01                	push   $0x1
     c85:	e8 fe 30 00 00       	call   3d88 <printf>
     c8a:	83 c4 10             	add    $0x10,%esp
     c8d:	e9 7c ff ff ff       	jmp    c0e <preempt+0xcf>

00000c92 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     c92:	55                   	push   %ebp
     c93:	89 e5                	mov    %esp,%ebp
     c95:	56                   	push   %esi
     c96:	53                   	push   %ebx
  int i, pid;

  for(i = 0; i < 100; i++){
     c97:	be 00 00 00 00       	mov    $0x0,%esi
     c9c:	83 fe 63             	cmp    $0x63,%esi
     c9f:	7f 58                	jg     cf9 <exitwait+0x67>
    pid = fork();
     ca1:	e8 87 2f 00 00       	call   3c2d <fork>
     ca6:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     ca8:	85 c0                	test   %eax,%eax
     caa:	78 16                	js     cc2 <exitwait+0x30>
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
     cac:	74 41                	je     cef <exitwait+0x5d>
      if(wait(NULL) != pid){
     cae:	83 ec 0c             	sub    $0xc,%esp
     cb1:	6a 00                	push   $0x0
     cb3:	e8 85 2f 00 00       	call   3c3d <wait>
     cb8:	83 c4 10             	add    $0x10,%esp
     cbb:	39 d8                	cmp    %ebx,%eax
     cbd:	75 1c                	jne    cdb <exitwait+0x49>
  for(i = 0; i < 100; i++){
     cbf:	46                   	inc    %esi
     cc0:	eb da                	jmp    c9c <exitwait+0xa>
      printf(1, "fork failed\n");
     cc2:	83 ec 08             	sub    $0x8,%esp
     cc5:	68 71 4f 00 00       	push   $0x4f71
     cca:	6a 01                	push   $0x1
     ccc:	e8 b7 30 00 00       	call   3d88 <printf>
      return;
     cd1:	83 c4 10             	add    $0x10,%esp
    } else {
      exit(0);
    }
  }
  printf(1, "exitwait ok\n");
}
     cd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
     cd7:	5b                   	pop    %ebx
     cd8:	5e                   	pop    %esi
     cd9:	5d                   	pop    %ebp
     cda:	c3                   	ret
        printf(1, "wait wrong pid\n");
     cdb:	83 ec 08             	sub    $0x8,%esp
     cde:	68 13 44 00 00       	push   $0x4413
     ce3:	6a 01                	push   $0x1
     ce5:	e8 9e 30 00 00       	call   3d88 <printf>
        return;
     cea:	83 c4 10             	add    $0x10,%esp
     ced:	eb e5                	jmp    cd4 <exitwait+0x42>
      exit(0);
     cef:	83 ec 0c             	sub    $0xc,%esp
     cf2:	6a 00                	push   $0x0
     cf4:	e8 3c 2f 00 00       	call   3c35 <exit>
  printf(1, "exitwait ok\n");
     cf9:	83 ec 08             	sub    $0x8,%esp
     cfc:	68 23 44 00 00       	push   $0x4423
     d01:	6a 01                	push   $0x1
     d03:	e8 80 30 00 00       	call   3d88 <printf>
     d08:	83 c4 10             	add    $0x10,%esp
     d0b:	eb c7                	jmp    cd4 <exitwait+0x42>

00000d0d <mem>:

void
mem(void)
{
     d0d:	55                   	push   %ebp
     d0e:	89 e5                	mov    %esp,%ebp
     d10:	57                   	push   %edi
     d11:	56                   	push   %esi
     d12:	53                   	push   %ebx
     d13:	83 ec 14             	sub    $0x14,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d16:	68 30 44 00 00       	push   $0x4430
     d1b:	6a 01                	push   $0x1
     d1d:	e8 66 30 00 00       	call   3d88 <printf>
  ppid = getpid();
     d22:	e8 8e 2f 00 00       	call   3cb5 <getpid>
     d27:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
     d29:	e8 ff 2e 00 00       	call   3c2d <fork>
     d2e:	83 c4 10             	add    $0x10,%esp
     d31:	85 c0                	test   %eax,%eax
     d33:	0f 85 90 00 00 00    	jne    dc9 <mem+0xbc>
    m1 = 0;
     d39:	bb 00 00 00 00       	mov    $0x0,%ebx
     d3e:	eb 04                	jmp    d44 <mem+0x37>
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
     d40:	89 18                	mov    %ebx,(%eax)
      m1 = m2;
     d42:	89 c3                	mov    %eax,%ebx
    while((m2 = malloc(10001)) != 0){
     d44:	83 ec 0c             	sub    $0xc,%esp
     d47:	68 11 27 00 00       	push   $0x2711
     d4c:	e8 57 32 00 00       	call   3fa8 <malloc>
     d51:	83 c4 10             	add    $0x10,%esp
     d54:	85 c0                	test   %eax,%eax
     d56:	75 e8                	jne    d40 <mem+0x33>
     d58:	eb 10                	jmp    d6a <mem+0x5d>
    }
    while(m1){
      m2 = *(char**)m1;
     d5a:	8b 3b                	mov    (%ebx),%edi
      free(m1);
     d5c:	83 ec 0c             	sub    $0xc,%esp
     d5f:	53                   	push   %ebx
     d60:	e8 83 31 00 00       	call   3ee8 <free>
     d65:	83 c4 10             	add    $0x10,%esp
      m1 = m2;
     d68:	89 fb                	mov    %edi,%ebx
    while(m1){
     d6a:	85 db                	test   %ebx,%ebx
     d6c:	75 ec                	jne    d5a <mem+0x4d>
    }
    m1 = malloc(1024*20);
     d6e:	83 ec 0c             	sub    $0xc,%esp
     d71:	68 00 50 00 00       	push   $0x5000
     d76:	e8 2d 32 00 00       	call   3fa8 <malloc>
    if(m1 == 0){
     d7b:	83 c4 10             	add    $0x10,%esp
     d7e:	85 c0                	test   %eax,%eax
     d80:	74 24                	je     da6 <mem+0x99>
      printf(1, "couldn't allocate mem?!!\n");
      kill(ppid);
      exit(0);
    }
    free(m1);
     d82:	83 ec 0c             	sub    $0xc,%esp
     d85:	50                   	push   %eax
     d86:	e8 5d 31 00 00       	call   3ee8 <free>
    printf(1, "mem ok\n");
     d8b:	83 c4 08             	add    $0x8,%esp
     d8e:	68 54 44 00 00       	push   $0x4454
     d93:	6a 01                	push   $0x1
     d95:	e8 ee 2f 00 00       	call   3d88 <printf>
    exit(0);
     d9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     da1:	e8 8f 2e 00 00       	call   3c35 <exit>
      printf(1, "couldn't allocate mem?!!\n");
     da6:	83 ec 08             	sub    $0x8,%esp
     da9:	68 3a 44 00 00       	push   $0x443a
     dae:	6a 01                	push   $0x1
     db0:	e8 d3 2f 00 00       	call   3d88 <printf>
      kill(ppid);
     db5:	89 34 24             	mov    %esi,(%esp)
     db8:	e8 a8 2e 00 00       	call   3c65 <kill>
      exit(0);
     dbd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     dc4:	e8 6c 2e 00 00       	call   3c35 <exit>
  } else {
    wait(NULL);
     dc9:	83 ec 0c             	sub    $0xc,%esp
     dcc:	6a 00                	push   $0x0
     dce:	e8 6a 2e 00 00       	call   3c3d <wait>
  }
}
     dd3:	83 c4 10             	add    $0x10,%esp
     dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
     dd9:	5b                   	pop    %ebx
     dda:	5e                   	pop    %esi
     ddb:	5f                   	pop    %edi
     ddc:	5d                   	pop    %ebp
     ddd:	c3                   	ret

00000dde <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     dde:	55                   	push   %ebp
     ddf:	89 e5                	mov    %esp,%ebp
     de1:	57                   	push   %edi
     de2:	56                   	push   %esi
     de3:	53                   	push   %ebx
     de4:	83 ec 24             	sub    $0x24,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     de7:	68 5c 44 00 00       	push   $0x445c
     dec:	6a 01                	push   $0x1
     dee:	e8 95 2f 00 00       	call   3d88 <printf>

  unlink("sharedfd");
     df3:	c7 04 24 6b 44 00 00 	movl   $0x446b,(%esp)
     dfa:	e8 86 2e 00 00       	call   3c85 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     dff:	83 c4 08             	add    $0x8,%esp
     e02:	68 02 02 00 00       	push   $0x202
     e07:	68 6b 44 00 00       	push   $0x446b
     e0c:	e8 64 2e 00 00       	call   3c75 <open>
  if(fd < 0){
     e11:	83 c4 10             	add    $0x10,%esp
     e14:	85 c0                	test   %eax,%eax
     e16:	78 4b                	js     e63 <sharedfd+0x85>
     e18:	89 c6                	mov    %eax,%esi
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
     e1a:	e8 0e 2e 00 00       	call   3c2d <fork>
     e1f:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e21:	85 c0                	test   %eax,%eax
     e23:	75 55                	jne    e7a <sharedfd+0x9c>
     e25:	b8 63 00 00 00       	mov    $0x63,%eax
     e2a:	83 ec 04             	sub    $0x4,%esp
     e2d:	6a 0a                	push   $0xa
     e2f:	50                   	push   %eax
     e30:	8d 45 de             	lea    -0x22(%ebp),%eax
     e33:	50                   	push   %eax
     e34:	e8 d1 2c 00 00       	call   3b0a <memset>
  for(i = 0; i < 1000; i++){
     e39:	83 c4 10             	add    $0x10,%esp
     e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
     e41:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
     e47:	7f 4a                	jg     e93 <sharedfd+0xb5>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     e49:	83 ec 04             	sub    $0x4,%esp
     e4c:	6a 0a                	push   $0xa
     e4e:	8d 45 de             	lea    -0x22(%ebp),%eax
     e51:	50                   	push   %eax
     e52:	56                   	push   %esi
     e53:	e8 fd 2d 00 00       	call   3c55 <write>
     e58:	83 c4 10             	add    $0x10,%esp
     e5b:	83 f8 0a             	cmp    $0xa,%eax
     e5e:	75 21                	jne    e81 <sharedfd+0xa3>
  for(i = 0; i < 1000; i++){
     e60:	43                   	inc    %ebx
     e61:	eb de                	jmp    e41 <sharedfd+0x63>
    printf(1, "fstests: cannot open sharedfd for writing");
     e63:	83 ec 08             	sub    $0x8,%esp
     e66:	68 38 51 00 00       	push   $0x5138
     e6b:	6a 01                	push   $0x1
     e6d:	e8 16 2f 00 00       	call   3d88 <printf>
    return;
     e72:	83 c4 10             	add    $0x10,%esp
     e75:	e9 de 00 00 00       	jmp    f58 <sharedfd+0x17a>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e7a:	b8 70 00 00 00       	mov    $0x70,%eax
     e7f:	eb a9                	jmp    e2a <sharedfd+0x4c>
      printf(1, "fstests: write sharedfd failed\n");
     e81:	83 ec 08             	sub    $0x8,%esp
     e84:	68 64 51 00 00       	push   $0x5164
     e89:	6a 01                	push   $0x1
     e8b:	e8 f8 2e 00 00       	call   3d88 <printf>
      break;
     e90:	83 c4 10             	add    $0x10,%esp
    }
  }
  if(pid == 0)
     e93:	85 ff                	test   %edi,%edi
     e95:	74 51                	je     ee8 <sharedfd+0x10a>
    exit(0);
  else
    wait(NULL);
     e97:	83 ec 0c             	sub    $0xc,%esp
     e9a:	6a 00                	push   $0x0
     e9c:	e8 9c 2d 00 00       	call   3c3d <wait>
  close(fd);
     ea1:	89 34 24             	mov    %esi,(%esp)
     ea4:	e8 b4 2d 00 00       	call   3c5d <close>
  fd = open("sharedfd", 0);
     ea9:	83 c4 08             	add    $0x8,%esp
     eac:	6a 00                	push   $0x0
     eae:	68 6b 44 00 00       	push   $0x446b
     eb3:	e8 bd 2d 00 00       	call   3c75 <open>
     eb8:	89 c7                	mov    %eax,%edi
  if(fd < 0){
     eba:	83 c4 10             	add    $0x10,%esp
     ebd:	85 c0                	test   %eax,%eax
     ebf:	78 31                	js     ef2 <sharedfd+0x114>
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
     ec1:	be 00 00 00 00       	mov    $0x0,%esi
     ec6:	bb 00 00 00 00       	mov    $0x0,%ebx
  while((n = read(fd, buf, sizeof(buf))) > 0){
     ecb:	83 ec 04             	sub    $0x4,%esp
     ece:	6a 0a                	push   $0xa
     ed0:	8d 45 de             	lea    -0x22(%ebp),%eax
     ed3:	50                   	push   %eax
     ed4:	57                   	push   %edi
     ed5:	e8 73 2d 00 00       	call   3c4d <read>
     eda:	83 c4 10             	add    $0x10,%esp
     edd:	85 c0                	test   %eax,%eax
     edf:	7e 3d                	jle    f1e <sharedfd+0x140>
    for(i = 0; i < sizeof(buf); i++){
     ee1:	ba 00 00 00 00       	mov    $0x0,%edx
     ee6:	eb 23                	jmp    f0b <sharedfd+0x12d>
    exit(0);
     ee8:	83 ec 0c             	sub    $0xc,%esp
     eeb:	6a 00                	push   $0x0
     eed:	e8 43 2d 00 00       	call   3c35 <exit>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     ef2:	83 ec 08             	sub    $0x8,%esp
     ef5:	68 84 51 00 00       	push   $0x5184
     efa:	6a 01                	push   $0x1
     efc:	e8 87 2e 00 00       	call   3d88 <printf>
    return;
     f01:	83 c4 10             	add    $0x10,%esp
     f04:	eb 52                	jmp    f58 <sharedfd+0x17a>
      if(buf[i] == 'c')
        nc++;
      if(buf[i] == 'p')
     f06:	3c 70                	cmp    $0x70,%al
     f08:	74 11                	je     f1b <sharedfd+0x13d>
    for(i = 0; i < sizeof(buf); i++){
     f0a:	42                   	inc    %edx
     f0b:	83 fa 09             	cmp    $0x9,%edx
     f0e:	77 bb                	ja     ecb <sharedfd+0xed>
      if(buf[i] == 'c')
     f10:	8a 44 15 de          	mov    -0x22(%ebp,%edx,1),%al
     f14:	3c 63                	cmp    $0x63,%al
     f16:	75 ee                	jne    f06 <sharedfd+0x128>
        nc++;
     f18:	43                   	inc    %ebx
     f19:	eb eb                	jmp    f06 <sharedfd+0x128>
        np++;
     f1b:	46                   	inc    %esi
     f1c:	eb ec                	jmp    f0a <sharedfd+0x12c>
    }
  }
  close(fd);
     f1e:	83 ec 0c             	sub    $0xc,%esp
     f21:	57                   	push   %edi
     f22:	e8 36 2d 00 00       	call   3c5d <close>
  unlink("sharedfd");
     f27:	c7 04 24 6b 44 00 00 	movl   $0x446b,(%esp)
     f2e:	e8 52 2d 00 00       	call   3c85 <unlink>
  if(nc == 10000 && np == 10000){
     f33:	83 c4 10             	add    $0x10,%esp
     f36:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     f3c:	75 22                	jne    f60 <sharedfd+0x182>
     f3e:	81 fe 10 27 00 00    	cmp    $0x2710,%esi
     f44:	75 1a                	jne    f60 <sharedfd+0x182>
    printf(1, "sharedfd ok\n");
     f46:	83 ec 08             	sub    $0x8,%esp
     f49:	68 74 44 00 00       	push   $0x4474
     f4e:	6a 01                	push   $0x1
     f50:	e8 33 2e 00 00       	call   3d88 <printf>
     f55:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    exit(0);
  }
}
     f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f5b:	5b                   	pop    %ebx
     f5c:	5e                   	pop    %esi
     f5d:	5f                   	pop    %edi
     f5e:	5d                   	pop    %ebp
     f5f:	c3                   	ret
    printf(1, "sharedfd oops %d %d\n", nc, np);
     f60:	56                   	push   %esi
     f61:	53                   	push   %ebx
     f62:	68 81 44 00 00       	push   $0x4481
     f67:	6a 01                	push   $0x1
     f69:	e8 1a 2e 00 00       	call   3d88 <printf>
    exit(0);
     f6e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     f75:	e8 bb 2c 00 00       	call   3c35 <exit>

00000f7a <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
     f7a:	55                   	push   %ebp
     f7b:	89 e5                	mov    %esp,%ebp
     f7d:	57                   	push   %edi
     f7e:	56                   	push   %esi
     f7f:	53                   	push   %ebx
     f80:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
     f83:	8d 7d d8             	lea    -0x28(%ebp),%edi
     f86:	be d0 57 00 00       	mov    $0x57d0,%esi
     f8b:	b9 04 00 00 00       	mov    $0x4,%ecx
     f90:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  char *fname;

  printf(1, "fourfiles test\n");
     f92:	68 96 44 00 00       	push   $0x4496
     f97:	6a 01                	push   $0x1
     f99:	e8 ea 2d 00 00       	call   3d88 <printf>

  for(pi = 0; pi < 4; pi++){
     f9e:	83 c4 10             	add    $0x10,%esp
     fa1:	be 00 00 00 00       	mov    $0x0,%esi
     fa6:	eb 5d                	jmp    1005 <fourfiles+0x8b>
    fname = names[pi];
    unlink(fname);

    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
     fa8:	83 ec 08             	sub    $0x8,%esp
     fab:	68 71 4f 00 00       	push   $0x4f71
     fb0:	6a 01                	push   $0x1
     fb2:	e8 d1 2d 00 00       	call   3d88 <printf>
      exit(0);
     fb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     fbe:	e8 72 2c 00 00       	call   3c35 <exit>
    }

    if(pid == 0){
      fd = open(fname, O_CREATE | O_RDWR);
      if(fd < 0){
        printf(1, "create failed\n");
     fc3:	83 ec 08             	sub    $0x8,%esp
     fc6:	68 37 47 00 00       	push   $0x4737
     fcb:	6a 01                	push   $0x1
     fcd:	e8 b6 2d 00 00       	call   3d88 <printf>
        exit(0);
     fd2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     fd9:	e8 57 2c 00 00       	call   3c35 <exit>
      }

      memset(buf, '0'+pi, 512);
      for(i = 0; i < 12; i++){
        if((n = write(fd, buf, 500)) != 500){
          printf(1, "write failed %d\n", n);
     fde:	83 ec 04             	sub    $0x4,%esp
     fe1:	50                   	push   %eax
     fe2:	68 a6 44 00 00       	push   $0x44a6
     fe7:	6a 01                	push   $0x1
     fe9:	e8 9a 2d 00 00       	call   3d88 <printf>
          exit(0);
     fee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     ff5:	e8 3b 2c 00 00       	call   3c35 <exit>
        }
      }
      exit(0);
     ffa:	83 ec 0c             	sub    $0xc,%esp
     ffd:	6a 00                	push   $0x0
     fff:	e8 31 2c 00 00       	call   3c35 <exit>
  for(pi = 0; pi < 4; pi++){
    1004:	46                   	inc    %esi
    1005:	83 fe 03             	cmp    $0x3,%esi
    1008:	7f 76                	jg     1080 <fourfiles+0x106>
    fname = names[pi];
    100a:	8b 7c b5 d8          	mov    -0x28(%ebp,%esi,4),%edi
    unlink(fname);
    100e:	83 ec 0c             	sub    $0xc,%esp
    1011:	57                   	push   %edi
    1012:	e8 6e 2c 00 00       	call   3c85 <unlink>
    pid = fork();
    1017:	e8 11 2c 00 00       	call   3c2d <fork>
    if(pid < 0){
    101c:	83 c4 10             	add    $0x10,%esp
    101f:	85 c0                	test   %eax,%eax
    1021:	78 85                	js     fa8 <fourfiles+0x2e>
    if(pid == 0){
    1023:	75 df                	jne    1004 <fourfiles+0x8a>
      fd = open(fname, O_CREATE | O_RDWR);
    1025:	89 c3                	mov    %eax,%ebx
    1027:	83 ec 08             	sub    $0x8,%esp
    102a:	68 02 02 00 00       	push   $0x202
    102f:	57                   	push   %edi
    1030:	e8 40 2c 00 00       	call   3c75 <open>
    1035:	89 c7                	mov    %eax,%edi
      if(fd < 0){
    1037:	83 c4 10             	add    $0x10,%esp
    103a:	85 c0                	test   %eax,%eax
    103c:	78 85                	js     fc3 <fourfiles+0x49>
      memset(buf, '0'+pi, 512);
    103e:	83 ec 04             	sub    $0x4,%esp
    1041:	68 00 02 00 00       	push   $0x200
    1046:	83 c6 30             	add    $0x30,%esi
    1049:	56                   	push   %esi
    104a:	68 20 88 00 00       	push   $0x8820
    104f:	e8 b6 2a 00 00       	call   3b0a <memset>
      for(i = 0; i < 12; i++){
    1054:	83 c4 10             	add    $0x10,%esp
    1057:	83 fb 0b             	cmp    $0xb,%ebx
    105a:	7f 9e                	jg     ffa <fourfiles+0x80>
        if((n = write(fd, buf, 500)) != 500){
    105c:	83 ec 04             	sub    $0x4,%esp
    105f:	68 f4 01 00 00       	push   $0x1f4
    1064:	68 20 88 00 00       	push   $0x8820
    1069:	57                   	push   %edi
    106a:	e8 e6 2b 00 00       	call   3c55 <write>
    106f:	83 c4 10             	add    $0x10,%esp
    1072:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    1077:	0f 85 61 ff ff ff    	jne    fde <fourfiles+0x64>
      for(i = 0; i < 12; i++){
    107d:	43                   	inc    %ebx
    107e:	eb d7                	jmp    1057 <fourfiles+0xdd>
    }
  }

  for(pi = 0; pi < 4; pi++){
    1080:	bb 00 00 00 00       	mov    $0x0,%ebx
    1085:	eb 0e                	jmp    1095 <fourfiles+0x11b>
    wait(NULL);
    1087:	83 ec 0c             	sub    $0xc,%esp
    108a:	6a 00                	push   $0x0
    108c:	e8 ac 2b 00 00       	call   3c3d <wait>
  for(pi = 0; pi < 4; pi++){
    1091:	43                   	inc    %ebx
    1092:	83 c4 10             	add    $0x10,%esp
    1095:	83 fb 03             	cmp    $0x3,%ebx
    1098:	7e ed                	jle    1087 <fourfiles+0x10d>
  }

  for(i = 0; i < 2; i++){
    109a:	bb 00 00 00 00       	mov    $0x0,%ebx
    109f:	eb 79                	jmp    111a <fourfiles+0x1a0>
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
    10a1:	83 ec 08             	sub    $0x8,%esp
    10a4:	68 b7 44 00 00       	push   $0x44b7
    10a9:	6a 01                	push   $0x1
    10ab:	e8 d8 2c 00 00       	call   3d88 <printf>
          exit(0);
    10b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    10b7:	e8 79 2b 00 00       	call   3c35 <exit>
        }
      }
      total += n;
    10bc:	01 7d d4             	add    %edi,-0x2c(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    10bf:	83 ec 04             	sub    $0x4,%esp
    10c2:	68 00 20 00 00       	push   $0x2000
    10c7:	68 20 88 00 00       	push   $0x8820
    10cc:	56                   	push   %esi
    10cd:	e8 7b 2b 00 00       	call   3c4d <read>
    10d2:	89 c7                	mov    %eax,%edi
    10d4:	83 c4 10             	add    $0x10,%esp
    10d7:	85 c0                	test   %eax,%eax
    10d9:	7e 1a                	jle    10f5 <fourfiles+0x17b>
      for(j = 0; j < n; j++){
    10db:	b8 00 00 00 00       	mov    $0x0,%eax
    10e0:	39 f8                	cmp    %edi,%eax
    10e2:	7d d8                	jge    10bc <fourfiles+0x142>
        if(buf[j] != '0'+i){
    10e4:	0f be 88 20 88 00 00 	movsbl 0x8820(%eax),%ecx
    10eb:	8d 53 30             	lea    0x30(%ebx),%edx
    10ee:	39 d1                	cmp    %edx,%ecx
    10f0:	75 af                	jne    10a1 <fourfiles+0x127>
      for(j = 0; j < n; j++){
    10f2:	40                   	inc    %eax
    10f3:	eb eb                	jmp    10e0 <fourfiles+0x166>
    }
    close(fd);
    10f5:	8b 7d d0             	mov    -0x30(%ebp),%edi
    10f8:	83 ec 0c             	sub    $0xc,%esp
    10fb:	56                   	push   %esi
    10fc:	e8 5c 2b 00 00       	call   3c5d <close>
    if(total != 12*500){
    1101:	83 c4 10             	add    $0x10,%esp
    1104:	81 7d d4 70 17 00 00 	cmpl   $0x1770,-0x2c(%ebp)
    110b:	75 32                	jne    113f <fourfiles+0x1c5>
      printf(1, "wrong length %d\n", total);
      exit(0);
    }
    unlink(fname);
    110d:	83 ec 0c             	sub    $0xc,%esp
    1110:	57                   	push   %edi
    1111:	e8 6f 2b 00 00       	call   3c85 <unlink>
  for(i = 0; i < 2; i++){
    1116:	43                   	inc    %ebx
    1117:	83 c4 10             	add    $0x10,%esp
    111a:	83 fb 01             	cmp    $0x1,%ebx
    111d:	7f 3e                	jg     115d <fourfiles+0x1e3>
    fname = names[i];
    111f:	8b 7c 9d d8          	mov    -0x28(%ebp,%ebx,4),%edi
    fd = open(fname, 0);
    1123:	83 ec 08             	sub    $0x8,%esp
    1126:	6a 00                	push   $0x0
    1128:	57                   	push   %edi
    1129:	e8 47 2b 00 00       	call   3c75 <open>
    112e:	89 c6                	mov    %eax,%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1130:	83 c4 10             	add    $0x10,%esp
    total = 0;
    1133:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    113a:	89 7d d0             	mov    %edi,-0x30(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    113d:	eb 80                	jmp    10bf <fourfiles+0x145>
      printf(1, "wrong length %d\n", total);
    113f:	83 ec 04             	sub    $0x4,%esp
    1142:	ff 75 d4             	push   -0x2c(%ebp)
    1145:	68 c3 44 00 00       	push   $0x44c3
    114a:	6a 01                	push   $0x1
    114c:	e8 37 2c 00 00       	call   3d88 <printf>
      exit(0);
    1151:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1158:	e8 d8 2a 00 00       	call   3c35 <exit>
  }

  printf(1, "fourfiles ok\n");
    115d:	83 ec 08             	sub    $0x8,%esp
    1160:	68 d4 44 00 00       	push   $0x44d4
    1165:	6a 01                	push   $0x1
    1167:	e8 1c 2c 00 00       	call   3d88 <printf>
}
    116c:	83 c4 10             	add    $0x10,%esp
    116f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1172:	5b                   	pop    %ebx
    1173:	5e                   	pop    %esi
    1174:	5f                   	pop    %edi
    1175:	5d                   	pop    %ebp
    1176:	c3                   	ret

00001177 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    1177:	55                   	push   %ebp
    1178:	89 e5                	mov    %esp,%ebp
    117a:	56                   	push   %esi
    117b:	53                   	push   %ebx
    117c:	83 ec 28             	sub    $0x28,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    117f:	68 e8 44 00 00       	push   $0x44e8
    1184:	6a 01                	push   $0x1
    1186:	e8 fd 2b 00 00       	call   3d88 <printf>

  for(pi = 0; pi < 4; pi++){
    118b:	83 c4 10             	add    $0x10,%esp
    118e:	be 00 00 00 00       	mov    $0x0,%esi
    1193:	83 fe 03             	cmp    $0x3,%esi
    1196:	0f 8f d2 00 00 00    	jg     126e <createdelete+0xf7>
    pid = fork();
    119c:	e8 8c 2a 00 00       	call   3c2d <fork>
    11a1:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
    11a3:	85 c0                	test   %eax,%eax
    11a5:	78 05                	js     11ac <createdelete+0x35>
      printf(1, "fork failed\n");
      exit(0);
    }

    if(pid == 0){
    11a7:	74 1e                	je     11c7 <createdelete+0x50>
  for(pi = 0; pi < 4; pi++){
    11a9:	46                   	inc    %esi
    11aa:	eb e7                	jmp    1193 <createdelete+0x1c>
      printf(1, "fork failed\n");
    11ac:	83 ec 08             	sub    $0x8,%esp
    11af:	68 71 4f 00 00       	push   $0x4f71
    11b4:	6a 01                	push   $0x1
    11b6:	e8 cd 2b 00 00       	call   3d88 <printf>
      exit(0);
    11bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11c2:	e8 6e 2a 00 00       	call   3c35 <exit>
      name[0] = 'p' + pi;
    11c7:	8d 46 70             	lea    0x70(%esi),%eax
    11ca:	88 45 d8             	mov    %al,-0x28(%ebp)
      name[2] = '\0';
    11cd:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
      for(i = 0; i < N; i++){
    11d1:	eb 1c                	jmp    11ef <createdelete+0x78>
        name[1] = '0' + i;
        fd = open(name, O_CREATE | O_RDWR);
        if(fd < 0){
          printf(1, "create failed\n");
    11d3:	83 ec 08             	sub    $0x8,%esp
    11d6:	68 37 47 00 00       	push   $0x4737
    11db:	6a 01                	push   $0x1
    11dd:	e8 a6 2b 00 00       	call   3d88 <printf>
          exit(0);
    11e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11e9:	e8 47 2a 00 00       	call   3c35 <exit>
      for(i = 0; i < N; i++){
    11ee:	43                   	inc    %ebx
    11ef:	83 fb 13             	cmp    $0x13,%ebx
    11f2:	7f 70                	jg     1264 <createdelete+0xed>
        name[1] = '0' + i;
    11f4:	8d 43 30             	lea    0x30(%ebx),%eax
    11f7:	88 45 d9             	mov    %al,-0x27(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    11fa:	83 ec 08             	sub    $0x8,%esp
    11fd:	68 02 02 00 00       	push   $0x202
    1202:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1205:	50                   	push   %eax
    1206:	e8 6a 2a 00 00       	call   3c75 <open>
        if(fd < 0){
    120b:	83 c4 10             	add    $0x10,%esp
    120e:	85 c0                	test   %eax,%eax
    1210:	78 c1                	js     11d3 <createdelete+0x5c>
        }
        close(fd);
    1212:	83 ec 0c             	sub    $0xc,%esp
    1215:	50                   	push   %eax
    1216:	e8 42 2a 00 00       	call   3c5d <close>
        if(i > 0 && (i % 2 ) == 0){
    121b:	83 c4 10             	add    $0x10,%esp
    121e:	85 db                	test   %ebx,%ebx
    1220:	7e cc                	jle    11ee <createdelete+0x77>
    1222:	f6 c3 01             	test   $0x1,%bl
    1225:	75 c7                	jne    11ee <createdelete+0x77>
          name[1] = '0' + (i / 2);
    1227:	89 d8                	mov    %ebx,%eax
    1229:	c1 e8 1f             	shr    $0x1f,%eax
    122c:	01 d8                	add    %ebx,%eax
    122e:	d1 f8                	sar    $1,%eax
    1230:	83 c0 30             	add    $0x30,%eax
    1233:	88 45 d9             	mov    %al,-0x27(%ebp)
          if(unlink(name) < 0){
    1236:	83 ec 0c             	sub    $0xc,%esp
    1239:	8d 45 d8             	lea    -0x28(%ebp),%eax
    123c:	50                   	push   %eax
    123d:	e8 43 2a 00 00       	call   3c85 <unlink>
    1242:	83 c4 10             	add    $0x10,%esp
    1245:	85 c0                	test   %eax,%eax
    1247:	79 a5                	jns    11ee <createdelete+0x77>
            printf(1, "unlink failed\n");
    1249:	83 ec 08             	sub    $0x8,%esp
    124c:	68 e9 40 00 00       	push   $0x40e9
    1251:	6a 01                	push   $0x1
    1253:	e8 30 2b 00 00       	call   3d88 <printf>
            exit(0);
    1258:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    125f:	e8 d1 29 00 00       	call   3c35 <exit>
          }
        }
      }
      exit(0);
    1264:	83 ec 0c             	sub    $0xc,%esp
    1267:	6a 00                	push   $0x0
    1269:	e8 c7 29 00 00       	call   3c35 <exit>
    }
  }

  for(pi = 0; pi < 4; pi++){
    126e:	bb 00 00 00 00       	mov    $0x0,%ebx
    1273:	83 fb 03             	cmp    $0x3,%ebx
    1276:	7f 10                	jg     1288 <createdelete+0x111>
    wait(NULL);
    1278:	83 ec 0c             	sub    $0xc,%esp
    127b:	6a 00                	push   $0x0
    127d:	e8 bb 29 00 00       	call   3c3d <wait>
  for(pi = 0; pi < 4; pi++){
    1282:	43                   	inc    %ebx
    1283:	83 c4 10             	add    $0x10,%esp
    1286:	eb eb                	jmp    1273 <createdelete+0xfc>
  }

  name[0] = name[1] = name[2] = 0;
    1288:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
    128c:	c6 45 d9 00          	movb   $0x0,-0x27(%ebp)
    1290:	c6 45 d8 00          	movb   $0x0,-0x28(%ebp)
  for(i = 0; i < N; i++){
    1294:	be 00 00 00 00       	mov    $0x0,%esi
    1299:	e9 8f 00 00 00       	jmp    132d <createdelete+0x1b6>
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
      name[1] = '0' + i;
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
    129e:	85 c0                	test   %eax,%eax
    12a0:	78 3a                	js     12dc <createdelete+0x165>
        printf(1, "oops createdelete %s didn't exist\n", name);
        exit(0);
      } else if((i >= 1 && i < N/2) && fd >= 0){
    12a2:	8d 56 ff             	lea    -0x1(%esi),%edx
    12a5:	83 fa 08             	cmp    $0x8,%edx
    12a8:	76 51                	jbe    12fb <createdelete+0x184>
        printf(1, "oops createdelete %s did exist\n", name);
        exit(0);
      }
      if(fd >= 0)
    12aa:	85 c0                	test   %eax,%eax
    12ac:	79 70                	jns    131e <createdelete+0x1a7>
    for(pi = 0; pi < 4; pi++){
    12ae:	43                   	inc    %ebx
    12af:	83 fb 03             	cmp    $0x3,%ebx
    12b2:	7f 78                	jg     132c <createdelete+0x1b5>
      name[0] = 'p' + pi;
    12b4:	8d 43 70             	lea    0x70(%ebx),%eax
    12b7:	88 45 d8             	mov    %al,-0x28(%ebp)
      name[1] = '0' + i;
    12ba:	8d 46 30             	lea    0x30(%esi),%eax
    12bd:	88 45 d9             	mov    %al,-0x27(%ebp)
      fd = open(name, 0);
    12c0:	83 ec 08             	sub    $0x8,%esp
    12c3:	6a 00                	push   $0x0
    12c5:	8d 45 d8             	lea    -0x28(%ebp),%eax
    12c8:	50                   	push   %eax
    12c9:	e8 a7 29 00 00       	call   3c75 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    12ce:	83 c4 10             	add    $0x10,%esp
    12d1:	85 f6                	test   %esi,%esi
    12d3:	74 c9                	je     129e <createdelete+0x127>
    12d5:	83 fe 09             	cmp    $0x9,%esi
    12d8:	7e c8                	jle    12a2 <createdelete+0x12b>
    12da:	eb c2                	jmp    129e <createdelete+0x127>
        printf(1, "oops createdelete %s didn't exist\n", name);
    12dc:	83 ec 04             	sub    $0x4,%esp
    12df:	8d 45 d8             	lea    -0x28(%ebp),%eax
    12e2:	50                   	push   %eax
    12e3:	68 b0 51 00 00       	push   $0x51b0
    12e8:	6a 01                	push   $0x1
    12ea:	e8 99 2a 00 00       	call   3d88 <printf>
        exit(0);
    12ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    12f6:	e8 3a 29 00 00       	call   3c35 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    12fb:	85 c0                	test   %eax,%eax
    12fd:	78 af                	js     12ae <createdelete+0x137>
        printf(1, "oops createdelete %s did exist\n", name);
    12ff:	83 ec 04             	sub    $0x4,%esp
    1302:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1305:	50                   	push   %eax
    1306:	68 d4 51 00 00       	push   $0x51d4
    130b:	6a 01                	push   $0x1
    130d:	e8 76 2a 00 00       	call   3d88 <printf>
        exit(0);
    1312:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1319:	e8 17 29 00 00       	call   3c35 <exit>
        close(fd);
    131e:	83 ec 0c             	sub    $0xc,%esp
    1321:	50                   	push   %eax
    1322:	e8 36 29 00 00       	call   3c5d <close>
    1327:	83 c4 10             	add    $0x10,%esp
    132a:	eb 82                	jmp    12ae <createdelete+0x137>
  for(i = 0; i < N; i++){
    132c:	46                   	inc    %esi
    132d:	83 fe 13             	cmp    $0x13,%esi
    1330:	7f 0a                	jg     133c <createdelete+0x1c5>
    for(pi = 0; pi < 4; pi++){
    1332:	bb 00 00 00 00       	mov    $0x0,%ebx
    1337:	e9 73 ff ff ff       	jmp    12af <createdelete+0x138>
    }
  }

  for(i = 0; i < N; i++){
    133c:	be 00 00 00 00       	mov    $0x0,%esi
    1341:	eb 22                	jmp    1365 <createdelete+0x1ee>
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
    1343:	8d 46 70             	lea    0x70(%esi),%eax
    1346:	88 45 d8             	mov    %al,-0x28(%ebp)
      name[1] = '0' + i;
    1349:	8d 46 30             	lea    0x30(%esi),%eax
    134c:	88 45 d9             	mov    %al,-0x27(%ebp)
      unlink(name);
    134f:	83 ec 0c             	sub    $0xc,%esp
    1352:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1355:	50                   	push   %eax
    1356:	e8 2a 29 00 00       	call   3c85 <unlink>
    for(pi = 0; pi < 4; pi++){
    135b:	43                   	inc    %ebx
    135c:	83 c4 10             	add    $0x10,%esp
    135f:	83 fb 03             	cmp    $0x3,%ebx
    1362:	7e df                	jle    1343 <createdelete+0x1cc>
  for(i = 0; i < N; i++){
    1364:	46                   	inc    %esi
    1365:	83 fe 13             	cmp    $0x13,%esi
    1368:	7f 07                	jg     1371 <createdelete+0x1fa>
    for(pi = 0; pi < 4; pi++){
    136a:	bb 00 00 00 00       	mov    $0x0,%ebx
    136f:	eb ee                	jmp    135f <createdelete+0x1e8>
    }
  }

  printf(1, "createdelete ok\n");
    1371:	83 ec 08             	sub    $0x8,%esp
    1374:	68 fb 44 00 00       	push   $0x44fb
    1379:	6a 01                	push   $0x1
    137b:	e8 08 2a 00 00       	call   3d88 <printf>
}
    1380:	83 c4 10             	add    $0x10,%esp
    1383:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1386:	5b                   	pop    %ebx
    1387:	5e                   	pop    %esi
    1388:	5d                   	pop    %ebp
    1389:	c3                   	ret

0000138a <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    138a:	55                   	push   %ebp
    138b:	89 e5                	mov    %esp,%ebp
    138d:	56                   	push   %esi
    138e:	53                   	push   %ebx
  int fd, fd1;

  printf(1, "unlinkread test\n");
    138f:	83 ec 08             	sub    $0x8,%esp
    1392:	68 0c 45 00 00       	push   $0x450c
    1397:	6a 01                	push   $0x1
    1399:	e8 ea 29 00 00       	call   3d88 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    139e:	83 c4 08             	add    $0x8,%esp
    13a1:	68 02 02 00 00       	push   $0x202
    13a6:	68 1d 45 00 00       	push   $0x451d
    13ab:	e8 c5 28 00 00       	call   3c75 <open>
  if(fd < 0){
    13b0:	83 c4 10             	add    $0x10,%esp
    13b3:	85 c0                	test   %eax,%eax
    13b5:	0f 88 f0 00 00 00    	js     14ab <unlinkread+0x121>
    13bb:	89 c3                	mov    %eax,%ebx
    printf(1, "create unlinkread failed\n");
    exit(0);
  }
  write(fd, "hello", 5);
    13bd:	83 ec 04             	sub    $0x4,%esp
    13c0:	6a 05                	push   $0x5
    13c2:	68 42 45 00 00       	push   $0x4542
    13c7:	50                   	push   %eax
    13c8:	e8 88 28 00 00       	call   3c55 <write>
  close(fd);
    13cd:	89 1c 24             	mov    %ebx,(%esp)
    13d0:	e8 88 28 00 00       	call   3c5d <close>

  fd = open("unlinkread", O_RDWR);
    13d5:	83 c4 08             	add    $0x8,%esp
    13d8:	6a 02                	push   $0x2
    13da:	68 1d 45 00 00       	push   $0x451d
    13df:	e8 91 28 00 00       	call   3c75 <open>
    13e4:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    13e6:	83 c4 10             	add    $0x10,%esp
    13e9:	85 c0                	test   %eax,%eax
    13eb:	0f 88 d5 00 00 00    	js     14c6 <unlinkread+0x13c>
    printf(1, "open unlinkread failed\n");
    exit(0);
  }
  if(unlink("unlinkread") != 0){
    13f1:	83 ec 0c             	sub    $0xc,%esp
    13f4:	68 1d 45 00 00       	push   $0x451d
    13f9:	e8 87 28 00 00       	call   3c85 <unlink>
    13fe:	83 c4 10             	add    $0x10,%esp
    1401:	85 c0                	test   %eax,%eax
    1403:	0f 85 d8 00 00 00    	jne    14e1 <unlinkread+0x157>
    printf(1, "unlink unlinkread failed\n");
    exit(0);
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1409:	83 ec 08             	sub    $0x8,%esp
    140c:	68 02 02 00 00       	push   $0x202
    1411:	68 1d 45 00 00       	push   $0x451d
    1416:	e8 5a 28 00 00       	call   3c75 <open>
    141b:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    141d:	83 c4 0c             	add    $0xc,%esp
    1420:	6a 03                	push   $0x3
    1422:	68 7a 45 00 00       	push   $0x457a
    1427:	50                   	push   %eax
    1428:	e8 28 28 00 00       	call   3c55 <write>
  close(fd1);
    142d:	89 34 24             	mov    %esi,(%esp)
    1430:	e8 28 28 00 00       	call   3c5d <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    1435:	83 c4 0c             	add    $0xc,%esp
    1438:	68 00 20 00 00       	push   $0x2000
    143d:	68 20 88 00 00       	push   $0x8820
    1442:	53                   	push   %ebx
    1443:	e8 05 28 00 00       	call   3c4d <read>
    1448:	83 c4 10             	add    $0x10,%esp
    144b:	83 f8 05             	cmp    $0x5,%eax
    144e:	0f 85 a8 00 00 00    	jne    14fc <unlinkread+0x172>
    printf(1, "unlinkread read failed");
    exit(0);
  }
  if(buf[0] != 'h'){
    1454:	80 3d 20 88 00 00 68 	cmpb   $0x68,0x8820
    145b:	0f 85 b6 00 00 00    	jne    1517 <unlinkread+0x18d>
    printf(1, "unlinkread wrong data\n");
    exit(0);
  }
  if(write(fd, buf, 10) != 10){
    1461:	83 ec 04             	sub    $0x4,%esp
    1464:	6a 0a                	push   $0xa
    1466:	68 20 88 00 00       	push   $0x8820
    146b:	53                   	push   %ebx
    146c:	e8 e4 27 00 00       	call   3c55 <write>
    1471:	83 c4 10             	add    $0x10,%esp
    1474:	83 f8 0a             	cmp    $0xa,%eax
    1477:	0f 85 b5 00 00 00    	jne    1532 <unlinkread+0x1a8>
    printf(1, "unlinkread write failed\n");
    exit(0);
  }
  close(fd);
    147d:	83 ec 0c             	sub    $0xc,%esp
    1480:	53                   	push   %ebx
    1481:	e8 d7 27 00 00       	call   3c5d <close>
  unlink("unlinkread");
    1486:	c7 04 24 1d 45 00 00 	movl   $0x451d,(%esp)
    148d:	e8 f3 27 00 00       	call   3c85 <unlink>
  printf(1, "unlinkread ok\n");
    1492:	83 c4 08             	add    $0x8,%esp
    1495:	68 c5 45 00 00       	push   $0x45c5
    149a:	6a 01                	push   $0x1
    149c:	e8 e7 28 00 00       	call   3d88 <printf>
}
    14a1:	83 c4 10             	add    $0x10,%esp
    14a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    14a7:	5b                   	pop    %ebx
    14a8:	5e                   	pop    %esi
    14a9:	5d                   	pop    %ebp
    14aa:	c3                   	ret
    printf(1, "create unlinkread failed\n");
    14ab:	83 ec 08             	sub    $0x8,%esp
    14ae:	68 28 45 00 00       	push   $0x4528
    14b3:	6a 01                	push   $0x1
    14b5:	e8 ce 28 00 00       	call   3d88 <printf>
    exit(0);
    14ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    14c1:	e8 6f 27 00 00       	call   3c35 <exit>
    printf(1, "open unlinkread failed\n");
    14c6:	83 ec 08             	sub    $0x8,%esp
    14c9:	68 48 45 00 00       	push   $0x4548
    14ce:	6a 01                	push   $0x1
    14d0:	e8 b3 28 00 00       	call   3d88 <printf>
    exit(0);
    14d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    14dc:	e8 54 27 00 00       	call   3c35 <exit>
    printf(1, "unlink unlinkread failed\n");
    14e1:	83 ec 08             	sub    $0x8,%esp
    14e4:	68 60 45 00 00       	push   $0x4560
    14e9:	6a 01                	push   $0x1
    14eb:	e8 98 28 00 00       	call   3d88 <printf>
    exit(0);
    14f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    14f7:	e8 39 27 00 00       	call   3c35 <exit>
    printf(1, "unlinkread read failed");
    14fc:	83 ec 08             	sub    $0x8,%esp
    14ff:	68 7e 45 00 00       	push   $0x457e
    1504:	6a 01                	push   $0x1
    1506:	e8 7d 28 00 00       	call   3d88 <printf>
    exit(0);
    150b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1512:	e8 1e 27 00 00       	call   3c35 <exit>
    printf(1, "unlinkread wrong data\n");
    1517:	83 ec 08             	sub    $0x8,%esp
    151a:	68 95 45 00 00       	push   $0x4595
    151f:	6a 01                	push   $0x1
    1521:	e8 62 28 00 00       	call   3d88 <printf>
    exit(0);
    1526:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    152d:	e8 03 27 00 00       	call   3c35 <exit>
    printf(1, "unlinkread write failed\n");
    1532:	83 ec 08             	sub    $0x8,%esp
    1535:	68 ac 45 00 00       	push   $0x45ac
    153a:	6a 01                	push   $0x1
    153c:	e8 47 28 00 00       	call   3d88 <printf>
    exit(0);
    1541:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1548:	e8 e8 26 00 00       	call   3c35 <exit>

0000154d <linktest>:

void
linktest(void)
{
    154d:	55                   	push   %ebp
    154e:	89 e5                	mov    %esp,%ebp
    1550:	53                   	push   %ebx
    1551:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "linktest\n");
    1554:	68 d4 45 00 00       	push   $0x45d4
    1559:	6a 01                	push   $0x1
    155b:	e8 28 28 00 00       	call   3d88 <printf>

  unlink("lf1");
    1560:	c7 04 24 de 45 00 00 	movl   $0x45de,(%esp)
    1567:	e8 19 27 00 00       	call   3c85 <unlink>
  unlink("lf2");
    156c:	c7 04 24 e2 45 00 00 	movl   $0x45e2,(%esp)
    1573:	e8 0d 27 00 00       	call   3c85 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    1578:	83 c4 08             	add    $0x8,%esp
    157b:	68 02 02 00 00       	push   $0x202
    1580:	68 de 45 00 00       	push   $0x45de
    1585:	e8 eb 26 00 00       	call   3c75 <open>
  if(fd < 0){
    158a:	83 c4 10             	add    $0x10,%esp
    158d:	85 c0                	test   %eax,%eax
    158f:	0f 88 2a 01 00 00    	js     16bf <linktest+0x172>
    1595:	89 c3                	mov    %eax,%ebx
    printf(1, "create lf1 failed\n");
    exit(0);
  }
  if(write(fd, "hello", 5) != 5){
    1597:	83 ec 04             	sub    $0x4,%esp
    159a:	6a 05                	push   $0x5
    159c:	68 42 45 00 00       	push   $0x4542
    15a1:	50                   	push   %eax
    15a2:	e8 ae 26 00 00       	call   3c55 <write>
    15a7:	83 c4 10             	add    $0x10,%esp
    15aa:	83 f8 05             	cmp    $0x5,%eax
    15ad:	0f 85 27 01 00 00    	jne    16da <linktest+0x18d>
    printf(1, "write lf1 failed\n");
    exit(0);
  }
  close(fd);
    15b3:	83 ec 0c             	sub    $0xc,%esp
    15b6:	53                   	push   %ebx
    15b7:	e8 a1 26 00 00       	call   3c5d <close>

  if(link("lf1", "lf2") < 0){
    15bc:	83 c4 08             	add    $0x8,%esp
    15bf:	68 e2 45 00 00       	push   $0x45e2
    15c4:	68 de 45 00 00       	push   $0x45de
    15c9:	e8 c7 26 00 00       	call   3c95 <link>
    15ce:	83 c4 10             	add    $0x10,%esp
    15d1:	85 c0                	test   %eax,%eax
    15d3:	0f 88 1c 01 00 00    	js     16f5 <linktest+0x1a8>
    printf(1, "link lf1 lf2 failed\n");
    exit(0);
  }
  unlink("lf1");
    15d9:	83 ec 0c             	sub    $0xc,%esp
    15dc:	68 de 45 00 00       	push   $0x45de
    15e1:	e8 9f 26 00 00       	call   3c85 <unlink>

  if(open("lf1", 0) >= 0){
    15e6:	83 c4 08             	add    $0x8,%esp
    15e9:	6a 00                	push   $0x0
    15eb:	68 de 45 00 00       	push   $0x45de
    15f0:	e8 80 26 00 00       	call   3c75 <open>
    15f5:	83 c4 10             	add    $0x10,%esp
    15f8:	85 c0                	test   %eax,%eax
    15fa:	0f 89 10 01 00 00    	jns    1710 <linktest+0x1c3>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit(0);
  }

  fd = open("lf2", 0);
    1600:	83 ec 08             	sub    $0x8,%esp
    1603:	6a 00                	push   $0x0
    1605:	68 e2 45 00 00       	push   $0x45e2
    160a:	e8 66 26 00 00       	call   3c75 <open>
    160f:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1611:	83 c4 10             	add    $0x10,%esp
    1614:	85 c0                	test   %eax,%eax
    1616:	0f 88 0f 01 00 00    	js     172b <linktest+0x1de>
    printf(1, "open lf2 failed\n");
    exit(0);
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    161c:	83 ec 04             	sub    $0x4,%esp
    161f:	68 00 20 00 00       	push   $0x2000
    1624:	68 20 88 00 00       	push   $0x8820
    1629:	50                   	push   %eax
    162a:	e8 1e 26 00 00       	call   3c4d <read>
    162f:	83 c4 10             	add    $0x10,%esp
    1632:	83 f8 05             	cmp    $0x5,%eax
    1635:	0f 85 0b 01 00 00    	jne    1746 <linktest+0x1f9>
    printf(1, "read lf2 failed\n");
    exit(0);
  }
  close(fd);
    163b:	83 ec 0c             	sub    $0xc,%esp
    163e:	53                   	push   %ebx
    163f:	e8 19 26 00 00       	call   3c5d <close>

  if(link("lf2", "lf2") >= 0){
    1644:	83 c4 08             	add    $0x8,%esp
    1647:	68 e2 45 00 00       	push   $0x45e2
    164c:	68 e2 45 00 00       	push   $0x45e2
    1651:	e8 3f 26 00 00       	call   3c95 <link>
    1656:	83 c4 10             	add    $0x10,%esp
    1659:	85 c0                	test   %eax,%eax
    165b:	0f 89 00 01 00 00    	jns    1761 <linktest+0x214>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit(0);
  }

  unlink("lf2");
    1661:	83 ec 0c             	sub    $0xc,%esp
    1664:	68 e2 45 00 00       	push   $0x45e2
    1669:	e8 17 26 00 00       	call   3c85 <unlink>
  if(link("lf2", "lf1") >= 0){
    166e:	83 c4 08             	add    $0x8,%esp
    1671:	68 de 45 00 00       	push   $0x45de
    1676:	68 e2 45 00 00       	push   $0x45e2
    167b:	e8 15 26 00 00       	call   3c95 <link>
    1680:	83 c4 10             	add    $0x10,%esp
    1683:	85 c0                	test   %eax,%eax
    1685:	0f 89 f1 00 00 00    	jns    177c <linktest+0x22f>
    printf(1, "link non-existant succeeded! oops\n");
    exit(0);
  }

  if(link(".", "lf1") >= 0){
    168b:	83 ec 08             	sub    $0x8,%esp
    168e:	68 de 45 00 00       	push   $0x45de
    1693:	68 a6 48 00 00       	push   $0x48a6
    1698:	e8 f8 25 00 00       	call   3c95 <link>
    169d:	83 c4 10             	add    $0x10,%esp
    16a0:	85 c0                	test   %eax,%eax
    16a2:	0f 89 ef 00 00 00    	jns    1797 <linktest+0x24a>
    printf(1, "link . lf1 succeeded! oops\n");
    exit(0);
  }

  printf(1, "linktest ok\n");
    16a8:	83 ec 08             	sub    $0x8,%esp
    16ab:	68 7c 46 00 00       	push   $0x467c
    16b0:	6a 01                	push   $0x1
    16b2:	e8 d1 26 00 00       	call   3d88 <printf>
}
    16b7:	83 c4 10             	add    $0x10,%esp
    16ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    16bd:	c9                   	leave
    16be:	c3                   	ret
    printf(1, "create lf1 failed\n");
    16bf:	83 ec 08             	sub    $0x8,%esp
    16c2:	68 e6 45 00 00       	push   $0x45e6
    16c7:	6a 01                	push   $0x1
    16c9:	e8 ba 26 00 00       	call   3d88 <printf>
    exit(0);
    16ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    16d5:	e8 5b 25 00 00       	call   3c35 <exit>
    printf(1, "write lf1 failed\n");
    16da:	83 ec 08             	sub    $0x8,%esp
    16dd:	68 f9 45 00 00       	push   $0x45f9
    16e2:	6a 01                	push   $0x1
    16e4:	e8 9f 26 00 00       	call   3d88 <printf>
    exit(0);
    16e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    16f0:	e8 40 25 00 00       	call   3c35 <exit>
    printf(1, "link lf1 lf2 failed\n");
    16f5:	83 ec 08             	sub    $0x8,%esp
    16f8:	68 0b 46 00 00       	push   $0x460b
    16fd:	6a 01                	push   $0x1
    16ff:	e8 84 26 00 00       	call   3d88 <printf>
    exit(0);
    1704:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    170b:	e8 25 25 00 00       	call   3c35 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    1710:	83 ec 08             	sub    $0x8,%esp
    1713:	68 f4 51 00 00       	push   $0x51f4
    1718:	6a 01                	push   $0x1
    171a:	e8 69 26 00 00       	call   3d88 <printf>
    exit(0);
    171f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1726:	e8 0a 25 00 00       	call   3c35 <exit>
    printf(1, "open lf2 failed\n");
    172b:	83 ec 08             	sub    $0x8,%esp
    172e:	68 20 46 00 00       	push   $0x4620
    1733:	6a 01                	push   $0x1
    1735:	e8 4e 26 00 00       	call   3d88 <printf>
    exit(0);
    173a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1741:	e8 ef 24 00 00       	call   3c35 <exit>
    printf(1, "read lf2 failed\n");
    1746:	83 ec 08             	sub    $0x8,%esp
    1749:	68 31 46 00 00       	push   $0x4631
    174e:	6a 01                	push   $0x1
    1750:	e8 33 26 00 00       	call   3d88 <printf>
    exit(0);
    1755:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    175c:	e8 d4 24 00 00       	call   3c35 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1761:	83 ec 08             	sub    $0x8,%esp
    1764:	68 42 46 00 00       	push   $0x4642
    1769:	6a 01                	push   $0x1
    176b:	e8 18 26 00 00       	call   3d88 <printf>
    exit(0);
    1770:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1777:	e8 b9 24 00 00       	call   3c35 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    177c:	83 ec 08             	sub    $0x8,%esp
    177f:	68 1c 52 00 00       	push   $0x521c
    1784:	6a 01                	push   $0x1
    1786:	e8 fd 25 00 00       	call   3d88 <printf>
    exit(0);
    178b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1792:	e8 9e 24 00 00       	call   3c35 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    1797:	83 ec 08             	sub    $0x8,%esp
    179a:	68 60 46 00 00       	push   $0x4660
    179f:	6a 01                	push   $0x1
    17a1:	e8 e2 25 00 00       	call   3d88 <printf>
    exit(0);
    17a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    17ad:	e8 83 24 00 00       	call   3c35 <exit>

000017b2 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    17b2:	55                   	push   %ebp
    17b3:	89 e5                	mov    %esp,%ebp
    17b5:	57                   	push   %edi
    17b6:	56                   	push   %esi
    17b7:	53                   	push   %ebx
    17b8:	83 ec 54             	sub    $0x54,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    17bb:	68 89 46 00 00       	push   $0x4689
    17c0:	6a 01                	push   $0x1
    17c2:	e8 c1 25 00 00       	call   3d88 <printf>
  file[0] = 'C';
    17c7:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    17cb:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    17cf:	83 c4 10             	add    $0x10,%esp
    17d2:	bb 00 00 00 00       	mov    $0x0,%ebx
    17d7:	eb 51                	jmp    182a <concreate+0x78>
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
    17d9:	b9 05 00 00 00       	mov    $0x5,%ecx
    17de:	89 d8                	mov    %ebx,%eax
    17e0:	99                   	cltd
    17e1:	f7 f9                	idiv   %ecx
    17e3:	83 fa 01             	cmp    $0x1,%edx
    17e6:	0f 84 8c 00 00 00    	je     1878 <concreate+0xc6>
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    17ec:	83 ec 08             	sub    $0x8,%esp
    17ef:	68 02 02 00 00       	push   $0x202
    17f4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    17f7:	50                   	push   %eax
    17f8:	e8 78 24 00 00       	call   3c75 <open>
      if(fd < 0){
    17fd:	83 c4 10             	add    $0x10,%esp
    1800:	85 c0                	test   %eax,%eax
    1802:	0f 88 86 00 00 00    	js     188e <concreate+0xdc>
        printf(1, "concreate create %s failed\n", file);
        exit(0);
      }
      close(fd);
    1808:	83 ec 0c             	sub    $0xc,%esp
    180b:	50                   	push   %eax
    180c:	e8 4c 24 00 00       	call   3c5d <close>
    1811:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1814:	85 f6                	test   %esi,%esi
    1816:	0f 84 91 00 00 00    	je     18ad <concreate+0xfb>
      exit(0);
    else
      wait(NULL);
    181c:	83 ec 0c             	sub    $0xc,%esp
    181f:	6a 00                	push   $0x0
    1821:	e8 17 24 00 00       	call   3c3d <wait>
  for(i = 0; i < 40; i++){
    1826:	43                   	inc    %ebx
    1827:	83 c4 10             	add    $0x10,%esp
    182a:	83 fb 27             	cmp    $0x27,%ebx
    182d:	0f 8f 84 00 00 00    	jg     18b7 <concreate+0x105>
    file[1] = '0' + i;
    1833:	8d 43 30             	lea    0x30(%ebx),%eax
    1836:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    1839:	83 ec 0c             	sub    $0xc,%esp
    183c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    183f:	50                   	push   %eax
    1840:	e8 40 24 00 00       	call   3c85 <unlink>
    pid = fork();
    1845:	e8 e3 23 00 00       	call   3c2d <fork>
    184a:	89 c6                	mov    %eax,%esi
    if(pid && (i % 3) == 1){
    184c:	83 c4 10             	add    $0x10,%esp
    184f:	85 c0                	test   %eax,%eax
    1851:	74 86                	je     17d9 <concreate+0x27>
    1853:	b9 03 00 00 00       	mov    $0x3,%ecx
    1858:	89 d8                	mov    %ebx,%eax
    185a:	99                   	cltd
    185b:	f7 f9                	idiv   %ecx
    185d:	83 fa 01             	cmp    $0x1,%edx
    1860:	75 8a                	jne    17ec <concreate+0x3a>
      link("C0", file);
    1862:	83 ec 08             	sub    $0x8,%esp
    1865:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1868:	50                   	push   %eax
    1869:	68 99 46 00 00       	push   $0x4699
    186e:	e8 22 24 00 00       	call   3c95 <link>
    1873:	83 c4 10             	add    $0x10,%esp
    1876:	eb 9c                	jmp    1814 <concreate+0x62>
      link("C0", file);
    1878:	83 ec 08             	sub    $0x8,%esp
    187b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    187e:	50                   	push   %eax
    187f:	68 99 46 00 00       	push   $0x4699
    1884:	e8 0c 24 00 00       	call   3c95 <link>
    1889:	83 c4 10             	add    $0x10,%esp
    188c:	eb 86                	jmp    1814 <concreate+0x62>
        printf(1, "concreate create %s failed\n", file);
    188e:	83 ec 04             	sub    $0x4,%esp
    1891:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1894:	50                   	push   %eax
    1895:	68 9c 46 00 00       	push   $0x469c
    189a:	6a 01                	push   $0x1
    189c:	e8 e7 24 00 00       	call   3d88 <printf>
        exit(0);
    18a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    18a8:	e8 88 23 00 00       	call   3c35 <exit>
      exit(0);
    18ad:	83 ec 0c             	sub    $0xc,%esp
    18b0:	6a 00                	push   $0x0
    18b2:	e8 7e 23 00 00       	call   3c35 <exit>
  }

  memset(fa, 0, sizeof(fa));
    18b7:	83 ec 04             	sub    $0x4,%esp
    18ba:	6a 28                	push   $0x28
    18bc:	6a 00                	push   $0x0
    18be:	8d 45 bd             	lea    -0x43(%ebp),%eax
    18c1:	50                   	push   %eax
    18c2:	e8 43 22 00 00       	call   3b0a <memset>
  fd = open(".", 0);
    18c7:	83 c4 08             	add    $0x8,%esp
    18ca:	6a 00                	push   $0x0
    18cc:	68 a6 48 00 00       	push   $0x48a6
    18d1:	e8 9f 23 00 00       	call   3c75 <open>
    18d6:	89 c3                	mov    %eax,%ebx
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    18d8:	83 c4 10             	add    $0x10,%esp
  n = 0;
    18db:	be 00 00 00 00       	mov    $0x0,%esi
  while(read(fd, &de, sizeof(de)) > 0){
    18e0:	83 ec 04             	sub    $0x4,%esp
    18e3:	6a 10                	push   $0x10
    18e5:	8d 45 ac             	lea    -0x54(%ebp),%eax
    18e8:	50                   	push   %eax
    18e9:	53                   	push   %ebx
    18ea:	e8 5e 23 00 00       	call   3c4d <read>
    18ef:	83 c4 10             	add    $0x10,%esp
    18f2:	85 c0                	test   %eax,%eax
    18f4:	7e 6c                	jle    1962 <concreate+0x1b0>
    if(de.inum == 0)
    18f6:	66 83 7d ac 00       	cmpw   $0x0,-0x54(%ebp)
    18fb:	74 e3                	je     18e0 <concreate+0x12e>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    18fd:	80 7d ae 43          	cmpb   $0x43,-0x52(%ebp)
    1901:	75 dd                	jne    18e0 <concreate+0x12e>
    1903:	80 7d b0 00          	cmpb   $0x0,-0x50(%ebp)
    1907:	75 d7                	jne    18e0 <concreate+0x12e>
      i = de.name[1] - '0';
    1909:	0f be 45 af          	movsbl -0x51(%ebp),%eax
    190d:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    1910:	83 f8 27             	cmp    $0x27,%eax
    1913:	77 0f                	ja     1924 <concreate+0x172>
        printf(1, "concreate weird file %s\n", de.name);
        exit(0);
      }
      if(fa[i]){
    1915:	80 7c 05 bd 00       	cmpb   $0x0,-0x43(%ebp,%eax,1)
    191a:	75 27                	jne    1943 <concreate+0x191>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit(0);
      }
      fa[i] = 1;
    191c:	c6 44 05 bd 01       	movb   $0x1,-0x43(%ebp,%eax,1)
      n++;
    1921:	46                   	inc    %esi
    1922:	eb bc                	jmp    18e0 <concreate+0x12e>
        printf(1, "concreate weird file %s\n", de.name);
    1924:	83 ec 04             	sub    $0x4,%esp
    1927:	8d 45 ae             	lea    -0x52(%ebp),%eax
    192a:	50                   	push   %eax
    192b:	68 b8 46 00 00       	push   $0x46b8
    1930:	6a 01                	push   $0x1
    1932:	e8 51 24 00 00       	call   3d88 <printf>
        exit(0);
    1937:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    193e:	e8 f2 22 00 00       	call   3c35 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    1943:	83 ec 04             	sub    $0x4,%esp
    1946:	8d 45 ae             	lea    -0x52(%ebp),%eax
    1949:	50                   	push   %eax
    194a:	68 d1 46 00 00       	push   $0x46d1
    194f:	6a 01                	push   $0x1
    1951:	e8 32 24 00 00       	call   3d88 <printf>
        exit(0);
    1956:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    195d:	e8 d3 22 00 00       	call   3c35 <exit>
    }
  }
  close(fd);
    1962:	83 ec 0c             	sub    $0xc,%esp
    1965:	53                   	push   %ebx
    1966:	e8 f2 22 00 00       	call   3c5d <close>

  if(n != 40){
    196b:	83 c4 10             	add    $0x10,%esp
    196e:	83 fe 28             	cmp    $0x28,%esi
    1971:	75 07                	jne    197a <concreate+0x1c8>
    printf(1, "concreate not enough files in directory listing\n");
    exit(0);
  }

  for(i = 0; i < 40; i++){
    1973:	bb 00 00 00 00       	mov    $0x0,%ebx
    1978:	eb 73                	jmp    19ed <concreate+0x23b>
    printf(1, "concreate not enough files in directory listing\n");
    197a:	83 ec 08             	sub    $0x8,%esp
    197d:	68 40 52 00 00       	push   $0x5240
    1982:	6a 01                	push   $0x1
    1984:	e8 ff 23 00 00       	call   3d88 <printf>
    exit(0);
    1989:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1990:	e8 a0 22 00 00       	call   3c35 <exit>
    file[1] = '0' + i;
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
    1995:	83 ec 08             	sub    $0x8,%esp
    1998:	68 71 4f 00 00       	push   $0x4f71
    199d:	6a 01                	push   $0x1
    199f:	e8 e4 23 00 00       	call   3d88 <printf>
      exit(0);
    19a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    19ab:	e8 85 22 00 00       	call   3c35 <exit>
      close(open(file, 0));
      close(open(file, 0));
      close(open(file, 0));
      close(open(file, 0));
    } else {
      unlink(file);
    19b0:	83 ec 0c             	sub    $0xc,%esp
    19b3:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    19b6:	57                   	push   %edi
    19b7:	e8 c9 22 00 00       	call   3c85 <unlink>
      unlink(file);
    19bc:	89 3c 24             	mov    %edi,(%esp)
    19bf:	e8 c1 22 00 00       	call   3c85 <unlink>
      unlink(file);
    19c4:	89 3c 24             	mov    %edi,(%esp)
    19c7:	e8 b9 22 00 00       	call   3c85 <unlink>
      unlink(file);
    19cc:	89 3c 24             	mov    %edi,(%esp)
    19cf:	e8 b1 22 00 00       	call   3c85 <unlink>
    19d4:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    19d7:	85 f6                	test   %esi,%esi
    19d9:	0f 84 9a 00 00 00    	je     1a79 <concreate+0x2c7>
      exit(0);
    else
      wait(NULL);
    19df:	83 ec 0c             	sub    $0xc,%esp
    19e2:	6a 00                	push   $0x0
    19e4:	e8 54 22 00 00       	call   3c3d <wait>
  for(i = 0; i < 40; i++){
    19e9:	43                   	inc    %ebx
    19ea:	83 c4 10             	add    $0x10,%esp
    19ed:	83 fb 27             	cmp    $0x27,%ebx
    19f0:	0f 8f 8d 00 00 00    	jg     1a83 <concreate+0x2d1>
    file[1] = '0' + i;
    19f6:	8d 43 30             	lea    0x30(%ebx),%eax
    19f9:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    19fc:	e8 2c 22 00 00       	call   3c2d <fork>
    1a01:	89 c6                	mov    %eax,%esi
    if(pid < 0){
    1a03:	85 c0                	test   %eax,%eax
    1a05:	78 8e                	js     1995 <concreate+0x1e3>
    if(((i % 3) == 0 && pid == 0) ||
    1a07:	b9 03 00 00 00       	mov    $0x3,%ecx
    1a0c:	89 d8                	mov    %ebx,%eax
    1a0e:	99                   	cltd
    1a0f:	f7 f9                	idiv   %ecx
    1a11:	85 d2                	test   %edx,%edx
    1a13:	75 04                	jne    1a19 <concreate+0x267>
    1a15:	85 f6                	test   %esi,%esi
    1a17:	74 09                	je     1a22 <concreate+0x270>
    1a19:	83 fa 01             	cmp    $0x1,%edx
    1a1c:	75 92                	jne    19b0 <concreate+0x1fe>
       ((i % 3) == 1 && pid != 0)){
    1a1e:	85 f6                	test   %esi,%esi
    1a20:	74 8e                	je     19b0 <concreate+0x1fe>
      close(open(file, 0));
    1a22:	83 ec 08             	sub    $0x8,%esp
    1a25:	6a 00                	push   $0x0
    1a27:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    1a2a:	57                   	push   %edi
    1a2b:	e8 45 22 00 00       	call   3c75 <open>
    1a30:	89 04 24             	mov    %eax,(%esp)
    1a33:	e8 25 22 00 00       	call   3c5d <close>
      close(open(file, 0));
    1a38:	83 c4 08             	add    $0x8,%esp
    1a3b:	6a 00                	push   $0x0
    1a3d:	57                   	push   %edi
    1a3e:	e8 32 22 00 00       	call   3c75 <open>
    1a43:	89 04 24             	mov    %eax,(%esp)
    1a46:	e8 12 22 00 00       	call   3c5d <close>
      close(open(file, 0));
    1a4b:	83 c4 08             	add    $0x8,%esp
    1a4e:	6a 00                	push   $0x0
    1a50:	57                   	push   %edi
    1a51:	e8 1f 22 00 00       	call   3c75 <open>
    1a56:	89 04 24             	mov    %eax,(%esp)
    1a59:	e8 ff 21 00 00       	call   3c5d <close>
      close(open(file, 0));
    1a5e:	83 c4 08             	add    $0x8,%esp
    1a61:	6a 00                	push   $0x0
    1a63:	57                   	push   %edi
    1a64:	e8 0c 22 00 00       	call   3c75 <open>
    1a69:	89 04 24             	mov    %eax,(%esp)
    1a6c:	e8 ec 21 00 00       	call   3c5d <close>
    1a71:	83 c4 10             	add    $0x10,%esp
    1a74:	e9 5e ff ff ff       	jmp    19d7 <concreate+0x225>
      exit(0);
    1a79:	83 ec 0c             	sub    $0xc,%esp
    1a7c:	6a 00                	push   $0x0
    1a7e:	e8 b2 21 00 00       	call   3c35 <exit>
  }

  printf(1, "concreate ok\n");
    1a83:	83 ec 08             	sub    $0x8,%esp
    1a86:	68 ee 46 00 00       	push   $0x46ee
    1a8b:	6a 01                	push   $0x1
    1a8d:	e8 f6 22 00 00       	call   3d88 <printf>
}
    1a92:	83 c4 10             	add    $0x10,%esp
    1a95:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1a98:	5b                   	pop    %ebx
    1a99:	5e                   	pop    %esi
    1a9a:	5f                   	pop    %edi
    1a9b:	5d                   	pop    %ebp
    1a9c:	c3                   	ret

00001a9d <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1a9d:	55                   	push   %ebp
    1a9e:	89 e5                	mov    %esp,%ebp
    1aa0:	57                   	push   %edi
    1aa1:	56                   	push   %esi
    1aa2:	53                   	push   %ebx
    1aa3:	83 ec 14             	sub    $0x14,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1aa6:	68 fc 46 00 00       	push   $0x46fc
    1aab:	6a 01                	push   $0x1
    1aad:	e8 d6 22 00 00       	call   3d88 <printf>

  unlink("x");
    1ab2:	c7 04 24 89 49 00 00 	movl   $0x4989,(%esp)
    1ab9:	e8 c7 21 00 00       	call   3c85 <unlink>
  pid = fork();
    1abe:	e8 6a 21 00 00       	call   3c2d <fork>
  if(pid < 0){
    1ac3:	83 c4 10             	add    $0x10,%esp
    1ac6:	85 c0                	test   %eax,%eax
    1ac8:	78 10                	js     1ada <linkunlink+0x3d>
    1aca:	89 c7                	mov    %eax,%edi
    printf(1, "fork failed\n");
    exit(0);
  }

  unsigned int x = (pid ? 1 : 97);
    1acc:	74 27                	je     1af5 <linkunlink+0x58>
    1ace:	bb 01 00 00 00       	mov    $0x1,%ebx
    1ad3:	be 00 00 00 00       	mov    $0x0,%esi
    1ad8:	eb 40                	jmp    1b1a <linkunlink+0x7d>
    printf(1, "fork failed\n");
    1ada:	83 ec 08             	sub    $0x8,%esp
    1add:	68 71 4f 00 00       	push   $0x4f71
    1ae2:	6a 01                	push   $0x1
    1ae4:	e8 9f 22 00 00       	call   3d88 <printf>
    exit(0);
    1ae9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1af0:	e8 40 21 00 00       	call   3c35 <exit>
  unsigned int x = (pid ? 1 : 97);
    1af5:	bb 61 00 00 00       	mov    $0x61,%ebx
    1afa:	eb d7                	jmp    1ad3 <linkunlink+0x36>
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
      close(open("x", O_RDWR | O_CREATE));
    1afc:	83 ec 08             	sub    $0x8,%esp
    1aff:	68 02 02 00 00       	push   $0x202
    1b04:	68 89 49 00 00       	push   $0x4989
    1b09:	e8 67 21 00 00       	call   3c75 <open>
    1b0e:	89 04 24             	mov    %eax,(%esp)
    1b11:	e8 47 21 00 00       	call   3c5d <close>
    1b16:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1b19:	46                   	inc    %esi
    1b1a:	83 fe 63             	cmp    $0x63,%esi
    1b1d:	7f 68                	jg     1b87 <linkunlink+0xea>
    x = x * 1103515245 + 12345;
    1b1f:	89 d8                	mov    %ebx,%eax
    1b21:	c1 e0 09             	shl    $0x9,%eax
    1b24:	29 d8                	sub    %ebx,%eax
    1b26:	8d 14 83             	lea    (%ebx,%eax,4),%edx
    1b29:	89 d0                	mov    %edx,%eax
    1b2b:	c1 e0 09             	shl    $0x9,%eax
    1b2e:	29 d0                	sub    %edx,%eax
    1b30:	01 c0                	add    %eax,%eax
    1b32:	01 d8                	add    %ebx,%eax
    1b34:	89 c2                	mov    %eax,%edx
    1b36:	c1 e2 05             	shl    $0x5,%edx
    1b39:	01 d0                	add    %edx,%eax
    1b3b:	c1 e0 02             	shl    $0x2,%eax
    1b3e:	29 d8                	sub    %ebx,%eax
    1b40:	8d 9c 83 39 30 00 00 	lea    0x3039(%ebx,%eax,4),%ebx
    if((x % 3) == 0){
    1b47:	b9 03 00 00 00       	mov    $0x3,%ecx
    1b4c:	89 d8                	mov    %ebx,%eax
    1b4e:	ba 00 00 00 00       	mov    $0x0,%edx
    1b53:	f7 f1                	div    %ecx
    1b55:	85 d2                	test   %edx,%edx
    1b57:	74 a3                	je     1afc <linkunlink+0x5f>
    } else if((x % 3) == 1){
    1b59:	83 fa 01             	cmp    $0x1,%edx
    1b5c:	74 12                	je     1b70 <linkunlink+0xd3>
      link("cat", "x");
    } else {
      unlink("x");
    1b5e:	83 ec 0c             	sub    $0xc,%esp
    1b61:	68 89 49 00 00       	push   $0x4989
    1b66:	e8 1a 21 00 00       	call   3c85 <unlink>
    1b6b:	83 c4 10             	add    $0x10,%esp
    1b6e:	eb a9                	jmp    1b19 <linkunlink+0x7c>
      link("cat", "x");
    1b70:	83 ec 08             	sub    $0x8,%esp
    1b73:	68 89 49 00 00       	push   $0x4989
    1b78:	68 0d 47 00 00       	push   $0x470d
    1b7d:	e8 13 21 00 00       	call   3c95 <link>
    1b82:	83 c4 10             	add    $0x10,%esp
    1b85:	eb 92                	jmp    1b19 <linkunlink+0x7c>
    }
  }

  if(pid)
    1b87:	85 ff                	test   %edi,%edi
    1b89:	74 21                	je     1bac <linkunlink+0x10f>
    wait(NULL);
    1b8b:	83 ec 0c             	sub    $0xc,%esp
    1b8e:	6a 00                	push   $0x0
    1b90:	e8 a8 20 00 00       	call   3c3d <wait>
  else
    exit(0);

  printf(1, "linkunlink ok\n");
    1b95:	83 c4 08             	add    $0x8,%esp
    1b98:	68 11 47 00 00       	push   $0x4711
    1b9d:	6a 01                	push   $0x1
    1b9f:	e8 e4 21 00 00       	call   3d88 <printf>
}
    1ba4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1ba7:	5b                   	pop    %ebx
    1ba8:	5e                   	pop    %esi
    1ba9:	5f                   	pop    %edi
    1baa:	5d                   	pop    %ebp
    1bab:	c3                   	ret
    exit(0);
    1bac:	83 ec 0c             	sub    $0xc,%esp
    1baf:	6a 00                	push   $0x0
    1bb1:	e8 7f 20 00 00       	call   3c35 <exit>

00001bb6 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1bb6:	55                   	push   %ebp
    1bb7:	89 e5                	mov    %esp,%ebp
    1bb9:	53                   	push   %ebx
    1bba:	83 ec 1c             	sub    $0x1c,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1bbd:	68 20 47 00 00       	push   $0x4720
    1bc2:	6a 01                	push   $0x1
    1bc4:	e8 bf 21 00 00       	call   3d88 <printf>
  unlink("bd");
    1bc9:	c7 04 24 2d 47 00 00 	movl   $0x472d,(%esp)
    1bd0:	e8 b0 20 00 00       	call   3c85 <unlink>

  fd = open("bd", O_CREATE);
    1bd5:	83 c4 08             	add    $0x8,%esp
    1bd8:	68 00 02 00 00       	push   $0x200
    1bdd:	68 2d 47 00 00       	push   $0x472d
    1be2:	e8 8e 20 00 00       	call   3c75 <open>
  if(fd < 0){
    1be7:	83 c4 10             	add    $0x10,%esp
    1bea:	85 c0                	test   %eax,%eax
    1bec:	78 13                	js     1c01 <bigdir+0x4b>
    printf(1, "bigdir create failed\n");
    exit(0);
  }
  close(fd);
    1bee:	83 ec 0c             	sub    $0xc,%esp
    1bf1:	50                   	push   %eax
    1bf2:	e8 66 20 00 00       	call   3c5d <close>

  for(i = 0; i < 500; i++){
    1bf7:	83 c4 10             	add    $0x10,%esp
    1bfa:	bb 00 00 00 00       	mov    $0x0,%ebx
    1bff:	eb 43                	jmp    1c44 <bigdir+0x8e>
    printf(1, "bigdir create failed\n");
    1c01:	83 ec 08             	sub    $0x8,%esp
    1c04:	68 30 47 00 00       	push   $0x4730
    1c09:	6a 01                	push   $0x1
    1c0b:	e8 78 21 00 00       	call   3d88 <printf>
    exit(0);
    1c10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1c17:	e8 19 20 00 00       	call   3c35 <exit>
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    1c1c:	8d 43 3f             	lea    0x3f(%ebx),%eax
    1c1f:	eb 35                	jmp    1c56 <bigdir+0xa0>
    name[2] = '0' + (i % 64);
    1c21:	83 c0 30             	add    $0x30,%eax
    1c24:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1c27:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(link("bd", name) != 0){
    1c2b:	83 ec 08             	sub    $0x8,%esp
    1c2e:	8d 45 ee             	lea    -0x12(%ebp),%eax
    1c31:	50                   	push   %eax
    1c32:	68 2d 47 00 00       	push   $0x472d
    1c37:	e8 59 20 00 00       	call   3c95 <link>
    1c3c:	83 c4 10             	add    $0x10,%esp
    1c3f:	85 c0                	test   %eax,%eax
    1c41:	75 2c                	jne    1c6f <bigdir+0xb9>
  for(i = 0; i < 500; i++){
    1c43:	43                   	inc    %ebx
    1c44:	81 fb f3 01 00 00    	cmp    $0x1f3,%ebx
    1c4a:	7f 3e                	jg     1c8a <bigdir+0xd4>
    name[0] = 'x';
    1c4c:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    1c50:	89 d8                	mov    %ebx,%eax
    1c52:	85 db                	test   %ebx,%ebx
    1c54:	78 c6                	js     1c1c <bigdir+0x66>
    1c56:	c1 f8 06             	sar    $0x6,%eax
    1c59:	83 c0 30             	add    $0x30,%eax
    1c5c:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    1c5f:	89 d8                	mov    %ebx,%eax
    1c61:	25 3f 00 00 80       	and    $0x8000003f,%eax
    1c66:	79 b9                	jns    1c21 <bigdir+0x6b>
    1c68:	48                   	dec    %eax
    1c69:	83 c8 c0             	or     $0xffffffc0,%eax
    1c6c:	40                   	inc    %eax
    1c6d:	eb b2                	jmp    1c21 <bigdir+0x6b>
      printf(1, "bigdir link failed\n");
    1c6f:	83 ec 08             	sub    $0x8,%esp
    1c72:	68 46 47 00 00       	push   $0x4746
    1c77:	6a 01                	push   $0x1
    1c79:	e8 0a 21 00 00       	call   3d88 <printf>
      exit(0);
    1c7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1c85:	e8 ab 1f 00 00       	call   3c35 <exit>
    }
  }

  unlink("bd");
    1c8a:	83 ec 0c             	sub    $0xc,%esp
    1c8d:	68 2d 47 00 00       	push   $0x472d
    1c92:	e8 ee 1f 00 00       	call   3c85 <unlink>
  for(i = 0; i < 500; i++){
    1c97:	83 c4 10             	add    $0x10,%esp
    1c9a:	bb 00 00 00 00       	mov    $0x0,%ebx
    1c9f:	eb 23                	jmp    1cc4 <bigdir+0x10e>
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    1ca1:	8d 43 3f             	lea    0x3f(%ebx),%eax
    1ca4:	eb 30                	jmp    1cd6 <bigdir+0x120>
    name[2] = '0' + (i % 64);
    1ca6:	83 c0 30             	add    $0x30,%eax
    1ca9:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1cac:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(unlink(name) != 0){
    1cb0:	83 ec 0c             	sub    $0xc,%esp
    1cb3:	8d 45 ee             	lea    -0x12(%ebp),%eax
    1cb6:	50                   	push   %eax
    1cb7:	e8 c9 1f 00 00       	call   3c85 <unlink>
    1cbc:	83 c4 10             	add    $0x10,%esp
    1cbf:	85 c0                	test   %eax,%eax
    1cc1:	75 2c                	jne    1cef <bigdir+0x139>
  for(i = 0; i < 500; i++){
    1cc3:	43                   	inc    %ebx
    1cc4:	81 fb f3 01 00 00    	cmp    $0x1f3,%ebx
    1cca:	7f 3e                	jg     1d0a <bigdir+0x154>
    name[0] = 'x';
    1ccc:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    1cd0:	89 d8                	mov    %ebx,%eax
    1cd2:	85 db                	test   %ebx,%ebx
    1cd4:	78 cb                	js     1ca1 <bigdir+0xeb>
    1cd6:	c1 f8 06             	sar    $0x6,%eax
    1cd9:	83 c0 30             	add    $0x30,%eax
    1cdc:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    1cdf:	89 d8                	mov    %ebx,%eax
    1ce1:	25 3f 00 00 80       	and    $0x8000003f,%eax
    1ce6:	79 be                	jns    1ca6 <bigdir+0xf0>
    1ce8:	48                   	dec    %eax
    1ce9:	83 c8 c0             	or     $0xffffffc0,%eax
    1cec:	40                   	inc    %eax
    1ced:	eb b7                	jmp    1ca6 <bigdir+0xf0>
      printf(1, "bigdir unlink failed");
    1cef:	83 ec 08             	sub    $0x8,%esp
    1cf2:	68 5a 47 00 00       	push   $0x475a
    1cf7:	6a 01                	push   $0x1
    1cf9:	e8 8a 20 00 00       	call   3d88 <printf>
      exit(0);
    1cfe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1d05:	e8 2b 1f 00 00       	call   3c35 <exit>
    }
  }

  printf(1, "bigdir ok\n");
    1d0a:	83 ec 08             	sub    $0x8,%esp
    1d0d:	68 6f 47 00 00       	push   $0x476f
    1d12:	6a 01                	push   $0x1
    1d14:	e8 6f 20 00 00       	call   3d88 <printf>
}
    1d19:	83 c4 10             	add    $0x10,%esp
    1d1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1d1f:	c9                   	leave
    1d20:	c3                   	ret

00001d21 <subdir>:

void
subdir(void)
{
    1d21:	55                   	push   %ebp
    1d22:	89 e5                	mov    %esp,%ebp
    1d24:	53                   	push   %ebx
    1d25:	83 ec 0c             	sub    $0xc,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1d28:	68 7a 47 00 00       	push   $0x477a
    1d2d:	6a 01                	push   $0x1
    1d2f:	e8 54 20 00 00       	call   3d88 <printf>

  unlink("ff");
    1d34:	c7 04 24 03 48 00 00 	movl   $0x4803,(%esp)
    1d3b:	e8 45 1f 00 00       	call   3c85 <unlink>
  if(mkdir("dd") != 0){
    1d40:	c7 04 24 a0 48 00 00 	movl   $0x48a0,(%esp)
    1d47:	e8 51 1f 00 00       	call   3c9d <mkdir>
    1d4c:	83 c4 10             	add    $0x10,%esp
    1d4f:	85 c0                	test   %eax,%eax
    1d51:	0f 85 14 04 00 00    	jne    216b <subdir+0x44a>
    printf(1, "subdir mkdir dd failed\n");
    exit(0);
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1d57:	83 ec 08             	sub    $0x8,%esp
    1d5a:	68 02 02 00 00       	push   $0x202
    1d5f:	68 d9 47 00 00       	push   $0x47d9
    1d64:	e8 0c 1f 00 00       	call   3c75 <open>
    1d69:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1d6b:	83 c4 10             	add    $0x10,%esp
    1d6e:	85 c0                	test   %eax,%eax
    1d70:	0f 88 10 04 00 00    	js     2186 <subdir+0x465>
    printf(1, "create dd/ff failed\n");
    exit(0);
  }
  write(fd, "ff", 2);
    1d76:	83 ec 04             	sub    $0x4,%esp
    1d79:	6a 02                	push   $0x2
    1d7b:	68 03 48 00 00       	push   $0x4803
    1d80:	50                   	push   %eax
    1d81:	e8 cf 1e 00 00       	call   3c55 <write>
  close(fd);
    1d86:	89 1c 24             	mov    %ebx,(%esp)
    1d89:	e8 cf 1e 00 00       	call   3c5d <close>

  if(unlink("dd") >= 0){
    1d8e:	c7 04 24 a0 48 00 00 	movl   $0x48a0,(%esp)
    1d95:	e8 eb 1e 00 00       	call   3c85 <unlink>
    1d9a:	83 c4 10             	add    $0x10,%esp
    1d9d:	85 c0                	test   %eax,%eax
    1d9f:	0f 89 fc 03 00 00    	jns    21a1 <subdir+0x480>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit(0);
  }

  if(mkdir("/dd/dd") != 0){
    1da5:	83 ec 0c             	sub    $0xc,%esp
    1da8:	68 b4 47 00 00       	push   $0x47b4
    1dad:	e8 eb 1e 00 00       	call   3c9d <mkdir>
    1db2:	83 c4 10             	add    $0x10,%esp
    1db5:	85 c0                	test   %eax,%eax
    1db7:	0f 85 ff 03 00 00    	jne    21bc <subdir+0x49b>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit(0);
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1dbd:	83 ec 08             	sub    $0x8,%esp
    1dc0:	68 02 02 00 00       	push   $0x202
    1dc5:	68 d6 47 00 00       	push   $0x47d6
    1dca:	e8 a6 1e 00 00       	call   3c75 <open>
    1dcf:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1dd1:	83 c4 10             	add    $0x10,%esp
    1dd4:	85 c0                	test   %eax,%eax
    1dd6:	0f 88 fb 03 00 00    	js     21d7 <subdir+0x4b6>
    printf(1, "create dd/dd/ff failed\n");
    exit(0);
  }
  write(fd, "FF", 2);
    1ddc:	83 ec 04             	sub    $0x4,%esp
    1ddf:	6a 02                	push   $0x2
    1de1:	68 f7 47 00 00       	push   $0x47f7
    1de6:	50                   	push   %eax
    1de7:	e8 69 1e 00 00       	call   3c55 <write>
  close(fd);
    1dec:	89 1c 24             	mov    %ebx,(%esp)
    1def:	e8 69 1e 00 00       	call   3c5d <close>

  fd = open("dd/dd/../ff", 0);
    1df4:	83 c4 08             	add    $0x8,%esp
    1df7:	6a 00                	push   $0x0
    1df9:	68 fa 47 00 00       	push   $0x47fa
    1dfe:	e8 72 1e 00 00       	call   3c75 <open>
    1e03:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e05:	83 c4 10             	add    $0x10,%esp
    1e08:	85 c0                	test   %eax,%eax
    1e0a:	0f 88 e2 03 00 00    	js     21f2 <subdir+0x4d1>
    printf(1, "open dd/dd/../ff failed\n");
    exit(0);
  }
  cc = read(fd, buf, sizeof(buf));
    1e10:	83 ec 04             	sub    $0x4,%esp
    1e13:	68 00 20 00 00       	push   $0x2000
    1e18:	68 20 88 00 00       	push   $0x8820
    1e1d:	50                   	push   %eax
    1e1e:	e8 2a 1e 00 00       	call   3c4d <read>
  if(cc != 2 || buf[0] != 'f'){
    1e23:	83 c4 10             	add    $0x10,%esp
    1e26:	83 f8 02             	cmp    $0x2,%eax
    1e29:	0f 85 de 03 00 00    	jne    220d <subdir+0x4ec>
    1e2f:	80 3d 20 88 00 00 66 	cmpb   $0x66,0x8820
    1e36:	0f 85 d1 03 00 00    	jne    220d <subdir+0x4ec>
    printf(1, "dd/dd/../ff wrong content\n");
    exit(0);
  }
  close(fd);
    1e3c:	83 ec 0c             	sub    $0xc,%esp
    1e3f:	53                   	push   %ebx
    1e40:	e8 18 1e 00 00       	call   3c5d <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1e45:	83 c4 08             	add    $0x8,%esp
    1e48:	68 3a 48 00 00       	push   $0x483a
    1e4d:	68 d6 47 00 00       	push   $0x47d6
    1e52:	e8 3e 1e 00 00       	call   3c95 <link>
    1e57:	83 c4 10             	add    $0x10,%esp
    1e5a:	85 c0                	test   %eax,%eax
    1e5c:	0f 85 c6 03 00 00    	jne    2228 <subdir+0x507>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit(0);
  }

  if(unlink("dd/dd/ff") != 0){
    1e62:	83 ec 0c             	sub    $0xc,%esp
    1e65:	68 d6 47 00 00       	push   $0x47d6
    1e6a:	e8 16 1e 00 00       	call   3c85 <unlink>
    1e6f:	83 c4 10             	add    $0x10,%esp
    1e72:	85 c0                	test   %eax,%eax
    1e74:	0f 85 c9 03 00 00    	jne    2243 <subdir+0x522>
    printf(1, "unlink dd/dd/ff failed\n");
    exit(0);
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1e7a:	83 ec 08             	sub    $0x8,%esp
    1e7d:	6a 00                	push   $0x0
    1e7f:	68 d6 47 00 00       	push   $0x47d6
    1e84:	e8 ec 1d 00 00       	call   3c75 <open>
    1e89:	83 c4 10             	add    $0x10,%esp
    1e8c:	85 c0                	test   %eax,%eax
    1e8e:	0f 89 ca 03 00 00    	jns    225e <subdir+0x53d>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit(0);
  }

  if(chdir("dd") != 0){
    1e94:	83 ec 0c             	sub    $0xc,%esp
    1e97:	68 a0 48 00 00       	push   $0x48a0
    1e9c:	e8 04 1e 00 00       	call   3ca5 <chdir>
    1ea1:	83 c4 10             	add    $0x10,%esp
    1ea4:	85 c0                	test   %eax,%eax
    1ea6:	0f 85 cd 03 00 00    	jne    2279 <subdir+0x558>
    printf(1, "chdir dd failed\n");
    exit(0);
  }
  if(chdir("dd/../../dd") != 0){
    1eac:	83 ec 0c             	sub    $0xc,%esp
    1eaf:	68 6e 48 00 00       	push   $0x486e
    1eb4:	e8 ec 1d 00 00       	call   3ca5 <chdir>
    1eb9:	83 c4 10             	add    $0x10,%esp
    1ebc:	85 c0                	test   %eax,%eax
    1ebe:	0f 85 d0 03 00 00    	jne    2294 <subdir+0x573>
    printf(1, "chdir dd/../../dd failed\n");
    exit(0);
  }
  if(chdir("dd/../../../dd") != 0){
    1ec4:	83 ec 0c             	sub    $0xc,%esp
    1ec7:	68 94 48 00 00       	push   $0x4894
    1ecc:	e8 d4 1d 00 00       	call   3ca5 <chdir>
    1ed1:	83 c4 10             	add    $0x10,%esp
    1ed4:	85 c0                	test   %eax,%eax
    1ed6:	0f 85 d3 03 00 00    	jne    22af <subdir+0x58e>
    printf(1, "chdir dd/../../dd failed\n");
    exit(0);
  }
  if(chdir("./..") != 0){
    1edc:	83 ec 0c             	sub    $0xc,%esp
    1edf:	68 a3 48 00 00       	push   $0x48a3
    1ee4:	e8 bc 1d 00 00       	call   3ca5 <chdir>
    1ee9:	83 c4 10             	add    $0x10,%esp
    1eec:	85 c0                	test   %eax,%eax
    1eee:	0f 85 d6 03 00 00    	jne    22ca <subdir+0x5a9>
    printf(1, "chdir ./.. failed\n");
    exit(0);
  }

  fd = open("dd/dd/ffff", 0);
    1ef4:	83 ec 08             	sub    $0x8,%esp
    1ef7:	6a 00                	push   $0x0
    1ef9:	68 3a 48 00 00       	push   $0x483a
    1efe:	e8 72 1d 00 00       	call   3c75 <open>
    1f03:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1f05:	83 c4 10             	add    $0x10,%esp
    1f08:	85 c0                	test   %eax,%eax
    1f0a:	0f 88 d5 03 00 00    	js     22e5 <subdir+0x5c4>
    printf(1, "open dd/dd/ffff failed\n");
    exit(0);
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    1f10:	83 ec 04             	sub    $0x4,%esp
    1f13:	68 00 20 00 00       	push   $0x2000
    1f18:	68 20 88 00 00       	push   $0x8820
    1f1d:	50                   	push   %eax
    1f1e:	e8 2a 1d 00 00       	call   3c4d <read>
    1f23:	83 c4 10             	add    $0x10,%esp
    1f26:	83 f8 02             	cmp    $0x2,%eax
    1f29:	0f 85 d1 03 00 00    	jne    2300 <subdir+0x5df>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit(0);
  }
  close(fd);
    1f2f:	83 ec 0c             	sub    $0xc,%esp
    1f32:	53                   	push   %ebx
    1f33:	e8 25 1d 00 00       	call   3c5d <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1f38:	83 c4 08             	add    $0x8,%esp
    1f3b:	6a 00                	push   $0x0
    1f3d:	68 d6 47 00 00       	push   $0x47d6
    1f42:	e8 2e 1d 00 00       	call   3c75 <open>
    1f47:	83 c4 10             	add    $0x10,%esp
    1f4a:	85 c0                	test   %eax,%eax
    1f4c:	0f 89 c9 03 00 00    	jns    231b <subdir+0x5fa>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit(0);
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1f52:	83 ec 08             	sub    $0x8,%esp
    1f55:	68 02 02 00 00       	push   $0x202
    1f5a:	68 ee 48 00 00       	push   $0x48ee
    1f5f:	e8 11 1d 00 00       	call   3c75 <open>
    1f64:	83 c4 10             	add    $0x10,%esp
    1f67:	85 c0                	test   %eax,%eax
    1f69:	0f 89 c7 03 00 00    	jns    2336 <subdir+0x615>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit(0);
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1f6f:	83 ec 08             	sub    $0x8,%esp
    1f72:	68 02 02 00 00       	push   $0x202
    1f77:	68 13 49 00 00       	push   $0x4913
    1f7c:	e8 f4 1c 00 00       	call   3c75 <open>
    1f81:	83 c4 10             	add    $0x10,%esp
    1f84:	85 c0                	test   %eax,%eax
    1f86:	0f 89 c5 03 00 00    	jns    2351 <subdir+0x630>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit(0);
  }
  if(open("dd", O_CREATE) >= 0){
    1f8c:	83 ec 08             	sub    $0x8,%esp
    1f8f:	68 00 02 00 00       	push   $0x200
    1f94:	68 a0 48 00 00       	push   $0x48a0
    1f99:	e8 d7 1c 00 00       	call   3c75 <open>
    1f9e:	83 c4 10             	add    $0x10,%esp
    1fa1:	85 c0                	test   %eax,%eax
    1fa3:	0f 89 c3 03 00 00    	jns    236c <subdir+0x64b>
    printf(1, "create dd succeeded!\n");
    exit(0);
  }
  if(open("dd", O_RDWR) >= 0){
    1fa9:	83 ec 08             	sub    $0x8,%esp
    1fac:	6a 02                	push   $0x2
    1fae:	68 a0 48 00 00       	push   $0x48a0
    1fb3:	e8 bd 1c 00 00       	call   3c75 <open>
    1fb8:	83 c4 10             	add    $0x10,%esp
    1fbb:	85 c0                	test   %eax,%eax
    1fbd:	0f 89 c4 03 00 00    	jns    2387 <subdir+0x666>
    printf(1, "open dd rdwr succeeded!\n");
    exit(0);
  }
  if(open("dd", O_WRONLY) >= 0){
    1fc3:	83 ec 08             	sub    $0x8,%esp
    1fc6:	6a 01                	push   $0x1
    1fc8:	68 a0 48 00 00       	push   $0x48a0
    1fcd:	e8 a3 1c 00 00       	call   3c75 <open>
    1fd2:	83 c4 10             	add    $0x10,%esp
    1fd5:	85 c0                	test   %eax,%eax
    1fd7:	0f 89 c5 03 00 00    	jns    23a2 <subdir+0x681>
    printf(1, "open dd wronly succeeded!\n");
    exit(0);
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1fdd:	83 ec 08             	sub    $0x8,%esp
    1fe0:	68 82 49 00 00       	push   $0x4982
    1fe5:	68 ee 48 00 00       	push   $0x48ee
    1fea:	e8 a6 1c 00 00       	call   3c95 <link>
    1fef:	83 c4 10             	add    $0x10,%esp
    1ff2:	85 c0                	test   %eax,%eax
    1ff4:	0f 84 c3 03 00 00    	je     23bd <subdir+0x69c>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit(0);
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    1ffa:	83 ec 08             	sub    $0x8,%esp
    1ffd:	68 82 49 00 00       	push   $0x4982
    2002:	68 13 49 00 00       	push   $0x4913
    2007:	e8 89 1c 00 00       	call   3c95 <link>
    200c:	83 c4 10             	add    $0x10,%esp
    200f:	85 c0                	test   %eax,%eax
    2011:	0f 84 c1 03 00 00    	je     23d8 <subdir+0x6b7>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit(0);
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2017:	83 ec 08             	sub    $0x8,%esp
    201a:	68 3a 48 00 00       	push   $0x483a
    201f:	68 d9 47 00 00       	push   $0x47d9
    2024:	e8 6c 1c 00 00       	call   3c95 <link>
    2029:	83 c4 10             	add    $0x10,%esp
    202c:	85 c0                	test   %eax,%eax
    202e:	0f 84 bf 03 00 00    	je     23f3 <subdir+0x6d2>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit(0);
  }
  if(mkdir("dd/ff/ff") == 0){
    2034:	83 ec 0c             	sub    $0xc,%esp
    2037:	68 ee 48 00 00       	push   $0x48ee
    203c:	e8 5c 1c 00 00       	call   3c9d <mkdir>
    2041:	83 c4 10             	add    $0x10,%esp
    2044:	85 c0                	test   %eax,%eax
    2046:	0f 84 c2 03 00 00    	je     240e <subdir+0x6ed>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit(0);
  }
  if(mkdir("dd/xx/ff") == 0){
    204c:	83 ec 0c             	sub    $0xc,%esp
    204f:	68 13 49 00 00       	push   $0x4913
    2054:	e8 44 1c 00 00       	call   3c9d <mkdir>
    2059:	83 c4 10             	add    $0x10,%esp
    205c:	85 c0                	test   %eax,%eax
    205e:	0f 84 c5 03 00 00    	je     2429 <subdir+0x708>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit(0);
  }
  if(mkdir("dd/dd/ffff") == 0){
    2064:	83 ec 0c             	sub    $0xc,%esp
    2067:	68 3a 48 00 00       	push   $0x483a
    206c:	e8 2c 1c 00 00       	call   3c9d <mkdir>
    2071:	83 c4 10             	add    $0x10,%esp
    2074:	85 c0                	test   %eax,%eax
    2076:	0f 84 c8 03 00 00    	je     2444 <subdir+0x723>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit(0);
  }
  if(unlink("dd/xx/ff") == 0){
    207c:	83 ec 0c             	sub    $0xc,%esp
    207f:	68 13 49 00 00       	push   $0x4913
    2084:	e8 fc 1b 00 00       	call   3c85 <unlink>
    2089:	83 c4 10             	add    $0x10,%esp
    208c:	85 c0                	test   %eax,%eax
    208e:	0f 84 cb 03 00 00    	je     245f <subdir+0x73e>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit(0);
  }
  if(unlink("dd/ff/ff") == 0){
    2094:	83 ec 0c             	sub    $0xc,%esp
    2097:	68 ee 48 00 00       	push   $0x48ee
    209c:	e8 e4 1b 00 00       	call   3c85 <unlink>
    20a1:	83 c4 10             	add    $0x10,%esp
    20a4:	85 c0                	test   %eax,%eax
    20a6:	0f 84 ce 03 00 00    	je     247a <subdir+0x759>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit(0);
  }
  if(chdir("dd/ff") == 0){
    20ac:	83 ec 0c             	sub    $0xc,%esp
    20af:	68 d9 47 00 00       	push   $0x47d9
    20b4:	e8 ec 1b 00 00       	call   3ca5 <chdir>
    20b9:	83 c4 10             	add    $0x10,%esp
    20bc:	85 c0                	test   %eax,%eax
    20be:	0f 84 d1 03 00 00    	je     2495 <subdir+0x774>
    printf(1, "chdir dd/ff succeeded!\n");
    exit(0);
  }
  if(chdir("dd/xx") == 0){
    20c4:	83 ec 0c             	sub    $0xc,%esp
    20c7:	68 85 49 00 00       	push   $0x4985
    20cc:	e8 d4 1b 00 00       	call   3ca5 <chdir>
    20d1:	83 c4 10             	add    $0x10,%esp
    20d4:	85 c0                	test   %eax,%eax
    20d6:	0f 84 d4 03 00 00    	je     24b0 <subdir+0x78f>
    printf(1, "chdir dd/xx succeeded!\n");
    exit(0);
  }

  if(unlink("dd/dd/ffff") != 0){
    20dc:	83 ec 0c             	sub    $0xc,%esp
    20df:	68 3a 48 00 00       	push   $0x483a
    20e4:	e8 9c 1b 00 00       	call   3c85 <unlink>
    20e9:	83 c4 10             	add    $0x10,%esp
    20ec:	85 c0                	test   %eax,%eax
    20ee:	0f 85 d7 03 00 00    	jne    24cb <subdir+0x7aa>
    printf(1, "unlink dd/dd/ff failed\n");
    exit(0);
  }
  if(unlink("dd/ff") != 0){
    20f4:	83 ec 0c             	sub    $0xc,%esp
    20f7:	68 d9 47 00 00       	push   $0x47d9
    20fc:	e8 84 1b 00 00       	call   3c85 <unlink>
    2101:	83 c4 10             	add    $0x10,%esp
    2104:	85 c0                	test   %eax,%eax
    2106:	0f 85 da 03 00 00    	jne    24e6 <subdir+0x7c5>
    printf(1, "unlink dd/ff failed\n");
    exit(0);
  }
  if(unlink("dd") == 0){
    210c:	83 ec 0c             	sub    $0xc,%esp
    210f:	68 a0 48 00 00       	push   $0x48a0
    2114:	e8 6c 1b 00 00       	call   3c85 <unlink>
    2119:	83 c4 10             	add    $0x10,%esp
    211c:	85 c0                	test   %eax,%eax
    211e:	0f 84 dd 03 00 00    	je     2501 <subdir+0x7e0>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit(0);
  }
  if(unlink("dd/dd") < 0){
    2124:	83 ec 0c             	sub    $0xc,%esp
    2127:	68 b5 47 00 00       	push   $0x47b5
    212c:	e8 54 1b 00 00       	call   3c85 <unlink>
    2131:	83 c4 10             	add    $0x10,%esp
    2134:	85 c0                	test   %eax,%eax
    2136:	0f 88 e0 03 00 00    	js     251c <subdir+0x7fb>
    printf(1, "unlink dd/dd failed\n");
    exit(0);
  }
  if(unlink("dd") < 0){
    213c:	83 ec 0c             	sub    $0xc,%esp
    213f:	68 a0 48 00 00       	push   $0x48a0
    2144:	e8 3c 1b 00 00       	call   3c85 <unlink>
    2149:	83 c4 10             	add    $0x10,%esp
    214c:	85 c0                	test   %eax,%eax
    214e:	0f 88 e3 03 00 00    	js     2537 <subdir+0x816>
    printf(1, "unlink dd failed\n");
    exit(0);
  }

  printf(1, "subdir ok\n");
    2154:	83 ec 08             	sub    $0x8,%esp
    2157:	68 82 4a 00 00       	push   $0x4a82
    215c:	6a 01                	push   $0x1
    215e:	e8 25 1c 00 00       	call   3d88 <printf>
}
    2163:	83 c4 10             	add    $0x10,%esp
    2166:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2169:	c9                   	leave
    216a:	c3                   	ret
    printf(1, "subdir mkdir dd failed\n");
    216b:	83 ec 08             	sub    $0x8,%esp
    216e:	68 87 47 00 00       	push   $0x4787
    2173:	6a 01                	push   $0x1
    2175:	e8 0e 1c 00 00       	call   3d88 <printf>
    exit(0);
    217a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2181:	e8 af 1a 00 00       	call   3c35 <exit>
    printf(1, "create dd/ff failed\n");
    2186:	83 ec 08             	sub    $0x8,%esp
    2189:	68 9f 47 00 00       	push   $0x479f
    218e:	6a 01                	push   $0x1
    2190:	e8 f3 1b 00 00       	call   3d88 <printf>
    exit(0);
    2195:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    219c:	e8 94 1a 00 00       	call   3c35 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    21a1:	83 ec 08             	sub    $0x8,%esp
    21a4:	68 74 52 00 00       	push   $0x5274
    21a9:	6a 01                	push   $0x1
    21ab:	e8 d8 1b 00 00       	call   3d88 <printf>
    exit(0);
    21b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    21b7:	e8 79 1a 00 00       	call   3c35 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    21bc:	83 ec 08             	sub    $0x8,%esp
    21bf:	68 bb 47 00 00       	push   $0x47bb
    21c4:	6a 01                	push   $0x1
    21c6:	e8 bd 1b 00 00       	call   3d88 <printf>
    exit(0);
    21cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    21d2:	e8 5e 1a 00 00       	call   3c35 <exit>
    printf(1, "create dd/dd/ff failed\n");
    21d7:	83 ec 08             	sub    $0x8,%esp
    21da:	68 df 47 00 00       	push   $0x47df
    21df:	6a 01                	push   $0x1
    21e1:	e8 a2 1b 00 00       	call   3d88 <printf>
    exit(0);
    21e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    21ed:	e8 43 1a 00 00       	call   3c35 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    21f2:	83 ec 08             	sub    $0x8,%esp
    21f5:	68 06 48 00 00       	push   $0x4806
    21fa:	6a 01                	push   $0x1
    21fc:	e8 87 1b 00 00       	call   3d88 <printf>
    exit(0);
    2201:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2208:	e8 28 1a 00 00       	call   3c35 <exit>
    printf(1, "dd/dd/../ff wrong content\n");
    220d:	83 ec 08             	sub    $0x8,%esp
    2210:	68 1f 48 00 00       	push   $0x481f
    2215:	6a 01                	push   $0x1
    2217:	e8 6c 1b 00 00       	call   3d88 <printf>
    exit(0);
    221c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2223:	e8 0d 1a 00 00       	call   3c35 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2228:	83 ec 08             	sub    $0x8,%esp
    222b:	68 9c 52 00 00       	push   $0x529c
    2230:	6a 01                	push   $0x1
    2232:	e8 51 1b 00 00       	call   3d88 <printf>
    exit(0);
    2237:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    223e:	e8 f2 19 00 00       	call   3c35 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    2243:	83 ec 08             	sub    $0x8,%esp
    2246:	68 45 48 00 00       	push   $0x4845
    224b:	6a 01                	push   $0x1
    224d:	e8 36 1b 00 00       	call   3d88 <printf>
    exit(0);
    2252:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2259:	e8 d7 19 00 00       	call   3c35 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    225e:	83 ec 08             	sub    $0x8,%esp
    2261:	68 c0 52 00 00       	push   $0x52c0
    2266:	6a 01                	push   $0x1
    2268:	e8 1b 1b 00 00       	call   3d88 <printf>
    exit(0);
    226d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2274:	e8 bc 19 00 00       	call   3c35 <exit>
    printf(1, "chdir dd failed\n");
    2279:	83 ec 08             	sub    $0x8,%esp
    227c:	68 5d 48 00 00       	push   $0x485d
    2281:	6a 01                	push   $0x1
    2283:	e8 00 1b 00 00       	call   3d88 <printf>
    exit(0);
    2288:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    228f:	e8 a1 19 00 00       	call   3c35 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    2294:	83 ec 08             	sub    $0x8,%esp
    2297:	68 7a 48 00 00       	push   $0x487a
    229c:	6a 01                	push   $0x1
    229e:	e8 e5 1a 00 00       	call   3d88 <printf>
    exit(0);
    22a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    22aa:	e8 86 19 00 00       	call   3c35 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    22af:	83 ec 08             	sub    $0x8,%esp
    22b2:	68 7a 48 00 00       	push   $0x487a
    22b7:	6a 01                	push   $0x1
    22b9:	e8 ca 1a 00 00       	call   3d88 <printf>
    exit(0);
    22be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    22c5:	e8 6b 19 00 00       	call   3c35 <exit>
    printf(1, "chdir ./.. failed\n");
    22ca:	83 ec 08             	sub    $0x8,%esp
    22cd:	68 a8 48 00 00       	push   $0x48a8
    22d2:	6a 01                	push   $0x1
    22d4:	e8 af 1a 00 00       	call   3d88 <printf>
    exit(0);
    22d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    22e0:	e8 50 19 00 00       	call   3c35 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    22e5:	83 ec 08             	sub    $0x8,%esp
    22e8:	68 bb 48 00 00       	push   $0x48bb
    22ed:	6a 01                	push   $0x1
    22ef:	e8 94 1a 00 00       	call   3d88 <printf>
    exit(0);
    22f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    22fb:	e8 35 19 00 00       	call   3c35 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    2300:	83 ec 08             	sub    $0x8,%esp
    2303:	68 d3 48 00 00       	push   $0x48d3
    2308:	6a 01                	push   $0x1
    230a:	e8 79 1a 00 00       	call   3d88 <printf>
    exit(0);
    230f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2316:	e8 1a 19 00 00       	call   3c35 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    231b:	83 ec 08             	sub    $0x8,%esp
    231e:	68 e4 52 00 00       	push   $0x52e4
    2323:	6a 01                	push   $0x1
    2325:	e8 5e 1a 00 00       	call   3d88 <printf>
    exit(0);
    232a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2331:	e8 ff 18 00 00       	call   3c35 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    2336:	83 ec 08             	sub    $0x8,%esp
    2339:	68 f7 48 00 00       	push   $0x48f7
    233e:	6a 01                	push   $0x1
    2340:	e8 43 1a 00 00       	call   3d88 <printf>
    exit(0);
    2345:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    234c:	e8 e4 18 00 00       	call   3c35 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    2351:	83 ec 08             	sub    $0x8,%esp
    2354:	68 1c 49 00 00       	push   $0x491c
    2359:	6a 01                	push   $0x1
    235b:	e8 28 1a 00 00       	call   3d88 <printf>
    exit(0);
    2360:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2367:	e8 c9 18 00 00       	call   3c35 <exit>
    printf(1, "create dd succeeded!\n");
    236c:	83 ec 08             	sub    $0x8,%esp
    236f:	68 38 49 00 00       	push   $0x4938
    2374:	6a 01                	push   $0x1
    2376:	e8 0d 1a 00 00       	call   3d88 <printf>
    exit(0);
    237b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2382:	e8 ae 18 00 00       	call   3c35 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    2387:	83 ec 08             	sub    $0x8,%esp
    238a:	68 4e 49 00 00       	push   $0x494e
    238f:	6a 01                	push   $0x1
    2391:	e8 f2 19 00 00       	call   3d88 <printf>
    exit(0);
    2396:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    239d:	e8 93 18 00 00       	call   3c35 <exit>
    printf(1, "open dd wronly succeeded!\n");
    23a2:	83 ec 08             	sub    $0x8,%esp
    23a5:	68 67 49 00 00       	push   $0x4967
    23aa:	6a 01                	push   $0x1
    23ac:	e8 d7 19 00 00       	call   3d88 <printf>
    exit(0);
    23b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    23b8:	e8 78 18 00 00       	call   3c35 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    23bd:	83 ec 08             	sub    $0x8,%esp
    23c0:	68 0c 53 00 00       	push   $0x530c
    23c5:	6a 01                	push   $0x1
    23c7:	e8 bc 19 00 00       	call   3d88 <printf>
    exit(0);
    23cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    23d3:	e8 5d 18 00 00       	call   3c35 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    23d8:	83 ec 08             	sub    $0x8,%esp
    23db:	68 30 53 00 00       	push   $0x5330
    23e0:	6a 01                	push   $0x1
    23e2:	e8 a1 19 00 00       	call   3d88 <printf>
    exit(0);
    23e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    23ee:	e8 42 18 00 00       	call   3c35 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    23f3:	83 ec 08             	sub    $0x8,%esp
    23f6:	68 54 53 00 00       	push   $0x5354
    23fb:	6a 01                	push   $0x1
    23fd:	e8 86 19 00 00       	call   3d88 <printf>
    exit(0);
    2402:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2409:	e8 27 18 00 00       	call   3c35 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    240e:	83 ec 08             	sub    $0x8,%esp
    2411:	68 8b 49 00 00       	push   $0x498b
    2416:	6a 01                	push   $0x1
    2418:	e8 6b 19 00 00       	call   3d88 <printf>
    exit(0);
    241d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2424:	e8 0c 18 00 00       	call   3c35 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2429:	83 ec 08             	sub    $0x8,%esp
    242c:	68 a6 49 00 00       	push   $0x49a6
    2431:	6a 01                	push   $0x1
    2433:	e8 50 19 00 00       	call   3d88 <printf>
    exit(0);
    2438:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    243f:	e8 f1 17 00 00       	call   3c35 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2444:	83 ec 08             	sub    $0x8,%esp
    2447:	68 c1 49 00 00       	push   $0x49c1
    244c:	6a 01                	push   $0x1
    244e:	e8 35 19 00 00       	call   3d88 <printf>
    exit(0);
    2453:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    245a:	e8 d6 17 00 00       	call   3c35 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    245f:	83 ec 08             	sub    $0x8,%esp
    2462:	68 de 49 00 00       	push   $0x49de
    2467:	6a 01                	push   $0x1
    2469:	e8 1a 19 00 00       	call   3d88 <printf>
    exit(0);
    246e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2475:	e8 bb 17 00 00       	call   3c35 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    247a:	83 ec 08             	sub    $0x8,%esp
    247d:	68 fa 49 00 00       	push   $0x49fa
    2482:	6a 01                	push   $0x1
    2484:	e8 ff 18 00 00       	call   3d88 <printf>
    exit(0);
    2489:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2490:	e8 a0 17 00 00       	call   3c35 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    2495:	83 ec 08             	sub    $0x8,%esp
    2498:	68 16 4a 00 00       	push   $0x4a16
    249d:	6a 01                	push   $0x1
    249f:	e8 e4 18 00 00       	call   3d88 <printf>
    exit(0);
    24a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    24ab:	e8 85 17 00 00       	call   3c35 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    24b0:	83 ec 08             	sub    $0x8,%esp
    24b3:	68 2e 4a 00 00       	push   $0x4a2e
    24b8:	6a 01                	push   $0x1
    24ba:	e8 c9 18 00 00       	call   3d88 <printf>
    exit(0);
    24bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    24c6:	e8 6a 17 00 00       	call   3c35 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    24cb:	83 ec 08             	sub    $0x8,%esp
    24ce:	68 45 48 00 00       	push   $0x4845
    24d3:	6a 01                	push   $0x1
    24d5:	e8 ae 18 00 00       	call   3d88 <printf>
    exit(0);
    24da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    24e1:	e8 4f 17 00 00       	call   3c35 <exit>
    printf(1, "unlink dd/ff failed\n");
    24e6:	83 ec 08             	sub    $0x8,%esp
    24e9:	68 46 4a 00 00       	push   $0x4a46
    24ee:	6a 01                	push   $0x1
    24f0:	e8 93 18 00 00       	call   3d88 <printf>
    exit(0);
    24f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    24fc:	e8 34 17 00 00       	call   3c35 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    2501:	83 ec 08             	sub    $0x8,%esp
    2504:	68 78 53 00 00       	push   $0x5378
    2509:	6a 01                	push   $0x1
    250b:	e8 78 18 00 00       	call   3d88 <printf>
    exit(0);
    2510:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2517:	e8 19 17 00 00       	call   3c35 <exit>
    printf(1, "unlink dd/dd failed\n");
    251c:	83 ec 08             	sub    $0x8,%esp
    251f:	68 5b 4a 00 00       	push   $0x4a5b
    2524:	6a 01                	push   $0x1
    2526:	e8 5d 18 00 00       	call   3d88 <printf>
    exit(0);
    252b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2532:	e8 fe 16 00 00       	call   3c35 <exit>
    printf(1, "unlink dd failed\n");
    2537:	83 ec 08             	sub    $0x8,%esp
    253a:	68 70 4a 00 00       	push   $0x4a70
    253f:	6a 01                	push   $0x1
    2541:	e8 42 18 00 00       	call   3d88 <printf>
    exit(0);
    2546:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    254d:	e8 e3 16 00 00       	call   3c35 <exit>

00002552 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    2552:	55                   	push   %ebp
    2553:	89 e5                	mov    %esp,%ebp
    2555:	57                   	push   %edi
    2556:	56                   	push   %esi
    2557:	53                   	push   %ebx
    2558:	83 ec 14             	sub    $0x14,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    255b:	68 8d 4a 00 00       	push   $0x4a8d
    2560:	6a 01                	push   $0x1
    2562:	e8 21 18 00 00       	call   3d88 <printf>

  unlink("bigwrite");
    2567:	c7 04 24 9c 4a 00 00 	movl   $0x4a9c,(%esp)
    256e:	e8 12 17 00 00       	call   3c85 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    2573:	83 c4 10             	add    $0x10,%esp
    2576:	be f3 01 00 00       	mov    $0x1f3,%esi
    257b:	eb 53                	jmp    25d0 <bigwrite+0x7e>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
    257d:	83 ec 08             	sub    $0x8,%esp
    2580:	68 a5 4a 00 00       	push   $0x4aa5
    2585:	6a 01                	push   $0x1
    2587:	e8 fc 17 00 00       	call   3d88 <printf>
      exit(0);
    258c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2593:	e8 9d 16 00 00       	call   3c35 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
    2598:	50                   	push   %eax
    2599:	56                   	push   %esi
    259a:	68 bd 4a 00 00       	push   $0x4abd
    259f:	6a 01                	push   $0x1
    25a1:	e8 e2 17 00 00       	call   3d88 <printf>
        exit(0);
    25a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    25ad:	e8 83 16 00 00       	call   3c35 <exit>
      }
    }
    close(fd);
    25b2:	83 ec 0c             	sub    $0xc,%esp
    25b5:	57                   	push   %edi
    25b6:	e8 a2 16 00 00       	call   3c5d <close>
    unlink("bigwrite");
    25bb:	c7 04 24 9c 4a 00 00 	movl   $0x4a9c,(%esp)
    25c2:	e8 be 16 00 00       	call   3c85 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    25c7:	81 c6 d7 01 00 00    	add    $0x1d7,%esi
    25cd:	83 c4 10             	add    $0x10,%esp
    25d0:	81 fe ff 17 00 00    	cmp    $0x17ff,%esi
    25d6:	7f 3e                	jg     2616 <bigwrite+0xc4>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    25d8:	83 ec 08             	sub    $0x8,%esp
    25db:	68 02 02 00 00       	push   $0x202
    25e0:	68 9c 4a 00 00       	push   $0x4a9c
    25e5:	e8 8b 16 00 00       	call   3c75 <open>
    25ea:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    25ec:	83 c4 10             	add    $0x10,%esp
    25ef:	85 c0                	test   %eax,%eax
    25f1:	78 8a                	js     257d <bigwrite+0x2b>
    for(i = 0; i < 2; i++){
    25f3:	bb 00 00 00 00       	mov    $0x0,%ebx
    25f8:	83 fb 01             	cmp    $0x1,%ebx
    25fb:	7f b5                	jg     25b2 <bigwrite+0x60>
      int cc = write(fd, buf, sz);
    25fd:	83 ec 04             	sub    $0x4,%esp
    2600:	56                   	push   %esi
    2601:	68 20 88 00 00       	push   $0x8820
    2606:	57                   	push   %edi
    2607:	e8 49 16 00 00       	call   3c55 <write>
      if(cc != sz){
    260c:	83 c4 10             	add    $0x10,%esp
    260f:	39 c6                	cmp    %eax,%esi
    2611:	75 85                	jne    2598 <bigwrite+0x46>
    for(i = 0; i < 2; i++){
    2613:	43                   	inc    %ebx
    2614:	eb e2                	jmp    25f8 <bigwrite+0xa6>
  }

  printf(1, "bigwrite ok\n");
    2616:	83 ec 08             	sub    $0x8,%esp
    2619:	68 cf 4a 00 00       	push   $0x4acf
    261e:	6a 01                	push   $0x1
    2620:	e8 63 17 00 00       	call   3d88 <printf>
}
    2625:	83 c4 10             	add    $0x10,%esp
    2628:	8d 65 f4             	lea    -0xc(%ebp),%esp
    262b:	5b                   	pop    %ebx
    262c:	5e                   	pop    %esi
    262d:	5f                   	pop    %edi
    262e:	5d                   	pop    %ebp
    262f:	c3                   	ret

00002630 <bigfile>:

void
bigfile(void)
{
    2630:	55                   	push   %ebp
    2631:	89 e5                	mov    %esp,%ebp
    2633:	57                   	push   %edi
    2634:	56                   	push   %esi
    2635:	53                   	push   %ebx
    2636:	83 ec 14             	sub    $0x14,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    2639:	68 dc 4a 00 00       	push   $0x4adc
    263e:	6a 01                	push   $0x1
    2640:	e8 43 17 00 00       	call   3d88 <printf>

  unlink("bigfile");
    2645:	c7 04 24 f8 4a 00 00 	movl   $0x4af8,(%esp)
    264c:	e8 34 16 00 00       	call   3c85 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2651:	83 c4 08             	add    $0x8,%esp
    2654:	68 02 02 00 00       	push   $0x202
    2659:	68 f8 4a 00 00       	push   $0x4af8
    265e:	e8 12 16 00 00       	call   3c75 <open>
  if(fd < 0){
    2663:	83 c4 10             	add    $0x10,%esp
    2666:	85 c0                	test   %eax,%eax
    2668:	78 3f                	js     26a9 <bigfile+0x79>
    266a:	89 c6                	mov    %eax,%esi
    printf(1, "cannot create bigfile");
    exit(0);
  }
  for(i = 0; i < 20; i++){
    266c:	bb 00 00 00 00       	mov    $0x0,%ebx
    2671:	83 fb 13             	cmp    $0x13,%ebx
    2674:	7f 69                	jg     26df <bigfile+0xaf>
    memset(buf, i, 600);
    2676:	83 ec 04             	sub    $0x4,%esp
    2679:	68 58 02 00 00       	push   $0x258
    267e:	53                   	push   %ebx
    267f:	68 20 88 00 00       	push   $0x8820
    2684:	e8 81 14 00 00       	call   3b0a <memset>
    if(write(fd, buf, 600) != 600){
    2689:	83 c4 0c             	add    $0xc,%esp
    268c:	68 58 02 00 00       	push   $0x258
    2691:	68 20 88 00 00       	push   $0x8820
    2696:	56                   	push   %esi
    2697:	e8 b9 15 00 00       	call   3c55 <write>
    269c:	83 c4 10             	add    $0x10,%esp
    269f:	3d 58 02 00 00       	cmp    $0x258,%eax
    26a4:	75 1e                	jne    26c4 <bigfile+0x94>
  for(i = 0; i < 20; i++){
    26a6:	43                   	inc    %ebx
    26a7:	eb c8                	jmp    2671 <bigfile+0x41>
    printf(1, "cannot create bigfile");
    26a9:	83 ec 08             	sub    $0x8,%esp
    26ac:	68 ea 4a 00 00       	push   $0x4aea
    26b1:	6a 01                	push   $0x1
    26b3:	e8 d0 16 00 00       	call   3d88 <printf>
    exit(0);
    26b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    26bf:	e8 71 15 00 00       	call   3c35 <exit>
      printf(1, "write bigfile failed\n");
    26c4:	83 ec 08             	sub    $0x8,%esp
    26c7:	68 00 4b 00 00       	push   $0x4b00
    26cc:	6a 01                	push   $0x1
    26ce:	e8 b5 16 00 00       	call   3d88 <printf>
      exit(0);
    26d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    26da:	e8 56 15 00 00       	call   3c35 <exit>
    }
  }
  close(fd);
    26df:	83 ec 0c             	sub    $0xc,%esp
    26e2:	56                   	push   %esi
    26e3:	e8 75 15 00 00       	call   3c5d <close>

  fd = open("bigfile", 0);
    26e8:	83 c4 08             	add    $0x8,%esp
    26eb:	6a 00                	push   $0x0
    26ed:	68 f8 4a 00 00       	push   $0x4af8
    26f2:	e8 7e 15 00 00       	call   3c75 <open>
    26f7:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    26f9:	83 c4 10             	add    $0x10,%esp
    26fc:	85 c0                	test   %eax,%eax
    26fe:	78 55                	js     2755 <bigfile+0x125>
    printf(1, "cannot open bigfile\n");
    exit(0);
  }
  total = 0;
    2700:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; ; i++){
    2705:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(fd, buf, 300);
    270a:	83 ec 04             	sub    $0x4,%esp
    270d:	68 2c 01 00 00       	push   $0x12c
    2712:	68 20 88 00 00       	push   $0x8820
    2717:	57                   	push   %edi
    2718:	e8 30 15 00 00       	call   3c4d <read>
    if(cc < 0){
    271d:	83 c4 10             	add    $0x10,%esp
    2720:	85 c0                	test   %eax,%eax
    2722:	78 4c                	js     2770 <bigfile+0x140>
      printf(1, "read bigfile failed\n");
      exit(0);
    }
    if(cc == 0)
    2724:	0f 84 97 00 00 00    	je     27c1 <bigfile+0x191>
      break;
    if(cc != 300){
    272a:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    272f:	75 5a                	jne    278b <bigfile+0x15b>
      printf(1, "short read bigfile\n");
      exit(0);
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    2731:	0f be 0d 20 88 00 00 	movsbl 0x8820,%ecx
    2738:	89 da                	mov    %ebx,%edx
    273a:	c1 ea 1f             	shr    $0x1f,%edx
    273d:	01 da                	add    %ebx,%edx
    273f:	d1 fa                	sar    $1,%edx
    2741:	39 d1                	cmp    %edx,%ecx
    2743:	75 61                	jne    27a6 <bigfile+0x176>
    2745:	0f be 0d 4b 89 00 00 	movsbl 0x894b,%ecx
    274c:	39 ca                	cmp    %ecx,%edx
    274e:	75 56                	jne    27a6 <bigfile+0x176>
      printf(1, "read bigfile wrong data\n");
      exit(0);
    }
    total += cc;
    2750:	01 c6                	add    %eax,%esi
  for(i = 0; ; i++){
    2752:	43                   	inc    %ebx
    cc = read(fd, buf, 300);
    2753:	eb b5                	jmp    270a <bigfile+0xda>
    printf(1, "cannot open bigfile\n");
    2755:	83 ec 08             	sub    $0x8,%esp
    2758:	68 16 4b 00 00       	push   $0x4b16
    275d:	6a 01                	push   $0x1
    275f:	e8 24 16 00 00       	call   3d88 <printf>
    exit(0);
    2764:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    276b:	e8 c5 14 00 00       	call   3c35 <exit>
      printf(1, "read bigfile failed\n");
    2770:	83 ec 08             	sub    $0x8,%esp
    2773:	68 2b 4b 00 00       	push   $0x4b2b
    2778:	6a 01                	push   $0x1
    277a:	e8 09 16 00 00       	call   3d88 <printf>
      exit(0);
    277f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2786:	e8 aa 14 00 00       	call   3c35 <exit>
      printf(1, "short read bigfile\n");
    278b:	83 ec 08             	sub    $0x8,%esp
    278e:	68 40 4b 00 00       	push   $0x4b40
    2793:	6a 01                	push   $0x1
    2795:	e8 ee 15 00 00       	call   3d88 <printf>
      exit(0);
    279a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    27a1:	e8 8f 14 00 00       	call   3c35 <exit>
      printf(1, "read bigfile wrong data\n");
    27a6:	83 ec 08             	sub    $0x8,%esp
    27a9:	68 54 4b 00 00       	push   $0x4b54
    27ae:	6a 01                	push   $0x1
    27b0:	e8 d3 15 00 00       	call   3d88 <printf>
      exit(0);
    27b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    27bc:	e8 74 14 00 00       	call   3c35 <exit>
  }
  close(fd);
    27c1:	83 ec 0c             	sub    $0xc,%esp
    27c4:	57                   	push   %edi
    27c5:	e8 93 14 00 00       	call   3c5d <close>
  if(total != 20*600){
    27ca:	83 c4 10             	add    $0x10,%esp
    27cd:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
    27d3:	75 27                	jne    27fc <bigfile+0x1cc>
    printf(1, "read bigfile wrong total\n");
    exit(0);
  }
  unlink("bigfile");
    27d5:	83 ec 0c             	sub    $0xc,%esp
    27d8:	68 f8 4a 00 00       	push   $0x4af8
    27dd:	e8 a3 14 00 00       	call   3c85 <unlink>

  printf(1, "bigfile test ok\n");
    27e2:	83 c4 08             	add    $0x8,%esp
    27e5:	68 87 4b 00 00       	push   $0x4b87
    27ea:	6a 01                	push   $0x1
    27ec:	e8 97 15 00 00       	call   3d88 <printf>
}
    27f1:	83 c4 10             	add    $0x10,%esp
    27f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    27f7:	5b                   	pop    %ebx
    27f8:	5e                   	pop    %esi
    27f9:	5f                   	pop    %edi
    27fa:	5d                   	pop    %ebp
    27fb:	c3                   	ret
    printf(1, "read bigfile wrong total\n");
    27fc:	83 ec 08             	sub    $0x8,%esp
    27ff:	68 6d 4b 00 00       	push   $0x4b6d
    2804:	6a 01                	push   $0x1
    2806:	e8 7d 15 00 00       	call   3d88 <printf>
    exit(0);
    280b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2812:	e8 1e 14 00 00       	call   3c35 <exit>

00002817 <fourteen>:

void
fourteen(void)
{
    2817:	55                   	push   %ebp
    2818:	89 e5                	mov    %esp,%ebp
    281a:	83 ec 10             	sub    $0x10,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    281d:	68 98 4b 00 00       	push   $0x4b98
    2822:	6a 01                	push   $0x1
    2824:	e8 5f 15 00 00       	call   3d88 <printf>

  if(mkdir("12345678901234") != 0){
    2829:	c7 04 24 d3 4b 00 00 	movl   $0x4bd3,(%esp)
    2830:	e8 68 14 00 00       	call   3c9d <mkdir>
    2835:	83 c4 10             	add    $0x10,%esp
    2838:	85 c0                	test   %eax,%eax
    283a:	0f 85 a4 00 00 00    	jne    28e4 <fourteen+0xcd>
    printf(1, "mkdir 12345678901234 failed\n");
    exit(0);
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2840:	83 ec 0c             	sub    $0xc,%esp
    2843:	68 98 53 00 00       	push   $0x5398
    2848:	e8 50 14 00 00       	call   3c9d <mkdir>
    284d:	83 c4 10             	add    $0x10,%esp
    2850:	85 c0                	test   %eax,%eax
    2852:	0f 85 a7 00 00 00    	jne    28ff <fourteen+0xe8>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit(0);
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2858:	83 ec 08             	sub    $0x8,%esp
    285b:	68 00 02 00 00       	push   $0x200
    2860:	68 e8 53 00 00       	push   $0x53e8
    2865:	e8 0b 14 00 00       	call   3c75 <open>
  if(fd < 0){
    286a:	83 c4 10             	add    $0x10,%esp
    286d:	85 c0                	test   %eax,%eax
    286f:	0f 88 a5 00 00 00    	js     291a <fourteen+0x103>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit(0);
  }
  close(fd);
    2875:	83 ec 0c             	sub    $0xc,%esp
    2878:	50                   	push   %eax
    2879:	e8 df 13 00 00       	call   3c5d <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    287e:	83 c4 08             	add    $0x8,%esp
    2881:	6a 00                	push   $0x0
    2883:	68 58 54 00 00       	push   $0x5458
    2888:	e8 e8 13 00 00       	call   3c75 <open>
  if(fd < 0){
    288d:	83 c4 10             	add    $0x10,%esp
    2890:	85 c0                	test   %eax,%eax
    2892:	0f 88 9d 00 00 00    	js     2935 <fourteen+0x11e>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit(0);
  }
  close(fd);
    2898:	83 ec 0c             	sub    $0xc,%esp
    289b:	50                   	push   %eax
    289c:	e8 bc 13 00 00       	call   3c5d <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    28a1:	c7 04 24 c4 4b 00 00 	movl   $0x4bc4,(%esp)
    28a8:	e8 f0 13 00 00       	call   3c9d <mkdir>
    28ad:	83 c4 10             	add    $0x10,%esp
    28b0:	85 c0                	test   %eax,%eax
    28b2:	0f 84 98 00 00 00    	je     2950 <fourteen+0x139>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit(0);
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    28b8:	83 ec 0c             	sub    $0xc,%esp
    28bb:	68 f4 54 00 00       	push   $0x54f4
    28c0:	e8 d8 13 00 00       	call   3c9d <mkdir>
    28c5:	83 c4 10             	add    $0x10,%esp
    28c8:	85 c0                	test   %eax,%eax
    28ca:	0f 84 9b 00 00 00    	je     296b <fourteen+0x154>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit(0);
  }

  printf(1, "fourteen ok\n");
    28d0:	83 ec 08             	sub    $0x8,%esp
    28d3:	68 e2 4b 00 00       	push   $0x4be2
    28d8:	6a 01                	push   $0x1
    28da:	e8 a9 14 00 00       	call   3d88 <printf>
}
    28df:	83 c4 10             	add    $0x10,%esp
    28e2:	c9                   	leave
    28e3:	c3                   	ret
    printf(1, "mkdir 12345678901234 failed\n");
    28e4:	83 ec 08             	sub    $0x8,%esp
    28e7:	68 a7 4b 00 00       	push   $0x4ba7
    28ec:	6a 01                	push   $0x1
    28ee:	e8 95 14 00 00       	call   3d88 <printf>
    exit(0);
    28f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    28fa:	e8 36 13 00 00       	call   3c35 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    28ff:	83 ec 08             	sub    $0x8,%esp
    2902:	68 b8 53 00 00       	push   $0x53b8
    2907:	6a 01                	push   $0x1
    2909:	e8 7a 14 00 00       	call   3d88 <printf>
    exit(0);
    290e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2915:	e8 1b 13 00 00       	call   3c35 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    291a:	83 ec 08             	sub    $0x8,%esp
    291d:	68 18 54 00 00       	push   $0x5418
    2922:	6a 01                	push   $0x1
    2924:	e8 5f 14 00 00       	call   3d88 <printf>
    exit(0);
    2929:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2930:	e8 00 13 00 00       	call   3c35 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2935:	83 ec 08             	sub    $0x8,%esp
    2938:	68 88 54 00 00       	push   $0x5488
    293d:	6a 01                	push   $0x1
    293f:	e8 44 14 00 00       	call   3d88 <printf>
    exit(0);
    2944:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    294b:	e8 e5 12 00 00       	call   3c35 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2950:	83 ec 08             	sub    $0x8,%esp
    2953:	68 c4 54 00 00       	push   $0x54c4
    2958:	6a 01                	push   $0x1
    295a:	e8 29 14 00 00       	call   3d88 <printf>
    exit(0);
    295f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2966:	e8 ca 12 00 00       	call   3c35 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    296b:	83 ec 08             	sub    $0x8,%esp
    296e:	68 14 55 00 00       	push   $0x5514
    2973:	6a 01                	push   $0x1
    2975:	e8 0e 14 00 00       	call   3d88 <printf>
    exit(0);
    297a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2981:	e8 af 12 00 00       	call   3c35 <exit>

00002986 <rmdot>:

void
rmdot(void)
{
    2986:	55                   	push   %ebp
    2987:	89 e5                	mov    %esp,%ebp
    2989:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    298c:	68 ef 4b 00 00       	push   $0x4bef
    2991:	6a 01                	push   $0x1
    2993:	e8 f0 13 00 00       	call   3d88 <printf>
  if(mkdir("dots") != 0){
    2998:	c7 04 24 fb 4b 00 00 	movl   $0x4bfb,(%esp)
    299f:	e8 f9 12 00 00       	call   3c9d <mkdir>
    29a4:	83 c4 10             	add    $0x10,%esp
    29a7:	85 c0                	test   %eax,%eax
    29a9:	0f 85 bc 00 00 00    	jne    2a6b <rmdot+0xe5>
    printf(1, "mkdir dots failed\n");
    exit(0);
  }
  if(chdir("dots") != 0){
    29af:	83 ec 0c             	sub    $0xc,%esp
    29b2:	68 fb 4b 00 00       	push   $0x4bfb
    29b7:	e8 e9 12 00 00       	call   3ca5 <chdir>
    29bc:	83 c4 10             	add    $0x10,%esp
    29bf:	85 c0                	test   %eax,%eax
    29c1:	0f 85 bf 00 00 00    	jne    2a86 <rmdot+0x100>
    printf(1, "chdir dots failed\n");
    exit(0);
  }
  if(unlink(".") == 0){
    29c7:	83 ec 0c             	sub    $0xc,%esp
    29ca:	68 a6 48 00 00       	push   $0x48a6
    29cf:	e8 b1 12 00 00       	call   3c85 <unlink>
    29d4:	83 c4 10             	add    $0x10,%esp
    29d7:	85 c0                	test   %eax,%eax
    29d9:	0f 84 c2 00 00 00    	je     2aa1 <rmdot+0x11b>
    printf(1, "rm . worked!\n");
    exit(0);
  }
  if(unlink("..") == 0){
    29df:	83 ec 0c             	sub    $0xc,%esp
    29e2:	68 a5 48 00 00       	push   $0x48a5
    29e7:	e8 99 12 00 00       	call   3c85 <unlink>
    29ec:	83 c4 10             	add    $0x10,%esp
    29ef:	85 c0                	test   %eax,%eax
    29f1:	0f 84 c5 00 00 00    	je     2abc <rmdot+0x136>
    printf(1, "rm .. worked!\n");
    exit(0);
  }
  if(chdir("/") != 0){
    29f7:	83 ec 0c             	sub    $0xc,%esp
    29fa:	68 79 40 00 00       	push   $0x4079
    29ff:	e8 a1 12 00 00       	call   3ca5 <chdir>
    2a04:	83 c4 10             	add    $0x10,%esp
    2a07:	85 c0                	test   %eax,%eax
    2a09:	0f 85 c8 00 00 00    	jne    2ad7 <rmdot+0x151>
    printf(1, "chdir / failed\n");
    exit(0);
  }
  if(unlink("dots/.") == 0){
    2a0f:	83 ec 0c             	sub    $0xc,%esp
    2a12:	68 43 4c 00 00       	push   $0x4c43
    2a17:	e8 69 12 00 00       	call   3c85 <unlink>
    2a1c:	83 c4 10             	add    $0x10,%esp
    2a1f:	85 c0                	test   %eax,%eax
    2a21:	0f 84 cb 00 00 00    	je     2af2 <rmdot+0x16c>
    printf(1, "unlink dots/. worked!\n");
    exit(0);
  }
  if(unlink("dots/..") == 0){
    2a27:	83 ec 0c             	sub    $0xc,%esp
    2a2a:	68 61 4c 00 00       	push   $0x4c61
    2a2f:	e8 51 12 00 00       	call   3c85 <unlink>
    2a34:	83 c4 10             	add    $0x10,%esp
    2a37:	85 c0                	test   %eax,%eax
    2a39:	0f 84 ce 00 00 00    	je     2b0d <rmdot+0x187>
    printf(1, "unlink dots/.. worked!\n");
    exit(0);
  }
  if(unlink("dots") != 0){
    2a3f:	83 ec 0c             	sub    $0xc,%esp
    2a42:	68 fb 4b 00 00       	push   $0x4bfb
    2a47:	e8 39 12 00 00       	call   3c85 <unlink>
    2a4c:	83 c4 10             	add    $0x10,%esp
    2a4f:	85 c0                	test   %eax,%eax
    2a51:	0f 85 d1 00 00 00    	jne    2b28 <rmdot+0x1a2>
    printf(1, "unlink dots failed!\n");
    exit(0);
  }
  printf(1, "rmdot ok\n");
    2a57:	83 ec 08             	sub    $0x8,%esp
    2a5a:	68 96 4c 00 00       	push   $0x4c96
    2a5f:	6a 01                	push   $0x1
    2a61:	e8 22 13 00 00       	call   3d88 <printf>
}
    2a66:	83 c4 10             	add    $0x10,%esp
    2a69:	c9                   	leave
    2a6a:	c3                   	ret
    printf(1, "mkdir dots failed\n");
    2a6b:	83 ec 08             	sub    $0x8,%esp
    2a6e:	68 00 4c 00 00       	push   $0x4c00
    2a73:	6a 01                	push   $0x1
    2a75:	e8 0e 13 00 00       	call   3d88 <printf>
    exit(0);
    2a7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2a81:	e8 af 11 00 00       	call   3c35 <exit>
    printf(1, "chdir dots failed\n");
    2a86:	83 ec 08             	sub    $0x8,%esp
    2a89:	68 13 4c 00 00       	push   $0x4c13
    2a8e:	6a 01                	push   $0x1
    2a90:	e8 f3 12 00 00       	call   3d88 <printf>
    exit(0);
    2a95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2a9c:	e8 94 11 00 00       	call   3c35 <exit>
    printf(1, "rm . worked!\n");
    2aa1:	83 ec 08             	sub    $0x8,%esp
    2aa4:	68 26 4c 00 00       	push   $0x4c26
    2aa9:	6a 01                	push   $0x1
    2aab:	e8 d8 12 00 00       	call   3d88 <printf>
    exit(0);
    2ab0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ab7:	e8 79 11 00 00       	call   3c35 <exit>
    printf(1, "rm .. worked!\n");
    2abc:	83 ec 08             	sub    $0x8,%esp
    2abf:	68 34 4c 00 00       	push   $0x4c34
    2ac4:	6a 01                	push   $0x1
    2ac6:	e8 bd 12 00 00       	call   3d88 <printf>
    exit(0);
    2acb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ad2:	e8 5e 11 00 00       	call   3c35 <exit>
    printf(1, "chdir / failed\n");
    2ad7:	83 ec 08             	sub    $0x8,%esp
    2ada:	68 7b 40 00 00       	push   $0x407b
    2adf:	6a 01                	push   $0x1
    2ae1:	e8 a2 12 00 00       	call   3d88 <printf>
    exit(0);
    2ae6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2aed:	e8 43 11 00 00       	call   3c35 <exit>
    printf(1, "unlink dots/. worked!\n");
    2af2:	83 ec 08             	sub    $0x8,%esp
    2af5:	68 4a 4c 00 00       	push   $0x4c4a
    2afa:	6a 01                	push   $0x1
    2afc:	e8 87 12 00 00       	call   3d88 <printf>
    exit(0);
    2b01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b08:	e8 28 11 00 00       	call   3c35 <exit>
    printf(1, "unlink dots/.. worked!\n");
    2b0d:	83 ec 08             	sub    $0x8,%esp
    2b10:	68 69 4c 00 00       	push   $0x4c69
    2b15:	6a 01                	push   $0x1
    2b17:	e8 6c 12 00 00       	call   3d88 <printf>
    exit(0);
    2b1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b23:	e8 0d 11 00 00       	call   3c35 <exit>
    printf(1, "unlink dots failed!\n");
    2b28:	83 ec 08             	sub    $0x8,%esp
    2b2b:	68 81 4c 00 00       	push   $0x4c81
    2b30:	6a 01                	push   $0x1
    2b32:	e8 51 12 00 00       	call   3d88 <printf>
    exit(0);
    2b37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b3e:	e8 f2 10 00 00       	call   3c35 <exit>

00002b43 <dirfile>:

void
dirfile(void)
{
    2b43:	55                   	push   %ebp
    2b44:	89 e5                	mov    %esp,%ebp
    2b46:	53                   	push   %ebx
    2b47:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "dir vs file\n");
    2b4a:	68 a0 4c 00 00       	push   $0x4ca0
    2b4f:	6a 01                	push   $0x1
    2b51:	e8 32 12 00 00       	call   3d88 <printf>

  fd = open("dirfile", O_CREATE);
    2b56:	83 c4 08             	add    $0x8,%esp
    2b59:	68 00 02 00 00       	push   $0x200
    2b5e:	68 ad 4c 00 00       	push   $0x4cad
    2b63:	e8 0d 11 00 00       	call   3c75 <open>
  if(fd < 0){
    2b68:	83 c4 10             	add    $0x10,%esp
    2b6b:	85 c0                	test   %eax,%eax
    2b6d:	0f 88 22 01 00 00    	js     2c95 <dirfile+0x152>
    printf(1, "create dirfile failed\n");
    exit(0);
  }
  close(fd);
    2b73:	83 ec 0c             	sub    $0xc,%esp
    2b76:	50                   	push   %eax
    2b77:	e8 e1 10 00 00       	call   3c5d <close>
  if(chdir("dirfile") == 0){
    2b7c:	c7 04 24 ad 4c 00 00 	movl   $0x4cad,(%esp)
    2b83:	e8 1d 11 00 00       	call   3ca5 <chdir>
    2b88:	83 c4 10             	add    $0x10,%esp
    2b8b:	85 c0                	test   %eax,%eax
    2b8d:	0f 84 1d 01 00 00    	je     2cb0 <dirfile+0x16d>
    printf(1, "chdir dirfile succeeded!\n");
    exit(0);
  }
  fd = open("dirfile/xx", 0);
    2b93:	83 ec 08             	sub    $0x8,%esp
    2b96:	6a 00                	push   $0x0
    2b98:	68 e6 4c 00 00       	push   $0x4ce6
    2b9d:	e8 d3 10 00 00       	call   3c75 <open>
  if(fd >= 0){
    2ba2:	83 c4 10             	add    $0x10,%esp
    2ba5:	85 c0                	test   %eax,%eax
    2ba7:	0f 89 1e 01 00 00    	jns    2ccb <dirfile+0x188>
    printf(1, "create dirfile/xx succeeded!\n");
    exit(0);
  }
  fd = open("dirfile/xx", O_CREATE);
    2bad:	83 ec 08             	sub    $0x8,%esp
    2bb0:	68 00 02 00 00       	push   $0x200
    2bb5:	68 e6 4c 00 00       	push   $0x4ce6
    2bba:	e8 b6 10 00 00       	call   3c75 <open>
  if(fd >= 0){
    2bbf:	83 c4 10             	add    $0x10,%esp
    2bc2:	85 c0                	test   %eax,%eax
    2bc4:	0f 89 1c 01 00 00    	jns    2ce6 <dirfile+0x1a3>
    printf(1, "create dirfile/xx succeeded!\n");
    exit(0);
  }
  if(mkdir("dirfile/xx") == 0){
    2bca:	83 ec 0c             	sub    $0xc,%esp
    2bcd:	68 e6 4c 00 00       	push   $0x4ce6
    2bd2:	e8 c6 10 00 00       	call   3c9d <mkdir>
    2bd7:	83 c4 10             	add    $0x10,%esp
    2bda:	85 c0                	test   %eax,%eax
    2bdc:	0f 84 1f 01 00 00    	je     2d01 <dirfile+0x1be>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit(0);
  }
  if(unlink("dirfile/xx") == 0){
    2be2:	83 ec 0c             	sub    $0xc,%esp
    2be5:	68 e6 4c 00 00       	push   $0x4ce6
    2bea:	e8 96 10 00 00       	call   3c85 <unlink>
    2bef:	83 c4 10             	add    $0x10,%esp
    2bf2:	85 c0                	test   %eax,%eax
    2bf4:	0f 84 22 01 00 00    	je     2d1c <dirfile+0x1d9>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit(0);
  }
  if(link("README", "dirfile/xx") == 0){
    2bfa:	83 ec 08             	sub    $0x8,%esp
    2bfd:	68 e6 4c 00 00       	push   $0x4ce6
    2c02:	68 4a 4d 00 00       	push   $0x4d4a
    2c07:	e8 89 10 00 00       	call   3c95 <link>
    2c0c:	83 c4 10             	add    $0x10,%esp
    2c0f:	85 c0                	test   %eax,%eax
    2c11:	0f 84 20 01 00 00    	je     2d37 <dirfile+0x1f4>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit(0);
  }
  if(unlink("dirfile") != 0){
    2c17:	83 ec 0c             	sub    $0xc,%esp
    2c1a:	68 ad 4c 00 00       	push   $0x4cad
    2c1f:	e8 61 10 00 00       	call   3c85 <unlink>
    2c24:	83 c4 10             	add    $0x10,%esp
    2c27:	85 c0                	test   %eax,%eax
    2c29:	0f 85 23 01 00 00    	jne    2d52 <dirfile+0x20f>
    printf(1, "unlink dirfile failed!\n");
    exit(0);
  }

  fd = open(".", O_RDWR);
    2c2f:	83 ec 08             	sub    $0x8,%esp
    2c32:	6a 02                	push   $0x2
    2c34:	68 a6 48 00 00       	push   $0x48a6
    2c39:	e8 37 10 00 00       	call   3c75 <open>
  if(fd >= 0){
    2c3e:	83 c4 10             	add    $0x10,%esp
    2c41:	85 c0                	test   %eax,%eax
    2c43:	0f 89 24 01 00 00    	jns    2d6d <dirfile+0x22a>
    printf(1, "open . for writing succeeded!\n");
    exit(0);
  }
  fd = open(".", 0);
    2c49:	83 ec 08             	sub    $0x8,%esp
    2c4c:	6a 00                	push   $0x0
    2c4e:	68 a6 48 00 00       	push   $0x48a6
    2c53:	e8 1d 10 00 00       	call   3c75 <open>
    2c58:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    2c5a:	83 c4 0c             	add    $0xc,%esp
    2c5d:	6a 01                	push   $0x1
    2c5f:	68 89 49 00 00       	push   $0x4989
    2c64:	50                   	push   %eax
    2c65:	e8 eb 0f 00 00       	call   3c55 <write>
    2c6a:	83 c4 10             	add    $0x10,%esp
    2c6d:	85 c0                	test   %eax,%eax
    2c6f:	0f 8f 13 01 00 00    	jg     2d88 <dirfile+0x245>
    printf(1, "write . succeeded!\n");
    exit(0);
  }
  close(fd);
    2c75:	83 ec 0c             	sub    $0xc,%esp
    2c78:	53                   	push   %ebx
    2c79:	e8 df 0f 00 00       	call   3c5d <close>

  printf(1, "dir vs file OK\n");
    2c7e:	83 c4 08             	add    $0x8,%esp
    2c81:	68 7d 4d 00 00       	push   $0x4d7d
    2c86:	6a 01                	push   $0x1
    2c88:	e8 fb 10 00 00       	call   3d88 <printf>
}
    2c8d:	83 c4 10             	add    $0x10,%esp
    2c90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2c93:	c9                   	leave
    2c94:	c3                   	ret
    printf(1, "create dirfile failed\n");
    2c95:	83 ec 08             	sub    $0x8,%esp
    2c98:	68 b5 4c 00 00       	push   $0x4cb5
    2c9d:	6a 01                	push   $0x1
    2c9f:	e8 e4 10 00 00       	call   3d88 <printf>
    exit(0);
    2ca4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2cab:	e8 85 0f 00 00       	call   3c35 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    2cb0:	83 ec 08             	sub    $0x8,%esp
    2cb3:	68 cc 4c 00 00       	push   $0x4ccc
    2cb8:	6a 01                	push   $0x1
    2cba:	e8 c9 10 00 00       	call   3d88 <printf>
    exit(0);
    2cbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2cc6:	e8 6a 0f 00 00       	call   3c35 <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    2ccb:	83 ec 08             	sub    $0x8,%esp
    2cce:	68 f1 4c 00 00       	push   $0x4cf1
    2cd3:	6a 01                	push   $0x1
    2cd5:	e8 ae 10 00 00       	call   3d88 <printf>
    exit(0);
    2cda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ce1:	e8 4f 0f 00 00       	call   3c35 <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    2ce6:	83 ec 08             	sub    $0x8,%esp
    2ce9:	68 f1 4c 00 00       	push   $0x4cf1
    2cee:	6a 01                	push   $0x1
    2cf0:	e8 93 10 00 00       	call   3d88 <printf>
    exit(0);
    2cf5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2cfc:	e8 34 0f 00 00       	call   3c35 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2d01:	83 ec 08             	sub    $0x8,%esp
    2d04:	68 0f 4d 00 00       	push   $0x4d0f
    2d09:	6a 01                	push   $0x1
    2d0b:	e8 78 10 00 00       	call   3d88 <printf>
    exit(0);
    2d10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d17:	e8 19 0f 00 00       	call   3c35 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2d1c:	83 ec 08             	sub    $0x8,%esp
    2d1f:	68 2c 4d 00 00       	push   $0x4d2c
    2d24:	6a 01                	push   $0x1
    2d26:	e8 5d 10 00 00       	call   3d88 <printf>
    exit(0);
    2d2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d32:	e8 fe 0e 00 00       	call   3c35 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    2d37:	83 ec 08             	sub    $0x8,%esp
    2d3a:	68 48 55 00 00       	push   $0x5548
    2d3f:	6a 01                	push   $0x1
    2d41:	e8 42 10 00 00       	call   3d88 <printf>
    exit(0);
    2d46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d4d:	e8 e3 0e 00 00       	call   3c35 <exit>
    printf(1, "unlink dirfile failed!\n");
    2d52:	83 ec 08             	sub    $0x8,%esp
    2d55:	68 51 4d 00 00       	push   $0x4d51
    2d5a:	6a 01                	push   $0x1
    2d5c:	e8 27 10 00 00       	call   3d88 <printf>
    exit(0);
    2d61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d68:	e8 c8 0e 00 00       	call   3c35 <exit>
    printf(1, "open . for writing succeeded!\n");
    2d6d:	83 ec 08             	sub    $0x8,%esp
    2d70:	68 68 55 00 00       	push   $0x5568
    2d75:	6a 01                	push   $0x1
    2d77:	e8 0c 10 00 00       	call   3d88 <printf>
    exit(0);
    2d7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d83:	e8 ad 0e 00 00       	call   3c35 <exit>
    printf(1, "write . succeeded!\n");
    2d88:	83 ec 08             	sub    $0x8,%esp
    2d8b:	68 69 4d 00 00       	push   $0x4d69
    2d90:	6a 01                	push   $0x1
    2d92:	e8 f1 0f 00 00       	call   3d88 <printf>
    exit(0);
    2d97:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d9e:	e8 92 0e 00 00       	call   3c35 <exit>

00002da3 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2da3:	55                   	push   %ebp
    2da4:	89 e5                	mov    %esp,%ebp
    2da6:	53                   	push   %ebx
    2da7:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2daa:	68 8d 4d 00 00       	push   $0x4d8d
    2daf:	6a 01                	push   $0x1
    2db1:	e8 d2 0f 00 00       	call   3d88 <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2db6:	83 c4 10             	add    $0x10,%esp
    2db9:	bb 00 00 00 00       	mov    $0x0,%ebx
    2dbe:	eb 55                	jmp    2e15 <iref+0x72>
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
    2dc0:	83 ec 08             	sub    $0x8,%esp
    2dc3:	68 a4 4d 00 00       	push   $0x4da4
    2dc8:	6a 01                	push   $0x1
    2dca:	e8 b9 0f 00 00       	call   3d88 <printf>
      exit(0);
    2dcf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2dd6:	e8 5a 0e 00 00       	call   3c35 <exit>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
    2ddb:	83 ec 08             	sub    $0x8,%esp
    2dde:	68 b8 4d 00 00       	push   $0x4db8
    2de3:	6a 01                	push   $0x1
    2de5:	e8 9e 0f 00 00       	call   3d88 <printf>
      exit(0);
    2dea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2df1:	e8 3f 0e 00 00       	call   3c35 <exit>

    mkdir("");
    link("README", "");
    fd = open("", O_CREATE);
    if(fd >= 0)
      close(fd);
    2df6:	83 ec 0c             	sub    $0xc,%esp
    2df9:	50                   	push   %eax
    2dfa:	e8 5e 0e 00 00       	call   3c5d <close>
    2dff:	83 c4 10             	add    $0x10,%esp
    2e02:	eb 7e                	jmp    2e82 <iref+0xdf>
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
    2e04:	83 ec 0c             	sub    $0xc,%esp
    2e07:	68 88 49 00 00       	push   $0x4988
    2e0c:	e8 74 0e 00 00       	call   3c85 <unlink>
  for(i = 0; i < 50 + 1; i++){
    2e11:	43                   	inc    %ebx
    2e12:	83 c4 10             	add    $0x10,%esp
    2e15:	83 fb 32             	cmp    $0x32,%ebx
    2e18:	0f 8f 92 00 00 00    	jg     2eb0 <iref+0x10d>
    if(mkdir("irefd") != 0){
    2e1e:	83 ec 0c             	sub    $0xc,%esp
    2e21:	68 9e 4d 00 00       	push   $0x4d9e
    2e26:	e8 72 0e 00 00       	call   3c9d <mkdir>
    2e2b:	83 c4 10             	add    $0x10,%esp
    2e2e:	85 c0                	test   %eax,%eax
    2e30:	75 8e                	jne    2dc0 <iref+0x1d>
    if(chdir("irefd") != 0){
    2e32:	83 ec 0c             	sub    $0xc,%esp
    2e35:	68 9e 4d 00 00       	push   $0x4d9e
    2e3a:	e8 66 0e 00 00       	call   3ca5 <chdir>
    2e3f:	83 c4 10             	add    $0x10,%esp
    2e42:	85 c0                	test   %eax,%eax
    2e44:	75 95                	jne    2ddb <iref+0x38>
    mkdir("");
    2e46:	83 ec 0c             	sub    $0xc,%esp
    2e49:	68 53 44 00 00       	push   $0x4453
    2e4e:	e8 4a 0e 00 00       	call   3c9d <mkdir>
    link("README", "");
    2e53:	83 c4 08             	add    $0x8,%esp
    2e56:	68 53 44 00 00       	push   $0x4453
    2e5b:	68 4a 4d 00 00       	push   $0x4d4a
    2e60:	e8 30 0e 00 00       	call   3c95 <link>
    fd = open("", O_CREATE);
    2e65:	83 c4 08             	add    $0x8,%esp
    2e68:	68 00 02 00 00       	push   $0x200
    2e6d:	68 53 44 00 00       	push   $0x4453
    2e72:	e8 fe 0d 00 00       	call   3c75 <open>
    if(fd >= 0)
    2e77:	83 c4 10             	add    $0x10,%esp
    2e7a:	85 c0                	test   %eax,%eax
    2e7c:	0f 89 74 ff ff ff    	jns    2df6 <iref+0x53>
    fd = open("xx", O_CREATE);
    2e82:	83 ec 08             	sub    $0x8,%esp
    2e85:	68 00 02 00 00       	push   $0x200
    2e8a:	68 88 49 00 00       	push   $0x4988
    2e8f:	e8 e1 0d 00 00       	call   3c75 <open>
    if(fd >= 0)
    2e94:	83 c4 10             	add    $0x10,%esp
    2e97:	85 c0                	test   %eax,%eax
    2e99:	0f 88 65 ff ff ff    	js     2e04 <iref+0x61>
      close(fd);
    2e9f:	83 ec 0c             	sub    $0xc,%esp
    2ea2:	50                   	push   %eax
    2ea3:	e8 b5 0d 00 00       	call   3c5d <close>
    2ea8:	83 c4 10             	add    $0x10,%esp
    2eab:	e9 54 ff ff ff       	jmp    2e04 <iref+0x61>
  }

  chdir("/");
    2eb0:	83 ec 0c             	sub    $0xc,%esp
    2eb3:	68 79 40 00 00       	push   $0x4079
    2eb8:	e8 e8 0d 00 00       	call   3ca5 <chdir>
  printf(1, "empty file name OK\n");
    2ebd:	83 c4 08             	add    $0x8,%esp
    2ec0:	68 cc 4d 00 00       	push   $0x4dcc
    2ec5:	6a 01                	push   $0x1
    2ec7:	e8 bc 0e 00 00       	call   3d88 <printf>
}
    2ecc:	83 c4 10             	add    $0x10,%esp
    2ecf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2ed2:	c9                   	leave
    2ed3:	c3                   	ret

00002ed4 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2ed4:	55                   	push   %ebp
    2ed5:	89 e5                	mov    %esp,%ebp
    2ed7:	53                   	push   %ebx
    2ed8:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
    2edb:	68 e0 4d 00 00       	push   $0x4de0
    2ee0:	6a 01                	push   $0x1
    2ee2:	e8 a1 0e 00 00       	call   3d88 <printf>

  for(n=0; n<1000; n++){
    2ee7:	83 c4 10             	add    $0x10,%esp
    2eea:	bb 00 00 00 00       	mov    $0x0,%ebx
    2eef:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
    2ef5:	7f 18                	jg     2f0f <forktest+0x3b>
    pid = fork();
    2ef7:	e8 31 0d 00 00       	call   3c2d <fork>
    if(pid < 0)
    2efc:	85 c0                	test   %eax,%eax
    2efe:	78 0f                	js     2f0f <forktest+0x3b>
      break;
    if(pid == 0)
    2f00:	74 03                	je     2f05 <forktest+0x31>
  for(n=0; n<1000; n++){
    2f02:	43                   	inc    %ebx
    2f03:	eb ea                	jmp    2eef <forktest+0x1b>
      exit(0);
    2f05:	83 ec 0c             	sub    $0xc,%esp
    2f08:	6a 00                	push   $0x0
    2f0a:	e8 26 0d 00 00       	call   3c35 <exit>
  }

  if(n == 1000){
    2f0f:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2f15:	74 18                	je     2f2f <forktest+0x5b>
    printf(1, "fork claimed to work 1000 times!\n");
    exit(0);
  }

  for(; n > 0; n--){
    2f17:	85 db                	test   %ebx,%ebx
    2f19:	7e 4a                	jle    2f65 <forktest+0x91>
    if(wait(NULL) < 0){
    2f1b:	83 ec 0c             	sub    $0xc,%esp
    2f1e:	6a 00                	push   $0x0
    2f20:	e8 18 0d 00 00       	call   3c3d <wait>
    2f25:	83 c4 10             	add    $0x10,%esp
    2f28:	85 c0                	test   %eax,%eax
    2f2a:	78 1e                	js     2f4a <forktest+0x76>
  for(; n > 0; n--){
    2f2c:	4b                   	dec    %ebx
    2f2d:	eb e8                	jmp    2f17 <forktest+0x43>
    printf(1, "fork claimed to work 1000 times!\n");
    2f2f:	83 ec 08             	sub    $0x8,%esp
    2f32:	68 88 55 00 00       	push   $0x5588
    2f37:	6a 01                	push   $0x1
    2f39:	e8 4a 0e 00 00       	call   3d88 <printf>
    exit(0);
    2f3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f45:	e8 eb 0c 00 00       	call   3c35 <exit>
      printf(1, "wait stopped early\n");
    2f4a:	83 ec 08             	sub    $0x8,%esp
    2f4d:	68 eb 4d 00 00       	push   $0x4deb
    2f52:	6a 01                	push   $0x1
    2f54:	e8 2f 0e 00 00       	call   3d88 <printf>
      exit(0);
    2f59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f60:	e8 d0 0c 00 00       	call   3c35 <exit>
    }
  }

  if(wait(NULL) != -1){
    2f65:	83 ec 0c             	sub    $0xc,%esp
    2f68:	6a 00                	push   $0x0
    2f6a:	e8 ce 0c 00 00       	call   3c3d <wait>
    2f6f:	83 c4 10             	add    $0x10,%esp
    2f72:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f75:	75 17                	jne    2f8e <forktest+0xba>
    printf(1, "wait got too many\n");
    exit(0);
  }

  printf(1, "fork test OK\n");
    2f77:	83 ec 08             	sub    $0x8,%esp
    2f7a:	68 12 4e 00 00       	push   $0x4e12
    2f7f:	6a 01                	push   $0x1
    2f81:	e8 02 0e 00 00       	call   3d88 <printf>
}
    2f86:	83 c4 10             	add    $0x10,%esp
    2f89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2f8c:	c9                   	leave
    2f8d:	c3                   	ret
    printf(1, "wait got too many\n");
    2f8e:	83 ec 08             	sub    $0x8,%esp
    2f91:	68 ff 4d 00 00       	push   $0x4dff
    2f96:	6a 01                	push   $0x1
    2f98:	e8 eb 0d 00 00       	call   3d88 <printf>
    exit(0);
    2f9d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fa4:	e8 8c 0c 00 00       	call   3c35 <exit>

00002fa9 <sbrktest>:

void
sbrktest(void)
{
    2fa9:	55                   	push   %ebp
    2faa:	89 e5                	mov    %esp,%ebp
    2fac:	57                   	push   %edi
    2fad:	56                   	push   %esi
    2fae:	53                   	push   %ebx
    2faf:	83 ec 54             	sub    $0x54,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    2fb2:	68 20 4e 00 00       	push   $0x4e20
    2fb7:	ff 35 d8 60 00 00    	push   0x60d8
    2fbd:	e8 c6 0d 00 00       	call   3d88 <printf>
  oldbrk = sbrk(0);
    2fc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fc9:	e8 ef 0c 00 00       	call   3cbd <sbrk>
    2fce:	89 c7                	mov    %eax,%edi

  // can one sbrk() less than a page?
  a = sbrk(0);
    2fd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fd7:	e8 e1 0c 00 00       	call   3cbd <sbrk>
    2fdc:	89 c6                	mov    %eax,%esi
  int i;
  for(i = 0; i < 5000; i++){
    2fde:	83 c4 10             	add    $0x10,%esp
    2fe1:	bb 00 00 00 00       	mov    $0x0,%ebx
    2fe6:	81 fb 87 13 00 00    	cmp    $0x1387,%ebx
    2fec:	7f 3a                	jg     3028 <sbrktest+0x7f>
    b = sbrk(1);
    2fee:	83 ec 0c             	sub    $0xc,%esp
    2ff1:	6a 01                	push   $0x1
    2ff3:	e8 c5 0c 00 00       	call   3cbd <sbrk>
    if(b != a){
    2ff8:	83 c4 10             	add    $0x10,%esp
    2ffb:	39 c6                	cmp    %eax,%esi
    2ffd:	75 09                	jne    3008 <sbrktest+0x5f>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
      exit(0);
    }
    *b = 1;
    2fff:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    3002:	8d 70 01             	lea    0x1(%eax),%esi
  for(i = 0; i < 5000; i++){
    3005:	43                   	inc    %ebx
    3006:	eb de                	jmp    2fe6 <sbrktest+0x3d>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    3008:	83 ec 0c             	sub    $0xc,%esp
    300b:	50                   	push   %eax
    300c:	56                   	push   %esi
    300d:	53                   	push   %ebx
    300e:	68 2b 4e 00 00       	push   $0x4e2b
    3013:	ff 35 d8 60 00 00    	push   0x60d8
    3019:	e8 6a 0d 00 00       	call   3d88 <printf>
      exit(0);
    301e:	83 c4 14             	add    $0x14,%esp
    3021:	6a 00                	push   $0x0
    3023:	e8 0d 0c 00 00       	call   3c35 <exit>
  }
  pid = fork();
    3028:	e8 00 0c 00 00       	call   3c2d <fork>
    302d:	89 c3                	mov    %eax,%ebx
  if(pid < 0){
    302f:	85 c0                	test   %eax,%eax
    3031:	0f 88 60 01 00 00    	js     3197 <sbrktest+0x1ee>
    printf(stdout, "sbrk test fork failed\n");
    exit(0);
  }
  c = sbrk(1);
    3037:	83 ec 0c             	sub    $0xc,%esp
    303a:	6a 01                	push   $0x1
    303c:	e8 7c 0c 00 00       	call   3cbd <sbrk>
  c = sbrk(1);
    3041:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3048:	e8 70 0c 00 00       	call   3cbd <sbrk>
  if(c != a + 1){
    304d:	46                   	inc    %esi
    304e:	83 c4 10             	add    $0x10,%esp
    3051:	39 c6                	cmp    %eax,%esi
    3053:	0f 85 5d 01 00 00    	jne    31b6 <sbrktest+0x20d>
    printf(stdout, "sbrk test failed post-fork\n");
    exit(0);
  }
  if(pid == 0)
    3059:	85 db                	test   %ebx,%ebx
    305b:	0f 84 74 01 00 00    	je     31d5 <sbrktest+0x22c>
    exit(0);
  wait(NULL);
    3061:	83 ec 0c             	sub    $0xc,%esp
    3064:	6a 00                	push   $0x0
    3066:	e8 d2 0b 00 00       	call   3c3d <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    306b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3072:	e8 46 0c 00 00       	call   3cbd <sbrk>
    3077:	89 c3                	mov    %eax,%ebx
  amt = (BIG) - (uint)a;
    3079:	b8 00 00 40 06       	mov    $0x6400000,%eax
    307e:	29 d8                	sub    %ebx,%eax
  p = sbrk(amt);
    3080:	89 04 24             	mov    %eax,(%esp)
    3083:	e8 35 0c 00 00       	call   3cbd <sbrk>
  if (p != a) {
    3088:	83 c4 10             	add    $0x10,%esp
    308b:	39 c3                	cmp    %eax,%ebx
    308d:	0f 85 4c 01 00 00    	jne    31df <sbrktest+0x236>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    exit(0);
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    3093:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff

  // can one de-allocate?
  a = sbrk(0);
    309a:	83 ec 0c             	sub    $0xc,%esp
    309d:	6a 00                	push   $0x0
    309f:	e8 19 0c 00 00       	call   3cbd <sbrk>
    30a4:	89 c3                	mov    %eax,%ebx
  c = sbrk(-4096);
    30a6:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    30ad:	e8 0b 0c 00 00       	call   3cbd <sbrk>
  if(c == (char*)0xffffffff){
    30b2:	83 c4 10             	add    $0x10,%esp
    30b5:	83 f8 ff             	cmp    $0xffffffff,%eax
    30b8:	0f 84 40 01 00 00    	je     31fe <sbrktest+0x255>
    printf(stdout, "sbrk could not deallocate\n");
    exit(0);
  }
  c = sbrk(0);
    30be:	83 ec 0c             	sub    $0xc,%esp
    30c1:	6a 00                	push   $0x0
    30c3:	e8 f5 0b 00 00       	call   3cbd <sbrk>
  if(c != a - 4096){
    30c8:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
    30ce:	83 c4 10             	add    $0x10,%esp
    30d1:	39 c2                	cmp    %eax,%edx
    30d3:	0f 85 44 01 00 00    	jne    321d <sbrktest+0x274>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit(0);
  }

  // can one re-allocate that page?
  a = sbrk(0);
    30d9:	83 ec 0c             	sub    $0xc,%esp
    30dc:	6a 00                	push   $0x0
    30de:	e8 da 0b 00 00       	call   3cbd <sbrk>
    30e3:	89 c3                	mov    %eax,%ebx
  c = sbrk(4096);
    30e5:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    30ec:	e8 cc 0b 00 00       	call   3cbd <sbrk>
    30f1:	89 c6                	mov    %eax,%esi
  if(c != a || sbrk(0) != a + 4096){
    30f3:	83 c4 10             	add    $0x10,%esp
    30f6:	39 c3                	cmp    %eax,%ebx
    30f8:	0f 85 3d 01 00 00    	jne    323b <sbrktest+0x292>
    30fe:	83 ec 0c             	sub    $0xc,%esp
    3101:	6a 00                	push   $0x0
    3103:	e8 b5 0b 00 00       	call   3cbd <sbrk>
    3108:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
    310e:	83 c4 10             	add    $0x10,%esp
    3111:	39 c2                	cmp    %eax,%edx
    3113:	0f 85 22 01 00 00    	jne    323b <sbrktest+0x292>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit(0);
  }
  if(*lastaddr == 99){
    3119:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    3120:	0f 84 33 01 00 00    	je     3259 <sbrktest+0x2b0>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit(0);
  }

  a = sbrk(0);
    3126:	83 ec 0c             	sub    $0xc,%esp
    3129:	6a 00                	push   $0x0
    312b:	e8 8d 0b 00 00       	call   3cbd <sbrk>
    3130:	89 c3                	mov    %eax,%ebx
  c = sbrk(-(sbrk(0) - oldbrk));
    3132:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3139:	e8 7f 0b 00 00       	call   3cbd <sbrk>
    313e:	89 c2                	mov    %eax,%edx
    3140:	89 f8                	mov    %edi,%eax
    3142:	29 d0                	sub    %edx,%eax
    3144:	89 04 24             	mov    %eax,(%esp)
    3147:	e8 71 0b 00 00       	call   3cbd <sbrk>
  if(c != a){
    314c:	83 c4 10             	add    $0x10,%esp
    314f:	39 c3                	cmp    %eax,%ebx
    3151:	0f 85 21 01 00 00    	jne    3278 <sbrktest+0x2cf>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit(0);
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3157:	bb 00 00 00 80       	mov    $0x80000000,%ebx
    315c:	81 fb 7f 84 1e 80    	cmp    $0x801e847f,%ebx
    3162:	0f 87 76 01 00 00    	ja     32de <sbrktest+0x335>
    ppid = getpid();
    3168:	e8 48 0b 00 00       	call   3cb5 <getpid>
    316d:	89 c6                	mov    %eax,%esi
    pid = fork();
    316f:	e8 b9 0a 00 00       	call   3c2d <fork>
    if(pid < 0){
    3174:	85 c0                	test   %eax,%eax
    3176:	0f 88 1a 01 00 00    	js     3296 <sbrktest+0x2ed>
      printf(stdout, "fork failed\n");
      exit(0);
    }
    if(pid == 0){
    317c:	0f 84 33 01 00 00    	je     32b5 <sbrktest+0x30c>
      printf(stdout, "oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit(0);
    }
    wait(NULL);
    3182:	83 ec 0c             	sub    $0xc,%esp
    3185:	6a 00                	push   $0x0
    3187:	e8 b1 0a 00 00       	call   3c3d <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    318c:	81 c3 50 c3 00 00    	add    $0xc350,%ebx
    3192:	83 c4 10             	add    $0x10,%esp
    3195:	eb c5                	jmp    315c <sbrktest+0x1b3>
    printf(stdout, "sbrk test fork failed\n");
    3197:	83 ec 08             	sub    $0x8,%esp
    319a:	68 46 4e 00 00       	push   $0x4e46
    319f:	ff 35 d8 60 00 00    	push   0x60d8
    31a5:	e8 de 0b 00 00       	call   3d88 <printf>
    exit(0);
    31aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    31b1:	e8 7f 0a 00 00       	call   3c35 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    31b6:	83 ec 08             	sub    $0x8,%esp
    31b9:	68 5d 4e 00 00       	push   $0x4e5d
    31be:	ff 35 d8 60 00 00    	push   0x60d8
    31c4:	e8 bf 0b 00 00       	call   3d88 <printf>
    exit(0);
    31c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    31d0:	e8 60 0a 00 00       	call   3c35 <exit>
    exit(0);
    31d5:	83 ec 0c             	sub    $0xc,%esp
    31d8:	6a 00                	push   $0x0
    31da:	e8 56 0a 00 00       	call   3c35 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    31df:	83 ec 08             	sub    $0x8,%esp
    31e2:	68 ac 55 00 00       	push   $0x55ac
    31e7:	ff 35 d8 60 00 00    	push   0x60d8
    31ed:	e8 96 0b 00 00       	call   3d88 <printf>
    exit(0);
    31f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    31f9:	e8 37 0a 00 00       	call   3c35 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    31fe:	83 ec 08             	sub    $0x8,%esp
    3201:	68 79 4e 00 00       	push   $0x4e79
    3206:	ff 35 d8 60 00 00    	push   0x60d8
    320c:	e8 77 0b 00 00       	call   3d88 <printf>
    exit(0);
    3211:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3218:	e8 18 0a 00 00       	call   3c35 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    321d:	50                   	push   %eax
    321e:	53                   	push   %ebx
    321f:	68 ec 55 00 00       	push   $0x55ec
    3224:	ff 35 d8 60 00 00    	push   0x60d8
    322a:	e8 59 0b 00 00       	call   3d88 <printf>
    exit(0);
    322f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3236:	e8 fa 09 00 00       	call   3c35 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    323b:	56                   	push   %esi
    323c:	53                   	push   %ebx
    323d:	68 24 56 00 00       	push   $0x5624
    3242:	ff 35 d8 60 00 00    	push   0x60d8
    3248:	e8 3b 0b 00 00       	call   3d88 <printf>
    exit(0);
    324d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3254:	e8 dc 09 00 00       	call   3c35 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    3259:	83 ec 08             	sub    $0x8,%esp
    325c:	68 4c 56 00 00       	push   $0x564c
    3261:	ff 35 d8 60 00 00    	push   0x60d8
    3267:	e8 1c 0b 00 00       	call   3d88 <printf>
    exit(0);
    326c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3273:	e8 bd 09 00 00       	call   3c35 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    3278:	50                   	push   %eax
    3279:	53                   	push   %ebx
    327a:	68 7c 56 00 00       	push   $0x567c
    327f:	ff 35 d8 60 00 00    	push   0x60d8
    3285:	e8 fe 0a 00 00       	call   3d88 <printf>
    exit(0);
    328a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3291:	e8 9f 09 00 00       	call   3c35 <exit>
      printf(stdout, "fork failed\n");
    3296:	83 ec 08             	sub    $0x8,%esp
    3299:	68 71 4f 00 00       	push   $0x4f71
    329e:	ff 35 d8 60 00 00    	push   0x60d8
    32a4:	e8 df 0a 00 00       	call   3d88 <printf>
      exit(0);
    32a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32b0:	e8 80 09 00 00       	call   3c35 <exit>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    32b5:	0f be 03             	movsbl (%ebx),%eax
    32b8:	50                   	push   %eax
    32b9:	53                   	push   %ebx
    32ba:	68 94 4e 00 00       	push   $0x4e94
    32bf:	ff 35 d8 60 00 00    	push   0x60d8
    32c5:	e8 be 0a 00 00       	call   3d88 <printf>
      kill(ppid);
    32ca:	89 34 24             	mov    %esi,(%esp)
    32cd:	e8 93 09 00 00       	call   3c65 <kill>
      exit(0);
    32d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32d9:	e8 57 09 00 00       	call   3c35 <exit>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    32de:	83 ec 0c             	sub    $0xc,%esp
    32e1:	8d 45 e0             	lea    -0x20(%ebp),%eax
    32e4:	50                   	push   %eax
    32e5:	e8 5b 09 00 00       	call   3c45 <pipe>
    32ea:	89 c3                	mov    %eax,%ebx
    32ec:	83 c4 10             	add    $0x10,%esp
    32ef:	85 c0                	test   %eax,%eax
    32f1:	75 04                	jne    32f7 <sbrktest+0x34e>
    printf(1, "pipe() failed\n");
    exit(0);
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    32f3:	89 c6                	mov    %eax,%esi
    32f5:	eb 5e                	jmp    3355 <sbrktest+0x3ac>
    printf(1, "pipe() failed\n");
    32f7:	83 ec 08             	sub    $0x8,%esp
    32fa:	68 69 43 00 00       	push   $0x4369
    32ff:	6a 01                	push   $0x1
    3301:	e8 82 0a 00 00       	call   3d88 <printf>
    exit(0);
    3306:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    330d:	e8 23 09 00 00       	call   3c35 <exit>
    if((pids[i] = fork()) == 0){
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    3312:	83 ec 0c             	sub    $0xc,%esp
    3315:	6a 00                	push   $0x0
    3317:	e8 a1 09 00 00       	call   3cbd <sbrk>
    331c:	89 c2                	mov    %eax,%edx
    331e:	b8 00 00 40 06       	mov    $0x6400000,%eax
    3323:	29 d0                	sub    %edx,%eax
    3325:	89 04 24             	mov    %eax,(%esp)
    3328:	e8 90 09 00 00       	call   3cbd <sbrk>
      write(fds[1], "x", 1);
    332d:	83 c4 0c             	add    $0xc,%esp
    3330:	6a 01                	push   $0x1
    3332:	68 89 49 00 00       	push   $0x4989
    3337:	ff 75 e4             	push   -0x1c(%ebp)
    333a:	e8 16 09 00 00       	call   3c55 <write>
    333f:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    3342:	83 ec 0c             	sub    $0xc,%esp
    3345:	68 e8 03 00 00       	push   $0x3e8
    334a:	e8 76 09 00 00       	call   3cc5 <sleep>
    334f:	83 c4 10             	add    $0x10,%esp
    3352:	eb ee                	jmp    3342 <sbrktest+0x399>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3354:	46                   	inc    %esi
    3355:	83 fe 09             	cmp    $0x9,%esi
    3358:	77 28                	ja     3382 <sbrktest+0x3d9>
    if((pids[i] = fork()) == 0){
    335a:	e8 ce 08 00 00       	call   3c2d <fork>
    335f:	89 44 b5 b8          	mov    %eax,-0x48(%ebp,%esi,4)
    3363:	85 c0                	test   %eax,%eax
    3365:	74 ab                	je     3312 <sbrktest+0x369>
    }
    if(pids[i] != -1)
    3367:	83 f8 ff             	cmp    $0xffffffff,%eax
    336a:	74 e8                	je     3354 <sbrktest+0x3ab>
      read(fds[0], &scratch, 1);
    336c:	83 ec 04             	sub    $0x4,%esp
    336f:	6a 01                	push   $0x1
    3371:	8d 45 b7             	lea    -0x49(%ebp),%eax
    3374:	50                   	push   %eax
    3375:	ff 75 e0             	push   -0x20(%ebp)
    3378:	e8 d0 08 00 00       	call   3c4d <read>
    337d:	83 c4 10             	add    $0x10,%esp
    3380:	eb d2                	jmp    3354 <sbrktest+0x3ab>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    3382:	83 ec 0c             	sub    $0xc,%esp
    3385:	68 00 10 00 00       	push   $0x1000
    338a:	e8 2e 09 00 00       	call   3cbd <sbrk>
    338f:	89 c6                	mov    %eax,%esi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3391:	83 c4 10             	add    $0x10,%esp
    3394:	eb 01                	jmp    3397 <sbrktest+0x3ee>
    3396:	43                   	inc    %ebx
    3397:	83 fb 09             	cmp    $0x9,%ebx
    339a:	77 23                	ja     33bf <sbrktest+0x416>
    if(pids[i] == -1)
    339c:	8b 44 9d b8          	mov    -0x48(%ebp,%ebx,4),%eax
    33a0:	83 f8 ff             	cmp    $0xffffffff,%eax
    33a3:	74 f1                	je     3396 <sbrktest+0x3ed>
      continue;
    kill(pids[i]);
    33a5:	83 ec 0c             	sub    $0xc,%esp
    33a8:	50                   	push   %eax
    33a9:	e8 b7 08 00 00       	call   3c65 <kill>
    wait(NULL);
    33ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33b5:	e8 83 08 00 00       	call   3c3d <wait>
    33ba:	83 c4 10             	add    $0x10,%esp
    33bd:	eb d7                	jmp    3396 <sbrktest+0x3ed>
  }
  if(c == (char*)0xffffffff){
    33bf:	83 fe ff             	cmp    $0xffffffff,%esi
    33c2:	74 2f                	je     33f3 <sbrktest+0x44a>
    printf(stdout, "failed sbrk leaked memory\n");
    exit(0);
  }

  if(sbrk(0) > oldbrk)
    33c4:	83 ec 0c             	sub    $0xc,%esp
    33c7:	6a 00                	push   $0x0
    33c9:	e8 ef 08 00 00       	call   3cbd <sbrk>
    33ce:	83 c4 10             	add    $0x10,%esp
    33d1:	39 c7                	cmp    %eax,%edi
    33d3:	72 3d                	jb     3412 <sbrktest+0x469>
    sbrk(-(sbrk(0) - oldbrk));

  printf(stdout, "sbrk test OK\n");
    33d5:	83 ec 08             	sub    $0x8,%esp
    33d8:	68 c8 4e 00 00       	push   $0x4ec8
    33dd:	ff 35 d8 60 00 00    	push   0x60d8
    33e3:	e8 a0 09 00 00       	call   3d88 <printf>
}
    33e8:	83 c4 10             	add    $0x10,%esp
    33eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
    33ee:	5b                   	pop    %ebx
    33ef:	5e                   	pop    %esi
    33f0:	5f                   	pop    %edi
    33f1:	5d                   	pop    %ebp
    33f2:	c3                   	ret
    printf(stdout, "failed sbrk leaked memory\n");
    33f3:	83 ec 08             	sub    $0x8,%esp
    33f6:	68 ad 4e 00 00       	push   $0x4ead
    33fb:	ff 35 d8 60 00 00    	push   0x60d8
    3401:	e8 82 09 00 00       	call   3d88 <printf>
    exit(0);
    3406:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    340d:	e8 23 08 00 00       	call   3c35 <exit>
    sbrk(-(sbrk(0) - oldbrk));
    3412:	83 ec 0c             	sub    $0xc,%esp
    3415:	6a 00                	push   $0x0
    3417:	e8 a1 08 00 00       	call   3cbd <sbrk>
    341c:	29 c7                	sub    %eax,%edi
    341e:	89 3c 24             	mov    %edi,(%esp)
    3421:	e8 97 08 00 00       	call   3cbd <sbrk>
    3426:	83 c4 10             	add    $0x10,%esp
    3429:	eb aa                	jmp    33d5 <sbrktest+0x42c>

0000342b <validateint>:
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    342b:	c3                   	ret

0000342c <validatetest>:

void
validatetest(void)
{
    342c:	55                   	push   %ebp
    342d:	89 e5                	mov    %esp,%ebp
    342f:	56                   	push   %esi
    3430:	53                   	push   %ebx
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3431:	83 ec 08             	sub    $0x8,%esp
    3434:	68 d6 4e 00 00       	push   $0x4ed6
    3439:	ff 35 d8 60 00 00    	push   0x60d8
    343f:	e8 44 09 00 00       	call   3d88 <printf>
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    3444:	83 c4 10             	add    $0x10,%esp
    3447:	be 00 00 00 00       	mov    $0x0,%esi
    344c:	81 fe 00 30 11 00    	cmp    $0x113000,%esi
    3452:	77 7c                	ja     34d0 <validatetest+0xa4>
    if((pid = fork()) == 0){
    3454:	e8 d4 07 00 00       	call   3c2d <fork>
    3459:	89 c3                	mov    %eax,%ebx
    345b:	85 c0                	test   %eax,%eax
    345d:	74 48                	je     34a7 <validatetest+0x7b>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
      exit(0);
    }
    sleep(0);
    345f:	83 ec 0c             	sub    $0xc,%esp
    3462:	6a 00                	push   $0x0
    3464:	e8 5c 08 00 00       	call   3cc5 <sleep>
    sleep(0);
    3469:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3470:	e8 50 08 00 00       	call   3cc5 <sleep>
    kill(pid);
    3475:	89 1c 24             	mov    %ebx,(%esp)
    3478:	e8 e8 07 00 00       	call   3c65 <kill>
    wait(NULL);
    347d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3484:	e8 b4 07 00 00       	call   3c3d <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    3489:	83 c4 08             	add    $0x8,%esp
    348c:	56                   	push   %esi
    348d:	68 e5 4e 00 00       	push   $0x4ee5
    3492:	e8 fe 07 00 00       	call   3c95 <link>
    3497:	83 c4 10             	add    $0x10,%esp
    349a:	83 f8 ff             	cmp    $0xffffffff,%eax
    349d:	75 12                	jne    34b1 <validatetest+0x85>
  for(p = 0; p <= (uint)hi; p += 4096){
    349f:	81 c6 00 10 00 00    	add    $0x1000,%esi
    34a5:	eb a5                	jmp    344c <validatetest+0x20>
      exit(0);
    34a7:	83 ec 0c             	sub    $0xc,%esp
    34aa:	6a 00                	push   $0x0
    34ac:	e8 84 07 00 00       	call   3c35 <exit>
      printf(stdout, "link should not succeed\n");
    34b1:	83 ec 08             	sub    $0x8,%esp
    34b4:	68 f0 4e 00 00       	push   $0x4ef0
    34b9:	ff 35 d8 60 00 00    	push   0x60d8
    34bf:	e8 c4 08 00 00       	call   3d88 <printf>
      exit(0);
    34c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    34cb:	e8 65 07 00 00       	call   3c35 <exit>
    }
  }

  printf(stdout, "validate ok\n");
    34d0:	83 ec 08             	sub    $0x8,%esp
    34d3:	68 09 4f 00 00       	push   $0x4f09
    34d8:	ff 35 d8 60 00 00    	push   0x60d8
    34de:	e8 a5 08 00 00       	call   3d88 <printf>
}
    34e3:	83 c4 10             	add    $0x10,%esp
    34e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
    34e9:	5b                   	pop    %ebx
    34ea:	5e                   	pop    %esi
    34eb:	5d                   	pop    %ebp
    34ec:	c3                   	ret

000034ed <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    34ed:	55                   	push   %ebp
    34ee:	89 e5                	mov    %esp,%ebp
    34f0:	83 ec 10             	sub    $0x10,%esp
  int i;

  printf(stdout, "bss test\n");
    34f3:	68 16 4f 00 00       	push   $0x4f16
    34f8:	ff 35 d8 60 00 00    	push   0x60d8
    34fe:	e8 85 08 00 00       	call   3d88 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    3503:	83 c4 10             	add    $0x10,%esp
    3506:	b8 00 00 00 00       	mov    $0x0,%eax
    350b:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    3510:	77 2b                	ja     353d <bsstest+0x50>
    if(uninit[i] != '\0'){
    3512:	80 b8 00 61 00 00 00 	cmpb   $0x0,0x6100(%eax)
    3519:	75 03                	jne    351e <bsstest+0x31>
  for(i = 0; i < sizeof(uninit); i++){
    351b:	40                   	inc    %eax
    351c:	eb ed                	jmp    350b <bsstest+0x1e>
      printf(stdout, "bss test failed\n");
    351e:	83 ec 08             	sub    $0x8,%esp
    3521:	68 20 4f 00 00       	push   $0x4f20
    3526:	ff 35 d8 60 00 00    	push   0x60d8
    352c:	e8 57 08 00 00       	call   3d88 <printf>
      exit(0);
    3531:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3538:	e8 f8 06 00 00       	call   3c35 <exit>
    }
  }
  printf(stdout, "bss test ok\n");
    353d:	83 ec 08             	sub    $0x8,%esp
    3540:	68 31 4f 00 00       	push   $0x4f31
    3545:	ff 35 d8 60 00 00    	push   0x60d8
    354b:	e8 38 08 00 00       	call   3d88 <printf>
}
    3550:	83 c4 10             	add    $0x10,%esp
    3553:	c9                   	leave
    3554:	c3                   	ret

00003555 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    3555:	55                   	push   %ebp
    3556:	89 e5                	mov    %esp,%ebp
    3558:	83 ec 14             	sub    $0x14,%esp
  int pid, fd;

  unlink("bigarg-ok");
    355b:	68 3e 4f 00 00       	push   $0x4f3e
    3560:	e8 20 07 00 00       	call   3c85 <unlink>
  pid = fork();
    3565:	e8 c3 06 00 00       	call   3c2d <fork>
  if(pid == 0){
    356a:	83 c4 10             	add    $0x10,%esp
    356d:	85 c0                	test   %eax,%eax
    356f:	74 50                	je     35c1 <bigargtest+0x6c>
    exec("echo", args);
    printf(stdout, "bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit(0);
  } else if(pid < 0){
    3571:	0f 88 b7 00 00 00    	js     362e <bigargtest+0xd9>
    printf(stdout, "bigargtest: fork failed\n");
    exit(0);
  }
  wait(NULL);
    3577:	83 ec 0c             	sub    $0xc,%esp
    357a:	6a 00                	push   $0x0
    357c:	e8 bc 06 00 00       	call   3c3d <wait>
  fd = open("bigarg-ok", 0);
    3581:	83 c4 08             	add    $0x8,%esp
    3584:	6a 00                	push   $0x0
    3586:	68 3e 4f 00 00       	push   $0x4f3e
    358b:	e8 e5 06 00 00       	call   3c75 <open>
  if(fd < 0){
    3590:	83 c4 10             	add    $0x10,%esp
    3593:	85 c0                	test   %eax,%eax
    3595:	0f 88 b2 00 00 00    	js     364d <bigargtest+0xf8>
    printf(stdout, "bigarg test failed!\n");
    exit(0);
  }
  close(fd);
    359b:	83 ec 0c             	sub    $0xc,%esp
    359e:	50                   	push   %eax
    359f:	e8 b9 06 00 00       	call   3c5d <close>
  unlink("bigarg-ok");
    35a4:	c7 04 24 3e 4f 00 00 	movl   $0x4f3e,(%esp)
    35ab:	e8 d5 06 00 00       	call   3c85 <unlink>
}
    35b0:	83 c4 10             	add    $0x10,%esp
    35b3:	c9                   	leave
    35b4:	c3                   	ret
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    35b5:	c7 04 85 20 a8 00 00 	movl   $0x56a0,0xa820(,%eax,4)
    35bc:	a0 56 00 00 
    for(i = 0; i < MAXARG-1; i++)
    35c0:	40                   	inc    %eax
    35c1:	83 f8 1e             	cmp    $0x1e,%eax
    35c4:	7e ef                	jle    35b5 <bigargtest+0x60>
    args[MAXARG-1] = 0;
    35c6:	c7 05 9c a8 00 00 00 	movl   $0x0,0xa89c
    35cd:	00 00 00 
    printf(stdout, "bigarg test\n");
    35d0:	83 ec 08             	sub    $0x8,%esp
    35d3:	68 48 4f 00 00       	push   $0x4f48
    35d8:	ff 35 d8 60 00 00    	push   0x60d8
    35de:	e8 a5 07 00 00       	call   3d88 <printf>
    exec("echo", args);
    35e3:	83 c4 08             	add    $0x8,%esp
    35e6:	68 20 a8 00 00       	push   $0xa820
    35eb:	68 15 41 00 00       	push   $0x4115
    35f0:	e8 78 06 00 00       	call   3c6d <exec>
    printf(stdout, "bigarg test ok\n");
    35f5:	83 c4 08             	add    $0x8,%esp
    35f8:	68 55 4f 00 00       	push   $0x4f55
    35fd:	ff 35 d8 60 00 00    	push   0x60d8
    3603:	e8 80 07 00 00       	call   3d88 <printf>
    fd = open("bigarg-ok", O_CREATE);
    3608:	83 c4 08             	add    $0x8,%esp
    360b:	68 00 02 00 00       	push   $0x200
    3610:	68 3e 4f 00 00       	push   $0x4f3e
    3615:	e8 5b 06 00 00       	call   3c75 <open>
    close(fd);
    361a:	89 04 24             	mov    %eax,(%esp)
    361d:	e8 3b 06 00 00       	call   3c5d <close>
    exit(0);
    3622:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3629:	e8 07 06 00 00       	call   3c35 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    362e:	83 ec 08             	sub    $0x8,%esp
    3631:	68 65 4f 00 00       	push   $0x4f65
    3636:	ff 35 d8 60 00 00    	push   0x60d8
    363c:	e8 47 07 00 00       	call   3d88 <printf>
    exit(0);
    3641:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3648:	e8 e8 05 00 00       	call   3c35 <exit>
    printf(stdout, "bigarg test failed!\n");
    364d:	83 ec 08             	sub    $0x8,%esp
    3650:	68 7e 4f 00 00       	push   $0x4f7e
    3655:	ff 35 d8 60 00 00    	push   0x60d8
    365b:	e8 28 07 00 00       	call   3d88 <printf>
    exit(0);
    3660:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3667:	e8 c9 05 00 00       	call   3c35 <exit>

0000366c <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    366c:	55                   	push   %ebp
    366d:	89 e5                	mov    %esp,%ebp
    366f:	57                   	push   %edi
    3670:	56                   	push   %esi
    3671:	53                   	push   %ebx
    3672:	83 ec 54             	sub    $0x54,%esp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
    3675:	68 93 4f 00 00       	push   $0x4f93
    367a:	6a 01                	push   $0x1
    367c:	e8 07 07 00 00       	call   3d88 <printf>
    3681:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    3684:	bb 00 00 00 00       	mov    $0x0,%ebx
    char name[64];
    name[0] = 'f';
    3689:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    368d:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3692:	f7 eb                	imul   %ebx
    3694:	89 d0                	mov    %edx,%eax
    3696:	c1 f8 06             	sar    $0x6,%eax
    3699:	89 de                	mov    %ebx,%esi
    369b:	c1 fe 1f             	sar    $0x1f,%esi
    369e:	29 f0                	sub    %esi,%eax
    36a0:	8d 50 30             	lea    0x30(%eax),%edx
    36a3:	88 55 a9             	mov    %dl,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    36a6:	8d 04 80             	lea    (%eax,%eax,4),%eax
    36a9:	8d 04 80             	lea    (%eax,%eax,4),%eax
    36ac:	8d 04 80             	lea    (%eax,%eax,4),%eax
    36af:	c1 e0 03             	shl    $0x3,%eax
    36b2:	89 df                	mov    %ebx,%edi
    36b4:	29 c7                	sub    %eax,%edi
    36b6:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
    36bb:	89 f8                	mov    %edi,%eax
    36bd:	f7 e9                	imul   %ecx
    36bf:	c1 fa 05             	sar    $0x5,%edx
    36c2:	c1 ff 1f             	sar    $0x1f,%edi
    36c5:	29 fa                	sub    %edi,%edx
    36c7:	83 c2 30             	add    $0x30,%edx
    36ca:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    36cd:	89 c8                	mov    %ecx,%eax
    36cf:	f7 eb                	imul   %ebx
    36d1:	89 d1                	mov    %edx,%ecx
    36d3:	c1 f9 05             	sar    $0x5,%ecx
    36d6:	29 f1                	sub    %esi,%ecx
    36d8:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
    36db:	8d 04 80             	lea    (%eax,%eax,4),%eax
    36de:	c1 e0 02             	shl    $0x2,%eax
    36e1:	89 d9                	mov    %ebx,%ecx
    36e3:	29 c1                	sub    %eax,%ecx
    36e5:	bf 67 66 66 66       	mov    $0x66666667,%edi
    36ea:	89 c8                	mov    %ecx,%eax
    36ec:	f7 ef                	imul   %edi
    36ee:	89 d0                	mov    %edx,%eax
    36f0:	c1 f8 02             	sar    $0x2,%eax
    36f3:	c1 f9 1f             	sar    $0x1f,%ecx
    36f6:	29 c8                	sub    %ecx,%eax
    36f8:	83 c0 30             	add    $0x30,%eax
    36fb:	88 45 ab             	mov    %al,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    36fe:	89 f8                	mov    %edi,%eax
    3700:	f7 eb                	imul   %ebx
    3702:	89 d0                	mov    %edx,%eax
    3704:	c1 f8 02             	sar    $0x2,%eax
    3707:	29 f0                	sub    %esi,%eax
    3709:	8d 04 80             	lea    (%eax,%eax,4),%eax
    370c:	8d 14 00             	lea    (%eax,%eax,1),%edx
    370f:	89 d8                	mov    %ebx,%eax
    3711:	29 d0                	sub    %edx,%eax
    3713:	83 c0 30             	add    $0x30,%eax
    3716:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    3719:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    printf(1, "writing %s\n", name);
    371d:	83 ec 04             	sub    $0x4,%esp
    3720:	8d 75 a8             	lea    -0x58(%ebp),%esi
    3723:	56                   	push   %esi
    3724:	68 a0 4f 00 00       	push   $0x4fa0
    3729:	6a 01                	push   $0x1
    372b:	e8 58 06 00 00       	call   3d88 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3730:	83 c4 08             	add    $0x8,%esp
    3733:	68 02 02 00 00       	push   $0x202
    3738:	56                   	push   %esi
    3739:	e8 37 05 00 00       	call   3c75 <open>
    373e:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    3740:	83 c4 10             	add    $0x10,%esp
    3743:	85 c0                	test   %eax,%eax
    3745:	79 1b                	jns    3762 <fsfull+0xf6>
      printf(1, "open %s failed\n", name);
    3747:	83 ec 04             	sub    $0x4,%esp
    374a:	8d 45 a8             	lea    -0x58(%ebp),%eax
    374d:	50                   	push   %eax
    374e:	68 ac 4f 00 00       	push   $0x4fac
    3753:	6a 01                	push   $0x1
    3755:	e8 2e 06 00 00       	call   3d88 <printf>
      break;
    375a:	83 c4 10             	add    $0x10,%esp
    375d:	e9 f3 00 00 00       	jmp    3855 <fsfull+0x1e9>
    }
    int total = 0;
    3762:	bf 00 00 00 00       	mov    $0x0,%edi
    while(1){
      int cc = write(fd, buf, 512);
    3767:	83 ec 04             	sub    $0x4,%esp
    376a:	68 00 02 00 00       	push   $0x200
    376f:	68 20 88 00 00       	push   $0x8820
    3774:	56                   	push   %esi
    3775:	e8 db 04 00 00       	call   3c55 <write>
      if(cc < 512)
    377a:	83 c4 10             	add    $0x10,%esp
    377d:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    3782:	7e 04                	jle    3788 <fsfull+0x11c>
        break;
      total += cc;
    3784:	01 c7                	add    %eax,%edi
    while(1){
    3786:	eb df                	jmp    3767 <fsfull+0xfb>
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    3788:	83 ec 04             	sub    $0x4,%esp
    378b:	57                   	push   %edi
    378c:	68 bc 4f 00 00       	push   $0x4fbc
    3791:	6a 01                	push   $0x1
    3793:	e8 f0 05 00 00       	call   3d88 <printf>
    close(fd);
    3798:	89 34 24             	mov    %esi,(%esp)
    379b:	e8 bd 04 00 00       	call   3c5d <close>
    if(total == 0)
    37a0:	83 c4 10             	add    $0x10,%esp
    37a3:	85 ff                	test   %edi,%edi
    37a5:	0f 84 aa 00 00 00    	je     3855 <fsfull+0x1e9>
  for(nfiles = 0; ; nfiles++){
    37ab:	43                   	inc    %ebx
    37ac:	e9 d8 fe ff ff       	jmp    3689 <fsfull+0x1d>
      break;
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    37b1:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    37b5:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    37ba:	f7 eb                	imul   %ebx
    37bc:	89 d0                	mov    %edx,%eax
    37be:	c1 f8 06             	sar    $0x6,%eax
    37c1:	89 de                	mov    %ebx,%esi
    37c3:	c1 fe 1f             	sar    $0x1f,%esi
    37c6:	29 f0                	sub    %esi,%eax
    37c8:	8d 50 30             	lea    0x30(%eax),%edx
    37cb:	88 55 a9             	mov    %dl,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    37ce:	8d 04 80             	lea    (%eax,%eax,4),%eax
    37d1:	8d 04 80             	lea    (%eax,%eax,4),%eax
    37d4:	8d 04 80             	lea    (%eax,%eax,4),%eax
    37d7:	c1 e0 03             	shl    $0x3,%eax
    37da:	89 df                	mov    %ebx,%edi
    37dc:	29 c7                	sub    %eax,%edi
    37de:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
    37e3:	89 f8                	mov    %edi,%eax
    37e5:	f7 e9                	imul   %ecx
    37e7:	c1 fa 05             	sar    $0x5,%edx
    37ea:	c1 ff 1f             	sar    $0x1f,%edi
    37ed:	29 fa                	sub    %edi,%edx
    37ef:	83 c2 30             	add    $0x30,%edx
    37f2:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    37f5:	89 c8                	mov    %ecx,%eax
    37f7:	f7 eb                	imul   %ebx
    37f9:	89 d1                	mov    %edx,%ecx
    37fb:	c1 f9 05             	sar    $0x5,%ecx
    37fe:	29 f1                	sub    %esi,%ecx
    3800:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
    3803:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3806:	c1 e0 02             	shl    $0x2,%eax
    3809:	89 d9                	mov    %ebx,%ecx
    380b:	29 c1                	sub    %eax,%ecx
    380d:	bf 67 66 66 66       	mov    $0x66666667,%edi
    3812:	89 c8                	mov    %ecx,%eax
    3814:	f7 ef                	imul   %edi
    3816:	89 d0                	mov    %edx,%eax
    3818:	c1 f8 02             	sar    $0x2,%eax
    381b:	c1 f9 1f             	sar    $0x1f,%ecx
    381e:	29 c8                	sub    %ecx,%eax
    3820:	83 c0 30             	add    $0x30,%eax
    3823:	88 45 ab             	mov    %al,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3826:	89 f8                	mov    %edi,%eax
    3828:	f7 eb                	imul   %ebx
    382a:	89 d0                	mov    %edx,%eax
    382c:	c1 f8 02             	sar    $0x2,%eax
    382f:	29 f0                	sub    %esi,%eax
    3831:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3834:	8d 14 00             	lea    (%eax,%eax,1),%edx
    3837:	89 d8                	mov    %ebx,%eax
    3839:	29 d0                	sub    %edx,%eax
    383b:	83 c0 30             	add    $0x30,%eax
    383e:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    3841:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    unlink(name);
    3845:	83 ec 0c             	sub    $0xc,%esp
    3848:	8d 45 a8             	lea    -0x58(%ebp),%eax
    384b:	50                   	push   %eax
    384c:	e8 34 04 00 00       	call   3c85 <unlink>
    nfiles--;
    3851:	4b                   	dec    %ebx
    3852:	83 c4 10             	add    $0x10,%esp
  while(nfiles >= 0){
    3855:	85 db                	test   %ebx,%ebx
    3857:	0f 89 54 ff ff ff    	jns    37b1 <fsfull+0x145>
  }

  printf(1, "fsfull test finished\n");
    385d:	83 ec 08             	sub    $0x8,%esp
    3860:	68 cc 4f 00 00       	push   $0x4fcc
    3865:	6a 01                	push   $0x1
    3867:	e8 1c 05 00 00       	call   3d88 <printf>
}
    386c:	83 c4 10             	add    $0x10,%esp
    386f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3872:	5b                   	pop    %ebx
    3873:	5e                   	pop    %esi
    3874:	5f                   	pop    %edi
    3875:	5d                   	pop    %ebp
    3876:	c3                   	ret

00003877 <uio>:

void
uio()
{
    3877:	55                   	push   %ebp
    3878:	89 e5                	mov    %esp,%ebp
    387a:	83 ec 10             	sub    $0x10,%esp

  ushort port = 0;
  uchar val = 0;
  int pid;

  printf(1, "uio test\n");
    387d:	68 e2 4f 00 00       	push   $0x4fe2
    3882:	6a 01                	push   $0x1
    3884:	e8 ff 04 00 00       	call   3d88 <printf>
  pid = fork();
    3889:	e8 9f 03 00 00       	call   3c2d <fork>
  if(pid == 0){
    388e:	83 c4 10             	add    $0x10,%esp
    3891:	85 c0                	test   %eax,%eax
    3893:	74 20                	je     38b5 <uio+0x3e>
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    port = RTC_DATA;
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    printf(1, "uio: uio succeeded; test FAILED\n");
    exit(0);
  } else if(pid < 0){
    3895:	78 47                	js     38de <uio+0x67>
    printf (1, "fork failed\n");
    exit(0);
  }
  wait(NULL);
    3897:	83 ec 0c             	sub    $0xc,%esp
    389a:	6a 00                	push   $0x0
    389c:	e8 9c 03 00 00       	call   3c3d <wait>
  printf(1, "uio test done\n");
    38a1:	83 c4 08             	add    $0x8,%esp
    38a4:	68 ec 4f 00 00       	push   $0x4fec
    38a9:	6a 01                	push   $0x1
    38ab:	e8 d8 04 00 00       	call   3d88 <printf>
}
    38b0:	83 c4 10             	add    $0x10,%esp
    38b3:	c9                   	leave
    38b4:	c3                   	ret
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    38b5:	b0 09                	mov    $0x9,%al
    38b7:	ba 70 00 00 00       	mov    $0x70,%edx
    38bc:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    38bd:	ba 71 00 00 00       	mov    $0x71,%edx
    38c2:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    38c3:	83 ec 08             	sub    $0x8,%esp
    38c6:	68 80 57 00 00       	push   $0x5780
    38cb:	6a 01                	push   $0x1
    38cd:	e8 b6 04 00 00       	call   3d88 <printf>
    exit(0);
    38d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    38d9:	e8 57 03 00 00       	call   3c35 <exit>
    printf (1, "fork failed\n");
    38de:	83 ec 08             	sub    $0x8,%esp
    38e1:	68 71 4f 00 00       	push   $0x4f71
    38e6:	6a 01                	push   $0x1
    38e8:	e8 9b 04 00 00       	call   3d88 <printf>
    exit(0);
    38ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    38f4:	e8 3c 03 00 00       	call   3c35 <exit>

000038f9 <argptest>:

void argptest()
{
    38f9:	55                   	push   %ebp
    38fa:	89 e5                	mov    %esp,%ebp
    38fc:	53                   	push   %ebx
    38fd:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  fd = open("init", O_RDONLY);
    3900:	6a 00                	push   $0x0
    3902:	68 fb 4f 00 00       	push   $0x4ffb
    3907:	e8 69 03 00 00       	call   3c75 <open>
  if (fd < 0) {
    390c:	83 c4 10             	add    $0x10,%esp
    390f:	85 c0                	test   %eax,%eax
    3911:	78 38                	js     394b <argptest+0x52>
    3913:	89 c3                	mov    %eax,%ebx
    printf(2, "open failed\n");
    exit(0);
  }
  read(fd, sbrk(0) - 1, -1);
    3915:	83 ec 0c             	sub    $0xc,%esp
    3918:	6a 00                	push   $0x0
    391a:	e8 9e 03 00 00       	call   3cbd <sbrk>
    391f:	48                   	dec    %eax
    3920:	83 c4 0c             	add    $0xc,%esp
    3923:	6a ff                	push   $0xffffffff
    3925:	50                   	push   %eax
    3926:	53                   	push   %ebx
    3927:	e8 21 03 00 00       	call   3c4d <read>
  close(fd);
    392c:	89 1c 24             	mov    %ebx,(%esp)
    392f:	e8 29 03 00 00       	call   3c5d <close>
  printf(1, "arg test passed\n");
    3934:	83 c4 08             	add    $0x8,%esp
    3937:	68 0d 50 00 00       	push   $0x500d
    393c:	6a 01                	push   $0x1
    393e:	e8 45 04 00 00       	call   3d88 <printf>
}
    3943:	83 c4 10             	add    $0x10,%esp
    3946:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3949:	c9                   	leave
    394a:	c3                   	ret
    printf(2, "open failed\n");
    394b:	83 ec 08             	sub    $0x8,%esp
    394e:	68 00 50 00 00       	push   $0x5000
    3953:	6a 02                	push   $0x2
    3955:	e8 2e 04 00 00       	call   3d88 <printf>
    exit(0);
    395a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3961:	e8 cf 02 00 00       	call   3c35 <exit>

00003966 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
  randstate = randstate * 1664525 + 1013904223;
    3966:	a1 d4 60 00 00       	mov    0x60d4,%eax
    396b:	8d 14 00             	lea    (%eax,%eax,1),%edx
    396e:	01 c2                	add    %eax,%edx
    3970:	8d 0c 90             	lea    (%eax,%edx,4),%ecx
    3973:	c1 e1 08             	shl    $0x8,%ecx
    3976:	89 ca                	mov    %ecx,%edx
    3978:	01 c2                	add    %eax,%edx
    397a:	8d 14 92             	lea    (%edx,%edx,4),%edx
    397d:	8d 04 90             	lea    (%eax,%edx,4),%eax
    3980:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3983:	8d 84 80 5f f3 6e 3c 	lea    0x3c6ef35f(%eax,%eax,4),%eax
    398a:	a3 d4 60 00 00       	mov    %eax,0x60d4
  return randstate;
}
    398f:	c3                   	ret

00003990 <main>:

int
main(int argc, char *argv[])
{
    3990:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3994:	83 e4 f0             	and    $0xfffffff0,%esp
    3997:	ff 71 fc             	push   -0x4(%ecx)
    399a:	55                   	push   %ebp
    399b:	89 e5                	mov    %esp,%ebp
    399d:	51                   	push   %ecx
    399e:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
    39a1:	68 1e 50 00 00       	push   $0x501e
    39a6:	6a 01                	push   $0x1
    39a8:	e8 db 03 00 00       	call   3d88 <printf>

  if(open("usertests.ran", 0) >= 0){
    39ad:	83 c4 08             	add    $0x8,%esp
    39b0:	6a 00                	push   $0x0
    39b2:	68 32 50 00 00       	push   $0x5032
    39b7:	e8 b9 02 00 00       	call   3c75 <open>
    39bc:	83 c4 10             	add    $0x10,%esp
    39bf:	85 c0                	test   %eax,%eax
    39c1:	78 1b                	js     39de <main+0x4e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    39c3:	83 ec 08             	sub    $0x8,%esp
    39c6:	68 a4 57 00 00       	push   $0x57a4
    39cb:	6a 01                	push   $0x1
    39cd:	e8 b6 03 00 00       	call   3d88 <printf>
    exit(0);
    39d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    39d9:	e8 57 02 00 00       	call   3c35 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    39de:	83 ec 08             	sub    $0x8,%esp
    39e1:	68 00 02 00 00       	push   $0x200
    39e6:	68 32 50 00 00       	push   $0x5032
    39eb:	e8 85 02 00 00       	call   3c75 <open>
    39f0:	89 04 24             	mov    %eax,(%esp)
    39f3:	e8 65 02 00 00       	call   3c5d <close>

  argptest();
    39f8:	e8 fc fe ff ff       	call   38f9 <argptest>
  createdelete();
    39fd:	e8 75 d7 ff ff       	call   1177 <createdelete>
  linkunlink();
    3a02:	e8 96 e0 ff ff       	call   1a9d <linkunlink>
  concreate();
    3a07:	e8 a6 dd ff ff       	call   17b2 <concreate>
  fourfiles();
    3a0c:	e8 69 d5 ff ff       	call   f7a <fourfiles>
  sharedfd();
    3a11:	e8 c8 d3 ff ff       	call   dde <sharedfd>

  bigargtest();
    3a16:	e8 3a fb ff ff       	call   3555 <bigargtest>
  bigwrite();
    3a1b:	e8 32 eb ff ff       	call   2552 <bigwrite>
  bigargtest();
    3a20:	e8 30 fb ff ff       	call   3555 <bigargtest>
  bsstest();
    3a25:	e8 c3 fa ff ff       	call   34ed <bsstest>
  sbrktest();
    3a2a:	e8 7a f5 ff ff       	call   2fa9 <sbrktest>
  validatetest();
    3a2f:	e8 f8 f9 ff ff       	call   342c <validatetest>

  opentest();
    3a34:	e8 db c8 ff ff       	call   314 <opentest>
  writetest();
    3a39:	e8 77 c9 ff ff       	call   3b5 <writetest>
  writetest1();
    3a3e:	e8 66 cb ff ff       	call   5a9 <writetest1>
  createtest();
    3a43:	e8 3e cd ff ff       	call   786 <createtest>

  openiputtest();
    3a48:	e8 b8 c7 ff ff       	call   205 <openiputtest>
  exitiputtest();
    3a4d:	e8 a7 c6 ff ff       	call   f9 <exitiputtest>
  iputtest();
    3a52:	e8 a9 c5 ff ff       	call   0 <iputtest>

  mem();
    3a57:	e8 b1 d2 ff ff       	call   d0d <mem>
  pipe1();
    3a5c:	e8 16 cf ff ff       	call   977 <pipe1>
  preempt();
    3a61:	e8 d9 d0 ff ff       	call   b3f <preempt>
  exitwait();
    3a66:	e8 27 d2 ff ff       	call   c92 <exitwait>

  rmdot();
    3a6b:	e8 16 ef ff ff       	call   2986 <rmdot>
  fourteen();
    3a70:	e8 a2 ed ff ff       	call   2817 <fourteen>
  bigfile();
    3a75:	e8 b6 eb ff ff       	call   2630 <bigfile>
  subdir();
    3a7a:	e8 a2 e2 ff ff       	call   1d21 <subdir>
  linktest();
    3a7f:	e8 c9 da ff ff       	call   154d <linktest>
  unlinkread();
    3a84:	e8 01 d9 ff ff       	call   138a <unlinkread>
  dirfile();
    3a89:	e8 b5 f0 ff ff       	call   2b43 <dirfile>
  iref();
    3a8e:	e8 10 f3 ff ff       	call   2da3 <iref>
  forktest();
    3a93:	e8 3c f4 ff ff       	call   2ed4 <forktest>
  bigdir(); // slow
    3a98:	e8 19 e1 ff ff       	call   1bb6 <bigdir>

  uio();
    3a9d:	e8 d5 fd ff ff       	call   3877 <uio>

  exectest();
    3aa2:	e8 80 ce ff ff       	call   927 <exectest>

  exit(0);
    3aa7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3aae:	e8 82 01 00 00       	call   3c35 <exit>

00003ab3 <start>:

// Entry point of the library	
void
start()
{
}
    3ab3:	c3                   	ret

00003ab4 <strcpy>:

char*
strcpy(char *s, const char *t)
{
    3ab4:	55                   	push   %ebp
    3ab5:	89 e5                	mov    %esp,%ebp
    3ab7:	56                   	push   %esi
    3ab8:	53                   	push   %ebx
    3ab9:	8b 45 08             	mov    0x8(%ebp),%eax
    3abc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3abf:	89 c2                	mov    %eax,%edx
    3ac1:	89 cb                	mov    %ecx,%ebx
    3ac3:	41                   	inc    %ecx
    3ac4:	89 d6                	mov    %edx,%esi
    3ac6:	42                   	inc    %edx
    3ac7:	8a 1b                	mov    (%ebx),%bl
    3ac9:	88 1e                	mov    %bl,(%esi)
    3acb:	84 db                	test   %bl,%bl
    3acd:	75 f2                	jne    3ac1 <strcpy+0xd>
    ;
  return os;
}
    3acf:	5b                   	pop    %ebx
    3ad0:	5e                   	pop    %esi
    3ad1:	5d                   	pop    %ebp
    3ad2:	c3                   	ret

00003ad3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3ad3:	55                   	push   %ebp
    3ad4:	89 e5                	mov    %esp,%ebp
    3ad6:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    3adc:	eb 02                	jmp    3ae0 <strcmp+0xd>
    p++, q++;
    3ade:	41                   	inc    %ecx
    3adf:	42                   	inc    %edx
  while(*p && *p == *q)
    3ae0:	8a 01                	mov    (%ecx),%al
    3ae2:	84 c0                	test   %al,%al
    3ae4:	74 04                	je     3aea <strcmp+0x17>
    3ae6:	3a 02                	cmp    (%edx),%al
    3ae8:	74 f4                	je     3ade <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
    3aea:	0f b6 c0             	movzbl %al,%eax
    3aed:	0f b6 12             	movzbl (%edx),%edx
    3af0:	29 d0                	sub    %edx,%eax
}
    3af2:	5d                   	pop    %ebp
    3af3:	c3                   	ret

00003af4 <strlen>:

uint
strlen(const char *s)
{
    3af4:	55                   	push   %ebp
    3af5:	89 e5                	mov    %esp,%ebp
    3af7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    3afa:	b8 00 00 00 00       	mov    $0x0,%eax
    3aff:	eb 01                	jmp    3b02 <strlen+0xe>
    3b01:	40                   	inc    %eax
    3b02:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    3b06:	75 f9                	jne    3b01 <strlen+0xd>
    ;
  return n;
}
    3b08:	5d                   	pop    %ebp
    3b09:	c3                   	ret

00003b0a <memset>:

void*
memset(void *dst, int c, uint n)
{
    3b0a:	55                   	push   %ebp
    3b0b:	89 e5                	mov    %esp,%ebp
    3b0d:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    3b0e:	8b 7d 08             	mov    0x8(%ebp),%edi
    3b11:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3b14:	8b 45 0c             	mov    0xc(%ebp),%eax
    3b17:	fc                   	cld
    3b18:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3b1a:	8b 45 08             	mov    0x8(%ebp),%eax
    3b1d:	8b 7d fc             	mov    -0x4(%ebp),%edi
    3b20:	c9                   	leave
    3b21:	c3                   	ret

00003b22 <strchr>:

char*
strchr(const char *s, char c)
{
    3b22:	55                   	push   %ebp
    3b23:	89 e5                	mov    %esp,%ebp
    3b25:	8b 45 08             	mov    0x8(%ebp),%eax
    3b28:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
    3b2b:	eb 01                	jmp    3b2e <strchr+0xc>
    3b2d:	40                   	inc    %eax
    3b2e:	8a 10                	mov    (%eax),%dl
    3b30:	84 d2                	test   %dl,%dl
    3b32:	74 06                	je     3b3a <strchr+0x18>
    if(*s == c)
    3b34:	38 ca                	cmp    %cl,%dl
    3b36:	75 f5                	jne    3b2d <strchr+0xb>
    3b38:	eb 05                	jmp    3b3f <strchr+0x1d>
      return (char*)s;
  return 0;
    3b3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3b3f:	5d                   	pop    %ebp
    3b40:	c3                   	ret

00003b41 <gets>:

char*
gets(char *buf, int max)
{
    3b41:	55                   	push   %ebp
    3b42:	89 e5                	mov    %esp,%ebp
    3b44:	57                   	push   %edi
    3b45:	56                   	push   %esi
    3b46:	53                   	push   %ebx
    3b47:	83 ec 1c             	sub    $0x1c,%esp
    3b4a:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3b4d:	bb 00 00 00 00       	mov    $0x0,%ebx
    3b52:	89 de                	mov    %ebx,%esi
    3b54:	43                   	inc    %ebx
    3b55:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    3b58:	7d 2b                	jge    3b85 <gets+0x44>
    cc = read(0, &c, 1);
    3b5a:	83 ec 04             	sub    $0x4,%esp
    3b5d:	6a 01                	push   $0x1
    3b5f:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3b62:	50                   	push   %eax
    3b63:	6a 00                	push   $0x0
    3b65:	e8 e3 00 00 00       	call   3c4d <read>
    if(cc < 1)
    3b6a:	83 c4 10             	add    $0x10,%esp
    3b6d:	85 c0                	test   %eax,%eax
    3b6f:	7e 14                	jle    3b85 <gets+0x44>
      break;
    buf[i++] = c;
    3b71:	8a 45 e7             	mov    -0x19(%ebp),%al
    3b74:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
    3b77:	3c 0a                	cmp    $0xa,%al
    3b79:	74 08                	je     3b83 <gets+0x42>
    3b7b:	3c 0d                	cmp    $0xd,%al
    3b7d:	75 d3                	jne    3b52 <gets+0x11>
    buf[i++] = c;
    3b7f:	89 de                	mov    %ebx,%esi
    3b81:	eb 02                	jmp    3b85 <gets+0x44>
    3b83:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    3b85:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    3b89:	89 f8                	mov    %edi,%eax
    3b8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3b8e:	5b                   	pop    %ebx
    3b8f:	5e                   	pop    %esi
    3b90:	5f                   	pop    %edi
    3b91:	5d                   	pop    %ebp
    3b92:	c3                   	ret

00003b93 <stat>:

int
stat(const char *n, struct stat *st)
{
    3b93:	55                   	push   %ebp
    3b94:	89 e5                	mov    %esp,%ebp
    3b96:	56                   	push   %esi
    3b97:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3b98:	83 ec 08             	sub    $0x8,%esp
    3b9b:	6a 00                	push   $0x0
    3b9d:	ff 75 08             	push   0x8(%ebp)
    3ba0:	e8 d0 00 00 00       	call   3c75 <open>
  if(fd < 0)
    3ba5:	83 c4 10             	add    $0x10,%esp
    3ba8:	85 c0                	test   %eax,%eax
    3baa:	78 24                	js     3bd0 <stat+0x3d>
    3bac:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    3bae:	83 ec 08             	sub    $0x8,%esp
    3bb1:	ff 75 0c             	push   0xc(%ebp)
    3bb4:	50                   	push   %eax
    3bb5:	e8 d3 00 00 00       	call   3c8d <fstat>
    3bba:	89 c6                	mov    %eax,%esi
  close(fd);
    3bbc:	89 1c 24             	mov    %ebx,(%esp)
    3bbf:	e8 99 00 00 00       	call   3c5d <close>
  return r;
    3bc4:	83 c4 10             	add    $0x10,%esp
}
    3bc7:	89 f0                	mov    %esi,%eax
    3bc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
    3bcc:	5b                   	pop    %ebx
    3bcd:	5e                   	pop    %esi
    3bce:	5d                   	pop    %ebp
    3bcf:	c3                   	ret
    return -1;
    3bd0:	be ff ff ff ff       	mov    $0xffffffff,%esi
    3bd5:	eb f0                	jmp    3bc7 <stat+0x34>

00003bd7 <atoi>:

int
atoi(const char *s)
{
    3bd7:	55                   	push   %ebp
    3bd8:	89 e5                	mov    %esp,%ebp
    3bda:	53                   	push   %ebx
    3bdb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
    3bde:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
    3be3:	eb 0e                	jmp    3bf3 <atoi+0x1c>
    n = n*10 + *s++ - '0';
    3be5:	8d 14 92             	lea    (%edx,%edx,4),%edx
    3be8:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
    3beb:	41                   	inc    %ecx
    3bec:	0f be c0             	movsbl %al,%eax
    3bef:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
    3bf3:	8a 01                	mov    (%ecx),%al
    3bf5:	8d 58 d0             	lea    -0x30(%eax),%ebx
    3bf8:	80 fb 09             	cmp    $0x9,%bl
    3bfb:	76 e8                	jbe    3be5 <atoi+0xe>
  return n;
}
    3bfd:	89 d0                	mov    %edx,%eax
    3bff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3c02:	c9                   	leave
    3c03:	c3                   	ret

00003c04 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    3c04:	55                   	push   %ebp
    3c05:	89 e5                	mov    %esp,%ebp
    3c07:	56                   	push   %esi
    3c08:	53                   	push   %ebx
    3c09:	8b 45 08             	mov    0x8(%ebp),%eax
    3c0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    3c0f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
    3c12:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
    3c14:	eb 0c                	jmp    3c22 <memmove+0x1e>
    *dst++ = *src++;
    3c16:	8a 13                	mov    (%ebx),%dl
    3c18:	88 11                	mov    %dl,(%ecx)
    3c1a:	8d 5b 01             	lea    0x1(%ebx),%ebx
    3c1d:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
    3c20:	89 f2                	mov    %esi,%edx
    3c22:	8d 72 ff             	lea    -0x1(%edx),%esi
    3c25:	85 d2                	test   %edx,%edx
    3c27:	7f ed                	jg     3c16 <memmove+0x12>
  return vdst;
}
    3c29:	5b                   	pop    %ebx
    3c2a:	5e                   	pop    %esi
    3c2b:	5d                   	pop    %ebp
    3c2c:	c3                   	ret

00003c2d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3c2d:	b8 01 00 00 00       	mov    $0x1,%eax
    3c32:	cd 40                	int    $0x40
    3c34:	c3                   	ret

00003c35 <exit>:
SYSCALL(exit)
    3c35:	b8 02 00 00 00       	mov    $0x2,%eax
    3c3a:	cd 40                	int    $0x40
    3c3c:	c3                   	ret

00003c3d <wait>:
SYSCALL(wait)
    3c3d:	b8 03 00 00 00       	mov    $0x3,%eax
    3c42:	cd 40                	int    $0x40
    3c44:	c3                   	ret

00003c45 <pipe>:
SYSCALL(pipe)
    3c45:	b8 04 00 00 00       	mov    $0x4,%eax
    3c4a:	cd 40                	int    $0x40
    3c4c:	c3                   	ret

00003c4d <read>:
SYSCALL(read)
    3c4d:	b8 05 00 00 00       	mov    $0x5,%eax
    3c52:	cd 40                	int    $0x40
    3c54:	c3                   	ret

00003c55 <write>:
SYSCALL(write)
    3c55:	b8 10 00 00 00       	mov    $0x10,%eax
    3c5a:	cd 40                	int    $0x40
    3c5c:	c3                   	ret

00003c5d <close>:
SYSCALL(close)
    3c5d:	b8 15 00 00 00       	mov    $0x15,%eax
    3c62:	cd 40                	int    $0x40
    3c64:	c3                   	ret

00003c65 <kill>:
SYSCALL(kill)
    3c65:	b8 06 00 00 00       	mov    $0x6,%eax
    3c6a:	cd 40                	int    $0x40
    3c6c:	c3                   	ret

00003c6d <exec>:
SYSCALL(exec)
    3c6d:	b8 07 00 00 00       	mov    $0x7,%eax
    3c72:	cd 40                	int    $0x40
    3c74:	c3                   	ret

00003c75 <open>:
SYSCALL(open)
    3c75:	b8 0f 00 00 00       	mov    $0xf,%eax
    3c7a:	cd 40                	int    $0x40
    3c7c:	c3                   	ret

00003c7d <mknod>:
SYSCALL(mknod)
    3c7d:	b8 11 00 00 00       	mov    $0x11,%eax
    3c82:	cd 40                	int    $0x40
    3c84:	c3                   	ret

00003c85 <unlink>:
SYSCALL(unlink)
    3c85:	b8 12 00 00 00       	mov    $0x12,%eax
    3c8a:	cd 40                	int    $0x40
    3c8c:	c3                   	ret

00003c8d <fstat>:
SYSCALL(fstat)
    3c8d:	b8 08 00 00 00       	mov    $0x8,%eax
    3c92:	cd 40                	int    $0x40
    3c94:	c3                   	ret

00003c95 <link>:
SYSCALL(link)
    3c95:	b8 13 00 00 00       	mov    $0x13,%eax
    3c9a:	cd 40                	int    $0x40
    3c9c:	c3                   	ret

00003c9d <mkdir>:
SYSCALL(mkdir)
    3c9d:	b8 14 00 00 00       	mov    $0x14,%eax
    3ca2:	cd 40                	int    $0x40
    3ca4:	c3                   	ret

00003ca5 <chdir>:
SYSCALL(chdir)
    3ca5:	b8 09 00 00 00       	mov    $0x9,%eax
    3caa:	cd 40                	int    $0x40
    3cac:	c3                   	ret

00003cad <dup>:
SYSCALL(dup)
    3cad:	b8 0a 00 00 00       	mov    $0xa,%eax
    3cb2:	cd 40                	int    $0x40
    3cb4:	c3                   	ret

00003cb5 <getpid>:
SYSCALL(getpid)
    3cb5:	b8 0b 00 00 00       	mov    $0xb,%eax
    3cba:	cd 40                	int    $0x40
    3cbc:	c3                   	ret

00003cbd <sbrk>:
SYSCALL(sbrk)
    3cbd:	b8 0c 00 00 00       	mov    $0xc,%eax
    3cc2:	cd 40                	int    $0x40
    3cc4:	c3                   	ret

00003cc5 <sleep>:
SYSCALL(sleep)
    3cc5:	b8 0d 00 00 00       	mov    $0xd,%eax
    3cca:	cd 40                	int    $0x40
    3ccc:	c3                   	ret

00003ccd <uptime>:
SYSCALL(uptime)
    3ccd:	b8 0e 00 00 00       	mov    $0xe,%eax
    3cd2:	cd 40                	int    $0x40
    3cd4:	c3                   	ret

00003cd5 <date>:
SYSCALL(date)
    3cd5:	b8 16 00 00 00       	mov    $0x16,%eax
    3cda:	cd 40                	int    $0x40
    3cdc:	c3                   	ret

00003cdd <dup2>:
SYSCALL(dup2)
    3cdd:	b8 17 00 00 00       	mov    $0x17,%eax
    3ce2:	cd 40                	int    $0x40
    3ce4:	c3                   	ret

00003ce5 <getprio>:
SYSCALL(getprio)
    3ce5:	b8 18 00 00 00       	mov    $0x18,%eax
    3cea:	cd 40                	int    $0x40
    3cec:	c3                   	ret

00003ced <setprio>:
    3ced:	b8 19 00 00 00       	mov    $0x19,%eax
    3cf2:	cd 40                	int    $0x40
    3cf4:	c3                   	ret

00003cf5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3cf5:	55                   	push   %ebp
    3cf6:	89 e5                	mov    %esp,%ebp
    3cf8:	83 ec 1c             	sub    $0x1c,%esp
    3cfb:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
    3cfe:	6a 01                	push   $0x1
    3d00:	8d 55 f4             	lea    -0xc(%ebp),%edx
    3d03:	52                   	push   %edx
    3d04:	50                   	push   %eax
    3d05:	e8 4b ff ff ff       	call   3c55 <write>
}
    3d0a:	83 c4 10             	add    $0x10,%esp
    3d0d:	c9                   	leave
    3d0e:	c3                   	ret

00003d0f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3d0f:	55                   	push   %ebp
    3d10:	89 e5                	mov    %esp,%ebp
    3d12:	57                   	push   %edi
    3d13:	56                   	push   %esi
    3d14:	53                   	push   %ebx
    3d15:	83 ec 2c             	sub    $0x2c,%esp
    3d18:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3d1b:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    3d1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    3d21:	74 04                	je     3d27 <printint+0x18>
    3d23:	85 d2                	test   %edx,%edx
    3d25:	78 3c                	js     3d63 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    3d27:	89 d1                	mov    %edx,%ecx
  neg = 0;
    3d29:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
    3d30:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
    3d35:	89 c8                	mov    %ecx,%eax
    3d37:	ba 00 00 00 00       	mov    $0x0,%edx
    3d3c:	f7 f6                	div    %esi
    3d3e:	89 df                	mov    %ebx,%edi
    3d40:	43                   	inc    %ebx
    3d41:	8a 92 38 58 00 00    	mov    0x5838(%edx),%dl
    3d47:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
    3d4b:	89 ca                	mov    %ecx,%edx
    3d4d:	89 c1                	mov    %eax,%ecx
    3d4f:	39 f2                	cmp    %esi,%edx
    3d51:	73 e2                	jae    3d35 <printint+0x26>
  if(neg)
    3d53:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    3d57:	74 24                	je     3d7d <printint+0x6e>
    buf[i++] = '-';
    3d59:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    3d5e:	8d 5f 02             	lea    0x2(%edi),%ebx
    3d61:	eb 1a                	jmp    3d7d <printint+0x6e>
    x = -xx;
    3d63:	89 d1                	mov    %edx,%ecx
    3d65:	f7 d9                	neg    %ecx
    neg = 1;
    3d67:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
    3d6e:	eb c0                	jmp    3d30 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
    3d70:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
    3d75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3d78:	e8 78 ff ff ff       	call   3cf5 <putc>
  while(--i >= 0)
    3d7d:	4b                   	dec    %ebx
    3d7e:	79 f0                	jns    3d70 <printint+0x61>
}
    3d80:	83 c4 2c             	add    $0x2c,%esp
    3d83:	5b                   	pop    %ebx
    3d84:	5e                   	pop    %esi
    3d85:	5f                   	pop    %edi
    3d86:	5d                   	pop    %ebp
    3d87:	c3                   	ret

00003d88 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    3d88:	55                   	push   %ebp
    3d89:	89 e5                	mov    %esp,%ebp
    3d8b:	57                   	push   %edi
    3d8c:	56                   	push   %esi
    3d8d:	53                   	push   %ebx
    3d8e:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    3d91:	8d 45 10             	lea    0x10(%ebp),%eax
    3d94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
    3d97:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
    3d9c:	bb 00 00 00 00       	mov    $0x0,%ebx
    3da1:	eb 12                	jmp    3db5 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    3da3:	89 fa                	mov    %edi,%edx
    3da5:	8b 45 08             	mov    0x8(%ebp),%eax
    3da8:	e8 48 ff ff ff       	call   3cf5 <putc>
    3dad:	eb 05                	jmp    3db4 <printf+0x2c>
      }
    } else if(state == '%'){
    3daf:	83 fe 25             	cmp    $0x25,%esi
    3db2:	74 22                	je     3dd6 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
    3db4:	43                   	inc    %ebx
    3db5:	8b 45 0c             	mov    0xc(%ebp),%eax
    3db8:	8a 04 18             	mov    (%eax,%ebx,1),%al
    3dbb:	84 c0                	test   %al,%al
    3dbd:	0f 84 1d 01 00 00    	je     3ee0 <printf+0x158>
    c = fmt[i] & 0xff;
    3dc3:	0f be f8             	movsbl %al,%edi
    3dc6:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
    3dc9:	85 f6                	test   %esi,%esi
    3dcb:	75 e2                	jne    3daf <printf+0x27>
      if(c == '%'){
    3dcd:	83 f8 25             	cmp    $0x25,%eax
    3dd0:	75 d1                	jne    3da3 <printf+0x1b>
        state = '%';
    3dd2:	89 c6                	mov    %eax,%esi
    3dd4:	eb de                	jmp    3db4 <printf+0x2c>
      if(c == 'd'){
    3dd6:	83 f8 25             	cmp    $0x25,%eax
    3dd9:	0f 84 cc 00 00 00    	je     3eab <printf+0x123>
    3ddf:	0f 8c da 00 00 00    	jl     3ebf <printf+0x137>
    3de5:	83 f8 78             	cmp    $0x78,%eax
    3de8:	0f 8f d1 00 00 00    	jg     3ebf <printf+0x137>
    3dee:	83 f8 63             	cmp    $0x63,%eax
    3df1:	0f 8c c8 00 00 00    	jl     3ebf <printf+0x137>
    3df7:	83 e8 63             	sub    $0x63,%eax
    3dfa:	83 f8 15             	cmp    $0x15,%eax
    3dfd:	0f 87 bc 00 00 00    	ja     3ebf <printf+0x137>
    3e03:	ff 24 85 e0 57 00 00 	jmp    *0x57e0(,%eax,4)
        printint(fd, *ap, 10, 1);
    3e0a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    3e0d:	8b 17                	mov    (%edi),%edx
    3e0f:	83 ec 0c             	sub    $0xc,%esp
    3e12:	6a 01                	push   $0x1
    3e14:	b9 0a 00 00 00       	mov    $0xa,%ecx
    3e19:	8b 45 08             	mov    0x8(%ebp),%eax
    3e1c:	e8 ee fe ff ff       	call   3d0f <printint>
        ap++;
    3e21:	83 c7 04             	add    $0x4,%edi
    3e24:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    3e27:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    3e2a:	be 00 00 00 00       	mov    $0x0,%esi
    3e2f:	eb 83                	jmp    3db4 <printf+0x2c>
        printint(fd, *ap, 16, 0);
    3e31:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    3e34:	8b 17                	mov    (%edi),%edx
    3e36:	83 ec 0c             	sub    $0xc,%esp
    3e39:	6a 00                	push   $0x0
    3e3b:	b9 10 00 00 00       	mov    $0x10,%ecx
    3e40:	8b 45 08             	mov    0x8(%ebp),%eax
    3e43:	e8 c7 fe ff ff       	call   3d0f <printint>
        ap++;
    3e48:	83 c7 04             	add    $0x4,%edi
    3e4b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    3e4e:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3e51:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
    3e56:	e9 59 ff ff ff       	jmp    3db4 <printf+0x2c>
        s = (char*)*ap;
    3e5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3e5e:	8b 30                	mov    (%eax),%esi
        ap++;
    3e60:	83 c0 04             	add    $0x4,%eax
    3e63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
    3e66:	85 f6                	test   %esi,%esi
    3e68:	75 13                	jne    3e7d <printf+0xf5>
          s = "(null)";
    3e6a:	be 51 50 00 00       	mov    $0x5051,%esi
    3e6f:	eb 0c                	jmp    3e7d <printf+0xf5>
          putc(fd, *s);
    3e71:	0f be d2             	movsbl %dl,%edx
    3e74:	8b 45 08             	mov    0x8(%ebp),%eax
    3e77:	e8 79 fe ff ff       	call   3cf5 <putc>
          s++;
    3e7c:	46                   	inc    %esi
        while(*s != 0){
    3e7d:	8a 16                	mov    (%esi),%dl
    3e7f:	84 d2                	test   %dl,%dl
    3e81:	75 ee                	jne    3e71 <printf+0xe9>
      state = 0;
    3e83:	be 00 00 00 00       	mov    $0x0,%esi
    3e88:	e9 27 ff ff ff       	jmp    3db4 <printf+0x2c>
        putc(fd, *ap);
    3e8d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    3e90:	0f be 17             	movsbl (%edi),%edx
    3e93:	8b 45 08             	mov    0x8(%ebp),%eax
    3e96:	e8 5a fe ff ff       	call   3cf5 <putc>
        ap++;
    3e9b:	83 c7 04             	add    $0x4,%edi
    3e9e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
    3ea1:	be 00 00 00 00       	mov    $0x0,%esi
    3ea6:	e9 09 ff ff ff       	jmp    3db4 <printf+0x2c>
        putc(fd, c);
    3eab:	89 fa                	mov    %edi,%edx
    3ead:	8b 45 08             	mov    0x8(%ebp),%eax
    3eb0:	e8 40 fe ff ff       	call   3cf5 <putc>
      state = 0;
    3eb5:	be 00 00 00 00       	mov    $0x0,%esi
    3eba:	e9 f5 fe ff ff       	jmp    3db4 <printf+0x2c>
        putc(fd, '%');
    3ebf:	ba 25 00 00 00       	mov    $0x25,%edx
    3ec4:	8b 45 08             	mov    0x8(%ebp),%eax
    3ec7:	e8 29 fe ff ff       	call   3cf5 <putc>
        putc(fd, c);
    3ecc:	89 fa                	mov    %edi,%edx
    3ece:	8b 45 08             	mov    0x8(%ebp),%eax
    3ed1:	e8 1f fe ff ff       	call   3cf5 <putc>
      state = 0;
    3ed6:	be 00 00 00 00       	mov    $0x0,%esi
    3edb:	e9 d4 fe ff ff       	jmp    3db4 <printf+0x2c>
    }
  }
}
    3ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3ee3:	5b                   	pop    %ebx
    3ee4:	5e                   	pop    %esi
    3ee5:	5f                   	pop    %edi
    3ee6:	5d                   	pop    %ebp
    3ee7:	c3                   	ret

00003ee8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3ee8:	55                   	push   %ebp
    3ee9:	89 e5                	mov    %esp,%ebp
    3eeb:	57                   	push   %edi
    3eec:	56                   	push   %esi
    3eed:	53                   	push   %ebx
    3eee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3ef1:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3ef4:	a1 a0 a8 00 00       	mov    0xa8a0,%eax
    3ef9:	eb 02                	jmp    3efd <free+0x15>
    3efb:	89 d0                	mov    %edx,%eax
    3efd:	39 c8                	cmp    %ecx,%eax
    3eff:	73 04                	jae    3f05 <free+0x1d>
    3f01:	3b 08                	cmp    (%eax),%ecx
    3f03:	72 12                	jb     3f17 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3f05:	8b 10                	mov    (%eax),%edx
    3f07:	39 d0                	cmp    %edx,%eax
    3f09:	72 f0                	jb     3efb <free+0x13>
    3f0b:	39 c8                	cmp    %ecx,%eax
    3f0d:	72 08                	jb     3f17 <free+0x2f>
    3f0f:	39 d1                	cmp    %edx,%ecx
    3f11:	72 04                	jb     3f17 <free+0x2f>
    3f13:	89 d0                	mov    %edx,%eax
    3f15:	eb e6                	jmp    3efd <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3f17:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3f1a:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3f1d:	8b 10                	mov    (%eax),%edx
    3f1f:	39 d7                	cmp    %edx,%edi
    3f21:	74 19                	je     3f3c <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3f23:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3f26:	8b 50 04             	mov    0x4(%eax),%edx
    3f29:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3f2c:	39 ce                	cmp    %ecx,%esi
    3f2e:	74 1b                	je     3f4b <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3f30:	89 08                	mov    %ecx,(%eax)
  freep = p;
    3f32:	a3 a0 a8 00 00       	mov    %eax,0xa8a0
}
    3f37:	5b                   	pop    %ebx
    3f38:	5e                   	pop    %esi
    3f39:	5f                   	pop    %edi
    3f3a:	5d                   	pop    %ebp
    3f3b:	c3                   	ret
    bp->s.size += p->s.ptr->s.size;
    3f3c:	03 72 04             	add    0x4(%edx),%esi
    3f3f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3f42:	8b 10                	mov    (%eax),%edx
    3f44:	8b 12                	mov    (%edx),%edx
    3f46:	89 53 f8             	mov    %edx,-0x8(%ebx)
    3f49:	eb db                	jmp    3f26 <free+0x3e>
    p->s.size += bp->s.size;
    3f4b:	03 53 fc             	add    -0x4(%ebx),%edx
    3f4e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3f51:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3f54:	89 10                	mov    %edx,(%eax)
    3f56:	eb da                	jmp    3f32 <free+0x4a>

00003f58 <morecore>:

static Header*
morecore(uint nu)
{
    3f58:	55                   	push   %ebp
    3f59:	89 e5                	mov    %esp,%ebp
    3f5b:	53                   	push   %ebx
    3f5c:	83 ec 04             	sub    $0x4,%esp
    3f5f:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
    3f61:	3d ff 0f 00 00       	cmp    $0xfff,%eax
    3f66:	77 05                	ja     3f6d <morecore+0x15>
    nu = 4096;
    3f68:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
    3f6d:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    3f74:	83 ec 0c             	sub    $0xc,%esp
    3f77:	50                   	push   %eax
    3f78:	e8 40 fd ff ff       	call   3cbd <sbrk>
  if(p == (char*)-1)
    3f7d:	83 c4 10             	add    $0x10,%esp
    3f80:	83 f8 ff             	cmp    $0xffffffff,%eax
    3f83:	74 1c                	je     3fa1 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    3f85:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    3f88:	83 c0 08             	add    $0x8,%eax
    3f8b:	83 ec 0c             	sub    $0xc,%esp
    3f8e:	50                   	push   %eax
    3f8f:	e8 54 ff ff ff       	call   3ee8 <free>
  return freep;
    3f94:	a1 a0 a8 00 00       	mov    0xa8a0,%eax
    3f99:	83 c4 10             	add    $0x10,%esp
}
    3f9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3f9f:	c9                   	leave
    3fa0:	c3                   	ret
    return 0;
    3fa1:	b8 00 00 00 00       	mov    $0x0,%eax
    3fa6:	eb f4                	jmp    3f9c <morecore+0x44>

00003fa8 <malloc>:

void*
malloc(uint nbytes)
{
    3fa8:	55                   	push   %ebp
    3fa9:	89 e5                	mov    %esp,%ebp
    3fab:	53                   	push   %ebx
    3fac:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3faf:	8b 45 08             	mov    0x8(%ebp),%eax
    3fb2:	8d 58 07             	lea    0x7(%eax),%ebx
    3fb5:	c1 eb 03             	shr    $0x3,%ebx
    3fb8:	43                   	inc    %ebx
  if((prevp = freep) == 0){
    3fb9:	8b 0d a0 a8 00 00    	mov    0xa8a0,%ecx
    3fbf:	85 c9                	test   %ecx,%ecx
    3fc1:	74 04                	je     3fc7 <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3fc3:	8b 01                	mov    (%ecx),%eax
    3fc5:	eb 4a                	jmp    4011 <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
    3fc7:	c7 05 a0 a8 00 00 a4 	movl   $0xa8a4,0xa8a0
    3fce:	a8 00 00 
    3fd1:	c7 05 a4 a8 00 00 a4 	movl   $0xa8a4,0xa8a4
    3fd8:	a8 00 00 
    base.s.size = 0;
    3fdb:	c7 05 a8 a8 00 00 00 	movl   $0x0,0xa8a8
    3fe2:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    3fe5:	b9 a4 a8 00 00       	mov    $0xa8a4,%ecx
    3fea:	eb d7                	jmp    3fc3 <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
    3fec:	74 19                	je     4007 <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    3fee:	29 da                	sub    %ebx,%edx
    3ff0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    3ff3:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    3ff6:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    3ff9:	89 0d a0 a8 00 00    	mov    %ecx,0xa8a0
      return (void*)(p + 1);
    3fff:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    4002:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    4005:	c9                   	leave
    4006:	c3                   	ret
        prevp->s.ptr = p->s.ptr;
    4007:	8b 10                	mov    (%eax),%edx
    4009:	89 11                	mov    %edx,(%ecx)
    400b:	eb ec                	jmp    3ff9 <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    400d:	89 c1                	mov    %eax,%ecx
    400f:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
    4011:	8b 50 04             	mov    0x4(%eax),%edx
    4014:	39 da                	cmp    %ebx,%edx
    4016:	73 d4                	jae    3fec <malloc+0x44>
    if(p == freep)
    4018:	39 05 a0 a8 00 00    	cmp    %eax,0xa8a0
    401e:	75 ed                	jne    400d <malloc+0x65>
      if((p = morecore(nunits)) == 0)
    4020:	89 d8                	mov    %ebx,%eax
    4022:	e8 31 ff ff ff       	call   3f58 <morecore>
    4027:	85 c0                	test   %eax,%eax
    4029:	75 e2                	jne    400d <malloc+0x65>
    402b:	eb d5                	jmp    4002 <malloc+0x5a>
