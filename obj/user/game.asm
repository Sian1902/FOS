
obj/user/game:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 79 00 00 00       	call   8000af <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
	
void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int i=28;
  80003e:	c7 45 f4 1c 00 00 00 	movl   $0x1c,-0xc(%ebp)
	for(;i<128; i++)
  800045:	eb 5f                	jmp    8000a6 <_main+0x6e>
	{
		int c=0;
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(;c<10; c++)
  80004e:	eb 16                	jmp    800066 <_main+0x2e>
		{
			cprintf("%c",i);
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	ff 75 f4             	pushl  -0xc(%ebp)
  800056:	68 c0 1b 80 00       	push   $0x801bc0
  80005b:	e8 68 02 00 00       	call   8002c8 <cprintf>
  800060:	83 c4 10             	add    $0x10,%esp
{	
	int i=28;
	for(;i<128; i++)
	{
		int c=0;
		for(;c<10; c++)
  800063:	ff 45 f0             	incl   -0x10(%ebp)
  800066:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  80006a:	7e e4                	jle    800050 <_main+0x18>
		{
			cprintf("%c",i);
		}
		int d=0;
  80006c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(; d< 500000; d++);	
  800073:	eb 03                	jmp    800078 <_main+0x40>
  800075:	ff 45 ec             	incl   -0x14(%ebp)
  800078:	81 7d ec 1f a1 07 00 	cmpl   $0x7a11f,-0x14(%ebp)
  80007f:	7e f4                	jle    800075 <_main+0x3d>
		c=0;
  800081:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(;c<10; c++)
  800088:	eb 13                	jmp    80009d <_main+0x65>
		{
			cprintf("\b");
  80008a:	83 ec 0c             	sub    $0xc,%esp
  80008d:	68 c3 1b 80 00       	push   $0x801bc3
  800092:	e8 31 02 00 00       	call   8002c8 <cprintf>
  800097:	83 c4 10             	add    $0x10,%esp
			cprintf("%c",i);
		}
		int d=0;
		for(; d< 500000; d++);	
		c=0;
		for(;c<10; c++)
  80009a:	ff 45 f0             	incl   -0x10(%ebp)
  80009d:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  8000a1:	7e e7                	jle    80008a <_main+0x52>
	
void
_main(void)
{	
	int i=28;
	for(;i<128; i++)
  8000a3:	ff 45 f4             	incl   -0xc(%ebp)
  8000a6:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  8000aa:	7e 9b                	jle    800047 <_main+0xf>
		{
			cprintf("\b");
		}		
	}
	
	return;	
  8000ac:	90                   	nop
}
  8000ad:	c9                   	leave  
  8000ae:	c3                   	ret    

008000af <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000b5:	e8 77 13 00 00       	call   801431 <sys_getenvindex>
  8000ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c0:	89 d0                	mov    %edx,%eax
  8000c2:	01 c0                	add    %eax,%eax
  8000c4:	01 d0                	add    %edx,%eax
  8000c6:	01 c0                	add    %eax,%eax
  8000c8:	01 d0                	add    %edx,%eax
  8000ca:	c1 e0 02             	shl    $0x2,%eax
  8000cd:	01 d0                	add    %edx,%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	01 d0                	add    %edx,%eax
  8000d3:	c1 e0 02             	shl    $0x2,%eax
  8000d6:	01 d0                	add    %edx,%eax
  8000d8:	c1 e0 02             	shl    $0x2,%eax
  8000db:	01 d0                	add    %edx,%eax
  8000dd:	c1 e0 02             	shl    $0x2,%eax
  8000e0:	01 d0                	add    %edx,%eax
  8000e2:	c1 e0 05             	shl    $0x5,%eax
  8000e5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ea:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f4:	8a 40 5c             	mov    0x5c(%eax),%al
  8000f7:	84 c0                	test   %al,%al
  8000f9:	74 0d                	je     800108 <libmain+0x59>
		binaryname = myEnv->prog_name;
  8000fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800100:	83 c0 5c             	add    $0x5c,%eax
  800103:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800108:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80010c:	7e 0a                	jle    800118 <libmain+0x69>
		binaryname = argv[0];
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	8b 00                	mov    (%eax),%eax
  800113:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	ff 75 0c             	pushl  0xc(%ebp)
  80011e:	ff 75 08             	pushl  0x8(%ebp)
  800121:	e8 12 ff ff ff       	call   800038 <_main>
  800126:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800129:	e8 10 11 00 00       	call   80123e <sys_disable_interrupt>
	cprintf("**************************************\n");
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	68 e0 1b 80 00       	push   $0x801be0
  800136:	e8 8d 01 00 00       	call   8002c8 <cprintf>
  80013b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80013e:	a1 20 30 80 00       	mov    0x803020,%eax
  800143:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  800149:	a1 20 30 80 00       	mov    0x803020,%eax
  80014e:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	52                   	push   %edx
  800158:	50                   	push   %eax
  800159:	68 08 1c 80 00       	push   $0x801c08
  80015e:	e8 65 01 00 00       	call   8002c8 <cprintf>
  800163:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800166:	a1 20 30 80 00       	mov    0x803020,%eax
  80016b:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  800171:	a1 20 30 80 00       	mov    0x803020,%eax
  800176:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  80017c:	a1 20 30 80 00       	mov    0x803020,%eax
  800181:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  800187:	51                   	push   %ecx
  800188:	52                   	push   %edx
  800189:	50                   	push   %eax
  80018a:	68 30 1c 80 00       	push   $0x801c30
  80018f:	e8 34 01 00 00       	call   8002c8 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800197:	a1 20 30 80 00       	mov    0x803020,%eax
  80019c:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	68 88 1c 80 00       	push   $0x801c88
  8001ab:	e8 18 01 00 00       	call   8002c8 <cprintf>
  8001b0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 e0 1b 80 00       	push   $0x801be0
  8001bb:	e8 08 01 00 00       	call   8002c8 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001c3:	e8 90 10 00 00       	call   801258 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001c8:	e8 19 00 00 00       	call   8001e6 <exit>
}
  8001cd:	90                   	nop
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    

008001d0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	6a 00                	push   $0x0
  8001db:	e8 1d 12 00 00       	call   8013fd <sys_destroy_env>
  8001e0:	83 c4 10             	add    $0x10,%esp
}
  8001e3:	90                   	nop
  8001e4:	c9                   	leave  
  8001e5:	c3                   	ret    

008001e6 <exit>:

void
exit(void)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001ec:	e8 72 12 00 00       	call   801463 <sys_exit_env>
}
  8001f1:	90                   	nop
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001fd:	8b 00                	mov    (%eax),%eax
  8001ff:	8d 48 01             	lea    0x1(%eax),%ecx
  800202:	8b 55 0c             	mov    0xc(%ebp),%edx
  800205:	89 0a                	mov    %ecx,(%edx)
  800207:	8b 55 08             	mov    0x8(%ebp),%edx
  80020a:	88 d1                	mov    %dl,%cl
  80020c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80020f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800213:	8b 45 0c             	mov    0xc(%ebp),%eax
  800216:	8b 00                	mov    (%eax),%eax
  800218:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021d:	75 2c                	jne    80024b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80021f:	a0 24 30 80 00       	mov    0x803024,%al
  800224:	0f b6 c0             	movzbl %al,%eax
  800227:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022a:	8b 12                	mov    (%edx),%edx
  80022c:	89 d1                	mov    %edx,%ecx
  80022e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800231:	83 c2 08             	add    $0x8,%edx
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	50                   	push   %eax
  800238:	51                   	push   %ecx
  800239:	52                   	push   %edx
  80023a:	e8 a6 0e 00 00       	call   8010e5 <sys_cputs>
  80023f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800242:	8b 45 0c             	mov    0xc(%ebp),%eax
  800245:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80024b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024e:	8b 40 04             	mov    0x4(%eax),%eax
  800251:	8d 50 01             	lea    0x1(%eax),%edx
  800254:	8b 45 0c             	mov    0xc(%ebp),%eax
  800257:	89 50 04             	mov    %edx,0x4(%eax)
}
  80025a:	90                   	nop
  80025b:	c9                   	leave  
  80025c:	c3                   	ret    

0080025d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80025d:	55                   	push   %ebp
  80025e:	89 e5                	mov    %esp,%ebp
  800260:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800266:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80026d:	00 00 00 
	b.cnt = 0;
  800270:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800277:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80027a:	ff 75 0c             	pushl  0xc(%ebp)
  80027d:	ff 75 08             	pushl  0x8(%ebp)
  800280:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800286:	50                   	push   %eax
  800287:	68 f4 01 80 00       	push   $0x8001f4
  80028c:	e8 11 02 00 00       	call   8004a2 <vprintfmt>
  800291:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800294:	a0 24 30 80 00       	mov    0x803024,%al
  800299:	0f b6 c0             	movzbl %al,%eax
  80029c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002a2:	83 ec 04             	sub    $0x4,%esp
  8002a5:	50                   	push   %eax
  8002a6:	52                   	push   %edx
  8002a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ad:	83 c0 08             	add    $0x8,%eax
  8002b0:	50                   	push   %eax
  8002b1:	e8 2f 0e 00 00       	call   8010e5 <sys_cputs>
  8002b6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002b9:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002c0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002ce:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8002d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002db:	8b 45 08             	mov    0x8(%ebp),%eax
  8002de:	83 ec 08             	sub    $0x8,%esp
  8002e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e4:	50                   	push   %eax
  8002e5:	e8 73 ff ff ff       	call   80025d <vcprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
  8002ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002fb:	e8 3e 0f 00 00       	call   80123e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800300:	8d 45 0c             	lea    0xc(%ebp),%eax
  800303:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800306:	8b 45 08             	mov    0x8(%ebp),%eax
  800309:	83 ec 08             	sub    $0x8,%esp
  80030c:	ff 75 f4             	pushl  -0xc(%ebp)
  80030f:	50                   	push   %eax
  800310:	e8 48 ff ff ff       	call   80025d <vcprintf>
  800315:	83 c4 10             	add    $0x10,%esp
  800318:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80031b:	e8 38 0f 00 00       	call   801258 <sys_enable_interrupt>
	return cnt;
  800320:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	53                   	push   %ebx
  800329:	83 ec 14             	sub    $0x14,%esp
  80032c:	8b 45 10             	mov    0x10(%ebp),%eax
  80032f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800332:	8b 45 14             	mov    0x14(%ebp),%eax
  800335:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800338:	8b 45 18             	mov    0x18(%ebp),%eax
  80033b:	ba 00 00 00 00       	mov    $0x0,%edx
  800340:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800343:	77 55                	ja     80039a <printnum+0x75>
  800345:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800348:	72 05                	jb     80034f <printnum+0x2a>
  80034a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80034d:	77 4b                	ja     80039a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80034f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800352:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800355:	8b 45 18             	mov    0x18(%ebp),%eax
  800358:	ba 00 00 00 00       	mov    $0x0,%edx
  80035d:	52                   	push   %edx
  80035e:	50                   	push   %eax
  80035f:	ff 75 f4             	pushl  -0xc(%ebp)
  800362:	ff 75 f0             	pushl  -0x10(%ebp)
  800365:	e8 d6 15 00 00       	call   801940 <__udivdi3>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	83 ec 04             	sub    $0x4,%esp
  800370:	ff 75 20             	pushl  0x20(%ebp)
  800373:	53                   	push   %ebx
  800374:	ff 75 18             	pushl  0x18(%ebp)
  800377:	52                   	push   %edx
  800378:	50                   	push   %eax
  800379:	ff 75 0c             	pushl  0xc(%ebp)
  80037c:	ff 75 08             	pushl  0x8(%ebp)
  80037f:	e8 a1 ff ff ff       	call   800325 <printnum>
  800384:	83 c4 20             	add    $0x20,%esp
  800387:	eb 1a                	jmp    8003a3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	ff 75 0c             	pushl  0xc(%ebp)
  80038f:	ff 75 20             	pushl  0x20(%ebp)
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	ff d0                	call   *%eax
  800397:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80039a:	ff 4d 1c             	decl   0x1c(%ebp)
  80039d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003a1:	7f e6                	jg     800389 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003a3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003b1:	53                   	push   %ebx
  8003b2:	51                   	push   %ecx
  8003b3:	52                   	push   %edx
  8003b4:	50                   	push   %eax
  8003b5:	e8 96 16 00 00       	call   801a50 <__umoddi3>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	05 b4 1e 80 00       	add    $0x801eb4,%eax
  8003c2:	8a 00                	mov    (%eax),%al
  8003c4:	0f be c0             	movsbl %al,%eax
  8003c7:	83 ec 08             	sub    $0x8,%esp
  8003ca:	ff 75 0c             	pushl  0xc(%ebp)
  8003cd:	50                   	push   %eax
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	ff d0                	call   *%eax
  8003d3:	83 c4 10             	add    $0x10,%esp
}
  8003d6:	90                   	nop
  8003d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003da:	c9                   	leave  
  8003db:	c3                   	ret    

