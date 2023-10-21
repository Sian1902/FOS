
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
  800052:	68 80 1e 80 00       	push   $0x801e80
  800057:	e8 1e 0a 00 00       	call   800a7a <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 70 0e 00 00       	call   800ee2 <strtol>
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
  800092:	68 9e 1e 80 00       	push   $0x801e9e
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
  8000e7:	e8 66 15 00 00       	call   801652 <sys_getenvindex>
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
  80015b:	e8 ff 12 00 00       	call   80145f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	68 cc 1e 80 00       	push   $0x801ecc
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
  80018b:	68 f4 1e 80 00       	push   $0x801ef4
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
  8001bc:	68 1c 1f 80 00       	push   $0x801f1c
  8001c1:	e8 34 01 00 00       	call   8002fa <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ce:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	50                   	push   %eax
  8001d8:	68 74 1f 80 00       	push   $0x801f74
  8001dd:	e8 18 01 00 00       	call   8002fa <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 cc 1e 80 00       	push   $0x801ecc
  8001ed:	e8 08 01 00 00       	call   8002fa <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001f5:	e8 7f 12 00 00       	call   801479 <sys_enable_interrupt>

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
  80020d:	e8 0c 14 00 00       	call   80161e <sys_destroy_env>
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
  80021e:	e8 61 14 00 00       	call   801684 <sys_exit_env>
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
  80026c:	e8 95 10 00 00       	call   801306 <sys_cputs>
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
  8002e3:	e8 1e 10 00 00       	call   801306 <sys_cputs>
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
  80032d:	e8 2d 11 00 00       	call   80145f <sys_disable_interrupt>
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
  80034d:	e8 27 11 00 00       	call   801479 <sys_enable_interrupt>
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
  800397:	e8 68 18 00 00       	call   801c04 <__udivdi3>
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
  8003e7:	e8 28 19 00 00       	call   801d14 <__umoddi3>
  8003ec:	83 c4 10             	add    $0x10,%esp
  8003ef:	05 b4 21 80 00       	add    $0x8021b4,%eax
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
  800542:	8b 04 85 d8 21 80 00 	mov    0x8021d8(,%eax,4),%eax
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
  800623:	8b 34 9d 20 20 80 00 	mov    0x802020(,%ebx,4),%esi
  80062a:	85 f6                	test   %esi,%esi
  80062c:	75 19                	jne    800647 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80062e:	53                   	push   %ebx
  80062f:	68 c5 21 80 00       	push   $0x8021c5
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
  800648:	68 ce 21 80 00       	push   $0x8021ce
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
  800675:	be d1 21 80 00       	mov    $0x8021d1,%esi
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
  80098e:	68 30 23 80 00       	push   $0x802330
  800993:	e8 62 f9 ff ff       	call   8002fa <cprintf>
  800998:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80099b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009a2:	83 ec 0c             	sub    $0xc,%esp
  8009a5:	6a 00                	push   $0x0
  8009a7:	e8 62 10 00 00       	call   801a0e <iscons>
  8009ac:	83 c4 10             	add    $0x10,%esp
  8009af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009b2:	e8 09 10 00 00       	call   8019c0 <getchar>
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
  8009d0:	68 33 23 80 00       	push   $0x802333
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
  8009fd:	e8 76 0f 00 00       	call   801978 <cputchar>
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
  800a34:	e8 3f 0f 00 00       	call   801978 <cputchar>
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
  800a5d:	e8 16 0f 00 00       	call   801978 <cputchar>
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
  800a80:	e8 da 09 00 00       	call   80145f <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a89:	74 13                	je     800a9e <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a8b:	83 ec 08             	sub    $0x8,%esp
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	68 30 23 80 00       	push   $0x802330
  800a96:	e8 5f f8 ff ff       	call   8002fa <cprintf>
  800a9b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800aa5:	83 ec 0c             	sub    $0xc,%esp
  800aa8:	6a 00                	push   $0x0
  800aaa:	e8 5f 0f 00 00       	call   801a0e <iscons>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800ab5:	e8 06 0f 00 00       	call   8019c0 <getchar>
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
  800acf:	68 33 23 80 00       	push   $0x802333
  800ad4:	e8 21 f8 ff ff       	call   8002fa <cprintf>
  800ad9:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800adc:	e8 98 09 00 00       	call   801479 <sys_enable_interrupt>
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
  800b01:	e8 72 0e 00 00       	call   801978 <cputchar>
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
  800b38:	e8 3b 0e 00 00       	call   801978 <cputchar>
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
  800b61:	e8 12 0e 00 00       	call   801978 <cputchar>
  800b66:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6f:	01 d0                	add    %edx,%eax
  800b71:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b74:	e8 00 09 00 00       	call   801479 <sys_enable_interrupt>
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


void *
memset(void *v, int c, uint32 n)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d82:	eb 0e                	jmp    800d92 <memset+0x22>
		*p++ = c;
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d87:	8d 50 01             	lea    0x1(%eax),%edx
  800d8a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d90:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d92:	ff 4d f8             	decl   -0x8(%ebp)
  800d95:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d99:	79 e9                	jns    800d84 <memset+0x14>
		*p++ = c;

	return v;
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800db2:	eb 16                	jmp    800dca <memcpy+0x2a>
		*d++ = *s++;
  800db4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db7:	8d 50 01             	lea    0x1(%eax),%edx
  800dba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dbd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dc6:	8a 12                	mov    (%edx),%dl
  800dc8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dca:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	75 dd                	jne    800db4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800df4:	73 50                	jae    800e46 <memmove+0x6a>
  800df6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfc:	01 d0                	add    %edx,%eax
  800dfe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e01:	76 43                	jbe    800e46 <memmove+0x6a>
		s += n;
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e09:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e0f:	eb 10                	jmp    800e21 <memmove+0x45>
			*--d = *--s;
  800e11:	ff 4d f8             	decl   -0x8(%ebp)
  800e14:	ff 4d fc             	decl   -0x4(%ebp)
  800e17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1a:	8a 10                	mov    (%eax),%dl
  800e1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e21:	8b 45 10             	mov    0x10(%ebp),%eax
  800e24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e27:	89 55 10             	mov    %edx,0x10(%ebp)
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	75 e3                	jne    800e11 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e2e:	eb 23                	jmp    800e53 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e33:	8d 50 01             	lea    0x1(%eax),%edx
  800e36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e42:	8a 12                	mov    (%edx),%dl
  800e44:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 dd                	jne    800e30 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e56:	c9                   	leave  
  800e57:	c3                   	ret    

