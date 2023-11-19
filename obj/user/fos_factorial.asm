
obj/user/fos_factorial:     file format elf32-i386


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
  800031:	e8 95 00 00 00       	call   8000cb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int factorial(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter a number:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 a0 1c 80 00       	push   $0x801ca0
  800057:	e8 08 0a 00 00       	call   800a64 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 65 0e 00 00       	call   800ed7 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int res = factorial(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 1f 00 00 00       	call   8000a2 <factorial>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Factorial %d = %d\n",i1, res);
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	ff 75 f0             	pushl  -0x10(%ebp)
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	68 b7 1c 80 00       	push   $0x801cb7
  800097:	e8 75 02 00 00       	call   800311 <atomic_cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
	return;
  80009f:	90                   	nop
}
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <factorial>:


int factorial(int n)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	83 ec 08             	sub    $0x8,%esp
	if (n <= 1)
  8000a8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ac:	7f 07                	jg     8000b5 <factorial+0x13>
		return 1 ;
  8000ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b3:	eb 14                	jmp    8000c9 <factorial+0x27>
	return n * factorial(n-1) ;
  8000b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b8:	48                   	dec    %eax
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	50                   	push   %eax
  8000bd:	e8 e0 ff ff ff       	call   8000a2 <factorial>
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	0f af 45 08          	imul   0x8(%ebp),%eax
}
  8000c9:	c9                   	leave  
  8000ca:	c3                   	ret    

008000cb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000d1:	e8 88 15 00 00       	call   80165e <sys_getenvindex>
  8000d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000dc:	89 d0                	mov    %edx,%eax
  8000de:	01 c0                	add    %eax,%eax
  8000e0:	01 d0                	add    %edx,%eax
  8000e2:	01 c0                	add    %eax,%eax
  8000e4:	01 d0                	add    %edx,%eax
  8000e6:	c1 e0 02             	shl    $0x2,%eax
  8000e9:	01 d0                	add    %edx,%eax
  8000eb:	01 c0                	add    %eax,%eax
  8000ed:	01 d0                	add    %edx,%eax
  8000ef:	c1 e0 02             	shl    $0x2,%eax
  8000f2:	01 d0                	add    %edx,%eax
  8000f4:	c1 e0 02             	shl    $0x2,%eax
  8000f7:	01 d0                	add    %edx,%eax
  8000f9:	c1 e0 02             	shl    $0x2,%eax
  8000fc:	01 d0                	add    %edx,%eax
  8000fe:	c1 e0 05             	shl    $0x5,%eax
  800101:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800106:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80010b:	a1 20 30 80 00       	mov    0x803020,%eax
  800110:	8a 40 5c             	mov    0x5c(%eax),%al
  800113:	84 c0                	test   %al,%al
  800115:	74 0d                	je     800124 <libmain+0x59>
		binaryname = myEnv->prog_name;
  800117:	a1 20 30 80 00       	mov    0x803020,%eax
  80011c:	83 c0 5c             	add    $0x5c,%eax
  80011f:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800124:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800128:	7e 0a                	jle    800134 <libmain+0x69>
		binaryname = argv[0];
  80012a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80012d:	8b 00                	mov    (%eax),%eax
  80012f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 0c             	pushl  0xc(%ebp)
  80013a:	ff 75 08             	pushl  0x8(%ebp)
  80013d:	e8 f6 fe ff ff       	call   800038 <_main>
  800142:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800145:	e8 21 13 00 00       	call   80146b <sys_disable_interrupt>
	cprintf("**************************************\n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 e4 1c 80 00       	push   $0x801ce4
  800152:	e8 8d 01 00 00       	call   8002e4 <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80015a:	a1 20 30 80 00       	mov    0x803020,%eax
  80015f:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  800165:	a1 20 30 80 00       	mov    0x803020,%eax
  80016a:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  800170:	83 ec 04             	sub    $0x4,%esp
  800173:	52                   	push   %edx
  800174:	50                   	push   %eax
  800175:	68 0c 1d 80 00       	push   $0x801d0c
  80017a:	e8 65 01 00 00       	call   8002e4 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800182:	a1 20 30 80 00       	mov    0x803020,%eax
  800187:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  80018d:	a1 20 30 80 00       	mov    0x803020,%eax
  800192:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  800198:	a1 20 30 80 00       	mov    0x803020,%eax
  80019d:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  8001a3:	51                   	push   %ecx
  8001a4:	52                   	push   %edx
  8001a5:	50                   	push   %eax
  8001a6:	68 34 1d 80 00       	push   $0x801d34
  8001ab:	e8 34 01 00 00       	call   8002e4 <cprintf>
  8001b0:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b8:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	50                   	push   %eax
  8001c2:	68 8c 1d 80 00       	push   $0x801d8c
  8001c7:	e8 18 01 00 00       	call   8002e4 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001cf:	83 ec 0c             	sub    $0xc,%esp
  8001d2:	68 e4 1c 80 00       	push   $0x801ce4
  8001d7:	e8 08 01 00 00       	call   8002e4 <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001df:	e8 a1 12 00 00       	call   801485 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001e4:	e8 19 00 00 00       	call   800202 <exit>
}
  8001e9:	90                   	nop
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    

008001ec <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001f2:	83 ec 0c             	sub    $0xc,%esp
  8001f5:	6a 00                	push   $0x0
  8001f7:	e8 2e 14 00 00       	call   80162a <sys_destroy_env>
  8001fc:	83 c4 10             	add    $0x10,%esp
}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <exit>:

void
exit(void)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800208:	e8 83 14 00 00       	call   801690 <sys_exit_env>
}
  80020d:	90                   	nop
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800216:	8b 45 0c             	mov    0xc(%ebp),%eax
  800219:	8b 00                	mov    (%eax),%eax
  80021b:	8d 48 01             	lea    0x1(%eax),%ecx
  80021e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800221:	89 0a                	mov    %ecx,(%edx)
  800223:	8b 55 08             	mov    0x8(%ebp),%edx
  800226:	88 d1                	mov    %dl,%cl
  800228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80022f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800232:	8b 00                	mov    (%eax),%eax
  800234:	3d ff 00 00 00       	cmp    $0xff,%eax
  800239:	75 2c                	jne    800267 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80023b:	a0 24 30 80 00       	mov    0x803024,%al
  800240:	0f b6 c0             	movzbl %al,%eax
  800243:	8b 55 0c             	mov    0xc(%ebp),%edx
  800246:	8b 12                	mov    (%edx),%edx
  800248:	89 d1                	mov    %edx,%ecx
  80024a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024d:	83 c2 08             	add    $0x8,%edx
  800250:	83 ec 04             	sub    $0x4,%esp
  800253:	50                   	push   %eax
  800254:	51                   	push   %ecx
  800255:	52                   	push   %edx
  800256:	e8 b7 10 00 00       	call   801312 <sys_cputs>
  80025b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80025e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800261:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026a:	8b 40 04             	mov    0x4(%eax),%eax
  80026d:	8d 50 01             	lea    0x1(%eax),%edx
  800270:	8b 45 0c             	mov    0xc(%ebp),%eax
  800273:	89 50 04             	mov    %edx,0x4(%eax)
}
  800276:	90                   	nop
  800277:	c9                   	leave  
  800278:	c3                   	ret    

00800279 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800282:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800289:	00 00 00 
	b.cnt = 0;
  80028c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800293:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800296:	ff 75 0c             	pushl  0xc(%ebp)
  800299:	ff 75 08             	pushl  0x8(%ebp)
  80029c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a2:	50                   	push   %eax
  8002a3:	68 10 02 80 00       	push   $0x800210
  8002a8:	e8 11 02 00 00       	call   8004be <vprintfmt>
  8002ad:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002b0:	a0 24 30 80 00       	mov    0x803024,%al
  8002b5:	0f b6 c0             	movzbl %al,%eax
  8002b8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002be:	83 ec 04             	sub    $0x4,%esp
  8002c1:	50                   	push   %eax
  8002c2:	52                   	push   %edx
  8002c3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c9:	83 c0 08             	add    $0x8,%eax
  8002cc:	50                   	push   %eax
  8002cd:	e8 40 10 00 00       	call   801312 <sys_cputs>
  8002d2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002d5:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002dc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002ea:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8002f1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800300:	50                   	push   %eax
  800301:	e8 73 ff ff ff       	call   800279 <vcprintf>
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80030c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800317:	e8 4f 11 00 00       	call   80146b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80031c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80031f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800322:	8b 45 08             	mov    0x8(%ebp),%eax
  800325:	83 ec 08             	sub    $0x8,%esp
  800328:	ff 75 f4             	pushl  -0xc(%ebp)
  80032b:	50                   	push   %eax
  80032c:	e8 48 ff ff ff       	call   800279 <vcprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800337:	e8 49 11 00 00       	call   801485 <sys_enable_interrupt>
	return cnt;
  80033c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80033f:	c9                   	leave  
  800340:	c3                   	ret    

00800341 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	53                   	push   %ebx
  800345:	83 ec 14             	sub    $0x14,%esp
  800348:	8b 45 10             	mov    0x10(%ebp),%eax
  80034b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80034e:	8b 45 14             	mov    0x14(%ebp),%eax
  800351:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800354:	8b 45 18             	mov    0x18(%ebp),%eax
  800357:	ba 00 00 00 00       	mov    $0x0,%edx
  80035c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80035f:	77 55                	ja     8003b6 <printnum+0x75>
  800361:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800364:	72 05                	jb     80036b <printnum+0x2a>
  800366:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800369:	77 4b                	ja     8003b6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80036e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800371:	8b 45 18             	mov    0x18(%ebp),%eax
  800374:	ba 00 00 00 00       	mov    $0x0,%edx
  800379:	52                   	push   %edx
  80037a:	50                   	push   %eax
  80037b:	ff 75 f4             	pushl  -0xc(%ebp)
  80037e:	ff 75 f0             	pushl  -0x10(%ebp)
  800381:	e8 9a 16 00 00       	call   801a20 <__udivdi3>
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	83 ec 04             	sub    $0x4,%esp
  80038c:	ff 75 20             	pushl  0x20(%ebp)
  80038f:	53                   	push   %ebx
  800390:	ff 75 18             	pushl  0x18(%ebp)
  800393:	52                   	push   %edx
  800394:	50                   	push   %eax
  800395:	ff 75 0c             	pushl  0xc(%ebp)
  800398:	ff 75 08             	pushl  0x8(%ebp)
  80039b:	e8 a1 ff ff ff       	call   800341 <printnum>
  8003a0:	83 c4 20             	add    $0x20,%esp
  8003a3:	eb 1a                	jmp    8003bf <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	ff 75 0c             	pushl  0xc(%ebp)
  8003ab:	ff 75 20             	pushl  0x20(%ebp)
  8003ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b1:	ff d0                	call   *%eax
  8003b3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b6:	ff 4d 1c             	decl   0x1c(%ebp)
  8003b9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003bd:	7f e6                	jg     8003a5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003bf:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003cd:	53                   	push   %ebx
  8003ce:	51                   	push   %ecx
  8003cf:	52                   	push   %edx
  8003d0:	50                   	push   %eax
  8003d1:	e8 5a 17 00 00       	call   801b30 <__umoddi3>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	05 b4 1f 80 00       	add    $0x801fb4,%eax
  8003de:	8a 00                	mov    (%eax),%al
  8003e0:	0f be c0             	movsbl %al,%eax
  8003e3:	83 ec 08             	sub    $0x8,%esp
  8003e6:	ff 75 0c             	pushl  0xc(%ebp)
  8003e9:	50                   	push   %eax
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	ff d0                	call   *%eax
  8003ef:	83 c4 10             	add    $0x10,%esp
}
  8003f2:	90                   	nop
  8003f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003f6:	c9                   	leave  
  8003f7:	c3                   	ret    

