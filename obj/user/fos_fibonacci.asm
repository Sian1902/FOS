
obj/user/fos_fibonacci:     file format elf32-i386


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
  800031:	e8 ab 00 00 00       	call   8000e1 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int fibonacci(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 a0 1c 80 00       	push   $0x801ca0
  800057:	e8 1e 0a 00 00       	call   800a7a <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 7b 0e 00 00       	call   800eed <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int res = fibonacci(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 1f 00 00 00       	call   8000a2 <fibonacci>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	ff 75 f0             	pushl  -0x10(%ebp)
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	68 be 1c 80 00       	push   $0x801cbe
  800097:	e8 8b 02 00 00       	call   800327 <atomic_cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
	return;
  80009f:	90                   	nop
}
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <fibonacci>:


int fibonacci(int n)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	53                   	push   %ebx
  8000a6:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000a9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ad:	7f 07                	jg     8000b6 <fibonacci+0x14>
		return 1 ;
  8000af:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b4:	eb 26                	jmp    8000dc <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b9:	48                   	dec    %eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 df ff ff ff       	call   8000a2 <fibonacci>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 c3                	mov    %eax,%ebx
  8000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cb:	83 e8 02             	sub    $0x2,%eax
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	50                   	push   %eax
  8000d2:	e8 cb ff ff ff       	call   8000a2 <fibonacci>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	01 d8                	add    %ebx,%eax
}
  8000dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    

008000e1 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e7:	e8 88 15 00 00       	call   801674 <sys_getenvindex>
  8000ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000f2:	89 d0                	mov    %edx,%eax
  8000f4:	01 c0                	add    %eax,%eax
  8000f6:	01 d0                	add    %edx,%eax
  8000f8:	01 c0                	add    %eax,%eax
  8000fa:	01 d0                	add    %edx,%eax
  8000fc:	c1 e0 02             	shl    $0x2,%eax
  8000ff:	01 d0                	add    %edx,%eax
  800101:	01 c0                	add    %eax,%eax
  800103:	01 d0                	add    %edx,%eax
  800105:	c1 e0 02             	shl    $0x2,%eax
  800108:	01 d0                	add    %edx,%eax
  80010a:	c1 e0 02             	shl    $0x2,%eax
  80010d:	01 d0                	add    %edx,%eax
  80010f:	c1 e0 02             	shl    $0x2,%eax
  800112:	01 d0                	add    %edx,%eax
  800114:	c1 e0 05             	shl    $0x5,%eax
  800117:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800121:	a1 20 30 80 00       	mov    0x803020,%eax
  800126:	8a 40 5c             	mov    0x5c(%eax),%al
  800129:	84 c0                	test   %al,%al
  80012b:	74 0d                	je     80013a <libmain+0x59>
		binaryname = myEnv->prog_name;
  80012d:	a1 20 30 80 00       	mov    0x803020,%eax
  800132:	83 c0 5c             	add    $0x5c,%eax
  800135:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80013e:	7e 0a                	jle    80014a <libmain+0x69>
		binaryname = argv[0];
  800140:	8b 45 0c             	mov    0xc(%ebp),%eax
  800143:	8b 00                	mov    (%eax),%eax
  800145:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80014a:	83 ec 08             	sub    $0x8,%esp
  80014d:	ff 75 0c             	pushl  0xc(%ebp)
  800150:	ff 75 08             	pushl  0x8(%ebp)
  800153:	e8 e0 fe ff ff       	call   800038 <_main>
  800158:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80015b:	e8 21 13 00 00       	call   801481 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	68 ec 1c 80 00       	push   $0x801cec
  800168:	e8 8d 01 00 00       	call   8002fa <cprintf>
  80016d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800170:	a1 20 30 80 00       	mov    0x803020,%eax
  800175:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  80017b:	a1 20 30 80 00       	mov    0x803020,%eax
  800180:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	52                   	push   %edx
  80018a:	50                   	push   %eax
  80018b:	68 14 1d 80 00       	push   $0x801d14
  800190:	e8 65 01 00 00       	call   8002fa <cprintf>
  800195:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800198:	a1 20 30 80 00       	mov    0x803020,%eax
  80019d:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  8001a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a8:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  8001ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b3:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  8001b9:	51                   	push   %ecx
  8001ba:	52                   	push   %edx
  8001bb:	50                   	push   %eax
  8001bc:	68 3c 1d 80 00       	push   $0x801d3c
  8001c1:	e8 34 01 00 00       	call   8002fa <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ce:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	50                   	push   %eax
  8001d8:	68 94 1d 80 00       	push   $0x801d94
  8001dd:	e8 18 01 00 00       	call   8002fa <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 ec 1c 80 00       	push   $0x801cec
  8001ed:	e8 08 01 00 00       	call   8002fa <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001f5:	e8 a1 12 00 00       	call   80149b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001fa:	e8 19 00 00 00       	call   800218 <exit>
}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	6a 00                	push   $0x0
  80020d:	e8 2e 14 00 00       	call   801640 <sys_destroy_env>
  800212:	83 c4 10             	add    $0x10,%esp
}
  800215:	90                   	nop
  800216:	c9                   	leave  
  800217:	c3                   	ret    

00800218 <exit>:

void
exit(void)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80021e:	e8 83 14 00 00       	call   8016a6 <sys_exit_env>
}
  800223:	90                   	nop
  800224:	c9                   	leave  
  800225:	c3                   	ret    

00800226 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80022c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022f:	8b 00                	mov    (%eax),%eax
  800231:	8d 48 01             	lea    0x1(%eax),%ecx
  800234:	8b 55 0c             	mov    0xc(%ebp),%edx
  800237:	89 0a                	mov    %ecx,(%edx)
  800239:	8b 55 08             	mov    0x8(%ebp),%edx
  80023c:	88 d1                	mov    %dl,%cl
  80023e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800241:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800245:	8b 45 0c             	mov    0xc(%ebp),%eax
  800248:	8b 00                	mov    (%eax),%eax
  80024a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024f:	75 2c                	jne    80027d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800251:	a0 24 30 80 00       	mov    0x803024,%al
  800256:	0f b6 c0             	movzbl %al,%eax
  800259:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025c:	8b 12                	mov    (%edx),%edx
  80025e:	89 d1                	mov    %edx,%ecx
  800260:	8b 55 0c             	mov    0xc(%ebp),%edx
  800263:	83 c2 08             	add    $0x8,%edx
  800266:	83 ec 04             	sub    $0x4,%esp
  800269:	50                   	push   %eax
  80026a:	51                   	push   %ecx
  80026b:	52                   	push   %edx
  80026c:	e8 b7 10 00 00       	call   801328 <sys_cputs>
  800271:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800274:	8b 45 0c             	mov    0xc(%ebp),%eax
  800277:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80027d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800280:	8b 40 04             	mov    0x4(%eax),%eax
  800283:	8d 50 01             	lea    0x1(%eax),%edx
  800286:	8b 45 0c             	mov    0xc(%ebp),%eax
  800289:	89 50 04             	mov    %edx,0x4(%eax)
}
  80028c:	90                   	nop
  80028d:	c9                   	leave  
  80028e:	c3                   	ret    

0080028f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800298:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80029f:	00 00 00 
	b.cnt = 0;
  8002a2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002ac:	ff 75 0c             	pushl  0xc(%ebp)
  8002af:	ff 75 08             	pushl  0x8(%ebp)
  8002b2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b8:	50                   	push   %eax
  8002b9:	68 26 02 80 00       	push   $0x800226
  8002be:	e8 11 02 00 00       	call   8004d4 <vprintfmt>
  8002c3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002c6:	a0 24 30 80 00       	mov    0x803024,%al
  8002cb:	0f b6 c0             	movzbl %al,%eax
  8002ce:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002d4:	83 ec 04             	sub    $0x4,%esp
  8002d7:	50                   	push   %eax
  8002d8:	52                   	push   %edx
  8002d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002df:	83 c0 08             	add    $0x8,%eax
  8002e2:	50                   	push   %eax
  8002e3:	e8 40 10 00 00       	call   801328 <sys_cputs>
  8002e8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002eb:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002f2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    

008002fa <cprintf>:

