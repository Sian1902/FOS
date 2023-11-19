
obj/user/fos_data_on_stack:     file format elf32-i386


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
  800031:	e8 1e 00 00 00       	call   800054 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 48 27 00 00    	sub    $0x2748,%esp
	/// Adding array of 512 integer on user stack
	int arr[2512];

	atomic_cprintf("user stack contains 512 integer\n");
  800041:	83 ec 0c             	sub    $0xc,%esp
  800044:	68 80 19 80 00       	push   $0x801980
  800049:	e8 4c 02 00 00       	call   80029a <atomic_cprintf>
  80004e:	83 c4 10             	add    $0x10,%esp

	return;	
  800051:	90                   	nop
}
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80005a:	e8 82 13 00 00       	call   8013e1 <sys_getenvindex>
  80005f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800065:	89 d0                	mov    %edx,%eax
  800067:	01 c0                	add    %eax,%eax
  800069:	01 d0                	add    %edx,%eax
  80006b:	01 c0                	add    %eax,%eax
  80006d:	01 d0                	add    %edx,%eax
  80006f:	c1 e0 02             	shl    $0x2,%eax
  800072:	01 d0                	add    %edx,%eax
  800074:	01 c0                	add    %eax,%eax
  800076:	01 d0                	add    %edx,%eax
  800078:	c1 e0 02             	shl    $0x2,%eax
  80007b:	01 d0                	add    %edx,%eax
  80007d:	c1 e0 02             	shl    $0x2,%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	c1 e0 02             	shl    $0x2,%eax
  800085:	01 d0                	add    %edx,%eax
  800087:	c1 e0 05             	shl    $0x5,%eax
  80008a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008f:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800094:	a1 20 20 80 00       	mov    0x802020,%eax
  800099:	8a 40 5c             	mov    0x5c(%eax),%al
  80009c:	84 c0                	test   %al,%al
  80009e:	74 0d                	je     8000ad <libmain+0x59>
		binaryname = myEnv->prog_name;
  8000a0:	a1 20 20 80 00       	mov    0x802020,%eax
  8000a5:	83 c0 5c             	add    $0x5c,%eax
  8000a8:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b1:	7e 0a                	jle    8000bd <libmain+0x69>
		binaryname = argv[0];
  8000b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000bd:	83 ec 08             	sub    $0x8,%esp
  8000c0:	ff 75 0c             	pushl  0xc(%ebp)
  8000c3:	ff 75 08             	pushl  0x8(%ebp)
  8000c6:	e8 6d ff ff ff       	call   800038 <_main>
  8000cb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000ce:	e8 1b 11 00 00       	call   8011ee <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	68 bc 19 80 00       	push   $0x8019bc
  8000db:	e8 8d 01 00 00       	call   80026d <cprintf>
  8000e0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000e3:	a1 20 20 80 00       	mov    0x802020,%eax
  8000e8:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  8000ee:	a1 20 20 80 00       	mov    0x802020,%eax
  8000f3:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	52                   	push   %edx
  8000fd:	50                   	push   %eax
  8000fe:	68 e4 19 80 00       	push   $0x8019e4
  800103:	e8 65 01 00 00       	call   80026d <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80010b:	a1 20 20 80 00       	mov    0x802020,%eax
  800110:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  800116:	a1 20 20 80 00       	mov    0x802020,%eax
  80011b:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  800121:	a1 20 20 80 00       	mov    0x802020,%eax
  800126:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  80012c:	51                   	push   %ecx
  80012d:	52                   	push   %edx
  80012e:	50                   	push   %eax
  80012f:	68 0c 1a 80 00       	push   $0x801a0c
  800134:	e8 34 01 00 00       	call   80026d <cprintf>
  800139:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80013c:	a1 20 20 80 00       	mov    0x802020,%eax
  800141:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  800147:	83 ec 08             	sub    $0x8,%esp
  80014a:	50                   	push   %eax
  80014b:	68 64 1a 80 00       	push   $0x801a64
  800150:	e8 18 01 00 00       	call   80026d <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	68 bc 19 80 00       	push   $0x8019bc
  800160:	e8 08 01 00 00       	call   80026d <cprintf>
  800165:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800168:	e8 9b 10 00 00       	call   801208 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80016d:	e8 19 00 00 00       	call   80018b <exit>
}
  800172:	90                   	nop
  800173:	c9                   	leave  
  800174:	c3                   	ret    

00800175 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80017b:	83 ec 0c             	sub    $0xc,%esp
  80017e:	6a 00                	push   $0x0
  800180:	e8 28 12 00 00       	call   8013ad <sys_destroy_env>
  800185:	83 c4 10             	add    $0x10,%esp
}
  800188:	90                   	nop
  800189:	c9                   	leave  
  80018a:	c3                   	ret    

0080018b <exit>:

void
exit(void)
{
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800191:	e8 7d 12 00 00       	call   801413 <sys_exit_env>
}
  800196:	90                   	nop
  800197:	c9                   	leave  
  800198:	c3                   	ret    

00800199 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800199:	55                   	push   %ebp
  80019a:	89 e5                	mov    %esp,%ebp
  80019c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80019f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a2:	8b 00                	mov    (%eax),%eax
  8001a4:	8d 48 01             	lea    0x1(%eax),%ecx
  8001a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001aa:	89 0a                	mov    %ecx,(%edx)
  8001ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8001af:	88 d1                	mov    %dl,%cl
  8001b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001bb:	8b 00                	mov    (%eax),%eax
  8001bd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c2:	75 2c                	jne    8001f0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001c4:	a0 24 20 80 00       	mov    0x802024,%al
  8001c9:	0f b6 c0             	movzbl %al,%eax
  8001cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cf:	8b 12                	mov    (%edx),%edx
  8001d1:	89 d1                	mov    %edx,%ecx
  8001d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d6:	83 c2 08             	add    $0x8,%edx
  8001d9:	83 ec 04             	sub    $0x4,%esp
  8001dc:	50                   	push   %eax
  8001dd:	51                   	push   %ecx
  8001de:	52                   	push   %edx
  8001df:	e8 b1 0e 00 00       	call   801095 <sys_cputs>
  8001e4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f3:	8b 40 04             	mov    0x4(%eax),%eax
  8001f6:	8d 50 01             	lea    0x1(%eax),%edx
  8001f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001fc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80020b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800212:	00 00 00 
	b.cnt = 0;
  800215:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80021c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80021f:	ff 75 0c             	pushl  0xc(%ebp)
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80022b:	50                   	push   %eax
  80022c:	68 99 01 80 00       	push   $0x800199
  800231:	e8 11 02 00 00       	call   800447 <vprintfmt>
  800236:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800239:	a0 24 20 80 00       	mov    0x802024,%al
  80023e:	0f b6 c0             	movzbl %al,%eax
  800241:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	50                   	push   %eax
  80024b:	52                   	push   %edx
  80024c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800252:	83 c0 08             	add    $0x8,%eax
  800255:	50                   	push   %eax
  800256:	e8 3a 0e 00 00       	call   801095 <sys_cputs>
  80025b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80025e:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  800265:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80026b:	c9                   	leave  
  80026c:	c3                   	ret    

0080026d <cprintf>:

int cprintf(const char *fmt, ...) {
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800273:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  80027a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80027d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800280:	8b 45 08             	mov    0x8(%ebp),%eax
  800283:	83 ec 08             	sub    $0x8,%esp
  800286:	ff 75 f4             	pushl  -0xc(%ebp)
  800289:	50                   	push   %eax
  80028a:	e8 73 ff ff ff       	call   800202 <vcprintf>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800295:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002a0:	e8 49 0f 00 00       	call   8011ee <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002a5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ae:	83 ec 08             	sub    $0x8,%esp
  8002b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b4:	50                   	push   %eax
  8002b5:	e8 48 ff ff ff       	call   800202 <vcprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp
  8002bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002c0:	e8 43 0f 00 00       	call   801208 <sys_enable_interrupt>
	return cnt;
  8002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002c8:	c9                   	leave  
  8002c9:	c3                   	ret    

008002ca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	53                   	push   %ebx
  8002ce:	83 ec 14             	sub    $0x14,%esp
  8002d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8002da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002dd:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002e8:	77 55                	ja     80033f <printnum+0x75>
  8002ea:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002ed:	72 05                	jb     8002f4 <printnum+0x2a>
  8002ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002f2:	77 4b                	ja     80033f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002f7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8002fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800302:	52                   	push   %edx
  800303:	50                   	push   %eax
  800304:	ff 75 f4             	pushl  -0xc(%ebp)
  800307:	ff 75 f0             	pushl  -0x10(%ebp)
  80030a:	e8 f5 13 00 00       	call   801704 <__udivdi3>
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	ff 75 20             	pushl  0x20(%ebp)
  800318:	53                   	push   %ebx
  800319:	ff 75 18             	pushl  0x18(%ebp)
  80031c:	52                   	push   %edx
  80031d:	50                   	push   %eax
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	ff 75 08             	pushl  0x8(%ebp)
  800324:	e8 a1 ff ff ff       	call   8002ca <printnum>
  800329:	83 c4 20             	add    $0x20,%esp
  80032c:	eb 1a                	jmp    800348 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	ff 75 0c             	pushl  0xc(%ebp)
  800334:	ff 75 20             	pushl  0x20(%ebp)
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	ff d0                	call   *%eax
  80033c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80033f:	ff 4d 1c             	decl   0x1c(%ebp)
  800342:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800346:	7f e6                	jg     80032e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800348:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80034b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800356:	53                   	push   %ebx
  800357:	51                   	push   %ecx
  800358:	52                   	push   %edx
  800359:	50                   	push   %eax
  80035a:	e8 b5 14 00 00       	call   801814 <__umoddi3>
  80035f:	83 c4 10             	add    $0x10,%esp
  800362:	05 94 1c 80 00       	add    $0x801c94,%eax
  800367:	8a 00                	mov    (%eax),%al
  800369:	0f be c0             	movsbl %al,%eax
  80036c:	83 ec 08             	sub    $0x8,%esp
  80036f:	ff 75 0c             	pushl  0xc(%ebp)
  800372:	50                   	push   %eax
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	ff d0                	call   *%eax
  800378:	83 c4 10             	add    $0x10,%esp
}
  80037b:	90                   	nop
  80037c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037f:	c9                   	leave  
  800380:	c3                   	ret    