008003f8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003f8:	55                   	push   %ebp
  8003f9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003fb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003ff:	7e 1c                	jle    80041d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	8d 50 08             	lea    0x8(%eax),%edx
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
  80040c:	89 10                	mov    %edx,(%eax)
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	83 e8 08             	sub    $0x8,%eax
  800416:	8b 50 04             	mov    0x4(%eax),%edx
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	eb 40                	jmp    80045d <getuint+0x65>
	else if (lflag)
  80041d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800421:	74 1e                	je     800441 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
  800426:	8b 00                	mov    (%eax),%eax
  800428:	8d 50 04             	lea    0x4(%eax),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	89 10                	mov    %edx,(%eax)
  800430:	8b 45 08             	mov    0x8(%ebp),%eax
  800433:	8b 00                	mov    (%eax),%eax
  800435:	83 e8 04             	sub    $0x4,%eax
  800438:	8b 00                	mov    (%eax),%eax
  80043a:	ba 00 00 00 00       	mov    $0x0,%edx
  80043f:	eb 1c                	jmp    80045d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	8d 50 04             	lea    0x4(%eax),%edx
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	89 10                	mov    %edx,(%eax)
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	83 e8 04             	sub    $0x4,%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80045d:	5d                   	pop    %ebp
  80045e:	c3                   	ret    

0080045f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800462:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800466:	7e 1c                	jle    800484 <getint+0x25>
		return va_arg(*ap, long long);
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	8d 50 08             	lea    0x8(%eax),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	89 10                	mov    %edx,(%eax)
  800475:	8b 45 08             	mov    0x8(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	83 e8 08             	sub    $0x8,%eax
  80047d:	8b 50 04             	mov    0x4(%eax),%edx
  800480:	8b 00                	mov    (%eax),%eax
  800482:	eb 38                	jmp    8004bc <getint+0x5d>
	else if (lflag)
  800484:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800488:	74 1a                	je     8004a4 <getint+0x45>
		return va_arg(*ap, long);
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	8d 50 04             	lea    0x4(%eax),%edx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	89 10                	mov    %edx,(%eax)
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	83 e8 04             	sub    $0x4,%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	99                   	cltd   
  8004a2:	eb 18                	jmp    8004bc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	8d 50 04             	lea    0x4(%eax),%edx
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	89 10                	mov    %edx,(%eax)
  8004b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	83 e8 04             	sub    $0x4,%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	99                   	cltd   
}
  8004bc:	5d                   	pop    %ebp
  8004bd:	c3                   	ret    

008004be <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
  8004c1:	56                   	push   %esi
  8004c2:	53                   	push   %ebx
  8004c3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c6:	eb 17                	jmp    8004df <vprintfmt+0x21>
			if (ch == '\0')
  8004c8:	85 db                	test   %ebx,%ebx
  8004ca:	0f 84 af 03 00 00    	je     80087f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004d0:	83 ec 08             	sub    $0x8,%esp
  8004d3:	ff 75 0c             	pushl  0xc(%ebp)
  8004d6:	53                   	push   %ebx
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	ff d0                	call   *%eax
  8004dc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004df:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e2:	8d 50 01             	lea    0x1(%eax),%edx
  8004e5:	89 55 10             	mov    %edx,0x10(%ebp)
  8004e8:	8a 00                	mov    (%eax),%al
  8004ea:	0f b6 d8             	movzbl %al,%ebx
  8004ed:	83 fb 25             	cmp    $0x25,%ebx
  8004f0:	75 d6                	jne    8004c8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004f2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004f6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004fd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800504:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80050b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800512:	8b 45 10             	mov    0x10(%ebp),%eax
  800515:	8d 50 01             	lea    0x1(%eax),%edx
  800518:	89 55 10             	mov    %edx,0x10(%ebp)
  80051b:	8a 00                	mov    (%eax),%al
  80051d:	0f b6 d8             	movzbl %al,%ebx
  800520:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800523:	83 f8 55             	cmp    $0x55,%eax
  800526:	0f 87 2b 03 00 00    	ja     800857 <vprintfmt+0x399>
  80052c:	8b 04 85 d8 1f 80 00 	mov    0x801fd8(,%eax,4),%eax
  800533:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800535:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800539:	eb d7                	jmp    800512 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80053b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80053f:	eb d1                	jmp    800512 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800541:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800548:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054b:	89 d0                	mov    %edx,%eax
  80054d:	c1 e0 02             	shl    $0x2,%eax
  800550:	01 d0                	add    %edx,%eax
  800552:	01 c0                	add    %eax,%eax
  800554:	01 d8                	add    %ebx,%eax
  800556:	83 e8 30             	sub    $0x30,%eax
  800559:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80055c:	8b 45 10             	mov    0x10(%ebp),%eax
  80055f:	8a 00                	mov    (%eax),%al
  800561:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800564:	83 fb 2f             	cmp    $0x2f,%ebx
  800567:	7e 3e                	jle    8005a7 <vprintfmt+0xe9>
  800569:	83 fb 39             	cmp    $0x39,%ebx
  80056c:	7f 39                	jg     8005a7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80056e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800571:	eb d5                	jmp    800548 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	83 c0 04             	add    $0x4,%eax
  800579:	89 45 14             	mov    %eax,0x14(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	83 e8 04             	sub    $0x4,%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800587:	eb 1f                	jmp    8005a8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800589:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80058d:	79 83                	jns    800512 <vprintfmt+0x54>
				width = 0;
  80058f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800596:	e9 77 ff ff ff       	jmp    800512 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80059b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005a2:	e9 6b ff ff ff       	jmp    800512 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005a7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ac:	0f 89 60 ff ff ff    	jns    800512 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005b8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005bf:	e9 4e ff ff ff       	jmp    800512 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005c4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005c7:	e9 46 ff ff ff       	jmp    800512 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	83 c0 04             	add    $0x4,%eax
  8005d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	83 e8 04             	sub    $0x4,%eax
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	ff 75 0c             	pushl  0xc(%ebp)
  8005e3:	50                   	push   %eax
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	ff d0                	call   *%eax
  8005e9:	83 c4 10             	add    $0x10,%esp
			break;
  8005ec:	e9 89 02 00 00       	jmp    80087a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	83 c0 04             	add    $0x4,%eax
  8005f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	83 e8 04             	sub    $0x4,%eax
  800600:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800602:	85 db                	test   %ebx,%ebx
  800604:	79 02                	jns    800608 <vprintfmt+0x14a>
				err = -err;
  800606:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800608:	83 fb 64             	cmp    $0x64,%ebx
  80060b:	7f 0b                	jg     800618 <vprintfmt+0x15a>
  80060d:	8b 34 9d 20 1e 80 00 	mov    0x801e20(,%ebx,4),%esi
  800614:	85 f6                	test   %esi,%esi
  800616:	75 19                	jne    800631 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800618:	53                   	push   %ebx
  800619:	68 c5 1f 80 00       	push   $0x801fc5
  80061e:	ff 75 0c             	pushl  0xc(%ebp)
  800621:	ff 75 08             	pushl  0x8(%ebp)
  800624:	e8 5e 02 00 00       	call   800887 <printfmt>
  800629:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80062c:	e9 49 02 00 00       	jmp    80087a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800631:	56                   	push   %esi
  800632:	68 ce 1f 80 00       	push   $0x801fce
  800637:	ff 75 0c             	pushl  0xc(%ebp)
  80063a:	ff 75 08             	pushl  0x8(%ebp)
  80063d:	e8 45 02 00 00       	call   800887 <printfmt>
  800642:	83 c4 10             	add    $0x10,%esp
			break;
  800645:	e9 30 02 00 00       	jmp    80087a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	83 c0 04             	add    $0x4,%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	83 e8 04             	sub    $0x4,%eax
  800659:	8b 30                	mov    (%eax),%esi
  80065b:	85 f6                	test   %esi,%esi
  80065d:	75 05                	jne    800664 <vprintfmt+0x1a6>
				p = "(null)";
  80065f:	be d1 1f 80 00       	mov    $0x801fd1,%esi
			if (width > 0 && padc != '-')
  800664:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800668:	7e 6d                	jle    8006d7 <vprintfmt+0x219>
  80066a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80066e:	74 67                	je     8006d7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800670:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	50                   	push   %eax
  800677:	56                   	push   %esi
  800678:	e8 12 05 00 00       	call   800b8f <strnlen>
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800683:	eb 16                	jmp    80069b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800685:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	ff 75 0c             	pushl  0xc(%ebp)
  80068f:	50                   	push   %eax
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	ff d0                	call   *%eax
  800695:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800698:	ff 4d e4             	decl   -0x1c(%ebp)
  80069b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80069f:	7f e4                	jg     800685 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a1:	eb 34                	jmp    8006d7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006a7:	74 1c                	je     8006c5 <vprintfmt+0x207>
  8006a9:	83 fb 1f             	cmp    $0x1f,%ebx
  8006ac:	7e 05                	jle    8006b3 <vprintfmt+0x1f5>
  8006ae:	83 fb 7e             	cmp    $0x7e,%ebx
  8006b1:	7e 12                	jle    8006c5 <vprintfmt+0x207>
					putch('?', putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	6a 3f                	push   $0x3f
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	ff d0                	call   *%eax
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	eb 0f                	jmp    8006d4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006c5:	83 ec 08             	sub    $0x8,%esp
  8006c8:	ff 75 0c             	pushl  0xc(%ebp)
  8006cb:	53                   	push   %ebx
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	ff d0                	call   *%eax
  8006d1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006d4:	ff 4d e4             	decl   -0x1c(%ebp)
  8006d7:	89 f0                	mov    %esi,%eax
  8006d9:	8d 70 01             	lea    0x1(%eax),%esi
  8006dc:	8a 00                	mov    (%eax),%al
  8006de:	0f be d8             	movsbl %al,%ebx
  8006e1:	85 db                	test   %ebx,%ebx
  8006e3:	74 24                	je     800709 <vprintfmt+0x24b>
  8006e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e9:	78 b8                	js     8006a3 <vprintfmt+0x1e5>
  8006eb:	ff 4d e0             	decl   -0x20(%ebp)
  8006ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f2:	79 af                	jns    8006a3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f4:	eb 13                	jmp    800709 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	6a 20                	push   $0x20
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	ff d0                	call   *%eax
  800703:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800706:	ff 4d e4             	decl   -0x1c(%ebp)
  800709:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070d:	7f e7                	jg     8006f6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80070f:	e9 66 01 00 00       	jmp    80087a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	ff 75 e8             	pushl  -0x18(%ebp)
  80071a:	8d 45 14             	lea    0x14(%ebp),%eax
  80071d:	50                   	push   %eax
  80071e:	e8 3c fd ff ff       	call   80045f <getint>
  800723:	83 c4 10             	add    $0x10,%esp
  800726:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800729:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80072c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800732:	85 d2                	test   %edx,%edx
  800734:	79 23                	jns    800759 <vprintfmt+0x29b>
				putch('-', putdat);
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	ff 75 0c             	pushl  0xc(%ebp)
  80073c:	6a 2d                	push   $0x2d
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	ff d0                	call   *%eax
  800743:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800749:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80074c:	f7 d8                	neg    %eax
  80074e:	83 d2 00             	adc    $0x0,%edx
  800751:	f7 da                	neg    %edx
  800753:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800756:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800759:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800760:	e9 bc 00 00 00       	jmp    800821 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	ff 75 e8             	pushl  -0x18(%ebp)
  80076b:	8d 45 14             	lea    0x14(%ebp),%eax
  80076e:	50                   	push   %eax
  80076f:	e8 84 fc ff ff       	call   8003f8 <getuint>
  800774:	83 c4 10             	add    $0x10,%esp
  800777:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80077a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80077d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800784:	e9 98 00 00 00       	jmp    800821 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	6a 58                	push   $0x58
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	ff d0                	call   *%eax
  800796:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800799:	83 ec 08             	sub    $0x8,%esp
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	6a 58                	push   $0x58
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	ff d0                	call   *%eax
  8007a6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	ff 75 0c             	pushl  0xc(%ebp)
  8007af:	6a 58                	push   $0x58
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	ff d0                	call   *%eax
  8007b6:	83 c4 10             	add    $0x10,%esp
			break;
  8007b9:	e9 bc 00 00 00       	jmp    80087a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	ff 75 0c             	pushl  0xc(%ebp)
  8007c4:	6a 30                	push   $0x30
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	ff d0                	call   *%eax
  8007cb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	6a 78                	push   $0x78
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	ff d0                	call   *%eax
  8007db:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	83 c0 04             	add    $0x4,%eax
  8007e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	83 e8 04             	sub    $0x4,%eax
  8007ed:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007f9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800800:	eb 1f                	jmp    800821 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	ff 75 e8             	pushl  -0x18(%ebp)
  800808:	8d 45 14             	lea    0x14(%ebp),%eax
  80080b:	50                   	push   %eax
  80080c:	e8 e7 fb ff ff       	call   8003f8 <getuint>
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800817:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80081a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800821:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	52                   	push   %edx
  80082c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80082f:	50                   	push   %eax
  800830:	ff 75 f4             	pushl  -0xc(%ebp)
  800833:	ff 75 f0             	pushl  -0x10(%ebp)
  800836:	ff 75 0c             	pushl  0xc(%ebp)
  800839:	ff 75 08             	pushl  0x8(%ebp)
  80083c:	e8 00 fb ff ff       	call   800341 <printnum>
  800841:	83 c4 20             	add    $0x20,%esp
			break;
  800844:	eb 34                	jmp    80087a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	ff 75 0c             	pushl  0xc(%ebp)
  80084c:	53                   	push   %ebx
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	ff d0                	call   *%eax
  800852:	83 c4 10             	add    $0x10,%esp
			break;
  800855:	eb 23                	jmp    80087a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	ff 75 0c             	pushl  0xc(%ebp)
  80085d:	6a 25                	push   $0x25
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	ff d0                	call   *%eax
  800864:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800867:	ff 4d 10             	decl   0x10(%ebp)
  80086a:	eb 03                	jmp    80086f <vprintfmt+0x3b1>
  80086c:	ff 4d 10             	decl   0x10(%ebp)
  80086f:	8b 45 10             	mov    0x10(%ebp),%eax
  800872:	48                   	dec    %eax
  800873:	8a 00                	mov    (%eax),%al
  800875:	3c 25                	cmp    $0x25,%al
  800877:	75 f3                	jne    80086c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800879:	90                   	nop
		}
	}
  80087a:	e9 47 fc ff ff       	jmp    8004c6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80087f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800880:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800883:	5b                   	pop    %ebx
  800884:	5e                   	pop    %esi
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80088d:	8d 45 10             	lea    0x10(%ebp),%eax
  800890:	83 c0 04             	add    $0x4,%eax
  800893:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800896:	8b 45 10             	mov    0x10(%ebp),%eax
  800899:	ff 75 f4             	pushl  -0xc(%ebp)
  80089c:	50                   	push   %eax
  80089d:	ff 75 0c             	pushl  0xc(%ebp)
  8008a0:	ff 75 08             	pushl  0x8(%ebp)
  8008a3:	e8 16 fc ff ff       	call   8004be <vprintfmt>
  8008a8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008ab:	90                   	nop
  8008ac:	c9                   	leave  
  8008ad:	c3                   	ret    

