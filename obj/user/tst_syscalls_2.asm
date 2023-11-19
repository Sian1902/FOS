
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
  80003e:	e8 75 15 00 00       	call   8015b8 <rsttst>
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
  800069:	68 20 1b 80 00       	push   $0x801b20
  80006e:	e8 f9 13 00 00       	call   80146c <sys_create_env>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_run_env(ID1);
  800079:	83 ec 0c             	sub    $0xc,%esp
  80007c:	ff 75 f4             	pushl  -0xc(%ebp)
  80007f:	e8 06 14 00 00       	call   80148a <sys_run_env>
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
  8000ad:	68 2c 1b 80 00       	push   $0x801b2c
  8000b2:	e8 b5 13 00 00       	call   80146c <sys_create_env>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID2);
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000c3:	e8 c2 13 00 00       	call   80148a <sys_run_env>
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
  8000f1:	68 38 1b 80 00       	push   $0x801b38
  8000f6:	e8 71 13 00 00       	call   80146c <sys_create_env>
  8000fb:	83 c4 10             	add    $0x10,%esp
  8000fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_run_env(ID3);
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	ff 75 ec             	pushl  -0x14(%ebp)
  800107:	e8 7e 13 00 00       	call   80148a <sys_run_env>
  80010c:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 10 27 00 00       	push   $0x2710
  800117:	e8 e0 16 00 00       	call   8017fc <env_sleep>
  80011c:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  80011f:	e8 0e 15 00 00       	call   801632 <gettst>
  800124:	85 c0                	test   %eax,%eax
  800126:	74 12                	je     80013a <_main+0x102>
		cprintf("\ntst_syscalls_2 Failed.\n");
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	68 44 1b 80 00       	push   $0x801b44
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
  80013d:	68 60 1b 80 00       	push   $0x801b60
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
  800153:	e8 82 13 00 00       	call   8014da <sys_getenvindex>
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
  8001c7:	e8 1b 11 00 00       	call   8012e7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	68 b8 1b 80 00       	push   $0x801bb8
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
  8001f7:	68 e0 1b 80 00       	push   $0x801be0
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
  800228:	68 08 1c 80 00       	push   $0x801c08
  80022d:	e8 34 01 00 00       	call   800366 <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800235:	a1 20 30 80 00       	mov    0x803020,%eax
  80023a:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  800240:	83 ec 08             	sub    $0x8,%esp
  800243:	50                   	push   %eax
  800244:	68 60 1c 80 00       	push   $0x801c60
  800249:	e8 18 01 00 00       	call   800366 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800251:	83 ec 0c             	sub    $0xc,%esp
  800254:	68 b8 1b 80 00       	push   $0x801bb8
  800259:	e8 08 01 00 00       	call   800366 <cprintf>
  80025e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800261:	e8 9b 10 00 00       	call   801301 <sys_enable_interrupt>

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
  800279:	e8 28 12 00 00       	call   8014a6 <sys_destroy_env>
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
  80028a:	e8 7d 12 00 00       	call   80150c <sys_exit_env>
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
  8002d8:	e8 b1 0e 00 00       	call   80118e <sys_cputs>
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
  80034f:	e8 3a 0e 00 00       	call   80118e <sys_cputs>
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
  800399:	e8 49 0f 00 00       	call   8012e7 <sys_disable_interrupt>
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
  8003b9:	e8 43 0f 00 00       	call   801301 <sys_enable_interrupt>
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
  800403:	e8 a8 14 00 00       	call   8018b0 <__udivdi3>
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
  800453:	e8 68 15 00 00       	call   8019c0 <__umoddi3>
  800458:	83 c4 10             	add    $0x10,%esp
  80045b:	05 94 1e 80 00       	add    $0x801e94,%eax
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
  8005ae:	8b 04 85 b8 1e 80 00 	mov    0x801eb8(,%eax,4),%eax
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
  80068f:	8b 34 9d 00 1d 80 00 	mov    0x801d00(,%ebx,4),%esi
  800696:	85 f6                	test   %esi,%esi
  800698:	75 19                	jne    8006b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80069a:	53                   	push   %ebx
  80069b:	68 a5 1e 80 00       	push   $0x801ea5
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
  8006b4:	68 ae 1e 80 00       	push   $0x801eae
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
  8006e1:	be b1 1e 80 00       	mov    $0x801eb1,%esi
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