00800381 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800381:	55                   	push   %ebp
  800382:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800384:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800388:	7e 1c                	jle    8003a6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80038a:	8b 45 08             	mov    0x8(%ebp),%eax
  80038d:	8b 00                	mov    (%eax),%eax
  80038f:	8d 50 08             	lea    0x8(%eax),%edx
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	89 10                	mov    %edx,(%eax)
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	8b 00                	mov    (%eax),%eax
  80039c:	83 e8 08             	sub    $0x8,%eax
  80039f:	8b 50 04             	mov    0x4(%eax),%edx
  8003a2:	8b 00                	mov    (%eax),%eax
  8003a4:	eb 40                	jmp    8003e6 <getuint+0x65>
	else if (lflag)
  8003a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003aa:	74 1e                	je     8003ca <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	8d 50 04             	lea    0x4(%eax),%edx
  8003b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b7:	89 10                	mov    %edx,(%eax)
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	8b 00                	mov    (%eax),%eax
  8003be:	83 e8 04             	sub    $0x4,%eax
  8003c1:	8b 00                	mov    (%eax),%eax
  8003c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c8:	eb 1c                	jmp    8003e6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	8b 00                	mov    (%eax),%eax
  8003cf:	8d 50 04             	lea    0x4(%eax),%edx
  8003d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d5:	89 10                	mov    %edx,(%eax)
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	8b 00                	mov    (%eax),%eax
  8003dc:	83 e8 04             	sub    $0x4,%eax
  8003df:	8b 00                	mov    (%eax),%eax
  8003e1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003e6:	5d                   	pop    %ebp
  8003e7:	c3                   	ret    

008003e8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003eb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003ef:	7e 1c                	jle    80040d <getint+0x25>
		return va_arg(*ap, long long);
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	8d 50 08             	lea    0x8(%eax),%edx
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	89 10                	mov    %edx,(%eax)
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	8b 00                	mov    (%eax),%eax
  800403:	83 e8 08             	sub    $0x8,%eax
  800406:	8b 50 04             	mov    0x4(%eax),%edx
  800409:	8b 00                	mov    (%eax),%eax
  80040b:	eb 38                	jmp    800445 <getint+0x5d>
	else if (lflag)
  80040d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800411:	74 1a                	je     80042d <getint+0x45>
		return va_arg(*ap, long);
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	8d 50 04             	lea    0x4(%eax),%edx
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
  800420:	8b 45 08             	mov    0x8(%ebp),%eax
  800423:	8b 00                	mov    (%eax),%eax
  800425:	83 e8 04             	sub    $0x4,%eax
  800428:	8b 00                	mov    (%eax),%eax
  80042a:	99                   	cltd   
  80042b:	eb 18                	jmp    800445 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	8b 00                	mov    (%eax),%eax
  800432:	8d 50 04             	lea    0x4(%eax),%edx
  800435:	8b 45 08             	mov    0x8(%ebp),%eax
  800438:	89 10                	mov    %edx,(%eax)
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	8b 00                	mov    (%eax),%eax
  80043f:	83 e8 04             	sub    $0x4,%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	99                   	cltd   
}
  800445:	5d                   	pop    %ebp
  800446:	c3                   	ret    

00800447 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800447:	55                   	push   %ebp
  800448:	89 e5                	mov    %esp,%ebp
  80044a:	56                   	push   %esi
  80044b:	53                   	push   %ebx
  80044c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80044f:	eb 17                	jmp    800468 <vprintfmt+0x21>
			if (ch == '\0')
  800451:	85 db                	test   %ebx,%ebx
  800453:	0f 84 af 03 00 00    	je     800808 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800459:	83 ec 08             	sub    $0x8,%esp
  80045c:	ff 75 0c             	pushl  0xc(%ebp)
  80045f:	53                   	push   %ebx
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	ff d0                	call   *%eax
  800465:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800468:	8b 45 10             	mov    0x10(%ebp),%eax
  80046b:	8d 50 01             	lea    0x1(%eax),%edx
  80046e:	89 55 10             	mov    %edx,0x10(%ebp)
  800471:	8a 00                	mov    (%eax),%al
  800473:	0f b6 d8             	movzbl %al,%ebx
  800476:	83 fb 25             	cmp    $0x25,%ebx
  800479:	75 d6                	jne    800451 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80047b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80047f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800486:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80048d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800494:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049b:	8b 45 10             	mov    0x10(%ebp),%eax
  80049e:	8d 50 01             	lea    0x1(%eax),%edx
  8004a1:	89 55 10             	mov    %edx,0x10(%ebp)
  8004a4:	8a 00                	mov    (%eax),%al
  8004a6:	0f b6 d8             	movzbl %al,%ebx
  8004a9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004ac:	83 f8 55             	cmp    $0x55,%eax
  8004af:	0f 87 2b 03 00 00    	ja     8007e0 <vprintfmt+0x399>
  8004b5:	8b 04 85 b8 1c 80 00 	mov    0x801cb8(,%eax,4),%eax
  8004bc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004be:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004c2:	eb d7                	jmp    80049b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004c4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004c8:	eb d1                	jmp    80049b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d4:	89 d0                	mov    %edx,%eax
  8004d6:	c1 e0 02             	shl    $0x2,%eax
  8004d9:	01 d0                	add    %edx,%eax
  8004db:	01 c0                	add    %eax,%eax
  8004dd:	01 d8                	add    %ebx,%eax
  8004df:	83 e8 30             	sub    $0x30,%eax
  8004e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e8:	8a 00                	mov    (%eax),%al
  8004ea:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004ed:	83 fb 2f             	cmp    $0x2f,%ebx
  8004f0:	7e 3e                	jle    800530 <vprintfmt+0xe9>
  8004f2:	83 fb 39             	cmp    $0x39,%ebx
  8004f5:	7f 39                	jg     800530 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004f7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004fa:	eb d5                	jmp    8004d1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ff:	83 c0 04             	add    $0x4,%eax
  800502:	89 45 14             	mov    %eax,0x14(%ebp)
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	83 e8 04             	sub    $0x4,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800510:	eb 1f                	jmp    800531 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800512:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800516:	79 83                	jns    80049b <vprintfmt+0x54>
				width = 0;
  800518:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80051f:	e9 77 ff ff ff       	jmp    80049b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800524:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80052b:	e9 6b ff ff ff       	jmp    80049b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800530:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800531:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800535:	0f 89 60 ff ff ff    	jns    80049b <vprintfmt+0x54>
				width = precision, precision = -1;
  80053b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800541:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800548:	e9 4e ff ff ff       	jmp    80049b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80054d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800550:	e9 46 ff ff ff       	jmp    80049b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	83 c0 04             	add    $0x4,%eax
  80055b:	89 45 14             	mov    %eax,0x14(%ebp)
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	83 e8 04             	sub    $0x4,%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	ff 75 0c             	pushl  0xc(%ebp)
  80056c:	50                   	push   %eax
  80056d:	8b 45 08             	mov    0x8(%ebp),%eax
  800570:	ff d0                	call   *%eax
  800572:	83 c4 10             	add    $0x10,%esp
			break;
  800575:	e9 89 02 00 00       	jmp    800803 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	83 c0 04             	add    $0x4,%eax
  800580:	89 45 14             	mov    %eax,0x14(%ebp)
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	83 e8 04             	sub    $0x4,%eax
  800589:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80058b:	85 db                	test   %ebx,%ebx
  80058d:	79 02                	jns    800591 <vprintfmt+0x14a>
				err = -err;
  80058f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800591:	83 fb 64             	cmp    $0x64,%ebx
  800594:	7f 0b                	jg     8005a1 <vprintfmt+0x15a>
  800596:	8b 34 9d 00 1b 80 00 	mov    0x801b00(,%ebx,4),%esi
  80059d:	85 f6                	test   %esi,%esi
  80059f:	75 19                	jne    8005ba <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005a1:	53                   	push   %ebx
  8005a2:	68 a5 1c 80 00       	push   $0x801ca5
  8005a7:	ff 75 0c             	pushl  0xc(%ebp)
  8005aa:	ff 75 08             	pushl  0x8(%ebp)
  8005ad:	e8 5e 02 00 00       	call   800810 <printfmt>
  8005b2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005b5:	e9 49 02 00 00       	jmp    800803 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005ba:	56                   	push   %esi
  8005bb:	68 ae 1c 80 00       	push   $0x801cae
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 45 02 00 00       	call   800810 <printfmt>
  8005cb:	83 c4 10             	add    $0x10,%esp
			break;
  8005ce:	e9 30 02 00 00       	jmp    800803 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	83 c0 04             	add    $0x4,%eax
  8005d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	83 e8 04             	sub    $0x4,%eax
  8005e2:	8b 30                	mov    (%eax),%esi
  8005e4:	85 f6                	test   %esi,%esi
  8005e6:	75 05                	jne    8005ed <vprintfmt+0x1a6>
				p = "(null)";
  8005e8:	be b1 1c 80 00       	mov    $0x801cb1,%esi
			if (width > 0 && padc != '-')
  8005ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f1:	7e 6d                	jle    800660 <vprintfmt+0x219>
  8005f3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005f7:	74 67                	je     800660 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	50                   	push   %eax
  800600:	56                   	push   %esi
  800601:	e8 0c 03 00 00       	call   800912 <strnlen>
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80060c:	eb 16                	jmp    800624 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80060e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800612:	83 ec 08             	sub    $0x8,%esp
  800615:	ff 75 0c             	pushl  0xc(%ebp)
  800618:	50                   	push   %eax
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	ff d0                	call   *%eax
  80061e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800621:	ff 4d e4             	decl   -0x1c(%ebp)
  800624:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800628:	7f e4                	jg     80060e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80062a:	eb 34                	jmp    800660 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80062c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800630:	74 1c                	je     80064e <vprintfmt+0x207>
  800632:	83 fb 1f             	cmp    $0x1f,%ebx
  800635:	7e 05                	jle    80063c <vprintfmt+0x1f5>
  800637:	83 fb 7e             	cmp    $0x7e,%ebx
  80063a:	7e 12                	jle    80064e <vprintfmt+0x207>
					putch('?', putdat);
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	ff 75 0c             	pushl  0xc(%ebp)
  800642:	6a 3f                	push   $0x3f
  800644:	8b 45 08             	mov    0x8(%ebp),%eax
  800647:	ff d0                	call   *%eax
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	eb 0f                	jmp    80065d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80064e:	83 ec 08             	sub    $0x8,%esp
  800651:	ff 75 0c             	pushl  0xc(%ebp)
  800654:	53                   	push   %ebx
  800655:	8b 45 08             	mov    0x8(%ebp),%eax
  800658:	ff d0                	call   *%eax
  80065a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80065d:	ff 4d e4             	decl   -0x1c(%ebp)
  800660:	89 f0                	mov    %esi,%eax
  800662:	8d 70 01             	lea    0x1(%eax),%esi
  800665:	8a 00                	mov    (%eax),%al
  800667:	0f be d8             	movsbl %al,%ebx
  80066a:	85 db                	test   %ebx,%ebx
  80066c:	74 24                	je     800692 <vprintfmt+0x24b>
  80066e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800672:	78 b8                	js     80062c <vprintfmt+0x1e5>
  800674:	ff 4d e0             	decl   -0x20(%ebp)
  800677:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067b:	79 af                	jns    80062c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80067d:	eb 13                	jmp    800692 <vprintfmt+0x24b>
				putch(' ', putdat);
  80067f:	83 ec 08             	sub    $0x8,%esp
  800682:	ff 75 0c             	pushl  0xc(%ebp)
  800685:	6a 20                	push   $0x20
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	ff d0                	call   *%eax
  80068c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80068f:	ff 4d e4             	decl   -0x1c(%ebp)
  800692:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800696:	7f e7                	jg     80067f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800698:	e9 66 01 00 00       	jmp    800803 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8006a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a6:	50                   	push   %eax
  8006a7:	e8 3c fd ff ff       	call   8003e8 <getint>
  8006ac:	83 c4 10             	add    $0x10,%esp
  8006af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006bb:	85 d2                	test   %edx,%edx
  8006bd:	79 23                	jns    8006e2 <vprintfmt+0x29b>
				putch('-', putdat);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	6a 2d                	push   $0x2d
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	ff d0                	call   *%eax
  8006cc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d5:	f7 d8                	neg    %eax
  8006d7:	83 d2 00             	adc    $0x0,%edx
  8006da:	f7 da                	neg    %edx
  8006dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006df:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006e2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006e9:	e9 bc 00 00 00       	jmp    8007aa <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8006f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f7:	50                   	push   %eax
  8006f8:	e8 84 fc ff ff       	call   800381 <getuint>
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800703:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800706:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80070d:	e9 98 00 00 00       	jmp    8007aa <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	6a 58                	push   $0x58
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	ff d0                	call   *%eax
  80071f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	6a 58                	push   $0x58
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	ff d0                	call   *%eax
  80072f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	ff 75 0c             	pushl  0xc(%ebp)
  800738:	6a 58                	push   $0x58
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	ff d0                	call   *%eax
  80073f:	83 c4 10             	add    $0x10,%esp
			break;
  800742:	e9 bc 00 00 00       	jmp    800803 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	ff 75 0c             	pushl  0xc(%ebp)
  80074d:	6a 30                	push   $0x30
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	ff d0                	call   *%eax
  800754:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	ff 75 0c             	pushl  0xc(%ebp)
  80075d:	6a 78                	push   $0x78
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	ff d0                	call   *%eax
  800764:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	83 c0 04             	add    $0x4,%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800778:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80077b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800782:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800789:	eb 1f                	jmp    8007aa <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	ff 75 e8             	pushl  -0x18(%ebp)
  800791:	8d 45 14             	lea    0x14(%ebp),%eax
  800794:	50                   	push   %eax
  800795:	e8 e7 fb ff ff       	call   800381 <getuint>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007a3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007aa:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b1:	83 ec 04             	sub    $0x4,%esp
  8007b4:	52                   	push   %edx
  8007b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007b8:	50                   	push   %eax
  8007b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8007bf:	ff 75 0c             	pushl  0xc(%ebp)
  8007c2:	ff 75 08             	pushl  0x8(%ebp)
  8007c5:	e8 00 fb ff ff       	call   8002ca <printnum>
  8007ca:	83 c4 20             	add    $0x20,%esp
			break;
  8007cd:	eb 34                	jmp    800803 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	ff 75 0c             	pushl  0xc(%ebp)
  8007d5:	53                   	push   %ebx
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	ff d0                	call   *%eax
  8007db:	83 c4 10             	add    $0x10,%esp
			break;
  8007de:	eb 23                	jmp    800803 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	ff 75 0c             	pushl  0xc(%ebp)
  8007e6:	6a 25                	push   $0x25
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	ff d0                	call   *%eax
  8007ed:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f0:	ff 4d 10             	decl   0x10(%ebp)
  8007f3:	eb 03                	jmp    8007f8 <vprintfmt+0x3b1>
  8007f5:	ff 4d 10             	decl   0x10(%ebp)
  8007f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fb:	48                   	dec    %eax
  8007fc:	8a 00                	mov    (%eax),%al
  8007fe:	3c 25                	cmp    $0x25,%al
  800800:	75 f3                	jne    8007f5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800802:	90                   	nop
		}
	}
  800803:	e9 47 fc ff ff       	jmp    80044f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800808:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800809:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80080c:	5b                   	pop    %ebx
  80080d:	5e                   	pop    %esi
  80080e:	5d                   	pop    %ebp
  80080f:	c3                   	ret    

