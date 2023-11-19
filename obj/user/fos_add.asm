
obj/user/fos_add:     file format elf32-i386


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
  800031:	e8 60 00 00 00       	call   800096 <libmain>
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
  80003b:	83 ec 18             	sub    $0x18,%esp

	int i1=0;
  80003e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800045:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	i1 = strtol("1", NULL, 10);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	6a 0a                	push   $0xa
  800051:	6a 00                	push   $0x0
  800053:	68 c0 19 80 00       	push   $0x8019c0
  800058:	e8 3f 0c 00 00       	call   800c9c <strtol>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	89 45 f4             	mov    %eax,-0xc(%ebp)
	i2 = strtol("2", NULL, 10);
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	6a 0a                	push   $0xa
  800068:	6a 00                	push   $0x0
  80006a:	68 c2 19 80 00       	push   $0x8019c2
  80006f:	e8 28 0c 00 00       	call   800c9c <strtol>
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  80007a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	50                   	push   %eax
  800086:	68 c4 19 80 00       	push   $0x8019c4
  80008b:	e8 4c 02 00 00       	call   8002dc <atomic_cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
	//cprintf("number 1 + number 2 = \n");
	return;
  800093:	90                   	nop
}
  800094:	c9                   	leave  
  800095:	c3                   	ret    

00800096 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80009c:	e8 82 13 00 00       	call   801423 <sys_getenvindex>
  8000a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a7:	89 d0                	mov    %edx,%eax
  8000a9:	01 c0                	add    %eax,%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	01 c0                	add    %eax,%eax
  8000af:	01 d0                	add    %edx,%eax
  8000b1:	c1 e0 02             	shl    $0x2,%eax
  8000b4:	01 d0                	add    %edx,%eax
  8000b6:	01 c0                	add    %eax,%eax
  8000b8:	01 d0                	add    %edx,%eax
  8000ba:	c1 e0 02             	shl    $0x2,%eax
  8000bd:	01 d0                	add    %edx,%eax
  8000bf:	c1 e0 02             	shl    $0x2,%eax
  8000c2:	01 d0                	add    %edx,%eax
  8000c4:	c1 e0 02             	shl    $0x2,%eax
  8000c7:	01 d0                	add    %edx,%eax
  8000c9:	c1 e0 05             	shl    $0x5,%eax
  8000cc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d1:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000d6:	a1 20 20 80 00       	mov    0x802020,%eax
  8000db:	8a 40 5c             	mov    0x5c(%eax),%al
  8000de:	84 c0                	test   %al,%al
  8000e0:	74 0d                	je     8000ef <libmain+0x59>
		binaryname = myEnv->prog_name;
  8000e2:	a1 20 20 80 00       	mov    0x802020,%eax
  8000e7:	83 c0 5c             	add    $0x5c,%eax
  8000ea:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000f3:	7e 0a                	jle    8000ff <libmain+0x69>
		binaryname = argv[0];
  8000f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f8:	8b 00                	mov    (%eax),%eax
  8000fa:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000ff:	83 ec 08             	sub    $0x8,%esp
  800102:	ff 75 0c             	pushl  0xc(%ebp)
  800105:	ff 75 08             	pushl  0x8(%ebp)
  800108:	e8 2b ff ff ff       	call   800038 <_main>
  80010d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800110:	e8 1b 11 00 00       	call   801230 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 f8 19 80 00       	push   $0x8019f8
  80011d:	e8 8d 01 00 00       	call   8002af <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800125:	a1 20 20 80 00       	mov    0x802020,%eax
  80012a:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  800130:	a1 20 20 80 00       	mov    0x802020,%eax
  800135:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	52                   	push   %edx
  80013f:	50                   	push   %eax
  800140:	68 20 1a 80 00       	push   $0x801a20
  800145:	e8 65 01 00 00       	call   8002af <cprintf>
  80014a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80014d:	a1 20 20 80 00       	mov    0x802020,%eax
  800152:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  800158:	a1 20 20 80 00       	mov    0x802020,%eax
  80015d:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  800163:	a1 20 20 80 00       	mov    0x802020,%eax
  800168:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  80016e:	51                   	push   %ecx
  80016f:	52                   	push   %edx
  800170:	50                   	push   %eax
  800171:	68 48 1a 80 00       	push   $0x801a48
  800176:	e8 34 01 00 00       	call   8002af <cprintf>
  80017b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80017e:	a1 20 20 80 00       	mov    0x802020,%eax
  800183:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  800189:	83 ec 08             	sub    $0x8,%esp
  80018c:	50                   	push   %eax
  80018d:	68 a0 1a 80 00       	push   $0x801aa0
  800192:	e8 18 01 00 00       	call   8002af <cprintf>
  800197:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80019a:	83 ec 0c             	sub    $0xc,%esp
  80019d:	68 f8 19 80 00       	push   $0x8019f8
  8001a2:	e8 08 01 00 00       	call   8002af <cprintf>
  8001a7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001aa:	e8 9b 10 00 00       	call   80124a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001af:	e8 19 00 00 00       	call   8001cd <exit>
}
  8001b4:	90                   	nop
  8001b5:	c9                   	leave  
  8001b6:	c3                   	ret    

008001b7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	6a 00                	push   $0x0
  8001c2:	e8 28 12 00 00       	call   8013ef <sys_destroy_env>
  8001c7:	83 c4 10             	add    $0x10,%esp
}
  8001ca:	90                   	nop
  8001cb:	c9                   	leave  
  8001cc:	c3                   	ret    

008001cd <exit>:

void
exit(void)
{
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001d3:	e8 7d 12 00 00       	call   801455 <sys_exit_env>
}
  8001d8:	90                   	nop
  8001d9:	c9                   	leave  
  8001da:	c3                   	ret    

008001db <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e4:	8b 00                	mov    (%eax),%eax
  8001e6:	8d 48 01             	lea    0x1(%eax),%ecx
  8001e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ec:	89 0a                	mov    %ecx,(%edx)
  8001ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f1:	88 d1                	mov    %dl,%cl
  8001f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001fd:	8b 00                	mov    (%eax),%eax
  8001ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800204:	75 2c                	jne    800232 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800206:	a0 24 20 80 00       	mov    0x802024,%al
  80020b:	0f b6 c0             	movzbl %al,%eax
  80020e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800211:	8b 12                	mov    (%edx),%edx
  800213:	89 d1                	mov    %edx,%ecx
  800215:	8b 55 0c             	mov    0xc(%ebp),%edx
  800218:	83 c2 08             	add    $0x8,%edx
  80021b:	83 ec 04             	sub    $0x4,%esp
  80021e:	50                   	push   %eax
  80021f:	51                   	push   %ecx
  800220:	52                   	push   %edx
  800221:	e8 b1 0e 00 00       	call   8010d7 <sys_cputs>
  800226:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800232:	8b 45 0c             	mov    0xc(%ebp),%eax
  800235:	8b 40 04             	mov    0x4(%eax),%eax
  800238:	8d 50 01             	lea    0x1(%eax),%edx
  80023b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800241:	90                   	nop
  800242:	c9                   	leave  
  800243:	c3                   	ret    

00800244 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80024d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800254:	00 00 00 
	b.cnt = 0;
  800257:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800261:	ff 75 0c             	pushl  0xc(%ebp)
  800264:	ff 75 08             	pushl  0x8(%ebp)
  800267:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026d:	50                   	push   %eax
  80026e:	68 db 01 80 00       	push   $0x8001db
  800273:	e8 11 02 00 00       	call   800489 <vprintfmt>
  800278:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80027b:	a0 24 20 80 00       	mov    0x802024,%al
  800280:	0f b6 c0             	movzbl %al,%eax
  800283:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	50                   	push   %eax
  80028d:	52                   	push   %edx
  80028e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800294:	83 c0 08             	add    $0x8,%eax
  800297:	50                   	push   %eax
  800298:	e8 3a 0e 00 00       	call   8010d7 <sys_cputs>
  80029d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002a0:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8002a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <cprintf>:

int cprintf(const char *fmt, ...) {
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002b5:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8002bc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c5:	83 ec 08             	sub    $0x8,%esp
  8002c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cb:	50                   	push   %eax
  8002cc:	e8 73 ff ff ff       	call   800244 <vcprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
  8002d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002da:	c9                   	leave  
  8002db:	c3                   	ret    

008002dc <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002e2:	e8 49 0f 00 00       	call   801230 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f0:	83 ec 08             	sub    $0x8,%esp
  8002f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f6:	50                   	push   %eax
  8002f7:	e8 48 ff ff ff       	call   800244 <vcprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
  8002ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800302:	e8 43 0f 00 00       	call   80124a <sys_enable_interrupt>
	return cnt;
  800307:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80030a:	c9                   	leave  
  80030b:	c3                   	ret    

0080030c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	53                   	push   %ebx
  800310:	83 ec 14             	sub    $0x14,%esp
  800313:	8b 45 10             	mov    0x10(%ebp),%eax
  800316:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800319:	8b 45 14             	mov    0x14(%ebp),%eax
  80031c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80031f:	8b 45 18             	mov    0x18(%ebp),%eax
  800322:	ba 00 00 00 00       	mov    $0x0,%edx
  800327:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80032a:	77 55                	ja     800381 <printnum+0x75>
  80032c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80032f:	72 05                	jb     800336 <printnum+0x2a>
  800331:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800334:	77 4b                	ja     800381 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800336:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800339:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80033c:	8b 45 18             	mov    0x18(%ebp),%eax
  80033f:	ba 00 00 00 00       	mov    $0x0,%edx
  800344:	52                   	push   %edx
  800345:	50                   	push   %eax
  800346:	ff 75 f4             	pushl  -0xc(%ebp)
  800349:	ff 75 f0             	pushl  -0x10(%ebp)
  80034c:	e8 f7 13 00 00       	call   801748 <__udivdi3>
  800351:	83 c4 10             	add    $0x10,%esp
  800354:	83 ec 04             	sub    $0x4,%esp
  800357:	ff 75 20             	pushl  0x20(%ebp)
  80035a:	53                   	push   %ebx
  80035b:	ff 75 18             	pushl  0x18(%ebp)
  80035e:	52                   	push   %edx
  80035f:	50                   	push   %eax
  800360:	ff 75 0c             	pushl  0xc(%ebp)
  800363:	ff 75 08             	pushl  0x8(%ebp)
  800366:	e8 a1 ff ff ff       	call   80030c <printnum>
  80036b:	83 c4 20             	add    $0x20,%esp
  80036e:	eb 1a                	jmp    80038a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	ff 75 0c             	pushl  0xc(%ebp)
  800376:	ff 75 20             	pushl  0x20(%ebp)
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	ff d0                	call   *%eax
  80037e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800381:	ff 4d 1c             	decl   0x1c(%ebp)
  800384:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800388:	7f e6                	jg     800370 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80038a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80038d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800395:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800398:	53                   	push   %ebx
  800399:	51                   	push   %ecx
  80039a:	52                   	push   %edx
  80039b:	50                   	push   %eax
  80039c:	e8 b7 14 00 00       	call   801858 <__umoddi3>
  8003a1:	83 c4 10             	add    $0x10,%esp
  8003a4:	05 d4 1c 80 00       	add    $0x801cd4,%eax
  8003a9:	8a 00                	mov    (%eax),%al
  8003ab:	0f be c0             	movsbl %al,%eax
  8003ae:	83 ec 08             	sub    $0x8,%esp
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	50                   	push   %eax
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	ff d0                	call   *%eax
  8003ba:	83 c4 10             	add    $0x10,%esp
}
  8003bd:	90                   	nop
  8003be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003c1:	c9                   	leave  
  8003c2:	c3                   	ret    

