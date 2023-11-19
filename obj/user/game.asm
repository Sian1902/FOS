
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
  800056:	68 e0 19 80 00       	push   $0x8019e0
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
  80008d:	68 e3 19 80 00       	push   $0x8019e3
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
  8000b5:	e8 82 13 00 00       	call   80143c <sys_getenvindex>
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
  8000ea:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000ef:	a1 20 20 80 00       	mov    0x802020,%eax
  8000f4:	8a 40 5c             	mov    0x5c(%eax),%al
  8000f7:	84 c0                	test   %al,%al
  8000f9:	74 0d                	je     800108 <libmain+0x59>
		binaryname = myEnv->prog_name;
  8000fb:	a1 20 20 80 00       	mov    0x802020,%eax
  800100:	83 c0 5c             	add    $0x5c,%eax
  800103:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800108:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80010c:	7e 0a                	jle    800118 <libmain+0x69>
		binaryname = argv[0];
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	8b 00                	mov    (%eax),%eax
  800113:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	ff 75 0c             	pushl  0xc(%ebp)
  80011e:	ff 75 08             	pushl  0x8(%ebp)
  800121:	e8 12 ff ff ff       	call   800038 <_main>
  800126:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800129:	e8 1b 11 00 00       	call   801249 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	68 00 1a 80 00       	push   $0x801a00
  800136:	e8 8d 01 00 00       	call   8002c8 <cprintf>
  80013b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80013e:	a1 20 20 80 00       	mov    0x802020,%eax
  800143:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  800149:	a1 20 20 80 00       	mov    0x802020,%eax
  80014e:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	52                   	push   %edx
  800158:	50                   	push   %eax
  800159:	68 28 1a 80 00       	push   $0x801a28
  80015e:	e8 65 01 00 00       	call   8002c8 <cprintf>
  800163:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800166:	a1 20 20 80 00       	mov    0x802020,%eax
  80016b:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  800171:	a1 20 20 80 00       	mov    0x802020,%eax
  800176:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  80017c:	a1 20 20 80 00       	mov    0x802020,%eax
  800181:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  800187:	51                   	push   %ecx
  800188:	52                   	push   %edx
  800189:	50                   	push   %eax
  80018a:	68 50 1a 80 00       	push   $0x801a50
  80018f:	e8 34 01 00 00       	call   8002c8 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800197:	a1 20 20 80 00       	mov    0x802020,%eax
  80019c:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	68 a8 1a 80 00       	push   $0x801aa8
  8001ab:	e8 18 01 00 00       	call   8002c8 <cprintf>
  8001b0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 00 1a 80 00       	push   $0x801a00
  8001bb:	e8 08 01 00 00       	call   8002c8 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001c3:	e8 9b 10 00 00       	call   801263 <sys_enable_interrupt>

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
  8001db:	e8 28 12 00 00       	call   801408 <sys_destroy_env>
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
  8001ec:	e8 7d 12 00 00       	call   80146e <sys_exit_env>
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
  80021f:	a0 24 20 80 00       	mov    0x802024,%al
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
  80023a:	e8 b1 0e 00 00       	call   8010f0 <sys_cputs>
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
  800294:	a0 24 20 80 00       	mov    0x802024,%al
  800299:	0f b6 c0             	movzbl %al,%eax
  80029c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002a2:	83 ec 04             	sub    $0x4,%esp
  8002a5:	50                   	push   %eax
  8002a6:	52                   	push   %edx
  8002a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ad:	83 c0 08             	add    $0x8,%eax
  8002b0:	50                   	push   %eax
  8002b1:	e8 3a 0e 00 00       	call   8010f0 <sys_cputs>
  8002b6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002b9:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
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
  8002ce:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
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
  8002fb:	e8 49 0f 00 00       	call   801249 <sys_disable_interrupt>
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
  80031b:	e8 43 0f 00 00       	call   801263 <sys_enable_interrupt>
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
  800365:	e8 f6 13 00 00       	call   801760 <__udivdi3>
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
  8003b5:	e8 b6 14 00 00       	call   801870 <__umoddi3>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	05 d4 1c 80 00       	add    $0x801cd4,%eax
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
  800510:	8b 04 85 f8 1c 80 00 	mov    0x801cf8(,%eax,4),%eax
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
  8005f1:	8b 34 9d 40 1b 80 00 	mov    0x801b40(,%ebx,4),%esi
  8005f8:	85 f6                	test   %esi,%esi
  8005fa:	75 19                	jne    800615 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005fc:	53                   	push   %ebx
  8005fd:	68 e5 1c 80 00       	push   $0x801ce5
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
  800616:	68 ee 1c 80 00       	push   $0x801cee
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
  800643:	be f1 1c 80 00       	mov    $0x801cf1,%esi
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

