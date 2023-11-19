
obj/user/fos_input:     file format elf32-i386


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
  800031:	e8 a5 00 00 00       	call   8000db <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 04 00 00    	sub    $0x418,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[512];
	char buff2[512];


	atomic_readline("Please enter first number :", buff1);
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800058:	50                   	push   %eax
  800059:	68 60 1d 80 00       	push   $0x801d60
  80005e:	e8 11 0a 00 00       	call   800a74 <atomic_readline>
  800063:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 0a                	push   $0xa
  80006b:	6a 00                	push   $0x0
  80006d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800073:	50                   	push   %eax
  800074:	e8 6e 0e 00 00       	call   800ee7 <strtol>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//sleep
	env_sleep(2800);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 f0 0a 00 00       	push   $0xaf0
  800087:	e8 04 19 00 00       	call   801990 <env_sleep>
  80008c:	83 c4 10             	add    $0x10,%esp

	atomic_readline("Please enter second number :", buff2);
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	68 7c 1d 80 00       	push   $0x801d7c
  80009e:	e8 d1 09 00 00       	call   800a74 <atomic_readline>
  8000a3:	83 c4 10             	add    $0x10,%esp
	
	i2 = strtol(buff2, NULL, 10);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 0a                	push   $0xa
  8000ab:	6a 00                	push   $0x0
  8000ad:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8000b3:	50                   	push   %eax
  8000b4:	e8 2e 0e 00 00       	call   800ee7 <strtol>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  8000bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 99 1d 80 00       	push   $0x801d99
  8000d0:	e8 4c 02 00 00       	call   800321 <atomic_cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	return;	
  8000d8:	90                   	nop
}
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e1:	e8 88 15 00 00       	call   80166e <sys_getenvindex>
  8000e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000ec:	89 d0                	mov    %edx,%eax
  8000ee:	01 c0                	add    %eax,%eax
  8000f0:	01 d0                	add    %edx,%eax
  8000f2:	01 c0                	add    %eax,%eax
  8000f4:	01 d0                	add    %edx,%eax
  8000f6:	c1 e0 02             	shl    $0x2,%eax
  8000f9:	01 d0                	add    %edx,%eax
  8000fb:	01 c0                	add    %eax,%eax
  8000fd:	01 d0                	add    %edx,%eax
  8000ff:	c1 e0 02             	shl    $0x2,%eax
  800102:	01 d0                	add    %edx,%eax
  800104:	c1 e0 02             	shl    $0x2,%eax
  800107:	01 d0                	add    %edx,%eax
  800109:	c1 e0 02             	shl    $0x2,%eax
  80010c:	01 d0                	add    %edx,%eax
  80010e:	c1 e0 05             	shl    $0x5,%eax
  800111:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800116:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80011b:	a1 20 30 80 00       	mov    0x803020,%eax
  800120:	8a 40 5c             	mov    0x5c(%eax),%al
  800123:	84 c0                	test   %al,%al
  800125:	74 0d                	je     800134 <libmain+0x59>
		binaryname = myEnv->prog_name;
  800127:	a1 20 30 80 00       	mov    0x803020,%eax
  80012c:	83 c0 5c             	add    $0x5c,%eax
  80012f:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800134:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800138:	7e 0a                	jle    800144 <libmain+0x69>
		binaryname = argv[0];
  80013a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013d:	8b 00                	mov    (%eax),%eax
  80013f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800144:	83 ec 08             	sub    $0x8,%esp
  800147:	ff 75 0c             	pushl  0xc(%ebp)
  80014a:	ff 75 08             	pushl  0x8(%ebp)
  80014d:	e8 e6 fe ff ff       	call   800038 <_main>
  800152:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800155:	e8 21 13 00 00       	call   80147b <sys_disable_interrupt>
	cprintf("**************************************\n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 cc 1d 80 00       	push   $0x801dcc
  800162:	e8 8d 01 00 00       	call   8002f4 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80016a:	a1 20 30 80 00       	mov    0x803020,%eax
  80016f:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  800175:	a1 20 30 80 00       	mov    0x803020,%eax
  80017a:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  800180:	83 ec 04             	sub    $0x4,%esp
  800183:	52                   	push   %edx
  800184:	50                   	push   %eax
  800185:	68 f4 1d 80 00       	push   $0x801df4
  80018a:	e8 65 01 00 00       	call   8002f4 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800192:	a1 20 30 80 00       	mov    0x803020,%eax
  800197:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  80019d:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a2:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  8001a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ad:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  8001b3:	51                   	push   %ecx
  8001b4:	52                   	push   %edx
  8001b5:	50                   	push   %eax
  8001b6:	68 1c 1e 80 00       	push   $0x801e1c
  8001bb:	e8 34 01 00 00       	call   8002f4 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c8:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	50                   	push   %eax
  8001d2:	68 74 1e 80 00       	push   $0x801e74
  8001d7:	e8 18 01 00 00       	call   8002f4 <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001df:	83 ec 0c             	sub    $0xc,%esp
  8001e2:	68 cc 1d 80 00       	push   $0x801dcc
  8001e7:	e8 08 01 00 00       	call   8002f4 <cprintf>
  8001ec:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ef:	e8 a1 12 00 00       	call   801495 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001f4:	e8 19 00 00 00       	call   800212 <exit>
}
  8001f9:	90                   	nop
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	6a 00                	push   $0x0
  800207:	e8 2e 14 00 00       	call   80163a <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
}
  80020f:	90                   	nop
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <exit>:

void
exit(void)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800218:	e8 83 14 00 00       	call   8016a0 <sys_exit_env>
}
  80021d:	90                   	nop
  80021e:	c9                   	leave  
  80021f:	c3                   	ret    

00800220 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800226:	8b 45 0c             	mov    0xc(%ebp),%eax
  800229:	8b 00                	mov    (%eax),%eax
  80022b:	8d 48 01             	lea    0x1(%eax),%ecx
  80022e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800231:	89 0a                	mov    %ecx,(%edx)
  800233:	8b 55 08             	mov    0x8(%ebp),%edx
  800236:	88 d1                	mov    %dl,%cl
  800238:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80023f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	3d ff 00 00 00       	cmp    $0xff,%eax
  800249:	75 2c                	jne    800277 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80024b:	a0 24 30 80 00       	mov    0x803024,%al
  800250:	0f b6 c0             	movzbl %al,%eax
  800253:	8b 55 0c             	mov    0xc(%ebp),%edx
  800256:	8b 12                	mov    (%edx),%edx
  800258:	89 d1                	mov    %edx,%ecx
  80025a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025d:	83 c2 08             	add    $0x8,%edx
  800260:	83 ec 04             	sub    $0x4,%esp
  800263:	50                   	push   %eax
  800264:	51                   	push   %ecx
  800265:	52                   	push   %edx
  800266:	e8 b7 10 00 00       	call   801322 <sys_cputs>
  80026b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80026e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800271:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027a:	8b 40 04             	mov    0x4(%eax),%eax
  80027d:	8d 50 01             	lea    0x1(%eax),%edx
  800280:	8b 45 0c             	mov    0xc(%ebp),%eax
  800283:	89 50 04             	mov    %edx,0x4(%eax)
}
  800286:	90                   	nop
  800287:	c9                   	leave  
  800288:	c3                   	ret    

00800289 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800292:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800299:	00 00 00 
	b.cnt = 0;
  80029c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002a6:	ff 75 0c             	pushl  0xc(%ebp)
  8002a9:	ff 75 08             	pushl  0x8(%ebp)
  8002ac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b2:	50                   	push   %eax
  8002b3:	68 20 02 80 00       	push   $0x800220
  8002b8:	e8 11 02 00 00       	call   8004ce <vprintfmt>
  8002bd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002c0:	a0 24 30 80 00       	mov    0x803024,%al
  8002c5:	0f b6 c0             	movzbl %al,%eax
  8002c8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002ce:	83 ec 04             	sub    $0x4,%esp
  8002d1:	50                   	push   %eax
  8002d2:	52                   	push   %edx
  8002d3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d9:	83 c0 08             	add    $0x8,%eax
  8002dc:	50                   	push   %eax
  8002dd:	e8 40 10 00 00       	call   801322 <sys_cputs>
  8002e2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002e5:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002ec:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

008002f4 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002fa:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800301:	8d 45 0c             	lea    0xc(%ebp),%eax
  800304:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800307:	8b 45 08             	mov    0x8(%ebp),%eax
  80030a:	83 ec 08             	sub    $0x8,%esp
  80030d:	ff 75 f4             	pushl  -0xc(%ebp)
  800310:	50                   	push   %eax
  800311:	e8 73 ff ff ff       	call   800289 <vcprintf>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80031c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800327:	e8 4f 11 00 00       	call   80147b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80032c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80032f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800332:	8b 45 08             	mov    0x8(%ebp),%eax
  800335:	83 ec 08             	sub    $0x8,%esp
  800338:	ff 75 f4             	pushl  -0xc(%ebp)
  80033b:	50                   	push   %eax
  80033c:	e8 48 ff ff ff       	call   800289 <vcprintf>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800347:	e8 49 11 00 00       	call   801495 <sys_enable_interrupt>
	return cnt;
  80034c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80034f:	c9                   	leave  
  800350:	c3                   	ret    

00800351 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	53                   	push   %ebx
  800355:	83 ec 14             	sub    $0x14,%esp
  800358:	8b 45 10             	mov    0x10(%ebp),%eax
  80035b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80035e:	8b 45 14             	mov    0x14(%ebp),%eax
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800364:	8b 45 18             	mov    0x18(%ebp),%eax
  800367:	ba 00 00 00 00       	mov    $0x0,%edx
  80036c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80036f:	77 55                	ja     8003c6 <printnum+0x75>
  800371:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800374:	72 05                	jb     80037b <printnum+0x2a>
  800376:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800379:	77 4b                	ja     8003c6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80037b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80037e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800381:	8b 45 18             	mov    0x18(%ebp),%eax
  800384:	ba 00 00 00 00       	mov    $0x0,%edx
  800389:	52                   	push   %edx
  80038a:	50                   	push   %eax
  80038b:	ff 75 f4             	pushl  -0xc(%ebp)
  80038e:	ff 75 f0             	pushl  -0x10(%ebp)
  800391:	e8 4e 17 00 00       	call   801ae4 <__udivdi3>
  800396:	83 c4 10             	add    $0x10,%esp
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	ff 75 20             	pushl  0x20(%ebp)
  80039f:	53                   	push   %ebx
  8003a0:	ff 75 18             	pushl  0x18(%ebp)
  8003a3:	52                   	push   %edx
  8003a4:	50                   	push   %eax
  8003a5:	ff 75 0c             	pushl  0xc(%ebp)
  8003a8:	ff 75 08             	pushl  0x8(%ebp)
  8003ab:	e8 a1 ff ff ff       	call   800351 <printnum>
  8003b0:	83 c4 20             	add    $0x20,%esp
  8003b3:	eb 1a                	jmp    8003cf <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003b5:	83 ec 08             	sub    $0x8,%esp
  8003b8:	ff 75 0c             	pushl  0xc(%ebp)
  8003bb:	ff 75 20             	pushl  0x20(%ebp)
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	ff d0                	call   *%eax
  8003c3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c6:	ff 4d 1c             	decl   0x1c(%ebp)
  8003c9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003cd:	7f e6                	jg     8003b5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003cf:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003dd:	53                   	push   %ebx
  8003de:	51                   	push   %ecx
  8003df:	52                   	push   %edx
  8003e0:	50                   	push   %eax
  8003e1:	e8 0e 18 00 00       	call   801bf4 <__umoddi3>
  8003e6:	83 c4 10             	add    $0x10,%esp
  8003e9:	05 b4 20 80 00       	add    $0x8020b4,%eax
  8003ee:	8a 00                	mov    (%eax),%al
  8003f0:	0f be c0             	movsbl %al,%eax
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	ff 75 0c             	pushl  0xc(%ebp)
  8003f9:	50                   	push   %eax
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	ff d0                	call   *%eax
  8003ff:	83 c4 10             	add    $0x10,%esp
}
  800402:	90                   	nop
  800403:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800406:	c9                   	leave  
  800407:	c3                   	ret    