008003dc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003df:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003e3:	7e 1c                	jle    800401 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e8:	8b 00                	mov    (%eax),%eax
  8003ea:	8d 50 08             	lea    0x8(%eax),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	89 10                	mov    %edx,(%eax)
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	8b 00                	mov    (%eax),%eax
  8003f7:	83 e8 08             	sub    $0x8,%eax
  8003fa:	8b 50 04             	mov    0x4(%eax),%edx
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	eb 40                	jmp    800441 <getuint+0x65>
	else if (lflag)
  800401:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800405:	74 1e                	je     800425 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800407:	8b 45 08             	mov    0x8(%ebp),%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	8d 50 04             	lea    0x4(%eax),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	89 10                	mov    %edx,(%eax)
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	8b 00                	mov    (%eax),%eax
  800419:	83 e8 04             	sub    $0x4,%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	ba 00 00 00 00       	mov    $0x0,%edx
  800423:	eb 1c                	jmp    800441 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800425:	8b 45 08             	mov    0x8(%ebp),%eax
  800428:	8b 00                	mov    (%eax),%eax
  80042a:	8d 50 04             	lea    0x4(%eax),%edx
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	89 10                	mov    %edx,(%eax)
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	83 e8 04             	sub    $0x4,%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800441:	5d                   	pop    %ebp
  800442:	c3                   	ret    

00800443 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800446:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80044a:	7e 1c                	jle    800468 <getint+0x25>
		return va_arg(*ap, long long);
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	8b 00                	mov    (%eax),%eax
  800451:	8d 50 08             	lea    0x8(%eax),%edx
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	89 10                	mov    %edx,(%eax)
  800459:	8b 45 08             	mov    0x8(%ebp),%eax
  80045c:	8b 00                	mov    (%eax),%eax
  80045e:	83 e8 08             	sub    $0x8,%eax
  800461:	8b 50 04             	mov    0x4(%eax),%edx
  800464:	8b 00                	mov    (%eax),%eax
  800466:	eb 38                	jmp    8004a0 <getint+0x5d>
	else if (lflag)
  800468:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80046c:	74 1a                	je     800488 <getint+0x45>
		return va_arg(*ap, long);
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	8d 50 04             	lea    0x4(%eax),%edx
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	89 10                	mov    %edx,(%eax)
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	83 e8 04             	sub    $0x4,%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	99                   	cltd   
  800486:	eb 18                	jmp    8004a0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800488:	8b 45 08             	mov    0x8(%ebp),%eax
  80048b:	8b 00                	mov    (%eax),%eax
  80048d:	8d 50 04             	lea    0x4(%eax),%edx
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	89 10                	mov    %edx,(%eax)
  800495:	8b 45 08             	mov    0x8(%ebp),%eax
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	83 e8 04             	sub    $0x4,%eax
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	99                   	cltd   
}
  8004a0:	5d                   	pop    %ebp
  8004a1:	c3                   	ret    

008004a2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004a2:	55                   	push   %ebp
  8004a3:	89 e5                	mov    %esp,%ebp
  8004a5:	56                   	push   %esi
  8004a6:	53                   	push   %ebx
  8004a7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004aa:	eb 17                	jmp    8004c3 <vprintfmt+0x21>
			if (ch == '\0')
  8004ac:	85 db                	test   %ebx,%ebx
  8004ae:	0f 84 af 03 00 00    	je     800863 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	ff 75 0c             	pushl  0xc(%ebp)
  8004ba:	53                   	push   %ebx
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	ff d0                	call   *%eax
  8004c0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c6:	8d 50 01             	lea    0x1(%eax),%edx
  8004c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8004cc:	8a 00                	mov    (%eax),%al
  8004ce:	0f b6 d8             	movzbl %al,%ebx
  8004d1:	83 fb 25             	cmp    $0x25,%ebx
  8004d4:	75 d6                	jne    8004ac <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004d6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004da:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004e8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004ef:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f9:	8d 50 01             	lea    0x1(%eax),%edx
  8004fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8004ff:	8a 00                	mov    (%eax),%al
  800501:	0f b6 d8             	movzbl %al,%ebx
  800504:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800507:	83 f8 55             	cmp    $0x55,%eax
  80050a:	0f 87 2b 03 00 00    	ja     80083b <vprintfmt+0x399>
  800510:	8b 04 85 d8 1e 80 00 	mov    0x801ed8(,%eax,4),%eax
  800517:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800519:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80051d:	eb d7                	jmp    8004f6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80051f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800523:	eb d1                	jmp    8004f6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800525:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80052c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052f:	89 d0                	mov    %edx,%eax
  800531:	c1 e0 02             	shl    $0x2,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	01 c0                	add    %eax,%eax
  800538:	01 d8                	add    %ebx,%eax
  80053a:	83 e8 30             	sub    $0x30,%eax
  80053d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800540:	8b 45 10             	mov    0x10(%ebp),%eax
  800543:	8a 00                	mov    (%eax),%al
  800545:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800548:	83 fb 2f             	cmp    $0x2f,%ebx
  80054b:	7e 3e                	jle    80058b <vprintfmt+0xe9>
  80054d:	83 fb 39             	cmp    $0x39,%ebx
  800550:	7f 39                	jg     80058b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800552:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800555:	eb d5                	jmp    80052c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	83 c0 04             	add    $0x4,%eax
  80055d:	89 45 14             	mov    %eax,0x14(%ebp)
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	83 e8 04             	sub    $0x4,%eax
  800566:	8b 00                	mov    (%eax),%eax
  800568:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80056b:	eb 1f                	jmp    80058c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80056d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800571:	79 83                	jns    8004f6 <vprintfmt+0x54>
				width = 0;
  800573:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80057a:	e9 77 ff ff ff       	jmp    8004f6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80057f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800586:	e9 6b ff ff ff       	jmp    8004f6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80058b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80058c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800590:	0f 89 60 ff ff ff    	jns    8004f6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800596:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800599:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80059c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005a3:	e9 4e ff ff ff       	jmp    8004f6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005a8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005ab:	e9 46 ff ff ff       	jmp    8004f6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b3:	83 c0 04             	add    $0x4,%eax
  8005b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	83 e8 04             	sub    $0x4,%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	ff 75 0c             	pushl  0xc(%ebp)
  8005c7:	50                   	push   %eax
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	ff d0                	call   *%eax
  8005cd:	83 c4 10             	add    $0x10,%esp
			break;
  8005d0:	e9 89 02 00 00       	jmp    80085e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	83 c0 04             	add    $0x4,%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	83 e8 04             	sub    $0x4,%eax
  8005e4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005e6:	85 db                	test   %ebx,%ebx
  8005e8:	79 02                	jns    8005ec <vprintfmt+0x14a>
				err = -err;
  8005ea:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005ec:	83 fb 64             	cmp    $0x64,%ebx
  8005ef:	7f 0b                	jg     8005fc <vprintfmt+0x15a>
  8005f1:	8b 34 9d 20 1d 80 00 	mov    0x801d20(,%ebx,4),%esi
  8005f8:	85 f6                	test   %esi,%esi
  8005fa:	75 19                	jne    800615 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005fc:	53                   	push   %ebx
  8005fd:	68 c5 1e 80 00       	push   $0x801ec5
  800602:	ff 75 0c             	pushl  0xc(%ebp)
  800605:	ff 75 08             	pushl  0x8(%ebp)
  800608:	e8 5e 02 00 00       	call   80086b <printfmt>
  80060d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800610:	e9 49 02 00 00       	jmp    80085e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800615:	56                   	push   %esi
  800616:	68 ce 1e 80 00       	push   $0x801ece
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	ff 75 08             	pushl  0x8(%ebp)
  800621:	e8 45 02 00 00       	call   80086b <printfmt>
  800626:	83 c4 10             	add    $0x10,%esp
			break;
  800629:	e9 30 02 00 00       	jmp    80085e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	83 c0 04             	add    $0x4,%eax
  800634:	89 45 14             	mov    %eax,0x14(%ebp)
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	83 e8 04             	sub    $0x4,%eax
  80063d:	8b 30                	mov    (%eax),%esi
  80063f:	85 f6                	test   %esi,%esi
  800641:	75 05                	jne    800648 <vprintfmt+0x1a6>
				p = "(null)";
  800643:	be d1 1e 80 00       	mov    $0x801ed1,%esi
			if (width > 0 && padc != '-')
  800648:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80064c:	7e 6d                	jle    8006bb <vprintfmt+0x219>
  80064e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800652:	74 67                	je     8006bb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800654:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	50                   	push   %eax
  80065b:	56                   	push   %esi
  80065c:	e8 0c 03 00 00       	call   80096d <strnlen>
  800661:	83 c4 10             	add    $0x10,%esp
  800664:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800667:	eb 16                	jmp    80067f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800669:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	ff 75 0c             	pushl  0xc(%ebp)
  800673:	50                   	push   %eax
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	ff d0                	call   *%eax
  800679:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80067c:	ff 4d e4             	decl   -0x1c(%ebp)
  80067f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800683:	7f e4                	jg     800669 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800685:	eb 34                	jmp    8006bb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800687:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80068b:	74 1c                	je     8006a9 <vprintfmt+0x207>
  80068d:	83 fb 1f             	cmp    $0x1f,%ebx
  800690:	7e 05                	jle    800697 <vprintfmt+0x1f5>
  800692:	83 fb 7e             	cmp    $0x7e,%ebx
  800695:	7e 12                	jle    8006a9 <vprintfmt+0x207>
					putch('?', putdat);
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	6a 3f                	push   $0x3f
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	ff d0                	call   *%eax
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	eb 0f                	jmp    8006b8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	ff 75 0c             	pushl  0xc(%ebp)
  8006af:	53                   	push   %ebx
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	ff d0                	call   *%eax
  8006b5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b8:	ff 4d e4             	decl   -0x1c(%ebp)
  8006bb:	89 f0                	mov    %esi,%eax
  8006bd:	8d 70 01             	lea    0x1(%eax),%esi
  8006c0:	8a 00                	mov    (%eax),%al
  8006c2:	0f be d8             	movsbl %al,%ebx
  8006c5:	85 db                	test   %ebx,%ebx
  8006c7:	74 24                	je     8006ed <vprintfmt+0x24b>
  8006c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006cd:	78 b8                	js     800687 <vprintfmt+0x1e5>
  8006cf:	ff 4d e0             	decl   -0x20(%ebp)
  8006d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006d6:	79 af                	jns    800687 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d8:	eb 13                	jmp    8006ed <vprintfmt+0x24b>
				putch(' ', putdat);
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	ff 75 0c             	pushl  0xc(%ebp)
  8006e0:	6a 20                	push   $0x20
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	ff d0                	call   *%eax
  8006e7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f1:	7f e7                	jg     8006da <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006f3:	e9 66 01 00 00       	jmp    80085e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	ff 75 e8             	pushl  -0x18(%ebp)
  8006fe:	8d 45 14             	lea    0x14(%ebp),%eax
  800701:	50                   	push   %eax
  800702:	e8 3c fd ff ff       	call   800443 <getint>
  800707:	83 c4 10             	add    $0x10,%esp
  80070a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80070d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800713:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800716:	85 d2                	test   %edx,%edx
  800718:	79 23                	jns    80073d <vprintfmt+0x29b>
				putch('-', putdat);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	ff 75 0c             	pushl  0xc(%ebp)
  800720:	6a 2d                	push   $0x2d
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	ff d0                	call   *%eax
  800727:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80072a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800730:	f7 d8                	neg    %eax
  800732:	83 d2 00             	adc    $0x0,%edx
  800735:	f7 da                	neg    %edx
  800737:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80073a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80073d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800744:	e9 bc 00 00 00       	jmp    800805 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	ff 75 e8             	pushl  -0x18(%ebp)
  80074f:	8d 45 14             	lea    0x14(%ebp),%eax
  800752:	50                   	push   %eax
  800753:	e8 84 fc ff ff       	call   8003dc <getuint>
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80075e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800761:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800768:	e9 98 00 00 00       	jmp    800805 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	6a 58                	push   $0x58
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	ff d0                	call   *%eax
  80077a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	ff 75 0c             	pushl  0xc(%ebp)
  800783:	6a 58                	push   $0x58
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	ff d0                	call   *%eax
  80078a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	6a 58                	push   $0x58
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	ff d0                	call   *%eax
  80079a:	83 c4 10             	add    $0x10,%esp
			break;
  80079d:	e9 bc 00 00 00       	jmp    80085e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	6a 30                	push   $0x30
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	ff d0                	call   *%eax
  8007af:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	6a 78                	push   $0x78
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	ff d0                	call   *%eax
  8007bf:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007e4:	eb 1f                	jmp    800805 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ef:	50                   	push   %eax
  8007f0:	e8 e7 fb ff ff       	call   8003dc <getuint>
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007fe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800805:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800809:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	52                   	push   %edx
  800810:	ff 75 e4             	pushl  -0x1c(%ebp)
  800813:	50                   	push   %eax
  800814:	ff 75 f4             	pushl  -0xc(%ebp)
  800817:	ff 75 f0             	pushl  -0x10(%ebp)
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	ff 75 08             	pushl  0x8(%ebp)
  800820:	e8 00 fb ff ff       	call   800325 <printnum>
  800825:	83 c4 20             	add    $0x20,%esp
			break;
  800828:	eb 34                	jmp    80085e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	53                   	push   %ebx
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
			break;
  800839:	eb 23                	jmp    80085e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	6a 25                	push   $0x25
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80084b:	ff 4d 10             	decl   0x10(%ebp)
  80084e:	eb 03                	jmp    800853 <vprintfmt+0x3b1>
  800850:	ff 4d 10             	decl   0x10(%ebp)
  800853:	8b 45 10             	mov    0x10(%ebp),%eax
  800856:	48                   	dec    %eax
  800857:	8a 00                	mov    (%eax),%al
  800859:	3c 25                	cmp    $0x25,%al
  80085b:	75 f3                	jne    800850 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80085d:	90                   	nop
		}
	}
  80085e:	e9 47 fc ff ff       	jmp    8004aa <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800863:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800864:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800867:	5b                   	pop    %ebx
  800868:	5e                   	pop    %esi
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800871:	8d 45 10             	lea    0x10(%ebp),%eax
  800874:	83 c0 04             	add    $0x4,%eax
  800877:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80087a:	8b 45 10             	mov    0x10(%ebp),%eax
  80087d:	ff 75 f4             	pushl  -0xc(%ebp)
  800880:	50                   	push   %eax
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	ff 75 08             	pushl  0x8(%ebp)
  800887:	e8 16 fc ff ff       	call   8004a2 <vprintfmt>
  80088c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80088f:	90                   	nop
  800890:	c9                   	leave  
  800891:	c3                   	ret    

