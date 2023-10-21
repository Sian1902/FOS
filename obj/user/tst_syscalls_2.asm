
obj/user/tst_syscalls_2:     file format elf32-i386


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
  800031:	e8 17 01 00 00       	call   80014d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the correct validation of system call params
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	rsttst();
  80003e:	e8 53 15 00 00       	call   801596 <rsttst>
	int ID1 = sys_create_env("tsc2_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800043:	a1 20 30 80 00       	mov    0x803020,%eax
  800048:	8b 90 70 da 01 00    	mov    0x1da70(%eax),%edx
  80004e:	a1 20 30 80 00       	mov    0x803020,%eax
  800053:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800059:	89 c1                	mov    %eax,%ecx
  80005b:	a1 20 30 80 00       	mov    0x803020,%eax
  800060:	8b 80 7c d5 01 00    	mov    0x1d57c(%eax),%eax
  800066:	52                   	push   %edx
  800067:	51                   	push   %ecx
  800068:	50                   	push   %eax
  800069:	68 e0 1c 80 00       	push   $0x801ce0
  80006e:	e8 d7 13 00 00       	call   80144a <sys_create_env>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_run_env(ID1);
  800079:	83 ec 0c             	sub    $0xc,%esp
  80007c:	ff 75 f4             	pushl  -0xc(%ebp)
  80007f:	e8 e4 13 00 00       	call   801468 <sys_run_env>
  800084:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tsc2_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800087:	a1 20 30 80 00       	mov    0x803020,%eax
  80008c:	8b 90 70 da 01 00    	mov    0x1da70(%eax),%edx
  800092:	a1 20 30 80 00       	mov    0x803020,%eax
  800097:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80009d:	89 c1                	mov    %eax,%ecx
  80009f:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a4:	8b 80 7c d5 01 00    	mov    0x1d57c(%eax),%eax
  8000aa:	52                   	push   %edx
  8000ab:	51                   	push   %ecx
  8000ac:	50                   	push   %eax
  8000ad:	68 ec 1c 80 00       	push   $0x801cec
  8000b2:	e8 93 13 00 00       	call   80144a <sys_create_env>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID2);
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000c3:	e8 a0 13 00 00       	call   801468 <sys_run_env>
  8000c8:	83 c4 10             	add    $0x10,%esp

	int ID3 = sys_create_env("tsc2_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d0:	8b 90 70 da 01 00    	mov    0x1da70(%eax),%edx
  8000d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000db:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8000e1:	89 c1                	mov    %eax,%ecx
  8000e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e8:	8b 80 7c d5 01 00    	mov    0x1d57c(%eax),%eax
  8000ee:	52                   	push   %edx
  8000ef:	51                   	push   %ecx
  8000f0:	50                   	push   %eax
  8000f1:	68 f8 1c 80 00       	push   $0x801cf8
  8000f6:	e8 4f 13 00 00       	call   80144a <sys_create_env>
  8000fb:	83 c4 10             	add    $0x10,%esp
  8000fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_run_env(ID3);
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	ff 75 ec             	pushl  -0x14(%ebp)
  800107:	e8 5c 13 00 00       	call   801468 <sys_run_env>
  80010c:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 10 27 00 00       	push   $0x2710
  800117:	e8 c2 16 00 00       	call   8017de <env_sleep>
  80011c:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  80011f:	e8 ec 14 00 00       	call   801610 <gettst>
  800124:	85 c0                	test   %eax,%eax
  800126:	74 12                	je     80013a <_main+0x102>
		cprintf("\ntst_syscalls_2 Failed.\n");
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	68 04 1d 80 00       	push   $0x801d04
  800130:	e8 31 02 00 00       	call   800366 <cprintf>
  800135:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nCongratulations... tst system calls #2 completed successfully\n");

}
  800138:	eb 10                	jmp    80014a <_main+0x112>
	env_sleep(10000);

	if (gettst() != 0)
		cprintf("\ntst_syscalls_2 Failed.\n");
	else
		cprintf("\nCongratulations... tst system calls #2 completed successfully\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 20 1d 80 00       	push   $0x801d20
  800142:	e8 1f 02 00 00       	call   800366 <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp

}
  80014a:	90                   	nop
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800153:	e8 60 13 00 00       	call   8014b8 <sys_getenvindex>
  800158:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80015b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80015e:	89 d0                	mov    %edx,%eax
  800160:	01 c0                	add    %eax,%eax
  800162:	01 d0                	add    %edx,%eax
  800164:	01 c0                	add    %eax,%eax
  800166:	01 d0                	add    %edx,%eax
  800168:	c1 e0 02             	shl    $0x2,%eax
  80016b:	01 d0                	add    %edx,%eax
  80016d:	01 c0                	add    %eax,%eax
  80016f:	01 d0                	add    %edx,%eax
  800171:	c1 e0 02             	shl    $0x2,%eax
  800174:	01 d0                	add    %edx,%eax
  800176:	c1 e0 02             	shl    $0x2,%eax
  800179:	01 d0                	add    %edx,%eax
  80017b:	c1 e0 02             	shl    $0x2,%eax
  80017e:	01 d0                	add    %edx,%eax
  800180:	c1 e0 05             	shl    $0x5,%eax
  800183:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800188:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80018d:	a1 20 30 80 00       	mov    0x803020,%eax
  800192:	8a 40 5c             	mov    0x5c(%eax),%al
  800195:	84 c0                	test   %al,%al
  800197:	74 0d                	je     8001a6 <libmain+0x59>
		binaryname = myEnv->prog_name;
  800199:	a1 20 30 80 00       	mov    0x803020,%eax
  80019e:	83 c0 5c             	add    $0x5c,%eax
  8001a1:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001aa:	7e 0a                	jle    8001b6 <libmain+0x69>
		binaryname = argv[0];
  8001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001af:	8b 00                	mov    (%eax),%eax
  8001b1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	ff 75 0c             	pushl  0xc(%ebp)
  8001bc:	ff 75 08             	pushl  0x8(%ebp)
  8001bf:	e8 74 fe ff ff       	call   800038 <_main>
  8001c4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001c7:	e8 f9 10 00 00       	call   8012c5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	68 78 1d 80 00       	push   $0x801d78
  8001d4:	e8 8d 01 00 00       	call   800366 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001dc:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e1:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  8001e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ec:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	52                   	push   %edx
  8001f6:	50                   	push   %eax
  8001f7:	68 a0 1d 80 00       	push   $0x801da0
  8001fc:	e8 65 01 00 00       	call   800366 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800204:	a1 20 30 80 00       	mov    0x803020,%eax
  800209:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  80020f:	a1 20 30 80 00       	mov    0x803020,%eax
  800214:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  80021a:	a1 20 30 80 00       	mov    0x803020,%eax
  80021f:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  800225:	51                   	push   %ecx
  800226:	52                   	push   %edx
  800227:	50                   	push   %eax
  800228:	68 c8 1d 80 00       	push   $0x801dc8
  80022d:	e8 34 01 00 00       	call   800366 <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800235:	a1 20 30 80 00       	mov    0x803020,%eax
  80023a:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  800240:	83 ec 08             	sub    $0x8,%esp
  800243:	50                   	push   %eax
  800244:	68 20 1e 80 00       	push   $0x801e20
  800249:	e8 18 01 00 00       	call   800366 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800251:	83 ec 0c             	sub    $0xc,%esp
  800254:	68 78 1d 80 00       	push   $0x801d78
  800259:	e8 08 01 00 00       	call   800366 <cprintf>
  80025e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800261:	e8 79 10 00 00       	call   8012df <sys_enable_interrupt>

	// exit gracefully
	exit();
  800266:	e8 19 00 00 00       	call   800284 <exit>
}
  80026b:	90                   	nop
  80026c:	c9                   	leave  
  80026d:	c3                   	ret    

0080026e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	6a 00                	push   $0x0
  800279:	e8 06 12 00 00       	call   801484 <sys_destroy_env>
  80027e:	83 c4 10             	add    $0x10,%esp
}
  800281:	90                   	nop
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <exit>:

void
exit(void)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80028a:	e8 5b 12 00 00       	call   8014ea <sys_exit_env>
}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029b:	8b 00                	mov    (%eax),%eax
  80029d:	8d 48 01             	lea    0x1(%eax),%ecx
  8002a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a3:	89 0a                	mov    %ecx,(%edx)
  8002a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a8:	88 d1                	mov    %dl,%cl
  8002aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ad:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b4:	8b 00                	mov    (%eax),%eax
  8002b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002bb:	75 2c                	jne    8002e9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002bd:	a0 24 30 80 00       	mov    0x803024,%al
  8002c2:	0f b6 c0             	movzbl %al,%eax
  8002c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c8:	8b 12                	mov    (%edx),%edx
  8002ca:	89 d1                	mov    %edx,%ecx
  8002cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cf:	83 c2 08             	add    $0x8,%edx
  8002d2:	83 ec 04             	sub    $0x4,%esp
  8002d5:	50                   	push   %eax
  8002d6:	51                   	push   %ecx
  8002d7:	52                   	push   %edx
  8002d8:	e8 8f 0e 00 00       	call   80116c <sys_cputs>
  8002dd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ec:	8b 40 04             	mov    0x4(%eax),%eax
  8002ef:	8d 50 01             	lea    0x1(%eax),%edx
  8002f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002f8:	90                   	nop
  8002f9:	c9                   	leave  
  8002fa:	c3                   	ret    

008002fb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800304:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80030b:	00 00 00 
	b.cnt = 0;
  80030e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800315:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800318:	ff 75 0c             	pushl  0xc(%ebp)
  80031b:	ff 75 08             	pushl  0x8(%ebp)
  80031e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800324:	50                   	push   %eax
  800325:	68 92 02 80 00       	push   $0x800292
  80032a:	e8 11 02 00 00       	call   800540 <vprintfmt>
  80032f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800332:	a0 24 30 80 00       	mov    0x803024,%al
  800337:	0f b6 c0             	movzbl %al,%eax
  80033a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800340:	83 ec 04             	sub    $0x4,%esp
  800343:	50                   	push   %eax
  800344:	52                   	push   %edx
  800345:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80034b:	83 c0 08             	add    $0x8,%eax
  80034e:	50                   	push   %eax
  80034f:	e8 18 0e 00 00       	call   80116c <sys_cputs>
  800354:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800357:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80035e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800364:	c9                   	leave  
  800365:	c3                   	ret    

00800366 <cprintf>:

int cprintf(const char *fmt, ...) {
  800366:	55                   	push   %ebp
  800367:	89 e5                	mov    %esp,%ebp
  800369:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80036c:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800373:	8d 45 0c             	lea    0xc(%ebp),%eax
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	83 ec 08             	sub    $0x8,%esp
  80037f:	ff 75 f4             	pushl  -0xc(%ebp)
  800382:	50                   	push   %eax
  800383:	e8 73 ff ff ff       	call   8002fb <vcprintf>
  800388:	83 c4 10             	add    $0x10,%esp
  80038b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80038e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800391:	c9                   	leave  
  800392:	c3                   	ret    

00800393 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800399:	e8 27 0f 00 00       	call   8012c5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80039e:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	83 ec 08             	sub    $0x8,%esp
  8003aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ad:	50                   	push   %eax
  8003ae:	e8 48 ff ff ff       	call   8002fb <vcprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
  8003b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003b9:	e8 21 0f 00 00       	call   8012df <sys_enable_interrupt>
	return cnt;
  8003be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003c1:	c9                   	leave  
  8003c2:	c3                   	ret    

008003c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	53                   	push   %ebx
  8003c7:	83 ec 14             	sub    $0x14,%esp
  8003ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8003cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003d6:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003de:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003e1:	77 55                	ja     800438 <printnum+0x75>
  8003e3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003e6:	72 05                	jb     8003ed <printnum+0x2a>
  8003e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003eb:	77 4b                	ja     800438 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ed:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003f0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8003f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fb:	52                   	push   %edx
  8003fc:	50                   	push   %eax
  8003fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800400:	ff 75 f0             	pushl  -0x10(%ebp)
  800403:	e8 74 16 00 00       	call   801a7c <__udivdi3>
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	83 ec 04             	sub    $0x4,%esp
  80040e:	ff 75 20             	pushl  0x20(%ebp)
  800411:	53                   	push   %ebx
  800412:	ff 75 18             	pushl  0x18(%ebp)
  800415:	52                   	push   %edx
  800416:	50                   	push   %eax
  800417:	ff 75 0c             	pushl  0xc(%ebp)
  80041a:	ff 75 08             	pushl  0x8(%ebp)
  80041d:	e8 a1 ff ff ff       	call   8003c3 <printnum>
  800422:	83 c4 20             	add    $0x20,%esp
  800425:	eb 1a                	jmp    800441 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800427:	83 ec 08             	sub    $0x8,%esp
  80042a:	ff 75 0c             	pushl  0xc(%ebp)
  80042d:	ff 75 20             	pushl  0x20(%ebp)
  800430:	8b 45 08             	mov    0x8(%ebp),%eax
  800433:	ff d0                	call   *%eax
  800435:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800438:	ff 4d 1c             	decl   0x1c(%ebp)
  80043b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80043f:	7f e6                	jg     800427 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800441:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800444:	bb 00 00 00 00       	mov    $0x0,%ebx
  800449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80044f:	53                   	push   %ebx
  800450:	51                   	push   %ecx
  800451:	52                   	push   %edx
  800452:	50                   	push   %eax
  800453:	e8 34 17 00 00       	call   801b8c <__umoddi3>
  800458:	83 c4 10             	add    $0x10,%esp
  80045b:	05 54 20 80 00       	add    $0x802054,%eax
  800460:	8a 00                	mov    (%eax),%al
  800462:	0f be c0             	movsbl %al,%eax
  800465:	83 ec 08             	sub    $0x8,%esp
  800468:	ff 75 0c             	pushl  0xc(%ebp)
  80046b:	50                   	push   %eax
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	ff d0                	call   *%eax
  800471:	83 c4 10             	add    $0x10,%esp
}
  800474:	90                   	nop
  800475:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800478:	c9                   	leave  
  800479:	c3                   	ret    

0080047a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80047a:	55                   	push   %ebp
  80047b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80047d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800481:	7e 1c                	jle    80049f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	8d 50 08             	lea    0x8(%eax),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	89 10                	mov    %edx,(%eax)
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	83 e8 08             	sub    $0x8,%eax
  800498:	8b 50 04             	mov    0x4(%eax),%edx
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	eb 40                	jmp    8004df <getuint+0x65>
	else if (lflag)
  80049f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004a3:	74 1e                	je     8004c3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	8d 50 04             	lea    0x4(%eax),%edx
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	89 10                	mov    %edx,(%eax)
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	83 e8 04             	sub    $0x4,%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c1:	eb 1c                	jmp    8004df <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	8d 50 04             	lea    0x4(%eax),%edx
  8004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ce:	89 10                	mov    %edx,(%eax)
  8004d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	83 e8 04             	sub    $0x4,%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004df:	5d                   	pop    %ebp
  8004e0:	c3                   	ret    

008004e1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004e8:	7e 1c                	jle    800506 <getint+0x25>
		return va_arg(*ap, long long);
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	8d 50 08             	lea    0x8(%eax),%edx
  8004f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f5:	89 10                	mov    %edx,(%eax)
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	83 e8 08             	sub    $0x8,%eax
  8004ff:	8b 50 04             	mov    0x4(%eax),%edx
  800502:	8b 00                	mov    (%eax),%eax
  800504:	eb 38                	jmp    80053e <getint+0x5d>
	else if (lflag)
  800506:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80050a:	74 1a                	je     800526 <getint+0x45>
		return va_arg(*ap, long);
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	8d 50 04             	lea    0x4(%eax),%edx
  800514:	8b 45 08             	mov    0x8(%ebp),%eax
  800517:	89 10                	mov    %edx,(%eax)
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	83 e8 04             	sub    $0x4,%eax
  800521:	8b 00                	mov    (%eax),%eax
  800523:	99                   	cltd   
  800524:	eb 18                	jmp    80053e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800526:	8b 45 08             	mov    0x8(%ebp),%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	8d 50 04             	lea    0x4(%eax),%edx
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	89 10                	mov    %edx,(%eax)
  800533:	8b 45 08             	mov    0x8(%ebp),%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	83 e8 04             	sub    $0x4,%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	99                   	cltd   
}
  80053e:	5d                   	pop    %ebp
  80053f:	c3                   	ret    

00800540 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	56                   	push   %esi
  800544:	53                   	push   %ebx
  800545:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800548:	eb 17                	jmp    800561 <vprintfmt+0x21>
			if (ch == '\0')
  80054a:	85 db                	test   %ebx,%ebx
  80054c:	0f 84 af 03 00 00    	je     800901 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800552:	83 ec 08             	sub    $0x8,%esp
  800555:	ff 75 0c             	pushl  0xc(%ebp)
  800558:	53                   	push   %ebx
  800559:	8b 45 08             	mov    0x8(%ebp),%eax
  80055c:	ff d0                	call   *%eax
  80055e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800561:	8b 45 10             	mov    0x10(%ebp),%eax
  800564:	8d 50 01             	lea    0x1(%eax),%edx
  800567:	89 55 10             	mov    %edx,0x10(%ebp)
  80056a:	8a 00                	mov    (%eax),%al
  80056c:	0f b6 d8             	movzbl %al,%ebx
  80056f:	83 fb 25             	cmp    $0x25,%ebx
  800572:	75 d6                	jne    80054a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800574:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800578:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80057f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800586:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80058d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800594:	8b 45 10             	mov    0x10(%ebp),%eax
  800597:	8d 50 01             	lea    0x1(%eax),%edx
  80059a:	89 55 10             	mov    %edx,0x10(%ebp)
  80059d:	8a 00                	mov    (%eax),%al
  80059f:	0f b6 d8             	movzbl %al,%ebx
  8005a2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005a5:	83 f8 55             	cmp    $0x55,%eax
  8005a8:	0f 87 2b 03 00 00    	ja     8008d9 <vprintfmt+0x399>
  8005ae:	8b 04 85 78 20 80 00 	mov    0x802078(,%eax,4),%eax
  8005b5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005b7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005bb:	eb d7                	jmp    800594 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005bd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005c1:	eb d1                	jmp    800594 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005cd:	89 d0                	mov    %edx,%eax
  8005cf:	c1 e0 02             	shl    $0x2,%eax
  8005d2:	01 d0                	add    %edx,%eax
  8005d4:	01 c0                	add    %eax,%eax
  8005d6:	01 d8                	add    %ebx,%eax
  8005d8:	83 e8 30             	sub    $0x30,%eax
  8005db:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005de:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e1:	8a 00                	mov    (%eax),%al
  8005e3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005e6:	83 fb 2f             	cmp    $0x2f,%ebx
  8005e9:	7e 3e                	jle    800629 <vprintfmt+0xe9>
  8005eb:	83 fb 39             	cmp    $0x39,%ebx
  8005ee:	7f 39                	jg     800629 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005f0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005f3:	eb d5                	jmp    8005ca <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	83 c0 04             	add    $0x4,%eax
  8005fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	83 e8 04             	sub    $0x4,%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800609:	eb 1f                	jmp    80062a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80060b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80060f:	79 83                	jns    800594 <vprintfmt+0x54>
				width = 0;
  800611:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800618:	e9 77 ff ff ff       	jmp    800594 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80061d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800624:	e9 6b ff ff ff       	jmp    800594 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800629:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80062a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80062e:	0f 89 60 ff ff ff    	jns    800594 <vprintfmt+0x54>
				width = precision, precision = -1;
  800634:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800637:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80063a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800641:	e9 4e ff ff ff       	jmp    800594 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800646:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800649:	e9 46 ff ff ff       	jmp    800594 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	83 c0 04             	add    $0x4,%eax
  800654:	89 45 14             	mov    %eax,0x14(%ebp)
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	83 e8 04             	sub    $0x4,%eax
  80065d:	8b 00                	mov    (%eax),%eax
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	50                   	push   %eax
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	ff d0                	call   *%eax
  80066b:	83 c4 10             	add    $0x10,%esp
			break;
  80066e:	e9 89 02 00 00       	jmp    8008fc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	83 c0 04             	add    $0x4,%eax
  800679:	89 45 14             	mov    %eax,0x14(%ebp)
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	83 e8 04             	sub    $0x4,%eax
  800682:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800684:	85 db                	test   %ebx,%ebx
  800686:	79 02                	jns    80068a <vprintfmt+0x14a>
				err = -err;
  800688:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80068a:	83 fb 64             	cmp    $0x64,%ebx
  80068d:	7f 0b                	jg     80069a <vprintfmt+0x15a>
  80068f:	8b 34 9d c0 1e 80 00 	mov    0x801ec0(,%ebx,4),%esi
  800696:	85 f6                	test   %esi,%esi
  800698:	75 19                	jne    8006b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80069a:	53                   	push   %ebx
  80069b:	68 65 20 80 00       	push   $0x802065
  8006a0:	ff 75 0c             	pushl  0xc(%ebp)
  8006a3:	ff 75 08             	pushl  0x8(%ebp)
  8006a6:	e8 5e 02 00 00       	call   800909 <printfmt>
  8006ab:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006ae:	e9 49 02 00 00       	jmp    8008fc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006b3:	56                   	push   %esi
  8006b4:	68 6e 20 80 00       	push   $0x80206e
  8006b9:	ff 75 0c             	pushl  0xc(%ebp)
  8006bc:	ff 75 08             	pushl  0x8(%ebp)
  8006bf:	e8 45 02 00 00       	call   800909 <printfmt>
  8006c4:	83 c4 10             	add    $0x10,%esp
			break;
  8006c7:	e9 30 02 00 00       	jmp    8008fc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	83 c0 04             	add    $0x4,%eax
  8006d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	83 e8 04             	sub    $0x4,%eax
  8006db:	8b 30                	mov    (%eax),%esi
  8006dd:	85 f6                	test   %esi,%esi
  8006df:	75 05                	jne    8006e6 <vprintfmt+0x1a6>
				p = "(null)";
  8006e1:	be 71 20 80 00       	mov    $0x802071,%esi
			if (width > 0 && padc != '-')
  8006e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ea:	7e 6d                	jle    800759 <vprintfmt+0x219>
  8006ec:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006f0:	74 67                	je     800759 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	50                   	push   %eax
  8006f9:	56                   	push   %esi
  8006fa:	e8 0c 03 00 00       	call   800a0b <strnlen>
  8006ff:	83 c4 10             	add    $0x10,%esp
  800702:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800705:	eb 16                	jmp    80071d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800707:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 0c             	pushl  0xc(%ebp)
  800711:	50                   	push   %eax
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	ff d0                	call   *%eax
  800717:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80071a:	ff 4d e4             	decl   -0x1c(%ebp)
  80071d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800721:	7f e4                	jg     800707 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800723:	eb 34                	jmp    800759 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800725:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800729:	74 1c                	je     800747 <vprintfmt+0x207>
  80072b:	83 fb 1f             	cmp    $0x1f,%ebx
  80072e:	7e 05                	jle    800735 <vprintfmt+0x1f5>
  800730:	83 fb 7e             	cmp    $0x7e,%ebx
  800733:	7e 12                	jle    800747 <vprintfmt+0x207>
					putch('?', putdat);
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	ff 75 0c             	pushl  0xc(%ebp)
  80073b:	6a 3f                	push   $0x3f
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	ff d0                	call   *%eax
  800742:	83 c4 10             	add    $0x10,%esp
  800745:	eb 0f                	jmp    800756 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	ff 75 0c             	pushl  0xc(%ebp)
  80074d:	53                   	push   %ebx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	ff d0                	call   *%eax
  800753:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800756:	ff 4d e4             	decl   -0x1c(%ebp)
  800759:	89 f0                	mov    %esi,%eax
  80075b:	8d 70 01             	lea    0x1(%eax),%esi
  80075e:	8a 00                	mov    (%eax),%al
  800760:	0f be d8             	movsbl %al,%ebx
  800763:	85 db                	test   %ebx,%ebx
  800765:	74 24                	je     80078b <vprintfmt+0x24b>
  800767:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80076b:	78 b8                	js     800725 <vprintfmt+0x1e5>
  80076d:	ff 4d e0             	decl   -0x20(%ebp)
  800770:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800774:	79 af                	jns    800725 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800776:	eb 13                	jmp    80078b <vprintfmt+0x24b>
				putch(' ', putdat);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 0c             	pushl  0xc(%ebp)
  80077e:	6a 20                	push   $0x20
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	ff d0                	call   *%eax
  800785:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800788:	ff 4d e4             	decl   -0x1c(%ebp)
  80078b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80078f:	7f e7                	jg     800778 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800791:	e9 66 01 00 00       	jmp    8008fc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	ff 75 e8             	pushl  -0x18(%ebp)
  80079c:	8d 45 14             	lea    0x14(%ebp),%eax
  80079f:	50                   	push   %eax
  8007a0:	e8 3c fd ff ff       	call   8004e1 <getint>
  8007a5:	83 c4 10             	add    $0x10,%esp
  8007a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b4:	85 d2                	test   %edx,%edx
  8007b6:	79 23                	jns    8007db <vprintfmt+0x29b>
				putch('-', putdat);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	ff 75 0c             	pushl  0xc(%ebp)
  8007be:	6a 2d                	push   $0x2d
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	ff d0                	call   *%eax
  8007c5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ce:	f7 d8                	neg    %eax
  8007d0:	83 d2 00             	adc    $0x0,%edx
  8007d3:	f7 da                	neg    %edx
  8007d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007e2:	e9 bc 00 00 00       	jmp    8008a3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ed:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f0:	50                   	push   %eax
  8007f1:	e8 84 fc ff ff       	call   80047a <getuint>
  8007f6:	83 c4 10             	add    $0x10,%esp
  8007f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800806:	e9 98 00 00 00       	jmp    8008a3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	ff 75 0c             	pushl  0xc(%ebp)
  800811:	6a 58                	push   $0x58
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	ff d0                	call   *%eax
  800818:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	ff 75 0c             	pushl  0xc(%ebp)
  800821:	6a 58                	push   $0x58
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	ff d0                	call   *%eax
  800828:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	6a 58                	push   $0x58
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
			break;
  80083b:	e9 bc 00 00 00       	jmp    8008fc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	6a 30                	push   $0x30
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	6a 78                	push   $0x78
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	ff d0                	call   *%eax
  80085d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	83 c0 04             	add    $0x4,%eax
  800866:	89 45 14             	mov    %eax,0x14(%ebp)
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	83 e8 04             	sub    $0x4,%eax
  80086f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800871:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800874:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80087b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800882:	eb 1f                	jmp    8008a3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	ff 75 e8             	pushl  -0x18(%ebp)
  80088a:	8d 45 14             	lea    0x14(%ebp),%eax
  80088d:	50                   	push   %eax
  80088e:	e8 e7 fb ff ff       	call   80047a <getuint>
  800893:	83 c4 10             	add    $0x10,%esp
  800896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800899:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80089c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008a3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008aa:	83 ec 04             	sub    $0x4,%esp
  8008ad:	52                   	push   %edx
  8008ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008b1:	50                   	push   %eax
  8008b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8008b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8008b8:	ff 75 0c             	pushl  0xc(%ebp)
  8008bb:	ff 75 08             	pushl  0x8(%ebp)
  8008be:	e8 00 fb ff ff       	call   8003c3 <printnum>
  8008c3:	83 c4 20             	add    $0x20,%esp
			break;
  8008c6:	eb 34                	jmp    8008fc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	53                   	push   %ebx
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	ff d0                	call   *%eax
  8008d4:	83 c4 10             	add    $0x10,%esp
			break;
  8008d7:	eb 23                	jmp    8008fc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008d9:	83 ec 08             	sub    $0x8,%esp
  8008dc:	ff 75 0c             	pushl  0xc(%ebp)
  8008df:	6a 25                	push   $0x25
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	ff d0                	call   *%eax
  8008e6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008e9:	ff 4d 10             	decl   0x10(%ebp)
  8008ec:	eb 03                	jmp    8008f1 <vprintfmt+0x3b1>
  8008ee:	ff 4d 10             	decl   0x10(%ebp)
  8008f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f4:	48                   	dec    %eax
  8008f5:	8a 00                	mov    (%eax),%al
  8008f7:	3c 25                	cmp    $0x25,%al
  8008f9:	75 f3                	jne    8008ee <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008fb:	90                   	nop
		}
	}
  8008fc:	e9 47 fc ff ff       	jmp    800548 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800901:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800902:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800905:	5b                   	pop    %ebx
  800906:	5e                   	pop    %esi
  800907:	5d                   	pop    %ebp
  800908:	c3                   	ret    