00800408 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80040b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80040f:	7e 1c                	jle    80042d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800411:	8b 45 08             	mov    0x8(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	8d 50 08             	lea    0x8(%eax),%edx
  800419:	8b 45 08             	mov    0x8(%ebp),%eax
  80041c:	89 10                	mov    %edx,(%eax)
  80041e:	8b 45 08             	mov    0x8(%ebp),%eax
  800421:	8b 00                	mov    (%eax),%eax
  800423:	83 e8 08             	sub    $0x8,%eax
  800426:	8b 50 04             	mov    0x4(%eax),%edx
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	eb 40                	jmp    80046d <getuint+0x65>
	else if (lflag)
  80042d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800431:	74 1e                	je     800451 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800433:	8b 45 08             	mov    0x8(%ebp),%eax
  800436:	8b 00                	mov    (%eax),%eax
  800438:	8d 50 04             	lea    0x4(%eax),%edx
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	89 10                	mov    %edx,(%eax)
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	8b 00                	mov    (%eax),%eax
  800445:	83 e8 04             	sub    $0x4,%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	ba 00 00 00 00       	mov    $0x0,%edx
  80044f:	eb 1c                	jmp    80046d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800451:	8b 45 08             	mov    0x8(%ebp),%eax
  800454:	8b 00                	mov    (%eax),%eax
  800456:	8d 50 04             	lea    0x4(%eax),%edx
  800459:	8b 45 08             	mov    0x8(%ebp),%eax
  80045c:	89 10                	mov    %edx,(%eax)
  80045e:	8b 45 08             	mov    0x8(%ebp),%eax
  800461:	8b 00                	mov    (%eax),%eax
  800463:	83 e8 04             	sub    $0x4,%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80046d:	5d                   	pop    %ebp
  80046e:	c3                   	ret    

0080046f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800472:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800476:	7e 1c                	jle    800494 <getint+0x25>
		return va_arg(*ap, long long);
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
  80047b:	8b 00                	mov    (%eax),%eax
  80047d:	8d 50 08             	lea    0x8(%eax),%edx
  800480:	8b 45 08             	mov    0x8(%ebp),%eax
  800483:	89 10                	mov    %edx,(%eax)
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	83 e8 08             	sub    $0x8,%eax
  80048d:	8b 50 04             	mov    0x4(%eax),%edx
  800490:	8b 00                	mov    (%eax),%eax
  800492:	eb 38                	jmp    8004cc <getint+0x5d>
	else if (lflag)
  800494:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800498:	74 1a                	je     8004b4 <getint+0x45>
		return va_arg(*ap, long);
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	8d 50 04             	lea    0x4(%eax),%edx
  8004a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a5:	89 10                	mov    %edx,(%eax)
  8004a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	83 e8 04             	sub    $0x4,%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	99                   	cltd   
  8004b2:	eb 18                	jmp    8004cc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	8d 50 04             	lea    0x4(%eax),%edx
  8004bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bf:	89 10                	mov    %edx,(%eax)
  8004c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	83 e8 04             	sub    $0x4,%eax
  8004c9:	8b 00                	mov    (%eax),%eax
  8004cb:	99                   	cltd   
}
  8004cc:	5d                   	pop    %ebp
  8004cd:	c3                   	ret    

008004ce <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	56                   	push   %esi
  8004d2:	53                   	push   %ebx
  8004d3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d6:	eb 17                	jmp    8004ef <vprintfmt+0x21>
			if (ch == '\0')
  8004d8:	85 db                	test   %ebx,%ebx
  8004da:	0f 84 af 03 00 00    	je     80088f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	ff 75 0c             	pushl  0xc(%ebp)
  8004e6:	53                   	push   %ebx
  8004e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ea:	ff d0                	call   *%eax
  8004ec:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f2:	8d 50 01             	lea    0x1(%eax),%edx
  8004f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f8:	8a 00                	mov    (%eax),%al
  8004fa:	0f b6 d8             	movzbl %al,%ebx
  8004fd:	83 fb 25             	cmp    $0x25,%ebx
  800500:	75 d6                	jne    8004d8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800502:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800506:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80050d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800514:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80051b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800522:	8b 45 10             	mov    0x10(%ebp),%eax
  800525:	8d 50 01             	lea    0x1(%eax),%edx
  800528:	89 55 10             	mov    %edx,0x10(%ebp)
  80052b:	8a 00                	mov    (%eax),%al
  80052d:	0f b6 d8             	movzbl %al,%ebx
  800530:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800533:	83 f8 55             	cmp    $0x55,%eax
  800536:	0f 87 2b 03 00 00    	ja     800867 <vprintfmt+0x399>
  80053c:	8b 04 85 d8 20 80 00 	mov    0x8020d8(,%eax,4),%eax
  800543:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800545:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800549:	eb d7                	jmp    800522 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80054b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80054f:	eb d1                	jmp    800522 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800551:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800558:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80055b:	89 d0                	mov    %edx,%eax
  80055d:	c1 e0 02             	shl    $0x2,%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	01 c0                	add    %eax,%eax
  800564:	01 d8                	add    %ebx,%eax
  800566:	83 e8 30             	sub    $0x30,%eax
  800569:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80056c:	8b 45 10             	mov    0x10(%ebp),%eax
  80056f:	8a 00                	mov    (%eax),%al
  800571:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800574:	83 fb 2f             	cmp    $0x2f,%ebx
  800577:	7e 3e                	jle    8005b7 <vprintfmt+0xe9>
  800579:	83 fb 39             	cmp    $0x39,%ebx
  80057c:	7f 39                	jg     8005b7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80057e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800581:	eb d5                	jmp    800558 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	83 c0 04             	add    $0x4,%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	83 e8 04             	sub    $0x4,%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800597:	eb 1f                	jmp    8005b8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800599:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80059d:	79 83                	jns    800522 <vprintfmt+0x54>
				width = 0;
  80059f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005a6:	e9 77 ff ff ff       	jmp    800522 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005ab:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005b2:	e9 6b ff ff ff       	jmp    800522 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005b7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005bc:	0f 89 60 ff ff ff    	jns    800522 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005c8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005cf:	e9 4e ff ff ff       	jmp    800522 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005d4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005d7:	e9 46 ff ff ff       	jmp    800522 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	83 c0 04             	add    $0x4,%eax
  8005e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	83 e8 04             	sub    $0x4,%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	ff 75 0c             	pushl  0xc(%ebp)
  8005f3:	50                   	push   %eax
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	ff d0                	call   *%eax
  8005f9:	83 c4 10             	add    $0x10,%esp
			break;
  8005fc:	e9 89 02 00 00       	jmp    80088a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	83 c0 04             	add    $0x4,%eax
  800607:	89 45 14             	mov    %eax,0x14(%ebp)
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	83 e8 04             	sub    $0x4,%eax
  800610:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800612:	85 db                	test   %ebx,%ebx
  800614:	79 02                	jns    800618 <vprintfmt+0x14a>
				err = -err;
  800616:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800618:	83 fb 64             	cmp    $0x64,%ebx
  80061b:	7f 0b                	jg     800628 <vprintfmt+0x15a>
  80061d:	8b 34 9d 20 1f 80 00 	mov    0x801f20(,%ebx,4),%esi
  800624:	85 f6                	test   %esi,%esi
  800626:	75 19                	jne    800641 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800628:	53                   	push   %ebx
  800629:	68 c5 20 80 00       	push   $0x8020c5
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	ff 75 08             	pushl  0x8(%ebp)
  800634:	e8 5e 02 00 00       	call   800897 <printfmt>
  800639:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80063c:	e9 49 02 00 00       	jmp    80088a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800641:	56                   	push   %esi
  800642:	68 ce 20 80 00       	push   $0x8020ce
  800647:	ff 75 0c             	pushl  0xc(%ebp)
  80064a:	ff 75 08             	pushl  0x8(%ebp)
  80064d:	e8 45 02 00 00       	call   800897 <printfmt>
  800652:	83 c4 10             	add    $0x10,%esp
			break;
  800655:	e9 30 02 00 00       	jmp    80088a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	83 c0 04             	add    $0x4,%eax
  800660:	89 45 14             	mov    %eax,0x14(%ebp)
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	83 e8 04             	sub    $0x4,%eax
  800669:	8b 30                	mov    (%eax),%esi
  80066b:	85 f6                	test   %esi,%esi
  80066d:	75 05                	jne    800674 <vprintfmt+0x1a6>
				p = "(null)";
  80066f:	be d1 20 80 00       	mov    $0x8020d1,%esi
			if (width > 0 && padc != '-')
  800674:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800678:	7e 6d                	jle    8006e7 <vprintfmt+0x219>
  80067a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80067e:	74 67                	je     8006e7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800680:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	50                   	push   %eax
  800687:	56                   	push   %esi
  800688:	e8 12 05 00 00       	call   800b9f <strnlen>
  80068d:	83 c4 10             	add    $0x10,%esp
  800690:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800693:	eb 16                	jmp    8006ab <vprintfmt+0x1dd>
					putch(padc, putdat);
  800695:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	ff 75 0c             	pushl  0xc(%ebp)
  80069f:	50                   	push   %eax
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	ff d0                	call   *%eax
  8006a5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a8:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006af:	7f e4                	jg     800695 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b1:	eb 34                	jmp    8006e7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006b7:	74 1c                	je     8006d5 <vprintfmt+0x207>
  8006b9:	83 fb 1f             	cmp    $0x1f,%ebx
  8006bc:	7e 05                	jle    8006c3 <vprintfmt+0x1f5>
  8006be:	83 fb 7e             	cmp    $0x7e,%ebx
  8006c1:	7e 12                	jle    8006d5 <vprintfmt+0x207>
					putch('?', putdat);
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	ff 75 0c             	pushl  0xc(%ebp)
  8006c9:	6a 3f                	push   $0x3f
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	ff d0                	call   *%eax
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	eb 0f                	jmp    8006e4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	ff 75 0c             	pushl  0xc(%ebp)
  8006db:	53                   	push   %ebx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	ff d0                	call   *%eax
  8006e1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e4:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e7:	89 f0                	mov    %esi,%eax
  8006e9:	8d 70 01             	lea    0x1(%eax),%esi
  8006ec:	8a 00                	mov    (%eax),%al
  8006ee:	0f be d8             	movsbl %al,%ebx
  8006f1:	85 db                	test   %ebx,%ebx
  8006f3:	74 24                	je     800719 <vprintfmt+0x24b>
  8006f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f9:	78 b8                	js     8006b3 <vprintfmt+0x1e5>
  8006fb:	ff 4d e0             	decl   -0x20(%ebp)
  8006fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800702:	79 af                	jns    8006b3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800704:	eb 13                	jmp    800719 <vprintfmt+0x24b>
				putch(' ', putdat);
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	ff 75 0c             	pushl  0xc(%ebp)
  80070c:	6a 20                	push   $0x20
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	ff d0                	call   *%eax
  800713:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800716:	ff 4d e4             	decl   -0x1c(%ebp)
  800719:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071d:	7f e7                	jg     800706 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80071f:	e9 66 01 00 00       	jmp    80088a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	ff 75 e8             	pushl  -0x18(%ebp)
  80072a:	8d 45 14             	lea    0x14(%ebp),%eax
  80072d:	50                   	push   %eax
  80072e:	e8 3c fd ff ff       	call   80046f <getint>
  800733:	83 c4 10             	add    $0x10,%esp
  800736:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800739:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80073c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800742:	85 d2                	test   %edx,%edx
  800744:	79 23                	jns    800769 <vprintfmt+0x29b>
				putch('-', putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	ff 75 0c             	pushl  0xc(%ebp)
  80074c:	6a 2d                	push   $0x2d
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	ff d0                	call   *%eax
  800753:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800759:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80075c:	f7 d8                	neg    %eax
  80075e:	83 d2 00             	adc    $0x0,%edx
  800761:	f7 da                	neg    %edx
  800763:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800766:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800769:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800770:	e9 bc 00 00 00       	jmp    800831 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	ff 75 e8             	pushl  -0x18(%ebp)
  80077b:	8d 45 14             	lea    0x14(%ebp),%eax
  80077e:	50                   	push   %eax
  80077f:	e8 84 fc ff ff       	call   800408 <getuint>
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80078d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800794:	e9 98 00 00 00       	jmp    800831 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
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
			putch('X', putdat);
  8007b9:	83 ec 08             	sub    $0x8,%esp
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	6a 58                	push   $0x58
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	ff d0                	call   *%eax
  8007c6:	83 c4 10             	add    $0x10,%esp
			break;
  8007c9:	e9 bc 00 00 00       	jmp    80088a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	6a 30                	push   $0x30
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	ff d0                	call   *%eax
  8007db:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	6a 78                	push   $0x78
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	ff d0                	call   *%eax
  8007eb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	83 c0 04             	add    $0x4,%eax
  8007f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 e8 04             	sub    $0x4,%eax
  8007fd:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800802:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800809:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800810:	eb 1f                	jmp    800831 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	ff 75 e8             	pushl  -0x18(%ebp)
  800818:	8d 45 14             	lea    0x14(%ebp),%eax
  80081b:	50                   	push   %eax
  80081c:	e8 e7 fb ff ff       	call   800408 <getuint>
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800827:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80082a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800831:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800835:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800838:	83 ec 04             	sub    $0x4,%esp
  80083b:	52                   	push   %edx
  80083c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80083f:	50                   	push   %eax
  800840:	ff 75 f4             	pushl  -0xc(%ebp)
  800843:	ff 75 f0             	pushl  -0x10(%ebp)
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	ff 75 08             	pushl  0x8(%ebp)
  80084c:	e8 00 fb ff ff       	call   800351 <printnum>
  800851:	83 c4 20             	add    $0x20,%esp
			break;
  800854:	eb 34                	jmp    80088a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	53                   	push   %ebx
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			break;
  800865:	eb 23                	jmp    80088a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	6a 25                	push   $0x25
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	ff d0                	call   *%eax
  800874:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800877:	ff 4d 10             	decl   0x10(%ebp)
  80087a:	eb 03                	jmp    80087f <vprintfmt+0x3b1>
  80087c:	ff 4d 10             	decl   0x10(%ebp)
  80087f:	8b 45 10             	mov    0x10(%ebp),%eax
  800882:	48                   	dec    %eax
  800883:	8a 00                	mov    (%eax),%al
  800885:	3c 25                	cmp    $0x25,%al
  800887:	75 f3                	jne    80087c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800889:	90                   	nop
		}
	}
  80088a:	e9 47 fc ff ff       	jmp    8004d6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80088f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800890:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800893:	5b                   	pop    %ebx
  800894:	5e                   	pop    %esi
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80089d:	8d 45 10             	lea    0x10(%ebp),%eax
  8008a0:	83 c0 04             	add    $0x4,%eax
  8008a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ac:	50                   	push   %eax
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	ff 75 08             	pushl  0x8(%ebp)
  8008b3:	e8 16 fc ff ff       	call   8004ce <vprintfmt>
  8008b8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008bb:	90                   	nop
  8008bc:	c9                   	leave  
  8008bd:	c3                   	ret    

