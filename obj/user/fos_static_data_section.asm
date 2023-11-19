
obj/user/fos_static_data_section:     file format elf32-i386


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
  800031:	e8 1b 00 00 00       	call   800051 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

/// Adding array of 20000 integer on user data section
int arr[20000];

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	atomic_cprintf("user data section contains 20,000 integer\n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 80 19 80 00       	push   $0x801980
  800046:	e8 4c 02 00 00       	call   800297 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	
	return;	
  80004e:	90                   	nop
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800057:	e8 82 13 00 00       	call   8013de <sys_getenvindex>
  80005c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80005f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800062:	89 d0                	mov    %edx,%eax
  800064:	01 c0                	add    %eax,%eax
  800066:	01 d0                	add    %edx,%eax
  800068:	01 c0                	add    %eax,%eax
  80006a:	01 d0                	add    %edx,%eax
  80006c:	c1 e0 02             	shl    $0x2,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	01 c0                	add    %eax,%eax
  800073:	01 d0                	add    %edx,%eax
  800075:	c1 e0 02             	shl    $0x2,%eax
  800078:	01 d0                	add    %edx,%eax
  80007a:	c1 e0 02             	shl    $0x2,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	c1 e0 02             	shl    $0x2,%eax
  800082:	01 d0                	add    %edx,%eax
  800084:	c1 e0 05             	shl    $0x5,%eax
  800087:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008c:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800091:	a1 20 20 80 00       	mov    0x802020,%eax
  800096:	8a 40 5c             	mov    0x5c(%eax),%al
  800099:	84 c0                	test   %al,%al
  80009b:	74 0d                	je     8000aa <libmain+0x59>
		binaryname = myEnv->prog_name;
  80009d:	a1 20 20 80 00       	mov    0x802020,%eax
  8000a2:	83 c0 5c             	add    $0x5c,%eax
  8000a5:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ae:	7e 0a                	jle    8000ba <libmain+0x69>
		binaryname = argv[0];
  8000b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b3:	8b 00                	mov    (%eax),%eax
  8000b5:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000ba:	83 ec 08             	sub    $0x8,%esp
  8000bd:	ff 75 0c             	pushl  0xc(%ebp)
  8000c0:	ff 75 08             	pushl  0x8(%ebp)
  8000c3:	e8 70 ff ff ff       	call   800038 <_main>
  8000c8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000cb:	e8 1b 11 00 00       	call   8011eb <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	68 c4 19 80 00       	push   $0x8019c4
  8000d8:	e8 8d 01 00 00       	call   80026a <cprintf>
  8000dd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000e0:	a1 20 20 80 00       	mov    0x802020,%eax
  8000e5:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  8000eb:	a1 20 20 80 00       	mov    0x802020,%eax
  8000f0:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	52                   	push   %edx
  8000fa:	50                   	push   %eax
  8000fb:	68 ec 19 80 00       	push   $0x8019ec
  800100:	e8 65 01 00 00       	call   80026a <cprintf>
  800105:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800108:	a1 20 20 80 00       	mov    0x802020,%eax
  80010d:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  800113:	a1 20 20 80 00       	mov    0x802020,%eax
  800118:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  80011e:	a1 20 20 80 00       	mov    0x802020,%eax
  800123:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  800129:	51                   	push   %ecx
  80012a:	52                   	push   %edx
  80012b:	50                   	push   %eax
  80012c:	68 14 1a 80 00       	push   $0x801a14
  800131:	e8 34 01 00 00       	call   80026a <cprintf>
  800136:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800139:	a1 20 20 80 00       	mov    0x802020,%eax
  80013e:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  800144:	83 ec 08             	sub    $0x8,%esp
  800147:	50                   	push   %eax
  800148:	68 6c 1a 80 00       	push   $0x801a6c
  80014d:	e8 18 01 00 00       	call   80026a <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	68 c4 19 80 00       	push   $0x8019c4
  80015d:	e8 08 01 00 00       	call   80026a <cprintf>
  800162:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800165:	e8 9b 10 00 00       	call   801205 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80016a:	e8 19 00 00 00       	call   800188 <exit>
}
  80016f:	90                   	nop
  800170:	c9                   	leave  
  800171:	c3                   	ret    

00800172 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800172:	55                   	push   %ebp
  800173:	89 e5                	mov    %esp,%ebp
  800175:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	6a 00                	push   $0x0
  80017d:	e8 28 12 00 00       	call   8013aa <sys_destroy_env>
  800182:	83 c4 10             	add    $0x10,%esp
}
  800185:	90                   	nop
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <exit>:

void
exit(void)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80018e:	e8 7d 12 00 00       	call   801410 <sys_exit_env>
}
  800193:	90                   	nop
  800194:	c9                   	leave  
  800195:	c3                   	ret    

00800196 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80019c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8001a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a7:	89 0a                	mov    %ecx,(%edx)
  8001a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ac:	88 d1                	mov    %dl,%cl
  8001ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b8:	8b 00                	mov    (%eax),%eax
  8001ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001bf:	75 2c                	jne    8001ed <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001c1:	a0 24 20 80 00       	mov    0x802024,%al
  8001c6:	0f b6 c0             	movzbl %al,%eax
  8001c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cc:	8b 12                	mov    (%edx),%edx
  8001ce:	89 d1                	mov    %edx,%ecx
  8001d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d3:	83 c2 08             	add    $0x8,%edx
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	50                   	push   %eax
  8001da:	51                   	push   %ecx
  8001db:	52                   	push   %edx
  8001dc:	e8 b1 0e 00 00       	call   801092 <sys_cputs>
  8001e1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f0:	8b 40 04             	mov    0x4(%eax),%eax
  8001f3:	8d 50 01             	lea    0x1(%eax),%edx
  8001f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001fc:	90                   	nop
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800208:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020f:	00 00 00 
	b.cnt = 0;
  800212:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800219:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80021c:	ff 75 0c             	pushl  0xc(%ebp)
  80021f:	ff 75 08             	pushl  0x8(%ebp)
  800222:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800228:	50                   	push   %eax
  800229:	68 96 01 80 00       	push   $0x800196
  80022e:	e8 11 02 00 00       	call   800444 <vprintfmt>
  800233:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800236:	a0 24 20 80 00       	mov    0x802024,%al
  80023b:	0f b6 c0             	movzbl %al,%eax
  80023e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800244:	83 ec 04             	sub    $0x4,%esp
  800247:	50                   	push   %eax
  800248:	52                   	push   %edx
  800249:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80024f:	83 c0 08             	add    $0x8,%eax
  800252:	50                   	push   %eax
  800253:	e8 3a 0e 00 00       	call   801092 <sys_cputs>
  800258:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80025b:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  800262:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800268:	c9                   	leave  
  800269:	c3                   	ret    

0080026a <cprintf>:

int cprintf(const char *fmt, ...) {
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800270:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  800277:	8d 45 0c             	lea    0xc(%ebp),%eax
  80027a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80027d:	8b 45 08             	mov    0x8(%ebp),%eax
  800280:	83 ec 08             	sub    $0x8,%esp
  800283:	ff 75 f4             	pushl  -0xc(%ebp)
  800286:	50                   	push   %eax
  800287:	e8 73 ff ff ff       	call   8001ff <vcprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800292:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800295:	c9                   	leave  
  800296:	c3                   	ret    

00800297 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80029d:	e8 49 0f 00 00       	call   8011eb <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ab:	83 ec 08             	sub    $0x8,%esp
  8002ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b1:	50                   	push   %eax
  8002b2:	e8 48 ff ff ff       	call   8001ff <vcprintf>
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002bd:	e8 43 0f 00 00       	call   801205 <sys_enable_interrupt>
	return cnt;
  8002c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002c5:	c9                   	leave  
  8002c6:	c3                   	ret    

008002c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 14             	sub    $0x14,%esp
  8002ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002da:	8b 45 18             	mov    0x18(%ebp),%eax
  8002dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002e5:	77 55                	ja     80033c <printnum+0x75>
  8002e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002ea:	72 05                	jb     8002f1 <printnum+0x2a>
  8002ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002ef:	77 4b                	ja     80033c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002f4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002f7:	8b 45 18             	mov    0x18(%ebp),%eax
  8002fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ff:	52                   	push   %edx
  800300:	50                   	push   %eax
  800301:	ff 75 f4             	pushl  -0xc(%ebp)
  800304:	ff 75 f0             	pushl  -0x10(%ebp)
  800307:	e8 f4 13 00 00       	call   801700 <__udivdi3>
  80030c:	83 c4 10             	add    $0x10,%esp
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	ff 75 20             	pushl  0x20(%ebp)
  800315:	53                   	push   %ebx
  800316:	ff 75 18             	pushl  0x18(%ebp)
  800319:	52                   	push   %edx
  80031a:	50                   	push   %eax
  80031b:	ff 75 0c             	pushl  0xc(%ebp)
  80031e:	ff 75 08             	pushl  0x8(%ebp)
  800321:	e8 a1 ff ff ff       	call   8002c7 <printnum>
  800326:	83 c4 20             	add    $0x20,%esp
  800329:	eb 1a                	jmp    800345 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 20             	pushl  0x20(%ebp)
  800334:	8b 45 08             	mov    0x8(%ebp),%eax
  800337:	ff d0                	call   *%eax
  800339:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80033c:	ff 4d 1c             	decl   0x1c(%ebp)
  80033f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800343:	7f e6                	jg     80032b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800345:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800348:	bb 00 00 00 00       	mov    $0x0,%ebx
  80034d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800353:	53                   	push   %ebx
  800354:	51                   	push   %ecx
  800355:	52                   	push   %edx
  800356:	50                   	push   %eax
  800357:	e8 b4 14 00 00       	call   801810 <__umoddi3>
  80035c:	83 c4 10             	add    $0x10,%esp
  80035f:	05 94 1c 80 00       	add    $0x801c94,%eax
  800364:	8a 00                	mov    (%eax),%al
  800366:	0f be c0             	movsbl %al,%eax
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	ff 75 0c             	pushl  0xc(%ebp)
  80036f:	50                   	push   %eax
  800370:	8b 45 08             	mov    0x8(%ebp),%eax
  800373:	ff d0                	call   *%eax
  800375:	83 c4 10             	add    $0x10,%esp
}
  800378:	90                   	nop
  800379:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800381:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800385:	7e 1c                	jle    8003a3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	8b 00                	mov    (%eax),%eax
  80038c:	8d 50 08             	lea    0x8(%eax),%edx
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	89 10                	mov    %edx,(%eax)
  800394:	8b 45 08             	mov    0x8(%ebp),%eax
  800397:	8b 00                	mov    (%eax),%eax
  800399:	83 e8 08             	sub    $0x8,%eax
  80039c:	8b 50 04             	mov    0x4(%eax),%edx
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	eb 40                	jmp    8003e3 <getuint+0x65>
	else if (lflag)
  8003a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003a7:	74 1e                	je     8003c7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ac:	8b 00                	mov    (%eax),%eax
  8003ae:	8d 50 04             	lea    0x4(%eax),%edx
  8003b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b4:	89 10                	mov    %edx,(%eax)
  8003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b9:	8b 00                	mov    (%eax),%eax
  8003bb:	83 e8 04             	sub    $0x4,%eax
  8003be:	8b 00                	mov    (%eax),%eax
  8003c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c5:	eb 1c                	jmp    8003e3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ca:	8b 00                	mov    (%eax),%eax
  8003cc:	8d 50 04             	lea    0x4(%eax),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	89 10                	mov    %edx,(%eax)
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	8b 00                	mov    (%eax),%eax
  8003d9:	83 e8 04             	sub    $0x4,%eax
  8003dc:	8b 00                	mov    (%eax),%eax
  8003de:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003e3:	5d                   	pop    %ebp
  8003e4:	c3                   	ret    