00800810 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800816:	8d 45 10             	lea    0x10(%ebp),%eax
  800819:	83 c0 04             	add    $0x4,%eax
  80081c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80081f:	8b 45 10             	mov    0x10(%ebp),%eax
  800822:	ff 75 f4             	pushl  -0xc(%ebp)
  800825:	50                   	push   %eax
  800826:	ff 75 0c             	pushl  0xc(%ebp)
  800829:	ff 75 08             	pushl  0x8(%ebp)
  80082c:	e8 16 fc ff ff       	call   800447 <vprintfmt>
  800831:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800834:	90                   	nop
  800835:	c9                   	leave  
  800836:	c3                   	ret    

00800837 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80083a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083d:	8b 40 08             	mov    0x8(%eax),%eax
  800840:	8d 50 01             	lea    0x1(%eax),%edx
  800843:	8b 45 0c             	mov    0xc(%ebp),%eax
  800846:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084c:	8b 10                	mov    (%eax),%edx
  80084e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800851:	8b 40 04             	mov    0x4(%eax),%eax
  800854:	39 c2                	cmp    %eax,%edx
  800856:	73 12                	jae    80086a <sprintputch+0x33>
		*b->buf++ = ch;
  800858:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	8d 48 01             	lea    0x1(%eax),%ecx
  800860:	8b 55 0c             	mov    0xc(%ebp),%edx
  800863:	89 0a                	mov    %ecx,(%edx)
  800865:	8b 55 08             	mov    0x8(%ebp),%edx
  800868:	88 10                	mov    %dl,(%eax)
}
  80086a:	90                   	nop
  80086b:	5d                   	pop    %ebp
  80086c:	c3                   	ret    

0080086d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086d:	55                   	push   %ebp
  80086e:	89 e5                	mov    %esp,%ebp
  800870:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800879:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	01 d0                	add    %edx,%eax
  800884:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800887:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800892:	74 06                	je     80089a <vsnprintf+0x2d>
  800894:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800898:	7f 07                	jg     8008a1 <vsnprintf+0x34>
		return -E_INVAL;
  80089a:	b8 03 00 00 00       	mov    $0x3,%eax
  80089f:	eb 20                	jmp    8008c1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a1:	ff 75 14             	pushl  0x14(%ebp)
  8008a4:	ff 75 10             	pushl  0x10(%ebp)
  8008a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008aa:	50                   	push   %eax
  8008ab:	68 37 08 80 00       	push   $0x800837
  8008b0:	e8 92 fb ff ff       	call   800447 <vprintfmt>
  8008b5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008c1:	c9                   	leave  
  8008c2:	c3                   	ret    

008008c3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c9:	8d 45 10             	lea    0x10(%ebp),%eax
  8008cc:	83 c0 04             	add    $0x4,%eax
  8008cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d8:	50                   	push   %eax
  8008d9:	ff 75 0c             	pushl  0xc(%ebp)
  8008dc:	ff 75 08             	pushl  0x8(%ebp)
  8008df:	e8 89 ff ff ff       	call   80086d <vsnprintf>
  8008e4:	83 c4 10             	add    $0x10,%esp
  8008e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008ed:	c9                   	leave  
  8008ee:	c3                   	ret    

008008ef <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008fc:	eb 06                	jmp    800904 <strlen+0x15>
		n++;
  8008fe:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800901:	ff 45 08             	incl   0x8(%ebp)
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	8a 00                	mov    (%eax),%al
  800909:	84 c0                	test   %al,%al
  80090b:	75 f1                	jne    8008fe <strlen+0xf>
		n++;
	return n;
  80090d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800918:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80091f:	eb 09                	jmp    80092a <strnlen+0x18>
		n++;
  800921:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800924:	ff 45 08             	incl   0x8(%ebp)
  800927:	ff 4d 0c             	decl   0xc(%ebp)
  80092a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092e:	74 09                	je     800939 <strnlen+0x27>
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8a 00                	mov    (%eax),%al
  800935:	84 c0                	test   %al,%al
  800937:	75 e8                	jne    800921 <strnlen+0xf>
		n++;
	return n;
  800939:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80093c:	c9                   	leave  
  80093d:	c3                   	ret    

0080093e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80094a:	90                   	nop
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8d 50 01             	lea    0x1(%eax),%edx
  800951:	89 55 08             	mov    %edx,0x8(%ebp)
  800954:	8b 55 0c             	mov    0xc(%ebp),%edx
  800957:	8d 4a 01             	lea    0x1(%edx),%ecx
  80095a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80095d:	8a 12                	mov    (%edx),%dl
  80095f:	88 10                	mov    %dl,(%eax)
  800961:	8a 00                	mov    (%eax),%al
  800963:	84 c0                	test   %al,%al
  800965:	75 e4                	jne    80094b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800967:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80096a:	c9                   	leave  
  80096b:	c3                   	ret    

0080096c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800978:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80097f:	eb 1f                	jmp    8009a0 <strncpy+0x34>
		*dst++ = *src;
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	8d 50 01             	lea    0x1(%eax),%edx
  800987:	89 55 08             	mov    %edx,0x8(%ebp)
  80098a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098d:	8a 12                	mov    (%edx),%dl
  80098f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800991:	8b 45 0c             	mov    0xc(%ebp),%eax
  800994:	8a 00                	mov    (%eax),%al
  800996:	84 c0                	test   %al,%al
  800998:	74 03                	je     80099d <strncpy+0x31>
			src++;
  80099a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80099d:	ff 45 fc             	incl   -0x4(%ebp)
  8009a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009a3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009a6:	72 d9                	jb     800981 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009ab:	c9                   	leave  
  8009ac:	c3                   	ret    

008009ad <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009bd:	74 30                	je     8009ef <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009bf:	eb 16                	jmp    8009d7 <strlcpy+0x2a>
			*dst++ = *src++;
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	8d 50 01             	lea    0x1(%eax),%edx
  8009c7:	89 55 08             	mov    %edx,0x8(%ebp)
  8009ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009d0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009d3:	8a 12                	mov    (%edx),%dl
  8009d5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009d7:	ff 4d 10             	decl   0x10(%ebp)
  8009da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009de:	74 09                	je     8009e9 <strlcpy+0x3c>
  8009e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e3:	8a 00                	mov    (%eax),%al
  8009e5:	84 c0                	test   %al,%al
  8009e7:	75 d8                	jne    8009c1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8009f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009f5:	29 c2                	sub    %eax,%edx
  8009f7:	89 d0                	mov    %edx,%eax
}
  8009f9:	c9                   	leave  
  8009fa:	c3                   	ret    