int i=0;
void *
memset(void *v, int c, uint32 n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	83 ec 10             	sub    $0x10,%esp


	i++;
  800b3e:	a1 28 20 80 00       	mov    0x802028,%eax
  800b43:	40                   	inc    %eax
  800b44:	a3 28 20 80 00       	mov    %eax,0x802028

	char *p;
	int m;

	p = v;
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b52:	89 45 f8             	mov    %eax,-0x8(%ebp)


	while (--m >= 0){
  800b55:	eb 0e                	jmp    800b65 <memset+0x2d>

		*p++ = c;
  800b57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b5a:	8d 50 01             	lea    0x1(%eax),%edx
  800b5d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b63:	88 10                	mov    %dl,(%eax)

	p = v;
	m = n;


	while (--m >= 0){
  800b65:	ff 4d f8             	decl   -0x8(%ebp)
  800b68:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b6c:	79 e9                	jns    800b57 <memset+0x1f>

		*p++ = c;
	}

	return v;
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b71:	c9                   	leave  
  800b72:	c3                   	ret    

00800b73 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b85:	eb 16                	jmp    800b9d <memcpy+0x2a>
		*d++ = *s++;
  800b87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b8a:	8d 50 01             	lea    0x1(%eax),%edx
  800b8d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b96:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b99:	8a 12                	mov    (%edx),%dl
  800b9b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba6:	85 c0                	test   %eax,%eax
  800ba8:	75 dd                	jne    800b87 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bc4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bc7:	73 50                	jae    800c19 <memmove+0x6a>
  800bc9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcf:	01 d0                	add    %edx,%eax
  800bd1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bd4:	76 43                	jbe    800c19 <memmove+0x6a>
		s += n;
  800bd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdf:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800be2:	eb 10                	jmp    800bf4 <memmove+0x45>
			*--d = *--s;
  800be4:	ff 4d f8             	decl   -0x8(%ebp)
  800be7:	ff 4d fc             	decl   -0x4(%ebp)
  800bea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bed:	8a 10                	mov    (%eax),%dl
  800bef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bf4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfa:	89 55 10             	mov    %edx,0x10(%ebp)
  800bfd:	85 c0                	test   %eax,%eax
  800bff:	75 e3                	jne    800be4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c01:	eb 23                	jmp    800c26 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c06:	8d 50 01             	lea    0x1(%eax),%edx
  800c09:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c12:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c15:	8a 12                	mov    (%edx),%dl
  800c17:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c19:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c22:	85 c0                	test   %eax,%eax
  800c24:	75 dd                	jne    800c03 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c29:	c9                   	leave  
  800c2a:	c3                   	ret    

00800c2b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c3d:	eb 2a                	jmp    800c69 <memcmp+0x3e>
		if (*s1 != *s2)
  800c3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c42:	8a 10                	mov    (%eax),%dl
  800c44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c47:	8a 00                	mov    (%eax),%al
  800c49:	38 c2                	cmp    %al,%dl
  800c4b:	74 16                	je     800c63 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c50:	8a 00                	mov    (%eax),%al
  800c52:	0f b6 d0             	movzbl %al,%edx
  800c55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c58:	8a 00                	mov    (%eax),%al
  800c5a:	0f b6 c0             	movzbl %al,%eax
  800c5d:	29 c2                	sub    %eax,%edx
  800c5f:	89 d0                	mov    %edx,%eax
  800c61:	eb 18                	jmp    800c7b <memcmp+0x50>
		s1++, s2++;
  800c63:	ff 45 fc             	incl   -0x4(%ebp)
  800c66:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c69:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	75 c9                	jne    800c3f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7b:	c9                   	leave  
  800c7c:	c3                   	ret    

00800c7d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
  800c80:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c83:	8b 55 08             	mov    0x8(%ebp),%edx
  800c86:	8b 45 10             	mov    0x10(%ebp),%eax
  800c89:	01 d0                	add    %edx,%eax
  800c8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c8e:	eb 15                	jmp    800ca5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	0f b6 d0             	movzbl %al,%edx
  800c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9b:	0f b6 c0             	movzbl %al,%eax
  800c9e:	39 c2                	cmp    %eax,%edx
  800ca0:	74 0d                	je     800caf <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800cab:	72 e3                	jb     800c90 <memfind+0x13>
  800cad:	eb 01                	jmp    800cb0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800caf:	90                   	nop
	return (void *) s;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cc2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc9:	eb 03                	jmp    800cce <strtol+0x19>
		s++;
  800ccb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	3c 20                	cmp    $0x20,%al
  800cd5:	74 f4                	je     800ccb <strtol+0x16>
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	3c 09                	cmp    $0x9,%al
  800cde:	74 eb                	je     800ccb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	3c 2b                	cmp    $0x2b,%al
  800ce7:	75 05                	jne    800cee <strtol+0x39>
		s++;
  800ce9:	ff 45 08             	incl   0x8(%ebp)
  800cec:	eb 13                	jmp    800d01 <strtol+0x4c>
	else if (*s == '-')
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	3c 2d                	cmp    $0x2d,%al
  800cf5:	75 0a                	jne    800d01 <strtol+0x4c>
		s++, neg = 1;
  800cf7:	ff 45 08             	incl   0x8(%ebp)
  800cfa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d05:	74 06                	je     800d0d <strtol+0x58>
  800d07:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d0b:	75 20                	jne    800d2d <strtol+0x78>
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	3c 30                	cmp    $0x30,%al
  800d14:	75 17                	jne    800d2d <strtol+0x78>
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	40                   	inc    %eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	3c 78                	cmp    $0x78,%al
  800d1e:	75 0d                	jne    800d2d <strtol+0x78>
		s += 2, base = 16;
  800d20:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d24:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d2b:	eb 28                	jmp    800d55 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d31:	75 15                	jne    800d48 <strtol+0x93>
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	3c 30                	cmp    $0x30,%al
  800d3a:	75 0c                	jne    800d48 <strtol+0x93>
		s++, base = 8;
  800d3c:	ff 45 08             	incl   0x8(%ebp)
  800d3f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d46:	eb 0d                	jmp    800d55 <strtol+0xa0>
	else if (base == 0)
  800d48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4c:	75 07                	jne    800d55 <strtol+0xa0>
		base = 10;
  800d4e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3c 2f                	cmp    $0x2f,%al
  800d5c:	7e 19                	jle    800d77 <strtol+0xc2>
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	3c 39                	cmp    $0x39,%al
  800d65:	7f 10                	jg     800d77 <strtol+0xc2>
			dig = *s - '0';
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	0f be c0             	movsbl %al,%eax
  800d6f:	83 e8 30             	sub    $0x30,%eax
  800d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d75:	eb 42                	jmp    800db9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3c 60                	cmp    $0x60,%al
  800d7e:	7e 19                	jle    800d99 <strtol+0xe4>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3c 7a                	cmp    $0x7a,%al
  800d87:	7f 10                	jg     800d99 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	0f be c0             	movsbl %al,%eax
  800d91:	83 e8 57             	sub    $0x57,%eax
  800d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d97:	eb 20                	jmp    800db9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	3c 40                	cmp    $0x40,%al
  800da0:	7e 39                	jle    800ddb <strtol+0x126>
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8a 00                	mov    (%eax),%al
  800da7:	3c 5a                	cmp    $0x5a,%al
  800da9:	7f 30                	jg     800ddb <strtol+0x126>
			dig = *s - 'A' + 10;
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	0f be c0             	movsbl %al,%eax
  800db3:	83 e8 37             	sub    $0x37,%eax
  800db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dbc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dbf:	7d 19                	jge    800dda <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800dc1:	ff 45 08             	incl   0x8(%ebp)
  800dc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dcb:	89 c2                	mov    %eax,%edx
  800dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd0:	01 d0                	add    %edx,%eax
  800dd2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dd5:	e9 7b ff ff ff       	jmp    800d55 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dda:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ddb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ddf:	74 08                	je     800de9 <strtol+0x134>
		*endptr = (char *) s;
  800de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de4:	8b 55 08             	mov    0x8(%ebp),%edx
  800de7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800de9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ded:	74 07                	je     800df6 <strtol+0x141>
  800def:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df2:	f7 d8                	neg    %eax
  800df4:	eb 03                	jmp    800df9 <strtol+0x144>
  800df6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800df9:	c9                   	leave  
  800dfa:	c3                   	ret    

00800dfb <ltostr>:

void
ltostr(long value, char *str)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e08:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e13:	79 13                	jns    800e28 <ltostr+0x2d>
	{
		neg = 1;
  800e15:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e22:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e25:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e30:	99                   	cltd   
  800e31:	f7 f9                	idiv   %ecx
  800e33:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e39:	8d 50 01             	lea    0x1(%eax),%edx
  800e3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3f:	89 c2                	mov    %eax,%edx
  800e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e44:	01 d0                	add    %edx,%eax
  800e46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e49:	83 c2 30             	add    $0x30,%edx
  800e4c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e51:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e56:	f7 e9                	imul   %ecx
  800e58:	c1 fa 02             	sar    $0x2,%edx
  800e5b:	89 c8                	mov    %ecx,%eax
  800e5d:	c1 f8 1f             	sar    $0x1f,%eax
  800e60:	29 c2                	sub    %eax,%edx
  800e62:	89 d0                	mov    %edx,%eax
  800e64:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e6a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e6f:	f7 e9                	imul   %ecx
  800e71:	c1 fa 02             	sar    $0x2,%edx
  800e74:	89 c8                	mov    %ecx,%eax
  800e76:	c1 f8 1f             	sar    $0x1f,%eax
  800e79:	29 c2                	sub    %eax,%edx
  800e7b:	89 d0                	mov    %edx,%eax
  800e7d:	c1 e0 02             	shl    $0x2,%eax
  800e80:	01 d0                	add    %edx,%eax
  800e82:	01 c0                	add    %eax,%eax
  800e84:	29 c1                	sub    %eax,%ecx
  800e86:	89 ca                	mov    %ecx,%edx
  800e88:	85 d2                	test   %edx,%edx
  800e8a:	75 9c                	jne    800e28 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e96:	48                   	dec    %eax
  800e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e9e:	74 3d                	je     800edd <ltostr+0xe2>
		start = 1 ;
  800ea0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800ea7:	eb 34                	jmp    800edd <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800ea9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaf:	01 d0                	add    %edx,%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	01 c2                	add    %eax,%edx
  800ebe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec4:	01 c8                	add    %ecx,%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800eca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	01 c2                	add    %eax,%edx
  800ed2:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ed5:	88 02                	mov    %al,(%edx)
		start++ ;
  800ed7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800eda:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ee3:	7c c4                	jl     800ea9 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ee5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eeb:	01 d0                	add    %edx,%eax
  800eed:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ef0:	90                   	nop
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ef9:	ff 75 08             	pushl  0x8(%ebp)
  800efc:	e8 49 fa ff ff       	call   80094a <strlen>
  800f01:	83 c4 04             	add    $0x4,%esp
  800f04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	e8 3b fa ff ff       	call   80094a <strlen>
  800f0f:	83 c4 04             	add    $0x4,%esp
  800f12:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f23:	eb 17                	jmp    800f3c <strcconcat+0x49>
		final[s] = str1[s] ;
  800f25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f28:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2b:	01 c2                	add    %eax,%edx
  800f2d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	01 c8                	add    %ecx,%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f39:	ff 45 fc             	incl   -0x4(%ebp)
  800f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f42:	7c e1                	jl     800f25 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f44:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f4b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f52:	eb 1f                	jmp    800f73 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f57:	8d 50 01             	lea    0x1(%eax),%edx
  800f5a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f5d:	89 c2                	mov    %eax,%edx
  800f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f62:	01 c2                	add    %eax,%edx
  800f64:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6a:	01 c8                	add    %ecx,%eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f70:	ff 45 f8             	incl   -0x8(%ebp)
  800f73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f76:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f79:	7c d9                	jl     800f54 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f81:	01 d0                	add    %edx,%eax
  800f83:	c6 00 00             	movb   $0x0,(%eax)
}
  800f86:	90                   	nop
  800f87:	c9                   	leave  
  800f88:	c3                   	ret    

00800f89 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f95:	8b 45 14             	mov    0x14(%ebp),%eax
  800f98:	8b 00                	mov    (%eax),%eax
  800f9a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fac:	eb 0c                	jmp    800fba <strsplit+0x31>
			*string++ = 0;
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8d 50 01             	lea    0x1(%eax),%edx
  800fb4:	89 55 08             	mov    %edx,0x8(%ebp)
  800fb7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	74 18                	je     800fdb <strsplit+0x52>
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	0f be c0             	movsbl %al,%eax
  800fcb:	50                   	push   %eax
  800fcc:	ff 75 0c             	pushl  0xc(%ebp)
  800fcf:	e8 08 fb ff ff       	call   800adc <strchr>
  800fd4:	83 c4 08             	add    $0x8,%esp
  800fd7:	85 c0                	test   %eax,%eax
  800fd9:	75 d3                	jne    800fae <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	84 c0                	test   %al,%al
  800fe2:	74 5a                	je     80103e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fe4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe7:	8b 00                	mov    (%eax),%eax
  800fe9:	83 f8 0f             	cmp    $0xf,%eax
  800fec:	75 07                	jne    800ff5 <strsplit+0x6c>
		{
			return 0;
  800fee:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff3:	eb 66                	jmp    80105b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800ff5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff8:	8b 00                	mov    (%eax),%eax
  800ffa:	8d 48 01             	lea    0x1(%eax),%ecx
  800ffd:	8b 55 14             	mov    0x14(%ebp),%edx
  801000:	89 0a                	mov    %ecx,(%edx)
  801002:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801009:	8b 45 10             	mov    0x10(%ebp),%eax
  80100c:	01 c2                	add    %eax,%edx
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801013:	eb 03                	jmp    801018 <strsplit+0x8f>
			string++;
  801015:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	8a 00                	mov    (%eax),%al
  80101d:	84 c0                	test   %al,%al
  80101f:	74 8b                	je     800fac <strsplit+0x23>
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	0f be c0             	movsbl %al,%eax
  801029:	50                   	push   %eax
  80102a:	ff 75 0c             	pushl  0xc(%ebp)
  80102d:	e8 aa fa ff ff       	call   800adc <strchr>
  801032:	83 c4 08             	add    $0x8,%esp
  801035:	85 c0                	test   %eax,%eax
  801037:	74 dc                	je     801015 <strsplit+0x8c>
			string++;
	}
  801039:	e9 6e ff ff ff       	jmp    800fac <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80103e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80103f:	8b 45 14             	mov    0x14(%ebp),%eax
  801042:	8b 00                	mov    (%eax),%eax
  801044:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80104b:	8b 45 10             	mov    0x10(%ebp),%eax
  80104e:	01 d0                	add    %edx,%eax
  801050:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801056:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80105b:	c9                   	leave  
  80105c:	c3                   	ret    

0080105d <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  801063:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801067:	74 06                	je     80106f <str2lower+0x12>
  801069:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106d:	75 07                	jne    801076 <str2lower+0x19>
		return NULL;
  80106f:	b8 00 00 00 00       	mov    $0x0,%eax
  801074:	eb 4d                	jmp    8010c3 <str2lower+0x66>
	}
	char *ref=dst;
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  80107c:	eb 33                	jmp    8010b1 <str2lower+0x54>
			if(*src>=65&&*src<=90){
  80107e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 40                	cmp    $0x40,%al
  801085:	7e 1a                	jle    8010a1 <str2lower+0x44>
  801087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 5a                	cmp    $0x5a,%al
  80108e:	7f 11                	jg     8010a1 <str2lower+0x44>
				*dst=*src+32;
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	83 c0 20             	add    $0x20,%eax
  801098:	88 c2                	mov    %al,%dl
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	88 10                	mov    %dl,(%eax)
  80109f:	eb 0a                	jmp    8010ab <str2lower+0x4e>
			}
			else{
				*dst=*src;
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	8a 10                	mov    (%eax),%dl
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	88 10                	mov    %dl,(%eax)
			}
			src++;
  8010ab:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  8010ae:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	84 c0                	test   %al,%al
  8010b8:	75 c4                	jne    80107e <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  8010c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	57                   	push   %edi
  8010c9:	56                   	push   %esi
  8010ca:	53                   	push   %ebx
  8010cb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010d7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010da:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010dd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010e0:	cd 30                	int    $0x30
  8010e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8010e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010e8:	83 c4 10             	add    $0x10,%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	83 ec 04             	sub    $0x4,%esp
  8010f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010fc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	6a 00                	push   $0x0
  801105:	6a 00                	push   $0x0
  801107:	52                   	push   %edx
  801108:	ff 75 0c             	pushl  0xc(%ebp)
  80110b:	50                   	push   %eax
  80110c:	6a 00                	push   $0x0
  80110e:	e8 b2 ff ff ff       	call   8010c5 <syscall>
  801113:	83 c4 18             	add    $0x18,%esp
}
  801116:	90                   	nop
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <sys_cgetc>:

int
sys_cgetc(void)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80111c:	6a 00                	push   $0x0
  80111e:	6a 00                	push   $0x0
  801120:	6a 00                	push   $0x0
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	6a 01                	push   $0x1
  801128:	e8 98 ff ff ff       	call   8010c5 <syscall>
  80112d:	83 c4 18             	add    $0x18,%esp
}
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801135:	8b 55 0c             	mov    0xc(%ebp),%edx
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	6a 00                	push   $0x0
  80113d:	6a 00                	push   $0x0
  80113f:	6a 00                	push   $0x0
  801141:	52                   	push   %edx
  801142:	50                   	push   %eax
  801143:	6a 05                	push   $0x5
  801145:	e8 7b ff ff ff       	call   8010c5 <syscall>
  80114a:	83 c4 18             	add    $0x18,%esp
}
  80114d:	c9                   	leave  
  80114e:	c3                   	ret    

0080114f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	56                   	push   %esi
  801153:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801154:	8b 75 18             	mov    0x18(%ebp),%esi
  801157:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80115a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80115d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	56                   	push   %esi
  801164:	53                   	push   %ebx
  801165:	51                   	push   %ecx
  801166:	52                   	push   %edx
  801167:	50                   	push   %eax
  801168:	6a 06                	push   $0x6
  80116a:	e8 56 ff ff ff       	call   8010c5 <syscall>
  80116f:	83 c4 18             	add    $0x18,%esp
}
  801172:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801175:	5b                   	pop    %ebx
  801176:	5e                   	pop    %esi
  801177:	5d                   	pop    %ebp
  801178:	c3                   	ret    