008003c3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003c6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003ca:	7e 1c                	jle    8003e8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cf:	8b 00                	mov    (%eax),%eax
  8003d1:	8d 50 08             	lea    0x8(%eax),%edx
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	89 10                	mov    %edx,(%eax)
  8003d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dc:	8b 00                	mov    (%eax),%eax
  8003de:	83 e8 08             	sub    $0x8,%eax
  8003e1:	8b 50 04             	mov    0x4(%eax),%edx
  8003e4:	8b 00                	mov    (%eax),%eax
  8003e6:	eb 40                	jmp    800428 <getuint+0x65>
	else if (lflag)
  8003e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003ec:	74 1e                	je     80040c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	8b 00                	mov    (%eax),%eax
  8003f3:	8d 50 04             	lea    0x4(%eax),%edx
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	89 10                	mov    %edx,(%eax)
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	8b 00                	mov    (%eax),%eax
  800400:	83 e8 04             	sub    $0x4,%eax
  800403:	8b 00                	mov    (%eax),%eax
  800405:	ba 00 00 00 00       	mov    $0x0,%edx
  80040a:	eb 1c                	jmp    800428 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80040c:	8b 45 08             	mov    0x8(%ebp),%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	8d 50 04             	lea    0x4(%eax),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	89 10                	mov    %edx,(%eax)
  800419:	8b 45 08             	mov    0x8(%ebp),%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	83 e8 04             	sub    $0x4,%eax
  800421:	8b 00                	mov    (%eax),%eax
  800423:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800428:	5d                   	pop    %ebp
  800429:	c3                   	ret    

0080042a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80042d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800431:	7e 1c                	jle    80044f <getint+0x25>
		return va_arg(*ap, long long);
  800433:	8b 45 08             	mov    0x8(%ebp),%eax
  800436:	8b 00                	mov    (%eax),%eax
  800438:	8d 50 08             	lea    0x8(%eax),%edx
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	89 10                	mov    %edx,(%eax)
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	8b 00                	mov    (%eax),%eax
  800445:	83 e8 08             	sub    $0x8,%eax
  800448:	8b 50 04             	mov    0x4(%eax),%edx
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	eb 38                	jmp    800487 <getint+0x5d>
	else if (lflag)
  80044f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800453:	74 1a                	je     80046f <getint+0x45>
		return va_arg(*ap, long);
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	8d 50 04             	lea    0x4(%eax),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	89 10                	mov    %edx,(%eax)
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	8b 00                	mov    (%eax),%eax
  800467:	83 e8 04             	sub    $0x4,%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	99                   	cltd   
  80046d:	eb 18                	jmp    800487 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	8b 00                	mov    (%eax),%eax
  800474:	8d 50 04             	lea    0x4(%eax),%edx
  800477:	8b 45 08             	mov    0x8(%ebp),%eax
  80047a:	89 10                	mov    %edx,(%eax)
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	83 e8 04             	sub    $0x4,%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	99                   	cltd   
}
  800487:	5d                   	pop    %ebp
  800488:	c3                   	ret    

00800489 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800489:	55                   	push   %ebp
  80048a:	89 e5                	mov    %esp,%ebp
  80048c:	56                   	push   %esi
  80048d:	53                   	push   %ebx
  80048e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800491:	eb 17                	jmp    8004aa <vprintfmt+0x21>
			if (ch == '\0')
  800493:	85 db                	test   %ebx,%ebx
  800495:	0f 84 af 03 00 00    	je     80084a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	ff 75 0c             	pushl  0xc(%ebp)
  8004a1:	53                   	push   %ebx
  8004a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a5:	ff d0                	call   *%eax
  8004a7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ad:	8d 50 01             	lea    0x1(%eax),%edx
  8004b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8004b3:	8a 00                	mov    (%eax),%al
  8004b5:	0f b6 d8             	movzbl %al,%ebx
  8004b8:	83 fb 25             	cmp    $0x25,%ebx
  8004bb:	75 d6                	jne    800493 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004bd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004c1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004c8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004d6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e0:	8d 50 01             	lea    0x1(%eax),%edx
  8004e3:	89 55 10             	mov    %edx,0x10(%ebp)
  8004e6:	8a 00                	mov    (%eax),%al
  8004e8:	0f b6 d8             	movzbl %al,%ebx
  8004eb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004ee:	83 f8 55             	cmp    $0x55,%eax
  8004f1:	0f 87 2b 03 00 00    	ja     800822 <vprintfmt+0x399>
  8004f7:	8b 04 85 f8 1c 80 00 	mov    0x801cf8(,%eax,4),%eax
  8004fe:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800500:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800504:	eb d7                	jmp    8004dd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800506:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80050a:	eb d1                	jmp    8004dd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80050c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800513:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800516:	89 d0                	mov    %edx,%eax
  800518:	c1 e0 02             	shl    $0x2,%eax
  80051b:	01 d0                	add    %edx,%eax
  80051d:	01 c0                	add    %eax,%eax
  80051f:	01 d8                	add    %ebx,%eax
  800521:	83 e8 30             	sub    $0x30,%eax
  800524:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800527:	8b 45 10             	mov    0x10(%ebp),%eax
  80052a:	8a 00                	mov    (%eax),%al
  80052c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80052f:	83 fb 2f             	cmp    $0x2f,%ebx
  800532:	7e 3e                	jle    800572 <vprintfmt+0xe9>
  800534:	83 fb 39             	cmp    $0x39,%ebx
  800537:	7f 39                	jg     800572 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800539:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80053c:	eb d5                	jmp    800513 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	83 c0 04             	add    $0x4,%eax
  800544:	89 45 14             	mov    %eax,0x14(%ebp)
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	83 e8 04             	sub    $0x4,%eax
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800552:	eb 1f                	jmp    800573 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800554:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800558:	79 83                	jns    8004dd <vprintfmt+0x54>
				width = 0;
  80055a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800561:	e9 77 ff ff ff       	jmp    8004dd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800566:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80056d:	e9 6b ff ff ff       	jmp    8004dd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800572:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800573:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800577:	0f 89 60 ff ff ff    	jns    8004dd <vprintfmt+0x54>
				width = precision, precision = -1;
  80057d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800580:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800583:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80058a:	e9 4e ff ff ff       	jmp    8004dd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80058f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800592:	e9 46 ff ff ff       	jmp    8004dd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	83 c0 04             	add    $0x4,%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	83 e8 04             	sub    $0x4,%eax
  8005a6:	8b 00                	mov    (%eax),%eax
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	ff 75 0c             	pushl  0xc(%ebp)
  8005ae:	50                   	push   %eax
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	ff d0                	call   *%eax
  8005b4:	83 c4 10             	add    $0x10,%esp
			break;
  8005b7:	e9 89 02 00 00       	jmp    800845 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bf:	83 c0 04             	add    $0x4,%eax
  8005c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	83 e8 04             	sub    $0x4,%eax
  8005cb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005cd:	85 db                	test   %ebx,%ebx
  8005cf:	79 02                	jns    8005d3 <vprintfmt+0x14a>
				err = -err;
  8005d1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005d3:	83 fb 64             	cmp    $0x64,%ebx
  8005d6:	7f 0b                	jg     8005e3 <vprintfmt+0x15a>
  8005d8:	8b 34 9d 40 1b 80 00 	mov    0x801b40(,%ebx,4),%esi
  8005df:	85 f6                	test   %esi,%esi
  8005e1:	75 19                	jne    8005fc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005e3:	53                   	push   %ebx
  8005e4:	68 e5 1c 80 00       	push   $0x801ce5
  8005e9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ec:	ff 75 08             	pushl  0x8(%ebp)
  8005ef:	e8 5e 02 00 00       	call   800852 <printfmt>
  8005f4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005f7:	e9 49 02 00 00       	jmp    800845 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005fc:	56                   	push   %esi
  8005fd:	68 ee 1c 80 00       	push   $0x801cee
  800602:	ff 75 0c             	pushl  0xc(%ebp)
  800605:	ff 75 08             	pushl  0x8(%ebp)
  800608:	e8 45 02 00 00       	call   800852 <printfmt>
  80060d:	83 c4 10             	add    $0x10,%esp
			break;
  800610:	e9 30 02 00 00       	jmp    800845 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	83 c0 04             	add    $0x4,%eax
  80061b:	89 45 14             	mov    %eax,0x14(%ebp)
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	83 e8 04             	sub    $0x4,%eax
  800624:	8b 30                	mov    (%eax),%esi
  800626:	85 f6                	test   %esi,%esi
  800628:	75 05                	jne    80062f <vprintfmt+0x1a6>
				p = "(null)";
  80062a:	be f1 1c 80 00       	mov    $0x801cf1,%esi
			if (width > 0 && padc != '-')
  80062f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800633:	7e 6d                	jle    8006a2 <vprintfmt+0x219>
  800635:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800639:	74 67                	je     8006a2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80063b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	50                   	push   %eax
  800642:	56                   	push   %esi
  800643:	e8 0c 03 00 00       	call   800954 <strnlen>
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80064e:	eb 16                	jmp    800666 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800650:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	50                   	push   %eax
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	ff d0                	call   *%eax
  800660:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800663:	ff 4d e4             	decl   -0x1c(%ebp)
  800666:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80066a:	7f e4                	jg     800650 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80066c:	eb 34                	jmp    8006a2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80066e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800672:	74 1c                	je     800690 <vprintfmt+0x207>
  800674:	83 fb 1f             	cmp    $0x1f,%ebx
  800677:	7e 05                	jle    80067e <vprintfmt+0x1f5>
  800679:	83 fb 7e             	cmp    $0x7e,%ebx
  80067c:	7e 12                	jle    800690 <vprintfmt+0x207>
					putch('?', putdat);
  80067e:	83 ec 08             	sub    $0x8,%esp
  800681:	ff 75 0c             	pushl  0xc(%ebp)
  800684:	6a 3f                	push   $0x3f
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	ff d0                	call   *%eax
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	eb 0f                	jmp    80069f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	ff 75 0c             	pushl  0xc(%ebp)
  800696:	53                   	push   %ebx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	ff d0                	call   *%eax
  80069c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80069f:	ff 4d e4             	decl   -0x1c(%ebp)
  8006a2:	89 f0                	mov    %esi,%eax
  8006a4:	8d 70 01             	lea    0x1(%eax),%esi
  8006a7:	8a 00                	mov    (%eax),%al
  8006a9:	0f be d8             	movsbl %al,%ebx
  8006ac:	85 db                	test   %ebx,%ebx
  8006ae:	74 24                	je     8006d4 <vprintfmt+0x24b>
  8006b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b4:	78 b8                	js     80066e <vprintfmt+0x1e5>
  8006b6:	ff 4d e0             	decl   -0x20(%ebp)
  8006b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006bd:	79 af                	jns    80066e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006bf:	eb 13                	jmp    8006d4 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	ff 75 0c             	pushl  0xc(%ebp)
  8006c7:	6a 20                	push   $0x20
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	ff d0                	call   *%eax
  8006ce:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d1:	ff 4d e4             	decl   -0x1c(%ebp)
  8006d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d8:	7f e7                	jg     8006c1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006da:	e9 66 01 00 00       	jmp    800845 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8006e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e8:	50                   	push   %eax
  8006e9:	e8 3c fd ff ff       	call   80042a <getint>
  8006ee:	83 c4 10             	add    $0x10,%esp
  8006f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006fd:	85 d2                	test   %edx,%edx
  8006ff:	79 23                	jns    800724 <vprintfmt+0x29b>
				putch('-', putdat);
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	ff 75 0c             	pushl  0xc(%ebp)
  800707:	6a 2d                	push   $0x2d
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	ff d0                	call   *%eax
  80070e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800717:	f7 d8                	neg    %eax
  800719:	83 d2 00             	adc    $0x0,%edx
  80071c:	f7 da                	neg    %edx
  80071e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800721:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800724:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80072b:	e9 bc 00 00 00       	jmp    8007ec <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 e8             	pushl  -0x18(%ebp)
  800736:	8d 45 14             	lea    0x14(%ebp),%eax
  800739:	50                   	push   %eax
  80073a:	e8 84 fc ff ff       	call   8003c3 <getuint>
  80073f:	83 c4 10             	add    $0x10,%esp
  800742:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800745:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800748:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80074f:	e9 98 00 00 00       	jmp    8007ec <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	6a 58                	push   $0x58
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	ff d0                	call   *%eax
  800761:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	6a 58                	push   $0x58
  80076c:	8b 45 08             	mov    0x8(%ebp),%eax
  80076f:	ff d0                	call   *%eax
  800771:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	ff 75 0c             	pushl  0xc(%ebp)
  80077a:	6a 58                	push   $0x58
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	ff d0                	call   *%eax
  800781:	83 c4 10             	add    $0x10,%esp
			break;
  800784:	e9 bc 00 00 00       	jmp    800845 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	6a 30                	push   $0x30
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	ff d0                	call   *%eax
  800796:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800799:	83 ec 08             	sub    $0x8,%esp
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	6a 78                	push   $0x78
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	ff d0                	call   *%eax
  8007a6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	83 c0 04             	add    $0x4,%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	83 e8 04             	sub    $0x4,%eax
  8007b8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007c4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007cb:	eb 1f                	jmp    8007ec <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d6:	50                   	push   %eax
  8007d7:	e8 e7 fb ff ff       	call   8003c3 <getuint>
  8007dc:	83 c4 10             	add    $0x10,%esp
  8007df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007e5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007ec:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f3:	83 ec 04             	sub    $0x4,%esp
  8007f6:	52                   	push   %edx
  8007f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007fa:	50                   	push   %eax
  8007fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8007fe:	ff 75 f0             	pushl  -0x10(%ebp)
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	ff 75 08             	pushl  0x8(%ebp)
  800807:	e8 00 fb ff ff       	call   80030c <printnum>
  80080c:	83 c4 20             	add    $0x20,%esp
			break;
  80080f:	eb 34                	jmp    800845 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	ff 75 0c             	pushl  0xc(%ebp)
  800817:	53                   	push   %ebx
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	ff d0                	call   *%eax
  80081d:	83 c4 10             	add    $0x10,%esp
			break;
  800820:	eb 23                	jmp    800845 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	6a 25                	push   $0x25
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	ff d0                	call   *%eax
  80082f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800832:	ff 4d 10             	decl   0x10(%ebp)
  800835:	eb 03                	jmp    80083a <vprintfmt+0x3b1>
  800837:	ff 4d 10             	decl   0x10(%ebp)
  80083a:	8b 45 10             	mov    0x10(%ebp),%eax
  80083d:	48                   	dec    %eax
  80083e:	8a 00                	mov    (%eax),%al
  800840:	3c 25                	cmp    $0x25,%al
  800842:	75 f3                	jne    800837 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800844:	90                   	nop
		}
	}
  800845:	e9 47 fc ff ff       	jmp    800491 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80084a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80084b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80084e:	5b                   	pop    %ebx
  80084f:	5e                   	pop    %esi
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800858:	8d 45 10             	lea    0x10(%ebp),%eax
  80085b:	83 c0 04             	add    $0x4,%eax
  80085e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800861:	8b 45 10             	mov    0x10(%ebp),%eax
  800864:	ff 75 f4             	pushl  -0xc(%ebp)
  800867:	50                   	push   %eax
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	ff 75 08             	pushl  0x8(%ebp)
  80086e:	e8 16 fc ff ff       	call   800489 <vprintfmt>
  800873:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800876:	90                   	nop
  800877:	c9                   	leave  
  800878:	c3                   	ret    