008009fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8009fe:	eb 06                	jmp    800a06 <strcmp+0xb>
		p++, q++;
  800a00:	ff 45 08             	incl   0x8(%ebp)
  800a03:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	8a 00                	mov    (%eax),%al
  800a0b:	84 c0                	test   %al,%al
  800a0d:	74 0e                	je     800a1d <strcmp+0x22>
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8a 10                	mov    (%eax),%dl
  800a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a17:	8a 00                	mov    (%eax),%al
  800a19:	38 c2                	cmp    %al,%dl
  800a1b:	74 e3                	je     800a00 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	8a 00                	mov    (%eax),%al
  800a22:	0f b6 d0             	movzbl %al,%edx
  800a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a28:	8a 00                	mov    (%eax),%al
  800a2a:	0f b6 c0             	movzbl %al,%eax
  800a2d:	29 c2                	sub    %eax,%edx
  800a2f:	89 d0                	mov    %edx,%eax
}
  800a31:	5d                   	pop    %ebp
  800a32:	c3                   	ret    

00800a33 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a36:	eb 09                	jmp    800a41 <strncmp+0xe>
		n--, p++, q++;
  800a38:	ff 4d 10             	decl   0x10(%ebp)
  800a3b:	ff 45 08             	incl   0x8(%ebp)
  800a3e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a45:	74 17                	je     800a5e <strncmp+0x2b>
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	8a 00                	mov    (%eax),%al
  800a4c:	84 c0                	test   %al,%al
  800a4e:	74 0e                	je     800a5e <strncmp+0x2b>
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	8a 10                	mov    (%eax),%dl
  800a55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a58:	8a 00                	mov    (%eax),%al
  800a5a:	38 c2                	cmp    %al,%dl
  800a5c:	74 da                	je     800a38 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a62:	75 07                	jne    800a6b <strncmp+0x38>
		return 0;
  800a64:	b8 00 00 00 00       	mov    $0x0,%eax
  800a69:	eb 14                	jmp    800a7f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	8a 00                	mov    (%eax),%al
  800a70:	0f b6 d0             	movzbl %al,%edx
  800a73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a76:	8a 00                	mov    (%eax),%al
  800a78:	0f b6 c0             	movzbl %al,%eax
  800a7b:	29 c2                	sub    %eax,%edx
  800a7d:	89 d0                	mov    %edx,%eax
}
  800a7f:	5d                   	pop    %ebp
  800a80:	c3                   	ret    

00800a81 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	83 ec 04             	sub    $0x4,%esp
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a8d:	eb 12                	jmp    800aa1 <strchr+0x20>
		if (*s == c)
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8a 00                	mov    (%eax),%al
  800a94:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a97:	75 05                	jne    800a9e <strchr+0x1d>
			return (char *) s;
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	eb 11                	jmp    800aaf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a9e:	ff 45 08             	incl   0x8(%ebp)
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	8a 00                	mov    (%eax),%al
  800aa6:	84 c0                	test   %al,%al
  800aa8:	75 e5                	jne    800a8f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800aaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aaf:	c9                   	leave  
  800ab0:	c3                   	ret    

00800ab1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800abd:	eb 0d                	jmp    800acc <strfind+0x1b>
		if (*s == c)
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8a 00                	mov    (%eax),%al
  800ac4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ac7:	74 0e                	je     800ad7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ac9:	ff 45 08             	incl   0x8(%ebp)
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	8a 00                	mov    (%eax),%al
  800ad1:	84 c0                	test   %al,%al
  800ad3:	75 ea                	jne    800abf <strfind+0xe>
  800ad5:	eb 01                	jmp    800ad8 <strfind+0x27>
		if (*s == c)
			break;
  800ad7:	90                   	nop
	return (char *) s;
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800adb:	c9                   	leave  
  800adc:	c3                   	ret    

00800add <memset>:

int i=0;
void *
memset(void *v, int c, uint32 n)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	83 ec 10             	sub    $0x10,%esp


	i++;
  800ae3:	a1 28 20 80 00       	mov    0x802028,%eax
  800ae8:	40                   	inc    %eax
  800ae9:	a3 28 20 80 00       	mov    %eax,0x802028

	char *p;
	int m;

	p = v;
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800af4:	8b 45 10             	mov    0x10(%ebp),%eax
  800af7:	89 45 f8             	mov    %eax,-0x8(%ebp)


	while (--m >= 0){
  800afa:	eb 0e                	jmp    800b0a <memset+0x2d>

		*p++ = c;
  800afc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aff:	8d 50 01             	lea    0x1(%eax),%edx
  800b02:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b08:	88 10                	mov    %dl,(%eax)

	p = v;
	m = n;


	while (--m >= 0){
  800b0a:	ff 4d f8             	decl   -0x8(%ebp)
  800b0d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b11:	79 e9                	jns    800afc <memset+0x1f>

		*p++ = c;
	}

	return v;
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b16:	c9                   	leave  
  800b17:	c3                   	ret    

00800b18 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b2a:	eb 16                	jmp    800b42 <memcpy+0x2a>
		*d++ = *s++;
  800b2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b2f:	8d 50 01             	lea    0x1(%eax),%edx
  800b32:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b35:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b38:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b3b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b3e:	8a 12                	mov    (%edx),%dl
  800b40:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b42:	8b 45 10             	mov    0x10(%ebp),%eax
  800b45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b48:	89 55 10             	mov    %edx,0x10(%ebp)
  800b4b:	85 c0                	test   %eax,%eax
  800b4d:	75 dd                	jne    800b2c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b52:	c9                   	leave  
  800b53:	c3                   	ret    

00800b54 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b69:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b6c:	73 50                	jae    800bbe <memmove+0x6a>
  800b6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b71:	8b 45 10             	mov    0x10(%ebp),%eax
  800b74:	01 d0                	add    %edx,%eax
  800b76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b79:	76 43                	jbe    800bbe <memmove+0x6a>
		s += n;
  800b7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b81:	8b 45 10             	mov    0x10(%ebp),%eax
  800b84:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b87:	eb 10                	jmp    800b99 <memmove+0x45>
			*--d = *--s;
  800b89:	ff 4d f8             	decl   -0x8(%ebp)
  800b8c:	ff 4d fc             	decl   -0x4(%ebp)
  800b8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b92:	8a 10                	mov    (%eax),%dl
  800b94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b97:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b99:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b9f:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba2:	85 c0                	test   %eax,%eax
  800ba4:	75 e3                	jne    800b89 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ba6:	eb 23                	jmp    800bcb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ba8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bab:	8d 50 01             	lea    0x1(%eax),%edx
  800bae:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bb1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bb4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bba:	8a 12                	mov    (%edx),%dl
  800bbc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc4:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc7:	85 c0                	test   %eax,%eax
  800bc9:	75 dd                	jne    800ba8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800be2:	eb 2a                	jmp    800c0e <memcmp+0x3e>
		if (*s1 != *s2)
  800be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be7:	8a 10                	mov    (%eax),%dl
  800be9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bec:	8a 00                	mov    (%eax),%al
  800bee:	38 c2                	cmp    %al,%dl
  800bf0:	74 16                	je     800c08 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf5:	8a 00                	mov    (%eax),%al
  800bf7:	0f b6 d0             	movzbl %al,%edx
  800bfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bfd:	8a 00                	mov    (%eax),%al
  800bff:	0f b6 c0             	movzbl %al,%eax
  800c02:	29 c2                	sub    %eax,%edx
  800c04:	89 d0                	mov    %edx,%eax
  800c06:	eb 18                	jmp    800c20 <memcmp+0x50>
		s1++, s2++;
  800c08:	ff 45 fc             	incl   -0x4(%ebp)
  800c0b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c14:	89 55 10             	mov    %edx,0x10(%ebp)
  800c17:	85 c0                	test   %eax,%eax
  800c19:	75 c9                	jne    800be4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c20:	c9                   	leave  
  800c21:	c3                   	ret    

00800c22 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c28:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2e:	01 d0                	add    %edx,%eax
  800c30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c33:	eb 15                	jmp    800c4a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	0f b6 d0             	movzbl %al,%edx
  800c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c40:	0f b6 c0             	movzbl %al,%eax
  800c43:	39 c2                	cmp    %eax,%edx
  800c45:	74 0d                	je     800c54 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c47:	ff 45 08             	incl   0x8(%ebp)
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c50:	72 e3                	jb     800c35 <memfind+0x13>
  800c52:	eb 01                	jmp    800c55 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c54:	90                   	nop
	return (void *) s;
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c67:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6e:	eb 03                	jmp    800c73 <strtol+0x19>
		s++;
  800c70:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	3c 20                	cmp    $0x20,%al
  800c7a:	74 f4                	je     800c70 <strtol+0x16>
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	3c 09                	cmp    $0x9,%al
  800c83:	74 eb                	je     800c70 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	3c 2b                	cmp    $0x2b,%al
  800c8c:	75 05                	jne    800c93 <strtol+0x39>
		s++;
  800c8e:	ff 45 08             	incl   0x8(%ebp)
  800c91:	eb 13                	jmp    800ca6 <strtol+0x4c>
	else if (*s == '-')
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	8a 00                	mov    (%eax),%al
  800c98:	3c 2d                	cmp    $0x2d,%al
  800c9a:	75 0a                	jne    800ca6 <strtol+0x4c>
		s++, neg = 1;
  800c9c:	ff 45 08             	incl   0x8(%ebp)
  800c9f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800caa:	74 06                	je     800cb2 <strtol+0x58>
  800cac:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cb0:	75 20                	jne    800cd2 <strtol+0x78>
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	3c 30                	cmp    $0x30,%al
  800cb9:	75 17                	jne    800cd2 <strtol+0x78>
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	40                   	inc    %eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	3c 78                	cmp    $0x78,%al
  800cc3:	75 0d                	jne    800cd2 <strtol+0x78>
		s += 2, base = 16;
  800cc5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cc9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cd0:	eb 28                	jmp    800cfa <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd6:	75 15                	jne    800ced <strtol+0x93>
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	3c 30                	cmp    $0x30,%al
  800cdf:	75 0c                	jne    800ced <strtol+0x93>
		s++, base = 8;
  800ce1:	ff 45 08             	incl   0x8(%ebp)
  800ce4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ceb:	eb 0d                	jmp    800cfa <strtol+0xa0>
	else if (base == 0)
  800ced:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf1:	75 07                	jne    800cfa <strtol+0xa0>
		base = 10;
  800cf3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	8a 00                	mov    (%eax),%al
  800cff:	3c 2f                	cmp    $0x2f,%al
  800d01:	7e 19                	jle    800d1c <strtol+0xc2>
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	3c 39                	cmp    $0x39,%al
  800d0a:	7f 10                	jg     800d1c <strtol+0xc2>
			dig = *s - '0';
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	0f be c0             	movsbl %al,%eax
  800d14:	83 e8 30             	sub    $0x30,%eax
  800d17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d1a:	eb 42                	jmp    800d5e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8a 00                	mov    (%eax),%al
  800d21:	3c 60                	cmp    $0x60,%al
  800d23:	7e 19                	jle    800d3e <strtol+0xe4>
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	3c 7a                	cmp    $0x7a,%al
  800d2c:	7f 10                	jg     800d3e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	0f be c0             	movsbl %al,%eax
  800d36:	83 e8 57             	sub    $0x57,%eax
  800d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d3c:	eb 20                	jmp    800d5e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	3c 40                	cmp    $0x40,%al
  800d45:	7e 39                	jle    800d80 <strtol+0x126>
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	3c 5a                	cmp    $0x5a,%al
  800d4e:	7f 30                	jg     800d80 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	0f be c0             	movsbl %al,%eax
  800d58:	83 e8 37             	sub    $0x37,%eax
  800d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d61:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d64:	7d 19                	jge    800d7f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d66:	ff 45 08             	incl   0x8(%ebp)
  800d69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d6c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d70:	89 c2                	mov    %eax,%edx
  800d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d75:	01 d0                	add    %edx,%eax
  800d77:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d7a:	e9 7b ff ff ff       	jmp    800cfa <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d7f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d84:	74 08                	je     800d8e <strtol+0x134>
		*endptr = (char *) s;
  800d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d89:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d92:	74 07                	je     800d9b <strtol+0x141>
  800d94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d97:	f7 d8                	neg    %eax
  800d99:	eb 03                	jmp    800d9e <strtol+0x144>
  800d9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <ltostr>:

void
ltostr(long value, char *str)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800da6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800db4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800db8:	79 13                	jns    800dcd <ltostr+0x2d>
	{
		neg = 1;
  800dba:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dc7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dca:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dd5:	99                   	cltd   
  800dd6:	f7 f9                	idiv   %ecx
  800dd8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ddb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dde:	8d 50 01             	lea    0x1(%eax),%edx
  800de1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de4:	89 c2                	mov    %eax,%edx
  800de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de9:	01 d0                	add    %edx,%eax
  800deb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dee:	83 c2 30             	add    $0x30,%edx
  800df1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800df3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800dfb:	f7 e9                	imul   %ecx
  800dfd:	c1 fa 02             	sar    $0x2,%edx
  800e00:	89 c8                	mov    %ecx,%eax
  800e02:	c1 f8 1f             	sar    $0x1f,%eax
  800e05:	29 c2                	sub    %eax,%edx
  800e07:	89 d0                	mov    %edx,%eax
  800e09:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e14:	f7 e9                	imul   %ecx
  800e16:	c1 fa 02             	sar    $0x2,%edx
  800e19:	89 c8                	mov    %ecx,%eax
  800e1b:	c1 f8 1f             	sar    $0x1f,%eax
  800e1e:	29 c2                	sub    %eax,%edx
  800e20:	89 d0                	mov    %edx,%eax
  800e22:	c1 e0 02             	shl    $0x2,%eax
  800e25:	01 d0                	add    %edx,%eax
  800e27:	01 c0                	add    %eax,%eax
  800e29:	29 c1                	sub    %eax,%ecx
  800e2b:	89 ca                	mov    %ecx,%edx
  800e2d:	85 d2                	test   %edx,%edx
  800e2f:	75 9c                	jne    800dcd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3b:	48                   	dec    %eax
  800e3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e43:	74 3d                	je     800e82 <ltostr+0xe2>
		start = 1 ;
  800e45:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e4c:	eb 34                	jmp    800e82 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e54:	01 d0                	add    %edx,%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	01 c2                	add    %eax,%edx
  800e63:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e69:	01 c8                	add    %ecx,%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	01 c2                	add    %eax,%edx
  800e77:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e7a:	88 02                	mov    %al,(%edx)
		start++ ;
  800e7c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e7f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e85:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e88:	7c c4                	jl     800e4e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e8a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e90:	01 d0                	add    %edx,%eax
  800e92:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e95:	90                   	nop
  800e96:	c9                   	leave  
  800e97:	c3                   	ret    

00800e98 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e9e:	ff 75 08             	pushl  0x8(%ebp)
  800ea1:	e8 49 fa ff ff       	call   8008ef <strlen>
  800ea6:	83 c4 04             	add    $0x4,%esp
  800ea9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	e8 3b fa ff ff       	call   8008ef <strlen>
  800eb4:	83 c4 04             	add    $0x4,%esp
  800eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800eba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ec1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec8:	eb 17                	jmp    800ee1 <strcconcat+0x49>
		final[s] = str1[s] ;
  800eca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed0:	01 c2                	add    %eax,%edx
  800ed2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	01 c8                	add    %ecx,%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ede:	ff 45 fc             	incl   -0x4(%ebp)
  800ee1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ee7:	7c e1                	jl     800eca <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ee9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ef0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ef7:	eb 1f                	jmp    800f18 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efc:	8d 50 01             	lea    0x1(%eax),%edx
  800eff:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f02:	89 c2                	mov    %eax,%edx
  800f04:	8b 45 10             	mov    0x10(%ebp),%eax
  800f07:	01 c2                	add    %eax,%edx
  800f09:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0f:	01 c8                	add    %ecx,%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f15:	ff 45 f8             	incl   -0x8(%ebp)
  800f18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f1e:	7c d9                	jl     800ef9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f20:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f23:	8b 45 10             	mov    0x10(%ebp),%eax
  800f26:	01 d0                	add    %edx,%eax
  800f28:	c6 00 00             	movb   $0x0,(%eax)
}
  800f2b:	90                   	nop
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f31:	8b 45 14             	mov    0x14(%ebp),%eax
  800f34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3d:	8b 00                	mov    (%eax),%eax
  800f3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f46:	8b 45 10             	mov    0x10(%ebp),%eax
  800f49:	01 d0                	add    %edx,%eax
  800f4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f51:	eb 0c                	jmp    800f5f <strsplit+0x31>
			*string++ = 0;
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	8d 50 01             	lea    0x1(%eax),%edx
  800f59:	89 55 08             	mov    %edx,0x8(%ebp)
  800f5c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	84 c0                	test   %al,%al
  800f66:	74 18                	je     800f80 <strsplit+0x52>
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	0f be c0             	movsbl %al,%eax
  800f70:	50                   	push   %eax
  800f71:	ff 75 0c             	pushl  0xc(%ebp)
  800f74:	e8 08 fb ff ff       	call   800a81 <strchr>
  800f79:	83 c4 08             	add    $0x8,%esp
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	75 d3                	jne    800f53 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	84 c0                	test   %al,%al
  800f87:	74 5a                	je     800fe3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f89:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8c:	8b 00                	mov    (%eax),%eax
  800f8e:	83 f8 0f             	cmp    $0xf,%eax
  800f91:	75 07                	jne    800f9a <strsplit+0x6c>
		{
			return 0;
  800f93:	b8 00 00 00 00       	mov    $0x0,%eax
  800f98:	eb 66                	jmp    801000 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9d:	8b 00                	mov    (%eax),%eax
  800f9f:	8d 48 01             	lea    0x1(%eax),%ecx
  800fa2:	8b 55 14             	mov    0x14(%ebp),%edx
  800fa5:	89 0a                	mov    %ecx,(%edx)
  800fa7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fae:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb1:	01 c2                	add    %eax,%edx
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fb8:	eb 03                	jmp    800fbd <strsplit+0x8f>
			string++;
  800fba:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	8a 00                	mov    (%eax),%al
  800fc2:	84 c0                	test   %al,%al
  800fc4:	74 8b                	je     800f51 <strsplit+0x23>
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	0f be c0             	movsbl %al,%eax
  800fce:	50                   	push   %eax
  800fcf:	ff 75 0c             	pushl  0xc(%ebp)
  800fd2:	e8 aa fa ff ff       	call   800a81 <strchr>
  800fd7:	83 c4 08             	add    $0x8,%esp
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	74 dc                	je     800fba <strsplit+0x8c>
			string++;
	}
  800fde:	e9 6e ff ff ff       	jmp    800f51 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fe3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fe4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe7:	8b 00                	mov    (%eax),%eax
  800fe9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ff0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff3:	01 d0                	add    %edx,%eax
  800ff5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800ffb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801000:	c9                   	leave  
  801001:	c3                   	ret    

00801002 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  801008:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80100c:	74 06                	je     801014 <str2lower+0x12>
  80100e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801012:	75 07                	jne    80101b <str2lower+0x19>
		return NULL;
  801014:	b8 00 00 00 00       	mov    $0x0,%eax
  801019:	eb 4d                	jmp    801068 <str2lower+0x66>
	}
	char *ref=dst;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  801021:	eb 33                	jmp    801056 <str2lower+0x54>
			if(*src>=65&&*src<=90){
  801023:	8b 45 0c             	mov    0xc(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 40                	cmp    $0x40,%al
  80102a:	7e 1a                	jle    801046 <str2lower+0x44>
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	3c 5a                	cmp    $0x5a,%al
  801033:	7f 11                	jg     801046 <str2lower+0x44>
				*dst=*src+32;
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	83 c0 20             	add    $0x20,%eax
  80103d:	88 c2                	mov    %al,%dl
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	88 10                	mov    %dl,(%eax)
  801044:	eb 0a                	jmp    801050 <str2lower+0x4e>
			}
			else{
				*dst=*src;
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	8a 10                	mov    (%eax),%dl
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	88 10                	mov    %dl,(%eax)
			}
			src++;
  801050:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  801053:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  801056:	8b 45 0c             	mov    0xc(%ebp),%eax
  801059:	8a 00                	mov    (%eax),%al
  80105b:	84 c0                	test   %al,%al
  80105d:	75 c4                	jne    801023 <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  801065:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801068:	c9                   	leave  
  801069:	c3                   	ret    

0080106a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	57                   	push   %edi
  80106e:	56                   	push   %esi
  80106f:	53                   	push   %ebx
  801070:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8b 55 0c             	mov    0xc(%ebp),%edx
  801079:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80107c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80107f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801082:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801085:	cd 30                	int    $0x30
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80108a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80108d:	83 c4 10             	add    $0x10,%esp
  801090:	5b                   	pop    %ebx
  801091:	5e                   	pop    %esi
  801092:	5f                   	pop    %edi
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    

00801095 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 04             	sub    $0x4,%esp
  80109b:	8b 45 10             	mov    0x10(%ebp),%eax
  80109e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010a1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	6a 00                	push   $0x0
  8010aa:	6a 00                	push   $0x0
  8010ac:	52                   	push   %edx
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	50                   	push   %eax
  8010b1:	6a 00                	push   $0x0
  8010b3:	e8 b2 ff ff ff       	call   80106a <syscall>
  8010b8:	83 c4 18             	add    $0x18,%esp
}
  8010bb:	90                   	nop
  8010bc:	c9                   	leave  
  8010bd:	c3                   	ret    

008010be <sys_cgetc>:

int
sys_cgetc(void)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010c1:	6a 00                	push   $0x0
  8010c3:	6a 00                	push   $0x0
  8010c5:	6a 00                	push   $0x0
  8010c7:	6a 00                	push   $0x0
  8010c9:	6a 00                	push   $0x0
  8010cb:	6a 01                	push   $0x1
  8010cd:	e8 98 ff ff ff       	call   80106a <syscall>
  8010d2:	83 c4 18             	add    $0x18,%esp
}
  8010d5:	c9                   	leave  
  8010d6:	c3                   	ret    

008010d7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e0:	6a 00                	push   $0x0
  8010e2:	6a 00                	push   $0x0
  8010e4:	6a 00                	push   $0x0
  8010e6:	52                   	push   %edx
  8010e7:	50                   	push   %eax
  8010e8:	6a 05                	push   $0x5
  8010ea:	e8 7b ff ff ff       	call   80106a <syscall>
  8010ef:	83 c4 18             	add    $0x18,%esp
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	56                   	push   %esi
  8010f8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010f9:	8b 75 18             	mov    0x18(%ebp),%esi
  8010fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801102:	8b 55 0c             	mov    0xc(%ebp),%edx
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	56                   	push   %esi
  801109:	53                   	push   %ebx
  80110a:	51                   	push   %ecx
  80110b:	52                   	push   %edx
  80110c:	50                   	push   %eax
  80110d:	6a 06                	push   $0x6
  80110f:	e8 56 ff ff ff       	call   80106a <syscall>
  801114:	83 c4 18             	add    $0x18,%esp
}
  801117:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80111a:	5b                   	pop    %ebx
  80111b:	5e                   	pop    %esi
  80111c:	5d                   	pop    %ebp
  80111d:	c3                   	ret    

0080111e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801121:	8b 55 0c             	mov    0xc(%ebp),%edx
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	6a 00                	push   $0x0
  801129:	6a 00                	push   $0x0
  80112b:	6a 00                	push   $0x0
  80112d:	52                   	push   %edx
  80112e:	50                   	push   %eax
  80112f:	6a 07                	push   $0x7
  801131:	e8 34 ff ff ff       	call   80106a <syscall>
  801136:	83 c4 18             	add    $0x18,%esp
}
  801139:	c9                   	leave  
  80113a:	c3                   	ret    

0080113b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80113e:	6a 00                	push   $0x0
  801140:	6a 00                	push   $0x0
  801142:	6a 00                	push   $0x0
  801144:	ff 75 0c             	pushl  0xc(%ebp)
  801147:	ff 75 08             	pushl  0x8(%ebp)
  80114a:	6a 08                	push   $0x8
  80114c:	e8 19 ff ff ff       	call   80106a <syscall>
  801151:	83 c4 18             	add    $0x18,%esp
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801159:	6a 00                	push   $0x0
  80115b:	6a 00                	push   $0x0
  80115d:	6a 00                	push   $0x0
  80115f:	6a 00                	push   $0x0
  801161:	6a 00                	push   $0x0
  801163:	6a 09                	push   $0x9
  801165:	e8 00 ff ff ff       	call   80106a <syscall>
  80116a:	83 c4 18             	add    $0x18,%esp
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801172:	6a 00                	push   $0x0
  801174:	6a 00                	push   $0x0
  801176:	6a 00                	push   $0x0
  801178:	6a 00                	push   $0x0
  80117a:	6a 00                	push   $0x0
  80117c:	6a 0a                	push   $0xa
  80117e:	e8 e7 fe ff ff       	call   80106a <syscall>
  801183:	83 c4 18             	add    $0x18,%esp
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80118b:	6a 00                	push   $0x0
  80118d:	6a 00                	push   $0x0
  80118f:	6a 00                	push   $0x0
  801191:	6a 00                	push   $0x0
  801193:	6a 00                	push   $0x0
  801195:	6a 0b                	push   $0xb
  801197:	e8 ce fe ff ff       	call   80106a <syscall>
  80119c:	83 c4 18             	add    $0x18,%esp
}
  80119f:	c9                   	leave  
  8011a0:	c3                   	ret    

008011a1 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011a4:	6a 00                	push   $0x0
  8011a6:	6a 00                	push   $0x0
  8011a8:	6a 00                	push   $0x0
  8011aa:	6a 00                	push   $0x0
  8011ac:	6a 00                	push   $0x0
  8011ae:	6a 0c                	push   $0xc
  8011b0:	e8 b5 fe ff ff       	call   80106a <syscall>
  8011b5:	83 c4 18             	add    $0x18,%esp
}
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    

008011ba <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011bd:	6a 00                	push   $0x0
  8011bf:	6a 00                	push   $0x0
  8011c1:	6a 00                	push   $0x0
  8011c3:	6a 00                	push   $0x0
  8011c5:	ff 75 08             	pushl  0x8(%ebp)
  8011c8:	6a 0d                	push   $0xd
  8011ca:	e8 9b fe ff ff       	call   80106a <syscall>
  8011cf:	83 c4 18             	add    $0x18,%esp
}
  8011d2:	c9                   	leave  
  8011d3:	c3                   	ret    

008011d4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011d7:	6a 00                	push   $0x0
  8011d9:	6a 00                	push   $0x0
  8011db:	6a 00                	push   $0x0
  8011dd:	6a 00                	push   $0x0
  8011df:	6a 00                	push   $0x0
  8011e1:	6a 0e                	push   $0xe
  8011e3:	e8 82 fe ff ff       	call   80106a <syscall>
  8011e8:	83 c4 18             	add    $0x18,%esp
}
  8011eb:	90                   	nop
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8011f1:	6a 00                	push   $0x0
  8011f3:	6a 00                	push   $0x0
  8011f5:	6a 00                	push   $0x0
  8011f7:	6a 00                	push   $0x0
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 11                	push   $0x11
  8011fd:	e8 68 fe ff ff       	call   80106a <syscall>
  801202:	83 c4 18             	add    $0x18,%esp
}
  801205:	90                   	nop
  801206:	c9                   	leave  
  801207:	c3                   	ret    

00801208 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80120b:	6a 00                	push   $0x0
  80120d:	6a 00                	push   $0x0
  80120f:	6a 00                	push   $0x0
  801211:	6a 00                	push   $0x0
  801213:	6a 00                	push   $0x0
  801215:	6a 12                	push   $0x12
  801217:	e8 4e fe ff ff       	call   80106a <syscall>
  80121c:	83 c4 18             	add    $0x18,%esp
}
  80121f:	90                   	nop
  801220:	c9                   	leave  
  801221:	c3                   	ret    

00801222 <sys_cputc>:


void
sys_cputc(const char c)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	83 ec 04             	sub    $0x4,%esp
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80122e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801232:	6a 00                	push   $0x0
  801234:	6a 00                	push   $0x0
  801236:	6a 00                	push   $0x0
  801238:	6a 00                	push   $0x0
  80123a:	50                   	push   %eax
  80123b:	6a 13                	push   $0x13
  80123d:	e8 28 fe ff ff       	call   80106a <syscall>
  801242:	83 c4 18             	add    $0x18,%esp
}
  801245:	90                   	nop
  801246:	c9                   	leave  
  801247:	c3                   	ret    

00801248 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80124b:	6a 00                	push   $0x0
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	6a 00                	push   $0x0
  801255:	6a 14                	push   $0x14
  801257:	e8 0e fe ff ff       	call   80106a <syscall>
  80125c:	83 c4 18             	add    $0x18,%esp
}
  80125f:	90                   	nop
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	6a 00                	push   $0x0
  80126a:	6a 00                	push   $0x0
  80126c:	6a 00                	push   $0x0
  80126e:	ff 75 0c             	pushl  0xc(%ebp)
  801271:	50                   	push   %eax
  801272:	6a 15                	push   $0x15
  801274:	e8 f1 fd ff ff       	call   80106a <syscall>
  801279:	83 c4 18             	add    $0x18,%esp
}
  80127c:	c9                   	leave  
  80127d:	c3                   	ret    

0080127e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801281:	8b 55 0c             	mov    0xc(%ebp),%edx
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	6a 00                	push   $0x0
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	52                   	push   %edx
  80128e:	50                   	push   %eax
  80128f:	6a 18                	push   $0x18
  801291:	e8 d4 fd ff ff       	call   80106a <syscall>
  801296:	83 c4 18             	add    $0x18,%esp
}
  801299:	c9                   	leave  
  80129a:	c3                   	ret    

0080129b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80129e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	52                   	push   %edx
  8012ab:	50                   	push   %eax
  8012ac:	6a 16                	push   $0x16
  8012ae:	e8 b7 fd ff ff       	call   80106a <syscall>
  8012b3:	83 c4 18             	add    $0x18,%esp
}
  8012b6:	90                   	nop
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	52                   	push   %edx
  8012c9:	50                   	push   %eax
  8012ca:	6a 17                	push   $0x17
  8012cc:	e8 99 fd ff ff       	call   80106a <syscall>
  8012d1:	83 c4 18             	add    $0x18,%esp
}
  8012d4:	90                   	nop
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	83 ec 04             	sub    $0x4,%esp
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012e3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012e6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	6a 00                	push   $0x0
  8012ef:	51                   	push   %ecx
  8012f0:	52                   	push   %edx
  8012f1:	ff 75 0c             	pushl  0xc(%ebp)
  8012f4:	50                   	push   %eax
  8012f5:	6a 19                	push   $0x19
  8012f7:	e8 6e fd ff ff       	call   80106a <syscall>
  8012fc:	83 c4 18             	add    $0x18,%esp
}
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801304:	8b 55 0c             	mov    0xc(%ebp),%edx
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	52                   	push   %edx
  801311:	50                   	push   %eax
  801312:	6a 1a                	push   $0x1a
  801314:	e8 51 fd ff ff       	call   80106a <syscall>
  801319:	83 c4 18             	add    $0x18,%esp
}
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801321:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801324:	8b 55 0c             	mov    0xc(%ebp),%edx
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	51                   	push   %ecx
  80132f:	52                   	push   %edx
  801330:	50                   	push   %eax
  801331:	6a 1b                	push   $0x1b
  801333:	e8 32 fd ff ff       	call   80106a <syscall>
  801338:	83 c4 18             	add    $0x18,%esp
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801340:	8b 55 0c             	mov    0xc(%ebp),%edx
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	52                   	push   %edx
  80134d:	50                   	push   %eax
  80134e:	6a 1c                	push   $0x1c
  801350:	e8 15 fd ff ff       	call   80106a <syscall>
  801355:	83 c4 18             	add    $0x18,%esp
}
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	6a 1d                	push   $0x1d
  801369:	e8 fc fc ff ff       	call   80106a <syscall>
  80136e:	83 c4 18             	add    $0x18,%esp
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	6a 00                	push   $0x0
  80137b:	ff 75 14             	pushl  0x14(%ebp)
  80137e:	ff 75 10             	pushl  0x10(%ebp)
  801381:	ff 75 0c             	pushl  0xc(%ebp)
  801384:	50                   	push   %eax
  801385:	6a 1e                	push   $0x1e
  801387:	e8 de fc ff ff       	call   80106a <syscall>
  80138c:	83 c4 18             	add    $0x18,%esp
}
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	50                   	push   %eax
  8013a0:	6a 1f                	push   $0x1f
  8013a2:	e8 c3 fc ff ff       	call   80106a <syscall>
  8013a7:	83 c4 18             	add    $0x18,%esp
}
  8013aa:	90                   	nop
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	50                   	push   %eax
  8013bc:	6a 20                	push   $0x20
  8013be:	e8 a7 fc ff ff       	call   80106a <syscall>
  8013c3:	83 c4 18             	add    $0x18,%esp
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 02                	push   $0x2
  8013d7:	e8 8e fc ff ff       	call   80106a <syscall>
  8013dc:	83 c4 18             	add    $0x18,%esp
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 03                	push   $0x3
  8013f0:	e8 75 fc ff ff       	call   80106a <syscall>
  8013f5:	83 c4 18             	add    $0x18,%esp
}
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