008008ae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b4:	8b 40 08             	mov    0x8(%eax),%eax
  8008b7:	8d 50 01             	lea    0x1(%eax),%edx
  8008ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c3:	8b 10                	mov    (%eax),%edx
  8008c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c8:	8b 40 04             	mov    0x4(%eax),%eax
  8008cb:	39 c2                	cmp    %eax,%edx
  8008cd:	73 12                	jae    8008e1 <sprintputch+0x33>
		*b->buf++ = ch;
  8008cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8008d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008da:	89 0a                	mov    %ecx,(%edx)
  8008dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8008df:	88 10                	mov    %dl,(%eax)
}
  8008e1:	90                   	nop
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	01 d0                	add    %edx,%eax
  8008fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800905:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800909:	74 06                	je     800911 <vsnprintf+0x2d>
  80090b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80090f:	7f 07                	jg     800918 <vsnprintf+0x34>
		return -E_INVAL;
  800911:	b8 03 00 00 00       	mov    $0x3,%eax
  800916:	eb 20                	jmp    800938 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800918:	ff 75 14             	pushl  0x14(%ebp)
  80091b:	ff 75 10             	pushl  0x10(%ebp)
  80091e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800921:	50                   	push   %eax
  800922:	68 ae 08 80 00       	push   $0x8008ae
  800927:	e8 92 fb ff ff       	call   8004be <vprintfmt>
  80092c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80092f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800932:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800935:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800938:	c9                   	leave  
  800939:	c3                   	ret    

0080093a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800940:	8d 45 10             	lea    0x10(%ebp),%eax
  800943:	83 c0 04             	add    $0x4,%eax
  800946:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800949:	8b 45 10             	mov    0x10(%ebp),%eax
  80094c:	ff 75 f4             	pushl  -0xc(%ebp)
  80094f:	50                   	push   %eax
  800950:	ff 75 0c             	pushl  0xc(%ebp)
  800953:	ff 75 08             	pushl  0x8(%ebp)
  800956:	e8 89 ff ff ff       	call   8008e4 <vsnprintf>
  80095b:	83 c4 10             	add    $0x10,%esp
  80095e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800961:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800964:	c9                   	leave  
  800965:	c3                   	ret    

00800966 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80096c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800970:	74 13                	je     800985 <readline+0x1f>
		cprintf("%s", prompt);
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	ff 75 08             	pushl  0x8(%ebp)
  800978:	68 30 21 80 00       	push   $0x802130
  80097d:	e8 62 f9 ff ff       	call   8002e4 <cprintf>
  800982:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800985:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	6a 00                	push   $0x0
  800991:	e8 80 10 00 00       	call   801a16 <iscons>
  800996:	83 c4 10             	add    $0x10,%esp
  800999:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80099c:	e8 27 10 00 00       	call   8019c8 <getchar>
  8009a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009a8:	79 22                	jns    8009cc <readline+0x66>
			if (c != -E_EOF)
  8009aa:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009ae:	0f 84 ad 00 00 00    	je     800a61 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8009ba:	68 33 21 80 00       	push   $0x802133
  8009bf:	e8 20 f9 ff ff       	call   8002e4 <cprintf>
  8009c4:	83 c4 10             	add    $0x10,%esp
			return;
  8009c7:	e9 95 00 00 00       	jmp    800a61 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009cc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009d0:	7e 34                	jle    800a06 <readline+0xa0>
  8009d2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009d9:	7f 2b                	jg     800a06 <readline+0xa0>
			if (echoing)
  8009db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009df:	74 0e                	je     8009ef <readline+0x89>
				cputchar(c);
  8009e1:	83 ec 0c             	sub    $0xc,%esp
  8009e4:	ff 75 ec             	pushl  -0x14(%ebp)
  8009e7:	e8 94 0f 00 00       	call   801980 <cputchar>
  8009ec:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8009ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f2:	8d 50 01             	lea    0x1(%eax),%edx
  8009f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8009f8:	89 c2                	mov    %eax,%edx
  8009fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fd:	01 d0                	add    %edx,%eax
  8009ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a02:	88 10                	mov    %dl,(%eax)
  800a04:	eb 56                	jmp    800a5c <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a06:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a0a:	75 1f                	jne    800a2b <readline+0xc5>
  800a0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a10:	7e 19                	jle    800a2b <readline+0xc5>
			if (echoing)
  800a12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a16:	74 0e                	je     800a26 <readline+0xc0>
				cputchar(c);
  800a18:	83 ec 0c             	sub    $0xc,%esp
  800a1b:	ff 75 ec             	pushl  -0x14(%ebp)
  800a1e:	e8 5d 0f 00 00       	call   801980 <cputchar>
  800a23:	83 c4 10             	add    $0x10,%esp

			i--;
  800a26:	ff 4d f4             	decl   -0xc(%ebp)
  800a29:	eb 31                	jmp    800a5c <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a2b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a2f:	74 0a                	je     800a3b <readline+0xd5>
  800a31:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a35:	0f 85 61 ff ff ff    	jne    80099c <readline+0x36>
			if (echoing)
  800a3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a3f:	74 0e                	je     800a4f <readline+0xe9>
				cputchar(c);
  800a41:	83 ec 0c             	sub    $0xc,%esp
  800a44:	ff 75 ec             	pushl  -0x14(%ebp)
  800a47:	e8 34 0f 00 00       	call   801980 <cputchar>
  800a4c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a55:	01 d0                	add    %edx,%eax
  800a57:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a5a:	eb 06                	jmp    800a62 <readline+0xfc>
		}
	}
  800a5c:	e9 3b ff ff ff       	jmp    80099c <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a61:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a62:	c9                   	leave  
  800a63:	c3                   	ret    