00800879 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80087c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087f:	8b 40 08             	mov    0x8(%eax),%eax
  800882:	8d 50 01             	lea    0x1(%eax),%edx
  800885:	8b 45 0c             	mov    0xc(%ebp),%eax
  800888:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80088b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088e:	8b 10                	mov    (%eax),%edx
  800890:	8b 45 0c             	mov    0xc(%ebp),%eax
  800893:	8b 40 04             	mov    0x4(%eax),%eax
  800896:	39 c2                	cmp    %eax,%edx
  800898:	73 12                	jae    8008ac <sprintputch+0x33>
		*b->buf++ = ch;
  80089a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 48 01             	lea    0x1(%eax),%ecx
  8008a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a5:	89 0a                	mov    %ecx,(%edx)
  8008a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8008aa:	88 10                	mov    %dl,(%eax)
}
  8008ac:	90                   	nop
  8008ad:	5d                   	pop    %ebp
  8008ae:	c3                   	ret    

008008af <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008be:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	01 d0                	add    %edx,%eax
  8008c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008d4:	74 06                	je     8008dc <vsnprintf+0x2d>
  8008d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008da:	7f 07                	jg     8008e3 <vsnprintf+0x34>
		return -E_INVAL;
  8008dc:	b8 03 00 00 00       	mov    $0x3,%eax
  8008e1:	eb 20                	jmp    800903 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e3:	ff 75 14             	pushl  0x14(%ebp)
  8008e6:	ff 75 10             	pushl  0x10(%ebp)
  8008e9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ec:	50                   	push   %eax
  8008ed:	68 79 08 80 00       	push   $0x800879
  8008f2:	e8 92 fb ff ff       	call   800489 <vprintfmt>
  8008f7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008fd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800900:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800903:	c9                   	leave  
  800904:	c3                   	ret    

00800905 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80090b:	8d 45 10             	lea    0x10(%ebp),%eax
  80090e:	83 c0 04             	add    $0x4,%eax
  800911:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800914:	8b 45 10             	mov    0x10(%ebp),%eax
  800917:	ff 75 f4             	pushl  -0xc(%ebp)
  80091a:	50                   	push   %eax
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	ff 75 08             	pushl  0x8(%ebp)
  800921:	e8 89 ff ff ff       	call   8008af <vsnprintf>
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80092c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80092f:	c9                   	leave  
  800930:	c3                   	ret    

00800931 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800937:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80093e:	eb 06                	jmp    800946 <strlen+0x15>
		n++;
  800940:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800943:	ff 45 08             	incl   0x8(%ebp)
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8a 00                	mov    (%eax),%al
  80094b:	84 c0                	test   %al,%al
  80094d:	75 f1                	jne    800940 <strlen+0xf>
		n++;
	return n;
  80094f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800952:	c9                   	leave  
  800953:	c3                   	ret    

00800954 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80095a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800961:	eb 09                	jmp    80096c <strnlen+0x18>
		n++;
  800963:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800966:	ff 45 08             	incl   0x8(%ebp)
  800969:	ff 4d 0c             	decl   0xc(%ebp)
  80096c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800970:	74 09                	je     80097b <strnlen+0x27>
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	8a 00                	mov    (%eax),%al
  800977:	84 c0                	test   %al,%al
  800979:	75 e8                	jne    800963 <strnlen+0xf>
		n++;
	return n;
  80097b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80097e:	c9                   	leave  
  80097f:	c3                   	ret    

00800980 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80098c:	90                   	nop
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8d 50 01             	lea    0x1(%eax),%edx
  800993:	89 55 08             	mov    %edx,0x8(%ebp)
  800996:	8b 55 0c             	mov    0xc(%ebp),%edx
  800999:	8d 4a 01             	lea    0x1(%edx),%ecx
  80099c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80099f:	8a 12                	mov    (%edx),%dl
  8009a1:	88 10                	mov    %dl,(%eax)
  8009a3:	8a 00                	mov    (%eax),%al
  8009a5:	84 c0                	test   %al,%al
  8009a7:	75 e4                	jne    80098d <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009ac:	c9                   	leave  
  8009ad:	c3                   	ret    

008009ae <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009c1:	eb 1f                	jmp    8009e2 <strncpy+0x34>
		*dst++ = *src;
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	8d 50 01             	lea    0x1(%eax),%edx
  8009c9:	89 55 08             	mov    %edx,0x8(%ebp)
  8009cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cf:	8a 12                	mov    (%edx),%dl
  8009d1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d6:	8a 00                	mov    (%eax),%al
  8009d8:	84 c0                	test   %al,%al
  8009da:	74 03                	je     8009df <strncpy+0x31>
			src++;
  8009dc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009df:	ff 45 fc             	incl   -0x4(%ebp)
  8009e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009e5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009e8:	72 d9                	jb     8009c3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009ed:	c9                   	leave  
  8009ee:	c3                   	ret    

008009ef <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009ff:	74 30                	je     800a31 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a01:	eb 16                	jmp    800a19 <strlcpy+0x2a>
			*dst++ = *src++;
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	8d 50 01             	lea    0x1(%eax),%edx
  800a09:	89 55 08             	mov    %edx,0x8(%ebp)
  800a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a12:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a15:	8a 12                	mov    (%edx),%dl
  800a17:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a19:	ff 4d 10             	decl   0x10(%ebp)
  800a1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a20:	74 09                	je     800a2b <strlcpy+0x3c>
  800a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a25:	8a 00                	mov    (%eax),%al
  800a27:	84 c0                	test   %al,%al
  800a29:	75 d8                	jne    800a03 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a31:	8b 55 08             	mov    0x8(%ebp),%edx
  800a34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a37:	29 c2                	sub    %eax,%edx
  800a39:	89 d0                	mov    %edx,%eax
}
  800a3b:	c9                   	leave  
  800a3c:	c3                   	ret    

