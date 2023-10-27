
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
  800059:	68 40 1d 80 00       	push   $0x801d40
  80005e:	e8 11 0a 00 00       	call   800a74 <atomic_readline>
  800063:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 0a                	push   $0xa
  80006b:	6a 00                	push   $0x0
  80006d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800073:	50                   	push   %eax
  800074:	e8 63 0e 00 00       	call   800edc <strtol>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//sleep
	env_sleep(2800);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 f0 0a 00 00       	push   $0xaf0
  800087:	e8 f9 18 00 00       	call   801985 <env_sleep>
  80008c:	83 c4 10             	add    $0x10,%esp

	atomic_readline("Please enter second number :", buff2);
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	68 5c 1d 80 00       	push   $0x801d5c
  80009e:	e8 d1 09 00 00       	call   800a74 <atomic_readline>
  8000a3:	83 c4 10             	add    $0x10,%esp
	
	i2 = strtol(buff2, NULL, 10);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 0a                	push   $0xa
  8000ab:	6a 00                	push   $0x0
  8000ad:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8000b3:	50                   	push   %eax
  8000b4:	e8 23 0e 00 00       	call   800edc <strtol>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  8000bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 79 1d 80 00       	push   $0x801d79
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
  8000e1:	e8 7d 15 00 00       	call   801663 <sys_getenvindex>
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
  800155:	e8 16 13 00 00       	call   801470 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 ac 1d 80 00       	push   $0x801dac
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
  800185:	68 d4 1d 80 00       	push   $0x801dd4
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
  8001b6:	68 fc 1d 80 00       	push   $0x801dfc
  8001bb:	e8 34 01 00 00       	call   8002f4 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c8:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	50                   	push   %eax
  8001d2:	68 54 1e 80 00       	push   $0x801e54
  8001d7:	e8 18 01 00 00       	call   8002f4 <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001df:	83 ec 0c             	sub    $0xc,%esp
  8001e2:	68 ac 1d 80 00       	push   $0x801dac
  8001e7:	e8 08 01 00 00       	call   8002f4 <cprintf>
  8001ec:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ef:	e8 96 12 00 00       	call   80148a <sys_enable_interrupt>

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
  800207:	e8 23 14 00 00       	call   80162f <sys_destroy_env>
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
  800218:	e8 78 14 00 00       	call   801695 <sys_exit_env>
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
  800266:	e8 ac 10 00 00       	call   801317 <sys_cputs>
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
  8002dd:	e8 35 10 00 00       	call   801317 <sys_cputs>
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
  800327:	e8 44 11 00 00       	call   801470 <sys_disable_interrupt>
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
  800347:	e8 3e 11 00 00       	call   80148a <sys_enable_interrupt>
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
  800391:	e8 46 17 00 00       	call   801adc <__udivdi3>
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
  8003e1:	e8 06 18 00 00       	call   801bec <__umoddi3>
  8003e6:	83 c4 10             	add    $0x10,%esp
  8003e9:	05 94 20 80 00       	add    $0x802094,%eax
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
  80053c:	8b 04 85 b8 20 80 00 	mov    0x8020b8(,%eax,4),%eax
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
  80061d:	8b 34 9d 00 1f 80 00 	mov    0x801f00(,%ebx,4),%esi
  800624:	85 f6                	test   %esi,%esi
  800626:	75 19                	jne    800641 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800628:	53                   	push   %ebx
  800629:	68 a5 20 80 00       	push   $0x8020a5
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
  800642:	68 ae 20 80 00       	push   $0x8020ae
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
  80066f:	be b1 20 80 00       	mov    $0x8020b1,%esi
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
  800988:	68 10 22 80 00       	push   $0x802210
  80098d:	e8 62 f9 ff ff       	call   8002f4 <cprintf>
  800992:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800995:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80099c:	83 ec 0c             	sub    $0xc,%esp
  80099f:	6a 00                	push   $0x0
  8009a1:	e8 29 11 00 00       	call   801acf <iscons>
  8009a6:	83 c4 10             	add    $0x10,%esp
  8009a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009ac:	e8 d0 10 00 00       	call   801a81 <getchar>
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
  8009ca:	68 13 22 80 00       	push   $0x802213
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
  8009f7:	e8 3d 10 00 00       	call   801a39 <cputchar>
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
  800a2e:	e8 06 10 00 00       	call   801a39 <cputchar>
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
  800a57:	e8 dd 0f 00 00       	call   801a39 <cputchar>
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
  800a7a:	e8 f1 09 00 00       	call   801470 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a83:	74 13                	je     800a98 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a85:	83 ec 08             	sub    $0x8,%esp
  800a88:	ff 75 08             	pushl  0x8(%ebp)
  800a8b:	68 10 22 80 00       	push   $0x802210
  800a90:	e8 5f f8 ff ff       	call   8002f4 <cprintf>
  800a95:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a9f:	83 ec 0c             	sub    $0xc,%esp
  800aa2:	6a 00                	push   $0x0
  800aa4:	e8 26 10 00 00       	call   801acf <iscons>
  800aa9:	83 c4 10             	add    $0x10,%esp
  800aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800aaf:	e8 cd 0f 00 00       	call   801a81 <getchar>
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
  800ac9:	68 13 22 80 00       	push   $0x802213
  800ace:	e8 21 f8 ff ff       	call   8002f4 <cprintf>
  800ad3:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800ad6:	e8 af 09 00 00       	call   80148a <sys_enable_interrupt>
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
  800afb:	e8 39 0f 00 00       	call   801a39 <cputchar>
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
  800b32:	e8 02 0f 00 00       	call   801a39 <cputchar>
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
  800b5b:	e8 d9 0e 00 00       	call   801a39 <cputchar>
  800b60:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	01 d0                	add    %edx,%eax
  800b6b:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b6e:	e8 17 09 00 00       	call   80148a <sys_enable_interrupt>
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


void *
memset(void *v, int c, uint32 n)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d76:	8b 45 10             	mov    0x10(%ebp),%eax
  800d79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d7c:	eb 0e                	jmp    800d8c <memset+0x22>
		*p++ = c;
  800d7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d81:	8d 50 01             	lea    0x1(%eax),%edx
  800d84:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d8c:	ff 4d f8             	decl   -0x8(%ebp)
  800d8f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d93:	79 e9                	jns    800d7e <memset+0x14>
		*p++ = c;

	return v;
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d98:	c9                   	leave  
  800d99:	c3                   	ret    