008003e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003ec:	7e 1c                	jle    80040a <getint+0x25>
		return va_arg(*ap, long long);
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	8b 00                	mov    (%eax),%eax
  8003f3:	8d 50 08             	lea    0x8(%eax),%edx
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	89 10                	mov    %edx,(%eax)
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	8b 00                	mov    (%eax),%eax
  800400:	83 e8 08             	sub    $0x8,%eax
  800403:	8b 50 04             	mov    0x4(%eax),%edx
  800406:	8b 00                	mov    (%eax),%eax
  800408:	eb 38                	jmp    800442 <getint+0x5d>
	else if (lflag)
  80040a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80040e:	74 1a                	je     80042a <getint+0x45>
		return va_arg(*ap, long);
  800410:	8b 45 08             	mov    0x8(%ebp),%eax
  800413:	8b 00                	mov    (%eax),%eax
  800415:	8d 50 04             	lea    0x4(%eax),%edx
  800418:	8b 45 08             	mov    0x8(%ebp),%eax
  80041b:	89 10                	mov    %edx,(%eax)
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	8b 00                	mov    (%eax),%eax
  800422:	83 e8 04             	sub    $0x4,%eax
  800425:	8b 00                	mov    (%eax),%eax
  800427:	99                   	cltd   
  800428:	eb 18                	jmp    800442 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80042a:	8b 45 08             	mov    0x8(%ebp),%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	8d 50 04             	lea    0x4(%eax),%edx
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	89 10                	mov    %edx,(%eax)
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	83 e8 04             	sub    $0x4,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	99                   	cltd   
}
  800442:	5d                   	pop    %ebp
  800443:	c3                   	ret    

00800444 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800444:	55                   	push   %ebp
  800445:	89 e5                	mov    %esp,%ebp
  800447:	56                   	push   %esi
  800448:	53                   	push   %ebx
  800449:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80044c:	eb 17                	jmp    800465 <vprintfmt+0x21>
			if (ch == '\0')
  80044e:	85 db                	test   %ebx,%ebx
  800450:	0f 84 af 03 00 00    	je     800805 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800456:	83 ec 08             	sub    $0x8,%esp
  800459:	ff 75 0c             	pushl  0xc(%ebp)
  80045c:	53                   	push   %ebx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	ff d0                	call   *%eax
  800462:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800465:	8b 45 10             	mov    0x10(%ebp),%eax
  800468:	8d 50 01             	lea    0x1(%eax),%edx
  80046b:	89 55 10             	mov    %edx,0x10(%ebp)
  80046e:	8a 00                	mov    (%eax),%al
  800470:	0f b6 d8             	movzbl %al,%ebx
  800473:	83 fb 25             	cmp    $0x25,%ebx
  800476:	75 d6                	jne    80044e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800478:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80047c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800483:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80048a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800491:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800498:	8b 45 10             	mov    0x10(%ebp),%eax
  80049b:	8d 50 01             	lea    0x1(%eax),%edx
  80049e:	89 55 10             	mov    %edx,0x10(%ebp)
  8004a1:	8a 00                	mov    (%eax),%al
  8004a3:	0f b6 d8             	movzbl %al,%ebx
  8004a6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004a9:	83 f8 55             	cmp    $0x55,%eax
  8004ac:	0f 87 2b 03 00 00    	ja     8007dd <vprintfmt+0x399>
  8004b2:	8b 04 85 b8 1c 80 00 	mov    0x801cb8(,%eax,4),%eax
  8004b9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004bb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004bf:	eb d7                	jmp    800498 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004c1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004c5:	eb d1                	jmp    800498 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d1:	89 d0                	mov    %edx,%eax
  8004d3:	c1 e0 02             	shl    $0x2,%eax
  8004d6:	01 d0                	add    %edx,%eax
  8004d8:	01 c0                	add    %eax,%eax
  8004da:	01 d8                	add    %ebx,%eax
  8004dc:	83 e8 30             	sub    $0x30,%eax
  8004df:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e5:	8a 00                	mov    (%eax),%al
  8004e7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004ea:	83 fb 2f             	cmp    $0x2f,%ebx
  8004ed:	7e 3e                	jle    80052d <vprintfmt+0xe9>
  8004ef:	83 fb 39             	cmp    $0x39,%ebx
  8004f2:	7f 39                	jg     80052d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004f4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004f7:	eb d5                	jmp    8004ce <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	83 c0 04             	add    $0x4,%eax
  8004ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800502:	8b 45 14             	mov    0x14(%ebp),%eax
  800505:	83 e8 04             	sub    $0x4,%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80050d:	eb 1f                	jmp    80052e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80050f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800513:	79 83                	jns    800498 <vprintfmt+0x54>
				width = 0;
  800515:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80051c:	e9 77 ff ff ff       	jmp    800498 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800521:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800528:	e9 6b ff ff ff       	jmp    800498 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80052d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80052e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800532:	0f 89 60 ff ff ff    	jns    800498 <vprintfmt+0x54>
				width = precision, precision = -1;
  800538:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80053e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800545:	e9 4e ff ff ff       	jmp    800498 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80054a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80054d:	e9 46 ff ff ff       	jmp    800498 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	83 c0 04             	add    $0x4,%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	83 e8 04             	sub    $0x4,%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	ff 75 0c             	pushl  0xc(%ebp)
  800569:	50                   	push   %eax
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	ff d0                	call   *%eax
  80056f:	83 c4 10             	add    $0x10,%esp
			break;
  800572:	e9 89 02 00 00       	jmp    800800 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	83 c0 04             	add    $0x4,%eax
  80057d:	89 45 14             	mov    %eax,0x14(%ebp)
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	83 e8 04             	sub    $0x4,%eax
  800586:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800588:	85 db                	test   %ebx,%ebx
  80058a:	79 02                	jns    80058e <vprintfmt+0x14a>
				err = -err;
  80058c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80058e:	83 fb 64             	cmp    $0x64,%ebx
  800591:	7f 0b                	jg     80059e <vprintfmt+0x15a>
  800593:	8b 34 9d 00 1b 80 00 	mov    0x801b00(,%ebx,4),%esi
  80059a:	85 f6                	test   %esi,%esi
  80059c:	75 19                	jne    8005b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80059e:	53                   	push   %ebx
  80059f:	68 a5 1c 80 00       	push   $0x801ca5
  8005a4:	ff 75 0c             	pushl  0xc(%ebp)
  8005a7:	ff 75 08             	pushl  0x8(%ebp)
  8005aa:	e8 5e 02 00 00       	call   80080d <printfmt>
  8005af:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005b2:	e9 49 02 00 00       	jmp    800800 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005b7:	56                   	push   %esi
  8005b8:	68 ae 1c 80 00       	push   $0x801cae
  8005bd:	ff 75 0c             	pushl  0xc(%ebp)
  8005c0:	ff 75 08             	pushl  0x8(%ebp)
  8005c3:	e8 45 02 00 00       	call   80080d <printfmt>
  8005c8:	83 c4 10             	add    $0x10,%esp
			break;
  8005cb:	e9 30 02 00 00       	jmp    800800 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	83 c0 04             	add    $0x4,%eax
  8005d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	83 e8 04             	sub    $0x4,%eax
  8005df:	8b 30                	mov    (%eax),%esi
  8005e1:	85 f6                	test   %esi,%esi
  8005e3:	75 05                	jne    8005ea <vprintfmt+0x1a6>
				p = "(null)";
  8005e5:	be b1 1c 80 00       	mov    $0x801cb1,%esi
			if (width > 0 && padc != '-')
  8005ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ee:	7e 6d                	jle    80065d <vprintfmt+0x219>
  8005f0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005f4:	74 67                	je     80065d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	50                   	push   %eax
  8005fd:	56                   	push   %esi
  8005fe:	e8 0c 03 00 00       	call   80090f <strnlen>
  800603:	83 c4 10             	add    $0x10,%esp
  800606:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800609:	eb 16                	jmp    800621 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80060b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80060f:	83 ec 08             	sub    $0x8,%esp
  800612:	ff 75 0c             	pushl  0xc(%ebp)
  800615:	50                   	push   %eax
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	ff d0                	call   *%eax
  80061b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80061e:	ff 4d e4             	decl   -0x1c(%ebp)
  800621:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800625:	7f e4                	jg     80060b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800627:	eb 34                	jmp    80065d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800629:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80062d:	74 1c                	je     80064b <vprintfmt+0x207>
  80062f:	83 fb 1f             	cmp    $0x1f,%ebx
  800632:	7e 05                	jle    800639 <vprintfmt+0x1f5>
  800634:	83 fb 7e             	cmp    $0x7e,%ebx
  800637:	7e 12                	jle    80064b <vprintfmt+0x207>
					putch('?', putdat);
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	ff 75 0c             	pushl  0xc(%ebp)
  80063f:	6a 3f                	push   $0x3f
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	ff d0                	call   *%eax
  800646:	83 c4 10             	add    $0x10,%esp
  800649:	eb 0f                	jmp    80065a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	53                   	push   %ebx
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	ff d0                	call   *%eax
  800657:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80065a:	ff 4d e4             	decl   -0x1c(%ebp)
  80065d:	89 f0                	mov    %esi,%eax
  80065f:	8d 70 01             	lea    0x1(%eax),%esi
  800662:	8a 00                	mov    (%eax),%al
  800664:	0f be d8             	movsbl %al,%ebx
  800667:	85 db                	test   %ebx,%ebx
  800669:	74 24                	je     80068f <vprintfmt+0x24b>
  80066b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80066f:	78 b8                	js     800629 <vprintfmt+0x1e5>
  800671:	ff 4d e0             	decl   -0x20(%ebp)
  800674:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800678:	79 af                	jns    800629 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80067a:	eb 13                	jmp    80068f <vprintfmt+0x24b>
				putch(' ', putdat);
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	ff 75 0c             	pushl  0xc(%ebp)
  800682:	6a 20                	push   $0x20
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	ff d0                	call   *%eax
  800689:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80068c:	ff 4d e4             	decl   -0x1c(%ebp)
  80068f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800693:	7f e7                	jg     80067c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800695:	e9 66 01 00 00       	jmp    800800 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	ff 75 e8             	pushl  -0x18(%ebp)
  8006a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a3:	50                   	push   %eax
  8006a4:	e8 3c fd ff ff       	call   8003e5 <getint>
  8006a9:	83 c4 10             	add    $0x10,%esp
  8006ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b8:	85 d2                	test   %edx,%edx
  8006ba:	79 23                	jns    8006df <vprintfmt+0x29b>
				putch('-', putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	ff 75 0c             	pushl  0xc(%ebp)
  8006c2:	6a 2d                	push   $0x2d
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	ff d0                	call   *%eax
  8006c9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d2:	f7 d8                	neg    %eax
  8006d4:	83 d2 00             	adc    $0x0,%edx
  8006d7:	f7 da                	neg    %edx
  8006d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006e6:	e9 bc 00 00 00       	jmp    8007a7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8006f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f4:	50                   	push   %eax
  8006f5:	e8 84 fc ff ff       	call   80037e <getuint>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800700:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800703:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80070a:	e9 98 00 00 00       	jmp    8007a7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	ff 75 0c             	pushl  0xc(%ebp)
  800715:	6a 58                	push   $0x58
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	ff d0                	call   *%eax
  80071c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	6a 58                	push   $0x58
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	6a 58                	push   $0x58
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
			break;
  80073f:	e9 bc 00 00 00       	jmp    800800 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	6a 30                	push   $0x30
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	ff d0                	call   *%eax
  800751:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	6a 78                	push   $0x78
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	ff d0                	call   *%eax
  800761:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	83 c0 04             	add    $0x4,%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	83 e8 04             	sub    $0x4,%eax
  800773:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800775:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800778:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80077f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800786:	eb 1f                	jmp    8007a7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	ff 75 e8             	pushl  -0x18(%ebp)
  80078e:	8d 45 14             	lea    0x14(%ebp),%eax
  800791:	50                   	push   %eax
  800792:	e8 e7 fb ff ff       	call   80037e <getuint>
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007a0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007a7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ae:	83 ec 04             	sub    $0x4,%esp
  8007b1:	52                   	push   %edx
  8007b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007b5:	50                   	push   %eax
  8007b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	ff 75 08             	pushl  0x8(%ebp)
  8007c2:	e8 00 fb ff ff       	call   8002c7 <printnum>
  8007c7:	83 c4 20             	add    $0x20,%esp
			break;
  8007ca:	eb 34                	jmp    800800 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	ff 75 0c             	pushl  0xc(%ebp)
  8007d2:	53                   	push   %ebx
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	ff d0                	call   *%eax
  8007d8:	83 c4 10             	add    $0x10,%esp
			break;
  8007db:	eb 23                	jmp    800800 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	ff 75 0c             	pushl  0xc(%ebp)
  8007e3:	6a 25                	push   $0x25
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	ff d0                	call   *%eax
  8007ea:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007ed:	ff 4d 10             	decl   0x10(%ebp)
  8007f0:	eb 03                	jmp    8007f5 <vprintfmt+0x3b1>
  8007f2:	ff 4d 10             	decl   0x10(%ebp)
  8007f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f8:	48                   	dec    %eax
  8007f9:	8a 00                	mov    (%eax),%al
  8007fb:	3c 25                	cmp    $0x25,%al
  8007fd:	75 f3                	jne    8007f2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8007ff:	90                   	nop
		}
	}
  800800:	e9 47 fc ff ff       	jmp    80044c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800805:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800806:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800809:	5b                   	pop    %ebx
  80080a:	5e                   	pop    %esi
  80080b:	5d                   	pop    %ebp
  80080c:	c3                   	ret    