00800a3d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a40:	eb 06                	jmp    800a48 <strcmp+0xb>
		p++, q++;
  800a42:	ff 45 08             	incl   0x8(%ebp)
  800a45:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	8a 00                	mov    (%eax),%al
  800a4d:	84 c0                	test   %al,%al
  800a4f:	74 0e                	je     800a5f <strcmp+0x22>
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	8a 10                	mov    (%eax),%dl
  800a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a59:	8a 00                	mov    (%eax),%al
  800a5b:	38 c2                	cmp    %al,%dl
  800a5d:	74 e3                	je     800a42 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	8a 00                	mov    (%eax),%al
  800a64:	0f b6 d0             	movzbl %al,%edx
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	8a 00                	mov    (%eax),%al
  800a6c:	0f b6 c0             	movzbl %al,%eax
  800a6f:	29 c2                	sub    %eax,%edx
  800a71:	89 d0                	mov    %edx,%eax
}
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a78:	eb 09                	jmp    800a83 <strncmp+0xe>
		n--, p++, q++;
  800a7a:	ff 4d 10             	decl   0x10(%ebp)
  800a7d:	ff 45 08             	incl   0x8(%ebp)
  800a80:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a87:	74 17                	je     800aa0 <strncmp+0x2b>
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8a 00                	mov    (%eax),%al
  800a8e:	84 c0                	test   %al,%al
  800a90:	74 0e                	je     800aa0 <strncmp+0x2b>
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	8a 10                	mov    (%eax),%dl
  800a97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9a:	8a 00                	mov    (%eax),%al
  800a9c:	38 c2                	cmp    %al,%dl
  800a9e:	74 da                	je     800a7a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800aa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa4:	75 07                	jne    800aad <strncmp+0x38>
		return 0;
  800aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  800aab:	eb 14                	jmp    800ac1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8a 00                	mov    (%eax),%al
  800ab2:	0f b6 d0             	movzbl %al,%edx
  800ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab8:	8a 00                	mov    (%eax),%al
  800aba:	0f b6 c0             	movzbl %al,%eax
  800abd:	29 c2                	sub    %eax,%edx
  800abf:	89 d0                	mov    %edx,%eax
}
  800ac1:	5d                   	pop    %ebp
  800ac2:	c3                   	ret    

00800ac3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	83 ec 04             	sub    $0x4,%esp
  800ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800acf:	eb 12                	jmp    800ae3 <strchr+0x20>
		if (*s == c)
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8a 00                	mov    (%eax),%al
  800ad6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ad9:	75 05                	jne    800ae0 <strchr+0x1d>
			return (char *) s;
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	eb 11                	jmp    800af1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ae0:	ff 45 08             	incl   0x8(%ebp)
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	8a 00                	mov    (%eax),%al
  800ae8:	84 c0                	test   %al,%al
  800aea:	75 e5                	jne    800ad1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800aec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af1:	c9                   	leave  
  800af2:	c3                   	ret    

00800af3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	83 ec 04             	sub    $0x4,%esp
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aff:	eb 0d                	jmp    800b0e <strfind+0x1b>
		if (*s == c)
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	8a 00                	mov    (%eax),%al
  800b06:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b09:	74 0e                	je     800b19 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b0b:	ff 45 08             	incl   0x8(%ebp)
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	8a 00                	mov    (%eax),%al
  800b13:	84 c0                	test   %al,%al
  800b15:	75 ea                	jne    800b01 <strfind+0xe>
  800b17:	eb 01                	jmp    800b1a <strfind+0x27>
		if (*s == c)
			break;
  800b19:	90                   	nop
	return (char *) s;
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b1d:	c9                   	leave  
  800b1e:	c3                   	ret    

00800b1f <memset>:

