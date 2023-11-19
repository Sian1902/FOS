
obj/user/fos_helloWorld:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	extern unsigned char * etext;
	//cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D %d\n",4);
	atomic_cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D \n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 80 19 80 00       	push   $0x801980
  800046:	e8 62 02 00 00       	call   8002ad <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	atomic_cprintf("end of code = %x\n",etext);
  80004e:	a1 79 19 80 00       	mov    0x801979,%eax
  800053:	83 ec 08             	sub    $0x8,%esp
  800056:	50                   	push   %eax
  800057:	68 a8 19 80 00       	push   $0x8019a8
  80005c:	e8 4c 02 00 00       	call   8002ad <atomic_cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
}
  800064:	90                   	nop
  800065:	c9                   	leave  
  800066:	c3                   	ret    

00800067 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006d:	e8 82 13 00 00       	call   8013f4 <sys_getenvindex>
  800072:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800078:	89 d0                	mov    %edx,%eax
  80007a:	01 c0                	add    %eax,%eax
  80007c:	01 d0                	add    %edx,%eax
  80007e:	01 c0                	add    %eax,%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	c1 e0 02             	shl    $0x2,%eax
  800085:	01 d0                	add    %edx,%eax
  800087:	01 c0                	add    %eax,%eax
  800089:	01 d0                	add    %edx,%eax
  80008b:	c1 e0 02             	shl    $0x2,%eax
  80008e:	01 d0                	add    %edx,%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	01 d0                	add    %edx,%eax
  800095:	c1 e0 02             	shl    $0x2,%eax
  800098:	01 d0                	add    %edx,%eax
  80009a:	c1 e0 05             	shl    $0x5,%eax
  80009d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a2:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000a7:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ac:	8a 40 5c             	mov    0x5c(%eax),%al
  8000af:	84 c0                	test   %al,%al
  8000b1:	74 0d                	je     8000c0 <libmain+0x59>
		binaryname = myEnv->prog_name;
  8000b3:	a1 20 20 80 00       	mov    0x802020,%eax
  8000b8:	83 c0 5c             	add    $0x5c,%eax
  8000bb:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000c4:	7e 0a                	jle    8000d0 <libmain+0x69>
		binaryname = argv[0];
  8000c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c9:	8b 00                	mov    (%eax),%eax
  8000cb:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	ff 75 0c             	pushl  0xc(%ebp)
  8000d6:	ff 75 08             	pushl  0x8(%ebp)
  8000d9:	e8 5a ff ff ff       	call   800038 <_main>
  8000de:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000e1:	e8 1b 11 00 00       	call   801201 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 d4 19 80 00       	push   $0x8019d4
  8000ee:	e8 8d 01 00 00       	call   800280 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000f6:	a1 20 20 80 00       	mov    0x802020,%eax
  8000fb:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  800101:	a1 20 20 80 00       	mov    0x802020,%eax
  800106:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	52                   	push   %edx
  800110:	50                   	push   %eax
  800111:	68 fc 19 80 00       	push   $0x8019fc
  800116:	e8 65 01 00 00       	call   800280 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80011e:	a1 20 20 80 00       	mov    0x802020,%eax
  800123:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  800129:	a1 20 20 80 00       	mov    0x802020,%eax
  80012e:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  800134:	a1 20 20 80 00       	mov    0x802020,%eax
  800139:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  80013f:	51                   	push   %ecx
  800140:	52                   	push   %edx
  800141:	50                   	push   %eax
  800142:	68 24 1a 80 00       	push   $0x801a24
  800147:	e8 34 01 00 00       	call   800280 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80014f:	a1 20 20 80 00       	mov    0x802020,%eax
  800154:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  80015a:	83 ec 08             	sub    $0x8,%esp
  80015d:	50                   	push   %eax
  80015e:	68 7c 1a 80 00       	push   $0x801a7c
  800163:	e8 18 01 00 00       	call   800280 <cprintf>
  800168:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80016b:	83 ec 0c             	sub    $0xc,%esp
  80016e:	68 d4 19 80 00       	push   $0x8019d4
  800173:	e8 08 01 00 00       	call   800280 <cprintf>
  800178:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80017b:	e8 9b 10 00 00       	call   80121b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800180:	e8 19 00 00 00       	call   80019e <exit>
}
  800185:	90                   	nop
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	6a 00                	push   $0x0
  800193:	e8 28 12 00 00       	call   8013c0 <sys_destroy_env>
  800198:	83 c4 10             	add    $0x10,%esp
}
  80019b:	90                   	nop
  80019c:	c9                   	leave  
  80019d:	c3                   	ret    

0080019e <exit>:

void
exit(void)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001a4:	e8 7d 12 00 00       	call   801426 <sys_exit_env>
}
  8001a9:	90                   	nop
  8001aa:	c9                   	leave  
  8001ab:	c3                   	ret    

008001ac <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b5:	8b 00                	mov    (%eax),%eax
  8001b7:	8d 48 01             	lea    0x1(%eax),%ecx
  8001ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bd:	89 0a                	mov    %ecx,(%edx)
  8001bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c2:	88 d1                	mov    %dl,%cl
  8001c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ce:	8b 00                	mov    (%eax),%eax
  8001d0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001d5:	75 2c                	jne    800203 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001d7:	a0 24 20 80 00       	mov    0x802024,%al
  8001dc:	0f b6 c0             	movzbl %al,%eax
  8001df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e2:	8b 12                	mov    (%edx),%edx
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e9:	83 c2 08             	add    $0x8,%edx
  8001ec:	83 ec 04             	sub    $0x4,%esp
  8001ef:	50                   	push   %eax
  8001f0:	51                   	push   %ecx
  8001f1:	52                   	push   %edx
  8001f2:	e8 b1 0e 00 00       	call   8010a8 <sys_cputs>
  8001f7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
  800206:	8b 40 04             	mov    0x4(%eax),%eax
  800209:	8d 50 01             	lea    0x1(%eax),%edx
  80020c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800212:	90                   	nop
  800213:	c9                   	leave  
  800214:	c3                   	ret    

00800215 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80021e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800225:	00 00 00 
	b.cnt = 0;
  800228:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800232:	ff 75 0c             	pushl  0xc(%ebp)
  800235:	ff 75 08             	pushl  0x8(%ebp)
  800238:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023e:	50                   	push   %eax
  80023f:	68 ac 01 80 00       	push   $0x8001ac
  800244:	e8 11 02 00 00       	call   80045a <vprintfmt>
  800249:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80024c:	a0 24 20 80 00       	mov    0x802024,%al
  800251:	0f b6 c0             	movzbl %al,%eax
  800254:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80025a:	83 ec 04             	sub    $0x4,%esp
  80025d:	50                   	push   %eax
  80025e:	52                   	push   %edx
  80025f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800265:	83 c0 08             	add    $0x8,%eax
  800268:	50                   	push   %eax
  800269:	e8 3a 0e 00 00       	call   8010a8 <sys_cputs>
  80026e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800271:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  800278:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80027e:	c9                   	leave  
  80027f:	c3                   	ret    

00800280 <cprintf>:

int cprintf(const char *fmt, ...) {
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800286:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  80028d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800290:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800293:	8b 45 08             	mov    0x8(%ebp),%eax
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	ff 75 f4             	pushl  -0xc(%ebp)
  80029c:	50                   	push   %eax
  80029d:	e8 73 ff ff ff       	call   800215 <vcprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002b3:	e8 49 0f 00 00       	call   801201 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002b8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c7:	50                   	push   %eax
  8002c8:	e8 48 ff ff ff       	call   800215 <vcprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
  8002d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002d3:	e8 43 0f 00 00       	call   80121b <sys_enable_interrupt>
	return cnt;
  8002d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	53                   	push   %ebx
  8002e1:	83 ec 14             	sub    $0x14,%esp
  8002e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002f0:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002fb:	77 55                	ja     800352 <printnum+0x75>
  8002fd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800300:	72 05                	jb     800307 <printnum+0x2a>
  800302:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800305:	77 4b                	ja     800352 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800307:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80030a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80030d:	8b 45 18             	mov    0x18(%ebp),%eax
  800310:	ba 00 00 00 00       	mov    $0x0,%edx
  800315:	52                   	push   %edx
  800316:	50                   	push   %eax
  800317:	ff 75 f4             	pushl  -0xc(%ebp)
  80031a:	ff 75 f0             	pushl  -0x10(%ebp)
  80031d:	e8 f6 13 00 00       	call   801718 <__udivdi3>
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 20             	pushl  0x20(%ebp)
  80032b:	53                   	push   %ebx
  80032c:	ff 75 18             	pushl  0x18(%ebp)
  80032f:	52                   	push   %edx
  800330:	50                   	push   %eax
  800331:	ff 75 0c             	pushl  0xc(%ebp)
  800334:	ff 75 08             	pushl  0x8(%ebp)
  800337:	e8 a1 ff ff ff       	call   8002dd <printnum>
  80033c:	83 c4 20             	add    $0x20,%esp
  80033f:	eb 1a                	jmp    80035b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	ff 75 0c             	pushl  0xc(%ebp)
  800347:	ff 75 20             	pushl  0x20(%ebp)
  80034a:	8b 45 08             	mov    0x8(%ebp),%eax
  80034d:	ff d0                	call   *%eax
  80034f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800352:	ff 4d 1c             	decl   0x1c(%ebp)
  800355:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800359:	7f e6                	jg     800341 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80035b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80035e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800363:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800366:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800369:	53                   	push   %ebx
  80036a:	51                   	push   %ecx
  80036b:	52                   	push   %edx
  80036c:	50                   	push   %eax
  80036d:	e8 b6 14 00 00       	call   801828 <__umoddi3>
  800372:	83 c4 10             	add    $0x10,%esp
  800375:	05 b4 1c 80 00       	add    $0x801cb4,%eax
  80037a:	8a 00                	mov    (%eax),%al
  80037c:	0f be c0             	movsbl %al,%eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 0c             	pushl  0xc(%ebp)
  800385:	50                   	push   %eax
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	ff d0                	call   *%eax
  80038b:	83 c4 10             	add    $0x10,%esp
}
  80038e:	90                   	nop
  80038f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800392:	c9                   	leave  
  800393:	c3                   	ret    