00800909 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80090f:	8d 45 10             	lea    0x10(%ebp),%eax
  800912:	83 c0 04             	add    $0x4,%eax
  800915:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800918:	8b 45 10             	mov    0x10(%ebp),%eax
  80091b:	ff 75 f4             	pushl  -0xc(%ebp)
  80091e:	50                   	push   %eax
  80091f:	ff 75 0c             	pushl  0xc(%ebp)
  800922:	ff 75 08             	pushl  0x8(%ebp)
  800925:	e8 16 fc ff ff       	call   800540 <vprintfmt>
  80092a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80092d:	90                   	nop
  80092e:	c9                   	leave  
  80092f:	c3                   	ret    

00800930 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	8b 40 08             	mov    0x8(%eax),%eax
  800939:	8d 50 01             	lea    0x1(%eax),%edx
  80093c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800942:	8b 45 0c             	mov    0xc(%ebp),%eax
  800945:	8b 10                	mov    (%eax),%edx
  800947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094a:	8b 40 04             	mov    0x4(%eax),%eax
  80094d:	39 c2                	cmp    %eax,%edx
  80094f:	73 12                	jae    800963 <sprintputch+0x33>
		*b->buf++ = ch;
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	8d 48 01             	lea    0x1(%eax),%ecx
  800959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095c:	89 0a                	mov    %ecx,(%edx)
  80095e:	8b 55 08             	mov    0x8(%ebp),%edx
  800961:	88 10                	mov    %dl,(%eax)
}
  800963:	90                   	nop
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    

00800966 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800972:	8b 45 0c             	mov    0xc(%ebp),%eax
  800975:	8d 50 ff             	lea    -0x1(%eax),%edx
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	01 d0                	add    %edx,%eax
  80097d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800980:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800987:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80098b:	74 06                	je     800993 <vsnprintf+0x2d>
  80098d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800991:	7f 07                	jg     80099a <vsnprintf+0x34>
		return -E_INVAL;
  800993:	b8 03 00 00 00       	mov    $0x3,%eax
  800998:	eb 20                	jmp    8009ba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80099a:	ff 75 14             	pushl  0x14(%ebp)
  80099d:	ff 75 10             	pushl  0x10(%ebp)
  8009a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a3:	50                   	push   %eax
  8009a4:	68 30 09 80 00       	push   $0x800930
  8009a9:	e8 92 fb ff ff       	call   800540 <vprintfmt>
  8009ae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8009c5:	83 c0 04             	add    $0x4,%eax
  8009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d1:	50                   	push   %eax
  8009d2:	ff 75 0c             	pushl  0xc(%ebp)
  8009d5:	ff 75 08             	pushl  0x8(%ebp)
  8009d8:	e8 89 ff ff ff       	call   800966 <vsnprintf>
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009e6:	c9                   	leave  
  8009e7:	c3                   	ret    

008009e8 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009f5:	eb 06                	jmp    8009fd <strlen+0x15>
		n++;
  8009f7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009fa:	ff 45 08             	incl   0x8(%ebp)
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	8a 00                	mov    (%eax),%al
  800a02:	84 c0                	test   %al,%al
  800a04:	75 f1                	jne    8009f7 <strlen+0xf>
		n++;
	return n;
  800a06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a09:	c9                   	leave  
  800a0a:	c3                   	ret    

00800a0b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a18:	eb 09                	jmp    800a23 <strnlen+0x18>
		n++;
  800a1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a1d:	ff 45 08             	incl   0x8(%ebp)
  800a20:	ff 4d 0c             	decl   0xc(%ebp)
  800a23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a27:	74 09                	je     800a32 <strnlen+0x27>
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8a 00                	mov    (%eax),%al
  800a2e:	84 c0                	test   %al,%al
  800a30:	75 e8                	jne    800a1a <strnlen+0xf>
		n++;
	return n;
  800a32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a43:	90                   	nop
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	8d 50 01             	lea    0x1(%eax),%edx
  800a4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a56:	8a 12                	mov    (%edx),%dl
  800a58:	88 10                	mov    %dl,(%eax)
  800a5a:	8a 00                	mov    (%eax),%al
  800a5c:	84 c0                	test   %al,%al
  800a5e:	75 e4                	jne    800a44 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a63:	c9                   	leave  
  800a64:	c3                   	ret    

00800a65 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a78:	eb 1f                	jmp    800a99 <strncpy+0x34>
		*dst++ = *src;
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	8d 50 01             	lea    0x1(%eax),%edx
  800a80:	89 55 08             	mov    %edx,0x8(%ebp)
  800a83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a86:	8a 12                	mov    (%edx),%dl
  800a88:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8d:	8a 00                	mov    (%eax),%al
  800a8f:	84 c0                	test   %al,%al
  800a91:	74 03                	je     800a96 <strncpy+0x31>
			src++;
  800a93:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a96:	ff 45 fc             	incl   -0x4(%ebp)
  800a99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a9f:	72 d9                	jb     800a7a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800aa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800aa4:	c9                   	leave  
  800aa5:	c3                   	ret    

00800aa6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ab2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab6:	74 30                	je     800ae8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ab8:	eb 16                	jmp    800ad0 <strlcpy+0x2a>
			*dst++ = *src++;
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8d 50 01             	lea    0x1(%eax),%edx
  800ac0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ac9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800acc:	8a 12                	mov    (%edx),%dl
  800ace:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ad0:	ff 4d 10             	decl   0x10(%ebp)
  800ad3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ad7:	74 09                	je     800ae2 <strlcpy+0x3c>
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	8a 00                	mov    (%eax),%al
  800ade:	84 c0                	test   %al,%al
  800ae0:	75 d8                	jne    800aba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae8:	8b 55 08             	mov    0x8(%ebp),%edx
  800aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aee:	29 c2                	sub    %eax,%edx
  800af0:	89 d0                	mov    %edx,%eax
}
  800af2:	c9                   	leave  
  800af3:	c3                   	ret    