0080080d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800813:	8d 45 10             	lea    0x10(%ebp),%eax
  800816:	83 c0 04             	add    $0x4,%eax
  800819:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80081c:	8b 45 10             	mov    0x10(%ebp),%eax
  80081f:	ff 75 f4             	pushl  -0xc(%ebp)
  800822:	50                   	push   %eax
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	ff 75 08             	pushl  0x8(%ebp)
  800829:	e8 16 fc ff ff       	call   800444 <vprintfmt>
  80082e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800831:	90                   	nop
  800832:	c9                   	leave  
  800833:	c3                   	ret    

00800834 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800837:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083a:	8b 40 08             	mov    0x8(%eax),%eax
  80083d:	8d 50 01             	lea    0x1(%eax),%edx
  800840:	8b 45 0c             	mov    0xc(%ebp),%eax
  800843:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800846:	8b 45 0c             	mov    0xc(%ebp),%eax
  800849:	8b 10                	mov    (%eax),%edx
  80084b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084e:	8b 40 04             	mov    0x4(%eax),%eax
  800851:	39 c2                	cmp    %eax,%edx
  800853:	73 12                	jae    800867 <sprintputch+0x33>
		*b->buf++ = ch;
  800855:	8b 45 0c             	mov    0xc(%ebp),%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	8d 48 01             	lea    0x1(%eax),%ecx
  80085d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800860:	89 0a                	mov    %ecx,(%edx)
  800862:	8b 55 08             	mov    0x8(%ebp),%edx
  800865:	88 10                	mov    %dl,(%eax)
}
  800867:	90                   	nop
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800876:	8b 45 0c             	mov    0xc(%ebp),%eax
  800879:	8d 50 ff             	lea    -0x1(%eax),%edx
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800884:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80088f:	74 06                	je     800897 <vsnprintf+0x2d>
  800891:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800895:	7f 07                	jg     80089e <vsnprintf+0x34>
		return -E_INVAL;
  800897:	b8 03 00 00 00       	mov    $0x3,%eax
  80089c:	eb 20                	jmp    8008be <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80089e:	ff 75 14             	pushl  0x14(%ebp)
  8008a1:	ff 75 10             	pushl  0x10(%ebp)
  8008a4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a7:	50                   	push   %eax
  8008a8:	68 34 08 80 00       	push   $0x800834
  8008ad:	e8 92 fb ff ff       	call   800444 <vprintfmt>
  8008b2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c6:	8d 45 10             	lea    0x10(%ebp),%eax
  8008c9:	83 c0 04             	add    $0x4,%eax
  8008cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d5:	50                   	push   %eax
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	ff 75 08             	pushl  0x8(%ebp)
  8008dc:	e8 89 ff ff ff       	call   80086a <vsnprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008ea:	c9                   	leave  
  8008eb:	c3                   	ret    

008008ec <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008f9:	eb 06                	jmp    800901 <strlen+0x15>
		n++;
  8008fb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008fe:	ff 45 08             	incl   0x8(%ebp)
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8a 00                	mov    (%eax),%al
  800906:	84 c0                	test   %al,%al
  800908:	75 f1                	jne    8008fb <strlen+0xf>
		n++;
	return n;
  80090a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80090d:	c9                   	leave  
  80090e:	c3                   	ret    

0080090f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800915:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80091c:	eb 09                	jmp    800927 <strnlen+0x18>
		n++;
  80091e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800921:	ff 45 08             	incl   0x8(%ebp)
  800924:	ff 4d 0c             	decl   0xc(%ebp)
  800927:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092b:	74 09                	je     800936 <strnlen+0x27>
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	8a 00                	mov    (%eax),%al
  800932:	84 c0                	test   %al,%al
  800934:	75 e8                	jne    80091e <strnlen+0xf>
		n++;
	return n;
  800936:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800939:	c9                   	leave  
  80093a:	c3                   	ret    

0080093b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800947:	90                   	nop
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8d 50 01             	lea    0x1(%eax),%edx
  80094e:	89 55 08             	mov    %edx,0x8(%ebp)
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
  800954:	8d 4a 01             	lea    0x1(%edx),%ecx
  800957:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80095a:	8a 12                	mov    (%edx),%dl
  80095c:	88 10                	mov    %dl,(%eax)
  80095e:	8a 00                	mov    (%eax),%al
  800960:	84 c0                	test   %al,%al
  800962:	75 e4                	jne    800948 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800964:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800967:	c9                   	leave  
  800968:	c3                   	ret    

00800969 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800975:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80097c:	eb 1f                	jmp    80099d <strncpy+0x34>
		*dst++ = *src;
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	8d 50 01             	lea    0x1(%eax),%edx
  800984:	89 55 08             	mov    %edx,0x8(%ebp)
  800987:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098a:	8a 12                	mov    (%edx),%dl
  80098c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80098e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800991:	8a 00                	mov    (%eax),%al
  800993:	84 c0                	test   %al,%al
  800995:	74 03                	je     80099a <strncpy+0x31>
			src++;
  800997:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80099a:	ff 45 fc             	incl   -0x4(%ebp)
  80099d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009a0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009a3:	72 d9                	jb     80097e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009a8:	c9                   	leave  
  8009a9:	c3                   	ret    

008009aa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009ba:	74 30                	je     8009ec <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009bc:	eb 16                	jmp    8009d4 <strlcpy+0x2a>
			*dst++ = *src++;
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8d 50 01             	lea    0x1(%eax),%edx
  8009c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8009c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009d0:	8a 12                	mov    (%edx),%dl
  8009d2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009d4:	ff 4d 10             	decl   0x10(%ebp)
  8009d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009db:	74 09                	je     8009e6 <strlcpy+0x3c>
  8009dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e0:	8a 00                	mov    (%eax),%al
  8009e2:	84 c0                	test   %al,%al
  8009e4:	75 d8                	jne    8009be <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8009ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009f2:	29 c2                	sub    %eax,%edx
  8009f4:	89 d0                	mov    %edx,%eax
}
  8009f6:	c9                   	leave  
  8009f7:	c3                   	ret    

008009f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8009fb:	eb 06                	jmp    800a03 <strcmp+0xb>
		p++, q++;
  8009fd:	ff 45 08             	incl   0x8(%ebp)
  800a00:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	8a 00                	mov    (%eax),%al
  800a08:	84 c0                	test   %al,%al
  800a0a:	74 0e                	je     800a1a <strcmp+0x22>
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	8a 10                	mov    (%eax),%dl
  800a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a14:	8a 00                	mov    (%eax),%al
  800a16:	38 c2                	cmp    %al,%dl
  800a18:	74 e3                	je     8009fd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	8a 00                	mov    (%eax),%al
  800a1f:	0f b6 d0             	movzbl %al,%edx
  800a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a25:	8a 00                	mov    (%eax),%al
  800a27:	0f b6 c0             	movzbl %al,%eax
  800a2a:	29 c2                	sub    %eax,%edx
  800a2c:	89 d0                	mov    %edx,%eax
}
  800a2e:	5d                   	pop    %ebp
  800a2f:	c3                   	ret    

