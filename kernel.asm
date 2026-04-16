
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 30 58 11 80       	mov    $0x80115830,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 1a 2a 10 80       	mov    $0x80102a1a,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
  struct buf *b;

  acquire(&bcache.lock);
80100041:	68 20 a5 10 80       	push   $0x8010a520
80100046:	e8 3b 3d 00 00       	call   80103d86 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010005f:	74 2e                	je     8010008f <bget+0x5b>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	40                   	inc    %eax
8010006f:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100072:	83 ec 0c             	sub    $0xc,%esp
80100075:	68 20 a5 10 80       	push   $0x8010a520
8010007a:	e8 6c 3d 00 00       	call   80103deb <release>
      acquiresleep(&b->lock);
8010007f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100082:	89 04 24             	mov    %eax,(%esp)
80100085:	e8 e4 3a 00 00       	call   80103b6e <acquiresleep>
      return b;
8010008a:	83 c4 10             	add    $0x10,%esp
8010008d:	eb 4c                	jmp    801000db <bget+0xa7>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010008f:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100095:	eb 03                	jmp    8010009a <bget+0x66>
80100097:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009a:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000a0:	74 43                	je     801000e5 <bget+0xb1>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a2:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a6:	75 ef                	jne    80100097 <bget+0x63>
801000a8:	f6 03 04             	testb  $0x4,(%ebx)
801000ab:	75 ea                	jne    80100097 <bget+0x63>
      b->dev = dev;
801000ad:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b0:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000b9:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c0:	83 ec 0c             	sub    $0xc,%esp
801000c3:	68 20 a5 10 80       	push   $0x8010a520
801000c8:	e8 1e 3d 00 00       	call   80103deb <release>
      acquiresleep(&b->lock);
801000cd:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d0:	89 04 24             	mov    %eax,(%esp)
801000d3:	e8 96 3a 00 00       	call   80103b6e <acquiresleep>
      return b;
801000d8:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000db:	89 d8                	mov    %ebx,%eax
801000dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e0:	5b                   	pop    %ebx
801000e1:	5e                   	pop    %esi
801000e2:	5f                   	pop    %edi
801000e3:	5d                   	pop    %ebp
801000e4:	c3                   	ret
  panic("bget: no buffers");
801000e5:	83 ec 0c             	sub    $0xc,%esp
801000e8:	68 00 6a 10 80       	push   $0x80106a00
801000ed:	e8 52 02 00 00       	call   80100344 <panic>

801000f2 <binit>:
{
801000f2:	55                   	push   %ebp
801000f3:	89 e5                	mov    %esp,%ebp
801000f5:	53                   	push   %ebx
801000f6:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000f9:	68 11 6a 10 80       	push   $0x80106a11
801000fe:	68 20 a5 10 80       	push   $0x8010a520
80100103:	e8 3e 3b 00 00       	call   80103c46 <initlock>
  bcache.head.prev = &bcache.head;
80100108:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010010f:	ec 10 80 
  bcache.head.next = &bcache.head;
80100112:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100119:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010011c:	83 c4 10             	add    $0x10,%esp
8010011f:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
80100124:	eb 37                	jmp    8010015d <binit+0x6b>
    b->next = bcache.head.next;
80100126:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010012b:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010012e:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100135:	83 ec 08             	sub    $0x8,%esp
80100138:	68 18 6a 10 80       	push   $0x80106a18
8010013d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100140:	50                   	push   %eax
80100141:	e8 f5 39 00 00       	call   80103b3b <initsleeplock>
    bcache.head.next->prev = b;
80100146:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010014b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010014e:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100154:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010015a:	83 c4 10             	add    $0x10,%esp
8010015d:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100163:	72 c1                	jb     80100126 <binit+0x34>
}
80100165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100168:	c9                   	leave
80100169:	c3                   	ret

8010016a <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
8010016a:	55                   	push   %ebp
8010016b:	89 e5                	mov    %esp,%ebp
8010016d:	53                   	push   %ebx
8010016e:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	8b 45 08             	mov    0x8(%ebp),%eax
80100177:	e8 b8 fe ff ff       	call   80100034 <bget>
8010017c:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
8010017e:	f6 00 02             	testb  $0x2,(%eax)
80100181:	74 07                	je     8010018a <bread+0x20>
    iderw(b);
  }
  return b;
}
80100183:	89 d8                	mov    %ebx,%eax
80100185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100188:	c9                   	leave
80100189:	c3                   	ret
    iderw(b);
8010018a:	83 ec 0c             	sub    $0xc,%esp
8010018d:	50                   	push   %eax
8010018e:	e8 6a 1c 00 00       	call   80101dfd <iderw>
80100193:	83 c4 10             	add    $0x10,%esp
  return b;
80100196:	eb eb                	jmp    80100183 <bread+0x19>

80100198 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100198:	55                   	push   %ebp
80100199:	89 e5                	mov    %esp,%ebp
8010019b:	53                   	push   %ebx
8010019c:	83 ec 10             	sub    $0x10,%esp
8010019f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001a2:	8d 43 0c             	lea    0xc(%ebx),%eax
801001a5:	50                   	push   %eax
801001a6:	e8 4d 3a 00 00       	call   80103bf8 <holdingsleep>
801001ab:	83 c4 10             	add    $0x10,%esp
801001ae:	85 c0                	test   %eax,%eax
801001b0:	74 18                	je     801001ca <bwrite+0x32>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b2:	8b 03                	mov    (%ebx),%eax
801001b4:	83 c8 04             	or     $0x4,%eax
801001b7:	89 03                	mov    %eax,(%ebx)
  iderw(b);
801001b9:	83 ec 0c             	sub    $0xc,%esp
801001bc:	53                   	push   %ebx
801001bd:	e8 3b 1c 00 00       	call   80101dfd <iderw>
}
801001c2:	83 c4 10             	add    $0x10,%esp
801001c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c8:	c9                   	leave
801001c9:	c3                   	ret
    panic("bwrite");
801001ca:	83 ec 0c             	sub    $0xc,%esp
801001cd:	68 1f 6a 10 80       	push   $0x80106a1f
801001d2:	e8 6d 01 00 00       	call   80100344 <panic>

801001d7 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001d7:	55                   	push   %ebp
801001d8:	89 e5                	mov    %esp,%ebp
801001da:	56                   	push   %esi
801001db:	53                   	push   %ebx
801001dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001df:	8d 73 0c             	lea    0xc(%ebx),%esi
801001e2:	83 ec 0c             	sub    $0xc,%esp
801001e5:	56                   	push   %esi
801001e6:	e8 0d 3a 00 00       	call   80103bf8 <holdingsleep>
801001eb:	83 c4 10             	add    $0x10,%esp
801001ee:	85 c0                	test   %eax,%eax
801001f0:	74 66                	je     80100258 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001f2:	83 ec 0c             	sub    $0xc,%esp
801001f5:	56                   	push   %esi
801001f6:	e8 c2 39 00 00       	call   80103bbd <releasesleep>

  acquire(&bcache.lock);
801001fb:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100202:	e8 7f 3b 00 00       	call   80103d86 <acquire>
  b->refcnt--;
80100207:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010020a:	48                   	dec    %eax
8010020b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010020e:	83 c4 10             	add    $0x10,%esp
80100211:	85 c0                	test   %eax,%eax
80100213:	75 2c                	jne    80100241 <brelse+0x6a>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100215:	8b 53 54             	mov    0x54(%ebx),%edx
80100218:	8b 43 50             	mov    0x50(%ebx),%eax
8010021b:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
8010021e:	8b 53 54             	mov    0x54(%ebx),%edx
80100221:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100224:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100229:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010022c:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    bcache.head.next->prev = b;
80100233:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100238:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023b:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
80100241:	83 ec 0c             	sub    $0xc,%esp
80100244:	68 20 a5 10 80       	push   $0x8010a520
80100249:	e8 9d 3b 00 00       	call   80103deb <release>
}
8010024e:	83 c4 10             	add    $0x10,%esp
80100251:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100254:	5b                   	pop    %ebx
80100255:	5e                   	pop    %esi
80100256:	5d                   	pop    %ebp
80100257:	c3                   	ret
    panic("brelse");
80100258:	83 ec 0c             	sub    $0xc,%esp
8010025b:	68 26 6a 10 80       	push   $0x80106a26
80100260:	e8 df 00 00 00       	call   80100344 <panic>

80100265 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100265:	55                   	push   %ebp
80100266:	89 e5                	mov    %esp,%ebp
80100268:	57                   	push   %edi
80100269:	56                   	push   %esi
8010026a:	53                   	push   %ebx
8010026b:	83 ec 28             	sub    $0x28,%esp
8010026e:	8b 7d 08             	mov    0x8(%ebp),%edi
80100271:	8b 75 0c             	mov    0xc(%ebp),%esi
80100274:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
80100277:	57                   	push   %edi
80100278:	e8 bc 13 00 00       	call   80101639 <iunlock>
  target = n;
8010027d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100280:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100287:	e8 fa 3a 00 00       	call   80103d86 <acquire>
  while(n > 0){
8010028c:	83 c4 10             	add    $0x10,%esp
8010028f:	85 db                	test   %ebx,%ebx
80100291:	0f 8e 8e 00 00 00    	jle    80100325 <consoleread+0xc0>
    while(input.r == input.w){
80100297:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010029c:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002a2:	75 47                	jne    801002eb <consoleread+0x86>
      if(myproc()->killed){
801002a4:	e8 e0 2f 00 00       	call   80103289 <myproc>
801002a9:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002ad:	75 17                	jne    801002c6 <consoleread+0x61>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002af:	83 ec 08             	sub    $0x8,%esp
801002b2:	68 20 ef 10 80       	push   $0x8010ef20
801002b7:	68 00 ef 10 80       	push   $0x8010ef00
801002bc:	e8 ac 34 00 00       	call   8010376d <sleep>
801002c1:	83 c4 10             	add    $0x10,%esp
801002c4:	eb d1                	jmp    80100297 <consoleread+0x32>
        release(&cons.lock);
801002c6:	83 ec 0c             	sub    $0xc,%esp
801002c9:	68 20 ef 10 80       	push   $0x8010ef20
801002ce:	e8 18 3b 00 00       	call   80103deb <release>
        ilock(ip);
801002d3:	89 3c 24             	mov    %edi,(%esp)
801002d6:	e8 9e 12 00 00       	call   80101579 <ilock>
        return -1;
801002db:	83 c4 10             	add    $0x10,%esp
801002de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002e6:	5b                   	pop    %ebx
801002e7:	5e                   	pop    %esi
801002e8:	5f                   	pop    %edi
801002e9:	5d                   	pop    %ebp
801002ea:	c3                   	ret
    c = input.buf[input.r++ % INPUT_BUF];
801002eb:	8d 50 01             	lea    0x1(%eax),%edx
801002ee:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
801002f4:	89 c2                	mov    %eax,%edx
801002f6:	83 e2 7f             	and    $0x7f,%edx
801002f9:	8a 92 80 ee 10 80    	mov    -0x7fef1180(%edx),%dl
801002ff:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
80100302:	80 fa 04             	cmp    $0x4,%dl
80100305:	74 12                	je     80100319 <consoleread+0xb4>
    *dst++ = c;
80100307:	8d 46 01             	lea    0x1(%esi),%eax
8010030a:	88 16                	mov    %dl,(%esi)
    --n;
8010030c:	4b                   	dec    %ebx
    if(c == '\n')
8010030d:	83 f9 0a             	cmp    $0xa,%ecx
80100310:	74 13                	je     80100325 <consoleread+0xc0>
    *dst++ = c;
80100312:	89 c6                	mov    %eax,%esi
80100314:	e9 76 ff ff ff       	jmp    8010028f <consoleread+0x2a>
      if(n < target){
80100319:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010031c:	39 cb                	cmp    %ecx,%ebx
8010031e:	73 05                	jae    80100325 <consoleread+0xc0>
        input.r--;
80100320:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
  release(&cons.lock);
80100325:	83 ec 0c             	sub    $0xc,%esp
80100328:	68 20 ef 10 80       	push   $0x8010ef20
8010032d:	e8 b9 3a 00 00       	call   80103deb <release>
  ilock(ip);
80100332:	89 3c 24             	mov    %edi,(%esp)
80100335:	e8 3f 12 00 00       	call   80101579 <ilock>
  return target - n;
8010033a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010033d:	29 d8                	sub    %ebx,%eax
8010033f:	83 c4 10             	add    $0x10,%esp
80100342:	eb 9f                	jmp    801002e3 <consoleread+0x7e>

80100344 <panic>:
{
80100344:	55                   	push   %ebp
80100345:	89 e5                	mov    %esp,%ebp
80100347:	53                   	push   %ebx
80100348:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010034b:	fa                   	cli
  cons.locking = 0;
8010034c:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100353:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100356:	e8 08 20 00 00       	call   80102363 <lapicid>
8010035b:	83 ec 08             	sub    $0x8,%esp
8010035e:	50                   	push   %eax
8010035f:	68 2d 6a 10 80       	push   $0x80106a2d
80100364:	e8 76 02 00 00       	call   801005df <cprintf>
  cprintf(s);
80100369:	83 c4 04             	add    $0x4,%esp
8010036c:	ff 75 08             	push   0x8(%ebp)
8010036f:	e8 6b 02 00 00       	call   801005df <cprintf>
  cprintf("\n");
80100374:	c7 04 24 e7 6e 10 80 	movl   $0x80106ee7,(%esp)
8010037b:	e8 5f 02 00 00       	call   801005df <cprintf>
  getcallerpcs(&s, pcs);
80100380:	83 c4 08             	add    $0x8,%esp
80100383:	8d 45 d0             	lea    -0x30(%ebp),%eax
80100386:	50                   	push   %eax
80100387:	8d 45 08             	lea    0x8(%ebp),%eax
8010038a:	50                   	push   %eax
8010038b:	e8 d1 38 00 00       	call   80103c61 <getcallerpcs>
  for(i=0; i<10; i++)
80100390:	83 c4 10             	add    $0x10,%esp
80100393:	bb 00 00 00 00       	mov    $0x0,%ebx
80100398:	eb 15                	jmp    801003af <panic+0x6b>
    cprintf(" %p", pcs[i]);
8010039a:	83 ec 08             	sub    $0x8,%esp
8010039d:	ff 74 9d d0          	push   -0x30(%ebp,%ebx,4)
801003a1:	68 41 6a 10 80       	push   $0x80106a41
801003a6:	e8 34 02 00 00       	call   801005df <cprintf>
  for(i=0; i<10; i++)
801003ab:	43                   	inc    %ebx
801003ac:	83 c4 10             	add    $0x10,%esp
801003af:	83 fb 09             	cmp    $0x9,%ebx
801003b2:	7e e6                	jle    8010039a <panic+0x56>
  panicked = 1; // freeze other CPU
801003b4:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003bb:	00 00 00 
  for(;;)
801003be:	eb fe                	jmp    801003be <panic+0x7a>

801003c0 <cgaputc>:
{
801003c0:	55                   	push   %ebp
801003c1:	89 e5                	mov    %esp,%ebp
801003c3:	57                   	push   %edi
801003c4:	56                   	push   %esi
801003c5:	53                   	push   %ebx
801003c6:	83 ec 0c             	sub    $0xc,%esp
801003c9:	89 c3                	mov    %eax,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003cb:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003d0:	b0 0e                	mov    $0xe,%al
801003d2:	89 fa                	mov    %edi,%edx
801003d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003d5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003da:	89 ca                	mov    %ecx,%edx
801003dc:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003dd:	0f b6 f0             	movzbl %al,%esi
801003e0:	c1 e6 08             	shl    $0x8,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e3:	b0 0f                	mov    $0xf,%al
801003e5:	89 fa                	mov    %edi,%edx
801003e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003e8:	89 ca                	mov    %ecx,%edx
801003ea:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801003eb:	0f b6 c8             	movzbl %al,%ecx
801003ee:	09 f1                	or     %esi,%ecx
  if(c == '\n')
801003f0:	83 fb 0a             	cmp    $0xa,%ebx
801003f3:	74 5a                	je     8010044f <cgaputc+0x8f>
  else if(c == BACKSPACE){
801003f5:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
801003fb:	74 62                	je     8010045f <cgaputc+0x9f>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801003fd:	0f b6 c3             	movzbl %bl,%eax
80100400:	8d 59 01             	lea    0x1(%ecx),%ebx
80100403:	80 cc 07             	or     $0x7,%ah
80100406:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
8010040d:	80 
  if(pos < 0 || pos > 25*80)
8010040e:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100414:	77 56                	ja     8010046c <cgaputc+0xac>
  if((pos/80) >= 24){  // Scroll up.
80100416:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010041c:	7f 5b                	jg     80100479 <cgaputc+0xb9>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010041e:	be d4 03 00 00       	mov    $0x3d4,%esi
80100423:	b0 0e                	mov    $0xe,%al
80100425:	89 f2                	mov    %esi,%edx
80100427:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100428:	0f b6 c7             	movzbl %bh,%eax
8010042b:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100430:	89 ca                	mov    %ecx,%edx
80100432:	ee                   	out    %al,(%dx)
80100433:	b0 0f                	mov    $0xf,%al
80100435:	89 f2                	mov    %esi,%edx
80100437:	ee                   	out    %al,(%dx)
80100438:	88 d8                	mov    %bl,%al
8010043a:	89 ca                	mov    %ecx,%edx
8010043c:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010043d:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100444:	80 20 07 
}
80100447:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010044a:	5b                   	pop    %ebx
8010044b:	5e                   	pop    %esi
8010044c:	5f                   	pop    %edi
8010044d:	5d                   	pop    %ebp
8010044e:	c3                   	ret
    pos += 80 - pos%80;
8010044f:	bb 50 00 00 00       	mov    $0x50,%ebx
80100454:	89 c8                	mov    %ecx,%eax
80100456:	99                   	cltd
80100457:	f7 fb                	idiv   %ebx
80100459:	29 d3                	sub    %edx,%ebx
8010045b:	01 cb                	add    %ecx,%ebx
8010045d:	eb af                	jmp    8010040e <cgaputc+0x4e>
    if(pos > 0) --pos;
8010045f:	85 c9                	test   %ecx,%ecx
80100461:	7e 05                	jle    80100468 <cgaputc+0xa8>
80100463:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100466:	eb a6                	jmp    8010040e <cgaputc+0x4e>
  pos |= inb(CRTPORT+1);
80100468:	89 cb                	mov    %ecx,%ebx
8010046a:	eb a2                	jmp    8010040e <cgaputc+0x4e>
    panic("pos under/overflow");
8010046c:	83 ec 0c             	sub    $0xc,%esp
8010046f:	68 45 6a 10 80       	push   $0x80106a45
80100474:	e8 cb fe ff ff       	call   80100344 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100479:	83 ec 04             	sub    $0x4,%esp
8010047c:	68 60 0e 00 00       	push   $0xe60
80100481:	68 a0 80 0b 80       	push   $0x800b80a0
80100486:	68 00 80 0b 80       	push   $0x800b8000
8010048b:	e8 18 3a 00 00       	call   80103ea8 <memmove>
    pos -= 80;
80100490:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100493:	b8 80 07 00 00       	mov    $0x780,%eax
80100498:	29 d8                	sub    %ebx,%eax
8010049a:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801004a1:	83 c4 0c             	add    $0xc,%esp
801004a4:	01 c0                	add    %eax,%eax
801004a6:	50                   	push   %eax
801004a7:	6a 00                	push   $0x0
801004a9:	52                   	push   %edx
801004aa:	e8 83 39 00 00       	call   80103e32 <memset>
801004af:	83 c4 10             	add    $0x10,%esp
801004b2:	e9 67 ff ff ff       	jmp    8010041e <cgaputc+0x5e>

801004b7 <consputc>:
  if(panicked){
801004b7:	83 3d 58 ef 10 80 00 	cmpl   $0x0,0x8010ef58
801004be:	74 03                	je     801004c3 <consputc+0xc>
  asm volatile("cli");
801004c0:	fa                   	cli
    for(;;)
801004c1:	eb fe                	jmp    801004c1 <consputc+0xa>
{
801004c3:	55                   	push   %ebp
801004c4:	89 e5                	mov    %esp,%ebp
801004c6:	53                   	push   %ebx
801004c7:	83 ec 04             	sub    $0x4,%esp
801004ca:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
801004cc:	3d 00 01 00 00       	cmp    $0x100,%eax
801004d1:	74 18                	je     801004eb <consputc+0x34>
    uartputc(c);
801004d3:	83 ec 0c             	sub    $0xc,%esp
801004d6:	50                   	push   %eax
801004d7:	e8 85 4f 00 00       	call   80105461 <uartputc>
801004dc:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801004df:	89 d8                	mov    %ebx,%eax
801004e1:	e8 da fe ff ff       	call   801003c0 <cgaputc>
}
801004e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801004e9:	c9                   	leave
801004ea:	c3                   	ret
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004eb:	83 ec 0c             	sub    $0xc,%esp
801004ee:	6a 08                	push   $0x8
801004f0:	e8 6c 4f 00 00       	call   80105461 <uartputc>
801004f5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004fc:	e8 60 4f 00 00       	call   80105461 <uartputc>
80100501:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100508:	e8 54 4f 00 00       	call   80105461 <uartputc>
8010050d:	83 c4 10             	add    $0x10,%esp
80100510:	eb cd                	jmp    801004df <consputc+0x28>

80100512 <printint>:
{
80100512:	55                   	push   %ebp
80100513:	89 e5                	mov    %esp,%ebp
80100515:	57                   	push   %edi
80100516:	56                   	push   %esi
80100517:	53                   	push   %ebx
80100518:	83 ec 2c             	sub    $0x2c,%esp
8010051b:	89 c3                	mov    %eax,%ebx
8010051d:	89 d6                	mov    %edx,%esi
8010051f:	89 c8                	mov    %ecx,%eax
  if(sign && (sign = xx < 0))
80100521:	85 c9                	test   %ecx,%ecx
80100523:	74 09                	je     8010052e <printint+0x1c>
80100525:	89 d8                	mov    %ebx,%eax
80100527:	c1 e8 1f             	shr    $0x1f,%eax
8010052a:	85 db                	test   %ebx,%ebx
8010052c:	78 39                	js     80100567 <printint+0x55>
    x = xx;
8010052e:	89 d9                	mov    %ebx,%ecx
  i = 0;
80100530:	bb 00 00 00 00       	mov    $0x0,%ebx
80100535:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    buf[i++] = digits[x % base];
80100538:	89 c8                	mov    %ecx,%eax
8010053a:	ba 00 00 00 00       	mov    $0x0,%edx
8010053f:	f7 f6                	div    %esi
80100541:	89 df                	mov    %ebx,%edi
80100543:	43                   	inc    %ebx
80100544:	8a 92 04 6f 10 80    	mov    -0x7fef90fc(%edx),%dl
8010054a:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
8010054e:	89 ca                	mov    %ecx,%edx
80100550:	89 c1                	mov    %eax,%ecx
80100552:	39 f2                	cmp    %esi,%edx
80100554:	73 e2                	jae    80100538 <printint+0x26>
  if(sign)
80100556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100559:	85 c0                	test   %eax,%eax
8010055b:	74 1a                	je     80100577 <printint+0x65>
    buf[i++] = '-';
8010055d:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
80100562:	8d 5f 02             	lea    0x2(%edi),%ebx
80100565:	eb 10                	jmp    80100577 <printint+0x65>
    x = -xx;
80100567:	89 d9                	mov    %ebx,%ecx
80100569:	f7 d9                	neg    %ecx
8010056b:	eb c3                	jmp    80100530 <printint+0x1e>
    consputc(buf[i]);
8010056d:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
80100572:	e8 40 ff ff ff       	call   801004b7 <consputc>
  while(--i >= 0)
80100577:	4b                   	dec    %ebx
80100578:	79 f3                	jns    8010056d <printint+0x5b>
}
8010057a:	83 c4 2c             	add    $0x2c,%esp
8010057d:	5b                   	pop    %ebx
8010057e:	5e                   	pop    %esi
8010057f:	5f                   	pop    %edi
80100580:	5d                   	pop    %ebp
80100581:	c3                   	ret

80100582 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100582:	55                   	push   %ebp
80100583:	89 e5                	mov    %esp,%ebp
80100585:	57                   	push   %edi
80100586:	56                   	push   %esi
80100587:	53                   	push   %ebx
80100588:	83 ec 18             	sub    $0x18,%esp
8010058b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010058e:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
80100591:	ff 75 08             	push   0x8(%ebp)
80100594:	e8 a0 10 00 00       	call   80101639 <iunlock>
  acquire(&cons.lock);
80100599:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005a0:	e8 e1 37 00 00       	call   80103d86 <acquire>
  for(i = 0; i < n; i++)
801005a5:	83 c4 10             	add    $0x10,%esp
801005a8:	bb 00 00 00 00       	mov    $0x0,%ebx
801005ad:	eb 0a                	jmp    801005b9 <consolewrite+0x37>
    consputc(buf[i] & 0xff);
801005af:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005b3:	e8 ff fe ff ff       	call   801004b7 <consputc>
  for(i = 0; i < n; i++)
801005b8:	43                   	inc    %ebx
801005b9:	39 f3                	cmp    %esi,%ebx
801005bb:	7c f2                	jl     801005af <consolewrite+0x2d>
  release(&cons.lock);
801005bd:	83 ec 0c             	sub    $0xc,%esp
801005c0:	68 20 ef 10 80       	push   $0x8010ef20
801005c5:	e8 21 38 00 00       	call   80103deb <release>
  ilock(ip);
801005ca:	83 c4 04             	add    $0x4,%esp
801005cd:	ff 75 08             	push   0x8(%ebp)
801005d0:	e8 a4 0f 00 00       	call   80101579 <ilock>

  return n;
}
801005d5:	89 f0                	mov    %esi,%eax
801005d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005da:	5b                   	pop    %ebx
801005db:	5e                   	pop    %esi
801005dc:	5f                   	pop    %edi
801005dd:	5d                   	pop    %ebp
801005de:	c3                   	ret

801005df <cprintf>:
{
801005df:	55                   	push   %ebp
801005e0:	89 e5                	mov    %esp,%ebp
801005e2:	57                   	push   %edi
801005e3:	56                   	push   %esi
801005e4:	53                   	push   %ebx
801005e5:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801005e8:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801005ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801005f0:	85 c0                	test   %eax,%eax
801005f2:	75 10                	jne    80100604 <cprintf+0x25>
  if (fmt == 0)
801005f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801005f8:	74 1c                	je     80100616 <cprintf+0x37>
  argp = (uint*)(void*)(&fmt + 1);
801005fa:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005fd:	bb 00 00 00 00       	mov    $0x0,%ebx
80100602:	eb 25                	jmp    80100629 <cprintf+0x4a>
    acquire(&cons.lock);
80100604:	83 ec 0c             	sub    $0xc,%esp
80100607:	68 20 ef 10 80       	push   $0x8010ef20
8010060c:	e8 75 37 00 00       	call   80103d86 <acquire>
80100611:	83 c4 10             	add    $0x10,%esp
80100614:	eb de                	jmp    801005f4 <cprintf+0x15>
    panic("null fmt");
80100616:	83 ec 0c             	sub    $0xc,%esp
80100619:	68 5f 6a 10 80       	push   $0x80106a5f
8010061e:	e8 21 fd ff ff       	call   80100344 <panic>
      consputc(c);
80100623:	e8 8f fe ff ff       	call   801004b7 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100628:	43                   	inc    %ebx
80100629:	8b 55 08             	mov    0x8(%ebp),%edx
8010062c:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
80100630:	85 c0                	test   %eax,%eax
80100632:	0f 84 a9 00 00 00    	je     801006e1 <cprintf+0x102>
    if(c != '%'){
80100638:	83 f8 25             	cmp    $0x25,%eax
8010063b:	75 e6                	jne    80100623 <cprintf+0x44>
    c = fmt[++i] & 0xff;
8010063d:	43                   	inc    %ebx
8010063e:	0f b6 34 1a          	movzbl (%edx,%ebx,1),%esi
    if(c == 0)
80100642:	85 f6                	test   %esi,%esi
80100644:	0f 84 97 00 00 00    	je     801006e1 <cprintf+0x102>
    switch(c){
8010064a:	83 fe 70             	cmp    $0x70,%esi
8010064d:	74 41                	je     80100690 <cprintf+0xb1>
8010064f:	7f 22                	jg     80100673 <cprintf+0x94>
80100651:	83 fe 25             	cmp    $0x25,%esi
80100654:	74 7c                	je     801006d2 <cprintf+0xf3>
80100656:	83 fe 64             	cmp    $0x64,%esi
80100659:	75 22                	jne    8010067d <cprintf+0x9e>
      printint(*argp++, 10, 1);
8010065b:	8d 77 04             	lea    0x4(%edi),%esi
8010065e:	8b 07                	mov    (%edi),%eax
80100660:	b9 01 00 00 00       	mov    $0x1,%ecx
80100665:	ba 0a 00 00 00       	mov    $0xa,%edx
8010066a:	e8 a3 fe ff ff       	call   80100512 <printint>
8010066f:	89 f7                	mov    %esi,%edi
      break;
80100671:	eb b5                	jmp    80100628 <cprintf+0x49>
    switch(c){
80100673:	83 fe 73             	cmp    $0x73,%esi
80100676:	74 30                	je     801006a8 <cprintf+0xc9>
80100678:	83 fe 78             	cmp    $0x78,%esi
8010067b:	74 13                	je     80100690 <cprintf+0xb1>
      consputc('%');
8010067d:	b8 25 00 00 00       	mov    $0x25,%eax
80100682:	e8 30 fe ff ff       	call   801004b7 <consputc>
      consputc(c);
80100687:	89 f0                	mov    %esi,%eax
80100689:	e8 29 fe ff ff       	call   801004b7 <consputc>
      break;
8010068e:	eb 98                	jmp    80100628 <cprintf+0x49>
      printint(*argp++, 16, 0);
80100690:	8d 77 04             	lea    0x4(%edi),%esi
80100693:	8b 07                	mov    (%edi),%eax
80100695:	b9 00 00 00 00       	mov    $0x0,%ecx
8010069a:	ba 10 00 00 00       	mov    $0x10,%edx
8010069f:	e8 6e fe ff ff       	call   80100512 <printint>
801006a4:	89 f7                	mov    %esi,%edi
      break;
801006a6:	eb 80                	jmp    80100628 <cprintf+0x49>
      if((s = (char*)*argp++) == 0)
801006a8:	8d 47 04             	lea    0x4(%edi),%eax
801006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006ae:	8b 37                	mov    (%edi),%esi
801006b0:	85 f6                	test   %esi,%esi
801006b2:	75 10                	jne    801006c4 <cprintf+0xe5>
        s = "(null)";
801006b4:	be 58 6a 10 80       	mov    $0x80106a58,%esi
801006b9:	eb 09                	jmp    801006c4 <cprintf+0xe5>
        consputc(*s);
801006bb:	0f be c0             	movsbl %al,%eax
801006be:	e8 f4 fd ff ff       	call   801004b7 <consputc>
      for(; *s; s++)
801006c3:	46                   	inc    %esi
801006c4:	8a 06                	mov    (%esi),%al
801006c6:	84 c0                	test   %al,%al
801006c8:	75 f1                	jne    801006bb <cprintf+0xdc>
      if((s = (char*)*argp++) == 0)
801006ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801006cd:	e9 56 ff ff ff       	jmp    80100628 <cprintf+0x49>
      consputc('%');
801006d2:	b8 25 00 00 00       	mov    $0x25,%eax
801006d7:	e8 db fd ff ff       	call   801004b7 <consputc>
      break;
801006dc:	e9 47 ff ff ff       	jmp    80100628 <cprintf+0x49>
  if(locking)
801006e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801006e5:	75 08                	jne    801006ef <cprintf+0x110>
}
801006e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006ea:	5b                   	pop    %ebx
801006eb:	5e                   	pop    %esi
801006ec:	5f                   	pop    %edi
801006ed:	5d                   	pop    %ebp
801006ee:	c3                   	ret
    release(&cons.lock);
801006ef:	83 ec 0c             	sub    $0xc,%esp
801006f2:	68 20 ef 10 80       	push   $0x8010ef20
801006f7:	e8 ef 36 00 00       	call   80103deb <release>
801006fc:	83 c4 10             	add    $0x10,%esp
}
801006ff:	eb e6                	jmp    801006e7 <cprintf+0x108>

80100701 <consoleintr>:
{
80100701:	55                   	push   %ebp
80100702:	89 e5                	mov    %esp,%ebp
80100704:	57                   	push   %edi
80100705:	56                   	push   %esi
80100706:	53                   	push   %ebx
80100707:	83 ec 18             	sub    $0x18,%esp
8010070a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010070d:	68 20 ef 10 80       	push   $0x8010ef20
80100712:	e8 6f 36 00 00       	call   80103d86 <acquire>
  while((c = getc()) >= 0){
80100717:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
8010071a:	be 00 00 00 00       	mov    $0x0,%esi
  while((c = getc()) >= 0){
8010071f:	e9 bb 00 00 00       	jmp    801007df <consoleintr+0xde>
    switch(c){
80100724:	83 ff 7f             	cmp    $0x7f,%edi
80100727:	0f 84 a5 00 00 00    	je     801007d2 <consoleintr+0xd1>
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010072d:	85 ff                	test   %edi,%edi
8010072f:	0f 84 aa 00 00 00    	je     801007df <consoleintr+0xde>
80100735:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010073a:	89 c2                	mov    %eax,%edx
8010073c:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100742:	83 fa 7f             	cmp    $0x7f,%edx
80100745:	0f 87 94 00 00 00    	ja     801007df <consoleintr+0xde>
        c = (c == '\r') ? '\n' : c;
8010074b:	83 ff 0d             	cmp    $0xd,%edi
8010074e:	0f 84 c5 00 00 00    	je     80100819 <consoleintr+0x118>
        input.buf[input.e++ % INPUT_BUF] = c;
80100754:	8d 50 01             	lea    0x1(%eax),%edx
80100757:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
8010075d:	83 e0 7f             	and    $0x7f,%eax
80100760:	89 f9                	mov    %edi,%ecx
80100762:	88 88 80 ee 10 80    	mov    %cl,-0x7fef1180(%eax)
        consputc(c);
80100768:	89 f8                	mov    %edi,%eax
8010076a:	e8 48 fd ff ff       	call   801004b7 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010076f:	83 ff 0a             	cmp    $0xa,%edi
80100772:	74 15                	je     80100789 <consoleintr+0x88>
80100774:	83 ff 04             	cmp    $0x4,%edi
80100777:	74 10                	je     80100789 <consoleintr+0x88>
80100779:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010077e:	83 e8 80             	sub    $0xffffff80,%eax
80100781:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100787:	75 56                	jne    801007df <consoleintr+0xde>
          input.w = input.e;
80100789:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010078e:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100793:	83 ec 0c             	sub    $0xc,%esp
80100796:	68 00 ef 10 80       	push   $0x8010ef00
8010079b:	e8 48 31 00 00       	call   801038e8 <wakeup>
801007a0:	83 c4 10             	add    $0x10,%esp
801007a3:	eb 3a                	jmp    801007df <consoleintr+0xde>
        input.e--;
801007a5:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
        consputc(BACKSPACE);
801007aa:	b8 00 01 00 00       	mov    $0x100,%eax
801007af:	e8 03 fd ff ff       	call   801004b7 <consputc>
      while(input.e != input.w &&
801007b4:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007b9:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801007bf:	74 1e                	je     801007df <consoleintr+0xde>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801007c1:	48                   	dec    %eax
801007c2:	89 c2                	mov    %eax,%edx
801007c4:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801007c7:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
801007ce:	75 d5                	jne    801007a5 <consoleintr+0xa4>
801007d0:	eb 0d                	jmp    801007df <consoleintr+0xde>
      if(input.e != input.w){
801007d2:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007d7:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801007dd:	75 28                	jne    80100807 <consoleintr+0x106>
  while((c = getc()) >= 0){
801007df:	ff d3                	call   *%ebx
801007e1:	89 c7                	mov    %eax,%edi
801007e3:	85 c0                	test   %eax,%eax
801007e5:	78 3c                	js     80100823 <consoleintr+0x122>
    switch(c){
801007e7:	83 ff 15             	cmp    $0x15,%edi
801007ea:	74 c8                	je     801007b4 <consoleintr+0xb3>
801007ec:	0f 8f 32 ff ff ff    	jg     80100724 <consoleintr+0x23>
801007f2:	83 ff 08             	cmp    $0x8,%edi
801007f5:	74 db                	je     801007d2 <consoleintr+0xd1>
801007f7:	83 ff 10             	cmp    $0x10,%edi
801007fa:	0f 85 2d ff ff ff    	jne    8010072d <consoleintr+0x2c>
80100800:	be 01 00 00 00       	mov    $0x1,%esi
80100805:	eb d8                	jmp    801007df <consoleintr+0xde>
        input.e--;
80100807:	48                   	dec    %eax
80100808:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
        consputc(BACKSPACE);
8010080d:	b8 00 01 00 00       	mov    $0x100,%eax
80100812:	e8 a0 fc ff ff       	call   801004b7 <consputc>
80100817:	eb c6                	jmp    801007df <consoleintr+0xde>
        c = (c == '\r') ? '\n' : c;
80100819:	bf 0a 00 00 00       	mov    $0xa,%edi
8010081e:	e9 31 ff ff ff       	jmp    80100754 <consoleintr+0x53>
  release(&cons.lock);
80100823:	83 ec 0c             	sub    $0xc,%esp
80100826:	68 20 ef 10 80       	push   $0x8010ef20
8010082b:	e8 bb 35 00 00       	call   80103deb <release>
  if(doprocdump) {
80100830:	83 c4 10             	add    $0x10,%esp
80100833:	85 f6                	test   %esi,%esi
80100835:	75 08                	jne    8010083f <consoleintr+0x13e>
}
80100837:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010083a:	5b                   	pop    %ebx
8010083b:	5e                   	pop    %esi
8010083c:	5f                   	pop    %edi
8010083d:	5d                   	pop    %ebp
8010083e:	c3                   	ret
    procdump();  // now call procdump() wo. cons.lock held
8010083f:	e8 4f 31 00 00       	call   80103993 <procdump>
}
80100844:	eb f1                	jmp    80100837 <consoleintr+0x136>

80100846 <consoleinit>:

void
consoleinit(void)
{
80100846:	55                   	push   %ebp
80100847:	89 e5                	mov    %esp,%ebp
80100849:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
8010084c:	68 68 6a 10 80       	push   $0x80106a68
80100851:	68 20 ef 10 80       	push   $0x8010ef20
80100856:	e8 eb 33 00 00       	call   80103c46 <initlock>

  devsw[CONSOLE].write = consolewrite;
8010085b:	c7 05 0c f9 10 80 82 	movl   $0x80100582,0x8010f90c
80100862:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100865:	c7 05 08 f9 10 80 65 	movl   $0x80100265,0x8010f908
8010086c:	02 10 80 
  cons.locking = 1;
8010086f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100876:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100879:	83 c4 08             	add    $0x8,%esp
8010087c:	6a 00                	push   $0x0
8010087e:	6a 01                	push   $0x1
80100880:	e8 e0 16 00 00       	call   80101f65 <ioapicenable>
}
80100885:	83 c4 10             	add    $0x10,%esp
80100888:	c9                   	leave
80100889:	c3                   	ret

8010088a <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
8010088a:	55                   	push   %ebp
8010088b:	89 e5                	mov    %esp,%ebp
8010088d:	57                   	push   %edi
8010088e:	56                   	push   %esi
8010088f:	53                   	push   %ebx
80100890:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100896:	e8 ee 29 00 00       	call   80103289 <myproc>
8010089b:	89 c7                	mov    %eax,%edi

  begin_op();
8010089d:	e8 be 1e 00 00       	call   80102760 <begin_op>

  if((ip = namei(path)) == 0){
801008a2:	83 ec 0c             	sub    $0xc,%esp
801008a5:	ff 75 08             	push   0x8(%ebp)
801008a8:	e8 38 13 00 00       	call   80101be5 <namei>
801008ad:	83 c4 10             	add    $0x10,%esp
801008b0:	85 c0                	test   %eax,%eax
801008b2:	74 56                	je     8010090a <exec+0x80>
801008b4:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801008b6:	83 ec 0c             	sub    $0xc,%esp
801008b9:	50                   	push   %eax
801008ba:	e8 ba 0c 00 00       	call   80101579 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801008bf:	6a 34                	push   $0x34
801008c1:	6a 00                	push   $0x0
801008c3:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801008c9:	50                   	push   %eax
801008ca:	53                   	push   %ebx
801008cb:	e8 96 0e 00 00       	call   80101766 <readi>
801008d0:	83 c4 20             	add    $0x20,%esp
801008d3:	83 f8 34             	cmp    $0x34,%eax
801008d6:	75 0c                	jne    801008e4 <exec+0x5a>
    goto bad;
  if(elf.magic != ELF_MAGIC)
801008d8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801008df:	45 4c 46 
801008e2:	74 42                	je     80100926 <exec+0x9c>
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir, 1);
  if(ip){
801008e4:	85 db                	test   %ebx,%ebx
801008e6:	0f 84 d7 02 00 00    	je     80100bc3 <exec+0x339>
    iunlockput(ip);
801008ec:	83 ec 0c             	sub    $0xc,%esp
801008ef:	53                   	push   %ebx
801008f0:	e8 27 0e 00 00       	call   8010171c <iunlockput>
    end_op();
801008f5:	e8 e2 1e 00 00       	call   801027dc <end_op>
801008fa:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
801008fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100902:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100905:	5b                   	pop    %ebx
80100906:	5e                   	pop    %esi
80100907:	5f                   	pop    %edi
80100908:	5d                   	pop    %ebp
80100909:	c3                   	ret
    end_op();
8010090a:	e8 cd 1e 00 00       	call   801027dc <end_op>
    cprintf("exec: fail\n");
8010090f:	83 ec 0c             	sub    $0xc,%esp
80100912:	68 70 6a 10 80       	push   $0x80106a70
80100917:	e8 c3 fc ff ff       	call   801005df <cprintf>
    return -1;
8010091c:	83 c4 10             	add    $0x10,%esp
8010091f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100924:	eb dc                	jmp    80100902 <exec+0x78>
  if((pgdir = setupkvm()) == 0)
80100926:	e8 92 5e 00 00       	call   801067bd <setupkvm>
8010092b:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100931:	85 c0                	test   %eax,%eax
80100933:	74 af                	je     801008e4 <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100935:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
8010093b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100942:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100945:	be 00 00 00 00       	mov    $0x0,%esi
8010094a:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100950:	eb 04                	jmp    80100956 <exec+0xcc>
80100952:	46                   	inc    %esi
80100953:	8d 47 20             	lea    0x20(%edi),%eax
80100956:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
8010095d:	39 f2                	cmp    %esi,%edx
8010095f:	0f 8e a5 00 00 00    	jle    80100a0a <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100965:	89 c7                	mov    %eax,%edi
80100967:	6a 20                	push   $0x20
80100969:	50                   	push   %eax
8010096a:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100970:	50                   	push   %eax
80100971:	53                   	push   %ebx
80100972:	e8 ef 0d 00 00       	call   80101766 <readi>
80100977:	83 c4 10             	add    $0x10,%esp
8010097a:	83 f8 20             	cmp    $0x20,%eax
8010097d:	0f 85 d6 00 00 00    	jne    80100a59 <exec+0x1cf>
    if(ph.type != ELF_PROG_LOAD || ph.memsz == 0)
80100983:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
8010098a:	75 c6                	jne    80100952 <exec+0xc8>
8010098c:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100992:	85 c0                	test   %eax,%eax
80100994:	74 bc                	je     80100952 <exec+0xc8>
    if(ph.memsz < ph.filesz)
80100996:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
8010099c:	0f 82 b7 00 00 00    	jb     80100a59 <exec+0x1cf>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801009a2:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801009a8:	0f 82 ab 00 00 00    	jb     80100a59 <exec+0x1cf>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801009ae:	83 ec 04             	sub    $0x4,%esp
801009b1:	50                   	push   %eax
801009b2:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
801009b8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801009be:	e8 a0 5c 00 00       	call   80106663 <allocuvm>
801009c3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009c9:	83 c4 10             	add    $0x10,%esp
801009cc:	85 c0                	test   %eax,%eax
801009ce:	0f 84 85 00 00 00    	je     80100a59 <exec+0x1cf>
    if(ph.vaddr % PGSIZE != 0)
801009d4:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
801009da:	a9 ff 0f 00 00       	test   $0xfff,%eax
801009df:	75 78                	jne    80100a59 <exec+0x1cf>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
801009e1:	83 ec 0c             	sub    $0xc,%esp
801009e4:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
801009ea:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
801009f0:	53                   	push   %ebx
801009f1:	50                   	push   %eax
801009f2:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801009f8:	e8 48 5b 00 00       	call   80106545 <loaduvm>
801009fd:	83 c4 20             	add    $0x20,%esp
80100a00:	85 c0                	test   %eax,%eax
80100a02:	0f 89 4a ff ff ff    	jns    80100952 <exec+0xc8>
80100a08:	eb 4f                	jmp    80100a59 <exec+0x1cf>
  iunlockput(ip);
80100a0a:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100a10:	83 ec 0c             	sub    $0xc,%esp
80100a13:	53                   	push   %ebx
80100a14:	e8 03 0d 00 00       	call   8010171c <iunlockput>
  end_op();
80100a19:	e8 be 1d 00 00       	call   801027dc <end_op>
  sz = PGROUNDUP(sz);
80100a1e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a24:	05 ff 0f 00 00       	add    $0xfff,%eax
80100a29:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a2e:	83 c4 0c             	add    $0xc,%esp
80100a31:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a37:	52                   	push   %edx
80100a38:	50                   	push   %eax
80100a39:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80100a3f:	53                   	push   %ebx
80100a40:	e8 1e 5c 00 00       	call   80106663 <allocuvm>
80100a45:	89 c6                	mov    %eax,%esi
80100a47:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a4d:	83 c4 10             	add    $0x10,%esp
80100a50:	85 c0                	test   %eax,%eax
80100a52:	75 1d                	jne    80100a71 <exec+0x1e7>
  ip = 0;
80100a54:	bb 00 00 00 00       	mov    $0x0,%ebx
    freevm(pgdir, 1);
80100a59:	83 ec 08             	sub    $0x8,%esp
80100a5c:	6a 01                	push   $0x1
80100a5e:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100a64:	e8 de 5c 00 00       	call   80106747 <freevm>
80100a69:	83 c4 10             	add    $0x10,%esp
80100a6c:	e9 73 fe ff ff       	jmp    801008e4 <exec+0x5a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100a71:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100a77:	83 ec 08             	sub    $0x8,%esp
80100a7a:	50                   	push   %eax
80100a7b:	53                   	push   %ebx
80100a7c:	e8 c3 5d 00 00       	call   80106844 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100a81:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100a84:	89 f0                	mov    %esi,%eax
  for(argc = 0; argv[argc]; argc++) {
80100a86:	be 00 00 00 00       	mov    $0x0,%esi
80100a8b:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100a91:	89 c7                	mov    %eax,%edi
80100a93:	eb 08                	jmp    80100a9d <exec+0x213>
    ustack[3+argc] = sp;
80100a95:	89 bc b5 64 ff ff ff 	mov    %edi,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100a9c:	46                   	inc    %esi
80100a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100aa0:	8d 1c b0             	lea    (%eax,%esi,4),%ebx
80100aa3:	8b 03                	mov    (%ebx),%eax
80100aa5:	85 c0                	test   %eax,%eax
80100aa7:	74 43                	je     80100aec <exec+0x262>
    if(argc >= MAXARG)
80100aa9:	83 fe 1f             	cmp    $0x1f,%esi
80100aac:	0f 87 07 01 00 00    	ja     80100bb9 <exec+0x32f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ab2:	83 ec 0c             	sub    $0xc,%esp
80100ab5:	50                   	push   %eax
80100ab6:	e8 07 35 00 00       	call   80103fc2 <strlen>
80100abb:	29 c7                	sub    %eax,%edi
80100abd:	4f                   	dec    %edi
80100abe:	83 e7 fc             	and    $0xfffffffc,%edi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ac1:	83 c4 04             	add    $0x4,%esp
80100ac4:	ff 33                	push   (%ebx)
80100ac6:	e8 f7 34 00 00       	call   80103fc2 <strlen>
80100acb:	40                   	inc    %eax
80100acc:	50                   	push   %eax
80100acd:	ff 33                	push   (%ebx)
80100acf:	57                   	push   %edi
80100ad0:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ad6:	e8 ab 5e 00 00       	call   80106986 <copyout>
80100adb:	83 c4 20             	add    $0x20,%esp
80100ade:	85 c0                	test   %eax,%eax
80100ae0:	79 b3                	jns    80100a95 <exec+0x20b>
  ip = 0;
80100ae2:	bb 00 00 00 00       	mov    $0x0,%ebx
80100ae7:	e9 6d ff ff ff       	jmp    80100a59 <exec+0x1cf>
  ustack[3+argc] = 0;
80100aec:	89 f9                	mov    %edi,%ecx
80100aee:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100af4:	89 c3                	mov    %eax,%ebx
80100af6:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100afd:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b01:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b08:	ff ff ff 
  ustack[1] = argc;
80100b0b:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b11:	8d 14 b5 04 00 00 00 	lea    0x4(,%esi,4),%edx
80100b18:	89 c8                	mov    %ecx,%eax
80100b1a:	29 d0                	sub    %edx,%eax
80100b1c:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b22:	8d 04 b5 10 00 00 00 	lea    0x10(,%esi,4),%eax
80100b29:	29 c1                	sub    %eax,%ecx
80100b2b:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b2d:	50                   	push   %eax
80100b2e:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b34:	50                   	push   %eax
80100b35:	51                   	push   %ecx
80100b36:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b3c:	e8 45 5e 00 00       	call   80106986 <copyout>
80100b41:	83 c4 10             	add    $0x10,%esp
80100b44:	85 c0                	test   %eax,%eax
80100b46:	0f 88 0d ff ff ff    	js     80100a59 <exec+0x1cf>
  for(last=s=path; *s; s++)
80100b4c:	8b 55 08             	mov    0x8(%ebp),%edx
80100b4f:	89 d0                	mov    %edx,%eax
80100b51:	eb 01                	jmp    80100b54 <exec+0x2ca>
80100b53:	40                   	inc    %eax
80100b54:	8a 08                	mov    (%eax),%cl
80100b56:	84 c9                	test   %cl,%cl
80100b58:	74 0a                	je     80100b64 <exec+0x2da>
    if(*s == '/')
80100b5a:	80 f9 2f             	cmp    $0x2f,%cl
80100b5d:	75 f4                	jne    80100b53 <exec+0x2c9>
      last = s+1;
80100b5f:	8d 50 01             	lea    0x1(%eax),%edx
80100b62:	eb ef                	jmp    80100b53 <exec+0x2c9>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100b64:	8d 47 6c             	lea    0x6c(%edi),%eax
80100b67:	83 ec 04             	sub    $0x4,%esp
80100b6a:	6a 10                	push   $0x10
80100b6c:	52                   	push   %edx
80100b6d:	50                   	push   %eax
80100b6e:	e8 17 34 00 00       	call   80103f8a <safestrcpy>
  oldpgdir = curproc->pgdir;
80100b73:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100b76:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b7c:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
80100b7f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b85:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100b87:	8b 47 18             	mov    0x18(%edi),%eax
80100b8a:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100b90:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100b93:	8b 47 18             	mov    0x18(%edi),%eax
80100b96:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100b99:	89 3c 24             	mov    %edi,(%esp)
80100b9c:	e8 e0 57 00 00       	call   80106381 <switchuvm>
  freevm(oldpgdir, 1);
80100ba1:	83 c4 08             	add    $0x8,%esp
80100ba4:	6a 01                	push   $0x1
80100ba6:	53                   	push   %ebx
80100ba7:	e8 9b 5b 00 00       	call   80106747 <freevm>
  return 0;
80100bac:	83 c4 10             	add    $0x10,%esp
80100baf:	b8 00 00 00 00       	mov    $0x0,%eax
80100bb4:	e9 49 fd ff ff       	jmp    80100902 <exec+0x78>
  ip = 0;
80100bb9:	bb 00 00 00 00       	mov    $0x0,%ebx
80100bbe:	e9 96 fe ff ff       	jmp    80100a59 <exec+0x1cf>
  return -1;
80100bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc8:	e9 35 fd ff ff       	jmp    80100902 <exec+0x78>

80100bcd <fileinit>:
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void fileinit(void)
{
80100bcd:	55                   	push   %ebp
80100bce:	89 e5                	mov    %esp,%ebp
80100bd0:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100bd3:	68 7c 6a 10 80       	push   $0x80106a7c
80100bd8:	68 60 ef 10 80       	push   $0x8010ef60
80100bdd:	e8 64 30 00 00       	call   80103c46 <initlock>
}
80100be2:	83 c4 10             	add    $0x10,%esp
80100be5:	c9                   	leave
80100be6:	c3                   	ret

80100be7 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
80100be7:	55                   	push   %ebp
80100be8:	89 e5                	mov    %esp,%ebp
80100bea:	53                   	push   %ebx
80100beb:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100bee:	68 60 ef 10 80       	push   $0x8010ef60
80100bf3:	e8 8e 31 00 00       	call   80103d86 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++)
80100bf8:	83 c4 10             	add    $0x10,%esp
80100bfb:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
80100c00:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100c06:	73 29                	jae    80100c31 <filealloc+0x4a>
  {
    if (f->ref == 0)
80100c08:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c0c:	74 05                	je     80100c13 <filealloc+0x2c>
  for (f = ftable.file; f < ftable.file + NFILE; f++)
80100c0e:	83 c3 18             	add    $0x18,%ebx
80100c11:	eb ed                	jmp    80100c00 <filealloc+0x19>
    {
      f->ref = 1;
80100c13:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c1a:	83 ec 0c             	sub    $0xc,%esp
80100c1d:	68 60 ef 10 80       	push   $0x8010ef60
80100c22:	e8 c4 31 00 00       	call   80103deb <release>
      return f;
80100c27:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100c2a:	89 d8                	mov    %ebx,%eax
80100c2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c2f:	c9                   	leave
80100c30:	c3                   	ret
  release(&ftable.lock);
80100c31:	83 ec 0c             	sub    $0xc,%esp
80100c34:	68 60 ef 10 80       	push   $0x8010ef60
80100c39:	e8 ad 31 00 00       	call   80103deb <release>
  return 0;
80100c3e:	83 c4 10             	add    $0x10,%esp
80100c41:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c46:	eb e2                	jmp    80100c2a <filealloc+0x43>

80100c48 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
80100c48:	55                   	push   %ebp
80100c49:	89 e5                	mov    %esp,%ebp
80100c4b:	53                   	push   %ebx
80100c4c:	83 ec 10             	sub    $0x10,%esp
80100c4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100c52:	68 60 ef 10 80       	push   $0x8010ef60
80100c57:	e8 2a 31 00 00       	call   80103d86 <acquire>
  if (f->ref < 1)
80100c5c:	8b 43 04             	mov    0x4(%ebx),%eax
80100c5f:	83 c4 10             	add    $0x10,%esp
80100c62:	85 c0                	test   %eax,%eax
80100c64:	7e 18                	jle    80100c7e <filedup+0x36>
    panic("filedup");
  f->ref++;
80100c66:	40                   	inc    %eax
80100c67:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100c6a:	83 ec 0c             	sub    $0xc,%esp
80100c6d:	68 60 ef 10 80       	push   $0x8010ef60
80100c72:	e8 74 31 00 00       	call   80103deb <release>
  return f;
}
80100c77:	89 d8                	mov    %ebx,%eax
80100c79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c7c:	c9                   	leave
80100c7d:	c3                   	ret
    panic("filedup");
80100c7e:	83 ec 0c             	sub    $0xc,%esp
80100c81:	68 83 6a 10 80       	push   $0x80106a83
80100c86:	e8 b9 f6 ff ff       	call   80100344 <panic>

80100c8b <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
80100c8b:	55                   	push   %ebp
80100c8c:	89 e5                	mov    %esp,%ebp
80100c8e:	57                   	push   %edi
80100c8f:	56                   	push   %esi
80100c90:	53                   	push   %ebx
80100c91:	83 ec 38             	sub    $0x38,%esp
80100c94:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100c97:	68 60 ef 10 80       	push   $0x8010ef60
80100c9c:	e8 e5 30 00 00       	call   80103d86 <acquire>
  if (f->ref < 1)
80100ca1:	8b 43 04             	mov    0x4(%ebx),%eax
80100ca4:	83 c4 10             	add    $0x10,%esp
80100ca7:	85 c0                	test   %eax,%eax
80100ca9:	7e 58                	jle    80100d03 <fileclose+0x78>
    panic("fileclose");
  if (--f->ref > 0)
80100cab:	48                   	dec    %eax
80100cac:	89 43 04             	mov    %eax,0x4(%ebx)
80100caf:	85 c0                	test   %eax,%eax
80100cb1:	7f 5d                	jg     80100d10 <fileclose+0x85>
  {
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100cb3:	8d 7d d0             	lea    -0x30(%ebp),%edi
80100cb6:	b9 06 00 00 00       	mov    $0x6,%ecx
80100cbb:	89 de                	mov    %ebx,%esi
80100cbd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
80100cbf:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100cc6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100ccc:	83 ec 0c             	sub    $0xc,%esp
80100ccf:	68 60 ef 10 80       	push   $0x8010ef60
80100cd4:	e8 12 31 00 00       	call   80103deb <release>

  if (ff.type == FD_PIPE)
80100cd9:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100cdc:	83 c4 10             	add    $0x10,%esp
80100cdf:	83 f8 01             	cmp    $0x1,%eax
80100ce2:	74 44                	je     80100d28 <fileclose+0x9d>
    pipeclose(ff.pipe, ff.writable);
  else if (ff.type == FD_INODE)
80100ce4:	83 f8 02             	cmp    $0x2,%eax
80100ce7:	75 37                	jne    80100d20 <fileclose+0x95>
  {
    begin_op();
80100ce9:	e8 72 1a 00 00       	call   80102760 <begin_op>
    iput(ff.ip);
80100cee:	83 ec 0c             	sub    $0xc,%esp
80100cf1:	ff 75 e0             	push   -0x20(%ebp)
80100cf4:	e8 85 09 00 00       	call   8010167e <iput>
    end_op();
80100cf9:	e8 de 1a 00 00       	call   801027dc <end_op>
80100cfe:	83 c4 10             	add    $0x10,%esp
80100d01:	eb 1d                	jmp    80100d20 <fileclose+0x95>
    panic("fileclose");
80100d03:	83 ec 0c             	sub    $0xc,%esp
80100d06:	68 8b 6a 10 80       	push   $0x80106a8b
80100d0b:	e8 34 f6 ff ff       	call   80100344 <panic>
    release(&ftable.lock);
80100d10:	83 ec 0c             	sub    $0xc,%esp
80100d13:	68 60 ef 10 80       	push   $0x8010ef60
80100d18:	e8 ce 30 00 00       	call   80103deb <release>
    return;
80100d1d:	83 c4 10             	add    $0x10,%esp
  }
}
80100d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d23:	5b                   	pop    %ebx
80100d24:	5e                   	pop    %esi
80100d25:	5f                   	pop    %edi
80100d26:	5d                   	pop    %ebp
80100d27:	c3                   	ret
    pipeclose(ff.pipe, ff.writable);
80100d28:	83 ec 08             	sub    $0x8,%esp
80100d2b:	0f be 45 d9          	movsbl -0x27(%ebp),%eax
80100d2f:	50                   	push   %eax
80100d30:	ff 75 dc             	push   -0x24(%ebp)
80100d33:	e8 8d 20 00 00       	call   80102dc5 <pipeclose>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	eb e3                	jmp    80100d20 <fileclose+0x95>

80100d3d <filestat>:

// Get metadata about file f.
int filestat(struct file *f, struct stat *st)
{
80100d3d:	55                   	push   %ebp
80100d3e:	89 e5                	mov    %esp,%ebp
80100d40:	53                   	push   %ebx
80100d41:	83 ec 04             	sub    $0x4,%esp
80100d44:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (f->type == FD_INODE)
80100d47:	83 3b 02             	cmpl   $0x2,(%ebx)
80100d4a:	75 31                	jne    80100d7d <filestat+0x40>
  {
    ilock(f->ip);
80100d4c:	83 ec 0c             	sub    $0xc,%esp
80100d4f:	ff 73 10             	push   0x10(%ebx)
80100d52:	e8 22 08 00 00       	call   80101579 <ilock>
    stati(f->ip, st);
80100d57:	83 c4 08             	add    $0x8,%esp
80100d5a:	ff 75 0c             	push   0xc(%ebp)
80100d5d:	ff 73 10             	push   0x10(%ebx)
80100d60:	e8 d7 09 00 00       	call   8010173c <stati>
    iunlock(f->ip);
80100d65:	83 c4 04             	add    $0x4,%esp
80100d68:	ff 73 10             	push   0x10(%ebx)
80100d6b:	e8 c9 08 00 00       	call   80101639 <iunlock>
    return 0;
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100d78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d7b:	c9                   	leave
80100d7c:	c3                   	ret
  return -1;
80100d7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d82:	eb f4                	jmp    80100d78 <filestat+0x3b>

80100d84 <fileread>:

// Read from file f.
int fileread(struct file *f, char *addr, int n)
{
80100d84:	55                   	push   %ebp
80100d85:	89 e5                	mov    %esp,%ebp
80100d87:	56                   	push   %esi
80100d88:	53                   	push   %ebx
80100d89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if (f->readable == 0)
80100d8c:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100d90:	74 70                	je     80100e02 <fileread+0x7e>
    return -1;
  if (f->type == FD_PIPE)
80100d92:	8b 03                	mov    (%ebx),%eax
80100d94:	83 f8 01             	cmp    $0x1,%eax
80100d97:	74 44                	je     80100ddd <fileread+0x59>
    return piperead(f->pipe, addr, n);
  if (f->type == FD_INODE)
80100d99:	83 f8 02             	cmp    $0x2,%eax
80100d9c:	75 57                	jne    80100df5 <fileread+0x71>
  {
    ilock(f->ip);
80100d9e:	83 ec 0c             	sub    $0xc,%esp
80100da1:	ff 73 10             	push   0x10(%ebx)
80100da4:	e8 d0 07 00 00       	call   80101579 <ilock>
    if ((r = readi(f->ip, addr, f->off, n)) > 0)
80100da9:	ff 75 10             	push   0x10(%ebp)
80100dac:	ff 73 14             	push   0x14(%ebx)
80100daf:	ff 75 0c             	push   0xc(%ebp)
80100db2:	ff 73 10             	push   0x10(%ebx)
80100db5:	e8 ac 09 00 00       	call   80101766 <readi>
80100dba:	89 c6                	mov    %eax,%esi
80100dbc:	83 c4 20             	add    $0x20,%esp
80100dbf:	85 c0                	test   %eax,%eax
80100dc1:	7e 03                	jle    80100dc6 <fileread+0x42>
      f->off += r;
80100dc3:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100dc6:	83 ec 0c             	sub    $0xc,%esp
80100dc9:	ff 73 10             	push   0x10(%ebx)
80100dcc:	e8 68 08 00 00       	call   80101639 <iunlock>
    return r;
80100dd1:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100dd4:	89 f0                	mov    %esi,%eax
80100dd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100dd9:	5b                   	pop    %ebx
80100dda:	5e                   	pop    %esi
80100ddb:	5d                   	pop    %ebp
80100ddc:	c3                   	ret
    return piperead(f->pipe, addr, n);
80100ddd:	83 ec 04             	sub    $0x4,%esp
80100de0:	ff 75 10             	push   0x10(%ebp)
80100de3:	ff 75 0c             	push   0xc(%ebp)
80100de6:	ff 73 0c             	push   0xc(%ebx)
80100de9:	e8 28 21 00 00       	call   80102f16 <piperead>
80100dee:	89 c6                	mov    %eax,%esi
80100df0:	83 c4 10             	add    $0x10,%esp
80100df3:	eb df                	jmp    80100dd4 <fileread+0x50>
  panic("fileread");
80100df5:	83 ec 0c             	sub    $0xc,%esp
80100df8:	68 95 6a 10 80       	push   $0x80106a95
80100dfd:	e8 42 f5 ff ff       	call   80100344 <panic>
    return -1;
80100e02:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e07:	eb cb                	jmp    80100dd4 <fileread+0x50>

80100e09 <filewrite>:

// PAGEBREAK!
//  Write to file f.
int filewrite(struct file *f, char *addr, int n)
{
80100e09:	55                   	push   %ebp
80100e0a:	89 e5                	mov    %esp,%ebp
80100e0c:	57                   	push   %edi
80100e0d:	56                   	push   %esi
80100e0e:	53                   	push   %ebx
80100e0f:	83 ec 1c             	sub    $0x1c,%esp
80100e12:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if (f->writable == 0)
80100e15:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100e19:	0f 84 cc 00 00 00    	je     80100eeb <filewrite+0xe2>
    return -1;
  if (f->type == FD_PIPE)
80100e1f:	8b 06                	mov    (%esi),%eax
80100e21:	83 f8 01             	cmp    $0x1,%eax
80100e24:	74 10                	je     80100e36 <filewrite+0x2d>
    return pipewrite(f->pipe, addr, n);
  if (f->type == FD_INODE)
80100e26:	83 f8 02             	cmp    $0x2,%eax
80100e29:	0f 85 af 00 00 00    	jne    80100ede <filewrite+0xd5>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * 512;
    int i = 0;
80100e2f:	bf 00 00 00 00       	mov    $0x0,%edi
80100e34:	eb 67                	jmp    80100e9d <filewrite+0x94>
    return pipewrite(f->pipe, addr, n);
80100e36:	83 ec 04             	sub    $0x4,%esp
80100e39:	ff 75 10             	push   0x10(%ebp)
80100e3c:	ff 75 0c             	push   0xc(%ebp)
80100e3f:	ff 76 0c             	push   0xc(%esi)
80100e42:	e8 0a 20 00 00       	call   80102e51 <pipewrite>
80100e47:	83 c4 10             	add    $0x10,%esp
80100e4a:	e9 82 00 00 00       	jmp    80100ed1 <filewrite+0xc8>
    {
      int n1 = n - i;
      if (n1 > max)
        n1 = max;

      begin_op();
80100e4f:	e8 0c 19 00 00       	call   80102760 <begin_op>
      ilock(f->ip);
80100e54:	83 ec 0c             	sub    $0xc,%esp
80100e57:	ff 76 10             	push   0x10(%esi)
80100e5a:	e8 1a 07 00 00       	call   80101579 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100e5f:	ff 75 e4             	push   -0x1c(%ebp)
80100e62:	ff 76 14             	push   0x14(%esi)
80100e65:	89 f8                	mov    %edi,%eax
80100e67:	03 45 0c             	add    0xc(%ebp),%eax
80100e6a:	50                   	push   %eax
80100e6b:	ff 76 10             	push   0x10(%esi)
80100e6e:	e8 f6 09 00 00       	call   80101869 <writei>
80100e73:	89 c3                	mov    %eax,%ebx
80100e75:	83 c4 20             	add    $0x20,%esp
80100e78:	85 c0                	test   %eax,%eax
80100e7a:	7e 03                	jle    80100e7f <filewrite+0x76>
        f->off += r;
80100e7c:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100e7f:	83 ec 0c             	sub    $0xc,%esp
80100e82:	ff 76 10             	push   0x10(%esi)
80100e85:	e8 af 07 00 00       	call   80101639 <iunlock>
      end_op();
80100e8a:	e8 4d 19 00 00       	call   801027dc <end_op>

      if (r < 0)
80100e8f:	83 c4 10             	add    $0x10,%esp
80100e92:	85 db                	test   %ebx,%ebx
80100e94:	78 31                	js     80100ec7 <filewrite+0xbe>
        break;
      if (r != n1)
80100e96:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100e99:	75 1f                	jne    80100eba <filewrite+0xb1>
        panic("short filewrite");
      i += r;
80100e9b:	01 df                	add    %ebx,%edi
    while (i < n)
80100e9d:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100ea0:	7d 25                	jge    80100ec7 <filewrite+0xbe>
      int n1 = n - i;
80100ea2:	8b 45 10             	mov    0x10(%ebp),%eax
80100ea5:	29 f8                	sub    %edi,%eax
80100ea7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if (n1 > max)
80100eaa:	3d 00 06 00 00       	cmp    $0x600,%eax
80100eaf:	7e 9e                	jle    80100e4f <filewrite+0x46>
        n1 = max;
80100eb1:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100eb8:	eb 95                	jmp    80100e4f <filewrite+0x46>
        panic("short filewrite");
80100eba:	83 ec 0c             	sub    $0xc,%esp
80100ebd:	68 9e 6a 10 80       	push   $0x80106a9e
80100ec2:	e8 7d f4 ff ff       	call   80100344 <panic>
    }
    return i == n ? n : -1;
80100ec7:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100eca:	74 0d                	je     80100ed9 <filewrite+0xd0>
80100ecc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ed4:	5b                   	pop    %ebx
80100ed5:	5e                   	pop    %esi
80100ed6:	5f                   	pop    %edi
80100ed7:	5d                   	pop    %ebp
80100ed8:	c3                   	ret
    return i == n ? n : -1;
80100ed9:	8b 45 10             	mov    0x10(%ebp),%eax
80100edc:	eb f3                	jmp    80100ed1 <filewrite+0xc8>
  panic("filewrite");
80100ede:	83 ec 0c             	sub    $0xc,%esp
80100ee1:	68 a4 6a 10 80       	push   $0x80106aa4
80100ee6:	e8 59 f4 ff ff       	call   80100344 <panic>
    return -1;
80100eeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ef0:	eb df                	jmp    80100ed1 <filewrite+0xc8>

80100ef2 <fd_dup2>:

int fd_dup2(int old, int new)
{
80100ef2:	55                   	push   %ebp
80100ef3:	89 e5                	mov    %esp,%ebp
80100ef5:	57                   	push   %edi
80100ef6:	56                   	push   %esi
80100ef7:	53                   	push   %ebx
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct file *f;
  struct proc *curproc = myproc();
80100efe:	e8 86 23 00 00       	call   80103289 <myproc>

  // 1. Validaciones: ¿Existe el viejo? ¿Es válido el nuevo?
  if (old < 0 || old >= NOFILE || (f = curproc->ofile[old]) == 0)
80100f03:	83 7d 08 0f          	cmpl   $0xf,0x8(%ebp)
80100f07:	77 44                	ja     80100f4d <fd_dup2+0x5b>
80100f09:	89 c3                	mov    %eax,%ebx
80100f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80100f0e:	8b 7c 83 28          	mov    0x28(%ebx,%eax,4),%edi
80100f12:	85 ff                	test   %edi,%edi
80100f14:	74 3e                	je     80100f54 <fd_dup2+0x62>
    return -1;
  if (new < 0 || new >= NOFILE)
80100f16:	83 fe 0f             	cmp    $0xf,%esi
80100f19:	77 40                	ja     80100f5b <fd_dup2+0x69>
    return -1;

  // 2. Si son el mismo, no hacemos nada (según POSIX)
  if (old == new)
80100f1b:	39 f0                	cmp    %esi,%eax
80100f1d:	74 24                	je     80100f43 <fd_dup2+0x51>
    return new;

  // 3. Si el nuevo ya estaba abierto, lo cerramos primero de forma silenciosa
  if (curproc->ofile[new])
80100f1f:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80100f23:	85 c0                	test   %eax,%eax
80100f25:	74 0c                	je     80100f33 <fd_dup2+0x41>
    fileclose(curproc->ofile[new]);
80100f27:	83 ec 0c             	sub    $0xc,%esp
80100f2a:	50                   	push   %eax
80100f2b:	e8 5b fd ff ff       	call   80100c8b <fileclose>
80100f30:	83 c4 10             	add    $0x10,%esp

  // 4. Hacemos el duplicado
  curproc->ofile[new] = f;
80100f33:	89 7c b3 28          	mov    %edi,0x28(%ebx,%esi,4)
  filedup(f);
80100f37:	83 ec 0c             	sub    $0xc,%esp
80100f3a:	57                   	push   %edi
80100f3b:	e8 08 fd ff ff       	call   80100c48 <filedup>

  return new;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	89 f0                	mov    %esi,%eax
80100f45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f48:	5b                   	pop    %ebx
80100f49:	5e                   	pop    %esi
80100f4a:	5f                   	pop    %edi
80100f4b:	5d                   	pop    %ebp
80100f4c:	c3                   	ret
    return -1;
80100f4d:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100f52:	eb ef                	jmp    80100f43 <fd_dup2+0x51>
80100f54:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100f59:	eb e8                	jmp    80100f43 <fd_dup2+0x51>
    return -1;
80100f5b:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100f60:	eb e1                	jmp    80100f43 <fd_dup2+0x51>

80100f62 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100f62:	55                   	push   %ebp
80100f63:	89 e5                	mov    %esp,%ebp
80100f65:	57                   	push   %edi
80100f66:	56                   	push   %esi
80100f67:	53                   	push   %ebx
80100f68:	83 ec 0c             	sub    $0xc,%esp
80100f6b:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100f6d:	eb 01                	jmp    80100f70 <skipelem+0xe>
    path++;
80100f6f:	40                   	inc    %eax
  while(*path == '/')
80100f70:	8a 10                	mov    (%eax),%dl
80100f72:	80 fa 2f             	cmp    $0x2f,%dl
80100f75:	74 f8                	je     80100f6f <skipelem+0xd>
  if(*path == 0)
80100f77:	84 d2                	test   %dl,%dl
80100f79:	74 4e                	je     80100fc9 <skipelem+0x67>
80100f7b:	89 c3                	mov    %eax,%ebx
80100f7d:	eb 01                	jmp    80100f80 <skipelem+0x1e>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80100f7f:	43                   	inc    %ebx
  while(*path != '/' && *path != 0)
80100f80:	8a 13                	mov    (%ebx),%dl
80100f82:	80 fa 2f             	cmp    $0x2f,%dl
80100f85:	74 04                	je     80100f8b <skipelem+0x29>
80100f87:	84 d2                	test   %dl,%dl
80100f89:	75 f4                	jne    80100f7f <skipelem+0x1d>
  len = path - s;
80100f8b:	89 df                	mov    %ebx,%edi
80100f8d:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100f8f:	83 ff 0d             	cmp    $0xd,%edi
80100f92:	7e 11                	jle    80100fa5 <skipelem+0x43>
    memmove(name, s, DIRSIZ);
80100f94:	83 ec 04             	sub    $0x4,%esp
80100f97:	6a 0e                	push   $0xe
80100f99:	50                   	push   %eax
80100f9a:	56                   	push   %esi
80100f9b:	e8 08 2f 00 00       	call   80103ea8 <memmove>
80100fa0:	83 c4 10             	add    $0x10,%esp
80100fa3:	eb 15                	jmp    80100fba <skipelem+0x58>
  else {
    memmove(name, s, len);
80100fa5:	83 ec 04             	sub    $0x4,%esp
80100fa8:	57                   	push   %edi
80100fa9:	50                   	push   %eax
80100faa:	56                   	push   %esi
80100fab:	e8 f8 2e 00 00       	call   80103ea8 <memmove>
    name[len] = 0;
80100fb0:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100fb4:	83 c4 10             	add    $0x10,%esp
80100fb7:	eb 01                	jmp    80100fba <skipelem+0x58>
  }
  while(*path == '/')
    path++;
80100fb9:	43                   	inc    %ebx
  while(*path == '/')
80100fba:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100fbd:	74 fa                	je     80100fb9 <skipelem+0x57>
  return path;
}
80100fbf:	89 d8                	mov    %ebx,%eax
80100fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc4:	5b                   	pop    %ebx
80100fc5:	5e                   	pop    %esi
80100fc6:	5f                   	pop    %edi
80100fc7:	5d                   	pop    %ebp
80100fc8:	c3                   	ret
    return 0;
80100fc9:	bb 00 00 00 00       	mov    $0x0,%ebx
80100fce:	eb ef                	jmp    80100fbf <skipelem+0x5d>

80100fd0 <bzero>:
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80100fd7:	52                   	push   %edx
80100fd8:	50                   	push   %eax
80100fd9:	e8 8c f1 ff ff       	call   8010016a <bread>
80100fde:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80100fe0:	8d 40 5c             	lea    0x5c(%eax),%eax
80100fe3:	83 c4 0c             	add    $0xc,%esp
80100fe6:	68 00 02 00 00       	push   $0x200
80100feb:	6a 00                	push   $0x0
80100fed:	50                   	push   %eax
80100fee:	e8 3f 2e 00 00       	call   80103e32 <memset>
  log_write(bp);
80100ff3:	89 1c 24             	mov    %ebx,(%esp)
80100ff6:	e8 8e 18 00 00       	call   80102889 <log_write>
  brelse(bp);
80100ffb:	89 1c 24             	mov    %ebx,(%esp)
80100ffe:	e8 d4 f1 ff ff       	call   801001d7 <brelse>
}
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101009:	c9                   	leave
8010100a:	c3                   	ret

8010100b <balloc>:
{
8010100b:	55                   	push   %ebp
8010100c:	89 e5                	mov    %esp,%ebp
8010100e:	57                   	push   %edi
8010100f:	56                   	push   %esi
80101010:	53                   	push   %ebx
80101011:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101014:	be 00 00 00 00       	mov    $0x0,%esi
80101019:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010101c:	eb 5b                	jmp    80101079 <balloc+0x6e>
    bp = bread(dev, BBLOCK(b, sb));
8010101e:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
80101024:	eb 61                	jmp    80101087 <balloc+0x7c>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101026:	c1 fa 03             	sar    $0x3,%edx
80101029:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010102c:	8a 4c 17 5c          	mov    0x5c(%edi,%edx,1),%cl
80101030:	0f b6 f9             	movzbl %cl,%edi
80101033:	85 7d e4             	test   %edi,-0x1c(%ebp)
80101036:	74 7e                	je     801010b6 <balloc+0xab>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101038:	40                   	inc    %eax
80101039:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010103e:	7f 25                	jg     80101065 <balloc+0x5a>
80101040:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80101043:	3b 1d b4 15 11 80    	cmp    0x801115b4,%ebx
80101049:	73 1a                	jae    80101065 <balloc+0x5a>
      m = 1 << (bi % 8);
8010104b:	89 c1                	mov    %eax,%ecx
8010104d:	83 e1 07             	and    $0x7,%ecx
80101050:	ba 01 00 00 00       	mov    $0x1,%edx
80101055:	d3 e2                	shl    %cl,%edx
80101057:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010105a:	89 c2                	mov    %eax,%edx
8010105c:	85 c0                	test   %eax,%eax
8010105e:	79 c6                	jns    80101026 <balloc+0x1b>
80101060:	8d 50 07             	lea    0x7(%eax),%edx
80101063:	eb c1                	jmp    80101026 <balloc+0x1b>
    brelse(bp);
80101065:	83 ec 0c             	sub    $0xc,%esp
80101068:	ff 75 e0             	push   -0x20(%ebp)
8010106b:	e8 67 f1 ff ff       	call   801001d7 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101070:	81 c6 00 10 00 00    	add    $0x1000,%esi
80101076:	83 c4 10             	add    $0x10,%esp
80101079:	3b 35 b4 15 11 80    	cmp    0x801115b4,%esi
8010107f:	73 28                	jae    801010a9 <balloc+0x9e>
    bp = bread(dev, BBLOCK(b, sb));
80101081:	89 f0                	mov    %esi,%eax
80101083:	85 f6                	test   %esi,%esi
80101085:	78 97                	js     8010101e <balloc+0x13>
80101087:	c1 f8 0c             	sar    $0xc,%eax
8010108a:	83 ec 08             	sub    $0x8,%esp
8010108d:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101093:	50                   	push   %eax
80101094:	ff 75 dc             	push   -0x24(%ebp)
80101097:	e8 ce f0 ff ff       	call   8010016a <bread>
8010109c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010109f:	83 c4 10             	add    $0x10,%esp
801010a2:	b8 00 00 00 00       	mov    $0x0,%eax
801010a7:	eb 90                	jmp    80101039 <balloc+0x2e>
  panic("balloc: out of blocks");
801010a9:	83 ec 0c             	sub    $0xc,%esp
801010ac:	68 ae 6a 10 80       	push   $0x80106aae
801010b1:	e8 8e f2 ff ff       	call   80100344 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
801010b6:	8b 7d dc             	mov    -0x24(%ebp),%edi
801010b9:	0b 4d e4             	or     -0x1c(%ebp),%ecx
801010bc:	8b 75 e0             	mov    -0x20(%ebp),%esi
801010bf:	88 4c 16 5c          	mov    %cl,0x5c(%esi,%edx,1)
        log_write(bp);
801010c3:	83 ec 0c             	sub    $0xc,%esp
801010c6:	56                   	push   %esi
801010c7:	e8 bd 17 00 00       	call   80102889 <log_write>
        brelse(bp);
801010cc:	89 34 24             	mov    %esi,(%esp)
801010cf:	e8 03 f1 ff ff       	call   801001d7 <brelse>
        bzero(dev, b + bi);
801010d4:	89 da                	mov    %ebx,%edx
801010d6:	89 f8                	mov    %edi,%eax
801010d8:	e8 f3 fe ff ff       	call   80100fd0 <bzero>
}
801010dd:	89 d8                	mov    %ebx,%eax
801010df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e2:	5b                   	pop    %ebx
801010e3:	5e                   	pop    %esi
801010e4:	5f                   	pop    %edi
801010e5:	5d                   	pop    %ebp
801010e6:	c3                   	ret

801010e7 <bmap>:
{
801010e7:	55                   	push   %ebp
801010e8:	89 e5                	mov    %esp,%ebp
801010ea:	57                   	push   %edi
801010eb:	56                   	push   %esi
801010ec:	53                   	push   %ebx
801010ed:	83 ec 1c             	sub    $0x1c,%esp
801010f0:	89 c3                	mov    %eax,%ebx
801010f2:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
801010f4:	83 fa 0b             	cmp    $0xb,%edx
801010f7:	76 45                	jbe    8010113e <bmap+0x57>
  bn -= NDIRECT;
801010f9:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
801010fc:	83 fe 7f             	cmp    $0x7f,%esi
801010ff:	77 7f                	ja     80101180 <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101101:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101107:	85 c0                	test   %eax,%eax
80101109:	74 4a                	je     80101155 <bmap+0x6e>
    bp = bread(ip->dev, addr);
8010110b:	83 ec 08             	sub    $0x8,%esp
8010110e:	50                   	push   %eax
8010110f:	ff 33                	push   (%ebx)
80101111:	e8 54 f0 ff ff       	call   8010016a <bread>
80101116:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101118:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
8010111c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010111f:	8b 30                	mov    (%eax),%esi
80101121:	83 c4 10             	add    $0x10,%esp
80101124:	85 f6                	test   %esi,%esi
80101126:	74 3c                	je     80101164 <bmap+0x7d>
    brelse(bp);
80101128:	83 ec 0c             	sub    $0xc,%esp
8010112b:	57                   	push   %edi
8010112c:	e8 a6 f0 ff ff       	call   801001d7 <brelse>
    return addr;
80101131:	83 c4 10             	add    $0x10,%esp
}
80101134:	89 f0                	mov    %esi,%eax
80101136:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101139:	5b                   	pop    %ebx
8010113a:	5e                   	pop    %esi
8010113b:	5f                   	pop    %edi
8010113c:	5d                   	pop    %ebp
8010113d:	c3                   	ret
    if((addr = ip->addrs[bn]) == 0)
8010113e:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
80101142:	85 f6                	test   %esi,%esi
80101144:	75 ee                	jne    80101134 <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101146:	8b 00                	mov    (%eax),%eax
80101148:	e8 be fe ff ff       	call   8010100b <balloc>
8010114d:	89 c6                	mov    %eax,%esi
8010114f:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
80101153:	eb df                	jmp    80101134 <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101155:	8b 03                	mov    (%ebx),%eax
80101157:	e8 af fe ff ff       	call   8010100b <balloc>
8010115c:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101162:	eb a7                	jmp    8010110b <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
80101164:	8b 03                	mov    (%ebx),%eax
80101166:	e8 a0 fe ff ff       	call   8010100b <balloc>
8010116b:	89 c6                	mov    %eax,%esi
8010116d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101170:	89 30                	mov    %esi,(%eax)
      log_write(bp);
80101172:	83 ec 0c             	sub    $0xc,%esp
80101175:	57                   	push   %edi
80101176:	e8 0e 17 00 00       	call   80102889 <log_write>
8010117b:	83 c4 10             	add    $0x10,%esp
8010117e:	eb a8                	jmp    80101128 <bmap+0x41>
  panic("bmap: out of range");
80101180:	83 ec 0c             	sub    $0xc,%esp
80101183:	68 c4 6a 10 80       	push   $0x80106ac4
80101188:	e8 b7 f1 ff ff       	call   80100344 <panic>

8010118d <iget>:
{
8010118d:	55                   	push   %ebp
8010118e:	89 e5                	mov    %esp,%ebp
80101190:	57                   	push   %edi
80101191:	56                   	push   %esi
80101192:	53                   	push   %ebx
80101193:	83 ec 28             	sub    $0x28,%esp
80101196:	89 c7                	mov    %eax,%edi
80101198:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010119b:	68 60 f9 10 80       	push   $0x8010f960
801011a0:	e8 e1 2b 00 00       	call   80103d86 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011a5:	83 c4 10             	add    $0x10,%esp
  empty = 0;
801011a8:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011ad:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
801011b2:	eb 0a                	jmp    801011be <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011b4:	85 f6                	test   %esi,%esi
801011b6:	74 39                	je     801011f1 <iget+0x64>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011b8:	81 c3 90 00 00 00    	add    $0x90,%ebx
801011be:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801011c4:	73 33                	jae    801011f9 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801011c6:	8b 43 08             	mov    0x8(%ebx),%eax
801011c9:	85 c0                	test   %eax,%eax
801011cb:	7e e7                	jle    801011b4 <iget+0x27>
801011cd:	39 3b                	cmp    %edi,(%ebx)
801011cf:	75 e3                	jne    801011b4 <iget+0x27>
801011d1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801011d4:	39 4b 04             	cmp    %ecx,0x4(%ebx)
801011d7:	75 db                	jne    801011b4 <iget+0x27>
      ip->ref++;
801011d9:	40                   	inc    %eax
801011da:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801011dd:	83 ec 0c             	sub    $0xc,%esp
801011e0:	68 60 f9 10 80       	push   $0x8010f960
801011e5:	e8 01 2c 00 00       	call   80103deb <release>
      return ip;
801011ea:	83 c4 10             	add    $0x10,%esp
801011ed:	89 de                	mov    %ebx,%esi
801011ef:	eb 32                	jmp    80101223 <iget+0x96>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011f1:	85 c0                	test   %eax,%eax
801011f3:	75 c3                	jne    801011b8 <iget+0x2b>
      empty = ip;
801011f5:	89 de                	mov    %ebx,%esi
801011f7:	eb bf                	jmp    801011b8 <iget+0x2b>
  if(empty == 0)
801011f9:	85 f6                	test   %esi,%esi
801011fb:	74 30                	je     8010122d <iget+0xa0>
  ip->dev = dev;
801011fd:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801011ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101202:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
80101205:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010120c:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101213:	83 ec 0c             	sub    $0xc,%esp
80101216:	68 60 f9 10 80       	push   $0x8010f960
8010121b:	e8 cb 2b 00 00       	call   80103deb <release>
  return ip;
80101220:	83 c4 10             	add    $0x10,%esp
}
80101223:	89 f0                	mov    %esi,%eax
80101225:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101228:	5b                   	pop    %ebx
80101229:	5e                   	pop    %esi
8010122a:	5f                   	pop    %edi
8010122b:	5d                   	pop    %ebp
8010122c:	c3                   	ret
    panic("iget: no inodes");
8010122d:	83 ec 0c             	sub    $0xc,%esp
80101230:	68 d7 6a 10 80       	push   $0x80106ad7
80101235:	e8 0a f1 ff ff       	call   80100344 <panic>

8010123a <readsb>:
{
8010123a:	55                   	push   %ebp
8010123b:	89 e5                	mov    %esp,%ebp
8010123d:	53                   	push   %ebx
8010123e:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
80101241:	6a 01                	push   $0x1
80101243:	ff 75 08             	push   0x8(%ebp)
80101246:	e8 1f ef ff ff       	call   8010016a <bread>
8010124b:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010124d:	8d 40 5c             	lea    0x5c(%eax),%eax
80101250:	83 c4 0c             	add    $0xc,%esp
80101253:	6a 1c                	push   $0x1c
80101255:	50                   	push   %eax
80101256:	ff 75 0c             	push   0xc(%ebp)
80101259:	e8 4a 2c 00 00       	call   80103ea8 <memmove>
  brelse(bp);
8010125e:	89 1c 24             	mov    %ebx,(%esp)
80101261:	e8 71 ef ff ff       	call   801001d7 <brelse>
}
80101266:	83 c4 10             	add    $0x10,%esp
80101269:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010126c:	c9                   	leave
8010126d:	c3                   	ret

8010126e <bfree>:
{
8010126e:	55                   	push   %ebp
8010126f:	89 e5                	mov    %esp,%ebp
80101271:	56                   	push   %esi
80101272:	53                   	push   %ebx
80101273:	89 c3                	mov    %eax,%ebx
80101275:	89 d6                	mov    %edx,%esi
  readsb(dev, &sb);
80101277:	83 ec 08             	sub    $0x8,%esp
8010127a:	68 b4 15 11 80       	push   $0x801115b4
8010127f:	50                   	push   %eax
80101280:	e8 b5 ff ff ff       	call   8010123a <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101285:	89 f0                	mov    %esi,%eax
80101287:	c1 e8 0c             	shr    $0xc,%eax
8010128a:	83 c4 08             	add    $0x8,%esp
8010128d:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101293:	50                   	push   %eax
80101294:	53                   	push   %ebx
80101295:	e8 d0 ee ff ff       	call   8010016a <bread>
8010129a:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
8010129c:	89 f2                	mov    %esi,%edx
8010129e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  m = 1 << (bi % 8);
801012a4:	89 f1                	mov    %esi,%ecx
801012a6:	83 e1 07             	and    $0x7,%ecx
801012a9:	b8 01 00 00 00       	mov    $0x1,%eax
801012ae:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801012b0:	83 c4 10             	add    $0x10,%esp
801012b3:	c1 fa 03             	sar    $0x3,%edx
801012b6:	8a 4c 13 5c          	mov    0x5c(%ebx,%edx,1),%cl
801012ba:	0f b6 f1             	movzbl %cl,%esi
801012bd:	85 c6                	test   %eax,%esi
801012bf:	74 23                	je     801012e4 <bfree+0x76>
  bp->data[bi/8] &= ~m;
801012c1:	f7 d0                	not    %eax
801012c3:	21 c8                	and    %ecx,%eax
801012c5:	88 44 13 5c          	mov    %al,0x5c(%ebx,%edx,1)
  log_write(bp);
801012c9:	83 ec 0c             	sub    $0xc,%esp
801012cc:	53                   	push   %ebx
801012cd:	e8 b7 15 00 00       	call   80102889 <log_write>
  brelse(bp);
801012d2:	89 1c 24             	mov    %ebx,(%esp)
801012d5:	e8 fd ee ff ff       	call   801001d7 <brelse>
}
801012da:	83 c4 10             	add    $0x10,%esp
801012dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801012e0:	5b                   	pop    %ebx
801012e1:	5e                   	pop    %esi
801012e2:	5d                   	pop    %ebp
801012e3:	c3                   	ret
    panic("freeing free block");
801012e4:	83 ec 0c             	sub    $0xc,%esp
801012e7:	68 e7 6a 10 80       	push   $0x80106ae7
801012ec:	e8 53 f0 ff ff       	call   80100344 <panic>

801012f1 <iinit>:
{
801012f1:	55                   	push   %ebp
801012f2:	89 e5                	mov    %esp,%ebp
801012f4:	53                   	push   %ebx
801012f5:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801012f8:	68 fa 6a 10 80       	push   $0x80106afa
801012fd:	68 60 f9 10 80       	push   $0x8010f960
80101302:	e8 3f 29 00 00       	call   80103c46 <initlock>
  for(i = 0; i < NINODE; i++) {
80101307:	83 c4 10             	add    $0x10,%esp
8010130a:	bb 00 00 00 00       	mov    $0x0,%ebx
8010130f:	eb 1f                	jmp    80101330 <iinit+0x3f>
    initsleeplock(&icache.inode[i].lock, "inode");
80101311:	83 ec 08             	sub    $0x8,%esp
80101314:	68 01 6b 10 80       	push   $0x80106b01
80101319:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
8010131c:	89 d0                	mov    %edx,%eax
8010131e:	c1 e0 04             	shl    $0x4,%eax
80101321:	05 a0 f9 10 80       	add    $0x8010f9a0,%eax
80101326:	50                   	push   %eax
80101327:	e8 0f 28 00 00       	call   80103b3b <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010132c:	43                   	inc    %ebx
8010132d:	83 c4 10             	add    $0x10,%esp
80101330:	83 fb 31             	cmp    $0x31,%ebx
80101333:	7e dc                	jle    80101311 <iinit+0x20>
  readsb(dev, &sb);
80101335:	83 ec 08             	sub    $0x8,%esp
80101338:	68 b4 15 11 80       	push   $0x801115b4
8010133d:	ff 75 08             	push   0x8(%ebp)
80101340:	e8 f5 fe ff ff       	call   8010123a <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101345:	ff 35 cc 15 11 80    	push   0x801115cc
8010134b:	ff 35 c8 15 11 80    	push   0x801115c8
80101351:	ff 35 c4 15 11 80    	push   0x801115c4
80101357:	ff 35 c0 15 11 80    	push   0x801115c0
8010135d:	ff 35 bc 15 11 80    	push   0x801115bc
80101363:	ff 35 b8 15 11 80    	push   0x801115b8
80101369:	ff 35 b4 15 11 80    	push   0x801115b4
8010136f:	68 18 6f 10 80       	push   $0x80106f18
80101374:	e8 66 f2 ff ff       	call   801005df <cprintf>
}
80101379:	83 c4 30             	add    $0x30,%esp
8010137c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010137f:	c9                   	leave
80101380:	c3                   	ret

80101381 <ialloc>:
{
80101381:	55                   	push   %ebp
80101382:	89 e5                	mov    %esp,%ebp
80101384:	57                   	push   %edi
80101385:	56                   	push   %esi
80101386:	53                   	push   %ebx
80101387:	83 ec 1c             	sub    $0x1c,%esp
8010138a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010138d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101390:	bb 01 00 00 00       	mov    $0x1,%ebx
80101395:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101398:	3b 1d bc 15 11 80    	cmp    0x801115bc,%ebx
8010139e:	73 3d                	jae    801013dd <ialloc+0x5c>
    bp = bread(dev, IBLOCK(inum, sb));
801013a0:	89 d8                	mov    %ebx,%eax
801013a2:	c1 e8 03             	shr    $0x3,%eax
801013a5:	83 ec 08             	sub    $0x8,%esp
801013a8:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801013ae:	50                   	push   %eax
801013af:	ff 75 08             	push   0x8(%ebp)
801013b2:	e8 b3 ed ff ff       	call   8010016a <bread>
801013b7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013b9:	89 d8                	mov    %ebx,%eax
801013bb:	83 e0 07             	and    $0x7,%eax
801013be:	c1 e0 06             	shl    $0x6,%eax
801013c1:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
801013c5:	83 c4 10             	add    $0x10,%esp
801013c8:	66 83 3f 00          	cmpw   $0x0,(%edi)
801013cc:	74 1c                	je     801013ea <ialloc+0x69>
    brelse(bp);
801013ce:	83 ec 0c             	sub    $0xc,%esp
801013d1:	56                   	push   %esi
801013d2:	e8 00 ee ff ff       	call   801001d7 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801013d7:	43                   	inc    %ebx
801013d8:	83 c4 10             	add    $0x10,%esp
801013db:	eb b8                	jmp    80101395 <ialloc+0x14>
  panic("ialloc: no inodes");
801013dd:	83 ec 0c             	sub    $0xc,%esp
801013e0:	68 07 6b 10 80       	push   $0x80106b07
801013e5:	e8 5a ef ff ff       	call   80100344 <panic>
      memset(dip, 0, sizeof(*dip));
801013ea:	83 ec 04             	sub    $0x4,%esp
801013ed:	6a 40                	push   $0x40
801013ef:	6a 00                	push   $0x0
801013f1:	57                   	push   %edi
801013f2:	e8 3b 2a 00 00       	call   80103e32 <memset>
      dip->type = type;
801013f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013fa:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
801013fd:	89 34 24             	mov    %esi,(%esp)
80101400:	e8 84 14 00 00       	call   80102889 <log_write>
      brelse(bp);
80101405:	89 34 24             	mov    %esi,(%esp)
80101408:	e8 ca ed ff ff       	call   801001d7 <brelse>
      return iget(dev, inum);
8010140d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101410:	8b 45 08             	mov    0x8(%ebp),%eax
80101413:	e8 75 fd ff ff       	call   8010118d <iget>
}
80101418:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010141b:	5b                   	pop    %ebx
8010141c:	5e                   	pop    %esi
8010141d:	5f                   	pop    %edi
8010141e:	5d                   	pop    %ebp
8010141f:	c3                   	ret

80101420 <iupdate>:
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
80101424:	53                   	push   %ebx
80101425:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101428:	8b 43 04             	mov    0x4(%ebx),%eax
8010142b:	c1 e8 03             	shr    $0x3,%eax
8010142e:	83 ec 08             	sub    $0x8,%esp
80101431:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101437:	50                   	push   %eax
80101438:	ff 33                	push   (%ebx)
8010143a:	e8 2b ed ff ff       	call   8010016a <bread>
8010143f:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101441:	8b 43 04             	mov    0x4(%ebx),%eax
80101444:	83 e0 07             	and    $0x7,%eax
80101447:	c1 e0 06             	shl    $0x6,%eax
8010144a:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010144e:	8b 53 50             	mov    0x50(%ebx),%edx
80101451:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101454:	66 8b 53 52          	mov    0x52(%ebx),%dx
80101458:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010145c:	8b 53 54             	mov    0x54(%ebx),%edx
8010145f:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101463:	66 8b 53 56          	mov    0x56(%ebx),%dx
80101467:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010146b:	8b 53 58             	mov    0x58(%ebx),%edx
8010146e:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101471:	83 c3 5c             	add    $0x5c,%ebx
80101474:	83 c0 0c             	add    $0xc,%eax
80101477:	83 c4 0c             	add    $0xc,%esp
8010147a:	6a 34                	push   $0x34
8010147c:	53                   	push   %ebx
8010147d:	50                   	push   %eax
8010147e:	e8 25 2a 00 00       	call   80103ea8 <memmove>
  log_write(bp);
80101483:	89 34 24             	mov    %esi,(%esp)
80101486:	e8 fe 13 00 00       	call   80102889 <log_write>
  brelse(bp);
8010148b:	89 34 24             	mov    %esi,(%esp)
8010148e:	e8 44 ed ff ff       	call   801001d7 <brelse>
}
80101493:	83 c4 10             	add    $0x10,%esp
80101496:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101499:	5b                   	pop    %ebx
8010149a:	5e                   	pop    %esi
8010149b:	5d                   	pop    %ebp
8010149c:	c3                   	ret

8010149d <itrunc>:
{
8010149d:	55                   	push   %ebp
8010149e:	89 e5                	mov    %esp,%ebp
801014a0:	57                   	push   %edi
801014a1:	56                   	push   %esi
801014a2:	53                   	push   %ebx
801014a3:	83 ec 1c             	sub    $0x1c,%esp
801014a6:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
801014a8:	bb 00 00 00 00       	mov    $0x0,%ebx
801014ad:	eb 01                	jmp    801014b0 <itrunc+0x13>
801014af:	43                   	inc    %ebx
801014b0:	83 fb 0b             	cmp    $0xb,%ebx
801014b3:	7f 19                	jg     801014ce <itrunc+0x31>
    if(ip->addrs[i]){
801014b5:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
801014b9:	85 d2                	test   %edx,%edx
801014bb:	74 f2                	je     801014af <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
801014bd:	8b 06                	mov    (%esi),%eax
801014bf:	e8 aa fd ff ff       	call   8010126e <bfree>
      ip->addrs[i] = 0;
801014c4:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
801014cb:	00 
801014cc:	eb e1                	jmp    801014af <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
801014ce:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801014d4:	85 c0                	test   %eax,%eax
801014d6:	75 1b                	jne    801014f3 <itrunc+0x56>
  ip->size = 0;
801014d8:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801014df:	83 ec 0c             	sub    $0xc,%esp
801014e2:	56                   	push   %esi
801014e3:	e8 38 ff ff ff       	call   80101420 <iupdate>
}
801014e8:	83 c4 10             	add    $0x10,%esp
801014eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014ee:	5b                   	pop    %ebx
801014ef:	5e                   	pop    %esi
801014f0:	5f                   	pop    %edi
801014f1:	5d                   	pop    %ebp
801014f2:	c3                   	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801014f3:	83 ec 08             	sub    $0x8,%esp
801014f6:	50                   	push   %eax
801014f7:	ff 36                	push   (%esi)
801014f9:	e8 6c ec ff ff       	call   8010016a <bread>
801014fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101501:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
80101504:	83 c4 10             	add    $0x10,%esp
80101507:	bb 00 00 00 00       	mov    $0x0,%ebx
8010150c:	eb 01                	jmp    8010150f <itrunc+0x72>
8010150e:	43                   	inc    %ebx
8010150f:	83 fb 7f             	cmp    $0x7f,%ebx
80101512:	77 10                	ja     80101524 <itrunc+0x87>
      if(a[j])
80101514:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
80101517:	85 d2                	test   %edx,%edx
80101519:	74 f3                	je     8010150e <itrunc+0x71>
        bfree(ip->dev, a[j]);
8010151b:	8b 06                	mov    (%esi),%eax
8010151d:	e8 4c fd ff ff       	call   8010126e <bfree>
80101522:	eb ea                	jmp    8010150e <itrunc+0x71>
    brelse(bp);
80101524:	83 ec 0c             	sub    $0xc,%esp
80101527:	ff 75 e4             	push   -0x1c(%ebp)
8010152a:	e8 a8 ec ff ff       	call   801001d7 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010152f:	8b 06                	mov    (%esi),%eax
80101531:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101537:	e8 32 fd ff ff       	call   8010126e <bfree>
    ip->addrs[NDIRECT] = 0;
8010153c:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101543:	00 00 00 
80101546:	83 c4 10             	add    $0x10,%esp
80101549:	eb 8d                	jmp    801014d8 <itrunc+0x3b>

8010154b <idup>:
{
8010154b:	55                   	push   %ebp
8010154c:	89 e5                	mov    %esp,%ebp
8010154e:	53                   	push   %ebx
8010154f:	83 ec 10             	sub    $0x10,%esp
80101552:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101555:	68 60 f9 10 80       	push   $0x8010f960
8010155a:	e8 27 28 00 00       	call   80103d86 <acquire>
  ip->ref++;
8010155f:	8b 43 08             	mov    0x8(%ebx),%eax
80101562:	40                   	inc    %eax
80101563:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
80101566:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010156d:	e8 79 28 00 00       	call   80103deb <release>
}
80101572:	89 d8                	mov    %ebx,%eax
80101574:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101577:	c9                   	leave
80101578:	c3                   	ret

80101579 <ilock>:
{
80101579:	55                   	push   %ebp
8010157a:	89 e5                	mov    %esp,%ebp
8010157c:	56                   	push   %esi
8010157d:	53                   	push   %ebx
8010157e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101581:	85 db                	test   %ebx,%ebx
80101583:	74 22                	je     801015a7 <ilock+0x2e>
80101585:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101589:	7e 1c                	jle    801015a7 <ilock+0x2e>
  acquiresleep(&ip->lock);
8010158b:	83 ec 0c             	sub    $0xc,%esp
8010158e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101591:	50                   	push   %eax
80101592:	e8 d7 25 00 00       	call   80103b6e <acquiresleep>
  if(ip->valid == 0){
80101597:	83 c4 10             	add    $0x10,%esp
8010159a:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
8010159e:	74 14                	je     801015b4 <ilock+0x3b>
}
801015a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015a3:	5b                   	pop    %ebx
801015a4:	5e                   	pop    %esi
801015a5:	5d                   	pop    %ebp
801015a6:	c3                   	ret
    panic("ilock");
801015a7:	83 ec 0c             	sub    $0xc,%esp
801015aa:	68 19 6b 10 80       	push   $0x80106b19
801015af:	e8 90 ed ff ff       	call   80100344 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015b4:	8b 43 04             	mov    0x4(%ebx),%eax
801015b7:	c1 e8 03             	shr    $0x3,%eax
801015ba:	83 ec 08             	sub    $0x8,%esp
801015bd:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801015c3:	50                   	push   %eax
801015c4:	ff 33                	push   (%ebx)
801015c6:	e8 9f eb ff ff       	call   8010016a <bread>
801015cb:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801015cd:	8b 43 04             	mov    0x4(%ebx),%eax
801015d0:	83 e0 07             	and    $0x7,%eax
801015d3:	c1 e0 06             	shl    $0x6,%eax
801015d6:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801015da:	8b 10                	mov    (%eax),%edx
801015dc:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801015e0:	66 8b 50 02          	mov    0x2(%eax),%dx
801015e4:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801015e8:	8b 50 04             	mov    0x4(%eax),%edx
801015eb:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801015ef:	66 8b 50 06          	mov    0x6(%eax),%dx
801015f3:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801015f7:	8b 50 08             	mov    0x8(%eax),%edx
801015fa:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801015fd:	83 c0 0c             	add    $0xc,%eax
80101600:	8d 53 5c             	lea    0x5c(%ebx),%edx
80101603:	83 c4 0c             	add    $0xc,%esp
80101606:	6a 34                	push   $0x34
80101608:	50                   	push   %eax
80101609:	52                   	push   %edx
8010160a:	e8 99 28 00 00       	call   80103ea8 <memmove>
    brelse(bp);
8010160f:	89 34 24             	mov    %esi,(%esp)
80101612:	e8 c0 eb ff ff       	call   801001d7 <brelse>
    ip->valid = 1;
80101617:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010161e:	83 c4 10             	add    $0x10,%esp
80101621:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101626:	0f 85 74 ff ff ff    	jne    801015a0 <ilock+0x27>
      panic("ilock: no type");
8010162c:	83 ec 0c             	sub    $0xc,%esp
8010162f:	68 1f 6b 10 80       	push   $0x80106b1f
80101634:	e8 0b ed ff ff       	call   80100344 <panic>

80101639 <iunlock>:
{
80101639:	55                   	push   %ebp
8010163a:	89 e5                	mov    %esp,%ebp
8010163c:	56                   	push   %esi
8010163d:	53                   	push   %ebx
8010163e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101641:	85 db                	test   %ebx,%ebx
80101643:	74 2c                	je     80101671 <iunlock+0x38>
80101645:	8d 73 0c             	lea    0xc(%ebx),%esi
80101648:	83 ec 0c             	sub    $0xc,%esp
8010164b:	56                   	push   %esi
8010164c:	e8 a7 25 00 00       	call   80103bf8 <holdingsleep>
80101651:	83 c4 10             	add    $0x10,%esp
80101654:	85 c0                	test   %eax,%eax
80101656:	74 19                	je     80101671 <iunlock+0x38>
80101658:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
8010165c:	7e 13                	jle    80101671 <iunlock+0x38>
  releasesleep(&ip->lock);
8010165e:	83 ec 0c             	sub    $0xc,%esp
80101661:	56                   	push   %esi
80101662:	e8 56 25 00 00       	call   80103bbd <releasesleep>
}
80101667:	83 c4 10             	add    $0x10,%esp
8010166a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010166d:	5b                   	pop    %ebx
8010166e:	5e                   	pop    %esi
8010166f:	5d                   	pop    %ebp
80101670:	c3                   	ret
    panic("iunlock");
80101671:	83 ec 0c             	sub    $0xc,%esp
80101674:	68 2e 6b 10 80       	push   $0x80106b2e
80101679:	e8 c6 ec ff ff       	call   80100344 <panic>

8010167e <iput>:
{
8010167e:	55                   	push   %ebp
8010167f:	89 e5                	mov    %esp,%ebp
80101681:	57                   	push   %edi
80101682:	56                   	push   %esi
80101683:	53                   	push   %ebx
80101684:	83 ec 18             	sub    $0x18,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010168a:	8d 73 0c             	lea    0xc(%ebx),%esi
8010168d:	56                   	push   %esi
8010168e:	e8 db 24 00 00       	call   80103b6e <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101693:	83 c4 10             	add    $0x10,%esp
80101696:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
8010169a:	74 07                	je     801016a3 <iput+0x25>
8010169c:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801016a1:	74 33                	je     801016d6 <iput+0x58>
  releasesleep(&ip->lock);
801016a3:	83 ec 0c             	sub    $0xc,%esp
801016a6:	56                   	push   %esi
801016a7:	e8 11 25 00 00       	call   80103bbd <releasesleep>
  acquire(&icache.lock);
801016ac:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801016b3:	e8 ce 26 00 00       	call   80103d86 <acquire>
  ip->ref--;
801016b8:	8b 43 08             	mov    0x8(%ebx),%eax
801016bb:	48                   	dec    %eax
801016bc:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801016bf:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801016c6:	e8 20 27 00 00       	call   80103deb <release>
}
801016cb:	83 c4 10             	add    $0x10,%esp
801016ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016d1:	5b                   	pop    %ebx
801016d2:	5e                   	pop    %esi
801016d3:	5f                   	pop    %edi
801016d4:	5d                   	pop    %ebp
801016d5:	c3                   	ret
    acquire(&icache.lock);
801016d6:	83 ec 0c             	sub    $0xc,%esp
801016d9:	68 60 f9 10 80       	push   $0x8010f960
801016de:	e8 a3 26 00 00       	call   80103d86 <acquire>
    int r = ip->ref;
801016e3:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
801016e6:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801016ed:	e8 f9 26 00 00       	call   80103deb <release>
    if(r == 1){
801016f2:	83 c4 10             	add    $0x10,%esp
801016f5:	83 ff 01             	cmp    $0x1,%edi
801016f8:	75 a9                	jne    801016a3 <iput+0x25>
      itrunc(ip);
801016fa:	89 d8                	mov    %ebx,%eax
801016fc:	e8 9c fd ff ff       	call   8010149d <itrunc>
      ip->type = 0;
80101701:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101707:	83 ec 0c             	sub    $0xc,%esp
8010170a:	53                   	push   %ebx
8010170b:	e8 10 fd ff ff       	call   80101420 <iupdate>
      ip->valid = 0;
80101710:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101717:	83 c4 10             	add    $0x10,%esp
8010171a:	eb 87                	jmp    801016a3 <iput+0x25>

8010171c <iunlockput>:
{
8010171c:	55                   	push   %ebp
8010171d:	89 e5                	mov    %esp,%ebp
8010171f:	53                   	push   %ebx
80101720:	83 ec 10             	sub    $0x10,%esp
80101723:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101726:	53                   	push   %ebx
80101727:	e8 0d ff ff ff       	call   80101639 <iunlock>
  iput(ip);
8010172c:	89 1c 24             	mov    %ebx,(%esp)
8010172f:	e8 4a ff ff ff       	call   8010167e <iput>
}
80101734:	83 c4 10             	add    $0x10,%esp
80101737:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010173a:	c9                   	leave
8010173b:	c3                   	ret

8010173c <stati>:
{
8010173c:	55                   	push   %ebp
8010173d:	89 e5                	mov    %esp,%ebp
8010173f:	8b 55 08             	mov    0x8(%ebp),%edx
80101742:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101745:	8b 0a                	mov    (%edx),%ecx
80101747:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010174a:	8b 4a 04             	mov    0x4(%edx),%ecx
8010174d:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101750:	8b 4a 50             	mov    0x50(%edx),%ecx
80101753:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101756:	66 8b 4a 56          	mov    0x56(%edx),%cx
8010175a:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
8010175e:	8b 52 58             	mov    0x58(%edx),%edx
80101761:	89 50 10             	mov    %edx,0x10(%eax)
}
80101764:	5d                   	pop    %ebp
80101765:	c3                   	ret

80101766 <readi>:
{
80101766:	55                   	push   %ebp
80101767:	89 e5                	mov    %esp,%ebp
80101769:	57                   	push   %edi
8010176a:	56                   	push   %esi
8010176b:	53                   	push   %ebx
8010176c:	83 ec 0c             	sub    $0xc,%esp
8010176f:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101772:	8b 45 08             	mov    0x8(%ebp),%eax
80101775:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010177a:	74 2c                	je     801017a8 <readi+0x42>
  if(off > ip->size || off + n < off)
8010177c:	8b 45 08             	mov    0x8(%ebp),%eax
8010177f:	8b 40 58             	mov    0x58(%eax),%eax
80101782:	39 f8                	cmp    %edi,%eax
80101784:	0f 82 d1 00 00 00    	jb     8010185b <readi+0xf5>
8010178a:	89 fa                	mov    %edi,%edx
8010178c:	03 55 14             	add    0x14(%ebp),%edx
8010178f:	0f 82 cd 00 00 00    	jb     80101862 <readi+0xfc>
  if(off + n > ip->size)
80101795:	39 d0                	cmp    %edx,%eax
80101797:	73 05                	jae    8010179e <readi+0x38>
    n = ip->size - off;
80101799:	29 f8                	sub    %edi,%eax
8010179b:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010179e:	be 00 00 00 00       	mov    $0x0,%esi
801017a3:	89 7d 10             	mov    %edi,0x10(%ebp)
801017a6:	eb 55                	jmp    801017fd <readi+0x97>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801017a8:	66 8b 40 52          	mov    0x52(%eax),%ax
801017ac:	66 83 f8 09          	cmp    $0x9,%ax
801017b0:	0f 87 97 00 00 00    	ja     8010184d <readi+0xe7>
801017b6:	98                   	cwtl
801017b7:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
801017be:	85 c0                	test   %eax,%eax
801017c0:	0f 84 8e 00 00 00    	je     80101854 <readi+0xee>
    return devsw[ip->major].read(ip, dst, n);
801017c6:	83 ec 04             	sub    $0x4,%esp
801017c9:	ff 75 14             	push   0x14(%ebp)
801017cc:	ff 75 0c             	push   0xc(%ebp)
801017cf:	ff 75 08             	push   0x8(%ebp)
801017d2:	ff d0                	call   *%eax
801017d4:	83 c4 10             	add    $0x10,%esp
801017d7:	eb 6c                	jmp    80101845 <readi+0xdf>
    memmove(dst, bp->data + off%BSIZE, m);
801017d9:	83 ec 04             	sub    $0x4,%esp
801017dc:	53                   	push   %ebx
801017dd:	8d 44 17 5c          	lea    0x5c(%edi,%edx,1),%eax
801017e1:	50                   	push   %eax
801017e2:	ff 75 0c             	push   0xc(%ebp)
801017e5:	e8 be 26 00 00       	call   80103ea8 <memmove>
    brelse(bp);
801017ea:	89 3c 24             	mov    %edi,(%esp)
801017ed:	e8 e5 e9 ff ff       	call   801001d7 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801017f2:	01 de                	add    %ebx,%esi
801017f4:	01 5d 10             	add    %ebx,0x10(%ebp)
801017f7:	01 5d 0c             	add    %ebx,0xc(%ebp)
801017fa:	83 c4 10             	add    $0x10,%esp
801017fd:	3b 75 14             	cmp    0x14(%ebp),%esi
80101800:	73 40                	jae    80101842 <readi+0xdc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101802:	8b 55 10             	mov    0x10(%ebp),%edx
80101805:	c1 ea 09             	shr    $0x9,%edx
80101808:	8b 45 08             	mov    0x8(%ebp),%eax
8010180b:	e8 d7 f8 ff ff       	call   801010e7 <bmap>
80101810:	83 ec 08             	sub    $0x8,%esp
80101813:	50                   	push   %eax
80101814:	8b 45 08             	mov    0x8(%ebp),%eax
80101817:	ff 30                	push   (%eax)
80101819:	e8 4c e9 ff ff       	call   8010016a <bread>
8010181e:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101820:	8b 55 10             	mov    0x10(%ebp),%edx
80101823:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101829:	b8 00 02 00 00       	mov    $0x200,%eax
8010182e:	29 d0                	sub    %edx,%eax
80101830:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101833:	29 f1                	sub    %esi,%ecx
80101835:	89 c3                	mov    %eax,%ebx
80101837:	83 c4 10             	add    $0x10,%esp
8010183a:	39 c1                	cmp    %eax,%ecx
8010183c:	73 9b                	jae    801017d9 <readi+0x73>
8010183e:	89 cb                	mov    %ecx,%ebx
80101840:	eb 97                	jmp    801017d9 <readi+0x73>
  return n;
80101842:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101845:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101848:	5b                   	pop    %ebx
80101849:	5e                   	pop    %esi
8010184a:	5f                   	pop    %edi
8010184b:	5d                   	pop    %ebp
8010184c:	c3                   	ret
      return -1;
8010184d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101852:	eb f1                	jmp    80101845 <readi+0xdf>
80101854:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101859:	eb ea                	jmp    80101845 <readi+0xdf>
    return -1;
8010185b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101860:	eb e3                	jmp    80101845 <readi+0xdf>
80101862:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101867:	eb dc                	jmp    80101845 <readi+0xdf>

80101869 <writei>:
{
80101869:	55                   	push   %ebp
8010186a:	89 e5                	mov    %esp,%ebp
8010186c:	57                   	push   %edi
8010186d:	56                   	push   %esi
8010186e:	53                   	push   %ebx
8010186f:	83 ec 0c             	sub    $0xc,%esp
80101872:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101875:	8b 45 08             	mov    0x8(%ebp),%eax
80101878:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010187d:	74 2e                	je     801018ad <writei+0x44>
  if(off > ip->size || off + n < off)
8010187f:	8b 45 08             	mov    0x8(%ebp),%eax
80101882:	39 78 58             	cmp    %edi,0x58(%eax)
80101885:	0f 82 02 01 00 00    	jb     8010198d <writei+0x124>
8010188b:	89 f8                	mov    %edi,%eax
8010188d:	03 45 14             	add    0x14(%ebp),%eax
80101890:	0f 82 fe 00 00 00    	jb     80101994 <writei+0x12b>
  if(off + n > MAXFILE*BSIZE)
80101896:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010189b:	0f 87 fa 00 00 00    	ja     8010199b <writei+0x132>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801018a1:	bb 00 00 00 00       	mov    $0x0,%ebx
801018a6:	89 7d 10             	mov    %edi,0x10(%ebp)
801018a9:	89 df                	mov    %ebx,%edi
801018ab:	eb 60                	jmp    8010190d <writei+0xa4>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801018ad:	66 8b 40 52          	mov    0x52(%eax),%ax
801018b1:	66 83 f8 09          	cmp    $0x9,%ax
801018b5:	0f 87 c4 00 00 00    	ja     8010197f <writei+0x116>
801018bb:	98                   	cwtl
801018bc:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
801018c3:	85 c0                	test   %eax,%eax
801018c5:	0f 84 bb 00 00 00    	je     80101986 <writei+0x11d>
    return devsw[ip->major].write(ip, src, n);
801018cb:	83 ec 04             	sub    $0x4,%esp
801018ce:	ff 75 14             	push   0x14(%ebp)
801018d1:	ff 75 0c             	push   0xc(%ebp)
801018d4:	ff 75 08             	push   0x8(%ebp)
801018d7:	ff d0                	call   *%eax
801018d9:	83 c4 10             	add    $0x10,%esp
801018dc:	e9 85 00 00 00       	jmp    80101966 <writei+0xfd>
    memmove(bp->data + off%BSIZE, src, m);
801018e1:	83 ec 04             	sub    $0x4,%esp
801018e4:	56                   	push   %esi
801018e5:	ff 75 0c             	push   0xc(%ebp)
801018e8:	8d 44 13 5c          	lea    0x5c(%ebx,%edx,1),%eax
801018ec:	50                   	push   %eax
801018ed:	e8 b6 25 00 00       	call   80103ea8 <memmove>
    log_write(bp);
801018f2:	89 1c 24             	mov    %ebx,(%esp)
801018f5:	e8 8f 0f 00 00       	call   80102889 <log_write>
    brelse(bp);
801018fa:	89 1c 24             	mov    %ebx,(%esp)
801018fd:	e8 d5 e8 ff ff       	call   801001d7 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101902:	01 f7                	add    %esi,%edi
80101904:	01 75 10             	add    %esi,0x10(%ebp)
80101907:	01 75 0c             	add    %esi,0xc(%ebp)
8010190a:	83 c4 10             	add    $0x10,%esp
8010190d:	3b 7d 14             	cmp    0x14(%ebp),%edi
80101910:	73 40                	jae    80101952 <writei+0xe9>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101912:	8b 55 10             	mov    0x10(%ebp),%edx
80101915:	c1 ea 09             	shr    $0x9,%edx
80101918:	8b 45 08             	mov    0x8(%ebp),%eax
8010191b:	e8 c7 f7 ff ff       	call   801010e7 <bmap>
80101920:	83 ec 08             	sub    $0x8,%esp
80101923:	50                   	push   %eax
80101924:	8b 45 08             	mov    0x8(%ebp),%eax
80101927:	ff 30                	push   (%eax)
80101929:	e8 3c e8 ff ff       	call   8010016a <bread>
8010192e:	89 c3                	mov    %eax,%ebx
    m = min(n - tot, BSIZE - off%BSIZE);
80101930:	8b 55 10             	mov    0x10(%ebp),%edx
80101933:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101939:	b8 00 02 00 00       	mov    $0x200,%eax
8010193e:	29 d0                	sub    %edx,%eax
80101940:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101943:	29 f9                	sub    %edi,%ecx
80101945:	89 c6                	mov    %eax,%esi
80101947:	83 c4 10             	add    $0x10,%esp
8010194a:	39 c1                	cmp    %eax,%ecx
8010194c:	73 93                	jae    801018e1 <writei+0x78>
8010194e:	89 ce                	mov    %ecx,%esi
80101950:	eb 8f                	jmp    801018e1 <writei+0x78>
  if(n > 0 && off > ip->size){
80101952:	8b 7d 10             	mov    0x10(%ebp),%edi
80101955:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80101959:	74 08                	je     80101963 <writei+0xfa>
8010195b:	8b 45 08             	mov    0x8(%ebp),%eax
8010195e:	39 78 58             	cmp    %edi,0x58(%eax)
80101961:	72 0b                	jb     8010196e <writei+0x105>
  return n;
80101963:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101966:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101969:	5b                   	pop    %ebx
8010196a:	5e                   	pop    %esi
8010196b:	5f                   	pop    %edi
8010196c:	5d                   	pop    %ebp
8010196d:	c3                   	ret
    ip->size = off;
8010196e:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101971:	83 ec 0c             	sub    $0xc,%esp
80101974:	50                   	push   %eax
80101975:	e8 a6 fa ff ff       	call   80101420 <iupdate>
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	eb e4                	jmp    80101963 <writei+0xfa>
      return -1;
8010197f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101984:	eb e0                	jmp    80101966 <writei+0xfd>
80101986:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010198b:	eb d9                	jmp    80101966 <writei+0xfd>
    return -1;
8010198d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101992:	eb d2                	jmp    80101966 <writei+0xfd>
80101994:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101999:	eb cb                	jmp    80101966 <writei+0xfd>
    return -1;
8010199b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019a0:	eb c4                	jmp    80101966 <writei+0xfd>

801019a2 <namecmp>:
{
801019a2:	55                   	push   %ebp
801019a3:	89 e5                	mov    %esp,%ebp
801019a5:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801019a8:	6a 0e                	push   $0xe
801019aa:	ff 75 0c             	push   0xc(%ebp)
801019ad:	ff 75 08             	push   0x8(%ebp)
801019b0:	e8 59 25 00 00       	call   80103f0e <strncmp>
}
801019b5:	c9                   	leave
801019b6:	c3                   	ret

801019b7 <dirlookup>:
{
801019b7:	55                   	push   %ebp
801019b8:	89 e5                	mov    %esp,%ebp
801019ba:	57                   	push   %edi
801019bb:	56                   	push   %esi
801019bc:	53                   	push   %ebx
801019bd:	83 ec 1c             	sub    $0x1c,%esp
801019c0:	8b 75 08             	mov    0x8(%ebp),%esi
801019c3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
801019c6:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801019cb:	75 07                	jne    801019d4 <dirlookup+0x1d>
  for(off = 0; off < dp->size; off += sizeof(de)){
801019cd:	bb 00 00 00 00       	mov    $0x0,%ebx
801019d2:	eb 1d                	jmp    801019f1 <dirlookup+0x3a>
    panic("dirlookup not DIR");
801019d4:	83 ec 0c             	sub    $0xc,%esp
801019d7:	68 36 6b 10 80       	push   $0x80106b36
801019dc:	e8 63 e9 ff ff       	call   80100344 <panic>
      panic("dirlookup read");
801019e1:	83 ec 0c             	sub    $0xc,%esp
801019e4:	68 48 6b 10 80       	push   $0x80106b48
801019e9:	e8 56 e9 ff ff       	call   80100344 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
801019ee:	83 c3 10             	add    $0x10,%ebx
801019f1:	3b 5e 58             	cmp    0x58(%esi),%ebx
801019f4:	73 48                	jae    80101a3e <dirlookup+0x87>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801019f6:	6a 10                	push   $0x10
801019f8:	53                   	push   %ebx
801019f9:	8d 45 d8             	lea    -0x28(%ebp),%eax
801019fc:	50                   	push   %eax
801019fd:	56                   	push   %esi
801019fe:	e8 63 fd ff ff       	call   80101766 <readi>
80101a03:	83 c4 10             	add    $0x10,%esp
80101a06:	83 f8 10             	cmp    $0x10,%eax
80101a09:	75 d6                	jne    801019e1 <dirlookup+0x2a>
    if(de.inum == 0)
80101a0b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a10:	74 dc                	je     801019ee <dirlookup+0x37>
    if(namecmp(name, de.name) == 0){
80101a12:	83 ec 08             	sub    $0x8,%esp
80101a15:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a18:	50                   	push   %eax
80101a19:	57                   	push   %edi
80101a1a:	e8 83 ff ff ff       	call   801019a2 <namecmp>
80101a1f:	83 c4 10             	add    $0x10,%esp
80101a22:	85 c0                	test   %eax,%eax
80101a24:	75 c8                	jne    801019ee <dirlookup+0x37>
      if(poff)
80101a26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a2a:	74 05                	je     80101a31 <dirlookup+0x7a>
        *poff = off;
80101a2c:	8b 45 10             	mov    0x10(%ebp),%eax
80101a2f:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a31:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a35:	8b 06                	mov    (%esi),%eax
80101a37:	e8 51 f7 ff ff       	call   8010118d <iget>
80101a3c:	eb 05                	jmp    80101a43 <dirlookup+0x8c>
  return 0;
80101a3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101a43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a46:	5b                   	pop    %ebx
80101a47:	5e                   	pop    %esi
80101a48:	5f                   	pop    %edi
80101a49:	5d                   	pop    %ebp
80101a4a:	c3                   	ret

80101a4b <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a4b:	55                   	push   %ebp
80101a4c:	89 e5                	mov    %esp,%ebp
80101a4e:	57                   	push   %edi
80101a4f:	56                   	push   %esi
80101a50:	53                   	push   %ebx
80101a51:	83 ec 1c             	sub    $0x1c,%esp
80101a54:	89 c3                	mov    %eax,%ebx
80101a56:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101a59:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a5c:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a5f:	74 17                	je     80101a78 <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101a61:	e8 23 18 00 00       	call   80103289 <myproc>
80101a66:	83 ec 0c             	sub    $0xc,%esp
80101a69:	ff 70 68             	push   0x68(%eax)
80101a6c:	e8 da fa ff ff       	call   8010154b <idup>
80101a71:	89 c6                	mov    %eax,%esi
80101a73:	83 c4 10             	add    $0x10,%esp
80101a76:	eb 53                	jmp    80101acb <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101a78:	ba 01 00 00 00       	mov    $0x1,%edx
80101a7d:	b8 01 00 00 00       	mov    $0x1,%eax
80101a82:	e8 06 f7 ff ff       	call   8010118d <iget>
80101a87:	89 c6                	mov    %eax,%esi
80101a89:	eb 40                	jmp    80101acb <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101a8b:	83 ec 0c             	sub    $0xc,%esp
80101a8e:	56                   	push   %esi
80101a8f:	e8 88 fc ff ff       	call   8010171c <iunlockput>
      return 0;
80101a94:	83 c4 10             	add    $0x10,%esp
80101a97:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101a9c:	89 f0                	mov    %esi,%eax
80101a9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aa1:	5b                   	pop    %ebx
80101aa2:	5e                   	pop    %esi
80101aa3:	5f                   	pop    %edi
80101aa4:	5d                   	pop    %ebp
80101aa5:	c3                   	ret
    if((next = dirlookup(ip, name, 0)) == 0){
80101aa6:	83 ec 04             	sub    $0x4,%esp
80101aa9:	6a 00                	push   $0x0
80101aab:	ff 75 e4             	push   -0x1c(%ebp)
80101aae:	56                   	push   %esi
80101aaf:	e8 03 ff ff ff       	call   801019b7 <dirlookup>
80101ab4:	89 c7                	mov    %eax,%edi
80101ab6:	83 c4 10             	add    $0x10,%esp
80101ab9:	85 c0                	test   %eax,%eax
80101abb:	74 4a                	je     80101b07 <namex+0xbc>
    iunlockput(ip);
80101abd:	83 ec 0c             	sub    $0xc,%esp
80101ac0:	56                   	push   %esi
80101ac1:	e8 56 fc ff ff       	call   8010171c <iunlockput>
80101ac6:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101ac9:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101acb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ace:	89 d8                	mov    %ebx,%eax
80101ad0:	e8 8d f4 ff ff       	call   80100f62 <skipelem>
80101ad5:	89 c3                	mov    %eax,%ebx
80101ad7:	85 c0                	test   %eax,%eax
80101ad9:	74 3c                	je     80101b17 <namex+0xcc>
    ilock(ip);
80101adb:	83 ec 0c             	sub    $0xc,%esp
80101ade:	56                   	push   %esi
80101adf:	e8 95 fa ff ff       	call   80101579 <ilock>
    if(ip->type != T_DIR){
80101ae4:	83 c4 10             	add    $0x10,%esp
80101ae7:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101aec:	75 9d                	jne    80101a8b <namex+0x40>
    if(nameiparent && *path == '\0'){
80101aee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101af2:	74 b2                	je     80101aa6 <namex+0x5b>
80101af4:	80 3b 00             	cmpb   $0x0,(%ebx)
80101af7:	75 ad                	jne    80101aa6 <namex+0x5b>
      iunlock(ip);
80101af9:	83 ec 0c             	sub    $0xc,%esp
80101afc:	56                   	push   %esi
80101afd:	e8 37 fb ff ff       	call   80101639 <iunlock>
      return ip;
80101b02:	83 c4 10             	add    $0x10,%esp
80101b05:	eb 95                	jmp    80101a9c <namex+0x51>
      iunlockput(ip);
80101b07:	83 ec 0c             	sub    $0xc,%esp
80101b0a:	56                   	push   %esi
80101b0b:	e8 0c fc ff ff       	call   8010171c <iunlockput>
      return 0;
80101b10:	83 c4 10             	add    $0x10,%esp
80101b13:	89 fe                	mov    %edi,%esi
80101b15:	eb 85                	jmp    80101a9c <namex+0x51>
  if(nameiparent){
80101b17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b1b:	0f 84 7b ff ff ff    	je     80101a9c <namex+0x51>
    iput(ip);
80101b21:	83 ec 0c             	sub    $0xc,%esp
80101b24:	56                   	push   %esi
80101b25:	e8 54 fb ff ff       	call   8010167e <iput>
    return 0;
80101b2a:	83 c4 10             	add    $0x10,%esp
80101b2d:	89 de                	mov    %ebx,%esi
80101b2f:	e9 68 ff ff ff       	jmp    80101a9c <namex+0x51>

80101b34 <dirlink>:
{
80101b34:	55                   	push   %ebp
80101b35:	89 e5                	mov    %esp,%ebp
80101b37:	57                   	push   %edi
80101b38:	56                   	push   %esi
80101b39:	53                   	push   %ebx
80101b3a:	83 ec 20             	sub    $0x20,%esp
80101b3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101b40:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101b43:	6a 00                	push   $0x0
80101b45:	57                   	push   %edi
80101b46:	53                   	push   %ebx
80101b47:	e8 6b fe ff ff       	call   801019b7 <dirlookup>
80101b4c:	83 c4 10             	add    $0x10,%esp
80101b4f:	85 c0                	test   %eax,%eax
80101b51:	75 2d                	jne    80101b80 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b53:	b8 00 00 00 00       	mov    $0x0,%eax
80101b58:	89 c6                	mov    %eax,%esi
80101b5a:	3b 43 58             	cmp    0x58(%ebx),%eax
80101b5d:	73 41                	jae    80101ba0 <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b5f:	6a 10                	push   $0x10
80101b61:	50                   	push   %eax
80101b62:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101b65:	50                   	push   %eax
80101b66:	53                   	push   %ebx
80101b67:	e8 fa fb ff ff       	call   80101766 <readi>
80101b6c:	83 c4 10             	add    $0x10,%esp
80101b6f:	83 f8 10             	cmp    $0x10,%eax
80101b72:	75 1f                	jne    80101b93 <dirlink+0x5f>
    if(de.inum == 0)
80101b74:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101b79:	74 25                	je     80101ba0 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b7b:	8d 46 10             	lea    0x10(%esi),%eax
80101b7e:	eb d8                	jmp    80101b58 <dirlink+0x24>
    iput(ip);
80101b80:	83 ec 0c             	sub    $0xc,%esp
80101b83:	50                   	push   %eax
80101b84:	e8 f5 fa ff ff       	call   8010167e <iput>
    return -1;
80101b89:	83 c4 10             	add    $0x10,%esp
80101b8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b91:	eb 3d                	jmp    80101bd0 <dirlink+0x9c>
      panic("dirlink read");
80101b93:	83 ec 0c             	sub    $0xc,%esp
80101b96:	68 57 6b 10 80       	push   $0x80106b57
80101b9b:	e8 a4 e7 ff ff       	call   80100344 <panic>
  strncpy(de.name, name, DIRSIZ);
80101ba0:	83 ec 04             	sub    $0x4,%esp
80101ba3:	6a 0e                	push   $0xe
80101ba5:	57                   	push   %edi
80101ba6:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101ba9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bac:	50                   	push   %eax
80101bad:	e8 94 23 00 00       	call   80103f46 <strncpy>
  de.inum = inum;
80101bb2:	8b 45 10             	mov    0x10(%ebp),%eax
80101bb5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bb9:	6a 10                	push   $0x10
80101bbb:	56                   	push   %esi
80101bbc:	57                   	push   %edi
80101bbd:	53                   	push   %ebx
80101bbe:	e8 a6 fc ff ff       	call   80101869 <writei>
80101bc3:	83 c4 20             	add    $0x20,%esp
80101bc6:	83 f8 10             	cmp    $0x10,%eax
80101bc9:	75 0d                	jne    80101bd8 <dirlink+0xa4>
  return 0;
80101bcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd3:	5b                   	pop    %ebx
80101bd4:	5e                   	pop    %esi
80101bd5:	5f                   	pop    %edi
80101bd6:	5d                   	pop    %ebp
80101bd7:	c3                   	ret
    panic("dirlink");
80101bd8:	83 ec 0c             	sub    $0xc,%esp
80101bdb:	68 c5 6d 10 80       	push   $0x80106dc5
80101be0:	e8 5f e7 ff ff       	call   80100344 <panic>

80101be5 <namei>:

struct inode*
namei(char *path)
{
80101be5:	55                   	push   %ebp
80101be6:	89 e5                	mov    %esp,%ebp
80101be8:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101beb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101bee:	ba 00 00 00 00       	mov    $0x0,%edx
80101bf3:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf6:	e8 50 fe ff ff       	call   80101a4b <namex>
}
80101bfb:	c9                   	leave
80101bfc:	c3                   	ret

80101bfd <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101bfd:	55                   	push   %ebp
80101bfe:	89 e5                	mov    %esp,%ebp
80101c00:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101c03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101c06:	ba 01 00 00 00       	mov    $0x1,%edx
80101c0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0e:	e8 38 fe ff ff       	call   80101a4b <namex>
}
80101c13:	c9                   	leave
80101c14:	c3                   	ret

80101c15 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101c15:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101c17:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c1c:	ec                   	in     (%dx),%al
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101c1d:	88 c2                	mov    %al,%dl
80101c1f:	83 e2 c0             	and    $0xffffffc0,%edx
80101c22:	80 fa 40             	cmp    $0x40,%dl
80101c25:	75 f0                	jne    80101c17 <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101c27:	85 c9                	test   %ecx,%ecx
80101c29:	74 09                	je     80101c34 <idewait+0x1f>
80101c2b:	a8 21                	test   $0x21,%al
80101c2d:	75 08                	jne    80101c37 <idewait+0x22>
    return -1;
  return 0;
80101c2f:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101c34:	89 c8                	mov    %ecx,%eax
80101c36:	c3                   	ret
    return -1;
80101c37:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101c3c:	eb f6                	jmp    80101c34 <idewait+0x1f>

80101c3e <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101c3e:	55                   	push   %ebp
80101c3f:	89 e5                	mov    %esp,%ebp
80101c41:	56                   	push   %esi
80101c42:	53                   	push   %ebx
  if(b == 0)
80101c43:	85 c0                	test   %eax,%eax
80101c45:	0f 84 85 00 00 00    	je     80101cd0 <idestart+0x92>
80101c4b:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101c4d:	8b 58 08             	mov    0x8(%eax),%ebx
80101c50:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101c56:	0f 87 81 00 00 00    	ja     80101cdd <idestart+0x9f>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101c5c:	b8 00 00 00 00       	mov    $0x0,%eax
80101c61:	e8 af ff ff ff       	call   80101c15 <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101c66:	b0 00                	mov    $0x0,%al
80101c68:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101c6d:	ee                   	out    %al,(%dx)
80101c6e:	b0 01                	mov    $0x1,%al
80101c70:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101c75:	ee                   	out    %al,(%dx)
80101c76:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101c7b:	88 d8                	mov    %bl,%al
80101c7d:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101c7e:	0f b6 c7             	movzbl %bh,%eax
80101c81:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101c86:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101c87:	89 d8                	mov    %ebx,%eax
80101c89:	c1 f8 10             	sar    $0x10,%eax
80101c8c:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101c91:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101c92:	8a 46 04             	mov    0x4(%esi),%al
80101c95:	c1 e0 04             	shl    $0x4,%eax
80101c98:	83 e0 10             	and    $0x10,%eax
80101c9b:	c1 fb 18             	sar    $0x18,%ebx
80101c9e:	83 e3 0f             	and    $0xf,%ebx
80101ca1:	09 d8                	or     %ebx,%eax
80101ca3:	83 c8 e0             	or     $0xffffffe0,%eax
80101ca6:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101cab:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101cac:	f6 06 04             	testb  $0x4,(%esi)
80101caf:	74 39                	je     80101cea <idestart+0xac>
80101cb1:	b0 30                	mov    $0x30,%al
80101cb3:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cb8:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101cb9:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101cbc:	b9 80 00 00 00       	mov    $0x80,%ecx
80101cc1:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101cc6:	fc                   	cld
80101cc7:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101cc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ccc:	5b                   	pop    %ebx
80101ccd:	5e                   	pop    %esi
80101cce:	5d                   	pop    %ebp
80101ccf:	c3                   	ret
    panic("idestart");
80101cd0:	83 ec 0c             	sub    $0xc,%esp
80101cd3:	68 64 6b 10 80       	push   $0x80106b64
80101cd8:	e8 67 e6 ff ff       	call   80100344 <panic>
    panic("incorrect blockno");
80101cdd:	83 ec 0c             	sub    $0xc,%esp
80101ce0:	68 6d 6b 10 80       	push   $0x80106b6d
80101ce5:	e8 5a e6 ff ff       	call   80100344 <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101cea:	b0 20                	mov    $0x20,%al
80101cec:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cf1:	ee                   	out    %al,(%dx)
}
80101cf2:	eb d5                	jmp    80101cc9 <idestart+0x8b>

80101cf4 <ideinit>:
{
80101cf4:	55                   	push   %ebp
80101cf5:	89 e5                	mov    %esp,%ebp
80101cf7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101cfa:	68 7f 6b 10 80       	push   $0x80106b7f
80101cff:	68 00 16 11 80       	push   $0x80111600
80101d04:	e8 3d 1f 00 00       	call   80103c46 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101d09:	83 c4 08             	add    $0x8,%esp
80101d0c:	a1 84 17 11 80       	mov    0x80111784,%eax
80101d11:	48                   	dec    %eax
80101d12:	50                   	push   %eax
80101d13:	6a 0e                	push   $0xe
80101d15:	e8 4b 02 00 00       	call   80101f65 <ioapicenable>
  idewait(0);
80101d1a:	b8 00 00 00 00       	mov    $0x0,%eax
80101d1f:	e8 f1 fe ff ff       	call   80101c15 <idewait>
80101d24:	b0 f0                	mov    $0xf0,%al
80101d26:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d2b:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101d2c:	83 c4 10             	add    $0x10,%esp
80101d2f:	b9 00 00 00 00       	mov    $0x0,%ecx
80101d34:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101d3a:	7f 17                	jg     80101d53 <ideinit+0x5f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d3c:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d41:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101d42:	84 c0                	test   %al,%al
80101d44:	75 03                	jne    80101d49 <ideinit+0x55>
  for(i=0; i<1000; i++){
80101d46:	41                   	inc    %ecx
80101d47:	eb eb                	jmp    80101d34 <ideinit+0x40>
      havedisk1 = 1;
80101d49:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80101d50:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d53:	b0 e0                	mov    $0xe0,%al
80101d55:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d5a:	ee                   	out    %al,(%dx)
}
80101d5b:	c9                   	leave
80101d5c:	c3                   	ret

80101d5d <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101d5d:	55                   	push   %ebp
80101d5e:	89 e5                	mov    %esp,%ebp
80101d60:	57                   	push   %edi
80101d61:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	68 00 16 11 80       	push   $0x80111600
80101d6a:	e8 17 20 00 00       	call   80103d86 <acquire>

  if((b = idequeue) == 0){
80101d6f:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80101d75:	83 c4 10             	add    $0x10,%esp
80101d78:	85 db                	test   %ebx,%ebx
80101d7a:	74 4f                	je     80101dcb <ideintr+0x6e>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101d7c:	8b 43 58             	mov    0x58(%ebx),%eax
80101d7f:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101d84:	f6 03 04             	testb  $0x4,(%ebx)
80101d87:	74 54                	je     80101ddd <ideintr+0x80>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101d89:	8b 03                	mov    (%ebx),%eax
80101d8b:	89 c2                	mov    %eax,%edx
80101d8d:	83 ca 02             	or     $0x2,%edx
80101d90:	89 13                	mov    %edx,(%ebx)
  b->flags &= ~B_DIRTY;
80101d92:	83 e0 fb             	and    $0xfffffffb,%eax
80101d95:	83 c8 02             	or     $0x2,%eax
80101d98:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101d9a:	83 ec 0c             	sub    $0xc,%esp
80101d9d:	53                   	push   %ebx
80101d9e:	e8 45 1b 00 00       	call   801038e8 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101da3:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80101da8:	83 c4 10             	add    $0x10,%esp
80101dab:	85 c0                	test   %eax,%eax
80101dad:	74 05                	je     80101db4 <ideintr+0x57>
    idestart(idequeue);
80101daf:	e8 8a fe ff ff       	call   80101c3e <idestart>

  release(&idelock);
80101db4:	83 ec 0c             	sub    $0xc,%esp
80101db7:	68 00 16 11 80       	push   $0x80111600
80101dbc:	e8 2a 20 00 00       	call   80103deb <release>
80101dc1:	83 c4 10             	add    $0x10,%esp
}
80101dc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101dc7:	5b                   	pop    %ebx
80101dc8:	5f                   	pop    %edi
80101dc9:	5d                   	pop    %ebp
80101dca:	c3                   	ret
    release(&idelock);
80101dcb:	83 ec 0c             	sub    $0xc,%esp
80101dce:	68 00 16 11 80       	push   $0x80111600
80101dd3:	e8 13 20 00 00       	call   80103deb <release>
    return;
80101dd8:	83 c4 10             	add    $0x10,%esp
80101ddb:	eb e7                	jmp    80101dc4 <ideintr+0x67>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101ddd:	b8 01 00 00 00       	mov    $0x1,%eax
80101de2:	e8 2e fe ff ff       	call   80101c15 <idewait>
80101de7:	85 c0                	test   %eax,%eax
80101de9:	78 9e                	js     80101d89 <ideintr+0x2c>
    insl(0x1f0, b->data, BSIZE/4);
80101deb:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101dee:	b9 80 00 00 00       	mov    $0x80,%ecx
80101df3:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101df8:	fc                   	cld
80101df9:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101dfb:	eb 8c                	jmp    80101d89 <ideintr+0x2c>

80101dfd <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101dfd:	55                   	push   %ebp
80101dfe:	89 e5                	mov    %esp,%ebp
80101e00:	53                   	push   %ebx
80101e01:	83 ec 10             	sub    $0x10,%esp
80101e04:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e07:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e0a:	50                   	push   %eax
80101e0b:	e8 e8 1d 00 00       	call   80103bf8 <holdingsleep>
80101e10:	83 c4 10             	add    $0x10,%esp
80101e13:	85 c0                	test   %eax,%eax
80101e15:	74 37                	je     80101e4e <iderw+0x51>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101e17:	8b 03                	mov    (%ebx),%eax
80101e19:	83 e0 06             	and    $0x6,%eax
80101e1c:	83 f8 02             	cmp    $0x2,%eax
80101e1f:	74 3a                	je     80101e5b <iderw+0x5e>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101e21:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101e25:	74 09                	je     80101e30 <iderw+0x33>
80101e27:	83 3d e0 15 11 80 00 	cmpl   $0x0,0x801115e0
80101e2e:	74 38                	je     80101e68 <iderw+0x6b>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	68 00 16 11 80       	push   $0x80111600
80101e38:	e8 49 1f 00 00       	call   80103d86 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101e3d:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101e44:	83 c4 10             	add    $0x10,%esp
80101e47:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80101e4c:	eb 2a                	jmp    80101e78 <iderw+0x7b>
    panic("iderw: buf not locked");
80101e4e:	83 ec 0c             	sub    $0xc,%esp
80101e51:	68 83 6b 10 80       	push   $0x80106b83
80101e56:	e8 e9 e4 ff ff       	call   80100344 <panic>
    panic("iderw: nothing to do");
80101e5b:	83 ec 0c             	sub    $0xc,%esp
80101e5e:	68 99 6b 10 80       	push   $0x80106b99
80101e63:	e8 dc e4 ff ff       	call   80100344 <panic>
    panic("iderw: ide disk 1 not present");
80101e68:	83 ec 0c             	sub    $0xc,%esp
80101e6b:	68 ae 6b 10 80       	push   $0x80106bae
80101e70:	e8 cf e4 ff ff       	call   80100344 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101e75:	8d 50 58             	lea    0x58(%eax),%edx
80101e78:	8b 02                	mov    (%edx),%eax
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	75 f7                	jne    80101e75 <iderw+0x78>
    ;
  *pp = b;
80101e7e:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101e80:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80101e86:	75 1a                	jne    80101ea2 <iderw+0xa5>
    idestart(b);
80101e88:	89 d8                	mov    %ebx,%eax
80101e8a:	e8 af fd ff ff       	call   80101c3e <idestart>
80101e8f:	eb 11                	jmp    80101ea2 <iderw+0xa5>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101e91:	83 ec 08             	sub    $0x8,%esp
80101e94:	68 00 16 11 80       	push   $0x80111600
80101e99:	53                   	push   %ebx
80101e9a:	e8 ce 18 00 00       	call   8010376d <sleep>
80101e9f:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101ea2:	8b 03                	mov    (%ebx),%eax
80101ea4:	83 e0 06             	and    $0x6,%eax
80101ea7:	83 f8 02             	cmp    $0x2,%eax
80101eaa:	75 e5                	jne    80101e91 <iderw+0x94>
  }


  release(&idelock);
80101eac:	83 ec 0c             	sub    $0xc,%esp
80101eaf:	68 00 16 11 80       	push   $0x80111600
80101eb4:	e8 32 1f 00 00       	call   80103deb <release>
}
80101eb9:	83 c4 10             	add    $0x10,%esp
80101ebc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ebf:	c9                   	leave
80101ec0:	c3                   	ret

80101ec1 <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101ec1:	8b 15 34 16 11 80    	mov    0x80111634,%edx
80101ec7:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101ec9:	a1 34 16 11 80       	mov    0x80111634,%eax
80101ece:	8b 40 10             	mov    0x10(%eax),%eax
}
80101ed1:	c3                   	ret

80101ed2 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101ed2:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80101ed8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101eda:	a1 34 16 11 80       	mov    0x80111634,%eax
80101edf:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ee2:	c3                   	ret

80101ee3 <ioapicinit>:

void
ioapicinit(void)
{
80101ee3:	55                   	push   %ebp
80101ee4:	89 e5                	mov    %esp,%ebp
80101ee6:	57                   	push   %edi
80101ee7:	56                   	push   %esi
80101ee8:	53                   	push   %ebx
80101ee9:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101eec:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80101ef3:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101ef6:	b8 01 00 00 00       	mov    $0x1,%eax
80101efb:	e8 c1 ff ff ff       	call   80101ec1 <ioapicread>
80101f00:	c1 e8 10             	shr    $0x10,%eax
80101f03:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101f06:	b8 00 00 00 00       	mov    $0x0,%eax
80101f0b:	e8 b1 ff ff ff       	call   80101ec1 <ioapicread>
80101f10:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101f13:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
80101f1a:	39 c2                	cmp    %eax,%edx
80101f1c:	75 07                	jne    80101f25 <ioapicinit+0x42>
{
80101f1e:	bb 00 00 00 00       	mov    $0x0,%ebx
80101f23:	eb 34                	jmp    80101f59 <ioapicinit+0x76>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101f25:	83 ec 0c             	sub    $0xc,%esp
80101f28:	68 6c 6f 10 80       	push   $0x80106f6c
80101f2d:	e8 ad e6 ff ff       	call   801005df <cprintf>
80101f32:	83 c4 10             	add    $0x10,%esp
80101f35:	eb e7                	jmp    80101f1e <ioapicinit+0x3b>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101f37:	8d 53 20             	lea    0x20(%ebx),%edx
80101f3a:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101f40:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101f44:	89 f0                	mov    %esi,%eax
80101f46:	e8 87 ff ff ff       	call   80101ed2 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101f4b:	8d 46 01             	lea    0x1(%esi),%eax
80101f4e:	ba 00 00 00 00       	mov    $0x0,%edx
80101f53:	e8 7a ff ff ff       	call   80101ed2 <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101f58:	43                   	inc    %ebx
80101f59:	39 fb                	cmp    %edi,%ebx
80101f5b:	7e da                	jle    80101f37 <ioapicinit+0x54>
  }
}
80101f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f60:	5b                   	pop    %ebx
80101f61:	5e                   	pop    %esi
80101f62:	5f                   	pop    %edi
80101f63:	5d                   	pop    %ebp
80101f64:	c3                   	ret

80101f65 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101f65:	55                   	push   %ebp
80101f66:	89 e5                	mov    %esp,%ebp
80101f68:	53                   	push   %ebx
80101f69:	83 ec 04             	sub    $0x4,%esp
80101f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80101f6f:	8d 50 20             	lea    0x20(%eax),%edx
80101f72:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80101f76:	89 d8                	mov    %ebx,%eax
80101f78:	e8 55 ff ff ff       	call   80101ed2 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80101f7d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f80:	c1 e2 18             	shl    $0x18,%edx
80101f83:	8d 43 01             	lea    0x1(%ebx),%eax
80101f86:	e8 47 ff ff ff       	call   80101ed2 <ioapicwrite>
}
80101f8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f8e:	c9                   	leave
80101f8f:	c3                   	ret

80101f90 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	53                   	push   %ebx
80101f94:	83 ec 04             	sub    $0x4,%esp
80101f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80101f9a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80101fa0:	75 4c                	jne    80101fee <kfree+0x5e>
80101fa2:	81 fb 30 58 11 80    	cmp    $0x80115830,%ebx
80101fa8:	72 44                	jb     80101fee <kfree+0x5e>
80101faa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80101fb0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80101fb5:	77 37                	ja     80101fee <kfree+0x5e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80101fb7:	83 ec 04             	sub    $0x4,%esp
80101fba:	68 00 10 00 00       	push   $0x1000
80101fbf:	6a 01                	push   $0x1
80101fc1:	53                   	push   %ebx
80101fc2:	e8 6b 1e 00 00       	call   80103e32 <memset>

  if(kmem.use_lock)
80101fc7:	83 c4 10             	add    $0x10,%esp
80101fca:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80101fd1:	75 28                	jne    80101ffb <kfree+0x6b>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80101fd3:	a1 78 16 11 80       	mov    0x80111678,%eax
80101fd8:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80101fda:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80101fe0:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80101fe7:	75 24                	jne    8010200d <kfree+0x7d>
    release(&kmem.lock);
}
80101fe9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101fec:	c9                   	leave
80101fed:	c3                   	ret
    panic("kfree");
80101fee:	83 ec 0c             	sub    $0xc,%esp
80101ff1:	68 cc 6b 10 80       	push   $0x80106bcc
80101ff6:	e8 49 e3 ff ff       	call   80100344 <panic>
    acquire(&kmem.lock);
80101ffb:	83 ec 0c             	sub    $0xc,%esp
80101ffe:	68 40 16 11 80       	push   $0x80111640
80102003:	e8 7e 1d 00 00       	call   80103d86 <acquire>
80102008:	83 c4 10             	add    $0x10,%esp
8010200b:	eb c6                	jmp    80101fd3 <kfree+0x43>
    release(&kmem.lock);
8010200d:	83 ec 0c             	sub    $0xc,%esp
80102010:	68 40 16 11 80       	push   $0x80111640
80102015:	e8 d1 1d 00 00       	call   80103deb <release>
8010201a:	83 c4 10             	add    $0x10,%esp
}
8010201d:	eb ca                	jmp    80101fe9 <kfree+0x59>

8010201f <freerange>:
{
8010201f:	55                   	push   %ebp
80102020:	89 e5                	mov    %esp,%ebp
80102022:	56                   	push   %esi
80102023:	53                   	push   %ebx
80102024:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102027:	8b 45 08             	mov    0x8(%ebp),%eax
8010202a:	05 ff 0f 00 00       	add    $0xfff,%eax
8010202f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102034:	eb 0e                	jmp    80102044 <freerange+0x25>
    kfree(p);
80102036:	83 ec 0c             	sub    $0xc,%esp
80102039:	50                   	push   %eax
8010203a:	e8 51 ff ff ff       	call   80101f90 <kfree>
8010203f:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102042:	89 f0                	mov    %esi,%eax
80102044:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
8010204a:	39 f3                	cmp    %esi,%ebx
8010204c:	73 e8                	jae    80102036 <freerange+0x17>
}
8010204e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102051:	5b                   	pop    %ebx
80102052:	5e                   	pop    %esi
80102053:	5d                   	pop    %ebp
80102054:	c3                   	ret

80102055 <kinit1>:
{
80102055:	55                   	push   %ebp
80102056:	89 e5                	mov    %esp,%ebp
80102058:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
8010205b:	68 d2 6b 10 80       	push   $0x80106bd2
80102060:	68 40 16 11 80       	push   $0x80111640
80102065:	e8 dc 1b 00 00       	call   80103c46 <initlock>
  kmem.use_lock = 0;
8010206a:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102071:	00 00 00 
  freerange(vstart, vend);
80102074:	83 c4 08             	add    $0x8,%esp
80102077:	ff 75 0c             	push   0xc(%ebp)
8010207a:	ff 75 08             	push   0x8(%ebp)
8010207d:	e8 9d ff ff ff       	call   8010201f <freerange>
}
80102082:	83 c4 10             	add    $0x10,%esp
80102085:	c9                   	leave
80102086:	c3                   	ret

80102087 <kinit2>:
{
80102087:	55                   	push   %ebp
80102088:	89 e5                	mov    %esp,%ebp
8010208a:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
8010208d:	ff 75 0c             	push   0xc(%ebp)
80102090:	ff 75 08             	push   0x8(%ebp)
80102093:	e8 87 ff ff ff       	call   8010201f <freerange>
  kmem.use_lock = 1;
80102098:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010209f:	00 00 00 
}
801020a2:	83 c4 10             	add    $0x10,%esp
801020a5:	c9                   	leave
801020a6:	c3                   	ret

801020a7 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801020a7:	55                   	push   %ebp
801020a8:	89 e5                	mov    %esp,%ebp
801020aa:	53                   	push   %ebx
801020ab:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801020ae:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
801020b5:	75 21                	jne    801020d8 <kalloc+0x31>
    acquire(&kmem.lock);
  r = kmem.freelist;
801020b7:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
801020bd:	85 db                	test   %ebx,%ebx
801020bf:	74 07                	je     801020c8 <kalloc+0x21>
    kmem.freelist = r->next;
801020c1:	8b 03                	mov    (%ebx),%eax
801020c3:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
801020c8:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
801020cf:	75 19                	jne    801020ea <kalloc+0x43>
    release(&kmem.lock);
  return (char*)r;
}
801020d1:	89 d8                	mov    %ebx,%eax
801020d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020d6:	c9                   	leave
801020d7:	c3                   	ret
    acquire(&kmem.lock);
801020d8:	83 ec 0c             	sub    $0xc,%esp
801020db:	68 40 16 11 80       	push   $0x80111640
801020e0:	e8 a1 1c 00 00       	call   80103d86 <acquire>
801020e5:	83 c4 10             	add    $0x10,%esp
801020e8:	eb cd                	jmp    801020b7 <kalloc+0x10>
    release(&kmem.lock);
801020ea:	83 ec 0c             	sub    $0xc,%esp
801020ed:	68 40 16 11 80       	push   $0x80111640
801020f2:	e8 f4 1c 00 00       	call   80103deb <release>
801020f7:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801020fa:	eb d5                	jmp    801020d1 <kalloc+0x2a>

801020fc <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020fc:	ba 64 00 00 00       	mov    $0x64,%edx
80102101:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102102:	a8 01                	test   $0x1,%al
80102104:	0f 84 b3 00 00 00    	je     801021bd <kbdgetc+0xc1>
8010210a:	ba 60 00 00 00       	mov    $0x60,%edx
8010210f:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102110:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102113:	3c e0                	cmp    $0xe0,%al
80102115:	74 61                	je     80102178 <kbdgetc+0x7c>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102117:	84 c0                	test   %al,%al
80102119:	78 6a                	js     80102185 <kbdgetc+0x89>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010211b:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
80102121:	f6 c2 40             	test   $0x40,%dl
80102124:	74 0f                	je     80102135 <kbdgetc+0x39>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102126:	83 c8 80             	or     $0xffffff80,%eax
80102129:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
8010212c:	83 e2 bf             	and    $0xffffffbf,%edx
8010212f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  }

  shift |= shiftcode[data];
80102135:	0f b6 91 00 72 10 80 	movzbl -0x7fef8e00(%ecx),%edx
8010213c:	0b 15 7c 16 11 80    	or     0x8011167c,%edx
80102142:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  shift ^= togglecode[data];
80102148:	0f b6 81 00 71 10 80 	movzbl -0x7fef8f00(%ecx),%eax
8010214f:	31 c2                	xor    %eax,%edx
80102151:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102157:	89 d0                	mov    %edx,%eax
80102159:	83 e0 03             	and    $0x3,%eax
8010215c:	8b 04 85 e0 70 10 80 	mov    -0x7fef8f20(,%eax,4),%eax
80102163:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102167:	f6 c2 08             	test   $0x8,%dl
8010216a:	74 56                	je     801021c2 <kbdgetc+0xc6>
    if('a' <= c && c <= 'z')
8010216c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010216f:	83 fa 19             	cmp    $0x19,%edx
80102172:	77 3d                	ja     801021b1 <kbdgetc+0xb5>
      c += 'A' - 'a';
80102174:	83 e8 20             	sub    $0x20,%eax
80102177:	c3                   	ret
    shift |= E0ESC;
80102178:	83 0d 7c 16 11 80 40 	orl    $0x40,0x8011167c
    return 0;
8010217f:	b8 00 00 00 00       	mov    $0x0,%eax
80102184:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102185:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
8010218b:	f6 c2 40             	test   $0x40,%dl
8010218e:	75 05                	jne    80102195 <kbdgetc+0x99>
80102190:	89 c1                	mov    %eax,%ecx
80102192:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102195:	8a 81 00 72 10 80    	mov    -0x7fef8e00(%ecx),%al
8010219b:	83 c8 40             	or     $0x40,%eax
8010219e:	0f b6 c0             	movzbl %al,%eax
801021a1:	f7 d0                	not    %eax
801021a3:	21 c2                	and    %eax,%edx
801021a5:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
    return 0;
801021ab:	b8 00 00 00 00       	mov    $0x0,%eax
801021b0:	c3                   	ret
    else if('A' <= c && c <= 'Z')
801021b1:	8d 50 bf             	lea    -0x41(%eax),%edx
801021b4:	83 fa 19             	cmp    $0x19,%edx
801021b7:	77 09                	ja     801021c2 <kbdgetc+0xc6>
      c += 'a' - 'A';
801021b9:	83 c0 20             	add    $0x20,%eax
  }
  return c;
801021bc:	c3                   	ret
    return -1;
801021bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801021c2:	c3                   	ret

801021c3 <kbdintr>:

void
kbdintr(void)
{
801021c3:	55                   	push   %ebp
801021c4:	89 e5                	mov    %esp,%ebp
801021c6:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801021c9:	68 fc 20 10 80       	push   $0x801020fc
801021ce:	e8 2e e5 ff ff       	call   80100701 <consoleintr>
}
801021d3:	83 c4 10             	add    $0x10,%esp
801021d6:	c9                   	leave
801021d7:	c3                   	ret

801021d8 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801021d8:	8b 0d 80 16 11 80    	mov    0x80111680,%ecx
801021de:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801021e1:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
801021e3:	a1 80 16 11 80       	mov    0x80111680,%eax
801021e8:	8b 40 20             	mov    0x20(%eax),%eax
}
801021eb:	c3                   	ret

801021ec <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021ec:	ba 70 00 00 00       	mov    $0x70,%edx
801021f1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021f2:	ba 71 00 00 00       	mov    $0x71,%edx
801021f7:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801021f8:	0f b6 c0             	movzbl %al,%eax
}
801021fb:	c3                   	ret

801021fc <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801021fc:	55                   	push   %ebp
801021fd:	89 e5                	mov    %esp,%ebp
801021ff:	53                   	push   %ebx
80102200:	83 ec 04             	sub    $0x4,%esp
80102203:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
80102205:	b8 00 00 00 00       	mov    $0x0,%eax
8010220a:	e8 dd ff ff ff       	call   801021ec <cmos_read>
8010220f:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
80102211:	b8 02 00 00 00       	mov    $0x2,%eax
80102216:	e8 d1 ff ff ff       	call   801021ec <cmos_read>
8010221b:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
8010221e:	b8 04 00 00 00       	mov    $0x4,%eax
80102223:	e8 c4 ff ff ff       	call   801021ec <cmos_read>
80102228:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
8010222b:	b8 07 00 00 00       	mov    $0x7,%eax
80102230:	e8 b7 ff ff ff       	call   801021ec <cmos_read>
80102235:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
80102238:	b8 08 00 00 00       	mov    $0x8,%eax
8010223d:	e8 aa ff ff ff       	call   801021ec <cmos_read>
80102242:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
80102245:	b8 09 00 00 00       	mov    $0x9,%eax
8010224a:	e8 9d ff ff ff       	call   801021ec <cmos_read>
8010224f:	89 43 14             	mov    %eax,0x14(%ebx)
}
80102252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102255:	c9                   	leave
80102256:	c3                   	ret

80102257 <lapicinit>:
  if(!lapic)
80102257:	83 3d 80 16 11 80 00 	cmpl   $0x0,0x80111680
8010225e:	0f 84 fe 00 00 00    	je     80102362 <lapicinit+0x10b>
{
80102264:	55                   	push   %ebp
80102265:	89 e5                	mov    %esp,%ebp
80102267:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
8010226a:	ba 3f 01 00 00       	mov    $0x13f,%edx
8010226f:	b8 3c 00 00 00       	mov    $0x3c,%eax
80102274:	e8 5f ff ff ff       	call   801021d8 <lapicw>
  lapicw(TDCR, X1);
80102279:	ba 0b 00 00 00       	mov    $0xb,%edx
8010227e:	b8 f8 00 00 00       	mov    $0xf8,%eax
80102283:	e8 50 ff ff ff       	call   801021d8 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102288:	ba 20 00 02 00       	mov    $0x20020,%edx
8010228d:	b8 c8 00 00 00       	mov    $0xc8,%eax
80102292:	e8 41 ff ff ff       	call   801021d8 <lapicw>
  lapicw(TICR, 10000000);
80102297:	ba 80 96 98 00       	mov    $0x989680,%edx
8010229c:	b8 e0 00 00 00       	mov    $0xe0,%eax
801022a1:	e8 32 ff ff ff       	call   801021d8 <lapicw>
  lapicw(LINT0, MASKED);
801022a6:	ba 00 00 01 00       	mov    $0x10000,%edx
801022ab:	b8 d4 00 00 00       	mov    $0xd4,%eax
801022b0:	e8 23 ff ff ff       	call   801021d8 <lapicw>
  lapicw(LINT1, MASKED);
801022b5:	ba 00 00 01 00       	mov    $0x10000,%edx
801022ba:	b8 d8 00 00 00       	mov    $0xd8,%eax
801022bf:	e8 14 ff ff ff       	call   801021d8 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801022c4:	a1 80 16 11 80       	mov    0x80111680,%eax
801022c9:	8b 40 30             	mov    0x30(%eax),%eax
801022cc:	a9 00 00 fc 00       	test   $0xfc0000,%eax
801022d1:	75 7b                	jne    8010234e <lapicinit+0xf7>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801022d3:	ba 33 00 00 00       	mov    $0x33,%edx
801022d8:	b8 dc 00 00 00       	mov    $0xdc,%eax
801022dd:	e8 f6 fe ff ff       	call   801021d8 <lapicw>
  lapicw(ESR, 0);
801022e2:	ba 00 00 00 00       	mov    $0x0,%edx
801022e7:	b8 a0 00 00 00       	mov    $0xa0,%eax
801022ec:	e8 e7 fe ff ff       	call   801021d8 <lapicw>
  lapicw(ESR, 0);
801022f1:	ba 00 00 00 00       	mov    $0x0,%edx
801022f6:	b8 a0 00 00 00       	mov    $0xa0,%eax
801022fb:	e8 d8 fe ff ff       	call   801021d8 <lapicw>
  lapicw(EOI, 0);
80102300:	ba 00 00 00 00       	mov    $0x0,%edx
80102305:	b8 2c 00 00 00       	mov    $0x2c,%eax
8010230a:	e8 c9 fe ff ff       	call   801021d8 <lapicw>
  lapicw(ICRHI, 0);
8010230f:	ba 00 00 00 00       	mov    $0x0,%edx
80102314:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102319:	e8 ba fe ff ff       	call   801021d8 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010231e:	ba 00 85 08 00       	mov    $0x88500,%edx
80102323:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102328:	e8 ab fe ff ff       	call   801021d8 <lapicw>
  while(lapic[ICRLO] & DELIVS)
8010232d:	a1 80 16 11 80       	mov    0x80111680,%eax
80102332:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
80102338:	f6 c4 10             	test   $0x10,%ah
8010233b:	75 f0                	jne    8010232d <lapicinit+0xd6>
  lapicw(TPR, 0);
8010233d:	ba 00 00 00 00       	mov    $0x0,%edx
80102342:	b8 20 00 00 00       	mov    $0x20,%eax
80102347:	e8 8c fe ff ff       	call   801021d8 <lapicw>
}
8010234c:	c9                   	leave
8010234d:	c3                   	ret
    lapicw(PCINT, MASKED);
8010234e:	ba 00 00 01 00       	mov    $0x10000,%edx
80102353:	b8 d0 00 00 00       	mov    $0xd0,%eax
80102358:	e8 7b fe ff ff       	call   801021d8 <lapicw>
8010235d:	e9 71 ff ff ff       	jmp    801022d3 <lapicinit+0x7c>
80102362:	c3                   	ret

80102363 <lapicid>:
  if (!lapic)
80102363:	a1 80 16 11 80       	mov    0x80111680,%eax
80102368:	85 c0                	test   %eax,%eax
8010236a:	74 07                	je     80102373 <lapicid+0x10>
  return lapic[ID] >> 24;
8010236c:	8b 40 20             	mov    0x20(%eax),%eax
8010236f:	c1 e8 18             	shr    $0x18,%eax
80102372:	c3                   	ret
    return 0;
80102373:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102378:	c3                   	ret

80102379 <lapiceoi>:
  if(lapic)
80102379:	83 3d 80 16 11 80 00 	cmpl   $0x0,0x80111680
80102380:	74 17                	je     80102399 <lapiceoi+0x20>
{
80102382:	55                   	push   %ebp
80102383:	89 e5                	mov    %esp,%ebp
80102385:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
80102388:	ba 00 00 00 00       	mov    $0x0,%edx
8010238d:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102392:	e8 41 fe ff ff       	call   801021d8 <lapicw>
}
80102397:	c9                   	leave
80102398:	c3                   	ret
80102399:	c3                   	ret

8010239a <microdelay>:
}
8010239a:	c3                   	ret

8010239b <lapicstartap>:
{
8010239b:	55                   	push   %ebp
8010239c:	89 e5                	mov    %esp,%ebp
8010239e:	57                   	push   %edi
8010239f:	56                   	push   %esi
801023a0:	53                   	push   %ebx
801023a1:	83 ec 0c             	sub    $0xc,%esp
801023a4:	8b 75 08             	mov    0x8(%ebp),%esi
801023a7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023aa:	b0 0f                	mov    $0xf,%al
801023ac:	ba 70 00 00 00       	mov    $0x70,%edx
801023b1:	ee                   	out    %al,(%dx)
801023b2:	b0 0a                	mov    $0xa,%al
801023b4:	ba 71 00 00 00       	mov    $0x71,%edx
801023b9:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801023ba:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801023c1:	00 00 
  wrv[1] = addr >> 4;
801023c3:	89 f8                	mov    %edi,%eax
801023c5:	c1 e8 04             	shr    $0x4,%eax
801023c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
801023ce:	c1 e6 18             	shl    $0x18,%esi
801023d1:	89 f2                	mov    %esi,%edx
801023d3:	b8 c4 00 00 00       	mov    $0xc4,%eax
801023d8:	e8 fb fd ff ff       	call   801021d8 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801023dd:	ba 00 c5 00 00       	mov    $0xc500,%edx
801023e2:	b8 c0 00 00 00       	mov    $0xc0,%eax
801023e7:	e8 ec fd ff ff       	call   801021d8 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
801023ec:	ba 00 85 00 00       	mov    $0x8500,%edx
801023f1:	b8 c0 00 00 00       	mov    $0xc0,%eax
801023f6:	e8 dd fd ff ff       	call   801021d8 <lapicw>
  for(i = 0; i < 2; i++){
801023fb:	bb 00 00 00 00       	mov    $0x0,%ebx
80102400:	eb 1f                	jmp    80102421 <lapicstartap+0x86>
    lapicw(ICRHI, apicid<<24);
80102402:	89 f2                	mov    %esi,%edx
80102404:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102409:	e8 ca fd ff ff       	call   801021d8 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010240e:	89 fa                	mov    %edi,%edx
80102410:	c1 ea 0c             	shr    $0xc,%edx
80102413:	80 ce 06             	or     $0x6,%dh
80102416:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010241b:	e8 b8 fd ff ff       	call   801021d8 <lapicw>
  for(i = 0; i < 2; i++){
80102420:	43                   	inc    %ebx
80102421:	83 fb 01             	cmp    $0x1,%ebx
80102424:	7e dc                	jle    80102402 <lapicstartap+0x67>
}
80102426:	83 c4 0c             	add    $0xc,%esp
80102429:	5b                   	pop    %ebx
8010242a:	5e                   	pop    %esi
8010242b:	5f                   	pop    %edi
8010242c:	5d                   	pop    %ebp
8010242d:	c3                   	ret

8010242e <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
8010242e:	55                   	push   %ebp
8010242f:	89 e5                	mov    %esp,%ebp
80102431:	57                   	push   %edi
80102432:	56                   	push   %esi
80102433:	53                   	push   %ebx
80102434:	83 ec 3c             	sub    $0x3c,%esp
80102437:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010243a:	b8 0b 00 00 00       	mov    $0xb,%eax
8010243f:	e8 a8 fd ff ff       	call   801021ec <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
80102444:	83 e0 04             	and    $0x4,%eax
80102447:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102449:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010244c:	e8 ab fd ff ff       	call   801021fc <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102451:	b8 0a 00 00 00       	mov    $0xa,%eax
80102456:	e8 91 fd ff ff       	call   801021ec <cmos_read>
8010245b:	a8 80                	test   $0x80,%al
8010245d:	75 ea                	jne    80102449 <cmostime+0x1b>
        continue;
    fill_rtcdate(&t2);
8010245f:	8d 75 b8             	lea    -0x48(%ebp),%esi
80102462:	89 f0                	mov    %esi,%eax
80102464:	e8 93 fd ff ff       	call   801021fc <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102469:	83 ec 04             	sub    $0x4,%esp
8010246c:	6a 18                	push   $0x18
8010246e:	56                   	push   %esi
8010246f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102472:	50                   	push   %eax
80102473:	e8 01 1a 00 00       	call   80103e79 <memcmp>
80102478:	83 c4 10             	add    $0x10,%esp
8010247b:	85 c0                	test   %eax,%eax
8010247d:	75 ca                	jne    80102449 <cmostime+0x1b>
      break;
  }

  // convert
  if(bcd) {
8010247f:	85 ff                	test   %edi,%edi
80102481:	75 7e                	jne    80102501 <cmostime+0xd3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102483:	8b 55 d0             	mov    -0x30(%ebp),%edx
80102486:	89 d0                	mov    %edx,%eax
80102488:	c1 e8 04             	shr    $0x4,%eax
8010248b:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010248e:	01 c0                	add    %eax,%eax
80102490:	83 e2 0f             	and    $0xf,%edx
80102493:	01 d0                	add    %edx,%eax
80102495:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
80102498:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010249b:	89 d0                	mov    %edx,%eax
8010249d:	c1 e8 04             	shr    $0x4,%eax
801024a0:	8d 04 80             	lea    (%eax,%eax,4),%eax
801024a3:	01 c0                	add    %eax,%eax
801024a5:	83 e2 0f             	and    $0xf,%edx
801024a8:	01 d0                	add    %edx,%eax
801024aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
801024ad:	8b 55 d8             	mov    -0x28(%ebp),%edx
801024b0:	89 d0                	mov    %edx,%eax
801024b2:	c1 e8 04             	shr    $0x4,%eax
801024b5:	8d 04 80             	lea    (%eax,%eax,4),%eax
801024b8:	01 c0                	add    %eax,%eax
801024ba:	83 e2 0f             	and    $0xf,%edx
801024bd:	01 d0                	add    %edx,%eax
801024bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
801024c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801024c5:	89 d0                	mov    %edx,%eax
801024c7:	c1 e8 04             	shr    $0x4,%eax
801024ca:	8d 04 80             	lea    (%eax,%eax,4),%eax
801024cd:	01 c0                	add    %eax,%eax
801024cf:	83 e2 0f             	and    $0xf,%edx
801024d2:	01 d0                	add    %edx,%eax
801024d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801024d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801024da:	89 d0                	mov    %edx,%eax
801024dc:	c1 e8 04             	shr    $0x4,%eax
801024df:	8d 04 80             	lea    (%eax,%eax,4),%eax
801024e2:	01 c0                	add    %eax,%eax
801024e4:	83 e2 0f             	and    $0xf,%edx
801024e7:	01 d0                	add    %edx,%eax
801024e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801024ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801024ef:	89 d0                	mov    %edx,%eax
801024f1:	c1 e8 04             	shr    $0x4,%eax
801024f4:	8d 04 80             	lea    (%eax,%eax,4),%eax
801024f7:	01 c0                	add    %eax,%eax
801024f9:	83 e2 0f             	and    $0xf,%edx
801024fc:	01 d0                	add    %edx,%eax
801024fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
80102501:	8d 75 d0             	lea    -0x30(%ebp),%esi
80102504:	b9 06 00 00 00       	mov    $0x6,%ecx
80102509:	89 df                	mov    %ebx,%edi
8010250b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
8010250d:	8b 43 14             	mov    0x14(%ebx),%eax
80102510:	05 d0 07 00 00       	add    $0x7d0,%eax
80102515:	89 43 14             	mov    %eax,0x14(%ebx)
}
80102518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010251b:	5b                   	pop    %ebx
8010251c:	5e                   	pop    %esi
8010251d:	5f                   	pop    %edi
8010251e:	5d                   	pop    %ebp
8010251f:	c3                   	ret

80102520 <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	53                   	push   %ebx
80102524:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102527:	ff 35 d4 16 11 80    	push   0x801116d4
8010252d:	ff 35 e4 16 11 80    	push   0x801116e4
80102533:	e8 32 dc ff ff       	call   8010016a <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102538:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010253b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102541:	83 c4 10             	add    $0x10,%esp
80102544:	ba 00 00 00 00       	mov    $0x0,%edx
80102549:	eb 0c                	jmp    80102557 <read_head+0x37>
    log.lh.block[i] = lh->block[i];
8010254b:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
8010254f:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102556:	42                   	inc    %edx
80102557:	39 d3                	cmp    %edx,%ebx
80102559:	7f f0                	jg     8010254b <read_head+0x2b>
  }
  brelse(buf);
8010255b:	83 ec 0c             	sub    $0xc,%esp
8010255e:	50                   	push   %eax
8010255f:	e8 73 dc ff ff       	call   801001d7 <brelse>
}
80102564:	83 c4 10             	add    $0x10,%esp
80102567:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010256a:	c9                   	leave
8010256b:	c3                   	ret

8010256c <install_trans>:
{
8010256c:	55                   	push   %ebp
8010256d:	89 e5                	mov    %esp,%ebp
8010256f:	57                   	push   %edi
80102570:	56                   	push   %esi
80102571:	53                   	push   %ebx
80102572:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102575:	be 00 00 00 00       	mov    $0x0,%esi
8010257a:	eb 62                	jmp    801025de <install_trans+0x72>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010257c:	89 f0                	mov    %esi,%eax
8010257e:	03 05 d4 16 11 80    	add    0x801116d4,%eax
80102584:	40                   	inc    %eax
80102585:	83 ec 08             	sub    $0x8,%esp
80102588:	50                   	push   %eax
80102589:	ff 35 e4 16 11 80    	push   0x801116e4
8010258f:	e8 d6 db ff ff       	call   8010016a <bread>
80102594:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102596:	83 c4 08             	add    $0x8,%esp
80102599:	ff 34 b5 ec 16 11 80 	push   -0x7feee914(,%esi,4)
801025a0:	ff 35 e4 16 11 80    	push   0x801116e4
801025a6:	e8 bf db ff ff       	call   8010016a <bread>
801025ab:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801025ad:	8d 57 5c             	lea    0x5c(%edi),%edx
801025b0:	8d 40 5c             	lea    0x5c(%eax),%eax
801025b3:	83 c4 0c             	add    $0xc,%esp
801025b6:	68 00 02 00 00       	push   $0x200
801025bb:	52                   	push   %edx
801025bc:	50                   	push   %eax
801025bd:	e8 e6 18 00 00       	call   80103ea8 <memmove>
    bwrite(dbuf);  // write dst to disk
801025c2:	89 1c 24             	mov    %ebx,(%esp)
801025c5:	e8 ce db ff ff       	call   80100198 <bwrite>
    brelse(lbuf);
801025ca:	89 3c 24             	mov    %edi,(%esp)
801025cd:	e8 05 dc ff ff       	call   801001d7 <brelse>
    brelse(dbuf);
801025d2:	89 1c 24             	mov    %ebx,(%esp)
801025d5:	e8 fd db ff ff       	call   801001d7 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801025da:	46                   	inc    %esi
801025db:	83 c4 10             	add    $0x10,%esp
801025de:	39 35 e8 16 11 80    	cmp    %esi,0x801116e8
801025e4:	7f 96                	jg     8010257c <install_trans+0x10>
}
801025e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025e9:	5b                   	pop    %ebx
801025ea:	5e                   	pop    %esi
801025eb:	5f                   	pop    %edi
801025ec:	5d                   	pop    %ebp
801025ed:	c3                   	ret

801025ee <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801025ee:	55                   	push   %ebp
801025ef:	89 e5                	mov    %esp,%ebp
801025f1:	53                   	push   %ebx
801025f2:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801025f5:	ff 35 d4 16 11 80    	push   0x801116d4
801025fb:	ff 35 e4 16 11 80    	push   0x801116e4
80102601:	e8 64 db ff ff       	call   8010016a <bread>
80102606:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102608:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
8010260e:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102611:	83 c4 10             	add    $0x10,%esp
80102614:	b8 00 00 00 00       	mov    $0x0,%eax
80102619:	eb 0c                	jmp    80102627 <write_head+0x39>
    hb->block[i] = log.lh.block[i];
8010261b:	8b 14 85 ec 16 11 80 	mov    -0x7feee914(,%eax,4),%edx
80102622:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102626:	40                   	inc    %eax
80102627:	39 c1                	cmp    %eax,%ecx
80102629:	7f f0                	jg     8010261b <write_head+0x2d>
  }
  bwrite(buf);
8010262b:	83 ec 0c             	sub    $0xc,%esp
8010262e:	53                   	push   %ebx
8010262f:	e8 64 db ff ff       	call   80100198 <bwrite>
  brelse(buf);
80102634:	89 1c 24             	mov    %ebx,(%esp)
80102637:	e8 9b db ff ff       	call   801001d7 <brelse>
}
8010263c:	83 c4 10             	add    $0x10,%esp
8010263f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102642:	c9                   	leave
80102643:	c3                   	ret

80102644 <recover_from_log>:

static void
recover_from_log(void)
{
80102644:	55                   	push   %ebp
80102645:	89 e5                	mov    %esp,%ebp
80102647:	83 ec 08             	sub    $0x8,%esp
  read_head();
8010264a:	e8 d1 fe ff ff       	call   80102520 <read_head>
  install_trans(); // if committed, copy from log to disk
8010264f:	e8 18 ff ff ff       	call   8010256c <install_trans>
  log.lh.n = 0;
80102654:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
8010265b:	00 00 00 
  write_head(); // clear the log
8010265e:	e8 8b ff ff ff       	call   801025ee <write_head>
}
80102663:	c9                   	leave
80102664:	c3                   	ret

80102665 <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80102665:	55                   	push   %ebp
80102666:	89 e5                	mov    %esp,%ebp
80102668:	57                   	push   %edi
80102669:	56                   	push   %esi
8010266a:	53                   	push   %ebx
8010266b:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010266e:	be 00 00 00 00       	mov    $0x0,%esi
80102673:	eb 62                	jmp    801026d7 <write_log+0x72>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102675:	89 f0                	mov    %esi,%eax
80102677:	03 05 d4 16 11 80    	add    0x801116d4,%eax
8010267d:	40                   	inc    %eax
8010267e:	83 ec 08             	sub    $0x8,%esp
80102681:	50                   	push   %eax
80102682:	ff 35 e4 16 11 80    	push   0x801116e4
80102688:	e8 dd da ff ff       	call   8010016a <bread>
8010268d:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010268f:	83 c4 08             	add    $0x8,%esp
80102692:	ff 34 b5 ec 16 11 80 	push   -0x7feee914(,%esi,4)
80102699:	ff 35 e4 16 11 80    	push   0x801116e4
8010269f:	e8 c6 da ff ff       	call   8010016a <bread>
801026a4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801026a6:	8d 50 5c             	lea    0x5c(%eax),%edx
801026a9:	8d 43 5c             	lea    0x5c(%ebx),%eax
801026ac:	83 c4 0c             	add    $0xc,%esp
801026af:	68 00 02 00 00       	push   $0x200
801026b4:	52                   	push   %edx
801026b5:	50                   	push   %eax
801026b6:	e8 ed 17 00 00       	call   80103ea8 <memmove>
    bwrite(to);  // write the log
801026bb:	89 1c 24             	mov    %ebx,(%esp)
801026be:	e8 d5 da ff ff       	call   80100198 <bwrite>
    brelse(from);
801026c3:	89 3c 24             	mov    %edi,(%esp)
801026c6:	e8 0c db ff ff       	call   801001d7 <brelse>
    brelse(to);
801026cb:	89 1c 24             	mov    %ebx,(%esp)
801026ce:	e8 04 db ff ff       	call   801001d7 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801026d3:	46                   	inc    %esi
801026d4:	83 c4 10             	add    $0x10,%esp
801026d7:	39 35 e8 16 11 80    	cmp    %esi,0x801116e8
801026dd:	7f 96                	jg     80102675 <write_log+0x10>
  }
}
801026df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026e2:	5b                   	pop    %ebx
801026e3:	5e                   	pop    %esi
801026e4:	5f                   	pop    %edi
801026e5:	5d                   	pop    %ebp
801026e6:	c3                   	ret

801026e7 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
801026e7:	83 3d e8 16 11 80 00 	cmpl   $0x0,0x801116e8
801026ee:	7f 01                	jg     801026f1 <commit+0xa>
801026f0:	c3                   	ret
{
801026f1:	55                   	push   %ebp
801026f2:	89 e5                	mov    %esp,%ebp
801026f4:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
801026f7:	e8 69 ff ff ff       	call   80102665 <write_log>
    write_head();    // Write header to disk -- the real commit
801026fc:	e8 ed fe ff ff       	call   801025ee <write_head>
    install_trans(); // Now install writes to home locations
80102701:	e8 66 fe ff ff       	call   8010256c <install_trans>
    log.lh.n = 0;
80102706:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
8010270d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102710:	e8 d9 fe ff ff       	call   801025ee <write_head>
  }
}
80102715:	c9                   	leave
80102716:	c3                   	ret

80102717 <initlog>:
{
80102717:	55                   	push   %ebp
80102718:	89 e5                	mov    %esp,%ebp
8010271a:	53                   	push   %ebx
8010271b:	83 ec 2c             	sub    $0x2c,%esp
8010271e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102721:	68 d7 6b 10 80       	push   $0x80106bd7
80102726:	68 a0 16 11 80       	push   $0x801116a0
8010272b:	e8 16 15 00 00       	call   80103c46 <initlock>
  readsb(dev, &sb);
80102730:	83 c4 08             	add    $0x8,%esp
80102733:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102736:	50                   	push   %eax
80102737:	53                   	push   %ebx
80102738:	e8 fd ea ff ff       	call   8010123a <readsb>
  log.start = sb.logstart;
8010273d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102740:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102745:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102748:	a3 d8 16 11 80       	mov    %eax,0x801116d8
  log.dev = dev;
8010274d:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  recover_from_log();
80102753:	e8 ec fe ff ff       	call   80102644 <recover_from_log>
}
80102758:	83 c4 10             	add    $0x10,%esp
8010275b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010275e:	c9                   	leave
8010275f:	c3                   	ret

80102760 <begin_op>:
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102766:	68 a0 16 11 80       	push   $0x801116a0
8010276b:	e8 16 16 00 00       	call   80103d86 <acquire>
80102770:	83 c4 10             	add    $0x10,%esp
80102773:	eb 15                	jmp    8010278a <begin_op+0x2a>
      sleep(&log, &log.lock);
80102775:	83 ec 08             	sub    $0x8,%esp
80102778:	68 a0 16 11 80       	push   $0x801116a0
8010277d:	68 a0 16 11 80       	push   $0x801116a0
80102782:	e8 e6 0f 00 00       	call   8010376d <sleep>
80102787:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010278a:	83 3d e0 16 11 80 00 	cmpl   $0x0,0x801116e0
80102791:	75 e2                	jne    80102775 <begin_op+0x15>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102793:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102798:	8d 48 01             	lea    0x1(%eax),%ecx
8010279b:	8d 54 80 05          	lea    0x5(%eax,%eax,4),%edx
8010279f:	8d 04 12             	lea    (%edx,%edx,1),%eax
801027a2:	03 05 e8 16 11 80    	add    0x801116e8,%eax
801027a8:	83 f8 1e             	cmp    $0x1e,%eax
801027ab:	7e 17                	jle    801027c4 <begin_op+0x64>
      sleep(&log, &log.lock);
801027ad:	83 ec 08             	sub    $0x8,%esp
801027b0:	68 a0 16 11 80       	push   $0x801116a0
801027b5:	68 a0 16 11 80       	push   $0x801116a0
801027ba:	e8 ae 0f 00 00       	call   8010376d <sleep>
801027bf:	83 c4 10             	add    $0x10,%esp
801027c2:	eb c6                	jmp    8010278a <begin_op+0x2a>
      log.outstanding += 1;
801027c4:	89 0d dc 16 11 80    	mov    %ecx,0x801116dc
      release(&log.lock);
801027ca:	83 ec 0c             	sub    $0xc,%esp
801027cd:	68 a0 16 11 80       	push   $0x801116a0
801027d2:	e8 14 16 00 00       	call   80103deb <release>
}
801027d7:	83 c4 10             	add    $0x10,%esp
801027da:	c9                   	leave
801027db:	c3                   	ret

801027dc <end_op>:
{
801027dc:	55                   	push   %ebp
801027dd:	89 e5                	mov    %esp,%ebp
801027df:	53                   	push   %ebx
801027e0:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
801027e3:	68 a0 16 11 80       	push   $0x801116a0
801027e8:	e8 99 15 00 00       	call   80103d86 <acquire>
  log.outstanding -= 1;
801027ed:	a1 dc 16 11 80       	mov    0x801116dc,%eax
801027f2:	48                   	dec    %eax
801027f3:	a3 dc 16 11 80       	mov    %eax,0x801116dc
  if(log.committing)
801027f8:	8b 1d e0 16 11 80    	mov    0x801116e0,%ebx
801027fe:	83 c4 10             	add    $0x10,%esp
80102801:	85 db                	test   %ebx,%ebx
80102803:	75 2c                	jne    80102831 <end_op+0x55>
  if(log.outstanding == 0){
80102805:	85 c0                	test   %eax,%eax
80102807:	75 35                	jne    8010283e <end_op+0x62>
    log.committing = 1;
80102809:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102810:	00 00 00 
    do_commit = 1;
80102813:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
80102818:	83 ec 0c             	sub    $0xc,%esp
8010281b:	68 a0 16 11 80       	push   $0x801116a0
80102820:	e8 c6 15 00 00       	call   80103deb <release>
  if(do_commit){
80102825:	83 c4 10             	add    $0x10,%esp
80102828:	85 db                	test   %ebx,%ebx
8010282a:	75 24                	jne    80102850 <end_op+0x74>
}
8010282c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010282f:	c9                   	leave
80102830:	c3                   	ret
    panic("log.committing");
80102831:	83 ec 0c             	sub    $0xc,%esp
80102834:	68 db 6b 10 80       	push   $0x80106bdb
80102839:	e8 06 db ff ff       	call   80100344 <panic>
    wakeup(&log);
8010283e:	83 ec 0c             	sub    $0xc,%esp
80102841:	68 a0 16 11 80       	push   $0x801116a0
80102846:	e8 9d 10 00 00       	call   801038e8 <wakeup>
8010284b:	83 c4 10             	add    $0x10,%esp
8010284e:	eb c8                	jmp    80102818 <end_op+0x3c>
    commit();
80102850:	e8 92 fe ff ff       	call   801026e7 <commit>
    acquire(&log.lock);
80102855:	83 ec 0c             	sub    $0xc,%esp
80102858:	68 a0 16 11 80       	push   $0x801116a0
8010285d:	e8 24 15 00 00       	call   80103d86 <acquire>
    log.committing = 0;
80102862:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102869:	00 00 00 
    wakeup(&log);
8010286c:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102873:	e8 70 10 00 00       	call   801038e8 <wakeup>
    release(&log.lock);
80102878:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
8010287f:	e8 67 15 00 00       	call   80103deb <release>
80102884:	83 c4 10             	add    $0x10,%esp
}
80102887:	eb a3                	jmp    8010282c <end_op+0x50>

80102889 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102889:	55                   	push   %ebp
8010288a:	89 e5                	mov    %esp,%ebp
8010288c:	53                   	push   %ebx
8010288d:	83 ec 04             	sub    $0x4,%esp
80102890:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102893:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102899:	83 fa 1d             	cmp    $0x1d,%edx
8010289c:	7f 2a                	jg     801028c8 <log_write+0x3f>
8010289e:	a1 d8 16 11 80       	mov    0x801116d8,%eax
801028a3:	48                   	dec    %eax
801028a4:	39 c2                	cmp    %eax,%edx
801028a6:	7d 20                	jge    801028c8 <log_write+0x3f>
    panic("too big a transaction");
  if (log.outstanding < 1)
801028a8:	83 3d dc 16 11 80 00 	cmpl   $0x0,0x801116dc
801028af:	7e 24                	jle    801028d5 <log_write+0x4c>
    panic("log_write outside of trans");

  acquire(&log.lock);
801028b1:	83 ec 0c             	sub    $0xc,%esp
801028b4:	68 a0 16 11 80       	push   $0x801116a0
801028b9:	e8 c8 14 00 00       	call   80103d86 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801028be:	83 c4 10             	add    $0x10,%esp
801028c1:	b8 00 00 00 00       	mov    $0x0,%eax
801028c6:	eb 1b                	jmp    801028e3 <log_write+0x5a>
    panic("too big a transaction");
801028c8:	83 ec 0c             	sub    $0xc,%esp
801028cb:	68 ea 6b 10 80       	push   $0x80106bea
801028d0:	e8 6f da ff ff       	call   80100344 <panic>
    panic("log_write outside of trans");
801028d5:	83 ec 0c             	sub    $0xc,%esp
801028d8:	68 00 6c 10 80       	push   $0x80106c00
801028dd:	e8 62 da ff ff       	call   80100344 <panic>
  for (i = 0; i < log.lh.n; i++) {
801028e2:	40                   	inc    %eax
801028e3:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
801028e9:	39 c2                	cmp    %eax,%edx
801028eb:	7e 0c                	jle    801028f9 <log_write+0x70>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801028ed:	8b 4b 08             	mov    0x8(%ebx),%ecx
801028f0:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
801028f7:	75 e9                	jne    801028e2 <log_write+0x59>
      break;
  }
  log.lh.block[i] = b->blockno;
801028f9:	8b 4b 08             	mov    0x8(%ebx),%ecx
801028fc:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80102903:	39 c2                	cmp    %eax,%edx
80102905:	74 1c                	je     80102923 <log_write+0x9a>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102907:	8b 03                	mov    (%ebx),%eax
80102909:	83 c8 04             	or     $0x4,%eax
8010290c:	89 03                	mov    %eax,(%ebx)
  release(&log.lock);
8010290e:	83 ec 0c             	sub    $0xc,%esp
80102911:	68 a0 16 11 80       	push   $0x801116a0
80102916:	e8 d0 14 00 00       	call   80103deb <release>
}
8010291b:	83 c4 10             	add    $0x10,%esp
8010291e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102921:	c9                   	leave
80102922:	c3                   	ret
    log.lh.n++;
80102923:	42                   	inc    %edx
80102924:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
8010292a:	eb db                	jmp    80102907 <log_write+0x7e>

8010292c <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010292c:	55                   	push   %ebp
8010292d:	89 e5                	mov    %esp,%ebp
8010292f:	53                   	push   %ebx
80102930:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102933:	68 8e 00 00 00       	push   $0x8e
80102938:	68 8c a4 10 80       	push   $0x8010a48c
8010293d:	68 00 70 00 80       	push   $0x80007000
80102942:	e8 61 15 00 00       	call   80103ea8 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102947:	83 c4 10             	add    $0x10,%esp
8010294a:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
8010294f:	eb 06                	jmp    80102957 <startothers+0x2b>
80102951:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102957:	8b 15 84 17 11 80    	mov    0x80111784,%edx
8010295d:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102960:	01 c0                	add    %eax,%eax
80102962:	01 d0                	add    %edx,%eax
80102964:	c1 e0 04             	shl    $0x4,%eax
80102967:	05 a0 17 11 80       	add    $0x801117a0,%eax
8010296c:	39 c3                	cmp    %eax,%ebx
8010296e:	73 4c                	jae    801029bc <startothers+0x90>
    if(c == mycpu())  // We've started already.
80102970:	e8 7f 08 00 00       	call   801031f4 <mycpu>
80102975:	39 c3                	cmp    %eax,%ebx
80102977:	74 d8                	je     80102951 <startothers+0x25>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102979:	e8 29 f7 ff ff       	call   801020a7 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010297e:	05 00 10 00 00       	add    $0x1000,%eax
80102983:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102988:	c7 05 f8 6f 00 80 00 	movl   $0x80102a00,0x80006ff8
8010298f:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102992:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102999:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
8010299c:	83 ec 08             	sub    $0x8,%esp
8010299f:	68 00 70 00 00       	push   $0x7000
801029a4:	0f b6 03             	movzbl (%ebx),%eax
801029a7:	50                   	push   %eax
801029a8:	e8 ee f9 ff ff       	call   8010239b <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801029ad:	83 c4 10             	add    $0x10,%esp
801029b0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801029b6:	85 c0                	test   %eax,%eax
801029b8:	74 f6                	je     801029b0 <startothers+0x84>
801029ba:	eb 95                	jmp    80102951 <startothers+0x25>
      ;
  }
}
801029bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029bf:	c9                   	leave
801029c0:	c3                   	ret

801029c1 <mpmain>:
{
801029c1:	55                   	push   %ebp
801029c2:	89 e5                	mov    %esp,%ebp
801029c4:	53                   	push   %ebx
801029c5:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801029c8:	e8 8b 08 00 00       	call   80103258 <cpuid>
801029cd:	89 c3                	mov    %eax,%ebx
801029cf:	e8 84 08 00 00       	call   80103258 <cpuid>
801029d4:	83 ec 04             	sub    $0x4,%esp
801029d7:	53                   	push   %ebx
801029d8:	50                   	push   %eax
801029d9:	68 1b 6c 10 80       	push   $0x80106c1b
801029de:	e8 fc db ff ff       	call   801005df <cprintf>
  idtinit();       // load idt register
801029e3:	e8 23 27 00 00       	call   8010510b <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801029e8:	e8 07 08 00 00       	call   801031f4 <mycpu>
801029ed:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801029ef:	b8 01 00 00 00       	mov    $0x1,%eax
801029f4:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801029fb:	e8 1d 0b 00 00       	call   8010351d <scheduler>

80102a00 <mpenter>:
{
80102a00:	55                   	push   %ebp
80102a01:	89 e5                	mov    %esp,%ebp
80102a03:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102a06:	e8 68 39 00 00       	call   80106373 <switchkvm>
  seginit();
80102a0b:	e8 1c 36 00 00       	call   8010602c <seginit>
  lapicinit();
80102a10:	e8 42 f8 ff ff       	call   80102257 <lapicinit>
  mpmain();
80102a15:	e8 a7 ff ff ff       	call   801029c1 <mpmain>

80102a1a <main>:
{
80102a1a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102a1e:	83 e4 f0             	and    $0xfffffff0,%esp
80102a21:	ff 71 fc             	push   -0x4(%ecx)
80102a24:	55                   	push   %ebp
80102a25:	89 e5                	mov    %esp,%ebp
80102a27:	51                   	push   %ecx
80102a28:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102a2b:	68 00 00 40 80       	push   $0x80400000
80102a30:	68 30 58 11 80       	push   $0x80115830
80102a35:	e8 1b f6 ff ff       	call   80102055 <kinit1>
  kvmalloc();      // kernel page table
80102a3a:	e8 ee 3d 00 00       	call   8010682d <kvmalloc>
  mpinit();        // detect other processors
80102a3f:	e8 b8 01 00 00       	call   80102bfc <mpinit>
  lapicinit();     // interrupt controller
80102a44:	e8 0e f8 ff ff       	call   80102257 <lapicinit>
  seginit();       // segment descriptors
80102a49:	e8 de 35 00 00       	call   8010602c <seginit>
  picinit();       // disable pic
80102a4e:	e8 79 02 00 00       	call   80102ccc <picinit>
  ioapicinit();    // another interrupt controller
80102a53:	e8 8b f4 ff ff       	call   80101ee3 <ioapicinit>
  consoleinit();   // console hardware
80102a58:	e8 e9 dd ff ff       	call   80100846 <consoleinit>
  uartinit();      // serial port
80102a5d:	e8 42 2a 00 00       	call   801054a4 <uartinit>
  pinit();         // process table
80102a62:	e8 73 07 00 00       	call   801031da <pinit>
  tvinit();        // trap vectors
80102a67:	e8 a2 25 00 00       	call   8010500e <tvinit>
  binit();         // buffer cache
80102a6c:	e8 81 d6 ff ff       	call   801000f2 <binit>
  fileinit();      // file table
80102a71:	e8 57 e1 ff ff       	call   80100bcd <fileinit>
  ideinit();       // disk 
80102a76:	e8 79 f2 ff ff       	call   80101cf4 <ideinit>
  startothers();   // start other processors
80102a7b:	e8 ac fe ff ff       	call   8010292c <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102a80:	83 c4 08             	add    $0x8,%esp
80102a83:	68 00 00 00 8e       	push   $0x8e000000
80102a88:	68 00 00 40 80       	push   $0x80400000
80102a8d:	e8 f5 f5 ff ff       	call   80102087 <kinit2>
  userinit();      // first user process
80102a92:	e8 15 08 00 00       	call   801032ac <userinit>
  mpmain();        // finish this processor's setup
80102a97:	e8 25 ff ff ff       	call   801029c1 <mpmain>

80102a9c <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102a9c:	55                   	push   %ebp
80102a9d:	89 e5                	mov    %esp,%ebp
80102a9f:	56                   	push   %esi
80102aa0:	53                   	push   %ebx
80102aa1:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102aa8:	b9 00 00 00 00       	mov    $0x0,%ecx
80102aad:	eb 07                	jmp    80102ab6 <sum+0x1a>
    sum += addr[i];
80102aaf:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102ab3:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102ab5:	41                   	inc    %ecx
80102ab6:	39 d1                	cmp    %edx,%ecx
80102ab8:	7c f5                	jl     80102aaf <sum+0x13>
  return sum;
}
80102aba:	5b                   	pop    %ebx
80102abb:	5e                   	pop    %esi
80102abc:	5d                   	pop    %ebp
80102abd:	c3                   	ret

80102abe <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102abe:	55                   	push   %ebp
80102abf:	89 e5                	mov    %esp,%ebp
80102ac1:	56                   	push   %esi
80102ac2:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102ac3:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102ac9:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102acb:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102acd:	eb 03                	jmp    80102ad2 <mpsearch1+0x14>
80102acf:	83 c3 10             	add    $0x10,%ebx
80102ad2:	39 f3                	cmp    %esi,%ebx
80102ad4:	73 29                	jae    80102aff <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ad6:	83 ec 04             	sub    $0x4,%esp
80102ad9:	6a 04                	push   $0x4
80102adb:	68 2f 6c 10 80       	push   $0x80106c2f
80102ae0:	53                   	push   %ebx
80102ae1:	e8 93 13 00 00       	call   80103e79 <memcmp>
80102ae6:	83 c4 10             	add    $0x10,%esp
80102ae9:	85 c0                	test   %eax,%eax
80102aeb:	75 e2                	jne    80102acf <mpsearch1+0x11>
80102aed:	ba 10 00 00 00       	mov    $0x10,%edx
80102af2:	89 d8                	mov    %ebx,%eax
80102af4:	e8 a3 ff ff ff       	call   80102a9c <sum>
80102af9:	84 c0                	test   %al,%al
80102afb:	75 d2                	jne    80102acf <mpsearch1+0x11>
80102afd:	eb 05                	jmp    80102b04 <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102aff:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102b04:	89 d8                	mov    %ebx,%eax
80102b06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b09:	5b                   	pop    %ebx
80102b0a:	5e                   	pop    %esi
80102b0b:	5d                   	pop    %ebp
80102b0c:	c3                   	ret

80102b0d <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102b0d:	55                   	push   %ebp
80102b0e:	89 e5                	mov    %esp,%ebp
80102b10:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102b13:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102b1a:	c1 e0 08             	shl    $0x8,%eax
80102b1d:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102b24:	09 d0                	or     %edx,%eax
80102b26:	c1 e0 04             	shl    $0x4,%eax
80102b29:	74 1f                	je     80102b4a <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102b2b:	ba 00 04 00 00       	mov    $0x400,%edx
80102b30:	e8 89 ff ff ff       	call   80102abe <mpsearch1>
80102b35:	85 c0                	test   %eax,%eax
80102b37:	75 0f                	jne    80102b48 <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102b39:	ba 00 00 01 00       	mov    $0x10000,%edx
80102b3e:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102b43:	e8 76 ff ff ff       	call   80102abe <mpsearch1>
}
80102b48:	c9                   	leave
80102b49:	c3                   	ret
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102b4a:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102b51:	c1 e0 08             	shl    $0x8,%eax
80102b54:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102b5b:	09 d0                	or     %edx,%eax
80102b5d:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102b60:	2d 00 04 00 00       	sub    $0x400,%eax
80102b65:	ba 00 04 00 00       	mov    $0x400,%edx
80102b6a:	e8 4f ff ff ff       	call   80102abe <mpsearch1>
80102b6f:	85 c0                	test   %eax,%eax
80102b71:	75 d5                	jne    80102b48 <mpsearch+0x3b>
80102b73:	eb c4                	jmp    80102b39 <mpsearch+0x2c>

80102b75 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102b75:	55                   	push   %ebp
80102b76:	89 e5                	mov    %esp,%ebp
80102b78:	57                   	push   %edi
80102b79:	56                   	push   %esi
80102b7a:	53                   	push   %ebx
80102b7b:	83 ec 1c             	sub    $0x1c,%esp
80102b7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102b81:	e8 87 ff ff ff       	call   80102b0d <mpsearch>
80102b86:	89 c3                	mov    %eax,%ebx
80102b88:	85 c0                	test   %eax,%eax
80102b8a:	74 53                	je     80102bdf <mpconfig+0x6a>
80102b8c:	8b 70 04             	mov    0x4(%eax),%esi
80102b8f:	85 f6                	test   %esi,%esi
80102b91:	74 50                	je     80102be3 <mpconfig+0x6e>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102b93:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102b99:	83 ec 04             	sub    $0x4,%esp
80102b9c:	6a 04                	push   $0x4
80102b9e:	68 34 6c 10 80       	push   $0x80106c34
80102ba3:	57                   	push   %edi
80102ba4:	e8 d0 12 00 00       	call   80103e79 <memcmp>
80102ba9:	83 c4 10             	add    $0x10,%esp
80102bac:	85 c0                	test   %eax,%eax
80102bae:	75 37                	jne    80102be7 <mpconfig+0x72>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102bb0:	8a 86 06 00 00 80    	mov    -0x7ffffffa(%esi),%al
80102bb6:	3c 01                	cmp    $0x1,%al
80102bb8:	74 04                	je     80102bbe <mpconfig+0x49>
80102bba:	3c 04                	cmp    $0x4,%al
80102bbc:	75 30                	jne    80102bee <mpconfig+0x79>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102bbe:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102bc5:	89 f8                	mov    %edi,%eax
80102bc7:	e8 d0 fe ff ff       	call   80102a9c <sum>
80102bcc:	84 c0                	test   %al,%al
80102bce:	75 25                	jne    80102bf5 <mpconfig+0x80>
    return 0;
  *pmp = mp;
80102bd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102bd3:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102bd5:	89 f8                	mov    %edi,%eax
80102bd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bda:	5b                   	pop    %ebx
80102bdb:	5e                   	pop    %esi
80102bdc:	5f                   	pop    %edi
80102bdd:	5d                   	pop    %ebp
80102bde:	c3                   	ret
    return 0;
80102bdf:	89 c7                	mov    %eax,%edi
80102be1:	eb f2                	jmp    80102bd5 <mpconfig+0x60>
80102be3:	89 f7                	mov    %esi,%edi
80102be5:	eb ee                	jmp    80102bd5 <mpconfig+0x60>
    return 0;
80102be7:	bf 00 00 00 00       	mov    $0x0,%edi
80102bec:	eb e7                	jmp    80102bd5 <mpconfig+0x60>
    return 0;
80102bee:	bf 00 00 00 00       	mov    $0x0,%edi
80102bf3:	eb e0                	jmp    80102bd5 <mpconfig+0x60>
    return 0;
80102bf5:	bf 00 00 00 00       	mov    $0x0,%edi
80102bfa:	eb d9                	jmp    80102bd5 <mpconfig+0x60>

80102bfc <mpinit>:

void
mpinit(void)
{
80102bfc:	55                   	push   %ebp
80102bfd:	89 e5                	mov    %esp,%ebp
80102bff:	57                   	push   %edi
80102c00:	56                   	push   %esi
80102c01:	53                   	push   %ebx
80102c02:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102c05:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102c08:	e8 68 ff ff ff       	call   80102b75 <mpconfig>
80102c0d:	85 c0                	test   %eax,%eax
80102c0f:	74 19                	je     80102c2a <mpinit+0x2e>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102c11:	8b 50 24             	mov    0x24(%eax),%edx
80102c14:	89 15 80 16 11 80    	mov    %edx,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102c1a:	8d 50 2c             	lea    0x2c(%eax),%edx
80102c1d:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102c21:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102c23:	bf 01 00 00 00       	mov    $0x1,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102c28:	eb 3f                	jmp    80102c69 <mpinit+0x6d>
    panic("Expect to run on an SMP");
80102c2a:	83 ec 0c             	sub    $0xc,%esp
80102c2d:	68 39 6c 10 80       	push   $0x80106c39
80102c32:	e8 0d d7 ff ff       	call   80100344 <panic>
    switch(*p){
80102c37:	83 e8 03             	sub    $0x3,%eax
80102c3a:	3c 01                	cmp    $0x1,%al
80102c3c:	77 53                	ja     80102c91 <mpinit+0x95>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102c3e:	83 c2 08             	add    $0x8,%edx
      continue;
80102c41:	eb 26                	jmp    80102c69 <mpinit+0x6d>
      if(ncpu < NCPU) {
80102c43:	a1 84 17 11 80       	mov    0x80111784,%eax
80102c48:	83 f8 07             	cmp    $0x7,%eax
80102c4b:	7f 19                	jg     80102c66 <mpinit+0x6a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102c4d:	8d 34 80             	lea    (%eax,%eax,4),%esi
80102c50:	01 f6                	add    %esi,%esi
80102c52:	01 c6                	add    %eax,%esi
80102c54:	c1 e6 04             	shl    $0x4,%esi
80102c57:	8a 5a 01             	mov    0x1(%edx),%bl
80102c5a:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
        ncpu++;
80102c60:	40                   	inc    %eax
80102c61:	a3 84 17 11 80       	mov    %eax,0x80111784
      p += sizeof(struct mpproc);
80102c66:	83 c2 14             	add    $0x14,%edx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102c69:	39 ca                	cmp    %ecx,%edx
80102c6b:	73 2b                	jae    80102c98 <mpinit+0x9c>
    switch(*p){
80102c6d:	8a 02                	mov    (%edx),%al
80102c6f:	3c 02                	cmp    $0x2,%al
80102c71:	74 11                	je     80102c84 <mpinit+0x88>
80102c73:	77 c2                	ja     80102c37 <mpinit+0x3b>
80102c75:	84 c0                	test   %al,%al
80102c77:	74 ca                	je     80102c43 <mpinit+0x47>
80102c79:	3c 01                	cmp    $0x1,%al
80102c7b:	74 c1                	je     80102c3e <mpinit+0x42>
80102c7d:	bf 00 00 00 00       	mov    $0x0,%edi
80102c82:	eb e5                	jmp    80102c69 <mpinit+0x6d>
      ioapicid = ioapic->apicno;
80102c84:	8a 42 01             	mov    0x1(%edx),%al
80102c87:	a2 80 17 11 80       	mov    %al,0x80111780
      p += sizeof(struct mpioapic);
80102c8c:	83 c2 08             	add    $0x8,%edx
      continue;
80102c8f:	eb d8                	jmp    80102c69 <mpinit+0x6d>
    switch(*p){
80102c91:	bf 00 00 00 00       	mov    $0x0,%edi
80102c96:	eb d1                	jmp    80102c69 <mpinit+0x6d>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102c98:	85 ff                	test   %edi,%edi
80102c9a:	74 23                	je     80102cbf <mpinit+0xc3>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102c9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102c9f:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102ca3:	74 12                	je     80102cb7 <mpinit+0xbb>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca5:	b0 70                	mov    $0x70,%al
80102ca7:	ba 22 00 00 00       	mov    $0x22,%edx
80102cac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cad:	ba 23 00 00 00       	mov    $0x23,%edx
80102cb2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102cb3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb6:	ee                   	out    %al,(%dx)
  }
}
80102cb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cba:	5b                   	pop    %ebx
80102cbb:	5e                   	pop    %esi
80102cbc:	5f                   	pop    %edi
80102cbd:	5d                   	pop    %ebp
80102cbe:	c3                   	ret
    panic("Didn't find a suitable machine");
80102cbf:	83 ec 0c             	sub    $0xc,%esp
80102cc2:	68 a0 6f 10 80       	push   $0x80106fa0
80102cc7:	e8 78 d6 ff ff       	call   80100344 <panic>

80102ccc <picinit>:
80102ccc:	b0 ff                	mov    $0xff,%al
80102cce:	ba 21 00 00 00       	mov    $0x21,%edx
80102cd3:	ee                   	out    %al,(%dx)
80102cd4:	ba a1 00 00 00       	mov    $0xa1,%edx
80102cd9:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102cda:	c3                   	ret

80102cdb <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102cdb:	55                   	push   %ebp
80102cdc:	89 e5                	mov    %esp,%ebp
80102cde:	57                   	push   %edi
80102cdf:	56                   	push   %esi
80102ce0:	53                   	push   %ebx
80102ce1:	83 ec 0c             	sub    $0xc,%esp
80102ce4:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ce7:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102cea:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102cf0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102cf6:	e8 ec de ff ff       	call   80100be7 <filealloc>
80102cfb:	89 03                	mov    %eax,(%ebx)
80102cfd:	85 c0                	test   %eax,%eax
80102cff:	0f 84 88 00 00 00    	je     80102d8d <pipealloc+0xb2>
80102d05:	e8 dd de ff ff       	call   80100be7 <filealloc>
80102d0a:	89 06                	mov    %eax,(%esi)
80102d0c:	85 c0                	test   %eax,%eax
80102d0e:	74 7d                	je     80102d8d <pipealloc+0xb2>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102d10:	e8 92 f3 ff ff       	call   801020a7 <kalloc>
80102d15:	89 c7                	mov    %eax,%edi
80102d17:	85 c0                	test   %eax,%eax
80102d19:	74 72                	je     80102d8d <pipealloc+0xb2>
    goto bad;
  p->readopen = 1;
80102d1b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102d22:	00 00 00 
  p->writeopen = 1;
80102d25:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102d2c:	00 00 00 
  p->nwrite = 0;
80102d2f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102d36:	00 00 00 
  p->nread = 0;
80102d39:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102d40:	00 00 00 
  initlock(&p->lock, "pipe");
80102d43:	83 ec 08             	sub    $0x8,%esp
80102d46:	68 51 6c 10 80       	push   $0x80106c51
80102d4b:	50                   	push   %eax
80102d4c:	e8 f5 0e 00 00       	call   80103c46 <initlock>
  (*f0)->type = FD_PIPE;
80102d51:	8b 03                	mov    (%ebx),%eax
80102d53:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102d59:	8b 03                	mov    (%ebx),%eax
80102d5b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102d5f:	8b 03                	mov    (%ebx),%eax
80102d61:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102d65:	8b 03                	mov    (%ebx),%eax
80102d67:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102d6a:	8b 06                	mov    (%esi),%eax
80102d6c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102d72:	8b 06                	mov    (%esi),%eax
80102d74:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102d78:	8b 06                	mov    (%esi),%eax
80102d7a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102d7e:	8b 06                	mov    (%esi),%eax
80102d80:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102d83:	83 c4 10             	add    $0x10,%esp
80102d86:	b8 00 00 00 00       	mov    $0x0,%eax
80102d8b:	eb 29                	jmp    80102db6 <pipealloc+0xdb>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102d8d:	8b 03                	mov    (%ebx),%eax
80102d8f:	85 c0                	test   %eax,%eax
80102d91:	74 0c                	je     80102d9f <pipealloc+0xc4>
    fileclose(*f0);
80102d93:	83 ec 0c             	sub    $0xc,%esp
80102d96:	50                   	push   %eax
80102d97:	e8 ef de ff ff       	call   80100c8b <fileclose>
80102d9c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102d9f:	8b 06                	mov    (%esi),%eax
80102da1:	85 c0                	test   %eax,%eax
80102da3:	74 19                	je     80102dbe <pipealloc+0xe3>
    fileclose(*f1);
80102da5:	83 ec 0c             	sub    $0xc,%esp
80102da8:	50                   	push   %eax
80102da9:	e8 dd de ff ff       	call   80100c8b <fileclose>
80102dae:	83 c4 10             	add    $0x10,%esp
  return -1;
80102db1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102db9:	5b                   	pop    %ebx
80102dba:	5e                   	pop    %esi
80102dbb:	5f                   	pop    %edi
80102dbc:	5d                   	pop    %ebp
80102dbd:	c3                   	ret
  return -1;
80102dbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102dc3:	eb f1                	jmp    80102db6 <pipealloc+0xdb>

80102dc5 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102dc5:	55                   	push   %ebp
80102dc6:	89 e5                	mov    %esp,%ebp
80102dc8:	53                   	push   %ebx
80102dc9:	83 ec 10             	sub    $0x10,%esp
80102dcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102dcf:	53                   	push   %ebx
80102dd0:	e8 b1 0f 00 00       	call   80103d86 <acquire>
  if(writable){
80102dd5:	83 c4 10             	add    $0x10,%esp
80102dd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102ddc:	74 3f                	je     80102e1d <pipeclose+0x58>
    p->writeopen = 0;
80102dde:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102de5:	00 00 00 
    wakeup(&p->nread);
80102de8:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102dee:	83 ec 0c             	sub    $0xc,%esp
80102df1:	50                   	push   %eax
80102df2:	e8 f1 0a 00 00       	call   801038e8 <wakeup>
80102df7:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102dfa:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102e01:	75 09                	jne    80102e0c <pipeclose+0x47>
80102e03:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102e0a:	74 2f                	je     80102e3b <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102e0c:	83 ec 0c             	sub    $0xc,%esp
80102e0f:	53                   	push   %ebx
80102e10:	e8 d6 0f 00 00       	call   80103deb <release>
80102e15:	83 c4 10             	add    $0x10,%esp
}
80102e18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e1b:	c9                   	leave
80102e1c:	c3                   	ret
    p->readopen = 0;
80102e1d:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102e24:	00 00 00 
    wakeup(&p->nwrite);
80102e27:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102e2d:	83 ec 0c             	sub    $0xc,%esp
80102e30:	50                   	push   %eax
80102e31:	e8 b2 0a 00 00       	call   801038e8 <wakeup>
80102e36:	83 c4 10             	add    $0x10,%esp
80102e39:	eb bf                	jmp    80102dfa <pipeclose+0x35>
    release(&p->lock);
80102e3b:	83 ec 0c             	sub    $0xc,%esp
80102e3e:	53                   	push   %ebx
80102e3f:	e8 a7 0f 00 00       	call   80103deb <release>
    kfree((char*)p);
80102e44:	89 1c 24             	mov    %ebx,(%esp)
80102e47:	e8 44 f1 ff ff       	call   80101f90 <kfree>
80102e4c:	83 c4 10             	add    $0x10,%esp
80102e4f:	eb c7                	jmp    80102e18 <pipeclose+0x53>

80102e51 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102e51:	55                   	push   %ebp
80102e52:	89 e5                	mov    %esp,%ebp
80102e54:	57                   	push   %edi
80102e55:	56                   	push   %esi
80102e56:	53                   	push   %ebx
80102e57:	83 ec 28             	sub    $0x28,%esp
80102e5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e5d:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  acquire(&p->lock);
80102e60:	53                   	push   %ebx
80102e61:	e8 20 0f 00 00       	call   80103d86 <acquire>
  for(i = 0; i < n; i++){
80102e66:	83 c4 10             	add    $0x10,%esp
80102e69:	bf 00 00 00 00       	mov    $0x0,%edi
80102e6e:	39 f7                	cmp    %esi,%edi
80102e70:	7c 40                	jl     80102eb2 <pipewrite+0x61>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102e72:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e78:	83 ec 0c             	sub    $0xc,%esp
80102e7b:	50                   	push   %eax
80102e7c:	e8 67 0a 00 00       	call   801038e8 <wakeup>
  release(&p->lock);
80102e81:	89 1c 24             	mov    %ebx,(%esp)
80102e84:	e8 62 0f 00 00       	call   80103deb <release>
  return n;
80102e89:	83 c4 10             	add    $0x10,%esp
80102e8c:	89 f0                	mov    %esi,%eax
80102e8e:	eb 5c                	jmp    80102eec <pipewrite+0x9b>
      wakeup(&p->nread);
80102e90:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e96:	83 ec 0c             	sub    $0xc,%esp
80102e99:	50                   	push   %eax
80102e9a:	e8 49 0a 00 00       	call   801038e8 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102e9f:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102ea5:	83 c4 08             	add    $0x8,%esp
80102ea8:	53                   	push   %ebx
80102ea9:	50                   	push   %eax
80102eaa:	e8 be 08 00 00       	call   8010376d <sleep>
80102eaf:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102eb2:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102eb8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102ebe:	05 00 02 00 00       	add    $0x200,%eax
80102ec3:	39 c2                	cmp    %eax,%edx
80102ec5:	75 2d                	jne    80102ef4 <pipewrite+0xa3>
      if(p->readopen == 0 || myproc()->killed){
80102ec7:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102ece:	74 0b                	je     80102edb <pipewrite+0x8a>
80102ed0:	e8 b4 03 00 00       	call   80103289 <myproc>
80102ed5:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102ed9:	74 b5                	je     80102e90 <pipewrite+0x3f>
        release(&p->lock);
80102edb:	83 ec 0c             	sub    $0xc,%esp
80102ede:	53                   	push   %ebx
80102edf:	e8 07 0f 00 00       	call   80103deb <release>
        return -1;
80102ee4:	83 c4 10             	add    $0x10,%esp
80102ee7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eef:	5b                   	pop    %ebx
80102ef0:	5e                   	pop    %esi
80102ef1:	5f                   	pop    %edi
80102ef2:	5d                   	pop    %ebp
80102ef3:	c3                   	ret
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102ef4:	8d 42 01             	lea    0x1(%edx),%eax
80102ef7:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102efd:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102f03:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f06:	8a 04 38             	mov    (%eax,%edi,1),%al
80102f09:	88 45 e7             	mov    %al,-0x19(%ebp)
80102f0c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80102f10:	47                   	inc    %edi
80102f11:	e9 58 ff ff ff       	jmp    80102e6e <pipewrite+0x1d>

80102f16 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80102f16:	55                   	push   %ebp
80102f17:	89 e5                	mov    %esp,%ebp
80102f19:	57                   	push   %edi
80102f1a:	56                   	push   %esi
80102f1b:	53                   	push   %ebx
80102f1c:	83 ec 18             	sub    $0x18,%esp
80102f1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f22:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
80102f25:	53                   	push   %ebx
80102f26:	e8 5b 0e 00 00       	call   80103d86 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102f2b:	83 c4 10             	add    $0x10,%esp
80102f2e:	eb 13                	jmp    80102f43 <piperead+0x2d>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80102f30:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f36:	83 ec 08             	sub    $0x8,%esp
80102f39:	53                   	push   %ebx
80102f3a:	50                   	push   %eax
80102f3b:	e8 2d 08 00 00       	call   8010376d <sleep>
80102f40:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102f43:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102f49:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80102f4f:	75 77                	jne    80102fc8 <piperead+0xb2>
80102f51:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80102f57:	85 f6                	test   %esi,%esi
80102f59:	74 37                	je     80102f92 <piperead+0x7c>
    if(myproc()->killed){
80102f5b:	e8 29 03 00 00       	call   80103289 <myproc>
80102f60:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102f64:	74 ca                	je     80102f30 <piperead+0x1a>
      release(&p->lock);
80102f66:	83 ec 0c             	sub    $0xc,%esp
80102f69:	53                   	push   %ebx
80102f6a:	e8 7c 0e 00 00       	call   80103deb <release>
      return -1;
80102f6f:	83 c4 10             	add    $0x10,%esp
80102f72:	be ff ff ff ff       	mov    $0xffffffff,%esi
80102f77:	eb 45                	jmp    80102fbe <piperead+0xa8>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80102f79:	8d 50 01             	lea    0x1(%eax),%edx
80102f7c:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80102f82:	25 ff 01 00 00       	and    $0x1ff,%eax
80102f87:	8a 44 03 34          	mov    0x34(%ebx,%eax,1),%al
80102f8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102f8e:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80102f91:	46                   	inc    %esi
80102f92:	39 fe                	cmp    %edi,%esi
80102f94:	7d 0e                	jge    80102fa4 <piperead+0x8e>
    if(p->nread == p->nwrite)
80102f96:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102f9c:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80102fa2:	75 d5                	jne    80102f79 <piperead+0x63>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80102fa4:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102faa:	83 ec 0c             	sub    $0xc,%esp
80102fad:	50                   	push   %eax
80102fae:	e8 35 09 00 00       	call   801038e8 <wakeup>
  release(&p->lock);
80102fb3:	89 1c 24             	mov    %ebx,(%esp)
80102fb6:	e8 30 0e 00 00       	call   80103deb <release>
  return i;
80102fbb:	83 c4 10             	add    $0x10,%esp
}
80102fbe:	89 f0                	mov    %esi,%eax
80102fc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fc3:	5b                   	pop    %ebx
80102fc4:	5e                   	pop    %esi
80102fc5:	5f                   	pop    %edi
80102fc6:	5d                   	pop    %ebp
80102fc7:	c3                   	ret
80102fc8:	be 00 00 00 00       	mov    $0x0,%esi
80102fcd:	eb c3                	jmp    80102f92 <piperead+0x7c>

80102fcf <allocproc>:
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{
80102fcf:	55                   	push   %ebp
80102fd0:	89 e5                	mov    %esp,%ebp
80102fd2:	53                   	push   %ebx
80102fd3:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80102fd6:	68 20 1d 11 80       	push   $0x80111d20
80102fdb:	e8 a6 0d 00 00       	call   80103d86 <acquire>

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80102fe0:	83 c4 10             	add    $0x10,%esp
80102fe3:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80102fe8:	eb 06                	jmp    80102ff0 <allocproc+0x21>
80102fea:	81 c3 88 00 00 00    	add    $0x88,%ebx
80102ff0:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80102ff6:	0f 83 80 00 00 00    	jae    8010307c <allocproc+0xad>
    if (p->state == UNUSED)
80102ffc:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
80103000:	75 e8                	jne    80102fea <allocproc+0x1b>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103002:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103009:	a1 04 a0 10 80       	mov    0x8010a004,%eax
8010300e:	8d 50 01             	lea    0x1(%eax),%edx
80103011:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80103017:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
8010301a:	83 ec 0c             	sub    $0xc,%esp
8010301d:	68 20 1d 11 80       	push   $0x80111d20
80103022:	e8 c4 0d 00 00       	call   80103deb <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
80103027:	e8 7b f0 ff ff       	call   801020a7 <kalloc>
8010302c:	89 43 08             	mov    %eax,0x8(%ebx)
8010302f:	83 c4 10             	add    $0x10,%esp
80103032:	85 c0                	test   %eax,%eax
80103034:	74 5d                	je     80103093 <allocproc+0xc4>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103036:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe *)sp;
8010303c:	89 53 18             	mov    %edx,0x18(%ebx)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint *)sp = (uint)trapret;
8010303f:	c7 80 b0 0f 00 00 03 	movl   $0x80105003,0xfb0(%eax)
80103046:	50 10 80 

  sp -= sizeof *p->context;
80103049:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context *)sp;
8010304e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103051:	83 ec 04             	sub    $0x4,%esp
80103054:	6a 14                	push   $0x14
80103056:	6a 00                	push   $0x0
80103058:	50                   	push   %eax
80103059:	e8 d4 0d 00 00       	call   80103e32 <memset>
  p->context->eip = (uint)forkret;
8010305e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103061:	c7 40 10 9e 30 10 80 	movl   $0x8010309e,0x10(%eax)

  p->priority = DEFAULT_PRIO; // Boletín 4: Todos los procesos empiezan con prioridad media (5)
80103068:	c7 83 80 00 00 00 05 	movl   $0x5,0x80(%ebx)
8010306f:	00 00 00 

  return p;
80103072:	83 c4 10             	add    $0x10,%esp
}
80103075:	89 d8                	mov    %ebx,%eax
80103077:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010307a:	c9                   	leave
8010307b:	c3                   	ret
  release(&ptable.lock);
8010307c:	83 ec 0c             	sub    $0xc,%esp
8010307f:	68 20 1d 11 80       	push   $0x80111d20
80103084:	e8 62 0d 00 00       	call   80103deb <release>
  return 0;
80103089:	83 c4 10             	add    $0x10,%esp
8010308c:	bb 00 00 00 00       	mov    $0x0,%ebx
80103091:	eb e2                	jmp    80103075 <allocproc+0xa6>
    p->state = UNUSED;
80103093:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010309a:	89 c3                	mov    %eax,%ebx
8010309c:	eb d7                	jmp    80103075 <allocproc+0xa6>

8010309e <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
8010309e:	55                   	push   %ebp
8010309f:	89 e5                	mov    %esp,%ebp
801030a1:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801030a4:	68 20 1d 11 80       	push   $0x80111d20
801030a9:	e8 3d 0d 00 00       	call   80103deb <release>

  if (first)
801030ae:	83 c4 10             	add    $0x10,%esp
801030b1:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
801030b8:	75 02                	jne    801030bc <forkret+0x1e>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801030ba:	c9                   	leave
801030bb:	c3                   	ret
    first = 0;
801030bc:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801030c3:	00 00 00 
    iinit(ROOTDEV);
801030c6:	83 ec 0c             	sub    $0xc,%esp
801030c9:	6a 01                	push   $0x1
801030cb:	e8 21 e2 ff ff       	call   801012f1 <iinit>
    initlog(ROOTDEV);
801030d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801030d7:	e8 3b f6 ff ff       	call   80102717 <initlog>
801030dc:	83 c4 10             	add    $0x10,%esp
}
801030df:	eb d9                	jmp    801030ba <forkret+0x1c>

801030e1 <prio_enqueue>:
{
801030e1:	55                   	push   %ebp
801030e2:	89 e5                	mov    %esp,%ebp
801030e4:	8b 55 08             	mov    0x8(%ebp),%edx
  int prio = p->priority;
801030e7:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
  p->next = 0; // Como va al final, no tiene a nadie detrás
801030ed:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
801030f4:	00 00 00 
  if (ptable.q_head[prio] == 0)
801030f7:	83 3c 85 54 3f 11 80 	cmpl   $0x0,-0x7feec0ac(,%eax,4)
801030fe:	00 
801030ff:	74 1b                	je     8010311c <prio_enqueue+0x3b>
    ptable.q_tail[prio]->next = p;
80103101:	05 94 08 00 00       	add    $0x894,%eax
80103106:	8b 0c 85 2c 1d 11 80 	mov    -0x7feee2d4(,%eax,4),%ecx
8010310d:	89 91 84 00 00 00    	mov    %edx,0x84(%ecx)
    ptable.q_tail[prio] = p;
80103113:	89 14 85 2c 1d 11 80 	mov    %edx,-0x7feee2d4(,%eax,4)
}
8010311a:	5d                   	pop    %ebp
8010311b:	c3                   	ret
    ptable.q_head[prio] = p;
8010311c:	89 14 85 54 3f 11 80 	mov    %edx,-0x7feec0ac(,%eax,4)
    ptable.q_tail[prio] = p;
80103123:	89 14 85 7c 3f 11 80 	mov    %edx,-0x7feec084(,%eax,4)
8010312a:	eb ee                	jmp    8010311a <prio_enqueue+0x39>

8010312c <wakeup1>:
// PAGEBREAK!
//  Wake up all processes sleeping on chan.
//  The ptable lock must be held.
static void
wakeup1(void *chan)
{
8010312c:	55                   	push   %ebp
8010312d:	89 e5                	mov    %esp,%ebp
8010312f:	56                   	push   %esi
80103130:	53                   	push   %ebx
80103131:	89 c6                	mov    %eax,%esi
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103133:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103138:	eb 06                	jmp    80103140 <wakeup1+0x14>
8010313a:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103140:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80103146:	73 20                	jae    80103168 <wakeup1+0x3c>
    if (p->state == SLEEPING && p->chan == chan)
80103148:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
8010314c:	75 ec                	jne    8010313a <wakeup1+0xe>
8010314e:	39 73 20             	cmp    %esi,0x20(%ebx)
80103151:	75 e7                	jne    8010313a <wakeup1+0xe>
    {
      p->state = RUNNABLE;
80103153:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      prio_enqueue(p); // Boletín 4: El proceso que se despierta se encola en su nivel de prioridad
8010315a:	83 ec 0c             	sub    $0xc,%esp
8010315d:	53                   	push   %ebx
8010315e:	e8 7e ff ff ff       	call   801030e1 <prio_enqueue>
80103163:	83 c4 10             	add    $0x10,%esp
80103166:	eb d2                	jmp    8010313a <wakeup1+0xe>
    }
}
80103168:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010316b:	5b                   	pop    %ebx
8010316c:	5e                   	pop    %esi
8010316d:	5d                   	pop    %ebp
8010316e:	c3                   	ret

8010316f <prio_remove>:
{
8010316f:	55                   	push   %ebp
80103170:	89 e5                	mov    %esp,%ebp
80103172:	56                   	push   %esi
80103173:	53                   	push   %ebx
80103174:	8b 55 08             	mov    0x8(%ebp),%edx
  int prio = p->priority;
80103177:	8b 9a 80 00 00 00    	mov    0x80(%edx),%ebx
  struct proc *curr = ptable.q_head[prio];
8010317d:	8b 04 9d 54 3f 11 80 	mov    -0x7feec0ac(,%ebx,4),%eax
  struct proc *prev = 0;
80103184:	b9 00 00 00 00       	mov    $0x0,%ecx
  while (curr != 0)
80103189:	eb 20                	jmp    801031ab <prio_remove+0x3c>
        ptable.q_head[prio] = curr->next;
8010318b:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
80103191:	89 34 9d 54 3f 11 80 	mov    %esi,-0x7feec0ac(,%ebx,4)
80103198:	eb 29                	jmp    801031c3 <prio_remove+0x54>
        ptable.q_tail[prio] = prev;
8010319a:	89 0c 9d 7c 3f 11 80 	mov    %ecx,-0x7feec084(,%ebx,4)
801031a1:	eb 29                	jmp    801031cc <prio_remove+0x5d>
    prev = curr;
801031a3:	89 c1                	mov    %eax,%ecx
    curr = curr->next;
801031a5:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  while (curr != 0)
801031ab:	85 c0                	test   %eax,%eax
801031ad:	74 27                	je     801031d6 <prio_remove+0x67>
    if (curr == p)
801031af:	39 d0                	cmp    %edx,%eax
801031b1:	75 f0                	jne    801031a3 <prio_remove+0x34>
      if (prev == 0)
801031b3:	85 c9                	test   %ecx,%ecx
801031b5:	74 d4                	je     8010318b <prio_remove+0x1c>
        prev->next = curr->next;
801031b7:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
801031bd:	89 b1 84 00 00 00    	mov    %esi,0x84(%ecx)
      if (ptable.q_tail[prio] == curr)
801031c3:	39 04 9d 7c 3f 11 80 	cmp    %eax,-0x7feec084(,%ebx,4)
801031ca:	74 ce                	je     8010319a <prio_remove+0x2b>
      p->next = 0; // Lo desconectamos totalmente de la fila
801031cc:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
801031d3:	00 00 00 
}
801031d6:	5b                   	pop    %ebx
801031d7:	5e                   	pop    %esi
801031d8:	5d                   	pop    %ebp
801031d9:	c3                   	ret

801031da <pinit>:
{
801031da:	55                   	push   %ebp
801031db:	89 e5                	mov    %esp,%ebp
801031dd:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801031e0:	68 56 6c 10 80       	push   $0x80106c56
801031e5:	68 20 1d 11 80       	push   $0x80111d20
801031ea:	e8 57 0a 00 00       	call   80103c46 <initlock>
}
801031ef:	83 c4 10             	add    $0x10,%esp
801031f2:	c9                   	leave
801031f3:	c3                   	ret

801031f4 <mycpu>:
{
801031f4:	55                   	push   %ebp
801031f5:	89 e5                	mov    %esp,%ebp
801031f7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801031fa:	9c                   	pushf
801031fb:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801031fc:	f6 c4 02             	test   $0x2,%ah
801031ff:	75 2c                	jne    8010322d <mycpu+0x39>
  apicid = lapicid();
80103201:	e8 5d f1 ff ff       	call   80102363 <lapicid>
80103206:	89 c1                	mov    %eax,%ecx
  for (i = 0; i < ncpu; ++i)
80103208:	ba 00 00 00 00       	mov    $0x0,%edx
8010320d:	39 15 84 17 11 80    	cmp    %edx,0x80111784
80103213:	7e 25                	jle    8010323a <mycpu+0x46>
    if (cpus[i].apicid == apicid)
80103215:	8d 04 92             	lea    (%edx,%edx,4),%eax
80103218:	01 c0                	add    %eax,%eax
8010321a:	01 d0                	add    %edx,%eax
8010321c:	c1 e0 04             	shl    $0x4,%eax
8010321f:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
80103226:	39 c8                	cmp    %ecx,%eax
80103228:	74 1d                	je     80103247 <mycpu+0x53>
  for (i = 0; i < ncpu; ++i)
8010322a:	42                   	inc    %edx
8010322b:	eb e0                	jmp    8010320d <mycpu+0x19>
    panic("mycpu called with interrupts enabled\n");
8010322d:	83 ec 0c             	sub    $0xc,%esp
80103230:	68 c0 6f 10 80       	push   $0x80106fc0
80103235:	e8 0a d1 ff ff       	call   80100344 <panic>
  panic("unknown apicid\n");
8010323a:	83 ec 0c             	sub    $0xc,%esp
8010323d:	68 5d 6c 10 80       	push   $0x80106c5d
80103242:	e8 fd d0 ff ff       	call   80100344 <panic>
      return &cpus[i];
80103247:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010324a:	01 c0                	add    %eax,%eax
8010324c:	01 d0                	add    %edx,%eax
8010324e:	c1 e0 04             	shl    $0x4,%eax
80103251:	05 a0 17 11 80       	add    $0x801117a0,%eax
}
80103256:	c9                   	leave
80103257:	c3                   	ret

80103258 <cpuid>:
{
80103258:	55                   	push   %ebp
80103259:	89 e5                	mov    %esp,%ebp
8010325b:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
8010325e:	e8 91 ff ff ff       	call   801031f4 <mycpu>
80103263:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103268:	c1 f8 04             	sar    $0x4,%eax
8010326b:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
8010326e:	89 ca                	mov    %ecx,%edx
80103270:	c1 e2 05             	shl    $0x5,%edx
80103273:	29 ca                	sub    %ecx,%edx
80103275:	8d 14 90             	lea    (%eax,%edx,4),%edx
80103278:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
8010327b:	89 ca                	mov    %ecx,%edx
8010327d:	c1 e2 0f             	shl    $0xf,%edx
80103280:	29 ca                	sub    %ecx,%edx
80103282:	8d 04 90             	lea    (%eax,%edx,4),%eax
80103285:	f7 d8                	neg    %eax
}
80103287:	c9                   	leave
80103288:	c3                   	ret

80103289 <myproc>:
{
80103289:	55                   	push   %ebp
8010328a:	89 e5                	mov    %esp,%ebp
8010328c:	53                   	push   %ebx
8010328d:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103290:	e8 0e 0a 00 00       	call   80103ca3 <pushcli>
  c = mycpu();
80103295:	e8 5a ff ff ff       	call   801031f4 <mycpu>
  p = c->proc;
8010329a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801032a0:	e8 42 0a 00 00       	call   80103ce7 <popcli>
}
801032a5:	89 d8                	mov    %ebx,%eax
801032a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032aa:	c9                   	leave
801032ab:	c3                   	ret

801032ac <userinit>:
{
801032ac:	55                   	push   %ebp
801032ad:	89 e5                	mov    %esp,%ebp
801032af:	53                   	push   %ebx
801032b0:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801032b3:	e8 17 fd ff ff       	call   80102fcf <allocproc>
801032b8:	89 c3                	mov    %eax,%ebx
  initproc = p;
801032ba:	a3 a4 3f 11 80       	mov    %eax,0x80113fa4
  if ((p->pgdir = setupkvm()) == 0)
801032bf:	e8 f9 34 00 00       	call   801067bd <setupkvm>
801032c4:	89 43 04             	mov    %eax,0x4(%ebx)
801032c7:	85 c0                	test   %eax,%eax
801032c9:	0f 84 be 00 00 00    	je     8010338d <userinit+0xe1>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801032cf:	83 ec 04             	sub    $0x4,%esp
801032d2:	68 2c 00 00 00       	push   $0x2c
801032d7:	68 60 a4 10 80       	push   $0x8010a460
801032dc:	50                   	push   %eax
801032dd:	e8 fb 31 00 00       	call   801064dd <inituvm>
  p->sz = PGSIZE;
801032e2:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801032e8:	8b 43 18             	mov    0x18(%ebx),%eax
801032eb:	83 c4 0c             	add    $0xc,%esp
801032ee:	6a 4c                	push   $0x4c
801032f0:	6a 00                	push   $0x0
801032f2:	50                   	push   %eax
801032f3:	e8 3a 0b 00 00       	call   80103e32 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801032f8:	8b 43 18             	mov    0x18(%ebx),%eax
801032fb:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103301:	8b 43 18             	mov    0x18(%ebx),%eax
80103304:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010330a:	8b 43 18             	mov    0x18(%ebx),%eax
8010330d:	8b 50 2c             	mov    0x2c(%eax),%edx
80103310:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103314:	8b 43 18             	mov    0x18(%ebx),%eax
80103317:	8b 50 2c             	mov    0x2c(%eax),%edx
8010331a:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010331e:	8b 43 18             	mov    0x18(%ebx),%eax
80103321:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103328:	8b 43 18             	mov    0x18(%ebx),%eax
8010332b:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103332:	8b 43 18             	mov    0x18(%ebx),%eax
80103335:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010333c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010333f:	83 c4 0c             	add    $0xc,%esp
80103342:	6a 10                	push   $0x10
80103344:	68 86 6c 10 80       	push   $0x80106c86
80103349:	50                   	push   %eax
8010334a:	e8 3b 0c 00 00       	call   80103f8a <safestrcpy>
  p->cwd = namei("/");
8010334f:	c7 04 24 8f 6c 10 80 	movl   $0x80106c8f,(%esp)
80103356:	e8 8a e8 ff ff       	call   80101be5 <namei>
8010335b:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010335e:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103365:	e8 1c 0a 00 00       	call   80103d86 <acquire>
  p->state = RUNNABLE;
8010336a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  prio_enqueue(p); // Boletín 4: El proceso inicial se encola en su nivel de prioridad
80103371:	89 1c 24             	mov    %ebx,(%esp)
80103374:	e8 68 fd ff ff       	call   801030e1 <prio_enqueue>
  release(&ptable.lock);
80103379:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103380:	e8 66 0a 00 00       	call   80103deb <release>
}
80103385:	83 c4 10             	add    $0x10,%esp
80103388:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010338b:	c9                   	leave
8010338c:	c3                   	ret
    panic("userinit: out of memory?");
8010338d:	83 ec 0c             	sub    $0xc,%esp
80103390:	68 6d 6c 10 80       	push   $0x80106c6d
80103395:	e8 aa cf ff ff       	call   80100344 <panic>

8010339a <growproc>:
{
8010339a:	55                   	push   %ebp
8010339b:	89 e5                	mov    %esp,%ebp
8010339d:	56                   	push   %esi
8010339e:	53                   	push   %ebx
8010339f:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801033a2:	e8 e2 fe ff ff       	call   80103289 <myproc>
801033a7:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801033a9:	8b 00                	mov    (%eax),%eax
  if (n > 0)
801033ab:	85 f6                	test   %esi,%esi
801033ad:	7f 1b                	jg     801033ca <growproc+0x30>
  else if (n < 0)
801033af:	78 36                	js     801033e7 <growproc+0x4d>
  curproc->sz = sz;
801033b1:	89 03                	mov    %eax,(%ebx)
  lcr3(V2P(curproc->pgdir)); // Invalidate TLB.
801033b3:	8b 43 04             	mov    0x4(%ebx),%eax
801033b6:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801033bb:	0f 22 d8             	mov    %eax,%cr3
  return 0;
801033be:	b8 00 00 00 00       	mov    $0x0,%eax
}
801033c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033c6:	5b                   	pop    %ebx
801033c7:	5e                   	pop    %esi
801033c8:	5d                   	pop    %ebp
801033c9:	c3                   	ret
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801033ca:	83 ec 04             	sub    $0x4,%esp
801033cd:	01 c6                	add    %eax,%esi
801033cf:	56                   	push   %esi
801033d0:	50                   	push   %eax
801033d1:	ff 73 04             	push   0x4(%ebx)
801033d4:	e8 8a 32 00 00       	call   80106663 <allocuvm>
801033d9:	83 c4 10             	add    $0x10,%esp
801033dc:	85 c0                	test   %eax,%eax
801033de:	75 d1                	jne    801033b1 <growproc+0x17>
      return -1;
801033e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033e5:	eb dc                	jmp    801033c3 <growproc+0x29>
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801033e7:	83 ec 04             	sub    $0x4,%esp
801033ea:	01 c6                	add    %eax,%esi
801033ec:	56                   	push   %esi
801033ed:	50                   	push   %eax
801033ee:	ff 73 04             	push   0x4(%ebx)
801033f1:	e8 ea 31 00 00       	call   801065e0 <deallocuvm>
801033f6:	83 c4 10             	add    $0x10,%esp
801033f9:	85 c0                	test   %eax,%eax
801033fb:	75 b4                	jne    801033b1 <growproc+0x17>
      return -1;
801033fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103402:	eb bf                	jmp    801033c3 <growproc+0x29>

80103404 <fork>:
{
80103404:	55                   	push   %ebp
80103405:	89 e5                	mov    %esp,%ebp
80103407:	57                   	push   %edi
80103408:	56                   	push   %esi
80103409:	53                   	push   %ebx
8010340a:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
8010340d:	e8 77 fe ff ff       	call   80103289 <myproc>
80103412:	89 c3                	mov    %eax,%ebx
  if ((np = allocproc()) == 0)
80103414:	e8 b6 fb ff ff       	call   80102fcf <allocproc>
80103419:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010341c:	85 c0                	test   %eax,%eax
8010341e:	0f 84 f2 00 00 00    	je     80103516 <fork+0x112>
80103424:	89 c7                	mov    %eax,%edi
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80103426:	83 ec 08             	sub    $0x8,%esp
80103429:	ff 33                	push   (%ebx)
8010342b:	ff 73 04             	push   0x4(%ebx)
8010342e:	e8 41 34 00 00       	call   80106874 <copyuvm>
80103433:	89 47 04             	mov    %eax,0x4(%edi)
80103436:	83 c4 10             	add    $0x10,%esp
80103439:	85 c0                	test   %eax,%eax
8010343b:	74 2a                	je     80103467 <fork+0x63>
  np->sz = curproc->sz;
8010343d:	8b 03                	mov    (%ebx),%eax
8010343f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103442:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103444:	89 c8                	mov    %ecx,%eax
80103446:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103449:	8b 73 18             	mov    0x18(%ebx),%esi
8010344c:	8b 79 18             	mov    0x18(%ecx),%edi
8010344f:	b9 13 00 00 00       	mov    $0x13,%ecx
80103454:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103456:	8b 40 18             	mov    0x18(%eax),%eax
80103459:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
80103460:	be 00 00 00 00       	mov    $0x0,%esi
80103465:	eb 27                	jmp    8010348e <fork+0x8a>
    kfree(np->kstack);
80103467:	83 ec 0c             	sub    $0xc,%esp
8010346a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010346d:	ff 73 08             	push   0x8(%ebx)
80103470:	e8 1b eb ff ff       	call   80101f90 <kfree>
    np->kstack = 0;
80103475:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
8010347c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103483:	83 c4 10             	add    $0x10,%esp
80103486:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010348b:	eb 7f                	jmp    8010350c <fork+0x108>
  for (i = 0; i < NOFILE; i++)
8010348d:	46                   	inc    %esi
8010348e:	83 fe 0f             	cmp    $0xf,%esi
80103491:	7f 1d                	jg     801034b0 <fork+0xac>
    if (curproc->ofile[i])
80103493:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103497:	85 c0                	test   %eax,%eax
80103499:	74 f2                	je     8010348d <fork+0x89>
      np->ofile[i] = filedup(curproc->ofile[i]);
8010349b:	83 ec 0c             	sub    $0xc,%esp
8010349e:	50                   	push   %eax
8010349f:	e8 a4 d7 ff ff       	call   80100c48 <filedup>
801034a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801034a7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
801034ab:	83 c4 10             	add    $0x10,%esp
801034ae:	eb dd                	jmp    8010348d <fork+0x89>
  np->cwd = idup(curproc->cwd);
801034b0:	83 ec 0c             	sub    $0xc,%esp
801034b3:	ff 73 68             	push   0x68(%ebx)
801034b6:	e8 90 e0 ff ff       	call   8010154b <idup>
801034bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801034be:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801034c1:	8d 53 6c             	lea    0x6c(%ebx),%edx
801034c4:	8d 47 6c             	lea    0x6c(%edi),%eax
801034c7:	83 c4 0c             	add    $0xc,%esp
801034ca:	6a 10                	push   $0x10
801034cc:	52                   	push   %edx
801034cd:	50                   	push   %eax
801034ce:	e8 b7 0a 00 00       	call   80103f8a <safestrcpy>
  np->priority = curproc->priority; // Boletín 4: El hijo hereda la prioridad del padre
801034d3:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801034d9:	89 87 80 00 00 00    	mov    %eax,0x80(%edi)
  pid = np->pid;
801034df:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801034e2:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801034e9:	e8 98 08 00 00       	call   80103d86 <acquire>
  np->state = RUNNABLE;
801034ee:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  prio_enqueue(np); // Boletín 4: El proceso recién creado se encola en su nivel de prioridad
801034f5:	89 3c 24             	mov    %edi,(%esp)
801034f8:	e8 e4 fb ff ff       	call   801030e1 <prio_enqueue>
  release(&ptable.lock);
801034fd:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103504:	e8 e2 08 00 00       	call   80103deb <release>
  return pid;
80103509:	83 c4 10             	add    $0x10,%esp
}
8010350c:	89 d8                	mov    %ebx,%eax
8010350e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103511:	5b                   	pop    %ebx
80103512:	5e                   	pop    %esi
80103513:	5f                   	pop    %edi
80103514:	5d                   	pop    %ebp
80103515:	c3                   	ret
    return -1;
80103516:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010351b:	eb ef                	jmp    8010350c <fork+0x108>

8010351d <scheduler>:
{
8010351d:	55                   	push   %ebp
8010351e:	89 e5                	mov    %esp,%ebp
80103520:	56                   	push   %esi
80103521:	53                   	push   %ebx
  struct cpu *c = mycpu(); // Obtenemos la CPU actual
80103522:	e8 cd fc ff ff       	call   801031f4 <mycpu>
80103527:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103529:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103530:	00 00 00 
80103533:	eb 4f                	jmp    80103584 <scheduler+0x67>
        prio_remove(p);
80103535:	83 ec 0c             	sub    $0xc,%esp
80103538:	53                   	push   %ebx
80103539:	e8 31 fc ff ff       	call   8010316f <prio_remove>
        c->proc = p;
8010353e:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
        switchuvm(p);
80103544:	89 1c 24             	mov    %ebx,(%esp)
80103547:	e8 35 2e 00 00       	call   80106381 <switchuvm>
        p->state = RUNNING;
8010354c:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        swtch(&(c->scheduler), p->context);
80103553:	83 c4 08             	add    $0x8,%esp
80103556:	ff 73 1c             	push   0x1c(%ebx)
80103559:	8d 46 04             	lea    0x4(%esi),%eax
8010355c:	50                   	push   %eax
8010355d:	e8 76 0a 00 00       	call   80103fd8 <swtch>
        switchkvm();
80103562:	e8 0c 2e 00 00       	call   80106373 <switchkvm>
        c->proc = 0;
80103567:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
8010356e:	00 00 00 
        break;
80103571:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80103574:	83 ec 0c             	sub    $0xc,%esp
80103577:	68 20 1d 11 80       	push   $0x80111d20
8010357c:	e8 6a 08 00 00       	call   80103deb <release>
    sti();
80103581:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103584:	fb                   	sti
    acquire(&ptable.lock);
80103585:	83 ec 0c             	sub    $0xc,%esp
80103588:	68 20 1d 11 80       	push   $0x80111d20
8010358d:	e8 f4 07 00 00       	call   80103d86 <acquire>
    for (prio = 0; prio < NPRIO; prio++)
80103592:	83 c4 10             	add    $0x10,%esp
80103595:	b8 00 00 00 00       	mov    $0x0,%eax
8010359a:	83 f8 09             	cmp    $0x9,%eax
8010359d:	7f d5                	jg     80103574 <scheduler+0x57>
      if (ptable.q_head[prio] != 0)
8010359f:	8b 1c 85 54 3f 11 80 	mov    -0x7feec0ac(,%eax,4),%ebx
801035a6:	85 db                	test   %ebx,%ebx
801035a8:	75 8b                	jne    80103535 <scheduler+0x18>
    for (prio = 0; prio < NPRIO; prio++)
801035aa:	40                   	inc    %eax
801035ab:	eb ed                	jmp    8010359a <scheduler+0x7d>

801035ad <sched>:
{
801035ad:	55                   	push   %ebp
801035ae:	89 e5                	mov    %esp,%ebp
801035b0:	56                   	push   %esi
801035b1:	53                   	push   %ebx
  struct proc *p = myproc();
801035b2:	e8 d2 fc ff ff       	call   80103289 <myproc>
801035b7:	89 c3                	mov    %eax,%ebx
  if (!holding(&ptable.lock))
801035b9:	83 ec 0c             	sub    $0xc,%esp
801035bc:	68 20 1d 11 80       	push   $0x80111d20
801035c1:	e8 81 07 00 00       	call   80103d47 <holding>
801035c6:	83 c4 10             	add    $0x10,%esp
801035c9:	85 c0                	test   %eax,%eax
801035cb:	74 4f                	je     8010361c <sched+0x6f>
  if (mycpu()->ncli != 1)
801035cd:	e8 22 fc ff ff       	call   801031f4 <mycpu>
801035d2:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801035d9:	75 4e                	jne    80103629 <sched+0x7c>
  if (p->state == RUNNING)
801035db:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801035df:	74 55                	je     80103636 <sched+0x89>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801035e1:	9c                   	pushf
801035e2:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801035e3:	f6 c4 02             	test   $0x2,%ah
801035e6:	75 5b                	jne    80103643 <sched+0x96>
  intena = mycpu()->intena;
801035e8:	e8 07 fc ff ff       	call   801031f4 <mycpu>
801035ed:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801035f3:	e8 fc fb ff ff       	call   801031f4 <mycpu>
801035f8:	83 ec 08             	sub    $0x8,%esp
801035fb:	ff 70 04             	push   0x4(%eax)
801035fe:	83 c3 1c             	add    $0x1c,%ebx
80103601:	53                   	push   %ebx
80103602:	e8 d1 09 00 00       	call   80103fd8 <swtch>
  mycpu()->intena = intena;
80103607:	e8 e8 fb ff ff       	call   801031f4 <mycpu>
8010360c:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103612:	83 c4 10             	add    $0x10,%esp
80103615:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103618:	5b                   	pop    %ebx
80103619:	5e                   	pop    %esi
8010361a:	5d                   	pop    %ebp
8010361b:	c3                   	ret
    panic("sched ptable.lock");
8010361c:	83 ec 0c             	sub    $0xc,%esp
8010361f:	68 91 6c 10 80       	push   $0x80106c91
80103624:	e8 1b cd ff ff       	call   80100344 <panic>
    panic("sched locks");
80103629:	83 ec 0c             	sub    $0xc,%esp
8010362c:	68 a3 6c 10 80       	push   $0x80106ca3
80103631:	e8 0e cd ff ff       	call   80100344 <panic>
    panic("sched running");
80103636:	83 ec 0c             	sub    $0xc,%esp
80103639:	68 af 6c 10 80       	push   $0x80106caf
8010363e:	e8 01 cd ff ff       	call   80100344 <panic>
    panic("sched interruptible");
80103643:	83 ec 0c             	sub    $0xc,%esp
80103646:	68 bd 6c 10 80       	push   $0x80106cbd
8010364b:	e8 f4 cc ff ff       	call   80100344 <panic>

80103650 <exit>:
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	56                   	push   %esi
80103654:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103655:	e8 2f fc ff ff       	call   80103289 <myproc>
  if (curproc == initproc)
8010365a:	39 05 a4 3f 11 80    	cmp    %eax,0x80113fa4
80103660:	74 09                	je     8010366b <exit+0x1b>
80103662:	89 c6                	mov    %eax,%esi
  for (fd = 0; fd < NOFILE; fd++)
80103664:	bb 00 00 00 00       	mov    $0x0,%ebx
80103669:	eb 22                	jmp    8010368d <exit+0x3d>
    panic("init exiting");
8010366b:	83 ec 0c             	sub    $0xc,%esp
8010366e:	68 d1 6c 10 80       	push   $0x80106cd1
80103673:	e8 cc cc ff ff       	call   80100344 <panic>
      fileclose(curproc->ofile[fd]);
80103678:	83 ec 0c             	sub    $0xc,%esp
8010367b:	50                   	push   %eax
8010367c:	e8 0a d6 ff ff       	call   80100c8b <fileclose>
      curproc->ofile[fd] = 0;
80103681:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
80103688:	00 
80103689:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
8010368c:	43                   	inc    %ebx
8010368d:	83 fb 0f             	cmp    $0xf,%ebx
80103690:	7f 0a                	jg     8010369c <exit+0x4c>
    if (curproc->ofile[fd])
80103692:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
80103696:	85 c0                	test   %eax,%eax
80103698:	75 de                	jne    80103678 <exit+0x28>
8010369a:	eb f0                	jmp    8010368c <exit+0x3c>
  begin_op();
8010369c:	e8 bf f0 ff ff       	call   80102760 <begin_op>
  iput(curproc->cwd);
801036a1:	83 ec 0c             	sub    $0xc,%esp
801036a4:	ff 76 68             	push   0x68(%esi)
801036a7:	e8 d2 df ff ff       	call   8010167e <iput>
  end_op();
801036ac:	e8 2b f1 ff ff       	call   801027dc <end_op>
  curproc->cwd = 0;
801036b1:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801036b8:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801036bf:	e8 c2 06 00 00       	call   80103d86 <acquire>
  wakeup1(curproc->parent);
801036c4:	8b 46 14             	mov    0x14(%esi),%eax
801036c7:	e8 60 fa ff ff       	call   8010312c <wakeup1>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036cc:	83 c4 10             	add    $0x10,%esp
801036cf:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801036d4:	eb 06                	jmp    801036dc <exit+0x8c>
801036d6:	81 c3 88 00 00 00    	add    $0x88,%ebx
801036dc:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
801036e2:	73 1a                	jae    801036fe <exit+0xae>
    if (p->parent == curproc)
801036e4:	39 73 14             	cmp    %esi,0x14(%ebx)
801036e7:	75 ed                	jne    801036d6 <exit+0x86>
      p->parent = initproc;
801036e9:	a1 a4 3f 11 80       	mov    0x80113fa4,%eax
801036ee:	89 43 14             	mov    %eax,0x14(%ebx)
      if (p->state == ZOMBIE)
801036f1:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801036f5:	75 df                	jne    801036d6 <exit+0x86>
        wakeup1(initproc);
801036f7:	e8 30 fa ff ff       	call   8010312c <wakeup1>
801036fc:	eb d8                	jmp    801036d6 <exit+0x86>
  deallocuvm(curproc->pgdir, KERNBASE, 0);
801036fe:	83 ec 04             	sub    $0x4,%esp
80103701:	6a 00                	push   $0x0
80103703:	68 00 00 00 80       	push   $0x80000000
80103708:	ff 76 04             	push   0x4(%esi)
8010370b:	e8 d0 2e 00 00       	call   801065e0 <deallocuvm>
  curproc->xstatus = status; // Guardamos el regalo para el padre.
80103710:	8b 45 08             	mov    0x8(%ebp),%eax
80103713:	89 46 7c             	mov    %eax,0x7c(%esi)
  curproc->state = ZOMBIE;
80103716:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010371d:	e8 8b fe ff ff       	call   801035ad <sched>
  panic("zombie exit");
80103722:	c7 04 24 de 6c 10 80 	movl   $0x80106cde,(%esp)
80103729:	e8 16 cc ff ff       	call   80100344 <panic>

8010372e <yield>:
{
8010372e:	55                   	push   %ebp
8010372f:	89 e5                	mov    %esp,%ebp
80103731:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock); // DOC: yieldlock
80103734:	68 20 1d 11 80       	push   $0x80111d20
80103739:	e8 48 06 00 00       	call   80103d86 <acquire>
  myproc()->state = RUNNABLE;
8010373e:	e8 46 fb ff ff       	call   80103289 <myproc>
80103743:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  prio_enqueue(myproc()); // Boletín 4: El proceso que cede el CPU se vuelve a encolar en su nivel de prioridad
8010374a:	e8 3a fb ff ff       	call   80103289 <myproc>
8010374f:	89 04 24             	mov    %eax,(%esp)
80103752:	e8 8a f9 ff ff       	call   801030e1 <prio_enqueue>
  sched();
80103757:	e8 51 fe ff ff       	call   801035ad <sched>
  release(&ptable.lock);
8010375c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103763:	e8 83 06 00 00       	call   80103deb <release>
}
80103768:	83 c4 10             	add    $0x10,%esp
8010376b:	c9                   	leave
8010376c:	c3                   	ret

8010376d <sleep>:
{
8010376d:	55                   	push   %ebp
8010376e:	89 e5                	mov    %esp,%ebp
80103770:	56                   	push   %esi
80103771:	53                   	push   %ebx
80103772:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103775:	e8 0f fb ff ff       	call   80103289 <myproc>
  if (p == 0)
8010377a:	85 c0                	test   %eax,%eax
8010377c:	74 66                	je     801037e4 <sleep+0x77>
8010377e:	89 c3                	mov    %eax,%ebx
  if (lk == 0)
80103780:	85 f6                	test   %esi,%esi
80103782:	74 6d                	je     801037f1 <sleep+0x84>
  if (lk != &ptable.lock)
80103784:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
8010378a:	74 18                	je     801037a4 <sleep+0x37>
    acquire(&ptable.lock); // DOC: sleeplock1
8010378c:	83 ec 0c             	sub    $0xc,%esp
8010378f:	68 20 1d 11 80       	push   $0x80111d20
80103794:	e8 ed 05 00 00       	call   80103d86 <acquire>
    release(lk);
80103799:	89 34 24             	mov    %esi,(%esp)
8010379c:	e8 4a 06 00 00       	call   80103deb <release>
801037a1:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
801037a4:	8b 45 08             	mov    0x8(%ebp),%eax
801037a7:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
801037aa:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801037b1:	e8 f7 fd ff ff       	call   801035ad <sched>
  p->chan = 0;
801037b6:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if (lk != &ptable.lock)
801037bd:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801037c3:	74 18                	je     801037dd <sleep+0x70>
    release(&ptable.lock);
801037c5:	83 ec 0c             	sub    $0xc,%esp
801037c8:	68 20 1d 11 80       	push   $0x80111d20
801037cd:	e8 19 06 00 00       	call   80103deb <release>
    acquire(lk);
801037d2:	89 34 24             	mov    %esi,(%esp)
801037d5:	e8 ac 05 00 00       	call   80103d86 <acquire>
801037da:	83 c4 10             	add    $0x10,%esp
}
801037dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037e0:	5b                   	pop    %ebx
801037e1:	5e                   	pop    %esi
801037e2:	5d                   	pop    %ebp
801037e3:	c3                   	ret
    panic("sleep");
801037e4:	83 ec 0c             	sub    $0xc,%esp
801037e7:	68 ea 6c 10 80       	push   $0x80106cea
801037ec:	e8 53 cb ff ff       	call   80100344 <panic>
    panic("sleep without lk");
801037f1:	83 ec 0c             	sub    $0xc,%esp
801037f4:	68 f0 6c 10 80       	push   $0x80106cf0
801037f9:	e8 46 cb ff ff       	call   80100344 <panic>

801037fe <wait>:
{
801037fe:	55                   	push   %ebp
801037ff:	89 e5                	mov    %esp,%ebp
80103801:	57                   	push   %edi
80103802:	56                   	push   %esi
80103803:	53                   	push   %ebx
80103804:	83 ec 0c             	sub    $0xc,%esp
80103807:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct proc *curproc = myproc();
8010380a:	e8 7a fa ff ff       	call   80103289 <myproc>
8010380f:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103811:	83 ec 0c             	sub    $0xc,%esp
80103814:	68 20 1d 11 80       	push   $0x80111d20
80103819:	e8 68 05 00 00       	call   80103d86 <acquire>
8010381e:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103821:	b8 00 00 00 00       	mov    $0x0,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103826:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
8010382b:	eb 6a                	jmp    80103897 <wait+0x99>
        pid = p->pid;
8010382d:	8b 73 10             	mov    0x10(%ebx),%esi
        if (status != 0)
80103830:	85 ff                	test   %edi,%edi
80103832:	74 05                	je     80103839 <wait+0x3b>
          *status = p->xstatus;
80103834:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103837:	89 07                	mov    %eax,(%edi)
        kfree(p->kstack);
80103839:	83 ec 0c             	sub    $0xc,%esp
8010383c:	ff 73 08             	push   0x8(%ebx)
8010383f:	e8 4c e7 ff ff       	call   80101f90 <kfree>
        p->kstack = 0;
80103844:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir, 0); // User zone deleted before
8010384b:	83 c4 08             	add    $0x8,%esp
8010384e:	6a 00                	push   $0x0
80103850:	ff 73 04             	push   0x4(%ebx)
80103853:	e8 ef 2e 00 00       	call   80106747 <freevm>
        p->pid = 0;
80103858:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010385f:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103866:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010386a:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103871:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103878:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010387f:	e8 67 05 00 00       	call   80103deb <release>
        return pid;
80103884:	83 c4 10             	add    $0x10,%esp
}
80103887:	89 f0                	mov    %esi,%eax
80103889:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010388c:	5b                   	pop    %ebx
8010388d:	5e                   	pop    %esi
8010388e:	5f                   	pop    %edi
8010388f:	5d                   	pop    %ebp
80103890:	c3                   	ret
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103891:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103897:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
8010389d:	73 12                	jae    801038b1 <wait+0xb3>
      if (p->parent != curproc)
8010389f:	39 73 14             	cmp    %esi,0x14(%ebx)
801038a2:	75 ed                	jne    80103891 <wait+0x93>
      if (p->state == ZOMBIE)
801038a4:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801038a8:	74 83                	je     8010382d <wait+0x2f>
      havekids = 1;
801038aa:	b8 01 00 00 00       	mov    $0x1,%eax
801038af:	eb e0                	jmp    80103891 <wait+0x93>
    if (!havekids || curproc->killed)
801038b1:	85 c0                	test   %eax,%eax
801038b3:	74 1c                	je     801038d1 <wait+0xd3>
801038b5:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
801038b9:	75 16                	jne    801038d1 <wait+0xd3>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
801038bb:	83 ec 08             	sub    $0x8,%esp
801038be:	68 20 1d 11 80       	push   $0x80111d20
801038c3:	56                   	push   %esi
801038c4:	e8 a4 fe ff ff       	call   8010376d <sleep>
    havekids = 0;
801038c9:	83 c4 10             	add    $0x10,%esp
801038cc:	e9 50 ff ff ff       	jmp    80103821 <wait+0x23>
      release(&ptable.lock);
801038d1:	83 ec 0c             	sub    $0xc,%esp
801038d4:	68 20 1d 11 80       	push   $0x80111d20
801038d9:	e8 0d 05 00 00       	call   80103deb <release>
      return -1;
801038de:	83 c4 10             	add    $0x10,%esp
801038e1:	be ff ff ff ff       	mov    $0xffffffff,%esi
801038e6:	eb 9f                	jmp    80103887 <wait+0x89>

801038e8 <wakeup>:

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
801038e8:	55                   	push   %ebp
801038e9:	89 e5                	mov    %esp,%ebp
801038eb:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801038ee:	68 20 1d 11 80       	push   $0x80111d20
801038f3:	e8 8e 04 00 00       	call   80103d86 <acquire>
  wakeup1(chan);
801038f8:	8b 45 08             	mov    0x8(%ebp),%eax
801038fb:	e8 2c f8 ff ff       	call   8010312c <wakeup1>
  release(&ptable.lock);
80103900:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103907:	e8 df 04 00 00       	call   80103deb <release>
}
8010390c:	83 c4 10             	add    $0x10,%esp
8010390f:	c9                   	leave
80103910:	c3                   	ret

80103911 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80103911:	55                   	push   %ebp
80103912:	89 e5                	mov    %esp,%ebp
80103914:	53                   	push   %ebx
80103915:	83 ec 10             	sub    $0x10,%esp
80103918:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010391b:	68 20 1d 11 80       	push   $0x80111d20
80103920:	e8 61 04 00 00       	call   80103d86 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103925:	83 c4 10             	add    $0x10,%esp
80103928:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010392d:	eb 1a                	jmp    80103949 <kill+0x38>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
      {
        p->state = RUNNABLE;
8010392f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        prio_enqueue(p); // Boletín 4: El proceso que se mata se encola en su nivel de prioridad
80103936:	83 ec 0c             	sub    $0xc,%esp
80103939:	50                   	push   %eax
8010393a:	e8 a2 f7 ff ff       	call   801030e1 <prio_enqueue>
8010393f:	83 c4 10             	add    $0x10,%esp
80103942:	eb 1e                	jmp    80103962 <kill+0x51>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103944:	05 88 00 00 00       	add    $0x88,%eax
80103949:	3d 54 3f 11 80       	cmp    $0x80113f54,%eax
8010394e:	73 2c                	jae    8010397c <kill+0x6b>
    if (p->pid == pid)
80103950:	39 58 10             	cmp    %ebx,0x10(%eax)
80103953:	75 ef                	jne    80103944 <kill+0x33>
      p->killed = 1;
80103955:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
8010395c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103960:	74 cd                	je     8010392f <kill+0x1e>
      }
      release(&ptable.lock);
80103962:	83 ec 0c             	sub    $0xc,%esp
80103965:	68 20 1d 11 80       	push   $0x80111d20
8010396a:	e8 7c 04 00 00       	call   80103deb <release>
      return 0;
8010396f:	83 c4 10             	add    $0x10,%esp
80103972:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103977:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010397a:	c9                   	leave
8010397b:	c3                   	ret
  release(&ptable.lock);
8010397c:	83 ec 0c             	sub    $0xc,%esp
8010397f:	68 20 1d 11 80       	push   $0x80111d20
80103984:	e8 62 04 00 00       	call   80103deb <release>
  return -1;
80103989:	83 c4 10             	add    $0x10,%esp
8010398c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103991:	eb e4                	jmp    80103977 <kill+0x66>

80103993 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80103993:	55                   	push   %ebp
80103994:	89 e5                	mov    %esp,%ebp
80103996:	56                   	push   %esi
80103997:	53                   	push   %ebx
80103998:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010399b:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801039a0:	eb 36                	jmp    801039d8 <procdump+0x45>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
801039a2:	b8 01 6d 10 80       	mov    $0x80106d01,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
801039a7:	8d 53 6c             	lea    0x6c(%ebx),%edx
801039aa:	52                   	push   %edx
801039ab:	50                   	push   %eax
801039ac:	ff 73 10             	push   0x10(%ebx)
801039af:	68 05 6d 10 80       	push   $0x80106d05
801039b4:	e8 26 cc ff ff       	call   801005df <cprintf>
    if (p->state == SLEEPING)
801039b9:	83 c4 10             	add    $0x10,%esp
801039bc:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801039c0:	74 3c                	je     801039fe <procdump+0x6b>
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801039c2:	83 ec 0c             	sub    $0xc,%esp
801039c5:	68 e7 6e 10 80       	push   $0x80106ee7
801039ca:	e8 10 cc ff ff       	call   801005df <cprintf>
801039cf:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039d2:	81 c3 88 00 00 00    	add    $0x88,%ebx
801039d8:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
801039de:	73 5f                	jae    80103a3f <procdump+0xac>
    if (p->state == UNUSED)
801039e0:	8b 43 0c             	mov    0xc(%ebx),%eax
801039e3:	85 c0                	test   %eax,%eax
801039e5:	74 eb                	je     801039d2 <procdump+0x3f>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801039e7:	83 f8 05             	cmp    $0x5,%eax
801039ea:	77 b6                	ja     801039a2 <procdump+0xf>
801039ec:	8b 04 85 00 73 10 80 	mov    -0x7fef8d00(,%eax,4),%eax
801039f3:	85 c0                	test   %eax,%eax
801039f5:	75 b0                	jne    801039a7 <procdump+0x14>
      state = "???";
801039f7:	b8 01 6d 10 80       	mov    $0x80106d01,%eax
801039fc:	eb a9                	jmp    801039a7 <procdump+0x14>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
801039fe:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a01:	8b 40 0c             	mov    0xc(%eax),%eax
80103a04:	83 c0 08             	add    $0x8,%eax
80103a07:	83 ec 08             	sub    $0x8,%esp
80103a0a:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103a0d:	52                   	push   %edx
80103a0e:	50                   	push   %eax
80103a0f:	e8 4d 02 00 00       	call   80103c61 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80103a14:	83 c4 10             	add    $0x10,%esp
80103a17:	be 00 00 00 00       	mov    $0x0,%esi
80103a1c:	eb 12                	jmp    80103a30 <procdump+0x9d>
        cprintf(" %p", pc[i]);
80103a1e:	83 ec 08             	sub    $0x8,%esp
80103a21:	50                   	push   %eax
80103a22:	68 41 6a 10 80       	push   $0x80106a41
80103a27:	e8 b3 cb ff ff       	call   801005df <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80103a2c:	46                   	inc    %esi
80103a2d:	83 c4 10             	add    $0x10,%esp
80103a30:	83 fe 09             	cmp    $0x9,%esi
80103a33:	7f 8d                	jg     801039c2 <procdump+0x2f>
80103a35:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103a39:	85 c0                	test   %eax,%eax
80103a3b:	75 e1                	jne    80103a1e <procdump+0x8b>
80103a3d:	eb 83                	jmp    801039c2 <procdump+0x2f>
  }
}
80103a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a42:	5b                   	pop    %ebx
80103a43:	5e                   	pop    %esi
80103a44:	5d                   	pop    %ebp
80103a45:	c3                   	ret

80103a46 <getprio>:

// BOLETÍN 4: Funciones para obtener y establecer la prioridad de un proceso
//  Devuelve la prioridad de un proceso dado su PID
int getprio(int pid)
{
80103a46:	55                   	push   %ebp
80103a47:	89 e5                	mov    %esp,%ebp
80103a49:	53                   	push   %ebx
80103a4a:	83 ec 10             	sub    $0x10,%esp
80103a4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  int prio = -1;

  acquire(&ptable.lock);
80103a50:	68 20 1d 11 80       	push   $0x80111d20
80103a55:	e8 2c 03 00 00       	call   80103d86 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a5a:	83 c4 10             	add    $0x10,%esp
80103a5d:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103a62:	eb 05                	jmp    80103a69 <getprio+0x23>
80103a64:	05 88 00 00 00       	add    $0x88,%eax
80103a69:	3d 54 3f 11 80       	cmp    $0x80113f54,%eax
80103a6e:	73 1f                	jae    80103a8f <getprio+0x49>
  {
    if (p->pid == pid)
80103a70:	39 58 10             	cmp    %ebx,0x10(%eax)
80103a73:	75 ef                	jne    80103a64 <getprio+0x1e>
    {
      prio = p->priority;
80103a75:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
      break;
    }
  }
  release(&ptable.lock);
80103a7b:	83 ec 0c             	sub    $0xc,%esp
80103a7e:	68 20 1d 11 80       	push   $0x80111d20
80103a83:	e8 63 03 00 00       	call   80103deb <release>

  return prio;
}
80103a88:	89 d8                	mov    %ebx,%eax
80103a8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8d:	c9                   	leave
80103a8e:	c3                   	ret
  int prio = -1;
80103a8f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103a94:	eb e5                	jmp    80103a7b <getprio+0x35>

80103a96 <setprio>:

// Establece una nueva prioridad para un proceso dado su PID
int setprio(int pid, int priority)
{
80103a96:	55                   	push   %ebp
80103a97:	89 e5                	mov    %esp,%ebp
80103a99:	57                   	push   %edi
80103a9a:	56                   	push   %esi
80103a9b:	53                   	push   %ebx
80103a9c:	83 ec 0c             	sub    $0xc,%esp
80103a9f:	8b 75 08             	mov    0x8(%ebp),%esi
80103aa2:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct proc *p;

  // Validar rango de prioridad (0 a NPRIO-1)
  if (priority < 0 || priority >= NPRIO)
80103aa5:	83 ff 09             	cmp    $0x9,%edi
80103aa8:	0f 87 86 00 00 00    	ja     80103b34 <setprio+0x9e>
    return -1;

  acquire(&ptable.lock);
80103aae:	83 ec 0c             	sub    $0xc,%esp
80103ab1:	68 20 1d 11 80       	push   $0x80111d20
80103ab6:	e8 cb 02 00 00       	call   80103d86 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103abb:	83 c4 10             	add    $0x10,%esp
80103abe:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103ac3:	eb 22                	jmp    80103ae7 <setprio+0x51>

      // Si el proceso ya estaba en una cola de listos (RUNNABLE)
      // hay que sacarlo de la cola vieja y meterlo en la nueva
      if (p->state == RUNNABLE)
      {
        prio_remove(p);
80103ac5:	83 ec 0c             	sub    $0xc,%esp
80103ac8:	53                   	push   %ebx
80103ac9:	e8 a1 f6 ff ff       	call   8010316f <prio_remove>
        p->priority = priority;
80103ace:	89 bb 80 00 00 00    	mov    %edi,0x80(%ebx)
        prio_enqueue(p);
80103ad4:	89 1c 24             	mov    %ebx,(%esp)
80103ad7:	e8 05 f6 ff ff       	call   801030e1 <prio_enqueue>
80103adc:	83 c4 10             	add    $0x10,%esp
80103adf:	eb 1f                	jmp    80103b00 <setprio+0x6a>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ae1:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103ae7:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80103aed:	73 2e                	jae    80103b1d <setprio+0x87>
    if (p->pid == pid)
80103aef:	39 73 10             	cmp    %esi,0x10(%ebx)
80103af2:	75 ed                	jne    80103ae1 <setprio+0x4b>
      if (p->state == RUNNABLE)
80103af4:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103af8:	74 cb                	je     80103ac5 <setprio+0x2f>
      }
      else
      {
        // Si está durmiendo o corriendo, solo le cambiamos la etiqueta.
        // Cuando despierte o ceda la CPU, entrará en la cola correcta.
        p->priority = priority;
80103afa:	89 bb 80 00 00 00    	mov    %edi,0x80(%ebx)
      }

      release(&ptable.lock);
80103b00:	83 ec 0c             	sub    $0xc,%esp
80103b03:	68 20 1d 11 80       	push   $0x80111d20
80103b08:	e8 de 02 00 00       	call   80103deb <release>
      return 0; // Éxito
80103b0d:	83 c4 10             	add    $0x10,%esp
80103b10:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);

  return -1; // PID no encontrado
}
80103b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b18:	5b                   	pop    %ebx
80103b19:	5e                   	pop    %esi
80103b1a:	5f                   	pop    %edi
80103b1b:	5d                   	pop    %ebp
80103b1c:	c3                   	ret
  release(&ptable.lock);
80103b1d:	83 ec 0c             	sub    $0xc,%esp
80103b20:	68 20 1d 11 80       	push   $0x80111d20
80103b25:	e8 c1 02 00 00       	call   80103deb <release>
  return -1; // PID no encontrado
80103b2a:	83 c4 10             	add    $0x10,%esp
80103b2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b32:	eb e1                	jmp    80103b15 <setprio+0x7f>
    return -1;
80103b34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b39:	eb da                	jmp    80103b15 <setprio+0x7f>

80103b3b <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103b3b:	55                   	push   %ebp
80103b3c:	89 e5                	mov    %esp,%ebp
80103b3e:	53                   	push   %ebx
80103b3f:	83 ec 0c             	sub    $0xc,%esp
80103b42:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103b45:	68 38 6d 10 80       	push   $0x80106d38
80103b4a:	8d 43 04             	lea    0x4(%ebx),%eax
80103b4d:	50                   	push   %eax
80103b4e:	e8 f3 00 00 00       	call   80103c46 <initlock>
  lk->name = name;
80103b53:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b56:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103b59:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b5f:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103b66:	83 c4 10             	add    $0x10,%esp
80103b69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b6c:	c9                   	leave
80103b6d:	c3                   	ret

80103b6e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103b6e:	55                   	push   %ebp
80103b6f:	89 e5                	mov    %esp,%ebp
80103b71:	56                   	push   %esi
80103b72:	53                   	push   %ebx
80103b73:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b76:	8d 73 04             	lea    0x4(%ebx),%esi
80103b79:	83 ec 0c             	sub    $0xc,%esp
80103b7c:	56                   	push   %esi
80103b7d:	e8 04 02 00 00       	call   80103d86 <acquire>
  while (lk->locked) {
80103b82:	83 c4 10             	add    $0x10,%esp
80103b85:	eb 0d                	jmp    80103b94 <acquiresleep+0x26>
    sleep(lk, &lk->lk);
80103b87:	83 ec 08             	sub    $0x8,%esp
80103b8a:	56                   	push   %esi
80103b8b:	53                   	push   %ebx
80103b8c:	e8 dc fb ff ff       	call   8010376d <sleep>
80103b91:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80103b94:	83 3b 00             	cmpl   $0x0,(%ebx)
80103b97:	75 ee                	jne    80103b87 <acquiresleep+0x19>
  }
  lk->locked = 1;
80103b99:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103b9f:	e8 e5 f6 ff ff       	call   80103289 <myproc>
80103ba4:	8b 40 10             	mov    0x10(%eax),%eax
80103ba7:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103baa:	83 ec 0c             	sub    $0xc,%esp
80103bad:	56                   	push   %esi
80103bae:	e8 38 02 00 00       	call   80103deb <release>
}
80103bb3:	83 c4 10             	add    $0x10,%esp
80103bb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bb9:	5b                   	pop    %ebx
80103bba:	5e                   	pop    %esi
80103bbb:	5d                   	pop    %ebp
80103bbc:	c3                   	ret

80103bbd <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103bbd:	55                   	push   %ebp
80103bbe:	89 e5                	mov    %esp,%ebp
80103bc0:	56                   	push   %esi
80103bc1:	53                   	push   %ebx
80103bc2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103bc5:	8d 73 04             	lea    0x4(%ebx),%esi
80103bc8:	83 ec 0c             	sub    $0xc,%esp
80103bcb:	56                   	push   %esi
80103bcc:	e8 b5 01 00 00       	call   80103d86 <acquire>
  lk->locked = 0;
80103bd1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103bd7:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103bde:	89 1c 24             	mov    %ebx,(%esp)
80103be1:	e8 02 fd ff ff       	call   801038e8 <wakeup>
  release(&lk->lk);
80103be6:	89 34 24             	mov    %esi,(%esp)
80103be9:	e8 fd 01 00 00       	call   80103deb <release>
}
80103bee:	83 c4 10             	add    $0x10,%esp
80103bf1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf4:	5b                   	pop    %ebx
80103bf5:	5e                   	pop    %esi
80103bf6:	5d                   	pop    %ebp
80103bf7:	c3                   	ret

80103bf8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103bf8:	55                   	push   %ebp
80103bf9:	89 e5                	mov    %esp,%ebp
80103bfb:	56                   	push   %esi
80103bfc:	53                   	push   %ebx
80103bfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103c00:	8d 73 04             	lea    0x4(%ebx),%esi
80103c03:	83 ec 0c             	sub    $0xc,%esp
80103c06:	56                   	push   %esi
80103c07:	e8 7a 01 00 00       	call   80103d86 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103c0c:	83 c4 10             	add    $0x10,%esp
80103c0f:	83 3b 00             	cmpl   $0x0,(%ebx)
80103c12:	75 17                	jne    80103c2b <holdingsleep+0x33>
80103c14:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103c19:	83 ec 0c             	sub    $0xc,%esp
80103c1c:	56                   	push   %esi
80103c1d:	e8 c9 01 00 00       	call   80103deb <release>
  return r;
}
80103c22:	89 d8                	mov    %ebx,%eax
80103c24:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c27:	5b                   	pop    %ebx
80103c28:	5e                   	pop    %esi
80103c29:	5d                   	pop    %ebp
80103c2a:	c3                   	ret
  r = lk->locked && (lk->pid == myproc()->pid);
80103c2b:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103c2e:	e8 56 f6 ff ff       	call   80103289 <myproc>
80103c33:	3b 58 10             	cmp    0x10(%eax),%ebx
80103c36:	74 07                	je     80103c3f <holdingsleep+0x47>
80103c38:	bb 00 00 00 00       	mov    $0x0,%ebx
80103c3d:	eb da                	jmp    80103c19 <holdingsleep+0x21>
80103c3f:	bb 01 00 00 00       	mov    $0x1,%ebx
80103c44:	eb d3                	jmp    80103c19 <holdingsleep+0x21>

80103c46 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103c46:	55                   	push   %ebp
80103c47:	89 e5                	mov    %esp,%ebp
80103c49:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103c4c:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c4f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103c52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103c58:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103c5f:	5d                   	pop    %ebp
80103c60:	c3                   	ret

80103c61 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103c61:	55                   	push   %ebp
80103c62:	89 e5                	mov    %esp,%ebp
80103c64:	53                   	push   %ebx
80103c65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103c68:	8b 45 08             	mov    0x8(%ebp),%eax
80103c6b:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103c6e:	b8 00 00 00 00       	mov    $0x0,%eax
80103c73:	83 f8 09             	cmp    $0x9,%eax
80103c76:	7f 21                	jg     80103c99 <getcallerpcs+0x38>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103c78:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103c7e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103c84:	77 13                	ja     80103c99 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103c86:	8b 5a 04             	mov    0x4(%edx),%ebx
80103c89:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103c8c:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103c8e:	40                   	inc    %eax
80103c8f:	eb e2                	jmp    80103c73 <getcallerpcs+0x12>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103c91:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103c98:	40                   	inc    %eax
80103c99:	83 f8 09             	cmp    $0x9,%eax
80103c9c:	7e f3                	jle    80103c91 <getcallerpcs+0x30>
}
80103c9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ca1:	c9                   	leave
80103ca2:	c3                   	ret

80103ca3 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103ca3:	55                   	push   %ebp
80103ca4:	89 e5                	mov    %esp,%ebp
80103ca6:	53                   	push   %ebx
80103ca7:	83 ec 04             	sub    $0x4,%esp
80103caa:	9c                   	pushf
80103cab:	5b                   	pop    %ebx
  asm volatile("cli");
80103cac:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103cad:	e8 42 f5 ff ff       	call   801031f4 <mycpu>
80103cb2:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103cb9:	74 19                	je     80103cd4 <pushcli+0x31>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103cbb:	e8 34 f5 ff ff       	call   801031f4 <mycpu>
80103cc0:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103cc6:	8d 51 01             	lea    0x1(%ecx),%edx
80103cc9:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80103ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cd2:	c9                   	leave
80103cd3:	c3                   	ret
    mycpu()->intena = eflags & FL_IF;
80103cd4:	e8 1b f5 ff ff       	call   801031f4 <mycpu>
80103cd9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103cdf:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103ce5:	eb d4                	jmp    80103cbb <pushcli+0x18>

80103ce7 <popcli>:

void
popcli(void)
{
80103ce7:	55                   	push   %ebp
80103ce8:	89 e5                	mov    %esp,%ebp
80103cea:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ced:	9c                   	pushf
80103cee:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103cef:	f6 c4 02             	test   $0x2,%ah
80103cf2:	75 28                	jne    80103d1c <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103cf4:	e8 fb f4 ff ff       	call   801031f4 <mycpu>
80103cf9:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103cff:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103d02:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103d08:	85 d2                	test   %edx,%edx
80103d0a:	78 1d                	js     80103d29 <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103d0c:	e8 e3 f4 ff ff       	call   801031f4 <mycpu>
80103d11:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103d18:	74 1c                	je     80103d36 <popcli+0x4f>
    sti();
}
80103d1a:	c9                   	leave
80103d1b:	c3                   	ret
    panic("popcli - interruptible");
80103d1c:	83 ec 0c             	sub    $0xc,%esp
80103d1f:	68 43 6d 10 80       	push   $0x80106d43
80103d24:	e8 1b c6 ff ff       	call   80100344 <panic>
    panic("popcli");
80103d29:	83 ec 0c             	sub    $0xc,%esp
80103d2c:	68 5a 6d 10 80       	push   $0x80106d5a
80103d31:	e8 0e c6 ff ff       	call   80100344 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103d36:	e8 b9 f4 ff ff       	call   801031f4 <mycpu>
80103d3b:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103d42:	74 d6                	je     80103d1a <popcli+0x33>
  asm volatile("sti");
80103d44:	fb                   	sti
}
80103d45:	eb d3                	jmp    80103d1a <popcli+0x33>

80103d47 <holding>:
{
80103d47:	55                   	push   %ebp
80103d48:	89 e5                	mov    %esp,%ebp
80103d4a:	53                   	push   %ebx
80103d4b:	83 ec 04             	sub    $0x4,%esp
80103d4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103d51:	e8 4d ff ff ff       	call   80103ca3 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103d56:	83 3b 00             	cmpl   $0x0,(%ebx)
80103d59:	75 11                	jne    80103d6c <holding+0x25>
80103d5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103d60:	e8 82 ff ff ff       	call   80103ce7 <popcli>
}
80103d65:	89 d8                	mov    %ebx,%eax
80103d67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d6a:	c9                   	leave
80103d6b:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80103d6c:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103d6f:	e8 80 f4 ff ff       	call   801031f4 <mycpu>
80103d74:	39 c3                	cmp    %eax,%ebx
80103d76:	74 07                	je     80103d7f <holding+0x38>
80103d78:	bb 00 00 00 00       	mov    $0x0,%ebx
80103d7d:	eb e1                	jmp    80103d60 <holding+0x19>
80103d7f:	bb 01 00 00 00       	mov    $0x1,%ebx
80103d84:	eb da                	jmp    80103d60 <holding+0x19>

80103d86 <acquire>:
{
80103d86:	55                   	push   %ebp
80103d87:	89 e5                	mov    %esp,%ebp
80103d89:	53                   	push   %ebx
80103d8a:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103d8d:	e8 11 ff ff ff       	call   80103ca3 <pushcli>
  if(holding(lk))
80103d92:	83 ec 0c             	sub    $0xc,%esp
80103d95:	ff 75 08             	push   0x8(%ebp)
80103d98:	e8 aa ff ff ff       	call   80103d47 <holding>
80103d9d:	83 c4 10             	add    $0x10,%esp
80103da0:	85 c0                	test   %eax,%eax
80103da2:	75 3a                	jne    80103dde <acquire+0x58>
  while(xchg(&lk->locked, 1) != 0)
80103da4:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103da7:	b8 01 00 00 00       	mov    $0x1,%eax
80103dac:	f0 87 02             	lock xchg %eax,(%edx)
80103daf:	85 c0                	test   %eax,%eax
80103db1:	75 f1                	jne    80103da4 <acquire+0x1e>
  __sync_synchronize();
80103db3:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103db8:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103dbb:	e8 34 f4 ff ff       	call   801031f4 <mycpu>
80103dc0:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103dc3:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc6:	83 c0 0c             	add    $0xc,%eax
80103dc9:	83 ec 08             	sub    $0x8,%esp
80103dcc:	50                   	push   %eax
80103dcd:	8d 45 08             	lea    0x8(%ebp),%eax
80103dd0:	50                   	push   %eax
80103dd1:	e8 8b fe ff ff       	call   80103c61 <getcallerpcs>
}
80103dd6:	83 c4 10             	add    $0x10,%esp
80103dd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ddc:	c9                   	leave
80103ddd:	c3                   	ret
    panic("acquire");
80103dde:	83 ec 0c             	sub    $0xc,%esp
80103de1:	68 61 6d 10 80       	push   $0x80106d61
80103de6:	e8 59 c5 ff ff       	call   80100344 <panic>

80103deb <release>:
{
80103deb:	55                   	push   %ebp
80103dec:	89 e5                	mov    %esp,%ebp
80103dee:	53                   	push   %ebx
80103def:	83 ec 10             	sub    $0x10,%esp
80103df2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103df5:	53                   	push   %ebx
80103df6:	e8 4c ff ff ff       	call   80103d47 <holding>
80103dfb:	83 c4 10             	add    $0x10,%esp
80103dfe:	85 c0                	test   %eax,%eax
80103e00:	74 23                	je     80103e25 <release+0x3a>
  lk->pcs[0] = 0;
80103e02:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103e09:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103e10:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103e15:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103e1b:	e8 c7 fe ff ff       	call   80103ce7 <popcli>
}
80103e20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e23:	c9                   	leave
80103e24:	c3                   	ret
    panic("release");
80103e25:	83 ec 0c             	sub    $0xc,%esp
80103e28:	68 69 6d 10 80       	push   $0x80106d69
80103e2d:	e8 12 c5 ff ff       	call   80100344 <panic>

80103e32 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103e32:	55                   	push   %ebp
80103e33:	89 e5                	mov    %esp,%ebp
80103e35:	57                   	push   %edi
80103e36:	53                   	push   %ebx
80103e37:	8b 55 08             	mov    0x8(%ebp),%edx
80103e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80103e3d:	f6 c2 03             	test   $0x3,%dl
80103e40:	75 29                	jne    80103e6b <memset+0x39>
80103e42:	f6 45 10 03          	testb  $0x3,0x10(%ebp)
80103e46:	75 23                	jne    80103e6b <memset+0x39>
    c &= 0xFF;
80103e48:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103e4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103e4e:	c1 e9 02             	shr    $0x2,%ecx
80103e51:	c1 e0 18             	shl    $0x18,%eax
80103e54:	89 fb                	mov    %edi,%ebx
80103e56:	c1 e3 10             	shl    $0x10,%ebx
80103e59:	09 d8                	or     %ebx,%eax
80103e5b:	89 fb                	mov    %edi,%ebx
80103e5d:	c1 e3 08             	shl    $0x8,%ebx
80103e60:	09 d8                	or     %ebx,%eax
80103e62:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103e64:	89 d7                	mov    %edx,%edi
80103e66:	fc                   	cld
80103e67:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103e69:	eb 08                	jmp    80103e73 <memset+0x41>
  asm volatile("cld; rep stosb" :
80103e6b:	89 d7                	mov    %edx,%edi
80103e6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103e70:	fc                   	cld
80103e71:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80103e73:	89 d0                	mov    %edx,%eax
80103e75:	5b                   	pop    %ebx
80103e76:	5f                   	pop    %edi
80103e77:	5d                   	pop    %ebp
80103e78:	c3                   	ret

80103e79 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103e79:	55                   	push   %ebp
80103e7a:	89 e5                	mov    %esp,%ebp
80103e7c:	56                   	push   %esi
80103e7d:	53                   	push   %ebx
80103e7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103e81:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e84:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103e87:	eb 04                	jmp    80103e8d <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80103e89:	41                   	inc    %ecx
80103e8a:	42                   	inc    %edx
  while(n-- > 0){
80103e8b:	89 f0                	mov    %esi,%eax
80103e8d:	8d 70 ff             	lea    -0x1(%eax),%esi
80103e90:	85 c0                	test   %eax,%eax
80103e92:	74 10                	je     80103ea4 <memcmp+0x2b>
    if(*s1 != *s2)
80103e94:	8a 01                	mov    (%ecx),%al
80103e96:	8a 1a                	mov    (%edx),%bl
80103e98:	38 d8                	cmp    %bl,%al
80103e9a:	74 ed                	je     80103e89 <memcmp+0x10>
      return *s1 - *s2;
80103e9c:	0f b6 c0             	movzbl %al,%eax
80103e9f:	0f b6 db             	movzbl %bl,%ebx
80103ea2:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80103ea4:	5b                   	pop    %ebx
80103ea5:	5e                   	pop    %esi
80103ea6:	5d                   	pop    %ebp
80103ea7:	c3                   	ret

80103ea8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103ea8:	55                   	push   %ebp
80103ea9:	89 e5                	mov    %esp,%ebp
80103eab:	56                   	push   %esi
80103eac:	53                   	push   %ebx
80103ead:	8b 75 08             	mov    0x8(%ebp),%esi
80103eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
80103eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103eb6:	39 f2                	cmp    %esi,%edx
80103eb8:	73 36                	jae    80103ef0 <memmove+0x48>
80103eba:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103ebd:	39 ce                	cmp    %ecx,%esi
80103ebf:	73 33                	jae    80103ef4 <memmove+0x4c>
    s += n;
    d += n;
80103ec1:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
80103ec4:	eb 08                	jmp    80103ece <memmove+0x26>
      *--d = *--s;
80103ec6:	49                   	dec    %ecx
80103ec7:	4a                   	dec    %edx
80103ec8:	8a 01                	mov    (%ecx),%al
80103eca:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
80103ecc:	89 d8                	mov    %ebx,%eax
80103ece:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103ed1:	85 c0                	test   %eax,%eax
80103ed3:	75 f1                	jne    80103ec6 <memmove+0x1e>
80103ed5:	eb 13                	jmp    80103eea <memmove+0x42>
  } else
    while(n-- > 0)
      *d++ = *s++;
80103ed7:	8a 02                	mov    (%edx),%al
80103ed9:	88 01                	mov    %al,(%ecx)
80103edb:	8d 49 01             	lea    0x1(%ecx),%ecx
80103ede:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
80103ee1:	89 d8                	mov    %ebx,%eax
80103ee3:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103ee6:	85 c0                	test   %eax,%eax
80103ee8:	75 ed                	jne    80103ed7 <memmove+0x2f>

  return dst;
}
80103eea:	89 f0                	mov    %esi,%eax
80103eec:	5b                   	pop    %ebx
80103eed:	5e                   	pop    %esi
80103eee:	5d                   	pop    %ebp
80103eef:	c3                   	ret
80103ef0:	89 f1                	mov    %esi,%ecx
80103ef2:	eb ef                	jmp    80103ee3 <memmove+0x3b>
80103ef4:	89 f1                	mov    %esi,%ecx
80103ef6:	eb eb                	jmp    80103ee3 <memmove+0x3b>

80103ef8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103ef8:	55                   	push   %ebp
80103ef9:	89 e5                	mov    %esp,%ebp
80103efb:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80103efe:	ff 75 10             	push   0x10(%ebp)
80103f01:	ff 75 0c             	push   0xc(%ebp)
80103f04:	ff 75 08             	push   0x8(%ebp)
80103f07:	e8 9c ff ff ff       	call   80103ea8 <memmove>
}
80103f0c:	c9                   	leave
80103f0d:	c3                   	ret

80103f0e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103f0e:	55                   	push   %ebp
80103f0f:	89 e5                	mov    %esp,%ebp
80103f11:	53                   	push   %ebx
80103f12:	8b 55 08             	mov    0x8(%ebp),%edx
80103f15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103f18:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80103f1b:	eb 03                	jmp    80103f20 <strncmp+0x12>
    n--, p++, q++;
80103f1d:	48                   	dec    %eax
80103f1e:	42                   	inc    %edx
80103f1f:	41                   	inc    %ecx
  while(n > 0 && *p && *p == *q)
80103f20:	85 c0                	test   %eax,%eax
80103f22:	74 0a                	je     80103f2e <strncmp+0x20>
80103f24:	8a 1a                	mov    (%edx),%bl
80103f26:	84 db                	test   %bl,%bl
80103f28:	74 04                	je     80103f2e <strncmp+0x20>
80103f2a:	3a 19                	cmp    (%ecx),%bl
80103f2c:	74 ef                	je     80103f1d <strncmp+0xf>
  if(n == 0)
80103f2e:	85 c0                	test   %eax,%eax
80103f30:	74 0d                	je     80103f3f <strncmp+0x31>
    return 0;
  return (uchar)*p - (uchar)*q;
80103f32:	0f b6 02             	movzbl (%edx),%eax
80103f35:	0f b6 11             	movzbl (%ecx),%edx
80103f38:	29 d0                	sub    %edx,%eax
}
80103f3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f3d:	c9                   	leave
80103f3e:	c3                   	ret
    return 0;
80103f3f:	b8 00 00 00 00       	mov    $0x0,%eax
80103f44:	eb f4                	jmp    80103f3a <strncmp+0x2c>

80103f46 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103f46:	55                   	push   %ebp
80103f47:	89 e5                	mov    %esp,%ebp
80103f49:	57                   	push   %edi
80103f4a:	56                   	push   %esi
80103f4b:	53                   	push   %ebx
80103f4c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103f52:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103f55:	89 c1                	mov    %eax,%ecx
80103f57:	eb 04                	jmp    80103f5d <strncpy+0x17>
80103f59:	89 fb                	mov    %edi,%ebx
80103f5b:	89 f1                	mov    %esi,%ecx
80103f5d:	89 d6                	mov    %edx,%esi
80103f5f:	4a                   	dec    %edx
80103f60:	85 f6                	test   %esi,%esi
80103f62:	7e 10                	jle    80103f74 <strncpy+0x2e>
80103f64:	8d 7b 01             	lea    0x1(%ebx),%edi
80103f67:	8d 71 01             	lea    0x1(%ecx),%esi
80103f6a:	8a 1b                	mov    (%ebx),%bl
80103f6c:	88 19                	mov    %bl,(%ecx)
80103f6e:	84 db                	test   %bl,%bl
80103f70:	75 e7                	jne    80103f59 <strncpy+0x13>
80103f72:	89 f1                	mov    %esi,%ecx
    ;
  while(n-- > 0)
80103f74:	8d 5a ff             	lea    -0x1(%edx),%ebx
80103f77:	85 d2                	test   %edx,%edx
80103f79:	7e 0a                	jle    80103f85 <strncpy+0x3f>
    *s++ = 0;
80103f7b:	c6 01 00             	movb   $0x0,(%ecx)
  while(n-- > 0)
80103f7e:	89 da                	mov    %ebx,%edx
    *s++ = 0;
80103f80:	8d 49 01             	lea    0x1(%ecx),%ecx
80103f83:	eb ef                	jmp    80103f74 <strncpy+0x2e>
  return os;
}
80103f85:	5b                   	pop    %ebx
80103f86:	5e                   	pop    %esi
80103f87:	5f                   	pop    %edi
80103f88:	5d                   	pop    %ebp
80103f89:	c3                   	ret

80103f8a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103f8a:	55                   	push   %ebp
80103f8b:	89 e5                	mov    %esp,%ebp
80103f8d:	57                   	push   %edi
80103f8e:	56                   	push   %esi
80103f8f:	53                   	push   %ebx
80103f90:	8b 45 08             	mov    0x8(%ebp),%eax
80103f93:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103f96:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80103f99:	85 d2                	test   %edx,%edx
80103f9b:	7e 20                	jle    80103fbd <safestrcpy+0x33>
80103f9d:	89 c1                	mov    %eax,%ecx
80103f9f:	eb 04                	jmp    80103fa5 <safestrcpy+0x1b>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103fa1:	89 fb                	mov    %edi,%ebx
80103fa3:	89 f1                	mov    %esi,%ecx
80103fa5:	4a                   	dec    %edx
80103fa6:	85 d2                	test   %edx,%edx
80103fa8:	7e 10                	jle    80103fba <safestrcpy+0x30>
80103faa:	8d 7b 01             	lea    0x1(%ebx),%edi
80103fad:	8d 71 01             	lea    0x1(%ecx),%esi
80103fb0:	8a 1b                	mov    (%ebx),%bl
80103fb2:	88 19                	mov    %bl,(%ecx)
80103fb4:	84 db                	test   %bl,%bl
80103fb6:	75 e9                	jne    80103fa1 <safestrcpy+0x17>
80103fb8:	89 f1                	mov    %esi,%ecx
    ;
  *s = 0;
80103fba:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80103fbd:	5b                   	pop    %ebx
80103fbe:	5e                   	pop    %esi
80103fbf:	5f                   	pop    %edi
80103fc0:	5d                   	pop    %ebp
80103fc1:	c3                   	ret

80103fc2 <strlen>:

int
strlen(const char *s)
{
80103fc2:	55                   	push   %ebp
80103fc3:	89 e5                	mov    %esp,%ebp
80103fc5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80103fc8:	b8 00 00 00 00       	mov    $0x0,%eax
80103fcd:	eb 01                	jmp    80103fd0 <strlen+0xe>
80103fcf:	40                   	inc    %eax
80103fd0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103fd4:	75 f9                	jne    80103fcf <strlen+0xd>
    ;
  return n;
}
80103fd6:	5d                   	pop    %ebp
80103fd7:	c3                   	ret

80103fd8 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80103fd8:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80103fdc:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80103fe0:	55                   	push   %ebp
  pushl %ebx
80103fe1:	53                   	push   %ebx
  pushl %esi
80103fe2:	56                   	push   %esi
  pushl %edi
80103fe3:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80103fe4:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80103fe6:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80103fe8:	5f                   	pop    %edi
  popl %esi
80103fe9:	5e                   	pop    %esi
  popl %ebx
80103fea:	5b                   	pop    %ebx
  popl %ebp
80103feb:	5d                   	pop    %ebp
  ret
80103fec:	c3                   	ret

80103fed <fetchint>:
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip)
{
80103fed:	55                   	push   %ebp
80103fee:	89 e5                	mov    %esp,%ebp
80103ff0:	53                   	push   %ebx
80103ff1:	83 ec 04             	sub    $0x4,%esp
80103ff4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103ff7:	e8 8d f2 ff ff       	call   80103289 <myproc>

  if (addr >= curproc->sz || addr + 4 > curproc->sz)
80103ffc:	8b 00                	mov    (%eax),%eax
80103ffe:	39 c3                	cmp    %eax,%ebx
80104000:	73 18                	jae    8010401a <fetchint+0x2d>
80104002:	8d 53 04             	lea    0x4(%ebx),%edx
80104005:	39 d0                	cmp    %edx,%eax
80104007:	72 18                	jb     80104021 <fetchint+0x34>
    return -1;
  *ip = *(int *)(addr);
80104009:	8b 13                	mov    (%ebx),%edx
8010400b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010400e:	89 10                	mov    %edx,(%eax)
  return 0;
80104010:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104015:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104018:	c9                   	leave
80104019:	c3                   	ret
    return -1;
8010401a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010401f:	eb f4                	jmp    80104015 <fetchint+0x28>
80104021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104026:	eb ed                	jmp    80104015 <fetchint+0x28>

80104028 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp)
{
80104028:	55                   	push   %ebp
80104029:	89 e5                	mov    %esp,%ebp
8010402b:	53                   	push   %ebx
8010402c:	83 ec 04             	sub    $0x4,%esp
8010402f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104032:	e8 52 f2 ff ff       	call   80103289 <myproc>

  if (addr >= curproc->sz)
80104037:	3b 18                	cmp    (%eax),%ebx
80104039:	73 23                	jae    8010405e <fetchstr+0x36>
    return -1;
  *pp = (char *)addr;
8010403b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010403e:	89 1a                	mov    %ebx,(%edx)
  ep = (char *)curproc->sz;
80104040:	8b 10                	mov    (%eax),%edx
  for (s = *pp; s < ep; s++)
80104042:	89 d8                	mov    %ebx,%eax
80104044:	eb 01                	jmp    80104047 <fetchstr+0x1f>
80104046:	40                   	inc    %eax
80104047:	39 d0                	cmp    %edx,%eax
80104049:	73 09                	jae    80104054 <fetchstr+0x2c>
  {
    if (*s == 0)
8010404b:	80 38 00             	cmpb   $0x0,(%eax)
8010404e:	75 f6                	jne    80104046 <fetchstr+0x1e>
      return s - *pp;
80104050:	29 d8                	sub    %ebx,%eax
80104052:	eb 05                	jmp    80104059 <fetchstr+0x31>
  }
  return -1;
80104054:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104059:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010405c:	c9                   	leave
8010405d:	c3                   	ret
    return -1;
8010405e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104063:	eb f4                	jmp    80104059 <fetchstr+0x31>

80104065 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip)
{
80104065:	55                   	push   %ebp
80104066:	89 e5                	mov    %esp,%ebp
80104068:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
8010406b:	e8 19 f2 ff ff       	call   80103289 <myproc>
80104070:	8b 50 18             	mov    0x18(%eax),%edx
80104073:	8b 45 08             	mov    0x8(%ebp),%eax
80104076:	c1 e0 02             	shl    $0x2,%eax
80104079:	03 42 44             	add    0x44(%edx),%eax
8010407c:	83 ec 08             	sub    $0x8,%esp
8010407f:	ff 75 0c             	push   0xc(%ebp)
80104082:	83 c0 04             	add    $0x4,%eax
80104085:	50                   	push   %eax
80104086:	e8 62 ff ff ff       	call   80103fed <fetchint>
}
8010408b:	c9                   	leave
8010408c:	c3                   	ret

8010408d <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, void **pp, int size)
{
8010408d:	55                   	push   %ebp
8010408e:	89 e5                	mov    %esp,%ebp
80104090:	56                   	push   %esi
80104091:	53                   	push   %ebx
80104092:	83 ec 10             	sub    $0x10,%esp
80104095:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104098:	e8 ec f1 ff ff       	call   80103289 <myproc>
8010409d:	89 c6                	mov    %eax,%esi

  if (argint(n, &i) < 0)
8010409f:	83 ec 08             	sub    $0x8,%esp
801040a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801040a5:	50                   	push   %eax
801040a6:	ff 75 08             	push   0x8(%ebp)
801040a9:	e8 b7 ff ff ff       	call   80104065 <argint>
801040ae:	83 c4 10             	add    $0x10,%esp
801040b1:	85 c0                	test   %eax,%eax
801040b3:	78 24                	js     801040d9 <argptr+0x4c>
    return -1;
  if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz)
801040b5:	85 db                	test   %ebx,%ebx
801040b7:	78 27                	js     801040e0 <argptr+0x53>
801040b9:	8b 16                	mov    (%esi),%edx
801040bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040be:	39 d0                	cmp    %edx,%eax
801040c0:	73 25                	jae    801040e7 <argptr+0x5a>
801040c2:	01 c3                	add    %eax,%ebx
801040c4:	39 da                	cmp    %ebx,%edx
801040c6:	72 26                	jb     801040ee <argptr+0x61>
    return -1;
  *pp = (void *)i;
801040c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801040cb:	89 02                	mov    %eax,(%edx)
  return 0;
801040cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801040d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040d5:	5b                   	pop    %ebx
801040d6:	5e                   	pop    %esi
801040d7:	5d                   	pop    %ebp
801040d8:	c3                   	ret
    return -1;
801040d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040de:	eb f2                	jmp    801040d2 <argptr+0x45>
    return -1;
801040e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040e5:	eb eb                	jmp    801040d2 <argptr+0x45>
801040e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040ec:	eb e4                	jmp    801040d2 <argptr+0x45>
801040ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040f3:	eb dd                	jmp    801040d2 <argptr+0x45>

801040f5 <argstr>:
// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp)
{
801040f5:	55                   	push   %ebp
801040f6:	89 e5                	mov    %esp,%ebp
801040f8:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if (argint(n, &addr) < 0)
801040fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801040fe:	50                   	push   %eax
801040ff:	ff 75 08             	push   0x8(%ebp)
80104102:	e8 5e ff ff ff       	call   80104065 <argint>
80104107:	83 c4 10             	add    $0x10,%esp
8010410a:	85 c0                	test   %eax,%eax
8010410c:	78 13                	js     80104121 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
8010410e:	83 ec 08             	sub    $0x8,%esp
80104111:	ff 75 0c             	push   0xc(%ebp)
80104114:	ff 75 f4             	push   -0xc(%ebp)
80104117:	e8 0c ff ff ff       	call   80104028 <fetchstr>
8010411c:	83 c4 10             	add    $0x10,%esp
}
8010411f:	c9                   	leave
80104120:	c3                   	ret
    return -1;
80104121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104126:	eb f7                	jmp    8010411f <argstr+0x2a>

80104128 <syscall>:
    [SYS_getprio] sys_getprio,
    [SYS_setprio] sys_setprio,
};

void syscall(void)
{
80104128:	55                   	push   %ebp
80104129:	89 e5                	mov    %esp,%ebp
8010412b:	53                   	push   %ebx
8010412c:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010412f:	e8 55 f1 ff ff       	call   80103289 <myproc>
80104134:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104136:	8b 40 18             	mov    0x18(%eax),%eax
80104139:	8b 40 1c             	mov    0x1c(%eax),%eax
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
8010413c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010413f:	83 fa 18             	cmp    $0x18,%edx
80104142:	77 17                	ja     8010415b <syscall+0x33>
80104144:	8b 14 85 20 73 10 80 	mov    -0x7fef8ce0(,%eax,4),%edx
8010414b:	85 d2                	test   %edx,%edx
8010414d:	74 0c                	je     8010415b <syscall+0x33>
  {
    curproc->tf->eax = syscalls[num]();
8010414f:	ff d2                	call   *%edx
80104151:	89 c2                	mov    %eax,%edx
80104153:	8b 43 18             	mov    0x18(%ebx),%eax
80104156:	89 50 1c             	mov    %edx,0x1c(%eax)
80104159:	eb 1f                	jmp    8010417a <syscall+0x52>
  }
  else
  {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
8010415b:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
8010415e:	50                   	push   %eax
8010415f:	52                   	push   %edx
80104160:	ff 73 10             	push   0x10(%ebx)
80104163:	68 71 6d 10 80       	push   $0x80106d71
80104168:	e8 72 c4 ff ff       	call   801005df <cprintf>
    curproc->tf->eax = -1;
8010416d:	8b 43 18             	mov    0x18(%ebx),%eax
80104170:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104177:	83 c4 10             	add    $0x10,%esp
  }
}
8010417a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010417d:	c9                   	leave
8010417e:	c3                   	ret

8010417f <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010417f:	55                   	push   %ebp
80104180:	89 e5                	mov    %esp,%ebp
80104182:	56                   	push   %esi
80104183:	53                   	push   %ebx
80104184:	83 ec 18             	sub    $0x18,%esp
80104187:	89 d6                	mov    %edx,%esi
80104189:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if (argint(n, &fd) < 0)
8010418b:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010418e:	52                   	push   %edx
8010418f:	50                   	push   %eax
80104190:	e8 d0 fe ff ff       	call   80104065 <argint>
80104195:	83 c4 10             	add    $0x10,%esp
80104198:	85 c0                	test   %eax,%eax
8010419a:	78 35                	js     801041d1 <argfd+0x52>
    return -1;
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010419c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801041a0:	77 28                	ja     801041ca <argfd+0x4b>
801041a2:	e8 e2 f0 ff ff       	call   80103289 <myproc>
801041a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041aa:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801041ae:	85 c0                	test   %eax,%eax
801041b0:	74 18                	je     801041ca <argfd+0x4b>
    return -1;
  if (pfd)
801041b2:	85 f6                	test   %esi,%esi
801041b4:	74 02                	je     801041b8 <argfd+0x39>
    *pfd = fd;
801041b6:	89 16                	mov    %edx,(%esi)
  if (pf)
801041b8:	85 db                	test   %ebx,%ebx
801041ba:	74 1c                	je     801041d8 <argfd+0x59>
    *pf = f;
801041bc:	89 03                	mov    %eax,(%ebx)
  return 0;
801041be:	b8 00 00 00 00       	mov    $0x0,%eax
}
801041c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041c6:	5b                   	pop    %ebx
801041c7:	5e                   	pop    %esi
801041c8:	5d                   	pop    %ebp
801041c9:	c3                   	ret
    return -1;
801041ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041cf:	eb f2                	jmp    801041c3 <argfd+0x44>
    return -1;
801041d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041d6:	eb eb                	jmp    801041c3 <argfd+0x44>
  return 0;
801041d8:	b8 00 00 00 00       	mov    $0x0,%eax
801041dd:	eb e4                	jmp    801041c3 <argfd+0x44>

801041df <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801041df:	55                   	push   %ebp
801041e0:	89 e5                	mov    %esp,%ebp
801041e2:	53                   	push   %ebx
801041e3:	83 ec 04             	sub    $0x4,%esp
801041e6:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
801041e8:	e8 9c f0 ff ff       	call   80103289 <myproc>
801041ed:	89 c2                	mov    %eax,%edx

  for (fd = 0; fd < NOFILE; fd++)
801041ef:	b8 00 00 00 00       	mov    $0x0,%eax
801041f4:	83 f8 0f             	cmp    $0xf,%eax
801041f7:	7f 10                	jg     80104209 <fdalloc+0x2a>
  {
    if (curproc->ofile[fd] == 0)
801041f9:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
801041fe:	74 03                	je     80104203 <fdalloc+0x24>
  for (fd = 0; fd < NOFILE; fd++)
80104200:	40                   	inc    %eax
80104201:	eb f1                	jmp    801041f4 <fdalloc+0x15>
    {
      curproc->ofile[fd] = f;
80104203:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
80104207:	eb 05                	jmp    8010420e <fdalloc+0x2f>
    }
  }
  return -1;
80104209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010420e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104211:	c9                   	leave
80104212:	c3                   	ret

80104213 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80104213:	55                   	push   %ebp
80104214:	89 e5                	mov    %esp,%ebp
80104216:	56                   	push   %esi
80104217:	53                   	push   %ebx
80104218:	83 ec 10             	sub    $0x10,%esp
8010421b:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
8010421d:	b8 20 00 00 00       	mov    $0x20,%eax
80104222:	89 c6                	mov    %eax,%esi
80104224:	3b 43 58             	cmp    0x58(%ebx),%eax
80104227:	73 2e                	jae    80104257 <isdirempty+0x44>
  {
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80104229:	6a 10                	push   $0x10
8010422b:	50                   	push   %eax
8010422c:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010422f:	50                   	push   %eax
80104230:	53                   	push   %ebx
80104231:	e8 30 d5 ff ff       	call   80101766 <readi>
80104236:	83 c4 10             	add    $0x10,%esp
80104239:	83 f8 10             	cmp    $0x10,%eax
8010423c:	75 0c                	jne    8010424a <isdirempty+0x37>
      panic("isdirempty: readi");
    if (de.inum != 0)
8010423e:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
80104243:	75 1e                	jne    80104263 <isdirempty+0x50>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80104245:	8d 46 10             	lea    0x10(%esi),%eax
80104248:	eb d8                	jmp    80104222 <isdirempty+0xf>
      panic("isdirempty: readi");
8010424a:	83 ec 0c             	sub    $0xc,%esp
8010424d:	68 8d 6d 10 80       	push   $0x80106d8d
80104252:	e8 ed c0 ff ff       	call   80100344 <panic>
      return 0;
  }
  return 1;
80104257:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010425c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010425f:	5b                   	pop    %ebx
80104260:	5e                   	pop    %esi
80104261:	5d                   	pop    %ebp
80104262:	c3                   	ret
      return 0;
80104263:	b8 00 00 00 00       	mov    $0x0,%eax
80104268:	eb f2                	jmp    8010425c <isdirempty+0x49>

8010426a <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
8010426a:	55                   	push   %ebp
8010426b:	89 e5                	mov    %esp,%ebp
8010426d:	57                   	push   %edi
8010426e:	56                   	push   %esi
8010426f:	53                   	push   %ebx
80104270:	83 ec 44             	sub    $0x44,%esp
80104273:	89 d7                	mov    %edx,%edi
80104275:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
80104278:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010427b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
8010427e:	8d 55 d6             	lea    -0x2a(%ebp),%edx
80104281:	52                   	push   %edx
80104282:	50                   	push   %eax
80104283:	e8 75 d9 ff ff       	call   80101bfd <nameiparent>
80104288:	89 c6                	mov    %eax,%esi
8010428a:	83 c4 10             	add    $0x10,%esp
8010428d:	85 c0                	test   %eax,%eax
8010428f:	0f 84 32 01 00 00    	je     801043c7 <create+0x15d>
    return 0;
  ilock(dp);
80104295:	83 ec 0c             	sub    $0xc,%esp
80104298:	50                   	push   %eax
80104299:	e8 db d2 ff ff       	call   80101579 <ilock>

  if ((ip = dirlookup(dp, name, &off)) != 0)
8010429e:	83 c4 0c             	add    $0xc,%esp
801042a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801042a4:	50                   	push   %eax
801042a5:	8d 45 d6             	lea    -0x2a(%ebp),%eax
801042a8:	50                   	push   %eax
801042a9:	56                   	push   %esi
801042aa:	e8 08 d7 ff ff       	call   801019b7 <dirlookup>
801042af:	89 c3                	mov    %eax,%ebx
801042b1:	83 c4 10             	add    $0x10,%esp
801042b4:	85 c0                	test   %eax,%eax
801042b6:	74 3c                	je     801042f4 <create+0x8a>
  {
    iunlockput(dp);
801042b8:	83 ec 0c             	sub    $0xc,%esp
801042bb:	56                   	push   %esi
801042bc:	e8 5b d4 ff ff       	call   8010171c <iunlockput>
    ilock(ip);
801042c1:	89 1c 24             	mov    %ebx,(%esp)
801042c4:	e8 b0 d2 ff ff       	call   80101579 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
801042c9:	83 c4 10             	add    $0x10,%esp
801042cc:	66 83 ff 02          	cmp    $0x2,%di
801042d0:	75 07                	jne    801042d9 <create+0x6f>
801042d2:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801042d7:	74 11                	je     801042ea <create+0x80>
      return ip;
    iunlockput(ip);
801042d9:	83 ec 0c             	sub    $0xc,%esp
801042dc:	53                   	push   %ebx
801042dd:	e8 3a d4 ff ff       	call   8010171c <iunlockput>
    return 0;
801042e2:	83 c4 10             	add    $0x10,%esp
801042e5:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801042ea:	89 d8                	mov    %ebx,%eax
801042ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042ef:	5b                   	pop    %ebx
801042f0:	5e                   	pop    %esi
801042f1:	5f                   	pop    %edi
801042f2:	5d                   	pop    %ebp
801042f3:	c3                   	ret
  if ((ip = ialloc(dp->dev, type)) == 0)
801042f4:	83 ec 08             	sub    $0x8,%esp
801042f7:	0f bf c7             	movswl %di,%eax
801042fa:	50                   	push   %eax
801042fb:	ff 36                	push   (%esi)
801042fd:	e8 7f d0 ff ff       	call   80101381 <ialloc>
80104302:	89 c3                	mov    %eax,%ebx
80104304:	83 c4 10             	add    $0x10,%esp
80104307:	85 c0                	test   %eax,%eax
80104309:	74 53                	je     8010435e <create+0xf4>
  ilock(ip);
8010430b:	83 ec 0c             	sub    $0xc,%esp
8010430e:	50                   	push   %eax
8010430f:	e8 65 d2 ff ff       	call   80101579 <ilock>
  ip->major = major;
80104314:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104317:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010431b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010431e:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104322:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
80104328:	89 1c 24             	mov    %ebx,(%esp)
8010432b:	e8 f0 d0 ff ff       	call   80101420 <iupdate>
  if (type == T_DIR)
80104330:	83 c4 10             	add    $0x10,%esp
80104333:	66 83 ff 01          	cmp    $0x1,%di
80104337:	74 32                	je     8010436b <create+0x101>
  if (dirlink(dp, name, ip->inum) < 0)
80104339:	83 ec 04             	sub    $0x4,%esp
8010433c:	ff 73 04             	push   0x4(%ebx)
8010433f:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104342:	50                   	push   %eax
80104343:	56                   	push   %esi
80104344:	e8 eb d7 ff ff       	call   80101b34 <dirlink>
80104349:	83 c4 10             	add    $0x10,%esp
8010434c:	85 c0                	test   %eax,%eax
8010434e:	78 6a                	js     801043ba <create+0x150>
  iunlockput(dp);
80104350:	83 ec 0c             	sub    $0xc,%esp
80104353:	56                   	push   %esi
80104354:	e8 c3 d3 ff ff       	call   8010171c <iunlockput>
  return ip;
80104359:	83 c4 10             	add    $0x10,%esp
8010435c:	eb 8c                	jmp    801042ea <create+0x80>
    panic("create: ialloc");
8010435e:	83 ec 0c             	sub    $0xc,%esp
80104361:	68 9f 6d 10 80       	push   $0x80106d9f
80104366:	e8 d9 bf ff ff       	call   80100344 <panic>
    dp->nlink++; // for ".."
8010436b:	66 8b 46 56          	mov    0x56(%esi),%ax
8010436f:	40                   	inc    %eax
80104370:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104374:	83 ec 0c             	sub    $0xc,%esp
80104377:	56                   	push   %esi
80104378:	e8 a3 d0 ff ff       	call   80101420 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010437d:	83 c4 0c             	add    $0xc,%esp
80104380:	ff 73 04             	push   0x4(%ebx)
80104383:	68 af 6d 10 80       	push   $0x80106daf
80104388:	53                   	push   %ebx
80104389:	e8 a6 d7 ff ff       	call   80101b34 <dirlink>
8010438e:	83 c4 10             	add    $0x10,%esp
80104391:	85 c0                	test   %eax,%eax
80104393:	78 18                	js     801043ad <create+0x143>
80104395:	83 ec 04             	sub    $0x4,%esp
80104398:	ff 76 04             	push   0x4(%esi)
8010439b:	68 ae 6d 10 80       	push   $0x80106dae
801043a0:	53                   	push   %ebx
801043a1:	e8 8e d7 ff ff       	call   80101b34 <dirlink>
801043a6:	83 c4 10             	add    $0x10,%esp
801043a9:	85 c0                	test   %eax,%eax
801043ab:	79 8c                	jns    80104339 <create+0xcf>
      panic("create dots");
801043ad:	83 ec 0c             	sub    $0xc,%esp
801043b0:	68 b1 6d 10 80       	push   $0x80106db1
801043b5:	e8 8a bf ff ff       	call   80100344 <panic>
    panic("create: dirlink");
801043ba:	83 ec 0c             	sub    $0xc,%esp
801043bd:	68 bd 6d 10 80       	push   $0x80106dbd
801043c2:	e8 7d bf ff ff       	call   80100344 <panic>
    return 0;
801043c7:	89 c3                	mov    %eax,%ebx
801043c9:	e9 1c ff ff ff       	jmp    801042ea <create+0x80>

801043ce <sys_dup>:
{
801043ce:	55                   	push   %ebp
801043cf:	89 e5                	mov    %esp,%ebp
801043d1:	53                   	push   %ebx
801043d2:	83 ec 14             	sub    $0x14,%esp
  if (argfd(0, 0, &f) < 0)
801043d5:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043d8:	ba 00 00 00 00       	mov    $0x0,%edx
801043dd:	b8 00 00 00 00       	mov    $0x0,%eax
801043e2:	e8 98 fd ff ff       	call   8010417f <argfd>
801043e7:	85 c0                	test   %eax,%eax
801043e9:	78 23                	js     8010440e <sys_dup+0x40>
  if ((fd = fdalloc(f)) < 0)
801043eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ee:	e8 ec fd ff ff       	call   801041df <fdalloc>
801043f3:	89 c3                	mov    %eax,%ebx
801043f5:	85 c0                	test   %eax,%eax
801043f7:	78 1c                	js     80104415 <sys_dup+0x47>
  filedup(f);
801043f9:	83 ec 0c             	sub    $0xc,%esp
801043fc:	ff 75 f4             	push   -0xc(%ebp)
801043ff:	e8 44 c8 ff ff       	call   80100c48 <filedup>
  return fd;
80104404:	83 c4 10             	add    $0x10,%esp
}
80104407:	89 d8                	mov    %ebx,%eax
80104409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010440c:	c9                   	leave
8010440d:	c3                   	ret
    return -1;
8010440e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104413:	eb f2                	jmp    80104407 <sys_dup+0x39>
    return -1;
80104415:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010441a:	eb eb                	jmp    80104407 <sys_dup+0x39>

8010441c <sys_read>:
{
8010441c:	55                   	push   %ebp
8010441d:	89 e5                	mov    %esp,%ebp
8010441f:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void **)&p, n) < 0)
80104422:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104425:	ba 00 00 00 00       	mov    $0x0,%edx
8010442a:	b8 00 00 00 00       	mov    $0x0,%eax
8010442f:	e8 4b fd ff ff       	call   8010417f <argfd>
80104434:	85 c0                	test   %eax,%eax
80104436:	78 43                	js     8010447b <sys_read+0x5f>
80104438:	83 ec 08             	sub    $0x8,%esp
8010443b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010443e:	50                   	push   %eax
8010443f:	6a 02                	push   $0x2
80104441:	e8 1f fc ff ff       	call   80104065 <argint>
80104446:	83 c4 10             	add    $0x10,%esp
80104449:	85 c0                	test   %eax,%eax
8010444b:	78 2e                	js     8010447b <sys_read+0x5f>
8010444d:	83 ec 04             	sub    $0x4,%esp
80104450:	ff 75 f0             	push   -0x10(%ebp)
80104453:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104456:	50                   	push   %eax
80104457:	6a 01                	push   $0x1
80104459:	e8 2f fc ff ff       	call   8010408d <argptr>
8010445e:	83 c4 10             	add    $0x10,%esp
80104461:	85 c0                	test   %eax,%eax
80104463:	78 16                	js     8010447b <sys_read+0x5f>
  return fileread(f, p, n);
80104465:	83 ec 04             	sub    $0x4,%esp
80104468:	ff 75 f0             	push   -0x10(%ebp)
8010446b:	ff 75 ec             	push   -0x14(%ebp)
8010446e:	ff 75 f4             	push   -0xc(%ebp)
80104471:	e8 0e c9 ff ff       	call   80100d84 <fileread>
80104476:	83 c4 10             	add    $0x10,%esp
}
80104479:	c9                   	leave
8010447a:	c3                   	ret
    return -1;
8010447b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104480:	eb f7                	jmp    80104479 <sys_read+0x5d>

80104482 <sys_write>:
{
80104482:	55                   	push   %ebp
80104483:	89 e5                	mov    %esp,%ebp
80104485:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void **)&p, n) < 0)
80104488:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010448b:	ba 00 00 00 00       	mov    $0x0,%edx
80104490:	b8 00 00 00 00       	mov    $0x0,%eax
80104495:	e8 e5 fc ff ff       	call   8010417f <argfd>
8010449a:	85 c0                	test   %eax,%eax
8010449c:	78 43                	js     801044e1 <sys_write+0x5f>
8010449e:	83 ec 08             	sub    $0x8,%esp
801044a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801044a4:	50                   	push   %eax
801044a5:	6a 02                	push   $0x2
801044a7:	e8 b9 fb ff ff       	call   80104065 <argint>
801044ac:	83 c4 10             	add    $0x10,%esp
801044af:	85 c0                	test   %eax,%eax
801044b1:	78 2e                	js     801044e1 <sys_write+0x5f>
801044b3:	83 ec 04             	sub    $0x4,%esp
801044b6:	ff 75 f0             	push   -0x10(%ebp)
801044b9:	8d 45 ec             	lea    -0x14(%ebp),%eax
801044bc:	50                   	push   %eax
801044bd:	6a 01                	push   $0x1
801044bf:	e8 c9 fb ff ff       	call   8010408d <argptr>
801044c4:	83 c4 10             	add    $0x10,%esp
801044c7:	85 c0                	test   %eax,%eax
801044c9:	78 16                	js     801044e1 <sys_write+0x5f>
  return filewrite(f, p, n);
801044cb:	83 ec 04             	sub    $0x4,%esp
801044ce:	ff 75 f0             	push   -0x10(%ebp)
801044d1:	ff 75 ec             	push   -0x14(%ebp)
801044d4:	ff 75 f4             	push   -0xc(%ebp)
801044d7:	e8 2d c9 ff ff       	call   80100e09 <filewrite>
801044dc:	83 c4 10             	add    $0x10,%esp
}
801044df:	c9                   	leave
801044e0:	c3                   	ret
    return -1;
801044e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044e6:	eb f7                	jmp    801044df <sys_write+0x5d>

801044e8 <sys_close>:
{
801044e8:	55                   	push   %ebp
801044e9:	89 e5                	mov    %esp,%ebp
801044eb:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, &fd, &f) < 0)
801044ee:	8d 4d f0             	lea    -0x10(%ebp),%ecx
801044f1:	8d 55 f4             	lea    -0xc(%ebp),%edx
801044f4:	b8 00 00 00 00       	mov    $0x0,%eax
801044f9:	e8 81 fc ff ff       	call   8010417f <argfd>
801044fe:	85 c0                	test   %eax,%eax
80104500:	78 25                	js     80104527 <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
80104502:	e8 82 ed ff ff       	call   80103289 <myproc>
80104507:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010450a:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104511:	00 
  fileclose(f);
80104512:	83 ec 0c             	sub    $0xc,%esp
80104515:	ff 75 f0             	push   -0x10(%ebp)
80104518:	e8 6e c7 ff ff       	call   80100c8b <fileclose>
  return 0;
8010451d:	83 c4 10             	add    $0x10,%esp
80104520:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104525:	c9                   	leave
80104526:	c3                   	ret
    return -1;
80104527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010452c:	eb f7                	jmp    80104525 <sys_close+0x3d>

8010452e <sys_fstat>:
{
8010452e:	55                   	push   %ebp
8010452f:	89 e5                	mov    %esp,%ebp
80104531:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
80104534:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104537:	ba 00 00 00 00       	mov    $0x0,%edx
8010453c:	b8 00 00 00 00       	mov    $0x0,%eax
80104541:	e8 39 fc ff ff       	call   8010417f <argfd>
80104546:	85 c0                	test   %eax,%eax
80104548:	78 2a                	js     80104574 <sys_fstat+0x46>
8010454a:	83 ec 04             	sub    $0x4,%esp
8010454d:	6a 14                	push   $0x14
8010454f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104552:	50                   	push   %eax
80104553:	6a 01                	push   $0x1
80104555:	e8 33 fb ff ff       	call   8010408d <argptr>
8010455a:	83 c4 10             	add    $0x10,%esp
8010455d:	85 c0                	test   %eax,%eax
8010455f:	78 13                	js     80104574 <sys_fstat+0x46>
  return filestat(f, st);
80104561:	83 ec 08             	sub    $0x8,%esp
80104564:	ff 75 f0             	push   -0x10(%ebp)
80104567:	ff 75 f4             	push   -0xc(%ebp)
8010456a:	e8 ce c7 ff ff       	call   80100d3d <filestat>
8010456f:	83 c4 10             	add    $0x10,%esp
}
80104572:	c9                   	leave
80104573:	c3                   	ret
    return -1;
80104574:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104579:	eb f7                	jmp    80104572 <sys_fstat+0x44>

8010457b <sys_link>:
{
8010457b:	55                   	push   %ebp
8010457c:	89 e5                	mov    %esp,%ebp
8010457e:	56                   	push   %esi
8010457f:	53                   	push   %ebx
80104580:	83 ec 28             	sub    $0x28,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104583:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104586:	50                   	push   %eax
80104587:	6a 00                	push   $0x0
80104589:	e8 67 fb ff ff       	call   801040f5 <argstr>
8010458e:	83 c4 10             	add    $0x10,%esp
80104591:	85 c0                	test   %eax,%eax
80104593:	0f 88 d1 00 00 00    	js     8010466a <sys_link+0xef>
80104599:	83 ec 08             	sub    $0x8,%esp
8010459c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010459f:	50                   	push   %eax
801045a0:	6a 01                	push   $0x1
801045a2:	e8 4e fb ff ff       	call   801040f5 <argstr>
801045a7:	83 c4 10             	add    $0x10,%esp
801045aa:	85 c0                	test   %eax,%eax
801045ac:	0f 88 b8 00 00 00    	js     8010466a <sys_link+0xef>
  begin_op();
801045b2:	e8 a9 e1 ff ff       	call   80102760 <begin_op>
  if ((ip = namei(old)) == 0)
801045b7:	83 ec 0c             	sub    $0xc,%esp
801045ba:	ff 75 e0             	push   -0x20(%ebp)
801045bd:	e8 23 d6 ff ff       	call   80101be5 <namei>
801045c2:	89 c3                	mov    %eax,%ebx
801045c4:	83 c4 10             	add    $0x10,%esp
801045c7:	85 c0                	test   %eax,%eax
801045c9:	0f 84 a2 00 00 00    	je     80104671 <sys_link+0xf6>
  ilock(ip);
801045cf:	83 ec 0c             	sub    $0xc,%esp
801045d2:	50                   	push   %eax
801045d3:	e8 a1 cf ff ff       	call   80101579 <ilock>
  if (ip->type == T_DIR)
801045d8:	83 c4 10             	add    $0x10,%esp
801045db:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801045e0:	0f 84 97 00 00 00    	je     8010467d <sys_link+0x102>
  ip->nlink++;
801045e6:	66 8b 43 56          	mov    0x56(%ebx),%ax
801045ea:	40                   	inc    %eax
801045eb:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801045ef:	83 ec 0c             	sub    $0xc,%esp
801045f2:	53                   	push   %ebx
801045f3:	e8 28 ce ff ff       	call   80101420 <iupdate>
  iunlock(ip);
801045f8:	89 1c 24             	mov    %ebx,(%esp)
801045fb:	e8 39 d0 ff ff       	call   80101639 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
80104600:	83 c4 08             	add    $0x8,%esp
80104603:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104606:	50                   	push   %eax
80104607:	ff 75 e4             	push   -0x1c(%ebp)
8010460a:	e8 ee d5 ff ff       	call   80101bfd <nameiparent>
8010460f:	89 c6                	mov    %eax,%esi
80104611:	83 c4 10             	add    $0x10,%esp
80104614:	85 c0                	test   %eax,%eax
80104616:	0f 84 85 00 00 00    	je     801046a1 <sys_link+0x126>
  ilock(dp);
8010461c:	83 ec 0c             	sub    $0xc,%esp
8010461f:	50                   	push   %eax
80104620:	e8 54 cf ff ff       	call   80101579 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
80104625:	83 c4 10             	add    $0x10,%esp
80104628:	8b 03                	mov    (%ebx),%eax
8010462a:	39 06                	cmp    %eax,(%esi)
8010462c:	75 67                	jne    80104695 <sys_link+0x11a>
8010462e:	83 ec 04             	sub    $0x4,%esp
80104631:	ff 73 04             	push   0x4(%ebx)
80104634:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104637:	50                   	push   %eax
80104638:	56                   	push   %esi
80104639:	e8 f6 d4 ff ff       	call   80101b34 <dirlink>
8010463e:	83 c4 10             	add    $0x10,%esp
80104641:	85 c0                	test   %eax,%eax
80104643:	78 50                	js     80104695 <sys_link+0x11a>
  iunlockput(dp);
80104645:	83 ec 0c             	sub    $0xc,%esp
80104648:	56                   	push   %esi
80104649:	e8 ce d0 ff ff       	call   8010171c <iunlockput>
  iput(ip);
8010464e:	89 1c 24             	mov    %ebx,(%esp)
80104651:	e8 28 d0 ff ff       	call   8010167e <iput>
  end_op();
80104656:	e8 81 e1 ff ff       	call   801027dc <end_op>
  return 0;
8010465b:	83 c4 10             	add    $0x10,%esp
8010465e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104663:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104666:	5b                   	pop    %ebx
80104667:	5e                   	pop    %esi
80104668:	5d                   	pop    %ebp
80104669:	c3                   	ret
    return -1;
8010466a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010466f:	eb f2                	jmp    80104663 <sys_link+0xe8>
    end_op();
80104671:	e8 66 e1 ff ff       	call   801027dc <end_op>
    return -1;
80104676:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010467b:	eb e6                	jmp    80104663 <sys_link+0xe8>
    iunlockput(ip);
8010467d:	83 ec 0c             	sub    $0xc,%esp
80104680:	53                   	push   %ebx
80104681:	e8 96 d0 ff ff       	call   8010171c <iunlockput>
    end_op();
80104686:	e8 51 e1 ff ff       	call   801027dc <end_op>
    return -1;
8010468b:	83 c4 10             	add    $0x10,%esp
8010468e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104693:	eb ce                	jmp    80104663 <sys_link+0xe8>
    iunlockput(dp);
80104695:	83 ec 0c             	sub    $0xc,%esp
80104698:	56                   	push   %esi
80104699:	e8 7e d0 ff ff       	call   8010171c <iunlockput>
    goto bad;
8010469e:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801046a1:	83 ec 0c             	sub    $0xc,%esp
801046a4:	53                   	push   %ebx
801046a5:	e8 cf ce ff ff       	call   80101579 <ilock>
  ip->nlink--;
801046aa:	66 8b 43 56          	mov    0x56(%ebx),%ax
801046ae:	48                   	dec    %eax
801046af:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801046b3:	89 1c 24             	mov    %ebx,(%esp)
801046b6:	e8 65 cd ff ff       	call   80101420 <iupdate>
  iunlockput(ip);
801046bb:	89 1c 24             	mov    %ebx,(%esp)
801046be:	e8 59 d0 ff ff       	call   8010171c <iunlockput>
  end_op();
801046c3:	e8 14 e1 ff ff       	call   801027dc <end_op>
  return -1;
801046c8:	83 c4 10             	add    $0x10,%esp
801046cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046d0:	eb 91                	jmp    80104663 <sys_link+0xe8>

801046d2 <sys_unlink>:
{
801046d2:	55                   	push   %ebp
801046d3:	89 e5                	mov    %esp,%ebp
801046d5:	57                   	push   %edi
801046d6:	56                   	push   %esi
801046d7:	53                   	push   %ebx
801046d8:	83 ec 44             	sub    $0x44,%esp
  if (argstr(0, &path) < 0)
801046db:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801046de:	50                   	push   %eax
801046df:	6a 00                	push   $0x0
801046e1:	e8 0f fa ff ff       	call   801040f5 <argstr>
801046e6:	83 c4 10             	add    $0x10,%esp
801046e9:	85 c0                	test   %eax,%eax
801046eb:	0f 88 7f 01 00 00    	js     80104870 <sys_unlink+0x19e>
  begin_op();
801046f1:	e8 6a e0 ff ff       	call   80102760 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
801046f6:	83 ec 08             	sub    $0x8,%esp
801046f9:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046fc:	50                   	push   %eax
801046fd:	ff 75 c4             	push   -0x3c(%ebp)
80104700:	e8 f8 d4 ff ff       	call   80101bfd <nameiparent>
80104705:	89 c6                	mov    %eax,%esi
80104707:	83 c4 10             	add    $0x10,%esp
8010470a:	85 c0                	test   %eax,%eax
8010470c:	0f 84 eb 00 00 00    	je     801047fd <sys_unlink+0x12b>
  ilock(dp);
80104712:	83 ec 0c             	sub    $0xc,%esp
80104715:	50                   	push   %eax
80104716:	e8 5e ce ff ff       	call   80101579 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010471b:	83 c4 08             	add    $0x8,%esp
8010471e:	68 af 6d 10 80       	push   $0x80106daf
80104723:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104726:	50                   	push   %eax
80104727:	e8 76 d2 ff ff       	call   801019a2 <namecmp>
8010472c:	83 c4 10             	add    $0x10,%esp
8010472f:	85 c0                	test   %eax,%eax
80104731:	0f 84 fa 00 00 00    	je     80104831 <sys_unlink+0x15f>
80104737:	83 ec 08             	sub    $0x8,%esp
8010473a:	68 ae 6d 10 80       	push   $0x80106dae
8010473f:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104742:	50                   	push   %eax
80104743:	e8 5a d2 ff ff       	call   801019a2 <namecmp>
80104748:	83 c4 10             	add    $0x10,%esp
8010474b:	85 c0                	test   %eax,%eax
8010474d:	0f 84 de 00 00 00    	je     80104831 <sys_unlink+0x15f>
  if ((ip = dirlookup(dp, name, &off)) == 0)
80104753:	83 ec 04             	sub    $0x4,%esp
80104756:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104759:	50                   	push   %eax
8010475a:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010475d:	50                   	push   %eax
8010475e:	56                   	push   %esi
8010475f:	e8 53 d2 ff ff       	call   801019b7 <dirlookup>
80104764:	89 c3                	mov    %eax,%ebx
80104766:	83 c4 10             	add    $0x10,%esp
80104769:	85 c0                	test   %eax,%eax
8010476b:	0f 84 c0 00 00 00    	je     80104831 <sys_unlink+0x15f>
  ilock(ip);
80104771:	83 ec 0c             	sub    $0xc,%esp
80104774:	50                   	push   %eax
80104775:	e8 ff cd ff ff       	call   80101579 <ilock>
  if (ip->nlink < 1)
8010477a:	83 c4 10             	add    $0x10,%esp
8010477d:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104782:	0f 8e 81 00 00 00    	jle    80104809 <sys_unlink+0x137>
  if (ip->type == T_DIR && !isdirempty(ip))
80104788:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010478d:	0f 84 83 00 00 00    	je     80104816 <sys_unlink+0x144>
  memset(&de, 0, sizeof(de));
80104793:	83 ec 04             	sub    $0x4,%esp
80104796:	6a 10                	push   $0x10
80104798:	6a 00                	push   $0x0
8010479a:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010479d:	57                   	push   %edi
8010479e:	e8 8f f6 ff ff       	call   80103e32 <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
801047a3:	6a 10                	push   $0x10
801047a5:	ff 75 c0             	push   -0x40(%ebp)
801047a8:	57                   	push   %edi
801047a9:	56                   	push   %esi
801047aa:	e8 ba d0 ff ff       	call   80101869 <writei>
801047af:	83 c4 20             	add    $0x20,%esp
801047b2:	83 f8 10             	cmp    $0x10,%eax
801047b5:	0f 85 8e 00 00 00    	jne    80104849 <sys_unlink+0x177>
  if (ip->type == T_DIR)
801047bb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801047c0:	0f 84 90 00 00 00    	je     80104856 <sys_unlink+0x184>
  iunlockput(dp);
801047c6:	83 ec 0c             	sub    $0xc,%esp
801047c9:	56                   	push   %esi
801047ca:	e8 4d cf ff ff       	call   8010171c <iunlockput>
  ip->nlink--;
801047cf:	66 8b 43 56          	mov    0x56(%ebx),%ax
801047d3:	48                   	dec    %eax
801047d4:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801047d8:	89 1c 24             	mov    %ebx,(%esp)
801047db:	e8 40 cc ff ff       	call   80101420 <iupdate>
  iunlockput(ip);
801047e0:	89 1c 24             	mov    %ebx,(%esp)
801047e3:	e8 34 cf ff ff       	call   8010171c <iunlockput>
  end_op();
801047e8:	e8 ef df ff ff       	call   801027dc <end_op>
  return 0;
801047ed:	83 c4 10             	add    $0x10,%esp
801047f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047f8:	5b                   	pop    %ebx
801047f9:	5e                   	pop    %esi
801047fa:	5f                   	pop    %edi
801047fb:	5d                   	pop    %ebp
801047fc:	c3                   	ret
    end_op();
801047fd:	e8 da df ff ff       	call   801027dc <end_op>
    return -1;
80104802:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104807:	eb ec                	jmp    801047f5 <sys_unlink+0x123>
    panic("unlink: nlink < 1");
80104809:	83 ec 0c             	sub    $0xc,%esp
8010480c:	68 cd 6d 10 80       	push   $0x80106dcd
80104811:	e8 2e bb ff ff       	call   80100344 <panic>
  if (ip->type == T_DIR && !isdirempty(ip))
80104816:	89 d8                	mov    %ebx,%eax
80104818:	e8 f6 f9 ff ff       	call   80104213 <isdirempty>
8010481d:	85 c0                	test   %eax,%eax
8010481f:	0f 85 6e ff ff ff    	jne    80104793 <sys_unlink+0xc1>
    iunlockput(ip);
80104825:	83 ec 0c             	sub    $0xc,%esp
80104828:	53                   	push   %ebx
80104829:	e8 ee ce ff ff       	call   8010171c <iunlockput>
    goto bad;
8010482e:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104831:	83 ec 0c             	sub    $0xc,%esp
80104834:	56                   	push   %esi
80104835:	e8 e2 ce ff ff       	call   8010171c <iunlockput>
  end_op();
8010483a:	e8 9d df ff ff       	call   801027dc <end_op>
  return -1;
8010483f:	83 c4 10             	add    $0x10,%esp
80104842:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104847:	eb ac                	jmp    801047f5 <sys_unlink+0x123>
    panic("unlink: writei");
80104849:	83 ec 0c             	sub    $0xc,%esp
8010484c:	68 df 6d 10 80       	push   $0x80106ddf
80104851:	e8 ee ba ff ff       	call   80100344 <panic>
    dp->nlink--;
80104856:	66 8b 46 56          	mov    0x56(%esi),%ax
8010485a:	48                   	dec    %eax
8010485b:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
8010485f:	83 ec 0c             	sub    $0xc,%esp
80104862:	56                   	push   %esi
80104863:	e8 b8 cb ff ff       	call   80101420 <iupdate>
80104868:	83 c4 10             	add    $0x10,%esp
8010486b:	e9 56 ff ff ff       	jmp    801047c6 <sys_unlink+0xf4>
    return -1;
80104870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104875:	e9 7b ff ff ff       	jmp    801047f5 <sys_unlink+0x123>

8010487a <sys_open>:

int sys_open(void)
{
8010487a:	55                   	push   %ebp
8010487b:	89 e5                	mov    %esp,%ebp
8010487d:	57                   	push   %edi
8010487e:	56                   	push   %esi
8010487f:	53                   	push   %ebx
80104880:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104883:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104886:	50                   	push   %eax
80104887:	6a 00                	push   $0x0
80104889:	e8 67 f8 ff ff       	call   801040f5 <argstr>
8010488e:	83 c4 10             	add    $0x10,%esp
80104891:	85 c0                	test   %eax,%eax
80104893:	0f 88 a0 00 00 00    	js     80104939 <sys_open+0xbf>
80104899:	83 ec 08             	sub    $0x8,%esp
8010489c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010489f:	50                   	push   %eax
801048a0:	6a 01                	push   $0x1
801048a2:	e8 be f7 ff ff       	call   80104065 <argint>
801048a7:	83 c4 10             	add    $0x10,%esp
801048aa:	85 c0                	test   %eax,%eax
801048ac:	0f 88 87 00 00 00    	js     80104939 <sys_open+0xbf>
    return -1;

  begin_op();
801048b2:	e8 a9 de ff ff       	call   80102760 <begin_op>

  if (omode & O_CREATE)
801048b7:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
801048bb:	0f 84 8b 00 00 00    	je     8010494c <sys_open+0xd2>
  {
    ip = create(path, T_FILE, 0, 0);
801048c1:	83 ec 0c             	sub    $0xc,%esp
801048c4:	6a 00                	push   $0x0
801048c6:	b9 00 00 00 00       	mov    $0x0,%ecx
801048cb:	ba 02 00 00 00       	mov    $0x2,%edx
801048d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801048d3:	e8 92 f9 ff ff       	call   8010426a <create>
801048d8:	89 c6                	mov    %eax,%esi
    if (ip == 0)
801048da:	83 c4 10             	add    $0x10,%esp
801048dd:	85 c0                	test   %eax,%eax
801048df:	74 5f                	je     80104940 <sys_open+0xc6>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
801048e1:	e8 01 c3 ff ff       	call   80100be7 <filealloc>
801048e6:	89 c3                	mov    %eax,%ebx
801048e8:	85 c0                	test   %eax,%eax
801048ea:	0f 84 c1 00 00 00    	je     801049b1 <sys_open+0x137>
801048f0:	e8 ea f8 ff ff       	call   801041df <fdalloc>
801048f5:	89 c7                	mov    %eax,%edi
801048f7:	85 c0                	test   %eax,%eax
801048f9:	0f 88 a6 00 00 00    	js     801049a5 <sys_open+0x12b>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801048ff:	83 ec 0c             	sub    $0xc,%esp
80104902:	56                   	push   %esi
80104903:	e8 31 cd ff ff       	call   80101639 <iunlock>
  end_op();
80104908:	e8 cf de ff ff       	call   801027dc <end_op>

  f->type = FD_INODE;
8010490d:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104913:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104916:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
8010491d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104920:	83 c4 10             	add    $0x10,%esp
80104923:	a8 01                	test   $0x1,%al
80104925:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104929:	a8 03                	test   $0x3,%al
8010492b:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
8010492f:	89 f8                	mov    %edi,%eax
80104931:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104934:	5b                   	pop    %ebx
80104935:	5e                   	pop    %esi
80104936:	5f                   	pop    %edi
80104937:	5d                   	pop    %ebp
80104938:	c3                   	ret
    return -1;
80104939:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010493e:	eb ef                	jmp    8010492f <sys_open+0xb5>
      end_op();
80104940:	e8 97 de ff ff       	call   801027dc <end_op>
      return -1;
80104945:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010494a:	eb e3                	jmp    8010492f <sys_open+0xb5>
    if ((ip = namei(path)) == 0)
8010494c:	83 ec 0c             	sub    $0xc,%esp
8010494f:	ff 75 e4             	push   -0x1c(%ebp)
80104952:	e8 8e d2 ff ff       	call   80101be5 <namei>
80104957:	89 c6                	mov    %eax,%esi
80104959:	83 c4 10             	add    $0x10,%esp
8010495c:	85 c0                	test   %eax,%eax
8010495e:	74 39                	je     80104999 <sys_open+0x11f>
    ilock(ip);
80104960:	83 ec 0c             	sub    $0xc,%esp
80104963:	50                   	push   %eax
80104964:	e8 10 cc ff ff       	call   80101579 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
80104969:	83 c4 10             	add    $0x10,%esp
8010496c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104971:	0f 85 6a ff ff ff    	jne    801048e1 <sys_open+0x67>
80104977:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010497b:	0f 84 60 ff ff ff    	je     801048e1 <sys_open+0x67>
      iunlockput(ip);
80104981:	83 ec 0c             	sub    $0xc,%esp
80104984:	56                   	push   %esi
80104985:	e8 92 cd ff ff       	call   8010171c <iunlockput>
      end_op();
8010498a:	e8 4d de ff ff       	call   801027dc <end_op>
      return -1;
8010498f:	83 c4 10             	add    $0x10,%esp
80104992:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104997:	eb 96                	jmp    8010492f <sys_open+0xb5>
      end_op();
80104999:	e8 3e de ff ff       	call   801027dc <end_op>
      return -1;
8010499e:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049a3:	eb 8a                	jmp    8010492f <sys_open+0xb5>
      fileclose(f);
801049a5:	83 ec 0c             	sub    $0xc,%esp
801049a8:	53                   	push   %ebx
801049a9:	e8 dd c2 ff ff       	call   80100c8b <fileclose>
801049ae:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801049b1:	83 ec 0c             	sub    $0xc,%esp
801049b4:	56                   	push   %esi
801049b5:	e8 62 cd ff ff       	call   8010171c <iunlockput>
    end_op();
801049ba:	e8 1d de ff ff       	call   801027dc <end_op>
    return -1;
801049bf:	83 c4 10             	add    $0x10,%esp
801049c2:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049c7:	e9 63 ff ff ff       	jmp    8010492f <sys_open+0xb5>

801049cc <sys_mkdir>:

int sys_mkdir(void)
{
801049cc:	55                   	push   %ebp
801049cd:	89 e5                	mov    %esp,%ebp
801049cf:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801049d2:	e8 89 dd ff ff       	call   80102760 <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
801049d7:	83 ec 08             	sub    $0x8,%esp
801049da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049dd:	50                   	push   %eax
801049de:	6a 00                	push   $0x0
801049e0:	e8 10 f7 ff ff       	call   801040f5 <argstr>
801049e5:	83 c4 10             	add    $0x10,%esp
801049e8:	85 c0                	test   %eax,%eax
801049ea:	78 36                	js     80104a22 <sys_mkdir+0x56>
801049ec:	83 ec 0c             	sub    $0xc,%esp
801049ef:	6a 00                	push   $0x0
801049f1:	b9 00 00 00 00       	mov    $0x0,%ecx
801049f6:	ba 01 00 00 00       	mov    $0x1,%edx
801049fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049fe:	e8 67 f8 ff ff       	call   8010426a <create>
80104a03:	83 c4 10             	add    $0x10,%esp
80104a06:	85 c0                	test   %eax,%eax
80104a08:	74 18                	je     80104a22 <sys_mkdir+0x56>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a0a:	83 ec 0c             	sub    $0xc,%esp
80104a0d:	50                   	push   %eax
80104a0e:	e8 09 cd ff ff       	call   8010171c <iunlockput>
  end_op();
80104a13:	e8 c4 dd ff ff       	call   801027dc <end_op>
  return 0;
80104a18:	83 c4 10             	add    $0x10,%esp
80104a1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a20:	c9                   	leave
80104a21:	c3                   	ret
    end_op();
80104a22:	e8 b5 dd ff ff       	call   801027dc <end_op>
    return -1;
80104a27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a2c:	eb f2                	jmp    80104a20 <sys_mkdir+0x54>

80104a2e <sys_mknod>:

int sys_mknod(void)
{
80104a2e:	55                   	push   %ebp
80104a2f:	89 e5                	mov    %esp,%ebp
80104a31:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104a34:	e8 27 dd ff ff       	call   80102760 <begin_op>
  if ((argstr(0, &path)) < 0 ||
80104a39:	83 ec 08             	sub    $0x8,%esp
80104a3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a3f:	50                   	push   %eax
80104a40:	6a 00                	push   $0x0
80104a42:	e8 ae f6 ff ff       	call   801040f5 <argstr>
80104a47:	83 c4 10             	add    $0x10,%esp
80104a4a:	85 c0                	test   %eax,%eax
80104a4c:	78 62                	js     80104ab0 <sys_mknod+0x82>
      argint(1, &major) < 0 ||
80104a4e:	83 ec 08             	sub    $0x8,%esp
80104a51:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a54:	50                   	push   %eax
80104a55:	6a 01                	push   $0x1
80104a57:	e8 09 f6 ff ff       	call   80104065 <argint>
  if ((argstr(0, &path)) < 0 ||
80104a5c:	83 c4 10             	add    $0x10,%esp
80104a5f:	85 c0                	test   %eax,%eax
80104a61:	78 4d                	js     80104ab0 <sys_mknod+0x82>
      argint(2, &minor) < 0 ||
80104a63:	83 ec 08             	sub    $0x8,%esp
80104a66:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104a69:	50                   	push   %eax
80104a6a:	6a 02                	push   $0x2
80104a6c:	e8 f4 f5 ff ff       	call   80104065 <argint>
      argint(1, &major) < 0 ||
80104a71:	83 c4 10             	add    $0x10,%esp
80104a74:	85 c0                	test   %eax,%eax
80104a76:	78 38                	js     80104ab0 <sys_mknod+0x82>
      (ip = create(path, T_DEV, major, minor)) == 0)
80104a78:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104a7c:	83 ec 0c             	sub    $0xc,%esp
80104a7f:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104a83:	50                   	push   %eax
80104a84:	ba 03 00 00 00       	mov    $0x3,%edx
80104a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a8c:	e8 d9 f7 ff ff       	call   8010426a <create>
      argint(2, &minor) < 0 ||
80104a91:	83 c4 10             	add    $0x10,%esp
80104a94:	85 c0                	test   %eax,%eax
80104a96:	74 18                	je     80104ab0 <sys_mknod+0x82>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a98:	83 ec 0c             	sub    $0xc,%esp
80104a9b:	50                   	push   %eax
80104a9c:	e8 7b cc ff ff       	call   8010171c <iunlockput>
  end_op();
80104aa1:	e8 36 dd ff ff       	call   801027dc <end_op>
  return 0;
80104aa6:	83 c4 10             	add    $0x10,%esp
80104aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104aae:	c9                   	leave
80104aaf:	c3                   	ret
    end_op();
80104ab0:	e8 27 dd ff ff       	call   801027dc <end_op>
    return -1;
80104ab5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aba:	eb f2                	jmp    80104aae <sys_mknod+0x80>

80104abc <sys_chdir>:

int sys_chdir(void)
{
80104abc:	55                   	push   %ebp
80104abd:	89 e5                	mov    %esp,%ebp
80104abf:	56                   	push   %esi
80104ac0:	53                   	push   %ebx
80104ac1:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104ac4:	e8 c0 e7 ff ff       	call   80103289 <myproc>
80104ac9:	89 c6                	mov    %eax,%esi

  begin_op();
80104acb:	e8 90 dc ff ff       	call   80102760 <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80104ad0:	83 ec 08             	sub    $0x8,%esp
80104ad3:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ad6:	50                   	push   %eax
80104ad7:	6a 00                	push   $0x0
80104ad9:	e8 17 f6 ff ff       	call   801040f5 <argstr>
80104ade:	83 c4 10             	add    $0x10,%esp
80104ae1:	85 c0                	test   %eax,%eax
80104ae3:	78 52                	js     80104b37 <sys_chdir+0x7b>
80104ae5:	83 ec 0c             	sub    $0xc,%esp
80104ae8:	ff 75 f4             	push   -0xc(%ebp)
80104aeb:	e8 f5 d0 ff ff       	call   80101be5 <namei>
80104af0:	89 c3                	mov    %eax,%ebx
80104af2:	83 c4 10             	add    $0x10,%esp
80104af5:	85 c0                	test   %eax,%eax
80104af7:	74 3e                	je     80104b37 <sys_chdir+0x7b>
  {
    end_op();
    return -1;
  }
  ilock(ip);
80104af9:	83 ec 0c             	sub    $0xc,%esp
80104afc:	50                   	push   %eax
80104afd:	e8 77 ca ff ff       	call   80101579 <ilock>
  if (ip->type != T_DIR)
80104b02:	83 c4 10             	add    $0x10,%esp
80104b05:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b0a:	75 37                	jne    80104b43 <sys_chdir+0x87>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104b0c:	83 ec 0c             	sub    $0xc,%esp
80104b0f:	53                   	push   %ebx
80104b10:	e8 24 cb ff ff       	call   80101639 <iunlock>
  iput(curproc->cwd);
80104b15:	83 c4 04             	add    $0x4,%esp
80104b18:	ff 76 68             	push   0x68(%esi)
80104b1b:	e8 5e cb ff ff       	call   8010167e <iput>
  end_op();
80104b20:	e8 b7 dc ff ff       	call   801027dc <end_op>
  curproc->cwd = ip;
80104b25:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104b28:	83 c4 10             	add    $0x10,%esp
80104b2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b30:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b33:	5b                   	pop    %ebx
80104b34:	5e                   	pop    %esi
80104b35:	5d                   	pop    %ebp
80104b36:	c3                   	ret
    end_op();
80104b37:	e8 a0 dc ff ff       	call   801027dc <end_op>
    return -1;
80104b3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b41:	eb ed                	jmp    80104b30 <sys_chdir+0x74>
    iunlockput(ip);
80104b43:	83 ec 0c             	sub    $0xc,%esp
80104b46:	53                   	push   %ebx
80104b47:	e8 d0 cb ff ff       	call   8010171c <iunlockput>
    end_op();
80104b4c:	e8 8b dc ff ff       	call   801027dc <end_op>
    return -1;
80104b51:	83 c4 10             	add    $0x10,%esp
80104b54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b59:	eb d5                	jmp    80104b30 <sys_chdir+0x74>

80104b5b <sys_exec>:

int sys_exec(void)
{
80104b5b:	55                   	push   %ebp
80104b5c:	89 e5                	mov    %esp,%ebp
80104b5e:	53                   	push   %ebx
80104b5f:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80104b65:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b68:	50                   	push   %eax
80104b69:	6a 00                	push   $0x0
80104b6b:	e8 85 f5 ff ff       	call   801040f5 <argstr>
80104b70:	83 c4 10             	add    $0x10,%esp
80104b73:	85 c0                	test   %eax,%eax
80104b75:	78 38                	js     80104baf <sys_exec+0x54>
80104b77:	83 ec 08             	sub    $0x8,%esp
80104b7a:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104b80:	50                   	push   %eax
80104b81:	6a 01                	push   $0x1
80104b83:	e8 dd f4 ff ff       	call   80104065 <argint>
80104b88:	83 c4 10             	add    $0x10,%esp
80104b8b:	85 c0                	test   %eax,%eax
80104b8d:	78 20                	js     80104baf <sys_exec+0x54>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104b8f:	83 ec 04             	sub    $0x4,%esp
80104b92:	68 80 00 00 00       	push   $0x80
80104b97:	6a 00                	push   $0x0
80104b99:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104b9f:	50                   	push   %eax
80104ba0:	e8 8d f2 ff ff       	call   80103e32 <memset>
80104ba5:	83 c4 10             	add    $0x10,%esp
  for (i = 0;; i++)
80104ba8:	bb 00 00 00 00       	mov    $0x0,%ebx
80104bad:	eb 2a                	jmp    80104bd9 <sys_exec+0x7e>
    return -1;
80104baf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bb4:	eb 76                	jmp    80104c2c <sys_exec+0xd1>
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
      return -1;
    if (uarg == 0)
    {
      argv[i] = 0;
80104bb6:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104bbd:	00 00 00 00 
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104bc1:	83 ec 08             	sub    $0x8,%esp
80104bc4:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104bca:	50                   	push   %eax
80104bcb:	ff 75 f4             	push   -0xc(%ebp)
80104bce:	e8 b7 bc ff ff       	call   8010088a <exec>
80104bd3:	83 c4 10             	add    $0x10,%esp
80104bd6:	eb 54                	jmp    80104c2c <sys_exec+0xd1>
  for (i = 0;; i++)
80104bd8:	43                   	inc    %ebx
    if (i >= NELEM(argv))
80104bd9:	83 fb 1f             	cmp    $0x1f,%ebx
80104bdc:	77 49                	ja     80104c27 <sys_exec+0xcc>
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80104bde:	83 ec 08             	sub    $0x8,%esp
80104be1:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104be7:	50                   	push   %eax
80104be8:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104bee:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104bf1:	50                   	push   %eax
80104bf2:	e8 f6 f3 ff ff       	call   80103fed <fetchint>
80104bf7:	83 c4 10             	add    $0x10,%esp
80104bfa:	85 c0                	test   %eax,%eax
80104bfc:	78 33                	js     80104c31 <sys_exec+0xd6>
    if (uarg == 0)
80104bfe:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104c04:	85 c0                	test   %eax,%eax
80104c06:	74 ae                	je     80104bb6 <sys_exec+0x5b>
    if (fetchstr(uarg, &argv[i]) < 0)
80104c08:	83 ec 08             	sub    $0x8,%esp
80104c0b:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104c12:	52                   	push   %edx
80104c13:	50                   	push   %eax
80104c14:	e8 0f f4 ff ff       	call   80104028 <fetchstr>
80104c19:	83 c4 10             	add    $0x10,%esp
80104c1c:	85 c0                	test   %eax,%eax
80104c1e:	79 b8                	jns    80104bd8 <sys_exec+0x7d>
      return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c25:	eb 05                	jmp    80104c2c <sys_exec+0xd1>
      return -1;
80104c27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c2f:	c9                   	leave
80104c30:	c3                   	ret
      return -1;
80104c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c36:	eb f4                	jmp    80104c2c <sys_exec+0xd1>

80104c38 <sys_pipe>:

int sys_pipe(void)
{
80104c38:	55                   	push   %ebp
80104c39:	89 e5                	mov    %esp,%ebp
80104c3b:	53                   	push   %ebx
80104c3c:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80104c3f:	6a 08                	push   $0x8
80104c41:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c44:	50                   	push   %eax
80104c45:	6a 00                	push   $0x0
80104c47:	e8 41 f4 ff ff       	call   8010408d <argptr>
80104c4c:	83 c4 10             	add    $0x10,%esp
80104c4f:	85 c0                	test   %eax,%eax
80104c51:	78 73                	js     80104cc6 <sys_pipe+0x8e>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
80104c53:	83 ec 08             	sub    $0x8,%esp
80104c56:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104c59:	50                   	push   %eax
80104c5a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c5d:	50                   	push   %eax
80104c5e:	e8 78 e0 ff ff       	call   80102cdb <pipealloc>
80104c63:	83 c4 10             	add    $0x10,%esp
80104c66:	85 c0                	test   %eax,%eax
80104c68:	78 63                	js     80104ccd <sys_pipe+0x95>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80104c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c6d:	e8 6d f5 ff ff       	call   801041df <fdalloc>
80104c72:	89 c3                	mov    %eax,%ebx
80104c74:	85 c0                	test   %eax,%eax
80104c76:	78 2e                	js     80104ca6 <sys_pipe+0x6e>
80104c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c7b:	e8 5f f5 ff ff       	call   801041df <fdalloc>
80104c80:	85 c0                	test   %eax,%eax
80104c82:	78 15                	js     80104c99 <sys_pipe+0x61>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104c84:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c87:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104c89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c8c:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c97:	c9                   	leave
80104c98:	c3                   	ret
      myproc()->ofile[fd0] = 0;
80104c99:	e8 eb e5 ff ff       	call   80103289 <myproc>
80104c9e:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104ca5:	00 
    fileclose(rf);
80104ca6:	83 ec 0c             	sub    $0xc,%esp
80104ca9:	ff 75 f0             	push   -0x10(%ebp)
80104cac:	e8 da bf ff ff       	call   80100c8b <fileclose>
    fileclose(wf);
80104cb1:	83 c4 04             	add    $0x4,%esp
80104cb4:	ff 75 ec             	push   -0x14(%ebp)
80104cb7:	e8 cf bf ff ff       	call   80100c8b <fileclose>
    return -1;
80104cbc:	83 c4 10             	add    $0x10,%esp
80104cbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cc4:	eb ce                	jmp    80104c94 <sys_pipe+0x5c>
    return -1;
80104cc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ccb:	eb c7                	jmp    80104c94 <sys_pipe+0x5c>
    return -1;
80104ccd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cd2:	eb c0                	jmp    80104c94 <sys_pipe+0x5c>

80104cd4 <sys_dup2>:

int sys_dup2(void)
{
80104cd4:	55                   	push   %ebp
80104cd5:	89 e5                	mov    %esp,%ebp
80104cd7:	53                   	push   %ebx
80104cd8:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int oldfd, newfd;
  struct proc *curproc = myproc();
80104cdb:	e8 a9 e5 ff ff       	call   80103289 <myproc>
80104ce0:	89 c3                	mov    %eax,%ebx

  // Recoger argumentos: el viejo FD (y su archivo) y el nuevo FD deseado
  if (argfd(0, &oldfd, &f) < 0 || argint(1, &newfd) < 0)
80104ce2:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104ce5:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104ce8:	b8 00 00 00 00       	mov    $0x0,%eax
80104ced:	e8 8d f4 ff ff       	call   8010417f <argfd>
80104cf2:	85 c0                	test   %eax,%eax
80104cf4:	78 54                	js     80104d4a <sys_dup2+0x76>
80104cf6:	83 ec 08             	sub    $0x8,%esp
80104cf9:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104cfc:	50                   	push   %eax
80104cfd:	6a 01                	push   $0x1
80104cff:	e8 61 f3 ff ff       	call   80104065 <argint>
80104d04:	83 c4 10             	add    $0x10,%esp
80104d07:	85 c0                	test   %eax,%eax
80104d09:	78 3f                	js     80104d4a <sys_dup2+0x76>
    return -1;

  // Comprobar límites del nuevo DESC. DE FICH.
  if (newfd < 0 || newfd >= NOFILE)
80104d0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d0e:	83 f8 0f             	cmp    $0xf,%eax
80104d11:	77 3e                	ja     80104d51 <sys_dup2+0x7d>
    return -1;

  // Si son iguales, no hacemos nada y devolvemos el mismo
  if (oldfd == newfd)
80104d13:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104d16:	74 2d                	je     80104d45 <sys_dup2+0x71>
    return newfd;

  // Si la ranura nueva ya estaba ocupada, la cerramos para evitar fugas de memoria
  if (curproc->ofile[newfd])
80104d18:	8b 44 83 28          	mov    0x28(%ebx,%eax,4),%eax
80104d1c:	85 c0                	test   %eax,%eax
80104d1e:	74 0c                	je     80104d2c <sys_dup2+0x58>
    fileclose(curproc->ofile[newfd]);
80104d20:	83 ec 0c             	sub    $0xc,%esp
80104d23:	50                   	push   %eax
80104d24:	e8 62 bf ff ff       	call   80100c8b <fileclose>
80104d29:	83 c4 10             	add    $0x10,%esp

  // Mapeamos el archivo a la nueva ranura y aumentamos sus referencias
  curproc->ofile[newfd] = f;
80104d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104d32:	89 44 93 28          	mov    %eax,0x28(%ebx,%edx,4)
  filedup(f);
80104d36:	83 ec 0c             	sub    $0xc,%esp
80104d39:	50                   	push   %eax
80104d3a:	e8 09 bf ff ff       	call   80100c48 <filedup>

  return newfd;
80104d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d42:	83 c4 10             	add    $0x10,%esp
}
80104d45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d48:	c9                   	leave
80104d49:	c3                   	ret
    return -1;
80104d4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d4f:	eb f4                	jmp    80104d45 <sys_dup2+0x71>
    return -1;
80104d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d56:	eb ed                	jmp    80104d45 <sys_dup2+0x71>

80104d58 <sys_fork>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
80104d58:	55                   	push   %ebp
80104d59:	89 e5                	mov    %esp,%ebp
80104d5b:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104d5e:	e8 a1 e6 ff ff       	call   80103404 <fork>
}
80104d63:	c9                   	leave
80104d64:	c3                   	ret

80104d65 <sys_exit>:

int sys_exit(void)
{
80104d65:	55                   	push   %ebp
80104d66:	89 e5                	mov    %esp,%ebp
80104d68:	83 ec 20             	sub    $0x20,%esp
  int status;
  // Se intenta leer el primer entero (posición 0) de la pila de argumentos del sistema.
  // Si no se puede, se devuelve -1 indicando error.
  if (argint(0, &status) < 0)
80104d6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d6e:	50                   	push   %eax
80104d6f:	6a 00                	push   $0x0
80104d71:	e8 ef f2 ff ff       	call   80104065 <argint>
80104d76:	83 c4 10             	add    $0x10,%esp
80104d79:	85 c0                	test   %eax,%eax
80104d7b:	78 15                	js     80104d92 <sys_exit+0x2d>
    return -1;

  exit(status); // Se llama a la lógica real pasando el estado de salida como argumento.
80104d7d:	83 ec 0c             	sub    $0xc,%esp
80104d80:	ff 75 f4             	push   -0xc(%ebp)
80104d83:	e8 c8 e8 ff ff       	call   80103650 <exit>
  return 0;
80104d88:	83 c4 10             	add    $0x10,%esp
80104d8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d90:	c9                   	leave
80104d91:	c3                   	ret
    return -1;
80104d92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d97:	eb f7                	jmp    80104d90 <sys_exit+0x2b>

80104d99 <sys_wait>:

int sys_wait(void)
{
80104d99:	55                   	push   %ebp
80104d9a:	89 e5                	mov    %esp,%ebp
80104d9c:	83 ec 1c             	sub    $0x1c,%esp
  int *p;
  // Se intenta leer el puntero (posición 0) de la pila de argumentos del sistema.
  // argptr se asegura de que el puntero sea válido para el tamaño de un entero.
  if (argptr(0, (void *)&p, sizeof(*p)) < 0)
80104d9f:	6a 04                	push   $0x4
80104da1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104da4:	50                   	push   %eax
80104da5:	6a 00                	push   $0x0
80104da7:	e8 e1 f2 ff ff       	call   8010408d <argptr>
80104dac:	83 c4 10             	add    $0x10,%esp
80104daf:	85 c0                	test   %eax,%eax
80104db1:	78 10                	js     80104dc3 <sys_wait+0x2a>
    return -1;

  return wait(p); // Se llama a la lógica real pasando el puntero para almacenar el estado de salida del hijo.
80104db3:	83 ec 0c             	sub    $0xc,%esp
80104db6:	ff 75 f4             	push   -0xc(%ebp)
80104db9:	e8 40 ea ff ff       	call   801037fe <wait>
80104dbe:	83 c4 10             	add    $0x10,%esp
}
80104dc1:	c9                   	leave
80104dc2:	c3                   	ret
    return -1;
80104dc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc8:	eb f7                	jmp    80104dc1 <sys_wait+0x28>

80104dca <sys_kill>:

int sys_kill(void)
{
80104dca:	55                   	push   %ebp
80104dcb:	89 e5                	mov    %esp,%ebp
80104dcd:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80104dd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dd3:	50                   	push   %eax
80104dd4:	6a 00                	push   $0x0
80104dd6:	e8 8a f2 ff ff       	call   80104065 <argint>
80104ddb:	83 c4 10             	add    $0x10,%esp
80104dde:	85 c0                	test   %eax,%eax
80104de0:	78 10                	js     80104df2 <sys_kill+0x28>
    return -1;
  return kill(pid);
80104de2:	83 ec 0c             	sub    $0xc,%esp
80104de5:	ff 75 f4             	push   -0xc(%ebp)
80104de8:	e8 24 eb ff ff       	call   80103911 <kill>
80104ded:	83 c4 10             	add    $0x10,%esp
}
80104df0:	c9                   	leave
80104df1:	c3                   	ret
    return -1;
80104df2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104df7:	eb f7                	jmp    80104df0 <sys_kill+0x26>

80104df9 <sys_getpid>:

int sys_getpid(void)
{
80104df9:	55                   	push   %ebp
80104dfa:	89 e5                	mov    %esp,%ebp
80104dfc:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104dff:	e8 85 e4 ff ff       	call   80103289 <myproc>
80104e04:	8b 40 10             	mov    0x10(%eax),%eax
}
80104e07:	c9                   	leave
80104e08:	c3                   	ret

80104e09 <sys_sbrk>:

int sys_sbrk(void)
{
80104e09:	55                   	push   %ebp
80104e0a:	89 e5                	mov    %esp,%ebp
80104e0c:	56                   	push   %esi
80104e0d:	53                   	push   %ebx
80104e0e:	83 ec 10             	sub    $0x10,%esp
  int addr;
  int n;
  struct proc *curproc = myproc();
80104e11:	e8 73 e4 ff ff       	call   80103289 <myproc>
80104e16:	89 c3                	mov    %eax,%ebx

  if (argint(0, &n) < 0)
80104e18:	83 ec 08             	sub    $0x8,%esp
80104e1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e1e:	50                   	push   %eax
80104e1f:	6a 00                	push   $0x0
80104e21:	e8 3f f2 ff ff       	call   80104065 <argint>
80104e26:	83 c4 10             	add    $0x10,%esp
80104e29:	85 c0                	test   %eax,%eax
80104e2b:	78 37                	js     80104e64 <sys_sbrk+0x5b>
    return -1;
  addr = curproc->sz;
80104e2d:	8b 13                	mov    (%ebx),%edx
80104e2f:	89 d6                	mov    %edx,%esi

  if (n > 0)
80104e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e34:	85 c0                	test   %eax,%eax
80104e36:	7e 13                	jle    80104e4b <sys_sbrk+0x42>
  { /*RESERVA PEREZOSA: EN LUGAR DE LLAMAR A growproc,
simplemente aumentamos el tamaño del proceso en n bytes.
No reservamos memoria física.
if (growproc(n) < 0)
return -1;*/
    if (curproc->sz + n >= KERNBASE || curproc->sz + n < curproc->sz)
80104e38:	01 d0                	add    %edx,%eax
80104e3a:	78 2f                	js     80104e6b <sys_sbrk+0x62>
80104e3c:	39 d0                	cmp    %edx,%eax
80104e3e:	72 32                	jb     80104e72 <sys_sbrk+0x69>
      return -1;

    curproc->sz += n; // Lazy allocation
80104e40:	89 03                	mov    %eax,(%ebx)
  {
    if (growproc(n) < 0)
      return -1;
  }
  return addr;
}
80104e42:	89 f0                	mov    %esi,%eax
80104e44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e47:	5b                   	pop    %ebx
80104e48:	5e                   	pop    %esi
80104e49:	5d                   	pop    %ebp
80104e4a:	c3                   	ret
  else if (n < 0)
80104e4b:	79 f5                	jns    80104e42 <sys_sbrk+0x39>
    if (growproc(n) < 0)
80104e4d:	83 ec 0c             	sub    $0xc,%esp
80104e50:	50                   	push   %eax
80104e51:	e8 44 e5 ff ff       	call   8010339a <growproc>
80104e56:	83 c4 10             	add    $0x10,%esp
80104e59:	85 c0                	test   %eax,%eax
80104e5b:	79 e5                	jns    80104e42 <sys_sbrk+0x39>
      return -1;
80104e5d:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104e62:	eb de                	jmp    80104e42 <sys_sbrk+0x39>
    return -1;
80104e64:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104e69:	eb d7                	jmp    80104e42 <sys_sbrk+0x39>
      return -1;
80104e6b:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104e70:	eb d0                	jmp    80104e42 <sys_sbrk+0x39>
80104e72:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104e77:	eb c9                	jmp    80104e42 <sys_sbrk+0x39>

80104e79 <sys_sleep>:

int sys_sleep(void)
{
80104e79:	55                   	push   %ebp
80104e7a:	89 e5                	mov    %esp,%ebp
80104e7c:	53                   	push   %ebx
80104e7d:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80104e80:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e83:	50                   	push   %eax
80104e84:	6a 00                	push   $0x0
80104e86:	e8 da f1 ff ff       	call   80104065 <argint>
80104e8b:	83 c4 10             	add    $0x10,%esp
80104e8e:	85 c0                	test   %eax,%eax
80104e90:	78 75                	js     80104f07 <sys_sleep+0x8e>
    return -1;
  acquire(&tickslock);
80104e92:	83 ec 0c             	sub    $0xc,%esp
80104e95:	68 e0 3f 11 80       	push   $0x80113fe0
80104e9a:	e8 e7 ee ff ff       	call   80103d86 <acquire>
  ticks0 = ticks;
80104e9f:	8b 1d c0 3f 11 80    	mov    0x80113fc0,%ebx
  while (ticks - ticks0 < n)
80104ea5:	83 c4 10             	add    $0x10,%esp
80104ea8:	a1 c0 3f 11 80       	mov    0x80113fc0,%eax
80104ead:	29 d8                	sub    %ebx,%eax
80104eaf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104eb2:	73 39                	jae    80104eed <sys_sleep+0x74>
  {
    if (myproc()->killed)
80104eb4:	e8 d0 e3 ff ff       	call   80103289 <myproc>
80104eb9:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104ebd:	75 17                	jne    80104ed6 <sys_sleep+0x5d>
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104ebf:	83 ec 08             	sub    $0x8,%esp
80104ec2:	68 e0 3f 11 80       	push   $0x80113fe0
80104ec7:	68 c0 3f 11 80       	push   $0x80113fc0
80104ecc:	e8 9c e8 ff ff       	call   8010376d <sleep>
80104ed1:	83 c4 10             	add    $0x10,%esp
80104ed4:	eb d2                	jmp    80104ea8 <sys_sleep+0x2f>
      release(&tickslock);
80104ed6:	83 ec 0c             	sub    $0xc,%esp
80104ed9:	68 e0 3f 11 80       	push   $0x80113fe0
80104ede:	e8 08 ef ff ff       	call   80103deb <release>
      return -1;
80104ee3:	83 c4 10             	add    $0x10,%esp
80104ee6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eeb:	eb 15                	jmp    80104f02 <sys_sleep+0x89>
  }
  release(&tickslock);
80104eed:	83 ec 0c             	sub    $0xc,%esp
80104ef0:	68 e0 3f 11 80       	push   $0x80113fe0
80104ef5:	e8 f1 ee ff ff       	call   80103deb <release>
  return 0;
80104efa:	83 c4 10             	add    $0x10,%esp
80104efd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f05:	c9                   	leave
80104f06:	c3                   	ret
    return -1;
80104f07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f0c:	eb f4                	jmp    80104f02 <sys_sleep+0x89>

80104f0e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80104f0e:	55                   	push   %ebp
80104f0f:	89 e5                	mov    %esp,%ebp
80104f11:	53                   	push   %ebx
80104f12:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104f15:	68 e0 3f 11 80       	push   $0x80113fe0
80104f1a:	e8 67 ee ff ff       	call   80103d86 <acquire>
  xticks = ticks;
80104f1f:	8b 1d c0 3f 11 80    	mov    0x80113fc0,%ebx
  release(&tickslock);
80104f25:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104f2c:	e8 ba ee ff ff       	call   80103deb <release>
  return xticks;
}
80104f31:	89 d8                	mov    %ebx,%eax
80104f33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f36:	c9                   	leave
80104f37:	c3                   	ret

80104f38 <sys_date>:

int sys_date(void)
{
80104f38:	55                   	push   %ebp
80104f39:	89 e5                	mov    %esp,%ebp
80104f3b:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *d;

  if (argptr(0, (void *)&d, sizeof(*d)) < 0)
80104f3e:	6a 18                	push   $0x18
80104f40:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f43:	50                   	push   %eax
80104f44:	6a 00                	push   $0x0
80104f46:	e8 42 f1 ff ff       	call   8010408d <argptr>
80104f4b:	83 c4 10             	add    $0x10,%esp
80104f4e:	85 c0                	test   %eax,%eax
80104f50:	78 15                	js     80104f67 <sys_date+0x2f>
    return -1;

  cmostime(d);
80104f52:	83 ec 0c             	sub    $0xc,%esp
80104f55:	ff 75 f4             	push   -0xc(%ebp)
80104f58:	e8 d1 d4 ff ff       	call   8010242e <cmostime>

  return 0;
80104f5d:	83 c4 10             	add    $0x10,%esp
80104f60:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f65:	c9                   	leave
80104f66:	c3                   	ret
    return -1;
80104f67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f6c:	eb f7                	jmp    80104f65 <sys_date+0x2d>

80104f6e <sys_getprio>:
// BOLETIN 4:Declaramos las funciones reales que vivirán en proc.c
int getprio(int pid);
int setprio(int pid, int priority);

int sys_getprio(void)
{
80104f6e:	55                   	push   %ebp
80104f6f:	89 e5                	mov    %esp,%ebp
80104f71:	83 ec 20             	sub    $0x20,%esp
  int pid;
  // Solo recoge el argumento PID
  if (argint(0, &pid) < 0)
80104f74:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f77:	50                   	push   %eax
80104f78:	6a 00                	push   $0x0
80104f7a:	e8 e6 f0 ff ff       	call   80104065 <argint>
80104f7f:	83 c4 10             	add    $0x10,%esp
80104f82:	85 c0                	test   %eax,%eax
80104f84:	78 10                	js     80104f96 <sys_getprio+0x28>
    return -1;

  return getprio(pid);
80104f86:	83 ec 0c             	sub    $0xc,%esp
80104f89:	ff 75 f4             	push   -0xc(%ebp)
80104f8c:	e8 b5 ea ff ff       	call   80103a46 <getprio>
80104f91:	83 c4 10             	add    $0x10,%esp
}
80104f94:	c9                   	leave
80104f95:	c3                   	ret
    return -1;
80104f96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f9b:	eb f7                	jmp    80104f94 <sys_getprio+0x26>

80104f9d <sys_setprio>:

int sys_setprio(void)
{
80104f9d:	55                   	push   %ebp
80104f9e:	89 e5                	mov    %esp,%ebp
80104fa0:	83 ec 20             	sub    $0x20,%esp
  int pid, priority;
  // Recoge los dos argumentos: PID y la nueva prioridad
  if (argint(0, &pid) < 0)
80104fa3:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fa6:	50                   	push   %eax
80104fa7:	6a 00                	push   $0x0
80104fa9:	e8 b7 f0 ff ff       	call   80104065 <argint>
80104fae:	83 c4 10             	add    $0x10,%esp
80104fb1:	85 c0                	test   %eax,%eax
80104fb3:	78 28                	js     80104fdd <sys_setprio+0x40>
    return -1;
  if (argint(1, &priority) < 0)
80104fb5:	83 ec 08             	sub    $0x8,%esp
80104fb8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fbb:	50                   	push   %eax
80104fbc:	6a 01                	push   $0x1
80104fbe:	e8 a2 f0 ff ff       	call   80104065 <argint>
80104fc3:	83 c4 10             	add    $0x10,%esp
80104fc6:	85 c0                	test   %eax,%eax
80104fc8:	78 1a                	js     80104fe4 <sys_setprio+0x47>
    return -1;

  return setprio(pid, priority);
80104fca:	83 ec 08             	sub    $0x8,%esp
80104fcd:	ff 75 f0             	push   -0x10(%ebp)
80104fd0:	ff 75 f4             	push   -0xc(%ebp)
80104fd3:	e8 be ea ff ff       	call   80103a96 <setprio>
80104fd8:	83 c4 10             	add    $0x10,%esp
}
80104fdb:	c9                   	leave
80104fdc:	c3                   	ret
    return -1;
80104fdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe2:	eb f7                	jmp    80104fdb <sys_setprio+0x3e>
    return -1;
80104fe4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe9:	eb f0                	jmp    80104fdb <sys_setprio+0x3e>

80104feb <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104feb:	1e                   	push   %ds
  pushl %es
80104fec:	06                   	push   %es
  pushl %fs
80104fed:	0f a0                	push   %fs
  pushl %gs
80104fef:	0f a8                	push   %gs
  pushal
80104ff1:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104ff2:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104ff6:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104ff8:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104ffa:	54                   	push   %esp
  call trap
80104ffb:	e8 2f 01 00 00       	call   8010512f <trap>
  addl $4, %esp
80105000:	83 c4 04             	add    $0x4,%esp

80105003 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105003:	61                   	popa
  popl %gs
80105004:	0f a9                	pop    %gs
  popl %fs
80105006:	0f a1                	pop    %fs
  popl %es
80105008:	07                   	pop    %es
  popl %ds
80105009:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010500a:	83 c4 08             	add    $0x8,%esp
  iret
8010500d:	cf                   	iret

8010500e <tvinit>:
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
8010500e:	55                   	push   %ebp
8010500f:	89 e5                	mov    %esp,%ebp
80105011:	53                   	push   %ebx
80105012:	83 ec 04             	sub    $0x4,%esp
  int i;

  for (i = 0; i < 256; i++)
80105015:	b8 00 00 00 00       	mov    $0x0,%eax
8010501a:	eb 72                	jmp    8010508e <tvinit+0x80>
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
8010501c:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
80105023:	66 89 0c c5 20 40 11 	mov    %cx,-0x7feebfe0(,%eax,8)
8010502a:	80 
8010502b:	66 c7 04 c5 22 40 11 	movw   $0x8,-0x7feebfde(,%eax,8)
80105032:	80 08 00 
80105035:	8a 14 c5 24 40 11 80 	mov    -0x7feebfdc(,%eax,8),%dl
8010503c:	83 e2 e0             	and    $0xffffffe0,%edx
8010503f:	88 14 c5 24 40 11 80 	mov    %dl,-0x7feebfdc(,%eax,8)
80105046:	c6 04 c5 24 40 11 80 	movb   $0x0,-0x7feebfdc(,%eax,8)
8010504d:	00 
8010504e:	8a 14 c5 25 40 11 80 	mov    -0x7feebfdb(,%eax,8),%dl
80105055:	83 e2 f0             	and    $0xfffffff0,%edx
80105058:	83 ca 0e             	or     $0xe,%edx
8010505b:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
80105062:	88 d3                	mov    %dl,%bl
80105064:	83 e3 ef             	and    $0xffffffef,%ebx
80105067:	88 1c c5 25 40 11 80 	mov    %bl,-0x7feebfdb(,%eax,8)
8010506e:	83 e2 8f             	and    $0xffffff8f,%edx
80105071:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
80105078:	83 ca 80             	or     $0xffffff80,%edx
8010507b:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
80105082:	c1 e9 10             	shr    $0x10,%ecx
80105085:	66 89 0c c5 26 40 11 	mov    %cx,-0x7feebfda(,%eax,8)
8010508c:	80 
  for (i = 0; i < 256; i++)
8010508d:	40                   	inc    %eax
8010508e:	3d ff 00 00 00       	cmp    $0xff,%eax
80105093:	7e 87                	jle    8010501c <tvinit+0xe>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105095:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
8010509b:	66 89 15 20 42 11 80 	mov    %dx,0x80114220
801050a2:	66 c7 05 22 42 11 80 	movw   $0x8,0x80114222
801050a9:	08 00 
801050ab:	a0 24 42 11 80       	mov    0x80114224,%al
801050b0:	83 e0 e0             	and    $0xffffffe0,%eax
801050b3:	a2 24 42 11 80       	mov    %al,0x80114224
801050b8:	c6 05 24 42 11 80 00 	movb   $0x0,0x80114224
801050bf:	a0 25 42 11 80       	mov    0x80114225,%al
801050c4:	83 c8 0f             	or     $0xf,%eax
801050c7:	a2 25 42 11 80       	mov    %al,0x80114225
801050cc:	83 e0 ef             	and    $0xffffffef,%eax
801050cf:	a2 25 42 11 80       	mov    %al,0x80114225
801050d4:	88 c1                	mov    %al,%cl
801050d6:	83 c9 60             	or     $0x60,%ecx
801050d9:	88 0d 25 42 11 80    	mov    %cl,0x80114225
801050df:	83 c8 e0             	or     $0xffffffe0,%eax
801050e2:	a2 25 42 11 80       	mov    %al,0x80114225
801050e7:	c1 ea 10             	shr    $0x10,%edx
801050ea:	66 89 15 26 42 11 80 	mov    %dx,0x80114226

  initlock(&tickslock, "time");
801050f1:	83 ec 08             	sub    $0x8,%esp
801050f4:	68 ee 6d 10 80       	push   $0x80106dee
801050f9:	68 e0 3f 11 80       	push   $0x80113fe0
801050fe:	e8 43 eb ff ff       	call   80103c46 <initlock>
}
80105103:	83 c4 10             	add    $0x10,%esp
80105106:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105109:	c9                   	leave
8010510a:	c3                   	ret

8010510b <idtinit>:

void idtinit(void)
{
8010510b:	55                   	push   %ebp
8010510c:	89 e5                	mov    %esp,%ebp
8010510e:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105111:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80105117:	b8 20 40 11 80       	mov    $0x80114020,%eax
8010511c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105120:	c1 e8 10             	shr    $0x10,%eax
80105123:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105127:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010512a:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
8010512d:	c9                   	leave
8010512e:	c3                   	ret

8010512f <trap>:

// PAGEBREAK: 41
void trap(struct trapframe *tf)
{
8010512f:	55                   	push   %ebp
80105130:	89 e5                	mov    %esp,%ebp
80105132:	57                   	push   %edi
80105133:	56                   	push   %esi
80105134:	53                   	push   %ebx
80105135:	83 ec 1c             	sub    $0x1c,%esp
80105138:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (tf->trapno == T_SYSCALL)
8010513b:	8b 43 30             	mov    0x30(%ebx),%eax
8010513e:	83 f8 40             	cmp    $0x40,%eax
80105141:	74 13                	je     80105156 <trap+0x27>
    if (myproc()->killed)
      exit(tf->trapno + 1);
    return;
  }

  switch (tf->trapno)
80105143:	83 e8 0e             	sub    $0xe,%eax
80105146:	83 f8 31             	cmp    $0x31,%eax
80105149:	0f 87 18 02 00 00    	ja     80105367 <trap+0x238>
8010514f:	ff 24 85 88 73 10 80 	jmp    *-0x7fef8c78(,%eax,4)
    if (myproc()->killed)
80105156:	e8 2e e1 ff ff       	call   80103289 <myproc>
8010515b:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010515f:	75 2e                	jne    8010518f <trap+0x60>
    myproc()->tf = tf;
80105161:	e8 23 e1 ff ff       	call   80103289 <myproc>
80105166:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105169:	e8 ba ef ff ff       	call   80104128 <syscall>
    if (myproc()->killed)
8010516e:	e8 16 e1 ff ff       	call   80103289 <myproc>
80105173:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105177:	0f 84 8c 00 00 00    	je     80105209 <trap+0xda>
      exit(tf->trapno + 1);
8010517d:	8b 43 30             	mov    0x30(%ebx),%eax
80105180:	40                   	inc    %eax
80105181:	83 ec 0c             	sub    $0xc,%esp
80105184:	50                   	push   %eax
80105185:	e8 c6 e4 ff ff       	call   80103650 <exit>
8010518a:	83 c4 10             	add    $0x10,%esp
    return;
8010518d:	eb 7a                	jmp    80105209 <trap+0xda>
      exit(tf->trapno + 1);
8010518f:	8b 43 30             	mov    0x30(%ebx),%eax
80105192:	40                   	inc    %eax
80105193:	83 ec 0c             	sub    $0xc,%esp
80105196:	50                   	push   %eax
80105197:	e8 b4 e4 ff ff       	call   80103650 <exit>
8010519c:	83 c4 10             	add    $0x10,%esp
8010519f:	eb c0                	jmp    80105161 <trap+0x32>
  {
  case T_IRQ0 + IRQ_TIMER:
    if (cpuid() == 0)
801051a1:	e8 b2 e0 ff ff       	call   80103258 <cpuid>
801051a6:	85 c0                	test   %eax,%eax
801051a8:	74 67                	je     80105211 <trap+0xe2>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
801051aa:	e8 ca d1 ff ff       	call   80102379 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801051af:	e8 d5 e0 ff ff       	call   80103289 <myproc>
801051b4:	85 c0                	test   %eax,%eax
801051b6:	74 18                	je     801051d0 <trap+0xa1>
801051b8:	e8 cc e0 ff ff       	call   80103289 <myproc>
801051bd:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801051c1:	74 0d                	je     801051d0 <trap+0xa1>
801051c3:	8b 43 3c             	mov    0x3c(%ebx),%eax
801051c6:	f7 d0                	not    %eax
801051c8:	a8 03                	test   $0x3,%al
801051ca:	0f 84 2a 02 00 00    	je     801053fa <trap+0x2cb>
    exit(tf->trapno + 1);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if (myproc() && myproc()->state == RUNNING &&
801051d0:	e8 b4 e0 ff ff       	call   80103289 <myproc>
801051d5:	85 c0                	test   %eax,%eax
801051d7:	74 0f                	je     801051e8 <trap+0xb9>
801051d9:	e8 ab e0 ff ff       	call   80103289 <myproc>
801051de:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801051e2:	0f 84 27 02 00 00    	je     8010540f <trap+0x2e0>
      tf->trapno == T_IRQ0 + IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801051e8:	e8 9c e0 ff ff       	call   80103289 <myproc>
801051ed:	85 c0                	test   %eax,%eax
801051ef:	74 18                	je     80105209 <trap+0xda>
801051f1:	e8 93 e0 ff ff       	call   80103289 <myproc>
801051f6:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801051fa:	74 0d                	je     80105209 <trap+0xda>
801051fc:	8b 43 3c             	mov    0x3c(%ebx),%eax
801051ff:	f7 d0                	not    %eax
80105201:	a8 03                	test   $0x3,%al
80105203:	0f 84 1a 02 00 00    	je     80105423 <trap+0x2f4>
    exit(tf->trapno + 1);
}
80105209:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010520c:	5b                   	pop    %ebx
8010520d:	5e                   	pop    %esi
8010520e:	5f                   	pop    %edi
8010520f:	5d                   	pop    %ebp
80105210:	c3                   	ret
      acquire(&tickslock);
80105211:	83 ec 0c             	sub    $0xc,%esp
80105214:	68 e0 3f 11 80       	push   $0x80113fe0
80105219:	e8 68 eb ff ff       	call   80103d86 <acquire>
      ticks++;
8010521e:	ff 05 c0 3f 11 80    	incl   0x80113fc0
      wakeup(&ticks);
80105224:	c7 04 24 c0 3f 11 80 	movl   $0x80113fc0,(%esp)
8010522b:	e8 b8 e6 ff ff       	call   801038e8 <wakeup>
      release(&tickslock);
80105230:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80105237:	e8 af eb ff ff       	call   80103deb <release>
8010523c:	83 c4 10             	add    $0x10,%esp
8010523f:	e9 66 ff ff ff       	jmp    801051aa <trap+0x7b>
    ideintr();
80105244:	e8 14 cb ff ff       	call   80101d5d <ideintr>
    lapiceoi();
80105249:	e8 2b d1 ff ff       	call   80102379 <lapiceoi>
    break;
8010524e:	e9 5c ff ff ff       	jmp    801051af <trap+0x80>
    kbdintr();
80105253:	e8 6b cf ff ff       	call   801021c3 <kbdintr>
    lapiceoi();
80105258:	e8 1c d1 ff ff       	call   80102379 <lapiceoi>
    break;
8010525d:	e9 4d ff ff ff       	jmp    801051af <trap+0x80>
    uartintr();
80105262:	e8 cd 02 00 00       	call   80105534 <uartintr>
    lapiceoi();
80105267:	e8 0d d1 ff ff       	call   80102379 <lapiceoi>
    break;
8010526c:	e9 3e ff ff ff       	jmp    801051af <trap+0x80>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105271:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
80105274:	8b 73 3c             	mov    0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105277:	e8 dc df ff ff       	call   80103258 <cpuid>
8010527c:	57                   	push   %edi
8010527d:	0f b7 f6             	movzwl %si,%esi
80105280:	56                   	push   %esi
80105281:	50                   	push   %eax
80105282:	68 e8 6f 10 80       	push   $0x80106fe8
80105287:	e8 53 b3 ff ff       	call   801005df <cprintf>
    lapiceoi();
8010528c:	e8 e8 d0 ff ff       	call   80102379 <lapiceoi>
    break;
80105291:	83 c4 10             	add    $0x10,%esp
80105294:	e9 16 ff ff ff       	jmp    801051af <trap+0x80>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105299:	0f 20 d7             	mov    %cr2,%edi
    struct proc *curproc = myproc();
8010529c:	e8 e8 df ff ff       	call   80103289 <myproc>
801052a1:	89 c6                	mov    %eax,%esi
    if (((tf->err & 0x1) == 0) && curproc != 0 && va < curproc->sz && va >= curproc->tf->esp && va < KERNBASE)
801052a3:	f6 43 34 01          	testb  $0x1,0x34(%ebx)
801052a7:	75 14                	jne    801052bd <trap+0x18e>
801052a9:	85 c0                	test   %eax,%eax
801052ab:	74 10                	je     801052bd <trap+0x18e>
801052ad:	3b 38                	cmp    (%eax),%edi
801052af:	73 0c                	jae    801052bd <trap+0x18e>
801052b1:	8b 40 18             	mov    0x18(%eax),%eax
801052b4:	3b 78 44             	cmp    0x44(%eax),%edi
801052b7:	72 04                	jb     801052bd <trap+0x18e>
801052b9:	85 ff                	test   %edi,%edi
801052bb:	79 1d                	jns    801052da <trap+0x1ab>
    cprintf("lazy alloc: invalid access at %x\n", va);
801052bd:	83 ec 08             	sub    $0x8,%esp
801052c0:	57                   	push   %edi
801052c1:	68 0c 70 10 80       	push   $0x8010700c
801052c6:	e8 14 b3 ff ff       	call   801005df <cprintf>
    curproc->killed = 1;
801052cb:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
    break;
801052d2:	83 c4 10             	add    $0x10,%esp
801052d5:	e9 d5 fe ff ff       	jmp    801051af <trap+0x80>
      uint a = PGROUNDDOWN(va);
801052da:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801052e0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      char *mem = kalloc();
801052e3:	e8 bf cd ff ff       	call   801020a7 <kalloc>
801052e8:	89 c7                	mov    %eax,%edi
      if (mem == 0)
801052ea:	85 c0                	test   %eax,%eax
801052ec:	74 5d                	je     8010534b <trap+0x21c>
        memset(mem, 0, PGSIZE);
801052ee:	83 ec 04             	sub    $0x4,%esp
801052f1:	68 00 10 00 00       	push   $0x1000
801052f6:	6a 00                	push   $0x0
801052f8:	50                   	push   %eax
801052f9:	e8 34 eb ff ff       	call   80103e32 <memset>
        if (mappages(curproc->pgdir, (void *)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
801052fe:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80105305:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
8010530b:	50                   	push   %eax
8010530c:	68 00 10 00 00       	push   $0x1000
80105311:	ff 75 e4             	push   -0x1c(%ebp)
80105314:	ff 76 04             	push   0x4(%esi)
80105317:	e8 e0 0f 00 00       	call   801062fc <mappages>
8010531c:	83 c4 20             	add    $0x20,%esp
8010531f:	85 c0                	test   %eax,%eax
80105321:	0f 89 88 fe ff ff    	jns    801051af <trap+0x80>
          cprintf("lazy alloc: mappages failed\n");
80105327:	83 ec 0c             	sub    $0xc,%esp
8010532a:	68 0e 6e 10 80       	push   $0x80106e0e
8010532f:	e8 ab b2 ff ff       	call   801005df <cprintf>
          kfree(mem);
80105334:	89 3c 24             	mov    %edi,(%esp)
80105337:	e8 54 cc ff ff       	call   80101f90 <kfree>
          curproc->killed = 1;
8010533c:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
80105343:	83 c4 10             	add    $0x10,%esp
80105346:	e9 64 fe ff ff       	jmp    801051af <trap+0x80>
        cprintf("lazy alloc: out of memory\n");
8010534b:	83 ec 0c             	sub    $0xc,%esp
8010534e:	68 f3 6d 10 80       	push   $0x80106df3
80105353:	e8 87 b2 ff ff       	call   801005df <cprintf>
        curproc->killed = 1;
80105358:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
8010535f:	83 c4 10             	add    $0x10,%esp
80105362:	e9 48 fe ff ff       	jmp    801051af <trap+0x80>
    if (myproc() == 0 || (tf->cs & 3) == 0)
80105367:	e8 1d df ff ff       	call   80103289 <myproc>
8010536c:	85 c0                	test   %eax,%eax
8010536e:	74 5f                	je     801053cf <trap+0x2a0>
80105370:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105374:	74 59                	je     801053cf <trap+0x2a0>
80105376:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105379:	8b 43 38             	mov    0x38(%ebx),%eax
8010537c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010537f:	e8 d4 de ff ff       	call   80103258 <cpuid>
80105384:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105387:	8b 53 34             	mov    0x34(%ebx),%edx
8010538a:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010538d:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
80105390:	e8 f4 de ff ff       	call   80103289 <myproc>
80105395:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105398:	89 4d d8             	mov    %ecx,-0x28(%ebp)
8010539b:	e8 e9 de ff ff       	call   80103289 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801053a0:	57                   	push   %edi
801053a1:	ff 75 e4             	push   -0x1c(%ebp)
801053a4:	ff 75 e0             	push   -0x20(%ebp)
801053a7:	ff 75 dc             	push   -0x24(%ebp)
801053aa:	56                   	push   %esi
801053ab:	ff 75 d8             	push   -0x28(%ebp)
801053ae:	ff 70 10             	push   0x10(%eax)
801053b1:	68 64 70 10 80       	push   $0x80107064
801053b6:	e8 24 b2 ff ff       	call   801005df <cprintf>
    myproc()->killed = 1;
801053bb:	83 c4 20             	add    $0x20,%esp
801053be:	e8 c6 de ff ff       	call   80103289 <myproc>
801053c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801053ca:	e9 e0 fd ff ff       	jmp    801051af <trap+0x80>
801053cf:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801053d2:	8b 73 38             	mov    0x38(%ebx),%esi
801053d5:	e8 7e de ff ff       	call   80103258 <cpuid>
801053da:	83 ec 0c             	sub    $0xc,%esp
801053dd:	57                   	push   %edi
801053de:	56                   	push   %esi
801053df:	50                   	push   %eax
801053e0:	ff 73 30             	push   0x30(%ebx)
801053e3:	68 30 70 10 80       	push   $0x80107030
801053e8:	e8 f2 b1 ff ff       	call   801005df <cprintf>
      panic("trap");
801053ed:	83 c4 14             	add    $0x14,%esp
801053f0:	68 2b 6e 10 80       	push   $0x80106e2b
801053f5:	e8 4a af ff ff       	call   80100344 <panic>
    exit(tf->trapno + 1);
801053fa:	8b 43 30             	mov    0x30(%ebx),%eax
801053fd:	40                   	inc    %eax
801053fe:	83 ec 0c             	sub    $0xc,%esp
80105401:	50                   	push   %eax
80105402:	e8 49 e2 ff ff       	call   80103650 <exit>
80105407:	83 c4 10             	add    $0x10,%esp
8010540a:	e9 c1 fd ff ff       	jmp    801051d0 <trap+0xa1>
  if (myproc() && myproc()->state == RUNNING &&
8010540f:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105413:	0f 85 cf fd ff ff    	jne    801051e8 <trap+0xb9>
    yield();
80105419:	e8 10 e3 ff ff       	call   8010372e <yield>
8010541e:	e9 c5 fd ff ff       	jmp    801051e8 <trap+0xb9>
    exit(tf->trapno + 1);
80105423:	8b 43 30             	mov    0x30(%ebx),%eax
80105426:	40                   	inc    %eax
80105427:	83 ec 0c             	sub    $0xc,%esp
8010542a:	50                   	push   %eax
8010542b:	e8 20 e2 ff ff       	call   80103650 <exit>
80105430:	83 c4 10             	add    $0x10,%esp
80105433:	e9 d1 fd ff ff       	jmp    80105209 <trap+0xda>

80105438 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105438:	83 3d 20 48 11 80 00 	cmpl   $0x0,0x80114820
8010543f:	74 14                	je     80105455 <uartgetc+0x1d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105441:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105446:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105447:	a8 01                	test   $0x1,%al
80105449:	74 10                	je     8010545b <uartgetc+0x23>
8010544b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105450:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105451:	0f b6 c0             	movzbl %al,%eax
80105454:	c3                   	ret
    return -1;
80105455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545a:	c3                   	ret
    return -1;
8010545b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105460:	c3                   	ret

80105461 <uartputc>:
  if(!uart)
80105461:	83 3d 20 48 11 80 00 	cmpl   $0x0,0x80114820
80105468:	74 39                	je     801054a3 <uartputc+0x42>
{
8010546a:	55                   	push   %ebp
8010546b:	89 e5                	mov    %esp,%ebp
8010546d:	53                   	push   %ebx
8010546e:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105471:	bb 00 00 00 00       	mov    $0x0,%ebx
80105476:	eb 0e                	jmp    80105486 <uartputc+0x25>
    microdelay(10);
80105478:	83 ec 0c             	sub    $0xc,%esp
8010547b:	6a 0a                	push   $0xa
8010547d:	e8 18 cf ff ff       	call   8010239a <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105482:	43                   	inc    %ebx
80105483:	83 c4 10             	add    $0x10,%esp
80105486:	83 fb 7f             	cmp    $0x7f,%ebx
80105489:	7f 0a                	jg     80105495 <uartputc+0x34>
8010548b:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105490:	ec                   	in     (%dx),%al
80105491:	a8 20                	test   $0x20,%al
80105493:	74 e3                	je     80105478 <uartputc+0x17>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105495:	8b 45 08             	mov    0x8(%ebp),%eax
80105498:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010549d:	ee                   	out    %al,(%dx)
}
8010549e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054a1:	c9                   	leave
801054a2:	c3                   	ret
801054a3:	c3                   	ret

801054a4 <uartinit>:
{
801054a4:	55                   	push   %ebp
801054a5:	89 e5                	mov    %esp,%ebp
801054a7:	56                   	push   %esi
801054a8:	53                   	push   %ebx
801054a9:	b1 00                	mov    $0x0,%cl
801054ab:	ba fa 03 00 00       	mov    $0x3fa,%edx
801054b0:	88 c8                	mov    %cl,%al
801054b2:	ee                   	out    %al,(%dx)
801054b3:	be fb 03 00 00       	mov    $0x3fb,%esi
801054b8:	b0 80                	mov    $0x80,%al
801054ba:	89 f2                	mov    %esi,%edx
801054bc:	ee                   	out    %al,(%dx)
801054bd:	b0 0c                	mov    $0xc,%al
801054bf:	ba f8 03 00 00       	mov    $0x3f8,%edx
801054c4:	ee                   	out    %al,(%dx)
801054c5:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801054ca:	88 c8                	mov    %cl,%al
801054cc:	89 da                	mov    %ebx,%edx
801054ce:	ee                   	out    %al,(%dx)
801054cf:	b0 03                	mov    $0x3,%al
801054d1:	89 f2                	mov    %esi,%edx
801054d3:	ee                   	out    %al,(%dx)
801054d4:	ba fc 03 00 00       	mov    $0x3fc,%edx
801054d9:	88 c8                	mov    %cl,%al
801054db:	ee                   	out    %al,(%dx)
801054dc:	b0 01                	mov    $0x1,%al
801054de:	89 da                	mov    %ebx,%edx
801054e0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801054e1:	ba fd 03 00 00       	mov    $0x3fd,%edx
801054e6:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801054e7:	3c ff                	cmp    $0xff,%al
801054e9:	74 42                	je     8010552d <uartinit+0x89>
  uart = 1;
801054eb:	c7 05 20 48 11 80 01 	movl   $0x1,0x80114820
801054f2:	00 00 00 
801054f5:	ba fa 03 00 00       	mov    $0x3fa,%edx
801054fa:	ec                   	in     (%dx),%al
801054fb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105500:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105501:	83 ec 08             	sub    $0x8,%esp
80105504:	6a 00                	push   $0x0
80105506:	6a 04                	push   $0x4
80105508:	e8 58 ca ff ff       	call   80101f65 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
8010550d:	83 c4 10             	add    $0x10,%esp
80105510:	bb 30 6e 10 80       	mov    $0x80106e30,%ebx
80105515:	eb 10                	jmp    80105527 <uartinit+0x83>
    uartputc(*p);
80105517:	83 ec 0c             	sub    $0xc,%esp
8010551a:	0f be c0             	movsbl %al,%eax
8010551d:	50                   	push   %eax
8010551e:	e8 3e ff ff ff       	call   80105461 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105523:	43                   	inc    %ebx
80105524:	83 c4 10             	add    $0x10,%esp
80105527:	8a 03                	mov    (%ebx),%al
80105529:	84 c0                	test   %al,%al
8010552b:	75 ea                	jne    80105517 <uartinit+0x73>
}
8010552d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105530:	5b                   	pop    %ebx
80105531:	5e                   	pop    %esi
80105532:	5d                   	pop    %ebp
80105533:	c3                   	ret

80105534 <uartintr>:

void
uartintr(void)
{
80105534:	55                   	push   %ebp
80105535:	89 e5                	mov    %esp,%ebp
80105537:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010553a:	68 38 54 10 80       	push   $0x80105438
8010553f:	e8 bd b1 ff ff       	call   80100701 <consoleintr>
}
80105544:	83 c4 10             	add    $0x10,%esp
80105547:	c9                   	leave
80105548:	c3                   	ret

80105549 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105549:	6a 00                	push   $0x0
  pushl $0
8010554b:	6a 00                	push   $0x0
  jmp alltraps
8010554d:	e9 99 fa ff ff       	jmp    80104feb <alltraps>

80105552 <vector1>:
.globl vector1
vector1:
  pushl $0
80105552:	6a 00                	push   $0x0
  pushl $1
80105554:	6a 01                	push   $0x1
  jmp alltraps
80105556:	e9 90 fa ff ff       	jmp    80104feb <alltraps>

8010555b <vector2>:
.globl vector2
vector2:
  pushl $0
8010555b:	6a 00                	push   $0x0
  pushl $2
8010555d:	6a 02                	push   $0x2
  jmp alltraps
8010555f:	e9 87 fa ff ff       	jmp    80104feb <alltraps>

80105564 <vector3>:
.globl vector3
vector3:
  pushl $0
80105564:	6a 00                	push   $0x0
  pushl $3
80105566:	6a 03                	push   $0x3
  jmp alltraps
80105568:	e9 7e fa ff ff       	jmp    80104feb <alltraps>

8010556d <vector4>:
.globl vector4
vector4:
  pushl $0
8010556d:	6a 00                	push   $0x0
  pushl $4
8010556f:	6a 04                	push   $0x4
  jmp alltraps
80105571:	e9 75 fa ff ff       	jmp    80104feb <alltraps>

80105576 <vector5>:
.globl vector5
vector5:
  pushl $0
80105576:	6a 00                	push   $0x0
  pushl $5
80105578:	6a 05                	push   $0x5
  jmp alltraps
8010557a:	e9 6c fa ff ff       	jmp    80104feb <alltraps>

8010557f <vector6>:
.globl vector6
vector6:
  pushl $0
8010557f:	6a 00                	push   $0x0
  pushl $6
80105581:	6a 06                	push   $0x6
  jmp alltraps
80105583:	e9 63 fa ff ff       	jmp    80104feb <alltraps>

80105588 <vector7>:
.globl vector7
vector7:
  pushl $0
80105588:	6a 00                	push   $0x0
  pushl $7
8010558a:	6a 07                	push   $0x7
  jmp alltraps
8010558c:	e9 5a fa ff ff       	jmp    80104feb <alltraps>

80105591 <vector8>:
.globl vector8
vector8:
  pushl $8
80105591:	6a 08                	push   $0x8
  jmp alltraps
80105593:	e9 53 fa ff ff       	jmp    80104feb <alltraps>

80105598 <vector9>:
.globl vector9
vector9:
  pushl $0
80105598:	6a 00                	push   $0x0
  pushl $9
8010559a:	6a 09                	push   $0x9
  jmp alltraps
8010559c:	e9 4a fa ff ff       	jmp    80104feb <alltraps>

801055a1 <vector10>:
.globl vector10
vector10:
  pushl $10
801055a1:	6a 0a                	push   $0xa
  jmp alltraps
801055a3:	e9 43 fa ff ff       	jmp    80104feb <alltraps>

801055a8 <vector11>:
.globl vector11
vector11:
  pushl $11
801055a8:	6a 0b                	push   $0xb
  jmp alltraps
801055aa:	e9 3c fa ff ff       	jmp    80104feb <alltraps>

801055af <vector12>:
.globl vector12
vector12:
  pushl $12
801055af:	6a 0c                	push   $0xc
  jmp alltraps
801055b1:	e9 35 fa ff ff       	jmp    80104feb <alltraps>

801055b6 <vector13>:
.globl vector13
vector13:
  pushl $13
801055b6:	6a 0d                	push   $0xd
  jmp alltraps
801055b8:	e9 2e fa ff ff       	jmp    80104feb <alltraps>

801055bd <vector14>:
.globl vector14
vector14:
  pushl $14
801055bd:	6a 0e                	push   $0xe
  jmp alltraps
801055bf:	e9 27 fa ff ff       	jmp    80104feb <alltraps>

801055c4 <vector15>:
.globl vector15
vector15:
  pushl $0
801055c4:	6a 00                	push   $0x0
  pushl $15
801055c6:	6a 0f                	push   $0xf
  jmp alltraps
801055c8:	e9 1e fa ff ff       	jmp    80104feb <alltraps>

801055cd <vector16>:
.globl vector16
vector16:
  pushl $0
801055cd:	6a 00                	push   $0x0
  pushl $16
801055cf:	6a 10                	push   $0x10
  jmp alltraps
801055d1:	e9 15 fa ff ff       	jmp    80104feb <alltraps>

801055d6 <vector17>:
.globl vector17
vector17:
  pushl $17
801055d6:	6a 11                	push   $0x11
  jmp alltraps
801055d8:	e9 0e fa ff ff       	jmp    80104feb <alltraps>

801055dd <vector18>:
.globl vector18
vector18:
  pushl $0
801055dd:	6a 00                	push   $0x0
  pushl $18
801055df:	6a 12                	push   $0x12
  jmp alltraps
801055e1:	e9 05 fa ff ff       	jmp    80104feb <alltraps>

801055e6 <vector19>:
.globl vector19
vector19:
  pushl $0
801055e6:	6a 00                	push   $0x0
  pushl $19
801055e8:	6a 13                	push   $0x13
  jmp alltraps
801055ea:	e9 fc f9 ff ff       	jmp    80104feb <alltraps>

801055ef <vector20>:
.globl vector20
vector20:
  pushl $0
801055ef:	6a 00                	push   $0x0
  pushl $20
801055f1:	6a 14                	push   $0x14
  jmp alltraps
801055f3:	e9 f3 f9 ff ff       	jmp    80104feb <alltraps>

801055f8 <vector21>:
.globl vector21
vector21:
  pushl $0
801055f8:	6a 00                	push   $0x0
  pushl $21
801055fa:	6a 15                	push   $0x15
  jmp alltraps
801055fc:	e9 ea f9 ff ff       	jmp    80104feb <alltraps>

80105601 <vector22>:
.globl vector22
vector22:
  pushl $0
80105601:	6a 00                	push   $0x0
  pushl $22
80105603:	6a 16                	push   $0x16
  jmp alltraps
80105605:	e9 e1 f9 ff ff       	jmp    80104feb <alltraps>

8010560a <vector23>:
.globl vector23
vector23:
  pushl $0
8010560a:	6a 00                	push   $0x0
  pushl $23
8010560c:	6a 17                	push   $0x17
  jmp alltraps
8010560e:	e9 d8 f9 ff ff       	jmp    80104feb <alltraps>

80105613 <vector24>:
.globl vector24
vector24:
  pushl $0
80105613:	6a 00                	push   $0x0
  pushl $24
80105615:	6a 18                	push   $0x18
  jmp alltraps
80105617:	e9 cf f9 ff ff       	jmp    80104feb <alltraps>

8010561c <vector25>:
.globl vector25
vector25:
  pushl $0
8010561c:	6a 00                	push   $0x0
  pushl $25
8010561e:	6a 19                	push   $0x19
  jmp alltraps
80105620:	e9 c6 f9 ff ff       	jmp    80104feb <alltraps>

80105625 <vector26>:
.globl vector26
vector26:
  pushl $0
80105625:	6a 00                	push   $0x0
  pushl $26
80105627:	6a 1a                	push   $0x1a
  jmp alltraps
80105629:	e9 bd f9 ff ff       	jmp    80104feb <alltraps>

8010562e <vector27>:
.globl vector27
vector27:
  pushl $0
8010562e:	6a 00                	push   $0x0
  pushl $27
80105630:	6a 1b                	push   $0x1b
  jmp alltraps
80105632:	e9 b4 f9 ff ff       	jmp    80104feb <alltraps>

80105637 <vector28>:
.globl vector28
vector28:
  pushl $0
80105637:	6a 00                	push   $0x0
  pushl $28
80105639:	6a 1c                	push   $0x1c
  jmp alltraps
8010563b:	e9 ab f9 ff ff       	jmp    80104feb <alltraps>

80105640 <vector29>:
.globl vector29
vector29:
  pushl $0
80105640:	6a 00                	push   $0x0
  pushl $29
80105642:	6a 1d                	push   $0x1d
  jmp alltraps
80105644:	e9 a2 f9 ff ff       	jmp    80104feb <alltraps>

80105649 <vector30>:
.globl vector30
vector30:
  pushl $0
80105649:	6a 00                	push   $0x0
  pushl $30
8010564b:	6a 1e                	push   $0x1e
  jmp alltraps
8010564d:	e9 99 f9 ff ff       	jmp    80104feb <alltraps>

80105652 <vector31>:
.globl vector31
vector31:
  pushl $0
80105652:	6a 00                	push   $0x0
  pushl $31
80105654:	6a 1f                	push   $0x1f
  jmp alltraps
80105656:	e9 90 f9 ff ff       	jmp    80104feb <alltraps>

8010565b <vector32>:
.globl vector32
vector32:
  pushl $0
8010565b:	6a 00                	push   $0x0
  pushl $32
8010565d:	6a 20                	push   $0x20
  jmp alltraps
8010565f:	e9 87 f9 ff ff       	jmp    80104feb <alltraps>

80105664 <vector33>:
.globl vector33
vector33:
  pushl $0
80105664:	6a 00                	push   $0x0
  pushl $33
80105666:	6a 21                	push   $0x21
  jmp alltraps
80105668:	e9 7e f9 ff ff       	jmp    80104feb <alltraps>

8010566d <vector34>:
.globl vector34
vector34:
  pushl $0
8010566d:	6a 00                	push   $0x0
  pushl $34
8010566f:	6a 22                	push   $0x22
  jmp alltraps
80105671:	e9 75 f9 ff ff       	jmp    80104feb <alltraps>

80105676 <vector35>:
.globl vector35
vector35:
  pushl $0
80105676:	6a 00                	push   $0x0
  pushl $35
80105678:	6a 23                	push   $0x23
  jmp alltraps
8010567a:	e9 6c f9 ff ff       	jmp    80104feb <alltraps>

8010567f <vector36>:
.globl vector36
vector36:
  pushl $0
8010567f:	6a 00                	push   $0x0
  pushl $36
80105681:	6a 24                	push   $0x24
  jmp alltraps
80105683:	e9 63 f9 ff ff       	jmp    80104feb <alltraps>

80105688 <vector37>:
.globl vector37
vector37:
  pushl $0
80105688:	6a 00                	push   $0x0
  pushl $37
8010568a:	6a 25                	push   $0x25
  jmp alltraps
8010568c:	e9 5a f9 ff ff       	jmp    80104feb <alltraps>

80105691 <vector38>:
.globl vector38
vector38:
  pushl $0
80105691:	6a 00                	push   $0x0
  pushl $38
80105693:	6a 26                	push   $0x26
  jmp alltraps
80105695:	e9 51 f9 ff ff       	jmp    80104feb <alltraps>

8010569a <vector39>:
.globl vector39
vector39:
  pushl $0
8010569a:	6a 00                	push   $0x0
  pushl $39
8010569c:	6a 27                	push   $0x27
  jmp alltraps
8010569e:	e9 48 f9 ff ff       	jmp    80104feb <alltraps>

801056a3 <vector40>:
.globl vector40
vector40:
  pushl $0
801056a3:	6a 00                	push   $0x0
  pushl $40
801056a5:	6a 28                	push   $0x28
  jmp alltraps
801056a7:	e9 3f f9 ff ff       	jmp    80104feb <alltraps>

801056ac <vector41>:
.globl vector41
vector41:
  pushl $0
801056ac:	6a 00                	push   $0x0
  pushl $41
801056ae:	6a 29                	push   $0x29
  jmp alltraps
801056b0:	e9 36 f9 ff ff       	jmp    80104feb <alltraps>

801056b5 <vector42>:
.globl vector42
vector42:
  pushl $0
801056b5:	6a 00                	push   $0x0
  pushl $42
801056b7:	6a 2a                	push   $0x2a
  jmp alltraps
801056b9:	e9 2d f9 ff ff       	jmp    80104feb <alltraps>

801056be <vector43>:
.globl vector43
vector43:
  pushl $0
801056be:	6a 00                	push   $0x0
  pushl $43
801056c0:	6a 2b                	push   $0x2b
  jmp alltraps
801056c2:	e9 24 f9 ff ff       	jmp    80104feb <alltraps>

801056c7 <vector44>:
.globl vector44
vector44:
  pushl $0
801056c7:	6a 00                	push   $0x0
  pushl $44
801056c9:	6a 2c                	push   $0x2c
  jmp alltraps
801056cb:	e9 1b f9 ff ff       	jmp    80104feb <alltraps>

801056d0 <vector45>:
.globl vector45
vector45:
  pushl $0
801056d0:	6a 00                	push   $0x0
  pushl $45
801056d2:	6a 2d                	push   $0x2d
  jmp alltraps
801056d4:	e9 12 f9 ff ff       	jmp    80104feb <alltraps>

801056d9 <vector46>:
.globl vector46
vector46:
  pushl $0
801056d9:	6a 00                	push   $0x0
  pushl $46
801056db:	6a 2e                	push   $0x2e
  jmp alltraps
801056dd:	e9 09 f9 ff ff       	jmp    80104feb <alltraps>

801056e2 <vector47>:
.globl vector47
vector47:
  pushl $0
801056e2:	6a 00                	push   $0x0
  pushl $47
801056e4:	6a 2f                	push   $0x2f
  jmp alltraps
801056e6:	e9 00 f9 ff ff       	jmp    80104feb <alltraps>

801056eb <vector48>:
.globl vector48
vector48:
  pushl $0
801056eb:	6a 00                	push   $0x0
  pushl $48
801056ed:	6a 30                	push   $0x30
  jmp alltraps
801056ef:	e9 f7 f8 ff ff       	jmp    80104feb <alltraps>

801056f4 <vector49>:
.globl vector49
vector49:
  pushl $0
801056f4:	6a 00                	push   $0x0
  pushl $49
801056f6:	6a 31                	push   $0x31
  jmp alltraps
801056f8:	e9 ee f8 ff ff       	jmp    80104feb <alltraps>

801056fd <vector50>:
.globl vector50
vector50:
  pushl $0
801056fd:	6a 00                	push   $0x0
  pushl $50
801056ff:	6a 32                	push   $0x32
  jmp alltraps
80105701:	e9 e5 f8 ff ff       	jmp    80104feb <alltraps>

80105706 <vector51>:
.globl vector51
vector51:
  pushl $0
80105706:	6a 00                	push   $0x0
  pushl $51
80105708:	6a 33                	push   $0x33
  jmp alltraps
8010570a:	e9 dc f8 ff ff       	jmp    80104feb <alltraps>

8010570f <vector52>:
.globl vector52
vector52:
  pushl $0
8010570f:	6a 00                	push   $0x0
  pushl $52
80105711:	6a 34                	push   $0x34
  jmp alltraps
80105713:	e9 d3 f8 ff ff       	jmp    80104feb <alltraps>

80105718 <vector53>:
.globl vector53
vector53:
  pushl $0
80105718:	6a 00                	push   $0x0
  pushl $53
8010571a:	6a 35                	push   $0x35
  jmp alltraps
8010571c:	e9 ca f8 ff ff       	jmp    80104feb <alltraps>

80105721 <vector54>:
.globl vector54
vector54:
  pushl $0
80105721:	6a 00                	push   $0x0
  pushl $54
80105723:	6a 36                	push   $0x36
  jmp alltraps
80105725:	e9 c1 f8 ff ff       	jmp    80104feb <alltraps>

8010572a <vector55>:
.globl vector55
vector55:
  pushl $0
8010572a:	6a 00                	push   $0x0
  pushl $55
8010572c:	6a 37                	push   $0x37
  jmp alltraps
8010572e:	e9 b8 f8 ff ff       	jmp    80104feb <alltraps>

80105733 <vector56>:
.globl vector56
vector56:
  pushl $0
80105733:	6a 00                	push   $0x0
  pushl $56
80105735:	6a 38                	push   $0x38
  jmp alltraps
80105737:	e9 af f8 ff ff       	jmp    80104feb <alltraps>

8010573c <vector57>:
.globl vector57
vector57:
  pushl $0
8010573c:	6a 00                	push   $0x0
  pushl $57
8010573e:	6a 39                	push   $0x39
  jmp alltraps
80105740:	e9 a6 f8 ff ff       	jmp    80104feb <alltraps>

80105745 <vector58>:
.globl vector58
vector58:
  pushl $0
80105745:	6a 00                	push   $0x0
  pushl $58
80105747:	6a 3a                	push   $0x3a
  jmp alltraps
80105749:	e9 9d f8 ff ff       	jmp    80104feb <alltraps>

8010574e <vector59>:
.globl vector59
vector59:
  pushl $0
8010574e:	6a 00                	push   $0x0
  pushl $59
80105750:	6a 3b                	push   $0x3b
  jmp alltraps
80105752:	e9 94 f8 ff ff       	jmp    80104feb <alltraps>

80105757 <vector60>:
.globl vector60
vector60:
  pushl $0
80105757:	6a 00                	push   $0x0
  pushl $60
80105759:	6a 3c                	push   $0x3c
  jmp alltraps
8010575b:	e9 8b f8 ff ff       	jmp    80104feb <alltraps>

80105760 <vector61>:
.globl vector61
vector61:
  pushl $0
80105760:	6a 00                	push   $0x0
  pushl $61
80105762:	6a 3d                	push   $0x3d
  jmp alltraps
80105764:	e9 82 f8 ff ff       	jmp    80104feb <alltraps>

80105769 <vector62>:
.globl vector62
vector62:
  pushl $0
80105769:	6a 00                	push   $0x0
  pushl $62
8010576b:	6a 3e                	push   $0x3e
  jmp alltraps
8010576d:	e9 79 f8 ff ff       	jmp    80104feb <alltraps>

80105772 <vector63>:
.globl vector63
vector63:
  pushl $0
80105772:	6a 00                	push   $0x0
  pushl $63
80105774:	6a 3f                	push   $0x3f
  jmp alltraps
80105776:	e9 70 f8 ff ff       	jmp    80104feb <alltraps>

8010577b <vector64>:
.globl vector64
vector64:
  pushl $0
8010577b:	6a 00                	push   $0x0
  pushl $64
8010577d:	6a 40                	push   $0x40
  jmp alltraps
8010577f:	e9 67 f8 ff ff       	jmp    80104feb <alltraps>

80105784 <vector65>:
.globl vector65
vector65:
  pushl $0
80105784:	6a 00                	push   $0x0
  pushl $65
80105786:	6a 41                	push   $0x41
  jmp alltraps
80105788:	e9 5e f8 ff ff       	jmp    80104feb <alltraps>

8010578d <vector66>:
.globl vector66
vector66:
  pushl $0
8010578d:	6a 00                	push   $0x0
  pushl $66
8010578f:	6a 42                	push   $0x42
  jmp alltraps
80105791:	e9 55 f8 ff ff       	jmp    80104feb <alltraps>

80105796 <vector67>:
.globl vector67
vector67:
  pushl $0
80105796:	6a 00                	push   $0x0
  pushl $67
80105798:	6a 43                	push   $0x43
  jmp alltraps
8010579a:	e9 4c f8 ff ff       	jmp    80104feb <alltraps>

8010579f <vector68>:
.globl vector68
vector68:
  pushl $0
8010579f:	6a 00                	push   $0x0
  pushl $68
801057a1:	6a 44                	push   $0x44
  jmp alltraps
801057a3:	e9 43 f8 ff ff       	jmp    80104feb <alltraps>

801057a8 <vector69>:
.globl vector69
vector69:
  pushl $0
801057a8:	6a 00                	push   $0x0
  pushl $69
801057aa:	6a 45                	push   $0x45
  jmp alltraps
801057ac:	e9 3a f8 ff ff       	jmp    80104feb <alltraps>

801057b1 <vector70>:
.globl vector70
vector70:
  pushl $0
801057b1:	6a 00                	push   $0x0
  pushl $70
801057b3:	6a 46                	push   $0x46
  jmp alltraps
801057b5:	e9 31 f8 ff ff       	jmp    80104feb <alltraps>

801057ba <vector71>:
.globl vector71
vector71:
  pushl $0
801057ba:	6a 00                	push   $0x0
  pushl $71
801057bc:	6a 47                	push   $0x47
  jmp alltraps
801057be:	e9 28 f8 ff ff       	jmp    80104feb <alltraps>

801057c3 <vector72>:
.globl vector72
vector72:
  pushl $0
801057c3:	6a 00                	push   $0x0
  pushl $72
801057c5:	6a 48                	push   $0x48
  jmp alltraps
801057c7:	e9 1f f8 ff ff       	jmp    80104feb <alltraps>

801057cc <vector73>:
.globl vector73
vector73:
  pushl $0
801057cc:	6a 00                	push   $0x0
  pushl $73
801057ce:	6a 49                	push   $0x49
  jmp alltraps
801057d0:	e9 16 f8 ff ff       	jmp    80104feb <alltraps>

801057d5 <vector74>:
.globl vector74
vector74:
  pushl $0
801057d5:	6a 00                	push   $0x0
  pushl $74
801057d7:	6a 4a                	push   $0x4a
  jmp alltraps
801057d9:	e9 0d f8 ff ff       	jmp    80104feb <alltraps>

801057de <vector75>:
.globl vector75
vector75:
  pushl $0
801057de:	6a 00                	push   $0x0
  pushl $75
801057e0:	6a 4b                	push   $0x4b
  jmp alltraps
801057e2:	e9 04 f8 ff ff       	jmp    80104feb <alltraps>

801057e7 <vector76>:
.globl vector76
vector76:
  pushl $0
801057e7:	6a 00                	push   $0x0
  pushl $76
801057e9:	6a 4c                	push   $0x4c
  jmp alltraps
801057eb:	e9 fb f7 ff ff       	jmp    80104feb <alltraps>

801057f0 <vector77>:
.globl vector77
vector77:
  pushl $0
801057f0:	6a 00                	push   $0x0
  pushl $77
801057f2:	6a 4d                	push   $0x4d
  jmp alltraps
801057f4:	e9 f2 f7 ff ff       	jmp    80104feb <alltraps>

801057f9 <vector78>:
.globl vector78
vector78:
  pushl $0
801057f9:	6a 00                	push   $0x0
  pushl $78
801057fb:	6a 4e                	push   $0x4e
  jmp alltraps
801057fd:	e9 e9 f7 ff ff       	jmp    80104feb <alltraps>

80105802 <vector79>:
.globl vector79
vector79:
  pushl $0
80105802:	6a 00                	push   $0x0
  pushl $79
80105804:	6a 4f                	push   $0x4f
  jmp alltraps
80105806:	e9 e0 f7 ff ff       	jmp    80104feb <alltraps>

8010580b <vector80>:
.globl vector80
vector80:
  pushl $0
8010580b:	6a 00                	push   $0x0
  pushl $80
8010580d:	6a 50                	push   $0x50
  jmp alltraps
8010580f:	e9 d7 f7 ff ff       	jmp    80104feb <alltraps>

80105814 <vector81>:
.globl vector81
vector81:
  pushl $0
80105814:	6a 00                	push   $0x0
  pushl $81
80105816:	6a 51                	push   $0x51
  jmp alltraps
80105818:	e9 ce f7 ff ff       	jmp    80104feb <alltraps>

8010581d <vector82>:
.globl vector82
vector82:
  pushl $0
8010581d:	6a 00                	push   $0x0
  pushl $82
8010581f:	6a 52                	push   $0x52
  jmp alltraps
80105821:	e9 c5 f7 ff ff       	jmp    80104feb <alltraps>

80105826 <vector83>:
.globl vector83
vector83:
  pushl $0
80105826:	6a 00                	push   $0x0
  pushl $83
80105828:	6a 53                	push   $0x53
  jmp alltraps
8010582a:	e9 bc f7 ff ff       	jmp    80104feb <alltraps>

8010582f <vector84>:
.globl vector84
vector84:
  pushl $0
8010582f:	6a 00                	push   $0x0
  pushl $84
80105831:	6a 54                	push   $0x54
  jmp alltraps
80105833:	e9 b3 f7 ff ff       	jmp    80104feb <alltraps>

80105838 <vector85>:
.globl vector85
vector85:
  pushl $0
80105838:	6a 00                	push   $0x0
  pushl $85
8010583a:	6a 55                	push   $0x55
  jmp alltraps
8010583c:	e9 aa f7 ff ff       	jmp    80104feb <alltraps>

80105841 <vector86>:
.globl vector86
vector86:
  pushl $0
80105841:	6a 00                	push   $0x0
  pushl $86
80105843:	6a 56                	push   $0x56
  jmp alltraps
80105845:	e9 a1 f7 ff ff       	jmp    80104feb <alltraps>

8010584a <vector87>:
.globl vector87
vector87:
  pushl $0
8010584a:	6a 00                	push   $0x0
  pushl $87
8010584c:	6a 57                	push   $0x57
  jmp alltraps
8010584e:	e9 98 f7 ff ff       	jmp    80104feb <alltraps>

80105853 <vector88>:
.globl vector88
vector88:
  pushl $0
80105853:	6a 00                	push   $0x0
  pushl $88
80105855:	6a 58                	push   $0x58
  jmp alltraps
80105857:	e9 8f f7 ff ff       	jmp    80104feb <alltraps>

8010585c <vector89>:
.globl vector89
vector89:
  pushl $0
8010585c:	6a 00                	push   $0x0
  pushl $89
8010585e:	6a 59                	push   $0x59
  jmp alltraps
80105860:	e9 86 f7 ff ff       	jmp    80104feb <alltraps>

80105865 <vector90>:
.globl vector90
vector90:
  pushl $0
80105865:	6a 00                	push   $0x0
  pushl $90
80105867:	6a 5a                	push   $0x5a
  jmp alltraps
80105869:	e9 7d f7 ff ff       	jmp    80104feb <alltraps>

8010586e <vector91>:
.globl vector91
vector91:
  pushl $0
8010586e:	6a 00                	push   $0x0
  pushl $91
80105870:	6a 5b                	push   $0x5b
  jmp alltraps
80105872:	e9 74 f7 ff ff       	jmp    80104feb <alltraps>

80105877 <vector92>:
.globl vector92
vector92:
  pushl $0
80105877:	6a 00                	push   $0x0
  pushl $92
80105879:	6a 5c                	push   $0x5c
  jmp alltraps
8010587b:	e9 6b f7 ff ff       	jmp    80104feb <alltraps>

80105880 <vector93>:
.globl vector93
vector93:
  pushl $0
80105880:	6a 00                	push   $0x0
  pushl $93
80105882:	6a 5d                	push   $0x5d
  jmp alltraps
80105884:	e9 62 f7 ff ff       	jmp    80104feb <alltraps>

80105889 <vector94>:
.globl vector94
vector94:
  pushl $0
80105889:	6a 00                	push   $0x0
  pushl $94
8010588b:	6a 5e                	push   $0x5e
  jmp alltraps
8010588d:	e9 59 f7 ff ff       	jmp    80104feb <alltraps>

80105892 <vector95>:
.globl vector95
vector95:
  pushl $0
80105892:	6a 00                	push   $0x0
  pushl $95
80105894:	6a 5f                	push   $0x5f
  jmp alltraps
80105896:	e9 50 f7 ff ff       	jmp    80104feb <alltraps>

8010589b <vector96>:
.globl vector96
vector96:
  pushl $0
8010589b:	6a 00                	push   $0x0
  pushl $96
8010589d:	6a 60                	push   $0x60
  jmp alltraps
8010589f:	e9 47 f7 ff ff       	jmp    80104feb <alltraps>

801058a4 <vector97>:
.globl vector97
vector97:
  pushl $0
801058a4:	6a 00                	push   $0x0
  pushl $97
801058a6:	6a 61                	push   $0x61
  jmp alltraps
801058a8:	e9 3e f7 ff ff       	jmp    80104feb <alltraps>

801058ad <vector98>:
.globl vector98
vector98:
  pushl $0
801058ad:	6a 00                	push   $0x0
  pushl $98
801058af:	6a 62                	push   $0x62
  jmp alltraps
801058b1:	e9 35 f7 ff ff       	jmp    80104feb <alltraps>

801058b6 <vector99>:
.globl vector99
vector99:
  pushl $0
801058b6:	6a 00                	push   $0x0
  pushl $99
801058b8:	6a 63                	push   $0x63
  jmp alltraps
801058ba:	e9 2c f7 ff ff       	jmp    80104feb <alltraps>

801058bf <vector100>:
.globl vector100
vector100:
  pushl $0
801058bf:	6a 00                	push   $0x0
  pushl $100
801058c1:	6a 64                	push   $0x64
  jmp alltraps
801058c3:	e9 23 f7 ff ff       	jmp    80104feb <alltraps>

801058c8 <vector101>:
.globl vector101
vector101:
  pushl $0
801058c8:	6a 00                	push   $0x0
  pushl $101
801058ca:	6a 65                	push   $0x65
  jmp alltraps
801058cc:	e9 1a f7 ff ff       	jmp    80104feb <alltraps>

801058d1 <vector102>:
.globl vector102
vector102:
  pushl $0
801058d1:	6a 00                	push   $0x0
  pushl $102
801058d3:	6a 66                	push   $0x66
  jmp alltraps
801058d5:	e9 11 f7 ff ff       	jmp    80104feb <alltraps>

801058da <vector103>:
.globl vector103
vector103:
  pushl $0
801058da:	6a 00                	push   $0x0
  pushl $103
801058dc:	6a 67                	push   $0x67
  jmp alltraps
801058de:	e9 08 f7 ff ff       	jmp    80104feb <alltraps>

801058e3 <vector104>:
.globl vector104
vector104:
  pushl $0
801058e3:	6a 00                	push   $0x0
  pushl $104
801058e5:	6a 68                	push   $0x68
  jmp alltraps
801058e7:	e9 ff f6 ff ff       	jmp    80104feb <alltraps>

801058ec <vector105>:
.globl vector105
vector105:
  pushl $0
801058ec:	6a 00                	push   $0x0
  pushl $105
801058ee:	6a 69                	push   $0x69
  jmp alltraps
801058f0:	e9 f6 f6 ff ff       	jmp    80104feb <alltraps>

801058f5 <vector106>:
.globl vector106
vector106:
  pushl $0
801058f5:	6a 00                	push   $0x0
  pushl $106
801058f7:	6a 6a                	push   $0x6a
  jmp alltraps
801058f9:	e9 ed f6 ff ff       	jmp    80104feb <alltraps>

801058fe <vector107>:
.globl vector107
vector107:
  pushl $0
801058fe:	6a 00                	push   $0x0
  pushl $107
80105900:	6a 6b                	push   $0x6b
  jmp alltraps
80105902:	e9 e4 f6 ff ff       	jmp    80104feb <alltraps>

80105907 <vector108>:
.globl vector108
vector108:
  pushl $0
80105907:	6a 00                	push   $0x0
  pushl $108
80105909:	6a 6c                	push   $0x6c
  jmp alltraps
8010590b:	e9 db f6 ff ff       	jmp    80104feb <alltraps>

80105910 <vector109>:
.globl vector109
vector109:
  pushl $0
80105910:	6a 00                	push   $0x0
  pushl $109
80105912:	6a 6d                	push   $0x6d
  jmp alltraps
80105914:	e9 d2 f6 ff ff       	jmp    80104feb <alltraps>

80105919 <vector110>:
.globl vector110
vector110:
  pushl $0
80105919:	6a 00                	push   $0x0
  pushl $110
8010591b:	6a 6e                	push   $0x6e
  jmp alltraps
8010591d:	e9 c9 f6 ff ff       	jmp    80104feb <alltraps>

80105922 <vector111>:
.globl vector111
vector111:
  pushl $0
80105922:	6a 00                	push   $0x0
  pushl $111
80105924:	6a 6f                	push   $0x6f
  jmp alltraps
80105926:	e9 c0 f6 ff ff       	jmp    80104feb <alltraps>

8010592b <vector112>:
.globl vector112
vector112:
  pushl $0
8010592b:	6a 00                	push   $0x0
  pushl $112
8010592d:	6a 70                	push   $0x70
  jmp alltraps
8010592f:	e9 b7 f6 ff ff       	jmp    80104feb <alltraps>

80105934 <vector113>:
.globl vector113
vector113:
  pushl $0
80105934:	6a 00                	push   $0x0
  pushl $113
80105936:	6a 71                	push   $0x71
  jmp alltraps
80105938:	e9 ae f6 ff ff       	jmp    80104feb <alltraps>

8010593d <vector114>:
.globl vector114
vector114:
  pushl $0
8010593d:	6a 00                	push   $0x0
  pushl $114
8010593f:	6a 72                	push   $0x72
  jmp alltraps
80105941:	e9 a5 f6 ff ff       	jmp    80104feb <alltraps>

80105946 <vector115>:
.globl vector115
vector115:
  pushl $0
80105946:	6a 00                	push   $0x0
  pushl $115
80105948:	6a 73                	push   $0x73
  jmp alltraps
8010594a:	e9 9c f6 ff ff       	jmp    80104feb <alltraps>

8010594f <vector116>:
.globl vector116
vector116:
  pushl $0
8010594f:	6a 00                	push   $0x0
  pushl $116
80105951:	6a 74                	push   $0x74
  jmp alltraps
80105953:	e9 93 f6 ff ff       	jmp    80104feb <alltraps>

80105958 <vector117>:
.globl vector117
vector117:
  pushl $0
80105958:	6a 00                	push   $0x0
  pushl $117
8010595a:	6a 75                	push   $0x75
  jmp alltraps
8010595c:	e9 8a f6 ff ff       	jmp    80104feb <alltraps>

80105961 <vector118>:
.globl vector118
vector118:
  pushl $0
80105961:	6a 00                	push   $0x0
  pushl $118
80105963:	6a 76                	push   $0x76
  jmp alltraps
80105965:	e9 81 f6 ff ff       	jmp    80104feb <alltraps>

8010596a <vector119>:
.globl vector119
vector119:
  pushl $0
8010596a:	6a 00                	push   $0x0
  pushl $119
8010596c:	6a 77                	push   $0x77
  jmp alltraps
8010596e:	e9 78 f6 ff ff       	jmp    80104feb <alltraps>

80105973 <vector120>:
.globl vector120
vector120:
  pushl $0
80105973:	6a 00                	push   $0x0
  pushl $120
80105975:	6a 78                	push   $0x78
  jmp alltraps
80105977:	e9 6f f6 ff ff       	jmp    80104feb <alltraps>

8010597c <vector121>:
.globl vector121
vector121:
  pushl $0
8010597c:	6a 00                	push   $0x0
  pushl $121
8010597e:	6a 79                	push   $0x79
  jmp alltraps
80105980:	e9 66 f6 ff ff       	jmp    80104feb <alltraps>

80105985 <vector122>:
.globl vector122
vector122:
  pushl $0
80105985:	6a 00                	push   $0x0
  pushl $122
80105987:	6a 7a                	push   $0x7a
  jmp alltraps
80105989:	e9 5d f6 ff ff       	jmp    80104feb <alltraps>

8010598e <vector123>:
.globl vector123
vector123:
  pushl $0
8010598e:	6a 00                	push   $0x0
  pushl $123
80105990:	6a 7b                	push   $0x7b
  jmp alltraps
80105992:	e9 54 f6 ff ff       	jmp    80104feb <alltraps>

80105997 <vector124>:
.globl vector124
vector124:
  pushl $0
80105997:	6a 00                	push   $0x0
  pushl $124
80105999:	6a 7c                	push   $0x7c
  jmp alltraps
8010599b:	e9 4b f6 ff ff       	jmp    80104feb <alltraps>

801059a0 <vector125>:
.globl vector125
vector125:
  pushl $0
801059a0:	6a 00                	push   $0x0
  pushl $125
801059a2:	6a 7d                	push   $0x7d
  jmp alltraps
801059a4:	e9 42 f6 ff ff       	jmp    80104feb <alltraps>

801059a9 <vector126>:
.globl vector126
vector126:
  pushl $0
801059a9:	6a 00                	push   $0x0
  pushl $126
801059ab:	6a 7e                	push   $0x7e
  jmp alltraps
801059ad:	e9 39 f6 ff ff       	jmp    80104feb <alltraps>

801059b2 <vector127>:
.globl vector127
vector127:
  pushl $0
801059b2:	6a 00                	push   $0x0
  pushl $127
801059b4:	6a 7f                	push   $0x7f
  jmp alltraps
801059b6:	e9 30 f6 ff ff       	jmp    80104feb <alltraps>

801059bb <vector128>:
.globl vector128
vector128:
  pushl $0
801059bb:	6a 00                	push   $0x0
  pushl $128
801059bd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801059c2:	e9 24 f6 ff ff       	jmp    80104feb <alltraps>

801059c7 <vector129>:
.globl vector129
vector129:
  pushl $0
801059c7:	6a 00                	push   $0x0
  pushl $129
801059c9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801059ce:	e9 18 f6 ff ff       	jmp    80104feb <alltraps>

801059d3 <vector130>:
.globl vector130
vector130:
  pushl $0
801059d3:	6a 00                	push   $0x0
  pushl $130
801059d5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801059da:	e9 0c f6 ff ff       	jmp    80104feb <alltraps>

801059df <vector131>:
.globl vector131
vector131:
  pushl $0
801059df:	6a 00                	push   $0x0
  pushl $131
801059e1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801059e6:	e9 00 f6 ff ff       	jmp    80104feb <alltraps>

801059eb <vector132>:
.globl vector132
vector132:
  pushl $0
801059eb:	6a 00                	push   $0x0
  pushl $132
801059ed:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801059f2:	e9 f4 f5 ff ff       	jmp    80104feb <alltraps>

801059f7 <vector133>:
.globl vector133
vector133:
  pushl $0
801059f7:	6a 00                	push   $0x0
  pushl $133
801059f9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801059fe:	e9 e8 f5 ff ff       	jmp    80104feb <alltraps>

80105a03 <vector134>:
.globl vector134
vector134:
  pushl $0
80105a03:	6a 00                	push   $0x0
  pushl $134
80105a05:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105a0a:	e9 dc f5 ff ff       	jmp    80104feb <alltraps>

80105a0f <vector135>:
.globl vector135
vector135:
  pushl $0
80105a0f:	6a 00                	push   $0x0
  pushl $135
80105a11:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105a16:	e9 d0 f5 ff ff       	jmp    80104feb <alltraps>

80105a1b <vector136>:
.globl vector136
vector136:
  pushl $0
80105a1b:	6a 00                	push   $0x0
  pushl $136
80105a1d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105a22:	e9 c4 f5 ff ff       	jmp    80104feb <alltraps>

80105a27 <vector137>:
.globl vector137
vector137:
  pushl $0
80105a27:	6a 00                	push   $0x0
  pushl $137
80105a29:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105a2e:	e9 b8 f5 ff ff       	jmp    80104feb <alltraps>

80105a33 <vector138>:
.globl vector138
vector138:
  pushl $0
80105a33:	6a 00                	push   $0x0
  pushl $138
80105a35:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105a3a:	e9 ac f5 ff ff       	jmp    80104feb <alltraps>

80105a3f <vector139>:
.globl vector139
vector139:
  pushl $0
80105a3f:	6a 00                	push   $0x0
  pushl $139
80105a41:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105a46:	e9 a0 f5 ff ff       	jmp    80104feb <alltraps>

80105a4b <vector140>:
.globl vector140
vector140:
  pushl $0
80105a4b:	6a 00                	push   $0x0
  pushl $140
80105a4d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105a52:	e9 94 f5 ff ff       	jmp    80104feb <alltraps>

80105a57 <vector141>:
.globl vector141
vector141:
  pushl $0
80105a57:	6a 00                	push   $0x0
  pushl $141
80105a59:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105a5e:	e9 88 f5 ff ff       	jmp    80104feb <alltraps>

80105a63 <vector142>:
.globl vector142
vector142:
  pushl $0
80105a63:	6a 00                	push   $0x0
  pushl $142
80105a65:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105a6a:	e9 7c f5 ff ff       	jmp    80104feb <alltraps>

80105a6f <vector143>:
.globl vector143
vector143:
  pushl $0
80105a6f:	6a 00                	push   $0x0
  pushl $143
80105a71:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105a76:	e9 70 f5 ff ff       	jmp    80104feb <alltraps>

80105a7b <vector144>:
.globl vector144
vector144:
  pushl $0
80105a7b:	6a 00                	push   $0x0
  pushl $144
80105a7d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105a82:	e9 64 f5 ff ff       	jmp    80104feb <alltraps>

80105a87 <vector145>:
.globl vector145
vector145:
  pushl $0
80105a87:	6a 00                	push   $0x0
  pushl $145
80105a89:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105a8e:	e9 58 f5 ff ff       	jmp    80104feb <alltraps>

80105a93 <vector146>:
.globl vector146
vector146:
  pushl $0
80105a93:	6a 00                	push   $0x0
  pushl $146
80105a95:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105a9a:	e9 4c f5 ff ff       	jmp    80104feb <alltraps>

80105a9f <vector147>:
.globl vector147
vector147:
  pushl $0
80105a9f:	6a 00                	push   $0x0
  pushl $147
80105aa1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105aa6:	e9 40 f5 ff ff       	jmp    80104feb <alltraps>

80105aab <vector148>:
.globl vector148
vector148:
  pushl $0
80105aab:	6a 00                	push   $0x0
  pushl $148
80105aad:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105ab2:	e9 34 f5 ff ff       	jmp    80104feb <alltraps>

80105ab7 <vector149>:
.globl vector149
vector149:
  pushl $0
80105ab7:	6a 00                	push   $0x0
  pushl $149
80105ab9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105abe:	e9 28 f5 ff ff       	jmp    80104feb <alltraps>

80105ac3 <vector150>:
.globl vector150
vector150:
  pushl $0
80105ac3:	6a 00                	push   $0x0
  pushl $150
80105ac5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105aca:	e9 1c f5 ff ff       	jmp    80104feb <alltraps>

80105acf <vector151>:
.globl vector151
vector151:
  pushl $0
80105acf:	6a 00                	push   $0x0
  pushl $151
80105ad1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105ad6:	e9 10 f5 ff ff       	jmp    80104feb <alltraps>

80105adb <vector152>:
.globl vector152
vector152:
  pushl $0
80105adb:	6a 00                	push   $0x0
  pushl $152
80105add:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105ae2:	e9 04 f5 ff ff       	jmp    80104feb <alltraps>

80105ae7 <vector153>:
.globl vector153
vector153:
  pushl $0
80105ae7:	6a 00                	push   $0x0
  pushl $153
80105ae9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105aee:	e9 f8 f4 ff ff       	jmp    80104feb <alltraps>

80105af3 <vector154>:
.globl vector154
vector154:
  pushl $0
80105af3:	6a 00                	push   $0x0
  pushl $154
80105af5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105afa:	e9 ec f4 ff ff       	jmp    80104feb <alltraps>

80105aff <vector155>:
.globl vector155
vector155:
  pushl $0
80105aff:	6a 00                	push   $0x0
  pushl $155
80105b01:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105b06:	e9 e0 f4 ff ff       	jmp    80104feb <alltraps>

80105b0b <vector156>:
.globl vector156
vector156:
  pushl $0
80105b0b:	6a 00                	push   $0x0
  pushl $156
80105b0d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105b12:	e9 d4 f4 ff ff       	jmp    80104feb <alltraps>

80105b17 <vector157>:
.globl vector157
vector157:
  pushl $0
80105b17:	6a 00                	push   $0x0
  pushl $157
80105b19:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105b1e:	e9 c8 f4 ff ff       	jmp    80104feb <alltraps>

80105b23 <vector158>:
.globl vector158
vector158:
  pushl $0
80105b23:	6a 00                	push   $0x0
  pushl $158
80105b25:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105b2a:	e9 bc f4 ff ff       	jmp    80104feb <alltraps>

80105b2f <vector159>:
.globl vector159
vector159:
  pushl $0
80105b2f:	6a 00                	push   $0x0
  pushl $159
80105b31:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105b36:	e9 b0 f4 ff ff       	jmp    80104feb <alltraps>

80105b3b <vector160>:
.globl vector160
vector160:
  pushl $0
80105b3b:	6a 00                	push   $0x0
  pushl $160
80105b3d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105b42:	e9 a4 f4 ff ff       	jmp    80104feb <alltraps>

80105b47 <vector161>:
.globl vector161
vector161:
  pushl $0
80105b47:	6a 00                	push   $0x0
  pushl $161
80105b49:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105b4e:	e9 98 f4 ff ff       	jmp    80104feb <alltraps>

80105b53 <vector162>:
.globl vector162
vector162:
  pushl $0
80105b53:	6a 00                	push   $0x0
  pushl $162
80105b55:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105b5a:	e9 8c f4 ff ff       	jmp    80104feb <alltraps>

80105b5f <vector163>:
.globl vector163
vector163:
  pushl $0
80105b5f:	6a 00                	push   $0x0
  pushl $163
80105b61:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105b66:	e9 80 f4 ff ff       	jmp    80104feb <alltraps>

80105b6b <vector164>:
.globl vector164
vector164:
  pushl $0
80105b6b:	6a 00                	push   $0x0
  pushl $164
80105b6d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105b72:	e9 74 f4 ff ff       	jmp    80104feb <alltraps>

80105b77 <vector165>:
.globl vector165
vector165:
  pushl $0
80105b77:	6a 00                	push   $0x0
  pushl $165
80105b79:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105b7e:	e9 68 f4 ff ff       	jmp    80104feb <alltraps>

80105b83 <vector166>:
.globl vector166
vector166:
  pushl $0
80105b83:	6a 00                	push   $0x0
  pushl $166
80105b85:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105b8a:	e9 5c f4 ff ff       	jmp    80104feb <alltraps>

80105b8f <vector167>:
.globl vector167
vector167:
  pushl $0
80105b8f:	6a 00                	push   $0x0
  pushl $167
80105b91:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105b96:	e9 50 f4 ff ff       	jmp    80104feb <alltraps>

80105b9b <vector168>:
.globl vector168
vector168:
  pushl $0
80105b9b:	6a 00                	push   $0x0
  pushl $168
80105b9d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105ba2:	e9 44 f4 ff ff       	jmp    80104feb <alltraps>

80105ba7 <vector169>:
.globl vector169
vector169:
  pushl $0
80105ba7:	6a 00                	push   $0x0
  pushl $169
80105ba9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105bae:	e9 38 f4 ff ff       	jmp    80104feb <alltraps>

80105bb3 <vector170>:
.globl vector170
vector170:
  pushl $0
80105bb3:	6a 00                	push   $0x0
  pushl $170
80105bb5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105bba:	e9 2c f4 ff ff       	jmp    80104feb <alltraps>

80105bbf <vector171>:
.globl vector171
vector171:
  pushl $0
80105bbf:	6a 00                	push   $0x0
  pushl $171
80105bc1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105bc6:	e9 20 f4 ff ff       	jmp    80104feb <alltraps>

80105bcb <vector172>:
.globl vector172
vector172:
  pushl $0
80105bcb:	6a 00                	push   $0x0
  pushl $172
80105bcd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105bd2:	e9 14 f4 ff ff       	jmp    80104feb <alltraps>

80105bd7 <vector173>:
.globl vector173
vector173:
  pushl $0
80105bd7:	6a 00                	push   $0x0
  pushl $173
80105bd9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105bde:	e9 08 f4 ff ff       	jmp    80104feb <alltraps>

80105be3 <vector174>:
.globl vector174
vector174:
  pushl $0
80105be3:	6a 00                	push   $0x0
  pushl $174
80105be5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105bea:	e9 fc f3 ff ff       	jmp    80104feb <alltraps>

80105bef <vector175>:
.globl vector175
vector175:
  pushl $0
80105bef:	6a 00                	push   $0x0
  pushl $175
80105bf1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105bf6:	e9 f0 f3 ff ff       	jmp    80104feb <alltraps>

80105bfb <vector176>:
.globl vector176
vector176:
  pushl $0
80105bfb:	6a 00                	push   $0x0
  pushl $176
80105bfd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105c02:	e9 e4 f3 ff ff       	jmp    80104feb <alltraps>

80105c07 <vector177>:
.globl vector177
vector177:
  pushl $0
80105c07:	6a 00                	push   $0x0
  pushl $177
80105c09:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105c0e:	e9 d8 f3 ff ff       	jmp    80104feb <alltraps>

80105c13 <vector178>:
.globl vector178
vector178:
  pushl $0
80105c13:	6a 00                	push   $0x0
  pushl $178
80105c15:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105c1a:	e9 cc f3 ff ff       	jmp    80104feb <alltraps>

80105c1f <vector179>:
.globl vector179
vector179:
  pushl $0
80105c1f:	6a 00                	push   $0x0
  pushl $179
80105c21:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105c26:	e9 c0 f3 ff ff       	jmp    80104feb <alltraps>

80105c2b <vector180>:
.globl vector180
vector180:
  pushl $0
80105c2b:	6a 00                	push   $0x0
  pushl $180
80105c2d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105c32:	e9 b4 f3 ff ff       	jmp    80104feb <alltraps>

80105c37 <vector181>:
.globl vector181
vector181:
  pushl $0
80105c37:	6a 00                	push   $0x0
  pushl $181
80105c39:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105c3e:	e9 a8 f3 ff ff       	jmp    80104feb <alltraps>

80105c43 <vector182>:
.globl vector182
vector182:
  pushl $0
80105c43:	6a 00                	push   $0x0
  pushl $182
80105c45:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105c4a:	e9 9c f3 ff ff       	jmp    80104feb <alltraps>

80105c4f <vector183>:
.globl vector183
vector183:
  pushl $0
80105c4f:	6a 00                	push   $0x0
  pushl $183
80105c51:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105c56:	e9 90 f3 ff ff       	jmp    80104feb <alltraps>

80105c5b <vector184>:
.globl vector184
vector184:
  pushl $0
80105c5b:	6a 00                	push   $0x0
  pushl $184
80105c5d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105c62:	e9 84 f3 ff ff       	jmp    80104feb <alltraps>

80105c67 <vector185>:
.globl vector185
vector185:
  pushl $0
80105c67:	6a 00                	push   $0x0
  pushl $185
80105c69:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105c6e:	e9 78 f3 ff ff       	jmp    80104feb <alltraps>

80105c73 <vector186>:
.globl vector186
vector186:
  pushl $0
80105c73:	6a 00                	push   $0x0
  pushl $186
80105c75:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105c7a:	e9 6c f3 ff ff       	jmp    80104feb <alltraps>

80105c7f <vector187>:
.globl vector187
vector187:
  pushl $0
80105c7f:	6a 00                	push   $0x0
  pushl $187
80105c81:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105c86:	e9 60 f3 ff ff       	jmp    80104feb <alltraps>

80105c8b <vector188>:
.globl vector188
vector188:
  pushl $0
80105c8b:	6a 00                	push   $0x0
  pushl $188
80105c8d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105c92:	e9 54 f3 ff ff       	jmp    80104feb <alltraps>

80105c97 <vector189>:
.globl vector189
vector189:
  pushl $0
80105c97:	6a 00                	push   $0x0
  pushl $189
80105c99:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105c9e:	e9 48 f3 ff ff       	jmp    80104feb <alltraps>

80105ca3 <vector190>:
.globl vector190
vector190:
  pushl $0
80105ca3:	6a 00                	push   $0x0
  pushl $190
80105ca5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105caa:	e9 3c f3 ff ff       	jmp    80104feb <alltraps>

80105caf <vector191>:
.globl vector191
vector191:
  pushl $0
80105caf:	6a 00                	push   $0x0
  pushl $191
80105cb1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105cb6:	e9 30 f3 ff ff       	jmp    80104feb <alltraps>

80105cbb <vector192>:
.globl vector192
vector192:
  pushl $0
80105cbb:	6a 00                	push   $0x0
  pushl $192
80105cbd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105cc2:	e9 24 f3 ff ff       	jmp    80104feb <alltraps>

80105cc7 <vector193>:
.globl vector193
vector193:
  pushl $0
80105cc7:	6a 00                	push   $0x0
  pushl $193
80105cc9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105cce:	e9 18 f3 ff ff       	jmp    80104feb <alltraps>

80105cd3 <vector194>:
.globl vector194
vector194:
  pushl $0
80105cd3:	6a 00                	push   $0x0
  pushl $194
80105cd5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105cda:	e9 0c f3 ff ff       	jmp    80104feb <alltraps>

80105cdf <vector195>:
.globl vector195
vector195:
  pushl $0
80105cdf:	6a 00                	push   $0x0
  pushl $195
80105ce1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105ce6:	e9 00 f3 ff ff       	jmp    80104feb <alltraps>

80105ceb <vector196>:
.globl vector196
vector196:
  pushl $0
80105ceb:	6a 00                	push   $0x0
  pushl $196
80105ced:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105cf2:	e9 f4 f2 ff ff       	jmp    80104feb <alltraps>

80105cf7 <vector197>:
.globl vector197
vector197:
  pushl $0
80105cf7:	6a 00                	push   $0x0
  pushl $197
80105cf9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105cfe:	e9 e8 f2 ff ff       	jmp    80104feb <alltraps>

80105d03 <vector198>:
.globl vector198
vector198:
  pushl $0
80105d03:	6a 00                	push   $0x0
  pushl $198
80105d05:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105d0a:	e9 dc f2 ff ff       	jmp    80104feb <alltraps>

80105d0f <vector199>:
.globl vector199
vector199:
  pushl $0
80105d0f:	6a 00                	push   $0x0
  pushl $199
80105d11:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105d16:	e9 d0 f2 ff ff       	jmp    80104feb <alltraps>

80105d1b <vector200>:
.globl vector200
vector200:
  pushl $0
80105d1b:	6a 00                	push   $0x0
  pushl $200
80105d1d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105d22:	e9 c4 f2 ff ff       	jmp    80104feb <alltraps>

80105d27 <vector201>:
.globl vector201
vector201:
  pushl $0
80105d27:	6a 00                	push   $0x0
  pushl $201
80105d29:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105d2e:	e9 b8 f2 ff ff       	jmp    80104feb <alltraps>

80105d33 <vector202>:
.globl vector202
vector202:
  pushl $0
80105d33:	6a 00                	push   $0x0
  pushl $202
80105d35:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105d3a:	e9 ac f2 ff ff       	jmp    80104feb <alltraps>

80105d3f <vector203>:
.globl vector203
vector203:
  pushl $0
80105d3f:	6a 00                	push   $0x0
  pushl $203
80105d41:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105d46:	e9 a0 f2 ff ff       	jmp    80104feb <alltraps>

80105d4b <vector204>:
.globl vector204
vector204:
  pushl $0
80105d4b:	6a 00                	push   $0x0
  pushl $204
80105d4d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105d52:	e9 94 f2 ff ff       	jmp    80104feb <alltraps>

80105d57 <vector205>:
.globl vector205
vector205:
  pushl $0
80105d57:	6a 00                	push   $0x0
  pushl $205
80105d59:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105d5e:	e9 88 f2 ff ff       	jmp    80104feb <alltraps>

80105d63 <vector206>:
.globl vector206
vector206:
  pushl $0
80105d63:	6a 00                	push   $0x0
  pushl $206
80105d65:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105d6a:	e9 7c f2 ff ff       	jmp    80104feb <alltraps>

80105d6f <vector207>:
.globl vector207
vector207:
  pushl $0
80105d6f:	6a 00                	push   $0x0
  pushl $207
80105d71:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105d76:	e9 70 f2 ff ff       	jmp    80104feb <alltraps>

80105d7b <vector208>:
.globl vector208
vector208:
  pushl $0
80105d7b:	6a 00                	push   $0x0
  pushl $208
80105d7d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105d82:	e9 64 f2 ff ff       	jmp    80104feb <alltraps>

80105d87 <vector209>:
.globl vector209
vector209:
  pushl $0
80105d87:	6a 00                	push   $0x0
  pushl $209
80105d89:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105d8e:	e9 58 f2 ff ff       	jmp    80104feb <alltraps>

80105d93 <vector210>:
.globl vector210
vector210:
  pushl $0
80105d93:	6a 00                	push   $0x0
  pushl $210
80105d95:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105d9a:	e9 4c f2 ff ff       	jmp    80104feb <alltraps>

80105d9f <vector211>:
.globl vector211
vector211:
  pushl $0
80105d9f:	6a 00                	push   $0x0
  pushl $211
80105da1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105da6:	e9 40 f2 ff ff       	jmp    80104feb <alltraps>

80105dab <vector212>:
.globl vector212
vector212:
  pushl $0
80105dab:	6a 00                	push   $0x0
  pushl $212
80105dad:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105db2:	e9 34 f2 ff ff       	jmp    80104feb <alltraps>

80105db7 <vector213>:
.globl vector213
vector213:
  pushl $0
80105db7:	6a 00                	push   $0x0
  pushl $213
80105db9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105dbe:	e9 28 f2 ff ff       	jmp    80104feb <alltraps>

80105dc3 <vector214>:
.globl vector214
vector214:
  pushl $0
80105dc3:	6a 00                	push   $0x0
  pushl $214
80105dc5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105dca:	e9 1c f2 ff ff       	jmp    80104feb <alltraps>

80105dcf <vector215>:
.globl vector215
vector215:
  pushl $0
80105dcf:	6a 00                	push   $0x0
  pushl $215
80105dd1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105dd6:	e9 10 f2 ff ff       	jmp    80104feb <alltraps>

80105ddb <vector216>:
.globl vector216
vector216:
  pushl $0
80105ddb:	6a 00                	push   $0x0
  pushl $216
80105ddd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105de2:	e9 04 f2 ff ff       	jmp    80104feb <alltraps>

80105de7 <vector217>:
.globl vector217
vector217:
  pushl $0
80105de7:	6a 00                	push   $0x0
  pushl $217
80105de9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105dee:	e9 f8 f1 ff ff       	jmp    80104feb <alltraps>

80105df3 <vector218>:
.globl vector218
vector218:
  pushl $0
80105df3:	6a 00                	push   $0x0
  pushl $218
80105df5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105dfa:	e9 ec f1 ff ff       	jmp    80104feb <alltraps>

80105dff <vector219>:
.globl vector219
vector219:
  pushl $0
80105dff:	6a 00                	push   $0x0
  pushl $219
80105e01:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105e06:	e9 e0 f1 ff ff       	jmp    80104feb <alltraps>

80105e0b <vector220>:
.globl vector220
vector220:
  pushl $0
80105e0b:	6a 00                	push   $0x0
  pushl $220
80105e0d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105e12:	e9 d4 f1 ff ff       	jmp    80104feb <alltraps>

80105e17 <vector221>:
.globl vector221
vector221:
  pushl $0
80105e17:	6a 00                	push   $0x0
  pushl $221
80105e19:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105e1e:	e9 c8 f1 ff ff       	jmp    80104feb <alltraps>

80105e23 <vector222>:
.globl vector222
vector222:
  pushl $0
80105e23:	6a 00                	push   $0x0
  pushl $222
80105e25:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105e2a:	e9 bc f1 ff ff       	jmp    80104feb <alltraps>

80105e2f <vector223>:
.globl vector223
vector223:
  pushl $0
80105e2f:	6a 00                	push   $0x0
  pushl $223
80105e31:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105e36:	e9 b0 f1 ff ff       	jmp    80104feb <alltraps>

80105e3b <vector224>:
.globl vector224
vector224:
  pushl $0
80105e3b:	6a 00                	push   $0x0
  pushl $224
80105e3d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105e42:	e9 a4 f1 ff ff       	jmp    80104feb <alltraps>

80105e47 <vector225>:
.globl vector225
vector225:
  pushl $0
80105e47:	6a 00                	push   $0x0
  pushl $225
80105e49:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105e4e:	e9 98 f1 ff ff       	jmp    80104feb <alltraps>

80105e53 <vector226>:
.globl vector226
vector226:
  pushl $0
80105e53:	6a 00                	push   $0x0
  pushl $226
80105e55:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105e5a:	e9 8c f1 ff ff       	jmp    80104feb <alltraps>

80105e5f <vector227>:
.globl vector227
vector227:
  pushl $0
80105e5f:	6a 00                	push   $0x0
  pushl $227
80105e61:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105e66:	e9 80 f1 ff ff       	jmp    80104feb <alltraps>

80105e6b <vector228>:
.globl vector228
vector228:
  pushl $0
80105e6b:	6a 00                	push   $0x0
  pushl $228
80105e6d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105e72:	e9 74 f1 ff ff       	jmp    80104feb <alltraps>

80105e77 <vector229>:
.globl vector229
vector229:
  pushl $0
80105e77:	6a 00                	push   $0x0
  pushl $229
80105e79:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105e7e:	e9 68 f1 ff ff       	jmp    80104feb <alltraps>

80105e83 <vector230>:
.globl vector230
vector230:
  pushl $0
80105e83:	6a 00                	push   $0x0
  pushl $230
80105e85:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105e8a:	e9 5c f1 ff ff       	jmp    80104feb <alltraps>

80105e8f <vector231>:
.globl vector231
vector231:
  pushl $0
80105e8f:	6a 00                	push   $0x0
  pushl $231
80105e91:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105e96:	e9 50 f1 ff ff       	jmp    80104feb <alltraps>

80105e9b <vector232>:
.globl vector232
vector232:
  pushl $0
80105e9b:	6a 00                	push   $0x0
  pushl $232
80105e9d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105ea2:	e9 44 f1 ff ff       	jmp    80104feb <alltraps>

80105ea7 <vector233>:
.globl vector233
vector233:
  pushl $0
80105ea7:	6a 00                	push   $0x0
  pushl $233
80105ea9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105eae:	e9 38 f1 ff ff       	jmp    80104feb <alltraps>

80105eb3 <vector234>:
.globl vector234
vector234:
  pushl $0
80105eb3:	6a 00                	push   $0x0
  pushl $234
80105eb5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105eba:	e9 2c f1 ff ff       	jmp    80104feb <alltraps>

80105ebf <vector235>:
.globl vector235
vector235:
  pushl $0
80105ebf:	6a 00                	push   $0x0
  pushl $235
80105ec1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105ec6:	e9 20 f1 ff ff       	jmp    80104feb <alltraps>

80105ecb <vector236>:
.globl vector236
vector236:
  pushl $0
80105ecb:	6a 00                	push   $0x0
  pushl $236
80105ecd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105ed2:	e9 14 f1 ff ff       	jmp    80104feb <alltraps>

80105ed7 <vector237>:
.globl vector237
vector237:
  pushl $0
80105ed7:	6a 00                	push   $0x0
  pushl $237
80105ed9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105ede:	e9 08 f1 ff ff       	jmp    80104feb <alltraps>

80105ee3 <vector238>:
.globl vector238
vector238:
  pushl $0
80105ee3:	6a 00                	push   $0x0
  pushl $238
80105ee5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105eea:	e9 fc f0 ff ff       	jmp    80104feb <alltraps>

80105eef <vector239>:
.globl vector239
vector239:
  pushl $0
80105eef:	6a 00                	push   $0x0
  pushl $239
80105ef1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105ef6:	e9 f0 f0 ff ff       	jmp    80104feb <alltraps>

80105efb <vector240>:
.globl vector240
vector240:
  pushl $0
80105efb:	6a 00                	push   $0x0
  pushl $240
80105efd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105f02:	e9 e4 f0 ff ff       	jmp    80104feb <alltraps>

80105f07 <vector241>:
.globl vector241
vector241:
  pushl $0
80105f07:	6a 00                	push   $0x0
  pushl $241
80105f09:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105f0e:	e9 d8 f0 ff ff       	jmp    80104feb <alltraps>

80105f13 <vector242>:
.globl vector242
vector242:
  pushl $0
80105f13:	6a 00                	push   $0x0
  pushl $242
80105f15:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105f1a:	e9 cc f0 ff ff       	jmp    80104feb <alltraps>

80105f1f <vector243>:
.globl vector243
vector243:
  pushl $0
80105f1f:	6a 00                	push   $0x0
  pushl $243
80105f21:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105f26:	e9 c0 f0 ff ff       	jmp    80104feb <alltraps>

80105f2b <vector244>:
.globl vector244
vector244:
  pushl $0
80105f2b:	6a 00                	push   $0x0
  pushl $244
80105f2d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105f32:	e9 b4 f0 ff ff       	jmp    80104feb <alltraps>

80105f37 <vector245>:
.globl vector245
vector245:
  pushl $0
80105f37:	6a 00                	push   $0x0
  pushl $245
80105f39:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105f3e:	e9 a8 f0 ff ff       	jmp    80104feb <alltraps>

80105f43 <vector246>:
.globl vector246
vector246:
  pushl $0
80105f43:	6a 00                	push   $0x0
  pushl $246
80105f45:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105f4a:	e9 9c f0 ff ff       	jmp    80104feb <alltraps>

80105f4f <vector247>:
.globl vector247
vector247:
  pushl $0
80105f4f:	6a 00                	push   $0x0
  pushl $247
80105f51:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105f56:	e9 90 f0 ff ff       	jmp    80104feb <alltraps>

80105f5b <vector248>:
.globl vector248
vector248:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $248
80105f5d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105f62:	e9 84 f0 ff ff       	jmp    80104feb <alltraps>

80105f67 <vector249>:
.globl vector249
vector249:
  pushl $0
80105f67:	6a 00                	push   $0x0
  pushl $249
80105f69:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105f6e:	e9 78 f0 ff ff       	jmp    80104feb <alltraps>

80105f73 <vector250>:
.globl vector250
vector250:
  pushl $0
80105f73:	6a 00                	push   $0x0
  pushl $250
80105f75:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105f7a:	e9 6c f0 ff ff       	jmp    80104feb <alltraps>

80105f7f <vector251>:
.globl vector251
vector251:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $251
80105f81:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105f86:	e9 60 f0 ff ff       	jmp    80104feb <alltraps>

80105f8b <vector252>:
.globl vector252
vector252:
  pushl $0
80105f8b:	6a 00                	push   $0x0
  pushl $252
80105f8d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105f92:	e9 54 f0 ff ff       	jmp    80104feb <alltraps>

80105f97 <vector253>:
.globl vector253
vector253:
  pushl $0
80105f97:	6a 00                	push   $0x0
  pushl $253
80105f99:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105f9e:	e9 48 f0 ff ff       	jmp    80104feb <alltraps>

80105fa3 <vector254>:
.globl vector254
vector254:
  pushl $0
80105fa3:	6a 00                	push   $0x0
  pushl $254
80105fa5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105faa:	e9 3c f0 ff ff       	jmp    80104feb <alltraps>

80105faf <vector255>:
.globl vector255
vector255:
  pushl $0
80105faf:	6a 00                	push   $0x0
  pushl $255
80105fb1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105fb6:	e9 30 f0 ff ff       	jmp    80104feb <alltraps>

80105fbb <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105fbb:	55                   	push   %ebp
80105fbc:	89 e5                	mov    %esp,%ebp
80105fbe:	57                   	push   %edi
80105fbf:	56                   	push   %esi
80105fc0:	53                   	push   %ebx
80105fc1:	83 ec 0c             	sub    $0xc,%esp
80105fc4:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105fc6:	c1 ea 16             	shr    $0x16,%edx
80105fc9:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if (*pde & PTE_P)
80105fcc:	8b 37                	mov    (%edi),%esi
80105fce:	f7 c6 01 00 00 00    	test   $0x1,%esi
80105fd4:	74 20                	je     80105ff6 <walkpgdir+0x3b>
  {
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde));
80105fd6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105fdc:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105fe2:	c1 eb 0c             	shr    $0xc,%ebx
80105fe5:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80105feb:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
80105fee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ff1:	5b                   	pop    %ebx
80105ff2:	5e                   	pop    %esi
80105ff3:	5f                   	pop    %edi
80105ff4:	5d                   	pop    %ebp
80105ff5:	c3                   	ret
    if (!alloc || (pgtab = (pte_t *)kalloc()) == 0)
80105ff6:	85 c9                	test   %ecx,%ecx
80105ff8:	74 2b                	je     80106025 <walkpgdir+0x6a>
80105ffa:	e8 a8 c0 ff ff       	call   801020a7 <kalloc>
80105fff:	89 c6                	mov    %eax,%esi
80106001:	85 c0                	test   %eax,%eax
80106003:	74 20                	je     80106025 <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
80106005:	83 ec 04             	sub    $0x4,%esp
80106008:	68 00 10 00 00       	push   $0x1000
8010600d:	6a 00                	push   $0x0
8010600f:	50                   	push   %eax
80106010:	e8 1d de ff ff       	call   80103e32 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106015:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010601b:	83 c8 07             	or     $0x7,%eax
8010601e:	89 07                	mov    %eax,(%edi)
80106020:	83 c4 10             	add    $0x10,%esp
80106023:	eb bd                	jmp    80105fe2 <walkpgdir+0x27>
      return 0;
80106025:	b8 00 00 00 00       	mov    $0x0,%eax
8010602a:	eb c2                	jmp    80105fee <walkpgdir+0x33>

8010602c <seginit>:
{
8010602c:	55                   	push   %ebp
8010602d:	89 e5                	mov    %esp,%ebp
8010602f:	57                   	push   %edi
80106030:	56                   	push   %esi
80106031:	53                   	push   %ebx
80106032:	83 ec 2c             	sub    $0x2c,%esp
  c = &cpus[cpuid()];
80106035:	e8 1e d2 ff ff       	call   80103258 <cpuid>
8010603a:	89 c3                	mov    %eax,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010603c:	8d 14 80             	lea    (%eax,%eax,4),%edx
8010603f:	8d 0c 12             	lea    (%edx,%edx,1),%ecx
80106042:	8d 04 01             	lea    (%ecx,%eax,1),%eax
80106045:	c1 e0 04             	shl    $0x4,%eax
80106048:	66 c7 80 18 18 11 80 	movw   $0xffff,-0x7feee7e8(%eax)
8010604f:	ff ff 
80106051:	66 c7 80 1a 18 11 80 	movw   $0x0,-0x7feee7e6(%eax)
80106058:	00 00 
8010605a:	c6 80 1c 18 11 80 00 	movb   $0x0,-0x7feee7e4(%eax)
80106061:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80106064:	01 d9                	add    %ebx,%ecx
80106066:	c1 e1 04             	shl    $0x4,%ecx
80106069:	0f b6 b1 1d 18 11 80 	movzbl -0x7feee7e3(%ecx),%esi
80106070:	83 e6 f0             	and    $0xfffffff0,%esi
80106073:	89 f7                	mov    %esi,%edi
80106075:	83 cf 0a             	or     $0xa,%edi
80106078:	89 fa                	mov    %edi,%edx
8010607a:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80106080:	83 ce 1a             	or     $0x1a,%esi
80106083:	89 f2                	mov    %esi,%edx
80106085:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
8010608b:	83 e6 9f             	and    $0xffffff9f,%esi
8010608e:	89 f2                	mov    %esi,%edx
80106090:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80106096:	83 ce 80             	or     $0xffffff80,%esi
80106099:	89 f2                	mov    %esi,%edx
8010609b:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
801060a1:	0f b6 b1 1e 18 11 80 	movzbl -0x7feee7e2(%ecx),%esi
801060a8:	83 ce 0f             	or     $0xf,%esi
801060ab:	89 f2                	mov    %esi,%edx
801060ad:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
801060b3:	89 f7                	mov    %esi,%edi
801060b5:	83 e7 ef             	and    $0xffffffef,%edi
801060b8:	89 fa                	mov    %edi,%edx
801060ba:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
801060c0:	83 e6 cf             	and    $0xffffffcf,%esi
801060c3:	89 f2                	mov    %esi,%edx
801060c5:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
801060cb:	89 f7                	mov    %esi,%edi
801060cd:	83 cf 40             	or     $0x40,%edi
801060d0:	89 fa                	mov    %edi,%edx
801060d2:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
801060d8:	83 ce c0             	or     $0xffffffc0,%esi
801060db:	89 f2                	mov    %esi,%edx
801060dd:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
801060e3:	c6 80 1f 18 11 80 00 	movb   $0x0,-0x7feee7e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801060ea:	66 c7 80 20 18 11 80 	movw   $0xffff,-0x7feee7e0(%eax)
801060f1:	ff ff 
801060f3:	66 c7 80 22 18 11 80 	movw   $0x0,-0x7feee7de(%eax)
801060fa:	00 00 
801060fc:	c6 80 24 18 11 80 00 	movb   $0x0,-0x7feee7dc(%eax)
80106103:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80106106:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80106109:	c1 e1 04             	shl    $0x4,%ecx
8010610c:	0f b6 b1 25 18 11 80 	movzbl -0x7feee7db(%ecx),%esi
80106113:	83 e6 f0             	and    $0xfffffff0,%esi
80106116:	89 f7                	mov    %esi,%edi
80106118:	83 cf 02             	or     $0x2,%edi
8010611b:	89 fa                	mov    %edi,%edx
8010611d:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80106123:	83 ce 12             	or     $0x12,%esi
80106126:	89 f2                	mov    %esi,%edx
80106128:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
8010612e:	83 e6 9f             	and    $0xffffff9f,%esi
80106131:	89 f2                	mov    %esi,%edx
80106133:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80106139:	83 ce 80             	or     $0xffffff80,%esi
8010613c:	89 f2                	mov    %esi,%edx
8010613e:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80106144:	0f b6 b1 26 18 11 80 	movzbl -0x7feee7da(%ecx),%esi
8010614b:	83 ce 0f             	or     $0xf,%esi
8010614e:	89 f2                	mov    %esi,%edx
80106150:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80106156:	89 f7                	mov    %esi,%edi
80106158:	83 e7 ef             	and    $0xffffffef,%edi
8010615b:	89 fa                	mov    %edi,%edx
8010615d:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80106163:	83 e6 cf             	and    $0xffffffcf,%esi
80106166:	89 f2                	mov    %esi,%edx
80106168:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
8010616e:	89 f7                	mov    %esi,%edi
80106170:	83 cf 40             	or     $0x40,%edi
80106173:	89 fa                	mov    %edi,%edx
80106175:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
8010617b:	83 ce c0             	or     $0xffffffc0,%esi
8010617e:	89 f2                	mov    %esi,%edx
80106180:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80106186:	c6 80 27 18 11 80 00 	movb   $0x0,-0x7feee7d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
8010618d:	66 c7 80 28 18 11 80 	movw   $0xffff,-0x7feee7d8(%eax)
80106194:	ff ff 
80106196:	66 c7 80 2a 18 11 80 	movw   $0x0,-0x7feee7d6(%eax)
8010619d:	00 00 
8010619f:	c6 80 2c 18 11 80 00 	movb   $0x0,-0x7feee7d4(%eax)
801061a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801061a9:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
801061ac:	c1 e1 04             	shl    $0x4,%ecx
801061af:	0f b6 b1 2d 18 11 80 	movzbl -0x7feee7d3(%ecx),%esi
801061b6:	83 e6 f0             	and    $0xfffffff0,%esi
801061b9:	89 f7                	mov    %esi,%edi
801061bb:	83 cf 0a             	or     $0xa,%edi
801061be:	89 fa                	mov    %edi,%edx
801061c0:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
801061c6:	89 f7                	mov    %esi,%edi
801061c8:	83 cf 1a             	or     $0x1a,%edi
801061cb:	89 fa                	mov    %edi,%edx
801061cd:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
801061d3:	83 ce 7a             	or     $0x7a,%esi
801061d6:	89 f2                	mov    %esi,%edx
801061d8:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
801061de:	c6 81 2d 18 11 80 fa 	movb   $0xfa,-0x7feee7d3(%ecx)
801061e5:	0f b6 b1 2e 18 11 80 	movzbl -0x7feee7d2(%ecx),%esi
801061ec:	83 ce 0f             	or     $0xf,%esi
801061ef:	89 f2                	mov    %esi,%edx
801061f1:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
801061f7:	89 f7                	mov    %esi,%edi
801061f9:	83 e7 ef             	and    $0xffffffef,%edi
801061fc:	89 fa                	mov    %edi,%edx
801061fe:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80106204:	83 e6 cf             	and    $0xffffffcf,%esi
80106207:	89 f2                	mov    %esi,%edx
80106209:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
8010620f:	89 f7                	mov    %esi,%edi
80106211:	83 cf 40             	or     $0x40,%edi
80106214:	89 fa                	mov    %edi,%edx
80106216:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
8010621c:	83 ce c0             	or     $0xffffffc0,%esi
8010621f:	89 f2                	mov    %esi,%edx
80106221:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80106227:	c6 80 2f 18 11 80 00 	movb   $0x0,-0x7feee7d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010622e:	66 c7 80 30 18 11 80 	movw   $0xffff,-0x7feee7d0(%eax)
80106235:	ff ff 
80106237:	66 c7 80 32 18 11 80 	movw   $0x0,-0x7feee7ce(%eax)
8010623e:	00 00 
80106240:	c6 80 34 18 11 80 00 	movb   $0x0,-0x7feee7cc(%eax)
80106247:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010624a:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
8010624d:	c1 e1 04             	shl    $0x4,%ecx
80106250:	0f b6 b1 35 18 11 80 	movzbl -0x7feee7cb(%ecx),%esi
80106257:	83 e6 f0             	and    $0xfffffff0,%esi
8010625a:	89 f7                	mov    %esi,%edi
8010625c:	83 cf 02             	or     $0x2,%edi
8010625f:	89 fa                	mov    %edi,%edx
80106261:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
80106267:	89 f7                	mov    %esi,%edi
80106269:	83 cf 12             	or     $0x12,%edi
8010626c:	89 fa                	mov    %edi,%edx
8010626e:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
80106274:	83 ce 72             	or     $0x72,%esi
80106277:	89 f2                	mov    %esi,%edx
80106279:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
8010627f:	c6 81 35 18 11 80 f2 	movb   $0xf2,-0x7feee7cb(%ecx)
80106286:	0f b6 b1 36 18 11 80 	movzbl -0x7feee7ca(%ecx),%esi
8010628d:	83 ce 0f             	or     $0xf,%esi
80106290:	89 f2                	mov    %esi,%edx
80106292:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
80106298:	89 f7                	mov    %esi,%edi
8010629a:	83 e7 ef             	and    $0xffffffef,%edi
8010629d:	89 fa                	mov    %edi,%edx
8010629f:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801062a5:	83 e6 cf             	and    $0xffffffcf,%esi
801062a8:	89 f2                	mov    %esi,%edx
801062aa:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801062b0:	89 f7                	mov    %esi,%edi
801062b2:	83 cf 40             	or     $0x40,%edi
801062b5:	89 fa                	mov    %edi,%edx
801062b7:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801062bd:	83 ce c0             	or     $0xffffffc0,%esi
801062c0:	89 f2                	mov    %esi,%edx
801062c2:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801062c8:	c6 80 37 18 11 80 00 	movb   $0x0,-0x7feee7c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801062cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801062d2:	01 da                	add    %ebx,%edx
801062d4:	c1 e2 04             	shl    $0x4,%edx
801062d7:	81 c2 10 18 11 80    	add    $0x80111810,%edx
  pd[0] = size-1;
801062dd:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
801062e3:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
801062e7:	c1 ea 10             	shr    $0x10,%edx
801062ea:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801062ee:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801062f1:	0f 01 10             	lgdtl  (%eax)
}
801062f4:	83 c4 2c             	add    $0x2c,%esp
801062f7:	5b                   	pop    %ebx
801062f8:	5e                   	pop    %esi
801062f9:	5f                   	pop    %edi
801062fa:	5d                   	pop    %ebp
801062fb:	c3                   	ret

801062fc <mappages>:

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801062fc:	55                   	push   %ebp
801062fd:	89 e5                	mov    %esp,%ebp
801062ff:	57                   	push   %edi
80106300:	56                   	push   %esi
80106301:	53                   	push   %ebx
80106302:	83 ec 0c             	sub    $0xc,%esp
80106305:	8b 45 0c             	mov    0xc(%ebp),%eax
80106308:	8b 75 14             	mov    0x14(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char *)PGROUNDDOWN((uint)va);
8010630b:	89 c3                	mov    %eax,%ebx
8010630d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
80106313:	03 45 10             	add    0x10(%ebp),%eax
80106316:	48                   	dec    %eax
80106317:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010631c:	89 c7                	mov    %eax,%edi
  for (;;)
  {
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
8010631e:	b9 01 00 00 00       	mov    $0x1,%ecx
80106323:	89 da                	mov    %ebx,%edx
80106325:	8b 45 08             	mov    0x8(%ebp),%eax
80106328:	e8 8e fc ff ff       	call   80105fbb <walkpgdir>
8010632d:	85 c0                	test   %eax,%eax
8010632f:	74 2e                	je     8010635f <mappages+0x63>
      return -1;
    if (*pte & PTE_P)
80106331:	f6 00 01             	testb  $0x1,(%eax)
80106334:	75 1c                	jne    80106352 <mappages+0x56>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106336:	89 f2                	mov    %esi,%edx
80106338:	0b 55 18             	or     0x18(%ebp),%edx
8010633b:	83 ca 01             	or     $0x1,%edx
8010633e:	89 10                	mov    %edx,(%eax)
    if (a == last)
80106340:	39 fb                	cmp    %edi,%ebx
80106342:	74 28                	je     8010636c <mappages+0x70>
      break;
    a += PGSIZE;
80106344:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
8010634a:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
80106350:	eb cc                	jmp    8010631e <mappages+0x22>
      panic("remap");
80106352:	83 ec 0c             	sub    $0xc,%esp
80106355:	68 38 6e 10 80       	push   $0x80106e38
8010635a:	e8 e5 9f ff ff       	call   80100344 <panic>
      return -1;
8010635f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106364:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106367:	5b                   	pop    %ebx
80106368:	5e                   	pop    %esi
80106369:	5f                   	pop    %edi
8010636a:	5d                   	pop    %ebp
8010636b:	c3                   	ret
  return 0;
8010636c:	b8 00 00 00 00       	mov    $0x0,%eax
80106371:	eb f1                	jmp    80106364 <mappages+0x68>

80106373 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void switchkvm(void)
{
  lcr3(V2P(kpgdir)); // switch to the kernel page table
80106373:	a1 24 48 11 80       	mov    0x80114824,%eax
80106378:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010637d:	0f 22 d8             	mov    %eax,%cr3
}
80106380:	c3                   	ret

80106381 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void switchuvm(struct proc *p)
{
80106381:	55                   	push   %ebp
80106382:	89 e5                	mov    %esp,%ebp
80106384:	57                   	push   %edi
80106385:	56                   	push   %esi
80106386:	53                   	push   %ebx
80106387:	83 ec 1c             	sub    $0x1c,%esp
8010638a:	8b 75 08             	mov    0x8(%ebp),%esi
  if (p == 0)
8010638d:	85 f6                	test   %esi,%esi
8010638f:	0f 84 21 01 00 00    	je     801064b6 <switchuvm+0x135>
    panic("switchuvm: no process");
  if (p->kstack == 0)
80106395:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80106399:	0f 84 24 01 00 00    	je     801064c3 <switchuvm+0x142>
    panic("switchuvm: no kstack");
  if (p->pgdir == 0)
8010639f:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
801063a3:	0f 84 27 01 00 00    	je     801064d0 <switchuvm+0x14f>
    panic("switchuvm: no pgdir");

  pushcli();
801063a9:	e8 f5 d8 ff ff       	call   80103ca3 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801063ae:	e8 41 ce ff ff       	call   801031f4 <mycpu>
801063b3:	89 c3                	mov    %eax,%ebx
801063b5:	e8 3a ce ff ff       	call   801031f4 <mycpu>
801063ba:	8d 78 08             	lea    0x8(%eax),%edi
801063bd:	e8 32 ce ff ff       	call   801031f4 <mycpu>
801063c2:	83 c0 08             	add    $0x8,%eax
801063c5:	c1 e8 10             	shr    $0x10,%eax
801063c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801063cb:	e8 24 ce ff ff       	call   801031f4 <mycpu>
801063d0:	83 c0 08             	add    $0x8,%eax
801063d3:	c1 e8 18             	shr    $0x18,%eax
801063d6:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801063dd:	67 00 
801063df:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801063e6:	8a 4d e4             	mov    -0x1c(%ebp),%cl
801063e9:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801063ef:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
801063f5:	83 e2 f0             	and    $0xfffffff0,%edx
801063f8:	88 d1                	mov    %dl,%cl
801063fa:	83 c9 09             	or     $0x9,%ecx
801063fd:	88 8b 9d 00 00 00    	mov    %cl,0x9d(%ebx)
80106403:	83 ca 19             	or     $0x19,%edx
80106406:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
8010640c:	83 e2 9f             	and    $0xffffff9f,%edx
8010640f:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106415:	83 ca 80             	or     $0xffffff80,%edx
80106418:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
8010641e:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80106424:	88 d1                	mov    %dl,%cl
80106426:	83 e1 f0             	and    $0xfffffff0,%ecx
80106429:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
8010642f:	88 d1                	mov    %dl,%cl
80106431:	83 e1 e0             	and    $0xffffffe0,%ecx
80106434:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
8010643a:	83 e2 c0             	and    $0xffffffc0,%edx
8010643d:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106443:	83 ca 40             	or     $0x40,%edx
80106446:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010644c:	83 e2 7f             	and    $0x7f,%edx
8010644f:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106455:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts) - 1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010645b:	e8 94 cd ff ff       	call   801031f4 <mycpu>
80106460:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80106466:	83 e2 ef             	and    $0xffffffef,%edx
80106469:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010646f:	e8 80 cd ff ff       	call   801031f4 <mycpu>
80106474:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010647a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010647d:	e8 72 cd ff ff       	call   801031f4 <mycpu>
80106482:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106488:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort)0xFFFF;
8010648b:	e8 64 cd ff ff       	call   801031f4 <mycpu>
80106490:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106496:	b8 28 00 00 00       	mov    $0x28,%eax
8010649b:	0f 00 d8             	ltr    %eax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir)); // switch to process's address space
8010649e:	8b 46 04             	mov    0x4(%esi),%eax
801064a1:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801064a6:	0f 22 d8             	mov    %eax,%cr3
  popcli();
801064a9:	e8 39 d8 ff ff       	call   80103ce7 <popcli>
}
801064ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064b1:	5b                   	pop    %ebx
801064b2:	5e                   	pop    %esi
801064b3:	5f                   	pop    %edi
801064b4:	5d                   	pop    %ebp
801064b5:	c3                   	ret
    panic("switchuvm: no process");
801064b6:	83 ec 0c             	sub    $0xc,%esp
801064b9:	68 3e 6e 10 80       	push   $0x80106e3e
801064be:	e8 81 9e ff ff       	call   80100344 <panic>
    panic("switchuvm: no kstack");
801064c3:	83 ec 0c             	sub    $0xc,%esp
801064c6:	68 54 6e 10 80       	push   $0x80106e54
801064cb:	e8 74 9e ff ff       	call   80100344 <panic>
    panic("switchuvm: no pgdir");
801064d0:	83 ec 0c             	sub    $0xc,%esp
801064d3:	68 69 6e 10 80       	push   $0x80106e69
801064d8:	e8 67 9e ff ff       	call   80100344 <panic>

801064dd <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void inituvm(pde_t *pgdir, char *init, uint sz)
{
801064dd:	55                   	push   %ebp
801064de:	89 e5                	mov    %esp,%ebp
801064e0:	56                   	push   %esi
801064e1:	53                   	push   %ebx
801064e2:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if (sz >= PGSIZE)
801064e5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801064eb:	77 4b                	ja     80106538 <inituvm+0x5b>
    panic("inituvm: more than a page");
  mem = kalloc();
801064ed:	e8 b5 bb ff ff       	call   801020a7 <kalloc>
801064f2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801064f4:	83 ec 04             	sub    $0x4,%esp
801064f7:	68 00 10 00 00       	push   $0x1000
801064fc:	6a 00                	push   $0x0
801064fe:	50                   	push   %eax
801064ff:	e8 2e d9 ff ff       	call   80103e32 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80106504:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
8010650b:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106511:	50                   	push   %eax
80106512:	68 00 10 00 00       	push   $0x1000
80106517:	6a 00                	push   $0x0
80106519:	ff 75 08             	push   0x8(%ebp)
8010651c:	e8 db fd ff ff       	call   801062fc <mappages>
  memmove(mem, init, sz);
80106521:	83 c4 1c             	add    $0x1c,%esp
80106524:	56                   	push   %esi
80106525:	ff 75 0c             	push   0xc(%ebp)
80106528:	53                   	push   %ebx
80106529:	e8 7a d9 ff ff       	call   80103ea8 <memmove>
}
8010652e:	83 c4 10             	add    $0x10,%esp
80106531:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106534:	5b                   	pop    %ebx
80106535:	5e                   	pop    %esi
80106536:	5d                   	pop    %ebp
80106537:	c3                   	ret
    panic("inituvm: more than a page");
80106538:	83 ec 0c             	sub    $0xc,%esp
8010653b:	68 7d 6e 10 80       	push   $0x80106e7d
80106540:	e8 ff 9d ff ff       	call   80100344 <panic>

80106545 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106545:	55                   	push   %ebp
80106546:	89 e5                	mov    %esp,%ebp
80106548:	57                   	push   %edi
80106549:	56                   	push   %esi
8010654a:	53                   	push   %ebx
8010654b:	83 ec 0c             	sub    $0xc,%esp
8010654e:	8b 7d 18             	mov    0x18(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if ((uint)addr % PGSIZE != 0)
80106551:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80106554:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
8010655a:	74 3c                	je     80106598 <loaduvm+0x53>
    panic("loaduvm: addr must be page aligned");
8010655c:	83 ec 0c             	sub    $0xc,%esp
8010655f:	68 a8 70 10 80       	push   $0x801070a8
80106564:	e8 db 9d ff ff       	call   80100344 <panic>
  for (i = 0; i < sz; i += PGSIZE)
  {
    if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
      panic("loaduvm: address should exist");
80106569:	83 ec 0c             	sub    $0xc,%esp
8010656c:	68 97 6e 10 80       	push   $0x80106e97
80106571:	e8 ce 9d ff ff       	call   80100344 <panic>
    pa = PTE_ADDR(*pte);
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, P2V(pa), offset + i, n) != n)
80106576:	05 00 00 00 80       	add    $0x80000000,%eax
8010657b:	56                   	push   %esi
8010657c:	89 da                	mov    %ebx,%edx
8010657e:	03 55 14             	add    0x14(%ebp),%edx
80106581:	52                   	push   %edx
80106582:	50                   	push   %eax
80106583:	ff 75 10             	push   0x10(%ebp)
80106586:	e8 db b1 ff ff       	call   80101766 <readi>
8010658b:	83 c4 10             	add    $0x10,%esp
8010658e:	39 f0                	cmp    %esi,%eax
80106590:	75 47                	jne    801065d9 <loaduvm+0x94>
  for (i = 0; i < sz; i += PGSIZE)
80106592:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106598:	39 fb                	cmp    %edi,%ebx
8010659a:	73 30                	jae    801065cc <loaduvm+0x87>
    if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
8010659c:	89 da                	mov    %ebx,%edx
8010659e:	03 55 0c             	add    0xc(%ebp),%edx
801065a1:	b9 00 00 00 00       	mov    $0x0,%ecx
801065a6:	8b 45 08             	mov    0x8(%ebp),%eax
801065a9:	e8 0d fa ff ff       	call   80105fbb <walkpgdir>
801065ae:	85 c0                	test   %eax,%eax
801065b0:	74 b7                	je     80106569 <loaduvm+0x24>
    pa = PTE_ADDR(*pte);
801065b2:	8b 00                	mov    (%eax),%eax
801065b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if (sz - i < PGSIZE)
801065b9:	89 fe                	mov    %edi,%esi
801065bb:	29 de                	sub    %ebx,%esi
801065bd:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801065c3:	76 b1                	jbe    80106576 <loaduvm+0x31>
      n = PGSIZE;
801065c5:	be 00 10 00 00       	mov    $0x1000,%esi
801065ca:	eb aa                	jmp    80106576 <loaduvm+0x31>
      return -1;
  }
  return 0;
801065cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065d4:	5b                   	pop    %ebx
801065d5:	5e                   	pop    %esi
801065d6:	5f                   	pop    %edi
801065d7:	5d                   	pop    %ebp
801065d8:	c3                   	ret
      return -1;
801065d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065de:	eb f1                	jmp    801065d1 <loaduvm+0x8c>

801065e0 <deallocuvm>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	57                   	push   %edi
801065e4:	56                   	push   %esi
801065e5:	53                   	push   %ebx
801065e6:	83 ec 0c             	sub    $0xc,%esp
801065e9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if (newsz >= oldsz)
801065ec:	39 7d 10             	cmp    %edi,0x10(%ebp)
801065ef:	73 11                	jae    80106602 <deallocuvm+0x22>
    return oldsz;

  a = PGROUNDUP(newsz);
801065f1:	8b 45 10             	mov    0x10(%ebp),%eax
801065f4:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801065fa:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; a < oldsz; a += PGSIZE)
80106600:	eb 17                	jmp    80106619 <deallocuvm+0x39>
    return oldsz;
80106602:	89 f8                	mov    %edi,%eax
80106604:	eb 55                	jmp    8010665b <deallocuvm+0x7b>
    // Si la página existe en el directorio pero no está presente en la RAM, pasamos
    if ((*pte & PTE_P) != 0)
    {
      pa = PTE_ADDR(*pte);
      if (pa == 0)
        panic("kfree");
80106606:	83 ec 0c             	sub    $0xc,%esp
80106609:	68 cc 6b 10 80       	push   $0x80106bcc
8010660e:	e8 31 9d ff ff       	call   80100344 <panic>
  for (; a < oldsz; a += PGSIZE)
80106613:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106619:	39 fe                	cmp    %edi,%esi
8010661b:	73 3b                	jae    80106658 <deallocuvm+0x78>
    pte = walkpgdir(pgdir, (char *)a, 0);
8010661d:	b9 00 00 00 00       	mov    $0x0,%ecx
80106622:	89 f2                	mov    %esi,%edx
80106624:	8b 45 08             	mov    0x8(%ebp),%eax
80106627:	e8 8f f9 ff ff       	call   80105fbb <walkpgdir>
8010662c:	89 c3                	mov    %eax,%ebx
    if (!pte)
8010662e:	85 c0                	test   %eax,%eax
80106630:	74 e1                	je     80106613 <deallocuvm+0x33>
    if ((*pte & PTE_P) != 0)
80106632:	8b 00                	mov    (%eax),%eax
80106634:	a8 01                	test   $0x1,%al
80106636:	74 db                	je     80106613 <deallocuvm+0x33>
      if (pa == 0)
80106638:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010663d:	74 c7                	je     80106606 <deallocuvm+0x26>
      char *v = P2V(pa);
8010663f:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106644:	83 ec 0c             	sub    $0xc,%esp
80106647:	50                   	push   %eax
80106648:	e8 43 b9 ff ff       	call   80101f90 <kfree>
      *pte = 0;
8010664d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106653:	83 c4 10             	add    $0x10,%esp
80106656:	eb bb                	jmp    80106613 <deallocuvm+0x33>
    }
  }
  return newsz;
80106658:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010665b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010665e:	5b                   	pop    %ebx
8010665f:	5e                   	pop    %esi
80106660:	5f                   	pop    %edi
80106661:	5d                   	pop    %ebp
80106662:	c3                   	ret

80106663 <allocuvm>:
{
80106663:	55                   	push   %ebp
80106664:	89 e5                	mov    %esp,%ebp
80106666:	57                   	push   %edi
80106667:	56                   	push   %esi
80106668:	53                   	push   %ebx
80106669:	83 ec 1c             	sub    $0x1c,%esp
8010666c:	8b 7d 10             	mov    0x10(%ebp),%edi
  if (newsz >= KERNBASE)
8010666f:	85 ff                	test   %edi,%edi
80106671:	0f 88 c3 00 00 00    	js     8010673a <allocuvm+0xd7>
  if (newsz < oldsz)
80106677:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010667a:	72 60                	jb     801066dc <allocuvm+0x79>
  a = PGROUNDUP(oldsz);
8010667c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010667f:	8d b2 ff 0f 00 00    	lea    0xfff(%edx),%esi
80106685:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; a < newsz; a += PGSIZE)
8010668b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010668e:	39 fe                	cmp    %edi,%esi
80106690:	0f 83 9f 00 00 00    	jae    80106735 <allocuvm+0xd2>
    mem = kalloc();
80106696:	e8 0c ba ff ff       	call   801020a7 <kalloc>
8010669b:	89 c3                	mov    %eax,%ebx
    if (mem == 0)
8010669d:	85 c0                	test   %eax,%eax
8010669f:	74 40                	je     801066e1 <allocuvm+0x7e>
    memset(mem, 0, PGSIZE);
801066a1:	83 ec 04             	sub    $0x4,%esp
801066a4:	68 00 10 00 00       	push   $0x1000
801066a9:	6a 00                	push   $0x0
801066ab:	50                   	push   %eax
801066ac:	e8 81 d7 ff ff       	call   80103e32 <memset>
    if (mappages(pgdir, (char *)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
801066b1:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801066b8:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801066be:	50                   	push   %eax
801066bf:	68 00 10 00 00       	push   $0x1000
801066c4:	56                   	push   %esi
801066c5:	ff 75 08             	push   0x8(%ebp)
801066c8:	e8 2f fc ff ff       	call   801062fc <mappages>
801066cd:	83 c4 20             	add    $0x20,%esp
801066d0:	85 c0                	test   %eax,%eax
801066d2:	78 33                	js     80106707 <allocuvm+0xa4>
  for (; a < newsz; a += PGSIZE)
801066d4:	81 c6 00 10 00 00    	add    $0x1000,%esi
801066da:	eb b2                	jmp    8010668e <allocuvm+0x2b>
    return oldsz;
801066dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801066df:	eb 5e                	jmp    8010673f <allocuvm+0xdc>
      cprintf("allocuvm out of memory\n");
801066e1:	83 ec 0c             	sub    $0xc,%esp
801066e4:	68 b5 6e 10 80       	push   $0x80106eb5
801066e9:	e8 f1 9e ff ff       	call   801005df <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801066ee:	83 c4 0c             	add    $0xc,%esp
801066f1:	ff 75 0c             	push   0xc(%ebp)
801066f4:	57                   	push   %edi
801066f5:	ff 75 08             	push   0x8(%ebp)
801066f8:	e8 e3 fe ff ff       	call   801065e0 <deallocuvm>
      return 0;
801066fd:	83 c4 10             	add    $0x10,%esp
80106700:	b8 00 00 00 00       	mov    $0x0,%eax
80106705:	eb 38                	jmp    8010673f <allocuvm+0xdc>
      cprintf("allocuvm out of memory (2)\n");
80106707:	83 ec 0c             	sub    $0xc,%esp
8010670a:	68 cd 6e 10 80       	push   $0x80106ecd
8010670f:	e8 cb 9e ff ff       	call   801005df <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106714:	83 c4 0c             	add    $0xc,%esp
80106717:	ff 75 0c             	push   0xc(%ebp)
8010671a:	57                   	push   %edi
8010671b:	ff 75 08             	push   0x8(%ebp)
8010671e:	e8 bd fe ff ff       	call   801065e0 <deallocuvm>
      kfree(mem);
80106723:	89 1c 24             	mov    %ebx,(%esp)
80106726:	e8 65 b8 ff ff       	call   80101f90 <kfree>
      return 0;
8010672b:	83 c4 10             	add    $0x10,%esp
8010672e:	b8 00 00 00 00       	mov    $0x0,%eax
80106733:	eb 0a                	jmp    8010673f <allocuvm+0xdc>
80106735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106738:	eb 05                	jmp    8010673f <allocuvm+0xdc>
    return 0;
8010673a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010673f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106742:	5b                   	pop    %ebx
80106743:	5e                   	pop    %esi
80106744:	5f                   	pop    %edi
80106745:	5d                   	pop    %ebp
80106746:	c3                   	ret

80106747 <freevm>:

// Free a page table and all the physical memory pages
// in the user part if dodeallocuvm is not zero
void freevm(pde_t *pgdir, int dodeallocuvm)
{
80106747:	55                   	push   %ebp
80106748:	89 e5                	mov    %esp,%ebp
8010674a:	56                   	push   %esi
8010674b:	53                   	push   %ebx
8010674c:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if (pgdir == 0)
8010674f:	85 f6                	test   %esi,%esi
80106751:	74 0d                	je     80106760 <freevm+0x19>
    panic("freevm: no pgdir");
  if (dodeallocuvm)
80106753:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106757:	75 14                	jne    8010676d <freevm+0x26>
{
80106759:	bb 00 00 00 00       	mov    $0x0,%ebx
8010675e:	eb 23                	jmp    80106783 <freevm+0x3c>
    panic("freevm: no pgdir");
80106760:	83 ec 0c             	sub    $0xc,%esp
80106763:	68 e9 6e 10 80       	push   $0x80106ee9
80106768:	e8 d7 9b ff ff       	call   80100344 <panic>
    deallocuvm(pgdir, KERNBASE, 0);
8010676d:	83 ec 04             	sub    $0x4,%esp
80106770:	6a 00                	push   $0x0
80106772:	68 00 00 00 80       	push   $0x80000000
80106777:	56                   	push   %esi
80106778:	e8 63 fe ff ff       	call   801065e0 <deallocuvm>
8010677d:	83 c4 10             	add    $0x10,%esp
80106780:	eb d7                	jmp    80106759 <freevm+0x12>
  for (i = 0; i < NPDENTRIES; i++)
80106782:	43                   	inc    %ebx
80106783:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
80106789:	77 1f                	ja     801067aa <freevm+0x63>
  {
    if (pgdir[i] & PTE_P)
8010678b:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
8010678e:	a8 01                	test   $0x1,%al
80106790:	74 f0                	je     80106782 <freevm+0x3b>
    {
      char *v = P2V(PTE_ADDR(pgdir[i]));
80106792:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106797:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010679c:	83 ec 0c             	sub    $0xc,%esp
8010679f:	50                   	push   %eax
801067a0:	e8 eb b7 ff ff       	call   80101f90 <kfree>
801067a5:	83 c4 10             	add    $0x10,%esp
801067a8:	eb d8                	jmp    80106782 <freevm+0x3b>
    }
  }
  kfree((char *)pgdir);
801067aa:	83 ec 0c             	sub    $0xc,%esp
801067ad:	56                   	push   %esi
801067ae:	e8 dd b7 ff ff       	call   80101f90 <kfree>
}
801067b3:	83 c4 10             	add    $0x10,%esp
801067b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801067b9:	5b                   	pop    %ebx
801067ba:	5e                   	pop    %esi
801067bb:	5d                   	pop    %ebp
801067bc:	c3                   	ret

801067bd <setupkvm>:
{
801067bd:	55                   	push   %ebp
801067be:	89 e5                	mov    %esp,%ebp
801067c0:	56                   	push   %esi
801067c1:	53                   	push   %ebx
  if ((pgdir = (pde_t *)kalloc()) == 0)
801067c2:	e8 e0 b8 ff ff       	call   801020a7 <kalloc>
801067c7:	89 c6                	mov    %eax,%esi
801067c9:	85 c0                	test   %eax,%eax
801067cb:	74 57                	je     80106824 <setupkvm+0x67>
  memset(pgdir, 0, PGSIZE);
801067cd:	83 ec 04             	sub    $0x4,%esp
801067d0:	68 00 10 00 00       	push   $0x1000
801067d5:	6a 00                	push   $0x0
801067d7:	50                   	push   %eax
801067d8:	e8 55 d6 ff ff       	call   80103e32 <memset>
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
801067dd:	83 c4 10             	add    $0x10,%esp
801067e0:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
801067e5:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801067eb:	73 37                	jae    80106824 <setupkvm+0x67>
                 (uint)k->phys_start, k->perm) < 0)
801067ed:	8b 53 04             	mov    0x4(%ebx),%edx
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801067f0:	83 ec 0c             	sub    $0xc,%esp
801067f3:	ff 73 0c             	push   0xc(%ebx)
801067f6:	52                   	push   %edx
801067f7:	8b 43 08             	mov    0x8(%ebx),%eax
801067fa:	29 d0                	sub    %edx,%eax
801067fc:	50                   	push   %eax
801067fd:	ff 33                	push   (%ebx)
801067ff:	56                   	push   %esi
80106800:	e8 f7 fa ff ff       	call   801062fc <mappages>
80106805:	83 c4 20             	add    $0x20,%esp
80106808:	85 c0                	test   %eax,%eax
8010680a:	78 05                	js     80106811 <setupkvm+0x54>
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010680c:	83 c3 10             	add    $0x10,%ebx
8010680f:	eb d4                	jmp    801067e5 <setupkvm+0x28>
      freevm(pgdir, 0);
80106811:	83 ec 08             	sub    $0x8,%esp
80106814:	6a 00                	push   $0x0
80106816:	56                   	push   %esi
80106817:	e8 2b ff ff ff       	call   80106747 <freevm>
      return 0;
8010681c:	83 c4 10             	add    $0x10,%esp
8010681f:	be 00 00 00 00       	mov    $0x0,%esi
}
80106824:	89 f0                	mov    %esi,%eax
80106826:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106829:	5b                   	pop    %ebx
8010682a:	5e                   	pop    %esi
8010682b:	5d                   	pop    %ebp
8010682c:	c3                   	ret

8010682d <kvmalloc>:
{
8010682d:	55                   	push   %ebp
8010682e:	89 e5                	mov    %esp,%ebp
80106830:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106833:	e8 85 ff ff ff       	call   801067bd <setupkvm>
80106838:	a3 24 48 11 80       	mov    %eax,0x80114824
  switchkvm();
8010683d:	e8 31 fb ff ff       	call   80106373 <switchkvm>
}
80106842:	c9                   	leave
80106843:	c3                   	ret

80106844 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void clearpteu(pde_t *pgdir, char *uva)
{
80106844:	55                   	push   %ebp
80106845:	89 e5                	mov    %esp,%ebp
80106847:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010684a:	b9 00 00 00 00       	mov    $0x0,%ecx
8010684f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106852:	8b 45 08             	mov    0x8(%ebp),%eax
80106855:	e8 61 f7 ff ff       	call   80105fbb <walkpgdir>
  if (pte == 0)
8010685a:	85 c0                	test   %eax,%eax
8010685c:	74 09                	je     80106867 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010685e:	8b 10                	mov    (%eax),%edx
80106860:	83 e2 fb             	and    $0xfffffffb,%edx
80106863:	89 10                	mov    %edx,(%eax)
}
80106865:	c9                   	leave
80106866:	c3                   	ret
    panic("clearpteu");
80106867:	83 ec 0c             	sub    $0xc,%esp
8010686a:	68 fa 6e 10 80       	push   $0x80106efa
8010686f:	e8 d0 9a ff ff       	call   80100344 <panic>

80106874 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *
copyuvm(pde_t *pgdir, uint sz)
{
80106874:	55                   	push   %ebp
80106875:	89 e5                	mov    %esp,%ebp
80106877:	57                   	push   %edi
80106878:	56                   	push   %esi
80106879:	53                   	push   %ebx
8010687a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if ((d = setupkvm()) == 0)
8010687d:	e8 3b ff ff ff       	call   801067bd <setupkvm>
80106882:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106885:	85 c0                	test   %eax,%eax
80106887:	0f 84 b4 00 00 00    	je     80106941 <copyuvm+0xcd>
    return 0;
  for (i = 0; i < sz; i += PGSIZE)
8010688d:	be 00 00 00 00       	mov    $0x0,%esi
80106892:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80106895:	eb 06                	jmp    8010689d <copyuvm+0x29>
80106897:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010689d:	39 de                	cmp    %ebx,%esi
8010689f:	0f 83 9c 00 00 00    	jae    80106941 <copyuvm+0xcd>
  {
    if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0)
801068a5:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801068a8:	b9 00 00 00 00       	mov    $0x0,%ecx
801068ad:	89 f2                	mov    %esi,%edx
801068af:	8b 45 08             	mov    0x8(%ebp),%eax
801068b2:	e8 04 f7 ff ff       	call   80105fbb <walkpgdir>
801068b7:	85 c0                	test   %eax,%eax
801068b9:	74 dc                	je     80106897 <copyuvm+0x23>
      continue;
    if (!(*pte & PTE_P))
801068bb:	8b 00                	mov    (%eax),%eax
801068bd:	a8 01                	test   $0x1,%al
801068bf:	74 d6                	je     80106897 <copyuvm+0x23>
      continue;
    pa = PTE_ADDR(*pte);
801068c1:	89 c2                	mov    %eax,%edx
801068c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801068c9:	89 55 e0             	mov    %edx,-0x20(%ebp)
    flags = PTE_FLAGS(*pte);
801068cc:	25 ff 0f 00 00       	and    $0xfff,%eax
801068d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if ((mem = kalloc()) == 0)
801068d4:	e8 ce b7 ff ff       	call   801020a7 <kalloc>
801068d9:	89 c7                	mov    %eax,%edi
801068db:	85 c0                	test   %eax,%eax
801068dd:	74 4b                	je     8010692a <copyuvm+0xb6>
      goto bad;
    memmove(mem, (char *)P2V(pa), PGSIZE);
801068df:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068e2:	05 00 00 00 80       	add    $0x80000000,%eax
801068e7:	83 ec 04             	sub    $0x4,%esp
801068ea:	68 00 10 00 00       	push   $0x1000
801068ef:	50                   	push   %eax
801068f0:	57                   	push   %edi
801068f1:	e8 b2 d5 ff ff       	call   80103ea8 <memmove>
    if (mappages(d, (void *)i, PGSIZE, V2P(mem), flags) < 0)
801068f6:	83 c4 04             	add    $0x4,%esp
801068f9:	ff 75 dc             	push   -0x24(%ebp)
801068fc:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80106902:	50                   	push   %eax
80106903:	68 00 10 00 00       	push   $0x1000
80106908:	ff 75 e4             	push   -0x1c(%ebp)
8010690b:	ff 75 d8             	push   -0x28(%ebp)
8010690e:	e8 e9 f9 ff ff       	call   801062fc <mappages>
80106913:	83 c4 20             	add    $0x20,%esp
80106916:	85 c0                	test   %eax,%eax
80106918:	0f 89 79 ff ff ff    	jns    80106897 <copyuvm+0x23>
    {
      kfree(mem);
8010691e:	83 ec 0c             	sub    $0xc,%esp
80106921:	57                   	push   %edi
80106922:	e8 69 b6 ff ff       	call   80101f90 <kfree>
      goto bad;
80106927:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d, 1);
8010692a:	83 ec 08             	sub    $0x8,%esp
8010692d:	6a 01                	push   $0x1
8010692f:	ff 75 d8             	push   -0x28(%ebp)
80106932:	e8 10 fe ff ff       	call   80106747 <freevm>
  return 0;
80106937:	83 c4 10             	add    $0x10,%esp
8010693a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
}
80106941:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106944:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106947:	5b                   	pop    %ebx
80106948:	5e                   	pop    %esi
80106949:	5f                   	pop    %edi
8010694a:	5d                   	pop    %ebp
8010694b:	c3                   	ret

8010694c <uva2ka>:

// PAGEBREAK!
//  Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva)
{
8010694c:	55                   	push   %ebp
8010694d:	89 e5                	mov    %esp,%ebp
8010694f:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106952:	b9 00 00 00 00       	mov    $0x0,%ecx
80106957:	8b 55 0c             	mov    0xc(%ebp),%edx
8010695a:	8b 45 08             	mov    0x8(%ebp),%eax
8010695d:	e8 59 f6 ff ff       	call   80105fbb <walkpgdir>
  if ((*pte & PTE_P) == 0)
80106962:	8b 00                	mov    (%eax),%eax
80106964:	a8 01                	test   $0x1,%al
80106966:	74 10                	je     80106978 <uva2ka+0x2c>
    return 0;
  if ((*pte & PTE_U) == 0)
80106968:	a8 04                	test   $0x4,%al
8010696a:	74 13                	je     8010697f <uva2ka+0x33>
    return 0;
  return (char *)P2V(PTE_ADDR(*pte));
8010696c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106971:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106976:	c9                   	leave
80106977:	c3                   	ret
    return 0;
80106978:	b8 00 00 00 00       	mov    $0x0,%eax
8010697d:	eb f7                	jmp    80106976 <uva2ka+0x2a>
    return 0;
8010697f:	b8 00 00 00 00       	mov    $0x0,%eax
80106984:	eb f0                	jmp    80106976 <uva2ka+0x2a>

80106986 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106986:	55                   	push   %ebp
80106987:	89 e5                	mov    %esp,%ebp
80106989:	57                   	push   %edi
8010698a:	56                   	push   %esi
8010698b:	53                   	push   %ebx
8010698c:	83 ec 0c             	sub    $0xc,%esp
8010698f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *buf, *pa0;
  uint n, va0;

  buf = (char *)p;
  while (len > 0)
80106992:	eb 20                	jmp    801069b4 <copyout+0x2e>
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if (n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106994:	29 fe                	sub    %edi,%esi
80106996:	01 f0                	add    %esi,%eax
80106998:	83 ec 04             	sub    $0x4,%esp
8010699b:	53                   	push   %ebx
8010699c:	ff 75 10             	push   0x10(%ebp)
8010699f:	50                   	push   %eax
801069a0:	e8 03 d5 ff ff       	call   80103ea8 <memmove>
    len -= n;
801069a5:	29 5d 14             	sub    %ebx,0x14(%ebp)
    buf += n;
801069a8:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801069ab:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
801069b1:	83 c4 10             	add    $0x10,%esp
  while (len > 0)
801069b4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801069b8:	74 2f                	je     801069e9 <copyout+0x63>
    va0 = (uint)PGROUNDDOWN(va);
801069ba:	89 f7                	mov    %esi,%edi
801069bc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char *)va0);
801069c2:	83 ec 08             	sub    $0x8,%esp
801069c5:	57                   	push   %edi
801069c6:	ff 75 08             	push   0x8(%ebp)
801069c9:	e8 7e ff ff ff       	call   8010694c <uva2ka>
    if (pa0 == 0)
801069ce:	83 c4 10             	add    $0x10,%esp
801069d1:	85 c0                	test   %eax,%eax
801069d3:	74 21                	je     801069f6 <copyout+0x70>
    n = PGSIZE - (va - va0);
801069d5:	89 fb                	mov    %edi,%ebx
801069d7:	29 f3                	sub    %esi,%ebx
801069d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if (n > len)
801069df:	39 5d 14             	cmp    %ebx,0x14(%ebp)
801069e2:	73 b0                	jae    80106994 <copyout+0xe>
      n = len;
801069e4:	8b 5d 14             	mov    0x14(%ebp),%ebx
801069e7:	eb ab                	jmp    80106994 <copyout+0xe>
  }
  return 0;
801069e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069f1:	5b                   	pop    %ebx
801069f2:	5e                   	pop    %esi
801069f3:	5f                   	pop    %edi
801069f4:	5d                   	pop    %ebp
801069f5:	c3                   	ret
      return -1;
801069f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069fb:	eb f1                	jmp    801069ee <copyout+0x68>