00800d9a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dac:	eb 16                	jmp    800dc4 <memcpy+0x2a>
		*d++ = *s++;
  800dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db1:	8d 50 01             	lea    0x1(%eax),%edx
  800db4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800db7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dba:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dbd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dc0:	8a 12                	mov    (%edx),%dl
  800dc2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dca:	89 55 10             	mov    %edx,0x10(%ebp)
  800dcd:	85 c0                	test   %eax,%eax
  800dcf:	75 dd                	jne    800dae <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800de8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800deb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dee:	73 50                	jae    800e40 <memmove+0x6a>
  800df0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df3:	8b 45 10             	mov    0x10(%ebp),%eax
  800df6:	01 d0                	add    %edx,%eax
  800df8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dfb:	76 43                	jbe    800e40 <memmove+0x6a>
		s += n;
  800dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800e00:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e09:	eb 10                	jmp    800e1b <memmove+0x45>
			*--d = *--s;
  800e0b:	ff 4d f8             	decl   -0x8(%ebp)
  800e0e:	ff 4d fc             	decl   -0x4(%ebp)
  800e11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e14:	8a 10                	mov    (%eax),%dl
  800e16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e19:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e21:	89 55 10             	mov    %edx,0x10(%ebp)
  800e24:	85 c0                	test   %eax,%eax
  800e26:	75 e3                	jne    800e0b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e28:	eb 23                	jmp    800e4d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2d:	8d 50 01             	lea    0x1(%eax),%edx
  800e30:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e36:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e39:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e3c:	8a 12                	mov    (%edx),%dl
  800e3e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e40:	8b 45 10             	mov    0x10(%ebp),%eax
  800e43:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e46:	89 55 10             	mov    %edx,0x10(%ebp)
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	75 dd                	jne    800e2a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e50:	c9                   	leave  
  800e51:	c3                   	ret    

00800e52 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e64:	eb 2a                	jmp    800e90 <memcmp+0x3e>
		if (*s1 != *s2)
  800e66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e69:	8a 10                	mov    (%eax),%dl
  800e6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	38 c2                	cmp    %al,%dl
  800e72:	74 16                	je     800e8a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	0f b6 d0             	movzbl %al,%edx
  800e7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7f:	8a 00                	mov    (%eax),%al
  800e81:	0f b6 c0             	movzbl %al,%eax
  800e84:	29 c2                	sub    %eax,%edx
  800e86:	89 d0                	mov    %edx,%eax
  800e88:	eb 18                	jmp    800ea2 <memcmp+0x50>
		s1++, s2++;
  800e8a:	ff 45 fc             	incl   -0x4(%ebp)
  800e8d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e90:	8b 45 10             	mov    0x10(%ebp),%eax
  800e93:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e96:	89 55 10             	mov    %edx,0x10(%ebp)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	75 c9                	jne    800e66 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eaa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ead:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb0:	01 d0                	add    %edx,%eax
  800eb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eb5:	eb 15                	jmp    800ecc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	0f b6 d0             	movzbl %al,%edx
  800ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec2:	0f b6 c0             	movzbl %al,%eax
  800ec5:	39 c2                	cmp    %eax,%edx
  800ec7:	74 0d                	je     800ed6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ec9:	ff 45 08             	incl   0x8(%ebp)
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ed2:	72 e3                	jb     800eb7 <memfind+0x13>
  800ed4:	eb 01                	jmp    800ed7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ed6:	90                   	nop
	return (void *) s;
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eda:	c9                   	leave  
  800edb:	c3                   	ret    

00800edc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ee2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ee9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ef0:	eb 03                	jmp    800ef5 <strtol+0x19>
		s++;
  800ef2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	3c 20                	cmp    $0x20,%al
  800efc:	74 f4                	je     800ef2 <strtol+0x16>
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	3c 09                	cmp    $0x9,%al
  800f05:	74 eb                	je     800ef2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3c 2b                	cmp    $0x2b,%al
  800f0e:	75 05                	jne    800f15 <strtol+0x39>
		s++;
  800f10:	ff 45 08             	incl   0x8(%ebp)
  800f13:	eb 13                	jmp    800f28 <strtol+0x4c>
	else if (*s == '-')
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	8a 00                	mov    (%eax),%al
  800f1a:	3c 2d                	cmp    $0x2d,%al
  800f1c:	75 0a                	jne    800f28 <strtol+0x4c>
		s++, neg = 1;
  800f1e:	ff 45 08             	incl   0x8(%ebp)
  800f21:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2c:	74 06                	je     800f34 <strtol+0x58>
  800f2e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f32:	75 20                	jne    800f54 <strtol+0x78>
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	3c 30                	cmp    $0x30,%al
  800f3b:	75 17                	jne    800f54 <strtol+0x78>
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	40                   	inc    %eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	3c 78                	cmp    $0x78,%al
  800f45:	75 0d                	jne    800f54 <strtol+0x78>
		s += 2, base = 16;
  800f47:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f4b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f52:	eb 28                	jmp    800f7c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f58:	75 15                	jne    800f6f <strtol+0x93>
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	3c 30                	cmp    $0x30,%al
  800f61:	75 0c                	jne    800f6f <strtol+0x93>
		s++, base = 8;
  800f63:	ff 45 08             	incl   0x8(%ebp)
  800f66:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f6d:	eb 0d                	jmp    800f7c <strtol+0xa0>
	else if (base == 0)
  800f6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f73:	75 07                	jne    800f7c <strtol+0xa0>
		base = 10;
  800f75:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	3c 2f                	cmp    $0x2f,%al
  800f83:	7e 19                	jle    800f9e <strtol+0xc2>
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 39                	cmp    $0x39,%al
  800f8c:	7f 10                	jg     800f9e <strtol+0xc2>
			dig = *s - '0';
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	0f be c0             	movsbl %al,%eax
  800f96:	83 e8 30             	sub    $0x30,%eax
  800f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f9c:	eb 42                	jmp    800fe0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	3c 60                	cmp    $0x60,%al
  800fa5:	7e 19                	jle    800fc0 <strtol+0xe4>
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	3c 7a                	cmp    $0x7a,%al
  800fae:	7f 10                	jg     800fc0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	0f be c0             	movsbl %al,%eax
  800fb8:	83 e8 57             	sub    $0x57,%eax
  800fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fbe:	eb 20                	jmp    800fe0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 40                	cmp    $0x40,%al
  800fc7:	7e 39                	jle    801002 <strtol+0x126>
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 5a                	cmp    $0x5a,%al
  800fd0:	7f 30                	jg     801002 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	0f be c0             	movsbl %al,%eax
  800fda:	83 e8 37             	sub    $0x37,%eax
  800fdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fe6:	7d 19                	jge    801001 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fe8:	ff 45 08             	incl   0x8(%ebp)
  800feb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fee:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ff2:	89 c2                	mov    %eax,%edx
  800ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff7:	01 d0                	add    %edx,%eax
  800ff9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ffc:	e9 7b ff ff ff       	jmp    800f7c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801001:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801002:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801006:	74 08                	je     801010 <strtol+0x134>
		*endptr = (char *) s;
  801008:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100b:	8b 55 08             	mov    0x8(%ebp),%edx
  80100e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801010:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801014:	74 07                	je     80101d <strtol+0x141>
  801016:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801019:	f7 d8                	neg    %eax
  80101b:	eb 03                	jmp    801020 <strtol+0x144>
  80101d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801020:	c9                   	leave  
  801021:	c3                   	ret    