008008be <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c4:	8b 40 08             	mov    0x8(%eax),%eax
  8008c7:	8d 50 01             	lea    0x1(%eax),%edx
  8008ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d3:	8b 10                	mov    (%eax),%edx
  8008d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d8:	8b 40 04             	mov    0x4(%eax),%eax
  8008db:	39 c2                	cmp    %eax,%edx
  8008dd:	73 12                	jae    8008f1 <sprintputch+0x33>
		*b->buf++ = ch;
  8008df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	8d 48 01             	lea    0x1(%eax),%ecx
  8008e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ea:	89 0a                	mov    %ecx,(%edx)
  8008ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ef:	88 10                	mov    %dl,(%eax)
}
  8008f1:	90                   	nop
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800900:	8b 45 0c             	mov    0xc(%ebp),%eax
  800903:	8d 50 ff             	lea    -0x1(%eax),%edx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	01 d0                	add    %edx,%eax
  80090b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80090e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800915:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800919:	74 06                	je     800921 <vsnprintf+0x2d>
  80091b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80091f:	7f 07                	jg     800928 <vsnprintf+0x34>
		return -E_INVAL;
  800921:	b8 03 00 00 00       	mov    $0x3,%eax
  800926:	eb 20                	jmp    800948 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800928:	ff 75 14             	pushl  0x14(%ebp)
  80092b:	ff 75 10             	pushl  0x10(%ebp)
  80092e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800931:	50                   	push   %eax
  800932:	68 be 08 80 00       	push   $0x8008be
  800937:	e8 92 fb ff ff       	call   8004ce <vprintfmt>
  80093c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80093f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800942:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800945:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800948:	c9                   	leave  
  800949:	c3                   	ret    

0080094a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800950:	8d 45 10             	lea    0x10(%ebp),%eax
  800953:	83 c0 04             	add    $0x4,%eax
  800956:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800959:	8b 45 10             	mov    0x10(%ebp),%eax
  80095c:	ff 75 f4             	pushl  -0xc(%ebp)
  80095f:	50                   	push   %eax
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	ff 75 08             	pushl  0x8(%ebp)
  800966:	e8 89 ff ff ff       	call   8008f4 <vsnprintf>
  80096b:	83 c4 10             	add    $0x10,%esp
  80096e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800971:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800974:	c9                   	leave  
  800975:	c3                   	ret    

00800976 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80097c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800980:	74 13                	je     800995 <readline+0x1f>
		cprintf("%s", prompt);
  800982:	83 ec 08             	sub    $0x8,%esp
  800985:	ff 75 08             	pushl  0x8(%ebp)
  800988:	68 30 22 80 00       	push   $0x802230
  80098d:	e8 62 f9 ff ff       	call   8002f4 <cprintf>
  800992:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800995:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80099c:	83 ec 0c             	sub    $0xc,%esp
  80099f:	6a 00                	push   $0x0
  8009a1:	e8 34 11 00 00       	call   801ada <iscons>
  8009a6:	83 c4 10             	add    $0x10,%esp
  8009a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009ac:	e8 db 10 00 00       	call   801a8c <getchar>
  8009b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009b8:	79 22                	jns    8009dc <readline+0x66>
			if (c != -E_EOF)
  8009ba:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009be:	0f 84 ad 00 00 00    	je     800a71 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 ec             	pushl  -0x14(%ebp)
  8009ca:	68 33 22 80 00       	push   $0x802233
  8009cf:	e8 20 f9 ff ff       	call   8002f4 <cprintf>
  8009d4:	83 c4 10             	add    $0x10,%esp
			return;
  8009d7:	e9 95 00 00 00       	jmp    800a71 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009dc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009e0:	7e 34                	jle    800a16 <readline+0xa0>
  8009e2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009e9:	7f 2b                	jg     800a16 <readline+0xa0>
			if (echoing)
  8009eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009ef:	74 0e                	je     8009ff <readline+0x89>
				cputchar(c);
  8009f1:	83 ec 0c             	sub    $0xc,%esp
  8009f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8009f7:	e8 48 10 00 00       	call   801a44 <cputchar>
  8009fc:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8009ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a02:	8d 50 01             	lea    0x1(%eax),%edx
  800a05:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a08:	89 c2                	mov    %eax,%edx
  800a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0d:	01 d0                	add    %edx,%eax
  800a0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a12:	88 10                	mov    %dl,(%eax)
  800a14:	eb 56                	jmp    800a6c <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a16:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a1a:	75 1f                	jne    800a3b <readline+0xc5>
  800a1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a20:	7e 19                	jle    800a3b <readline+0xc5>
			if (echoing)
  800a22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a26:	74 0e                	je     800a36 <readline+0xc0>
				cputchar(c);
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	ff 75 ec             	pushl  -0x14(%ebp)
  800a2e:	e8 11 10 00 00       	call   801a44 <cputchar>
  800a33:	83 c4 10             	add    $0x10,%esp

			i--;
  800a36:	ff 4d f4             	decl   -0xc(%ebp)
  800a39:	eb 31                	jmp    800a6c <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a3b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a3f:	74 0a                	je     800a4b <readline+0xd5>
  800a41:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a45:	0f 85 61 ff ff ff    	jne    8009ac <readline+0x36>
			if (echoing)
  800a4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a4f:	74 0e                	je     800a5f <readline+0xe9>
				cputchar(c);
  800a51:	83 ec 0c             	sub    $0xc,%esp
  800a54:	ff 75 ec             	pushl  -0x14(%ebp)
  800a57:	e8 e8 0f 00 00       	call   801a44 <cputchar>
  800a5c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a65:	01 d0                	add    %edx,%eax
  800a67:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a6a:	eb 06                	jmp    800a72 <readline+0xfc>
		}
	}
  800a6c:	e9 3b ff ff ff       	jmp    8009ac <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a71:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a72:	c9                   	leave  
  800a73:	c3                   	ret    