int cprintf(const char *fmt, ...) {
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800300:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800307:	8d 45 0c             	lea    0xc(%ebp),%eax
  80030a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	83 ec 08             	sub    $0x8,%esp
  800313:	ff 75 f4             	pushl  -0xc(%ebp)
  800316:	50                   	push   %eax
  800317:	e8 73 ff ff ff       	call   80028f <vcprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800322:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80032d:	e8 4f 11 00 00       	call   801481 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800332:	8d 45 0c             	lea    0xc(%ebp),%eax
  800335:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800338:	8b 45 08             	mov    0x8(%ebp),%eax
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	ff 75 f4             	pushl  -0xc(%ebp)
  800341:	50                   	push   %eax
  800342:	e8 48 ff ff ff       	call   80028f <vcprintf>
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80034d:	e8 49 11 00 00       	call   80149b <sys_enable_interrupt>
	return cnt;
  800352:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800355:	c9                   	leave  
  800356:	c3                   	ret    

00800357 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	53                   	push   %ebx
  80035b:	83 ec 14             	sub    $0x14,%esp
  80035e:	8b 45 10             	mov    0x10(%ebp),%eax
  800361:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800364:	8b 45 14             	mov    0x14(%ebp),%eax
  800367:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80036a:	8b 45 18             	mov    0x18(%ebp),%eax
  80036d:	ba 00 00 00 00       	mov    $0x0,%edx
  800372:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800375:	77 55                	ja     8003cc <printnum+0x75>
  800377:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80037a:	72 05                	jb     800381 <printnum+0x2a>
  80037c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80037f:	77 4b                	ja     8003cc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800381:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800384:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800387:	8b 45 18             	mov    0x18(%ebp),%eax
  80038a:	ba 00 00 00 00       	mov    $0x0,%edx
  80038f:	52                   	push   %edx
  800390:	50                   	push   %eax
  800391:	ff 75 f4             	pushl  -0xc(%ebp)
  800394:	ff 75 f0             	pushl  -0x10(%ebp)
  800397:	e8 9c 16 00 00       	call   801a38 <__udivdi3>
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	83 ec 04             	sub    $0x4,%esp
  8003a2:	ff 75 20             	pushl  0x20(%ebp)
  8003a5:	53                   	push   %ebx
  8003a6:	ff 75 18             	pushl  0x18(%ebp)
  8003a9:	52                   	push   %edx
  8003aa:	50                   	push   %eax
  8003ab:	ff 75 0c             	pushl  0xc(%ebp)
  8003ae:	ff 75 08             	pushl  0x8(%ebp)
  8003b1:	e8 a1 ff ff ff       	call   800357 <printnum>
  8003b6:	83 c4 20             	add    $0x20,%esp
  8003b9:	eb 1a                	jmp    8003d5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003bb:	83 ec 08             	sub    $0x8,%esp
  8003be:	ff 75 0c             	pushl  0xc(%ebp)
  8003c1:	ff 75 20             	pushl  0x20(%ebp)
  8003c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c7:	ff d0                	call   *%eax
  8003c9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003cc:	ff 4d 1c             	decl   0x1c(%ebp)
  8003cf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003d3:	7f e6                	jg     8003bb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003e3:	53                   	push   %ebx
  8003e4:	51                   	push   %ecx
  8003e5:	52                   	push   %edx
  8003e6:	50                   	push   %eax
  8003e7:	e8 5c 17 00 00       	call   801b48 <__umoddi3>
  8003ec:	83 c4 10             	add    $0x10,%esp
  8003ef:	05 d4 1f 80 00       	add    $0x801fd4,%eax
  8003f4:	8a 00                	mov    (%eax),%al
  8003f6:	0f be c0             	movsbl %al,%eax
  8003f9:	83 ec 08             	sub    $0x8,%esp
  8003fc:	ff 75 0c             	pushl  0xc(%ebp)
  8003ff:	50                   	push   %eax
  800400:	8b 45 08             	mov    0x8(%ebp),%eax
  800403:	ff d0                	call   *%eax
  800405:	83 c4 10             	add    $0x10,%esp
}
  800408:	90                   	nop
  800409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800411:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800415:	7e 1c                	jle    800433 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	8b 00                	mov    (%eax),%eax
  80041c:	8d 50 08             	lea    0x8(%eax),%edx
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
  800422:	89 10                	mov    %edx,(%eax)
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	83 e8 08             	sub    $0x8,%eax
  80042c:	8b 50 04             	mov    0x4(%eax),%edx
  80042f:	8b 00                	mov    (%eax),%eax
  800431:	eb 40                	jmp    800473 <getuint+0x65>
	else if (lflag)
  800433:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800437:	74 1e                	je     800457 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	8d 50 04             	lea    0x4(%eax),%edx
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	89 10                	mov    %edx,(%eax)
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	83 e8 04             	sub    $0x4,%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	ba 00 00 00 00       	mov    $0x0,%edx
  800455:	eb 1c                	jmp    800473 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 50 04             	lea    0x4(%eax),%edx
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
  800464:	8b 45 08             	mov    0x8(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	83 e8 04             	sub    $0x4,%eax
  80046c:	8b 00                	mov    (%eax),%eax
  80046e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800473:	5d                   	pop    %ebp
  800474:	c3                   	ret    

00800475 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800478:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80047c:	7e 1c                	jle    80049a <getint+0x25>
		return va_arg(*ap, long long);
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	8d 50 08             	lea    0x8(%eax),%edx
  800486:	8b 45 08             	mov    0x8(%ebp),%eax
  800489:	89 10                	mov    %edx,(%eax)
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	8b 00                	mov    (%eax),%eax
  800490:	83 e8 08             	sub    $0x8,%eax
  800493:	8b 50 04             	mov    0x4(%eax),%edx
  800496:	8b 00                	mov    (%eax),%eax
  800498:	eb 38                	jmp    8004d2 <getint+0x5d>
	else if (lflag)
  80049a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80049e:	74 1a                	je     8004ba <getint+0x45>
		return va_arg(*ap, long);
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	8d 50 04             	lea    0x4(%eax),%edx
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	89 10                	mov    %edx,(%eax)
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	83 e8 04             	sub    $0x4,%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	99                   	cltd   
  8004b8:	eb 18                	jmp    8004d2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	8d 50 04             	lea    0x4(%eax),%edx
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	89 10                	mov    %edx,(%eax)
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	83 e8 04             	sub    $0x4,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	99                   	cltd   
}
  8004d2:	5d                   	pop    %ebp
  8004d3:	c3                   	ret    

008004d4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	56                   	push   %esi
  8004d8:	53                   	push   %ebx
  8004d9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004dc:	eb 17                	jmp    8004f5 <vprintfmt+0x21>
			if (ch == '\0')
  8004de:	85 db                	test   %ebx,%ebx
  8004e0:	0f 84 af 03 00 00    	je     800895 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	ff 75 0c             	pushl  0xc(%ebp)
  8004ec:	53                   	push   %ebx
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	ff d0                	call   *%eax
  8004f2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f8:	8d 50 01             	lea    0x1(%eax),%edx
  8004fb:	89 55 10             	mov    %edx,0x10(%ebp)
  8004fe:	8a 00                	mov    (%eax),%al
  800500:	0f b6 d8             	movzbl %al,%ebx
  800503:	83 fb 25             	cmp    $0x25,%ebx
  800506:	75 d6                	jne    8004de <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800508:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80050c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800513:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80051a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800521:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800528:	8b 45 10             	mov    0x10(%ebp),%eax
  80052b:	8d 50 01             	lea    0x1(%eax),%edx
  80052e:	89 55 10             	mov    %edx,0x10(%ebp)
  800531:	8a 00                	mov    (%eax),%al
  800533:	0f b6 d8             	movzbl %al,%ebx
  800536:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800539:	83 f8 55             	cmp    $0x55,%eax
  80053c:	0f 87 2b 03 00 00    	ja     80086d <vprintfmt+0x399>
  800542:	8b 04 85 f8 1f 80 00 	mov    0x801ff8(,%eax,4),%eax
  800549:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80054b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80054f:	eb d7                	jmp    800528 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800551:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800555:	eb d1                	jmp    800528 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800557:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80055e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800561:	89 d0                	mov    %edx,%eax
  800563:	c1 e0 02             	shl    $0x2,%eax
  800566:	01 d0                	add    %edx,%eax
  800568:	01 c0                	add    %eax,%eax
  80056a:	01 d8                	add    %ebx,%eax
  80056c:	83 e8 30             	sub    $0x30,%eax
  80056f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800572:	8b 45 10             	mov    0x10(%ebp),%eax
  800575:	8a 00                	mov    (%eax),%al
  800577:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80057a:	83 fb 2f             	cmp    $0x2f,%ebx
  80057d:	7e 3e                	jle    8005bd <vprintfmt+0xe9>
  80057f:	83 fb 39             	cmp    $0x39,%ebx
  800582:	7f 39                	jg     8005bd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800584:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800587:	eb d5                	jmp    80055e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	83 c0 04             	add    $0x4,%eax
  80058f:	89 45 14             	mov    %eax,0x14(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	83 e8 04             	sub    $0x4,%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80059d:	eb 1f                	jmp    8005be <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80059f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a3:	79 83                	jns    800528 <vprintfmt+0x54>
				width = 0;
  8005a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005ac:	e9 77 ff ff ff       	jmp    800528 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005b1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005b8:	e9 6b ff ff ff       	jmp    800528 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005bd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005c2:	0f 89 60 ff ff ff    	jns    800528 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005d5:	e9 4e ff ff ff       	jmp    800528 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005dd:	e9 46 ff ff ff       	jmp    800528 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	83 c0 04             	add    $0x4,%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	83 e8 04             	sub    $0x4,%eax
  8005f1:	8b 00                	mov    (%eax),%eax
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	50                   	push   %eax
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	ff d0                	call   *%eax
  8005ff:	83 c4 10             	add    $0x10,%esp
			break;
  800602:	e9 89 02 00 00       	jmp    800890 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	83 c0 04             	add    $0x4,%eax
  80060d:	89 45 14             	mov    %eax,0x14(%ebp)
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	83 e8 04             	sub    $0x4,%eax
  800616:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800618:	85 db                	test   %ebx,%ebx
  80061a:	79 02                	jns    80061e <vprintfmt+0x14a>
				err = -err;
  80061c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80061e:	83 fb 64             	cmp    $0x64,%ebx
  800621:	7f 0b                	jg     80062e <vprintfmt+0x15a>
  800623:	8b 34 9d 40 1e 80 00 	mov    0x801e40(,%ebx,4),%esi
  80062a:	85 f6                	test   %esi,%esi
  80062c:	75 19                	jne    800647 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80062e:	53                   	push   %ebx
  80062f:	68 e5 1f 80 00       	push   $0x801fe5
  800634:	ff 75 0c             	pushl  0xc(%ebp)
  800637:	ff 75 08             	pushl  0x8(%ebp)
  80063a:	e8 5e 02 00 00       	call   80089d <printfmt>
  80063f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800642:	e9 49 02 00 00       	jmp    800890 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800647:	56                   	push   %esi
  800648:	68 ee 1f 80 00       	push   $0x801fee
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	ff 75 08             	pushl  0x8(%ebp)
  800653:	e8 45 02 00 00       	call   80089d <printfmt>
  800658:	83 c4 10             	add    $0x10,%esp
			break;
  80065b:	e9 30 02 00 00       	jmp    800890 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	83 c0 04             	add    $0x4,%eax
  800666:	89 45 14             	mov    %eax,0x14(%ebp)
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	83 e8 04             	sub    $0x4,%eax
  80066f:	8b 30                	mov    (%eax),%esi
  800671:	85 f6                	test   %esi,%esi
  800673:	75 05                	jne    80067a <vprintfmt+0x1a6>
				p = "(null)";
  800675:	be f1 1f 80 00       	mov    $0x801ff1,%esi
			if (width > 0 && padc != '-')
  80067a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067e:	7e 6d                	jle    8006ed <vprintfmt+0x219>
  800680:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800684:	74 67                	je     8006ed <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800686:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	50                   	push   %eax
  80068d:	56                   	push   %esi
  80068e:	e8 12 05 00 00       	call   800ba5 <strnlen>
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800699:	eb 16                	jmp    8006b1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80069b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	ff 75 0c             	pushl  0xc(%ebp)
  8006a5:	50                   	push   %eax
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	ff d0                	call   *%eax
  8006ab:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ae:	ff 4d e4             	decl   -0x1c(%ebp)
  8006b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b5:	7f e4                	jg     80069b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b7:	eb 34                	jmp    8006ed <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006bd:	74 1c                	je     8006db <vprintfmt+0x207>
  8006bf:	83 fb 1f             	cmp    $0x1f,%ebx
  8006c2:	7e 05                	jle    8006c9 <vprintfmt+0x1f5>
  8006c4:	83 fb 7e             	cmp    $0x7e,%ebx
  8006c7:	7e 12                	jle    8006db <vprintfmt+0x207>
					putch('?', putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	ff 75 0c             	pushl  0xc(%ebp)
  8006cf:	6a 3f                	push   $0x3f
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	ff d0                	call   *%eax
  8006d6:	83 c4 10             	add    $0x10,%esp
  8006d9:	eb 0f                	jmp    8006ea <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006db:	83 ec 08             	sub    $0x8,%esp
  8006de:	ff 75 0c             	pushl  0xc(%ebp)
  8006e1:	53                   	push   %ebx
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	ff d0                	call   *%eax
  8006e7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ed:	89 f0                	mov    %esi,%eax
  8006ef:	8d 70 01             	lea    0x1(%eax),%esi
  8006f2:	8a 00                	mov    (%eax),%al
  8006f4:	0f be d8             	movsbl %al,%ebx
  8006f7:	85 db                	test   %ebx,%ebx
  8006f9:	74 24                	je     80071f <vprintfmt+0x24b>
  8006fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ff:	78 b8                	js     8006b9 <vprintfmt+0x1e5>
  800701:	ff 4d e0             	decl   -0x20(%ebp)
  800704:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800708:	79 af                	jns    8006b9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80070a:	eb 13                	jmp    80071f <vprintfmt+0x24b>
				putch(' ', putdat);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	ff 75 0c             	pushl  0xc(%ebp)
  800712:	6a 20                	push   $0x20
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	ff d0                	call   *%eax
  800719:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80071c:	ff 4d e4             	decl   -0x1c(%ebp)
  80071f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800723:	7f e7                	jg     80070c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800725:	e9 66 01 00 00       	jmp    800890 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	ff 75 e8             	pushl  -0x18(%ebp)
  800730:	8d 45 14             	lea    0x14(%ebp),%eax
  800733:	50                   	push   %eax
  800734:	e8 3c fd ff ff       	call   800475 <getint>
  800739:	83 c4 10             	add    $0x10,%esp
  80073c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80073f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800745:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800748:	85 d2                	test   %edx,%edx
  80074a:	79 23                	jns    80076f <vprintfmt+0x29b>
				putch('-', putdat);
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	ff 75 0c             	pushl  0xc(%ebp)
  800752:	6a 2d                	push   $0x2d
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	ff d0                	call   *%eax
  800759:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80075c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800762:	f7 d8                	neg    %eax
  800764:	83 d2 00             	adc    $0x0,%edx
  800767:	f7 da                	neg    %edx
  800769:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80076f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800776:	e9 bc 00 00 00       	jmp    800837 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	ff 75 e8             	pushl  -0x18(%ebp)
  800781:	8d 45 14             	lea    0x14(%ebp),%eax
  800784:	50                   	push   %eax
  800785:	e8 84 fc ff ff       	call   80040e <getuint>
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800790:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800793:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80079a:	e9 98 00 00 00       	jmp    800837 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	ff 75 0c             	pushl  0xc(%ebp)
  8007a5:	6a 58                	push   $0x58
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	ff d0                	call   *%eax
  8007ac:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	6a 58                	push   $0x58
  8007b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ba:	ff d0                	call   *%eax
  8007bc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	ff 75 0c             	pushl  0xc(%ebp)
  8007c5:	6a 58                	push   $0x58
  8007c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ca:	ff d0                	call   *%eax
  8007cc:	83 c4 10             	add    $0x10,%esp
			break;
  8007cf:	e9 bc 00 00 00       	jmp    800890 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	ff 75 0c             	pushl  0xc(%ebp)
  8007da:	6a 30                	push   $0x30
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	ff d0                	call   *%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ea:	6a 78                	push   $0x78
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	ff d0                	call   *%eax
  8007f1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	83 c0 04             	add    $0x4,%eax
  8007fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	83 e8 04             	sub    $0x4,%eax
  800803:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800805:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800808:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80080f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800816:	eb 1f                	jmp    800837 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	ff 75 e8             	pushl  -0x18(%ebp)
  80081e:	8d 45 14             	lea    0x14(%ebp),%eax
  800821:	50                   	push   %eax
  800822:	e8 e7 fb ff ff       	call   80040e <getuint>
  800827:	83 c4 10             	add    $0x10,%esp
  80082a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800830:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800837:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80083b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80083e:	83 ec 04             	sub    $0x4,%esp
  800841:	52                   	push   %edx
  800842:	ff 75 e4             	pushl  -0x1c(%ebp)
  800845:	50                   	push   %eax
  800846:	ff 75 f4             	pushl  -0xc(%ebp)
  800849:	ff 75 f0             	pushl  -0x10(%ebp)
  80084c:	ff 75 0c             	pushl  0xc(%ebp)
  80084f:	ff 75 08             	pushl  0x8(%ebp)
  800852:	e8 00 fb ff ff       	call   800357 <printnum>
  800857:	83 c4 20             	add    $0x20,%esp
			break;
  80085a:	eb 34                	jmp    800890 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	53                   	push   %ebx
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	ff d0                	call   *%eax
  800868:	83 c4 10             	add    $0x10,%esp
			break;
  80086b:	eb 23                	jmp    800890 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	6a 25                	push   $0x25
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80087d:	ff 4d 10             	decl   0x10(%ebp)
  800880:	eb 03                	jmp    800885 <vprintfmt+0x3b1>
  800882:	ff 4d 10             	decl   0x10(%ebp)
  800885:	8b 45 10             	mov    0x10(%ebp),%eax
  800888:	48                   	dec    %eax
  800889:	8a 00                	mov    (%eax),%al
  80088b:	3c 25                	cmp    $0x25,%al
  80088d:	75 f3                	jne    800882 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80088f:	90                   	nop
		}
	}
  800890:	e9 47 fc ff ff       	jmp    8004dc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800895:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800896:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800899:	5b                   	pop    %ebx
  80089a:	5e                   	pop    %esi
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    