00800394 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800397:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80039b:	7e 1c                	jle    8003b9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80039d:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a0:	8b 00                	mov    (%eax),%eax
  8003a2:	8d 50 08             	lea    0x8(%eax),%edx
  8003a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a8:	89 10                	mov    %edx,(%eax)
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ad:	8b 00                	mov    (%eax),%eax
  8003af:	83 e8 08             	sub    $0x8,%eax
  8003b2:	8b 50 04             	mov    0x4(%eax),%edx
  8003b5:	8b 00                	mov    (%eax),%eax
  8003b7:	eb 40                	jmp    8003f9 <getuint+0x65>
	else if (lflag)
  8003b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003bd:	74 1e                	je     8003dd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	8d 50 04             	lea    0x4(%eax),%edx
  8003c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ca:	89 10                	mov    %edx,(%eax)
  8003cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cf:	8b 00                	mov    (%eax),%eax
  8003d1:	83 e8 04             	sub    $0x4,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003db:	eb 1c                	jmp    8003f9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e0:	8b 00                	mov    (%eax),%eax
  8003e2:	8d 50 04             	lea    0x4(%eax),%edx
  8003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e8:	89 10                	mov    %edx,(%eax)
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	8b 00                	mov    (%eax),%eax
  8003ef:	83 e8 04             	sub    $0x4,%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003f9:	5d                   	pop    %ebp
  8003fa:	c3                   	ret    

008003fb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003fe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800402:	7e 1c                	jle    800420 <getint+0x25>
		return va_arg(*ap, long long);
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	8b 00                	mov    (%eax),%eax
  800409:	8d 50 08             	lea    0x8(%eax),%edx
  80040c:	8b 45 08             	mov    0x8(%ebp),%eax
  80040f:	89 10                	mov    %edx,(%eax)
  800411:	8b 45 08             	mov    0x8(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	83 e8 08             	sub    $0x8,%eax
  800419:	8b 50 04             	mov    0x4(%eax),%edx
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	eb 38                	jmp    800458 <getint+0x5d>
	else if (lflag)
  800420:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800424:	74 1a                	je     800440 <getint+0x45>
		return va_arg(*ap, long);
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	8d 50 04             	lea    0x4(%eax),%edx
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	89 10                	mov    %edx,(%eax)
  800433:	8b 45 08             	mov    0x8(%ebp),%eax
  800436:	8b 00                	mov    (%eax),%eax
  800438:	83 e8 04             	sub    $0x4,%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	99                   	cltd   
  80043e:	eb 18                	jmp    800458 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	8b 00                	mov    (%eax),%eax
  800445:	8d 50 04             	lea    0x4(%eax),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	89 10                	mov    %edx,(%eax)
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	8b 00                	mov    (%eax),%eax
  800452:	83 e8 04             	sub    $0x4,%eax
  800455:	8b 00                	mov    (%eax),%eax
  800457:	99                   	cltd   
}
  800458:	5d                   	pop    %ebp
  800459:	c3                   	ret    

0080045a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	56                   	push   %esi
  80045e:	53                   	push   %ebx
  80045f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800462:	eb 17                	jmp    80047b <vprintfmt+0x21>
			if (ch == '\0')
  800464:	85 db                	test   %ebx,%ebx
  800466:	0f 84 af 03 00 00    	je     80081b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	ff 75 0c             	pushl  0xc(%ebp)
  800472:	53                   	push   %ebx
  800473:	8b 45 08             	mov    0x8(%ebp),%eax
  800476:	ff d0                	call   *%eax
  800478:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80047b:	8b 45 10             	mov    0x10(%ebp),%eax
  80047e:	8d 50 01             	lea    0x1(%eax),%edx
  800481:	89 55 10             	mov    %edx,0x10(%ebp)
  800484:	8a 00                	mov    (%eax),%al
  800486:	0f b6 d8             	movzbl %al,%ebx
  800489:	83 fb 25             	cmp    $0x25,%ebx
  80048c:	75 d6                	jne    800464 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80048e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800492:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800499:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004a7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b1:	8d 50 01             	lea    0x1(%eax),%edx
  8004b4:	89 55 10             	mov    %edx,0x10(%ebp)
  8004b7:	8a 00                	mov    (%eax),%al
  8004b9:	0f b6 d8             	movzbl %al,%ebx
  8004bc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004bf:	83 f8 55             	cmp    $0x55,%eax
  8004c2:	0f 87 2b 03 00 00    	ja     8007f3 <vprintfmt+0x399>
  8004c8:	8b 04 85 d8 1c 80 00 	mov    0x801cd8(,%eax,4),%eax
  8004cf:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004d1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004d5:	eb d7                	jmp    8004ae <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004d7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004db:	eb d1                	jmp    8004ae <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004dd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e7:	89 d0                	mov    %edx,%eax
  8004e9:	c1 e0 02             	shl    $0x2,%eax
  8004ec:	01 d0                	add    %edx,%eax
  8004ee:	01 c0                	add    %eax,%eax
  8004f0:	01 d8                	add    %ebx,%eax
  8004f2:	83 e8 30             	sub    $0x30,%eax
  8004f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fb:	8a 00                	mov    (%eax),%al
  8004fd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800500:	83 fb 2f             	cmp    $0x2f,%ebx
  800503:	7e 3e                	jle    800543 <vprintfmt+0xe9>
  800505:	83 fb 39             	cmp    $0x39,%ebx
  800508:	7f 39                	jg     800543 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80050a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80050d:	eb d5                	jmp    8004e4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	83 c0 04             	add    $0x4,%eax
  800515:	89 45 14             	mov    %eax,0x14(%ebp)
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	83 e8 04             	sub    $0x4,%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800523:	eb 1f                	jmp    800544 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800525:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800529:	79 83                	jns    8004ae <vprintfmt+0x54>
				width = 0;
  80052b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800532:	e9 77 ff ff ff       	jmp    8004ae <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800537:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80053e:	e9 6b ff ff ff       	jmp    8004ae <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800543:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800544:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800548:	0f 89 60 ff ff ff    	jns    8004ae <vprintfmt+0x54>
				width = precision, precision = -1;
  80054e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800551:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800554:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80055b:	e9 4e ff ff ff       	jmp    8004ae <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800560:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800563:	e9 46 ff ff ff       	jmp    8004ae <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	83 c0 04             	add    $0x4,%eax
  80056e:	89 45 14             	mov    %eax,0x14(%ebp)
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	83 e8 04             	sub    $0x4,%eax
  800577:	8b 00                	mov    (%eax),%eax
  800579:	83 ec 08             	sub    $0x8,%esp
  80057c:	ff 75 0c             	pushl  0xc(%ebp)
  80057f:	50                   	push   %eax
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	ff d0                	call   *%eax
  800585:	83 c4 10             	add    $0x10,%esp
			break;
  800588:	e9 89 02 00 00       	jmp    800816 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	83 c0 04             	add    $0x4,%eax
  800593:	89 45 14             	mov    %eax,0x14(%ebp)
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	83 e8 04             	sub    $0x4,%eax
  80059c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80059e:	85 db                	test   %ebx,%ebx
  8005a0:	79 02                	jns    8005a4 <vprintfmt+0x14a>
				err = -err;
  8005a2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005a4:	83 fb 64             	cmp    $0x64,%ebx
  8005a7:	7f 0b                	jg     8005b4 <vprintfmt+0x15a>
  8005a9:	8b 34 9d 20 1b 80 00 	mov    0x801b20(,%ebx,4),%esi
  8005b0:	85 f6                	test   %esi,%esi
  8005b2:	75 19                	jne    8005cd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005b4:	53                   	push   %ebx
  8005b5:	68 c5 1c 80 00       	push   $0x801cc5
  8005ba:	ff 75 0c             	pushl  0xc(%ebp)
  8005bd:	ff 75 08             	pushl  0x8(%ebp)
  8005c0:	e8 5e 02 00 00       	call   800823 <printfmt>
  8005c5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005c8:	e9 49 02 00 00       	jmp    800816 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005cd:	56                   	push   %esi
  8005ce:	68 ce 1c 80 00       	push   $0x801cce
  8005d3:	ff 75 0c             	pushl  0xc(%ebp)
  8005d6:	ff 75 08             	pushl  0x8(%ebp)
  8005d9:	e8 45 02 00 00       	call   800823 <printfmt>
  8005de:	83 c4 10             	add    $0x10,%esp
			break;
  8005e1:	e9 30 02 00 00       	jmp    800816 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	83 c0 04             	add    $0x4,%eax
  8005ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	83 e8 04             	sub    $0x4,%eax
  8005f5:	8b 30                	mov    (%eax),%esi
  8005f7:	85 f6                	test   %esi,%esi
  8005f9:	75 05                	jne    800600 <vprintfmt+0x1a6>
				p = "(null)";
  8005fb:	be d1 1c 80 00       	mov    $0x801cd1,%esi
			if (width > 0 && padc != '-')
  800600:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800604:	7e 6d                	jle    800673 <vprintfmt+0x219>
  800606:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80060a:	74 67                	je     800673 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80060c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80060f:	83 ec 08             	sub    $0x8,%esp
  800612:	50                   	push   %eax
  800613:	56                   	push   %esi
  800614:	e8 0c 03 00 00       	call   800925 <strnlen>
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80061f:	eb 16                	jmp    800637 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800621:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	ff 75 0c             	pushl  0xc(%ebp)
  80062b:	50                   	push   %eax
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	ff d0                	call   *%eax
  800631:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800634:	ff 4d e4             	decl   -0x1c(%ebp)
  800637:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80063b:	7f e4                	jg     800621 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80063d:	eb 34                	jmp    800673 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80063f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800643:	74 1c                	je     800661 <vprintfmt+0x207>
  800645:	83 fb 1f             	cmp    $0x1f,%ebx
  800648:	7e 05                	jle    80064f <vprintfmt+0x1f5>
  80064a:	83 fb 7e             	cmp    $0x7e,%ebx
  80064d:	7e 12                	jle    800661 <vprintfmt+0x207>
					putch('?', putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	ff 75 0c             	pushl  0xc(%ebp)
  800655:	6a 3f                	push   $0x3f
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	ff d0                	call   *%eax
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	eb 0f                	jmp    800670 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	ff 75 0c             	pushl  0xc(%ebp)
  800667:	53                   	push   %ebx
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	ff d0                	call   *%eax
  80066d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800670:	ff 4d e4             	decl   -0x1c(%ebp)
  800673:	89 f0                	mov    %esi,%eax
  800675:	8d 70 01             	lea    0x1(%eax),%esi
  800678:	8a 00                	mov    (%eax),%al
  80067a:	0f be d8             	movsbl %al,%ebx
  80067d:	85 db                	test   %ebx,%ebx
  80067f:	74 24                	je     8006a5 <vprintfmt+0x24b>
  800681:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800685:	78 b8                	js     80063f <vprintfmt+0x1e5>
  800687:	ff 4d e0             	decl   -0x20(%ebp)
  80068a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80068e:	79 af                	jns    80063f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800690:	eb 13                	jmp    8006a5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 0c             	pushl  0xc(%ebp)
  800698:	6a 20                	push   $0x20
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	ff d0                	call   *%eax
  80069f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006a2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a9:	7f e7                	jg     800692 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006ab:	e9 66 01 00 00       	jmp    800816 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8006b6:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b9:	50                   	push   %eax
  8006ba:	e8 3c fd ff ff       	call   8003fb <getint>
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ce:	85 d2                	test   %edx,%edx
  8006d0:	79 23                	jns    8006f5 <vprintfmt+0x29b>
				putch('-', putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	ff 75 0c             	pushl  0xc(%ebp)
  8006d8:	6a 2d                	push   $0x2d
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	ff d0                	call   *%eax
  8006df:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e8:	f7 d8                	neg    %eax
  8006ea:	83 d2 00             	adc    $0x0,%edx
  8006ed:	f7 da                	neg    %edx
  8006ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006f5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006fc:	e9 bc 00 00 00       	jmp    8007bd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	ff 75 e8             	pushl  -0x18(%ebp)
  800707:	8d 45 14             	lea    0x14(%ebp),%eax
  80070a:	50                   	push   %eax
  80070b:	e8 84 fc ff ff       	call   800394 <getuint>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800716:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800719:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800720:	e9 98 00 00 00       	jmp    8007bd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	ff 75 0c             	pushl  0xc(%ebp)
  80072b:	6a 58                	push   $0x58
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	ff d0                	call   *%eax
  800732:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	ff 75 0c             	pushl  0xc(%ebp)
  80073b:	6a 58                	push   $0x58
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	ff d0                	call   *%eax
  800742:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	ff 75 0c             	pushl  0xc(%ebp)
  80074b:	6a 58                	push   $0x58
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	ff d0                	call   *%eax
  800752:	83 c4 10             	add    $0x10,%esp
			break;
  800755:	e9 bc 00 00 00       	jmp    800816 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	6a 30                	push   $0x30
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	ff d0                	call   *%eax
  800767:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	6a 78                	push   $0x78
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	ff d0                	call   *%eax
  800777:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	83 c0 04             	add    $0x4,%eax
  800780:	89 45 14             	mov    %eax,0x14(%ebp)
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	83 e8 04             	sub    $0x4,%eax
  800789:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80078b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800795:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80079c:	eb 1f                	jmp    8007bd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	ff 75 e8             	pushl  -0x18(%ebp)
  8007a4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a7:	50                   	push   %eax
  8007a8:	e8 e7 fb ff ff       	call   800394 <getuint>
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007b6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007bd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007c4:	83 ec 04             	sub    $0x4,%esp
  8007c7:	52                   	push   %edx
  8007c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007cb:	50                   	push   %eax
  8007cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8007d2:	ff 75 0c             	pushl  0xc(%ebp)
  8007d5:	ff 75 08             	pushl  0x8(%ebp)
  8007d8:	e8 00 fb ff ff       	call   8002dd <printnum>
  8007dd:	83 c4 20             	add    $0x20,%esp
			break;
  8007e0:	eb 34                	jmp    800816 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	ff 75 0c             	pushl  0xc(%ebp)
  8007e8:	53                   	push   %ebx
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	ff d0                	call   *%eax
  8007ee:	83 c4 10             	add    $0x10,%esp
			break;
  8007f1:	eb 23                	jmp    800816 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	ff 75 0c             	pushl  0xc(%ebp)
  8007f9:	6a 25                	push   $0x25
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	ff d0                	call   *%eax
  800800:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800803:	ff 4d 10             	decl   0x10(%ebp)
  800806:	eb 03                	jmp    80080b <vprintfmt+0x3b1>
  800808:	ff 4d 10             	decl   0x10(%ebp)
  80080b:	8b 45 10             	mov    0x10(%ebp),%eax
  80080e:	48                   	dec    %eax
  80080f:	8a 00                	mov    (%eax),%al
  800811:	3c 25                	cmp    $0x25,%al
  800813:	75 f3                	jne    800808 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800815:	90                   	nop
		}
	}
  800816:	e9 47 fc ff ff       	jmp    800462 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80081b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80081c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80081f:	5b                   	pop    %ebx
  800820:	5e                   	pop    %esi
  800821:	5d                   	pop    %ebp
  800822:	c3                   	ret    