00800e58 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e6a:	eb 2a                	jmp    800e96 <memcmp+0x3e>
		if (*s1 != *s2)
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6f:	8a 10                	mov    (%eax),%dl
  800e71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	38 c2                	cmp    %al,%dl
  800e78:	74 16                	je     800e90 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	0f b6 d0             	movzbl %al,%edx
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	0f b6 c0             	movzbl %al,%eax
  800e8a:	29 c2                	sub    %eax,%edx
  800e8c:	89 d0                	mov    %edx,%eax
  800e8e:	eb 18                	jmp    800ea8 <memcmp+0x50>
		s1++, s2++;
  800e90:	ff 45 fc             	incl   -0x4(%ebp)
  800e93:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e96:	8b 45 10             	mov    0x10(%ebp),%eax
  800e99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e9c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9f:	85 c0                	test   %eax,%eax
  800ea1:	75 c9                	jne    800e6c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ea3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	01 d0                	add    %edx,%eax
  800eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ebb:	eb 15                	jmp    800ed2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	0f b6 d0             	movzbl %al,%edx
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	0f b6 c0             	movzbl %al,%eax
  800ecb:	39 c2                	cmp    %eax,%edx
  800ecd:	74 0d                	je     800edc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ecf:	ff 45 08             	incl   0x8(%ebp)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ed8:	72 e3                	jb     800ebd <memfind+0x13>
  800eda:	eb 01                	jmp    800edd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800edc:	90                   	nop
	return (void *) s;
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee0:	c9                   	leave  
  800ee1:	c3                   	ret    

00800ee2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ee8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800eef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ef6:	eb 03                	jmp    800efb <strtol+0x19>
		s++;
  800ef8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	3c 20                	cmp    $0x20,%al
  800f02:	74 f4                	je     800ef8 <strtol+0x16>
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	3c 09                	cmp    $0x9,%al
  800f0b:	74 eb                	je     800ef8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	3c 2b                	cmp    $0x2b,%al
  800f14:	75 05                	jne    800f1b <strtol+0x39>
		s++;
  800f16:	ff 45 08             	incl   0x8(%ebp)
  800f19:	eb 13                	jmp    800f2e <strtol+0x4c>
	else if (*s == '-')
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3c 2d                	cmp    $0x2d,%al
  800f22:	75 0a                	jne    800f2e <strtol+0x4c>
		s++, neg = 1;
  800f24:	ff 45 08             	incl   0x8(%ebp)
  800f27:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	74 06                	je     800f3a <strtol+0x58>
  800f34:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f38:	75 20                	jne    800f5a <strtol+0x78>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 30                	cmp    $0x30,%al
  800f41:	75 17                	jne    800f5a <strtol+0x78>
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	40                   	inc    %eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	3c 78                	cmp    $0x78,%al
  800f4b:	75 0d                	jne    800f5a <strtol+0x78>
		s += 2, base = 16;
  800f4d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f51:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f58:	eb 28                	jmp    800f82 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5e:	75 15                	jne    800f75 <strtol+0x93>
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	3c 30                	cmp    $0x30,%al
  800f67:	75 0c                	jne    800f75 <strtol+0x93>
		s++, base = 8;
  800f69:	ff 45 08             	incl   0x8(%ebp)
  800f6c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f73:	eb 0d                	jmp    800f82 <strtol+0xa0>
	else if (base == 0)
  800f75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f79:	75 07                	jne    800f82 <strtol+0xa0>
		base = 10;
  800f7b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	3c 2f                	cmp    $0x2f,%al
  800f89:	7e 19                	jle    800fa4 <strtol+0xc2>
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	3c 39                	cmp    $0x39,%al
  800f92:	7f 10                	jg     800fa4 <strtol+0xc2>
			dig = *s - '0';
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	0f be c0             	movsbl %al,%eax
  800f9c:	83 e8 30             	sub    $0x30,%eax
  800f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa2:	eb 42                	jmp    800fe6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 60                	cmp    $0x60,%al
  800fab:	7e 19                	jle    800fc6 <strtol+0xe4>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 7a                	cmp    $0x7a,%al
  800fb4:	7f 10                	jg     800fc6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f be c0             	movsbl %al,%eax
  800fbe:	83 e8 57             	sub    $0x57,%eax
  800fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc4:	eb 20                	jmp    800fe6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 40                	cmp    $0x40,%al
  800fcd:	7e 39                	jle    801008 <strtol+0x126>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 5a                	cmp    $0x5a,%al
  800fd6:	7f 30                	jg     801008 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	83 e8 37             	sub    $0x37,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fec:	7d 19                	jge    801007 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ff8:	89 c2                	mov    %eax,%edx
  800ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffd:	01 d0                	add    %edx,%eax
  800fff:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801002:	e9 7b ff ff ff       	jmp    800f82 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801007:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801008:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80100c:	74 08                	je     801016 <strtol+0x134>
		*endptr = (char *) s;
  80100e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
  801014:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801016:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80101a:	74 07                	je     801023 <strtol+0x141>
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	f7 d8                	neg    %eax
  801021:	eb 03                	jmp    801026 <strtol+0x144>
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <ltostr>:

void
ltostr(long value, char *str)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801035:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80103c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801040:	79 13                	jns    801055 <ltostr+0x2d>
	{
		neg = 1;
  801042:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80104f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801052:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80105d:	99                   	cltd   
  80105e:	f7 f9                	idiv   %ecx
  801060:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801063:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801066:	8d 50 01             	lea    0x1(%eax),%edx
  801069:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80106c:	89 c2                	mov    %eax,%edx
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	01 d0                	add    %edx,%eax
  801073:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801076:	83 c2 30             	add    $0x30,%edx
  801079:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80107b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80107e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801083:	f7 e9                	imul   %ecx
  801085:	c1 fa 02             	sar    $0x2,%edx
  801088:	89 c8                	mov    %ecx,%eax
  80108a:	c1 f8 1f             	sar    $0x1f,%eax
  80108d:	29 c2                	sub    %eax,%edx
  80108f:	89 d0                	mov    %edx,%eax
  801091:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801094:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801097:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80109c:	f7 e9                	imul   %ecx
  80109e:	c1 fa 02             	sar    $0x2,%edx
  8010a1:	89 c8                	mov    %ecx,%eax
  8010a3:	c1 f8 1f             	sar    $0x1f,%eax
  8010a6:	29 c2                	sub    %eax,%edx
  8010a8:	89 d0                	mov    %edx,%eax
  8010aa:	c1 e0 02             	shl    $0x2,%eax
  8010ad:	01 d0                	add    %edx,%eax
  8010af:	01 c0                	add    %eax,%eax
  8010b1:	29 c1                	sub    %eax,%ecx
  8010b3:	89 ca                	mov    %ecx,%edx
  8010b5:	85 d2                	test   %edx,%edx
  8010b7:	75 9c                	jne    801055 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c3:	48                   	dec    %eax
  8010c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010cb:	74 3d                	je     80110a <ltostr+0xe2>
		start = 1 ;
  8010cd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010d4:	eb 34                	jmp    80110a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	01 d0                	add    %edx,%eax
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	01 c2                	add    %eax,%edx
  8010eb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c8                	add    %ecx,%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	01 c2                	add    %eax,%edx
  8010ff:	8a 45 eb             	mov    -0x15(%ebp),%al
  801102:	88 02                	mov    %al,(%edx)
		start++ ;
  801104:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801107:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80110a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801110:	7c c4                	jl     8010d6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801112:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801115:	8b 45 0c             	mov    0xc(%ebp),%eax
  801118:	01 d0                	add    %edx,%eax
  80111a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80111d:	90                   	nop
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801126:	ff 75 08             	pushl  0x8(%ebp)
  801129:	e8 54 fa ff ff       	call   800b82 <strlen>
  80112e:	83 c4 04             	add    $0x4,%esp
  801131:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801134:	ff 75 0c             	pushl  0xc(%ebp)
  801137:	e8 46 fa ff ff       	call   800b82 <strlen>
  80113c:	83 c4 04             	add    $0x4,%esp
  80113f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801142:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801149:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801150:	eb 17                	jmp    801169 <strcconcat+0x49>
		final[s] = str1[s] ;
  801152:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801155:	8b 45 10             	mov    0x10(%ebp),%eax
  801158:	01 c2                	add    %eax,%edx
  80115a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	01 c8                	add    %ecx,%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801166:	ff 45 fc             	incl   -0x4(%ebp)
  801169:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80116f:	7c e1                	jl     801152 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801171:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801178:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80117f:	eb 1f                	jmp    8011a0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801181:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801184:	8d 50 01             	lea    0x1(%eax),%edx
  801187:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	01 c2                	add    %eax,%edx
  801191:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	01 c8                	add    %ecx,%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80119d:	ff 45 f8             	incl   -0x8(%ebp)
  8011a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011a6:	7c d9                	jl     801181 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ae:	01 d0                	add    %edx,%eax
  8011b0:	c6 00 00             	movb   $0x0,(%eax)
}
  8011b3:	90                   	nop
  8011b4:	c9                   	leave  
  8011b5:	c3                   	ret    