00800892 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800895:	8b 45 0c             	mov    0xc(%ebp),%eax
  800898:	8b 40 08             	mov    0x8(%eax),%eax
  80089b:	8d 50 01             	lea    0x1(%eax),%edx
  80089e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a7:	8b 10                	mov    (%eax),%edx
  8008a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ac:	8b 40 04             	mov    0x4(%eax),%eax
  8008af:	39 c2                	cmp    %eax,%edx
  8008b1:	73 12                	jae    8008c5 <sprintputch+0x33>
		*b->buf++ = ch;
  8008b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	8d 48 01             	lea    0x1(%eax),%ecx
  8008bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008be:	89 0a                	mov    %ecx,(%edx)
  8008c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c3:	88 10                	mov    %dl,(%eax)
}
  8008c5:	90                   	nop
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	01 d0                	add    %edx,%eax
  8008df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008ed:	74 06                	je     8008f5 <vsnprintf+0x2d>
  8008ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f3:	7f 07                	jg     8008fc <vsnprintf+0x34>
		return -E_INVAL;
  8008f5:	b8 03 00 00 00       	mov    $0x3,%eax
  8008fa:	eb 20                	jmp    80091c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008fc:	ff 75 14             	pushl  0x14(%ebp)
  8008ff:	ff 75 10             	pushl  0x10(%ebp)
  800902:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800905:	50                   	push   %eax
  800906:	68 92 08 80 00       	push   $0x800892
  80090b:	e8 92 fb ff ff       	call   8004a2 <vprintfmt>
  800910:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800913:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800916:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800919:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80091c:	c9                   	leave  
  80091d:	c3                   	ret    

0080091e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800924:	8d 45 10             	lea    0x10(%ebp),%eax
  800927:	83 c0 04             	add    $0x4,%eax
  80092a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80092d:	8b 45 10             	mov    0x10(%ebp),%eax
  800930:	ff 75 f4             	pushl  -0xc(%ebp)
  800933:	50                   	push   %eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	e8 89 ff ff ff       	call   8008c8 <vsnprintf>
  80093f:	83 c4 10             	add    $0x10,%esp
  800942:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800945:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800948:	c9                   	leave  
  800949:	c3                   	ret    

0080094a <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800950:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800957:	eb 06                	jmp    80095f <strlen+0x15>
		n++;
  800959:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80095c:	ff 45 08             	incl   0x8(%ebp)
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8a 00                	mov    (%eax),%al
  800964:	84 c0                	test   %al,%al
  800966:	75 f1                	jne    800959 <strlen+0xf>
		n++;
	return n;
  800968:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80096b:	c9                   	leave  
  80096c:	c3                   	ret    

0080096d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800973:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80097a:	eb 09                	jmp    800985 <strnlen+0x18>
		n++;
  80097c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097f:	ff 45 08             	incl   0x8(%ebp)
  800982:	ff 4d 0c             	decl   0xc(%ebp)
  800985:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800989:	74 09                	je     800994 <strnlen+0x27>
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8a 00                	mov    (%eax),%al
  800990:	84 c0                	test   %al,%al
  800992:	75 e8                	jne    80097c <strnlen+0xf>
		n++;
	return n;
  800994:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800997:	c9                   	leave  
  800998:	c3                   	ret    

00800999 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009a5:	90                   	nop
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	8d 50 01             	lea    0x1(%eax),%edx
  8009ac:	89 55 08             	mov    %edx,0x8(%ebp)
  8009af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009b5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009b8:	8a 12                	mov    (%edx),%dl
  8009ba:	88 10                	mov    %dl,(%eax)
  8009bc:	8a 00                	mov    (%eax),%al
  8009be:	84 c0                	test   %al,%al
  8009c0:	75 e4                	jne    8009a6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009c5:	c9                   	leave  
  8009c6:	c3                   	ret    

008009c7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009da:	eb 1f                	jmp    8009fb <strncpy+0x34>
		*dst++ = *src;
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	8d 50 01             	lea    0x1(%eax),%edx
  8009e2:	89 55 08             	mov    %edx,0x8(%ebp)
  8009e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e8:	8a 12                	mov    (%edx),%dl
  8009ea:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ef:	8a 00                	mov    (%eax),%al
  8009f1:	84 c0                	test   %al,%al
  8009f3:	74 03                	je     8009f8 <strncpy+0x31>
			src++;
  8009f5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f8:	ff 45 fc             	incl   -0x4(%ebp)
  8009fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009fe:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a01:	72 d9                	jb     8009dc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a03:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a06:	c9                   	leave  
  800a07:	c3                   	ret    

00800a08 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a18:	74 30                	je     800a4a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a1a:	eb 16                	jmp    800a32 <strlcpy+0x2a>
			*dst++ = *src++;
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	8d 50 01             	lea    0x1(%eax),%edx
  800a22:	89 55 08             	mov    %edx,0x8(%ebp)
  800a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a28:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a2b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a2e:	8a 12                	mov    (%edx),%dl
  800a30:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a32:	ff 4d 10             	decl   0x10(%ebp)
  800a35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a39:	74 09                	je     800a44 <strlcpy+0x3c>
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	8a 00                	mov    (%eax),%al
  800a40:	84 c0                	test   %al,%al
  800a42:	75 d8                	jne    800a1c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a50:	29 c2                	sub    %eax,%edx
  800a52:	89 d0                	mov    %edx,%eax
}
  800a54:	c9                   	leave  
  800a55:	c3                   	ret    

00800a56 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a59:	eb 06                	jmp    800a61 <strcmp+0xb>
		p++, q++;
  800a5b:	ff 45 08             	incl   0x8(%ebp)
  800a5e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8a 00                	mov    (%eax),%al
  800a66:	84 c0                	test   %al,%al
  800a68:	74 0e                	je     800a78 <strcmp+0x22>
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	8a 10                	mov    (%eax),%dl
  800a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a72:	8a 00                	mov    (%eax),%al
  800a74:	38 c2                	cmp    %al,%dl
  800a76:	74 e3                	je     800a5b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8a 00                	mov    (%eax),%al
  800a7d:	0f b6 d0             	movzbl %al,%edx
  800a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a83:	8a 00                	mov    (%eax),%al
  800a85:	0f b6 c0             	movzbl %al,%eax
  800a88:	29 c2                	sub    %eax,%edx
  800a8a:	89 d0                	mov    %edx,%eax
}
  800a8c:	5d                   	pop    %ebp
  800a8d:	c3                   	ret    