00800af4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800af7:	eb 06                	jmp    800aff <strcmp+0xb>
		p++, q++;
  800af9:	ff 45 08             	incl   0x8(%ebp)
  800afc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8a 00                	mov    (%eax),%al
  800b04:	84 c0                	test   %al,%al
  800b06:	74 0e                	je     800b16 <strcmp+0x22>
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	8a 10                	mov    (%eax),%dl
  800b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b10:	8a 00                	mov    (%eax),%al
  800b12:	38 c2                	cmp    %al,%dl
  800b14:	74 e3                	je     800af9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	8a 00                	mov    (%eax),%al
  800b1b:	0f b6 d0             	movzbl %al,%edx
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	8a 00                	mov    (%eax),%al
  800b23:	0f b6 c0             	movzbl %al,%eax
  800b26:	29 c2                	sub    %eax,%edx
  800b28:	89 d0                	mov    %edx,%eax
}
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b2f:	eb 09                	jmp    800b3a <strncmp+0xe>
		n--, p++, q++;
  800b31:	ff 4d 10             	decl   0x10(%ebp)
  800b34:	ff 45 08             	incl   0x8(%ebp)
  800b37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3e:	74 17                	je     800b57 <strncmp+0x2b>
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	8a 00                	mov    (%eax),%al
  800b45:	84 c0                	test   %al,%al
  800b47:	74 0e                	je     800b57 <strncmp+0x2b>
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8a 10                	mov    (%eax),%dl
  800b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b51:	8a 00                	mov    (%eax),%al
  800b53:	38 c2                	cmp    %al,%dl
  800b55:	74 da                	je     800b31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b5b:	75 07                	jne    800b64 <strncmp+0x38>
		return 0;
  800b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b62:	eb 14                	jmp    800b78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	0f b6 d0             	movzbl %al,%edx
  800b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6f:	8a 00                	mov    (%eax),%al
  800b71:	0f b6 c0             	movzbl %al,%eax
  800b74:	29 c2                	sub    %eax,%edx
  800b76:	89 d0                	mov    %edx,%eax
}
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	83 ec 04             	sub    $0x4,%esp
  800b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b86:	eb 12                	jmp    800b9a <strchr+0x20>
		if (*s == c)
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	8a 00                	mov    (%eax),%al
  800b8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b90:	75 05                	jne    800b97 <strchr+0x1d>
			return (char *) s;
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	eb 11                	jmp    800ba8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b97:	ff 45 08             	incl   0x8(%ebp)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8a 00                	mov    (%eax),%al
  800b9f:	84 c0                	test   %al,%al
  800ba1:	75 e5                	jne    800b88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ba3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba8:	c9                   	leave  
  800ba9:	c3                   	ret    

00800baa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	83 ec 04             	sub    $0x4,%esp
  800bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bb6:	eb 0d                	jmp    800bc5 <strfind+0x1b>
		if (*s == c)
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bc0:	74 0e                	je     800bd0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bc2:	ff 45 08             	incl   0x8(%ebp)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8a 00                	mov    (%eax),%al
  800bca:	84 c0                	test   %al,%al
  800bcc:	75 ea                	jne    800bb8 <strfind+0xe>
  800bce:	eb 01                	jmp    800bd1 <strfind+0x27>
		if (*s == c)
			break;
  800bd0:	90                   	nop
	return (char *) s;
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bd4:	c9                   	leave  
  800bd5:	c3                   	ret    

00800bd6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800be2:	8b 45 10             	mov    0x10(%ebp),%eax
  800be5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800be8:	eb 0e                	jmp    800bf8 <memset+0x22>
		*p++ = c;
  800bea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bed:	8d 50 01             	lea    0x1(%eax),%edx
  800bf0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bf8:	ff 4d f8             	decl   -0x8(%ebp)
  800bfb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bff:	79 e9                	jns    800bea <memset+0x14>
		*p++ = c;

	return v;
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c04:	c9                   	leave  
  800c05:	c3                   	ret    

00800c06 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c18:	eb 16                	jmp    800c30 <memcpy+0x2a>
		*d++ = *s++;
  800c1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c1d:	8d 50 01             	lea    0x1(%eax),%edx
  800c20:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c29:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c2c:	8a 12                	mov    (%edx),%dl
  800c2e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c30:	8b 45 10             	mov    0x10(%ebp),%eax
  800c33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c36:	89 55 10             	mov    %edx,0x10(%ebp)
  800c39:	85 c0                	test   %eax,%eax
  800c3b:	75 dd                	jne    800c1a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c57:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c5a:	73 50                	jae    800cac <memmove+0x6a>
  800c5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c62:	01 d0                	add    %edx,%eax
  800c64:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c67:	76 43                	jbe    800cac <memmove+0x6a>
		s += n;
  800c69:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c72:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c75:	eb 10                	jmp    800c87 <memmove+0x45>
			*--d = *--s;
  800c77:	ff 4d f8             	decl   -0x8(%ebp)
  800c7a:	ff 4d fc             	decl   -0x4(%ebp)
  800c7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c80:	8a 10                	mov    (%eax),%dl
  800c82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c85:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c87:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800c90:	85 c0                	test   %eax,%eax
  800c92:	75 e3                	jne    800c77 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c94:	eb 23                	jmp    800cb9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c99:	8d 50 01             	lea    0x1(%eax),%edx
  800c9c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ca2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ca8:	8a 12                	mov    (%edx),%dl
  800caa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cac:	8b 45 10             	mov    0x10(%ebp),%eax
  800caf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800cb5:	85 c0                	test   %eax,%eax
  800cb7:	75 dd                	jne    800c96 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cbc:	c9                   	leave  
  800cbd:	c3                   	ret    

00800cbe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cd0:	eb 2a                	jmp    800cfc <memcmp+0x3e>
		if (*s1 != *s2)
  800cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd5:	8a 10                	mov    (%eax),%dl
  800cd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	38 c2                	cmp    %al,%dl
  800cde:	74 16                	je     800cf6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ce0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	0f b6 d0             	movzbl %al,%edx
  800ce8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	0f b6 c0             	movzbl %al,%eax
  800cf0:	29 c2                	sub    %eax,%edx
  800cf2:	89 d0                	mov    %edx,%eax
  800cf4:	eb 18                	jmp    800d0e <memcmp+0x50>
		s1++, s2++;
  800cf6:	ff 45 fc             	incl   -0x4(%ebp)
  800cf9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d02:	89 55 10             	mov    %edx,0x10(%ebp)
  800d05:	85 c0                	test   %eax,%eax
  800d07:	75 c9                	jne    800cd2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d16:	8b 55 08             	mov    0x8(%ebp),%edx
  800d19:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1c:	01 d0                	add    %edx,%eax
  800d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d21:	eb 15                	jmp    800d38 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	0f b6 d0             	movzbl %al,%edx
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	0f b6 c0             	movzbl %al,%eax
  800d31:	39 c2                	cmp    %eax,%edx
  800d33:	74 0d                	je     800d42 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d35:	ff 45 08             	incl   0x8(%ebp)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d3e:	72 e3                	jb     800d23 <memfind+0x13>
  800d40:	eb 01                	jmp    800d43 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d42:	90                   	nop
	return (void *) s;
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d46:	c9                   	leave  
  800d47:	c3                   	ret    

00800d48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d55:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d5c:	eb 03                	jmp    800d61 <strtol+0x19>
		s++;
  800d5e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	3c 20                	cmp    $0x20,%al
  800d68:	74 f4                	je     800d5e <strtol+0x16>
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	3c 09                	cmp    $0x9,%al
  800d71:	74 eb                	je     800d5e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	3c 2b                	cmp    $0x2b,%al
  800d7a:	75 05                	jne    800d81 <strtol+0x39>
		s++;
  800d7c:	ff 45 08             	incl   0x8(%ebp)
  800d7f:	eb 13                	jmp    800d94 <strtol+0x4c>
	else if (*s == '-')
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	3c 2d                	cmp    $0x2d,%al
  800d88:	75 0a                	jne    800d94 <strtol+0x4c>
		s++, neg = 1;
  800d8a:	ff 45 08             	incl   0x8(%ebp)
  800d8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d98:	74 06                	je     800da0 <strtol+0x58>
  800d9a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d9e:	75 20                	jne    800dc0 <strtol+0x78>
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	3c 30                	cmp    $0x30,%al
  800da7:	75 17                	jne    800dc0 <strtol+0x78>
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	40                   	inc    %eax
  800dad:	8a 00                	mov    (%eax),%al
  800daf:	3c 78                	cmp    $0x78,%al
  800db1:	75 0d                	jne    800dc0 <strtol+0x78>
		s += 2, base = 16;
  800db3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800db7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dbe:	eb 28                	jmp    800de8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc4:	75 15                	jne    800ddb <strtol+0x93>
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	3c 30                	cmp    $0x30,%al
  800dcd:	75 0c                	jne    800ddb <strtol+0x93>
		s++, base = 8;
  800dcf:	ff 45 08             	incl   0x8(%ebp)
  800dd2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dd9:	eb 0d                	jmp    800de8 <strtol+0xa0>
	else if (base == 0)
  800ddb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddf:	75 07                	jne    800de8 <strtol+0xa0>
		base = 10;
  800de1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	3c 2f                	cmp    $0x2f,%al
  800def:	7e 19                	jle    800e0a <strtol+0xc2>
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	3c 39                	cmp    $0x39,%al
  800df8:	7f 10                	jg     800e0a <strtol+0xc2>
			dig = *s - '0';
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8a 00                	mov    (%eax),%al
  800dff:	0f be c0             	movsbl %al,%eax
  800e02:	83 e8 30             	sub    $0x30,%eax
  800e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e08:	eb 42                	jmp    800e4c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	3c 60                	cmp    $0x60,%al
  800e11:	7e 19                	jle    800e2c <strtol+0xe4>
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	3c 7a                	cmp    $0x7a,%al
  800e1a:	7f 10                	jg     800e2c <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	0f be c0             	movsbl %al,%eax
  800e24:	83 e8 57             	sub    $0x57,%eax
  800e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e2a:	eb 20                	jmp    800e4c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	3c 40                	cmp    $0x40,%al
  800e33:	7e 39                	jle    800e6e <strtol+0x126>
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	8a 00                	mov    (%eax),%al
  800e3a:	3c 5a                	cmp    $0x5a,%al
  800e3c:	7f 30                	jg     800e6e <strtol+0x126>
			dig = *s - 'A' + 10;
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	0f be c0             	movsbl %al,%eax
  800e46:	83 e8 37             	sub    $0x37,%eax
  800e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e52:	7d 19                	jge    800e6d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e54:	ff 45 08             	incl   0x8(%ebp)
  800e57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e5e:	89 c2                	mov    %eax,%edx
  800e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e63:	01 d0                	add    %edx,%eax
  800e65:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e68:	e9 7b ff ff ff       	jmp    800de8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e6d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e72:	74 08                	je     800e7c <strtol+0x134>
		*endptr = (char *) s;
  800e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e77:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e80:	74 07                	je     800e89 <strtol+0x141>
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	f7 d8                	neg    %eax
  800e87:	eb 03                	jmp    800e8c <strtol+0x144>
  800e89:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <ltostr>:

void
ltostr(long value, char *str)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e9b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ea2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ea6:	79 13                	jns    800ebb <ltostr+0x2d>
	{
		neg = 1;
  800ea8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eb5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800eb8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ec3:	99                   	cltd   
  800ec4:	f7 f9                	idiv   %ecx
  800ec6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ec9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ecc:	8d 50 01             	lea    0x1(%eax),%edx
  800ecf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed2:	89 c2                	mov    %eax,%edx
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	01 d0                	add    %edx,%eax
  800ed9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800edc:	83 c2 30             	add    $0x30,%edx
  800edf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ee1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ee4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ee9:	f7 e9                	imul   %ecx
  800eeb:	c1 fa 02             	sar    $0x2,%edx
  800eee:	89 c8                	mov    %ecx,%eax
  800ef0:	c1 f8 1f             	sar    $0x1f,%eax
  800ef3:	29 c2                	sub    %eax,%edx
  800ef5:	89 d0                	mov    %edx,%eax
  800ef7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800efa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f02:	f7 e9                	imul   %ecx
  800f04:	c1 fa 02             	sar    $0x2,%edx
  800f07:	89 c8                	mov    %ecx,%eax
  800f09:	c1 f8 1f             	sar    $0x1f,%eax
  800f0c:	29 c2                	sub    %eax,%edx
  800f0e:	89 d0                	mov    %edx,%eax
  800f10:	c1 e0 02             	shl    $0x2,%eax
  800f13:	01 d0                	add    %edx,%eax
  800f15:	01 c0                	add    %eax,%eax
  800f17:	29 c1                	sub    %eax,%ecx
  800f19:	89 ca                	mov    %ecx,%edx
  800f1b:	85 d2                	test   %edx,%edx
  800f1d:	75 9c                	jne    800ebb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f29:	48                   	dec    %eax
  800f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f31:	74 3d                	je     800f70 <ltostr+0xe2>
		start = 1 ;
  800f33:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f3a:	eb 34                	jmp    800f70 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f42:	01 d0                	add    %edx,%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4f:	01 c2                	add    %eax,%edx
  800f51:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	01 c8                	add    %ecx,%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f63:	01 c2                	add    %eax,%edx
  800f65:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f68:	88 02                	mov    %al,(%edx)
		start++ ;
  800f6a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f6d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f73:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f76:	7c c4                	jl     800f3c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f78:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7e:	01 d0                	add    %edx,%eax
  800f80:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f83:	90                   	nop
  800f84:	c9                   	leave  
  800f85:	c3                   	ret    

00800f86 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f8c:	ff 75 08             	pushl  0x8(%ebp)
  800f8f:	e8 54 fa ff ff       	call   8009e8 <strlen>
  800f94:	83 c4 04             	add    $0x4,%esp
  800f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f9a:	ff 75 0c             	pushl  0xc(%ebp)
  800f9d:	e8 46 fa ff ff       	call   8009e8 <strlen>
  800fa2:	83 c4 04             	add    $0x4,%esp
  800fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fa8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800faf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fb6:	eb 17                	jmp    800fcf <strcconcat+0x49>
		final[s] = str1[s] ;
  800fb8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbe:	01 c2                	add    %eax,%edx
  800fc0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	01 c8                	add    %ecx,%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fcc:	ff 45 fc             	incl   -0x4(%ebp)
  800fcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fd5:	7c e1                	jl     800fb8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fd7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fde:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fe5:	eb 1f                	jmp    801006 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fe7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fea:	8d 50 01             	lea    0x1(%eax),%edx
  800fed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ff0:	89 c2                	mov    %eax,%edx
  800ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff5:	01 c2                	add    %eax,%edx
  800ff7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	01 c8                	add    %ecx,%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801003:	ff 45 f8             	incl   -0x8(%ebp)
  801006:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801009:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80100c:	7c d9                	jl     800fe7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80100e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801011:	8b 45 10             	mov    0x10(%ebp),%eax
  801014:	01 d0                	add    %edx,%eax
  801016:	c6 00 00             	movb   $0x0,(%eax)
}
  801019:	90                   	nop
  80101a:	c9                   	leave  
  80101b:	c3                   	ret    

0080101c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80101f:	8b 45 14             	mov    0x14(%ebp),%eax
  801022:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801028:	8b 45 14             	mov    0x14(%ebp),%eax
  80102b:	8b 00                	mov    (%eax),%eax
  80102d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801034:	8b 45 10             	mov    0x10(%ebp),%eax
  801037:	01 d0                	add    %edx,%eax
  801039:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80103f:	eb 0c                	jmp    80104d <strsplit+0x31>
			*string++ = 0;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8d 50 01             	lea    0x1(%eax),%edx
  801047:	89 55 08             	mov    %edx,0x8(%ebp)
  80104a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	84 c0                	test   %al,%al
  801054:	74 18                	je     80106e <strsplit+0x52>
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8a 00                	mov    (%eax),%al
  80105b:	0f be c0             	movsbl %al,%eax
  80105e:	50                   	push   %eax
  80105f:	ff 75 0c             	pushl  0xc(%ebp)
  801062:	e8 13 fb ff ff       	call   800b7a <strchr>
  801067:	83 c4 08             	add    $0x8,%esp
  80106a:	85 c0                	test   %eax,%eax
  80106c:	75 d3                	jne    801041 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	84 c0                	test   %al,%al
  801075:	74 5a                	je     8010d1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801077:	8b 45 14             	mov    0x14(%ebp),%eax
  80107a:	8b 00                	mov    (%eax),%eax
  80107c:	83 f8 0f             	cmp    $0xf,%eax
  80107f:	75 07                	jne    801088 <strsplit+0x6c>
		{
			return 0;
  801081:	b8 00 00 00 00       	mov    $0x0,%eax
  801086:	eb 66                	jmp    8010ee <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801088:	8b 45 14             	mov    0x14(%ebp),%eax
  80108b:	8b 00                	mov    (%eax),%eax
  80108d:	8d 48 01             	lea    0x1(%eax),%ecx
  801090:	8b 55 14             	mov    0x14(%ebp),%edx
  801093:	89 0a                	mov    %ecx,(%edx)
  801095:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80109c:	8b 45 10             	mov    0x10(%ebp),%eax
  80109f:	01 c2                	add    %eax,%edx
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010a6:	eb 03                	jmp    8010ab <strsplit+0x8f>
			string++;
  8010a8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	84 c0                	test   %al,%al
  8010b2:	74 8b                	je     80103f <strsplit+0x23>
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	0f be c0             	movsbl %al,%eax
  8010bc:	50                   	push   %eax
  8010bd:	ff 75 0c             	pushl  0xc(%ebp)
  8010c0:	e8 b5 fa ff ff       	call   800b7a <strchr>
  8010c5:	83 c4 08             	add    $0x8,%esp
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	74 dc                	je     8010a8 <strsplit+0x8c>
			string++;
	}
  8010cc:	e9 6e ff ff ff       	jmp    80103f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010d1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d5:	8b 00                	mov    (%eax),%eax
  8010d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010de:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e1:	01 d0                	add    %edx,%eax
  8010e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL){
  8010f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f7:	75 3a                	jne    801133 <str2lower+0x43>
	return NULL;
  8010f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fe:	eb 3f                	jmp    80113f <str2lower+0x4f>
	}
	while(*src!='\0'){
		if(*src>=65&&*src<=90){
  801100:	8b 45 0c             	mov    0xc(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	3c 40                	cmp    $0x40,%al
  801107:	7e 1a                	jle    801123 <str2lower+0x33>
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	8a 00                	mov    (%eax),%al
  80110e:	3c 5a                	cmp    $0x5a,%al
  801110:	7f 11                	jg     801123 <str2lower+0x33>
			*dst=*src+32;
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	83 c0 20             	add    $0x20,%eax
  80111a:	88 c2                	mov    %al,%dl
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	88 10                	mov    %dl,(%eax)
  801121:	eb 0a                	jmp    80112d <str2lower+0x3d>
		}
		else{
			*dst=*src;
  801123:	8b 45 0c             	mov    0xc(%ebp),%eax
  801126:	8a 10                	mov    (%eax),%dl
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	88 10                	mov    %dl,(%eax)
		}
		src++;
  80112d:	ff 45 0c             	incl   0xc(%ebp)
		dst++;
  801130:	ff 45 08             	incl   0x8(%ebp)
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL){
	return NULL;
	}
	while(*src!='\0'){
  801133:	8b 45 0c             	mov    0xc(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	84 c0                	test   %al,%al
  80113a:	75 c4                	jne    801100 <str2lower+0x10>
			*dst=*src;
		}
		src++;
		dst++;
	}
	return dst;
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    

00801141 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	57                   	push   %edi
  801145:	56                   	push   %esi
  801146:	53                   	push   %ebx
  801147:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801150:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801153:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801156:	8b 7d 18             	mov    0x18(%ebp),%edi
  801159:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80115c:	cd 30                	int    $0x30
  80115e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801161:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801164:	83 c4 10             	add    $0x10,%esp
  801167:	5b                   	pop    %ebx
  801168:	5e                   	pop    %esi
  801169:	5f                   	pop    %edi
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    

0080116c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 04             	sub    $0x4,%esp
  801172:	8b 45 10             	mov    0x10(%ebp),%eax
  801175:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801178:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	6a 00                	push   $0x0
  801181:	6a 00                	push   $0x0
  801183:	52                   	push   %edx
  801184:	ff 75 0c             	pushl  0xc(%ebp)
  801187:	50                   	push   %eax
  801188:	6a 00                	push   $0x0
  80118a:	e8 b2 ff ff ff       	call   801141 <syscall>
  80118f:	83 c4 18             	add    $0x18,%esp
}
  801192:	90                   	nop
  801193:	c9                   	leave  
  801194:	c3                   	ret    

00801195 <sys_cgetc>:

int
sys_cgetc(void)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801198:	6a 00                	push   $0x0
  80119a:	6a 00                	push   $0x0
  80119c:	6a 00                	push   $0x0
  80119e:	6a 00                	push   $0x0
  8011a0:	6a 00                	push   $0x0
  8011a2:	6a 01                	push   $0x1
  8011a4:	e8 98 ff ff ff       	call   801141 <syscall>
  8011a9:	83 c4 18             	add    $0x18,%esp
}
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8011b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	6a 00                	push   $0x0
  8011b9:	6a 00                	push   $0x0
  8011bb:	6a 00                	push   $0x0
  8011bd:	52                   	push   %edx
  8011be:	50                   	push   %eax
  8011bf:	6a 05                	push   $0x5
  8011c1:	e8 7b ff ff ff       	call   801141 <syscall>
  8011c6:	83 c4 18             	add    $0x18,%esp
}
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    

008011cb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	56                   	push   %esi
  8011cf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8011d0:	8b 75 18             	mov    0x18(%ebp),%esi
  8011d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	56                   	push   %esi
  8011e0:	53                   	push   %ebx
  8011e1:	51                   	push   %ecx
  8011e2:	52                   	push   %edx
  8011e3:	50                   	push   %eax
  8011e4:	6a 06                	push   $0x6
  8011e6:	e8 56 ff ff ff       	call   801141 <syscall>
  8011eb:	83 c4 18             	add    $0x18,%esp
}
  8011ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011f1:	5b                   	pop    %ebx
  8011f2:	5e                   	pop    %esi
  8011f3:	5d                   	pop    %ebp
  8011f4:	c3                   	ret    

008011f5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8011f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	6a 00                	push   $0x0
  801200:	6a 00                	push   $0x0
  801202:	6a 00                	push   $0x0
  801204:	52                   	push   %edx
  801205:	50                   	push   %eax
  801206:	6a 07                	push   $0x7
  801208:	e8 34 ff ff ff       	call   801141 <syscall>
  80120d:	83 c4 18             	add    $0x18,%esp
}
  801210:	c9                   	leave  
  801211:	c3                   	ret    

00801212 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801215:	6a 00                	push   $0x0
  801217:	6a 00                	push   $0x0
  801219:	6a 00                	push   $0x0
  80121b:	ff 75 0c             	pushl  0xc(%ebp)
  80121e:	ff 75 08             	pushl  0x8(%ebp)
  801221:	6a 08                	push   $0x8
  801223:	e8 19 ff ff ff       	call   801141 <syscall>
  801228:	83 c4 18             	add    $0x18,%esp
}
  80122b:	c9                   	leave  
  80122c:	c3                   	ret    

0080122d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801230:	6a 00                	push   $0x0
  801232:	6a 00                	push   $0x0
  801234:	6a 00                	push   $0x0
  801236:	6a 00                	push   $0x0
  801238:	6a 00                	push   $0x0
  80123a:	6a 09                	push   $0x9
  80123c:	e8 00 ff ff ff       	call   801141 <syscall>
  801241:	83 c4 18             	add    $0x18,%esp
}
  801244:	c9                   	leave  
  801245:	c3                   	ret    