00800a74 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a7a:	e8 fc 09 00 00       	call   80147b <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a83:	74 13                	je     800a98 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a85:	83 ec 08             	sub    $0x8,%esp
  800a88:	ff 75 08             	pushl  0x8(%ebp)
  800a8b:	68 30 22 80 00       	push   $0x802230
  800a90:	e8 5f f8 ff ff       	call   8002f4 <cprintf>
  800a95:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a9f:	83 ec 0c             	sub    $0xc,%esp
  800aa2:	6a 00                	push   $0x0
  800aa4:	e8 31 10 00 00       	call   801ada <iscons>
  800aa9:	83 c4 10             	add    $0x10,%esp
  800aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800aaf:	e8 d8 0f 00 00       	call   801a8c <getchar>
  800ab4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800ab7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800abb:	79 23                	jns    800ae0 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800abd:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ac1:	74 13                	je     800ad6 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 ec             	pushl  -0x14(%ebp)
  800ac9:	68 33 22 80 00       	push   $0x802233
  800ace:	e8 21 f8 ff ff       	call   8002f4 <cprintf>
  800ad3:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800ad6:	e8 ba 09 00 00       	call   801495 <sys_enable_interrupt>
			return;
  800adb:	e9 9a 00 00 00       	jmp    800b7a <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ae0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ae4:	7e 34                	jle    800b1a <atomic_readline+0xa6>
  800ae6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800aed:	7f 2b                	jg     800b1a <atomic_readline+0xa6>
			if (echoing)
  800aef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800af3:	74 0e                	je     800b03 <atomic_readline+0x8f>
				cputchar(c);
  800af5:	83 ec 0c             	sub    $0xc,%esp
  800af8:	ff 75 ec             	pushl  -0x14(%ebp)
  800afb:	e8 44 0f 00 00       	call   801a44 <cputchar>
  800b00:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b06:	8d 50 01             	lea    0x1(%eax),%edx
  800b09:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b0c:	89 c2                	mov    %eax,%edx
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	01 d0                	add    %edx,%eax
  800b13:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b16:	88 10                	mov    %dl,(%eax)
  800b18:	eb 5b                	jmp    800b75 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800b1a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b1e:	75 1f                	jne    800b3f <atomic_readline+0xcb>
  800b20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b24:	7e 19                	jle    800b3f <atomic_readline+0xcb>
			if (echoing)
  800b26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b2a:	74 0e                	je     800b3a <atomic_readline+0xc6>
				cputchar(c);
  800b2c:	83 ec 0c             	sub    $0xc,%esp
  800b2f:	ff 75 ec             	pushl  -0x14(%ebp)
  800b32:	e8 0d 0f 00 00       	call   801a44 <cputchar>
  800b37:	83 c4 10             	add    $0x10,%esp
			i--;
  800b3a:	ff 4d f4             	decl   -0xc(%ebp)
  800b3d:	eb 36                	jmp    800b75 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b3f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b43:	74 0a                	je     800b4f <atomic_readline+0xdb>
  800b45:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b49:	0f 85 60 ff ff ff    	jne    800aaf <atomic_readline+0x3b>
			if (echoing)
  800b4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b53:	74 0e                	je     800b63 <atomic_readline+0xef>
				cputchar(c);
  800b55:	83 ec 0c             	sub    $0xc,%esp
  800b58:	ff 75 ec             	pushl  -0x14(%ebp)
  800b5b:	e8 e4 0e 00 00       	call   801a44 <cputchar>
  800b60:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	01 d0                	add    %edx,%eax
  800b6b:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b6e:	e8 22 09 00 00       	call   801495 <sys_enable_interrupt>
			return;
  800b73:	eb 05                	jmp    800b7a <atomic_readline+0x106>
		}
	}
  800b75:	e9 35 ff ff ff       	jmp    800aaf <atomic_readline+0x3b>
}
  800b7a:	c9                   	leave  
  800b7b:	c3                   	ret    

00800b7c <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b89:	eb 06                	jmp    800b91 <strlen+0x15>
		n++;
  800b8b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b8e:	ff 45 08             	incl   0x8(%ebp)
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8a 00                	mov    (%eax),%al
  800b96:	84 c0                	test   %al,%al
  800b98:	75 f1                	jne    800b8b <strlen+0xf>
		n++;
	return n;
  800b9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    

00800b9f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ba5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bac:	eb 09                	jmp    800bb7 <strnlen+0x18>
		n++;
  800bae:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb1:	ff 45 08             	incl   0x8(%ebp)
  800bb4:	ff 4d 0c             	decl   0xc(%ebp)
  800bb7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bbb:	74 09                	je     800bc6 <strnlen+0x27>
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	8a 00                	mov    (%eax),%al
  800bc2:	84 c0                	test   %al,%al
  800bc4:	75 e8                	jne    800bae <strnlen+0xf>
		n++;
	return n;
  800bc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc9:	c9                   	leave  
  800bca:	c3                   	ret    

00800bcb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bd7:	90                   	nop
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	8d 50 01             	lea    0x1(%eax),%edx
  800bde:	89 55 08             	mov    %edx,0x8(%ebp)
  800be1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bea:	8a 12                	mov    (%edx),%dl
  800bec:	88 10                	mov    %dl,(%eax)
  800bee:	8a 00                	mov    (%eax),%al
  800bf0:	84 c0                	test   %al,%al
  800bf2:	75 e4                	jne    800bd8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf7:	c9                   	leave  
  800bf8:	c3                   	ret    

00800bf9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c0c:	eb 1f                	jmp    800c2d <strncpy+0x34>
		*dst++ = *src;
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8d 50 01             	lea    0x1(%eax),%edx
  800c14:	89 55 08             	mov    %edx,0x8(%ebp)
  800c17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1a:	8a 12                	mov    (%edx),%dl
  800c1c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	84 c0                	test   %al,%al
  800c25:	74 03                	je     800c2a <strncpy+0x31>
			src++;
  800c27:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c2a:	ff 45 fc             	incl   -0x4(%ebp)
  800c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c30:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c33:	72 d9                	jb     800c0e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c35:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c38:	c9                   	leave  
  800c39:	c3                   	ret    

00800c3a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4a:	74 30                	je     800c7c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c4c:	eb 16                	jmp    800c64 <strlcpy+0x2a>
			*dst++ = *src++;
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8d 50 01             	lea    0x1(%eax),%edx
  800c54:	89 55 08             	mov    %edx,0x8(%ebp)
  800c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c60:	8a 12                	mov    (%edx),%dl
  800c62:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c64:	ff 4d 10             	decl   0x10(%ebp)
  800c67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c6b:	74 09                	je     800c76 <strlcpy+0x3c>
  800c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	84 c0                	test   %al,%al
  800c74:	75 d8                	jne    800c4e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c82:	29 c2                	sub    %eax,%edx
  800c84:	89 d0                	mov    %edx,%eax
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c8b:	eb 06                	jmp    800c93 <strcmp+0xb>
		p++, q++;
  800c8d:	ff 45 08             	incl   0x8(%ebp)
  800c90:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	8a 00                	mov    (%eax),%al
  800c98:	84 c0                	test   %al,%al
  800c9a:	74 0e                	je     800caa <strcmp+0x22>
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8a 10                	mov    (%eax),%dl
  800ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca4:	8a 00                	mov    (%eax),%al
  800ca6:	38 c2                	cmp    %al,%dl
  800ca8:	74 e3                	je     800c8d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	8a 00                	mov    (%eax),%al
  800caf:	0f b6 d0             	movzbl %al,%edx
  800cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	0f b6 c0             	movzbl %al,%eax
  800cba:	29 c2                	sub    %eax,%edx
  800cbc:	89 d0                	mov    %edx,%eax
}
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    

00800cc0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cc3:	eb 09                	jmp    800cce <strncmp+0xe>
		n--, p++, q++;
  800cc5:	ff 4d 10             	decl   0x10(%ebp)
  800cc8:	ff 45 08             	incl   0x8(%ebp)
  800ccb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd2:	74 17                	je     800ceb <strncmp+0x2b>
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	84 c0                	test   %al,%al
  800cdb:	74 0e                	je     800ceb <strncmp+0x2b>
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8a 10                	mov    (%eax),%dl
  800ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	38 c2                	cmp    %al,%dl
  800ce9:	74 da                	je     800cc5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ceb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cef:	75 07                	jne    800cf8 <strncmp+0x38>
		return 0;
  800cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf6:	eb 14                	jmp    800d0c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	0f b6 d0             	movzbl %al,%edx
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	0f b6 c0             	movzbl %al,%eax
  800d08:	29 c2                	sub    %eax,%edx
  800d0a:	89 d0                	mov    %edx,%eax
}
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d1a:	eb 12                	jmp    800d2e <strchr+0x20>
		if (*s == c)
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8a 00                	mov    (%eax),%al
  800d21:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d24:	75 05                	jne    800d2b <strchr+0x1d>
			return (char *) s;
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	eb 11                	jmp    800d3c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d2b:	ff 45 08             	incl   0x8(%ebp)
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	84 c0                	test   %al,%al
  800d35:	75 e5                	jne    800d1c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d3c:	c9                   	leave  
  800d3d:	c3                   	ret    

00800d3e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	83 ec 04             	sub    $0x4,%esp
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d4a:	eb 0d                	jmp    800d59 <strfind+0x1b>
		if (*s == c)
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d54:	74 0e                	je     800d64 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d56:	ff 45 08             	incl   0x8(%ebp)
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	84 c0                	test   %al,%al
  800d60:	75 ea                	jne    800d4c <strfind+0xe>
  800d62:	eb 01                	jmp    800d65 <strfind+0x27>
		if (*s == c)
			break;
  800d64:	90                   	nop
	return (char *) s;
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <memset>:

int i=0;
void *
memset(void *v, int c, uint32 n)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	83 ec 10             	sub    $0x10,%esp


	i++;
  800d70:	a1 28 30 80 00       	mov    0x803028,%eax
  800d75:	40                   	inc    %eax
  800d76:	a3 28 30 80 00       	mov    %eax,0x803028

	char *p;
	int m;

	p = v;
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d81:	8b 45 10             	mov    0x10(%ebp),%eax
  800d84:	89 45 f8             	mov    %eax,-0x8(%ebp)


	while (--m >= 0){
  800d87:	eb 0e                	jmp    800d97 <memset+0x2d>

		*p++ = c;
  800d89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8c:	8d 50 01             	lea    0x1(%eax),%edx
  800d8f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d95:	88 10                	mov    %dl,(%eax)

	p = v;
	m = n;


	while (--m >= 0){
  800d97:	ff 4d f8             	decl   -0x8(%ebp)
  800d9a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d9e:	79 e9                	jns    800d89 <memset+0x1f>

		*p++ = c;
	}

	return v;
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da3:	c9                   	leave  
  800da4:	c3                   	ret    

00800da5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800db7:	eb 16                	jmp    800dcf <memcpy+0x2a>
		*d++ = *s++;
  800db9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dbc:	8d 50 01             	lea    0x1(%eax),%edx
  800dbf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dc2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dcb:	8a 12                	mov    (%edx),%dl
  800dcd:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd5:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	75 dd                	jne    800db9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800df3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800df9:	73 50                	jae    800e4b <memmove+0x6a>
  800dfb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800e01:	01 d0                	add    %edx,%eax
  800e03:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e06:	76 43                	jbe    800e4b <memmove+0x6a>
		s += n;
  800e08:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e11:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e14:	eb 10                	jmp    800e26 <memmove+0x45>
			*--d = *--s;
  800e16:	ff 4d f8             	decl   -0x8(%ebp)
  800e19:	ff 4d fc             	decl   -0x4(%ebp)
  800e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1f:	8a 10                	mov    (%eax),%dl
  800e21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e24:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e26:	8b 45 10             	mov    0x10(%ebp),%eax
  800e29:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e2c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	75 e3                	jne    800e16 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e33:	eb 23                	jmp    800e58 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e38:	8d 50 01             	lea    0x1(%eax),%edx
  800e3b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e41:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e44:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e47:	8a 12                	mov    (%edx),%dl
  800e49:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e51:	89 55 10             	mov    %edx,0x10(%ebp)
  800e54:	85 c0                	test   %eax,%eax
  800e56:	75 dd                	jne    800e35 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e6f:	eb 2a                	jmp    800e9b <memcmp+0x3e>
		if (*s1 != *s2)
  800e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e74:	8a 10                	mov    (%eax),%dl
  800e76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	38 c2                	cmp    %al,%dl
  800e7d:	74 16                	je     800e95 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	0f b6 d0             	movzbl %al,%edx
  800e87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	0f b6 c0             	movzbl %al,%eax
  800e8f:	29 c2                	sub    %eax,%edx
  800e91:	89 d0                	mov    %edx,%eax
  800e93:	eb 18                	jmp    800ead <memcmp+0x50>
		s1++, s2++;
  800e95:	ff 45 fc             	incl   -0x4(%ebp)
  800e98:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	75 c9                	jne    800e71 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ea8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebb:	01 d0                	add    %edx,%eax
  800ebd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ec0:	eb 15                	jmp    800ed7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	0f b6 d0             	movzbl %al,%edx
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	0f b6 c0             	movzbl %al,%eax
  800ed0:	39 c2                	cmp    %eax,%edx
  800ed2:	74 0d                	je     800ee1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ed4:	ff 45 08             	incl   0x8(%ebp)
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800edd:	72 e3                	jb     800ec2 <memfind+0x13>
  800edf:	eb 01                	jmp    800ee2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ee1:	90                   	nop
	return (void *) s;
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    

00800ee7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800eed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ef4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800efb:	eb 03                	jmp    800f00 <strtol+0x19>
		s++;
  800efd:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	3c 20                	cmp    $0x20,%al
  800f07:	74 f4                	je     800efd <strtol+0x16>
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8a 00                	mov    (%eax),%al
  800f0e:	3c 09                	cmp    $0x9,%al
  800f10:	74 eb                	je     800efd <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	3c 2b                	cmp    $0x2b,%al
  800f19:	75 05                	jne    800f20 <strtol+0x39>
		s++;
  800f1b:	ff 45 08             	incl   0x8(%ebp)
  800f1e:	eb 13                	jmp    800f33 <strtol+0x4c>
	else if (*s == '-')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 2d                	cmp    $0x2d,%al
  800f27:	75 0a                	jne    800f33 <strtol+0x4c>
		s++, neg = 1;
  800f29:	ff 45 08             	incl   0x8(%ebp)
  800f2c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f37:	74 06                	je     800f3f <strtol+0x58>
  800f39:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f3d:	75 20                	jne    800f5f <strtol+0x78>
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 30                	cmp    $0x30,%al
  800f46:	75 17                	jne    800f5f <strtol+0x78>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	40                   	inc    %eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3c 78                	cmp    $0x78,%al
  800f50:	75 0d                	jne    800f5f <strtol+0x78>
		s += 2, base = 16;
  800f52:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f56:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f5d:	eb 28                	jmp    800f87 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f63:	75 15                	jne    800f7a <strtol+0x93>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 30                	cmp    $0x30,%al
  800f6c:	75 0c                	jne    800f7a <strtol+0x93>
		s++, base = 8;
  800f6e:	ff 45 08             	incl   0x8(%ebp)
  800f71:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f78:	eb 0d                	jmp    800f87 <strtol+0xa0>
	else if (base == 0)
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	75 07                	jne    800f87 <strtol+0xa0>
		base = 10;
  800f80:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	3c 2f                	cmp    $0x2f,%al
  800f8e:	7e 19                	jle    800fa9 <strtol+0xc2>
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	3c 39                	cmp    $0x39,%al
  800f97:	7f 10                	jg     800fa9 <strtol+0xc2>
			dig = *s - '0';
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	0f be c0             	movsbl %al,%eax
  800fa1:	83 e8 30             	sub    $0x30,%eax
  800fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa7:	eb 42                	jmp    800feb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3c 60                	cmp    $0x60,%al
  800fb0:	7e 19                	jle    800fcb <strtol+0xe4>
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	3c 7a                	cmp    $0x7a,%al
  800fb9:	7f 10                	jg     800fcb <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	0f be c0             	movsbl %al,%eax
  800fc3:	83 e8 57             	sub    $0x57,%eax
  800fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc9:	eb 20                	jmp    800feb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	3c 40                	cmp    $0x40,%al
  800fd2:	7e 39                	jle    80100d <strtol+0x126>
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	3c 5a                	cmp    $0x5a,%al
  800fdb:	7f 30                	jg     80100d <strtol+0x126>
			dig = *s - 'A' + 10;
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	8a 00                	mov    (%eax),%al
  800fe2:	0f be c0             	movsbl %al,%eax
  800fe5:	83 e8 37             	sub    $0x37,%eax
  800fe8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fee:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ff1:	7d 19                	jge    80100c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ff3:	ff 45 08             	incl   0x8(%ebp)
  800ff6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ffd:	89 c2                	mov    %eax,%edx
  800fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801002:	01 d0                	add    %edx,%eax
  801004:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801007:	e9 7b ff ff ff       	jmp    800f87 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80100c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80100d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801011:	74 08                	je     80101b <strtol+0x134>
		*endptr = (char *) s;
  801013:	8b 45 0c             	mov    0xc(%ebp),%eax
  801016:	8b 55 08             	mov    0x8(%ebp),%edx
  801019:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80101b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80101f:	74 07                	je     801028 <strtol+0x141>
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	f7 d8                	neg    %eax
  801026:	eb 03                	jmp    80102b <strtol+0x144>
  801028:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <ltostr>:

void
ltostr(long value, char *str)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801033:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80103a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801041:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801045:	79 13                	jns    80105a <ltostr+0x2d>
	{
		neg = 1;
  801047:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80104e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801051:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801054:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801057:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801062:	99                   	cltd   
  801063:	f7 f9                	idiv   %ecx
  801065:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801068:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106b:	8d 50 01             	lea    0x1(%eax),%edx
  80106e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801071:	89 c2                	mov    %eax,%edx
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	01 d0                	add    %edx,%eax
  801078:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80107b:	83 c2 30             	add    $0x30,%edx
  80107e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801080:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801083:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801088:	f7 e9                	imul   %ecx
  80108a:	c1 fa 02             	sar    $0x2,%edx
  80108d:	89 c8                	mov    %ecx,%eax
  80108f:	c1 f8 1f             	sar    $0x1f,%eax
  801092:	29 c2                	sub    %eax,%edx
  801094:	89 d0                	mov    %edx,%eax
  801096:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801099:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a1:	f7 e9                	imul   %ecx
  8010a3:	c1 fa 02             	sar    $0x2,%edx
  8010a6:	89 c8                	mov    %ecx,%eax
  8010a8:	c1 f8 1f             	sar    $0x1f,%eax
  8010ab:	29 c2                	sub    %eax,%edx
  8010ad:	89 d0                	mov    %edx,%eax
  8010af:	c1 e0 02             	shl    $0x2,%eax
  8010b2:	01 d0                	add    %edx,%eax
  8010b4:	01 c0                	add    %eax,%eax
  8010b6:	29 c1                	sub    %eax,%ecx
  8010b8:	89 ca                	mov    %ecx,%edx
  8010ba:	85 d2                	test   %edx,%edx
  8010bc:	75 9c                	jne    80105a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c8:	48                   	dec    %eax
  8010c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010d0:	74 3d                	je     80110f <ltostr+0xe2>
		start = 1 ;
  8010d2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010d9:	eb 34                	jmp    80110f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e1:	01 d0                	add    %edx,%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ee:	01 c2                	add    %eax,%edx
  8010f0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f6:	01 c8                	add    %ecx,%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801102:	01 c2                	add    %eax,%edx
  801104:	8a 45 eb             	mov    -0x15(%ebp),%al
  801107:	88 02                	mov    %al,(%edx)
		start++ ;
  801109:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80110c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80110f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801112:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801115:	7c c4                	jl     8010db <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801117:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	01 d0                	add    %edx,%eax
  80111f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801122:	90                   	nop
  801123:	c9                   	leave  
  801124:	c3                   	ret    

00801125 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80112b:	ff 75 08             	pushl  0x8(%ebp)
  80112e:	e8 49 fa ff ff       	call   800b7c <strlen>
  801133:	83 c4 04             	add    $0x4,%esp
  801136:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801139:	ff 75 0c             	pushl  0xc(%ebp)
  80113c:	e8 3b fa ff ff       	call   800b7c <strlen>
  801141:	83 c4 04             	add    $0x4,%esp
  801144:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801147:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80114e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801155:	eb 17                	jmp    80116e <strcconcat+0x49>
		final[s] = str1[s] ;
  801157:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115a:	8b 45 10             	mov    0x10(%ebp),%eax
  80115d:	01 c2                	add    %eax,%edx
  80115f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	01 c8                	add    %ecx,%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80116b:	ff 45 fc             	incl   -0x4(%ebp)
  80116e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801171:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801174:	7c e1                	jl     801157 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801176:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80117d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801184:	eb 1f                	jmp    8011a5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801186:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801189:	8d 50 01             	lea    0x1(%eax),%edx
  80118c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80118f:	89 c2                	mov    %eax,%edx
  801191:	8b 45 10             	mov    0x10(%ebp),%eax
  801194:	01 c2                	add    %eax,%edx
  801196:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	01 c8                	add    %ecx,%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011a2:	ff 45 f8             	incl   -0x8(%ebp)
  8011a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ab:	7c d9                	jl     801186 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b3:	01 d0                	add    %edx,%eax
  8011b5:	c6 00 00             	movb   $0x0,(%eax)
}
  8011b8:	90                   	nop
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011be:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ca:	8b 00                	mov    (%eax),%eax
  8011cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d6:	01 d0                	add    %edx,%eax
  8011d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011de:	eb 0c                	jmp    8011ec <strsplit+0x31>
			*string++ = 0;
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8d 50 01             	lea    0x1(%eax),%edx
  8011e6:	89 55 08             	mov    %edx,0x8(%ebp)
  8011e9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	8a 00                	mov    (%eax),%al
  8011f1:	84 c0                	test   %al,%al
  8011f3:	74 18                	je     80120d <strsplit+0x52>
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	0f be c0             	movsbl %al,%eax
  8011fd:	50                   	push   %eax
  8011fe:	ff 75 0c             	pushl  0xc(%ebp)
  801201:	e8 08 fb ff ff       	call   800d0e <strchr>
  801206:	83 c4 08             	add    $0x8,%esp
  801209:	85 c0                	test   %eax,%eax
  80120b:	75 d3                	jne    8011e0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	84 c0                	test   %al,%al
  801214:	74 5a                	je     801270 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801216:	8b 45 14             	mov    0x14(%ebp),%eax
  801219:	8b 00                	mov    (%eax),%eax
  80121b:	83 f8 0f             	cmp    $0xf,%eax
  80121e:	75 07                	jne    801227 <strsplit+0x6c>
		{
			return 0;
  801220:	b8 00 00 00 00       	mov    $0x0,%eax
  801225:	eb 66                	jmp    80128d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801227:	8b 45 14             	mov    0x14(%ebp),%eax
  80122a:	8b 00                	mov    (%eax),%eax
  80122c:	8d 48 01             	lea    0x1(%eax),%ecx
  80122f:	8b 55 14             	mov    0x14(%ebp),%edx
  801232:	89 0a                	mov    %ecx,(%edx)
  801234:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123b:	8b 45 10             	mov    0x10(%ebp),%eax
  80123e:	01 c2                	add    %eax,%edx
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801245:	eb 03                	jmp    80124a <strsplit+0x8f>
			string++;
  801247:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	84 c0                	test   %al,%al
  801251:	74 8b                	je     8011de <strsplit+0x23>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	0f be c0             	movsbl %al,%eax
  80125b:	50                   	push   %eax
  80125c:	ff 75 0c             	pushl  0xc(%ebp)
  80125f:	e8 aa fa ff ff       	call   800d0e <strchr>
  801264:	83 c4 08             	add    $0x8,%esp
  801267:	85 c0                	test   %eax,%eax
  801269:	74 dc                	je     801247 <strsplit+0x8c>
			string++;
	}
  80126b:	e9 6e ff ff ff       	jmp    8011de <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801270:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801271:	8b 45 14             	mov    0x14(%ebp),%eax
  801274:	8b 00                	mov    (%eax),%eax
  801276:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127d:	8b 45 10             	mov    0x10(%ebp),%eax
  801280:	01 d0                	add    %edx,%eax
  801282:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801288:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  801295:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801299:	74 06                	je     8012a1 <str2lower+0x12>
  80129b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80129f:	75 07                	jne    8012a8 <str2lower+0x19>
		return NULL;
  8012a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a6:	eb 4d                	jmp    8012f5 <str2lower+0x66>
	}
	char *ref=dst;
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  8012ae:	eb 33                	jmp    8012e3 <str2lower+0x54>
			if(*src>=65&&*src<=90){
  8012b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	3c 40                	cmp    $0x40,%al
  8012b7:	7e 1a                	jle    8012d3 <str2lower+0x44>
  8012b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	3c 5a                	cmp    $0x5a,%al
  8012c0:	7f 11                	jg     8012d3 <str2lower+0x44>
				*dst=*src+32;
  8012c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	83 c0 20             	add    $0x20,%eax
  8012ca:	88 c2                	mov    %al,%dl
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	88 10                	mov    %dl,(%eax)
  8012d1:	eb 0a                	jmp    8012dd <str2lower+0x4e>
			}
			else{
				*dst=*src;
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	8a 10                	mov    (%eax),%dl
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	88 10                	mov    %dl,(%eax)
			}
			src++;
  8012dd:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  8012e0:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  8012e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e6:	8a 00                	mov    (%eax),%al
  8012e8:	84 c0                	test   %al,%al
  8012ea:	75 c4                	jne    8012b0 <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  8012f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012f5:	c9                   	leave  
  8012f6:	c3                   	ret    