00800a64 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a6a:	e8 fc 09 00 00       	call   80146b <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a73:	74 13                	je     800a88 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	ff 75 08             	pushl  0x8(%ebp)
  800a7b:	68 30 21 80 00       	push   $0x802130
  800a80:	e8 5f f8 ff ff       	call   8002e4 <cprintf>
  800a85:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a8f:	83 ec 0c             	sub    $0xc,%esp
  800a92:	6a 00                	push   $0x0
  800a94:	e8 7d 0f 00 00       	call   801a16 <iscons>
  800a99:	83 c4 10             	add    $0x10,%esp
  800a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a9f:	e8 24 0f 00 00       	call   8019c8 <getchar>
  800aa4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800aa7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aab:	79 23                	jns    800ad0 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800aad:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ab1:	74 13                	je     800ac6 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 ec             	pushl  -0x14(%ebp)
  800ab9:	68 33 21 80 00       	push   $0x802133
  800abe:	e8 21 f8 ff ff       	call   8002e4 <cprintf>
  800ac3:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800ac6:	e8 ba 09 00 00       	call   801485 <sys_enable_interrupt>
			return;
  800acb:	e9 9a 00 00 00       	jmp    800b6a <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ad0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ad4:	7e 34                	jle    800b0a <atomic_readline+0xa6>
  800ad6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800add:	7f 2b                	jg     800b0a <atomic_readline+0xa6>
			if (echoing)
  800adf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ae3:	74 0e                	je     800af3 <atomic_readline+0x8f>
				cputchar(c);
  800ae5:	83 ec 0c             	sub    $0xc,%esp
  800ae8:	ff 75 ec             	pushl  -0x14(%ebp)
  800aeb:	e8 90 0e 00 00       	call   801980 <cputchar>
  800af0:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800af6:	8d 50 01             	lea    0x1(%eax),%edx
  800af9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800afc:	89 c2                	mov    %eax,%edx
  800afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b01:	01 d0                	add    %edx,%eax
  800b03:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b06:	88 10                	mov    %dl,(%eax)
  800b08:	eb 5b                	jmp    800b65 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800b0a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b0e:	75 1f                	jne    800b2f <atomic_readline+0xcb>
  800b10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b14:	7e 19                	jle    800b2f <atomic_readline+0xcb>
			if (echoing)
  800b16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b1a:	74 0e                	je     800b2a <atomic_readline+0xc6>
				cputchar(c);
  800b1c:	83 ec 0c             	sub    $0xc,%esp
  800b1f:	ff 75 ec             	pushl  -0x14(%ebp)
  800b22:	e8 59 0e 00 00       	call   801980 <cputchar>
  800b27:	83 c4 10             	add    $0x10,%esp
			i--;
  800b2a:	ff 4d f4             	decl   -0xc(%ebp)
  800b2d:	eb 36                	jmp    800b65 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b2f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b33:	74 0a                	je     800b3f <atomic_readline+0xdb>
  800b35:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b39:	0f 85 60 ff ff ff    	jne    800a9f <atomic_readline+0x3b>
			if (echoing)
  800b3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b43:	74 0e                	je     800b53 <atomic_readline+0xef>
				cputchar(c);
  800b45:	83 ec 0c             	sub    $0xc,%esp
  800b48:	ff 75 ec             	pushl  -0x14(%ebp)
  800b4b:	e8 30 0e 00 00       	call   801980 <cputchar>
  800b50:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	01 d0                	add    %edx,%eax
  800b5b:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b5e:	e8 22 09 00 00       	call   801485 <sys_enable_interrupt>
			return;
  800b63:	eb 05                	jmp    800b6a <atomic_readline+0x106>
		}
	}
  800b65:	e9 35 ff ff ff       	jmp    800a9f <atomic_readline+0x3b>
}
  800b6a:	c9                   	leave  
  800b6b:	c3                   	ret    

00800b6c <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b79:	eb 06                	jmp    800b81 <strlen+0x15>
		n++;
  800b7b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b7e:	ff 45 08             	incl   0x8(%ebp)
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	84 c0                	test   %al,%al
  800b88:	75 f1                	jne    800b7b <strlen+0xf>
		n++;
	return n;
  800b8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b8d:	c9                   	leave  
  800b8e:	c3                   	ret    

00800b8f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b9c:	eb 09                	jmp    800ba7 <strnlen+0x18>
		n++;
  800b9e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ba1:	ff 45 08             	incl   0x8(%ebp)
  800ba4:	ff 4d 0c             	decl   0xc(%ebp)
  800ba7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bab:	74 09                	je     800bb6 <strnlen+0x27>
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8a 00                	mov    (%eax),%al
  800bb2:	84 c0                	test   %al,%al
  800bb4:	75 e8                	jne    800b9e <strnlen+0xf>
		n++;
	return n;
  800bb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb9:	c9                   	leave  
  800bba:	c3                   	ret    

00800bbb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bc7:	90                   	nop
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	8d 50 01             	lea    0x1(%eax),%edx
  800bce:	89 55 08             	mov    %edx,0x8(%ebp)
  800bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bda:	8a 12                	mov    (%edx),%dl
  800bdc:	88 10                	mov    %dl,(%eax)
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 e4                	jne    800bc8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bf5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bfc:	eb 1f                	jmp    800c1d <strncpy+0x34>
		*dst++ = *src;
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8d 50 01             	lea    0x1(%eax),%edx
  800c04:	89 55 08             	mov    %edx,0x8(%ebp)
  800c07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0a:	8a 12                	mov    (%edx),%dl
  800c0c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	84 c0                	test   %al,%al
  800c15:	74 03                	je     800c1a <strncpy+0x31>
			src++;
  800c17:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c1a:	ff 45 fc             	incl   -0x4(%ebp)
  800c1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c20:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c23:	72 d9                	jb     800bfe <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c25:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c3a:	74 30                	je     800c6c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c3c:	eb 16                	jmp    800c54 <strlcpy+0x2a>
			*dst++ = *src++;
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	8d 50 01             	lea    0x1(%eax),%edx
  800c44:	89 55 08             	mov    %edx,0x8(%ebp)
  800c47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c4d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c50:	8a 12                	mov    (%edx),%dl
  800c52:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c54:	ff 4d 10             	decl   0x10(%ebp)
  800c57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5b:	74 09                	je     800c66 <strlcpy+0x3c>
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	8a 00                	mov    (%eax),%al
  800c62:	84 c0                	test   %al,%al
  800c64:	75 d8                	jne    800c3e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c72:	29 c2                	sub    %eax,%edx
  800c74:	89 d0                	mov    %edx,%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c7b:	eb 06                	jmp    800c83 <strcmp+0xb>
		p++, q++;
  800c7d:	ff 45 08             	incl   0x8(%ebp)
  800c80:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	84 c0                	test   %al,%al
  800c8a:	74 0e                	je     800c9a <strcmp+0x22>
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	8a 10                	mov    (%eax),%dl
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	8a 00                	mov    (%eax),%al
  800c96:	38 c2                	cmp    %al,%dl
  800c98:	74 e3                	je     800c7d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	8a 00                	mov    (%eax),%al
  800c9f:	0f b6 d0             	movzbl %al,%edx
  800ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca5:	8a 00                	mov    (%eax),%al
  800ca7:	0f b6 c0             	movzbl %al,%eax
  800caa:	29 c2                	sub    %eax,%edx
  800cac:	89 d0                	mov    %edx,%eax
}
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cb3:	eb 09                	jmp    800cbe <strncmp+0xe>
		n--, p++, q++;
  800cb5:	ff 4d 10             	decl   0x10(%ebp)
  800cb8:	ff 45 08             	incl   0x8(%ebp)
  800cbb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc2:	74 17                	je     800cdb <strncmp+0x2b>
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	84 c0                	test   %al,%al
  800ccb:	74 0e                	je     800cdb <strncmp+0x2b>
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 10                	mov    (%eax),%dl
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	38 c2                	cmp    %al,%dl
  800cd9:	74 da                	je     800cb5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdf:	75 07                	jne    800ce8 <strncmp+0x38>
		return 0;
  800ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce6:	eb 14                	jmp    800cfc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	0f b6 d0             	movzbl %al,%edx
  800cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf3:	8a 00                	mov    (%eax),%al
  800cf5:	0f b6 c0             	movzbl %al,%eax
  800cf8:	29 c2                	sub    %eax,%edx
  800cfa:	89 d0                	mov    %edx,%eax
}
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 04             	sub    $0x4,%esp
  800d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d07:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d0a:	eb 12                	jmp    800d1e <strchr+0x20>
		if (*s == c)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d14:	75 05                	jne    800d1b <strchr+0x1d>
			return (char *) s;
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	eb 11                	jmp    800d2c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d1b:	ff 45 08             	incl   0x8(%ebp)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	75 e5                	jne    800d0c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d2c:	c9                   	leave  
  800d2d:	c3                   	ret    

00800d2e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	83 ec 04             	sub    $0x4,%esp
  800d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d37:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d3a:	eb 0d                	jmp    800d49 <strfind+0x1b>
		if (*s == c)
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d44:	74 0e                	je     800d54 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d46:	ff 45 08             	incl   0x8(%ebp)
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	84 c0                	test   %al,%al
  800d50:	75 ea                	jne    800d3c <strfind+0xe>
  800d52:	eb 01                	jmp    800d55 <strfind+0x27>
		if (*s == c)
			break;
  800d54:	90                   	nop
	return (char *) s;
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d58:	c9                   	leave  
  800d59:	c3                   	ret    

00800d5a <memset>:

int i=0;
void *
memset(void *v, int c, uint32 n)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	83 ec 10             	sub    $0x10,%esp


	i++;
  800d60:	a1 28 30 80 00       	mov    0x803028,%eax
  800d65:	40                   	inc    %eax
  800d66:	a3 28 30 80 00       	mov    %eax,0x803028

	char *p;
	int m;

	p = v;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d71:	8b 45 10             	mov    0x10(%ebp),%eax
  800d74:	89 45 f8             	mov    %eax,-0x8(%ebp)


	while (--m >= 0){
  800d77:	eb 0e                	jmp    800d87 <memset+0x2d>

		*p++ = c;
  800d79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7c:	8d 50 01             	lea    0x1(%eax),%edx
  800d7f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d85:	88 10                	mov    %dl,(%eax)

	p = v;
	m = n;


	while (--m >= 0){
  800d87:	ff 4d f8             	decl   -0x8(%ebp)
  800d8a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d8e:	79 e9                	jns    800d79 <memset+0x1f>

		*p++ = c;
	}

	return v;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800da7:	eb 16                	jmp    800dbf <memcpy+0x2a>
		*d++ = *s++;
  800da9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dac:	8d 50 01             	lea    0x1(%eax),%edx
  800daf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800db2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dbb:	8a 12                	mov    (%edx),%dl
  800dbd:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc5:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	75 dd                	jne    800da9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dcf:	c9                   	leave  
  800dd0:	c3                   	ret    

00800dd1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800de3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800de9:	73 50                	jae    800e3b <memmove+0x6a>
  800deb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	01 d0                	add    %edx,%eax
  800df3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800df6:	76 43                	jbe    800e3b <memmove+0x6a>
		s += n;
  800df8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800e01:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e04:	eb 10                	jmp    800e16 <memmove+0x45>
			*--d = *--s;
  800e06:	ff 4d f8             	decl   -0x8(%ebp)
  800e09:	ff 4d fc             	decl   -0x4(%ebp)
  800e0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0f:	8a 10                	mov    (%eax),%dl
  800e11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e14:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e16:	8b 45 10             	mov    0x10(%ebp),%eax
  800e19:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1f:	85 c0                	test   %eax,%eax
  800e21:	75 e3                	jne    800e06 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e23:	eb 23                	jmp    800e48 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e28:	8d 50 01             	lea    0x1(%eax),%edx
  800e2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e37:	8a 12                	mov    (%edx),%dl
  800e39:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e41:	89 55 10             	mov    %edx,0x10(%ebp)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	75 dd                	jne    800e25 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e5f:	eb 2a                	jmp    800e8b <memcmp+0x3e>
		if (*s1 != *s2)
  800e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e64:	8a 10                	mov    (%eax),%dl
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	38 c2                	cmp    %al,%dl
  800e6d:	74 16                	je     800e85 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e72:	8a 00                	mov    (%eax),%al
  800e74:	0f b6 d0             	movzbl %al,%edx
  800e77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	0f b6 c0             	movzbl %al,%eax
  800e7f:	29 c2                	sub    %eax,%edx
  800e81:	89 d0                	mov    %edx,%eax
  800e83:	eb 18                	jmp    800e9d <memcmp+0x50>
		s1++, s2++;
  800e85:	ff 45 fc             	incl   -0x4(%ebp)
  800e88:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e91:	89 55 10             	mov    %edx,0x10(%ebp)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	75 c9                	jne    800e61 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e9d:	c9                   	leave  
  800e9e:	c3                   	ret    

00800e9f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eab:	01 d0                	add    %edx,%eax
  800ead:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eb0:	eb 15                	jmp    800ec7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	0f b6 d0             	movzbl %al,%edx
  800eba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebd:	0f b6 c0             	movzbl %al,%eax
  800ec0:	39 c2                	cmp    %eax,%edx
  800ec2:	74 0d                	je     800ed1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ec4:	ff 45 08             	incl   0x8(%ebp)
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ecd:	72 e3                	jb     800eb2 <memfind+0x13>
  800ecf:	eb 01                	jmp    800ed2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ed1:	90                   	nop
	return (void *) s;
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed5:	c9                   	leave  
  800ed6:	c3                   	ret    

00800ed7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800edd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ee4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eeb:	eb 03                	jmp    800ef0 <strtol+0x19>
		s++;
  800eed:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	3c 20                	cmp    $0x20,%al
  800ef7:	74 f4                	je     800eed <strtol+0x16>
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	3c 09                	cmp    $0x9,%al
  800f00:	74 eb                	je     800eed <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	3c 2b                	cmp    $0x2b,%al
  800f09:	75 05                	jne    800f10 <strtol+0x39>
		s++;
  800f0b:	ff 45 08             	incl   0x8(%ebp)
  800f0e:	eb 13                	jmp    800f23 <strtol+0x4c>
	else if (*s == '-')
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	3c 2d                	cmp    $0x2d,%al
  800f17:	75 0a                	jne    800f23 <strtol+0x4c>
		s++, neg = 1;
  800f19:	ff 45 08             	incl   0x8(%ebp)
  800f1c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f27:	74 06                	je     800f2f <strtol+0x58>
  800f29:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f2d:	75 20                	jne    800f4f <strtol+0x78>
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	3c 30                	cmp    $0x30,%al
  800f36:	75 17                	jne    800f4f <strtol+0x78>
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	40                   	inc    %eax
  800f3c:	8a 00                	mov    (%eax),%al
  800f3e:	3c 78                	cmp    $0x78,%al
  800f40:	75 0d                	jne    800f4f <strtol+0x78>
		s += 2, base = 16;
  800f42:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f46:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f4d:	eb 28                	jmp    800f77 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f53:	75 15                	jne    800f6a <strtol+0x93>
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	3c 30                	cmp    $0x30,%al
  800f5c:	75 0c                	jne    800f6a <strtol+0x93>
		s++, base = 8;
  800f5e:	ff 45 08             	incl   0x8(%ebp)
  800f61:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f68:	eb 0d                	jmp    800f77 <strtol+0xa0>
	else if (base == 0)
  800f6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6e:	75 07                	jne    800f77 <strtol+0xa0>
		base = 10;
  800f70:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 2f                	cmp    $0x2f,%al
  800f7e:	7e 19                	jle    800f99 <strtol+0xc2>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 39                	cmp    $0x39,%al
  800f87:	7f 10                	jg     800f99 <strtol+0xc2>
			dig = *s - '0';
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	0f be c0             	movsbl %al,%eax
  800f91:	83 e8 30             	sub    $0x30,%eax
  800f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f97:	eb 42                	jmp    800fdb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 60                	cmp    $0x60,%al
  800fa0:	7e 19                	jle    800fbb <strtol+0xe4>
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	3c 7a                	cmp    $0x7a,%al
  800fa9:	7f 10                	jg     800fbb <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	0f be c0             	movsbl %al,%eax
  800fb3:	83 e8 57             	sub    $0x57,%eax
  800fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb9:	eb 20                	jmp    800fdb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	3c 40                	cmp    $0x40,%al
  800fc2:	7e 39                	jle    800ffd <strtol+0x126>
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3c 5a                	cmp    $0x5a,%al
  800fcb:	7f 30                	jg     800ffd <strtol+0x126>
			dig = *s - 'A' + 10;
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	0f be c0             	movsbl %al,%eax
  800fd5:	83 e8 37             	sub    $0x37,%eax
  800fd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fde:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fe1:	7d 19                	jge    800ffc <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fe3:	ff 45 08             	incl   0x8(%ebp)
  800fe6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fed:	89 c2                	mov    %eax,%edx
  800fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff2:	01 d0                	add    %edx,%eax
  800ff4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ff7:	e9 7b ff ff ff       	jmp    800f77 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ffc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ffd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801001:	74 08                	je     80100b <strtol+0x134>
		*endptr = (char *) s;
  801003:	8b 45 0c             	mov    0xc(%ebp),%eax
  801006:	8b 55 08             	mov    0x8(%ebp),%edx
  801009:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80100b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80100f:	74 07                	je     801018 <strtol+0x141>
  801011:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801014:	f7 d8                	neg    %eax
  801016:	eb 03                	jmp    80101b <strtol+0x144>
  801018:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80101b:	c9                   	leave  
  80101c:	c3                   	ret    

0080101d <ltostr>:

void
ltostr(long value, char *str)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801023:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80102a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801031:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801035:	79 13                	jns    80104a <ltostr+0x2d>
	{
		neg = 1;
  801037:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80103e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801041:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801044:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801047:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801052:	99                   	cltd   
  801053:	f7 f9                	idiv   %ecx
  801055:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801058:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105b:	8d 50 01             	lea    0x1(%eax),%edx
  80105e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801061:	89 c2                	mov    %eax,%edx
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	01 d0                	add    %edx,%eax
  801068:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80106b:	83 c2 30             	add    $0x30,%edx
  80106e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801070:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801073:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801078:	f7 e9                	imul   %ecx
  80107a:	c1 fa 02             	sar    $0x2,%edx
  80107d:	89 c8                	mov    %ecx,%eax
  80107f:	c1 f8 1f             	sar    $0x1f,%eax
  801082:	29 c2                	sub    %eax,%edx
  801084:	89 d0                	mov    %edx,%eax
  801086:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801089:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801091:	f7 e9                	imul   %ecx
  801093:	c1 fa 02             	sar    $0x2,%edx
  801096:	89 c8                	mov    %ecx,%eax
  801098:	c1 f8 1f             	sar    $0x1f,%eax
  80109b:	29 c2                	sub    %eax,%edx
  80109d:	89 d0                	mov    %edx,%eax
  80109f:	c1 e0 02             	shl    $0x2,%eax
  8010a2:	01 d0                	add    %edx,%eax
  8010a4:	01 c0                	add    %eax,%eax
  8010a6:	29 c1                	sub    %eax,%ecx
  8010a8:	89 ca                	mov    %ecx,%edx
  8010aa:	85 d2                	test   %edx,%edx
  8010ac:	75 9c                	jne    80104a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b8:	48                   	dec    %eax
  8010b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010c0:	74 3d                	je     8010ff <ltostr+0xe2>
		start = 1 ;
  8010c2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010c9:	eb 34                	jmp    8010ff <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	01 d0                	add    %edx,%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010de:	01 c2                	add    %eax,%edx
  8010e0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e6:	01 c8                	add    %ecx,%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f2:	01 c2                	add    %eax,%edx
  8010f4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010f7:	88 02                	mov    %al,(%edx)
		start++ ;
  8010f9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010fc:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801102:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801105:	7c c4                	jl     8010cb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801107:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	01 d0                	add    %edx,%eax
  80110f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801112:	90                   	nop
  801113:	c9                   	leave  
  801114:	c3                   	ret    

00801115 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80111b:	ff 75 08             	pushl  0x8(%ebp)
  80111e:	e8 49 fa ff ff       	call   800b6c <strlen>
  801123:	83 c4 04             	add    $0x4,%esp
  801126:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801129:	ff 75 0c             	pushl  0xc(%ebp)
  80112c:	e8 3b fa ff ff       	call   800b6c <strlen>
  801131:	83 c4 04             	add    $0x4,%esp
  801134:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801137:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80113e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801145:	eb 17                	jmp    80115e <strcconcat+0x49>
		final[s] = str1[s] ;
  801147:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114a:	8b 45 10             	mov    0x10(%ebp),%eax
  80114d:	01 c2                	add    %eax,%edx
  80114f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	01 c8                	add    %ecx,%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80115b:	ff 45 fc             	incl   -0x4(%ebp)
  80115e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801161:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801164:	7c e1                	jl     801147 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801166:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80116d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801174:	eb 1f                	jmp    801195 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801176:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801179:	8d 50 01             	lea    0x1(%eax),%edx
  80117c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80117f:	89 c2                	mov    %eax,%edx
  801181:	8b 45 10             	mov    0x10(%ebp),%eax
  801184:	01 c2                	add    %eax,%edx
  801186:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118c:	01 c8                	add    %ecx,%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801192:	ff 45 f8             	incl   -0x8(%ebp)
  801195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801198:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80119b:	7c d9                	jl     801176 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80119d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a3:	01 d0                	add    %edx,%eax
  8011a5:	c6 00 00             	movb   $0x0,(%eax)
}
  8011a8:	90                   	nop
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ba:	8b 00                	mov    (%eax),%eax
  8011bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c6:	01 d0                	add    %edx,%eax
  8011c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ce:	eb 0c                	jmp    8011dc <strsplit+0x31>
			*string++ = 0;
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8d 50 01             	lea    0x1(%eax),%edx
  8011d6:	89 55 08             	mov    %edx,0x8(%ebp)
  8011d9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	8a 00                	mov    (%eax),%al
  8011e1:	84 c0                	test   %al,%al
  8011e3:	74 18                	je     8011fd <strsplit+0x52>
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	0f be c0             	movsbl %al,%eax
  8011ed:	50                   	push   %eax
  8011ee:	ff 75 0c             	pushl  0xc(%ebp)
  8011f1:	e8 08 fb ff ff       	call   800cfe <strchr>
  8011f6:	83 c4 08             	add    $0x8,%esp
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	75 d3                	jne    8011d0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	84 c0                	test   %al,%al
  801204:	74 5a                	je     801260 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801206:	8b 45 14             	mov    0x14(%ebp),%eax
  801209:	8b 00                	mov    (%eax),%eax
  80120b:	83 f8 0f             	cmp    $0xf,%eax
  80120e:	75 07                	jne    801217 <strsplit+0x6c>
		{
			return 0;
  801210:	b8 00 00 00 00       	mov    $0x0,%eax
  801215:	eb 66                	jmp    80127d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801217:	8b 45 14             	mov    0x14(%ebp),%eax
  80121a:	8b 00                	mov    (%eax),%eax
  80121c:	8d 48 01             	lea    0x1(%eax),%ecx
  80121f:	8b 55 14             	mov    0x14(%ebp),%edx
  801222:	89 0a                	mov    %ecx,(%edx)
  801224:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80122b:	8b 45 10             	mov    0x10(%ebp),%eax
  80122e:	01 c2                	add    %eax,%edx
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801235:	eb 03                	jmp    80123a <strsplit+0x8f>
			string++;
  801237:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	84 c0                	test   %al,%al
  801241:	74 8b                	je     8011ce <strsplit+0x23>
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	0f be c0             	movsbl %al,%eax
  80124b:	50                   	push   %eax
  80124c:	ff 75 0c             	pushl  0xc(%ebp)
  80124f:	e8 aa fa ff ff       	call   800cfe <strchr>
  801254:	83 c4 08             	add    $0x8,%esp
  801257:	85 c0                	test   %eax,%eax
  801259:	74 dc                	je     801237 <strsplit+0x8c>
			string++;
	}
  80125b:	e9 6e ff ff ff       	jmp    8011ce <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801260:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801261:	8b 45 14             	mov    0x14(%ebp),%eax
  801264:	8b 00                	mov    (%eax),%eax
  801266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126d:	8b 45 10             	mov    0x10(%ebp),%eax
  801270:	01 d0                	add    %edx,%eax
  801272:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801278:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  801285:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801289:	74 06                	je     801291 <str2lower+0x12>
  80128b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128f:	75 07                	jne    801298 <str2lower+0x19>
		return NULL;
  801291:	b8 00 00 00 00       	mov    $0x0,%eax
  801296:	eb 4d                	jmp    8012e5 <str2lower+0x66>
	}
	char *ref=dst;
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  80129e:	eb 33                	jmp    8012d3 <str2lower+0x54>
			if(*src>=65&&*src<=90){
  8012a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	3c 40                	cmp    $0x40,%al
  8012a7:	7e 1a                	jle    8012c3 <str2lower+0x44>
  8012a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ac:	8a 00                	mov    (%eax),%al
  8012ae:	3c 5a                	cmp    $0x5a,%al
  8012b0:	7f 11                	jg     8012c3 <str2lower+0x44>
				*dst=*src+32;
  8012b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b5:	8a 00                	mov    (%eax),%al
  8012b7:	83 c0 20             	add    $0x20,%eax
  8012ba:	88 c2                	mov    %al,%dl
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	88 10                	mov    %dl,(%eax)
  8012c1:	eb 0a                	jmp    8012cd <str2lower+0x4e>
			}
			else{
				*dst=*src;
  8012c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c6:	8a 10                	mov    (%eax),%dl
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	88 10                	mov    %dl,(%eax)
			}
			src++;
  8012cd:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  8012d0:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	84 c0                	test   %al,%al
  8012da:	75 c4                	jne    8012a0 <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  8012e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	57                   	push   %edi
  8012eb:	56                   	push   %esi
  8012ec:	53                   	push   %ebx
  8012ed:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012fc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012ff:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801302:	cd 30                	int    $0x30
  801304:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801307:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80130a:	83 c4 10             	add    $0x10,%esp
  80130d:	5b                   	pop    %ebx
  80130e:	5e                   	pop    %esi
  80130f:	5f                   	pop    %edi
  801310:	5d                   	pop    %ebp
  801311:	c3                   	ret    