00801022 <ltostr>:

void
ltostr(long value, char *str)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801028:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80102f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801036:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80103a:	79 13                	jns    80104f <ltostr+0x2d>
	{
		neg = 1;
  80103c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801049:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80104c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801057:	99                   	cltd   
  801058:	f7 f9                	idiv   %ecx
  80105a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80105d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801060:	8d 50 01             	lea    0x1(%eax),%edx
  801063:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801066:	89 c2                	mov    %eax,%edx
  801068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106b:	01 d0                	add    %edx,%eax
  80106d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801070:	83 c2 30             	add    $0x30,%edx
  801073:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801075:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801078:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80107d:	f7 e9                	imul   %ecx
  80107f:	c1 fa 02             	sar    $0x2,%edx
  801082:	89 c8                	mov    %ecx,%eax
  801084:	c1 f8 1f             	sar    $0x1f,%eax
  801087:	29 c2                	sub    %eax,%edx
  801089:	89 d0                	mov    %edx,%eax
  80108b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80108e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801091:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801096:	f7 e9                	imul   %ecx
  801098:	c1 fa 02             	sar    $0x2,%edx
  80109b:	89 c8                	mov    %ecx,%eax
  80109d:	c1 f8 1f             	sar    $0x1f,%eax
  8010a0:	29 c2                	sub    %eax,%edx
  8010a2:	89 d0                	mov    %edx,%eax
  8010a4:	c1 e0 02             	shl    $0x2,%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	01 c0                	add    %eax,%eax
  8010ab:	29 c1                	sub    %eax,%ecx
  8010ad:	89 ca                	mov    %ecx,%edx
  8010af:	85 d2                	test   %edx,%edx
  8010b1:	75 9c                	jne    80104f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	48                   	dec    %eax
  8010be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010c5:	74 3d                	je     801104 <ltostr+0xe2>
		start = 1 ;
  8010c7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010ce:	eb 34                	jmp    801104 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	01 d0                	add    %edx,%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	01 c2                	add    %eax,%edx
  8010e5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	01 c8                	add    %ecx,%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f7:	01 c2                	add    %eax,%edx
  8010f9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010fc:	88 02                	mov    %al,(%edx)
		start++ ;
  8010fe:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801101:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801107:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80110a:	7c c4                	jl     8010d0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80110c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	01 d0                	add    %edx,%eax
  801114:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801117:	90                   	nop
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801120:	ff 75 08             	pushl  0x8(%ebp)
  801123:	e8 54 fa ff ff       	call   800b7c <strlen>
  801128:	83 c4 04             	add    $0x4,%esp
  80112b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80112e:	ff 75 0c             	pushl  0xc(%ebp)
  801131:	e8 46 fa ff ff       	call   800b7c <strlen>
  801136:	83 c4 04             	add    $0x4,%esp
  801139:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80113c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80114a:	eb 17                	jmp    801163 <strcconcat+0x49>
		final[s] = str1[s] ;
  80114c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114f:	8b 45 10             	mov    0x10(%ebp),%eax
  801152:	01 c2                	add    %eax,%edx
  801154:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	01 c8                	add    %ecx,%eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801160:	ff 45 fc             	incl   -0x4(%ebp)
  801163:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801166:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801169:	7c e1                	jl     80114c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80116b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801172:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801179:	eb 1f                	jmp    80119a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80117b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117e:	8d 50 01             	lea    0x1(%eax),%edx
  801181:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801184:	89 c2                	mov    %eax,%edx
  801186:	8b 45 10             	mov    0x10(%ebp),%eax
  801189:	01 c2                	add    %eax,%edx
  80118b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80118e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801191:	01 c8                	add    %ecx,%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801197:	ff 45 f8             	incl   -0x8(%ebp)
  80119a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011a0:	7c d9                	jl     80117b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a8:	01 d0                	add    %edx,%eax
  8011aa:	c6 00 00             	movb   $0x0,(%eax)
}
  8011ad:	90                   	nop
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bf:	8b 00                	mov    (%eax),%eax
  8011c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cb:	01 d0                	add    %edx,%eax
  8011cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d3:	eb 0c                	jmp    8011e1 <strsplit+0x31>
			*string++ = 0;
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8d 50 01             	lea    0x1(%eax),%edx
  8011db:	89 55 08             	mov    %edx,0x8(%ebp)
  8011de:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	84 c0                	test   %al,%al
  8011e8:	74 18                	je     801202 <strsplit+0x52>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	0f be c0             	movsbl %al,%eax
  8011f2:	50                   	push   %eax
  8011f3:	ff 75 0c             	pushl  0xc(%ebp)
  8011f6:	e8 13 fb ff ff       	call   800d0e <strchr>
  8011fb:	83 c4 08             	add    $0x8,%esp
  8011fe:	85 c0                	test   %eax,%eax
  801200:	75 d3                	jne    8011d5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	84 c0                	test   %al,%al
  801209:	74 5a                	je     801265 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80120b:	8b 45 14             	mov    0x14(%ebp),%eax
  80120e:	8b 00                	mov    (%eax),%eax
  801210:	83 f8 0f             	cmp    $0xf,%eax
  801213:	75 07                	jne    80121c <strsplit+0x6c>
		{
			return 0;
  801215:	b8 00 00 00 00       	mov    $0x0,%eax
  80121a:	eb 66                	jmp    801282 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80121c:	8b 45 14             	mov    0x14(%ebp),%eax
  80121f:	8b 00                	mov    (%eax),%eax
  801221:	8d 48 01             	lea    0x1(%eax),%ecx
  801224:	8b 55 14             	mov    0x14(%ebp),%edx
  801227:	89 0a                	mov    %ecx,(%edx)
  801229:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	01 c2                	add    %eax,%edx
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80123a:	eb 03                	jmp    80123f <strsplit+0x8f>
			string++;
  80123c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	84 c0                	test   %al,%al
  801246:	74 8b                	je     8011d3 <strsplit+0x23>
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	0f be c0             	movsbl %al,%eax
  801250:	50                   	push   %eax
  801251:	ff 75 0c             	pushl  0xc(%ebp)
  801254:	e8 b5 fa ff ff       	call   800d0e <strchr>
  801259:	83 c4 08             	add    $0x8,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	74 dc                	je     80123c <strsplit+0x8c>
			string++;
	}
  801260:	e9 6e ff ff ff       	jmp    8011d3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801265:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801266:	8b 45 14             	mov    0x14(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801272:	8b 45 10             	mov    0x10(%ebp),%eax
  801275:	01 d0                	add    %edx,%eax
  801277:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80127d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801282:	c9                   	leave  
  801283:	c3                   	ret    

00801284 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  80128a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80128e:	74 06                	je     801296 <str2lower+0x12>
  801290:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801294:	75 07                	jne    80129d <str2lower+0x19>
		return NULL;
  801296:	b8 00 00 00 00       	mov    $0x0,%eax
  80129b:	eb 4d                	jmp    8012ea <str2lower+0x66>
	}
	char *ref=dst;
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  8012a3:	eb 33                	jmp    8012d8 <str2lower+0x54>
			if(*src>=65&&*src<=90){
  8012a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	3c 40                	cmp    $0x40,%al
  8012ac:	7e 1a                	jle    8012c8 <str2lower+0x44>
  8012ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	3c 5a                	cmp    $0x5a,%al
  8012b5:	7f 11                	jg     8012c8 <str2lower+0x44>
				*dst=*src+32;
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	83 c0 20             	add    $0x20,%eax
  8012bf:	88 c2                	mov    %al,%dl
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	88 10                	mov    %dl,(%eax)
  8012c6:	eb 0a                	jmp    8012d2 <str2lower+0x4e>
			}
			else{
				*dst=*src;
  8012c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cb:	8a 10                	mov    (%eax),%dl
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	88 10                	mov    %dl,(%eax)
			}
			src++;
  8012d2:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  8012d5:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	84 c0                	test   %al,%al
  8012df:	75 c4                	jne    8012a5 <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  8012e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    