00801246 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801249:	6a 00                	push   $0x0
  80124b:	6a 00                	push   $0x0
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	6a 0a                	push   $0xa
  801255:	e8 e7 fe ff ff       	call   801141 <syscall>
  80125a:	83 c4 18             	add    $0x18,%esp
}
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 00                	push   $0x0
  80126a:	6a 00                	push   $0x0
  80126c:	6a 0b                	push   $0xb
  80126e:	e8 ce fe ff ff       	call   801141 <syscall>
  801273:	83 c4 18             	add    $0x18,%esp
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	6a 0c                	push   $0xc
  801287:	e8 b5 fe ff ff       	call   801141 <syscall>
  80128c:	83 c4 18             	add    $0x18,%esp
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801294:	6a 00                	push   $0x0
  801296:	6a 00                	push   $0x0
  801298:	6a 00                	push   $0x0
  80129a:	6a 00                	push   $0x0
  80129c:	ff 75 08             	pushl  0x8(%ebp)
  80129f:	6a 0d                	push   $0xd
  8012a1:	e8 9b fe ff ff       	call   801141 <syscall>
  8012a6:	83 c4 18             	add    $0x18,%esp
}
  8012a9:	c9                   	leave  
  8012aa:	c3                   	ret    

008012ab <sys_scarce_memory>:

void sys_scarce_memory()
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8012ae:	6a 00                	push   $0x0
  8012b0:	6a 00                	push   $0x0
  8012b2:	6a 00                	push   $0x0
  8012b4:	6a 00                	push   $0x0
  8012b6:	6a 00                	push   $0x0
  8012b8:	6a 0e                	push   $0xe
  8012ba:	e8 82 fe ff ff       	call   801141 <syscall>
  8012bf:	83 c4 18             	add    $0x18,%esp
}
  8012c2:	90                   	nop
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

008012c5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8012c8:	6a 00                	push   $0x0
  8012ca:	6a 00                	push   $0x0
  8012cc:	6a 00                	push   $0x0
  8012ce:	6a 00                	push   $0x0
  8012d0:	6a 00                	push   $0x0
  8012d2:	6a 11                	push   $0x11
  8012d4:	e8 68 fe ff ff       	call   801141 <syscall>
  8012d9:	83 c4 18             	add    $0x18,%esp
}
  8012dc:	90                   	nop
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 00                	push   $0x0
  8012e6:	6a 00                	push   $0x0
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 12                	push   $0x12
  8012ee:	e8 4e fe ff ff       	call   801141 <syscall>
  8012f3:	83 c4 18             	add    $0x18,%esp
}
  8012f6:	90                   	nop
  8012f7:	c9                   	leave  
  8012f8:	c3                   	ret    

008012f9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	83 ec 04             	sub    $0x4,%esp
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801305:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	50                   	push   %eax
  801312:	6a 13                	push   $0x13
  801314:	e8 28 fe ff ff       	call   801141 <syscall>
  801319:	83 c4 18             	add    $0x18,%esp
}
  80131c:	90                   	nop
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 14                	push   $0x14
  80132e:	e8 0e fe ff ff       	call   801141 <syscall>
  801333:	83 c4 18             	add    $0x18,%esp
}
  801336:	90                   	nop
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	ff 75 0c             	pushl  0xc(%ebp)
  801348:	50                   	push   %eax
  801349:	6a 15                	push   $0x15
  80134b:	e8 f1 fd ff ff       	call   801141 <syscall>
  801350:	83 c4 18             	add    $0x18,%esp
}
  801353:	c9                   	leave  
  801354:	c3                   	ret    

00801355 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801358:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	52                   	push   %edx
  801365:	50                   	push   %eax
  801366:	6a 18                	push   $0x18
  801368:	e8 d4 fd ff ff       	call   801141 <syscall>
  80136d:	83 c4 18             	add    $0x18,%esp
}
  801370:	c9                   	leave  
  801371:	c3                   	ret    

00801372 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801375:	8b 55 0c             	mov    0xc(%ebp),%edx
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	52                   	push   %edx
  801382:	50                   	push   %eax
  801383:	6a 16                	push   $0x16
  801385:	e8 b7 fd ff ff       	call   801141 <syscall>
  80138a:	83 c4 18             	add    $0x18,%esp
}
  80138d:	90                   	nop
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    

00801390 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801393:	8b 55 0c             	mov    0xc(%ebp),%edx
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	52                   	push   %edx
  8013a0:	50                   	push   %eax
  8013a1:	6a 17                	push   $0x17
  8013a3:	e8 99 fd ff ff       	call   801141 <syscall>
  8013a8:	83 c4 18             	add    $0x18,%esp
}
  8013ab:	90                   	nop
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	83 ec 04             	sub    $0x4,%esp
  8013b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013ba:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013bd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	6a 00                	push   $0x0
  8013c6:	51                   	push   %ecx
  8013c7:	52                   	push   %edx
  8013c8:	ff 75 0c             	pushl  0xc(%ebp)
  8013cb:	50                   	push   %eax
  8013cc:	6a 19                	push   $0x19
  8013ce:	e8 6e fd ff ff       	call   801141 <syscall>
  8013d3:	83 c4 18             	add    $0x18,%esp
}
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    

008013d8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8013db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	52                   	push   %edx
  8013e8:	50                   	push   %eax
  8013e9:	6a 1a                	push   $0x1a
  8013eb:	e8 51 fd ff ff       	call   801141 <syscall>
  8013f0:	83 c4 18             	add    $0x18,%esp
}
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8013f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	51                   	push   %ecx
  801406:	52                   	push   %edx
  801407:	50                   	push   %eax
  801408:	6a 1b                	push   $0x1b
  80140a:	e8 32 fd ff ff       	call   801141 <syscall>
  80140f:	83 c4 18             	add    $0x18,%esp
}
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801417:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	52                   	push   %edx
  801424:	50                   	push   %eax
  801425:	6a 1c                	push   $0x1c
  801427:	e8 15 fd ff ff       	call   801141 <syscall>
  80142c:	83 c4 18             	add    $0x18,%esp
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 1d                	push   $0x1d
  801440:	e8 fc fc ff ff       	call   801141 <syscall>
  801445:	83 c4 18             	add    $0x18,%esp
}
  801448:	c9                   	leave  
  801449:	c3                   	ret    

0080144a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	6a 00                	push   $0x0
  801452:	ff 75 14             	pushl  0x14(%ebp)
  801455:	ff 75 10             	pushl  0x10(%ebp)
  801458:	ff 75 0c             	pushl  0xc(%ebp)
  80145b:	50                   	push   %eax
  80145c:	6a 1e                	push   $0x1e
  80145e:	e8 de fc ff ff       	call   801141 <syscall>
  801463:	83 c4 18             	add    $0x18,%esp
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	50                   	push   %eax
  801477:	6a 1f                	push   $0x1f
  801479:	e8 c3 fc ff ff       	call   801141 <syscall>
  80147e:	83 c4 18             	add    $0x18,%esp
}
  801481:	90                   	nop
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	50                   	push   %eax
  801493:	6a 20                	push   $0x20
  801495:	e8 a7 fc ff ff       	call   801141 <syscall>
  80149a:	83 c4 18             	add    $0x18,%esp
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 02                	push   $0x2
  8014ae:	e8 8e fc ff ff       	call   801141 <syscall>
  8014b3:	83 c4 18             	add    $0x18,%esp
}
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 03                	push   $0x3
  8014c7:	e8 75 fc ff ff       	call   801141 <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 04                	push   $0x4
  8014e0:	e8 5c fc ff ff       	call   801141 <syscall>
  8014e5:	83 c4 18             	add    $0x18,%esp
}
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <sys_exit_env>:


void sys_exit_env(void)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 21                	push   $0x21
  8014f9:	e8 43 fc ff ff       	call   801141 <syscall>
  8014fe:	83 c4 18             	add    $0x18,%esp
}
  801501:	90                   	nop
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80150a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80150d:	8d 50 04             	lea    0x4(%eax),%edx
  801510:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	52                   	push   %edx
  80151a:	50                   	push   %eax
  80151b:	6a 22                	push   $0x22
  80151d:	e8 1f fc ff ff       	call   801141 <syscall>
  801522:	83 c4 18             	add    $0x18,%esp
	return result;
  801525:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801528:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80152e:	89 01                	mov    %eax,(%ecx)
  801530:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	c9                   	leave  
  801537:	c2 04 00             	ret    $0x4

0080153a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	ff 75 10             	pushl  0x10(%ebp)
  801544:	ff 75 0c             	pushl  0xc(%ebp)
  801547:	ff 75 08             	pushl  0x8(%ebp)
  80154a:	6a 10                	push   $0x10
  80154c:	e8 f0 fb ff ff       	call   801141 <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
	return ;
  801554:	90                   	nop
}
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <sys_rcr2>:
uint32 sys_rcr2()
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 23                	push   $0x23
  801566:	e8 d6 fb ff ff       	call   801141 <syscall>
  80156b:	83 c4 18             	add    $0x18,%esp
}
  80156e:	c9                   	leave  
  80156f:	c3                   	ret    

00801570 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
  801579:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80157c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	50                   	push   %eax
  801589:	6a 24                	push   $0x24
  80158b:	e8 b1 fb ff ff       	call   801141 <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
	return ;
  801593:	90                   	nop
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <rsttst>:
void rsttst()
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 26                	push   $0x26
  8015a5:	e8 97 fb ff ff       	call   801141 <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ad:	90                   	nop
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 04             	sub    $0x4,%esp
  8015b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015bc:	8b 55 18             	mov    0x18(%ebp),%edx
  8015bf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015c3:	52                   	push   %edx
  8015c4:	50                   	push   %eax
  8015c5:	ff 75 10             	pushl  0x10(%ebp)
  8015c8:	ff 75 0c             	pushl  0xc(%ebp)
  8015cb:	ff 75 08             	pushl  0x8(%ebp)
  8015ce:	6a 25                	push   $0x25
  8015d0:	e8 6c fb ff ff       	call   801141 <syscall>
  8015d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d8:	90                   	nop
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <chktst>:
void chktst(uint32 n)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	ff 75 08             	pushl  0x8(%ebp)
  8015e9:	6a 27                	push   $0x27
  8015eb:	e8 51 fb ff ff       	call   801141 <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8015f3:	90                   	nop
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <inctst>:

void inctst()
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 28                	push   $0x28
  801605:	e8 37 fb ff ff       	call   801141 <syscall>
  80160a:	83 c4 18             	add    $0x18,%esp
	return ;
  80160d:	90                   	nop
}
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <gettst>:
uint32 gettst()
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 29                	push   $0x29
  80161f:	e8 1d fb ff ff       	call   801141 <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 2a                	push   $0x2a
  80163b:	e8 01 fb ff ff       	call   801141 <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
  801643:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801646:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80164a:	75 07                	jne    801653 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80164c:	b8 01 00 00 00       	mov    $0x1,%eax
  801651:	eb 05                	jmp    801658 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 2a                	push   $0x2a
  80166c:	e8 d0 fa ff ff       	call   801141 <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
  801674:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801677:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80167b:	75 07                	jne    801684 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80167d:	b8 01 00 00 00       	mov    $0x1,%eax
  801682:	eb 05                	jmp    801689 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801684:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 2a                	push   $0x2a
  80169d:	e8 9f fa ff ff       	call   801141 <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
  8016a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016a8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016ac:	75 07                	jne    8016b5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8016b3:	eb 05                	jmp    8016ba <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 2a                	push   $0x2a
  8016ce:	e8 6e fa ff ff       	call   801141 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
  8016d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8016d9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8016dd:	75 07                	jne    8016e6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8016df:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e4:	eb 05                	jmp    8016eb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	6a 2b                	push   $0x2b
  8016fd:	e8 3f fa ff ff       	call   801141 <syscall>
  801702:	83 c4 18             	add    $0x18,%esp
	return ;
  801705:	90                   	nop
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80170c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80170f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801712:	8b 55 0c             	mov    0xc(%ebp),%edx
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	6a 00                	push   $0x0
  80171a:	53                   	push   %ebx
  80171b:	51                   	push   %ecx
  80171c:	52                   	push   %edx
  80171d:	50                   	push   %eax
  80171e:	6a 2c                	push   $0x2c
  801720:	e8 1c fa ff ff       	call   801141 <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801730:	8b 55 0c             	mov    0xc(%ebp),%edx
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	52                   	push   %edx
  80173d:	50                   	push   %eax
  80173e:	6a 2d                	push   $0x2d
  801740:	e8 fc f9 ff ff       	call   801141 <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80174d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801750:	8b 55 0c             	mov    0xc(%ebp),%edx
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	6a 00                	push   $0x0
  801758:	51                   	push   %ecx
  801759:	ff 75 10             	pushl  0x10(%ebp)
  80175c:	52                   	push   %edx
  80175d:	50                   	push   %eax
  80175e:	6a 2e                	push   $0x2e
  801760:	e8 dc f9 ff ff       	call   801141 <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	ff 75 10             	pushl  0x10(%ebp)
  801774:	ff 75 0c             	pushl  0xc(%ebp)
  801777:	ff 75 08             	pushl  0x8(%ebp)
  80177a:	6a 0f                	push   $0xf
  80177c:	e8 c0 f9 ff ff       	call   801141 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
	return ;
  801784:	90                   	nop
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	68 d0 21 80 00       	push   $0x8021d0
  801795:	68 54 01 00 00       	push   $0x154
  80179a:	68 e4 21 80 00       	push   $0x8021e4
  80179f:	e8 ee 00 00 00       	call   801892 <_panic>