0080089d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008a6:	83 c0 04             	add    $0x4,%eax
  8008a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8008af:	ff 75 f4             	pushl  -0xc(%ebp)
  8008b2:	50                   	push   %eax
  8008b3:	ff 75 0c             	pushl  0xc(%ebp)
  8008b6:	ff 75 08             	pushl  0x8(%ebp)
  8008b9:	e8 16 fc ff ff       	call   8004d4 <vprintfmt>
  8008be:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008c1:	90                   	nop
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

008008c4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ca:	8b 40 08             	mov    0x8(%eax),%eax
  8008cd:	8d 50 01             	lea    0x1(%eax),%edx
  8008d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d9:	8b 10                	mov    (%eax),%edx
  8008db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008de:	8b 40 04             	mov    0x4(%eax),%eax
  8008e1:	39 c2                	cmp    %eax,%edx
  8008e3:	73 12                	jae    8008f7 <sprintputch+0x33>
		*b->buf++ = ch;
  8008e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 48 01             	lea    0x1(%eax),%ecx
  8008ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f0:	89 0a                	mov    %ecx,(%edx)
  8008f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f5:	88 10                	mov    %dl,(%eax)
}
  8008f7:	90                   	nop
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800906:	8b 45 0c             	mov    0xc(%ebp),%eax
  800909:	8d 50 ff             	lea    -0x1(%eax),%edx
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	01 d0                	add    %edx,%eax
  800911:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800914:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80091b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80091f:	74 06                	je     800927 <vsnprintf+0x2d>
  800921:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800925:	7f 07                	jg     80092e <vsnprintf+0x34>
		return -E_INVAL;
  800927:	b8 03 00 00 00       	mov    $0x3,%eax
  80092c:	eb 20                	jmp    80094e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80092e:	ff 75 14             	pushl  0x14(%ebp)
  800931:	ff 75 10             	pushl  0x10(%ebp)
  800934:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800937:	50                   	push   %eax
  800938:	68 c4 08 80 00       	push   $0x8008c4
  80093d:	e8 92 fb ff ff       	call   8004d4 <vprintfmt>
  800942:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800945:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800948:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80094b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80094e:	c9                   	leave  
  80094f:	c3                   	ret    

00800950 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800956:	8d 45 10             	lea    0x10(%ebp),%eax
  800959:	83 c0 04             	add    $0x4,%eax
  80095c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80095f:	8b 45 10             	mov    0x10(%ebp),%eax
  800962:	ff 75 f4             	pushl  -0xc(%ebp)
  800965:	50                   	push   %eax
  800966:	ff 75 0c             	pushl  0xc(%ebp)
  800969:	ff 75 08             	pushl  0x8(%ebp)
  80096c:	e8 89 ff ff ff       	call   8008fa <vsnprintf>
  800971:	83 c4 10             	add    $0x10,%esp
  800974:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800977:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    

0080097c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800982:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800986:	74 13                	je     80099b <readline+0x1f>
		cprintf("%s", prompt);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 08             	pushl  0x8(%ebp)
  80098e:	68 50 21 80 00       	push   $0x802150
  800993:	e8 62 f9 ff ff       	call   8002fa <cprintf>
  800998:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80099b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009a2:	83 ec 0c             	sub    $0xc,%esp
  8009a5:	6a 00                	push   $0x0
  8009a7:	e8 80 10 00 00       	call   801a2c <iscons>
  8009ac:	83 c4 10             	add    $0x10,%esp
  8009af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009b2:	e8 27 10 00 00       	call   8019de <getchar>
  8009b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009be:	79 22                	jns    8009e2 <readline+0x66>
			if (c != -E_EOF)
  8009c0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009c4:	0f 84 ad 00 00 00    	je     800a77 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 ec             	pushl  -0x14(%ebp)
  8009d0:	68 53 21 80 00       	push   $0x802153
  8009d5:	e8 20 f9 ff ff       	call   8002fa <cprintf>
  8009da:	83 c4 10             	add    $0x10,%esp
			return;
  8009dd:	e9 95 00 00 00       	jmp    800a77 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009e2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009e6:	7e 34                	jle    800a1c <readline+0xa0>
  8009e8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009ef:	7f 2b                	jg     800a1c <readline+0xa0>
			if (echoing)
  8009f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009f5:	74 0e                	je     800a05 <readline+0x89>
				cputchar(c);
  8009f7:	83 ec 0c             	sub    $0xc,%esp
  8009fa:	ff 75 ec             	pushl  -0x14(%ebp)
  8009fd:	e8 94 0f 00 00       	call   801996 <cputchar>
  800a02:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a08:	8d 50 01             	lea    0x1(%eax),%edx
  800a0b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a0e:	89 c2                	mov    %eax,%edx
  800a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a13:	01 d0                	add    %edx,%eax
  800a15:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a18:	88 10                	mov    %dl,(%eax)
  800a1a:	eb 56                	jmp    800a72 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a1c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a20:	75 1f                	jne    800a41 <readline+0xc5>
  800a22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a26:	7e 19                	jle    800a41 <readline+0xc5>
			if (echoing)
  800a28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a2c:	74 0e                	je     800a3c <readline+0xc0>
				cputchar(c);
  800a2e:	83 ec 0c             	sub    $0xc,%esp
  800a31:	ff 75 ec             	pushl  -0x14(%ebp)
  800a34:	e8 5d 0f 00 00       	call   801996 <cputchar>
  800a39:	83 c4 10             	add    $0x10,%esp

			i--;
  800a3c:	ff 4d f4             	decl   -0xc(%ebp)
  800a3f:	eb 31                	jmp    800a72 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a41:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a45:	74 0a                	je     800a51 <readline+0xd5>
  800a47:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a4b:	0f 85 61 ff ff ff    	jne    8009b2 <readline+0x36>
			if (echoing)
  800a51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a55:	74 0e                	je     800a65 <readline+0xe9>
				cputchar(c);
  800a57:	83 ec 0c             	sub    $0xc,%esp
  800a5a:	ff 75 ec             	pushl  -0x14(%ebp)
  800a5d:	e8 34 0f 00 00       	call   801996 <cputchar>
  800a62:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6b:	01 d0                	add    %edx,%eax
  800a6d:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a70:	eb 06                	jmp    800a78 <readline+0xfc>
		}
	}
  800a72:	e9 3b ff ff ff       	jmp    8009b2 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a77:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a80:	e8 fc 09 00 00       	call   801481 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a89:	74 13                	je     800a9e <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a8b:	83 ec 08             	sub    $0x8,%esp
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	68 50 21 80 00       	push   $0x802150
  800a96:	e8 5f f8 ff ff       	call   8002fa <cprintf>
  800a9b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800aa5:	83 ec 0c             	sub    $0xc,%esp
  800aa8:	6a 00                	push   $0x0
  800aaa:	e8 7d 0f 00 00       	call   801a2c <iscons>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800ab5:	e8 24 0f 00 00       	call   8019de <getchar>
  800aba:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800abd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ac1:	79 23                	jns    800ae6 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800ac3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ac7:	74 13                	je     800adc <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800ac9:	83 ec 08             	sub    $0x8,%esp
  800acc:	ff 75 ec             	pushl  -0x14(%ebp)
  800acf:	68 53 21 80 00       	push   $0x802153
  800ad4:	e8 21 f8 ff ff       	call   8002fa <cprintf>
  800ad9:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800adc:	e8 ba 09 00 00       	call   80149b <sys_enable_interrupt>
			return;
  800ae1:	e9 9a 00 00 00       	jmp    800b80 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ae6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800aea:	7e 34                	jle    800b20 <atomic_readline+0xa6>
  800aec:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800af3:	7f 2b                	jg     800b20 <atomic_readline+0xa6>
			if (echoing)
  800af5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800af9:	74 0e                	je     800b09 <atomic_readline+0x8f>
				cputchar(c);
  800afb:	83 ec 0c             	sub    $0xc,%esp
  800afe:	ff 75 ec             	pushl  -0x14(%ebp)
  800b01:	e8 90 0e 00 00       	call   801996 <cputchar>
  800b06:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b0c:	8d 50 01             	lea    0x1(%eax),%edx
  800b0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b12:	89 c2                	mov    %eax,%edx
  800b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b17:	01 d0                	add    %edx,%eax
  800b19:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b1c:	88 10                	mov    %dl,(%eax)
  800b1e:	eb 5b                	jmp    800b7b <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800b20:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b24:	75 1f                	jne    800b45 <atomic_readline+0xcb>
  800b26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b2a:	7e 19                	jle    800b45 <atomic_readline+0xcb>
			if (echoing)
  800b2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b30:	74 0e                	je     800b40 <atomic_readline+0xc6>
				cputchar(c);
  800b32:	83 ec 0c             	sub    $0xc,%esp
  800b35:	ff 75 ec             	pushl  -0x14(%ebp)
  800b38:	e8 59 0e 00 00       	call   801996 <cputchar>
  800b3d:	83 c4 10             	add    $0x10,%esp
			i--;
  800b40:	ff 4d f4             	decl   -0xc(%ebp)
  800b43:	eb 36                	jmp    800b7b <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b45:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b49:	74 0a                	je     800b55 <atomic_readline+0xdb>
  800b4b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b4f:	0f 85 60 ff ff ff    	jne    800ab5 <atomic_readline+0x3b>
			if (echoing)
  800b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b59:	74 0e                	je     800b69 <atomic_readline+0xef>
				cputchar(c);
  800b5b:	83 ec 0c             	sub    $0xc,%esp
  800b5e:	ff 75 ec             	pushl  -0x14(%ebp)
  800b61:	e8 30 0e 00 00       	call   801996 <cputchar>
  800b66:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6f:	01 d0                	add    %edx,%eax
  800b71:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b74:	e8 22 09 00 00       	call   80149b <sys_enable_interrupt>
			return;
  800b79:	eb 05                	jmp    800b80 <atomic_readline+0x106>
		}
	}
  800b7b:	e9 35 ff ff ff       	jmp    800ab5 <atomic_readline+0x3b>
}
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b8f:	eb 06                	jmp    800b97 <strlen+0x15>
		n++;
  800b91:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b94:	ff 45 08             	incl   0x8(%ebp)
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8a 00                	mov    (%eax),%al
  800b9c:	84 c0                	test   %al,%al
  800b9e:	75 f1                	jne    800b91 <strlen+0xf>
		n++;
	return n;
  800ba0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    