int i=0;
void *
memset(void *v, int c, uint32 n)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	83 ec 10             	sub    $0x10,%esp


	i++;
  800bdc:	a1 28 30 80 00       	mov    0x803028,%eax
  800be1:	40                   	inc    %eax
  800be2:	a3 28 30 80 00       	mov    %eax,0x803028

	char *p;
	int m;

	p = v;
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bed:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf0:	89 45 f8             	mov    %eax,-0x8(%ebp)


	while (--m >= 0){
  800bf3:	eb 0e                	jmp    800c03 <memset+0x2d>

		*p++ = c;
  800bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf8:	8d 50 01             	lea    0x1(%eax),%edx
  800bfb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c01:	88 10                	mov    %dl,(%eax)

	p = v;
	m = n;


	while (--m >= 0){
  800c03:	ff 4d f8             	decl   -0x8(%ebp)
  800c06:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c0a:	79 e9                	jns    800bf5 <memset+0x1f>

		*p++ = c;
	}

	return v;
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c0f:	c9                   	leave  
  800c10:	c3                   	ret    

00800c11 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c23:	eb 16                	jmp    800c3b <memcpy+0x2a>
		*d++ = *s++;
  800c25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c28:	8d 50 01             	lea    0x1(%eax),%edx
  800c2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c37:	8a 12                	mov    (%edx),%dl
  800c39:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c41:	89 55 10             	mov    %edx,0x10(%ebp)
  800c44:	85 c0                	test   %eax,%eax
  800c46:	75 dd                	jne    800c25 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c65:	73 50                	jae    800cb7 <memmove+0x6a>
  800c67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6d:	01 d0                	add    %edx,%eax
  800c6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c72:	76 43                	jbe    800cb7 <memmove+0x6a>
		s += n;
  800c74:	8b 45 10             	mov    0x10(%ebp),%eax
  800c77:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c80:	eb 10                	jmp    800c92 <memmove+0x45>
			*--d = *--s;
  800c82:	ff 4d f8             	decl   -0x8(%ebp)
  800c85:	ff 4d fc             	decl   -0x4(%ebp)
  800c88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8b:	8a 10                	mov    (%eax),%dl
  800c8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c90:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c92:	8b 45 10             	mov    0x10(%ebp),%eax
  800c95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c98:	89 55 10             	mov    %edx,0x10(%ebp)
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	75 e3                	jne    800c82 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c9f:	eb 23                	jmp    800cc4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ca1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ca4:	8d 50 01             	lea    0x1(%eax),%edx
  800ca7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800caa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cad:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cb3:	8a 12                	mov    (%edx),%dl
  800cb5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cbd:	89 55 10             	mov    %edx,0x10(%ebp)
  800cc0:	85 c0                	test   %eax,%eax
  800cc2:	75 dd                	jne    800ca1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cdb:	eb 2a                	jmp    800d07 <memcmp+0x3e>
		if (*s1 != *s2)
  800cdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce0:	8a 10                	mov    (%eax),%dl
  800ce2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	38 c2                	cmp    %al,%dl
  800ce9:	74 16                	je     800d01 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	0f b6 d0             	movzbl %al,%edx
  800cf3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	0f b6 c0             	movzbl %al,%eax
  800cfb:	29 c2                	sub    %eax,%edx
  800cfd:	89 d0                	mov    %edx,%eax
  800cff:	eb 18                	jmp    800d19 <memcmp+0x50>
		s1++, s2++;
  800d01:	ff 45 fc             	incl   -0x4(%ebp)
  800d04:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d07:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d0d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d10:	85 c0                	test   %eax,%eax
  800d12:	75 c9                	jne    800cdd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d19:	c9                   	leave  
  800d1a:	c3                   	ret    

00800d1b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d21:	8b 55 08             	mov    0x8(%ebp),%edx
  800d24:	8b 45 10             	mov    0x10(%ebp),%eax
  800d27:	01 d0                	add    %edx,%eax
  800d29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d2c:	eb 15                	jmp    800d43 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	0f b6 d0             	movzbl %al,%edx
  800d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d39:	0f b6 c0             	movzbl %al,%eax
  800d3c:	39 c2                	cmp    %eax,%edx
  800d3e:	74 0d                	je     800d4d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d40:	ff 45 08             	incl   0x8(%ebp)
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d49:	72 e3                	jb     800d2e <memfind+0x13>
  800d4b:	eb 01                	jmp    800d4e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d4d:	90                   	nop
	return (void *) s;
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d67:	eb 03                	jmp    800d6c <strtol+0x19>
		s++;
  800d69:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	3c 20                	cmp    $0x20,%al
  800d73:	74 f4                	je     800d69 <strtol+0x16>
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	3c 09                	cmp    $0x9,%al
  800d7c:	74 eb                	je     800d69 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	3c 2b                	cmp    $0x2b,%al
  800d85:	75 05                	jne    800d8c <strtol+0x39>
		s++;
  800d87:	ff 45 08             	incl   0x8(%ebp)
  800d8a:	eb 13                	jmp    800d9f <strtol+0x4c>
	else if (*s == '-')
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3c 2d                	cmp    $0x2d,%al
  800d93:	75 0a                	jne    800d9f <strtol+0x4c>
		s++, neg = 1;
  800d95:	ff 45 08             	incl   0x8(%ebp)
  800d98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da3:	74 06                	je     800dab <strtol+0x58>
  800da5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800da9:	75 20                	jne    800dcb <strtol+0x78>
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	3c 30                	cmp    $0x30,%al
  800db2:	75 17                	jne    800dcb <strtol+0x78>
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	40                   	inc    %eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	3c 78                	cmp    $0x78,%al
  800dbc:	75 0d                	jne    800dcb <strtol+0x78>
		s += 2, base = 16;
  800dbe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dc2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dc9:	eb 28                	jmp    800df3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcf:	75 15                	jne    800de6 <strtol+0x93>
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	3c 30                	cmp    $0x30,%al
  800dd8:	75 0c                	jne    800de6 <strtol+0x93>
		s++, base = 8;
  800dda:	ff 45 08             	incl   0x8(%ebp)
  800ddd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800de4:	eb 0d                	jmp    800df3 <strtol+0xa0>
	else if (base == 0)
  800de6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dea:	75 07                	jne    800df3 <strtol+0xa0>
		base = 10;
  800dec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8a 00                	mov    (%eax),%al
  800df8:	3c 2f                	cmp    $0x2f,%al
  800dfa:	7e 19                	jle    800e15 <strtol+0xc2>
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	3c 39                	cmp    $0x39,%al
  800e03:	7f 10                	jg     800e15 <strtol+0xc2>
			dig = *s - '0';
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 00                	mov    (%eax),%al
  800e0a:	0f be c0             	movsbl %al,%eax
  800e0d:	83 e8 30             	sub    $0x30,%eax
  800e10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e13:	eb 42                	jmp    800e57 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8a 00                	mov    (%eax),%al
  800e1a:	3c 60                	cmp    $0x60,%al
  800e1c:	7e 19                	jle    800e37 <strtol+0xe4>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	3c 7a                	cmp    $0x7a,%al
  800e25:	7f 10                	jg     800e37 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 00                	mov    (%eax),%al
  800e2c:	0f be c0             	movsbl %al,%eax
  800e2f:	83 e8 57             	sub    $0x57,%eax
  800e32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e35:	eb 20                	jmp    800e57 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	3c 40                	cmp    $0x40,%al
  800e3e:	7e 39                	jle    800e79 <strtol+0x126>
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	3c 5a                	cmp    $0x5a,%al
  800e47:	7f 30                	jg     800e79 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	0f be c0             	movsbl %al,%eax
  800e51:	83 e8 37             	sub    $0x37,%eax
  800e54:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e5a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e5d:	7d 19                	jge    800e78 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e5f:	ff 45 08             	incl   0x8(%ebp)
  800e62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e65:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e69:	89 c2                	mov    %eax,%edx
  800e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6e:	01 d0                	add    %edx,%eax
  800e70:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e73:	e9 7b ff ff ff       	jmp    800df3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e78:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7d:	74 08                	je     800e87 <strtol+0x134>
		*endptr = (char *) s;
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	8b 55 08             	mov    0x8(%ebp),%edx
  800e85:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e87:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e8b:	74 07                	je     800e94 <strtol+0x141>
  800e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e90:	f7 d8                	neg    %eax
  800e92:	eb 03                	jmp    800e97 <strtol+0x144>
  800e94:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e97:	c9                   	leave  
  800e98:	c3                   	ret    

00800e99 <ltostr>:

void
ltostr(long value, char *str)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800ea6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ead:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800eb1:	79 13                	jns    800ec6 <ltostr+0x2d>
	{
		neg = 1;
  800eb3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800eba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ec0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ec3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ece:	99                   	cltd   
  800ecf:	f7 f9                	idiv   %ecx
  800ed1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ed4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed7:	8d 50 01             	lea    0x1(%eax),%edx
  800eda:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edd:	89 c2                	mov    %eax,%edx
  800edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee2:	01 d0                	add    %edx,%eax
  800ee4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ee7:	83 c2 30             	add    $0x30,%edx
  800eea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800eec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ef4:	f7 e9                	imul   %ecx
  800ef6:	c1 fa 02             	sar    $0x2,%edx
  800ef9:	89 c8                	mov    %ecx,%eax
  800efb:	c1 f8 1f             	sar    $0x1f,%eax
  800efe:	29 c2                	sub    %eax,%edx
  800f00:	89 d0                	mov    %edx,%eax
  800f02:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f08:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f0d:	f7 e9                	imul   %ecx
  800f0f:	c1 fa 02             	sar    $0x2,%edx
  800f12:	89 c8                	mov    %ecx,%eax
  800f14:	c1 f8 1f             	sar    $0x1f,%eax
  800f17:	29 c2                	sub    %eax,%edx
  800f19:	89 d0                	mov    %edx,%eax
  800f1b:	c1 e0 02             	shl    $0x2,%eax
  800f1e:	01 d0                	add    %edx,%eax
  800f20:	01 c0                	add    %eax,%eax
  800f22:	29 c1                	sub    %eax,%ecx
  800f24:	89 ca                	mov    %ecx,%edx
  800f26:	85 d2                	test   %edx,%edx
  800f28:	75 9c                	jne    800ec6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f34:	48                   	dec    %eax
  800f35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f38:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f3c:	74 3d                	je     800f7b <ltostr+0xe2>
		start = 1 ;
  800f3e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f45:	eb 34                	jmp    800f7b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4d:	01 d0                	add    %edx,%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	01 c2                	add    %eax,%edx
  800f5c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	01 c8                	add    %ecx,%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	01 c2                	add    %eax,%edx
  800f70:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f73:	88 02                	mov    %al,(%edx)
		start++ ;
  800f75:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f78:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f7e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f81:	7c c4                	jl     800f47 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f83:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	01 d0                	add    %edx,%eax
  800f8b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f8e:	90                   	nop
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f97:	ff 75 08             	pushl  0x8(%ebp)
  800f9a:	e8 49 fa ff ff       	call   8009e8 <strlen>
  800f9f:	83 c4 04             	add    $0x4,%esp
  800fa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fa5:	ff 75 0c             	pushl  0xc(%ebp)
  800fa8:	e8 3b fa ff ff       	call   8009e8 <strlen>
  800fad:	83 c4 04             	add    $0x4,%esp
  800fb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fc1:	eb 17                	jmp    800fda <strcconcat+0x49>
		final[s] = str1[s] ;
  800fc3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc9:	01 c2                	add    %eax,%edx
  800fcb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	01 c8                	add    %ecx,%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fd7:	ff 45 fc             	incl   -0x4(%ebp)
  800fda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fe0:	7c e1                	jl     800fc3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fe2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fe9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ff0:	eb 1f                	jmp    801011 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ff2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff5:	8d 50 01             	lea    0x1(%eax),%edx
  800ff8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ffb:	89 c2                	mov    %eax,%edx
  800ffd:	8b 45 10             	mov    0x10(%ebp),%eax
  801000:	01 c2                	add    %eax,%edx
  801002:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801005:	8b 45 0c             	mov    0xc(%ebp),%eax
  801008:	01 c8                	add    %ecx,%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80100e:	ff 45 f8             	incl   -0x8(%ebp)
  801011:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801014:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801017:	7c d9                	jl     800ff2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801019:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80101c:	8b 45 10             	mov    0x10(%ebp),%eax
  80101f:	01 d0                	add    %edx,%eax
  801021:	c6 00 00             	movb   $0x0,(%eax)
}
  801024:	90                   	nop
  801025:	c9                   	leave  
  801026:	c3                   	ret    

00801027 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80102a:	8b 45 14             	mov    0x14(%ebp),%eax
  80102d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801033:	8b 45 14             	mov    0x14(%ebp),%eax
  801036:	8b 00                	mov    (%eax),%eax
  801038:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	01 d0                	add    %edx,%eax
  801044:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80104a:	eb 0c                	jmp    801058 <strsplit+0x31>
			*string++ = 0;
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8d 50 01             	lea    0x1(%eax),%edx
  801052:	89 55 08             	mov    %edx,0x8(%ebp)
  801055:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	74 18                	je     801079 <strsplit+0x52>
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	0f be c0             	movsbl %al,%eax
  801069:	50                   	push   %eax
  80106a:	ff 75 0c             	pushl  0xc(%ebp)
  80106d:	e8 08 fb ff ff       	call   800b7a <strchr>
  801072:	83 c4 08             	add    $0x8,%esp
  801075:	85 c0                	test   %eax,%eax
  801077:	75 d3                	jne    80104c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	84 c0                	test   %al,%al
  801080:	74 5a                	je     8010dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801082:	8b 45 14             	mov    0x14(%ebp),%eax
  801085:	8b 00                	mov    (%eax),%eax
  801087:	83 f8 0f             	cmp    $0xf,%eax
  80108a:	75 07                	jne    801093 <strsplit+0x6c>
		{
			return 0;
  80108c:	b8 00 00 00 00       	mov    $0x0,%eax
  801091:	eb 66                	jmp    8010f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801093:	8b 45 14             	mov    0x14(%ebp),%eax
  801096:	8b 00                	mov    (%eax),%eax
  801098:	8d 48 01             	lea    0x1(%eax),%ecx
  80109b:	8b 55 14             	mov    0x14(%ebp),%edx
  80109e:	89 0a                	mov    %ecx,(%edx)
  8010a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010aa:	01 c2                	add    %eax,%edx
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010b1:	eb 03                	jmp    8010b6 <strsplit+0x8f>
			string++;
  8010b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	84 c0                	test   %al,%al
  8010bd:	74 8b                	je     80104a <strsplit+0x23>
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	0f be c0             	movsbl %al,%eax
  8010c7:	50                   	push   %eax
  8010c8:	ff 75 0c             	pushl  0xc(%ebp)
  8010cb:	e8 aa fa ff ff       	call   800b7a <strchr>
  8010d0:	83 c4 08             	add    $0x8,%esp
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	74 dc                	je     8010b3 <strsplit+0x8c>
			string++;
	}
  8010d7:	e9 6e ff ff ff       	jmp    80104a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e0:	8b 00                	mov    (%eax),%eax
  8010e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ec:	01 d0                	add    %edx,%eax
  8010ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010f9:	c9                   	leave  
  8010fa:	c3                   	ret    

008010fb <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  801101:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801105:	74 06                	je     80110d <str2lower+0x12>
  801107:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80110b:	75 07                	jne    801114 <str2lower+0x19>
		return NULL;
  80110d:	b8 00 00 00 00       	mov    $0x0,%eax
  801112:	eb 4d                	jmp    801161 <str2lower+0x66>
	}
	char *ref=dst;
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  80111a:	eb 33                	jmp    80114f <str2lower+0x54>
			if(*src>=65&&*src<=90){
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	3c 40                	cmp    $0x40,%al
  801123:	7e 1a                	jle    80113f <str2lower+0x44>
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	3c 5a                	cmp    $0x5a,%al
  80112c:	7f 11                	jg     80113f <str2lower+0x44>
				*dst=*src+32;
  80112e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	83 c0 20             	add    $0x20,%eax
  801136:	88 c2                	mov    %al,%dl
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	88 10                	mov    %dl,(%eax)
  80113d:	eb 0a                	jmp    801149 <str2lower+0x4e>
			}
			else{
				*dst=*src;
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	8a 10                	mov    (%eax),%dl
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	88 10                	mov    %dl,(%eax)
			}
			src++;
  801149:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  80114c:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	84 c0                	test   %al,%al
  801156:	75 c4                	jne    80111c <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  80115e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	57                   	push   %edi
  801167:	56                   	push   %esi
  801168:	53                   	push   %ebx
  801169:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801172:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801175:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801178:	8b 7d 18             	mov    0x18(%ebp),%edi
  80117b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80117e:	cd 30                	int    $0x30
  801180:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801183:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	5b                   	pop    %ebx
  80118a:	5e                   	pop    %esi
  80118b:	5f                   	pop    %edi
  80118c:	5d                   	pop    %ebp
  80118d:	c3                   	ret    