00800a30 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a33:	eb 09                	jmp    800a3e <strncmp+0xe>
		n--, p++, q++;
  800a35:	ff 4d 10             	decl   0x10(%ebp)
  800a38:	ff 45 08             	incl   0x8(%ebp)
  800a3b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a42:	74 17                	je     800a5b <strncmp+0x2b>
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	8a 00                	mov    (%eax),%al
  800a49:	84 c0                	test   %al,%al
  800a4b:	74 0e                	je     800a5b <strncmp+0x2b>
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	8a 10                	mov    (%eax),%dl
  800a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a55:	8a 00                	mov    (%eax),%al
  800a57:	38 c2                	cmp    %al,%dl
  800a59:	74 da                	je     800a35 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a5f:	75 07                	jne    800a68 <strncmp+0x38>
		return 0;
  800a61:	b8 00 00 00 00       	mov    $0x0,%eax
  800a66:	eb 14                	jmp    800a7c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	8a 00                	mov    (%eax),%al
  800a6d:	0f b6 d0             	movzbl %al,%edx
  800a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a73:	8a 00                	mov    (%eax),%al
  800a75:	0f b6 c0             	movzbl %al,%eax
  800a78:	29 c2                	sub    %eax,%edx
  800a7a:	89 d0                	mov    %edx,%eax
}
  800a7c:	5d                   	pop    %ebp
  800a7d:	c3                   	ret    

00800a7e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	83 ec 04             	sub    $0x4,%esp
  800a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a87:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a8a:	eb 12                	jmp    800a9e <strchr+0x20>
		if (*s == c)
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a94:	75 05                	jne    800a9b <strchr+0x1d>
			return (char *) s;
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	eb 11                	jmp    800aac <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a9b:	ff 45 08             	incl   0x8(%ebp)
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8a 00                	mov    (%eax),%al
  800aa3:	84 c0                	test   %al,%al
  800aa5:	75 e5                	jne    800a8c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800aa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aac:	c9                   	leave  
  800aad:	c3                   	ret    

00800aae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aba:	eb 0d                	jmp    800ac9 <strfind+0x1b>
		if (*s == c)
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	8a 00                	mov    (%eax),%al
  800ac1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ac4:	74 0e                	je     800ad4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ac6:	ff 45 08             	incl   0x8(%ebp)
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8a 00                	mov    (%eax),%al
  800ace:	84 c0                	test   %al,%al
  800ad0:	75 ea                	jne    800abc <strfind+0xe>
  800ad2:	eb 01                	jmp    800ad5 <strfind+0x27>
		if (*s == c)
			break;
  800ad4:	90                   	nop
	return (char *) s;
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ad8:	c9                   	leave  
  800ad9:	c3                   	ret    

00800ada <memset>:

int i=0;
void *
memset(void *v, int c, uint32 n)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	83 ec 10             	sub    $0x10,%esp


	i++;
  800ae0:	a1 28 20 80 00       	mov    0x802028,%eax
  800ae5:	40                   	inc    %eax
  800ae6:	a3 28 20 80 00       	mov    %eax,0x802028

	char *p;
	int m;

	p = v;
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800af1:	8b 45 10             	mov    0x10(%ebp),%eax
  800af4:	89 45 f8             	mov    %eax,-0x8(%ebp)


	while (--m >= 0){
  800af7:	eb 0e                	jmp    800b07 <memset+0x2d>

		*p++ = c;
  800af9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800afc:	8d 50 01             	lea    0x1(%eax),%edx
  800aff:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	88 10                	mov    %dl,(%eax)

	p = v;
	m = n;


	while (--m >= 0){
  800b07:	ff 4d f8             	decl   -0x8(%ebp)
  800b0a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b0e:	79 e9                	jns    800af9 <memset+0x1f>

		*p++ = c;
	}

	return v;
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b13:	c9                   	leave  
  800b14:	c3                   	ret    

00800b15 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b27:	eb 16                	jmp    800b3f <memcpy+0x2a>
		*d++ = *s++;
  800b29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b2c:	8d 50 01             	lea    0x1(%eax),%edx
  800b2f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b35:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b38:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b3b:	8a 12                	mov    (%edx),%dl
  800b3d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b45:	89 55 10             	mov    %edx,0x10(%ebp)
  800b48:	85 c0                	test   %eax,%eax
  800b4a:	75 dd                	jne    800b29 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b66:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b69:	73 50                	jae    800bbb <memmove+0x6a>
  800b6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b71:	01 d0                	add    %edx,%eax
  800b73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b76:	76 43                	jbe    800bbb <memmove+0x6a>
		s += n;
  800b78:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b81:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b84:	eb 10                	jmp    800b96 <memmove+0x45>
			*--d = *--s;
  800b86:	ff 4d f8             	decl   -0x8(%ebp)
  800b89:	ff 4d fc             	decl   -0x4(%ebp)
  800b8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b8f:	8a 10                	mov    (%eax),%dl
  800b91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b94:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b96:	8b 45 10             	mov    0x10(%ebp),%eax
  800b99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b9c:	89 55 10             	mov    %edx,0x10(%ebp)
  800b9f:	85 c0                	test   %eax,%eax
  800ba1:	75 e3                	jne    800b86 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ba3:	eb 23                	jmp    800bc8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ba5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ba8:	8d 50 01             	lea    0x1(%eax),%edx
  800bab:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bb1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bb7:	8a 12                	mov    (%edx),%dl
  800bb9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc4:	85 c0                	test   %eax,%eax
  800bc6:	75 dd                	jne    800ba5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bcb:	c9                   	leave  
  800bcc:	c3                   	ret    

00800bcd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bdf:	eb 2a                	jmp    800c0b <memcmp+0x3e>
		if (*s1 != *s2)
  800be1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be4:	8a 10                	mov    (%eax),%dl
  800be6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be9:	8a 00                	mov    (%eax),%al
  800beb:	38 c2                	cmp    %al,%dl
  800bed:	74 16                	je     800c05 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf2:	8a 00                	mov    (%eax),%al
  800bf4:	0f b6 d0             	movzbl %al,%edx
  800bf7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bfa:	8a 00                	mov    (%eax),%al
  800bfc:	0f b6 c0             	movzbl %al,%eax
  800bff:	29 c2                	sub    %eax,%edx
  800c01:	89 d0                	mov    %edx,%eax
  800c03:	eb 18                	jmp    800c1d <memcmp+0x50>
		s1++, s2++;
  800c05:	ff 45 fc             	incl   -0x4(%ebp)
  800c08:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c11:	89 55 10             	mov    %edx,0x10(%ebp)
  800c14:	85 c0                	test   %eax,%eax
  800c16:	75 c9                	jne    800be1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c25:	8b 55 08             	mov    0x8(%ebp),%edx
  800c28:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2b:	01 d0                	add    %edx,%eax
  800c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c30:	eb 15                	jmp    800c47 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	8a 00                	mov    (%eax),%al
  800c37:	0f b6 d0             	movzbl %al,%edx
  800c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3d:	0f b6 c0             	movzbl %al,%eax
  800c40:	39 c2                	cmp    %eax,%edx
  800c42:	74 0d                	je     800c51 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c44:	ff 45 08             	incl   0x8(%ebp)
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c4d:	72 e3                	jb     800c32 <memfind+0x13>
  800c4f:	eb 01                	jmp    800c52 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c51:	90                   	nop
	return (void *) s;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c64:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6b:	eb 03                	jmp    800c70 <strtol+0x19>
		s++;
  800c6d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	8a 00                	mov    (%eax),%al
  800c75:	3c 20                	cmp    $0x20,%al
  800c77:	74 f4                	je     800c6d <strtol+0x16>
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	3c 09                	cmp    $0x9,%al
  800c80:	74 eb                	je     800c6d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	3c 2b                	cmp    $0x2b,%al
  800c89:	75 05                	jne    800c90 <strtol+0x39>
		s++;
  800c8b:	ff 45 08             	incl   0x8(%ebp)
  800c8e:	eb 13                	jmp    800ca3 <strtol+0x4c>
	else if (*s == '-')
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	3c 2d                	cmp    $0x2d,%al
  800c97:	75 0a                	jne    800ca3 <strtol+0x4c>
		s++, neg = 1;
  800c99:	ff 45 08             	incl   0x8(%ebp)
  800c9c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca7:	74 06                	je     800caf <strtol+0x58>
  800ca9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cad:	75 20                	jne    800ccf <strtol+0x78>
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8a 00                	mov    (%eax),%al
  800cb4:	3c 30                	cmp    $0x30,%al
  800cb6:	75 17                	jne    800ccf <strtol+0x78>
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	40                   	inc    %eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	3c 78                	cmp    $0x78,%al
  800cc0:	75 0d                	jne    800ccf <strtol+0x78>
		s += 2, base = 16;
  800cc2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cc6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ccd:	eb 28                	jmp    800cf7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ccf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd3:	75 15                	jne    800cea <strtol+0x93>
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	3c 30                	cmp    $0x30,%al
  800cdc:	75 0c                	jne    800cea <strtol+0x93>
		s++, base = 8;
  800cde:	ff 45 08             	incl   0x8(%ebp)
  800ce1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ce8:	eb 0d                	jmp    800cf7 <strtol+0xa0>
	else if (base == 0)
  800cea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cee:	75 07                	jne    800cf7 <strtol+0xa0>
		base = 10;
  800cf0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	3c 2f                	cmp    $0x2f,%al
  800cfe:	7e 19                	jle    800d19 <strtol+0xc2>
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	3c 39                	cmp    $0x39,%al
  800d07:	7f 10                	jg     800d19 <strtol+0xc2>
			dig = *s - '0';
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	0f be c0             	movsbl %al,%eax
  800d11:	83 e8 30             	sub    $0x30,%eax
  800d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d17:	eb 42                	jmp    800d5b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 00                	mov    (%eax),%al
  800d1e:	3c 60                	cmp    $0x60,%al
  800d20:	7e 19                	jle    800d3b <strtol+0xe4>
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	3c 7a                	cmp    $0x7a,%al
  800d29:	7f 10                	jg     800d3b <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f be c0             	movsbl %al,%eax
  800d33:	83 e8 57             	sub    $0x57,%eax
  800d36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d39:	eb 20                	jmp    800d5b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	3c 40                	cmp    $0x40,%al
  800d42:	7e 39                	jle    800d7d <strtol+0x126>
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	3c 5a                	cmp    $0x5a,%al
  800d4b:	7f 30                	jg     800d7d <strtol+0x126>
			dig = *s - 'A' + 10;
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f be c0             	movsbl %al,%eax
  800d55:	83 e8 37             	sub    $0x37,%eax
  800d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d61:	7d 19                	jge    800d7c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d63:	ff 45 08             	incl   0x8(%ebp)
  800d66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d69:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d6d:	89 c2                	mov    %eax,%edx
  800d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d72:	01 d0                	add    %edx,%eax
  800d74:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d77:	e9 7b ff ff ff       	jmp    800cf7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d7c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d81:	74 08                	je     800d8b <strtol+0x134>
		*endptr = (char *) s;
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d8f:	74 07                	je     800d98 <strtol+0x141>
  800d91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d94:	f7 d8                	neg    %eax
  800d96:	eb 03                	jmp    800d9b <strtol+0x144>
  800d98:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d9b:	c9                   	leave  
  800d9c:	c3                   	ret    

00800d9d <ltostr>:

void
ltostr(long value, char *str)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800da3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800daa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800db1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800db5:	79 13                	jns    800dca <ltostr+0x2d>
	{
		neg = 1;
  800db7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dc4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dc7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dd2:	99                   	cltd   
  800dd3:	f7 f9                	idiv   %ecx
  800dd5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddb:	8d 50 01             	lea    0x1(%eax),%edx
  800dde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de1:	89 c2                	mov    %eax,%edx
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	01 d0                	add    %edx,%eax
  800de8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800deb:	83 c2 30             	add    $0x30,%edx
  800dee:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800df0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800df8:	f7 e9                	imul   %ecx
  800dfa:	c1 fa 02             	sar    $0x2,%edx
  800dfd:	89 c8                	mov    %ecx,%eax
  800dff:	c1 f8 1f             	sar    $0x1f,%eax
  800e02:	29 c2                	sub    %eax,%edx
  800e04:	89 d0                	mov    %edx,%eax
  800e06:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e11:	f7 e9                	imul   %ecx
  800e13:	c1 fa 02             	sar    $0x2,%edx
  800e16:	89 c8                	mov    %ecx,%eax
  800e18:	c1 f8 1f             	sar    $0x1f,%eax
  800e1b:	29 c2                	sub    %eax,%edx
  800e1d:	89 d0                	mov    %edx,%eax
  800e1f:	c1 e0 02             	shl    $0x2,%eax
  800e22:	01 d0                	add    %edx,%eax
  800e24:	01 c0                	add    %eax,%eax
  800e26:	29 c1                	sub    %eax,%ecx
  800e28:	89 ca                	mov    %ecx,%edx
  800e2a:	85 d2                	test   %edx,%edx
  800e2c:	75 9c                	jne    800dca <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e38:	48                   	dec    %eax
  800e39:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e40:	74 3d                	je     800e7f <ltostr+0xe2>
		start = 1 ;
  800e42:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e49:	eb 34                	jmp    800e7f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	01 d0                	add    %edx,%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5e:	01 c2                	add    %eax,%edx
  800e60:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e66:	01 c8                	add    %ecx,%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	01 c2                	add    %eax,%edx
  800e74:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e77:	88 02                	mov    %al,(%edx)
		start++ ;
  800e79:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e7c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e82:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e85:	7c c4                	jl     800e4b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e87:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	01 d0                	add    %edx,%eax
  800e8f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e92:	90                   	nop
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e9b:	ff 75 08             	pushl  0x8(%ebp)
  800e9e:	e8 49 fa ff ff       	call   8008ec <strlen>
  800ea3:	83 c4 04             	add    $0x4,%esp
  800ea6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ea9:	ff 75 0c             	pushl  0xc(%ebp)
  800eac:	e8 3b fa ff ff       	call   8008ec <strlen>
  800eb1:	83 c4 04             	add    $0x4,%esp
  800eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800eb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ebe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec5:	eb 17                	jmp    800ede <strcconcat+0x49>
		final[s] = str1[s] ;
  800ec7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecd:	01 c2                	add    %eax,%edx
  800ecf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	01 c8                	add    %ecx,%eax
  800ed7:	8a 00                	mov    (%eax),%al
  800ed9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800edb:	ff 45 fc             	incl   -0x4(%ebp)
  800ede:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ee4:	7c e1                	jl     800ec7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ee6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800eed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ef4:	eb 1f                	jmp    800f15 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ef6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef9:	8d 50 01             	lea    0x1(%eax),%edx
  800efc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eff:	89 c2                	mov    %eax,%edx
  800f01:	8b 45 10             	mov    0x10(%ebp),%eax
  800f04:	01 c2                	add    %eax,%edx
  800f06:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	01 c8                	add    %ecx,%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f12:	ff 45 f8             	incl   -0x8(%ebp)
  800f15:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f18:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f1b:	7c d9                	jl     800ef6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	01 d0                	add    %edx,%eax
  800f25:	c6 00 00             	movb   $0x0,(%eax)
}
  800f28:	90                   	nop
  800f29:	c9                   	leave  
  800f2a:	c3                   	ret    

00800f2b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	8b 00                	mov    (%eax),%eax
  800f3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	01 d0                	add    %edx,%eax
  800f48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f4e:	eb 0c                	jmp    800f5c <strsplit+0x31>
			*string++ = 0;
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8d 50 01             	lea    0x1(%eax),%edx
  800f56:	89 55 08             	mov    %edx,0x8(%ebp)
  800f59:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	84 c0                	test   %al,%al
  800f63:	74 18                	je     800f7d <strsplit+0x52>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	0f be c0             	movsbl %al,%eax
  800f6d:	50                   	push   %eax
  800f6e:	ff 75 0c             	pushl  0xc(%ebp)
  800f71:	e8 08 fb ff ff       	call   800a7e <strchr>
  800f76:	83 c4 08             	add    $0x8,%esp
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	75 d3                	jne    800f50 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	84 c0                	test   %al,%al
  800f84:	74 5a                	je     800fe0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f86:	8b 45 14             	mov    0x14(%ebp),%eax
  800f89:	8b 00                	mov    (%eax),%eax
  800f8b:	83 f8 0f             	cmp    $0xf,%eax
  800f8e:	75 07                	jne    800f97 <strsplit+0x6c>
		{
			return 0;
  800f90:	b8 00 00 00 00       	mov    $0x0,%eax
  800f95:	eb 66                	jmp    800ffd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f97:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9a:	8b 00                	mov    (%eax),%eax
  800f9c:	8d 48 01             	lea    0x1(%eax),%ecx
  800f9f:	8b 55 14             	mov    0x14(%ebp),%edx
  800fa2:	89 0a                	mov    %ecx,(%edx)
  800fa4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	01 c2                	add    %eax,%edx
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fb5:	eb 03                	jmp    800fba <strsplit+0x8f>
			string++;
  800fb7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	74 8b                	je     800f4e <strsplit+0x23>
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	0f be c0             	movsbl %al,%eax
  800fcb:	50                   	push   %eax
  800fcc:	ff 75 0c             	pushl  0xc(%ebp)
  800fcf:	e8 aa fa ff ff       	call   800a7e <strchr>
  800fd4:	83 c4 08             	add    $0x8,%esp
  800fd7:	85 c0                	test   %eax,%eax
  800fd9:	74 dc                	je     800fb7 <strsplit+0x8c>
			string++;
	}
  800fdb:	e9 6e ff ff ff       	jmp    800f4e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fe0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fe1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe4:	8b 00                	mov    (%eax),%eax
  800fe6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff0:	01 d0                	add    %edx,%eax
  800ff2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800ff8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800ffd:	c9                   	leave  
  800ffe:	c3                   	ret    

00800fff <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  801005:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801009:	74 06                	je     801011 <str2lower+0x12>
  80100b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80100f:	75 07                	jne    801018 <str2lower+0x19>
		return NULL;
  801011:	b8 00 00 00 00       	mov    $0x0,%eax
  801016:	eb 4d                	jmp    801065 <str2lower+0x66>
	}
	char *ref=dst;
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  80101e:	eb 33                	jmp    801053 <str2lower+0x54>
			if(*src>=65&&*src<=90){
  801020:	8b 45 0c             	mov    0xc(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	3c 40                	cmp    $0x40,%al
  801027:	7e 1a                	jle    801043 <str2lower+0x44>
  801029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 5a                	cmp    $0x5a,%al
  801030:	7f 11                	jg     801043 <str2lower+0x44>
				*dst=*src+32;
  801032:	8b 45 0c             	mov    0xc(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	83 c0 20             	add    $0x20,%eax
  80103a:	88 c2                	mov    %al,%dl
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	88 10                	mov    %dl,(%eax)
  801041:	eb 0a                	jmp    80104d <str2lower+0x4e>
			}
			else{
				*dst=*src;
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	8a 10                	mov    (%eax),%dl
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	88 10                	mov    %dl,(%eax)
			}
			src++;
  80104d:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  801050:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	84 c0                	test   %al,%al
  80105a:	75 c4                	jne    801020 <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  801062:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	57                   	push   %edi
  80106b:	56                   	push   %esi
  80106c:	53                   	push   %ebx
  80106d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	8b 55 0c             	mov    0xc(%ebp),%edx
  801076:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801079:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80107c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80107f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801082:	cd 30                	int    $0x30
  801084:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801087:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80108a:	83 c4 10             	add    $0x10,%esp
  80108d:	5b                   	pop    %ebx
  80108e:	5e                   	pop    %esi
  80108f:	5f                   	pop    %edi
  801090:	5d                   	pop    %ebp
  801091:	c3                   	ret    

00801092 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	8b 45 10             	mov    0x10(%ebp),%eax
  80109b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80109e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	6a 00                	push   $0x0
  8010a7:	6a 00                	push   $0x0
  8010a9:	52                   	push   %edx
  8010aa:	ff 75 0c             	pushl  0xc(%ebp)
  8010ad:	50                   	push   %eax
  8010ae:	6a 00                	push   $0x0
  8010b0:	e8 b2 ff ff ff       	call   801067 <syscall>
  8010b5:	83 c4 18             	add    $0x18,%esp
}
  8010b8:	90                   	nop
  8010b9:	c9                   	leave  
  8010ba:	c3                   	ret    

008010bb <sys_cgetc>:

int
sys_cgetc(void)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010be:	6a 00                	push   $0x0
  8010c0:	6a 00                	push   $0x0
  8010c2:	6a 00                	push   $0x0
  8010c4:	6a 00                	push   $0x0
  8010c6:	6a 00                	push   $0x0
  8010c8:	6a 01                	push   $0x1
  8010ca:	e8 98 ff ff ff       	call   801067 <syscall>
  8010cf:	83 c4 18             	add    $0x18,%esp
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	6a 00                	push   $0x0
  8010df:	6a 00                	push   $0x0
  8010e1:	6a 00                	push   $0x0
  8010e3:	52                   	push   %edx
  8010e4:	50                   	push   %eax
  8010e5:	6a 05                	push   $0x5
  8010e7:	e8 7b ff ff ff       	call   801067 <syscall>
  8010ec:	83 c4 18             	add    $0x18,%esp
}
  8010ef:	c9                   	leave  
  8010f0:	c3                   	ret    