int i=0;
void *
memset(void *v, int c, uint32 n)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	83 ec 10             	sub    $0x10,%esp


	i++;
  800b25:	a1 28 20 80 00       	mov    0x802028,%eax
  800b2a:	40                   	inc    %eax
  800b2b:	a3 28 20 80 00       	mov    %eax,0x802028

	char *p;
	int m;

	p = v;
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b36:	8b 45 10             	mov    0x10(%ebp),%eax
  800b39:	89 45 f8             	mov    %eax,-0x8(%ebp)


	while (--m >= 0){
  800b3c:	eb 0e                	jmp    800b4c <memset+0x2d>

		*p++ = c;
  800b3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b41:	8d 50 01             	lea    0x1(%eax),%edx
  800b44:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4a:	88 10                	mov    %dl,(%eax)

	p = v;
	m = n;


	while (--m >= 0){
  800b4c:	ff 4d f8             	decl   -0x8(%ebp)
  800b4f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b53:	79 e9                	jns    800b3e <memset+0x1f>

		*p++ = c;
	}

	return v;
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b58:	c9                   	leave  
  800b59:	c3                   	ret    

00800b5a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b6c:	eb 16                	jmp    800b84 <memcpy+0x2a>
		*d++ = *s++;
  800b6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b71:	8d 50 01             	lea    0x1(%eax),%edx
  800b74:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b7d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b80:	8a 12                	mov    (%edx),%dl
  800b82:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b84:	8b 45 10             	mov    0x10(%ebp),%eax
  800b87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800b8d:	85 c0                	test   %eax,%eax
  800b8f:	75 dd                	jne    800b6e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b94:	c9                   	leave  
  800b95:	c3                   	ret    

00800b96 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ba8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bae:	73 50                	jae    800c00 <memmove+0x6a>
  800bb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb6:	01 d0                	add    %edx,%eax
  800bb8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bbb:	76 43                	jbe    800c00 <memmove+0x6a>
		s += n;
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bc9:	eb 10                	jmp    800bdb <memmove+0x45>
			*--d = *--s;
  800bcb:	ff 4d f8             	decl   -0x8(%ebp)
  800bce:	ff 4d fc             	decl   -0x4(%ebp)
  800bd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd4:	8a 10                	mov    (%eax),%dl
  800bd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bd9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bdb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bde:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be1:	89 55 10             	mov    %edx,0x10(%ebp)
  800be4:	85 c0                	test   %eax,%eax
  800be6:	75 e3                	jne    800bcb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be8:	eb 23                	jmp    800c0d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bed:	8d 50 01             	lea    0x1(%eax),%edx
  800bf0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bf3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bf6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bfc:	8a 12                	mov    (%edx),%dl
  800bfe:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c00:	8b 45 10             	mov    0x10(%ebp),%eax
  800c03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c06:	89 55 10             	mov    %edx,0x10(%ebp)
  800c09:	85 c0                	test   %eax,%eax
  800c0b:	75 dd                	jne    800bea <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c24:	eb 2a                	jmp    800c50 <memcmp+0x3e>
		if (*s1 != *s2)
  800c26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c29:	8a 10                	mov    (%eax),%dl
  800c2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c2e:	8a 00                	mov    (%eax),%al
  800c30:	38 c2                	cmp    %al,%dl
  800c32:	74 16                	je     800c4a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	0f b6 d0             	movzbl %al,%edx
  800c3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	0f b6 c0             	movzbl %al,%eax
  800c44:	29 c2                	sub    %eax,%edx
  800c46:	89 d0                	mov    %edx,%eax
  800c48:	eb 18                	jmp    800c62 <memcmp+0x50>
		s1++, s2++;
  800c4a:	ff 45 fc             	incl   -0x4(%ebp)
  800c4d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c50:	8b 45 10             	mov    0x10(%ebp),%eax
  800c53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c56:	89 55 10             	mov    %edx,0x10(%ebp)
  800c59:	85 c0                	test   %eax,%eax
  800c5b:	75 c9                	jne    800c26 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c62:	c9                   	leave  
  800c63:	c3                   	ret    

00800c64 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c70:	01 d0                	add    %edx,%eax
  800c72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c75:	eb 15                	jmp    800c8c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	8a 00                	mov    (%eax),%al
  800c7c:	0f b6 d0             	movzbl %al,%edx
  800c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c82:	0f b6 c0             	movzbl %al,%eax
  800c85:	39 c2                	cmp    %eax,%edx
  800c87:	74 0d                	je     800c96 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c89:	ff 45 08             	incl   0x8(%ebp)
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c92:	72 e3                	jb     800c77 <memfind+0x13>
  800c94:	eb 01                	jmp    800c97 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c96:	90                   	nop
	return (void *) s;
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ca2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ca9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb0:	eb 03                	jmp    800cb5 <strtol+0x19>
		s++;
  800cb2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	3c 20                	cmp    $0x20,%al
  800cbc:	74 f4                	je     800cb2 <strtol+0x16>
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	3c 09                	cmp    $0x9,%al
  800cc5:	74 eb                	je     800cb2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	3c 2b                	cmp    $0x2b,%al
  800cce:	75 05                	jne    800cd5 <strtol+0x39>
		s++;
  800cd0:	ff 45 08             	incl   0x8(%ebp)
  800cd3:	eb 13                	jmp    800ce8 <strtol+0x4c>
	else if (*s == '-')
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	3c 2d                	cmp    $0x2d,%al
  800cdc:	75 0a                	jne    800ce8 <strtol+0x4c>
		s++, neg = 1;
  800cde:	ff 45 08             	incl   0x8(%ebp)
  800ce1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cec:	74 06                	je     800cf4 <strtol+0x58>
  800cee:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cf2:	75 20                	jne    800d14 <strtol+0x78>
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	3c 30                	cmp    $0x30,%al
  800cfb:	75 17                	jne    800d14 <strtol+0x78>
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	40                   	inc    %eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	3c 78                	cmp    $0x78,%al
  800d05:	75 0d                	jne    800d14 <strtol+0x78>
		s += 2, base = 16;
  800d07:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d0b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d12:	eb 28                	jmp    800d3c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d18:	75 15                	jne    800d2f <strtol+0x93>
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	3c 30                	cmp    $0x30,%al
  800d21:	75 0c                	jne    800d2f <strtol+0x93>
		s++, base = 8;
  800d23:	ff 45 08             	incl   0x8(%ebp)
  800d26:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d2d:	eb 0d                	jmp    800d3c <strtol+0xa0>
	else if (base == 0)
  800d2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d33:	75 07                	jne    800d3c <strtol+0xa0>
		base = 10;
  800d35:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	3c 2f                	cmp    $0x2f,%al
  800d43:	7e 19                	jle    800d5e <strtol+0xc2>
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	3c 39                	cmp    $0x39,%al
  800d4c:	7f 10                	jg     800d5e <strtol+0xc2>
			dig = *s - '0';
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	0f be c0             	movsbl %al,%eax
  800d56:	83 e8 30             	sub    $0x30,%eax
  800d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d5c:	eb 42                	jmp    800da0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	3c 60                	cmp    $0x60,%al
  800d65:	7e 19                	jle    800d80 <strtol+0xe4>
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	3c 7a                	cmp    $0x7a,%al
  800d6e:	7f 10                	jg     800d80 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f be c0             	movsbl %al,%eax
  800d78:	83 e8 57             	sub    $0x57,%eax
  800d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d7e:	eb 20                	jmp    800da0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3c 40                	cmp    $0x40,%al
  800d87:	7e 39                	jle    800dc2 <strtol+0x126>
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	3c 5a                	cmp    $0x5a,%al
  800d90:	7f 30                	jg     800dc2 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	0f be c0             	movsbl %al,%eax
  800d9a:	83 e8 37             	sub    $0x37,%eax
  800d9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800da3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800da6:	7d 19                	jge    800dc1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dae:	0f af 45 10          	imul   0x10(%ebp),%eax
  800db2:	89 c2                	mov    %eax,%edx
  800db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db7:	01 d0                	add    %edx,%eax
  800db9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dbc:	e9 7b ff ff ff       	jmp    800d3c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dc1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dc2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc6:	74 08                	je     800dd0 <strtol+0x134>
		*endptr = (char *) s;
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dce:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dd4:	74 07                	je     800ddd <strtol+0x141>
  800dd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd9:	f7 d8                	neg    %eax
  800ddb:	eb 03                	jmp    800de0 <strtol+0x144>
  800ddd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <ltostr>:

void
ltostr(long value, char *str)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800def:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800df6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dfa:	79 13                	jns    800e0f <ltostr+0x2d>
	{
		neg = 1;
  800dfc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e09:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e0c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e17:	99                   	cltd   
  800e18:	f7 f9                	idiv   %ecx
  800e1a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e20:	8d 50 01             	lea    0x1(%eax),%edx
  800e23:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e26:	89 c2                	mov    %eax,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	01 d0                	add    %edx,%eax
  800e2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e30:	83 c2 30             	add    $0x30,%edx
  800e33:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e38:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e3d:	f7 e9                	imul   %ecx
  800e3f:	c1 fa 02             	sar    $0x2,%edx
  800e42:	89 c8                	mov    %ecx,%eax
  800e44:	c1 f8 1f             	sar    $0x1f,%eax
  800e47:	29 c2                	sub    %eax,%edx
  800e49:	89 d0                	mov    %edx,%eax
  800e4b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e51:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e56:	f7 e9                	imul   %ecx
  800e58:	c1 fa 02             	sar    $0x2,%edx
  800e5b:	89 c8                	mov    %ecx,%eax
  800e5d:	c1 f8 1f             	sar    $0x1f,%eax
  800e60:	29 c2                	sub    %eax,%edx
  800e62:	89 d0                	mov    %edx,%eax
  800e64:	c1 e0 02             	shl    $0x2,%eax
  800e67:	01 d0                	add    %edx,%eax
  800e69:	01 c0                	add    %eax,%eax
  800e6b:	29 c1                	sub    %eax,%ecx
  800e6d:	89 ca                	mov    %ecx,%edx
  800e6f:	85 d2                	test   %edx,%edx
  800e71:	75 9c                	jne    800e0f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7d:	48                   	dec    %eax
  800e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e81:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e85:	74 3d                	je     800ec4 <ltostr+0xe2>
		start = 1 ;
  800e87:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e8e:	eb 34                	jmp    800ec4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	01 d0                	add    %edx,%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea3:	01 c2                	add    %eax,%edx
  800ea5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	01 c8                	add    %ecx,%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800eb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb7:	01 c2                	add    %eax,%edx
  800eb9:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ebc:	88 02                	mov    %al,(%edx)
		start++ ;
  800ebe:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ec1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800eca:	7c c4                	jl     800e90 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ecc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed2:	01 d0                	add    %edx,%eax
  800ed4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ed7:	90                   	nop
  800ed8:	c9                   	leave  
  800ed9:	c3                   	ret    

00800eda <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ee0:	ff 75 08             	pushl  0x8(%ebp)
  800ee3:	e8 49 fa ff ff       	call   800931 <strlen>
  800ee8:	83 c4 04             	add    $0x4,%esp
  800eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800eee:	ff 75 0c             	pushl  0xc(%ebp)
  800ef1:	e8 3b fa ff ff       	call   800931 <strlen>
  800ef6:	83 c4 04             	add    $0x4,%esp
  800ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800efc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f0a:	eb 17                	jmp    800f23 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	01 c2                	add    %eax,%edx
  800f14:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	01 c8                	add    %ecx,%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f20:	ff 45 fc             	incl   -0x4(%ebp)
  800f23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f26:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f29:	7c e1                	jl     800f0c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f2b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f32:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f39:	eb 1f                	jmp    800f5a <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3e:	8d 50 01             	lea    0x1(%eax),%edx
  800f41:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f44:	89 c2                	mov    %eax,%edx
  800f46:	8b 45 10             	mov    0x10(%ebp),%eax
  800f49:	01 c2                	add    %eax,%edx
  800f4b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	01 c8                	add    %ecx,%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f57:	ff 45 f8             	incl   -0x8(%ebp)
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f60:	7c d9                	jl     800f3b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	01 d0                	add    %edx,%eax
  800f6a:	c6 00 00             	movb   $0x0,(%eax)
}
  800f6d:	90                   	nop
  800f6e:	c9                   	leave  
  800f6f:	c3                   	ret    

00800f70 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7f:	8b 00                	mov    (%eax),%eax
  800f81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f88:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8b:	01 d0                	add    %edx,%eax
  800f8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f93:	eb 0c                	jmp    800fa1 <strsplit+0x31>
			*string++ = 0;
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	8d 50 01             	lea    0x1(%eax),%edx
  800f9b:	89 55 08             	mov    %edx,0x8(%ebp)
  800f9e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	84 c0                	test   %al,%al
  800fa8:	74 18                	je     800fc2 <strsplit+0x52>
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f be c0             	movsbl %al,%eax
  800fb2:	50                   	push   %eax
  800fb3:	ff 75 0c             	pushl  0xc(%ebp)
  800fb6:	e8 08 fb ff ff       	call   800ac3 <strchr>
  800fbb:	83 c4 08             	add    $0x8,%esp
  800fbe:	85 c0                	test   %eax,%eax
  800fc0:	75 d3                	jne    800f95 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	84 c0                	test   %al,%al
  800fc9:	74 5a                	je     801025 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fce:	8b 00                	mov    (%eax),%eax
  800fd0:	83 f8 0f             	cmp    $0xf,%eax
  800fd3:	75 07                	jne    800fdc <strsplit+0x6c>
		{
			return 0;
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fda:	eb 66                	jmp    801042 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdf:	8b 00                	mov    (%eax),%eax
  800fe1:	8d 48 01             	lea    0x1(%eax),%ecx
  800fe4:	8b 55 14             	mov    0x14(%ebp),%edx
  800fe7:	89 0a                	mov    %ecx,(%edx)
  800fe9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ff0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff3:	01 c2                	add    %eax,%edx
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ffa:	eb 03                	jmp    800fff <strsplit+0x8f>
			string++;
  800ffc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	84 c0                	test   %al,%al
  801006:	74 8b                	je     800f93 <strsplit+0x23>
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8a 00                	mov    (%eax),%al
  80100d:	0f be c0             	movsbl %al,%eax
  801010:	50                   	push   %eax
  801011:	ff 75 0c             	pushl  0xc(%ebp)
  801014:	e8 aa fa ff ff       	call   800ac3 <strchr>
  801019:	83 c4 08             	add    $0x8,%esp
  80101c:	85 c0                	test   %eax,%eax
  80101e:	74 dc                	je     800ffc <strsplit+0x8c>
			string++;
	}
  801020:	e9 6e ff ff ff       	jmp    800f93 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801025:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801026:	8b 45 14             	mov    0x14(%ebp),%eax
  801029:	8b 00                	mov    (%eax),%eax
  80102b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801032:	8b 45 10             	mov    0x10(%ebp),%eax
  801035:	01 d0                	add    %edx,%eax
  801037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80103d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  80104a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80104e:	74 06                	je     801056 <str2lower+0x12>
  801050:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801054:	75 07                	jne    80105d <str2lower+0x19>
		return NULL;
  801056:	b8 00 00 00 00       	mov    $0x0,%eax
  80105b:	eb 4d                	jmp    8010aa <str2lower+0x66>
	}
	char *ref=dst;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  801063:	eb 33                	jmp    801098 <str2lower+0x54>
			if(*src>=65&&*src<=90){
  801065:	8b 45 0c             	mov    0xc(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3c 40                	cmp    $0x40,%al
  80106c:	7e 1a                	jle    801088 <str2lower+0x44>
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	3c 5a                	cmp    $0x5a,%al
  801075:	7f 11                	jg     801088 <str2lower+0x44>
				*dst=*src+32;
  801077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107a:	8a 00                	mov    (%eax),%al
  80107c:	83 c0 20             	add    $0x20,%eax
  80107f:	88 c2                	mov    %al,%dl
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	88 10                	mov    %dl,(%eax)
  801086:	eb 0a                	jmp    801092 <str2lower+0x4e>
			}
			else{
				*dst=*src;
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	8a 10                	mov    (%eax),%dl
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	88 10                	mov    %dl,(%eax)
			}
			src++;
  801092:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  801095:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	84 c0                	test   %al,%al
  80109f:	75 c4                	jne    801065 <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  8010a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010aa:	c9                   	leave  
  8010ab:	c3                   	ret    

008010ac <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	57                   	push   %edi
  8010b0:	56                   	push   %esi
  8010b1:	53                   	push   %ebx
  8010b2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010be:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010c1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010c4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010c7:	cd 30                	int    $0x30
  8010c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8010cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010cf:	83 c4 10             	add    $0x10,%esp
  8010d2:	5b                   	pop    %ebx
  8010d3:	5e                   	pop    %esi
  8010d4:	5f                   	pop    %edi
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    

008010d7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	83 ec 04             	sub    $0x4,%esp
  8010dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010e3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	6a 00                	push   $0x0
  8010ec:	6a 00                	push   $0x0
  8010ee:	52                   	push   %edx
  8010ef:	ff 75 0c             	pushl  0xc(%ebp)
  8010f2:	50                   	push   %eax
  8010f3:	6a 00                	push   $0x0
  8010f5:	e8 b2 ff ff ff       	call   8010ac <syscall>
  8010fa:	83 c4 18             	add    $0x18,%esp
}
  8010fd:	90                   	nop
  8010fe:	c9                   	leave  
  8010ff:	c3                   	ret    

00801100 <sys_cgetc>:

int
sys_cgetc(void)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801103:	6a 00                	push   $0x0
  801105:	6a 00                	push   $0x0
  801107:	6a 00                	push   $0x0
  801109:	6a 00                	push   $0x0
  80110b:	6a 00                	push   $0x0
  80110d:	6a 01                	push   $0x1
  80110f:	e8 98 ff ff ff       	call   8010ac <syscall>
  801114:	83 c4 18             	add    $0x18,%esp
}
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80111c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	6a 00                	push   $0x0
  801128:	52                   	push   %edx
  801129:	50                   	push   %eax
  80112a:	6a 05                	push   $0x5
  80112c:	e8 7b ff ff ff       	call   8010ac <syscall>
  801131:	83 c4 18             	add    $0x18,%esp
}
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	56                   	push   %esi
  80113a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80113b:	8b 75 18             	mov    0x18(%ebp),%esi
  80113e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801141:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801144:	8b 55 0c             	mov    0xc(%ebp),%edx
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	56                   	push   %esi
  80114b:	53                   	push   %ebx
  80114c:	51                   	push   %ecx
  80114d:	52                   	push   %edx
  80114e:	50                   	push   %eax
  80114f:	6a 06                	push   $0x6
  801151:	e8 56 ff ff ff       	call   8010ac <syscall>
  801156:	83 c4 18             	add    $0x18,%esp
}
  801159:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80115c:	5b                   	pop    %ebx
  80115d:	5e                   	pop    %esi
  80115e:	5d                   	pop    %ebp
  80115f:	c3                   	ret    

00801160 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801163:	8b 55 0c             	mov    0xc(%ebp),%edx
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	6a 00                	push   $0x0
  80116b:	6a 00                	push   $0x0
  80116d:	6a 00                	push   $0x0
  80116f:	52                   	push   %edx
  801170:	50                   	push   %eax
  801171:	6a 07                	push   $0x7
  801173:	e8 34 ff ff ff       	call   8010ac <syscall>
  801178:	83 c4 18             	add    $0x18,%esp
}
  80117b:	c9                   	leave  
  80117c:	c3                   	ret    

0080117d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801180:	6a 00                	push   $0x0
  801182:	6a 00                	push   $0x0
  801184:	6a 00                	push   $0x0
  801186:	ff 75 0c             	pushl  0xc(%ebp)
  801189:	ff 75 08             	pushl  0x8(%ebp)
  80118c:	6a 08                	push   $0x8
  80118e:	e8 19 ff ff ff       	call   8010ac <syscall>
  801193:	83 c4 18             	add    $0x18,%esp
}
  801196:	c9                   	leave  
  801197:	c3                   	ret    

00801198 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80119b:	6a 00                	push   $0x0
  80119d:	6a 00                	push   $0x0
  80119f:	6a 00                	push   $0x0
  8011a1:	6a 00                	push   $0x0
  8011a3:	6a 00                	push   $0x0
  8011a5:	6a 09                	push   $0x9
  8011a7:	e8 00 ff ff ff       	call   8010ac <syscall>
  8011ac:	83 c4 18             	add    $0x18,%esp
}
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 00                	push   $0x0
  8011b8:	6a 00                	push   $0x0
  8011ba:	6a 00                	push   $0x0
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 0a                	push   $0xa
  8011c0:	e8 e7 fe ff ff       	call   8010ac <syscall>
  8011c5:	83 c4 18             	add    $0x18,%esp
}
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011cd:	6a 00                	push   $0x0
  8011cf:	6a 00                	push   $0x0
  8011d1:	6a 00                	push   $0x0
  8011d3:	6a 00                	push   $0x0
  8011d5:	6a 00                	push   $0x0
  8011d7:	6a 0b                	push   $0xb
  8011d9:	e8 ce fe ff ff       	call   8010ac <syscall>
  8011de:	83 c4 18             	add    $0x18,%esp
}
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    

008011e3 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011e6:	6a 00                	push   $0x0
  8011e8:	6a 00                	push   $0x0
  8011ea:	6a 00                	push   $0x0
  8011ec:	6a 00                	push   $0x0
  8011ee:	6a 00                	push   $0x0
  8011f0:	6a 0c                	push   $0xc
  8011f2:	e8 b5 fe ff ff       	call   8010ac <syscall>
  8011f7:	83 c4 18             	add    $0x18,%esp
}
  8011fa:	c9                   	leave  
  8011fb:	c3                   	ret    

008011fc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011ff:	6a 00                	push   $0x0
  801201:	6a 00                	push   $0x0
  801203:	6a 00                	push   $0x0
  801205:	6a 00                	push   $0x0
  801207:	ff 75 08             	pushl  0x8(%ebp)
  80120a:	6a 0d                	push   $0xd
  80120c:	e8 9b fe ff ff       	call   8010ac <syscall>
  801211:	83 c4 18             	add    $0x18,%esp
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801219:	6a 00                	push   $0x0
  80121b:	6a 00                	push   $0x0
  80121d:	6a 00                	push   $0x0
  80121f:	6a 00                	push   $0x0
  801221:	6a 00                	push   $0x0
  801223:	6a 0e                	push   $0xe
  801225:	e8 82 fe ff ff       	call   8010ac <syscall>
  80122a:	83 c4 18             	add    $0x18,%esp
}
  80122d:	90                   	nop
  80122e:	c9                   	leave  
  80122f:	c3                   	ret    

00801230 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 11                	push   $0x11
  80123f:	e8 68 fe ff ff       	call   8010ac <syscall>
  801244:	83 c4 18             	add    $0x18,%esp
}
  801247:	90                   	nop
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	6a 00                	push   $0x0
  801255:	6a 00                	push   $0x0
  801257:	6a 12                	push   $0x12
  801259:	e8 4e fe ff ff       	call   8010ac <syscall>
  80125e:	83 c4 18             	add    $0x18,%esp
}
  801261:	90                   	nop
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <sys_cputc>:


void
sys_cputc(const char c)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	83 ec 04             	sub    $0x4,%esp
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801270:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801274:	6a 00                	push   $0x0
  801276:	6a 00                	push   $0x0
  801278:	6a 00                	push   $0x0
  80127a:	6a 00                	push   $0x0
  80127c:	50                   	push   %eax
  80127d:	6a 13                	push   $0x13
  80127f:	e8 28 fe ff ff       	call   8010ac <syscall>
  801284:	83 c4 18             	add    $0x18,%esp
}
  801287:	90                   	nop
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 00                	push   $0x0
  801297:	6a 14                	push   $0x14
  801299:	e8 0e fe ff ff       	call   8010ac <syscall>
  80129e:	83 c4 18             	add    $0x18,%esp
}
  8012a1:	90                   	nop
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 00                	push   $0x0
  8012b0:	ff 75 0c             	pushl  0xc(%ebp)
  8012b3:	50                   	push   %eax
  8012b4:	6a 15                	push   $0x15
  8012b6:	e8 f1 fd ff ff       	call   8010ac <syscall>
  8012bb:	83 c4 18             	add    $0x18,%esp
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	6a 00                	push   $0x0
  8012cb:	6a 00                	push   $0x0
  8012cd:	6a 00                	push   $0x0
  8012cf:	52                   	push   %edx
  8012d0:	50                   	push   %eax
  8012d1:	6a 18                	push   $0x18
  8012d3:	e8 d4 fd ff ff       	call   8010ac <syscall>
  8012d8:	83 c4 18             	add    $0x18,%esp
}
  8012db:	c9                   	leave  
  8012dc:	c3                   	ret    

008012dd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	6a 00                	push   $0x0
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	52                   	push   %edx
  8012ed:	50                   	push   %eax
  8012ee:	6a 16                	push   $0x16
  8012f0:	e8 b7 fd ff ff       	call   8010ac <syscall>
  8012f5:	83 c4 18             	add    $0x18,%esp
}
  8012f8:	90                   	nop
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	52                   	push   %edx
  80130b:	50                   	push   %eax
  80130c:	6a 17                	push   $0x17
  80130e:	e8 99 fd ff ff       	call   8010ac <syscall>
  801313:	83 c4 18             	add    $0x18,%esp
}
  801316:	90                   	nop
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 04             	sub    $0x4,%esp
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801325:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801328:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	6a 00                	push   $0x0
  801331:	51                   	push   %ecx
  801332:	52                   	push   %edx
  801333:	ff 75 0c             	pushl  0xc(%ebp)
  801336:	50                   	push   %eax
  801337:	6a 19                	push   $0x19
  801339:	e8 6e fd ff ff       	call   8010ac <syscall>
  80133e:	83 c4 18             	add    $0x18,%esp
}
  801341:	c9                   	leave  
  801342:	c3                   	ret    

00801343 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801346:	8b 55 0c             	mov    0xc(%ebp),%edx
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	52                   	push   %edx
  801353:	50                   	push   %eax
  801354:	6a 1a                	push   $0x1a
  801356:	e8 51 fd ff ff       	call   8010ac <syscall>
  80135b:	83 c4 18             	add    $0x18,%esp
}
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    

00801360 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801363:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801366:	8b 55 0c             	mov    0xc(%ebp),%edx
  801369:	8b 45 08             	mov    0x8(%ebp),%eax
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	51                   	push   %ecx
  801371:	52                   	push   %edx
  801372:	50                   	push   %eax
  801373:	6a 1b                	push   $0x1b
  801375:	e8 32 fd ff ff       	call   8010ac <syscall>
  80137a:	83 c4 18             	add    $0x18,%esp
}
  80137d:	c9                   	leave  
  80137e:	c3                   	ret    

0080137f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801382:	8b 55 0c             	mov    0xc(%ebp),%edx
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	52                   	push   %edx
  80138f:	50                   	push   %eax
  801390:	6a 1c                	push   $0x1c
  801392:	e8 15 fd ff ff       	call   8010ac <syscall>
  801397:	83 c4 18             	add    $0x18,%esp
}
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 1d                	push   $0x1d
  8013ab:	e8 fc fc ff ff       	call   8010ac <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	6a 00                	push   $0x0
  8013bd:	ff 75 14             	pushl  0x14(%ebp)
  8013c0:	ff 75 10             	pushl  0x10(%ebp)
  8013c3:	ff 75 0c             	pushl  0xc(%ebp)
  8013c6:	50                   	push   %eax
  8013c7:	6a 1e                	push   $0x1e
  8013c9:	e8 de fc ff ff       	call   8010ac <syscall>
  8013ce:	83 c4 18             	add    $0x18,%esp
}
  8013d1:	c9                   	leave  
  8013d2:	c3                   	ret    

008013d3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	50                   	push   %eax
  8013e2:	6a 1f                	push   $0x1f
  8013e4:	e8 c3 fc ff ff       	call   8010ac <syscall>
  8013e9:	83 c4 18             	add    $0x18,%esp
}
  8013ec:	90                   	nop
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	50                   	push   %eax
  8013fe:	6a 20                	push   $0x20
  801400:	e8 a7 fc ff ff       	call   8010ac <syscall>
  801405:	83 c4 18             	add    $0x18,%esp
}
  801408:	c9                   	leave  
  801409:	c3                   	ret    