00800ba5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb2:	eb 09                	jmp    800bbd <strnlen+0x18>
		n++;
  800bb4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb7:	ff 45 08             	incl   0x8(%ebp)
  800bba:	ff 4d 0c             	decl   0xc(%ebp)
  800bbd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc1:	74 09                	je     800bcc <strnlen+0x27>
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	8a 00                	mov    (%eax),%al
  800bc8:	84 c0                	test   %al,%al
  800bca:	75 e8                	jne    800bb4 <strnlen+0xf>
		n++;
	return n;
  800bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bdd:	90                   	nop
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8d 50 01             	lea    0x1(%eax),%edx
  800be4:	89 55 08             	mov    %edx,0x8(%ebp)
  800be7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bf0:	8a 12                	mov    (%edx),%dl
  800bf2:	88 10                	mov    %dl,(%eax)
  800bf4:	8a 00                	mov    (%eax),%al
  800bf6:	84 c0                	test   %al,%al
  800bf8:	75 e4                	jne    800bde <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfd:	c9                   	leave  
  800bfe:	c3                   	ret    

00800bff <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c12:	eb 1f                	jmp    800c33 <strncpy+0x34>
		*dst++ = *src;
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c20:	8a 12                	mov    (%edx),%dl
  800c22:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	74 03                	je     800c30 <strncpy+0x31>
			src++;
  800c2d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c30:	ff 45 fc             	incl   -0x4(%ebp)
  800c33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c36:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c39:	72 d9                	jb     800c14 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c3e:	c9                   	leave  
  800c3f:	c3                   	ret    

00800c40 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c50:	74 30                	je     800c82 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c52:	eb 16                	jmp    800c6a <strlcpy+0x2a>
			*dst++ = *src++;
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	8d 50 01             	lea    0x1(%eax),%edx
  800c5a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c60:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c63:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c66:	8a 12                	mov    (%edx),%dl
  800c68:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c6a:	ff 4d 10             	decl   0x10(%ebp)
  800c6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c71:	74 09                	je     800c7c <strlcpy+0x3c>
  800c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 d8                	jne    800c54 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c82:	8b 55 08             	mov    0x8(%ebp),%edx
  800c85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c88:	29 c2                	sub    %eax,%edx
  800c8a:	89 d0                	mov    %edx,%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c91:	eb 06                	jmp    800c99 <strcmp+0xb>
		p++, q++;
  800c93:	ff 45 08             	incl   0x8(%ebp)
  800c96:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8a 00                	mov    (%eax),%al
  800c9e:	84 c0                	test   %al,%al
  800ca0:	74 0e                	je     800cb0 <strcmp+0x22>
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8a 10                	mov    (%eax),%dl
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	8a 00                	mov    (%eax),%al
  800cac:	38 c2                	cmp    %al,%dl
  800cae:	74 e3                	je     800c93 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8a 00                	mov    (%eax),%al
  800cb5:	0f b6 d0             	movzbl %al,%edx
  800cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	0f b6 c0             	movzbl %al,%eax
  800cc0:	29 c2                	sub    %eax,%edx
  800cc2:	89 d0                	mov    %edx,%eax
}
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cc9:	eb 09                	jmp    800cd4 <strncmp+0xe>
		n--, p++, q++;
  800ccb:	ff 4d 10             	decl   0x10(%ebp)
  800cce:	ff 45 08             	incl   0x8(%ebp)
  800cd1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd8:	74 17                	je     800cf1 <strncmp+0x2b>
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	74 0e                	je     800cf1 <strncmp+0x2b>
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 10                	mov    (%eax),%dl
  800ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	38 c2                	cmp    %al,%dl
  800cef:	74 da                	je     800ccb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cf1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf5:	75 07                	jne    800cfe <strncmp+0x38>
		return 0;
  800cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfc:	eb 14                	jmp    800d12 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 d0             	movzbl %al,%edx
  800d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	0f b6 c0             	movzbl %al,%eax
  800d0e:	29 c2                	sub    %eax,%edx
  800d10:	89 d0                	mov    %edx,%eax
}
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 04             	sub    $0x4,%esp
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d20:	eb 12                	jmp    800d34 <strchr+0x20>
		if (*s == c)
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d2a:	75 05                	jne    800d31 <strchr+0x1d>
			return (char *) s;
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	eb 11                	jmp    800d42 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d31:	ff 45 08             	incl   0x8(%ebp)
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	84 c0                	test   %al,%al
  800d3b:	75 e5                	jne    800d22 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d42:	c9                   	leave  
  800d43:	c3                   	ret    

00800d44 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	83 ec 04             	sub    $0x4,%esp
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d50:	eb 0d                	jmp    800d5f <strfind+0x1b>
		if (*s == c)
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5a:	74 0e                	je     800d6a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	75 ea                	jne    800d52 <strfind+0xe>
  800d68:	eb 01                	jmp    800d6b <strfind+0x27>
		if (*s == c)
			break;
  800d6a:	90                   	nop
	return (char *) s;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <memset>:

int i=0;
void *
memset(void *v, int c, uint32 n)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	83 ec 10             	sub    $0x10,%esp


	i++;
  800d76:	a1 28 30 80 00       	mov    0x803028,%eax
  800d7b:	40                   	inc    %eax
  800d7c:	a3 28 30 80 00       	mov    %eax,0x803028

	char *p;
	int m;

	p = v;
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d87:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8a:	89 45 f8             	mov    %eax,-0x8(%ebp)


	while (--m >= 0){
  800d8d:	eb 0e                	jmp    800d9d <memset+0x2d>

		*p++ = c;
  800d8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d92:	8d 50 01             	lea    0x1(%eax),%edx
  800d95:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9b:	88 10                	mov    %dl,(%eax)

	p = v;
	m = n;


	while (--m >= 0){
  800d9d:	ff 4d f8             	decl   -0x8(%ebp)
  800da0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800da4:	79 e9                	jns    800d8f <memset+0x1f>

		*p++ = c;
	}

	return v;
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da9:	c9                   	leave  
  800daa:	c3                   	ret    

00800dab <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dbd:	eb 16                	jmp    800dd5 <memcpy+0x2a>
		*d++ = *s++;
  800dbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc2:	8d 50 01             	lea    0x1(%eax),%edx
  800dc5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dc8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dcb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dce:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dd1:	8a 12                	mov    (%edx),%dl
  800dd3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dde:	85 c0                	test   %eax,%eax
  800de0:	75 dd                	jne    800dbf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de5:	c9                   	leave  
  800de6:	c3                   	ret    

00800de7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800df9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dff:	73 50                	jae    800e51 <memmove+0x6a>
  800e01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e04:	8b 45 10             	mov    0x10(%ebp),%eax
  800e07:	01 d0                	add    %edx,%eax
  800e09:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e0c:	76 43                	jbe    800e51 <memmove+0x6a>
		s += n;
  800e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e11:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e14:	8b 45 10             	mov    0x10(%ebp),%eax
  800e17:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e1a:	eb 10                	jmp    800e2c <memmove+0x45>
			*--d = *--s;
  800e1c:	ff 4d f8             	decl   -0x8(%ebp)
  800e1f:	ff 4d fc             	decl   -0x4(%ebp)
  800e22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e25:	8a 10                	mov    (%eax),%dl
  800e27:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e32:	89 55 10             	mov    %edx,0x10(%ebp)
  800e35:	85 c0                	test   %eax,%eax
  800e37:	75 e3                	jne    800e1c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e39:	eb 23                	jmp    800e5e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3e:	8d 50 01             	lea    0x1(%eax),%edx
  800e41:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e44:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e47:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e4d:	8a 12                	mov    (%edx),%dl
  800e4f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e51:	8b 45 10             	mov    0x10(%ebp),%eax
  800e54:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e57:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	75 dd                	jne    800e3b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e61:	c9                   	leave  
  800e62:	c3                   	ret    

00800e63 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e75:	eb 2a                	jmp    800ea1 <memcmp+0x3e>
		if (*s1 != *s2)
  800e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7a:	8a 10                	mov    (%eax),%dl
  800e7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7f:	8a 00                	mov    (%eax),%al
  800e81:	38 c2                	cmp    %al,%dl
  800e83:	74 16                	je     800e9b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	0f b6 d0             	movzbl %al,%edx
  800e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e90:	8a 00                	mov    (%eax),%al
  800e92:	0f b6 c0             	movzbl %al,%eax
  800e95:	29 c2                	sub    %eax,%edx
  800e97:	89 d0                	mov    %edx,%eax
  800e99:	eb 18                	jmp    800eb3 <memcmp+0x50>
		s1++, s2++;
  800e9b:	ff 45 fc             	incl   -0x4(%ebp)
  800e9e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ea1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea7:	89 55 10             	mov    %edx,0x10(%ebp)
  800eaa:	85 c0                	test   %eax,%eax
  800eac:	75 c9                	jne    800e77 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb3:	c9                   	leave  
  800eb4:	c3                   	ret    

00800eb5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	01 d0                	add    %edx,%eax
  800ec3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ec6:	eb 15                	jmp    800edd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	8a 00                	mov    (%eax),%al
  800ecd:	0f b6 d0             	movzbl %al,%edx
  800ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed3:	0f b6 c0             	movzbl %al,%eax
  800ed6:	39 c2                	cmp    %eax,%edx
  800ed8:	74 0d                	je     800ee7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eda:	ff 45 08             	incl   0x8(%ebp)
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee3:	72 e3                	jb     800ec8 <memfind+0x13>
  800ee5:	eb 01                	jmp    800ee8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ee7:	90                   	nop
	return (void *) s;
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    

00800eed <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ef3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800efa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f01:	eb 03                	jmp    800f06 <strtol+0x19>
		s++;
  800f03:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	8a 00                	mov    (%eax),%al
  800f0b:	3c 20                	cmp    $0x20,%al
  800f0d:	74 f4                	je     800f03 <strtol+0x16>
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	3c 09                	cmp    $0x9,%al
  800f16:	74 eb                	je     800f03 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	3c 2b                	cmp    $0x2b,%al
  800f1f:	75 05                	jne    800f26 <strtol+0x39>
		s++;
  800f21:	ff 45 08             	incl   0x8(%ebp)
  800f24:	eb 13                	jmp    800f39 <strtol+0x4c>
	else if (*s == '-')
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 2d                	cmp    $0x2d,%al
  800f2d:	75 0a                	jne    800f39 <strtol+0x4c>
		s++, neg = 1;
  800f2f:	ff 45 08             	incl   0x8(%ebp)
  800f32:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3d:	74 06                	je     800f45 <strtol+0x58>
  800f3f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f43:	75 20                	jne    800f65 <strtol+0x78>
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	3c 30                	cmp    $0x30,%al
  800f4c:	75 17                	jne    800f65 <strtol+0x78>
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	40                   	inc    %eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	3c 78                	cmp    $0x78,%al
  800f56:	75 0d                	jne    800f65 <strtol+0x78>
		s += 2, base = 16;
  800f58:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f5c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f63:	eb 28                	jmp    800f8d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f69:	75 15                	jne    800f80 <strtol+0x93>
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	3c 30                	cmp    $0x30,%al
  800f72:	75 0c                	jne    800f80 <strtol+0x93>
		s++, base = 8;
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f7e:	eb 0d                	jmp    800f8d <strtol+0xa0>
	else if (base == 0)
  800f80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f84:	75 07                	jne    800f8d <strtol+0xa0>
		base = 10;
  800f86:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	3c 2f                	cmp    $0x2f,%al
  800f94:	7e 19                	jle    800faf <strtol+0xc2>
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 39                	cmp    $0x39,%al
  800f9d:	7f 10                	jg     800faf <strtol+0xc2>
			dig = *s - '0';
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	0f be c0             	movsbl %al,%eax
  800fa7:	83 e8 30             	sub    $0x30,%eax
  800faa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fad:	eb 42                	jmp    800ff1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	3c 60                	cmp    $0x60,%al
  800fb6:	7e 19                	jle    800fd1 <strtol+0xe4>
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 7a                	cmp    $0x7a,%al
  800fbf:	7f 10                	jg     800fd1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	0f be c0             	movsbl %al,%eax
  800fc9:	83 e8 57             	sub    $0x57,%eax
  800fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fcf:	eb 20                	jmp    800ff1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 40                	cmp    $0x40,%al
  800fd8:	7e 39                	jle    801013 <strtol+0x126>
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 5a                	cmp    $0x5a,%al
  800fe1:	7f 30                	jg     801013 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	0f be c0             	movsbl %al,%eax
  800feb:	83 e8 37             	sub    $0x37,%eax
  800fee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ff7:	7d 19                	jge    801012 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ff9:	ff 45 08             	incl   0x8(%ebp)
  800ffc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fff:	0f af 45 10          	imul   0x10(%ebp),%eax
  801003:	89 c2                	mov    %eax,%edx
  801005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801008:	01 d0                	add    %edx,%eax
  80100a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80100d:	e9 7b ff ff ff       	jmp    800f8d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801012:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801013:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801017:	74 08                	je     801021 <strtol+0x134>
		*endptr = (char *) s;
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	8b 55 08             	mov    0x8(%ebp),%edx
  80101f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801021:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801025:	74 07                	je     80102e <strtol+0x141>
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	f7 d8                	neg    %eax
  80102c:	eb 03                	jmp    801031 <strtol+0x144>
  80102e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801031:	c9                   	leave  
  801032:	c3                   	ret    

00801033 <ltostr>:

void
ltostr(long value, char *str)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801040:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801047:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104b:	79 13                	jns    801060 <ltostr+0x2d>
	{
		neg = 1;
  80104d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80105a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80105d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801068:	99                   	cltd   
  801069:	f7 f9                	idiv   %ecx
  80106b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80106e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801071:	8d 50 01             	lea    0x1(%eax),%edx
  801074:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801077:	89 c2                	mov    %eax,%edx
  801079:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107c:	01 d0                	add    %edx,%eax
  80107e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801081:	83 c2 30             	add    $0x30,%edx
  801084:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801086:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801089:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80108e:	f7 e9                	imul   %ecx
  801090:	c1 fa 02             	sar    $0x2,%edx
  801093:	89 c8                	mov    %ecx,%eax
  801095:	c1 f8 1f             	sar    $0x1f,%eax
  801098:	29 c2                	sub    %eax,%edx
  80109a:	89 d0                	mov    %edx,%eax
  80109c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80109f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a7:	f7 e9                	imul   %ecx
  8010a9:	c1 fa 02             	sar    $0x2,%edx
  8010ac:	89 c8                	mov    %ecx,%eax
  8010ae:	c1 f8 1f             	sar    $0x1f,%eax
  8010b1:	29 c2                	sub    %eax,%edx
  8010b3:	89 d0                	mov    %edx,%eax
  8010b5:	c1 e0 02             	shl    $0x2,%eax
  8010b8:	01 d0                	add    %edx,%eax
  8010ba:	01 c0                	add    %eax,%eax
  8010bc:	29 c1                	sub    %eax,%ecx
  8010be:	89 ca                	mov    %ecx,%edx
  8010c0:	85 d2                	test   %edx,%edx
  8010c2:	75 9c                	jne    801060 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ce:	48                   	dec    %eax
  8010cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010d6:	74 3d                	je     801115 <ltostr+0xe2>
		start = 1 ;
  8010d8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010df:	eb 34                	jmp    801115 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e7:	01 d0                	add    %edx,%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f4:	01 c2                	add    %eax,%edx
  8010f6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fc:	01 c8                	add    %ecx,%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801102:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801105:	8b 45 0c             	mov    0xc(%ebp),%eax
  801108:	01 c2                	add    %eax,%edx
  80110a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80110d:	88 02                	mov    %al,(%edx)
		start++ ;
  80110f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801112:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801118:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80111b:	7c c4                	jl     8010e1 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80111d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	01 d0                	add    %edx,%eax
  801125:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801128:	90                   	nop
  801129:	c9                   	leave  
  80112a:	c3                   	ret    

0080112b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801131:	ff 75 08             	pushl  0x8(%ebp)
  801134:	e8 49 fa ff ff       	call   800b82 <strlen>
  801139:	83 c4 04             	add    $0x4,%esp
  80113c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80113f:	ff 75 0c             	pushl  0xc(%ebp)
  801142:	e8 3b fa ff ff       	call   800b82 <strlen>
  801147:	83 c4 04             	add    $0x4,%esp
  80114a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80114d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801154:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80115b:	eb 17                	jmp    801174 <strcconcat+0x49>
		final[s] = str1[s] ;
  80115d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801160:	8b 45 10             	mov    0x10(%ebp),%eax
  801163:	01 c2                	add    %eax,%edx
  801165:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	01 c8                	add    %ecx,%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801171:	ff 45 fc             	incl   -0x4(%ebp)
  801174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801177:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80117a:	7c e1                	jl     80115d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80117c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801183:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80118a:	eb 1f                	jmp    8011ab <strcconcat+0x80>
		final[s++] = str2[i] ;
  80118c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801195:	89 c2                	mov    %eax,%edx
  801197:	8b 45 10             	mov    0x10(%ebp),%eax
  80119a:	01 c2                	add    %eax,%edx
  80119c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80119f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a2:	01 c8                	add    %ecx,%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011a8:	ff 45 f8             	incl   -0x8(%ebp)
  8011ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011b1:	7c d9                	jl     80118c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	01 d0                	add    %edx,%eax
  8011bb:	c6 00 00             	movb   $0x0,(%eax)
}
  8011be:	90                   	nop
  8011bf:	c9                   	leave  
  8011c0:	c3                   	ret    

008011c1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d0:	8b 00                	mov    (%eax),%eax
  8011d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dc:	01 d0                	add    %edx,%eax
  8011de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e4:	eb 0c                	jmp    8011f2 <strsplit+0x31>
			*string++ = 0;
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ef:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	84 c0                	test   %al,%al
  8011f9:	74 18                	je     801213 <strsplit+0x52>
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	0f be c0             	movsbl %al,%eax
  801203:	50                   	push   %eax
  801204:	ff 75 0c             	pushl  0xc(%ebp)
  801207:	e8 08 fb ff ff       	call   800d14 <strchr>
  80120c:	83 c4 08             	add    $0x8,%esp
  80120f:	85 c0                	test   %eax,%eax
  801211:	75 d3                	jne    8011e6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	84 c0                	test   %al,%al
  80121a:	74 5a                	je     801276 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80121c:	8b 45 14             	mov    0x14(%ebp),%eax
  80121f:	8b 00                	mov    (%eax),%eax
  801221:	83 f8 0f             	cmp    $0xf,%eax
  801224:	75 07                	jne    80122d <strsplit+0x6c>
		{
			return 0;
  801226:	b8 00 00 00 00       	mov    $0x0,%eax
  80122b:	eb 66                	jmp    801293 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80122d:	8b 45 14             	mov    0x14(%ebp),%eax
  801230:	8b 00                	mov    (%eax),%eax
  801232:	8d 48 01             	lea    0x1(%eax),%ecx
  801235:	8b 55 14             	mov    0x14(%ebp),%edx
  801238:	89 0a                	mov    %ecx,(%edx)
  80123a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801241:	8b 45 10             	mov    0x10(%ebp),%eax
  801244:	01 c2                	add    %eax,%edx
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124b:	eb 03                	jmp    801250 <strsplit+0x8f>
			string++;
  80124d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	84 c0                	test   %al,%al
  801257:	74 8b                	je     8011e4 <strsplit+0x23>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	0f be c0             	movsbl %al,%eax
  801261:	50                   	push   %eax
  801262:	ff 75 0c             	pushl  0xc(%ebp)
  801265:	e8 aa fa ff ff       	call   800d14 <strchr>
  80126a:	83 c4 08             	add    $0x8,%esp
  80126d:	85 c0                	test   %eax,%eax
  80126f:	74 dc                	je     80124d <strsplit+0x8c>
			string++;
	}
  801271:	e9 6e ff ff ff       	jmp    8011e4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801276:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801283:	8b 45 10             	mov    0x10(%ebp),%eax
  801286:	01 d0                	add    %edx,%eax
  801288:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80128e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801293:	c9                   	leave  
  801294:	c3                   	ret    

00801295 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  80129b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80129f:	74 06                	je     8012a7 <str2lower+0x12>
  8012a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012a5:	75 07                	jne    8012ae <str2lower+0x19>
		return NULL;
  8012a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ac:	eb 4d                	jmp    8012fb <str2lower+0x66>
	}
	char *ref=dst;
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  8012b4:	eb 33                	jmp    8012e9 <str2lower+0x54>
			if(*src>=65&&*src<=90){
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	3c 40                	cmp    $0x40,%al
  8012bd:	7e 1a                	jle    8012d9 <str2lower+0x44>
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	3c 5a                	cmp    $0x5a,%al
  8012c6:	7f 11                	jg     8012d9 <str2lower+0x44>
				*dst=*src+32;
  8012c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	83 c0 20             	add    $0x20,%eax
  8012d0:	88 c2                	mov    %al,%dl
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	88 10                	mov    %dl,(%eax)
  8012d7:	eb 0a                	jmp    8012e3 <str2lower+0x4e>
			}
			else{
				*dst=*src;
  8012d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dc:	8a 10                	mov    (%eax),%dl
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	88 10                	mov    %dl,(%eax)
			}
			src++;
  8012e3:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  8012e6:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  8012e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	84 c0                	test   %al,%al
  8012f0:	75 c4                	jne    8012b6 <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  8012f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    