008010f1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	56                   	push   %esi
  8010f5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010f6:	8b 75 18             	mov    0x18(%ebp),%esi
  8010f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	56                   	push   %esi
  801106:	53                   	push   %ebx
  801107:	51                   	push   %ecx
  801108:	52                   	push   %edx
  801109:	50                   	push   %eax
  80110a:	6a 06                	push   $0x6
  80110c:	e8 56 ff ff ff       	call   801067 <syscall>
  801111:	83 c4 18             	add    $0x18,%esp
}
  801114:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801117:	5b                   	pop    %ebx
  801118:	5e                   	pop    %esi
  801119:	5d                   	pop    %ebp
  80111a:	c3                   	ret    

0080111b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80111e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	6a 00                	push   $0x0
  801126:	6a 00                	push   $0x0
  801128:	6a 00                	push   $0x0
  80112a:	52                   	push   %edx
  80112b:	50                   	push   %eax
  80112c:	6a 07                	push   $0x7
  80112e:	e8 34 ff ff ff       	call   801067 <syscall>
  801133:	83 c4 18             	add    $0x18,%esp
}
  801136:	c9                   	leave  
  801137:	c3                   	ret    

00801138 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80113b:	6a 00                	push   $0x0
  80113d:	6a 00                	push   $0x0
  80113f:	6a 00                	push   $0x0
  801141:	ff 75 0c             	pushl  0xc(%ebp)
  801144:	ff 75 08             	pushl  0x8(%ebp)
  801147:	6a 08                	push   $0x8
  801149:	e8 19 ff ff ff       	call   801067 <syscall>
  80114e:	83 c4 18             	add    $0x18,%esp
}
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801156:	6a 00                	push   $0x0
  801158:	6a 00                	push   $0x0
  80115a:	6a 00                	push   $0x0
  80115c:	6a 00                	push   $0x0
  80115e:	6a 00                	push   $0x0
  801160:	6a 09                	push   $0x9
  801162:	e8 00 ff ff ff       	call   801067 <syscall>
  801167:	83 c4 18             	add    $0x18,%esp
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80116f:	6a 00                	push   $0x0
  801171:	6a 00                	push   $0x0
  801173:	6a 00                	push   $0x0
  801175:	6a 00                	push   $0x0
  801177:	6a 00                	push   $0x0
  801179:	6a 0a                	push   $0xa
  80117b:	e8 e7 fe ff ff       	call   801067 <syscall>
  801180:	83 c4 18             	add    $0x18,%esp
}
  801183:	c9                   	leave  
  801184:	c3                   	ret    

00801185 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801188:	6a 00                	push   $0x0
  80118a:	6a 00                	push   $0x0
  80118c:	6a 00                	push   $0x0
  80118e:	6a 00                	push   $0x0
  801190:	6a 00                	push   $0x0
  801192:	6a 0b                	push   $0xb
  801194:	e8 ce fe ff ff       	call   801067 <syscall>
  801199:	83 c4 18             	add    $0x18,%esp
}
  80119c:	c9                   	leave  
  80119d:	c3                   	ret    

0080119e <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011a1:	6a 00                	push   $0x0
  8011a3:	6a 00                	push   $0x0
  8011a5:	6a 00                	push   $0x0
  8011a7:	6a 00                	push   $0x0
  8011a9:	6a 00                	push   $0x0
  8011ab:	6a 0c                	push   $0xc
  8011ad:	e8 b5 fe ff ff       	call   801067 <syscall>
  8011b2:	83 c4 18             	add    $0x18,%esp
}
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011ba:	6a 00                	push   $0x0
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 00                	push   $0x0
  8011c0:	6a 00                	push   $0x0
  8011c2:	ff 75 08             	pushl  0x8(%ebp)
  8011c5:	6a 0d                	push   $0xd
  8011c7:	e8 9b fe ff ff       	call   801067 <syscall>
  8011cc:	83 c4 18             	add    $0x18,%esp
}
  8011cf:	c9                   	leave  
  8011d0:	c3                   	ret    

008011d1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011d4:	6a 00                	push   $0x0
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 00                	push   $0x0
  8011da:	6a 00                	push   $0x0
  8011dc:	6a 00                	push   $0x0
  8011de:	6a 0e                	push   $0xe
  8011e0:	e8 82 fe ff ff       	call   801067 <syscall>
  8011e5:	83 c4 18             	add    $0x18,%esp
}
  8011e8:	90                   	nop
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    

008011eb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8011ee:	6a 00                	push   $0x0
  8011f0:	6a 00                	push   $0x0
  8011f2:	6a 00                	push   $0x0
  8011f4:	6a 00                	push   $0x0
  8011f6:	6a 00                	push   $0x0
  8011f8:	6a 11                	push   $0x11
  8011fa:	e8 68 fe ff ff       	call   801067 <syscall>
  8011ff:	83 c4 18             	add    $0x18,%esp
}
  801202:	90                   	nop
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801208:	6a 00                	push   $0x0
  80120a:	6a 00                	push   $0x0
  80120c:	6a 00                	push   $0x0
  80120e:	6a 00                	push   $0x0
  801210:	6a 00                	push   $0x0
  801212:	6a 12                	push   $0x12
  801214:	e8 4e fe ff ff       	call   801067 <syscall>
  801219:	83 c4 18             	add    $0x18,%esp
}
  80121c:	90                   	nop
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    

0080121f <sys_cputc>:


void
sys_cputc(const char c)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	83 ec 04             	sub    $0x4,%esp
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80122b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80122f:	6a 00                	push   $0x0
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	50                   	push   %eax
  801238:	6a 13                	push   $0x13
  80123a:	e8 28 fe ff ff       	call   801067 <syscall>
  80123f:	83 c4 18             	add    $0x18,%esp
}
  801242:	90                   	nop
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801248:	6a 00                	push   $0x0
  80124a:	6a 00                	push   $0x0
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	6a 14                	push   $0x14
  801254:	e8 0e fe ff ff       	call   801067 <syscall>
  801259:	83 c4 18             	add    $0x18,%esp
}
  80125c:	90                   	nop
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	ff 75 0c             	pushl  0xc(%ebp)
  80126e:	50                   	push   %eax
  80126f:	6a 15                	push   $0x15
  801271:	e8 f1 fd ff ff       	call   801067 <syscall>
  801276:	83 c4 18             	add    $0x18,%esp
}
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80127e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	6a 00                	push   $0x0
  80128a:	52                   	push   %edx
  80128b:	50                   	push   %eax
  80128c:	6a 18                	push   $0x18
  80128e:	e8 d4 fd ff ff       	call   801067 <syscall>
  801293:	83 c4 18             	add    $0x18,%esp
}
  801296:	c9                   	leave  
  801297:	c3                   	ret    

00801298 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80129b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	6a 00                	push   $0x0
  8012a3:	6a 00                	push   $0x0
  8012a5:	6a 00                	push   $0x0
  8012a7:	52                   	push   %edx
  8012a8:	50                   	push   %eax
  8012a9:	6a 16                	push   $0x16
  8012ab:	e8 b7 fd ff ff       	call   801067 <syscall>
  8012b0:	83 c4 18             	add    $0x18,%esp
}
  8012b3:	90                   	nop
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    

008012b6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	52                   	push   %edx
  8012c6:	50                   	push   %eax
  8012c7:	6a 17                	push   $0x17
  8012c9:	e8 99 fd ff ff       	call   801067 <syscall>
  8012ce:	83 c4 18             	add    $0x18,%esp
}
  8012d1:	90                   	nop
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	83 ec 04             	sub    $0x4,%esp
  8012da:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012e0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012e3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	6a 00                	push   $0x0
  8012ec:	51                   	push   %ecx
  8012ed:	52                   	push   %edx
  8012ee:	ff 75 0c             	pushl  0xc(%ebp)
  8012f1:	50                   	push   %eax
  8012f2:	6a 19                	push   $0x19
  8012f4:	e8 6e fd ff ff       	call   801067 <syscall>
  8012f9:	83 c4 18             	add    $0x18,%esp
}
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801301:	8b 55 0c             	mov    0xc(%ebp),%edx
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	52                   	push   %edx
  80130e:	50                   	push   %eax
  80130f:	6a 1a                	push   $0x1a
  801311:	e8 51 fd ff ff       	call   801067 <syscall>
  801316:	83 c4 18             	add    $0x18,%esp
}
  801319:	c9                   	leave  
  80131a:	c3                   	ret    

0080131b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80131e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801321:	8b 55 0c             	mov    0xc(%ebp),%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	51                   	push   %ecx
  80132c:	52                   	push   %edx
  80132d:	50                   	push   %eax
  80132e:	6a 1b                	push   $0x1b
  801330:	e8 32 fd ff ff       	call   801067 <syscall>
  801335:	83 c4 18             	add    $0x18,%esp
}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80133d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	52                   	push   %edx
  80134a:	50                   	push   %eax
  80134b:	6a 1c                	push   $0x1c
  80134d:	e8 15 fd ff ff       	call   801067 <syscall>
  801352:	83 c4 18             	add    $0x18,%esp
}
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 1d                	push   $0x1d
  801366:	e8 fc fc ff ff       	call   801067 <syscall>
  80136b:	83 c4 18             	add    $0x18,%esp
}
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	6a 00                	push   $0x0
  801378:	ff 75 14             	pushl  0x14(%ebp)
  80137b:	ff 75 10             	pushl  0x10(%ebp)
  80137e:	ff 75 0c             	pushl  0xc(%ebp)
  801381:	50                   	push   %eax
  801382:	6a 1e                	push   $0x1e
  801384:	e8 de fc ff ff       	call   801067 <syscall>
  801389:	83 c4 18             	add    $0x18,%esp
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	50                   	push   %eax
  80139d:	6a 1f                	push   $0x1f
  80139f:	e8 c3 fc ff ff       	call   801067 <syscall>
  8013a4:	83 c4 18             	add    $0x18,%esp
}
  8013a7:	90                   	nop
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 00                	push   $0x0
  8013b8:	50                   	push   %eax
  8013b9:	6a 20                	push   $0x20
  8013bb:	e8 a7 fc ff ff       	call   801067 <syscall>
  8013c0:	83 c4 18             	add    $0x18,%esp
}
  8013c3:	c9                   	leave  
  8013c4:	c3                   	ret    