0080140a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 02                	push   $0x2
  801419:	e8 8e fc ff ff       	call   8010ac <syscall>
  80141e:	83 c4 18             	add    $0x18,%esp
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 03                	push   $0x3
  801432:	e8 75 fc ff ff       	call   8010ac <syscall>
  801437:	83 c4 18             	add    $0x18,%esp
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 04                	push   $0x4
  80144b:	e8 5c fc ff ff       	call   8010ac <syscall>
  801450:	83 c4 18             	add    $0x18,%esp
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <sys_exit_env>:


void sys_exit_env(void)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 21                	push   $0x21
  801464:	e8 43 fc ff ff       	call   8010ac <syscall>
  801469:	83 c4 18             	add    $0x18,%esp
}
  80146c:	90                   	nop
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801475:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801478:	8d 50 04             	lea    0x4(%eax),%edx
  80147b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	52                   	push   %edx
  801485:	50                   	push   %eax
  801486:	6a 22                	push   $0x22
  801488:	e8 1f fc ff ff       	call   8010ac <syscall>
  80148d:	83 c4 18             	add    $0x18,%esp
	return result;
  801490:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801493:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801496:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801499:	89 01                	mov    %eax,(%ecx)
  80149b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	c9                   	leave  
  8014a2:	c2 04 00             	ret    $0x4

008014a5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	ff 75 10             	pushl  0x10(%ebp)
  8014af:	ff 75 0c             	pushl  0xc(%ebp)
  8014b2:	ff 75 08             	pushl  0x8(%ebp)
  8014b5:	6a 10                	push   $0x10
  8014b7:	e8 f0 fb ff ff       	call   8010ac <syscall>
  8014bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8014bf:	90                   	nop
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 23                	push   $0x23
  8014d1:	e8 d6 fb ff ff       	call   8010ac <syscall>
  8014d6:	83 c4 18             	add    $0x18,%esp
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	83 ec 04             	sub    $0x4,%esp
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014e7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	50                   	push   %eax
  8014f4:	6a 24                	push   $0x24
  8014f6:	e8 b1 fb ff ff       	call   8010ac <syscall>
  8014fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8014fe:	90                   	nop
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <rsttst>:
void rsttst()
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 26                	push   $0x26
  801510:	e8 97 fb ff ff       	call   8010ac <syscall>
  801515:	83 c4 18             	add    $0x18,%esp
	return ;
  801518:	90                   	nop
}
  801519:	c9                   	leave  
  80151a:	c3                   	ret    

0080151b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
  80151e:	83 ec 04             	sub    $0x4,%esp
  801521:	8b 45 14             	mov    0x14(%ebp),%eax
  801524:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801527:	8b 55 18             	mov    0x18(%ebp),%edx
  80152a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80152e:	52                   	push   %edx
  80152f:	50                   	push   %eax
  801530:	ff 75 10             	pushl  0x10(%ebp)
  801533:	ff 75 0c             	pushl  0xc(%ebp)
  801536:	ff 75 08             	pushl  0x8(%ebp)
  801539:	6a 25                	push   $0x25
  80153b:	e8 6c fb ff ff       	call   8010ac <syscall>
  801540:	83 c4 18             	add    $0x18,%esp
	return ;
  801543:	90                   	nop
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <chktst>:
void chktst(uint32 n)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	ff 75 08             	pushl  0x8(%ebp)
  801554:	6a 27                	push   $0x27
  801556:	e8 51 fb ff ff       	call   8010ac <syscall>
  80155b:	83 c4 18             	add    $0x18,%esp
	return ;
  80155e:	90                   	nop
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <inctst>:

void inctst()
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 28                	push   $0x28
  801570:	e8 37 fb ff ff       	call   8010ac <syscall>
  801575:	83 c4 18             	add    $0x18,%esp
	return ;
  801578:	90                   	nop
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <gettst>:
uint32 gettst()
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 29                	push   $0x29
  80158a:	e8 1d fb ff ff       	call   8010ac <syscall>
  80158f:	83 c4 18             	add    $0x18,%esp
}
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 2a                	push   $0x2a
  8015a6:	e8 01 fb ff ff       	call   8010ac <syscall>
  8015ab:	83 c4 18             	add    $0x18,%esp
  8015ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8015b1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8015b5:	75 07                	jne    8015be <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8015b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8015bc:	eb 05                	jmp    8015c3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 2a                	push   $0x2a
  8015d7:	e8 d0 fa ff ff       	call   8010ac <syscall>
  8015dc:	83 c4 18             	add    $0x18,%esp
  8015df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015e2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015e6:	75 07                	jne    8015ef <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8015ed:	eb 05                	jmp    8015f4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 2a                	push   $0x2a
  801608:	e8 9f fa ff ff       	call   8010ac <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
  801610:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801613:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801617:	75 07                	jne    801620 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801619:	b8 01 00 00 00       	mov    $0x1,%eax
  80161e:	eb 05                	jmp    801625 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 2a                	push   $0x2a
  801639:	e8 6e fa ff ff       	call   8010ac <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
  801641:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801644:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801648:	75 07                	jne    801651 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80164a:	b8 01 00 00 00       	mov    $0x1,%eax
  80164f:	eb 05                	jmp    801656 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801651:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	ff 75 08             	pushl  0x8(%ebp)
  801666:	6a 2b                	push   $0x2b
  801668:	e8 3f fa ff ff       	call   8010ac <syscall>
  80166d:	83 c4 18             	add    $0x18,%esp
	return ;
  801670:	90                   	nop
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801677:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80167a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80167d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	6a 00                	push   $0x0
  801685:	53                   	push   %ebx
  801686:	51                   	push   %ecx
  801687:	52                   	push   %edx
  801688:	50                   	push   %eax
  801689:	6a 2c                	push   $0x2c
  80168b:	e8 1c fa ff ff       	call   8010ac <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
}
  801693:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80169b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	52                   	push   %edx
  8016a8:	50                   	push   %eax
  8016a9:	6a 2d                	push   $0x2d
  8016ab:	e8 fc f9 ff ff       	call   8010ac <syscall>
  8016b0:	83 c4 18             	add    $0x18,%esp
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016b8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	6a 00                	push   $0x0
  8016c3:	51                   	push   %ecx
  8016c4:	ff 75 10             	pushl  0x10(%ebp)
  8016c7:	52                   	push   %edx
  8016c8:	50                   	push   %eax
  8016c9:	6a 2e                	push   $0x2e
  8016cb:	e8 dc f9 ff ff       	call   8010ac <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	ff 75 10             	pushl  0x10(%ebp)
  8016df:	ff 75 0c             	pushl  0xc(%ebp)
  8016e2:	ff 75 08             	pushl  0x8(%ebp)
  8016e5:	6a 0f                	push   $0xf
  8016e7:	e8 c0 f9 ff ff       	call   8010ac <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ef:	90                   	nop
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	50                   	push   %eax
  801701:	6a 2f                	push   $0x2f
  801703:	e8 a4 f9 ff ff       	call   8010ac <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	ff 75 0c             	pushl  0xc(%ebp)
  801719:	ff 75 08             	pushl  0x8(%ebp)
  80171c:	6a 30                	push   $0x30
  80171e:	e8 89 f9 ff ff       	call   8010ac <syscall>
  801723:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801726:	90                   	nop
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	ff 75 0c             	pushl  0xc(%ebp)
  801735:	ff 75 08             	pushl  0x8(%ebp)
  801738:	6a 31                	push   $0x31
  80173a:	e8 6d f9 ff ff       	call   8010ac <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801742:	90                   	nop
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    
  801745:	66 90                	xchg   %ax,%ax
  801747:	90                   	nop