00800823 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
  800826:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800829:	8d 45 10             	lea    0x10(%ebp),%eax
  80082c:	83 c0 04             	add    $0x4,%eax
  80082f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800832:	8b 45 10             	mov    0x10(%ebp),%eax
  800835:	ff 75 f4             	pushl  -0xc(%ebp)
  800838:	50                   	push   %eax
  800839:	ff 75 0c             	pushl  0xc(%ebp)
  80083c:	ff 75 08             	pushl  0x8(%ebp)
  80083f:	e8 16 fc ff ff       	call   80045a <vprintfmt>
  800844:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800847:	90                   	nop
  800848:	c9                   	leave  
  800849:	c3                   	ret    

0080084a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80084a:	55                   	push   %ebp
  80084b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80084d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800850:	8b 40 08             	mov    0x8(%eax),%eax
  800853:	8d 50 01             	lea    0x1(%eax),%edx
  800856:	8b 45 0c             	mov    0xc(%ebp),%eax
  800859:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80085c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085f:	8b 10                	mov    (%eax),%edx
  800861:	8b 45 0c             	mov    0xc(%ebp),%eax
  800864:	8b 40 04             	mov    0x4(%eax),%eax
  800867:	39 c2                	cmp    %eax,%edx
  800869:	73 12                	jae    80087d <sprintputch+0x33>
		*b->buf++ = ch;
  80086b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086e:	8b 00                	mov    (%eax),%eax
  800870:	8d 48 01             	lea    0x1(%eax),%ecx
  800873:	8b 55 0c             	mov    0xc(%ebp),%edx
  800876:	89 0a                	mov    %ecx,(%edx)
  800878:	8b 55 08             	mov    0x8(%ebp),%edx
  80087b:	88 10                	mov    %dl,(%eax)
}
  80087d:	90                   	nop
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    

00800880 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80088c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	01 d0                	add    %edx,%eax
  800897:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008a5:	74 06                	je     8008ad <vsnprintf+0x2d>
  8008a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ab:	7f 07                	jg     8008b4 <vsnprintf+0x34>
		return -E_INVAL;
  8008ad:	b8 03 00 00 00       	mov    $0x3,%eax
  8008b2:	eb 20                	jmp    8008d4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b4:	ff 75 14             	pushl  0x14(%ebp)
  8008b7:	ff 75 10             	pushl  0x10(%ebp)
  8008ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008bd:	50                   	push   %eax
  8008be:	68 4a 08 80 00       	push   $0x80084a
  8008c3:	e8 92 fb ff ff       	call   80045a <vprintfmt>
  8008c8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ce:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008d4:	c9                   	leave  
  8008d5:	c3                   	ret    

008008d6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008dc:	8d 45 10             	lea    0x10(%ebp),%eax
  8008df:	83 c0 04             	add    $0x4,%eax
  8008e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8008eb:	50                   	push   %eax
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	ff 75 08             	pushl  0x8(%ebp)
  8008f2:	e8 89 ff ff ff       	call   800880 <vsnprintf>
  8008f7:	83 c4 10             	add    $0x10,%esp
  8008fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800900:	c9                   	leave  
  800901:	c3                   	ret    

00800902 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800908:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80090f:	eb 06                	jmp    800917 <strlen+0x15>
		n++;
  800911:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800914:	ff 45 08             	incl   0x8(%ebp)
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	8a 00                	mov    (%eax),%al
  80091c:	84 c0                	test   %al,%al
  80091e:	75 f1                	jne    800911 <strlen+0xf>
		n++;
	return n;
  800920:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800923:	c9                   	leave  
  800924:	c3                   	ret    

00800925 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800932:	eb 09                	jmp    80093d <strnlen+0x18>
		n++;
  800934:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800937:	ff 45 08             	incl   0x8(%ebp)
  80093a:	ff 4d 0c             	decl   0xc(%ebp)
  80093d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800941:	74 09                	je     80094c <strnlen+0x27>
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	8a 00                	mov    (%eax),%al
  800948:	84 c0                	test   %al,%al
  80094a:	75 e8                	jne    800934 <strnlen+0xf>
		n++;
	return n;
  80094c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80094f:	c9                   	leave  
  800950:	c3                   	ret    

00800951 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80095d:	90                   	nop
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8d 50 01             	lea    0x1(%eax),%edx
  800964:	89 55 08             	mov    %edx,0x8(%ebp)
  800967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80096d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800970:	8a 12                	mov    (%edx),%dl
  800972:	88 10                	mov    %dl,(%eax)
  800974:	8a 00                	mov    (%eax),%al
  800976:	84 c0                	test   %al,%al
  800978:	75 e4                	jne    80095e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80097a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80097d:	c9                   	leave  
  80097e:	c3                   	ret    

0080097f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80098b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800992:	eb 1f                	jmp    8009b3 <strncpy+0x34>
		*dst++ = *src;
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	8d 50 01             	lea    0x1(%eax),%edx
  80099a:	89 55 08             	mov    %edx,0x8(%ebp)
  80099d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a0:	8a 12                	mov    (%edx),%dl
  8009a2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a7:	8a 00                	mov    (%eax),%al
  8009a9:	84 c0                	test   %al,%al
  8009ab:	74 03                	je     8009b0 <strncpy+0x31>
			src++;
  8009ad:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b0:	ff 45 fc             	incl   -0x4(%ebp)
  8009b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009b6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009b9:	72 d9                	jb     800994 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009be:	c9                   	leave  
  8009bf:	c3                   	ret    

008009c0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009d0:	74 30                	je     800a02 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009d2:	eb 16                	jmp    8009ea <strlcpy+0x2a>
			*dst++ = *src++;
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	8d 50 01             	lea    0x1(%eax),%edx
  8009da:	89 55 08             	mov    %edx,0x8(%ebp)
  8009dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009e3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009e6:	8a 12                	mov    (%edx),%dl
  8009e8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009ea:	ff 4d 10             	decl   0x10(%ebp)
  8009ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009f1:	74 09                	je     8009fc <strlcpy+0x3c>
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f6:	8a 00                	mov    (%eax),%al
  8009f8:	84 c0                	test   %al,%al
  8009fa:	75 d8                	jne    8009d4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a02:	8b 55 08             	mov    0x8(%ebp),%edx
  800a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a08:	29 c2                	sub    %eax,%edx
  800a0a:	89 d0                	mov    %edx,%eax
}
  800a0c:	c9                   	leave  
  800a0d:	c3                   	ret    