008012ec <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	57                   	push   %edi
  8012f0:	56                   	push   %esi
  8012f1:	53                   	push   %ebx
  8012f2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012fe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801301:	8b 7d 18             	mov    0x18(%ebp),%edi
  801304:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801307:	cd 30                	int    $0x30
  801309:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80130c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80130f:	83 c4 10             	add    $0x10,%esp
  801312:	5b                   	pop    %ebx
  801313:	5e                   	pop    %esi
  801314:	5f                   	pop    %edi
  801315:	5d                   	pop    %ebp
  801316:	c3                   	ret    

00801317 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	83 ec 04             	sub    $0x4,%esp
  80131d:	8b 45 10             	mov    0x10(%ebp),%eax
  801320:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801323:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	52                   	push   %edx
  80132f:	ff 75 0c             	pushl  0xc(%ebp)
  801332:	50                   	push   %eax
  801333:	6a 00                	push   $0x0
  801335:	e8 b2 ff ff ff       	call   8012ec <syscall>
  80133a:	83 c4 18             	add    $0x18,%esp
}
  80133d:	90                   	nop
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <sys_cgetc>:

int
sys_cgetc(void)
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 01                	push   $0x1
  80134f:	e8 98 ff ff ff       	call   8012ec <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80135c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	52                   	push   %edx
  801369:	50                   	push   %eax
  80136a:	6a 05                	push   $0x5
  80136c:	e8 7b ff ff ff       	call   8012ec <syscall>
  801371:	83 c4 18             	add    $0x18,%esp
}
  801374:	c9                   	leave  
  801375:	c3                   	ret    

00801376 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	56                   	push   %esi
  80137a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80137b:	8b 75 18             	mov    0x18(%ebp),%esi
  80137e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801381:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801384:	8b 55 0c             	mov    0xc(%ebp),%edx
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	56                   	push   %esi
  80138b:	53                   	push   %ebx
  80138c:	51                   	push   %ecx
  80138d:	52                   	push   %edx
  80138e:	50                   	push   %eax
  80138f:	6a 06                	push   $0x6
  801391:	e8 56 ff ff ff       	call   8012ec <syscall>
  801396:	83 c4 18             	add    $0x18,%esp
}
  801399:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80139c:	5b                   	pop    %ebx
  80139d:	5e                   	pop    %esi
  80139e:	5d                   	pop    %ebp
  80139f:	c3                   	ret    

008013a0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	52                   	push   %edx
  8013b0:	50                   	push   %eax
  8013b1:	6a 07                	push   $0x7
  8013b3:	e8 34 ff ff ff       	call   8012ec <syscall>
  8013b8:	83 c4 18             	add    $0x18,%esp
}
  8013bb:	c9                   	leave  
  8013bc:	c3                   	ret    

008013bd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	ff 75 0c             	pushl  0xc(%ebp)
  8013c9:	ff 75 08             	pushl  0x8(%ebp)
  8013cc:	6a 08                	push   $0x8
  8013ce:	e8 19 ff ff ff       	call   8012ec <syscall>
  8013d3:	83 c4 18             	add    $0x18,%esp
}
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    

008013d8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 09                	push   $0x9
  8013e7:	e8 00 ff ff ff       	call   8012ec <syscall>
  8013ec:	83 c4 18             	add    $0x18,%esp
}
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 0a                	push   $0xa
  801400:	e8 e7 fe ff ff       	call   8012ec <syscall>
  801405:	83 c4 18             	add    $0x18,%esp
}
  801408:	c9                   	leave  
  801409:	c3                   	ret    

0080140a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 0b                	push   $0xb
  801419:	e8 ce fe ff ff       	call   8012ec <syscall>
  80141e:	83 c4 18             	add    $0x18,%esp
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 0c                	push   $0xc
  801432:	e8 b5 fe ff ff       	call   8012ec <syscall>
  801437:	83 c4 18             	add    $0x18,%esp
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	ff 75 08             	pushl  0x8(%ebp)
  80144a:	6a 0d                	push   $0xd
  80144c:	e8 9b fe ff ff       	call   8012ec <syscall>
  801451:	83 c4 18             	add    $0x18,%esp
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 0e                	push   $0xe
  801465:	e8 82 fe ff ff       	call   8012ec <syscall>
  80146a:	83 c4 18             	add    $0x18,%esp
}
  80146d:	90                   	nop
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 11                	push   $0x11
  80147f:	e8 68 fe ff ff       	call   8012ec <syscall>
  801484:	83 c4 18             	add    $0x18,%esp
}
  801487:	90                   	nop
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	6a 12                	push   $0x12
  801499:	e8 4e fe ff ff       	call   8012ec <syscall>
  80149e:	83 c4 18             	add    $0x18,%esp
}
  8014a1:	90                   	nop
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 04             	sub    $0x4,%esp
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014b0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	50                   	push   %eax
  8014bd:	6a 13                	push   $0x13
  8014bf:	e8 28 fe ff ff       	call   8012ec <syscall>
  8014c4:	83 c4 18             	add    $0x18,%esp
}
  8014c7:	90                   	nop
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 14                	push   $0x14
  8014d9:	e8 0e fe ff ff       	call   8012ec <syscall>
  8014de:	83 c4 18             	add    $0x18,%esp
}
  8014e1:	90                   	nop
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    