008012fd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	57                   	push   %edi
  801301:	56                   	push   %esi
  801302:	53                   	push   %ebx
  801303:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80130f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801312:	8b 7d 18             	mov    0x18(%ebp),%edi
  801315:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801318:	cd 30                	int    $0x30
  80131a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80131d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801320:	83 c4 10             	add    $0x10,%esp
  801323:	5b                   	pop    %ebx
  801324:	5e                   	pop    %esi
  801325:	5f                   	pop    %edi
  801326:	5d                   	pop    %ebp
  801327:	c3                   	ret    

00801328 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	83 ec 04             	sub    $0x4,%esp
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801334:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	52                   	push   %edx
  801340:	ff 75 0c             	pushl  0xc(%ebp)
  801343:	50                   	push   %eax
  801344:	6a 00                	push   $0x0
  801346:	e8 b2 ff ff ff       	call   8012fd <syscall>
  80134b:	83 c4 18             	add    $0x18,%esp
}
  80134e:	90                   	nop
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <sys_cgetc>:

int
sys_cgetc(void)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 01                	push   $0x1
  801360:	e8 98 ff ff ff       	call   8012fd <syscall>
  801365:	83 c4 18             	add    $0x18,%esp
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80136d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	52                   	push   %edx
  80137a:	50                   	push   %eax
  80137b:	6a 05                	push   $0x5
  80137d:	e8 7b ff ff ff       	call   8012fd <syscall>
  801382:	83 c4 18             	add    $0x18,%esp
}
  801385:	c9                   	leave  
  801386:	c3                   	ret    

00801387 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	56                   	push   %esi
  80138b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80138c:	8b 75 18             	mov    0x18(%ebp),%esi
  80138f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801392:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801395:	8b 55 0c             	mov    0xc(%ebp),%edx
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	56                   	push   %esi
  80139c:	53                   	push   %ebx
  80139d:	51                   	push   %ecx
  80139e:	52                   	push   %edx
  80139f:	50                   	push   %eax
  8013a0:	6a 06                	push   $0x6
  8013a2:	e8 56 ff ff ff       	call   8012fd <syscall>
  8013a7:	83 c4 18             	add    $0x18,%esp
}
  8013aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013ad:	5b                   	pop    %ebx
  8013ae:	5e                   	pop    %esi
  8013af:	5d                   	pop    %ebp
  8013b0:	c3                   	ret    

008013b1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	52                   	push   %edx
  8013c1:	50                   	push   %eax
  8013c2:	6a 07                	push   $0x7
  8013c4:	e8 34 ff ff ff       	call   8012fd <syscall>
  8013c9:	83 c4 18             	add    $0x18,%esp
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	ff 75 0c             	pushl  0xc(%ebp)
  8013da:	ff 75 08             	pushl  0x8(%ebp)
  8013dd:	6a 08                	push   $0x8
  8013df:	e8 19 ff ff ff       	call   8012fd <syscall>
  8013e4:	83 c4 18             	add    $0x18,%esp
}
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 09                	push   $0x9
  8013f8:	e8 00 ff ff ff       	call   8012fd <syscall>
  8013fd:	83 c4 18             	add    $0x18,%esp
}
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 0a                	push   $0xa
  801411:	e8 e7 fe ff ff       	call   8012fd <syscall>
  801416:	83 c4 18             	add    $0x18,%esp
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 0b                	push   $0xb
  80142a:	e8 ce fe ff ff       	call   8012fd <syscall>
  80142f:	83 c4 18             	add    $0x18,%esp
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 0c                	push   $0xc
  801443:	e8 b5 fe ff ff       	call   8012fd <syscall>
  801448:	83 c4 18             	add    $0x18,%esp
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	ff 75 08             	pushl  0x8(%ebp)
  80145b:	6a 0d                	push   $0xd
  80145d:	e8 9b fe ff ff       	call   8012fd <syscall>
  801462:	83 c4 18             	add    $0x18,%esp
}
  801465:	c9                   	leave  
  801466:	c3                   	ret    

00801467 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 0e                	push   $0xe
  801476:	e8 82 fe ff ff       	call   8012fd <syscall>
  80147b:	83 c4 18             	add    $0x18,%esp
}
  80147e:	90                   	nop
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 11                	push   $0x11
  801490:	e8 68 fe ff ff       	call   8012fd <syscall>
  801495:	83 c4 18             	add    $0x18,%esp
}
  801498:	90                   	nop
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 12                	push   $0x12
  8014aa:	e8 4e fe ff ff       	call   8012fd <syscall>
  8014af:	83 c4 18             	add    $0x18,%esp
}
  8014b2:	90                   	nop
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	83 ec 04             	sub    $0x4,%esp
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	50                   	push   %eax
  8014ce:	6a 13                	push   $0x13
  8014d0:	e8 28 fe ff ff       	call   8012fd <syscall>
  8014d5:	83 c4 18             	add    $0x18,%esp
}
  8014d8:	90                   	nop
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 14                	push   $0x14
  8014ea:	e8 0e fe ff ff       	call   8012fd <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
}
  8014f2:	90                   	nop
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	ff 75 0c             	pushl  0xc(%ebp)
  801504:	50                   	push   %eax
  801505:	6a 15                	push   $0x15
  801507:	e8 f1 fd ff ff       	call   8012fd <syscall>
  80150c:	83 c4 18             	add    $0x18,%esp
}
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801514:	8b 55 0c             	mov    0xc(%ebp),%edx
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	52                   	push   %edx
  801521:	50                   	push   %eax
  801522:	6a 18                	push   $0x18
  801524:	e8 d4 fd ff ff       	call   8012fd <syscall>
  801529:	83 c4 18             	add    $0x18,%esp
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801531:	8b 55 0c             	mov    0xc(%ebp),%edx
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	52                   	push   %edx
  80153e:	50                   	push   %eax
  80153f:	6a 16                	push   $0x16
  801541:	e8 b7 fd ff ff       	call   8012fd <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
}
  801549:	90                   	nop
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    

0080154c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80154f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	52                   	push   %edx
  80155c:	50                   	push   %eax
  80155d:	6a 17                	push   $0x17
  80155f:	e8 99 fd ff ff       	call   8012fd <syscall>
  801564:	83 c4 18             	add    $0x18,%esp
}
  801567:	90                   	nop
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 04             	sub    $0x4,%esp
  801570:	8b 45 10             	mov    0x10(%ebp),%eax
  801573:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801576:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801579:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	6a 00                	push   $0x0
  801582:	51                   	push   %ecx
  801583:	52                   	push   %edx
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	50                   	push   %eax
  801588:	6a 19                	push   $0x19
  80158a:	e8 6e fd ff ff       	call   8012fd <syscall>
  80158f:	83 c4 18             	add    $0x18,%esp
}
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801597:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	52                   	push   %edx
  8015a4:	50                   	push   %eax
  8015a5:	6a 1a                	push   $0x1a
  8015a7:	e8 51 fd ff ff       	call   8012fd <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	51                   	push   %ecx
  8015c2:	52                   	push   %edx
  8015c3:	50                   	push   %eax
  8015c4:	6a 1b                	push   $0x1b
  8015c6:	e8 32 fd ff ff       	call   8012fd <syscall>
  8015cb:	83 c4 18             	add    $0x18,%esp
}
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	52                   	push   %edx
  8015e0:	50                   	push   %eax
  8015e1:	6a 1c                	push   $0x1c
  8015e3:	e8 15 fd ff ff       	call   8012fd <syscall>
  8015e8:	83 c4 18             	add    $0x18,%esp
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 1d                	push   $0x1d
  8015fc:	e8 fc fc ff ff       	call   8012fd <syscall>
  801601:	83 c4 18             	add    $0x18,%esp
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	6a 00                	push   $0x0
  80160e:	ff 75 14             	pushl  0x14(%ebp)
  801611:	ff 75 10             	pushl  0x10(%ebp)
  801614:	ff 75 0c             	pushl  0xc(%ebp)
  801617:	50                   	push   %eax
  801618:	6a 1e                	push   $0x1e
  80161a:	e8 de fc ff ff       	call   8012fd <syscall>
  80161f:	83 c4 18             	add    $0x18,%esp
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	50                   	push   %eax
  801633:	6a 1f                	push   $0x1f
  801635:	e8 c3 fc ff ff       	call   8012fd <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
}
  80163d:	90                   	nop
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	50                   	push   %eax
  80164f:	6a 20                	push   $0x20
  801651:	e8 a7 fc ff ff       	call   8012fd <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 02                	push   $0x2
  80166a:	e8 8e fc ff ff       	call   8012fd <syscall>
  80166f:	83 c4 18             	add    $0x18,%esp
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 03                	push   $0x3
  801683:	e8 75 fc ff ff       	call   8012fd <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 04                	push   $0x4
  80169c:	e8 5c fc ff ff       	call   8012fd <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sys_exit_env>:


void sys_exit_env(void)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 21                	push   $0x21
  8016b5:	e8 43 fc ff ff       	call   8012fd <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
}
  8016bd:	90                   	nop
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016c6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016c9:	8d 50 04             	lea    0x4(%eax),%edx
  8016cc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	52                   	push   %edx
  8016d6:	50                   	push   %eax
  8016d7:	6a 22                	push   $0x22
  8016d9:	e8 1f fc ff ff       	call   8012fd <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
	return result;
  8016e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ea:	89 01                	mov    %eax,(%ecx)
  8016ec:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	c9                   	leave  
  8016f3:	c2 04 00             	ret    $0x4

008016f6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	ff 75 10             	pushl  0x10(%ebp)
  801700:	ff 75 0c             	pushl  0xc(%ebp)
  801703:	ff 75 08             	pushl  0x8(%ebp)
  801706:	6a 10                	push   $0x10
  801708:	e8 f0 fb ff ff       	call   8012fd <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
	return ;
  801710:	90                   	nop
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sys_rcr2>:
uint32 sys_rcr2()
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 23                	push   $0x23
  801722:	e8 d6 fb ff ff       	call   8012fd <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	83 ec 04             	sub    $0x4,%esp
  801732:	8b 45 08             	mov    0x8(%ebp),%eax
  801735:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801738:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	50                   	push   %eax
  801745:	6a 24                	push   $0x24
  801747:	e8 b1 fb ff ff       	call   8012fd <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
	return ;
  80174f:	90                   	nop
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <rsttst>:
void rsttst()
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 26                	push   $0x26
  801761:	e8 97 fb ff ff       	call   8012fd <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
	return ;
  801769:	90                   	nop
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 04             	sub    $0x4,%esp
  801772:	8b 45 14             	mov    0x14(%ebp),%eax
  801775:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801778:	8b 55 18             	mov    0x18(%ebp),%edx
  80177b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80177f:	52                   	push   %edx
  801780:	50                   	push   %eax
  801781:	ff 75 10             	pushl  0x10(%ebp)
  801784:	ff 75 0c             	pushl  0xc(%ebp)
  801787:	ff 75 08             	pushl  0x8(%ebp)
  80178a:	6a 25                	push   $0x25
  80178c:	e8 6c fb ff ff       	call   8012fd <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
	return ;
  801794:	90                   	nop
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <chktst>:
void chktst(uint32 n)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	ff 75 08             	pushl  0x8(%ebp)
  8017a5:	6a 27                	push   $0x27
  8017a7:	e8 51 fb ff ff       	call   8012fd <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8017af:	90                   	nop
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <inctst>:

void inctst()
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 28                	push   $0x28
  8017c1:	e8 37 fb ff ff       	call   8012fd <syscall>
  8017c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c9:	90                   	nop
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <gettst>:
uint32 gettst()
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 29                	push   $0x29
  8017db:	e8 1d fb ff ff       	call   8012fd <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 2a                	push   $0x2a
  8017f7:	e8 01 fb ff ff       	call   8012fd <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
  8017ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801802:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801806:	75 07                	jne    80180f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801808:	b8 01 00 00 00       	mov    $0x1,%eax
  80180d:	eb 05                	jmp    801814 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80180f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 2a                	push   $0x2a
  801828:	e8 d0 fa ff ff       	call   8012fd <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
  801830:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801833:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801837:	75 07                	jne    801840 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801839:	b8 01 00 00 00       	mov    $0x1,%eax
  80183e:	eb 05                	jmp    801845 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801840:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 2a                	push   $0x2a
  801859:	e8 9f fa ff ff       	call   8012fd <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
  801861:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801864:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801868:	75 07                	jne    801871 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80186a:	b8 01 00 00 00       	mov    $0x1,%eax
  80186f:	eb 05                	jmp    801876 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801871:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 2a                	push   $0x2a
  80188a:	e8 6e fa ff ff       	call   8012fd <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
  801892:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801895:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801899:	75 07                	jne    8018a2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80189b:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a0:	eb 05                	jmp    8018a7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8018a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	ff 75 08             	pushl  0x8(%ebp)
  8018b7:	6a 2b                	push   $0x2b
  8018b9:	e8 3f fa ff ff       	call   8012fd <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c1:	90                   	nop
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	6a 00                	push   $0x0
  8018d6:	53                   	push   %ebx
  8018d7:	51                   	push   %ecx
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	6a 2c                	push   $0x2c
  8018dc:	e8 1c fa ff ff       	call   8012fd <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	52                   	push   %edx
  8018f9:	50                   	push   %eax
  8018fa:	6a 2d                	push   $0x2d
  8018fc:	e8 fc f9 ff ff       	call   8012fd <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801909:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80190c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	6a 00                	push   $0x0
  801914:	51                   	push   %ecx
  801915:	ff 75 10             	pushl  0x10(%ebp)
  801918:	52                   	push   %edx
  801919:	50                   	push   %eax
  80191a:	6a 2e                	push   $0x2e
  80191c:	e8 dc f9 ff ff       	call   8012fd <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	ff 75 10             	pushl  0x10(%ebp)
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	ff 75 08             	pushl  0x8(%ebp)
  801936:	6a 0f                	push   $0xf
  801938:	e8 c0 f9 ff ff       	call   8012fd <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
	return ;
  801940:	90                   	nop
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	50                   	push   %eax
  801952:	6a 2f                	push   $0x2f
  801954:	e8 a4 f9 ff ff       	call   8012fd <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	ff 75 0c             	pushl  0xc(%ebp)
  80196a:	ff 75 08             	pushl  0x8(%ebp)
  80196d:	6a 30                	push   $0x30
  80196f:	e8 89 f9 ff ff       	call   8012fd <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801977:	90                   	nop
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	ff 75 0c             	pushl  0xc(%ebp)
  801986:	ff 75 08             	pushl  0x8(%ebp)
  801989:	6a 31                	push   $0x31
  80198b:	e8 6d f9 ff ff       	call   8012fd <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801993:	90                   	nop
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019a2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019a6:	83 ec 0c             	sub    $0xc,%esp
  8019a9:	50                   	push   %eax
  8019aa:	e8 06 fb ff ff       	call   8014b5 <sys_cputc>
  8019af:	83 c4 10             	add    $0x10,%esp
}
  8019b2:	90                   	nop
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8019bb:	e8 c1 fa ff ff       	call   801481 <sys_disable_interrupt>
	char c = ch;
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019c6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019ca:	83 ec 0c             	sub    $0xc,%esp
  8019cd:	50                   	push   %eax
  8019ce:	e8 e2 fa ff ff       	call   8014b5 <sys_cputc>
  8019d3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8019d6:	e8 c0 fa ff ff       	call   80149b <sys_enable_interrupt>
}
  8019db:	90                   	nop
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <getchar>:

int
getchar(void)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8019e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8019eb:	eb 08                	jmp    8019f5 <getchar+0x17>
	{
		c = sys_cgetc();
  8019ed:	e8 5f f9 ff ff       	call   801351 <sys_cgetc>
  8019f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8019f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019f9:	74 f2                	je     8019ed <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8019fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <atomic_getchar>:

int
atomic_getchar(void)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801a06:	e8 76 fa ff ff       	call   801481 <sys_disable_interrupt>
	int c=0;
  801a0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801a12:	eb 08                	jmp    801a1c <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801a14:	e8 38 f9 ff ff       	call   801351 <sys_cgetc>
  801a19:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801a1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a20:	74 f2                	je     801a14 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801a22:	e8 74 fa ff ff       	call   80149b <sys_enable_interrupt>
	return c;
  801a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <iscons>:

int iscons(int fdnum)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a2f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a34:	5d                   	pop    %ebp
  801a35:	c3                   	ret    
  801a36:	66 90                	xchg   %ax,%ax

00801a38 <__udivdi3>:
  801a38:	55                   	push   %ebp
  801a39:	57                   	push   %edi
  801a3a:	56                   	push   %esi
  801a3b:	53                   	push   %ebx
  801a3c:	83 ec 1c             	sub    $0x1c,%esp
  801a3f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a43:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a4f:	89 ca                	mov    %ecx,%edx
  801a51:	89 f8                	mov    %edi,%eax
  801a53:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a57:	85 f6                	test   %esi,%esi
  801a59:	75 2d                	jne    801a88 <__udivdi3+0x50>
  801a5b:	39 cf                	cmp    %ecx,%edi
  801a5d:	77 65                	ja     801ac4 <__udivdi3+0x8c>
  801a5f:	89 fd                	mov    %edi,%ebp
  801a61:	85 ff                	test   %edi,%edi
  801a63:	75 0b                	jne    801a70 <__udivdi3+0x38>
  801a65:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6a:	31 d2                	xor    %edx,%edx
  801a6c:	f7 f7                	div    %edi
  801a6e:	89 c5                	mov    %eax,%ebp
  801a70:	31 d2                	xor    %edx,%edx
  801a72:	89 c8                	mov    %ecx,%eax
  801a74:	f7 f5                	div    %ebp
  801a76:	89 c1                	mov    %eax,%ecx
  801a78:	89 d8                	mov    %ebx,%eax
  801a7a:	f7 f5                	div    %ebp
  801a7c:	89 cf                	mov    %ecx,%edi
  801a7e:	89 fa                	mov    %edi,%edx
  801a80:	83 c4 1c             	add    $0x1c,%esp
  801a83:	5b                   	pop    %ebx
  801a84:	5e                   	pop    %esi
  801a85:	5f                   	pop    %edi
  801a86:	5d                   	pop    %ebp
  801a87:	c3                   	ret    
  801a88:	39 ce                	cmp    %ecx,%esi
  801a8a:	77 28                	ja     801ab4 <__udivdi3+0x7c>
  801a8c:	0f bd fe             	bsr    %esi,%edi
  801a8f:	83 f7 1f             	xor    $0x1f,%edi
  801a92:	75 40                	jne    801ad4 <__udivdi3+0x9c>
  801a94:	39 ce                	cmp    %ecx,%esi
  801a96:	72 0a                	jb     801aa2 <__udivdi3+0x6a>
  801a98:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a9c:	0f 87 9e 00 00 00    	ja     801b40 <__udivdi3+0x108>
  801aa2:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa7:	89 fa                	mov    %edi,%edx
  801aa9:	83 c4 1c             	add    $0x1c,%esp
  801aac:	5b                   	pop    %ebx
  801aad:	5e                   	pop    %esi
  801aae:	5f                   	pop    %edi
  801aaf:	5d                   	pop    %ebp
  801ab0:	c3                   	ret    
  801ab1:	8d 76 00             	lea    0x0(%esi),%esi
  801ab4:	31 ff                	xor    %edi,%edi
  801ab6:	31 c0                	xor    %eax,%eax
  801ab8:	89 fa                	mov    %edi,%edx
  801aba:	83 c4 1c             	add    $0x1c,%esp
  801abd:	5b                   	pop    %ebx
  801abe:	5e                   	pop    %esi
  801abf:	5f                   	pop    %edi
  801ac0:	5d                   	pop    %ebp
  801ac1:	c3                   	ret    
  801ac2:	66 90                	xchg   %ax,%ax
  801ac4:	89 d8                	mov    %ebx,%eax
  801ac6:	f7 f7                	div    %edi
  801ac8:	31 ff                	xor    %edi,%edi
  801aca:	89 fa                	mov    %edi,%edx
  801acc:	83 c4 1c             	add    $0x1c,%esp
  801acf:	5b                   	pop    %ebx
  801ad0:	5e                   	pop    %esi
  801ad1:	5f                   	pop    %edi
  801ad2:	5d                   	pop    %ebp
  801ad3:	c3                   	ret    
  801ad4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ad9:	89 eb                	mov    %ebp,%ebx
  801adb:	29 fb                	sub    %edi,%ebx
  801add:	89 f9                	mov    %edi,%ecx
  801adf:	d3 e6                	shl    %cl,%esi
  801ae1:	89 c5                	mov    %eax,%ebp
  801ae3:	88 d9                	mov    %bl,%cl
  801ae5:	d3 ed                	shr    %cl,%ebp
  801ae7:	89 e9                	mov    %ebp,%ecx
  801ae9:	09 f1                	or     %esi,%ecx
  801aeb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801aef:	89 f9                	mov    %edi,%ecx
  801af1:	d3 e0                	shl    %cl,%eax
  801af3:	89 c5                	mov    %eax,%ebp
  801af5:	89 d6                	mov    %edx,%esi
  801af7:	88 d9                	mov    %bl,%cl
  801af9:	d3 ee                	shr    %cl,%esi
  801afb:	89 f9                	mov    %edi,%ecx
  801afd:	d3 e2                	shl    %cl,%edx
  801aff:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b03:	88 d9                	mov    %bl,%cl
  801b05:	d3 e8                	shr    %cl,%eax
  801b07:	09 c2                	or     %eax,%edx
  801b09:	89 d0                	mov    %edx,%eax
  801b0b:	89 f2                	mov    %esi,%edx
  801b0d:	f7 74 24 0c          	divl   0xc(%esp)
  801b11:	89 d6                	mov    %edx,%esi
  801b13:	89 c3                	mov    %eax,%ebx
  801b15:	f7 e5                	mul    %ebp
  801b17:	39 d6                	cmp    %edx,%esi
  801b19:	72 19                	jb     801b34 <__udivdi3+0xfc>
  801b1b:	74 0b                	je     801b28 <__udivdi3+0xf0>
  801b1d:	89 d8                	mov    %ebx,%eax
  801b1f:	31 ff                	xor    %edi,%edi
  801b21:	e9 58 ff ff ff       	jmp    801a7e <__udivdi3+0x46>
  801b26:	66 90                	xchg   %ax,%ax
  801b28:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b2c:	89 f9                	mov    %edi,%ecx
  801b2e:	d3 e2                	shl    %cl,%edx
  801b30:	39 c2                	cmp    %eax,%edx
  801b32:	73 e9                	jae    801b1d <__udivdi3+0xe5>
  801b34:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b37:	31 ff                	xor    %edi,%edi
  801b39:	e9 40 ff ff ff       	jmp    801a7e <__udivdi3+0x46>
  801b3e:	66 90                	xchg   %ax,%ax
  801b40:	31 c0                	xor    %eax,%eax
  801b42:	e9 37 ff ff ff       	jmp    801a7e <__udivdi3+0x46>
  801b47:	90                   	nop

00801b48 <__umoddi3>:
  801b48:	55                   	push   %ebp
  801b49:	57                   	push   %edi
  801b4a:	56                   	push   %esi
  801b4b:	53                   	push   %ebx
  801b4c:	83 ec 1c             	sub    $0x1c,%esp
  801b4f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b53:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b67:	89 f3                	mov    %esi,%ebx
  801b69:	89 fa                	mov    %edi,%edx
  801b6b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b6f:	89 34 24             	mov    %esi,(%esp)
  801b72:	85 c0                	test   %eax,%eax
  801b74:	75 1a                	jne    801b90 <__umoddi3+0x48>
  801b76:	39 f7                	cmp    %esi,%edi
  801b78:	0f 86 a2 00 00 00    	jbe    801c20 <__umoddi3+0xd8>
  801b7e:	89 c8                	mov    %ecx,%eax
  801b80:	89 f2                	mov    %esi,%edx
  801b82:	f7 f7                	div    %edi
  801b84:	89 d0                	mov    %edx,%eax
  801b86:	31 d2                	xor    %edx,%edx
  801b88:	83 c4 1c             	add    $0x1c,%esp
  801b8b:	5b                   	pop    %ebx
  801b8c:	5e                   	pop    %esi
  801b8d:	5f                   	pop    %edi
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    
  801b90:	39 f0                	cmp    %esi,%eax
  801b92:	0f 87 ac 00 00 00    	ja     801c44 <__umoddi3+0xfc>
  801b98:	0f bd e8             	bsr    %eax,%ebp
  801b9b:	83 f5 1f             	xor    $0x1f,%ebp
  801b9e:	0f 84 ac 00 00 00    	je     801c50 <__umoddi3+0x108>
  801ba4:	bf 20 00 00 00       	mov    $0x20,%edi
  801ba9:	29 ef                	sub    %ebp,%edi
  801bab:	89 fe                	mov    %edi,%esi
  801bad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bb1:	89 e9                	mov    %ebp,%ecx
  801bb3:	d3 e0                	shl    %cl,%eax
  801bb5:	89 d7                	mov    %edx,%edi
  801bb7:	89 f1                	mov    %esi,%ecx
  801bb9:	d3 ef                	shr    %cl,%edi
  801bbb:	09 c7                	or     %eax,%edi
  801bbd:	89 e9                	mov    %ebp,%ecx
  801bbf:	d3 e2                	shl    %cl,%edx
  801bc1:	89 14 24             	mov    %edx,(%esp)
  801bc4:	89 d8                	mov    %ebx,%eax
  801bc6:	d3 e0                	shl    %cl,%eax
  801bc8:	89 c2                	mov    %eax,%edx
  801bca:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bce:	d3 e0                	shl    %cl,%eax
  801bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd8:	89 f1                	mov    %esi,%ecx
  801bda:	d3 e8                	shr    %cl,%eax
  801bdc:	09 d0                	or     %edx,%eax
  801bde:	d3 eb                	shr    %cl,%ebx
  801be0:	89 da                	mov    %ebx,%edx
  801be2:	f7 f7                	div    %edi
  801be4:	89 d3                	mov    %edx,%ebx
  801be6:	f7 24 24             	mull   (%esp)
  801be9:	89 c6                	mov    %eax,%esi
  801beb:	89 d1                	mov    %edx,%ecx
  801bed:	39 d3                	cmp    %edx,%ebx
  801bef:	0f 82 87 00 00 00    	jb     801c7c <__umoddi3+0x134>
  801bf5:	0f 84 91 00 00 00    	je     801c8c <__umoddi3+0x144>
  801bfb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bff:	29 f2                	sub    %esi,%edx
  801c01:	19 cb                	sbb    %ecx,%ebx
  801c03:	89 d8                	mov    %ebx,%eax
  801c05:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c09:	d3 e0                	shl    %cl,%eax
  801c0b:	89 e9                	mov    %ebp,%ecx
  801c0d:	d3 ea                	shr    %cl,%edx
  801c0f:	09 d0                	or     %edx,%eax
  801c11:	89 e9                	mov    %ebp,%ecx
  801c13:	d3 eb                	shr    %cl,%ebx
  801c15:	89 da                	mov    %ebx,%edx
  801c17:	83 c4 1c             	add    $0x1c,%esp
  801c1a:	5b                   	pop    %ebx
  801c1b:	5e                   	pop    %esi
  801c1c:	5f                   	pop    %edi
  801c1d:	5d                   	pop    %ebp
  801c1e:	c3                   	ret    
  801c1f:	90                   	nop
  801c20:	89 fd                	mov    %edi,%ebp
  801c22:	85 ff                	test   %edi,%edi
  801c24:	75 0b                	jne    801c31 <__umoddi3+0xe9>
  801c26:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2b:	31 d2                	xor    %edx,%edx
  801c2d:	f7 f7                	div    %edi
  801c2f:	89 c5                	mov    %eax,%ebp
  801c31:	89 f0                	mov    %esi,%eax
  801c33:	31 d2                	xor    %edx,%edx
  801c35:	f7 f5                	div    %ebp
  801c37:	89 c8                	mov    %ecx,%eax
  801c39:	f7 f5                	div    %ebp
  801c3b:	89 d0                	mov    %edx,%eax
  801c3d:	e9 44 ff ff ff       	jmp    801b86 <__umoddi3+0x3e>
  801c42:	66 90                	xchg   %ax,%ax
  801c44:	89 c8                	mov    %ecx,%eax
  801c46:	89 f2                	mov    %esi,%edx
  801c48:	83 c4 1c             	add    $0x1c,%esp
  801c4b:	5b                   	pop    %ebx
  801c4c:	5e                   	pop    %esi
  801c4d:	5f                   	pop    %edi
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    
  801c50:	3b 04 24             	cmp    (%esp),%eax
  801c53:	72 06                	jb     801c5b <__umoddi3+0x113>
  801c55:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c59:	77 0f                	ja     801c6a <__umoddi3+0x122>
  801c5b:	89 f2                	mov    %esi,%edx
  801c5d:	29 f9                	sub    %edi,%ecx
  801c5f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c63:	89 14 24             	mov    %edx,(%esp)
  801c66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c6a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c6e:	8b 14 24             	mov    (%esp),%edx
  801c71:	83 c4 1c             	add    $0x1c,%esp
  801c74:	5b                   	pop    %ebx
  801c75:	5e                   	pop    %esi
  801c76:	5f                   	pop    %edi
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    
  801c79:	8d 76 00             	lea    0x0(%esi),%esi
  801c7c:	2b 04 24             	sub    (%esp),%eax
  801c7f:	19 fa                	sbb    %edi,%edx
  801c81:	89 d1                	mov    %edx,%ecx
  801c83:	89 c6                	mov    %eax,%esi
  801c85:	e9 71 ff ff ff       	jmp    801bfb <__umoddi3+0xb3>
  801c8a:	66 90                	xchg   %ax,%ax
  801c8c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c90:	72 ea                	jb     801c7c <__umoddi3+0x134>
  801c92:	89 d9                	mov    %ebx,%ecx
  801c94:	e9 62 ff ff ff       	jmp    801bfb <__umoddi3+0xb3>