00800a0e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a11:	eb 06                	jmp    800a19 <strcmp+0xb>
		p++, q++;
  800a13:	ff 45 08             	incl   0x8(%ebp)
  800a16:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8a 00                	mov    (%eax),%al
  800a1e:	84 c0                	test   %al,%al
  800a20:	74 0e                	je     800a30 <strcmp+0x22>
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8a 10                	mov    (%eax),%dl
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	8a 00                	mov    (%eax),%al
  800a2c:	38 c2                	cmp    %al,%dl
  800a2e:	74 e3                	je     800a13 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8a 00                	mov    (%eax),%al
  800a35:	0f b6 d0             	movzbl %al,%edx
  800a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3b:	8a 00                	mov    (%eax),%al
  800a3d:	0f b6 c0             	movzbl %al,%eax
  800a40:	29 c2                	sub    %eax,%edx
  800a42:	89 d0                	mov    %edx,%eax
}
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a49:	eb 09                	jmp    800a54 <strncmp+0xe>
		n--, p++, q++;
  800a4b:	ff 4d 10             	decl   0x10(%ebp)
  800a4e:	ff 45 08             	incl   0x8(%ebp)
  800a51:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a58:	74 17                	je     800a71 <strncmp+0x2b>
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8a 00                	mov    (%eax),%al
  800a5f:	84 c0                	test   %al,%al
  800a61:	74 0e                	je     800a71 <strncmp+0x2b>
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	8a 10                	mov    (%eax),%dl
  800a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6b:	8a 00                	mov    (%eax),%al
  800a6d:	38 c2                	cmp    %al,%dl
  800a6f:	74 da                	je     800a4b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a75:	75 07                	jne    800a7e <strncmp+0x38>
		return 0;
  800a77:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7c:	eb 14                	jmp    800a92 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	8a 00                	mov    (%eax),%al
  800a83:	0f b6 d0             	movzbl %al,%edx
  800a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a89:	8a 00                	mov    (%eax),%al
  800a8b:	0f b6 c0             	movzbl %al,%eax
  800a8e:	29 c2                	sub    %eax,%edx
  800a90:	89 d0                	mov    %edx,%eax
}
  800a92:	5d                   	pop    %ebp
  800a93:	c3                   	ret    

00800a94 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	83 ec 04             	sub    $0x4,%esp
  800a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aa0:	eb 12                	jmp    800ab4 <strchr+0x20>
		if (*s == c)
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8a 00                	mov    (%eax),%al
  800aa7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800aaa:	75 05                	jne    800ab1 <strchr+0x1d>
			return (char *) s;
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	eb 11                	jmp    800ac2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ab1:	ff 45 08             	incl   0x8(%ebp)
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	8a 00                	mov    (%eax),%al
  800ab9:	84 c0                	test   %al,%al
  800abb:	75 e5                	jne    800aa2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800abd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 04             	sub    $0x4,%esp
  800aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ad0:	eb 0d                	jmp    800adf <strfind+0x1b>
		if (*s == c)
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	8a 00                	mov    (%eax),%al
  800ad7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ada:	74 0e                	je     800aea <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800adc:	ff 45 08             	incl   0x8(%ebp)
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	8a 00                	mov    (%eax),%al
  800ae4:	84 c0                	test   %al,%al
  800ae6:	75 ea                	jne    800ad2 <strfind+0xe>
  800ae8:	eb 01                	jmp    800aeb <strfind+0x27>
		if (*s == c)
			break;
  800aea:	90                   	nop
	return (char *) s;
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <memset>:

int i=0;
void *
memset(void *v, int c, uint32 n)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	83 ec 10             	sub    $0x10,%esp


	i++;
  800af6:	a1 28 20 80 00       	mov    0x802028,%eax
  800afb:	40                   	inc    %eax
  800afc:	a3 28 20 80 00       	mov    %eax,0x802028

	char *p;
	int m;

	p = v;
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b07:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0a:	89 45 f8             	mov    %eax,-0x8(%ebp)


	while (--m >= 0){
  800b0d:	eb 0e                	jmp    800b1d <memset+0x2d>

		*p++ = c;
  800b0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b12:	8d 50 01             	lea    0x1(%eax),%edx
  800b15:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	88 10                	mov    %dl,(%eax)

	p = v;
	m = n;


	while (--m >= 0){
  800b1d:	ff 4d f8             	decl   -0x8(%ebp)
  800b20:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b24:	79 e9                	jns    800b0f <memset+0x1f>

		*p++ = c;
	}

	return v;
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b3d:	eb 16                	jmp    800b55 <memcpy+0x2a>
		*d++ = *s++;
  800b3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b42:	8d 50 01             	lea    0x1(%eax),%edx
  800b45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b4e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b51:	8a 12                	mov    (%edx),%dl
  800b53:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b55:	8b 45 10             	mov    0x10(%ebp),%eax
  800b58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b5e:	85 c0                	test   %eax,%eax
  800b60:	75 dd                	jne    800b3f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b7c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b7f:	73 50                	jae    800bd1 <memmove+0x6a>
  800b81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b84:	8b 45 10             	mov    0x10(%ebp),%eax
  800b87:	01 d0                	add    %edx,%eax
  800b89:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b8c:	76 43                	jbe    800bd1 <memmove+0x6a>
		s += n;
  800b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b91:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b94:	8b 45 10             	mov    0x10(%ebp),%eax
  800b97:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b9a:	eb 10                	jmp    800bac <memmove+0x45>
			*--d = *--s;
  800b9c:	ff 4d f8             	decl   -0x8(%ebp)
  800b9f:	ff 4d fc             	decl   -0x4(%ebp)
  800ba2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba5:	8a 10                	mov    (%eax),%dl
  800ba7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800baa:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bac:	8b 45 10             	mov    0x10(%ebp),%eax
  800baf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800bb5:	85 c0                	test   %eax,%eax
  800bb7:	75 e3                	jne    800b9c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb9:	eb 23                	jmp    800bde <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bbe:	8d 50 01             	lea    0x1(%eax),%edx
  800bc1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bca:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bcd:	8a 12                	mov    (%edx),%dl
  800bcf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bd7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bda:	85 c0                	test   %eax,%eax
  800bdc:	75 dd                	jne    800bbb <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bf5:	eb 2a                	jmp    800c21 <memcmp+0x3e>
		if (*s1 != *s2)
  800bf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bfa:	8a 10                	mov    (%eax),%dl
  800bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bff:	8a 00                	mov    (%eax),%al
  800c01:	38 c2                	cmp    %al,%dl
  800c03:	74 16                	je     800c1b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c08:	8a 00                	mov    (%eax),%al
  800c0a:	0f b6 d0             	movzbl %al,%edx
  800c0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	0f b6 c0             	movzbl %al,%eax
  800c15:	29 c2                	sub    %eax,%edx
  800c17:	89 d0                	mov    %edx,%eax
  800c19:	eb 18                	jmp    800c33 <memcmp+0x50>
		s1++, s2++;
  800c1b:	ff 45 fc             	incl   -0x4(%ebp)
  800c1e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c21:	8b 45 10             	mov    0x10(%ebp),%eax
  800c24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c27:	89 55 10             	mov    %edx,0x10(%ebp)
  800c2a:	85 c0                	test   %eax,%eax
  800c2c:	75 c9                	jne    800bf7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c41:	01 d0                	add    %edx,%eax
  800c43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c46:	eb 15                	jmp    800c5d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	0f b6 d0             	movzbl %al,%edx
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	0f b6 c0             	movzbl %al,%eax
  800c56:	39 c2                	cmp    %eax,%edx
  800c58:	74 0d                	je     800c67 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c5a:	ff 45 08             	incl   0x8(%ebp)
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c63:	72 e3                	jb     800c48 <memfind+0x13>
  800c65:	eb 01                	jmp    800c68 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c67:	90                   	nop
	return (void *) s;
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c7a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c81:	eb 03                	jmp    800c86 <strtol+0x19>
		s++;
  800c83:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	8a 00                	mov    (%eax),%al
  800c8b:	3c 20                	cmp    $0x20,%al
  800c8d:	74 f4                	je     800c83 <strtol+0x16>
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8a 00                	mov    (%eax),%al
  800c94:	3c 09                	cmp    $0x9,%al
  800c96:	74 eb                	je     800c83 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	3c 2b                	cmp    $0x2b,%al
  800c9f:	75 05                	jne    800ca6 <strtol+0x39>
		s++;
  800ca1:	ff 45 08             	incl   0x8(%ebp)
  800ca4:	eb 13                	jmp    800cb9 <strtol+0x4c>
	else if (*s == '-')
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	3c 2d                	cmp    $0x2d,%al
  800cad:	75 0a                	jne    800cb9 <strtol+0x4c>
		s++, neg = 1;
  800caf:	ff 45 08             	incl   0x8(%ebp)
  800cb2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cbd:	74 06                	je     800cc5 <strtol+0x58>
  800cbf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cc3:	75 20                	jne    800ce5 <strtol+0x78>
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8a 00                	mov    (%eax),%al
  800cca:	3c 30                	cmp    $0x30,%al
  800ccc:	75 17                	jne    800ce5 <strtol+0x78>
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	40                   	inc    %eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	3c 78                	cmp    $0x78,%al
  800cd6:	75 0d                	jne    800ce5 <strtol+0x78>
		s += 2, base = 16;
  800cd8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cdc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ce3:	eb 28                	jmp    800d0d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ce5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce9:	75 15                	jne    800d00 <strtol+0x93>
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	3c 30                	cmp    $0x30,%al
  800cf2:	75 0c                	jne    800d00 <strtol+0x93>
		s++, base = 8;
  800cf4:	ff 45 08             	incl   0x8(%ebp)
  800cf7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cfe:	eb 0d                	jmp    800d0d <strtol+0xa0>
	else if (base == 0)
  800d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d04:	75 07                	jne    800d0d <strtol+0xa0>
		base = 10;
  800d06:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	3c 2f                	cmp    $0x2f,%al
  800d14:	7e 19                	jle    800d2f <strtol+0xc2>
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 39                	cmp    $0x39,%al
  800d1d:	7f 10                	jg     800d2f <strtol+0xc2>
			dig = *s - '0';
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	0f be c0             	movsbl %al,%eax
  800d27:	83 e8 30             	sub    $0x30,%eax
  800d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d2d:	eb 42                	jmp    800d71 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	3c 60                	cmp    $0x60,%al
  800d36:	7e 19                	jle    800d51 <strtol+0xe4>
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	3c 7a                	cmp    $0x7a,%al
  800d3f:	7f 10                	jg     800d51 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	0f be c0             	movsbl %al,%eax
  800d49:	83 e8 57             	sub    $0x57,%eax
  800d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d4f:	eb 20                	jmp    800d71 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	3c 40                	cmp    $0x40,%al
  800d58:	7e 39                	jle    800d93 <strtol+0x126>
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	3c 5a                	cmp    $0x5a,%al
  800d61:	7f 30                	jg     800d93 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	0f be c0             	movsbl %al,%eax
  800d6b:	83 e8 37             	sub    $0x37,%eax
  800d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d74:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d77:	7d 19                	jge    800d92 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d79:	ff 45 08             	incl   0x8(%ebp)
  800d7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d83:	89 c2                	mov    %eax,%edx
  800d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d88:	01 d0                	add    %edx,%eax
  800d8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d8d:	e9 7b ff ff ff       	jmp    800d0d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d92:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d97:	74 08                	je     800da1 <strtol+0x134>
		*endptr = (char *) s;
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800da1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800da5:	74 07                	je     800dae <strtol+0x141>
  800da7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800daa:	f7 d8                	neg    %eax
  800dac:	eb 03                	jmp    800db1 <strtol+0x144>
  800dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800db1:	c9                   	leave  
  800db2:	c3                   	ret    

00800db3 <ltostr>:

void
ltostr(long value, char *str)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800db9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcb:	79 13                	jns    800de0 <ltostr+0x2d>
	{
		neg = 1;
  800dcd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dda:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ddd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800de8:	99                   	cltd   
  800de9:	f7 f9                	idiv   %ecx
  800deb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df7:	89 c2                	mov    %eax,%edx
  800df9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfc:	01 d0                	add    %edx,%eax
  800dfe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e01:	83 c2 30             	add    $0x30,%edx
  800e04:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e09:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e0e:	f7 e9                	imul   %ecx
  800e10:	c1 fa 02             	sar    $0x2,%edx
  800e13:	89 c8                	mov    %ecx,%eax
  800e15:	c1 f8 1f             	sar    $0x1f,%eax
  800e18:	29 c2                	sub    %eax,%edx
  800e1a:	89 d0                	mov    %edx,%eax
  800e1c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e22:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e27:	f7 e9                	imul   %ecx
  800e29:	c1 fa 02             	sar    $0x2,%edx
  800e2c:	89 c8                	mov    %ecx,%eax
  800e2e:	c1 f8 1f             	sar    $0x1f,%eax
  800e31:	29 c2                	sub    %eax,%edx
  800e33:	89 d0                	mov    %edx,%eax
  800e35:	c1 e0 02             	shl    $0x2,%eax
  800e38:	01 d0                	add    %edx,%eax
  800e3a:	01 c0                	add    %eax,%eax
  800e3c:	29 c1                	sub    %eax,%ecx
  800e3e:	89 ca                	mov    %ecx,%edx
  800e40:	85 d2                	test   %edx,%edx
  800e42:	75 9c                	jne    800de0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4e:	48                   	dec    %eax
  800e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e52:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e56:	74 3d                	je     800e95 <ltostr+0xe2>
		start = 1 ;
  800e58:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e5f:	eb 34                	jmp    800e95 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	01 d0                	add    %edx,%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	01 c2                	add    %eax,%edx
  800e76:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7c:	01 c8                	add    %ecx,%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e88:	01 c2                	add    %eax,%edx
  800e8a:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e8d:	88 02                	mov    %al,(%edx)
		start++ ;
  800e8f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e92:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e98:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e9b:	7c c4                	jl     800e61 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e9d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea3:	01 d0                	add    %edx,%eax
  800ea5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ea8:	90                   	nop
  800ea9:	c9                   	leave  
  800eaa:	c3                   	ret    

00800eab <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800eb1:	ff 75 08             	pushl  0x8(%ebp)
  800eb4:	e8 49 fa ff ff       	call   800902 <strlen>
  800eb9:	83 c4 04             	add    $0x4,%esp
  800ebc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	e8 3b fa ff ff       	call   800902 <strlen>
  800ec7:	83 c4 04             	add    $0x4,%esp
  800eca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ecd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ed4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800edb:	eb 17                	jmp    800ef4 <strcconcat+0x49>
		final[s] = str1[s] ;
  800edd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee3:	01 c2                	add    %eax,%edx
  800ee5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	01 c8                	add    %ecx,%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ef1:	ff 45 fc             	incl   -0x4(%ebp)
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800efa:	7c e1                	jl     800edd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800efc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f03:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f0a:	eb 1f                	jmp    800f2b <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0f:	8d 50 01             	lea    0x1(%eax),%edx
  800f12:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f15:	89 c2                	mov    %eax,%edx
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	01 c2                	add    %eax,%edx
  800f1c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f22:	01 c8                	add    %ecx,%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f28:	ff 45 f8             	incl   -0x8(%ebp)
  800f2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f2e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f31:	7c d9                	jl     800f0c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f36:	8b 45 10             	mov    0x10(%ebp),%eax
  800f39:	01 d0                	add    %edx,%eax
  800f3b:	c6 00 00             	movb   $0x0,(%eax)
}
  800f3e:	90                   	nop
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f44:	8b 45 14             	mov    0x14(%ebp),%eax
  800f47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f50:	8b 00                	mov    (%eax),%eax
  800f52:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f59:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5c:	01 d0                	add    %edx,%eax
  800f5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f64:	eb 0c                	jmp    800f72 <strsplit+0x31>
			*string++ = 0;
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	8d 50 01             	lea    0x1(%eax),%edx
  800f6c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f6f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	84 c0                	test   %al,%al
  800f79:	74 18                	je     800f93 <strsplit+0x52>
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	0f be c0             	movsbl %al,%eax
  800f83:	50                   	push   %eax
  800f84:	ff 75 0c             	pushl  0xc(%ebp)
  800f87:	e8 08 fb ff ff       	call   800a94 <strchr>
  800f8c:	83 c4 08             	add    $0x8,%esp
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	75 d3                	jne    800f66 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	84 c0                	test   %al,%al
  800f9a:	74 5a                	je     800ff6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9f:	8b 00                	mov    (%eax),%eax
  800fa1:	83 f8 0f             	cmp    $0xf,%eax
  800fa4:	75 07                	jne    800fad <strsplit+0x6c>
		{
			return 0;
  800fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fab:	eb 66                	jmp    801013 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fad:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb0:	8b 00                	mov    (%eax),%eax
  800fb2:	8d 48 01             	lea    0x1(%eax),%ecx
  800fb5:	8b 55 14             	mov    0x14(%ebp),%edx
  800fb8:	89 0a                	mov    %ecx,(%edx)
  800fba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc4:	01 c2                	add    %eax,%edx
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fcb:	eb 03                	jmp    800fd0 <strsplit+0x8f>
			string++;
  800fcd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	84 c0                	test   %al,%al
  800fd7:	74 8b                	je     800f64 <strsplit+0x23>
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	0f be c0             	movsbl %al,%eax
  800fe1:	50                   	push   %eax
  800fe2:	ff 75 0c             	pushl  0xc(%ebp)
  800fe5:	e8 aa fa ff ff       	call   800a94 <strchr>
  800fea:	83 c4 08             	add    $0x8,%esp
  800fed:	85 c0                	test   %eax,%eax
  800fef:	74 dc                	je     800fcd <strsplit+0x8c>
			string++;
	}
  800ff1:	e9 6e ff ff ff       	jmp    800f64 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800ff6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800ff7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffa:	8b 00                	mov    (%eax),%eax
  800ffc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801003:	8b 45 10             	mov    0x10(%ebp),%eax
  801006:	01 d0                	add    %edx,%eax
  801008:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80100e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801013:	c9                   	leave  
  801014:	c3                   	ret    

00801015 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  80101b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101f:	74 06                	je     801027 <str2lower+0x12>
  801021:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801025:	75 07                	jne    80102e <str2lower+0x19>
		return NULL;
  801027:	b8 00 00 00 00       	mov    $0x0,%eax
  80102c:	eb 4d                	jmp    80107b <str2lower+0x66>
	}
	char *ref=dst;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  801034:	eb 33                	jmp    801069 <str2lower+0x54>
			if(*src>=65&&*src<=90){
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 40                	cmp    $0x40,%al
  80103d:	7e 1a                	jle    801059 <str2lower+0x44>
  80103f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 5a                	cmp    $0x5a,%al
  801046:	7f 11                	jg     801059 <str2lower+0x44>
				*dst=*src+32;
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	83 c0 20             	add    $0x20,%eax
  801050:	88 c2                	mov    %al,%dl
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	88 10                	mov    %dl,(%eax)
  801057:	eb 0a                	jmp    801063 <str2lower+0x4e>
			}
			else{
				*dst=*src;
  801059:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105c:	8a 10                	mov    (%eax),%dl
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	88 10                	mov    %dl,(%eax)
			}
			src++;
  801063:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  801066:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	84 c0                	test   %al,%al
  801070:	75 c4                	jne    801036 <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  801078:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    

0080107d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	57                   	push   %edi
  801081:	56                   	push   %esi
  801082:	53                   	push   %ebx
  801083:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80108f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801092:	8b 7d 18             	mov    0x18(%ebp),%edi
  801095:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801098:	cd 30                	int    $0x30
  80109a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80109d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010a0:	83 c4 10             	add    $0x10,%esp
  8010a3:	5b                   	pop    %ebx
  8010a4:	5e                   	pop    %esi
  8010a5:	5f                   	pop    %edi
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    

008010a8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	83 ec 04             	sub    $0x4,%esp
  8010ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010b4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	6a 00                	push   $0x0
  8010bd:	6a 00                	push   $0x0
  8010bf:	52                   	push   %edx
  8010c0:	ff 75 0c             	pushl  0xc(%ebp)
  8010c3:	50                   	push   %eax
  8010c4:	6a 00                	push   $0x0
  8010c6:	e8 b2 ff ff ff       	call   80107d <syscall>
  8010cb:	83 c4 18             	add    $0x18,%esp
}
  8010ce:	90                   	nop
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010d4:	6a 00                	push   $0x0
  8010d6:	6a 00                	push   $0x0
  8010d8:	6a 00                	push   $0x0
  8010da:	6a 00                	push   $0x0
  8010dc:	6a 00                	push   $0x0
  8010de:	6a 01                	push   $0x1
  8010e0:	e8 98 ff ff ff       	call   80107d <syscall>
  8010e5:	83 c4 18             	add    $0x18,%esp
}
  8010e8:	c9                   	leave  
  8010e9:	c3                   	ret    