00801179 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80117c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	6a 00                	push   $0x0
  801184:	6a 00                	push   $0x0
  801186:	6a 00                	push   $0x0
  801188:	52                   	push   %edx
  801189:	50                   	push   %eax
  80118a:	6a 07                	push   $0x7
  80118c:	e8 34 ff ff ff       	call   8010c5 <syscall>
  801191:	83 c4 18             	add    $0x18,%esp
}
  801194:	c9                   	leave  
  801195:	c3                   	ret    

00801196 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801199:	6a 00                	push   $0x0
  80119b:	6a 00                	push   $0x0
  80119d:	6a 00                	push   $0x0
  80119f:	ff 75 0c             	pushl  0xc(%ebp)
  8011a2:	ff 75 08             	pushl  0x8(%ebp)
  8011a5:	6a 08                	push   $0x8
  8011a7:	e8 19 ff ff ff       	call   8010c5 <syscall>
  8011ac:	83 c4 18             	add    $0x18,%esp
}
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 00                	push   $0x0
  8011b8:	6a 00                	push   $0x0
  8011ba:	6a 00                	push   $0x0
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 09                	push   $0x9
  8011c0:	e8 00 ff ff ff       	call   8010c5 <syscall>
  8011c5:	83 c4 18             	add    $0x18,%esp
}
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011cd:	6a 00                	push   $0x0
  8011cf:	6a 00                	push   $0x0
  8011d1:	6a 00                	push   $0x0
  8011d3:	6a 00                	push   $0x0
  8011d5:	6a 00                	push   $0x0
  8011d7:	6a 0a                	push   $0xa
  8011d9:	e8 e7 fe ff ff       	call   8010c5 <syscall>
  8011de:	83 c4 18             	add    $0x18,%esp
}
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    

008011e3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011e6:	6a 00                	push   $0x0
  8011e8:	6a 00                	push   $0x0
  8011ea:	6a 00                	push   $0x0
  8011ec:	6a 00                	push   $0x0
  8011ee:	6a 00                	push   $0x0
  8011f0:	6a 0b                	push   $0xb
  8011f2:	e8 ce fe ff ff       	call   8010c5 <syscall>
  8011f7:	83 c4 18             	add    $0x18,%esp
}
  8011fa:	c9                   	leave  
  8011fb:	c3                   	ret    

008011fc <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011ff:	6a 00                	push   $0x0
  801201:	6a 00                	push   $0x0
  801203:	6a 00                	push   $0x0
  801205:	6a 00                	push   $0x0
  801207:	6a 00                	push   $0x0
  801209:	6a 0c                	push   $0xc
  80120b:	e8 b5 fe ff ff       	call   8010c5 <syscall>
  801210:	83 c4 18             	add    $0x18,%esp
}
  801213:	c9                   	leave  
  801214:	c3                   	ret    

00801215 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801218:	6a 00                	push   $0x0
  80121a:	6a 00                	push   $0x0
  80121c:	6a 00                	push   $0x0
  80121e:	6a 00                	push   $0x0
  801220:	ff 75 08             	pushl  0x8(%ebp)
  801223:	6a 0d                	push   $0xd
  801225:	e8 9b fe ff ff       	call   8010c5 <syscall>
  80122a:	83 c4 18             	add    $0x18,%esp
}
  80122d:	c9                   	leave  
  80122e:	c3                   	ret    