0080118e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	83 ec 04             	sub    $0x4,%esp
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80119a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	6a 00                	push   $0x0
  8011a3:	6a 00                	push   $0x0
  8011a5:	52                   	push   %edx
  8011a6:	ff 75 0c             	pushl  0xc(%ebp)
  8011a9:	50                   	push   %eax
  8011aa:	6a 00                	push   $0x0
  8011ac:	e8 b2 ff ff ff       	call   801163 <syscall>
  8011b1:	83 c4 18             	add    $0x18,%esp
}
  8011b4:	90                   	nop
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8011ba:	6a 00                	push   $0x0
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 00                	push   $0x0
  8011c0:	6a 00                	push   $0x0
  8011c2:	6a 00                	push   $0x0
  8011c4:	6a 01                	push   $0x1
  8011c6:	e8 98 ff ff ff       	call   801163 <syscall>
  8011cb:	83 c4 18             	add    $0x18,%esp
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8011d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	6a 00                	push   $0x0
  8011db:	6a 00                	push   $0x0
  8011dd:	6a 00                	push   $0x0
  8011df:	52                   	push   %edx
  8011e0:	50                   	push   %eax
  8011e1:	6a 05                	push   $0x5
  8011e3:	e8 7b ff ff ff       	call   801163 <syscall>
  8011e8:	83 c4 18             	add    $0x18,%esp
}
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	56                   	push   %esi
  8011f1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8011f2:	8b 75 18             	mov    0x18(%ebp),%esi
  8011f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	56                   	push   %esi
  801202:	53                   	push   %ebx
  801203:	51                   	push   %ecx
  801204:	52                   	push   %edx
  801205:	50                   	push   %eax
  801206:	6a 06                	push   $0x6
  801208:	e8 56 ff ff ff       	call   801163 <syscall>
  80120d:	83 c4 18             	add    $0x18,%esp
}
  801210:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801213:	5b                   	pop    %ebx
  801214:	5e                   	pop    %esi
  801215:	5d                   	pop    %ebp
  801216:	c3                   	ret    