008013c5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 02                	push   $0x2
  8013d4:	e8 8e fc ff ff       	call   801067 <syscall>
  8013d9:	83 c4 18             	add    $0x18,%esp
}
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 03                	push   $0x3
  8013ed:	e8 75 fc ff ff       	call   801067 <syscall>
  8013f2:	83 c4 18             	add    $0x18,%esp
}
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 04                	push   $0x4
  801406:	e8 5c fc ff ff       	call   801067 <syscall>
  80140b:	83 c4 18             	add    $0x18,%esp
}
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <sys_exit_env>:


void sys_exit_env(void)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 21                	push   $0x21
  80141f:	e8 43 fc ff ff       	call   801067 <syscall>
  801424:	83 c4 18             	add    $0x18,%esp
}
  801427:	90                   	nop
  801428:	c9                   	leave  
  801429:	c3                   	ret    

0080142a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801430:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801433:	8d 50 04             	lea    0x4(%eax),%edx
  801436:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	52                   	push   %edx
  801440:	50                   	push   %eax
  801441:	6a 22                	push   $0x22
  801443:	e8 1f fc ff ff       	call   801067 <syscall>
  801448:	83 c4 18             	add    $0x18,%esp
	return result;
  80144b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80144e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801451:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801454:	89 01                	mov    %eax,(%ecx)
  801456:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	c9                   	leave  
  80145d:	c2 04 00             	ret    $0x4

00801460 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	ff 75 10             	pushl  0x10(%ebp)
  80146a:	ff 75 0c             	pushl  0xc(%ebp)
  80146d:	ff 75 08             	pushl  0x8(%ebp)
  801470:	6a 10                	push   $0x10
  801472:	e8 f0 fb ff ff       	call   801067 <syscall>
  801477:	83 c4 18             	add    $0x18,%esp
	return ;
  80147a:	90                   	nop
}
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <sys_rcr2>:
uint32 sys_rcr2()
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 23                	push   $0x23
  80148c:	e8 d6 fb ff ff       	call   801067 <syscall>
  801491:	83 c4 18             	add    $0x18,%esp
}
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	83 ec 04             	sub    $0x4,%esp
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014a2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	50                   	push   %eax
  8014af:	6a 24                	push   $0x24
  8014b1:	e8 b1 fb ff ff       	call   801067 <syscall>
  8014b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8014b9:	90                   	nop
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <rsttst>:
void rsttst()
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 26                	push   $0x26
  8014cb:	e8 97 fb ff ff       	call   801067 <syscall>
  8014d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8014d3:	90                   	nop
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	83 ec 04             	sub    $0x4,%esp
  8014dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014e2:	8b 55 18             	mov    0x18(%ebp),%edx
  8014e5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014e9:	52                   	push   %edx
  8014ea:	50                   	push   %eax
  8014eb:	ff 75 10             	pushl  0x10(%ebp)
  8014ee:	ff 75 0c             	pushl  0xc(%ebp)
  8014f1:	ff 75 08             	pushl  0x8(%ebp)
  8014f4:	6a 25                	push   $0x25
  8014f6:	e8 6c fb ff ff       	call   801067 <syscall>
  8014fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8014fe:	90                   	nop
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <chktst>:
void chktst(uint32 n)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	ff 75 08             	pushl  0x8(%ebp)
  80150f:	6a 27                	push   $0x27
  801511:	e8 51 fb ff ff       	call   801067 <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
	return ;
  801519:	90                   	nop
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <inctst>:

void inctst()
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 28                	push   $0x28
  80152b:	e8 37 fb ff ff       	call   801067 <syscall>
  801530:	83 c4 18             	add    $0x18,%esp
	return ;
  801533:	90                   	nop
}
  801534:	c9                   	leave  
  801535:	c3                   	ret    

00801536 <gettst>:
uint32 gettst()
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 29                	push   $0x29
  801545:	e8 1d fb ff ff       	call   801067 <syscall>
  80154a:	83 c4 18             	add    $0x18,%esp
}
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 2a                	push   $0x2a
  801561:	e8 01 fb ff ff       	call   801067 <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
  801569:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80156c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801570:	75 07                	jne    801579 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801572:	b8 01 00 00 00       	mov    $0x1,%eax
  801577:	eb 05                	jmp    80157e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801579:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 2a                	push   $0x2a
  801592:	e8 d0 fa ff ff       	call   801067 <syscall>
  801597:	83 c4 18             	add    $0x18,%esp
  80159a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80159d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015a1:	75 07                	jne    8015aa <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a8:	eb 05                	jmp    8015af <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 2a                	push   $0x2a
  8015c3:	e8 9f fa ff ff       	call   801067 <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
  8015cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015ce:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015d2:	75 07                	jne    8015db <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d9:	eb 05                	jmp    8015e0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 2a                	push   $0x2a
  8015f4:	e8 6e fa ff ff       	call   801067 <syscall>
  8015f9:	83 c4 18             	add    $0x18,%esp
  8015fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015ff:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801603:	75 07                	jne    80160c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801605:	b8 01 00 00 00       	mov    $0x1,%eax
  80160a:	eb 05                	jmp    801611 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80160c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	ff 75 08             	pushl  0x8(%ebp)
  801621:	6a 2b                	push   $0x2b
  801623:	e8 3f fa ff ff       	call   801067 <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
	return ;
  80162b:	90                   	nop
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801632:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801635:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801638:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	6a 00                	push   $0x0
  801640:	53                   	push   %ebx
  801641:	51                   	push   %ecx
  801642:	52                   	push   %edx
  801643:	50                   	push   %eax
  801644:	6a 2c                	push   $0x2c
  801646:	e8 1c fa ff ff       	call   801067 <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
}
  80164e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801656:	8b 55 0c             	mov    0xc(%ebp),%edx
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	52                   	push   %edx
  801663:	50                   	push   %eax
  801664:	6a 2d                	push   $0x2d
  801666:	e8 fc f9 ff ff       	call   801067 <syscall>
  80166b:	83 c4 18             	add    $0x18,%esp
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801673:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801676:	8b 55 0c             	mov    0xc(%ebp),%edx
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	6a 00                	push   $0x0
  80167e:	51                   	push   %ecx
  80167f:	ff 75 10             	pushl  0x10(%ebp)
  801682:	52                   	push   %edx
  801683:	50                   	push   %eax
  801684:	6a 2e                	push   $0x2e
  801686:	e8 dc f9 ff ff       	call   801067 <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	ff 75 10             	pushl  0x10(%ebp)
  80169a:	ff 75 0c             	pushl  0xc(%ebp)
  80169d:	ff 75 08             	pushl  0x8(%ebp)
  8016a0:	6a 0f                	push   $0xf
  8016a2:	e8 c0 f9 ff ff       	call   801067 <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8016aa:	90                   	nop
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	50                   	push   %eax
  8016bc:	6a 2f                	push   $0x2f
  8016be:	e8 a4 f9 ff ff       	call   801067 <syscall>
  8016c3:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	ff 75 0c             	pushl  0xc(%ebp)
  8016d4:	ff 75 08             	pushl  0x8(%ebp)
  8016d7:	6a 30                	push   $0x30
  8016d9:	e8 89 f9 ff ff       	call   801067 <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  8016e1:	90                   	nop
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	ff 75 08             	pushl  0x8(%ebp)
  8016f3:	6a 31                	push   $0x31
  8016f5:	e8 6d f9 ff ff       	call   801067 <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  8016fd:	90                   	nop
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <__udivdi3>:
  801700:	55                   	push   %ebp
  801701:	57                   	push   %edi
  801702:	56                   	push   %esi
  801703:	53                   	push   %ebx
  801704:	83 ec 1c             	sub    $0x1c,%esp
  801707:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80170b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80170f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801713:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801717:	89 ca                	mov    %ecx,%edx
  801719:	89 f8                	mov    %edi,%eax
  80171b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80171f:	85 f6                	test   %esi,%esi
  801721:	75 2d                	jne    801750 <__udivdi3+0x50>
  801723:	39 cf                	cmp    %ecx,%edi
  801725:	77 65                	ja     80178c <__udivdi3+0x8c>
  801727:	89 fd                	mov    %edi,%ebp
  801729:	85 ff                	test   %edi,%edi
  80172b:	75 0b                	jne    801738 <__udivdi3+0x38>
  80172d:	b8 01 00 00 00       	mov    $0x1,%eax
  801732:	31 d2                	xor    %edx,%edx
  801734:	f7 f7                	div    %edi
  801736:	89 c5                	mov    %eax,%ebp
  801738:	31 d2                	xor    %edx,%edx
  80173a:	89 c8                	mov    %ecx,%eax
  80173c:	f7 f5                	div    %ebp
  80173e:	89 c1                	mov    %eax,%ecx
  801740:	89 d8                	mov    %ebx,%eax
  801742:	f7 f5                	div    %ebp
  801744:	89 cf                	mov    %ecx,%edi
  801746:	89 fa                	mov    %edi,%edx
  801748:	83 c4 1c             	add    $0x1c,%esp
  80174b:	5b                   	pop    %ebx
  80174c:	5e                   	pop    %esi
  80174d:	5f                   	pop    %edi
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    
  801750:	39 ce                	cmp    %ecx,%esi
  801752:	77 28                	ja     80177c <__udivdi3+0x7c>
  801754:	0f bd fe             	bsr    %esi,%edi
  801757:	83 f7 1f             	xor    $0x1f,%edi
  80175a:	75 40                	jne    80179c <__udivdi3+0x9c>
  80175c:	39 ce                	cmp    %ecx,%esi
  80175e:	72 0a                	jb     80176a <__udivdi3+0x6a>
  801760:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801764:	0f 87 9e 00 00 00    	ja     801808 <__udivdi3+0x108>
  80176a:	b8 01 00 00 00       	mov    $0x1,%eax
  80176f:	89 fa                	mov    %edi,%edx
  801771:	83 c4 1c             	add    $0x1c,%esp
  801774:	5b                   	pop    %ebx
  801775:	5e                   	pop    %esi
  801776:	5f                   	pop    %edi
  801777:	5d                   	pop    %ebp
  801778:	c3                   	ret    
  801779:	8d 76 00             	lea    0x0(%esi),%esi
  80177c:	31 ff                	xor    %edi,%edi
  80177e:	31 c0                	xor    %eax,%eax
  801780:	89 fa                	mov    %edi,%edx
  801782:	83 c4 1c             	add    $0x1c,%esp
  801785:	5b                   	pop    %ebx
  801786:	5e                   	pop    %esi
  801787:	5f                   	pop    %edi
  801788:	5d                   	pop    %ebp
  801789:	c3                   	ret    
  80178a:	66 90                	xchg   %ax,%ax
  80178c:	89 d8                	mov    %ebx,%eax
  80178e:	f7 f7                	div    %edi
  801790:	31 ff                	xor    %edi,%edi
  801792:	89 fa                	mov    %edi,%edx
  801794:	83 c4 1c             	add    $0x1c,%esp
  801797:	5b                   	pop    %ebx
  801798:	5e                   	pop    %esi
  801799:	5f                   	pop    %edi
  80179a:	5d                   	pop    %ebp
  80179b:	c3                   	ret    
  80179c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8017a1:	89 eb                	mov    %ebp,%ebx
  8017a3:	29 fb                	sub    %edi,%ebx
  8017a5:	89 f9                	mov    %edi,%ecx
  8017a7:	d3 e6                	shl    %cl,%esi
  8017a9:	89 c5                	mov    %eax,%ebp
  8017ab:	88 d9                	mov    %bl,%cl
  8017ad:	d3 ed                	shr    %cl,%ebp
  8017af:	89 e9                	mov    %ebp,%ecx
  8017b1:	09 f1                	or     %esi,%ecx
  8017b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8017b7:	89 f9                	mov    %edi,%ecx
  8017b9:	d3 e0                	shl    %cl,%eax
  8017bb:	89 c5                	mov    %eax,%ebp
  8017bd:	89 d6                	mov    %edx,%esi
  8017bf:	88 d9                	mov    %bl,%cl
  8017c1:	d3 ee                	shr    %cl,%esi
  8017c3:	89 f9                	mov    %edi,%ecx
  8017c5:	d3 e2                	shl    %cl,%edx
  8017c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017cb:	88 d9                	mov    %bl,%cl
  8017cd:	d3 e8                	shr    %cl,%eax
  8017cf:	09 c2                	or     %eax,%edx
  8017d1:	89 d0                	mov    %edx,%eax
  8017d3:	89 f2                	mov    %esi,%edx
  8017d5:	f7 74 24 0c          	divl   0xc(%esp)
  8017d9:	89 d6                	mov    %edx,%esi
  8017db:	89 c3                	mov    %eax,%ebx
  8017dd:	f7 e5                	mul    %ebp
  8017df:	39 d6                	cmp    %edx,%esi
  8017e1:	72 19                	jb     8017fc <__udivdi3+0xfc>
  8017e3:	74 0b                	je     8017f0 <__udivdi3+0xf0>
  8017e5:	89 d8                	mov    %ebx,%eax
  8017e7:	31 ff                	xor    %edi,%edi
  8017e9:	e9 58 ff ff ff       	jmp    801746 <__udivdi3+0x46>
  8017ee:	66 90                	xchg   %ax,%ax
  8017f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8017f4:	89 f9                	mov    %edi,%ecx
  8017f6:	d3 e2                	shl    %cl,%edx
  8017f8:	39 c2                	cmp    %eax,%edx
  8017fa:	73 e9                	jae    8017e5 <__udivdi3+0xe5>
  8017fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8017ff:	31 ff                	xor    %edi,%edi
  801801:	e9 40 ff ff ff       	jmp    801746 <__udivdi3+0x46>
  801806:	66 90                	xchg   %ax,%ax
  801808:	31 c0                	xor    %eax,%eax
  80180a:	e9 37 ff ff ff       	jmp    801746 <__udivdi3+0x46>
  80180f:	90                   	nop