0080122f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801232:	6a 00                	push   $0x0
  801234:	6a 00                	push   $0x0
  801236:	6a 00                	push   $0x0
  801238:	6a 00                	push   $0x0
  80123a:	6a 00                	push   $0x0
  80123c:	6a 0e                	push   $0xe
  80123e:	e8 82 fe ff ff       	call   8010c5 <syscall>
  801243:	83 c4 18             	add    $0x18,%esp
}
  801246:	90                   	nop
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 11                	push   $0x11
  801258:	e8 68 fe ff ff       	call   8010c5 <syscall>
  80125d:	83 c4 18             	add    $0x18,%esp
}
  801260:	90                   	nop
  801261:	c9                   	leave  
  801262:	c3                   	ret    

00801263 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801266:	6a 00                	push   $0x0
  801268:	6a 00                	push   $0x0
  80126a:	6a 00                	push   $0x0
  80126c:	6a 00                	push   $0x0
  80126e:	6a 00                	push   $0x0
  801270:	6a 12                	push   $0x12
  801272:	e8 4e fe ff ff       	call   8010c5 <syscall>
  801277:	83 c4 18             	add    $0x18,%esp
}
  80127a:	90                   	nop
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <sys_cputc>:


void
sys_cputc(const char c)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 04             	sub    $0x4,%esp
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801289:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	50                   	push   %eax
  801296:	6a 13                	push   $0x13
  801298:	e8 28 fe ff ff       	call   8010c5 <syscall>
  80129d:	83 c4 18             	add    $0x18,%esp
}
  8012a0:	90                   	nop
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 00                	push   $0x0
  8012b0:	6a 14                	push   $0x14
  8012b2:	e8 0e fe ff ff       	call   8010c5 <syscall>
  8012b7:	83 c4 18             	add    $0x18,%esp
}
  8012ba:	90                   	nop
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	6a 00                	push   $0x0
  8012c9:	ff 75 0c             	pushl  0xc(%ebp)
  8012cc:	50                   	push   %eax
  8012cd:	6a 15                	push   $0x15
  8012cf:	e8 f1 fd ff ff       	call   8010c5 <syscall>
  8012d4:	83 c4 18             	add    $0x18,%esp
}
  8012d7:	c9                   	leave  
  8012d8:	c3                   	ret    

008012d9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 00                	push   $0x0
  8012e6:	6a 00                	push   $0x0
  8012e8:	52                   	push   %edx
  8012e9:	50                   	push   %eax
  8012ea:	6a 18                	push   $0x18
  8012ec:	e8 d4 fd ff ff       	call   8010c5 <syscall>
  8012f1:	83 c4 18             	add    $0x18,%esp
}
  8012f4:	c9                   	leave  
  8012f5:	c3                   	ret    

008012f6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	6a 00                	push   $0x0
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	52                   	push   %edx
  801306:	50                   	push   %eax
  801307:	6a 16                	push   $0x16
  801309:	e8 b7 fd ff ff       	call   8010c5 <syscall>
  80130e:	83 c4 18             	add    $0x18,%esp
}
  801311:	90                   	nop
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	52                   	push   %edx
  801324:	50                   	push   %eax
  801325:	6a 17                	push   $0x17
  801327:	e8 99 fd ff ff       	call   8010c5 <syscall>
  80132c:	83 c4 18             	add    $0x18,%esp
}
  80132f:	90                   	nop
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	83 ec 04             	sub    $0x4,%esp
  801338:	8b 45 10             	mov    0x10(%ebp),%eax
  80133b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80133e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801341:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	6a 00                	push   $0x0
  80134a:	51                   	push   %ecx
  80134b:	52                   	push   %edx
  80134c:	ff 75 0c             	pushl  0xc(%ebp)
  80134f:	50                   	push   %eax
  801350:	6a 19                	push   $0x19
  801352:	e8 6e fd ff ff       	call   8010c5 <syscall>
  801357:	83 c4 18             	add    $0x18,%esp
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80135f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	6a 00                	push   $0x0
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	52                   	push   %edx
  80136c:	50                   	push   %eax
  80136d:	6a 1a                	push   $0x1a
  80136f:	e8 51 fd ff ff       	call   8010c5 <syscall>
  801374:	83 c4 18             	add    $0x18,%esp
}
  801377:	c9                   	leave  
  801378:	c3                   	ret    

00801379 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80137c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80137f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	51                   	push   %ecx
  80138a:	52                   	push   %edx
  80138b:	50                   	push   %eax
  80138c:	6a 1b                	push   $0x1b
  80138e:	e8 32 fd ff ff       	call   8010c5 <syscall>
  801393:	83 c4 18             	add    $0x18,%esp
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80139b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	52                   	push   %edx
  8013a8:	50                   	push   %eax
  8013a9:	6a 1c                	push   $0x1c
  8013ab:	e8 15 fd ff ff       	call   8010c5 <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 1d                	push   $0x1d
  8013c4:	e8 fc fc ff ff       	call   8010c5 <syscall>
  8013c9:	83 c4 18             	add    $0x18,%esp
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	6a 00                	push   $0x0
  8013d6:	ff 75 14             	pushl  0x14(%ebp)
  8013d9:	ff 75 10             	pushl  0x10(%ebp)
  8013dc:	ff 75 0c             	pushl  0xc(%ebp)
  8013df:	50                   	push   %eax
  8013e0:	6a 1e                	push   $0x1e
  8013e2:	e8 de fc ff ff       	call   8010c5 <syscall>
  8013e7:	83 c4 18             	add    $0x18,%esp
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	50                   	push   %eax
  8013fb:	6a 1f                	push   $0x1f
  8013fd:	e8 c3 fc ff ff       	call   8010c5 <syscall>
  801402:	83 c4 18             	add    $0x18,%esp
}
  801405:	90                   	nop
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	50                   	push   %eax
  801417:	6a 20                	push   $0x20
  801419:	e8 a7 fc ff ff       	call   8010c5 <syscall>
  80141e:	83 c4 18             	add    $0x18,%esp
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 02                	push   $0x2
  801432:	e8 8e fc ff ff       	call   8010c5 <syscall>
  801437:	83 c4 18             	add    $0x18,%esp
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 03                	push   $0x3
  80144b:	e8 75 fc ff ff       	call   8010c5 <syscall>
  801450:	83 c4 18             	add    $0x18,%esp
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 04                	push   $0x4
  801464:	e8 5c fc ff ff       	call   8010c5 <syscall>
  801469:	83 c4 18             	add    $0x18,%esp
}
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <sys_exit_env>:


void sys_exit_env(void)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 21                	push   $0x21
  80147d:	e8 43 fc ff ff       	call   8010c5 <syscall>
  801482:	83 c4 18             	add    $0x18,%esp
}
  801485:	90                   	nop
  801486:	c9                   	leave  
  801487:	c3                   	ret    

00801488 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80148e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801491:	8d 50 04             	lea    0x4(%eax),%edx
  801494:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	52                   	push   %edx
  80149e:	50                   	push   %eax
  80149f:	6a 22                	push   $0x22
  8014a1:	e8 1f fc ff ff       	call   8010c5 <syscall>
  8014a6:	83 c4 18             	add    $0x18,%esp
	return result;
  8014a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b2:	89 01                	mov    %eax,(%ecx)
  8014b4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	c9                   	leave  
  8014bb:	c2 04 00             	ret    $0x4