00801217 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80121a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	6a 00                	push   $0x0
  801222:	6a 00                	push   $0x0
  801224:	6a 00                	push   $0x0
  801226:	52                   	push   %edx
  801227:	50                   	push   %eax
  801228:	6a 07                	push   $0x7
  80122a:	e8 34 ff ff ff       	call   801163 <syscall>
  80122f:	83 c4 18             	add    $0x18,%esp
}
  801232:	c9                   	leave  
  801233:	c3                   	ret    

00801234 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	ff 75 0c             	pushl  0xc(%ebp)
  801240:	ff 75 08             	pushl  0x8(%ebp)
  801243:	6a 08                	push   $0x8
  801245:	e8 19 ff ff ff       	call   801163 <syscall>
  80124a:	83 c4 18             	add    $0x18,%esp
}
  80124d:	c9                   	leave  
  80124e:	c3                   	ret    

0080124f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	6a 00                	push   $0x0
  80125c:	6a 09                	push   $0x9
  80125e:	e8 00 ff ff ff       	call   801163 <syscall>
  801263:	83 c4 18             	add    $0x18,%esp
}
  801266:	c9                   	leave  
  801267:	c3                   	ret    

00801268 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80126b:	6a 00                	push   $0x0
  80126d:	6a 00                	push   $0x0
  80126f:	6a 00                	push   $0x0
  801271:	6a 00                	push   $0x0
  801273:	6a 00                	push   $0x0
  801275:	6a 0a                	push   $0xa
  801277:	e8 e7 fe ff ff       	call   801163 <syscall>
  80127c:	83 c4 18             	add    $0x18,%esp
}
  80127f:	c9                   	leave  
  801280:	c3                   	ret    

00801281 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	6a 00                	push   $0x0
  80128a:	6a 00                	push   $0x0
  80128c:	6a 00                	push   $0x0
  80128e:	6a 0b                	push   $0xb
  801290:	e8 ce fe ff ff       	call   801163 <syscall>
  801295:	83 c4 18             	add    $0x18,%esp
}
  801298:	c9                   	leave  
  801299:	c3                   	ret    

0080129a <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80129d:	6a 00                	push   $0x0
  80129f:	6a 00                	push   $0x0
  8012a1:	6a 00                	push   $0x0
  8012a3:	6a 00                	push   $0x0
  8012a5:	6a 00                	push   $0x0
  8012a7:	6a 0c                	push   $0xc
  8012a9:	e8 b5 fe ff ff       	call   801163 <syscall>
  8012ae:	83 c4 18             	add    $0x18,%esp
}
  8012b1:	c9                   	leave  
  8012b2:	c3                   	ret    

008012b3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8012b6:	6a 00                	push   $0x0
  8012b8:	6a 00                	push   $0x0
  8012ba:	6a 00                	push   $0x0
  8012bc:	6a 00                	push   $0x0
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	6a 0d                	push   $0xd
  8012c3:	e8 9b fe ff ff       	call   801163 <syscall>
  8012c8:	83 c4 18             	add    $0x18,%esp
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8012d0:	6a 00                	push   $0x0
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 0e                	push   $0xe
  8012dc:	e8 82 fe ff ff       	call   801163 <syscall>
  8012e1:	83 c4 18             	add    $0x18,%esp
}
  8012e4:	90                   	nop
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	6a 11                	push   $0x11
  8012f6:	e8 68 fe ff ff       	call   801163 <syscall>
  8012fb:	83 c4 18             	add    $0x18,%esp
}
  8012fe:	90                   	nop
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 12                	push   $0x12
  801310:	e8 4e fe ff ff       	call   801163 <syscall>
  801315:	83 c4 18             	add    $0x18,%esp
}
  801318:	90                   	nop
  801319:	c9                   	leave  
  80131a:	c3                   	ret    

0080131b <sys_cputc>:


void
sys_cputc(const char c)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	83 ec 04             	sub    $0x4,%esp
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801327:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	50                   	push   %eax
  801334:	6a 13                	push   $0x13
  801336:	e8 28 fe ff ff       	call   801163 <syscall>
  80133b:	83 c4 18             	add    $0x18,%esp
}
  80133e:	90                   	nop
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	6a 14                	push   $0x14
  801350:	e8 0e fe ff ff       	call   801163 <syscall>
  801355:	83 c4 18             	add    $0x18,%esp
}
  801358:	90                   	nop
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	ff 75 0c             	pushl  0xc(%ebp)
  80136a:	50                   	push   %eax
  80136b:	6a 15                	push   $0x15
  80136d:	e8 f1 fd ff ff       	call   801163 <syscall>
  801372:	83 c4 18             	add    $0x18,%esp
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80137a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	52                   	push   %edx
  801387:	50                   	push   %eax
  801388:	6a 18                	push   $0x18
  80138a:	e8 d4 fd ff ff       	call   801163 <syscall>
  80138f:	83 c4 18             	add    $0x18,%esp
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	52                   	push   %edx
  8013a4:	50                   	push   %eax
  8013a5:	6a 16                	push   $0x16
  8013a7:	e8 b7 fd ff ff       	call   801163 <syscall>
  8013ac:	83 c4 18             	add    $0x18,%esp
}
  8013af:	90                   	nop
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    

008013b2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8013b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	52                   	push   %edx
  8013c2:	50                   	push   %eax
  8013c3:	6a 17                	push   $0x17
  8013c5:	e8 99 fd ff ff       	call   801163 <syscall>
  8013ca:	83 c4 18             	add    $0x18,%esp
}
  8013cd:	90                   	nop
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013dc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013df:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	6a 00                	push   $0x0
  8013e8:	51                   	push   %ecx
  8013e9:	52                   	push   %edx
  8013ea:	ff 75 0c             	pushl  0xc(%ebp)
  8013ed:	50                   	push   %eax
  8013ee:	6a 19                	push   $0x19
  8013f0:	e8 6e fd ff ff       	call   801163 <syscall>
  8013f5:	83 c4 18             	add    $0x18,%esp
}
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

008013fa <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8013fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	52                   	push   %edx
  80140a:	50                   	push   %eax
  80140b:	6a 1a                	push   $0x1a
  80140d:	e8 51 fd ff ff       	call   801163 <syscall>
  801412:	83 c4 18             	add    $0x18,%esp
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80141a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80141d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	51                   	push   %ecx
  801428:	52                   	push   %edx
  801429:	50                   	push   %eax
  80142a:	6a 1b                	push   $0x1b
  80142c:	e8 32 fd ff ff       	call   801163 <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801439:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	52                   	push   %edx
  801446:	50                   	push   %eax
  801447:	6a 1c                	push   $0x1c
  801449:	e8 15 fd ff ff       	call   801163 <syscall>
  80144e:	83 c4 18             	add    $0x18,%esp
}
  801451:	c9                   	leave  
  801452:	c3                   	ret    

00801453 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 1d                	push   $0x1d
  801462:	e8 fc fc ff ff       	call   801163 <syscall>
  801467:	83 c4 18             	add    $0x18,%esp
}
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	6a 00                	push   $0x0
  801474:	ff 75 14             	pushl  0x14(%ebp)
  801477:	ff 75 10             	pushl  0x10(%ebp)
  80147a:	ff 75 0c             	pushl  0xc(%ebp)
  80147d:	50                   	push   %eax
  80147e:	6a 1e                	push   $0x1e
  801480:	e8 de fc ff ff       	call   801163 <syscall>
  801485:	83 c4 18             	add    $0x18,%esp
}
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	50                   	push   %eax
  801499:	6a 1f                	push   $0x1f
  80149b:	e8 c3 fc ff ff       	call   801163 <syscall>
  8014a0:	83 c4 18             	add    $0x18,%esp
}
  8014a3:	90                   	nop
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    

008014a6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	50                   	push   %eax
  8014b5:	6a 20                	push   $0x20
  8014b7:	e8 a7 fc ff ff       	call   801163 <syscall>
  8014bc:	83 c4 18             	add    $0x18,%esp
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 02                	push   $0x2
  8014d0:	e8 8e fc ff ff       	call   801163 <syscall>
  8014d5:	83 c4 18             	add    $0x18,%esp
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 03                	push   $0x3
  8014e9:	e8 75 fc ff ff       	call   801163 <syscall>
  8014ee:	83 c4 18             	add    $0x18,%esp
}
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 04                	push   $0x4
  801502:	e8 5c fc ff ff       	call   801163 <syscall>
  801507:	83 c4 18             	add    $0x18,%esp
}
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <sys_exit_env>:


void sys_exit_env(void)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 21                	push   $0x21
  80151b:	e8 43 fc ff ff       	call   801163 <syscall>
  801520:	83 c4 18             	add    $0x18,%esp
}
  801523:	90                   	nop
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80152c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80152f:	8d 50 04             	lea    0x4(%eax),%edx
  801532:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	52                   	push   %edx
  80153c:	50                   	push   %eax
  80153d:	6a 22                	push   $0x22
  80153f:	e8 1f fc ff ff       	call   801163 <syscall>
  801544:	83 c4 18             	add    $0x18,%esp
	return result;
  801547:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80154d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801550:	89 01                	mov    %eax,(%ecx)
  801552:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	c9                   	leave  
  801559:	c2 04 00             	ret    $0x4

0080155c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	ff 75 10             	pushl  0x10(%ebp)
  801566:	ff 75 0c             	pushl  0xc(%ebp)
  801569:	ff 75 08             	pushl  0x8(%ebp)
  80156c:	6a 10                	push   $0x10
  80156e:	e8 f0 fb ff ff       	call   801163 <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
	return ;
  801576:	90                   	nop
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <sys_rcr2>:
uint32 sys_rcr2()
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 23                	push   $0x23
  801588:	e8 d6 fb ff ff       	call   801163 <syscall>
  80158d:	83 c4 18             	add    $0x18,%esp
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 04             	sub    $0x4,%esp
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80159e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	50                   	push   %eax
  8015ab:	6a 24                	push   $0x24
  8015ad:	e8 b1 fb ff ff       	call   801163 <syscall>
  8015b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b5:	90                   	nop
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <rsttst>:
void rsttst()
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 26                	push   $0x26
  8015c7:	e8 97 fb ff ff       	call   801163 <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8015cf:	90                   	nop
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	83 ec 04             	sub    $0x4,%esp
  8015d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015de:	8b 55 18             	mov    0x18(%ebp),%edx
  8015e1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015e5:	52                   	push   %edx
  8015e6:	50                   	push   %eax
  8015e7:	ff 75 10             	pushl  0x10(%ebp)
  8015ea:	ff 75 0c             	pushl  0xc(%ebp)
  8015ed:	ff 75 08             	pushl  0x8(%ebp)
  8015f0:	6a 25                	push   $0x25
  8015f2:	e8 6c fb ff ff       	call   801163 <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8015fa:	90                   	nop
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <chktst>:
void chktst(uint32 n)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	ff 75 08             	pushl  0x8(%ebp)
  80160b:	6a 27                	push   $0x27
  80160d:	e8 51 fb ff ff       	call   801163 <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
	return ;
  801615:	90                   	nop
}
  801616:	c9                   	leave  
  801617:	c3                   	ret    