008017a4 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	68 d0 21 80 00       	push   $0x8021d0
  8017b2:	68 5b 01 00 00       	push   $0x15b
  8017b7:	68 e4 21 80 00       	push   $0x8021e4
  8017bc:	e8 d1 00 00 00       	call   801892 <_panic>

008017c1 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8017c7:	83 ec 04             	sub    $0x4,%esp
  8017ca:	68 d0 21 80 00       	push   $0x8021d0
  8017cf:	68 61 01 00 00       	push   $0x161
  8017d4:	68 e4 21 80 00       	push   $0x8021e4
  8017d9:	e8 b4 00 00 00       	call   801892 <_panic>

008017de <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8017e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e7:	89 d0                	mov    %edx,%eax
  8017e9:	c1 e0 02             	shl    $0x2,%eax
  8017ec:	01 d0                	add    %edx,%eax
  8017ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017f5:	01 d0                	add    %edx,%eax
  8017f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017fe:	01 d0                	add    %edx,%eax
  801800:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801807:	01 d0                	add    %edx,%eax
  801809:	c1 e0 04             	shl    $0x4,%eax
  80180c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80180f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801816:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801819:	83 ec 0c             	sub    $0xc,%esp
  80181c:	50                   	push   %eax
  80181d:	e8 e2 fc ff ff       	call   801504 <sys_get_virtual_time>
  801822:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801825:	eb 41                	jmp    801868 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801827:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80182a:	83 ec 0c             	sub    $0xc,%esp
  80182d:	50                   	push   %eax
  80182e:	e8 d1 fc ff ff       	call   801504 <sys_get_virtual_time>
  801833:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801836:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801839:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80183c:	29 c2                	sub    %eax,%edx
  80183e:	89 d0                	mov    %edx,%eax
  801840:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801843:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801846:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801849:	89 d1                	mov    %edx,%ecx
  80184b:	29 c1                	sub    %eax,%ecx
  80184d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801850:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801853:	39 c2                	cmp    %eax,%edx
  801855:	0f 97 c0             	seta   %al
  801858:	0f b6 c0             	movzbl %al,%eax
  80185b:	29 c1                	sub    %eax,%ecx
  80185d:	89 c8                	mov    %ecx,%eax
  80185f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801862:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801865:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80186e:	72 b7                	jb     801827 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801870:	90                   	nop
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801879:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801880:	eb 03                	jmp    801885 <busy_wait+0x12>
  801882:	ff 45 fc             	incl   -0x4(%ebp)
  801885:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801888:	3b 45 08             	cmp    0x8(%ebp),%eax
  80188b:	72 f5                	jb     801882 <busy_wait+0xf>
	return i;
  80188d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801898:	8d 45 10             	lea    0x10(%ebp),%eax
  80189b:	83 c0 04             	add    $0x4,%eax
  80189e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8018a1:	a1 18 31 80 00       	mov    0x803118,%eax
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	74 16                	je     8018c0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8018aa:	a1 18 31 80 00       	mov    0x803118,%eax
  8018af:	83 ec 08             	sub    $0x8,%esp
  8018b2:	50                   	push   %eax
  8018b3:	68 f4 21 80 00       	push   $0x8021f4
  8018b8:	e8 a9 ea ff ff       	call   800366 <cprintf>
  8018bd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8018c0:	a1 00 30 80 00       	mov    0x803000,%eax
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	50                   	push   %eax
  8018cc:	68 f9 21 80 00       	push   $0x8021f9
  8018d1:	e8 90 ea ff ff       	call   800366 <cprintf>
  8018d6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8018d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e2:	50                   	push   %eax
  8018e3:	e8 13 ea ff ff       	call   8002fb <vcprintf>
  8018e8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8018eb:	83 ec 08             	sub    $0x8,%esp
  8018ee:	6a 00                	push   $0x0
  8018f0:	68 15 22 80 00       	push   $0x802215
  8018f5:	e8 01 ea ff ff       	call   8002fb <vcprintf>
  8018fa:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8018fd:	e8 82 e9 ff ff       	call   800284 <exit>

	// should not return here
	while (1) ;
  801902:	eb fe                	jmp    801902 <_panic+0x70>

00801904 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80190a:	a1 20 30 80 00       	mov    0x803020,%eax
  80190f:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  801915:	8b 45 0c             	mov    0xc(%ebp),%eax
  801918:	39 c2                	cmp    %eax,%edx
  80191a:	74 14                	je     801930 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80191c:	83 ec 04             	sub    $0x4,%esp
  80191f:	68 18 22 80 00       	push   $0x802218
  801924:	6a 26                	push   $0x26
  801926:	68 64 22 80 00       	push   $0x802264
  80192b:	e8 62 ff ff ff       	call   801892 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801930:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801937:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80193e:	e9 c5 00 00 00       	jmp    801a08 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801946:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	01 d0                	add    %edx,%eax
  801952:	8b 00                	mov    (%eax),%eax
  801954:	85 c0                	test   %eax,%eax
  801956:	75 08                	jne    801960 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801958:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80195b:	e9 a5 00 00 00       	jmp    801a05 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801960:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801967:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80196e:	eb 69                	jmp    8019d9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801970:	a1 20 30 80 00       	mov    0x803020,%eax
  801975:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  80197b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80197e:	89 d0                	mov    %edx,%eax
  801980:	01 c0                	add    %eax,%eax
  801982:	01 d0                	add    %edx,%eax
  801984:	c1 e0 03             	shl    $0x3,%eax
  801987:	01 c8                	add    %ecx,%eax
  801989:	8a 40 04             	mov    0x4(%eax),%al
  80198c:	84 c0                	test   %al,%al
  80198e:	75 46                	jne    8019d6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801990:	a1 20 30 80 00       	mov    0x803020,%eax
  801995:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  80199b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80199e:	89 d0                	mov    %edx,%eax
  8019a0:	01 c0                	add    %eax,%eax
  8019a2:	01 d0                	add    %edx,%eax
  8019a4:	c1 e0 03             	shl    $0x3,%eax
  8019a7:	01 c8                	add    %ecx,%eax
  8019a9:	8b 00                	mov    (%eax),%eax
  8019ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019b6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8019b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	01 c8                	add    %ecx,%eax
  8019c7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019c9:	39 c2                	cmp    %eax,%edx
  8019cb:	75 09                	jne    8019d6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8019cd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8019d4:	eb 15                	jmp    8019eb <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019d6:	ff 45 e8             	incl   -0x18(%ebp)
  8019d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8019de:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  8019e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019e7:	39 c2                	cmp    %eax,%edx
  8019e9:	77 85                	ja     801970 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8019eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019ef:	75 14                	jne    801a05 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8019f1:	83 ec 04             	sub    $0x4,%esp
  8019f4:	68 70 22 80 00       	push   $0x802270
  8019f9:	6a 3a                	push   $0x3a
  8019fb:	68 64 22 80 00       	push   $0x802264
  801a00:	e8 8d fe ff ff       	call   801892 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a05:	ff 45 f0             	incl   -0x10(%ebp)
  801a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a0e:	0f 8c 2f ff ff ff    	jl     801943 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a14:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a1b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a22:	eb 26                	jmp    801a4a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a24:	a1 20 30 80 00       	mov    0x803020,%eax
  801a29:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  801a2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a32:	89 d0                	mov    %edx,%eax
  801a34:	01 c0                	add    %eax,%eax
  801a36:	01 d0                	add    %edx,%eax
  801a38:	c1 e0 03             	shl    $0x3,%eax
  801a3b:	01 c8                	add    %ecx,%eax
  801a3d:	8a 40 04             	mov    0x4(%eax),%al
  801a40:	3c 01                	cmp    $0x1,%al
  801a42:	75 03                	jne    801a47 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801a44:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a47:	ff 45 e0             	incl   -0x20(%ebp)
  801a4a:	a1 20 30 80 00       	mov    0x803020,%eax
  801a4f:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  801a55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a58:	39 c2                	cmp    %eax,%edx
  801a5a:	77 c8                	ja     801a24 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a62:	74 14                	je     801a78 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801a64:	83 ec 04             	sub    $0x4,%esp
  801a67:	68 c4 22 80 00       	push   $0x8022c4
  801a6c:	6a 44                	push   $0x44
  801a6e:	68 64 22 80 00       	push   $0x802264
  801a73:	e8 1a fe ff ff       	call   801892 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a78:	90                   	nop
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    
  801a7b:	90                   	nop