008014be <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	ff 75 10             	pushl  0x10(%ebp)
  8014c8:	ff 75 0c             	pushl  0xc(%ebp)
  8014cb:	ff 75 08             	pushl  0x8(%ebp)
  8014ce:	6a 10                	push   $0x10
  8014d0:	e8 f0 fb ff ff       	call   8010c5 <syscall>
  8014d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8014d8:	90                   	nop
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <sys_rcr2>:
uint32 sys_rcr2()
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 23                	push   $0x23
  8014ea:	e8 d6 fb ff ff       	call   8010c5 <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 04             	sub    $0x4,%esp
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801500:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	50                   	push   %eax
  80150d:	6a 24                	push   $0x24
  80150f:	e8 b1 fb ff ff       	call   8010c5 <syscall>
  801514:	83 c4 18             	add    $0x18,%esp
	return ;
  801517:	90                   	nop
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <rsttst>:
void rsttst()
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 26                	push   $0x26
  801529:	e8 97 fb ff ff       	call   8010c5 <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
	return ;
  801531:	90                   	nop
}
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
  801537:	83 ec 04             	sub    $0x4,%esp
  80153a:	8b 45 14             	mov    0x14(%ebp),%eax
  80153d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801540:	8b 55 18             	mov    0x18(%ebp),%edx
  801543:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801547:	52                   	push   %edx
  801548:	50                   	push   %eax
  801549:	ff 75 10             	pushl  0x10(%ebp)
  80154c:	ff 75 0c             	pushl  0xc(%ebp)
  80154f:	ff 75 08             	pushl  0x8(%ebp)
  801552:	6a 25                	push   $0x25
  801554:	e8 6c fb ff ff       	call   8010c5 <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
	return ;
  80155c:	90                   	nop
}
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <chktst>:
void chktst(uint32 n)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	ff 75 08             	pushl  0x8(%ebp)
  80156d:	6a 27                	push   $0x27
  80156f:	e8 51 fb ff ff       	call   8010c5 <syscall>
  801574:	83 c4 18             	add    $0x18,%esp
	return ;
  801577:	90                   	nop
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <inctst>:

void inctst()
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 28                	push   $0x28
  801589:	e8 37 fb ff ff       	call   8010c5 <syscall>
  80158e:	83 c4 18             	add    $0x18,%esp
	return ;
  801591:	90                   	nop
}
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <gettst>:
uint32 gettst()
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 29                	push   $0x29
  8015a3:	e8 1d fb ff ff       	call   8010c5 <syscall>
  8015a8:	83 c4 18             	add    $0x18,%esp
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 2a                	push   $0x2a
  8015bf:	e8 01 fb ff ff       	call   8010c5 <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
  8015c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8015ca:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8015ce:	75 07                	jne    8015d7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8015d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d5:	eb 05                	jmp    8015dc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 2a                	push   $0x2a
  8015f0:	e8 d0 fa ff ff       	call   8010c5 <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
  8015f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015fb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015ff:	75 07                	jne    801608 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801601:	b8 01 00 00 00       	mov    $0x1,%eax
  801606:	eb 05                	jmp    80160d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801608:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 2a                	push   $0x2a
  801621:	e8 9f fa ff ff       	call   8010c5 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
  801629:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80162c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801630:	75 07                	jne    801639 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801632:	b8 01 00 00 00       	mov    $0x1,%eax
  801637:	eb 05                	jmp    80163e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801639:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 2a                	push   $0x2a
  801652:	e8 6e fa ff ff       	call   8010c5 <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
  80165a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80165d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801661:	75 07                	jne    80166a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801663:	b8 01 00 00 00       	mov    $0x1,%eax
  801668:	eb 05                	jmp    80166f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80166a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	ff 75 08             	pushl  0x8(%ebp)
  80167f:	6a 2b                	push   $0x2b
  801681:	e8 3f fa ff ff       	call   8010c5 <syscall>
  801686:	83 c4 18             	add    $0x18,%esp
	return ;
  801689:	90                   	nop
}
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801690:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801693:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801696:	8b 55 0c             	mov    0xc(%ebp),%edx
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	6a 00                	push   $0x0
  80169e:	53                   	push   %ebx
  80169f:	51                   	push   %ecx
  8016a0:	52                   	push   %edx
  8016a1:	50                   	push   %eax
  8016a2:	6a 2c                	push   $0x2c
  8016a4:	e8 1c fa ff ff       	call   8010c5 <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
}
  8016ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	52                   	push   %edx
  8016c1:	50                   	push   %eax
  8016c2:	6a 2d                	push   $0x2d
  8016c4:	e8 fc f9 ff ff       	call   8010c5 <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016d1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	6a 00                	push   $0x0
  8016dc:	51                   	push   %ecx
  8016dd:	ff 75 10             	pushl  0x10(%ebp)
  8016e0:	52                   	push   %edx
  8016e1:	50                   	push   %eax
  8016e2:	6a 2e                	push   $0x2e
  8016e4:	e8 dc f9 ff ff       	call   8010c5 <syscall>
  8016e9:	83 c4 18             	add    $0x18,%esp
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	ff 75 10             	pushl  0x10(%ebp)
  8016f8:	ff 75 0c             	pushl  0xc(%ebp)
  8016fb:	ff 75 08             	pushl  0x8(%ebp)
  8016fe:	6a 0f                	push   $0xf
  801700:	e8 c0 f9 ff ff       	call   8010c5 <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
	return ;
  801708:	90                   	nop
}
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	50                   	push   %eax
  80171a:	6a 2f                	push   $0x2f
  80171c:	e8 a4 f9 ff ff       	call   8010c5 <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	6a 30                	push   $0x30
  801737:	e8 89 f9 ff ff       	call   8010c5 <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  80173f:	90                   	nop
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	ff 75 0c             	pushl  0xc(%ebp)
  80174e:	ff 75 08             	pushl  0x8(%ebp)
  801751:	6a 31                	push   $0x31
  801753:	e8 6d f9 ff ff       	call   8010c5 <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  80175b:	90                   	nop
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    
  80175e:	66 90                	xchg   %ax,%ax