00801312 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	83 ec 04             	sub    $0x4,%esp
  801318:	8b 45 10             	mov    0x10(%ebp),%eax
  80131b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80131e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	52                   	push   %edx
  80132a:	ff 75 0c             	pushl  0xc(%ebp)
  80132d:	50                   	push   %eax
  80132e:	6a 00                	push   $0x0
  801330:	e8 b2 ff ff ff       	call   8012e7 <syscall>
  801335:	83 c4 18             	add    $0x18,%esp
}
  801338:	90                   	nop
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <sys_cgetc>:

int
sys_cgetc(void)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 01                	push   $0x1
  80134a:	e8 98 ff ff ff       	call   8012e7 <syscall>
  80134f:	83 c4 18             	add    $0x18,%esp
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	52                   	push   %edx
  801364:	50                   	push   %eax
  801365:	6a 05                	push   $0x5
  801367:	e8 7b ff ff ff       	call   8012e7 <syscall>
  80136c:	83 c4 18             	add    $0x18,%esp
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	56                   	push   %esi
  801375:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801376:	8b 75 18             	mov    0x18(%ebp),%esi
  801379:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80137c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80137f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	56                   	push   %esi
  801386:	53                   	push   %ebx
  801387:	51                   	push   %ecx
  801388:	52                   	push   %edx
  801389:	50                   	push   %eax
  80138a:	6a 06                	push   $0x6
  80138c:	e8 56 ff ff ff       	call   8012e7 <syscall>
  801391:	83 c4 18             	add    $0x18,%esp
}
  801394:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801397:	5b                   	pop    %ebx
  801398:	5e                   	pop    %esi
  801399:	5d                   	pop    %ebp
  80139a:	c3                   	ret    

0080139b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80139e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	52                   	push   %edx
  8013ab:	50                   	push   %eax
  8013ac:	6a 07                	push   $0x7
  8013ae:	e8 34 ff ff ff       	call   8012e7 <syscall>
  8013b3:	83 c4 18             	add    $0x18,%esp
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	ff 75 0c             	pushl  0xc(%ebp)
  8013c4:	ff 75 08             	pushl  0x8(%ebp)
  8013c7:	6a 08                	push   $0x8
  8013c9:	e8 19 ff ff ff       	call   8012e7 <syscall>
  8013ce:	83 c4 18             	add    $0x18,%esp
}
  8013d1:	c9                   	leave  
  8013d2:	c3                   	ret    

008013d3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 09                	push   $0x9
  8013e2:	e8 00 ff ff ff       	call   8012e7 <syscall>
  8013e7:	83 c4 18             	add    $0x18,%esp
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 0a                	push   $0xa
  8013fb:	e8 e7 fe ff ff       	call   8012e7 <syscall>
  801400:	83 c4 18             	add    $0x18,%esp
}
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 0b                	push   $0xb
  801414:	e8 ce fe ff ff       	call   8012e7 <syscall>
  801419:	83 c4 18             	add    $0x18,%esp
}
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 0c                	push   $0xc
  80142d:	e8 b5 fe ff ff       	call   8012e7 <syscall>
  801432:	83 c4 18             	add    $0x18,%esp
}
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	ff 75 08             	pushl  0x8(%ebp)
  801445:	6a 0d                	push   $0xd
  801447:	e8 9b fe ff ff       	call   8012e7 <syscall>
  80144c:	83 c4 18             	add    $0x18,%esp
}
  80144f:	c9                   	leave  
  801450:	c3                   	ret    

00801451 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 0e                	push   $0xe
  801460:	e8 82 fe ff ff       	call   8012e7 <syscall>
  801465:	83 c4 18             	add    $0x18,%esp
}
  801468:	90                   	nop
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 11                	push   $0x11
  80147a:	e8 68 fe ff ff       	call   8012e7 <syscall>
  80147f:	83 c4 18             	add    $0x18,%esp
}
  801482:	90                   	nop
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 12                	push   $0x12
  801494:	e8 4e fe ff ff       	call   8012e7 <syscall>
  801499:	83 c4 18             	add    $0x18,%esp
}
  80149c:	90                   	nop
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <sys_cputc>:


void
sys_cputc(const char c)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	83 ec 04             	sub    $0x4,%esp
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014ab:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	50                   	push   %eax
  8014b8:	6a 13                	push   $0x13
  8014ba:	e8 28 fe ff ff       	call   8012e7 <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
}
  8014c2:	90                   	nop
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 14                	push   $0x14
  8014d4:	e8 0e fe ff ff       	call   8012e7 <syscall>
  8014d9:	83 c4 18             	add    $0x18,%esp
}
  8014dc:	90                   	nop
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ee:	50                   	push   %eax
  8014ef:	6a 15                	push   $0x15
  8014f1:	e8 f1 fd ff ff       	call   8012e7 <syscall>
  8014f6:	83 c4 18             	add    $0x18,%esp
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	52                   	push   %edx
  80150b:	50                   	push   %eax
  80150c:	6a 18                	push   $0x18
  80150e:	e8 d4 fd ff ff       	call   8012e7 <syscall>
  801513:	83 c4 18             	add    $0x18,%esp
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80151b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	52                   	push   %edx
  801528:	50                   	push   %eax
  801529:	6a 16                	push   $0x16
  80152b:	e8 b7 fd ff ff       	call   8012e7 <syscall>
  801530:	83 c4 18             	add    $0x18,%esp
}
  801533:	90                   	nop
  801534:	c9                   	leave  
  801535:	c3                   	ret    

00801536 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	52                   	push   %edx
  801546:	50                   	push   %eax
  801547:	6a 17                	push   $0x17
  801549:	e8 99 fd ff ff       	call   8012e7 <syscall>
  80154e:	83 c4 18             	add    $0x18,%esp
}
  801551:	90                   	nop
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	83 ec 04             	sub    $0x4,%esp
  80155a:	8b 45 10             	mov    0x10(%ebp),%eax
  80155d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801560:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801563:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	6a 00                	push   $0x0
  80156c:	51                   	push   %ecx
  80156d:	52                   	push   %edx
  80156e:	ff 75 0c             	pushl  0xc(%ebp)
  801571:	50                   	push   %eax
  801572:	6a 19                	push   $0x19
  801574:	e8 6e fd ff ff       	call   8012e7 <syscall>
  801579:	83 c4 18             	add    $0x18,%esp
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801581:	8b 55 0c             	mov    0xc(%ebp),%edx
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	52                   	push   %edx
  80158e:	50                   	push   %eax
  80158f:	6a 1a                	push   $0x1a
  801591:	e8 51 fd ff ff       	call   8012e7 <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80159e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	51                   	push   %ecx
  8015ac:	52                   	push   %edx
  8015ad:	50                   	push   %eax
  8015ae:	6a 1b                	push   $0x1b
  8015b0:	e8 32 fd ff ff       	call   8012e7 <syscall>
  8015b5:	83 c4 18             	add    $0x18,%esp
}
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	52                   	push   %edx
  8015ca:	50                   	push   %eax
  8015cb:	6a 1c                	push   $0x1c
  8015cd:	e8 15 fd ff ff       	call   8012e7 <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 1d                	push   $0x1d
  8015e6:	e8 fc fc ff ff       	call   8012e7 <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	6a 00                	push   $0x0
  8015f8:	ff 75 14             	pushl  0x14(%ebp)
  8015fb:	ff 75 10             	pushl  0x10(%ebp)
  8015fe:	ff 75 0c             	pushl  0xc(%ebp)
  801601:	50                   	push   %eax
  801602:	6a 1e                	push   $0x1e
  801604:	e8 de fc ff ff       	call   8012e7 <syscall>
  801609:	83 c4 18             	add    $0x18,%esp
}
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	50                   	push   %eax
  80161d:	6a 1f                	push   $0x1f
  80161f:	e8 c3 fc ff ff       	call   8012e7 <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
}
  801627:	90                   	nop
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	50                   	push   %eax
  801639:	6a 20                	push   $0x20
  80163b:	e8 a7 fc ff ff       	call   8012e7 <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 02                	push   $0x2
  801654:	e8 8e fc ff ff       	call   8012e7 <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 03                	push   $0x3
  80166d:	e8 75 fc ff ff       	call   8012e7 <syscall>
  801672:	83 c4 18             	add    $0x18,%esp
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 04                	push   $0x4
  801686:	e8 5c fc ff ff       	call   8012e7 <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_exit_env>:


void sys_exit_env(void)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 21                	push   $0x21
  80169f:	e8 43 fc ff ff       	call   8012e7 <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
}
  8016a7:	90                   	nop
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016b0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016b3:	8d 50 04             	lea    0x4(%eax),%edx
  8016b6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	52                   	push   %edx
  8016c0:	50                   	push   %eax
  8016c1:	6a 22                	push   $0x22
  8016c3:	e8 1f fc ff ff       	call   8012e7 <syscall>
  8016c8:	83 c4 18             	add    $0x18,%esp
	return result;
  8016cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d4:	89 01                	mov    %eax,(%ecx)
  8016d6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	c9                   	leave  
  8016dd:	c2 04 00             	ret    $0x4

008016e0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	ff 75 10             	pushl  0x10(%ebp)
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	ff 75 08             	pushl  0x8(%ebp)
  8016f0:	6a 10                	push   $0x10
  8016f2:	e8 f0 fb ff ff       	call   8012e7 <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8016fa:	90                   	nop
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_rcr2>:
uint32 sys_rcr2()
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 23                	push   $0x23
  80170c:	e8 d6 fb ff ff       	call   8012e7 <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 04             	sub    $0x4,%esp
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801722:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	50                   	push   %eax
  80172f:	6a 24                	push   $0x24
  801731:	e8 b1 fb ff ff       	call   8012e7 <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
	return ;
  801739:	90                   	nop
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <rsttst>:
void rsttst()
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 26                	push   $0x26
  80174b:	e8 97 fb ff ff       	call   8012e7 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
	return ;
  801753:	90                   	nop
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 04             	sub    $0x4,%esp
  80175c:	8b 45 14             	mov    0x14(%ebp),%eax
  80175f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801762:	8b 55 18             	mov    0x18(%ebp),%edx
  801765:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801769:	52                   	push   %edx
  80176a:	50                   	push   %eax
  80176b:	ff 75 10             	pushl  0x10(%ebp)
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	ff 75 08             	pushl  0x8(%ebp)
  801774:	6a 25                	push   $0x25
  801776:	e8 6c fb ff ff       	call   8012e7 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
	return ;
  80177e:	90                   	nop
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <chktst>:
void chktst(uint32 n)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	6a 27                	push   $0x27
  801791:	e8 51 fb ff ff       	call   8012e7 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
	return ;
  801799:	90                   	nop
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <inctst>:

void inctst()
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 28                	push   $0x28
  8017ab:	e8 37 fb ff ff       	call   8012e7 <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b3:	90                   	nop
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <gettst>:
uint32 gettst()
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 29                	push   $0x29
  8017c5:	e8 1d fb ff ff       	call   8012e7 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 2a                	push   $0x2a
  8017e1:	e8 01 fb ff ff       	call   8012e7 <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
  8017e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017ec:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017f0:	75 07                	jne    8017f9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f7:	eb 05                	jmp    8017fe <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 2a                	push   $0x2a
  801812:	e8 d0 fa ff ff       	call   8012e7 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
  80181a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80181d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801821:	75 07                	jne    80182a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801823:	b8 01 00 00 00       	mov    $0x1,%eax
  801828:	eb 05                	jmp    80182f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80182a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 2a                	push   $0x2a
  801843:	e8 9f fa ff ff       	call   8012e7 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
  80184b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80184e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801852:	75 07                	jne    80185b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801854:	b8 01 00 00 00       	mov    $0x1,%eax
  801859:	eb 05                	jmp    801860 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80185b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 2a                	push   $0x2a
  801874:	e8 6e fa ff ff       	call   8012e7 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
  80187c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80187f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801883:	75 07                	jne    80188c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801885:	b8 01 00 00 00       	mov    $0x1,%eax
  80188a:	eb 05                	jmp    801891 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80188c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	ff 75 08             	pushl  0x8(%ebp)
  8018a1:	6a 2b                	push   $0x2b
  8018a3:	e8 3f fa ff ff       	call   8012e7 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ab:	90                   	nop
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	6a 00                	push   $0x0
  8018c0:	53                   	push   %ebx
  8018c1:	51                   	push   %ecx
  8018c2:	52                   	push   %edx
  8018c3:	50                   	push   %eax
  8018c4:	6a 2c                	push   $0x2c
  8018c6:	e8 1c fa ff ff       	call   8012e7 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	52                   	push   %edx
  8018e3:	50                   	push   %eax
  8018e4:	6a 2d                	push   $0x2d
  8018e6:	e8 fc f9 ff ff       	call   8012e7 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018f3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	6a 00                	push   $0x0
  8018fe:	51                   	push   %ecx
  8018ff:	ff 75 10             	pushl  0x10(%ebp)
  801902:	52                   	push   %edx
  801903:	50                   	push   %eax
  801904:	6a 2e                	push   $0x2e
  801906:	e8 dc f9 ff ff       	call   8012e7 <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	ff 75 10             	pushl  0x10(%ebp)
  80191a:	ff 75 0c             	pushl  0xc(%ebp)
  80191d:	ff 75 08             	pushl  0x8(%ebp)
  801920:	6a 0f                	push   $0xf
  801922:	e8 c0 f9 ff ff       	call   8012e7 <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
	return ;
  80192a:	90                   	nop
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	50                   	push   %eax
  80193c:	6a 2f                	push   $0x2f
  80193e:	e8 a4 f9 ff ff       	call   8012e7 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	ff 75 0c             	pushl  0xc(%ebp)
  801954:	ff 75 08             	pushl  0x8(%ebp)
  801957:	6a 30                	push   $0x30
  801959:	e8 89 f9 ff ff       	call   8012e7 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801961:	90                   	nop
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	6a 31                	push   $0x31
  801975:	e8 6d f9 ff ff       	call   8012e7 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  80197d:	90                   	nop
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80198c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801990:	83 ec 0c             	sub    $0xc,%esp
  801993:	50                   	push   %eax
  801994:	e8 06 fb ff ff       	call   80149f <sys_cputc>
  801999:	83 c4 10             	add    $0x10,%esp
}
  80199c:	90                   	nop
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8019a5:	e8 c1 fa ff ff       	call   80146b <sys_disable_interrupt>
	char c = ch;
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019b0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019b4:	83 ec 0c             	sub    $0xc,%esp
  8019b7:	50                   	push   %eax
  8019b8:	e8 e2 fa ff ff       	call   80149f <sys_cputc>
  8019bd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8019c0:	e8 c0 fa ff ff       	call   801485 <sys_enable_interrupt>
}
  8019c5:	90                   	nop
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <getchar>:

int
getchar(void)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8019ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8019d5:	eb 08                	jmp    8019df <getchar+0x17>
	{
		c = sys_cgetc();
  8019d7:	e8 5f f9 ff ff       	call   80133b <sys_cgetc>
  8019dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8019df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019e3:	74 f2                	je     8019d7 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8019e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <atomic_getchar>:

int
atomic_getchar(void)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8019f0:	e8 76 fa ff ff       	call   80146b <sys_disable_interrupt>
	int c=0;
  8019f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8019fc:	eb 08                	jmp    801a06 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8019fe:	e8 38 f9 ff ff       	call   80133b <sys_cgetc>
  801a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801a06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a0a:	74 f2                	je     8019fe <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801a0c:	e8 74 fa ff ff       	call   801485 <sys_enable_interrupt>
	return c;
  801a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <iscons>:

int iscons(int fdnum)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a19:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a1e:	5d                   	pop    %ebp
  801a1f:	c3                   	ret    

00801a20 <__udivdi3>:
  801a20:	55                   	push   %ebp
  801a21:	57                   	push   %edi
  801a22:	56                   	push   %esi
  801a23:	53                   	push   %ebx
  801a24:	83 ec 1c             	sub    $0x1c,%esp
  801a27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a37:	89 ca                	mov    %ecx,%edx
  801a39:	89 f8                	mov    %edi,%eax
  801a3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a3f:	85 f6                	test   %esi,%esi
  801a41:	75 2d                	jne    801a70 <__udivdi3+0x50>
  801a43:	39 cf                	cmp    %ecx,%edi
  801a45:	77 65                	ja     801aac <__udivdi3+0x8c>
  801a47:	89 fd                	mov    %edi,%ebp
  801a49:	85 ff                	test   %edi,%edi
  801a4b:	75 0b                	jne    801a58 <__udivdi3+0x38>
  801a4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a52:	31 d2                	xor    %edx,%edx
  801a54:	f7 f7                	div    %edi
  801a56:	89 c5                	mov    %eax,%ebp
  801a58:	31 d2                	xor    %edx,%edx
  801a5a:	89 c8                	mov    %ecx,%eax
  801a5c:	f7 f5                	div    %ebp
  801a5e:	89 c1                	mov    %eax,%ecx
  801a60:	89 d8                	mov    %ebx,%eax
  801a62:	f7 f5                	div    %ebp
  801a64:	89 cf                	mov    %ecx,%edi
  801a66:	89 fa                	mov    %edi,%edx
  801a68:	83 c4 1c             	add    $0x1c,%esp
  801a6b:	5b                   	pop    %ebx
  801a6c:	5e                   	pop    %esi
  801a6d:	5f                   	pop    %edi
  801a6e:	5d                   	pop    %ebp
  801a6f:	c3                   	ret    
  801a70:	39 ce                	cmp    %ecx,%esi
  801a72:	77 28                	ja     801a9c <__udivdi3+0x7c>
  801a74:	0f bd fe             	bsr    %esi,%edi
  801a77:	83 f7 1f             	xor    $0x1f,%edi
  801a7a:	75 40                	jne    801abc <__udivdi3+0x9c>
  801a7c:	39 ce                	cmp    %ecx,%esi
  801a7e:	72 0a                	jb     801a8a <__udivdi3+0x6a>
  801a80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a84:	0f 87 9e 00 00 00    	ja     801b28 <__udivdi3+0x108>
  801a8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8f:	89 fa                	mov    %edi,%edx
  801a91:	83 c4 1c             	add    $0x1c,%esp
  801a94:	5b                   	pop    %ebx
  801a95:	5e                   	pop    %esi
  801a96:	5f                   	pop    %edi
  801a97:	5d                   	pop    %ebp
  801a98:	c3                   	ret    
  801a99:	8d 76 00             	lea    0x0(%esi),%esi
  801a9c:	31 ff                	xor    %edi,%edi
  801a9e:	31 c0                	xor    %eax,%eax
  801aa0:	89 fa                	mov    %edi,%edx
  801aa2:	83 c4 1c             	add    $0x1c,%esp
  801aa5:	5b                   	pop    %ebx
  801aa6:	5e                   	pop    %esi
  801aa7:	5f                   	pop    %edi
  801aa8:	5d                   	pop    %ebp
  801aa9:	c3                   	ret    
  801aaa:	66 90                	xchg   %ax,%ax
  801aac:	89 d8                	mov    %ebx,%eax
  801aae:	f7 f7                	div    %edi
  801ab0:	31 ff                	xor    %edi,%edi
  801ab2:	89 fa                	mov    %edi,%edx
  801ab4:	83 c4 1c             	add    $0x1c,%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5f                   	pop    %edi
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    
  801abc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ac1:	89 eb                	mov    %ebp,%ebx
  801ac3:	29 fb                	sub    %edi,%ebx
  801ac5:	89 f9                	mov    %edi,%ecx
  801ac7:	d3 e6                	shl    %cl,%esi
  801ac9:	89 c5                	mov    %eax,%ebp
  801acb:	88 d9                	mov    %bl,%cl
  801acd:	d3 ed                	shr    %cl,%ebp
  801acf:	89 e9                	mov    %ebp,%ecx
  801ad1:	09 f1                	or     %esi,%ecx
  801ad3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ad7:	89 f9                	mov    %edi,%ecx
  801ad9:	d3 e0                	shl    %cl,%eax
  801adb:	89 c5                	mov    %eax,%ebp
  801add:	89 d6                	mov    %edx,%esi
  801adf:	88 d9                	mov    %bl,%cl
  801ae1:	d3 ee                	shr    %cl,%esi
  801ae3:	89 f9                	mov    %edi,%ecx
  801ae5:	d3 e2                	shl    %cl,%edx
  801ae7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aeb:	88 d9                	mov    %bl,%cl
  801aed:	d3 e8                	shr    %cl,%eax
  801aef:	09 c2                	or     %eax,%edx
  801af1:	89 d0                	mov    %edx,%eax
  801af3:	89 f2                	mov    %esi,%edx
  801af5:	f7 74 24 0c          	divl   0xc(%esp)
  801af9:	89 d6                	mov    %edx,%esi
  801afb:	89 c3                	mov    %eax,%ebx
  801afd:	f7 e5                	mul    %ebp
  801aff:	39 d6                	cmp    %edx,%esi
  801b01:	72 19                	jb     801b1c <__udivdi3+0xfc>
  801b03:	74 0b                	je     801b10 <__udivdi3+0xf0>
  801b05:	89 d8                	mov    %ebx,%eax
  801b07:	31 ff                	xor    %edi,%edi
  801b09:	e9 58 ff ff ff       	jmp    801a66 <__udivdi3+0x46>
  801b0e:	66 90                	xchg   %ax,%ax
  801b10:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b14:	89 f9                	mov    %edi,%ecx
  801b16:	d3 e2                	shl    %cl,%edx
  801b18:	39 c2                	cmp    %eax,%edx
  801b1a:	73 e9                	jae    801b05 <__udivdi3+0xe5>
  801b1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b1f:	31 ff                	xor    %edi,%edi
  801b21:	e9 40 ff ff ff       	jmp    801a66 <__udivdi3+0x46>
  801b26:	66 90                	xchg   %ax,%ax
  801b28:	31 c0                	xor    %eax,%eax
  801b2a:	e9 37 ff ff ff       	jmp    801a66 <__udivdi3+0x46>
  801b2f:	90                   	nop

00801b30 <__umoddi3>:
  801b30:	55                   	push   %ebp
  801b31:	57                   	push   %edi
  801b32:	56                   	push   %esi
  801b33:	53                   	push   %ebx
  801b34:	83 ec 1c             	sub    $0x1c,%esp
  801b37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b4f:	89 f3                	mov    %esi,%ebx
  801b51:	89 fa                	mov    %edi,%edx
  801b53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b57:	89 34 24             	mov    %esi,(%esp)
  801b5a:	85 c0                	test   %eax,%eax
  801b5c:	75 1a                	jne    801b78 <__umoddi3+0x48>
  801b5e:	39 f7                	cmp    %esi,%edi
  801b60:	0f 86 a2 00 00 00    	jbe    801c08 <__umoddi3+0xd8>
  801b66:	89 c8                	mov    %ecx,%eax
  801b68:	89 f2                	mov    %esi,%edx
  801b6a:	f7 f7                	div    %edi
  801b6c:	89 d0                	mov    %edx,%eax
  801b6e:	31 d2                	xor    %edx,%edx
  801b70:	83 c4 1c             	add    $0x1c,%esp
  801b73:	5b                   	pop    %ebx
  801b74:	5e                   	pop    %esi
  801b75:	5f                   	pop    %edi
  801b76:	5d                   	pop    %ebp
  801b77:	c3                   	ret    
  801b78:	39 f0                	cmp    %esi,%eax
  801b7a:	0f 87 ac 00 00 00    	ja     801c2c <__umoddi3+0xfc>
  801b80:	0f bd e8             	bsr    %eax,%ebp
  801b83:	83 f5 1f             	xor    $0x1f,%ebp
  801b86:	0f 84 ac 00 00 00    	je     801c38 <__umoddi3+0x108>
  801b8c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b91:	29 ef                	sub    %ebp,%edi
  801b93:	89 fe                	mov    %edi,%esi
  801b95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b99:	89 e9                	mov    %ebp,%ecx
  801b9b:	d3 e0                	shl    %cl,%eax
  801b9d:	89 d7                	mov    %edx,%edi
  801b9f:	89 f1                	mov    %esi,%ecx
  801ba1:	d3 ef                	shr    %cl,%edi
  801ba3:	09 c7                	or     %eax,%edi
  801ba5:	89 e9                	mov    %ebp,%ecx
  801ba7:	d3 e2                	shl    %cl,%edx
  801ba9:	89 14 24             	mov    %edx,(%esp)
  801bac:	89 d8                	mov    %ebx,%eax
  801bae:	d3 e0                	shl    %cl,%eax
  801bb0:	89 c2                	mov    %eax,%edx
  801bb2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bb6:	d3 e0                	shl    %cl,%eax
  801bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bc0:	89 f1                	mov    %esi,%ecx
  801bc2:	d3 e8                	shr    %cl,%eax
  801bc4:	09 d0                	or     %edx,%eax
  801bc6:	d3 eb                	shr    %cl,%ebx
  801bc8:	89 da                	mov    %ebx,%edx
  801bca:	f7 f7                	div    %edi
  801bcc:	89 d3                	mov    %edx,%ebx
  801bce:	f7 24 24             	mull   (%esp)
  801bd1:	89 c6                	mov    %eax,%esi
  801bd3:	89 d1                	mov    %edx,%ecx
  801bd5:	39 d3                	cmp    %edx,%ebx
  801bd7:	0f 82 87 00 00 00    	jb     801c64 <__umoddi3+0x134>
  801bdd:	0f 84 91 00 00 00    	je     801c74 <__umoddi3+0x144>
  801be3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801be7:	29 f2                	sub    %esi,%edx
  801be9:	19 cb                	sbb    %ecx,%ebx
  801beb:	89 d8                	mov    %ebx,%eax
  801bed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bf1:	d3 e0                	shl    %cl,%eax
  801bf3:	89 e9                	mov    %ebp,%ecx
  801bf5:	d3 ea                	shr    %cl,%edx
  801bf7:	09 d0                	or     %edx,%eax
  801bf9:	89 e9                	mov    %ebp,%ecx
  801bfb:	d3 eb                	shr    %cl,%ebx
  801bfd:	89 da                	mov    %ebx,%edx
  801bff:	83 c4 1c             	add    $0x1c,%esp
  801c02:	5b                   	pop    %ebx
  801c03:	5e                   	pop    %esi
  801c04:	5f                   	pop    %edi
  801c05:	5d                   	pop    %ebp
  801c06:	c3                   	ret    
  801c07:	90                   	nop
  801c08:	89 fd                	mov    %edi,%ebp
  801c0a:	85 ff                	test   %edi,%edi
  801c0c:	75 0b                	jne    801c19 <__umoddi3+0xe9>
  801c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c13:	31 d2                	xor    %edx,%edx
  801c15:	f7 f7                	div    %edi
  801c17:	89 c5                	mov    %eax,%ebp
  801c19:	89 f0                	mov    %esi,%eax
  801c1b:	31 d2                	xor    %edx,%edx
  801c1d:	f7 f5                	div    %ebp
  801c1f:	89 c8                	mov    %ecx,%eax
  801c21:	f7 f5                	div    %ebp
  801c23:	89 d0                	mov    %edx,%eax
  801c25:	e9 44 ff ff ff       	jmp    801b6e <__umoddi3+0x3e>
  801c2a:	66 90                	xchg   %ax,%ax
  801c2c:	89 c8                	mov    %ecx,%eax
  801c2e:	89 f2                	mov    %esi,%edx
  801c30:	83 c4 1c             	add    $0x1c,%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5e                   	pop    %esi
  801c35:	5f                   	pop    %edi
  801c36:	5d                   	pop    %ebp
  801c37:	c3                   	ret    
  801c38:	3b 04 24             	cmp    (%esp),%eax
  801c3b:	72 06                	jb     801c43 <__umoddi3+0x113>
  801c3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c41:	77 0f                	ja     801c52 <__umoddi3+0x122>
  801c43:	89 f2                	mov    %esi,%edx
  801c45:	29 f9                	sub    %edi,%ecx
  801c47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c4b:	89 14 24             	mov    %edx,(%esp)
  801c4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c52:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c56:	8b 14 24             	mov    (%esp),%edx
  801c59:	83 c4 1c             	add    $0x1c,%esp
  801c5c:	5b                   	pop    %ebx
  801c5d:	5e                   	pop    %esi
  801c5e:	5f                   	pop    %edi
  801c5f:	5d                   	pop    %ebp
  801c60:	c3                   	ret    
  801c61:	8d 76 00             	lea    0x0(%esi),%esi
  801c64:	2b 04 24             	sub    (%esp),%eax
  801c67:	19 fa                	sbb    %edi,%edx
  801c69:	89 d1                	mov    %edx,%ecx
  801c6b:	89 c6                	mov    %eax,%esi
  801c6d:	e9 71 ff ff ff       	jmp    801be3 <__umoddi3+0xb3>
  801c72:	66 90                	xchg   %ax,%ax
  801c74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c78:	72 ea                	jb     801c64 <__umoddi3+0x134>
  801c7a:	89 d9                	mov    %ebx,%ecx
  801c7c:	e9 62 ff ff ff       	jmp    801be3 <__umoddi3+0xb3>