00801618 <inctst>:

void inctst()
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 28                	push   $0x28
  801627:	e8 37 fb ff ff       	call   801163 <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
	return ;
  80162f:	90                   	nop
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <gettst>:
uint32 gettst()
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 29                	push   $0x29
  801641:	e8 1d fb ff ff       	call   801163 <syscall>
  801646:	83 c4 18             	add    $0x18,%esp
}
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 2a                	push   $0x2a
  80165d:	e8 01 fb ff ff       	call   801163 <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
  801665:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801668:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80166c:	75 07                	jne    801675 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80166e:	b8 01 00 00 00       	mov    $0x1,%eax
  801673:	eb 05                	jmp    80167a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801675:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 2a                	push   $0x2a
  80168e:	e8 d0 fa ff ff       	call   801163 <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
  801696:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801699:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80169d:	75 07                	jne    8016a6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80169f:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a4:	eb 05                	jmp    8016ab <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 2a                	push   $0x2a
  8016bf:	e8 9f fa ff ff       	call   801163 <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
  8016c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016ca:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016ce:	75 07                	jne    8016d7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8016d5:	eb 05                	jmp    8016dc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 2a                	push   $0x2a
  8016f0:	e8 6e fa ff ff       	call   801163 <syscall>
  8016f5:	83 c4 18             	add    $0x18,%esp
  8016f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8016fb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8016ff:	75 07                	jne    801708 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801701:	b8 01 00 00 00       	mov    $0x1,%eax
  801706:	eb 05                	jmp    80170d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801708:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	ff 75 08             	pushl  0x8(%ebp)
  80171d:	6a 2b                	push   $0x2b
  80171f:	e8 3f fa ff ff       	call   801163 <syscall>
  801724:	83 c4 18             	add    $0x18,%esp
	return ;
  801727:	90                   	nop
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
  80172d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80172e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801731:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801734:	8b 55 0c             	mov    0xc(%ebp),%edx
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	6a 00                	push   $0x0
  80173c:	53                   	push   %ebx
  80173d:	51                   	push   %ecx
  80173e:	52                   	push   %edx
  80173f:	50                   	push   %eax
  801740:	6a 2c                	push   $0x2c
  801742:	e8 1c fa ff ff       	call   801163 <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
}
  80174a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801752:	8b 55 0c             	mov    0xc(%ebp),%edx
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	52                   	push   %edx
  80175f:	50                   	push   %eax
  801760:	6a 2d                	push   $0x2d
  801762:	e8 fc f9 ff ff       	call   801163 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80176f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801772:	8b 55 0c             	mov    0xc(%ebp),%edx
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	6a 00                	push   $0x0
  80177a:	51                   	push   %ecx
  80177b:	ff 75 10             	pushl  0x10(%ebp)
  80177e:	52                   	push   %edx
  80177f:	50                   	push   %eax
  801780:	6a 2e                	push   $0x2e
  801782:	e8 dc f9 ff ff       	call   801163 <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	ff 75 10             	pushl  0x10(%ebp)
  801796:	ff 75 0c             	pushl  0xc(%ebp)
  801799:	ff 75 08             	pushl  0x8(%ebp)
  80179c:	6a 0f                	push   $0xf
  80179e:	e8 c0 f9 ff ff       	call   801163 <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a6:	90                   	nop
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	50                   	push   %eax
  8017b8:	6a 2f                	push   $0x2f
  8017ba:	e8 a4 f9 ff ff       	call   801163 <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	ff 75 08             	pushl  0x8(%ebp)
  8017d3:	6a 30                	push   $0x30
  8017d5:	e8 89 f9 ff ff       	call   801163 <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  8017dd:	90                   	nop
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ec:	ff 75 08             	pushl  0x8(%ebp)
  8017ef:	6a 31                	push   $0x31
  8017f1:	e8 6d f9 ff ff       	call   801163 <syscall>
  8017f6:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  8017f9:	90                   	nop
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801802:	8b 55 08             	mov    0x8(%ebp),%edx
  801805:	89 d0                	mov    %edx,%eax
  801807:	c1 e0 02             	shl    $0x2,%eax
  80180a:	01 d0                	add    %edx,%eax
  80180c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801813:	01 d0                	add    %edx,%eax
  801815:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80181c:	01 d0                	add    %edx,%eax
  80181e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801825:	01 d0                	add    %edx,%eax
  801827:	c1 e0 04             	shl    $0x4,%eax
  80182a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80182d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801834:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801837:	83 ec 0c             	sub    $0xc,%esp
  80183a:	50                   	push   %eax
  80183b:	e8 e6 fc ff ff       	call   801526 <sys_get_virtual_time>
  801840:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801843:	eb 41                	jmp    801886 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801845:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801848:	83 ec 0c             	sub    $0xc,%esp
  80184b:	50                   	push   %eax
  80184c:	e8 d5 fc ff ff       	call   801526 <sys_get_virtual_time>
  801851:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801854:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801857:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80185a:	29 c2                	sub    %eax,%edx
  80185c:	89 d0                	mov    %edx,%eax
  80185e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801861:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801864:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801867:	89 d1                	mov    %edx,%ecx
  801869:	29 c1                	sub    %eax,%ecx
  80186b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80186e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801871:	39 c2                	cmp    %eax,%edx
  801873:	0f 97 c0             	seta   %al
  801876:	0f b6 c0             	movzbl %al,%eax
  801879:	29 c1                	sub    %eax,%ecx
  80187b:	89 c8                	mov    %ecx,%eax
  80187d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801880:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801883:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801889:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80188c:	72 b7                	jb     801845 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80188e:	90                   	nop
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801897:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80189e:	eb 03                	jmp    8018a3 <busy_wait+0x12>
  8018a0:	ff 45 fc             	incl   -0x4(%ebp)
  8018a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018a9:	72 f5                	jb     8018a0 <busy_wait+0xf>
	return i;
  8018ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <__udivdi3>:
  8018b0:	55                   	push   %ebp
  8018b1:	57                   	push   %edi
  8018b2:	56                   	push   %esi
  8018b3:	53                   	push   %ebx
  8018b4:	83 ec 1c             	sub    $0x1c,%esp
  8018b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018c7:	89 ca                	mov    %ecx,%edx
  8018c9:	89 f8                	mov    %edi,%eax
  8018cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018cf:	85 f6                	test   %esi,%esi
  8018d1:	75 2d                	jne    801900 <__udivdi3+0x50>
  8018d3:	39 cf                	cmp    %ecx,%edi
  8018d5:	77 65                	ja     80193c <__udivdi3+0x8c>
  8018d7:	89 fd                	mov    %edi,%ebp
  8018d9:	85 ff                	test   %edi,%edi
  8018db:	75 0b                	jne    8018e8 <__udivdi3+0x38>
  8018dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8018e2:	31 d2                	xor    %edx,%edx
  8018e4:	f7 f7                	div    %edi
  8018e6:	89 c5                	mov    %eax,%ebp
  8018e8:	31 d2                	xor    %edx,%edx
  8018ea:	89 c8                	mov    %ecx,%eax
  8018ec:	f7 f5                	div    %ebp
  8018ee:	89 c1                	mov    %eax,%ecx
  8018f0:	89 d8                	mov    %ebx,%eax
  8018f2:	f7 f5                	div    %ebp
  8018f4:	89 cf                	mov    %ecx,%edi
  8018f6:	89 fa                	mov    %edi,%edx
  8018f8:	83 c4 1c             	add    $0x1c,%esp
  8018fb:	5b                   	pop    %ebx
  8018fc:	5e                   	pop    %esi
  8018fd:	5f                   	pop    %edi
  8018fe:	5d                   	pop    %ebp
  8018ff:	c3                   	ret    
  801900:	39 ce                	cmp    %ecx,%esi
  801902:	77 28                	ja     80192c <__udivdi3+0x7c>
  801904:	0f bd fe             	bsr    %esi,%edi
  801907:	83 f7 1f             	xor    $0x1f,%edi
  80190a:	75 40                	jne    80194c <__udivdi3+0x9c>
  80190c:	39 ce                	cmp    %ecx,%esi
  80190e:	72 0a                	jb     80191a <__udivdi3+0x6a>
  801910:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801914:	0f 87 9e 00 00 00    	ja     8019b8 <__udivdi3+0x108>
  80191a:	b8 01 00 00 00       	mov    $0x1,%eax
  80191f:	89 fa                	mov    %edi,%edx
  801921:	83 c4 1c             	add    $0x1c,%esp
  801924:	5b                   	pop    %ebx
  801925:	5e                   	pop    %esi
  801926:	5f                   	pop    %edi
  801927:	5d                   	pop    %ebp
  801928:	c3                   	ret    
  801929:	8d 76 00             	lea    0x0(%esi),%esi
  80192c:	31 ff                	xor    %edi,%edi
  80192e:	31 c0                	xor    %eax,%eax
  801930:	89 fa                	mov    %edi,%edx
  801932:	83 c4 1c             	add    $0x1c,%esp
  801935:	5b                   	pop    %ebx
  801936:	5e                   	pop    %esi
  801937:	5f                   	pop    %edi
  801938:	5d                   	pop    %ebp
  801939:	c3                   	ret    
  80193a:	66 90                	xchg   %ax,%ax
  80193c:	89 d8                	mov    %ebx,%eax
  80193e:	f7 f7                	div    %edi
  801940:	31 ff                	xor    %edi,%edi
  801942:	89 fa                	mov    %edi,%edx
  801944:	83 c4 1c             	add    $0x1c,%esp
  801947:	5b                   	pop    %ebx
  801948:	5e                   	pop    %esi
  801949:	5f                   	pop    %edi
  80194a:	5d                   	pop    %ebp
  80194b:	c3                   	ret    
  80194c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801951:	89 eb                	mov    %ebp,%ebx
  801953:	29 fb                	sub    %edi,%ebx
  801955:	89 f9                	mov    %edi,%ecx
  801957:	d3 e6                	shl    %cl,%esi
  801959:	89 c5                	mov    %eax,%ebp
  80195b:	88 d9                	mov    %bl,%cl
  80195d:	d3 ed                	shr    %cl,%ebp
  80195f:	89 e9                	mov    %ebp,%ecx
  801961:	09 f1                	or     %esi,%ecx
  801963:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801967:	89 f9                	mov    %edi,%ecx
  801969:	d3 e0                	shl    %cl,%eax
  80196b:	89 c5                	mov    %eax,%ebp
  80196d:	89 d6                	mov    %edx,%esi
  80196f:	88 d9                	mov    %bl,%cl
  801971:	d3 ee                	shr    %cl,%esi
  801973:	89 f9                	mov    %edi,%ecx
  801975:	d3 e2                	shl    %cl,%edx
  801977:	8b 44 24 08          	mov    0x8(%esp),%eax
  80197b:	88 d9                	mov    %bl,%cl
  80197d:	d3 e8                	shr    %cl,%eax
  80197f:	09 c2                	or     %eax,%edx
  801981:	89 d0                	mov    %edx,%eax
  801983:	89 f2                	mov    %esi,%edx
  801985:	f7 74 24 0c          	divl   0xc(%esp)
  801989:	89 d6                	mov    %edx,%esi
  80198b:	89 c3                	mov    %eax,%ebx
  80198d:	f7 e5                	mul    %ebp
  80198f:	39 d6                	cmp    %edx,%esi
  801991:	72 19                	jb     8019ac <__udivdi3+0xfc>
  801993:	74 0b                	je     8019a0 <__udivdi3+0xf0>
  801995:	89 d8                	mov    %ebx,%eax
  801997:	31 ff                	xor    %edi,%edi
  801999:	e9 58 ff ff ff       	jmp    8018f6 <__udivdi3+0x46>
  80199e:	66 90                	xchg   %ax,%ax
  8019a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019a4:	89 f9                	mov    %edi,%ecx
  8019a6:	d3 e2                	shl    %cl,%edx
  8019a8:	39 c2                	cmp    %eax,%edx
  8019aa:	73 e9                	jae    801995 <__udivdi3+0xe5>
  8019ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019af:	31 ff                	xor    %edi,%edi
  8019b1:	e9 40 ff ff ff       	jmp    8018f6 <__udivdi3+0x46>
  8019b6:	66 90                	xchg   %ax,%ax
  8019b8:	31 c0                	xor    %eax,%eax
  8019ba:	e9 37 ff ff ff       	jmp    8018f6 <__udivdi3+0x46>
  8019bf:	90                   	nop