00801760 <__udivdi3>:
  801760:	55                   	push   %ebp
  801761:	57                   	push   %edi
  801762:	56                   	push   %esi
  801763:	53                   	push   %ebx
  801764:	83 ec 1c             	sub    $0x1c,%esp
  801767:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80176b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80176f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801773:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801777:	89 ca                	mov    %ecx,%edx
  801779:	89 f8                	mov    %edi,%eax
  80177b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80177f:	85 f6                	test   %esi,%esi
  801781:	75 2d                	jne    8017b0 <__udivdi3+0x50>
  801783:	39 cf                	cmp    %ecx,%edi
  801785:	77 65                	ja     8017ec <__udivdi3+0x8c>
  801787:	89 fd                	mov    %edi,%ebp
  801789:	85 ff                	test   %edi,%edi
  80178b:	75 0b                	jne    801798 <__udivdi3+0x38>
  80178d:	b8 01 00 00 00       	mov    $0x1,%eax
  801792:	31 d2                	xor    %edx,%edx
  801794:	f7 f7                	div    %edi
  801796:	89 c5                	mov    %eax,%ebp
  801798:	31 d2                	xor    %edx,%edx
  80179a:	89 c8                	mov    %ecx,%eax
  80179c:	f7 f5                	div    %ebp
  80179e:	89 c1                	mov    %eax,%ecx
  8017a0:	89 d8                	mov    %ebx,%eax
  8017a2:	f7 f5                	div    %ebp
  8017a4:	89 cf                	mov    %ecx,%edi
  8017a6:	89 fa                	mov    %edi,%edx
  8017a8:	83 c4 1c             	add    $0x1c,%esp
  8017ab:	5b                   	pop    %ebx
  8017ac:	5e                   	pop    %esi
  8017ad:	5f                   	pop    %edi
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    
  8017b0:	39 ce                	cmp    %ecx,%esi
  8017b2:	77 28                	ja     8017dc <__udivdi3+0x7c>
  8017b4:	0f bd fe             	bsr    %esi,%edi
  8017b7:	83 f7 1f             	xor    $0x1f,%edi
  8017ba:	75 40                	jne    8017fc <__udivdi3+0x9c>
  8017bc:	39 ce                	cmp    %ecx,%esi
  8017be:	72 0a                	jb     8017ca <__udivdi3+0x6a>
  8017c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8017c4:	0f 87 9e 00 00 00    	ja     801868 <__udivdi3+0x108>
  8017ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8017cf:	89 fa                	mov    %edi,%edx
  8017d1:	83 c4 1c             	add    $0x1c,%esp
  8017d4:	5b                   	pop    %ebx
  8017d5:	5e                   	pop    %esi
  8017d6:	5f                   	pop    %edi
  8017d7:	5d                   	pop    %ebp
  8017d8:	c3                   	ret    
  8017d9:	8d 76 00             	lea    0x0(%esi),%esi
  8017dc:	31 ff                	xor    %edi,%edi
  8017de:	31 c0                	xor    %eax,%eax
  8017e0:	89 fa                	mov    %edi,%edx
  8017e2:	83 c4 1c             	add    $0x1c,%esp
  8017e5:	5b                   	pop    %ebx
  8017e6:	5e                   	pop    %esi
  8017e7:	5f                   	pop    %edi
  8017e8:	5d                   	pop    %ebp
  8017e9:	c3                   	ret    
  8017ea:	66 90                	xchg   %ax,%ax
  8017ec:	89 d8                	mov    %ebx,%eax
  8017ee:	f7 f7                	div    %edi
  8017f0:	31 ff                	xor    %edi,%edi
  8017f2:	89 fa                	mov    %edi,%edx
  8017f4:	83 c4 1c             	add    $0x1c,%esp
  8017f7:	5b                   	pop    %ebx
  8017f8:	5e                   	pop    %esi
  8017f9:	5f                   	pop    %edi
  8017fa:	5d                   	pop    %ebp
  8017fb:	c3                   	ret    
  8017fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801801:	89 eb                	mov    %ebp,%ebx
  801803:	29 fb                	sub    %edi,%ebx
  801805:	89 f9                	mov    %edi,%ecx
  801807:	d3 e6                	shl    %cl,%esi
  801809:	89 c5                	mov    %eax,%ebp
  80180b:	88 d9                	mov    %bl,%cl
  80180d:	d3 ed                	shr    %cl,%ebp
  80180f:	89 e9                	mov    %ebp,%ecx
  801811:	09 f1                	or     %esi,%ecx
  801813:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801817:	89 f9                	mov    %edi,%ecx
  801819:	d3 e0                	shl    %cl,%eax
  80181b:	89 c5                	mov    %eax,%ebp
  80181d:	89 d6                	mov    %edx,%esi
  80181f:	88 d9                	mov    %bl,%cl
  801821:	d3 ee                	shr    %cl,%esi
  801823:	89 f9                	mov    %edi,%ecx
  801825:	d3 e2                	shl    %cl,%edx
  801827:	8b 44 24 08          	mov    0x8(%esp),%eax
  80182b:	88 d9                	mov    %bl,%cl
  80182d:	d3 e8                	shr    %cl,%eax
  80182f:	09 c2                	or     %eax,%edx
  801831:	89 d0                	mov    %edx,%eax
  801833:	89 f2                	mov    %esi,%edx
  801835:	f7 74 24 0c          	divl   0xc(%esp)
  801839:	89 d6                	mov    %edx,%esi
  80183b:	89 c3                	mov    %eax,%ebx
  80183d:	f7 e5                	mul    %ebp
  80183f:	39 d6                	cmp    %edx,%esi
  801841:	72 19                	jb     80185c <__udivdi3+0xfc>
  801843:	74 0b                	je     801850 <__udivdi3+0xf0>
  801845:	89 d8                	mov    %ebx,%eax
  801847:	31 ff                	xor    %edi,%edi
  801849:	e9 58 ff ff ff       	jmp    8017a6 <__udivdi3+0x46>
  80184e:	66 90                	xchg   %ax,%ax
  801850:	8b 54 24 08          	mov    0x8(%esp),%edx
  801854:	89 f9                	mov    %edi,%ecx
  801856:	d3 e2                	shl    %cl,%edx
  801858:	39 c2                	cmp    %eax,%edx
  80185a:	73 e9                	jae    801845 <__udivdi3+0xe5>
  80185c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80185f:	31 ff                	xor    %edi,%edi
  801861:	e9 40 ff ff ff       	jmp    8017a6 <__udivdi3+0x46>
  801866:	66 90                	xchg   %ax,%ax
  801868:	31 c0                	xor    %eax,%eax
  80186a:	e9 37 ff ff ff       	jmp    8017a6 <__udivdi3+0x46>
  80186f:	90                   	nop