00801748 <__udivdi3>:
  801748:	55                   	push   %ebp
  801749:	57                   	push   %edi
  80174a:	56                   	push   %esi
  80174b:	53                   	push   %ebx
  80174c:	83 ec 1c             	sub    $0x1c,%esp
  80174f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801753:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801757:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80175b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80175f:	89 ca                	mov    %ecx,%edx
  801761:	89 f8                	mov    %edi,%eax
  801763:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801767:	85 f6                	test   %esi,%esi
  801769:	75 2d                	jne    801798 <__udivdi3+0x50>
  80176b:	39 cf                	cmp    %ecx,%edi
  80176d:	77 65                	ja     8017d4 <__udivdi3+0x8c>
  80176f:	89 fd                	mov    %edi,%ebp
  801771:	85 ff                	test   %edi,%edi
  801773:	75 0b                	jne    801780 <__udivdi3+0x38>
  801775:	b8 01 00 00 00       	mov    $0x1,%eax
  80177a:	31 d2                	xor    %edx,%edx
  80177c:	f7 f7                	div    %edi
  80177e:	89 c5                	mov    %eax,%ebp
  801780:	31 d2                	xor    %edx,%edx
  801782:	89 c8                	mov    %ecx,%eax
  801784:	f7 f5                	div    %ebp
  801786:	89 c1                	mov    %eax,%ecx
  801788:	89 d8                	mov    %ebx,%eax
  80178a:	f7 f5                	div    %ebp
  80178c:	89 cf                	mov    %ecx,%edi
  80178e:	89 fa                	mov    %edi,%edx
  801790:	83 c4 1c             	add    $0x1c,%esp
  801793:	5b                   	pop    %ebx
  801794:	5e                   	pop    %esi
  801795:	5f                   	pop    %edi
  801796:	5d                   	pop    %ebp
  801797:	c3                   	ret    
  801798:	39 ce                	cmp    %ecx,%esi
  80179a:	77 28                	ja     8017c4 <__udivdi3+0x7c>
  80179c:	0f bd fe             	bsr    %esi,%edi
  80179f:	83 f7 1f             	xor    $0x1f,%edi
  8017a2:	75 40                	jne    8017e4 <__udivdi3+0x9c>
  8017a4:	39 ce                	cmp    %ecx,%esi
  8017a6:	72 0a                	jb     8017b2 <__udivdi3+0x6a>
  8017a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8017ac:	0f 87 9e 00 00 00    	ja     801850 <__udivdi3+0x108>
  8017b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b7:	89 fa                	mov    %edi,%edx
  8017b9:	83 c4 1c             	add    $0x1c,%esp
  8017bc:	5b                   	pop    %ebx
  8017bd:	5e                   	pop    %esi
  8017be:	5f                   	pop    %edi
  8017bf:	5d                   	pop    %ebp
  8017c0:	c3                   	ret    
  8017c1:	8d 76 00             	lea    0x0(%esi),%esi
  8017c4:	31 ff                	xor    %edi,%edi
  8017c6:	31 c0                	xor    %eax,%eax
  8017c8:	89 fa                	mov    %edi,%edx
  8017ca:	83 c4 1c             	add    $0x1c,%esp
  8017cd:	5b                   	pop    %ebx
  8017ce:	5e                   	pop    %esi
  8017cf:	5f                   	pop    %edi
  8017d0:	5d                   	pop    %ebp
  8017d1:	c3                   	ret    
  8017d2:	66 90                	xchg   %ax,%ax
  8017d4:	89 d8                	mov    %ebx,%eax
  8017d6:	f7 f7                	div    %edi
  8017d8:	31 ff                	xor    %edi,%edi
  8017da:	89 fa                	mov    %edi,%edx
  8017dc:	83 c4 1c             	add    $0x1c,%esp
  8017df:	5b                   	pop    %ebx
  8017e0:	5e                   	pop    %esi
  8017e1:	5f                   	pop    %edi
  8017e2:	5d                   	pop    %ebp
  8017e3:	c3                   	ret    
  8017e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8017e9:	89 eb                	mov    %ebp,%ebx
  8017eb:	29 fb                	sub    %edi,%ebx
  8017ed:	89 f9                	mov    %edi,%ecx
  8017ef:	d3 e6                	shl    %cl,%esi
  8017f1:	89 c5                	mov    %eax,%ebp
  8017f3:	88 d9                	mov    %bl,%cl
  8017f5:	d3 ed                	shr    %cl,%ebp
  8017f7:	89 e9                	mov    %ebp,%ecx
  8017f9:	09 f1                	or     %esi,%ecx
  8017fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8017ff:	89 f9                	mov    %edi,%ecx
  801801:	d3 e0                	shl    %cl,%eax
  801803:	89 c5                	mov    %eax,%ebp
  801805:	89 d6                	mov    %edx,%esi
  801807:	88 d9                	mov    %bl,%cl
  801809:	d3 ee                	shr    %cl,%esi
  80180b:	89 f9                	mov    %edi,%ecx
  80180d:	d3 e2                	shl    %cl,%edx
  80180f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801813:	88 d9                	mov    %bl,%cl
  801815:	d3 e8                	shr    %cl,%eax
  801817:	09 c2                	or     %eax,%edx
  801819:	89 d0                	mov    %edx,%eax
  80181b:	89 f2                	mov    %esi,%edx
  80181d:	f7 74 24 0c          	divl   0xc(%esp)
  801821:	89 d6                	mov    %edx,%esi
  801823:	89 c3                	mov    %eax,%ebx
  801825:	f7 e5                	mul    %ebp
  801827:	39 d6                	cmp    %edx,%esi
  801829:	72 19                	jb     801844 <__udivdi3+0xfc>
  80182b:	74 0b                	je     801838 <__udivdi3+0xf0>
  80182d:	89 d8                	mov    %ebx,%eax
  80182f:	31 ff                	xor    %edi,%edi
  801831:	e9 58 ff ff ff       	jmp    80178e <__udivdi3+0x46>
  801836:	66 90                	xchg   %ax,%ax
  801838:	8b 54 24 08          	mov    0x8(%esp),%edx
  80183c:	89 f9                	mov    %edi,%ecx
  80183e:	d3 e2                	shl    %cl,%edx
  801840:	39 c2                	cmp    %eax,%edx
  801842:	73 e9                	jae    80182d <__udivdi3+0xe5>
  801844:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801847:	31 ff                	xor    %edi,%edi
  801849:	e9 40 ff ff ff       	jmp    80178e <__udivdi3+0x46>
  80184e:	66 90                	xchg   %ax,%ax
  801850:	31 c0                	xor    %eax,%eax
  801852:	e9 37 ff ff ff       	jmp    80178e <__udivdi3+0x46>
  801857:	90                   	nop

00801858 <__umoddi3>:
  801858:	55                   	push   %ebp
  801859:	57                   	push   %edi
  80185a:	56                   	push   %esi
  80185b:	53                   	push   %ebx
  80185c:	83 ec 1c             	sub    $0x1c,%esp
  80185f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801863:	8b 74 24 34          	mov    0x34(%esp),%esi
  801867:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80186b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80186f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801873:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801877:	89 f3                	mov    %esi,%ebx
  801879:	89 fa                	mov    %edi,%edx
  80187b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80187f:	89 34 24             	mov    %esi,(%esp)
  801882:	85 c0                	test   %eax,%eax
  801884:	75 1a                	jne    8018a0 <__umoddi3+0x48>
  801886:	39 f7                	cmp    %esi,%edi
  801888:	0f 86 a2 00 00 00    	jbe    801930 <__umoddi3+0xd8>
  80188e:	89 c8                	mov    %ecx,%eax
  801890:	89 f2                	mov    %esi,%edx
  801892:	f7 f7                	div    %edi
  801894:	89 d0                	mov    %edx,%eax
  801896:	31 d2                	xor    %edx,%edx
  801898:	83 c4 1c             	add    $0x1c,%esp
  80189b:	5b                   	pop    %ebx
  80189c:	5e                   	pop    %esi
  80189d:	5f                   	pop    %edi
  80189e:	5d                   	pop    %ebp
  80189f:	c3                   	ret    
  8018a0:	39 f0                	cmp    %esi,%eax
  8018a2:	0f 87 ac 00 00 00    	ja     801954 <__umoddi3+0xfc>
  8018a8:	0f bd e8             	bsr    %eax,%ebp
  8018ab:	83 f5 1f             	xor    $0x1f,%ebp
  8018ae:	0f 84 ac 00 00 00    	je     801960 <__umoddi3+0x108>
  8018b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8018b9:	29 ef                	sub    %ebp,%edi
  8018bb:	89 fe                	mov    %edi,%esi
  8018bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018c1:	89 e9                	mov    %ebp,%ecx
  8018c3:	d3 e0                	shl    %cl,%eax
  8018c5:	89 d7                	mov    %edx,%edi
  8018c7:	89 f1                	mov    %esi,%ecx
  8018c9:	d3 ef                	shr    %cl,%edi
  8018cb:	09 c7                	or     %eax,%edi
  8018cd:	89 e9                	mov    %ebp,%ecx
  8018cf:	d3 e2                	shl    %cl,%edx
  8018d1:	89 14 24             	mov    %edx,(%esp)
  8018d4:	89 d8                	mov    %ebx,%eax
  8018d6:	d3 e0                	shl    %cl,%eax
  8018d8:	89 c2                	mov    %eax,%edx
  8018da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018de:	d3 e0                	shl    %cl,%eax
  8018e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018e8:	89 f1                	mov    %esi,%ecx
  8018ea:	d3 e8                	shr    %cl,%eax
  8018ec:	09 d0                	or     %edx,%eax
  8018ee:	d3 eb                	shr    %cl,%ebx
  8018f0:	89 da                	mov    %ebx,%edx
  8018f2:	f7 f7                	div    %edi
  8018f4:	89 d3                	mov    %edx,%ebx
  8018f6:	f7 24 24             	mull   (%esp)
  8018f9:	89 c6                	mov    %eax,%esi
  8018fb:	89 d1                	mov    %edx,%ecx
  8018fd:	39 d3                	cmp    %edx,%ebx
  8018ff:	0f 82 87 00 00 00    	jb     80198c <__umoddi3+0x134>
  801905:	0f 84 91 00 00 00    	je     80199c <__umoddi3+0x144>
  80190b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80190f:	29 f2                	sub    %esi,%edx
  801911:	19 cb                	sbb    %ecx,%ebx
  801913:	89 d8                	mov    %ebx,%eax
  801915:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801919:	d3 e0                	shl    %cl,%eax
  80191b:	89 e9                	mov    %ebp,%ecx
  80191d:	d3 ea                	shr    %cl,%edx
  80191f:	09 d0                	or     %edx,%eax
  801921:	89 e9                	mov    %ebp,%ecx
  801923:	d3 eb                	shr    %cl,%ebx
  801925:	89 da                	mov    %ebx,%edx
  801927:	83 c4 1c             	add    $0x1c,%esp
  80192a:	5b                   	pop    %ebx
  80192b:	5e                   	pop    %esi
  80192c:	5f                   	pop    %edi
  80192d:	5d                   	pop    %ebp
  80192e:	c3                   	ret    
  80192f:	90                   	nop
  801930:	89 fd                	mov    %edi,%ebp
  801932:	85 ff                	test   %edi,%edi
  801934:	75 0b                	jne    801941 <__umoddi3+0xe9>
  801936:	b8 01 00 00 00       	mov    $0x1,%eax
  80193b:	31 d2                	xor    %edx,%edx
  80193d:	f7 f7                	div    %edi
  80193f:	89 c5                	mov    %eax,%ebp
  801941:	89 f0                	mov    %esi,%eax
  801943:	31 d2                	xor    %edx,%edx
  801945:	f7 f5                	div    %ebp
  801947:	89 c8                	mov    %ecx,%eax
  801949:	f7 f5                	div    %ebp
  80194b:	89 d0                	mov    %edx,%eax
  80194d:	e9 44 ff ff ff       	jmp    801896 <__umoddi3+0x3e>
  801952:	66 90                	xchg   %ax,%ax
  801954:	89 c8                	mov    %ecx,%eax
  801956:	89 f2                	mov    %esi,%edx
  801958:	83 c4 1c             	add    $0x1c,%esp
  80195b:	5b                   	pop    %ebx
  80195c:	5e                   	pop    %esi
  80195d:	5f                   	pop    %edi
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    
  801960:	3b 04 24             	cmp    (%esp),%eax
  801963:	72 06                	jb     80196b <__umoddi3+0x113>
  801965:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801969:	77 0f                	ja     80197a <__umoddi3+0x122>
  80196b:	89 f2                	mov    %esi,%edx
  80196d:	29 f9                	sub    %edi,%ecx
  80196f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801973:	89 14 24             	mov    %edx,(%esp)
  801976:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80197a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80197e:	8b 14 24             	mov    (%esp),%edx
  801981:	83 c4 1c             	add    $0x1c,%esp
  801984:	5b                   	pop    %ebx
  801985:	5e                   	pop    %esi
  801986:	5f                   	pop    %edi
  801987:	5d                   	pop    %ebp
  801988:	c3                   	ret    
  801989:	8d 76 00             	lea    0x0(%esi),%esi
  80198c:	2b 04 24             	sub    (%esp),%eax
  80198f:	19 fa                	sbb    %edi,%edx
  801991:	89 d1                	mov    %edx,%ecx
  801993:	89 c6                	mov    %eax,%esi
  801995:	e9 71 ff ff ff       	jmp    80190b <__umoddi3+0xb3>
  80199a:	66 90                	xchg   %ax,%ax
  80199c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8019a0:	72 ea                	jb     80198c <__umoddi3+0x134>
  8019a2:	89 d9                	mov    %ebx,%ecx
  8019a4:	e9 62 ff ff ff       	jmp    80190b <__umoddi3+0xb3>