008010ea <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	6a 00                	push   $0x0
  8010f5:	6a 00                	push   $0x0
  8010f7:	6a 00                	push   $0x0
  8010f9:	52                   	push   %edx
  8010fa:	50                   	push   %eax
  8010fb:	6a 05                	push   $0x5
  8010fd:	e8 7b ff ff ff       	call   80107d <syscall>
  801102:	83 c4 18             	add    $0x18,%esp
}
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	56                   	push   %esi
  80110b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80110c:	8b 75 18             	mov    0x18(%ebp),%esi
  80110f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801112:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801115:	8b 55 0c             	mov    0xc(%ebp),%edx
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	56                   	push   %esi
  80111c:	53                   	push   %ebx
  80111d:	51                   	push   %ecx
  80111e:	52                   	push   %edx
  80111f:	50                   	push   %eax
  801120:	6a 06                	push   $0x6
  801122:	e8 56 ff ff ff       	call   80107d <syscall>
  801127:	83 c4 18             	add    $0x18,%esp
}
  80112a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80112d:	5b                   	pop    %ebx
  80112e:	5e                   	pop    %esi
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    

00801131 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801134:	8b 55 0c             	mov    0xc(%ebp),%edx
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	6a 00                	push   $0x0
  80113c:	6a 00                	push   $0x0
  80113e:	6a 00                	push   $0x0
  801140:	52                   	push   %edx
  801141:	50                   	push   %eax
  801142:	6a 07                	push   $0x7
  801144:	e8 34 ff ff ff       	call   80107d <syscall>
  801149:	83 c4 18             	add    $0x18,%esp
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801151:	6a 00                	push   $0x0
  801153:	6a 00                	push   $0x0
  801155:	6a 00                	push   $0x0
  801157:	ff 75 0c             	pushl  0xc(%ebp)
  80115a:	ff 75 08             	pushl  0x8(%ebp)
  80115d:	6a 08                	push   $0x8
  80115f:	e8 19 ff ff ff       	call   80107d <syscall>
  801164:	83 c4 18             	add    $0x18,%esp
}
  801167:	c9                   	leave  
  801168:	c3                   	ret    

00801169 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80116c:	6a 00                	push   $0x0
  80116e:	6a 00                	push   $0x0
  801170:	6a 00                	push   $0x0
  801172:	6a 00                	push   $0x0
  801174:	6a 00                	push   $0x0
  801176:	6a 09                	push   $0x9
  801178:	e8 00 ff ff ff       	call   80107d <syscall>
  80117d:	83 c4 18             	add    $0x18,%esp
}
  801180:	c9                   	leave  
  801181:	c3                   	ret    

00801182 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801185:	6a 00                	push   $0x0
  801187:	6a 00                	push   $0x0
  801189:	6a 00                	push   $0x0
  80118b:	6a 00                	push   $0x0
  80118d:	6a 00                	push   $0x0
  80118f:	6a 0a                	push   $0xa
  801191:	e8 e7 fe ff ff       	call   80107d <syscall>
  801196:	83 c4 18             	add    $0x18,%esp
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80119e:	6a 00                	push   $0x0
  8011a0:	6a 00                	push   $0x0
  8011a2:	6a 00                	push   $0x0
  8011a4:	6a 00                	push   $0x0
  8011a6:	6a 00                	push   $0x0
  8011a8:	6a 0b                	push   $0xb
  8011aa:	e8 ce fe ff ff       	call   80107d <syscall>
  8011af:	83 c4 18             	add    $0x18,%esp
}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011b7:	6a 00                	push   $0x0
  8011b9:	6a 00                	push   $0x0
  8011bb:	6a 00                	push   $0x0
  8011bd:	6a 00                	push   $0x0
  8011bf:	6a 00                	push   $0x0
  8011c1:	6a 0c                	push   $0xc
  8011c3:	e8 b5 fe ff ff       	call   80107d <syscall>
  8011c8:	83 c4 18             	add    $0x18,%esp
}
  8011cb:	c9                   	leave  
  8011cc:	c3                   	ret    

008011cd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011d0:	6a 00                	push   $0x0
  8011d2:	6a 00                	push   $0x0
  8011d4:	6a 00                	push   $0x0
  8011d6:	6a 00                	push   $0x0
  8011d8:	ff 75 08             	pushl  0x8(%ebp)
  8011db:	6a 0d                	push   $0xd
  8011dd:	e8 9b fe ff ff       	call   80107d <syscall>
  8011e2:	83 c4 18             	add    $0x18,%esp
}
  8011e5:	c9                   	leave  
  8011e6:	c3                   	ret    

008011e7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011ea:	6a 00                	push   $0x0
  8011ec:	6a 00                	push   $0x0
  8011ee:	6a 00                	push   $0x0
  8011f0:	6a 00                	push   $0x0
  8011f2:	6a 00                	push   $0x0
  8011f4:	6a 0e                	push   $0xe
  8011f6:	e8 82 fe ff ff       	call   80107d <syscall>
  8011fb:	83 c4 18             	add    $0x18,%esp
}
  8011fe:	90                   	nop
  8011ff:	c9                   	leave  
  801200:	c3                   	ret    

00801201 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801204:	6a 00                	push   $0x0
  801206:	6a 00                	push   $0x0
  801208:	6a 00                	push   $0x0
  80120a:	6a 00                	push   $0x0
  80120c:	6a 00                	push   $0x0
  80120e:	6a 11                	push   $0x11
  801210:	e8 68 fe ff ff       	call   80107d <syscall>
  801215:	83 c4 18             	add    $0x18,%esp
}
  801218:	90                   	nop
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80121e:	6a 00                	push   $0x0
  801220:	6a 00                	push   $0x0
  801222:	6a 00                	push   $0x0
  801224:	6a 00                	push   $0x0
  801226:	6a 00                	push   $0x0
  801228:	6a 12                	push   $0x12
  80122a:	e8 4e fe ff ff       	call   80107d <syscall>
  80122f:	83 c4 18             	add    $0x18,%esp
}
  801232:	90                   	nop
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <sys_cputc>:


void
sys_cputc(const char c)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 04             	sub    $0x4,%esp
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801241:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801245:	6a 00                	push   $0x0
  801247:	6a 00                	push   $0x0
  801249:	6a 00                	push   $0x0
  80124b:	6a 00                	push   $0x0
  80124d:	50                   	push   %eax
  80124e:	6a 13                	push   $0x13
  801250:	e8 28 fe ff ff       	call   80107d <syscall>
  801255:	83 c4 18             	add    $0x18,%esp
}
  801258:	90                   	nop
  801259:	c9                   	leave  
  80125a:	c3                   	ret    

0080125b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80125e:	6a 00                	push   $0x0
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 14                	push   $0x14
  80126a:	e8 0e fe ff ff       	call   80107d <syscall>
  80126f:	83 c4 18             	add    $0x18,%esp
}
  801272:	90                   	nop
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	ff 75 0c             	pushl  0xc(%ebp)
  801284:	50                   	push   %eax
  801285:	6a 15                	push   $0x15
  801287:	e8 f1 fd ff ff       	call   80107d <syscall>
  80128c:	83 c4 18             	add    $0x18,%esp
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801294:	8b 55 0c             	mov    0xc(%ebp),%edx
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	6a 00                	push   $0x0
  80129c:	6a 00                	push   $0x0
  80129e:	6a 00                	push   $0x0
  8012a0:	52                   	push   %edx
  8012a1:	50                   	push   %eax
  8012a2:	6a 18                	push   $0x18
  8012a4:	e8 d4 fd ff ff       	call   80107d <syscall>
  8012a9:	83 c4 18             	add    $0x18,%esp
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	52                   	push   %edx
  8012be:	50                   	push   %eax
  8012bf:	6a 16                	push   $0x16
  8012c1:	e8 b7 fd ff ff       	call   80107d <syscall>
  8012c6:	83 c4 18             	add    $0x18,%esp
}
  8012c9:	90                   	nop
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    

008012cc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	6a 00                	push   $0x0
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 00                	push   $0x0
  8012db:	52                   	push   %edx
  8012dc:	50                   	push   %eax
  8012dd:	6a 17                	push   $0x17
  8012df:	e8 99 fd ff ff       	call   80107d <syscall>
  8012e4:	83 c4 18             	add    $0x18,%esp
}
  8012e7:	90                   	nop
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	83 ec 04             	sub    $0x4,%esp
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012f6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	6a 00                	push   $0x0
  801302:	51                   	push   %ecx
  801303:	52                   	push   %edx
  801304:	ff 75 0c             	pushl  0xc(%ebp)
  801307:	50                   	push   %eax
  801308:	6a 19                	push   $0x19
  80130a:	e8 6e fd ff ff       	call   80107d <syscall>
  80130f:	83 c4 18             	add    $0x18,%esp
}
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	52                   	push   %edx
  801324:	50                   	push   %eax
  801325:	6a 1a                	push   $0x1a
  801327:	e8 51 fd ff ff       	call   80107d <syscall>
  80132c:	83 c4 18             	add    $0x18,%esp
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801334:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801337:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	51                   	push   %ecx
  801342:	52                   	push   %edx
  801343:	50                   	push   %eax
  801344:	6a 1b                	push   $0x1b
  801346:	e8 32 fd ff ff       	call   80107d <syscall>
  80134b:	83 c4 18             	add    $0x18,%esp
}
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801353:	8b 55 0c             	mov    0xc(%ebp),%edx
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	52                   	push   %edx
  801360:	50                   	push   %eax
  801361:	6a 1c                	push   $0x1c
  801363:	e8 15 fd ff ff       	call   80107d <syscall>
  801368:	83 c4 18             	add    $0x18,%esp
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 1d                	push   $0x1d
  80137c:	e8 fc fc ff ff       	call   80107d <syscall>
  801381:	83 c4 18             	add    $0x18,%esp
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	6a 00                	push   $0x0
  80138e:	ff 75 14             	pushl  0x14(%ebp)
  801391:	ff 75 10             	pushl  0x10(%ebp)
  801394:	ff 75 0c             	pushl  0xc(%ebp)
  801397:	50                   	push   %eax
  801398:	6a 1e                	push   $0x1e
  80139a:	e8 de fc ff ff       	call   80107d <syscall>
  80139f:	83 c4 18             	add    $0x18,%esp
}
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    

008013a4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	50                   	push   %eax
  8013b3:	6a 1f                	push   $0x1f
  8013b5:	e8 c3 fc ff ff       	call   80107d <syscall>
  8013ba:	83 c4 18             	add    $0x18,%esp
}
  8013bd:	90                   	nop
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    