008013fa <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 04                	push   $0x4
  801409:	e8 5c fc ff ff       	call   80106a <syscall>
  80140e:	83 c4 18             	add    $0x18,%esp
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <sys_exit_env>:


void sys_exit_env(void)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	6a 21                	push   $0x21
  801422:	e8 43 fc ff ff       	call   80106a <syscall>
  801427:	83 c4 18             	add    $0x18,%esp
}
  80142a:	90                   	nop
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801433:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801436:	8d 50 04             	lea    0x4(%eax),%edx
  801439:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	52                   	push   %edx
  801443:	50                   	push   %eax
  801444:	6a 22                	push   $0x22
  801446:	e8 1f fc ff ff       	call   80106a <syscall>
  80144b:	83 c4 18             	add    $0x18,%esp
	return result;
  80144e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801451:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801454:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801457:	89 01                	mov    %eax,(%ecx)
  801459:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	c9                   	leave  
  801460:	c2 04 00             	ret    $0x4

00801463 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	ff 75 10             	pushl  0x10(%ebp)
  80146d:	ff 75 0c             	pushl  0xc(%ebp)
  801470:	ff 75 08             	pushl  0x8(%ebp)
  801473:	6a 10                	push   $0x10
  801475:	e8 f0 fb ff ff       	call   80106a <syscall>
  80147a:	83 c4 18             	add    $0x18,%esp
	return ;
  80147d:	90                   	nop
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <sys_rcr2>:
uint32 sys_rcr2()
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 23                	push   $0x23
  80148f:	e8 d6 fb ff ff       	call   80106a <syscall>
  801494:	83 c4 18             	add    $0x18,%esp
}
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 04             	sub    $0x4,%esp
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014a5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	50                   	push   %eax
  8014b2:	6a 24                	push   $0x24
  8014b4:	e8 b1 fb ff ff       	call   80106a <syscall>
  8014b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8014bc:	90                   	nop
}
  8014bd:	c9                   	leave  
  8014be:	c3                   	ret    

008014bf <rsttst>:
void rsttst()
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 26                	push   $0x26
  8014ce:	e8 97 fb ff ff       	call   80106a <syscall>
  8014d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8014d6:	90                   	nop
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	83 ec 04             	sub    $0x4,%esp
  8014df:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014e5:	8b 55 18             	mov    0x18(%ebp),%edx
  8014e8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014ec:	52                   	push   %edx
  8014ed:	50                   	push   %eax
  8014ee:	ff 75 10             	pushl  0x10(%ebp)
  8014f1:	ff 75 0c             	pushl  0xc(%ebp)
  8014f4:	ff 75 08             	pushl  0x8(%ebp)
  8014f7:	6a 25                	push   $0x25
  8014f9:	e8 6c fb ff ff       	call   80106a <syscall>
  8014fe:	83 c4 18             	add    $0x18,%esp
	return ;
  801501:	90                   	nop
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <chktst>:
void chktst(uint32 n)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	ff 75 08             	pushl  0x8(%ebp)
  801512:	6a 27                	push   $0x27
  801514:	e8 51 fb ff ff       	call   80106a <syscall>
  801519:	83 c4 18             	add    $0x18,%esp
	return ;
  80151c:	90                   	nop
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <inctst>:

void inctst()
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 28                	push   $0x28
  80152e:	e8 37 fb ff ff       	call   80106a <syscall>
  801533:	83 c4 18             	add    $0x18,%esp
	return ;
  801536:	90                   	nop
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <gettst>:
uint32 gettst()
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 29                	push   $0x29
  801548:	e8 1d fb ff ff       	call   80106a <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
}
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
  801555:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 2a                	push   $0x2a
  801564:	e8 01 fb ff ff       	call   80106a <syscall>
  801569:	83 c4 18             	add    $0x18,%esp
  80156c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80156f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801573:	75 07                	jne    80157c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801575:	b8 01 00 00 00       	mov    $0x1,%eax
  80157a:	eb 05                	jmp    801581 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80157c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 2a                	push   $0x2a
  801595:	e8 d0 fa ff ff       	call   80106a <syscall>
  80159a:	83 c4 18             	add    $0x18,%esp
  80159d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015a0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015a4:	75 07                	jne    8015ad <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8015ab:	eb 05                	jmp    8015b2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 2a                	push   $0x2a
  8015c6:	e8 9f fa ff ff       	call   80106a <syscall>
  8015cb:	83 c4 18             	add    $0x18,%esp
  8015ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015d1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015d5:	75 07                	jne    8015de <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8015dc:	eb 05                	jmp    8015e3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 2a                	push   $0x2a
  8015f7:	e8 6e fa ff ff       	call   80106a <syscall>
  8015fc:	83 c4 18             	add    $0x18,%esp
  8015ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801602:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801606:	75 07                	jne    80160f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801608:	b8 01 00 00 00       	mov    $0x1,%eax
  80160d:	eb 05                	jmp    801614 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80160f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	ff 75 08             	pushl  0x8(%ebp)
  801624:	6a 2b                	push   $0x2b
  801626:	e8 3f fa ff ff       	call   80106a <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
	return ;
  80162e:	90                   	nop
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801635:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801638:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80163b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	6a 00                	push   $0x0
  801643:	53                   	push   %ebx
  801644:	51                   	push   %ecx
  801645:	52                   	push   %edx
  801646:	50                   	push   %eax
  801647:	6a 2c                	push   $0x2c
  801649:	e8 1c fa ff ff       	call   80106a <syscall>
  80164e:	83 c4 18             	add    $0x18,%esp
}
  801651:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801659:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	52                   	push   %edx
  801666:	50                   	push   %eax
  801667:	6a 2d                	push   $0x2d
  801669:	e8 fc f9 ff ff       	call   80106a <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801676:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801679:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	6a 00                	push   $0x0
  801681:	51                   	push   %ecx
  801682:	ff 75 10             	pushl  0x10(%ebp)
  801685:	52                   	push   %edx
  801686:	50                   	push   %eax
  801687:	6a 2e                	push   $0x2e
  801689:	e8 dc f9 ff ff       	call   80106a <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	ff 75 10             	pushl  0x10(%ebp)
  80169d:	ff 75 0c             	pushl  0xc(%ebp)
  8016a0:	ff 75 08             	pushl  0x8(%ebp)
  8016a3:	6a 0f                	push   $0xf
  8016a5:	e8 c0 f9 ff ff       	call   80106a <syscall>
  8016aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ad:	90                   	nop
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	50                   	push   %eax
  8016bf:	6a 2f                	push   $0x2f
  8016c1:	e8 a4 f9 ff ff       	call   80106a <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	ff 75 08             	pushl  0x8(%ebp)
  8016da:	6a 30                	push   $0x30
  8016dc:	e8 89 f9 ff ff       	call   80106a <syscall>
  8016e1:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  8016e4:	90                   	nop
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	ff 75 0c             	pushl  0xc(%ebp)
  8016f3:	ff 75 08             	pushl  0x8(%ebp)
  8016f6:	6a 31                	push   $0x31
  8016f8:	e8 6d f9 ff ff       	call   80106a <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801700:	90                   	nop
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    
  801703:	90                   	nop