00801810 <__umoddi3>:
  801810:	55                   	push   %ebp
  801811:	57                   	push   %edi
  801812:	56                   	push   %esi
  801813:	53                   	push   %ebx
  801814:	83 ec 1c             	sub    $0x1c,%esp
  801817:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80181b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80181f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801823:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801827:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80182b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80182f:	89 f3                	mov    %esi,%ebx
  801831:	89 fa                	mov    %edi,%edx
  801833:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801837:	89 34 24             	mov    %esi,(%esp)
  80183a:	85 c0                	test   %eax,%eax
  80183c:	75 1a                	jne    801858 <__umoddi3+0x48>
  80183e:	39 f7                	cmp    %esi,%edi
  801840:	0f 86 a2 00 00 00    	jbe    8018e8 <__umoddi3+0xd8>
  801846:	89 c8                	mov    %ecx,%eax
  801848:	89 f2                	mov    %esi,%edx
  80184a:	f7 f7                	div    %edi
  80184c:	89 d0                	mov    %edx,%eax
  80184e:	31 d2                	xor    %edx,%edx
  801850:	83 c4 1c             	add    $0x1c,%esp
  801853:	5b                   	pop    %ebx
  801854:	5e                   	pop    %esi
  801855:	5f                   	pop    %edi
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    
  801858:	39 f0                	cmp    %esi,%eax
  80185a:	0f 87 ac 00 00 00    	ja     80190c <__umoddi3+0xfc>
  801860:	0f bd e8             	bsr    %eax,%ebp
  801863:	83 f5 1f             	xor    $0x1f,%ebp
  801866:	0f 84 ac 00 00 00    	je     801918 <__umoddi3+0x108>
  80186c:	bf 20 00 00 00       	mov    $0x20,%edi
  801871:	29 ef                	sub    %ebp,%edi
  801873:	89 fe                	mov    %edi,%esi
  801875:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801879:	89 e9                	mov    %ebp,%ecx
  80187b:	d3 e0                	shl    %cl,%eax
  80187d:	89 d7                	mov    %edx,%edi
  80187f:	89 f1                	mov    %esi,%ecx
  801881:	d3 ef                	shr    %cl,%edi
  801883:	09 c7                	or     %eax,%edi
  801885:	89 e9                	mov    %ebp,%ecx
  801887:	d3 e2                	shl    %cl,%edx
  801889:	89 14 24             	mov    %edx,(%esp)
  80188c:	89 d8                	mov    %ebx,%eax
  80188e:	d3 e0                	shl    %cl,%eax
  801890:	89 c2                	mov    %eax,%edx
  801892:	8b 44 24 08          	mov    0x8(%esp),%eax
  801896:	d3 e0                	shl    %cl,%eax
  801898:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018a0:	89 f1                	mov    %esi,%ecx
  8018a2:	d3 e8                	shr    %cl,%eax
  8018a4:	09 d0                	or     %edx,%eax
  8018a6:	d3 eb                	shr    %cl,%ebx
  8018a8:	89 da                	mov    %ebx,%edx
  8018aa:	f7 f7                	div    %edi
  8018ac:	89 d3                	mov    %edx,%ebx
  8018ae:	f7 24 24             	mull   (%esp)
  8018b1:	89 c6                	mov    %eax,%esi
  8018b3:	89 d1                	mov    %edx,%ecx
  8018b5:	39 d3                	cmp    %edx,%ebx
  8018b7:	0f 82 87 00 00 00    	jb     801944 <__umoddi3+0x134>
  8018bd:	0f 84 91 00 00 00    	je     801954 <__umoddi3+0x144>
  8018c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8018c7:	29 f2                	sub    %esi,%edx
  8018c9:	19 cb                	sbb    %ecx,%ebx
  8018cb:	89 d8                	mov    %ebx,%eax
  8018cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8018d1:	d3 e0                	shl    %cl,%eax
  8018d3:	89 e9                	mov    %ebp,%ecx
  8018d5:	d3 ea                	shr    %cl,%edx
  8018d7:	09 d0                	or     %edx,%eax
  8018d9:	89 e9                	mov    %ebp,%ecx
  8018db:	d3 eb                	shr    %cl,%ebx
  8018dd:	89 da                	mov    %ebx,%edx
  8018df:	83 c4 1c             	add    $0x1c,%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5f                   	pop    %edi
  8018e5:	5d                   	pop    %ebp
  8018e6:	c3                   	ret    
  8018e7:	90                   	nop
  8018e8:	89 fd                	mov    %edi,%ebp
  8018ea:	85 ff                	test   %edi,%edi
  8018ec:	75 0b                	jne    8018f9 <__umoddi3+0xe9>
  8018ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f3:	31 d2                	xor    %edx,%edx
  8018f5:	f7 f7                	div    %edi
  8018f7:	89 c5                	mov    %eax,%ebp
  8018f9:	89 f0                	mov    %esi,%eax
  8018fb:	31 d2                	xor    %edx,%edx
  8018fd:	f7 f5                	div    %ebp
  8018ff:	89 c8                	mov    %ecx,%eax
  801901:	f7 f5                	div    %ebp
  801903:	89 d0                	mov    %edx,%eax
  801905:	e9 44 ff ff ff       	jmp    80184e <__umoddi3+0x3e>
  80190a:	66 90                	xchg   %ax,%ax
  80190c:	89 c8                	mov    %ecx,%eax
  80190e:	89 f2                	mov    %esi,%edx
  801910:	83 c4 1c             	add    $0x1c,%esp
  801913:	5b                   	pop    %ebx
  801914:	5e                   	pop    %esi
  801915:	5f                   	pop    %edi
  801916:	5d                   	pop    %ebp
  801917:	c3                   	ret    
  801918:	3b 04 24             	cmp    (%esp),%eax
  80191b:	72 06                	jb     801923 <__umoddi3+0x113>
  80191d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801921:	77 0f                	ja     801932 <__umoddi3+0x122>
  801923:	89 f2                	mov    %esi,%edx
  801925:	29 f9                	sub    %edi,%ecx
  801927:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80192b:	89 14 24             	mov    %edx,(%esp)
  80192e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801932:	8b 44 24 04          	mov    0x4(%esp),%eax
  801936:	8b 14 24             	mov    (%esp),%edx
  801939:	83 c4 1c             	add    $0x1c,%esp
  80193c:	5b                   	pop    %ebx
  80193d:	5e                   	pop    %esi
  80193e:	5f                   	pop    %edi
  80193f:	5d                   	pop    %ebp
  801940:	c3                   	ret    
  801941:	8d 76 00             	lea    0x0(%esi),%esi
  801944:	2b 04 24             	sub    (%esp),%eax
  801947:	19 fa                	sbb    %edi,%edx
  801949:	89 d1                	mov    %edx,%ecx
  80194b:	89 c6                	mov    %eax,%esi
  80194d:	e9 71 ff ff ff       	jmp    8018c3 <__umoddi3+0xb3>
  801952:	66 90                	xchg   %ax,%ax
  801954:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801958:	72 ea                	jb     801944 <__umoddi3+0x134>
  80195a:	89 d9                	mov    %ebx,%ecx
  80195c:	e9 62 ff ff ff       	jmp    8018c3 <__umoddi3+0xb3>