00800a8e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a91:	eb 09                	jmp    800a9c <strncmp+0xe>
		n--, p++, q++;
  800a93:	ff 4d 10             	decl   0x10(%ebp)
  800a96:	ff 45 08             	incl   0x8(%ebp)
  800a99:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa0:	74 17                	je     800ab9 <strncmp+0x2b>
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8a 00                	mov    (%eax),%al
  800aa7:	84 c0                	test   %al,%al
  800aa9:	74 0e                	je     800ab9 <strncmp+0x2b>
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8a 10                	mov    (%eax),%dl
  800ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab3:	8a 00                	mov    (%eax),%al
  800ab5:	38 c2                	cmp    %al,%dl
  800ab7:	74 da                	je     800a93 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ab9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800abd:	75 07                	jne    800ac6 <strncmp+0x38>
		return 0;
  800abf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac4:	eb 14                	jmp    800ada <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	8a 00                	mov    (%eax),%al
  800acb:	0f b6 d0             	movzbl %al,%edx
  800ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad1:	8a 00                	mov    (%eax),%al
  800ad3:	0f b6 c0             	movzbl %al,%eax
  800ad6:	29 c2                	sub    %eax,%edx
  800ad8:	89 d0                	mov    %edx,%eax
}
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 04             	sub    $0x4,%esp
  800ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ae8:	eb 12                	jmp    800afc <strchr+0x20>
		if (*s == c)
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8a 00                	mov    (%eax),%al
  800aef:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800af2:	75 05                	jne    800af9 <strchr+0x1d>
			return (char *) s;
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	eb 11                	jmp    800b0a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800af9:	ff 45 08             	incl   0x8(%ebp)
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8a 00                	mov    (%eax),%al
  800b01:	84 c0                	test   %al,%al
  800b03:	75 e5                	jne    800aea <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b0a:	c9                   	leave  
  800b0b:	c3                   	ret    

00800b0c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	83 ec 04             	sub    $0x4,%esp
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b18:	eb 0d                	jmp    800b27 <strfind+0x1b>
		if (*s == c)
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8a 00                	mov    (%eax),%al
  800b1f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b22:	74 0e                	je     800b32 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b24:	ff 45 08             	incl   0x8(%ebp)
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8a 00                	mov    (%eax),%al
  800b2c:	84 c0                	test   %al,%al
  800b2e:	75 ea                	jne    800b1a <strfind+0xe>
  800b30:	eb 01                	jmp    800b33 <strfind+0x27>
		if (*s == c)
			break;
  800b32:	90                   	nop
	return (char *) s;
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b36:	c9                   	leave  
  800b37:	c3                   	ret    

00800b38 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b44:	8b 45 10             	mov    0x10(%ebp),%eax
  800b47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b4a:	eb 0e                	jmp    800b5a <memset+0x22>
		*p++ = c;
  800b4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b4f:	8d 50 01             	lea    0x1(%eax),%edx
  800b52:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b58:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b5a:	ff 4d f8             	decl   -0x8(%ebp)
  800b5d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b61:	79 e9                	jns    800b4c <memset+0x14>
		*p++ = c;

	return v;
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b66:	c9                   	leave  
  800b67:	c3                   	ret    

00800b68 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b7a:	eb 16                	jmp    800b92 <memcpy+0x2a>
		*d++ = *s++;
  800b7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b7f:	8d 50 01             	lea    0x1(%eax),%edx
  800b82:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b88:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b8b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b8e:	8a 12                	mov    (%edx),%dl
  800b90:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b92:	8b 45 10             	mov    0x10(%ebp),%eax
  800b95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b98:	89 55 10             	mov    %edx,0x10(%ebp)
  800b9b:	85 c0                	test   %eax,%eax
  800b9d:	75 dd                	jne    800b7c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bbc:	73 50                	jae    800c0e <memmove+0x6a>
  800bbe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc4:	01 d0                	add    %edx,%eax
  800bc6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bc9:	76 43                	jbe    800c0e <memmove+0x6a>
		s += n;
  800bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bce:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bd7:	eb 10                	jmp    800be9 <memmove+0x45>
			*--d = *--s;
  800bd9:	ff 4d f8             	decl   -0x8(%ebp)
  800bdc:	ff 4d fc             	decl   -0x4(%ebp)
  800bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be2:	8a 10                	mov    (%eax),%dl
  800be4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800be9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bec:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bef:	89 55 10             	mov    %edx,0x10(%ebp)
  800bf2:	85 c0                	test   %eax,%eax
  800bf4:	75 e3                	jne    800bd9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf6:	eb 23                	jmp    800c1b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bf8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bfb:	8d 50 01             	lea    0x1(%eax),%edx
  800bfe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c0a:	8a 12                	mov    (%edx),%dl
  800c0c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c14:	89 55 10             	mov    %edx,0x10(%ebp)
  800c17:	85 c0                	test   %eax,%eax
  800c19:	75 dd                	jne    800bf8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c32:	eb 2a                	jmp    800c5e <memcmp+0x3e>
		if (*s1 != *s2)
  800c34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c37:	8a 10                	mov    (%eax),%dl
  800c39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c3c:	8a 00                	mov    (%eax),%al
  800c3e:	38 c2                	cmp    %al,%dl
  800c40:	74 16                	je     800c58 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c45:	8a 00                	mov    (%eax),%al
  800c47:	0f b6 d0             	movzbl %al,%edx
  800c4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	0f b6 c0             	movzbl %al,%eax
  800c52:	29 c2                	sub    %eax,%edx
  800c54:	89 d0                	mov    %edx,%eax
  800c56:	eb 18                	jmp    800c70 <memcmp+0x50>
		s1++, s2++;
  800c58:	ff 45 fc             	incl   -0x4(%ebp)
  800c5b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c61:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c64:	89 55 10             	mov    %edx,0x10(%ebp)
  800c67:	85 c0                	test   %eax,%eax
  800c69:	75 c9                	jne    800c34 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7e:	01 d0                	add    %edx,%eax
  800c80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c83:	eb 15                	jmp    800c9a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	0f b6 d0             	movzbl %al,%edx
  800c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c90:	0f b6 c0             	movzbl %al,%eax
  800c93:	39 c2                	cmp    %eax,%edx
  800c95:	74 0d                	je     800ca4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c97:	ff 45 08             	incl   0x8(%ebp)
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ca0:	72 e3                	jb     800c85 <memfind+0x13>
  800ca2:	eb 01                	jmp    800ca5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ca4:	90                   	nop
	return (void *) s;
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cb7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cbe:	eb 03                	jmp    800cc3 <strtol+0x19>
		s++;
  800cc0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	3c 20                	cmp    $0x20,%al
  800cca:	74 f4                	je     800cc0 <strtol+0x16>
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	3c 09                	cmp    $0x9,%al
  800cd3:	74 eb                	je     800cc0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	3c 2b                	cmp    $0x2b,%al
  800cdc:	75 05                	jne    800ce3 <strtol+0x39>
		s++;
  800cde:	ff 45 08             	incl   0x8(%ebp)
  800ce1:	eb 13                	jmp    800cf6 <strtol+0x4c>
	else if (*s == '-')
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	3c 2d                	cmp    $0x2d,%al
  800cea:	75 0a                	jne    800cf6 <strtol+0x4c>
		s++, neg = 1;
  800cec:	ff 45 08             	incl   0x8(%ebp)
  800cef:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfa:	74 06                	je     800d02 <strtol+0x58>
  800cfc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d00:	75 20                	jne    800d22 <strtol+0x78>
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	3c 30                	cmp    $0x30,%al
  800d09:	75 17                	jne    800d22 <strtol+0x78>
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	40                   	inc    %eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	3c 78                	cmp    $0x78,%al
  800d13:	75 0d                	jne    800d22 <strtol+0x78>
		s += 2, base = 16;
  800d15:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d19:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d20:	eb 28                	jmp    800d4a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d26:	75 15                	jne    800d3d <strtol+0x93>
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	3c 30                	cmp    $0x30,%al
  800d2f:	75 0c                	jne    800d3d <strtol+0x93>
		s++, base = 8;
  800d31:	ff 45 08             	incl   0x8(%ebp)
  800d34:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d3b:	eb 0d                	jmp    800d4a <strtol+0xa0>
	else if (base == 0)
  800d3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d41:	75 07                	jne    800d4a <strtol+0xa0>
		base = 10;
  800d43:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	3c 2f                	cmp    $0x2f,%al
  800d51:	7e 19                	jle    800d6c <strtol+0xc2>
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	3c 39                	cmp    $0x39,%al
  800d5a:	7f 10                	jg     800d6c <strtol+0xc2>
			dig = *s - '0';
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	0f be c0             	movsbl %al,%eax
  800d64:	83 e8 30             	sub    $0x30,%eax
  800d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d6a:	eb 42                	jmp    800dae <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	3c 60                	cmp    $0x60,%al
  800d73:	7e 19                	jle    800d8e <strtol+0xe4>
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	3c 7a                	cmp    $0x7a,%al
  800d7c:	7f 10                	jg     800d8e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	0f be c0             	movsbl %al,%eax
  800d86:	83 e8 57             	sub    $0x57,%eax
  800d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d8c:	eb 20                	jmp    800dae <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	3c 40                	cmp    $0x40,%al
  800d95:	7e 39                	jle    800dd0 <strtol+0x126>
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	3c 5a                	cmp    $0x5a,%al
  800d9e:	7f 30                	jg     800dd0 <strtol+0x126>
			dig = *s - 'A' + 10;
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	0f be c0             	movsbl %al,%eax
  800da8:	83 e8 37             	sub    $0x37,%eax
  800dab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800db4:	7d 19                	jge    800dcf <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800db6:	ff 45 08             	incl   0x8(%ebp)
  800db9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dbc:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dc0:	89 c2                	mov    %eax,%edx
  800dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc5:	01 d0                	add    %edx,%eax
  800dc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dca:	e9 7b ff ff ff       	jmp    800d4a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dcf:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dd0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd4:	74 08                	je     800dde <strtol+0x134>
		*endptr = (char *) s;
  800dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dde:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800de2:	74 07                	je     800deb <strtol+0x141>
  800de4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de7:	f7 d8                	neg    %eax
  800de9:	eb 03                	jmp    800dee <strtol+0x144>
  800deb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <ltostr>:

void
ltostr(long value, char *str)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800df6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dfd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e08:	79 13                	jns    800e1d <ltostr+0x2d>
	{
		neg = 1;
  800e0a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e14:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e17:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e1a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e25:	99                   	cltd   
  800e26:	f7 f9                	idiv   %ecx
  800e28:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2e:	8d 50 01             	lea    0x1(%eax),%edx
  800e31:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e34:	89 c2                	mov    %eax,%edx
  800e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e39:	01 d0                	add    %edx,%eax
  800e3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e3e:	83 c2 30             	add    $0x30,%edx
  800e41:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e46:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e4b:	f7 e9                	imul   %ecx
  800e4d:	c1 fa 02             	sar    $0x2,%edx
  800e50:	89 c8                	mov    %ecx,%eax
  800e52:	c1 f8 1f             	sar    $0x1f,%eax
  800e55:	29 c2                	sub    %eax,%edx
  800e57:	89 d0                	mov    %edx,%eax
  800e59:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e5f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e64:	f7 e9                	imul   %ecx
  800e66:	c1 fa 02             	sar    $0x2,%edx
  800e69:	89 c8                	mov    %ecx,%eax
  800e6b:	c1 f8 1f             	sar    $0x1f,%eax
  800e6e:	29 c2                	sub    %eax,%edx
  800e70:	89 d0                	mov    %edx,%eax
  800e72:	c1 e0 02             	shl    $0x2,%eax
  800e75:	01 d0                	add    %edx,%eax
  800e77:	01 c0                	add    %eax,%eax
  800e79:	29 c1                	sub    %eax,%ecx
  800e7b:	89 ca                	mov    %ecx,%edx
  800e7d:	85 d2                	test   %edx,%edx
  800e7f:	75 9c                	jne    800e1d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8b:	48                   	dec    %eax
  800e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e93:	74 3d                	je     800ed2 <ltostr+0xe2>
		start = 1 ;
  800e95:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e9c:	eb 34                	jmp    800ed2 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea4:	01 d0                	add    %edx,%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800eab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	01 c2                	add    %eax,%edx
  800eb3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	01 c8                	add    %ecx,%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ebf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	01 c2                	add    %eax,%edx
  800ec7:	8a 45 eb             	mov    -0x15(%ebp),%al
  800eca:	88 02                	mov    %al,(%edx)
		start++ ;
  800ecc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ecf:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ed8:	7c c4                	jl     800e9e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800eda:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ee5:	90                   	nop
  800ee6:	c9                   	leave  
  800ee7:	c3                   	ret    

00800ee8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800eee:	ff 75 08             	pushl  0x8(%ebp)
  800ef1:	e8 54 fa ff ff       	call   80094a <strlen>
  800ef6:	83 c4 04             	add    $0x4,%esp
  800ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800efc:	ff 75 0c             	pushl  0xc(%ebp)
  800eff:	e8 46 fa ff ff       	call   80094a <strlen>
  800f04:	83 c4 04             	add    $0x4,%esp
  800f07:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f18:	eb 17                	jmp    800f31 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f20:	01 c2                	add    %eax,%edx
  800f22:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	01 c8                	add    %ecx,%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f2e:	ff 45 fc             	incl   -0x4(%ebp)
  800f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f34:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f37:	7c e1                	jl     800f1a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f39:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f40:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f47:	eb 1f                	jmp    800f68 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4c:	8d 50 01             	lea    0x1(%eax),%edx
  800f4f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	8b 45 10             	mov    0x10(%ebp),%eax
  800f57:	01 c2                	add    %eax,%edx
  800f59:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5f:	01 c8                	add    %ecx,%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f65:	ff 45 f8             	incl   -0x8(%ebp)
  800f68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f6e:	7c d9                	jl     800f49 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f70:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f73:	8b 45 10             	mov    0x10(%ebp),%eax
  800f76:	01 d0                	add    %edx,%eax
  800f78:	c6 00 00             	movb   $0x0,(%eax)
}
  800f7b:	90                   	nop
  800f7c:	c9                   	leave  
  800f7d:	c3                   	ret    

00800f7e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f81:	8b 45 14             	mov    0x14(%ebp),%eax
  800f84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8d:	8b 00                	mov    (%eax),%eax
  800f8f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f96:	8b 45 10             	mov    0x10(%ebp),%eax
  800f99:	01 d0                	add    %edx,%eax
  800f9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fa1:	eb 0c                	jmp    800faf <strsplit+0x31>
			*string++ = 0;
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8d 50 01             	lea    0x1(%eax),%edx
  800fa9:	89 55 08             	mov    %edx,0x8(%ebp)
  800fac:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	84 c0                	test   %al,%al
  800fb6:	74 18                	je     800fd0 <strsplit+0x52>
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	0f be c0             	movsbl %al,%eax
  800fc0:	50                   	push   %eax
  800fc1:	ff 75 0c             	pushl  0xc(%ebp)
  800fc4:	e8 13 fb ff ff       	call   800adc <strchr>
  800fc9:	83 c4 08             	add    $0x8,%esp
  800fcc:	85 c0                	test   %eax,%eax
  800fce:	75 d3                	jne    800fa3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	84 c0                	test   %al,%al
  800fd7:	74 5a                	je     801033 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdc:	8b 00                	mov    (%eax),%eax
  800fde:	83 f8 0f             	cmp    $0xf,%eax
  800fe1:	75 07                	jne    800fea <strsplit+0x6c>
		{
			return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe8:	eb 66                	jmp    801050 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fea:	8b 45 14             	mov    0x14(%ebp),%eax
  800fed:	8b 00                	mov    (%eax),%eax
  800fef:	8d 48 01             	lea    0x1(%eax),%ecx
  800ff2:	8b 55 14             	mov    0x14(%ebp),%edx
  800ff5:	89 0a                	mov    %ecx,(%edx)
  800ff7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  801001:	01 c2                	add    %eax,%edx
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801008:	eb 03                	jmp    80100d <strsplit+0x8f>
			string++;
  80100a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	84 c0                	test   %al,%al
  801014:	74 8b                	je     800fa1 <strsplit+0x23>
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	0f be c0             	movsbl %al,%eax
  80101e:	50                   	push   %eax
  80101f:	ff 75 0c             	pushl  0xc(%ebp)
  801022:	e8 b5 fa ff ff       	call   800adc <strchr>
  801027:	83 c4 08             	add    $0x8,%esp
  80102a:	85 c0                	test   %eax,%eax
  80102c:	74 dc                	je     80100a <strsplit+0x8c>
			string++;
	}
  80102e:	e9 6e ff ff ff       	jmp    800fa1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801033:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801034:	8b 45 14             	mov    0x14(%ebp),%eax
  801037:	8b 00                	mov    (%eax),%eax
  801039:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	01 d0                	add    %edx,%eax
  801045:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80104b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  801058:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80105c:	74 06                	je     801064 <str2lower+0x12>
  80105e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801062:	75 07                	jne    80106b <str2lower+0x19>
		return NULL;
  801064:	b8 00 00 00 00       	mov    $0x0,%eax
  801069:	eb 4d                	jmp    8010b8 <str2lower+0x66>
	}
	char *ref=dst;
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  801071:	eb 33                	jmp    8010a6 <str2lower+0x54>
			if(*src>=65&&*src<=90){
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	3c 40                	cmp    $0x40,%al
  80107a:	7e 1a                	jle    801096 <str2lower+0x44>
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	3c 5a                	cmp    $0x5a,%al
  801083:	7f 11                	jg     801096 <str2lower+0x44>
				*dst=*src+32;
  801085:	8b 45 0c             	mov    0xc(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	83 c0 20             	add    $0x20,%eax
  80108d:	88 c2                	mov    %al,%dl
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	88 10                	mov    %dl,(%eax)
  801094:	eb 0a                	jmp    8010a0 <str2lower+0x4e>
			}
			else{
				*dst=*src;
  801096:	8b 45 0c             	mov    0xc(%ebp),%eax
  801099:	8a 10                	mov    (%eax),%dl
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	88 10                	mov    %dl,(%eax)
			}
			src++;
  8010a0:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  8010a3:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  8010a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a9:	8a 00                	mov    (%eax),%al
  8010ab:	84 c0                	test   %al,%al
  8010ad:	75 c4                	jne    801073 <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  8010b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	57                   	push   %edi
  8010be:	56                   	push   %esi
  8010bf:	53                   	push   %ebx
  8010c0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010cf:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010d2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010d5:	cd 30                	int    $0x30
  8010d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8010da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010dd:	83 c4 10             	add    $0x10,%esp
  8010e0:	5b                   	pop    %ebx
  8010e1:	5e                   	pop    %esi
  8010e2:	5f                   	pop    %edi
  8010e3:	5d                   	pop    %ebp
  8010e4:	c3                   	ret    

008010e5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	83 ec 04             	sub    $0x4,%esp
  8010eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010f1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	6a 00                	push   $0x0
  8010fa:	6a 00                	push   $0x0
  8010fc:	52                   	push   %edx
  8010fd:	ff 75 0c             	pushl  0xc(%ebp)
  801100:	50                   	push   %eax
  801101:	6a 00                	push   $0x0
  801103:	e8 b2 ff ff ff       	call   8010ba <syscall>
  801108:	83 c4 18             	add    $0x18,%esp
}
  80110b:	90                   	nop
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <sys_cgetc>:

int
sys_cgetc(void)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801111:	6a 00                	push   $0x0
  801113:	6a 00                	push   $0x0
  801115:	6a 00                	push   $0x0
  801117:	6a 00                	push   $0x0
  801119:	6a 00                	push   $0x0
  80111b:	6a 01                	push   $0x1
  80111d:	e8 98 ff ff ff       	call   8010ba <syscall>
  801122:	83 c4 18             	add    $0x18,%esp
}
  801125:	c9                   	leave  
  801126:	c3                   	ret    

00801127 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80112a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	6a 00                	push   $0x0
  801132:	6a 00                	push   $0x0
  801134:	6a 00                	push   $0x0
  801136:	52                   	push   %edx
  801137:	50                   	push   %eax
  801138:	6a 05                	push   $0x5
  80113a:	e8 7b ff ff ff       	call   8010ba <syscall>
  80113f:	83 c4 18             	add    $0x18,%esp
}
  801142:	c9                   	leave  
  801143:	c3                   	ret    

00801144 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	56                   	push   %esi
  801148:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801149:	8b 75 18             	mov    0x18(%ebp),%esi
  80114c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80114f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801152:	8b 55 0c             	mov    0xc(%ebp),%edx
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	56                   	push   %esi
  801159:	53                   	push   %ebx
  80115a:	51                   	push   %ecx
  80115b:	52                   	push   %edx
  80115c:	50                   	push   %eax
  80115d:	6a 06                	push   $0x6
  80115f:	e8 56 ff ff ff       	call   8010ba <syscall>
  801164:	83 c4 18             	add    $0x18,%esp
}
  801167:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116a:	5b                   	pop    %ebx
  80116b:	5e                   	pop    %esi
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801171:	8b 55 0c             	mov    0xc(%ebp),%edx
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	6a 00                	push   $0x0
  801179:	6a 00                	push   $0x0
  80117b:	6a 00                	push   $0x0
  80117d:	52                   	push   %edx
  80117e:	50                   	push   %eax
  80117f:	6a 07                	push   $0x7
  801181:	e8 34 ff ff ff       	call   8010ba <syscall>
  801186:	83 c4 18             	add    $0x18,%esp
}
  801189:	c9                   	leave  
  80118a:	c3                   	ret    

0080118b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80118e:	6a 00                	push   $0x0
  801190:	6a 00                	push   $0x0
  801192:	6a 00                	push   $0x0
  801194:	ff 75 0c             	pushl  0xc(%ebp)
  801197:	ff 75 08             	pushl  0x8(%ebp)
  80119a:	6a 08                	push   $0x8
  80119c:	e8 19 ff ff ff       	call   8010ba <syscall>
  8011a1:	83 c4 18             	add    $0x18,%esp
}
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8011a9:	6a 00                	push   $0x0
  8011ab:	6a 00                	push   $0x0
  8011ad:	6a 00                	push   $0x0
  8011af:	6a 00                	push   $0x0
  8011b1:	6a 00                	push   $0x0
  8011b3:	6a 09                	push   $0x9
  8011b5:	e8 00 ff ff ff       	call   8010ba <syscall>
  8011ba:	83 c4 18             	add    $0x18,%esp
}
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011c2:	6a 00                	push   $0x0
  8011c4:	6a 00                	push   $0x0
  8011c6:	6a 00                	push   $0x0
  8011c8:	6a 00                	push   $0x0
  8011ca:	6a 00                	push   $0x0
  8011cc:	6a 0a                	push   $0xa
  8011ce:	e8 e7 fe ff ff       	call   8010ba <syscall>
  8011d3:	83 c4 18             	add    $0x18,%esp
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011db:	6a 00                	push   $0x0
  8011dd:	6a 00                	push   $0x0
  8011df:	6a 00                	push   $0x0
  8011e1:	6a 00                	push   $0x0
  8011e3:	6a 00                	push   $0x0
  8011e5:	6a 0b                	push   $0xb
  8011e7:	e8 ce fe ff ff       	call   8010ba <syscall>
  8011ec:	83 c4 18             	add    $0x18,%esp
}
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011f4:	6a 00                	push   $0x0
  8011f6:	6a 00                	push   $0x0
  8011f8:	6a 00                	push   $0x0
  8011fa:	6a 00                	push   $0x0
  8011fc:	6a 00                	push   $0x0
  8011fe:	6a 0c                	push   $0xc
  801200:	e8 b5 fe ff ff       	call   8010ba <syscall>
  801205:	83 c4 18             	add    $0x18,%esp
}
  801208:	c9                   	leave  
  801209:	c3                   	ret    