00801704 <__udivdi3>:
  801704:	55                   	push   %ebp
  801705:	57                   	push   %edi
  801706:	56                   	push   %esi
  801707:	53                   	push   %ebx
  801708:	83 ec 1c             	sub    $0x1c,%esp
  80170b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80170f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801713:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801717:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80171b:	89 ca                	mov    %ecx,%edx
  80171d:	89 f8                	mov    %edi,%eax
  80171f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801723:	85 f6                	test   %esi,%esi
  801725:	75 2d                	jne    801754 <__udivdi3+0x50>
  801727:	39 cf                	cmp    %ecx,%edi
  801729:	77 65                	ja     801790 <__udivdi3+0x8c>
  80172b:	89 fd                	mov    %edi,%ebp
  80172d:	85 ff                	test   %edi,%edi
  80172f:	75 0b                	jne    80173c <__udivdi3+0x38>
  801731:	b8 01 00 00 00       	mov    $0x1,%eax
  801736:	31 d2                	xor    %edx,%edx
  801738:	f7 f7                	div    %edi
  80173a:	89 c5                	mov    %eax,%ebp
  80173c:	31 d2                	xor    %edx,%edx
  80173e:	89 c8                	mov    %ecx,%eax
  801740:	f7 f5                	div    %ebp
  801742:	89 c1                	mov    %eax,%ecx
  801744:	89 d8                	mov    %ebx,%eax
  801746:	f7 f5                	div    %ebp
  801748:	89 cf                	mov    %ecx,%edi
  80174a:	89 fa                	mov    %edi,%edx
  80174c:	83 c4 1c             	add    $0x1c,%esp
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5f                   	pop    %edi
  801752:	5d                   	pop    %ebp
  801753:	c3                   	ret    
  801754:	39 ce                	cmp    %ecx,%esi
  801756:	77 28                	ja     801780 <__udivdi3+0x7c>
  801758:	0f bd fe             	bsr    %esi,%edi
  80175b:	83 f7 1f             	xor    $0x1f,%edi
  80175e:	75 40                	jne    8017a0 <__udivdi3+0x9c>
  801760:	39 ce                	cmp    %ecx,%esi
  801762:	72 0a                	jb     80176e <__udivdi3+0x6a>
  801764:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801768:	0f 87 9e 00 00 00    	ja     80180c <__udivdi3+0x108>
  80176e:	b8 01 00 00 00       	mov    $0x1,%eax
  801773:	89 fa                	mov    %edi,%edx
  801775:	83 c4 1c             	add    $0x1c,%esp
  801778:	5b                   	pop    %ebx
  801779:	5e                   	pop    %esi
  80177a:	5f                   	pop    %edi
  80177b:	5d                   	pop    %ebp
  80177c:	c3                   	ret    
  80177d:	8d 76 00             	lea    0x0(%esi),%esi
  801780:	31 ff                	xor    %edi,%edi
  801782:	31 c0                	xor    %eax,%eax
  801784:	89 fa                	mov    %edi,%edx
  801786:	83 c4 1c             	add    $0x1c,%esp
  801789:	5b                   	pop    %ebx
  80178a:	5e                   	pop    %esi
  80178b:	5f                   	pop    %edi
  80178c:	5d                   	pop    %ebp
  80178d:	c3                   	ret    
  80178e:	66 90                	xchg   %ax,%ax
  801790:	89 d8                	mov    %ebx,%eax
  801792:	f7 f7                	div    %edi
  801794:	31 ff                	xor    %edi,%edi
  801796:	89 fa                	mov    %edi,%edx
  801798:	83 c4 1c             	add    $0x1c,%esp
  80179b:	5b                   	pop    %ebx
  80179c:	5e                   	pop    %esi
  80179d:	5f                   	pop    %edi
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    
  8017a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8017a5:	89 eb                	mov    %ebp,%ebx
  8017a7:	29 fb                	sub    %edi,%ebx
  8017a9:	89 f9                	mov    %edi,%ecx
  8017ab:	d3 e6                	shl    %cl,%esi
  8017ad:	89 c5                	mov    %eax,%ebp
  8017af:	88 d9                	mov    %bl,%cl
  8017b1:	d3 ed                	shr    %cl,%ebp
  8017b3:	89 e9                	mov    %ebp,%ecx
  8017b5:	09 f1                	or     %esi,%ecx
  8017b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8017bb:	89 f9                	mov    %edi,%ecx
  8017bd:	d3 e0                	shl    %cl,%eax
  8017bf:	89 c5                	mov    %eax,%ebp
  8017c1:	89 d6                	mov    %edx,%esi
  8017c3:	88 d9                	mov    %bl,%cl
  8017c5:	d3 ee                	shr    %cl,%esi
  8017c7:	89 f9                	mov    %edi,%ecx
  8017c9:	d3 e2                	shl    %cl,%edx
  8017cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017cf:	88 d9                	mov    %bl,%cl
  8017d1:	d3 e8                	shr    %cl,%eax
  8017d3:	09 c2                	or     %eax,%edx
  8017d5:	89 d0                	mov    %edx,%eax
  8017d7:	89 f2                	mov    %esi,%edx
  8017d9:	f7 74 24 0c          	divl   0xc(%esp)
  8017dd:	89 d6                	mov    %edx,%esi
  8017df:	89 c3                	mov    %eax,%ebx
  8017e1:	f7 e5                	mul    %ebp
  8017e3:	39 d6                	cmp    %edx,%esi
  8017e5:	72 19                	jb     801800 <__udivdi3+0xfc>
  8017e7:	74 0b                	je     8017f4 <__udivdi3+0xf0>
  8017e9:	89 d8                	mov    %ebx,%eax
  8017eb:	31 ff                	xor    %edi,%edi
  8017ed:	e9 58 ff ff ff       	jmp    80174a <__udivdi3+0x46>
  8017f2:	66 90                	xchg   %ax,%ax
  8017f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8017f8:	89 f9                	mov    %edi,%ecx
  8017fa:	d3 e2                	shl    %cl,%edx
  8017fc:	39 c2                	cmp    %eax,%edx
  8017fe:	73 e9                	jae    8017e9 <__udivdi3+0xe5>
  801800:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801803:	31 ff                	xor    %edi,%edi
  801805:	e9 40 ff ff ff       	jmp    80174a <__udivdi3+0x46>
  80180a:	66 90                	xchg   %ax,%ax
  80180c:	31 c0                	xor    %eax,%eax
  80180e:	e9 37 ff ff ff       	jmp    80174a <__udivdi3+0x46>
  801813:	90                   	nop

00801814 <__umoddi3>:
  801814:	55                   	push   %ebp
  801815:	57                   	push   %edi
  801816:	56                   	push   %esi
  801817:	53                   	push   %ebx
  801818:	83 ec 1c             	sub    $0x1c,%esp
  80181b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80181f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801823:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801827:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80182b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80182f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801833:	89 f3                	mov    %esi,%ebx
  801835:	89 fa                	mov    %edi,%edx
  801837:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80183b:	89 34 24             	mov    %esi,(%esp)
  80183e:	85 c0                	test   %eax,%eax
  801840:	75 1a                	jne    80185c <__umoddi3+0x48>
  801842:	39 f7                	cmp    %esi,%edi
  801844:	0f 86 a2 00 00 00    	jbe    8018ec <__umoddi3+0xd8>
  80184a:	89 c8                	mov    %ecx,%eax
  80184c:	89 f2                	mov    %esi,%edx
  80184e:	f7 f7                	div    %edi
  801850:	89 d0                	mov    %edx,%eax
  801852:	31 d2                	xor    %edx,%edx
  801854:	83 c4 1c             	add    $0x1c,%esp
  801857:	5b                   	pop    %ebx
  801858:	5e                   	pop    %esi
  801859:	5f                   	pop    %edi
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    
  80185c:	39 f0                	cmp    %esi,%eax
  80185e:	0f 87 ac 00 00 00    	ja     801910 <__umoddi3+0xfc>
  801864:	0f bd e8             	bsr    %eax,%ebp
  801867:	83 f5 1f             	xor    $0x1f,%ebp
  80186a:	0f 84 ac 00 00 00    	je     80191c <__umoddi3+0x108>
  801870:	bf 20 00 00 00       	mov    $0x20,%edi
  801875:	29 ef                	sub    %ebp,%edi
  801877:	89 fe                	mov    %edi,%esi
  801879:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80187d:	89 e9                	mov    %ebp,%ecx
  80187f:	d3 e0                	shl    %cl,%eax
  801881:	89 d7                	mov    %edx,%edi
  801883:	89 f1                	mov    %esi,%ecx
  801885:	d3 ef                	shr    %cl,%edi
  801887:	09 c7                	or     %eax,%edi
  801889:	89 e9                	mov    %ebp,%ecx
  80188b:	d3 e2                	shl    %cl,%edx
  80188d:	89 14 24             	mov    %edx,(%esp)
  801890:	89 d8                	mov    %ebx,%eax
  801892:	d3 e0                	shl    %cl,%eax
  801894:	89 c2                	mov    %eax,%edx
  801896:	8b 44 24 08          	mov    0x8(%esp),%eax
  80189a:	d3 e0                	shl    %cl,%eax
  80189c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018a4:	89 f1                	mov    %esi,%ecx
  8018a6:	d3 e8                	shr    %cl,%eax
  8018a8:	09 d0                	or     %edx,%eax
  8018aa:	d3 eb                	shr    %cl,%ebx
  8018ac:	89 da                	mov    %ebx,%edx
  8018ae:	f7 f7                	div    %edi
  8018b0:	89 d3                	mov    %edx,%ebx
  8018b2:	f7 24 24             	mull   (%esp)
  8018b5:	89 c6                	mov    %eax,%esi
  8018b7:	89 d1                	mov    %edx,%ecx
  8018b9:	39 d3                	cmp    %edx,%ebx
  8018bb:	0f 82 87 00 00 00    	jb     801948 <__umoddi3+0x134>
  8018c1:	0f 84 91 00 00 00    	je     801958 <__umoddi3+0x144>
  8018c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8018cb:	29 f2                	sub    %esi,%edx
  8018cd:	19 cb                	sbb    %ecx,%ebx
  8018cf:	89 d8                	mov    %ebx,%eax
  8018d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8018d5:	d3 e0                	shl    %cl,%eax
  8018d7:	89 e9                	mov    %ebp,%ecx
  8018d9:	d3 ea                	shr    %cl,%edx
  8018db:	09 d0                	or     %edx,%eax
  8018dd:	89 e9                	mov    %ebp,%ecx
  8018df:	d3 eb                	shr    %cl,%ebx
  8018e1:	89 da                	mov    %ebx,%edx
  8018e3:	83 c4 1c             	add    $0x1c,%esp
  8018e6:	5b                   	pop    %ebx
  8018e7:	5e                   	pop    %esi
  8018e8:	5f                   	pop    %edi
  8018e9:	5d                   	pop    %ebp
  8018ea:	c3                   	ret    
  8018eb:	90                   	nop
  8018ec:	89 fd                	mov    %edi,%ebp
  8018ee:	85 ff                	test   %edi,%edi
  8018f0:	75 0b                	jne    8018fd <__umoddi3+0xe9>
  8018f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f7:	31 d2                	xor    %edx,%edx
  8018f9:	f7 f7                	div    %edi
  8018fb:	89 c5                	mov    %eax,%ebp
  8018fd:	89 f0                	mov    %esi,%eax
  8018ff:	31 d2                	xor    %edx,%edx
  801901:	f7 f5                	div    %ebp
  801903:	89 c8                	mov    %ecx,%eax
  801905:	f7 f5                	div    %ebp
  801907:	89 d0                	mov    %edx,%eax
  801909:	e9 44 ff ff ff       	jmp    801852 <__umoddi3+0x3e>
  80190e:	66 90                	xchg   %ax,%ax
  801910:	89 c8                	mov    %ecx,%eax
  801912:	89 f2                	mov    %esi,%edx
  801914:	83 c4 1c             	add    $0x1c,%esp
  801917:	5b                   	pop    %ebx
  801918:	5e                   	pop    %esi
  801919:	5f                   	pop    %edi
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    
  80191c:	3b 04 24             	cmp    (%esp),%eax
  80191f:	72 06                	jb     801927 <__umoddi3+0x113>
  801921:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801925:	77 0f                	ja     801936 <__umoddi3+0x122>
  801927:	89 f2                	mov    %esi,%edx
  801929:	29 f9                	sub    %edi,%ecx
  80192b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80192f:	89 14 24             	mov    %edx,(%esp)
  801932:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801936:	8b 44 24 04          	mov    0x4(%esp),%eax
  80193a:	8b 14 24             	mov    (%esp),%edx
  80193d:	83 c4 1c             	add    $0x1c,%esp
  801940:	5b                   	pop    %ebx
  801941:	5e                   	pop    %esi
  801942:	5f                   	pop    %edi
  801943:	5d                   	pop    %ebp
  801944:	c3                   	ret    
  801945:	8d 76 00             	lea    0x0(%esi),%esi
  801948:	2b 04 24             	sub    (%esp),%eax
  80194b:	19 fa                	sbb    %edi,%edx
  80194d:	89 d1                	mov    %edx,%ecx
  80194f:	89 c6                	mov    %eax,%esi
  801951:	e9 71 ff ff ff       	jmp    8018c7 <__umoddi3+0xb3>
  801956:	66 90                	xchg   %ax,%ax
  801958:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80195c:	72 ea                	jb     801948 <__umoddi3+0x134>
  80195e:	89 d9                	mov    %ebx,%ecx
  801960:	e9 62 ff ff ff       	jmp    8018c7 <__umoddi3+0xb3>