008012f7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	57                   	push   %edi
  8012fb:	56                   	push   %esi
  8012fc:	53                   	push   %ebx
  8012fd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8b 55 0c             	mov    0xc(%ebp),%edx
  801306:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801309:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80130c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80130f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801312:	cd 30                	int    $0x30
  801314:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801317:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	5b                   	pop    %ebx
  80131e:	5e                   	pop    %esi
  80131f:	5f                   	pop    %edi
  801320:	5d                   	pop    %ebp
  801321:	c3                   	ret    

00801322 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	83 ec 04             	sub    $0x4,%esp
  801328:	8b 45 10             	mov    0x10(%ebp),%eax
  80132b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80132e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	52                   	push   %edx
  80133a:	ff 75 0c             	pushl  0xc(%ebp)
  80133d:	50                   	push   %eax
  80133e:	6a 00                	push   $0x0
  801340:	e8 b2 ff ff ff       	call   8012f7 <syscall>
  801345:	83 c4 18             	add    $0x18,%esp
}
  801348:	90                   	nop
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <sys_cgetc>:

int
sys_cgetc(void)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 01                	push   $0x1
  80135a:	e8 98 ff ff ff       	call   8012f7 <syscall>
  80135f:	83 c4 18             	add    $0x18,%esp
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	52                   	push   %edx
  801374:	50                   	push   %eax
  801375:	6a 05                	push   $0x5
  801377:	e8 7b ff ff ff       	call   8012f7 <syscall>
  80137c:	83 c4 18             	add    $0x18,%esp
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	56                   	push   %esi
  801385:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801386:	8b 75 18             	mov    0x18(%ebp),%esi
  801389:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80138c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80138f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	56                   	push   %esi
  801396:	53                   	push   %ebx
  801397:	51                   	push   %ecx
  801398:	52                   	push   %edx
  801399:	50                   	push   %eax
  80139a:	6a 06                	push   $0x6
  80139c:	e8 56 ff ff ff       	call   8012f7 <syscall>
  8013a1:	83 c4 18             	add    $0x18,%esp
}
  8013a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013a7:	5b                   	pop    %ebx
  8013a8:	5e                   	pop    %esi
  8013a9:	5d                   	pop    %ebp
  8013aa:	c3                   	ret    

008013ab <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 00                	push   $0x0
  8013ba:	52                   	push   %edx
  8013bb:	50                   	push   %eax
  8013bc:	6a 07                	push   $0x7
  8013be:	e8 34 ff ff ff       	call   8012f7 <syscall>
  8013c3:	83 c4 18             	add    $0x18,%esp
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	ff 75 0c             	pushl  0xc(%ebp)
  8013d4:	ff 75 08             	pushl  0x8(%ebp)
  8013d7:	6a 08                	push   $0x8
  8013d9:	e8 19 ff ff ff       	call   8012f7 <syscall>
  8013de:	83 c4 18             	add    $0x18,%esp
}
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    

008013e3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 09                	push   $0x9
  8013f2:	e8 00 ff ff ff       	call   8012f7 <syscall>
  8013f7:	83 c4 18             	add    $0x18,%esp
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 0a                	push   $0xa
  80140b:	e8 e7 fe ff ff       	call   8012f7 <syscall>
  801410:	83 c4 18             	add    $0x18,%esp
}
  801413:	c9                   	leave  
  801414:	c3                   	ret    

00801415 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 0b                	push   $0xb
  801424:	e8 ce fe ff ff       	call   8012f7 <syscall>
  801429:	83 c4 18             	add    $0x18,%esp
}
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 0c                	push   $0xc
  80143d:	e8 b5 fe ff ff       	call   8012f7 <syscall>
  801442:	83 c4 18             	add    $0x18,%esp
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	ff 75 08             	pushl  0x8(%ebp)
  801455:	6a 0d                	push   $0xd
  801457:	e8 9b fe ff ff       	call   8012f7 <syscall>
  80145c:	83 c4 18             	add    $0x18,%esp
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 0e                	push   $0xe
  801470:	e8 82 fe ff ff       	call   8012f7 <syscall>
  801475:	83 c4 18             	add    $0x18,%esp
}
  801478:	90                   	nop
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 11                	push   $0x11
  80148a:	e8 68 fe ff ff       	call   8012f7 <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
}
  801492:	90                   	nop
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 12                	push   $0x12
  8014a4:	e8 4e fe ff ff       	call   8012f7 <syscall>
  8014a9:	83 c4 18             	add    $0x18,%esp
}
  8014ac:	90                   	nop
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <sys_cputc>:


void
sys_cputc(const char c)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	83 ec 04             	sub    $0x4,%esp
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014bb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	50                   	push   %eax
  8014c8:	6a 13                	push   $0x13
  8014ca:	e8 28 fe ff ff       	call   8012f7 <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 14                	push   $0x14
  8014e4:	e8 0e fe ff ff       	call   8012f7 <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	90                   	nop
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	ff 75 0c             	pushl  0xc(%ebp)
  8014fe:	50                   	push   %eax
  8014ff:	6a 15                	push   $0x15
  801501:	e8 f1 fd ff ff       	call   8012f7 <syscall>
  801506:	83 c4 18             	add    $0x18,%esp
}
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80150e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	52                   	push   %edx
  80151b:	50                   	push   %eax
  80151c:	6a 18                	push   $0x18
  80151e:	e8 d4 fd ff ff       	call   8012f7 <syscall>
  801523:	83 c4 18             	add    $0x18,%esp
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80152b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	52                   	push   %edx
  801538:	50                   	push   %eax
  801539:	6a 16                	push   $0x16
  80153b:	e8 b7 fd ff ff       	call   8012f7 <syscall>
  801540:	83 c4 18             	add    $0x18,%esp
}
  801543:	90                   	nop
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801549:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	52                   	push   %edx
  801556:	50                   	push   %eax
  801557:	6a 17                	push   $0x17
  801559:	e8 99 fd ff ff       	call   8012f7 <syscall>
  80155e:	83 c4 18             	add    $0x18,%esp
}
  801561:	90                   	nop
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	8b 45 10             	mov    0x10(%ebp),%eax
  80156d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801570:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801573:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	6a 00                	push   $0x0
  80157c:	51                   	push   %ecx
  80157d:	52                   	push   %edx
  80157e:	ff 75 0c             	pushl  0xc(%ebp)
  801581:	50                   	push   %eax
  801582:	6a 19                	push   $0x19
  801584:	e8 6e fd ff ff       	call   8012f7 <syscall>
  801589:	83 c4 18             	add    $0x18,%esp
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801591:	8b 55 0c             	mov    0xc(%ebp),%edx
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	52                   	push   %edx
  80159e:	50                   	push   %eax
  80159f:	6a 1a                	push   $0x1a
  8015a1:	e8 51 fd ff ff       	call   8012f7 <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	51                   	push   %ecx
  8015bc:	52                   	push   %edx
  8015bd:	50                   	push   %eax
  8015be:	6a 1b                	push   $0x1b
  8015c0:	e8 32 fd ff ff       	call   8012f7 <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	52                   	push   %edx
  8015da:	50                   	push   %eax
  8015db:	6a 1c                	push   $0x1c
  8015dd:	e8 15 fd ff ff       	call   8012f7 <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 1d                	push   $0x1d
  8015f6:	e8 fc fc ff ff       	call   8012f7 <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	6a 00                	push   $0x0
  801608:	ff 75 14             	pushl  0x14(%ebp)
  80160b:	ff 75 10             	pushl  0x10(%ebp)
  80160e:	ff 75 0c             	pushl  0xc(%ebp)
  801611:	50                   	push   %eax
  801612:	6a 1e                	push   $0x1e
  801614:	e8 de fc ff ff       	call   8012f7 <syscall>
  801619:	83 c4 18             	add    $0x18,%esp
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	50                   	push   %eax
  80162d:	6a 1f                	push   $0x1f
  80162f:	e8 c3 fc ff ff       	call   8012f7 <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
}
  801637:	90                   	nop
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	50                   	push   %eax
  801649:	6a 20                	push   $0x20
  80164b:	e8 a7 fc ff ff       	call   8012f7 <syscall>
  801650:	83 c4 18             	add    $0x18,%esp
}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 02                	push   $0x2
  801664:	e8 8e fc ff ff       	call   8012f7 <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 03                	push   $0x3
  80167d:	e8 75 fc ff ff       	call   8012f7 <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 04                	push   $0x4
  801696:	e8 5c fc ff ff       	call   8012f7 <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_exit_env>:


void sys_exit_env(void)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 21                	push   $0x21
  8016af:	e8 43 fc ff ff       	call   8012f7 <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
}
  8016b7:	90                   	nop
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016c0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016c3:	8d 50 04             	lea    0x4(%eax),%edx
  8016c6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	52                   	push   %edx
  8016d0:	50                   	push   %eax
  8016d1:	6a 22                	push   $0x22
  8016d3:	e8 1f fc ff ff       	call   8012f7 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
	return result;
  8016db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e4:	89 01                	mov    %eax,(%ecx)
  8016e6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	c9                   	leave  
  8016ed:	c2 04 00             	ret    $0x4