008014e4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	ff 75 0c             	pushl  0xc(%ebp)
  8014f3:	50                   	push   %eax
  8014f4:	6a 15                	push   $0x15
  8014f6:	e8 f1 fd ff ff       	call   8012ec <syscall>
  8014fb:	83 c4 18             	add    $0x18,%esp
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801503:	8b 55 0c             	mov    0xc(%ebp),%edx
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	52                   	push   %edx
  801510:	50                   	push   %eax
  801511:	6a 18                	push   $0x18
  801513:	e8 d4 fd ff ff       	call   8012ec <syscall>
  801518:	83 c4 18             	add    $0x18,%esp
}
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    

0080151d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801520:	8b 55 0c             	mov    0xc(%ebp),%edx
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	52                   	push   %edx
  80152d:	50                   	push   %eax
  80152e:	6a 16                	push   $0x16
  801530:	e8 b7 fd ff ff       	call   8012ec <syscall>
  801535:	83 c4 18             	add    $0x18,%esp
}
  801538:	90                   	nop
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80153e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	52                   	push   %edx
  80154b:	50                   	push   %eax
  80154c:	6a 17                	push   $0x17
  80154e:	e8 99 fd ff ff       	call   8012ec <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
}
  801556:	90                   	nop
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	83 ec 04             	sub    $0x4,%esp
  80155f:	8b 45 10             	mov    0x10(%ebp),%eax
  801562:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801565:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801568:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	6a 00                	push   $0x0
  801571:	51                   	push   %ecx
  801572:	52                   	push   %edx
  801573:	ff 75 0c             	pushl  0xc(%ebp)
  801576:	50                   	push   %eax
  801577:	6a 19                	push   $0x19
  801579:	e8 6e fd ff ff       	call   8012ec <syscall>
  80157e:	83 c4 18             	add    $0x18,%esp
}
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801586:	8b 55 0c             	mov    0xc(%ebp),%edx
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	52                   	push   %edx
  801593:	50                   	push   %eax
  801594:	6a 1a                	push   $0x1a
  801596:	e8 51 fd ff ff       	call   8012ec <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	51                   	push   %ecx
  8015b1:	52                   	push   %edx
  8015b2:	50                   	push   %eax
  8015b3:	6a 1b                	push   $0x1b
  8015b5:	e8 32 fd ff ff       	call   8012ec <syscall>
  8015ba:	83 c4 18             	add    $0x18,%esp
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	52                   	push   %edx
  8015cf:	50                   	push   %eax
  8015d0:	6a 1c                	push   $0x1c
  8015d2:	e8 15 fd ff ff       	call   8012ec <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 1d                	push   $0x1d
  8015eb:	e8 fc fc ff ff       	call   8012ec <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fb:	6a 00                	push   $0x0
  8015fd:	ff 75 14             	pushl  0x14(%ebp)
  801600:	ff 75 10             	pushl  0x10(%ebp)
  801603:	ff 75 0c             	pushl  0xc(%ebp)
  801606:	50                   	push   %eax
  801607:	6a 1e                	push   $0x1e
  801609:	e8 de fc ff ff       	call   8012ec <syscall>
  80160e:	83 c4 18             	add    $0x18,%esp
}
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	50                   	push   %eax
  801622:	6a 1f                	push   $0x1f
  801624:	e8 c3 fc ff ff       	call   8012ec <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
}
  80162c:	90                   	nop
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	50                   	push   %eax
  80163e:	6a 20                	push   $0x20
  801640:	e8 a7 fc ff ff       	call   8012ec <syscall>
  801645:	83 c4 18             	add    $0x18,%esp
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 02                	push   $0x2
  801659:	e8 8e fc ff ff       	call   8012ec <syscall>
  80165e:	83 c4 18             	add    $0x18,%esp
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 03                	push   $0x3
  801672:	e8 75 fc ff ff       	call   8012ec <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 04                	push   $0x4
  80168b:	e8 5c fc ff ff       	call   8012ec <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <sys_exit_env>:


void sys_exit_env(void)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 21                	push   $0x21
  8016a4:	e8 43 fc ff ff       	call   8012ec <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
}
  8016ac:	90                   	nop
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016b5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016b8:	8d 50 04             	lea    0x4(%eax),%edx
  8016bb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	52                   	push   %edx
  8016c5:	50                   	push   %eax
  8016c6:	6a 22                	push   $0x22
  8016c8:	e8 1f fc ff ff       	call   8012ec <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
	return result;
  8016d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d9:	89 01                	mov    %eax,(%ecx)
  8016db:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	c9                   	leave  
  8016e2:	c2 04 00             	ret    $0x4

008016e5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	ff 75 10             	pushl  0x10(%ebp)
  8016ef:	ff 75 0c             	pushl  0xc(%ebp)
  8016f2:	ff 75 08             	pushl  0x8(%ebp)
  8016f5:	6a 10                	push   $0x10
  8016f7:	e8 f0 fb ff ff       	call   8012ec <syscall>
  8016fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ff:	90                   	nop
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <sys_rcr2>:
uint32 sys_rcr2()
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 23                	push   $0x23
  801711:	e8 d6 fb ff ff       	call   8012ec <syscall>
  801716:	83 c4 18             	add    $0x18,%esp
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	83 ec 04             	sub    $0x4,%esp
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801727:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	50                   	push   %eax
  801734:	6a 24                	push   $0x24
  801736:	e8 b1 fb ff ff       	call   8012ec <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
	return ;
  80173e:	90                   	nop
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <rsttst>:
void rsttst()
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 26                	push   $0x26
  801750:	e8 97 fb ff ff       	call   8012ec <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
	return ;
  801758:	90                   	nop
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	83 ec 04             	sub    $0x4,%esp
  801761:	8b 45 14             	mov    0x14(%ebp),%eax
  801764:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801767:	8b 55 18             	mov    0x18(%ebp),%edx
  80176a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80176e:	52                   	push   %edx
  80176f:	50                   	push   %eax
  801770:	ff 75 10             	pushl  0x10(%ebp)
  801773:	ff 75 0c             	pushl  0xc(%ebp)
  801776:	ff 75 08             	pushl  0x8(%ebp)
  801779:	6a 25                	push   $0x25
  80177b:	e8 6c fb ff ff       	call   8012ec <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
	return ;
  801783:	90                   	nop
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <chktst>:
void chktst(uint32 n)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	6a 27                	push   $0x27
  801796:	e8 51 fb ff ff       	call   8012ec <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
	return ;
  80179e:	90                   	nop
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <inctst>:

void inctst()
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 28                	push   $0x28
  8017b0:	e8 37 fb ff ff       	call   8012ec <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b8:	90                   	nop
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <gettst>:
uint32 gettst()
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 29                	push   $0x29
  8017ca:	e8 1d fb ff ff       	call   8012ec <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 2a                	push   $0x2a
  8017e6:	e8 01 fb ff ff       	call   8012ec <syscall>
  8017eb:	83 c4 18             	add    $0x18,%esp
  8017ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017f1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017f5:	75 07                	jne    8017fe <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8017fc:	eb 05                	jmp    801803 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 2a                	push   $0x2a
  801817:	e8 d0 fa ff ff       	call   8012ec <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
  80181f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801822:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801826:	75 07                	jne    80182f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801828:	b8 01 00 00 00       	mov    $0x1,%eax
  80182d:	eb 05                	jmp    801834 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 2a                	push   $0x2a
  801848:	e8 9f fa ff ff       	call   8012ec <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
  801850:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801853:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801857:	75 07                	jne    801860 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801859:	b8 01 00 00 00       	mov    $0x1,%eax
  80185e:	eb 05                	jmp    801865 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801860:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 2a                	push   $0x2a
  801879:	e8 6e fa ff ff       	call   8012ec <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
  801881:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801884:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801888:	75 07                	jne    801891 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80188a:	b8 01 00 00 00       	mov    $0x1,%eax
  80188f:	eb 05                	jmp    801896 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801891:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	ff 75 08             	pushl  0x8(%ebp)
  8018a6:	6a 2b                	push   $0x2b
  8018a8:	e8 3f fa ff ff       	call   8012ec <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b0:	90                   	nop
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	6a 00                	push   $0x0
  8018c5:	53                   	push   %ebx
  8018c6:	51                   	push   %ecx
  8018c7:	52                   	push   %edx
  8018c8:	50                   	push   %eax
  8018c9:	6a 2c                	push   $0x2c
  8018cb:	e8 1c fa ff ff       	call   8012ec <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	52                   	push   %edx
  8018e8:	50                   	push   %eax
  8018e9:	6a 2d                	push   $0x2d
  8018eb:	e8 fc f9 ff ff       	call   8012ec <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018f8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	6a 00                	push   $0x0
  801903:	51                   	push   %ecx
  801904:	ff 75 10             	pushl  0x10(%ebp)
  801907:	52                   	push   %edx
  801908:	50                   	push   %eax
  801909:	6a 2e                	push   $0x2e
  80190b:	e8 dc f9 ff ff       	call   8012ec <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	ff 75 10             	pushl  0x10(%ebp)
  80191f:	ff 75 0c             	pushl  0xc(%ebp)
  801922:	ff 75 08             	pushl  0x8(%ebp)
  801925:	6a 0f                	push   $0xf
  801927:	e8 c0 f9 ff ff       	call   8012ec <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
	return ;
  80192f:	90                   	nop
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	50                   	push   %eax
  801941:	6a 2f                	push   $0x2f
  801943:	e8 a4 f9 ff ff       	call   8012ec <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	6a 30                	push   $0x30
  80195e:	e8 89 f9 ff ff       	call   8012ec <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801966:	90                   	nop
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	ff 75 08             	pushl  0x8(%ebp)
  801978:	6a 31                	push   $0x31
  80197a:	e8 6d f9 ff ff       	call   8012ec <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801982:	90                   	nop
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80198b:	8b 55 08             	mov    0x8(%ebp),%edx
  80198e:	89 d0                	mov    %edx,%eax
  801990:	c1 e0 02             	shl    $0x2,%eax
  801993:	01 d0                	add    %edx,%eax
  801995:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80199c:	01 d0                	add    %edx,%eax
  80199e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a5:	01 d0                	add    %edx,%eax
  8019a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ae:	01 d0                	add    %edx,%eax
  8019b0:	c1 e0 04             	shl    $0x4,%eax
  8019b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8019b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8019bd:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8019c0:	83 ec 0c             	sub    $0xc,%esp
  8019c3:	50                   	push   %eax
  8019c4:	e8 e6 fc ff ff       	call   8016af <sys_get_virtual_time>
  8019c9:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8019cc:	eb 41                	jmp    801a0f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8019ce:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019d1:	83 ec 0c             	sub    $0xc,%esp
  8019d4:	50                   	push   %eax
  8019d5:	e8 d5 fc ff ff       	call   8016af <sys_get_virtual_time>
  8019da:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019e3:	29 c2                	sub    %eax,%edx
  8019e5:	89 d0                	mov    %edx,%eax
  8019e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f0:	89 d1                	mov    %edx,%ecx
  8019f2:	29 c1                	sub    %eax,%ecx
  8019f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019fa:	39 c2                	cmp    %eax,%edx
  8019fc:	0f 97 c0             	seta   %al
  8019ff:	0f b6 c0             	movzbl %al,%eax
  801a02:	29 c1                	sub    %eax,%ecx
  801a04:	89 c8                	mov    %ecx,%eax
  801a06:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a09:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a15:	72 b7                	jb     8019ce <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a17:	90                   	nop
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a27:	eb 03                	jmp    801a2c <busy_wait+0x12>
  801a29:	ff 45 fc             	incl   -0x4(%ebp)
  801a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a2f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a32:	72 f5                	jb     801a29 <busy_wait+0xf>
	return i;
  801a34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a45:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a49:	83 ec 0c             	sub    $0xc,%esp
  801a4c:	50                   	push   %eax
  801a4d:	e8 52 fa ff ff       	call   8014a4 <sys_cputc>
  801a52:	83 c4 10             	add    $0x10,%esp
}
  801a55:	90                   	nop
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801a5e:	e8 0d fa ff ff       	call   801470 <sys_disable_interrupt>
	char c = ch;
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a69:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a6d:	83 ec 0c             	sub    $0xc,%esp
  801a70:	50                   	push   %eax
  801a71:	e8 2e fa ff ff       	call   8014a4 <sys_cputc>
  801a76:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801a79:	e8 0c fa ff ff       	call   80148a <sys_enable_interrupt>
}
  801a7e:	90                   	nop
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <getchar>:

int
getchar(void)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  801a87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801a8e:	eb 08                	jmp    801a98 <getchar+0x17>
	{
		c = sys_cgetc();
  801a90:	e8 ab f8 ff ff       	call   801340 <sys_cgetc>
  801a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  801a98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a9c:	74 f2                	je     801a90 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  801a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <atomic_getchar>:

int
atomic_getchar(void)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801aa9:	e8 c2 f9 ff ff       	call   801470 <sys_disable_interrupt>
	int c=0;
  801aae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801ab5:	eb 08                	jmp    801abf <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801ab7:	e8 84 f8 ff ff       	call   801340 <sys_cgetc>
  801abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801abf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ac3:	74 f2                	je     801ab7 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801ac5:	e8 c0 f9 ff ff       	call   80148a <sys_enable_interrupt>
	return c;
  801aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <iscons>:

int iscons(int fdnum)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801ad2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ad7:	5d                   	pop    %ebp
  801ad8:	c3                   	ret    
  801ad9:	66 90                	xchg   %ax,%ax
  801adb:	90                   	nop

00801adc <__udivdi3>:
  801adc:	55                   	push   %ebp
  801add:	57                   	push   %edi
  801ade:	56                   	push   %esi
  801adf:	53                   	push   %ebx
  801ae0:	83 ec 1c             	sub    $0x1c,%esp
  801ae3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ae7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801aeb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801af3:	89 ca                	mov    %ecx,%edx
  801af5:	89 f8                	mov    %edi,%eax
  801af7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801afb:	85 f6                	test   %esi,%esi
  801afd:	75 2d                	jne    801b2c <__udivdi3+0x50>
  801aff:	39 cf                	cmp    %ecx,%edi
  801b01:	77 65                	ja     801b68 <__udivdi3+0x8c>
  801b03:	89 fd                	mov    %edi,%ebp
  801b05:	85 ff                	test   %edi,%edi
  801b07:	75 0b                	jne    801b14 <__udivdi3+0x38>
  801b09:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0e:	31 d2                	xor    %edx,%edx
  801b10:	f7 f7                	div    %edi
  801b12:	89 c5                	mov    %eax,%ebp
  801b14:	31 d2                	xor    %edx,%edx
  801b16:	89 c8                	mov    %ecx,%eax
  801b18:	f7 f5                	div    %ebp
  801b1a:	89 c1                	mov    %eax,%ecx
  801b1c:	89 d8                	mov    %ebx,%eax
  801b1e:	f7 f5                	div    %ebp
  801b20:	89 cf                	mov    %ecx,%edi
  801b22:	89 fa                	mov    %edi,%edx
  801b24:	83 c4 1c             	add    $0x1c,%esp
  801b27:	5b                   	pop    %ebx
  801b28:	5e                   	pop    %esi
  801b29:	5f                   	pop    %edi
  801b2a:	5d                   	pop    %ebp
  801b2b:	c3                   	ret    
  801b2c:	39 ce                	cmp    %ecx,%esi
  801b2e:	77 28                	ja     801b58 <__udivdi3+0x7c>
  801b30:	0f bd fe             	bsr    %esi,%edi
  801b33:	83 f7 1f             	xor    $0x1f,%edi
  801b36:	75 40                	jne    801b78 <__udivdi3+0x9c>
  801b38:	39 ce                	cmp    %ecx,%esi
  801b3a:	72 0a                	jb     801b46 <__udivdi3+0x6a>
  801b3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b40:	0f 87 9e 00 00 00    	ja     801be4 <__udivdi3+0x108>
  801b46:	b8 01 00 00 00       	mov    $0x1,%eax
  801b4b:	89 fa                	mov    %edi,%edx
  801b4d:	83 c4 1c             	add    $0x1c,%esp
  801b50:	5b                   	pop    %ebx
  801b51:	5e                   	pop    %esi
  801b52:	5f                   	pop    %edi
  801b53:	5d                   	pop    %ebp
  801b54:	c3                   	ret    
  801b55:	8d 76 00             	lea    0x0(%esi),%esi
  801b58:	31 ff                	xor    %edi,%edi
  801b5a:	31 c0                	xor    %eax,%eax
  801b5c:	89 fa                	mov    %edi,%edx
  801b5e:	83 c4 1c             	add    $0x1c,%esp
  801b61:	5b                   	pop    %ebx
  801b62:	5e                   	pop    %esi
  801b63:	5f                   	pop    %edi
  801b64:	5d                   	pop    %ebp
  801b65:	c3                   	ret    
  801b66:	66 90                	xchg   %ax,%ax
  801b68:	89 d8                	mov    %ebx,%eax
  801b6a:	f7 f7                	div    %edi
  801b6c:	31 ff                	xor    %edi,%edi
  801b6e:	89 fa                	mov    %edi,%edx
  801b70:	83 c4 1c             	add    $0x1c,%esp
  801b73:	5b                   	pop    %ebx
  801b74:	5e                   	pop    %esi
  801b75:	5f                   	pop    %edi
  801b76:	5d                   	pop    %ebp
  801b77:	c3                   	ret    
  801b78:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b7d:	89 eb                	mov    %ebp,%ebx
  801b7f:	29 fb                	sub    %edi,%ebx
  801b81:	89 f9                	mov    %edi,%ecx
  801b83:	d3 e6                	shl    %cl,%esi
  801b85:	89 c5                	mov    %eax,%ebp
  801b87:	88 d9                	mov    %bl,%cl
  801b89:	d3 ed                	shr    %cl,%ebp
  801b8b:	89 e9                	mov    %ebp,%ecx
  801b8d:	09 f1                	or     %esi,%ecx
  801b8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b93:	89 f9                	mov    %edi,%ecx
  801b95:	d3 e0                	shl    %cl,%eax
  801b97:	89 c5                	mov    %eax,%ebp
  801b99:	89 d6                	mov    %edx,%esi
  801b9b:	88 d9                	mov    %bl,%cl
  801b9d:	d3 ee                	shr    %cl,%esi
  801b9f:	89 f9                	mov    %edi,%ecx
  801ba1:	d3 e2                	shl    %cl,%edx
  801ba3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ba7:	88 d9                	mov    %bl,%cl
  801ba9:	d3 e8                	shr    %cl,%eax
  801bab:	09 c2                	or     %eax,%edx
  801bad:	89 d0                	mov    %edx,%eax
  801baf:	89 f2                	mov    %esi,%edx
  801bb1:	f7 74 24 0c          	divl   0xc(%esp)
  801bb5:	89 d6                	mov    %edx,%esi
  801bb7:	89 c3                	mov    %eax,%ebx
  801bb9:	f7 e5                	mul    %ebp
  801bbb:	39 d6                	cmp    %edx,%esi
  801bbd:	72 19                	jb     801bd8 <__udivdi3+0xfc>
  801bbf:	74 0b                	je     801bcc <__udivdi3+0xf0>
  801bc1:	89 d8                	mov    %ebx,%eax
  801bc3:	31 ff                	xor    %edi,%edi
  801bc5:	e9 58 ff ff ff       	jmp    801b22 <__udivdi3+0x46>
  801bca:	66 90                	xchg   %ax,%ax
  801bcc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bd0:	89 f9                	mov    %edi,%ecx
  801bd2:	d3 e2                	shl    %cl,%edx
  801bd4:	39 c2                	cmp    %eax,%edx
  801bd6:	73 e9                	jae    801bc1 <__udivdi3+0xe5>
  801bd8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bdb:	31 ff                	xor    %edi,%edi
  801bdd:	e9 40 ff ff ff       	jmp    801b22 <__udivdi3+0x46>
  801be2:	66 90                	xchg   %ax,%ax
  801be4:	31 c0                	xor    %eax,%eax
  801be6:	e9 37 ff ff ff       	jmp    801b22 <__udivdi3+0x46>
  801beb:	90                   	nop

00801bec <__umoddi3>:
  801bec:	55                   	push   %ebp
  801bed:	57                   	push   %edi
  801bee:	56                   	push   %esi
  801bef:	53                   	push   %ebx
  801bf0:	83 ec 1c             	sub    $0x1c,%esp
  801bf3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bf7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bfb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c0b:	89 f3                	mov    %esi,%ebx
  801c0d:	89 fa                	mov    %edi,%edx
  801c0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c13:	89 34 24             	mov    %esi,(%esp)
  801c16:	85 c0                	test   %eax,%eax
  801c18:	75 1a                	jne    801c34 <__umoddi3+0x48>
  801c1a:	39 f7                	cmp    %esi,%edi
  801c1c:	0f 86 a2 00 00 00    	jbe    801cc4 <__umoddi3+0xd8>
  801c22:	89 c8                	mov    %ecx,%eax
  801c24:	89 f2                	mov    %esi,%edx
  801c26:	f7 f7                	div    %edi
  801c28:	89 d0                	mov    %edx,%eax
  801c2a:	31 d2                	xor    %edx,%edx
  801c2c:	83 c4 1c             	add    $0x1c,%esp
  801c2f:	5b                   	pop    %ebx
  801c30:	5e                   	pop    %esi
  801c31:	5f                   	pop    %edi
  801c32:	5d                   	pop    %ebp
  801c33:	c3                   	ret    
  801c34:	39 f0                	cmp    %esi,%eax
  801c36:	0f 87 ac 00 00 00    	ja     801ce8 <__umoddi3+0xfc>
  801c3c:	0f bd e8             	bsr    %eax,%ebp
  801c3f:	83 f5 1f             	xor    $0x1f,%ebp
  801c42:	0f 84 ac 00 00 00    	je     801cf4 <__umoddi3+0x108>
  801c48:	bf 20 00 00 00       	mov    $0x20,%edi
  801c4d:	29 ef                	sub    %ebp,%edi
  801c4f:	89 fe                	mov    %edi,%esi
  801c51:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c55:	89 e9                	mov    %ebp,%ecx
  801c57:	d3 e0                	shl    %cl,%eax
  801c59:	89 d7                	mov    %edx,%edi
  801c5b:	89 f1                	mov    %esi,%ecx
  801c5d:	d3 ef                	shr    %cl,%edi
  801c5f:	09 c7                	or     %eax,%edi
  801c61:	89 e9                	mov    %ebp,%ecx
  801c63:	d3 e2                	shl    %cl,%edx
  801c65:	89 14 24             	mov    %edx,(%esp)
  801c68:	89 d8                	mov    %ebx,%eax
  801c6a:	d3 e0                	shl    %cl,%eax
  801c6c:	89 c2                	mov    %eax,%edx
  801c6e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c72:	d3 e0                	shl    %cl,%eax
  801c74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c78:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c7c:	89 f1                	mov    %esi,%ecx
  801c7e:	d3 e8                	shr    %cl,%eax
  801c80:	09 d0                	or     %edx,%eax
  801c82:	d3 eb                	shr    %cl,%ebx
  801c84:	89 da                	mov    %ebx,%edx
  801c86:	f7 f7                	div    %edi
  801c88:	89 d3                	mov    %edx,%ebx
  801c8a:	f7 24 24             	mull   (%esp)
  801c8d:	89 c6                	mov    %eax,%esi
  801c8f:	89 d1                	mov    %edx,%ecx
  801c91:	39 d3                	cmp    %edx,%ebx
  801c93:	0f 82 87 00 00 00    	jb     801d20 <__umoddi3+0x134>
  801c99:	0f 84 91 00 00 00    	je     801d30 <__umoddi3+0x144>
  801c9f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ca3:	29 f2                	sub    %esi,%edx
  801ca5:	19 cb                	sbb    %ecx,%ebx
  801ca7:	89 d8                	mov    %ebx,%eax
  801ca9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cad:	d3 e0                	shl    %cl,%eax
  801caf:	89 e9                	mov    %ebp,%ecx
  801cb1:	d3 ea                	shr    %cl,%edx
  801cb3:	09 d0                	or     %edx,%eax
  801cb5:	89 e9                	mov    %ebp,%ecx
  801cb7:	d3 eb                	shr    %cl,%ebx
  801cb9:	89 da                	mov    %ebx,%edx
  801cbb:	83 c4 1c             	add    $0x1c,%esp
  801cbe:	5b                   	pop    %ebx
  801cbf:	5e                   	pop    %esi
  801cc0:	5f                   	pop    %edi
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    
  801cc3:	90                   	nop
  801cc4:	89 fd                	mov    %edi,%ebp
  801cc6:	85 ff                	test   %edi,%edi
  801cc8:	75 0b                	jne    801cd5 <__umoddi3+0xe9>
  801cca:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccf:	31 d2                	xor    %edx,%edx
  801cd1:	f7 f7                	div    %edi
  801cd3:	89 c5                	mov    %eax,%ebp
  801cd5:	89 f0                	mov    %esi,%eax
  801cd7:	31 d2                	xor    %edx,%edx
  801cd9:	f7 f5                	div    %ebp
  801cdb:	89 c8                	mov    %ecx,%eax
  801cdd:	f7 f5                	div    %ebp
  801cdf:	89 d0                	mov    %edx,%eax
  801ce1:	e9 44 ff ff ff       	jmp    801c2a <__umoddi3+0x3e>
  801ce6:	66 90                	xchg   %ax,%ax
  801ce8:	89 c8                	mov    %ecx,%eax
  801cea:	89 f2                	mov    %esi,%edx
  801cec:	83 c4 1c             	add    $0x1c,%esp
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5f                   	pop    %edi
  801cf2:	5d                   	pop    %ebp
  801cf3:	c3                   	ret    
  801cf4:	3b 04 24             	cmp    (%esp),%eax
  801cf7:	72 06                	jb     801cff <__umoddi3+0x113>
  801cf9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cfd:	77 0f                	ja     801d0e <__umoddi3+0x122>
  801cff:	89 f2                	mov    %esi,%edx
  801d01:	29 f9                	sub    %edi,%ecx
  801d03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d07:	89 14 24             	mov    %edx,(%esp)
  801d0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d12:	8b 14 24             	mov    (%esp),%edx
  801d15:	83 c4 1c             	add    $0x1c,%esp
  801d18:	5b                   	pop    %ebx
  801d19:	5e                   	pop    %esi
  801d1a:	5f                   	pop    %edi
  801d1b:	5d                   	pop    %ebp
  801d1c:	c3                   	ret    
  801d1d:	8d 76 00             	lea    0x0(%esi),%esi
  801d20:	2b 04 24             	sub    (%esp),%eax
  801d23:	19 fa                	sbb    %edi,%edx
  801d25:	89 d1                	mov    %edx,%ecx
  801d27:	89 c6                	mov    %eax,%esi
  801d29:	e9 71 ff ff ff       	jmp    801c9f <__umoddi3+0xb3>
  801d2e:	66 90                	xchg   %ax,%ax
  801d30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d34:	72 ea                	jb     801d20 <__umoddi3+0x134>
  801d36:	89 d9                	mov    %ebx,%ecx
  801d38:	e9 62 ff ff ff       	jmp    801c9f <__umoddi3+0xb3>