008019c0 <__umoddi3>:
  8019c0:	55                   	push   %ebp
  8019c1:	57                   	push   %edi
  8019c2:	56                   	push   %esi
  8019c3:	53                   	push   %ebx
  8019c4:	83 ec 1c             	sub    $0x1c,%esp
  8019c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019df:	89 f3                	mov    %esi,%ebx
  8019e1:	89 fa                	mov    %edi,%edx
  8019e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019e7:	89 34 24             	mov    %esi,(%esp)
  8019ea:	85 c0                	test   %eax,%eax
  8019ec:	75 1a                	jne    801a08 <__umoddi3+0x48>
  8019ee:	39 f7                	cmp    %esi,%edi
  8019f0:	0f 86 a2 00 00 00    	jbe    801a98 <__umoddi3+0xd8>
  8019f6:	89 c8                	mov    %ecx,%eax
  8019f8:	89 f2                	mov    %esi,%edx
  8019fa:	f7 f7                	div    %edi
  8019fc:	89 d0                	mov    %edx,%eax
  8019fe:	31 d2                	xor    %edx,%edx
  801a00:	83 c4 1c             	add    $0x1c,%esp
  801a03:	5b                   	pop    %ebx
  801a04:	5e                   	pop    %esi
  801a05:	5f                   	pop    %edi
  801a06:	5d                   	pop    %ebp
  801a07:	c3                   	ret    
  801a08:	39 f0                	cmp    %esi,%eax
  801a0a:	0f 87 ac 00 00 00    	ja     801abc <__umoddi3+0xfc>
  801a10:	0f bd e8             	bsr    %eax,%ebp
  801a13:	83 f5 1f             	xor    $0x1f,%ebp
  801a16:	0f 84 ac 00 00 00    	je     801ac8 <__umoddi3+0x108>
  801a1c:	bf 20 00 00 00       	mov    $0x20,%edi
  801a21:	29 ef                	sub    %ebp,%edi
  801a23:	89 fe                	mov    %edi,%esi
  801a25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a29:	89 e9                	mov    %ebp,%ecx
  801a2b:	d3 e0                	shl    %cl,%eax
  801a2d:	89 d7                	mov    %edx,%edi
  801a2f:	89 f1                	mov    %esi,%ecx
  801a31:	d3 ef                	shr    %cl,%edi
  801a33:	09 c7                	or     %eax,%edi
  801a35:	89 e9                	mov    %ebp,%ecx
  801a37:	d3 e2                	shl    %cl,%edx
  801a39:	89 14 24             	mov    %edx,(%esp)
  801a3c:	89 d8                	mov    %ebx,%eax
  801a3e:	d3 e0                	shl    %cl,%eax
  801a40:	89 c2                	mov    %eax,%edx
  801a42:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a46:	d3 e0                	shl    %cl,%eax
  801a48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a50:	89 f1                	mov    %esi,%ecx
  801a52:	d3 e8                	shr    %cl,%eax
  801a54:	09 d0                	or     %edx,%eax
  801a56:	d3 eb                	shr    %cl,%ebx
  801a58:	89 da                	mov    %ebx,%edx
  801a5a:	f7 f7                	div    %edi
  801a5c:	89 d3                	mov    %edx,%ebx
  801a5e:	f7 24 24             	mull   (%esp)
  801a61:	89 c6                	mov    %eax,%esi
  801a63:	89 d1                	mov    %edx,%ecx
  801a65:	39 d3                	cmp    %edx,%ebx
  801a67:	0f 82 87 00 00 00    	jb     801af4 <__umoddi3+0x134>
  801a6d:	0f 84 91 00 00 00    	je     801b04 <__umoddi3+0x144>
  801a73:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a77:	29 f2                	sub    %esi,%edx
  801a79:	19 cb                	sbb    %ecx,%ebx
  801a7b:	89 d8                	mov    %ebx,%eax
  801a7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a81:	d3 e0                	shl    %cl,%eax
  801a83:	89 e9                	mov    %ebp,%ecx
  801a85:	d3 ea                	shr    %cl,%edx
  801a87:	09 d0                	or     %edx,%eax
  801a89:	89 e9                	mov    %ebp,%ecx
  801a8b:	d3 eb                	shr    %cl,%ebx
  801a8d:	89 da                	mov    %ebx,%edx
  801a8f:	83 c4 1c             	add    $0x1c,%esp
  801a92:	5b                   	pop    %ebx
  801a93:	5e                   	pop    %esi
  801a94:	5f                   	pop    %edi
  801a95:	5d                   	pop    %ebp
  801a96:	c3                   	ret    
  801a97:	90                   	nop
  801a98:	89 fd                	mov    %edi,%ebp
  801a9a:	85 ff                	test   %edi,%edi
  801a9c:	75 0b                	jne    801aa9 <__umoddi3+0xe9>
  801a9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa3:	31 d2                	xor    %edx,%edx
  801aa5:	f7 f7                	div    %edi
  801aa7:	89 c5                	mov    %eax,%ebp
  801aa9:	89 f0                	mov    %esi,%eax
  801aab:	31 d2                	xor    %edx,%edx
  801aad:	f7 f5                	div    %ebp
  801aaf:	89 c8                	mov    %ecx,%eax
  801ab1:	f7 f5                	div    %ebp
  801ab3:	89 d0                	mov    %edx,%eax
  801ab5:	e9 44 ff ff ff       	jmp    8019fe <__umoddi3+0x3e>
  801aba:	66 90                	xchg   %ax,%ax
  801abc:	89 c8                	mov    %ecx,%eax
  801abe:	89 f2                	mov    %esi,%edx
  801ac0:	83 c4 1c             	add    $0x1c,%esp
  801ac3:	5b                   	pop    %ebx
  801ac4:	5e                   	pop    %esi
  801ac5:	5f                   	pop    %edi
  801ac6:	5d                   	pop    %ebp
  801ac7:	c3                   	ret    
  801ac8:	3b 04 24             	cmp    (%esp),%eax
  801acb:	72 06                	jb     801ad3 <__umoddi3+0x113>
  801acd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ad1:	77 0f                	ja     801ae2 <__umoddi3+0x122>
  801ad3:	89 f2                	mov    %esi,%edx
  801ad5:	29 f9                	sub    %edi,%ecx
  801ad7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801adb:	89 14 24             	mov    %edx,(%esp)
  801ade:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ae2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ae6:	8b 14 24             	mov    (%esp),%edx
  801ae9:	83 c4 1c             	add    $0x1c,%esp
  801aec:	5b                   	pop    %ebx
  801aed:	5e                   	pop    %esi
  801aee:	5f                   	pop    %edi
  801aef:	5d                   	pop    %ebp
  801af0:	c3                   	ret    
  801af1:	8d 76 00             	lea    0x0(%esi),%esi
  801af4:	2b 04 24             	sub    (%esp),%eax
  801af7:	19 fa                	sbb    %edi,%edx
  801af9:	89 d1                	mov    %edx,%ecx
  801afb:	89 c6                	mov    %eax,%esi
  801afd:	e9 71 ff ff ff       	jmp    801a73 <__umoddi3+0xb3>
  801b02:	66 90                	xchg   %ax,%ax
  801b04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b08:	72 ea                	jb     801af4 <__umoddi3+0x134>
  801b0a:	89 d9                	mov    %ebx,%ecx
  801b0c:	e9 62 ff ff ff       	jmp    801a73 <__umoddi3+0xb3>