00801a7c <__udivdi3>:
  801a7c:	55                   	push   %ebp
  801a7d:	57                   	push   %edi
  801a7e:	56                   	push   %esi
  801a7f:	53                   	push   %ebx
  801a80:	83 ec 1c             	sub    $0x1c,%esp
  801a83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a93:	89 ca                	mov    %ecx,%edx
  801a95:	89 f8                	mov    %edi,%eax
  801a97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a9b:	85 f6                	test   %esi,%esi
  801a9d:	75 2d                	jne    801acc <__udivdi3+0x50>
  801a9f:	39 cf                	cmp    %ecx,%edi
  801aa1:	77 65                	ja     801b08 <__udivdi3+0x8c>
  801aa3:	89 fd                	mov    %edi,%ebp
  801aa5:	85 ff                	test   %edi,%edi
  801aa7:	75 0b                	jne    801ab4 <__udivdi3+0x38>
  801aa9:	b8 01 00 00 00       	mov    $0x1,%eax
  801aae:	31 d2                	xor    %edx,%edx
  801ab0:	f7 f7                	div    %edi
  801ab2:	89 c5                	mov    %eax,%ebp
  801ab4:	31 d2                	xor    %edx,%edx
  801ab6:	89 c8                	mov    %ecx,%eax
  801ab8:	f7 f5                	div    %ebp
  801aba:	89 c1                	mov    %eax,%ecx
  801abc:	89 d8                	mov    %ebx,%eax
  801abe:	f7 f5                	div    %ebp
  801ac0:	89 cf                	mov    %ecx,%edi
  801ac2:	89 fa                	mov    %edi,%edx
  801ac4:	83 c4 1c             	add    $0x1c,%esp
  801ac7:	5b                   	pop    %ebx
  801ac8:	5e                   	pop    %esi
  801ac9:	5f                   	pop    %edi
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    
  801acc:	39 ce                	cmp    %ecx,%esi
  801ace:	77 28                	ja     801af8 <__udivdi3+0x7c>
  801ad0:	0f bd fe             	bsr    %esi,%edi
  801ad3:	83 f7 1f             	xor    $0x1f,%edi
  801ad6:	75 40                	jne    801b18 <__udivdi3+0x9c>
  801ad8:	39 ce                	cmp    %ecx,%esi
  801ada:	72 0a                	jb     801ae6 <__udivdi3+0x6a>
  801adc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ae0:	0f 87 9e 00 00 00    	ja     801b84 <__udivdi3+0x108>
  801ae6:	b8 01 00 00 00       	mov    $0x1,%eax
  801aeb:	89 fa                	mov    %edi,%edx
  801aed:	83 c4 1c             	add    $0x1c,%esp
  801af0:	5b                   	pop    %ebx
  801af1:	5e                   	pop    %esi
  801af2:	5f                   	pop    %edi
  801af3:	5d                   	pop    %ebp
  801af4:	c3                   	ret    
  801af5:	8d 76 00             	lea    0x0(%esi),%esi
  801af8:	31 ff                	xor    %edi,%edi
  801afa:	31 c0                	xor    %eax,%eax
  801afc:	89 fa                	mov    %edi,%edx
  801afe:	83 c4 1c             	add    $0x1c,%esp
  801b01:	5b                   	pop    %ebx
  801b02:	5e                   	pop    %esi
  801b03:	5f                   	pop    %edi
  801b04:	5d                   	pop    %ebp
  801b05:	c3                   	ret    
  801b06:	66 90                	xchg   %ax,%ax
  801b08:	89 d8                	mov    %ebx,%eax
  801b0a:	f7 f7                	div    %edi
  801b0c:	31 ff                	xor    %edi,%edi
  801b0e:	89 fa                	mov    %edi,%edx
  801b10:	83 c4 1c             	add    $0x1c,%esp
  801b13:	5b                   	pop    %ebx
  801b14:	5e                   	pop    %esi
  801b15:	5f                   	pop    %edi
  801b16:	5d                   	pop    %ebp
  801b17:	c3                   	ret    
  801b18:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b1d:	89 eb                	mov    %ebp,%ebx
  801b1f:	29 fb                	sub    %edi,%ebx
  801b21:	89 f9                	mov    %edi,%ecx
  801b23:	d3 e6                	shl    %cl,%esi
  801b25:	89 c5                	mov    %eax,%ebp
  801b27:	88 d9                	mov    %bl,%cl
  801b29:	d3 ed                	shr    %cl,%ebp
  801b2b:	89 e9                	mov    %ebp,%ecx
  801b2d:	09 f1                	or     %esi,%ecx
  801b2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b33:	89 f9                	mov    %edi,%ecx
  801b35:	d3 e0                	shl    %cl,%eax
  801b37:	89 c5                	mov    %eax,%ebp
  801b39:	89 d6                	mov    %edx,%esi
  801b3b:	88 d9                	mov    %bl,%cl
  801b3d:	d3 ee                	shr    %cl,%esi
  801b3f:	89 f9                	mov    %edi,%ecx
  801b41:	d3 e2                	shl    %cl,%edx
  801b43:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b47:	88 d9                	mov    %bl,%cl
  801b49:	d3 e8                	shr    %cl,%eax
  801b4b:	09 c2                	or     %eax,%edx
  801b4d:	89 d0                	mov    %edx,%eax
  801b4f:	89 f2                	mov    %esi,%edx
  801b51:	f7 74 24 0c          	divl   0xc(%esp)
  801b55:	89 d6                	mov    %edx,%esi
  801b57:	89 c3                	mov    %eax,%ebx
  801b59:	f7 e5                	mul    %ebp
  801b5b:	39 d6                	cmp    %edx,%esi
  801b5d:	72 19                	jb     801b78 <__udivdi3+0xfc>
  801b5f:	74 0b                	je     801b6c <__udivdi3+0xf0>
  801b61:	89 d8                	mov    %ebx,%eax
  801b63:	31 ff                	xor    %edi,%edi
  801b65:	e9 58 ff ff ff       	jmp    801ac2 <__udivdi3+0x46>
  801b6a:	66 90                	xchg   %ax,%ax
  801b6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b70:	89 f9                	mov    %edi,%ecx
  801b72:	d3 e2                	shl    %cl,%edx
  801b74:	39 c2                	cmp    %eax,%edx
  801b76:	73 e9                	jae    801b61 <__udivdi3+0xe5>
  801b78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b7b:	31 ff                	xor    %edi,%edi
  801b7d:	e9 40 ff ff ff       	jmp    801ac2 <__udivdi3+0x46>
  801b82:	66 90                	xchg   %ax,%ax
  801b84:	31 c0                	xor    %eax,%eax
  801b86:	e9 37 ff ff ff       	jmp    801ac2 <__udivdi3+0x46>
  801b8b:	90                   	nop

00801b8c <__umoddi3>:
  801b8c:	55                   	push   %ebp
  801b8d:	57                   	push   %edi
  801b8e:	56                   	push   %esi
  801b8f:	53                   	push   %ebx
  801b90:	83 ec 1c             	sub    $0x1c,%esp
  801b93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b97:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ba3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ba7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bab:	89 f3                	mov    %esi,%ebx
  801bad:	89 fa                	mov    %edi,%edx
  801baf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bb3:	89 34 24             	mov    %esi,(%esp)
  801bb6:	85 c0                	test   %eax,%eax
  801bb8:	75 1a                	jne    801bd4 <__umoddi3+0x48>
  801bba:	39 f7                	cmp    %esi,%edi
  801bbc:	0f 86 a2 00 00 00    	jbe    801c64 <__umoddi3+0xd8>
  801bc2:	89 c8                	mov    %ecx,%eax
  801bc4:	89 f2                	mov    %esi,%edx
  801bc6:	f7 f7                	div    %edi
  801bc8:	89 d0                	mov    %edx,%eax
  801bca:	31 d2                	xor    %edx,%edx
  801bcc:	83 c4 1c             	add    $0x1c,%esp
  801bcf:	5b                   	pop    %ebx
  801bd0:	5e                   	pop    %esi
  801bd1:	5f                   	pop    %edi
  801bd2:	5d                   	pop    %ebp
  801bd3:	c3                   	ret    
  801bd4:	39 f0                	cmp    %esi,%eax
  801bd6:	0f 87 ac 00 00 00    	ja     801c88 <__umoddi3+0xfc>
  801bdc:	0f bd e8             	bsr    %eax,%ebp
  801bdf:	83 f5 1f             	xor    $0x1f,%ebp
  801be2:	0f 84 ac 00 00 00    	je     801c94 <__umoddi3+0x108>
  801be8:	bf 20 00 00 00       	mov    $0x20,%edi
  801bed:	29 ef                	sub    %ebp,%edi
  801bef:	89 fe                	mov    %edi,%esi
  801bf1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bf5:	89 e9                	mov    %ebp,%ecx
  801bf7:	d3 e0                	shl    %cl,%eax
  801bf9:	89 d7                	mov    %edx,%edi
  801bfb:	89 f1                	mov    %esi,%ecx
  801bfd:	d3 ef                	shr    %cl,%edi
  801bff:	09 c7                	or     %eax,%edi
  801c01:	89 e9                	mov    %ebp,%ecx
  801c03:	d3 e2                	shl    %cl,%edx
  801c05:	89 14 24             	mov    %edx,(%esp)
  801c08:	89 d8                	mov    %ebx,%eax
  801c0a:	d3 e0                	shl    %cl,%eax
  801c0c:	89 c2                	mov    %eax,%edx
  801c0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c12:	d3 e0                	shl    %cl,%eax
  801c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c18:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c1c:	89 f1                	mov    %esi,%ecx
  801c1e:	d3 e8                	shr    %cl,%eax
  801c20:	09 d0                	or     %edx,%eax
  801c22:	d3 eb                	shr    %cl,%ebx
  801c24:	89 da                	mov    %ebx,%edx
  801c26:	f7 f7                	div    %edi
  801c28:	89 d3                	mov    %edx,%ebx
  801c2a:	f7 24 24             	mull   (%esp)
  801c2d:	89 c6                	mov    %eax,%esi
  801c2f:	89 d1                	mov    %edx,%ecx
  801c31:	39 d3                	cmp    %edx,%ebx
  801c33:	0f 82 87 00 00 00    	jb     801cc0 <__umoddi3+0x134>
  801c39:	0f 84 91 00 00 00    	je     801cd0 <__umoddi3+0x144>
  801c3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c43:	29 f2                	sub    %esi,%edx
  801c45:	19 cb                	sbb    %ecx,%ebx
  801c47:	89 d8                	mov    %ebx,%eax
  801c49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c4d:	d3 e0                	shl    %cl,%eax
  801c4f:	89 e9                	mov    %ebp,%ecx
  801c51:	d3 ea                	shr    %cl,%edx
  801c53:	09 d0                	or     %edx,%eax
  801c55:	89 e9                	mov    %ebp,%ecx
  801c57:	d3 eb                	shr    %cl,%ebx
  801c59:	89 da                	mov    %ebx,%edx
  801c5b:	83 c4 1c             	add    $0x1c,%esp
  801c5e:	5b                   	pop    %ebx
  801c5f:	5e                   	pop    %esi
  801c60:	5f                   	pop    %edi
  801c61:	5d                   	pop    %ebp
  801c62:	c3                   	ret    
  801c63:	90                   	nop
  801c64:	89 fd                	mov    %edi,%ebp
  801c66:	85 ff                	test   %edi,%edi
  801c68:	75 0b                	jne    801c75 <__umoddi3+0xe9>
  801c6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6f:	31 d2                	xor    %edx,%edx
  801c71:	f7 f7                	div    %edi
  801c73:	89 c5                	mov    %eax,%ebp
  801c75:	89 f0                	mov    %esi,%eax
  801c77:	31 d2                	xor    %edx,%edx
  801c79:	f7 f5                	div    %ebp
  801c7b:	89 c8                	mov    %ecx,%eax
  801c7d:	f7 f5                	div    %ebp
  801c7f:	89 d0                	mov    %edx,%eax
  801c81:	e9 44 ff ff ff       	jmp    801bca <__umoddi3+0x3e>
  801c86:	66 90                	xchg   %ax,%ax
  801c88:	89 c8                	mov    %ecx,%eax
  801c8a:	89 f2                	mov    %esi,%edx
  801c8c:	83 c4 1c             	add    $0x1c,%esp
  801c8f:	5b                   	pop    %ebx
  801c90:	5e                   	pop    %esi
  801c91:	5f                   	pop    %edi
  801c92:	5d                   	pop    %ebp
  801c93:	c3                   	ret    
  801c94:	3b 04 24             	cmp    (%esp),%eax
  801c97:	72 06                	jb     801c9f <__umoddi3+0x113>
  801c99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c9d:	77 0f                	ja     801cae <__umoddi3+0x122>
  801c9f:	89 f2                	mov    %esi,%edx
  801ca1:	29 f9                	sub    %edi,%ecx
  801ca3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ca7:	89 14 24             	mov    %edx,(%esp)
  801caa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cae:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cb2:	8b 14 24             	mov    (%esp),%edx
  801cb5:	83 c4 1c             	add    $0x1c,%esp
  801cb8:	5b                   	pop    %ebx
  801cb9:	5e                   	pop    %esi
  801cba:	5f                   	pop    %edi
  801cbb:	5d                   	pop    %ebp
  801cbc:	c3                   	ret    
  801cbd:	8d 76 00             	lea    0x0(%esi),%esi
  801cc0:	2b 04 24             	sub    (%esp),%eax
  801cc3:	19 fa                	sbb    %edi,%edx
  801cc5:	89 d1                	mov    %edx,%ecx
  801cc7:	89 c6                	mov    %eax,%esi
  801cc9:	e9 71 ff ff ff       	jmp    801c3f <__umoddi3+0xb3>
  801cce:	66 90                	xchg   %ax,%ax
  801cd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cd4:	72 ea                	jb     801cc0 <__umoddi3+0x134>
  801cd6:	89 d9                	mov    %ebx,%ecx
  801cd8:	e9 62 ff ff ff       	jmp    801c3f <__umoddi3+0xb3>