00801870 <__umoddi3>:
  801870:	55                   	push   %ebp
  801871:	57                   	push   %edi
  801872:	56                   	push   %esi
  801873:	53                   	push   %ebx
  801874:	83 ec 1c             	sub    $0x1c,%esp
  801877:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80187b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80187f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801883:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801887:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80188b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80188f:	89 f3                	mov    %esi,%ebx
  801891:	89 fa                	mov    %edi,%edx
  801893:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801897:	89 34 24             	mov    %esi,(%esp)
  80189a:	85 c0                	test   %eax,%eax
  80189c:	75 1a                	jne    8018b8 <__umoddi3+0x48>
  80189e:	39 f7                	cmp    %esi,%edi
  8018a0:	0f 86 a2 00 00 00    	jbe    801948 <__umoddi3+0xd8>
  8018a6:	89 c8                	mov    %ecx,%eax
  8018a8:	89 f2                	mov    %esi,%edx
  8018aa:	f7 f7                	div    %edi
  8018ac:	89 d0                	mov    %edx,%eax
  8018ae:	31 d2                	xor    %edx,%edx
  8018b0:	83 c4 1c             	add    $0x1c,%esp
  8018b3:	5b                   	pop    %ebx
  8018b4:	5e                   	pop    %esi
  8018b5:	5f                   	pop    %edi
  8018b6:	5d                   	pop    %ebp
  8018b7:	c3                   	ret    
  8018b8:	39 f0                	cmp    %esi,%eax
  8018ba:	0f 87 ac 00 00 00    	ja     80196c <__umoddi3+0xfc>
  8018c0:	0f bd e8             	bsr    %eax,%ebp
  8018c3:	83 f5 1f             	xor    $0x1f,%ebp
  8018c6:	0f 84 ac 00 00 00    	je     801978 <__umoddi3+0x108>
  8018cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8018d1:	29 ef                	sub    %ebp,%edi
  8018d3:	89 fe                	mov    %edi,%esi
  8018d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018d9:	89 e9                	mov    %ebp,%ecx
  8018db:	d3 e0                	shl    %cl,%eax
  8018dd:	89 d7                	mov    %edx,%edi
  8018df:	89 f1                	mov    %esi,%ecx
  8018e1:	d3 ef                	shr    %cl,%edi
  8018e3:	09 c7                	or     %eax,%edi
  8018e5:	89 e9                	mov    %ebp,%ecx
  8018e7:	d3 e2                	shl    %cl,%edx
  8018e9:	89 14 24             	mov    %edx,(%esp)
  8018ec:	89 d8                	mov    %ebx,%eax
  8018ee:	d3 e0                	shl    %cl,%eax
  8018f0:	89 c2                	mov    %eax,%edx
  8018f2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018f6:	d3 e0                	shl    %cl,%eax
  8018f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801900:	89 f1                	mov    %esi,%ecx
  801902:	d3 e8                	shr    %cl,%eax
  801904:	09 d0                	or     %edx,%eax
  801906:	d3 eb                	shr    %cl,%ebx
  801908:	89 da                	mov    %ebx,%edx
  80190a:	f7 f7                	div    %edi
  80190c:	89 d3                	mov    %edx,%ebx
  80190e:	f7 24 24             	mull   (%esp)
  801911:	89 c6                	mov    %eax,%esi
  801913:	89 d1                	mov    %edx,%ecx
  801915:	39 d3                	cmp    %edx,%ebx
  801917:	0f 82 87 00 00 00    	jb     8019a4 <__umoddi3+0x134>
  80191d:	0f 84 91 00 00 00    	je     8019b4 <__umoddi3+0x144>
  801923:	8b 54 24 04          	mov    0x4(%esp),%edx
  801927:	29 f2                	sub    %esi,%edx
  801929:	19 cb                	sbb    %ecx,%ebx
  80192b:	89 d8                	mov    %ebx,%eax
  80192d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801931:	d3 e0                	shl    %cl,%eax
  801933:	89 e9                	mov    %ebp,%ecx
  801935:	d3 ea                	shr    %cl,%edx
  801937:	09 d0                	or     %edx,%eax
  801939:	89 e9                	mov    %ebp,%ecx
  80193b:	d3 eb                	shr    %cl,%ebx
  80193d:	89 da                	mov    %ebx,%edx
  80193f:	83 c4 1c             	add    $0x1c,%esp
  801942:	5b                   	pop    %ebx
  801943:	5e                   	pop    %esi
  801944:	5f                   	pop    %edi
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    
  801947:	90                   	nop
  801948:	89 fd                	mov    %edi,%ebp
  80194a:	85 ff                	test   %edi,%edi
  80194c:	75 0b                	jne    801959 <__umoddi3+0xe9>
  80194e:	b8 01 00 00 00       	mov    $0x1,%eax
  801953:	31 d2                	xor    %edx,%edx
  801955:	f7 f7                	div    %edi
  801957:	89 c5                	mov    %eax,%ebp
  801959:	89 f0                	mov    %esi,%eax
  80195b:	31 d2                	xor    %edx,%edx
  80195d:	f7 f5                	div    %ebp
  80195f:	89 c8                	mov    %ecx,%eax
  801961:	f7 f5                	div    %ebp
  801963:	89 d0                	mov    %edx,%eax
  801965:	e9 44 ff ff ff       	jmp    8018ae <__umoddi3+0x3e>
  80196a:	66 90                	xchg   %ax,%ax
  80196c:	89 c8                	mov    %ecx,%eax
  80196e:	89 f2                	mov    %esi,%edx
  801970:	83 c4 1c             	add    $0x1c,%esp
  801973:	5b                   	pop    %ebx
  801974:	5e                   	pop    %esi
  801975:	5f                   	pop    %edi
  801976:	5d                   	pop    %ebp
  801977:	c3                   	ret    
  801978:	3b 04 24             	cmp    (%esp),%eax
  80197b:	72 06                	jb     801983 <__umoddi3+0x113>
  80197d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801981:	77 0f                	ja     801992 <__umoddi3+0x122>
  801983:	89 f2                	mov    %esi,%edx
  801985:	29 f9                	sub    %edi,%ecx
  801987:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80198b:	89 14 24             	mov    %edx,(%esp)
  80198e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801992:	8b 44 24 04          	mov    0x4(%esp),%eax
  801996:	8b 14 24             	mov    (%esp),%edx
  801999:	83 c4 1c             	add    $0x1c,%esp
  80199c:	5b                   	pop    %ebx
  80199d:	5e                   	pop    %esi
  80199e:	5f                   	pop    %edi
  80199f:	5d                   	pop    %ebp
  8019a0:	c3                   	ret    
  8019a1:	8d 76 00             	lea    0x0(%esi),%esi
  8019a4:	2b 04 24             	sub    (%esp),%eax
  8019a7:	19 fa                	sbb    %edi,%edx
  8019a9:	89 d1                	mov    %edx,%ecx
  8019ab:	89 c6                	mov    %eax,%esi
  8019ad:	e9 71 ff ff ff       	jmp    801923 <__umoddi3+0xb3>
  8019b2:	66 90                	xchg   %ax,%ax
  8019b4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8019b8:	72 ea                	jb     8019a4 <__umoddi3+0x134>
  8019ba:	89 d9                	mov    %ebx,%ecx
  8019bc:	e9 62 ff ff ff       	jmp    801923 <__umoddi3+0xb3>