0080120a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80120d:	6a 00                	push   $0x0
  80120f:	6a 00                	push   $0x0
  801211:	6a 00                	push   $0x0
  801213:	6a 00                	push   $0x0
  801215:	ff 75 08             	pushl  0x8(%ebp)
  801218:	6a 0d                	push   $0xd
  80121a:	e8 9b fe ff ff       	call   8010ba <syscall>
  80121f:	83 c4 18             	add    $0x18,%esp
}
  801222:	c9                   	leave  
  801223:	c3                   	ret    

00801224 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801227:	6a 00                	push   $0x0
  801229:	6a 00                	push   $0x0
  80122b:	6a 00                	push   $0x0
  80122d:	6a 00                	push   $0x0
  80122f:	6a 00                	push   $0x0
  801231:	6a 0e                	push   $0xe
  801233:	e8 82 fe ff ff       	call   8010ba <syscall>
  801238:	83 c4 18             	add    $0x18,%esp
}
  80123b:	90                   	nop
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801241:	6a 00                	push   $0x0
  801243:	6a 00                	push   $0x0
  801245:	6a 00                	push   $0x0
  801247:	6a 00                	push   $0x0
  801249:	6a 00                	push   $0x0
  80124b:	6a 11                	push   $0x11
  80124d:	e8 68 fe ff ff       	call   8010ba <syscall>
  801252:	83 c4 18             	add    $0x18,%esp
}
  801255:	90                   	nop
  801256:	c9                   	leave  
  801257:	c3                   	ret    

00801258 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80125b:	6a 00                	push   $0x0
  80125d:	6a 00                	push   $0x0
  80125f:	6a 00                	push   $0x0
  801261:	6a 00                	push   $0x0
  801263:	6a 00                	push   $0x0
  801265:	6a 12                	push   $0x12
  801267:	e8 4e fe ff ff       	call   8010ba <syscall>
  80126c:	83 c4 18             	add    $0x18,%esp
}
  80126f:	90                   	nop
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <sys_cputc>:


void
sys_cputc(const char c)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 04             	sub    $0x4,%esp
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80127e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	6a 00                	push   $0x0
  80128a:	50                   	push   %eax
  80128b:	6a 13                	push   $0x13
  80128d:	e8 28 fe ff ff       	call   8010ba <syscall>
  801292:	83 c4 18             	add    $0x18,%esp
}
  801295:	90                   	nop
  801296:	c9                   	leave  
  801297:	c3                   	ret    

00801298 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80129b:	6a 00                	push   $0x0
  80129d:	6a 00                	push   $0x0
  80129f:	6a 00                	push   $0x0
  8012a1:	6a 00                	push   $0x0
  8012a3:	6a 00                	push   $0x0
  8012a5:	6a 14                	push   $0x14
  8012a7:	e8 0e fe ff ff       	call   8010ba <syscall>
  8012ac:	83 c4 18             	add    $0x18,%esp
}
  8012af:	90                   	nop
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	6a 00                	push   $0x0
  8012ba:	6a 00                	push   $0x0
  8012bc:	6a 00                	push   $0x0
  8012be:	ff 75 0c             	pushl  0xc(%ebp)
  8012c1:	50                   	push   %eax
  8012c2:	6a 15                	push   $0x15
  8012c4:	e8 f1 fd ff ff       	call   8010ba <syscall>
  8012c9:	83 c4 18             	add    $0x18,%esp
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 00                	push   $0x0
  8012dd:	52                   	push   %edx
  8012de:	50                   	push   %eax
  8012df:	6a 18                	push   $0x18
  8012e1:	e8 d4 fd ff ff       	call   8010ba <syscall>
  8012e6:	83 c4 18             	add    $0x18,%esp
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	52                   	push   %edx
  8012fb:	50                   	push   %eax
  8012fc:	6a 16                	push   $0x16
  8012fe:	e8 b7 fd ff ff       	call   8010ba <syscall>
  801303:	83 c4 18             	add    $0x18,%esp
}
  801306:	90                   	nop
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80130c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	52                   	push   %edx
  801319:	50                   	push   %eax
  80131a:	6a 17                	push   $0x17
  80131c:	e8 99 fd ff ff       	call   8010ba <syscall>
  801321:	83 c4 18             	add    $0x18,%esp
}
  801324:	90                   	nop
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 04             	sub    $0x4,%esp
  80132d:	8b 45 10             	mov    0x10(%ebp),%eax
  801330:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801333:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801336:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	6a 00                	push   $0x0
  80133f:	51                   	push   %ecx
  801340:	52                   	push   %edx
  801341:	ff 75 0c             	pushl  0xc(%ebp)
  801344:	50                   	push   %eax
  801345:	6a 19                	push   $0x19
  801347:	e8 6e fd ff ff       	call   8010ba <syscall>
  80134c:	83 c4 18             	add    $0x18,%esp
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801354:	8b 55 0c             	mov    0xc(%ebp),%edx
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	52                   	push   %edx
  801361:	50                   	push   %eax
  801362:	6a 1a                	push   $0x1a
  801364:	e8 51 fd ff ff       	call   8010ba <syscall>
  801369:	83 c4 18             	add    $0x18,%esp
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801371:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801374:	8b 55 0c             	mov    0xc(%ebp),%edx
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	51                   	push   %ecx
  80137f:	52                   	push   %edx
  801380:	50                   	push   %eax
  801381:	6a 1b                	push   $0x1b
  801383:	e8 32 fd ff ff       	call   8010ba <syscall>
  801388:	83 c4 18             	add    $0x18,%esp
}
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801390:	8b 55 0c             	mov    0xc(%ebp),%edx
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	52                   	push   %edx
  80139d:	50                   	push   %eax
  80139e:	6a 1c                	push   $0x1c
  8013a0:	e8 15 fd ff ff       	call   8010ba <syscall>
  8013a5:	83 c4 18             	add    $0x18,%esp
}
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 1d                	push   $0x1d
  8013b9:	e8 fc fc ff ff       	call   8010ba <syscall>
  8013be:	83 c4 18             	add    $0x18,%esp
}
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	6a 00                	push   $0x0
  8013cb:	ff 75 14             	pushl  0x14(%ebp)
  8013ce:	ff 75 10             	pushl  0x10(%ebp)
  8013d1:	ff 75 0c             	pushl  0xc(%ebp)
  8013d4:	50                   	push   %eax
  8013d5:	6a 1e                	push   $0x1e
  8013d7:	e8 de fc ff ff       	call   8010ba <syscall>
  8013dc:	83 c4 18             	add    $0x18,%esp
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	50                   	push   %eax
  8013f0:	6a 1f                	push   $0x1f
  8013f2:	e8 c3 fc ff ff       	call   8010ba <syscall>
  8013f7:	83 c4 18             	add    $0x18,%esp
}
  8013fa:	90                   	nop
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	50                   	push   %eax
  80140c:	6a 20                	push   $0x20
  80140e:	e8 a7 fc ff ff       	call   8010ba <syscall>
  801413:	83 c4 18             	add    $0x18,%esp
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 02                	push   $0x2
  801427:	e8 8e fc ff ff       	call   8010ba <syscall>
  80142c:	83 c4 18             	add    $0x18,%esp
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 03                	push   $0x3
  801440:	e8 75 fc ff ff       	call   8010ba <syscall>
  801445:	83 c4 18             	add    $0x18,%esp
}
  801448:	c9                   	leave  
  801449:	c3                   	ret    

0080144a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	6a 00                	push   $0x0
  801457:	6a 04                	push   $0x4
  801459:	e8 5c fc ff ff       	call   8010ba <syscall>
  80145e:	83 c4 18             	add    $0x18,%esp
}
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <sys_exit_env>:


void sys_exit_env(void)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 21                	push   $0x21
  801472:	e8 43 fc ff ff       	call   8010ba <syscall>
  801477:	83 c4 18             	add    $0x18,%esp
}
  80147a:	90                   	nop
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801483:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801486:	8d 50 04             	lea    0x4(%eax),%edx
  801489:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	52                   	push   %edx
  801493:	50                   	push   %eax
  801494:	6a 22                	push   $0x22
  801496:	e8 1f fc ff ff       	call   8010ba <syscall>
  80149b:	83 c4 18             	add    $0x18,%esp
	return result;
  80149e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a7:	89 01                	mov    %eax,(%ecx)
  8014a9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	c9                   	leave  
  8014b0:	c2 04 00             	ret    $0x4

008014b3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	ff 75 10             	pushl  0x10(%ebp)
  8014bd:	ff 75 0c             	pushl  0xc(%ebp)
  8014c0:	ff 75 08             	pushl  0x8(%ebp)
  8014c3:	6a 10                	push   $0x10
  8014c5:	e8 f0 fb ff ff       	call   8010ba <syscall>
  8014ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8014cd:	90                   	nop
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 23                	push   $0x23
  8014df:	e8 d6 fb ff ff       	call   8010ba <syscall>
  8014e4:	83 c4 18             	add    $0x18,%esp
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	83 ec 04             	sub    $0x4,%esp
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014f5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	50                   	push   %eax
  801502:	6a 24                	push   $0x24
  801504:	e8 b1 fb ff ff       	call   8010ba <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
	return ;
  80150c:	90                   	nop
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <rsttst>:
void rsttst()
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 26                	push   $0x26
  80151e:	e8 97 fb ff ff       	call   8010ba <syscall>
  801523:	83 c4 18             	add    $0x18,%esp
	return ;
  801526:	90                   	nop
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	83 ec 04             	sub    $0x4,%esp
  80152f:	8b 45 14             	mov    0x14(%ebp),%eax
  801532:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801535:	8b 55 18             	mov    0x18(%ebp),%edx
  801538:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80153c:	52                   	push   %edx
  80153d:	50                   	push   %eax
  80153e:	ff 75 10             	pushl  0x10(%ebp)
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	ff 75 08             	pushl  0x8(%ebp)
  801547:	6a 25                	push   $0x25
  801549:	e8 6c fb ff ff       	call   8010ba <syscall>
  80154e:	83 c4 18             	add    $0x18,%esp
	return ;
  801551:	90                   	nop
}
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <chktst>:
void chktst(uint32 n)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	ff 75 08             	pushl  0x8(%ebp)
  801562:	6a 27                	push   $0x27
  801564:	e8 51 fb ff ff       	call   8010ba <syscall>
  801569:	83 c4 18             	add    $0x18,%esp
	return ;
  80156c:	90                   	nop
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <inctst>:

void inctst()
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 28                	push   $0x28
  80157e:	e8 37 fb ff ff       	call   8010ba <syscall>
  801583:	83 c4 18             	add    $0x18,%esp
	return ;
  801586:	90                   	nop
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <gettst>:
uint32 gettst()
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 29                	push   $0x29
  801598:	e8 1d fb ff ff       	call   8010ba <syscall>
  80159d:	83 c4 18             	add    $0x18,%esp
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 2a                	push   $0x2a
  8015b4:	e8 01 fb ff ff       	call   8010ba <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
  8015bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8015bf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8015c3:	75 07                	jne    8015cc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8015c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8015ca:	eb 05                	jmp    8015d1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 2a                	push   $0x2a
  8015e5:	e8 d0 fa ff ff       	call   8010ba <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
  8015ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015f0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015f4:	75 07                	jne    8015fd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8015fb:	eb 05                	jmp    801602 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 2a                	push   $0x2a
  801616:	e8 9f fa ff ff       	call   8010ba <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
  80161e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801621:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801625:	75 07                	jne    80162e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801627:	b8 01 00 00 00       	mov    $0x1,%eax
  80162c:	eb 05                	jmp    801633 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80162e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 2a                	push   $0x2a
  801647:	e8 6e fa ff ff       	call   8010ba <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
  80164f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801652:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801656:	75 07                	jne    80165f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801658:	b8 01 00 00 00       	mov    $0x1,%eax
  80165d:	eb 05                	jmp    801664 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80165f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	ff 75 08             	pushl  0x8(%ebp)
  801674:	6a 2b                	push   $0x2b
  801676:	e8 3f fa ff ff       	call   8010ba <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
	return ;
  80167e:	90                   	nop
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801685:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801688:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	6a 00                	push   $0x0
  801693:	53                   	push   %ebx
  801694:	51                   	push   %ecx
  801695:	52                   	push   %edx
  801696:	50                   	push   %eax
  801697:	6a 2c                	push   $0x2c
  801699:	e8 1c fa ff ff       	call   8010ba <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
}
  8016a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	52                   	push   %edx
  8016b6:	50                   	push   %eax
  8016b7:	6a 2d                	push   $0x2d
  8016b9:	e8 fc f9 ff ff       	call   8010ba <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016c6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	6a 00                	push   $0x0
  8016d1:	51                   	push   %ecx
  8016d2:	ff 75 10             	pushl  0x10(%ebp)
  8016d5:	52                   	push   %edx
  8016d6:	50                   	push   %eax
  8016d7:	6a 2e                	push   $0x2e
  8016d9:	e8 dc f9 ff ff       	call   8010ba <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	ff 75 10             	pushl  0x10(%ebp)
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	ff 75 08             	pushl  0x8(%ebp)
  8016f3:	6a 0f                	push   $0xf
  8016f5:	e8 c0 f9 ff ff       	call   8010ba <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8016fd:	90                   	nop
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801706:	83 ec 04             	sub    $0x4,%esp
  801709:	68 30 20 80 00       	push   $0x802030
  80170e:	68 54 01 00 00       	push   $0x154
  801713:	68 44 20 80 00       	push   $0x802044
  801718:	e8 3a 00 00 00       	call   801757 <_panic>

0080171d <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801723:	83 ec 04             	sub    $0x4,%esp
  801726:	68 30 20 80 00       	push   $0x802030
  80172b:	68 5b 01 00 00       	push   $0x15b
  801730:	68 44 20 80 00       	push   $0x802044
  801735:	e8 1d 00 00 00       	call   801757 <_panic>

0080173a <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	68 30 20 80 00       	push   $0x802030
  801748:	68 61 01 00 00       	push   $0x161
  80174d:	68 44 20 80 00       	push   $0x802044
  801752:	e8 00 00 00 00       	call   801757 <_panic>

00801757 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80175d:	8d 45 10             	lea    0x10(%ebp),%eax
  801760:	83 c0 04             	add    $0x4,%eax
  801763:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801766:	a1 28 31 80 00       	mov    0x803128,%eax
  80176b:	85 c0                	test   %eax,%eax
  80176d:	74 16                	je     801785 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80176f:	a1 28 31 80 00       	mov    0x803128,%eax
  801774:	83 ec 08             	sub    $0x8,%esp
  801777:	50                   	push   %eax
  801778:	68 54 20 80 00       	push   $0x802054
  80177d:	e8 46 eb ff ff       	call   8002c8 <cprintf>
  801782:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801785:	a1 00 30 80 00       	mov    0x803000,%eax
  80178a:	ff 75 0c             	pushl  0xc(%ebp)
  80178d:	ff 75 08             	pushl  0x8(%ebp)
  801790:	50                   	push   %eax
  801791:	68 59 20 80 00       	push   $0x802059
  801796:	e8 2d eb ff ff       	call   8002c8 <cprintf>
  80179b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80179e:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a7:	50                   	push   %eax
  8017a8:	e8 b0 ea ff ff       	call   80025d <vcprintf>
  8017ad:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8017b0:	83 ec 08             	sub    $0x8,%esp
  8017b3:	6a 00                	push   $0x0
  8017b5:	68 75 20 80 00       	push   $0x802075
  8017ba:	e8 9e ea ff ff       	call   80025d <vcprintf>
  8017bf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8017c2:	e8 1f ea ff ff       	call   8001e6 <exit>

	// should not return here
	while (1) ;
  8017c7:	eb fe                	jmp    8017c7 <_panic+0x70>

008017c9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8017cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8017d4:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	39 c2                	cmp    %eax,%edx
  8017df:	74 14                	je     8017f5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	68 78 20 80 00       	push   $0x802078
  8017e9:	6a 26                	push   $0x26
  8017eb:	68 c4 20 80 00       	push   $0x8020c4
  8017f0:	e8 62 ff ff ff       	call   801757 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8017f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8017fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801803:	e9 c5 00 00 00       	jmp    8018cd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	01 d0                	add    %edx,%eax
  801817:	8b 00                	mov    (%eax),%eax
  801819:	85 c0                	test   %eax,%eax
  80181b:	75 08                	jne    801825 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80181d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801820:	e9 a5 00 00 00       	jmp    8018ca <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801825:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80182c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801833:	eb 69                	jmp    80189e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801835:	a1 20 30 80 00       	mov    0x803020,%eax
  80183a:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  801840:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801843:	89 d0                	mov    %edx,%eax
  801845:	01 c0                	add    %eax,%eax
  801847:	01 d0                	add    %edx,%eax
  801849:	c1 e0 03             	shl    $0x3,%eax
  80184c:	01 c8                	add    %ecx,%eax
  80184e:	8a 40 04             	mov    0x4(%eax),%al
  801851:	84 c0                	test   %al,%al
  801853:	75 46                	jne    80189b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801855:	a1 20 30 80 00       	mov    0x803020,%eax
  80185a:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  801860:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801863:	89 d0                	mov    %edx,%eax
  801865:	01 c0                	add    %eax,%eax
  801867:	01 d0                	add    %edx,%eax
  801869:	c1 e0 03             	shl    $0x3,%eax
  80186c:	01 c8                	add    %ecx,%eax
  80186e:	8b 00                	mov    (%eax),%eax
  801870:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801873:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801876:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80187b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80187d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801880:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	01 c8                	add    %ecx,%eax
  80188c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80188e:	39 c2                	cmp    %eax,%edx
  801890:	75 09                	jne    80189b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801892:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801899:	eb 15                	jmp    8018b0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80189b:	ff 45 e8             	incl   -0x18(%ebp)
  80189e:	a1 20 30 80 00       	mov    0x803020,%eax
  8018a3:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  8018a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ac:	39 c2                	cmp    %eax,%edx
  8018ae:	77 85                	ja     801835 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8018b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018b4:	75 14                	jne    8018ca <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8018b6:	83 ec 04             	sub    $0x4,%esp
  8018b9:	68 d0 20 80 00       	push   $0x8020d0
  8018be:	6a 3a                	push   $0x3a
  8018c0:	68 c4 20 80 00       	push   $0x8020c4
  8018c5:	e8 8d fe ff ff       	call   801757 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8018ca:	ff 45 f0             	incl   -0x10(%ebp)
  8018cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8018d3:	0f 8c 2f ff ff ff    	jl     801808 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8018d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8018e7:	eb 26                	jmp    80190f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8018e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8018ee:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  8018f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018f7:	89 d0                	mov    %edx,%eax
  8018f9:	01 c0                	add    %eax,%eax
  8018fb:	01 d0                	add    %edx,%eax
  8018fd:	c1 e0 03             	shl    $0x3,%eax
  801900:	01 c8                	add    %ecx,%eax
  801902:	8a 40 04             	mov    0x4(%eax),%al
  801905:	3c 01                	cmp    $0x1,%al
  801907:	75 03                	jne    80190c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801909:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80190c:	ff 45 e0             	incl   -0x20(%ebp)
  80190f:	a1 20 30 80 00       	mov    0x803020,%eax
  801914:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  80191a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191d:	39 c2                	cmp    %eax,%edx
  80191f:	77 c8                	ja     8018e9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801924:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801927:	74 14                	je     80193d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	68 24 21 80 00       	push   $0x802124
  801931:	6a 44                	push   $0x44
  801933:	68 c4 20 80 00       	push   $0x8020c4
  801938:	e8 1a fe ff ff       	call   801757 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80193d:	90                   	nop
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <__udivdi3>:
  801940:	55                   	push   %ebp
  801941:	57                   	push   %edi
  801942:	56                   	push   %esi
  801943:	53                   	push   %ebx
  801944:	83 ec 1c             	sub    $0x1c,%esp
  801947:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80194b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80194f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801953:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801957:	89 ca                	mov    %ecx,%edx
  801959:	89 f8                	mov    %edi,%eax
  80195b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80195f:	85 f6                	test   %esi,%esi
  801961:	75 2d                	jne    801990 <__udivdi3+0x50>
  801963:	39 cf                	cmp    %ecx,%edi
  801965:	77 65                	ja     8019cc <__udivdi3+0x8c>
  801967:	89 fd                	mov    %edi,%ebp
  801969:	85 ff                	test   %edi,%edi
  80196b:	75 0b                	jne    801978 <__udivdi3+0x38>
  80196d:	b8 01 00 00 00       	mov    $0x1,%eax
  801972:	31 d2                	xor    %edx,%edx
  801974:	f7 f7                	div    %edi
  801976:	89 c5                	mov    %eax,%ebp
  801978:	31 d2                	xor    %edx,%edx
  80197a:	89 c8                	mov    %ecx,%eax
  80197c:	f7 f5                	div    %ebp
  80197e:	89 c1                	mov    %eax,%ecx
  801980:	89 d8                	mov    %ebx,%eax
  801982:	f7 f5                	div    %ebp
  801984:	89 cf                	mov    %ecx,%edi
  801986:	89 fa                	mov    %edi,%edx
  801988:	83 c4 1c             	add    $0x1c,%esp
  80198b:	5b                   	pop    %ebx
  80198c:	5e                   	pop    %esi
  80198d:	5f                   	pop    %edi
  80198e:	5d                   	pop    %ebp
  80198f:	c3                   	ret    
  801990:	39 ce                	cmp    %ecx,%esi
  801992:	77 28                	ja     8019bc <__udivdi3+0x7c>
  801994:	0f bd fe             	bsr    %esi,%edi
  801997:	83 f7 1f             	xor    $0x1f,%edi
  80199a:	75 40                	jne    8019dc <__udivdi3+0x9c>
  80199c:	39 ce                	cmp    %ecx,%esi
  80199e:	72 0a                	jb     8019aa <__udivdi3+0x6a>
  8019a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019a4:	0f 87 9e 00 00 00    	ja     801a48 <__udivdi3+0x108>
  8019aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8019af:	89 fa                	mov    %edi,%edx
  8019b1:	83 c4 1c             	add    $0x1c,%esp
  8019b4:	5b                   	pop    %ebx
  8019b5:	5e                   	pop    %esi
  8019b6:	5f                   	pop    %edi
  8019b7:	5d                   	pop    %ebp
  8019b8:	c3                   	ret    
  8019b9:	8d 76 00             	lea    0x0(%esi),%esi
  8019bc:	31 ff                	xor    %edi,%edi
  8019be:	31 c0                	xor    %eax,%eax
  8019c0:	89 fa                	mov    %edi,%edx
  8019c2:	83 c4 1c             	add    $0x1c,%esp
  8019c5:	5b                   	pop    %ebx
  8019c6:	5e                   	pop    %esi
  8019c7:	5f                   	pop    %edi
  8019c8:	5d                   	pop    %ebp
  8019c9:	c3                   	ret    
  8019ca:	66 90                	xchg   %ax,%ax
  8019cc:	89 d8                	mov    %ebx,%eax
  8019ce:	f7 f7                	div    %edi
  8019d0:	31 ff                	xor    %edi,%edi
  8019d2:	89 fa                	mov    %edi,%edx
  8019d4:	83 c4 1c             	add    $0x1c,%esp
  8019d7:	5b                   	pop    %ebx
  8019d8:	5e                   	pop    %esi
  8019d9:	5f                   	pop    %edi
  8019da:	5d                   	pop    %ebp
  8019db:	c3                   	ret    
  8019dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019e1:	89 eb                	mov    %ebp,%ebx
  8019e3:	29 fb                	sub    %edi,%ebx
  8019e5:	89 f9                	mov    %edi,%ecx
  8019e7:	d3 e6                	shl    %cl,%esi
  8019e9:	89 c5                	mov    %eax,%ebp
  8019eb:	88 d9                	mov    %bl,%cl
  8019ed:	d3 ed                	shr    %cl,%ebp
  8019ef:	89 e9                	mov    %ebp,%ecx
  8019f1:	09 f1                	or     %esi,%ecx
  8019f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019f7:	89 f9                	mov    %edi,%ecx
  8019f9:	d3 e0                	shl    %cl,%eax
  8019fb:	89 c5                	mov    %eax,%ebp
  8019fd:	89 d6                	mov    %edx,%esi
  8019ff:	88 d9                	mov    %bl,%cl
  801a01:	d3 ee                	shr    %cl,%esi
  801a03:	89 f9                	mov    %edi,%ecx
  801a05:	d3 e2                	shl    %cl,%edx
  801a07:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a0b:	88 d9                	mov    %bl,%cl
  801a0d:	d3 e8                	shr    %cl,%eax
  801a0f:	09 c2                	or     %eax,%edx
  801a11:	89 d0                	mov    %edx,%eax
  801a13:	89 f2                	mov    %esi,%edx
  801a15:	f7 74 24 0c          	divl   0xc(%esp)
  801a19:	89 d6                	mov    %edx,%esi
  801a1b:	89 c3                	mov    %eax,%ebx
  801a1d:	f7 e5                	mul    %ebp
  801a1f:	39 d6                	cmp    %edx,%esi
  801a21:	72 19                	jb     801a3c <__udivdi3+0xfc>
  801a23:	74 0b                	je     801a30 <__udivdi3+0xf0>
  801a25:	89 d8                	mov    %ebx,%eax
  801a27:	31 ff                	xor    %edi,%edi
  801a29:	e9 58 ff ff ff       	jmp    801986 <__udivdi3+0x46>
  801a2e:	66 90                	xchg   %ax,%ax
  801a30:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a34:	89 f9                	mov    %edi,%ecx
  801a36:	d3 e2                	shl    %cl,%edx
  801a38:	39 c2                	cmp    %eax,%edx
  801a3a:	73 e9                	jae    801a25 <__udivdi3+0xe5>
  801a3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a3f:	31 ff                	xor    %edi,%edi
  801a41:	e9 40 ff ff ff       	jmp    801986 <__udivdi3+0x46>
  801a46:	66 90                	xchg   %ax,%ax
  801a48:	31 c0                	xor    %eax,%eax
  801a4a:	e9 37 ff ff ff       	jmp    801986 <__udivdi3+0x46>
  801a4f:	90                   	nop