008013c0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	50                   	push   %eax
  8013cf:	6a 20                	push   $0x20
  8013d1:	e8 a7 fc ff ff       	call   80107d <syscall>
  8013d6:	83 c4 18             	add    $0x18,%esp
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 02                	push   $0x2
  8013ea:	e8 8e fc ff ff       	call   80107d <syscall>
  8013ef:	83 c4 18             	add    $0x18,%esp
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 03                	push   $0x3
  801403:	e8 75 fc ff ff       	call   80107d <syscall>
  801408:	83 c4 18             	add    $0x18,%esp
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 04                	push   $0x4
  80141c:	e8 5c fc ff ff       	call   80107d <syscall>
  801421:	83 c4 18             	add    $0x18,%esp
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <sys_exit_env>:


void sys_exit_env(void)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 21                	push   $0x21
  801435:	e8 43 fc ff ff       	call   80107d <syscall>
  80143a:	83 c4 18             	add    $0x18,%esp
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801446:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801449:	8d 50 04             	lea    0x4(%eax),%edx
  80144c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	52                   	push   %edx
  801456:	50                   	push   %eax
  801457:	6a 22                	push   $0x22
  801459:	e8 1f fc ff ff       	call   80107d <syscall>
  80145e:	83 c4 18             	add    $0x18,%esp
	return result;
  801461:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801464:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801467:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146a:	89 01                	mov    %eax,(%ecx)
  80146c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	c9                   	leave  
  801473:	c2 04 00             	ret    $0x4

00801476 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	ff 75 10             	pushl  0x10(%ebp)
  801480:	ff 75 0c             	pushl  0xc(%ebp)
  801483:	ff 75 08             	pushl  0x8(%ebp)
  801486:	6a 10                	push   $0x10
  801488:	e8 f0 fb ff ff       	call   80107d <syscall>
  80148d:	83 c4 18             	add    $0x18,%esp
	return ;
  801490:	90                   	nop
}
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <sys_rcr2>:
uint32 sys_rcr2()
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 23                	push   $0x23
  8014a2:	e8 d6 fb ff ff       	call   80107d <syscall>
  8014a7:	83 c4 18             	add    $0x18,%esp
}
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	83 ec 04             	sub    $0x4,%esp
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014b8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	50                   	push   %eax
  8014c5:	6a 24                	push   $0x24
  8014c7:	e8 b1 fb ff ff       	call   80107d <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8014cf:	90                   	nop
}
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <rsttst>:
void rsttst()
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 26                	push   $0x26
  8014e1:	e8 97 fb ff ff       	call   80107d <syscall>
  8014e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8014e9:	90                   	nop
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014f8:	8b 55 18             	mov    0x18(%ebp),%edx
  8014fb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014ff:	52                   	push   %edx
  801500:	50                   	push   %eax
  801501:	ff 75 10             	pushl  0x10(%ebp)
  801504:	ff 75 0c             	pushl  0xc(%ebp)
  801507:	ff 75 08             	pushl  0x8(%ebp)
  80150a:	6a 25                	push   $0x25
  80150c:	e8 6c fb ff ff       	call   80107d <syscall>
  801511:	83 c4 18             	add    $0x18,%esp
	return ;
  801514:	90                   	nop
}
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <chktst>:
void chktst(uint32 n)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	ff 75 08             	pushl  0x8(%ebp)
  801525:	6a 27                	push   $0x27
  801527:	e8 51 fb ff ff       	call   80107d <syscall>
  80152c:	83 c4 18             	add    $0x18,%esp
	return ;
  80152f:	90                   	nop
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <inctst>:

void inctst()
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 28                	push   $0x28
  801541:	e8 37 fb ff ff       	call   80107d <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
	return ;
  801549:	90                   	nop
}
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    

0080154c <gettst>:
uint32 gettst()
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 29                	push   $0x29
  80155b:	e8 1d fb ff ff       	call   80107d <syscall>
  801560:	83 c4 18             	add    $0x18,%esp
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 2a                	push   $0x2a
  801577:	e8 01 fb ff ff       	call   80107d <syscall>
  80157c:	83 c4 18             	add    $0x18,%esp
  80157f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801582:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801586:	75 07                	jne    80158f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801588:	b8 01 00 00 00       	mov    $0x1,%eax
  80158d:	eb 05                	jmp    801594 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80158f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 2a                	push   $0x2a
  8015a8:	e8 d0 fa ff ff       	call   80107d <syscall>
  8015ad:	83 c4 18             	add    $0x18,%esp
  8015b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015b3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015b7:	75 07                	jne    8015c0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8015be:	eb 05                	jmp    8015c5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 2a                	push   $0x2a
  8015d9:	e8 9f fa ff ff       	call   80107d <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
  8015e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015e4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015e8:	75 07                	jne    8015f1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8015ef:	eb 05                	jmp    8015f6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 2a                	push   $0x2a
  80160a:	e8 6e fa ff ff       	call   80107d <syscall>
  80160f:	83 c4 18             	add    $0x18,%esp
  801612:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801615:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801619:	75 07                	jne    801622 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80161b:	b8 01 00 00 00       	mov    $0x1,%eax
  801620:	eb 05                	jmp    801627 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801622:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	ff 75 08             	pushl  0x8(%ebp)
  801637:	6a 2b                	push   $0x2b
  801639:	e8 3f fa ff ff       	call   80107d <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
	return ;
  801641:	90                   	nop
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801648:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80164b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80164e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	6a 00                	push   $0x0
  801656:	53                   	push   %ebx
  801657:	51                   	push   %ecx
  801658:	52                   	push   %edx
  801659:	50                   	push   %eax
  80165a:	6a 2c                	push   $0x2c
  80165c:	e8 1c fa ff ff       	call   80107d <syscall>
  801661:	83 c4 18             	add    $0x18,%esp
}
  801664:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80166c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	52                   	push   %edx
  801679:	50                   	push   %eax
  80167a:	6a 2d                	push   $0x2d
  80167c:	e8 fc f9 ff ff       	call   80107d <syscall>
  801681:	83 c4 18             	add    $0x18,%esp
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801689:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80168c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	6a 00                	push   $0x0
  801694:	51                   	push   %ecx
  801695:	ff 75 10             	pushl  0x10(%ebp)
  801698:	52                   	push   %edx
  801699:	50                   	push   %eax
  80169a:	6a 2e                	push   $0x2e
  80169c:	e8 dc f9 ff ff       	call   80107d <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	ff 75 10             	pushl  0x10(%ebp)
  8016b0:	ff 75 0c             	pushl  0xc(%ebp)
  8016b3:	ff 75 08             	pushl  0x8(%ebp)
  8016b6:	6a 0f                	push   $0xf
  8016b8:	e8 c0 f9 ff ff       	call   80107d <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c0:	90                   	nop
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	50                   	push   %eax
  8016d2:	6a 2f                	push   $0x2f
  8016d4:	e8 a4 f9 ff ff       	call   80107d <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ea:	ff 75 08             	pushl  0x8(%ebp)
  8016ed:	6a 30                	push   $0x30
  8016ef:	e8 89 f9 ff ff       	call   80107d <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  8016f7:	90                   	nop
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	ff 75 0c             	pushl  0xc(%ebp)
  801706:	ff 75 08             	pushl  0x8(%ebp)
  801709:	6a 31                	push   $0x31
  80170b:	e8 6d f9 ff ff       	call   80107d <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801713:	90                   	nop
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    
  801716:	66 90                	xchg   %ax,%ax