008011b6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c5:	8b 00                	mov    (%eax),%eax
  8011c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d1:	01 d0                	add    %edx,%eax
  8011d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d9:	eb 0c                	jmp    8011e7 <strsplit+0x31>
			*string++ = 0;
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8d 50 01             	lea    0x1(%eax),%edx
  8011e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8011e4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 18                	je     801208 <strsplit+0x52>
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	0f be c0             	movsbl %al,%eax
  8011f8:	50                   	push   %eax
  8011f9:	ff 75 0c             	pushl  0xc(%ebp)
  8011fc:	e8 13 fb ff ff       	call   800d14 <strchr>
  801201:	83 c4 08             	add    $0x8,%esp
  801204:	85 c0                	test   %eax,%eax
  801206:	75 d3                	jne    8011db <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	84 c0                	test   %al,%al
  80120f:	74 5a                	je     80126b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801211:	8b 45 14             	mov    0x14(%ebp),%eax
  801214:	8b 00                	mov    (%eax),%eax
  801216:	83 f8 0f             	cmp    $0xf,%eax
  801219:	75 07                	jne    801222 <strsplit+0x6c>
		{
			return 0;
  80121b:	b8 00 00 00 00       	mov    $0x0,%eax
  801220:	eb 66                	jmp    801288 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801222:	8b 45 14             	mov    0x14(%ebp),%eax
  801225:	8b 00                	mov    (%eax),%eax
  801227:	8d 48 01             	lea    0x1(%eax),%ecx
  80122a:	8b 55 14             	mov    0x14(%ebp),%edx
  80122d:	89 0a                	mov    %ecx,(%edx)
  80122f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801236:	8b 45 10             	mov    0x10(%ebp),%eax
  801239:	01 c2                	add    %eax,%edx
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801240:	eb 03                	jmp    801245 <strsplit+0x8f>
			string++;
  801242:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	84 c0                	test   %al,%al
  80124c:	74 8b                	je     8011d9 <strsplit+0x23>
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	0f be c0             	movsbl %al,%eax
  801256:	50                   	push   %eax
  801257:	ff 75 0c             	pushl  0xc(%ebp)
  80125a:	e8 b5 fa ff ff       	call   800d14 <strchr>
  80125f:	83 c4 08             	add    $0x8,%esp
  801262:	85 c0                	test   %eax,%eax
  801264:	74 dc                	je     801242 <strsplit+0x8c>
			string++;
	}
  801266:	e9 6e ff ff ff       	jmp    8011d9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80126b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	8b 00                	mov    (%eax),%eax
  801271:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801278:	8b 45 10             	mov    0x10(%ebp),%eax
  80127b:	01 d0                	add    %edx,%eax
  80127d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801283:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL){
  80128d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801291:	75 3a                	jne    8012cd <str2lower+0x43>
	return NULL;
  801293:	b8 00 00 00 00       	mov    $0x0,%eax
  801298:	eb 3f                	jmp    8012d9 <str2lower+0x4f>
	}
	while(*src!='\0'){
		if(*src>=65&&*src<=90){
  80129a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129d:	8a 00                	mov    (%eax),%al
  80129f:	3c 40                	cmp    $0x40,%al
  8012a1:	7e 1a                	jle    8012bd <str2lower+0x33>
  8012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	3c 5a                	cmp    $0x5a,%al
  8012aa:	7f 11                	jg     8012bd <str2lower+0x33>
			*dst=*src+32;
  8012ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	83 c0 20             	add    $0x20,%eax
  8012b4:	88 c2                	mov    %al,%dl
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	88 10                	mov    %dl,(%eax)
  8012bb:	eb 0a                	jmp    8012c7 <str2lower+0x3d>
		}
		else{
			*dst=*src;
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c0:	8a 10                	mov    (%eax),%dl
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	88 10                	mov    %dl,(%eax)
		}
		src++;
  8012c7:	ff 45 0c             	incl   0xc(%ebp)
		dst++;
  8012ca:	ff 45 08             	incl   0x8(%ebp)
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL){
	return NULL;
	}
	while(*src!='\0'){
  8012cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	84 c0                	test   %al,%al
  8012d4:	75 c4                	jne    80129a <str2lower+0x10>
			*dst=*src;
		}
		src++;
		dst++;
	}
	return dst;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	57                   	push   %edi
  8012df:	56                   	push   %esi
  8012e0:	53                   	push   %ebx
  8012e1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012f0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012f3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012f6:	cd 30                	int    $0x30
  8012f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	5b                   	pop    %ebx
  801302:	5e                   	pop    %esi
  801303:	5f                   	pop    %edi
  801304:	5d                   	pop    %ebp
  801305:	c3                   	ret    

00801306 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	83 ec 04             	sub    $0x4,%esp
  80130c:	8b 45 10             	mov    0x10(%ebp),%eax
  80130f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801312:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	52                   	push   %edx
  80131e:	ff 75 0c             	pushl  0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	6a 00                	push   $0x0
  801324:	e8 b2 ff ff ff       	call   8012db <syscall>
  801329:	83 c4 18             	add    $0x18,%esp
}
  80132c:	90                   	nop
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <sys_cgetc>:

int
sys_cgetc(void)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 01                	push   $0x1
  80133e:	e8 98 ff ff ff       	call   8012db <syscall>
  801343:	83 c4 18             	add    $0x18,%esp
}
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80134b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	52                   	push   %edx
  801358:	50                   	push   %eax
  801359:	6a 05                	push   $0x5
  80135b:	e8 7b ff ff ff       	call   8012db <syscall>
  801360:	83 c4 18             	add    $0x18,%esp
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	56                   	push   %esi
  801369:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80136a:	8b 75 18             	mov    0x18(%ebp),%esi
  80136d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801370:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801373:	8b 55 0c             	mov    0xc(%ebp),%edx
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	56                   	push   %esi
  80137a:	53                   	push   %ebx
  80137b:	51                   	push   %ecx
  80137c:	52                   	push   %edx
  80137d:	50                   	push   %eax
  80137e:	6a 06                	push   $0x6
  801380:	e8 56 ff ff ff       	call   8012db <syscall>
  801385:	83 c4 18             	add    $0x18,%esp
}
  801388:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80138b:	5b                   	pop    %ebx
  80138c:	5e                   	pop    %esi
  80138d:	5d                   	pop    %ebp
  80138e:	c3                   	ret    

0080138f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801392:	8b 55 0c             	mov    0xc(%ebp),%edx
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	52                   	push   %edx
  80139f:	50                   	push   %eax
  8013a0:	6a 07                	push   $0x7
  8013a2:	e8 34 ff ff ff       	call   8012db <syscall>
  8013a7:	83 c4 18             	add    $0x18,%esp
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	ff 75 0c             	pushl  0xc(%ebp)
  8013b8:	ff 75 08             	pushl  0x8(%ebp)
  8013bb:	6a 08                	push   $0x8
  8013bd:	e8 19 ff ff ff       	call   8012db <syscall>
  8013c2:	83 c4 18             	add    $0x18,%esp
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 09                	push   $0x9
  8013d6:	e8 00 ff ff ff       	call   8012db <syscall>
  8013db:	83 c4 18             	add    $0x18,%esp
}
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 0a                	push   $0xa
  8013ef:	e8 e7 fe ff ff       	call   8012db <syscall>
  8013f4:	83 c4 18             	add    $0x18,%esp
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 0b                	push   $0xb
  801408:	e8 ce fe ff ff       	call   8012db <syscall>
  80140d:	83 c4 18             	add    $0x18,%esp
}
  801410:	c9                   	leave  
  801411:	c3                   	ret    

00801412 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 0c                	push   $0xc
  801421:	e8 b5 fe ff ff       	call   8012db <syscall>
  801426:	83 c4 18             	add    $0x18,%esp
}
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	ff 75 08             	pushl  0x8(%ebp)
  801439:	6a 0d                	push   $0xd
  80143b:	e8 9b fe ff ff       	call   8012db <syscall>
  801440:	83 c4 18             	add    $0x18,%esp
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 0e                	push   $0xe
  801454:	e8 82 fe ff ff       	call   8012db <syscall>
  801459:	83 c4 18             	add    $0x18,%esp
}
  80145c:	90                   	nop
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 11                	push   $0x11
  80146e:	e8 68 fe ff ff       	call   8012db <syscall>
  801473:	83 c4 18             	add    $0x18,%esp
}
  801476:	90                   	nop
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80147c:	6a 00                	push   $0x0
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 12                	push   $0x12
  801488:	e8 4e fe ff ff       	call   8012db <syscall>
  80148d:	83 c4 18             	add    $0x18,%esp
}
  801490:	90                   	nop
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <sys_cputc>:


void
sys_cputc(const char c)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	83 ec 04             	sub    $0x4,%esp
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80149f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	50                   	push   %eax
  8014ac:	6a 13                	push   $0x13
  8014ae:	e8 28 fe ff ff       	call   8012db <syscall>
  8014b3:	83 c4 18             	add    $0x18,%esp
}
  8014b6:	90                   	nop
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 14                	push   $0x14
  8014c8:	e8 0e fe ff ff       	call   8012db <syscall>
  8014cd:	83 c4 18             	add    $0x18,%esp
}
  8014d0:	90                   	nop
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	50                   	push   %eax
  8014e3:	6a 15                	push   $0x15
  8014e5:	e8 f1 fd ff ff       	call   8012db <syscall>
  8014ea:	83 c4 18             	add    $0x18,%esp
}
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	52                   	push   %edx
  8014ff:	50                   	push   %eax
  801500:	6a 18                	push   $0x18
  801502:	e8 d4 fd ff ff       	call   8012db <syscall>
  801507:	83 c4 18             	add    $0x18,%esp
}
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80150f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	52                   	push   %edx
  80151c:	50                   	push   %eax
  80151d:	6a 16                	push   $0x16
  80151f:	e8 b7 fd ff ff       	call   8012db <syscall>
  801524:	83 c4 18             	add    $0x18,%esp
}
  801527:	90                   	nop
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80152d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	52                   	push   %edx
  80153a:	50                   	push   %eax
  80153b:	6a 17                	push   $0x17
  80153d:	e8 99 fd ff ff       	call   8012db <syscall>
  801542:	83 c4 18             	add    $0x18,%esp
}
  801545:	90                   	nop
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 04             	sub    $0x4,%esp
  80154e:	8b 45 10             	mov    0x10(%ebp),%eax
  801551:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801554:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801557:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	6a 00                	push   $0x0
  801560:	51                   	push   %ecx
  801561:	52                   	push   %edx
  801562:	ff 75 0c             	pushl  0xc(%ebp)
  801565:	50                   	push   %eax
  801566:	6a 19                	push   $0x19
  801568:	e8 6e fd ff ff       	call   8012db <syscall>
  80156d:	83 c4 18             	add    $0x18,%esp
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801575:	8b 55 0c             	mov    0xc(%ebp),%edx
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	52                   	push   %edx
  801582:	50                   	push   %eax
  801583:	6a 1a                	push   $0x1a
  801585:	e8 51 fd ff ff       	call   8012db <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801592:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801595:	8b 55 0c             	mov    0xc(%ebp),%edx
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	51                   	push   %ecx
  8015a0:	52                   	push   %edx
  8015a1:	50                   	push   %eax
  8015a2:	6a 1b                	push   $0x1b
  8015a4:	e8 32 fd ff ff       	call   8012db <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	52                   	push   %edx
  8015be:	50                   	push   %eax
  8015bf:	6a 1c                	push   $0x1c
  8015c1:	e8 15 fd ff ff       	call   8012db <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
}
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 1d                	push   $0x1d
  8015da:	e8 fc fc ff ff       	call   8012db <syscall>
  8015df:	83 c4 18             	add    $0x18,%esp
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	6a 00                	push   $0x0
  8015ec:	ff 75 14             	pushl  0x14(%ebp)
  8015ef:	ff 75 10             	pushl  0x10(%ebp)
  8015f2:	ff 75 0c             	pushl  0xc(%ebp)
  8015f5:	50                   	push   %eax
  8015f6:	6a 1e                	push   $0x1e
  8015f8:	e8 de fc ff ff       	call   8012db <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	50                   	push   %eax
  801611:	6a 1f                	push   $0x1f
  801613:	e8 c3 fc ff ff       	call   8012db <syscall>
  801618:	83 c4 18             	add    $0x18,%esp
}
  80161b:	90                   	nop
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	50                   	push   %eax
  80162d:	6a 20                	push   $0x20
  80162f:	e8 a7 fc ff ff       	call   8012db <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
}
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 02                	push   $0x2
  801648:	e8 8e fc ff ff       	call   8012db <syscall>
  80164d:	83 c4 18             	add    $0x18,%esp
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 03                	push   $0x3
  801661:	e8 75 fc ff ff       	call   8012db <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 04                	push   $0x4
  80167a:	e8 5c fc ff ff       	call   8012db <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_exit_env>:


void sys_exit_env(void)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 21                	push   $0x21
  801693:	e8 43 fc ff ff       	call   8012db <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	90                   	nop
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016a4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016a7:	8d 50 04             	lea    0x4(%eax),%edx
  8016aa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	52                   	push   %edx
  8016b4:	50                   	push   %eax
  8016b5:	6a 22                	push   $0x22
  8016b7:	e8 1f fc ff ff       	call   8012db <syscall>
  8016bc:	83 c4 18             	add    $0x18,%esp
	return result;
  8016bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c8:	89 01                	mov    %eax,(%ecx)
  8016ca:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	c9                   	leave  
  8016d1:	c2 04 00             	ret    $0x4

008016d4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	ff 75 10             	pushl  0x10(%ebp)
  8016de:	ff 75 0c             	pushl  0xc(%ebp)
  8016e1:	ff 75 08             	pushl  0x8(%ebp)
  8016e4:	6a 10                	push   $0x10
  8016e6:	e8 f0 fb ff ff       	call   8012db <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ee:	90                   	nop
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 23                	push   $0x23
  801700:	e8 d6 fb ff ff       	call   8012db <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 04             	sub    $0x4,%esp
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801716:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	50                   	push   %eax
  801723:	6a 24                	push   $0x24
  801725:	e8 b1 fb ff ff       	call   8012db <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
	return ;
  80172d:	90                   	nop
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <rsttst>:
void rsttst()
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 26                	push   $0x26
  80173f:	e8 97 fb ff ff       	call   8012db <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
	return ;
  801747:	90                   	nop
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 04             	sub    $0x4,%esp
  801750:	8b 45 14             	mov    0x14(%ebp),%eax
  801753:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801756:	8b 55 18             	mov    0x18(%ebp),%edx
  801759:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80175d:	52                   	push   %edx
  80175e:	50                   	push   %eax
  80175f:	ff 75 10             	pushl  0x10(%ebp)
  801762:	ff 75 0c             	pushl  0xc(%ebp)
  801765:	ff 75 08             	pushl  0x8(%ebp)
  801768:	6a 25                	push   $0x25
  80176a:	e8 6c fb ff ff       	call   8012db <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
	return ;
  801772:	90                   	nop
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <chktst>:
void chktst(uint32 n)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	ff 75 08             	pushl  0x8(%ebp)
  801783:	6a 27                	push   $0x27
  801785:	e8 51 fb ff ff       	call   8012db <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
	return ;
  80178d:	90                   	nop
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <inctst>:

void inctst()
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 28                	push   $0x28
  80179f:	e8 37 fb ff ff       	call   8012db <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a7:	90                   	nop
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <gettst>:
uint32 gettst()
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 29                	push   $0x29
  8017b9:	e8 1d fb ff ff       	call   8012db <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 2a                	push   $0x2a
  8017d5:	e8 01 fb ff ff       	call   8012db <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
  8017dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017e0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017e4:	75 07                	jne    8017ed <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8017eb:	eb 05                	jmp    8017f2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 2a                	push   $0x2a
  801806:	e8 d0 fa ff ff       	call   8012db <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
  80180e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801811:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801815:	75 07                	jne    80181e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801817:	b8 01 00 00 00       	mov    $0x1,%eax
  80181c:	eb 05                	jmp    801823 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80181e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 2a                	push   $0x2a
  801837:	e8 9f fa ff ff       	call   8012db <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
  80183f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801842:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801846:	75 07                	jne    80184f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801848:	b8 01 00 00 00       	mov    $0x1,%eax
  80184d:	eb 05                	jmp    801854 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80184f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 2a                	push   $0x2a
  801868:	e8 6e fa ff ff       	call   8012db <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
  801870:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801873:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801877:	75 07                	jne    801880 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801879:	b8 01 00 00 00       	mov    $0x1,%eax
  80187e:	eb 05                	jmp    801885 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801880:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	ff 75 08             	pushl  0x8(%ebp)
  801895:	6a 2b                	push   $0x2b
  801897:	e8 3f fa ff ff       	call   8012db <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
	return ;
  80189f:	90                   	nop
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	6a 00                	push   $0x0
  8018b4:	53                   	push   %ebx
  8018b5:	51                   	push   %ecx
  8018b6:	52                   	push   %edx
  8018b7:	50                   	push   %eax
  8018b8:	6a 2c                	push   $0x2c
  8018ba:	e8 1c fa ff ff       	call   8012db <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	52                   	push   %edx
  8018d7:	50                   	push   %eax
  8018d8:	6a 2d                	push   $0x2d
  8018da:	e8 fc f9 ff ff       	call   8012db <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018e7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	6a 00                	push   $0x0
  8018f2:	51                   	push   %ecx
  8018f3:	ff 75 10             	pushl  0x10(%ebp)
  8018f6:	52                   	push   %edx
  8018f7:	50                   	push   %eax
  8018f8:	6a 2e                	push   $0x2e
  8018fa:	e8 dc f9 ff ff       	call   8012db <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	ff 75 10             	pushl  0x10(%ebp)
  80190e:	ff 75 0c             	pushl  0xc(%ebp)
  801911:	ff 75 08             	pushl  0x8(%ebp)
  801914:	6a 0f                	push   $0xf
  801916:	e8 c0 f9 ff ff       	call   8012db <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
	return ;
  80191e:	90                   	nop
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	68 43 23 80 00       	push   $0x802343
  80192f:	68 54 01 00 00       	push   $0x154
  801934:	68 57 23 80 00       	push   $0x802357
  801939:	e8 da 00 00 00       	call   801a18 <_panic>

0080193e <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801944:	83 ec 04             	sub    $0x4,%esp
  801947:	68 43 23 80 00       	push   $0x802343
  80194c:	68 5b 01 00 00       	push   $0x15b
  801951:	68 57 23 80 00       	push   $0x802357
  801956:	e8 bd 00 00 00       	call   801a18 <_panic>

0080195b <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801961:	83 ec 04             	sub    $0x4,%esp
  801964:	68 43 23 80 00       	push   $0x802343
  801969:	68 61 01 00 00       	push   $0x161
  80196e:	68 57 23 80 00       	push   $0x802357
  801973:	e8 a0 00 00 00       	call   801a18 <_panic>

00801978 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801984:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801988:	83 ec 0c             	sub    $0xc,%esp
  80198b:	50                   	push   %eax
  80198c:	e8 02 fb ff ff       	call   801493 <sys_cputc>
  801991:	83 c4 10             	add    $0x10,%esp
}
  801994:	90                   	nop
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80199d:	e8 bd fa ff ff       	call   80145f <sys_disable_interrupt>
	char c = ch;
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019a8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019ac:	83 ec 0c             	sub    $0xc,%esp
  8019af:	50                   	push   %eax
  8019b0:	e8 de fa ff ff       	call   801493 <sys_cputc>
  8019b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8019b8:	e8 bc fa ff ff       	call   801479 <sys_enable_interrupt>
}
  8019bd:	90                   	nop
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <getchar>:

int
getchar(void)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8019c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8019cd:	eb 08                	jmp    8019d7 <getchar+0x17>
	{
		c = sys_cgetc();
  8019cf:	e8 5b f9 ff ff       	call   80132f <sys_cgetc>
  8019d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8019d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019db:	74 f2                	je     8019cf <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8019dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <atomic_getchar>:

int
atomic_getchar(void)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8019e8:	e8 72 fa ff ff       	call   80145f <sys_disable_interrupt>
	int c=0;
  8019ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8019f4:	eb 08                	jmp    8019fe <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8019f6:	e8 34 f9 ff ff       	call   80132f <sys_cgetc>
  8019fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8019fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a02:	74 f2                	je     8019f6 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801a04:	e8 70 fa ff ff       	call   801479 <sys_enable_interrupt>
	return c;
  801a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <iscons>:

int iscons(int fdnum)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a11:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a16:	5d                   	pop    %ebp
  801a17:	c3                   	ret    

00801a18 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a1e:	8d 45 10             	lea    0x10(%ebp),%eax
  801a21:	83 c0 04             	add    $0x4,%eax
  801a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801a27:	a1 18 31 80 00       	mov    0x803118,%eax
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	74 16                	je     801a46 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a30:	a1 18 31 80 00       	mov    0x803118,%eax
  801a35:	83 ec 08             	sub    $0x8,%esp
  801a38:	50                   	push   %eax
  801a39:	68 68 23 80 00       	push   $0x802368
  801a3e:	e8 b7 e8 ff ff       	call   8002fa <cprintf>
  801a43:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801a46:	a1 00 30 80 00       	mov    0x803000,%eax
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	ff 75 08             	pushl  0x8(%ebp)
  801a51:	50                   	push   %eax
  801a52:	68 6d 23 80 00       	push   $0x80236d
  801a57:	e8 9e e8 ff ff       	call   8002fa <cprintf>
  801a5c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801a5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a62:	83 ec 08             	sub    $0x8,%esp
  801a65:	ff 75 f4             	pushl  -0xc(%ebp)
  801a68:	50                   	push   %eax
  801a69:	e8 21 e8 ff ff       	call   80028f <vcprintf>
  801a6e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801a71:	83 ec 08             	sub    $0x8,%esp
  801a74:	6a 00                	push   $0x0
  801a76:	68 89 23 80 00       	push   $0x802389
  801a7b:	e8 0f e8 ff ff       	call   80028f <vcprintf>
  801a80:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801a83:	e8 90 e7 ff ff       	call   800218 <exit>

	// should not return here
	while (1) ;
  801a88:	eb fe                	jmp    801a88 <_panic+0x70>

00801a8a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801a90:	a1 20 30 80 00       	mov    0x803020,%eax
  801a95:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  801a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9e:	39 c2                	cmp    %eax,%edx
  801aa0:	74 14                	je     801ab6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	68 8c 23 80 00       	push   $0x80238c
  801aaa:	6a 26                	push   $0x26
  801aac:	68 d8 23 80 00       	push   $0x8023d8
  801ab1:	e8 62 ff ff ff       	call   801a18 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801ab6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801abd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801ac4:	e9 c5 00 00 00       	jmp    801b8e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801acc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	01 d0                	add    %edx,%eax
  801ad8:	8b 00                	mov    (%eax),%eax
  801ada:	85 c0                	test   %eax,%eax
  801adc:	75 08                	jne    801ae6 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801ade:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801ae1:	e9 a5 00 00 00       	jmp    801b8b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801ae6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801af4:	eb 69                	jmp    801b5f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801af6:	a1 20 30 80 00       	mov    0x803020,%eax
  801afb:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  801b01:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b04:	89 d0                	mov    %edx,%eax
  801b06:	01 c0                	add    %eax,%eax
  801b08:	01 d0                	add    %edx,%eax
  801b0a:	c1 e0 03             	shl    $0x3,%eax
  801b0d:	01 c8                	add    %ecx,%eax
  801b0f:	8a 40 04             	mov    0x4(%eax),%al
  801b12:	84 c0                	test   %al,%al
  801b14:	75 46                	jne    801b5c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b16:	a1 20 30 80 00       	mov    0x803020,%eax
  801b1b:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  801b21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b24:	89 d0                	mov    %edx,%eax
  801b26:	01 c0                	add    %eax,%eax
  801b28:	01 d0                	add    %edx,%eax
  801b2a:	c1 e0 03             	shl    $0x3,%eax
  801b2d:	01 c8                	add    %ecx,%eax
  801b2f:	8b 00                	mov    (%eax),%eax
  801b31:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b34:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b3c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b41:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	01 c8                	add    %ecx,%eax
  801b4d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b4f:	39 c2                	cmp    %eax,%edx
  801b51:	75 09                	jne    801b5c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801b53:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801b5a:	eb 15                	jmp    801b71 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b5c:	ff 45 e8             	incl   -0x18(%ebp)
  801b5f:	a1 20 30 80 00       	mov    0x803020,%eax
  801b64:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  801b6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b6d:	39 c2                	cmp    %eax,%edx
  801b6f:	77 85                	ja     801af6 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801b71:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b75:	75 14                	jne    801b8b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801b77:	83 ec 04             	sub    $0x4,%esp
  801b7a:	68 e4 23 80 00       	push   $0x8023e4
  801b7f:	6a 3a                	push   $0x3a
  801b81:	68 d8 23 80 00       	push   $0x8023d8
  801b86:	e8 8d fe ff ff       	call   801a18 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801b8b:	ff 45 f0             	incl   -0x10(%ebp)
  801b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b91:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801b94:	0f 8c 2f ff ff ff    	jl     801ac9 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b9a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ba1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ba8:	eb 26                	jmp    801bd0 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801baa:	a1 20 30 80 00       	mov    0x803020,%eax
  801baf:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  801bb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bb8:	89 d0                	mov    %edx,%eax
  801bba:	01 c0                	add    %eax,%eax
  801bbc:	01 d0                	add    %edx,%eax
  801bbe:	c1 e0 03             	shl    $0x3,%eax
  801bc1:	01 c8                	add    %ecx,%eax
  801bc3:	8a 40 04             	mov    0x4(%eax),%al
  801bc6:	3c 01                	cmp    $0x1,%al
  801bc8:	75 03                	jne    801bcd <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801bca:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bcd:	ff 45 e0             	incl   -0x20(%ebp)
  801bd0:	a1 20 30 80 00       	mov    0x803020,%eax
  801bd5:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  801bdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bde:	39 c2                	cmp    %eax,%edx
  801be0:	77 c8                	ja     801baa <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801be8:	74 14                	je     801bfe <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801bea:	83 ec 04             	sub    $0x4,%esp
  801bed:	68 38 24 80 00       	push   $0x802438
  801bf2:	6a 44                	push   $0x44
  801bf4:	68 d8 23 80 00       	push   $0x8023d8
  801bf9:	e8 1a fe ff ff       	call   801a18 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801bfe:	90                   	nop
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    
  801c01:	66 90                	xchg   %ax,%ax
  801c03:	90                   	nop

00801c04 <__udivdi3>:
  801c04:	55                   	push   %ebp
  801c05:	57                   	push   %edi
  801c06:	56                   	push   %esi
  801c07:	53                   	push   %ebx
  801c08:	83 ec 1c             	sub    $0x1c,%esp
  801c0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c1b:	89 ca                	mov    %ecx,%edx
  801c1d:	89 f8                	mov    %edi,%eax
  801c1f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c23:	85 f6                	test   %esi,%esi
  801c25:	75 2d                	jne    801c54 <__udivdi3+0x50>
  801c27:	39 cf                	cmp    %ecx,%edi
  801c29:	77 65                	ja     801c90 <__udivdi3+0x8c>
  801c2b:	89 fd                	mov    %edi,%ebp
  801c2d:	85 ff                	test   %edi,%edi
  801c2f:	75 0b                	jne    801c3c <__udivdi3+0x38>
  801c31:	b8 01 00 00 00       	mov    $0x1,%eax
  801c36:	31 d2                	xor    %edx,%edx
  801c38:	f7 f7                	div    %edi
  801c3a:	89 c5                	mov    %eax,%ebp
  801c3c:	31 d2                	xor    %edx,%edx
  801c3e:	89 c8                	mov    %ecx,%eax
  801c40:	f7 f5                	div    %ebp
  801c42:	89 c1                	mov    %eax,%ecx
  801c44:	89 d8                	mov    %ebx,%eax
  801c46:	f7 f5                	div    %ebp
  801c48:	89 cf                	mov    %ecx,%edi
  801c4a:	89 fa                	mov    %edi,%edx
  801c4c:	83 c4 1c             	add    $0x1c,%esp
  801c4f:	5b                   	pop    %ebx
  801c50:	5e                   	pop    %esi
  801c51:	5f                   	pop    %edi
  801c52:	5d                   	pop    %ebp
  801c53:	c3                   	ret    
  801c54:	39 ce                	cmp    %ecx,%esi
  801c56:	77 28                	ja     801c80 <__udivdi3+0x7c>
  801c58:	0f bd fe             	bsr    %esi,%edi
  801c5b:	83 f7 1f             	xor    $0x1f,%edi
  801c5e:	75 40                	jne    801ca0 <__udivdi3+0x9c>
  801c60:	39 ce                	cmp    %ecx,%esi
  801c62:	72 0a                	jb     801c6e <__udivdi3+0x6a>
  801c64:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c68:	0f 87 9e 00 00 00    	ja     801d0c <__udivdi3+0x108>
  801c6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c73:	89 fa                	mov    %edi,%edx
  801c75:	83 c4 1c             	add    $0x1c,%esp
  801c78:	5b                   	pop    %ebx
  801c79:	5e                   	pop    %esi
  801c7a:	5f                   	pop    %edi
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    
  801c7d:	8d 76 00             	lea    0x0(%esi),%esi
  801c80:	31 ff                	xor    %edi,%edi
  801c82:	31 c0                	xor    %eax,%eax
  801c84:	89 fa                	mov    %edi,%edx
  801c86:	83 c4 1c             	add    $0x1c,%esp
  801c89:	5b                   	pop    %ebx
  801c8a:	5e                   	pop    %esi
  801c8b:	5f                   	pop    %edi
  801c8c:	5d                   	pop    %ebp
  801c8d:	c3                   	ret    
  801c8e:	66 90                	xchg   %ax,%ax
  801c90:	89 d8                	mov    %ebx,%eax
  801c92:	f7 f7                	div    %edi
  801c94:	31 ff                	xor    %edi,%edi
  801c96:	89 fa                	mov    %edi,%edx
  801c98:	83 c4 1c             	add    $0x1c,%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5e                   	pop    %esi
  801c9d:	5f                   	pop    %edi
  801c9e:	5d                   	pop    %ebp
  801c9f:	c3                   	ret    
  801ca0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ca5:	89 eb                	mov    %ebp,%ebx
  801ca7:	29 fb                	sub    %edi,%ebx
  801ca9:	89 f9                	mov    %edi,%ecx
  801cab:	d3 e6                	shl    %cl,%esi
  801cad:	89 c5                	mov    %eax,%ebp
  801caf:	88 d9                	mov    %bl,%cl
  801cb1:	d3 ed                	shr    %cl,%ebp
  801cb3:	89 e9                	mov    %ebp,%ecx
  801cb5:	09 f1                	or     %esi,%ecx
  801cb7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cbb:	89 f9                	mov    %edi,%ecx
  801cbd:	d3 e0                	shl    %cl,%eax
  801cbf:	89 c5                	mov    %eax,%ebp
  801cc1:	89 d6                	mov    %edx,%esi
  801cc3:	88 d9                	mov    %bl,%cl
  801cc5:	d3 ee                	shr    %cl,%esi
  801cc7:	89 f9                	mov    %edi,%ecx
  801cc9:	d3 e2                	shl    %cl,%edx
  801ccb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ccf:	88 d9                	mov    %bl,%cl
  801cd1:	d3 e8                	shr    %cl,%eax
  801cd3:	09 c2                	or     %eax,%edx
  801cd5:	89 d0                	mov    %edx,%eax
  801cd7:	89 f2                	mov    %esi,%edx
  801cd9:	f7 74 24 0c          	divl   0xc(%esp)
  801cdd:	89 d6                	mov    %edx,%esi
  801cdf:	89 c3                	mov    %eax,%ebx
  801ce1:	f7 e5                	mul    %ebp
  801ce3:	39 d6                	cmp    %edx,%esi
  801ce5:	72 19                	jb     801d00 <__udivdi3+0xfc>
  801ce7:	74 0b                	je     801cf4 <__udivdi3+0xf0>
  801ce9:	89 d8                	mov    %ebx,%eax
  801ceb:	31 ff                	xor    %edi,%edi
  801ced:	e9 58 ff ff ff       	jmp    801c4a <__udivdi3+0x46>
  801cf2:	66 90                	xchg   %ax,%ax
  801cf4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cf8:	89 f9                	mov    %edi,%ecx
  801cfa:	d3 e2                	shl    %cl,%edx
  801cfc:	39 c2                	cmp    %eax,%edx
  801cfe:	73 e9                	jae    801ce9 <__udivdi3+0xe5>
  801d00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d03:	31 ff                	xor    %edi,%edi
  801d05:	e9 40 ff ff ff       	jmp    801c4a <__udivdi3+0x46>
  801d0a:	66 90                	xchg   %ax,%ax
  801d0c:	31 c0                	xor    %eax,%eax
  801d0e:	e9 37 ff ff ff       	jmp    801c4a <__udivdi3+0x46>
  801d13:	90                   	nop

00801d14 <__umoddi3>:
  801d14:	55                   	push   %ebp
  801d15:	57                   	push   %edi
  801d16:	56                   	push   %esi
  801d17:	53                   	push   %ebx
  801d18:	83 ec 1c             	sub    $0x1c,%esp
  801d1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d33:	89 f3                	mov    %esi,%ebx
  801d35:	89 fa                	mov    %edi,%edx
  801d37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d3b:	89 34 24             	mov    %esi,(%esp)
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	75 1a                	jne    801d5c <__umoddi3+0x48>
  801d42:	39 f7                	cmp    %esi,%edi
  801d44:	0f 86 a2 00 00 00    	jbe    801dec <__umoddi3+0xd8>
  801d4a:	89 c8                	mov    %ecx,%eax
  801d4c:	89 f2                	mov    %esi,%edx
  801d4e:	f7 f7                	div    %edi
  801d50:	89 d0                	mov    %edx,%eax
  801d52:	31 d2                	xor    %edx,%edx
  801d54:	83 c4 1c             	add    $0x1c,%esp
  801d57:	5b                   	pop    %ebx
  801d58:	5e                   	pop    %esi
  801d59:	5f                   	pop    %edi
  801d5a:	5d                   	pop    %ebp
  801d5b:	c3                   	ret    
  801d5c:	39 f0                	cmp    %esi,%eax
  801d5e:	0f 87 ac 00 00 00    	ja     801e10 <__umoddi3+0xfc>
  801d64:	0f bd e8             	bsr    %eax,%ebp
  801d67:	83 f5 1f             	xor    $0x1f,%ebp
  801d6a:	0f 84 ac 00 00 00    	je     801e1c <__umoddi3+0x108>
  801d70:	bf 20 00 00 00       	mov    $0x20,%edi
  801d75:	29 ef                	sub    %ebp,%edi
  801d77:	89 fe                	mov    %edi,%esi
  801d79:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d7d:	89 e9                	mov    %ebp,%ecx
  801d7f:	d3 e0                	shl    %cl,%eax
  801d81:	89 d7                	mov    %edx,%edi
  801d83:	89 f1                	mov    %esi,%ecx
  801d85:	d3 ef                	shr    %cl,%edi
  801d87:	09 c7                	or     %eax,%edi
  801d89:	89 e9                	mov    %ebp,%ecx
  801d8b:	d3 e2                	shl    %cl,%edx
  801d8d:	89 14 24             	mov    %edx,(%esp)
  801d90:	89 d8                	mov    %ebx,%eax
  801d92:	d3 e0                	shl    %cl,%eax
  801d94:	89 c2                	mov    %eax,%edx
  801d96:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d9a:	d3 e0                	shl    %cl,%eax
  801d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801da4:	89 f1                	mov    %esi,%ecx
  801da6:	d3 e8                	shr    %cl,%eax
  801da8:	09 d0                	or     %edx,%eax
  801daa:	d3 eb                	shr    %cl,%ebx
  801dac:	89 da                	mov    %ebx,%edx
  801dae:	f7 f7                	div    %edi
  801db0:	89 d3                	mov    %edx,%ebx
  801db2:	f7 24 24             	mull   (%esp)
  801db5:	89 c6                	mov    %eax,%esi
  801db7:	89 d1                	mov    %edx,%ecx
  801db9:	39 d3                	cmp    %edx,%ebx
  801dbb:	0f 82 87 00 00 00    	jb     801e48 <__umoddi3+0x134>
  801dc1:	0f 84 91 00 00 00    	je     801e58 <__umoddi3+0x144>
  801dc7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dcb:	29 f2                	sub    %esi,%edx
  801dcd:	19 cb                	sbb    %ecx,%ebx
  801dcf:	89 d8                	mov    %ebx,%eax
  801dd1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801dd5:	d3 e0                	shl    %cl,%eax
  801dd7:	89 e9                	mov    %ebp,%ecx
  801dd9:	d3 ea                	shr    %cl,%edx
  801ddb:	09 d0                	or     %edx,%eax
  801ddd:	89 e9                	mov    %ebp,%ecx
  801ddf:	d3 eb                	shr    %cl,%ebx
  801de1:	89 da                	mov    %ebx,%edx
  801de3:	83 c4 1c             	add    $0x1c,%esp
  801de6:	5b                   	pop    %ebx
  801de7:	5e                   	pop    %esi
  801de8:	5f                   	pop    %edi
  801de9:	5d                   	pop    %ebp
  801dea:	c3                   	ret    
  801deb:	90                   	nop
  801dec:	89 fd                	mov    %edi,%ebp
  801dee:	85 ff                	test   %edi,%edi
  801df0:	75 0b                	jne    801dfd <__umoddi3+0xe9>
  801df2:	b8 01 00 00 00       	mov    $0x1,%eax
  801df7:	31 d2                	xor    %edx,%edx
  801df9:	f7 f7                	div    %edi
  801dfb:	89 c5                	mov    %eax,%ebp
  801dfd:	89 f0                	mov    %esi,%eax
  801dff:	31 d2                	xor    %edx,%edx
  801e01:	f7 f5                	div    %ebp
  801e03:	89 c8                	mov    %ecx,%eax
  801e05:	f7 f5                	div    %ebp
  801e07:	89 d0                	mov    %edx,%eax
  801e09:	e9 44 ff ff ff       	jmp    801d52 <__umoddi3+0x3e>
  801e0e:	66 90                	xchg   %ax,%ax
  801e10:	89 c8                	mov    %ecx,%eax
  801e12:	89 f2                	mov    %esi,%edx
  801e14:	83 c4 1c             	add    $0x1c,%esp
  801e17:	5b                   	pop    %ebx
  801e18:	5e                   	pop    %esi
  801e19:	5f                   	pop    %edi
  801e1a:	5d                   	pop    %ebp
  801e1b:	c3                   	ret    
  801e1c:	3b 04 24             	cmp    (%esp),%eax
  801e1f:	72 06                	jb     801e27 <__umoddi3+0x113>
  801e21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e25:	77 0f                	ja     801e36 <__umoddi3+0x122>
  801e27:	89 f2                	mov    %esi,%edx
  801e29:	29 f9                	sub    %edi,%ecx
  801e2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e2f:	89 14 24             	mov    %edx,(%esp)
  801e32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e36:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e3a:	8b 14 24             	mov    (%esp),%edx
  801e3d:	83 c4 1c             	add    $0x1c,%esp
  801e40:	5b                   	pop    %ebx
  801e41:	5e                   	pop    %esi
  801e42:	5f                   	pop    %edi
  801e43:	5d                   	pop    %ebp
  801e44:	c3                   	ret    
  801e45:	8d 76 00             	lea    0x0(%esi),%esi
  801e48:	2b 04 24             	sub    (%esp),%eax
  801e4b:	19 fa                	sbb    %edi,%edx
  801e4d:	89 d1                	mov    %edx,%ecx
  801e4f:	89 c6                	mov    %eax,%esi
  801e51:	e9 71 ff ff ff       	jmp    801dc7 <__umoddi3+0xb3>
  801e56:	66 90                	xchg   %ax,%ax
  801e58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e5c:	72 ea                	jb     801e48 <__umoddi3+0x134>
  801e5e:	89 d9                	mov    %ebx,%ecx
  801e60:	e9 62 ff ff ff       	jmp    801dc7 <__umoddi3+0xb3>