00801a50 <__umoddi3>:
  801a50:	55                   	push   %ebp
  801a51:	57                   	push   %edi
  801a52:	56                   	push   %esi
  801a53:	53                   	push   %ebx
  801a54:	83 ec 1c             	sub    $0x1c,%esp
  801a57:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a5b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a63:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a6f:	89 f3                	mov    %esi,%ebx
  801a71:	89 fa                	mov    %edi,%edx
  801a73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a77:	89 34 24             	mov    %esi,(%esp)
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	75 1a                	jne    801a98 <__umoddi3+0x48>
  801a7e:	39 f7                	cmp    %esi,%edi
  801a80:	0f 86 a2 00 00 00    	jbe    801b28 <__umoddi3+0xd8>
  801a86:	89 c8                	mov    %ecx,%eax
  801a88:	89 f2                	mov    %esi,%edx
  801a8a:	f7 f7                	div    %edi
  801a8c:	89 d0                	mov    %edx,%eax
  801a8e:	31 d2                	xor    %edx,%edx
  801a90:	83 c4 1c             	add    $0x1c,%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5f                   	pop    %edi
  801a96:	5d                   	pop    %ebp
  801a97:	c3                   	ret    
  801a98:	39 f0                	cmp    %esi,%eax
  801a9a:	0f 87 ac 00 00 00    	ja     801b4c <__umoddi3+0xfc>
  801aa0:	0f bd e8             	bsr    %eax,%ebp
  801aa3:	83 f5 1f             	xor    $0x1f,%ebp
  801aa6:	0f 84 ac 00 00 00    	je     801b58 <__umoddi3+0x108>
  801aac:	bf 20 00 00 00       	mov    $0x20,%edi
  801ab1:	29 ef                	sub    %ebp,%edi
  801ab3:	89 fe                	mov    %edi,%esi
  801ab5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ab9:	89 e9                	mov    %ebp,%ecx
  801abb:	d3 e0                	shl    %cl,%eax
  801abd:	89 d7                	mov    %edx,%edi
  801abf:	89 f1                	mov    %esi,%ecx
  801ac1:	d3 ef                	shr    %cl,%edi
  801ac3:	09 c7                	or     %eax,%edi
  801ac5:	89 e9                	mov    %ebp,%ecx
  801ac7:	d3 e2                	shl    %cl,%edx
  801ac9:	89 14 24             	mov    %edx,(%esp)
  801acc:	89 d8                	mov    %ebx,%eax
  801ace:	d3 e0                	shl    %cl,%eax
  801ad0:	89 c2                	mov    %eax,%edx
  801ad2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ad6:	d3 e0                	shl    %cl,%eax
  801ad8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801adc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ae0:	89 f1                	mov    %esi,%ecx
  801ae2:	d3 e8                	shr    %cl,%eax
  801ae4:	09 d0                	or     %edx,%eax
  801ae6:	d3 eb                	shr    %cl,%ebx
  801ae8:	89 da                	mov    %ebx,%edx
  801aea:	f7 f7                	div    %edi
  801aec:	89 d3                	mov    %edx,%ebx
  801aee:	f7 24 24             	mull   (%esp)
  801af1:	89 c6                	mov    %eax,%esi
  801af3:	89 d1                	mov    %edx,%ecx
  801af5:	39 d3                	cmp    %edx,%ebx
  801af7:	0f 82 87 00 00 00    	jb     801b84 <__umoddi3+0x134>
  801afd:	0f 84 91 00 00 00    	je     801b94 <__umoddi3+0x144>
  801b03:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b07:	29 f2                	sub    %esi,%edx
  801b09:	19 cb                	sbb    %ecx,%ebx
  801b0b:	89 d8                	mov    %ebx,%eax
  801b0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b11:	d3 e0                	shl    %cl,%eax
  801b13:	89 e9                	mov    %ebp,%ecx
  801b15:	d3 ea                	shr    %cl,%edx
  801b17:	09 d0                	or     %edx,%eax
  801b19:	89 e9                	mov    %ebp,%ecx
  801b1b:	d3 eb                	shr    %cl,%ebx
  801b1d:	89 da                	mov    %ebx,%edx
  801b1f:	83 c4 1c             	add    $0x1c,%esp
  801b22:	5b                   	pop    %ebx
  801b23:	5e                   	pop    %esi
  801b24:	5f                   	pop    %edi
  801b25:	5d                   	pop    %ebp
  801b26:	c3                   	ret    
  801b27:	90                   	nop
  801b28:	89 fd                	mov    %edi,%ebp
  801b2a:	85 ff                	test   %edi,%edi
  801b2c:	75 0b                	jne    801b39 <__umoddi3+0xe9>
  801b2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b33:	31 d2                	xor    %edx,%edx
  801b35:	f7 f7                	div    %edi
  801b37:	89 c5                	mov    %eax,%ebp
  801b39:	89 f0                	mov    %esi,%eax
  801b3b:	31 d2                	xor    %edx,%edx
  801b3d:	f7 f5                	div    %ebp
  801b3f:	89 c8                	mov    %ecx,%eax
  801b41:	f7 f5                	div    %ebp
  801b43:	89 d0                	mov    %edx,%eax
  801b45:	e9 44 ff ff ff       	jmp    801a8e <__umoddi3+0x3e>
  801b4a:	66 90                	xchg   %ax,%ax
  801b4c:	89 c8                	mov    %ecx,%eax
  801b4e:	89 f2                	mov    %esi,%edx
  801b50:	83 c4 1c             	add    $0x1c,%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5e                   	pop    %esi
  801b55:	5f                   	pop    %edi
  801b56:	5d                   	pop    %ebp
  801b57:	c3                   	ret    
  801b58:	3b 04 24             	cmp    (%esp),%eax
  801b5b:	72 06                	jb     801b63 <__umoddi3+0x113>
  801b5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b61:	77 0f                	ja     801b72 <__umoddi3+0x122>
  801b63:	89 f2                	mov    %esi,%edx
  801b65:	29 f9                	sub    %edi,%ecx
  801b67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b6b:	89 14 24             	mov    %edx,(%esp)
  801b6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b72:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b76:	8b 14 24             	mov    (%esp),%edx
  801b79:	83 c4 1c             	add    $0x1c,%esp
  801b7c:	5b                   	pop    %ebx
  801b7d:	5e                   	pop    %esi
  801b7e:	5f                   	pop    %edi
  801b7f:	5d                   	pop    %ebp
  801b80:	c3                   	ret    
  801b81:	8d 76 00             	lea    0x0(%esi),%esi
  801b84:	2b 04 24             	sub    (%esp),%eax
  801b87:	19 fa                	sbb    %edi,%edx
  801b89:	89 d1                	mov    %edx,%ecx
  801b8b:	89 c6                	mov    %eax,%esi
  801b8d:	e9 71 ff ff ff       	jmp    801b03 <__umoddi3+0xb3>
  801b92:	66 90                	xchg   %ax,%ax
  801b94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b98:	72 ea                	jb     801b84 <__umoddi3+0x134>
  801b9a:	89 d9                	mov    %ebx,%ecx
  801b9c:	e9 62 ff ff ff       	jmp    801b03 <__umoddi3+0xb3>