00801718 <__udivdi3>:
  801718:	55                   	push   %ebp
  801719:	57                   	push   %edi
  80171a:	56                   	push   %esi
  80171b:	53                   	push   %ebx
  80171c:	83 ec 1c             	sub    $0x1c,%esp
  80171f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801723:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801727:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80172b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80172f:	89 ca                	mov    %ecx,%edx
  801731:	89 f8                	mov    %edi,%eax
  801733:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801737:	85 f6                	test   %esi,%esi
  801739:	75 2d                	jne    801768 <__udivdi3+0x50>
  80173b:	39 cf                	cmp    %ecx,%edi
  80173d:	77 65                	ja     8017a4 <__udivdi3+0x8c>
  80173f:	89 fd                	mov    %edi,%ebp
  801741:	85 ff                	test   %edi,%edi
  801743:	75 0b                	jne    801750 <__udivdi3+0x38>
  801745:	b8 01 00 00 00       	mov    $0x1,%eax
  80174a:	31 d2                	xor    %edx,%edx
  80174c:	f7 f7                	div    %edi
  80174e:	89 c5                	mov    %eax,%ebp
  801750:	31 d2                	xor    %edx,%edx
  801752:	89 c8                	mov    %ecx,%eax
  801754:	f7 f5                	div    %ebp
  801756:	89 c1                	mov    %eax,%ecx
  801758:	89 d8                	mov    %ebx,%eax
  80175a:	f7 f5                	div    %ebp
  80175c:	89 cf                	mov    %ecx,%edi
  80175e:	89 fa                	mov    %edi,%edx
  801760:	83 c4 1c             	add    $0x1c,%esp
  801763:	5b                   	pop    %ebx
  801764:	5e                   	pop    %esi
  801765:	5f                   	pop    %edi
  801766:	5d                   	pop    %ebp
  801767:	c3                   	ret    
  801768:	39 ce                	cmp    %ecx,%esi
  80176a:	77 28                	ja     801794 <__udivdi3+0x7c>
  80176c:	0f bd fe             	bsr    %esi,%edi
  80176f:	83 f7 1f             	xor    $0x1f,%edi
  801772:	75 40                	jne    8017b4 <__udivdi3+0x9c>
  801774:	39 ce                	cmp    %ecx,%esi
  801776:	72 0a                	jb     801782 <__udivdi3+0x6a>
  801778:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80177c:	0f 87 9e 00 00 00    	ja     801820 <__udivdi3+0x108>
  801782:	b8 01 00 00 00       	mov    $0x1,%eax
  801787:	89 fa                	mov    %edi,%edx
  801789:	83 c4 1c             	add    $0x1c,%esp
  80178c:	5b                   	pop    %ebx
  80178d:	5e                   	pop    %esi
  80178e:	5f                   	pop    %edi
  80178f:	5d                   	pop    %ebp
  801790:	c3                   	ret    
  801791:	8d 76 00             	lea    0x0(%esi),%esi
  801794:	31 ff                	xor    %edi,%edi
  801796:	31 c0                	xor    %eax,%eax
  801798:	89 fa                	mov    %edi,%edx
  80179a:	83 c4 1c             	add    $0x1c,%esp
  80179d:	5b                   	pop    %ebx
  80179e:	5e                   	pop    %esi
  80179f:	5f                   	pop    %edi
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    
  8017a2:	66 90                	xchg   %ax,%ax
  8017a4:	89 d8                	mov    %ebx,%eax
  8017a6:	f7 f7                	div    %edi
  8017a8:	31 ff                	xor    %edi,%edi
  8017aa:	89 fa                	mov    %edi,%edx
  8017ac:	83 c4 1c             	add    $0x1c,%esp
  8017af:	5b                   	pop    %ebx
  8017b0:	5e                   	pop    %esi
  8017b1:	5f                   	pop    %edi
  8017b2:	5d                   	pop    %ebp
  8017b3:	c3                   	ret    
  8017b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8017b9:	89 eb                	mov    %ebp,%ebx
  8017bb:	29 fb                	sub    %edi,%ebx
  8017bd:	89 f9                	mov    %edi,%ecx
  8017bf:	d3 e6                	shl    %cl,%esi
  8017c1:	89 c5                	mov    %eax,%ebp
  8017c3:	88 d9                	mov    %bl,%cl
  8017c5:	d3 ed                	shr    %cl,%ebp
  8017c7:	89 e9                	mov    %ebp,%ecx
  8017c9:	09 f1                	or     %esi,%ecx
  8017cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8017cf:	89 f9                	mov    %edi,%ecx
  8017d1:	d3 e0                	shl    %cl,%eax
  8017d3:	89 c5                	mov    %eax,%ebp
  8017d5:	89 d6                	mov    %edx,%esi
  8017d7:	88 d9                	mov    %bl,%cl
  8017d9:	d3 ee                	shr    %cl,%esi
  8017db:	89 f9                	mov    %edi,%ecx
  8017dd:	d3 e2                	shl    %cl,%edx
  8017df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017e3:	88 d9                	mov    %bl,%cl
  8017e5:	d3 e8                	shr    %cl,%eax
  8017e7:	09 c2                	or     %eax,%edx
  8017e9:	89 d0                	mov    %edx,%eax
  8017eb:	89 f2                	mov    %esi,%edx
  8017ed:	f7 74 24 0c          	divl   0xc(%esp)
  8017f1:	89 d6                	mov    %edx,%esi
  8017f3:	89 c3                	mov    %eax,%ebx
  8017f5:	f7 e5                	mul    %ebp
  8017f7:	39 d6                	cmp    %edx,%esi
  8017f9:	72 19                	jb     801814 <__udivdi3+0xfc>
  8017fb:	74 0b                	je     801808 <__udivdi3+0xf0>
  8017fd:	89 d8                	mov    %ebx,%eax
  8017ff:	31 ff                	xor    %edi,%edi
  801801:	e9 58 ff ff ff       	jmp    80175e <__udivdi3+0x46>
  801806:	66 90                	xchg   %ax,%ax
  801808:	8b 54 24 08          	mov    0x8(%esp),%edx
  80180c:	89 f9                	mov    %edi,%ecx
  80180e:	d3 e2                	shl    %cl,%edx
  801810:	39 c2                	cmp    %eax,%edx
  801812:	73 e9                	jae    8017fd <__udivdi3+0xe5>
  801814:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801817:	31 ff                	xor    %edi,%edi
  801819:	e9 40 ff ff ff       	jmp    80175e <__udivdi3+0x46>
  80181e:	66 90                	xchg   %ax,%ax
  801820:	31 c0                	xor    %eax,%eax
  801822:	e9 37 ff ff ff       	jmp    80175e <__udivdi3+0x46>
  801827:	90                   	nop

00801828 <__umoddi3>:
  801828:	55                   	push   %ebp
  801829:	57                   	push   %edi
  80182a:	56                   	push   %esi
  80182b:	53                   	push   %ebx
  80182c:	83 ec 1c             	sub    $0x1c,%esp
  80182f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801833:	8b 74 24 34          	mov    0x34(%esp),%esi
  801837:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80183b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80183f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801843:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801847:	89 f3                	mov    %esi,%ebx
  801849:	89 fa                	mov    %edi,%edx
  80184b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80184f:	89 34 24             	mov    %esi,(%esp)
  801852:	85 c0                	test   %eax,%eax
  801854:	75 1a                	jne    801870 <__umoddi3+0x48>
  801856:	39 f7                	cmp    %esi,%edi
  801858:	0f 86 a2 00 00 00    	jbe    801900 <__umoddi3+0xd8>
  80185e:	89 c8                	mov    %ecx,%eax
  801860:	89 f2                	mov    %esi,%edx
  801862:	f7 f7                	div    %edi
  801864:	89 d0                	mov    %edx,%eax
  801866:	31 d2                	xor    %edx,%edx
  801868:	83 c4 1c             	add    $0x1c,%esp
  80186b:	5b                   	pop    %ebx
  80186c:	5e                   	pop    %esi
  80186d:	5f                   	pop    %edi
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    
  801870:	39 f0                	cmp    %esi,%eax
  801872:	0f 87 ac 00 00 00    	ja     801924 <__umoddi3+0xfc>
  801878:	0f bd e8             	bsr    %eax,%ebp
  80187b:	83 f5 1f             	xor    $0x1f,%ebp
  80187e:	0f 84 ac 00 00 00    	je     801930 <__umoddi3+0x108>
  801884:	bf 20 00 00 00       	mov    $0x20,%edi
  801889:	29 ef                	sub    %ebp,%edi
  80188b:	89 fe                	mov    %edi,%esi
  80188d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801891:	89 e9                	mov    %ebp,%ecx
  801893:	d3 e0                	shl    %cl,%eax
  801895:	89 d7                	mov    %edx,%edi
  801897:	89 f1                	mov    %esi,%ecx
  801899:	d3 ef                	shr    %cl,%edi
  80189b:	09 c7                	or     %eax,%edi
  80189d:	89 e9                	mov    %ebp,%ecx
  80189f:	d3 e2                	shl    %cl,%edx
  8018a1:	89 14 24             	mov    %edx,(%esp)
  8018a4:	89 d8                	mov    %ebx,%eax
  8018a6:	d3 e0                	shl    %cl,%eax
  8018a8:	89 c2                	mov    %eax,%edx
  8018aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018ae:	d3 e0                	shl    %cl,%eax
  8018b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018b8:	89 f1                	mov    %esi,%ecx
  8018ba:	d3 e8                	shr    %cl,%eax
  8018bc:	09 d0                	or     %edx,%eax
  8018be:	d3 eb                	shr    %cl,%ebx
  8018c0:	89 da                	mov    %ebx,%edx
  8018c2:	f7 f7                	div    %edi
  8018c4:	89 d3                	mov    %edx,%ebx
  8018c6:	f7 24 24             	mull   (%esp)
  8018c9:	89 c6                	mov    %eax,%esi
  8018cb:	89 d1                	mov    %edx,%ecx
  8018cd:	39 d3                	cmp    %edx,%ebx
  8018cf:	0f 82 87 00 00 00    	jb     80195c <__umoddi3+0x134>
  8018d5:	0f 84 91 00 00 00    	je     80196c <__umoddi3+0x144>
  8018db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8018df:	29 f2                	sub    %esi,%edx
  8018e1:	19 cb                	sbb    %ecx,%ebx
  8018e3:	89 d8                	mov    %ebx,%eax
  8018e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8018e9:	d3 e0                	shl    %cl,%eax
  8018eb:	89 e9                	mov    %ebp,%ecx
  8018ed:	d3 ea                	shr    %cl,%edx
  8018ef:	09 d0                	or     %edx,%eax
  8018f1:	89 e9                	mov    %ebp,%ecx
  8018f3:	d3 eb                	shr    %cl,%ebx
  8018f5:	89 da                	mov    %ebx,%edx
  8018f7:	83 c4 1c             	add    $0x1c,%esp
  8018fa:	5b                   	pop    %ebx
  8018fb:	5e                   	pop    %esi
  8018fc:	5f                   	pop    %edi
  8018fd:	5d                   	pop    %ebp
  8018fe:	c3                   	ret    
  8018ff:	90                   	nop
  801900:	89 fd                	mov    %edi,%ebp
  801902:	85 ff                	test   %edi,%edi
  801904:	75 0b                	jne    801911 <__umoddi3+0xe9>
  801906:	b8 01 00 00 00       	mov    $0x1,%eax
  80190b:	31 d2                	xor    %edx,%edx
  80190d:	f7 f7                	div    %edi
  80190f:	89 c5                	mov    %eax,%ebp
  801911:	89 f0                	mov    %esi,%eax
  801913:	31 d2                	xor    %edx,%edx
  801915:	f7 f5                	div    %ebp
  801917:	89 c8                	mov    %ecx,%eax
  801919:	f7 f5                	div    %ebp
  80191b:	89 d0                	mov    %edx,%eax
  80191d:	e9 44 ff ff ff       	jmp    801866 <__umoddi3+0x3e>
  801922:	66 90                	xchg   %ax,%ax
  801924:	89 c8                	mov    %ecx,%eax
  801926:	89 f2                	mov    %esi,%edx
  801928:	83 c4 1c             	add    $0x1c,%esp
  80192b:	5b                   	pop    %ebx
  80192c:	5e                   	pop    %esi
  80192d:	5f                   	pop    %edi
  80192e:	5d                   	pop    %ebp
  80192f:	c3                   	ret    
  801930:	3b 04 24             	cmp    (%esp),%eax
  801933:	72 06                	jb     80193b <__umoddi3+0x113>
  801935:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801939:	77 0f                	ja     80194a <__umoddi3+0x122>
  80193b:	89 f2                	mov    %esi,%edx
  80193d:	29 f9                	sub    %edi,%ecx
  80193f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801943:	89 14 24             	mov    %edx,(%esp)
  801946:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80194a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80194e:	8b 14 24             	mov    (%esp),%edx
  801951:	83 c4 1c             	add    $0x1c,%esp
  801954:	5b                   	pop    %ebx
  801955:	5e                   	pop    %esi
  801956:	5f                   	pop    %edi
  801957:	5d                   	pop    %ebp
  801958:	c3                   	ret    
  801959:	8d 76 00             	lea    0x0(%esi),%esi
  80195c:	2b 04 24             	sub    (%esp),%eax
  80195f:	19 fa                	sbb    %edi,%edx
  801961:	89 d1                	mov    %edx,%ecx
  801963:	89 c6                	mov    %eax,%esi
  801965:	e9 71 ff ff ff       	jmp    8018db <__umoddi3+0xb3>
  80196a:	66 90                	xchg   %ax,%ax
  80196c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801970:	72 ea                	jb     80195c <__umoddi3+0x134>
  801972:	89 d9                	mov    %ebx,%ecx
  801974:	e9 62 ff ff ff       	jmp    8018db <__umoddi3+0xb3>