008016f0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	ff 75 10             	pushl  0x10(%ebp)
  8016fa:	ff 75 0c             	pushl  0xc(%ebp)
  8016fd:	ff 75 08             	pushl  0x8(%ebp)
  801700:	6a 10                	push   $0x10
  801702:	e8 f0 fb ff ff       	call   8012f7 <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
	return ;
  80170a:	90                   	nop
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_rcr2>:
uint32 sys_rcr2()
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 23                	push   $0x23
  80171c:	e8 d6 fb ff ff       	call   8012f7 <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 04             	sub    $0x4,%esp
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801732:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	50                   	push   %eax
  80173f:	6a 24                	push   $0x24
  801741:	e8 b1 fb ff ff       	call   8012f7 <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
	return ;
  801749:	90                   	nop
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <rsttst>:
void rsttst()
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 26                	push   $0x26
  80175b:	e8 97 fb ff ff       	call   8012f7 <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
	return ;
  801763:	90                   	nop
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 04             	sub    $0x4,%esp
  80176c:	8b 45 14             	mov    0x14(%ebp),%eax
  80176f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801772:	8b 55 18             	mov    0x18(%ebp),%edx
  801775:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801779:	52                   	push   %edx
  80177a:	50                   	push   %eax
  80177b:	ff 75 10             	pushl  0x10(%ebp)
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	ff 75 08             	pushl  0x8(%ebp)
  801784:	6a 25                	push   $0x25
  801786:	e8 6c fb ff ff       	call   8012f7 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
	return ;
  80178e:	90                   	nop
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <chktst>:
void chktst(uint32 n)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	ff 75 08             	pushl  0x8(%ebp)
  80179f:	6a 27                	push   $0x27
  8017a1:	e8 51 fb ff ff       	call   8012f7 <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a9:	90                   	nop
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <inctst>:

void inctst()
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 28                	push   $0x28
  8017bb:	e8 37 fb ff ff       	call   8012f7 <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c3:	90                   	nop
}
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <gettst>:
uint32 gettst()
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 29                	push   $0x29
  8017d5:	e8 1d fb ff ff       	call   8012f7 <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 2a                	push   $0x2a
  8017f1:	e8 01 fb ff ff       	call   8012f7 <syscall>
  8017f6:	83 c4 18             	add    $0x18,%esp
  8017f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017fc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801800:	75 07                	jne    801809 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801802:	b8 01 00 00 00       	mov    $0x1,%eax
  801807:	eb 05                	jmp    80180e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801809:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 2a                	push   $0x2a
  801822:	e8 d0 fa ff ff       	call   8012f7 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
  80182a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80182d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801831:	75 07                	jne    80183a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801833:	b8 01 00 00 00       	mov    $0x1,%eax
  801838:	eb 05                	jmp    80183f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80183a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 2a                	push   $0x2a
  801853:	e8 9f fa ff ff       	call   8012f7 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
  80185b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80185e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801862:	75 07                	jne    80186b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801864:	b8 01 00 00 00       	mov    $0x1,%eax
  801869:	eb 05                	jmp    801870 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80186b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 2a                	push   $0x2a
  801884:	e8 6e fa ff ff       	call   8012f7 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
  80188c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80188f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801893:	75 07                	jne    80189c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801895:	b8 01 00 00 00       	mov    $0x1,%eax
  80189a:	eb 05                	jmp    8018a1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80189c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	ff 75 08             	pushl  0x8(%ebp)
  8018b1:	6a 2b                	push   $0x2b
  8018b3:	e8 3f fa ff ff       	call   8012f7 <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018bb:	90                   	nop
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	6a 00                	push   $0x0
  8018d0:	53                   	push   %ebx
  8018d1:	51                   	push   %ecx
  8018d2:	52                   	push   %edx
  8018d3:	50                   	push   %eax
  8018d4:	6a 2c                	push   $0x2c
  8018d6:	e8 1c fa ff ff       	call   8012f7 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	52                   	push   %edx
  8018f3:	50                   	push   %eax
  8018f4:	6a 2d                	push   $0x2d
  8018f6:	e8 fc f9 ff ff       	call   8012f7 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801903:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801906:	8b 55 0c             	mov    0xc(%ebp),%edx
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	6a 00                	push   $0x0
  80190e:	51                   	push   %ecx
  80190f:	ff 75 10             	pushl  0x10(%ebp)
  801912:	52                   	push   %edx
  801913:	50                   	push   %eax
  801914:	6a 2e                	push   $0x2e
  801916:	e8 dc f9 ff ff       	call   8012f7 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	ff 75 10             	pushl  0x10(%ebp)
  80192a:	ff 75 0c             	pushl  0xc(%ebp)
  80192d:	ff 75 08             	pushl  0x8(%ebp)
  801930:	6a 0f                	push   $0xf
  801932:	e8 c0 f9 ff ff       	call   8012f7 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
	return ;
  80193a:	90                   	nop
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	50                   	push   %eax
  80194c:	6a 2f                	push   $0x2f
  80194e:	e8 a4 f9 ff ff       	call   8012f7 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	ff 75 0c             	pushl  0xc(%ebp)
  801964:	ff 75 08             	pushl  0x8(%ebp)
  801967:	6a 30                	push   $0x30
  801969:	e8 89 f9 ff ff       	call   8012f7 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801971:	90                   	nop
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	ff 75 0c             	pushl  0xc(%ebp)
  801980:	ff 75 08             	pushl  0x8(%ebp)
  801983:	6a 31                	push   $0x31
  801985:	e8 6d f9 ff ff       	call   8012f7 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  80198d:	90                   	nop
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801996:	8b 55 08             	mov    0x8(%ebp),%edx
  801999:	89 d0                	mov    %edx,%eax
  80199b:	c1 e0 02             	shl    $0x2,%eax
  80199e:	01 d0                	add    %edx,%eax
  8019a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a7:	01 d0                	add    %edx,%eax
  8019a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b0:	01 d0                	add    %edx,%eax
  8019b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b9:	01 d0                	add    %edx,%eax
  8019bb:	c1 e0 04             	shl    $0x4,%eax
  8019be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8019c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8019c8:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8019cb:	83 ec 0c             	sub    $0xc,%esp
  8019ce:	50                   	push   %eax
  8019cf:	e8 e6 fc ff ff       	call   8016ba <sys_get_virtual_time>
  8019d4:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8019d7:	eb 41                	jmp    801a1a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8019d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019dc:	83 ec 0c             	sub    $0xc,%esp
  8019df:	50                   	push   %eax
  8019e0:	e8 d5 fc ff ff       	call   8016ba <sys_get_virtual_time>
  8019e5:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019ee:	29 c2                	sub    %eax,%edx
  8019f0:	89 d0                	mov    %edx,%eax
  8019f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019fb:	89 d1                	mov    %edx,%ecx
  8019fd:	29 c1                	sub    %eax,%ecx
  8019ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a05:	39 c2                	cmp    %eax,%edx
  801a07:	0f 97 c0             	seta   %al
  801a0a:	0f b6 c0             	movzbl %al,%eax
  801a0d:	29 c1                	sub    %eax,%ecx
  801a0f:	89 c8                	mov    %ecx,%eax
  801a11:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a14:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a20:	72 b7                	jb     8019d9 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a22:	90                   	nop
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a32:	eb 03                	jmp    801a37 <busy_wait+0x12>
  801a34:	ff 45 fc             	incl   -0x4(%ebp)
  801a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a3d:	72 f5                	jb     801a34 <busy_wait+0xf>
	return i;
  801a3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a50:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a54:	83 ec 0c             	sub    $0xc,%esp
  801a57:	50                   	push   %eax
  801a58:	e8 52 fa ff ff       	call   8014af <sys_cputc>
  801a5d:	83 c4 10             	add    $0x10,%esp
}
  801a60:	90                   	nop
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801a69:	e8 0d fa ff ff       	call   80147b <sys_disable_interrupt>
	char c = ch;
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a74:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	50                   	push   %eax
  801a7c:	e8 2e fa ff ff       	call   8014af <sys_cputc>
  801a81:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801a84:	e8 0c fa ff ff       	call   801495 <sys_enable_interrupt>
}
  801a89:	90                   	nop
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <getchar>:

int
getchar(void)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  801a92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801a99:	eb 08                	jmp    801aa3 <getchar+0x17>
	{
		c = sys_cgetc();
  801a9b:	e8 ab f8 ff ff       	call   80134b <sys_cgetc>
  801aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  801aa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aa7:	74 f2                	je     801a9b <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  801aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <atomic_getchar>:

int
atomic_getchar(void)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801ab4:	e8 c2 f9 ff ff       	call   80147b <sys_disable_interrupt>
	int c=0;
  801ab9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801ac0:	eb 08                	jmp    801aca <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801ac2:	e8 84 f8 ff ff       	call   80134b <sys_cgetc>
  801ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801aca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ace:	74 f2                	je     801ac2 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801ad0:	e8 c0 f9 ff ff       	call   801495 <sys_enable_interrupt>
	return c;
  801ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <iscons>:

int iscons(int fdnum)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801add:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    

00801ae4 <__udivdi3>:
  801ae4:	55                   	push   %ebp
  801ae5:	57                   	push   %edi
  801ae6:	56                   	push   %esi
  801ae7:	53                   	push   %ebx
  801ae8:	83 ec 1c             	sub    $0x1c,%esp
  801aeb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801aef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801af3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801af7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801afb:	89 ca                	mov    %ecx,%edx
  801afd:	89 f8                	mov    %edi,%eax
  801aff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b03:	85 f6                	test   %esi,%esi
  801b05:	75 2d                	jne    801b34 <__udivdi3+0x50>
  801b07:	39 cf                	cmp    %ecx,%edi
  801b09:	77 65                	ja     801b70 <__udivdi3+0x8c>
  801b0b:	89 fd                	mov    %edi,%ebp
  801b0d:	85 ff                	test   %edi,%edi
  801b0f:	75 0b                	jne    801b1c <__udivdi3+0x38>
  801b11:	b8 01 00 00 00       	mov    $0x1,%eax
  801b16:	31 d2                	xor    %edx,%edx
  801b18:	f7 f7                	div    %edi
  801b1a:	89 c5                	mov    %eax,%ebp
  801b1c:	31 d2                	xor    %edx,%edx
  801b1e:	89 c8                	mov    %ecx,%eax
  801b20:	f7 f5                	div    %ebp
  801b22:	89 c1                	mov    %eax,%ecx
  801b24:	89 d8                	mov    %ebx,%eax
  801b26:	f7 f5                	div    %ebp
  801b28:	89 cf                	mov    %ecx,%edi
  801b2a:	89 fa                	mov    %edi,%edx
  801b2c:	83 c4 1c             	add    $0x1c,%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5e                   	pop    %esi
  801b31:	5f                   	pop    %edi
  801b32:	5d                   	pop    %ebp
  801b33:	c3                   	ret    
  801b34:	39 ce                	cmp    %ecx,%esi
  801b36:	77 28                	ja     801b60 <__udivdi3+0x7c>
  801b38:	0f bd fe             	bsr    %esi,%edi
  801b3b:	83 f7 1f             	xor    $0x1f,%edi
  801b3e:	75 40                	jne    801b80 <__udivdi3+0x9c>
  801b40:	39 ce                	cmp    %ecx,%esi
  801b42:	72 0a                	jb     801b4e <__udivdi3+0x6a>
  801b44:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b48:	0f 87 9e 00 00 00    	ja     801bec <__udivdi3+0x108>
  801b4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b53:	89 fa                	mov    %edi,%edx
  801b55:	83 c4 1c             	add    $0x1c,%esp
  801b58:	5b                   	pop    %ebx
  801b59:	5e                   	pop    %esi
  801b5a:	5f                   	pop    %edi
  801b5b:	5d                   	pop    %ebp
  801b5c:	c3                   	ret    
  801b5d:	8d 76 00             	lea    0x0(%esi),%esi
  801b60:	31 ff                	xor    %edi,%edi
  801b62:	31 c0                	xor    %eax,%eax
  801b64:	89 fa                	mov    %edi,%edx
  801b66:	83 c4 1c             	add    $0x1c,%esp
  801b69:	5b                   	pop    %ebx
  801b6a:	5e                   	pop    %esi
  801b6b:	5f                   	pop    %edi
  801b6c:	5d                   	pop    %ebp
  801b6d:	c3                   	ret    
  801b6e:	66 90                	xchg   %ax,%ax
  801b70:	89 d8                	mov    %ebx,%eax
  801b72:	f7 f7                	div    %edi
  801b74:	31 ff                	xor    %edi,%edi
  801b76:	89 fa                	mov    %edi,%edx
  801b78:	83 c4 1c             	add    $0x1c,%esp
  801b7b:	5b                   	pop    %ebx
  801b7c:	5e                   	pop    %esi
  801b7d:	5f                   	pop    %edi
  801b7e:	5d                   	pop    %ebp
  801b7f:	c3                   	ret    
  801b80:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b85:	89 eb                	mov    %ebp,%ebx
  801b87:	29 fb                	sub    %edi,%ebx
  801b89:	89 f9                	mov    %edi,%ecx
  801b8b:	d3 e6                	shl    %cl,%esi
  801b8d:	89 c5                	mov    %eax,%ebp
  801b8f:	88 d9                	mov    %bl,%cl
  801b91:	d3 ed                	shr    %cl,%ebp
  801b93:	89 e9                	mov    %ebp,%ecx
  801b95:	09 f1                	or     %esi,%ecx
  801b97:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b9b:	89 f9                	mov    %edi,%ecx
  801b9d:	d3 e0                	shl    %cl,%eax
  801b9f:	89 c5                	mov    %eax,%ebp
  801ba1:	89 d6                	mov    %edx,%esi
  801ba3:	88 d9                	mov    %bl,%cl
  801ba5:	d3 ee                	shr    %cl,%esi
  801ba7:	89 f9                	mov    %edi,%ecx
  801ba9:	d3 e2                	shl    %cl,%edx
  801bab:	8b 44 24 08          	mov    0x8(%esp),%eax
  801baf:	88 d9                	mov    %bl,%cl
  801bb1:	d3 e8                	shr    %cl,%eax
  801bb3:	09 c2                	or     %eax,%edx
  801bb5:	89 d0                	mov    %edx,%eax
  801bb7:	89 f2                	mov    %esi,%edx
  801bb9:	f7 74 24 0c          	divl   0xc(%esp)
  801bbd:	89 d6                	mov    %edx,%esi
  801bbf:	89 c3                	mov    %eax,%ebx
  801bc1:	f7 e5                	mul    %ebp
  801bc3:	39 d6                	cmp    %edx,%esi
  801bc5:	72 19                	jb     801be0 <__udivdi3+0xfc>
  801bc7:	74 0b                	je     801bd4 <__udivdi3+0xf0>
  801bc9:	89 d8                	mov    %ebx,%eax
  801bcb:	31 ff                	xor    %edi,%edi
  801bcd:	e9 58 ff ff ff       	jmp    801b2a <__udivdi3+0x46>
  801bd2:	66 90                	xchg   %ax,%ax
  801bd4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bd8:	89 f9                	mov    %edi,%ecx
  801bda:	d3 e2                	shl    %cl,%edx
  801bdc:	39 c2                	cmp    %eax,%edx
  801bde:	73 e9                	jae    801bc9 <__udivdi3+0xe5>
  801be0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801be3:	31 ff                	xor    %edi,%edi
  801be5:	e9 40 ff ff ff       	jmp    801b2a <__udivdi3+0x46>
  801bea:	66 90                	xchg   %ax,%ax
  801bec:	31 c0                	xor    %eax,%eax
  801bee:	e9 37 ff ff ff       	jmp    801b2a <__udivdi3+0x46>
  801bf3:	90                   	nop

00801bf4 <__umoddi3>:
  801bf4:	55                   	push   %ebp
  801bf5:	57                   	push   %edi
  801bf6:	56                   	push   %esi
  801bf7:	53                   	push   %ebx
  801bf8:	83 ec 1c             	sub    $0x1c,%esp
  801bfb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c07:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c13:	89 f3                	mov    %esi,%ebx
  801c15:	89 fa                	mov    %edi,%edx
  801c17:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c1b:	89 34 24             	mov    %esi,(%esp)
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	75 1a                	jne    801c3c <__umoddi3+0x48>
  801c22:	39 f7                	cmp    %esi,%edi
  801c24:	0f 86 a2 00 00 00    	jbe    801ccc <__umoddi3+0xd8>
  801c2a:	89 c8                	mov    %ecx,%eax
  801c2c:	89 f2                	mov    %esi,%edx
  801c2e:	f7 f7                	div    %edi
  801c30:	89 d0                	mov    %edx,%eax
  801c32:	31 d2                	xor    %edx,%edx
  801c34:	83 c4 1c             	add    $0x1c,%esp
  801c37:	5b                   	pop    %ebx
  801c38:	5e                   	pop    %esi
  801c39:	5f                   	pop    %edi
  801c3a:	5d                   	pop    %ebp
  801c3b:	c3                   	ret    
  801c3c:	39 f0                	cmp    %esi,%eax
  801c3e:	0f 87 ac 00 00 00    	ja     801cf0 <__umoddi3+0xfc>
  801c44:	0f bd e8             	bsr    %eax,%ebp
  801c47:	83 f5 1f             	xor    $0x1f,%ebp
  801c4a:	0f 84 ac 00 00 00    	je     801cfc <__umoddi3+0x108>
  801c50:	bf 20 00 00 00       	mov    $0x20,%edi
  801c55:	29 ef                	sub    %ebp,%edi
  801c57:	89 fe                	mov    %edi,%esi
  801c59:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c5d:	89 e9                	mov    %ebp,%ecx
  801c5f:	d3 e0                	shl    %cl,%eax
  801c61:	89 d7                	mov    %edx,%edi
  801c63:	89 f1                	mov    %esi,%ecx
  801c65:	d3 ef                	shr    %cl,%edi
  801c67:	09 c7                	or     %eax,%edi
  801c69:	89 e9                	mov    %ebp,%ecx
  801c6b:	d3 e2                	shl    %cl,%edx
  801c6d:	89 14 24             	mov    %edx,(%esp)
  801c70:	89 d8                	mov    %ebx,%eax
  801c72:	d3 e0                	shl    %cl,%eax
  801c74:	89 c2                	mov    %eax,%edx
  801c76:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c7a:	d3 e0                	shl    %cl,%eax
  801c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c80:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c84:	89 f1                	mov    %esi,%ecx
  801c86:	d3 e8                	shr    %cl,%eax
  801c88:	09 d0                	or     %edx,%eax
  801c8a:	d3 eb                	shr    %cl,%ebx
  801c8c:	89 da                	mov    %ebx,%edx
  801c8e:	f7 f7                	div    %edi
  801c90:	89 d3                	mov    %edx,%ebx
  801c92:	f7 24 24             	mull   (%esp)
  801c95:	89 c6                	mov    %eax,%esi
  801c97:	89 d1                	mov    %edx,%ecx
  801c99:	39 d3                	cmp    %edx,%ebx
  801c9b:	0f 82 87 00 00 00    	jb     801d28 <__umoddi3+0x134>
  801ca1:	0f 84 91 00 00 00    	je     801d38 <__umoddi3+0x144>
  801ca7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801cab:	29 f2                	sub    %esi,%edx
  801cad:	19 cb                	sbb    %ecx,%ebx
  801caf:	89 d8                	mov    %ebx,%eax
  801cb1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cb5:	d3 e0                	shl    %cl,%eax
  801cb7:	89 e9                	mov    %ebp,%ecx
  801cb9:	d3 ea                	shr    %cl,%edx
  801cbb:	09 d0                	or     %edx,%eax
  801cbd:	89 e9                	mov    %ebp,%ecx
  801cbf:	d3 eb                	shr    %cl,%ebx
  801cc1:	89 da                	mov    %ebx,%edx
  801cc3:	83 c4 1c             	add    $0x1c,%esp
  801cc6:	5b                   	pop    %ebx
  801cc7:	5e                   	pop    %esi
  801cc8:	5f                   	pop    %edi
  801cc9:	5d                   	pop    %ebp
  801cca:	c3                   	ret    
  801ccb:	90                   	nop
  801ccc:	89 fd                	mov    %edi,%ebp
  801cce:	85 ff                	test   %edi,%edi
  801cd0:	75 0b                	jne    801cdd <__umoddi3+0xe9>
  801cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd7:	31 d2                	xor    %edx,%edx
  801cd9:	f7 f7                	div    %edi
  801cdb:	89 c5                	mov    %eax,%ebp
  801cdd:	89 f0                	mov    %esi,%eax
  801cdf:	31 d2                	xor    %edx,%edx
  801ce1:	f7 f5                	div    %ebp
  801ce3:	89 c8                	mov    %ecx,%eax
  801ce5:	f7 f5                	div    %ebp
  801ce7:	89 d0                	mov    %edx,%eax
  801ce9:	e9 44 ff ff ff       	jmp    801c32 <__umoddi3+0x3e>
  801cee:	66 90                	xchg   %ax,%ax
  801cf0:	89 c8                	mov    %ecx,%eax
  801cf2:	89 f2                	mov    %esi,%edx
  801cf4:	83 c4 1c             	add    $0x1c,%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5f                   	pop    %edi
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    
  801cfc:	3b 04 24             	cmp    (%esp),%eax
  801cff:	72 06                	jb     801d07 <__umoddi3+0x113>
  801d01:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d05:	77 0f                	ja     801d16 <__umoddi3+0x122>
  801d07:	89 f2                	mov    %esi,%edx
  801d09:	29 f9                	sub    %edi,%ecx
  801d0b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d0f:	89 14 24             	mov    %edx,(%esp)
  801d12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d16:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d1a:	8b 14 24             	mov    (%esp),%edx
  801d1d:	83 c4 1c             	add    $0x1c,%esp
  801d20:	5b                   	pop    %ebx
  801d21:	5e                   	pop    %esi
  801d22:	5f                   	pop    %edi
  801d23:	5d                   	pop    %ebp
  801d24:	c3                   	ret    
  801d25:	8d 76 00             	lea    0x0(%esi),%esi
  801d28:	2b 04 24             	sub    (%esp),%eax
  801d2b:	19 fa                	sbb    %edi,%edx
  801d2d:	89 d1                	mov    %edx,%ecx
  801d2f:	89 c6                	mov    %eax,%esi
  801d31:	e9 71 ff ff ff       	jmp    801ca7 <__umoddi3+0xb3>
  801d36:	66 90                	xchg   %ax,%ax
  801d38:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d3c:	72 ea                	jb     801d28 <__umoddi3+0x134>
  801d3e:	89 d9                	mov    %ebx,%ecx
  801d40:	e9 62 ff ff ff       	jmp    801ca7 <__umoddi3+0xb3>
