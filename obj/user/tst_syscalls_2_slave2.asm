
obj/user/tst_syscalls_2_slave2:     file format elf32-i386


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
  800031:	e8 33 00 00 00       	call   800069 <libmain>
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
  80003b:	83 ec 08             	sub    $0x8,%esp
	//[2] Invalid Range (Above USER_LIMIT)
	sys_allocate_user_mem(USER_LIMIT,10);
  80003e:	83 ec 08             	sub    $0x8,%esp
  800041:	6a 0a                	push   $0xa
  800043:	68 00 00 80 ef       	push   $0xef800000
  800048:	e8 98 18 00 00       	call   8018e5 <sys_allocate_user_mem>
  80004d:	83 c4 10             	add    $0x10,%esp
	inctst();
  800050:	e8 c8 16 00 00       	call   80171d <inctst>
	panic("tst system calls #2 failed: sys_allocate_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	68 80 1b 80 00       	push   $0x801b80
  80005d:	6a 0a                	push   $0xa
  80005f:	68 02 1c 80 00       	push   $0x801c02
  800064:	e8 45 01 00 00       	call   8001ae <_panic>

00800069 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800069:	55                   	push   %ebp
  80006a:	89 e5                	mov    %esp,%ebp
  80006c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006f:	e8 6b 15 00 00       	call   8015df <sys_getenvindex>
  800074:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007a:	89 d0                	mov    %edx,%eax
  80007c:	01 c0                	add    %eax,%eax
  80007e:	01 d0                	add    %edx,%eax
  800080:	01 c0                	add    %eax,%eax
  800082:	01 d0                	add    %edx,%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	01 d0                	add    %edx,%eax
  800089:	01 c0                	add    %eax,%eax
  80008b:	01 d0                	add    %edx,%eax
  80008d:	c1 e0 02             	shl    $0x2,%eax
  800090:	01 d0                	add    %edx,%eax
  800092:	c1 e0 02             	shl    $0x2,%eax
  800095:	01 d0                	add    %edx,%eax
  800097:	c1 e0 02             	shl    $0x2,%eax
  80009a:	01 d0                	add    %edx,%eax
  80009c:	c1 e0 05             	shl    $0x5,%eax
  80009f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a4:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ae:	8a 40 5c             	mov    0x5c(%eax),%al
  8000b1:	84 c0                	test   %al,%al
  8000b3:	74 0d                	je     8000c2 <libmain+0x59>
		binaryname = myEnv->prog_name;
  8000b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ba:	83 c0 5c             	add    $0x5c,%eax
  8000bd:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000c6:	7e 0a                	jle    8000d2 <libmain+0x69>
		binaryname = argv[0];
  8000c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000cb:	8b 00                	mov    (%eax),%eax
  8000cd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	ff 75 0c             	pushl  0xc(%ebp)
  8000d8:	ff 75 08             	pushl  0x8(%ebp)
  8000db:	e8 58 ff ff ff       	call   800038 <_main>
  8000e0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000e3:	e8 04 13 00 00       	call   8013ec <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 38 1c 80 00       	push   $0x801c38
  8000f0:	e8 76 03 00 00       	call   80046b <cprintf>
  8000f5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fd:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  800103:	a1 20 30 80 00       	mov    0x803020,%eax
  800108:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  80010e:	83 ec 04             	sub    $0x4,%esp
  800111:	52                   	push   %edx
  800112:	50                   	push   %eax
  800113:	68 60 1c 80 00       	push   $0x801c60
  800118:	e8 4e 03 00 00       	call   80046b <cprintf>
  80011d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800120:	a1 20 30 80 00       	mov    0x803020,%eax
  800125:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  80012b:	a1 20 30 80 00       	mov    0x803020,%eax
  800130:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  800136:	a1 20 30 80 00       	mov    0x803020,%eax
  80013b:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  800141:	51                   	push   %ecx
  800142:	52                   	push   %edx
  800143:	50                   	push   %eax
  800144:	68 88 1c 80 00       	push   $0x801c88
  800149:	e8 1d 03 00 00       	call   80046b <cprintf>
  80014e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800151:	a1 20 30 80 00       	mov    0x803020,%eax
  800156:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	50                   	push   %eax
  800160:	68 e0 1c 80 00       	push   $0x801ce0
  800165:	e8 01 03 00 00       	call   80046b <cprintf>
  80016a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	68 38 1c 80 00       	push   $0x801c38
  800175:	e8 f1 02 00 00       	call   80046b <cprintf>
  80017a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80017d:	e8 84 12 00 00       	call   801406 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800182:	e8 19 00 00 00       	call   8001a0 <exit>
}
  800187:	90                   	nop
  800188:	c9                   	leave  
  800189:	c3                   	ret    

0080018a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80018a:	55                   	push   %ebp
  80018b:	89 e5                	mov    %esp,%ebp
  80018d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	6a 00                	push   $0x0
  800195:	e8 11 14 00 00       	call   8015ab <sys_destroy_env>
  80019a:	83 c4 10             	add    $0x10,%esp
}
  80019d:	90                   	nop
  80019e:	c9                   	leave  
  80019f:	c3                   	ret    

008001a0 <exit>:

void
exit(void)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001a6:	e8 66 14 00 00       	call   801611 <sys_exit_env>
}
  8001ab:	90                   	nop
  8001ac:	c9                   	leave  
  8001ad:	c3                   	ret    

008001ae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001ae:	55                   	push   %ebp
  8001af:	89 e5                	mov    %esp,%ebp
  8001b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001b4:	8d 45 10             	lea    0x10(%ebp),%eax
  8001b7:	83 c0 04             	add    $0x4,%eax
  8001ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001bd:	a1 28 31 80 00       	mov    0x803128,%eax
  8001c2:	85 c0                	test   %eax,%eax
  8001c4:	74 16                	je     8001dc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001c6:	a1 28 31 80 00       	mov    0x803128,%eax
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	50                   	push   %eax
  8001cf:	68 f4 1c 80 00       	push   $0x801cf4
  8001d4:	e8 92 02 00 00       	call   80046b <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001dc:	a1 00 30 80 00       	mov    0x803000,%eax
  8001e1:	ff 75 0c             	pushl  0xc(%ebp)
  8001e4:	ff 75 08             	pushl  0x8(%ebp)
  8001e7:	50                   	push   %eax
  8001e8:	68 f9 1c 80 00       	push   $0x801cf9
  8001ed:	e8 79 02 00 00       	call   80046b <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f8:	83 ec 08             	sub    $0x8,%esp
  8001fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8001fe:	50                   	push   %eax
  8001ff:	e8 fc 01 00 00       	call   800400 <vcprintf>
  800204:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	6a 00                	push   $0x0
  80020c:	68 15 1d 80 00       	push   $0x801d15
  800211:	e8 ea 01 00 00       	call   800400 <vcprintf>
  800216:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800219:	e8 82 ff ff ff       	call   8001a0 <exit>

	// should not return here
	while (1) ;
  80021e:	eb fe                	jmp    80021e <_panic+0x70>

00800220 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800226:	a1 20 30 80 00       	mov    0x803020,%eax
  80022b:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  800231:	8b 45 0c             	mov    0xc(%ebp),%eax
  800234:	39 c2                	cmp    %eax,%edx
  800236:	74 14                	je     80024c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 18 1d 80 00       	push   $0x801d18
  800240:	6a 26                	push   $0x26
  800242:	68 64 1d 80 00       	push   $0x801d64
  800247:	e8 62 ff ff ff       	call   8001ae <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80024c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800253:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80025a:	e9 c5 00 00 00       	jmp    800324 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80025f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800269:	8b 45 08             	mov    0x8(%ebp),%eax
  80026c:	01 d0                	add    %edx,%eax
  80026e:	8b 00                	mov    (%eax),%eax
  800270:	85 c0                	test   %eax,%eax
  800272:	75 08                	jne    80027c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800274:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800277:	e9 a5 00 00 00       	jmp    800321 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80027c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800283:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80028a:	eb 69                	jmp    8002f5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80028c:	a1 20 30 80 00       	mov    0x803020,%eax
  800291:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  800297:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80029a:	89 d0                	mov    %edx,%eax
  80029c:	01 c0                	add    %eax,%eax
  80029e:	01 d0                	add    %edx,%eax
  8002a0:	c1 e0 03             	shl    $0x3,%eax
  8002a3:	01 c8                	add    %ecx,%eax
  8002a5:	8a 40 04             	mov    0x4(%eax),%al
  8002a8:	84 c0                	test   %al,%al
  8002aa:	75 46                	jne    8002f2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b1:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  8002b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002ba:	89 d0                	mov    %edx,%eax
  8002bc:	01 c0                	add    %eax,%eax
  8002be:	01 d0                	add    %edx,%eax
  8002c0:	c1 e0 03             	shl    $0x3,%eax
  8002c3:	01 c8                	add    %ecx,%eax
  8002c5:	8b 00                	mov    (%eax),%eax
  8002c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002d2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e1:	01 c8                	add    %ecx,%eax
  8002e3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002e5:	39 c2                	cmp    %eax,%edx
  8002e7:	75 09                	jne    8002f2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002e9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002f0:	eb 15                	jmp    800307 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002f2:	ff 45 e8             	incl   -0x18(%ebp)
  8002f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002fa:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  800300:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800303:	39 c2                	cmp    %eax,%edx
  800305:	77 85                	ja     80028c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800307:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80030b:	75 14                	jne    800321 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	68 70 1d 80 00       	push   $0x801d70
  800315:	6a 3a                	push   $0x3a
  800317:	68 64 1d 80 00       	push   $0x801d64
  80031c:	e8 8d fe ff ff       	call   8001ae <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800321:	ff 45 f0             	incl   -0x10(%ebp)
  800324:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800327:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80032a:	0f 8c 2f ff ff ff    	jl     80025f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800330:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800337:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80033e:	eb 26                	jmp    800366 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800340:	a1 20 30 80 00       	mov    0x803020,%eax
  800345:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  80034b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80034e:	89 d0                	mov    %edx,%eax
  800350:	01 c0                	add    %eax,%eax
  800352:	01 d0                	add    %edx,%eax
  800354:	c1 e0 03             	shl    $0x3,%eax
  800357:	01 c8                	add    %ecx,%eax
  800359:	8a 40 04             	mov    0x4(%eax),%al
  80035c:	3c 01                	cmp    $0x1,%al
  80035e:	75 03                	jne    800363 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800360:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800363:	ff 45 e0             	incl   -0x20(%ebp)
  800366:	a1 20 30 80 00       	mov    0x803020,%eax
  80036b:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  800371:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800374:	39 c2                	cmp    %eax,%edx
  800376:	77 c8                	ja     800340 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80037e:	74 14                	je     800394 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800380:	83 ec 04             	sub    $0x4,%esp
  800383:	68 c4 1d 80 00       	push   $0x801dc4
  800388:	6a 44                	push   $0x44
  80038a:	68 64 1d 80 00       	push   $0x801d64
  80038f:	e8 1a fe ff ff       	call   8001ae <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800394:	90                   	nop
  800395:	c9                   	leave  
  800396:	c3                   	ret    

00800397 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80039d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a0:	8b 00                	mov    (%eax),%eax
  8003a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8003a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a8:	89 0a                	mov    %ecx,(%edx)
  8003aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ad:	88 d1                	mov    %dl,%cl
  8003af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b9:	8b 00                	mov    (%eax),%eax
  8003bb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c0:	75 2c                	jne    8003ee <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003c2:	a0 24 30 80 00       	mov    0x803024,%al
  8003c7:	0f b6 c0             	movzbl %al,%eax
  8003ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cd:	8b 12                	mov    (%edx),%edx
  8003cf:	89 d1                	mov    %edx,%ecx
  8003d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d4:	83 c2 08             	add    $0x8,%edx
  8003d7:	83 ec 04             	sub    $0x4,%esp
  8003da:	50                   	push   %eax
  8003db:	51                   	push   %ecx
  8003dc:	52                   	push   %edx
  8003dd:	e8 b1 0e 00 00       	call   801293 <sys_cputs>
  8003e2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f1:	8b 40 04             	mov    0x4(%eax),%eax
  8003f4:	8d 50 01             	lea    0x1(%eax),%edx
  8003f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fa:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003fd:	90                   	nop
  8003fe:	c9                   	leave  
  8003ff:	c3                   	ret    

00800400 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800409:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800410:	00 00 00 
	b.cnt = 0;
  800413:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80041a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80041d:	ff 75 0c             	pushl  0xc(%ebp)
  800420:	ff 75 08             	pushl  0x8(%ebp)
  800423:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800429:	50                   	push   %eax
  80042a:	68 97 03 80 00       	push   $0x800397
  80042f:	e8 11 02 00 00       	call   800645 <vprintfmt>
  800434:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800437:	a0 24 30 80 00       	mov    0x803024,%al
  80043c:	0f b6 c0             	movzbl %al,%eax
  80043f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800445:	83 ec 04             	sub    $0x4,%esp
  800448:	50                   	push   %eax
  800449:	52                   	push   %edx
  80044a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800450:	83 c0 08             	add    $0x8,%eax
  800453:	50                   	push   %eax
  800454:	e8 3a 0e 00 00       	call   801293 <sys_cputs>
  800459:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80045c:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800463:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800469:	c9                   	leave  
  80046a:	c3                   	ret    

0080046b <cprintf>:

int cprintf(const char *fmt, ...) {
  80046b:	55                   	push   %ebp
  80046c:	89 e5                	mov    %esp,%ebp
  80046e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800471:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800478:	8d 45 0c             	lea    0xc(%ebp),%eax
  80047b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	ff 75 f4             	pushl  -0xc(%ebp)
  800487:	50                   	push   %eax
  800488:	e8 73 ff ff ff       	call   800400 <vcprintf>
  80048d:	83 c4 10             	add    $0x10,%esp
  800490:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800493:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800496:	c9                   	leave  
  800497:	c3                   	ret    

00800498 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
  80049b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80049e:	e8 49 0f 00 00       	call   8013ec <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004a3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ac:	83 ec 08             	sub    $0x8,%esp
  8004af:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b2:	50                   	push   %eax
  8004b3:	e8 48 ff ff ff       	call   800400 <vcprintf>
  8004b8:	83 c4 10             	add    $0x10,%esp
  8004bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004be:	e8 43 0f 00 00       	call   801406 <sys_enable_interrupt>
	return cnt;
  8004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	53                   	push   %ebx
  8004cc:	83 ec 14             	sub    $0x14,%esp
  8004cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004db:	8b 45 18             	mov    0x18(%ebp),%eax
  8004de:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e6:	77 55                	ja     80053d <printnum+0x75>
  8004e8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004eb:	72 05                	jb     8004f2 <printnum+0x2a>
  8004ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004f0:	77 4b                	ja     80053d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004f5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004f8:	8b 45 18             	mov    0x18(%ebp),%eax
  8004fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800500:	52                   	push   %edx
  800501:	50                   	push   %eax
  800502:	ff 75 f4             	pushl  -0xc(%ebp)
  800505:	ff 75 f0             	pushl  -0x10(%ebp)
  800508:	e8 f7 13 00 00       	call   801904 <__udivdi3>
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	83 ec 04             	sub    $0x4,%esp
  800513:	ff 75 20             	pushl  0x20(%ebp)
  800516:	53                   	push   %ebx
  800517:	ff 75 18             	pushl  0x18(%ebp)
  80051a:	52                   	push   %edx
  80051b:	50                   	push   %eax
  80051c:	ff 75 0c             	pushl  0xc(%ebp)
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	e8 a1 ff ff ff       	call   8004c8 <printnum>
  800527:	83 c4 20             	add    $0x20,%esp
  80052a:	eb 1a                	jmp    800546 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80052c:	83 ec 08             	sub    $0x8,%esp
  80052f:	ff 75 0c             	pushl  0xc(%ebp)
  800532:	ff 75 20             	pushl  0x20(%ebp)
  800535:	8b 45 08             	mov    0x8(%ebp),%eax
  800538:	ff d0                	call   *%eax
  80053a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80053d:	ff 4d 1c             	decl   0x1c(%ebp)
  800540:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800544:	7f e6                	jg     80052c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800546:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800549:	bb 00 00 00 00       	mov    $0x0,%ebx
  80054e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800551:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800554:	53                   	push   %ebx
  800555:	51                   	push   %ecx
  800556:	52                   	push   %edx
  800557:	50                   	push   %eax
  800558:	e8 b7 14 00 00       	call   801a14 <__umoddi3>
  80055d:	83 c4 10             	add    $0x10,%esp
  800560:	05 34 20 80 00       	add    $0x802034,%eax
  800565:	8a 00                	mov    (%eax),%al
  800567:	0f be c0             	movsbl %al,%eax
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	ff 75 0c             	pushl  0xc(%ebp)
  800570:	50                   	push   %eax
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	ff d0                	call   *%eax
  800576:	83 c4 10             	add    $0x10,%esp
}
  800579:	90                   	nop
  80057a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80057d:	c9                   	leave  
  80057e:	c3                   	ret    

0080057f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80057f:	55                   	push   %ebp
  800580:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800582:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800586:	7e 1c                	jle    8005a4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	8b 00                	mov    (%eax),%eax
  80058d:	8d 50 08             	lea    0x8(%eax),%edx
  800590:	8b 45 08             	mov    0x8(%ebp),%eax
  800593:	89 10                	mov    %edx,(%eax)
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	83 e8 08             	sub    $0x8,%eax
  80059d:	8b 50 04             	mov    0x4(%eax),%edx
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	eb 40                	jmp    8005e4 <getuint+0x65>
	else if (lflag)
  8005a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005a8:	74 1e                	je     8005c8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	8d 50 04             	lea    0x4(%eax),%edx
  8005b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b5:	89 10                	mov    %edx,(%eax)
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	83 e8 04             	sub    $0x4,%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c6:	eb 1c                	jmp    8005e4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	8b 00                	mov    (%eax),%eax
  8005cd:	8d 50 04             	lea    0x4(%eax),%edx
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	89 10                	mov    %edx,(%eax)
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	8b 00                	mov    (%eax),%eax
  8005da:	83 e8 04             	sub    $0x4,%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005e4:	5d                   	pop    %ebp
  8005e5:	c3                   	ret    

008005e6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005e9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005ed:	7e 1c                	jle    80060b <getint+0x25>
		return va_arg(*ap, long long);
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	8b 00                	mov    (%eax),%eax
  8005f4:	8d 50 08             	lea    0x8(%eax),%edx
  8005f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fa:	89 10                	mov    %edx,(%eax)
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	83 e8 08             	sub    $0x8,%eax
  800604:	8b 50 04             	mov    0x4(%eax),%edx
  800607:	8b 00                	mov    (%eax),%eax
  800609:	eb 38                	jmp    800643 <getint+0x5d>
	else if (lflag)
  80060b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80060f:	74 1a                	je     80062b <getint+0x45>
		return va_arg(*ap, long);
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	8b 00                	mov    (%eax),%eax
  800616:	8d 50 04             	lea    0x4(%eax),%edx
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	89 10                	mov    %edx,(%eax)
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	83 e8 04             	sub    $0x4,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	99                   	cltd   
  800629:	eb 18                	jmp    800643 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	8b 00                	mov    (%eax),%eax
  800630:	8d 50 04             	lea    0x4(%eax),%edx
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	89 10                	mov    %edx,(%eax)
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	83 e8 04             	sub    $0x4,%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	99                   	cltd   
}
  800643:	5d                   	pop    %ebp
  800644:	c3                   	ret    

00800645 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	56                   	push   %esi
  800649:	53                   	push   %ebx
  80064a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064d:	eb 17                	jmp    800666 <vprintfmt+0x21>
			if (ch == '\0')
  80064f:	85 db                	test   %ebx,%ebx
  800651:	0f 84 af 03 00 00    	je     800a06 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	ff 75 0c             	pushl  0xc(%ebp)
  80065d:	53                   	push   %ebx
  80065e:	8b 45 08             	mov    0x8(%ebp),%eax
  800661:	ff d0                	call   *%eax
  800663:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800666:	8b 45 10             	mov    0x10(%ebp),%eax
  800669:	8d 50 01             	lea    0x1(%eax),%edx
  80066c:	89 55 10             	mov    %edx,0x10(%ebp)
  80066f:	8a 00                	mov    (%eax),%al
  800671:	0f b6 d8             	movzbl %al,%ebx
  800674:	83 fb 25             	cmp    $0x25,%ebx
  800677:	75 d6                	jne    80064f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800679:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80067d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800684:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80068b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800692:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800699:	8b 45 10             	mov    0x10(%ebp),%eax
  80069c:	8d 50 01             	lea    0x1(%eax),%edx
  80069f:	89 55 10             	mov    %edx,0x10(%ebp)
  8006a2:	8a 00                	mov    (%eax),%al
  8006a4:	0f b6 d8             	movzbl %al,%ebx
  8006a7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006aa:	83 f8 55             	cmp    $0x55,%eax
  8006ad:	0f 87 2b 03 00 00    	ja     8009de <vprintfmt+0x399>
  8006b3:	8b 04 85 58 20 80 00 	mov    0x802058(,%eax,4),%eax
  8006ba:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006bc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006c0:	eb d7                	jmp    800699 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006c2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006c6:	eb d1                	jmp    800699 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d2:	89 d0                	mov    %edx,%eax
  8006d4:	c1 e0 02             	shl    $0x2,%eax
  8006d7:	01 d0                	add    %edx,%eax
  8006d9:	01 c0                	add    %eax,%eax
  8006db:	01 d8                	add    %ebx,%eax
  8006dd:	83 e8 30             	sub    $0x30,%eax
  8006e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e6:	8a 00                	mov    (%eax),%al
  8006e8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006eb:	83 fb 2f             	cmp    $0x2f,%ebx
  8006ee:	7e 3e                	jle    80072e <vprintfmt+0xe9>
  8006f0:	83 fb 39             	cmp    $0x39,%ebx
  8006f3:	7f 39                	jg     80072e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006f8:	eb d5                	jmp    8006cf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	83 c0 04             	add    $0x4,%eax
  800700:	89 45 14             	mov    %eax,0x14(%ebp)
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	83 e8 04             	sub    $0x4,%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80070e:	eb 1f                	jmp    80072f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800710:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800714:	79 83                	jns    800699 <vprintfmt+0x54>
				width = 0;
  800716:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80071d:	e9 77 ff ff ff       	jmp    800699 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800722:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800729:	e9 6b ff ff ff       	jmp    800699 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80072e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80072f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800733:	0f 89 60 ff ff ff    	jns    800699 <vprintfmt+0x54>
				width = precision, precision = -1;
  800739:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80073c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800746:	e9 4e ff ff ff       	jmp    800699 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80074b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80074e:	e9 46 ff ff ff       	jmp    800699 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	83 c0 04             	add    $0x4,%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	83 e8 04             	sub    $0x4,%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	50                   	push   %eax
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	ff d0                	call   *%eax
  800770:	83 c4 10             	add    $0x10,%esp
			break;
  800773:	e9 89 02 00 00       	jmp    800a01 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	83 c0 04             	add    $0x4,%eax
  80077e:	89 45 14             	mov    %eax,0x14(%ebp)
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	83 e8 04             	sub    $0x4,%eax
  800787:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800789:	85 db                	test   %ebx,%ebx
  80078b:	79 02                	jns    80078f <vprintfmt+0x14a>
				err = -err;
  80078d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80078f:	83 fb 64             	cmp    $0x64,%ebx
  800792:	7f 0b                	jg     80079f <vprintfmt+0x15a>
  800794:	8b 34 9d a0 1e 80 00 	mov    0x801ea0(,%ebx,4),%esi
  80079b:	85 f6                	test   %esi,%esi
  80079d:	75 19                	jne    8007b8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80079f:	53                   	push   %ebx
  8007a0:	68 45 20 80 00       	push   $0x802045
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	ff 75 08             	pushl  0x8(%ebp)
  8007ab:	e8 5e 02 00 00       	call   800a0e <printfmt>
  8007b0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007b3:	e9 49 02 00 00       	jmp    800a01 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007b8:	56                   	push   %esi
  8007b9:	68 4e 20 80 00       	push   $0x80204e
  8007be:	ff 75 0c             	pushl  0xc(%ebp)
  8007c1:	ff 75 08             	pushl  0x8(%ebp)
  8007c4:	e8 45 02 00 00       	call   800a0e <printfmt>
  8007c9:	83 c4 10             	add    $0x10,%esp
			break;
  8007cc:	e9 30 02 00 00       	jmp    800a01 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	83 c0 04             	add    $0x4,%eax
  8007d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	83 e8 04             	sub    $0x4,%eax
  8007e0:	8b 30                	mov    (%eax),%esi
  8007e2:	85 f6                	test   %esi,%esi
  8007e4:	75 05                	jne    8007eb <vprintfmt+0x1a6>
				p = "(null)";
  8007e6:	be 51 20 80 00       	mov    $0x802051,%esi
			if (width > 0 && padc != '-')
  8007eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ef:	7e 6d                	jle    80085e <vprintfmt+0x219>
  8007f1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007f5:	74 67                	je     80085e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	50                   	push   %eax
  8007fe:	56                   	push   %esi
  8007ff:	e8 0c 03 00 00       	call   800b10 <strnlen>
  800804:	83 c4 10             	add    $0x10,%esp
  800807:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80080a:	eb 16                	jmp    800822 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80080c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	ff 75 0c             	pushl  0xc(%ebp)
  800816:	50                   	push   %eax
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	ff d0                	call   *%eax
  80081c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80081f:	ff 4d e4             	decl   -0x1c(%ebp)
  800822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800826:	7f e4                	jg     80080c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800828:	eb 34                	jmp    80085e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80082a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80082e:	74 1c                	je     80084c <vprintfmt+0x207>
  800830:	83 fb 1f             	cmp    $0x1f,%ebx
  800833:	7e 05                	jle    80083a <vprintfmt+0x1f5>
  800835:	83 fb 7e             	cmp    $0x7e,%ebx
  800838:	7e 12                	jle    80084c <vprintfmt+0x207>
					putch('?', putdat);
  80083a:	83 ec 08             	sub    $0x8,%esp
  80083d:	ff 75 0c             	pushl  0xc(%ebp)
  800840:	6a 3f                	push   $0x3f
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	ff d0                	call   *%eax
  800847:	83 c4 10             	add    $0x10,%esp
  80084a:	eb 0f                	jmp    80085b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	53                   	push   %ebx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	ff d0                	call   *%eax
  800858:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80085b:	ff 4d e4             	decl   -0x1c(%ebp)
  80085e:	89 f0                	mov    %esi,%eax
  800860:	8d 70 01             	lea    0x1(%eax),%esi
  800863:	8a 00                	mov    (%eax),%al
  800865:	0f be d8             	movsbl %al,%ebx
  800868:	85 db                	test   %ebx,%ebx
  80086a:	74 24                	je     800890 <vprintfmt+0x24b>
  80086c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800870:	78 b8                	js     80082a <vprintfmt+0x1e5>
  800872:	ff 4d e0             	decl   -0x20(%ebp)
  800875:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800879:	79 af                	jns    80082a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087b:	eb 13                	jmp    800890 <vprintfmt+0x24b>
				putch(' ', putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	ff 75 0c             	pushl  0xc(%ebp)
  800883:	6a 20                	push   $0x20
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80088d:	ff 4d e4             	decl   -0x1c(%ebp)
  800890:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800894:	7f e7                	jg     80087d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800896:	e9 66 01 00 00       	jmp    800a01 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a4:	50                   	push   %eax
  8008a5:	e8 3c fd ff ff       	call   8005e6 <getint>
  8008aa:	83 c4 10             	add    $0x10,%esp
  8008ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b9:	85 d2                	test   %edx,%edx
  8008bb:	79 23                	jns    8008e0 <vprintfmt+0x29b>
				putch('-', putdat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	ff 75 0c             	pushl  0xc(%ebp)
  8008c3:	6a 2d                	push   $0x2d
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	ff d0                	call   *%eax
  8008ca:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d3:	f7 d8                	neg    %eax
  8008d5:	83 d2 00             	adc    $0x0,%edx
  8008d8:	f7 da                	neg    %edx
  8008da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008e0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008e7:	e9 bc 00 00 00       	jmp    8009a8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	ff 75 e8             	pushl  -0x18(%ebp)
  8008f2:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f5:	50                   	push   %eax
  8008f6:	e8 84 fc ff ff       	call   80057f <getuint>
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800901:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800904:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80090b:	e9 98 00 00 00       	jmp    8009a8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	ff 75 0c             	pushl  0xc(%ebp)
  800916:	6a 58                	push   $0x58
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	ff d0                	call   *%eax
  80091d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	6a 58                	push   $0x58
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	ff d0                	call   *%eax
  80092d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	ff 75 0c             	pushl  0xc(%ebp)
  800936:	6a 58                	push   $0x58
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	ff d0                	call   *%eax
  80093d:	83 c4 10             	add    $0x10,%esp
			break;
  800940:	e9 bc 00 00 00       	jmp    800a01 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	6a 30                	push   $0x30
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	6a 78                	push   $0x78
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	ff d0                	call   *%eax
  800962:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	83 c0 04             	add    $0x4,%eax
  80096b:	89 45 14             	mov    %eax,0x14(%ebp)
  80096e:	8b 45 14             	mov    0x14(%ebp),%eax
  800971:	83 e8 04             	sub    $0x4,%eax
  800974:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800976:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800979:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800980:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800987:	eb 1f                	jmp    8009a8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800989:	83 ec 08             	sub    $0x8,%esp
  80098c:	ff 75 e8             	pushl  -0x18(%ebp)
  80098f:	8d 45 14             	lea    0x14(%ebp),%eax
  800992:	50                   	push   %eax
  800993:	e8 e7 fb ff ff       	call   80057f <getuint>
  800998:	83 c4 10             	add    $0x10,%esp
  80099b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009a1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009a8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009af:	83 ec 04             	sub    $0x4,%esp
  8009b2:	52                   	push   %edx
  8009b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009b6:	50                   	push   %eax
  8009b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	ff 75 08             	pushl  0x8(%ebp)
  8009c3:	e8 00 fb ff ff       	call   8004c8 <printnum>
  8009c8:	83 c4 20             	add    $0x20,%esp
			break;
  8009cb:	eb 34                	jmp    800a01 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	53                   	push   %ebx
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	ff d0                	call   *%eax
  8009d9:	83 c4 10             	add    $0x10,%esp
			break;
  8009dc:	eb 23                	jmp    800a01 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009de:	83 ec 08             	sub    $0x8,%esp
  8009e1:	ff 75 0c             	pushl  0xc(%ebp)
  8009e4:	6a 25                	push   $0x25
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	ff d0                	call   *%eax
  8009eb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009ee:	ff 4d 10             	decl   0x10(%ebp)
  8009f1:	eb 03                	jmp    8009f6 <vprintfmt+0x3b1>
  8009f3:	ff 4d 10             	decl   0x10(%ebp)
  8009f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f9:	48                   	dec    %eax
  8009fa:	8a 00                	mov    (%eax),%al
  8009fc:	3c 25                	cmp    $0x25,%al
  8009fe:	75 f3                	jne    8009f3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800a00:	90                   	nop
		}
	}
  800a01:	e9 47 fc ff ff       	jmp    80064d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a06:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a0a:	5b                   	pop    %ebx
  800a0b:	5e                   	pop    %esi
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    

00800a0e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a14:	8d 45 10             	lea    0x10(%ebp),%eax
  800a17:	83 c0 04             	add    $0x4,%eax
  800a1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a20:	ff 75 f4             	pushl  -0xc(%ebp)
  800a23:	50                   	push   %eax
  800a24:	ff 75 0c             	pushl  0xc(%ebp)
  800a27:	ff 75 08             	pushl  0x8(%ebp)
  800a2a:	e8 16 fc ff ff       	call   800645 <vprintfmt>
  800a2f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a32:	90                   	nop
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3b:	8b 40 08             	mov    0x8(%eax),%eax
  800a3e:	8d 50 01             	lea    0x1(%eax),%edx
  800a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a44:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4a:	8b 10                	mov    (%eax),%edx
  800a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4f:	8b 40 04             	mov    0x4(%eax),%eax
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	73 12                	jae    800a68 <sprintputch+0x33>
		*b->buf++ = ch;
  800a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a59:	8b 00                	mov    (%eax),%eax
  800a5b:	8d 48 01             	lea    0x1(%eax),%ecx
  800a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a61:	89 0a                	mov    %ecx,(%edx)
  800a63:	8b 55 08             	mov    0x8(%ebp),%edx
  800a66:	88 10                	mov    %dl,(%eax)
}
  800a68:	90                   	nop
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	01 d0                	add    %edx,%eax
  800a82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a90:	74 06                	je     800a98 <vsnprintf+0x2d>
  800a92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a96:	7f 07                	jg     800a9f <vsnprintf+0x34>
		return -E_INVAL;
  800a98:	b8 03 00 00 00       	mov    $0x3,%eax
  800a9d:	eb 20                	jmp    800abf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a9f:	ff 75 14             	pushl  0x14(%ebp)
  800aa2:	ff 75 10             	pushl  0x10(%ebp)
  800aa5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aa8:	50                   	push   %eax
  800aa9:	68 35 0a 80 00       	push   $0x800a35
  800aae:	e8 92 fb ff ff       	call   800645 <vprintfmt>
  800ab3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ab6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800abf:	c9                   	leave  
  800ac0:	c3                   	ret    

00800ac1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ac7:	8d 45 10             	lea    0x10(%ebp),%eax
  800aca:	83 c0 04             	add    $0x4,%eax
  800acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ad0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad6:	50                   	push   %eax
  800ad7:	ff 75 0c             	pushl  0xc(%ebp)
  800ada:	ff 75 08             	pushl  0x8(%ebp)
  800add:	e8 89 ff ff ff       	call   800a6b <vsnprintf>
  800ae2:	83 c4 10             	add    $0x10,%esp
  800ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aeb:	c9                   	leave  
  800aec:	c3                   	ret    

00800aed <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800af3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800afa:	eb 06                	jmp    800b02 <strlen+0x15>
		n++;
  800afc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aff:	ff 45 08             	incl   0x8(%ebp)
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	8a 00                	mov    (%eax),%al
  800b07:	84 c0                	test   %al,%al
  800b09:	75 f1                	jne    800afc <strlen+0xf>
		n++;
	return n;
  800b0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b0e:	c9                   	leave  
  800b0f:	c3                   	ret    

00800b10 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b1d:	eb 09                	jmp    800b28 <strnlen+0x18>
		n++;
  800b1f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b22:	ff 45 08             	incl   0x8(%ebp)
  800b25:	ff 4d 0c             	decl   0xc(%ebp)
  800b28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b2c:	74 09                	je     800b37 <strnlen+0x27>
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	8a 00                	mov    (%eax),%al
  800b33:	84 c0                	test   %al,%al
  800b35:	75 e8                	jne    800b1f <strnlen+0xf>
		n++;
	return n;
  800b37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b48:	90                   	nop
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8d 50 01             	lea    0x1(%eax),%edx
  800b4f:	89 55 08             	mov    %edx,0x8(%ebp)
  800b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b55:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b58:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b5b:	8a 12                	mov    (%edx),%dl
  800b5d:	88 10                	mov    %dl,(%eax)
  800b5f:	8a 00                	mov    (%eax),%al
  800b61:	84 c0                	test   %al,%al
  800b63:	75 e4                	jne    800b49 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b65:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b68:	c9                   	leave  
  800b69:	c3                   	ret    

00800b6a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b7d:	eb 1f                	jmp    800b9e <strncpy+0x34>
		*dst++ = *src;
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	8d 50 01             	lea    0x1(%eax),%edx
  800b85:	89 55 08             	mov    %edx,0x8(%ebp)
  800b88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8b:	8a 12                	mov    (%edx),%dl
  800b8d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b92:	8a 00                	mov    (%eax),%al
  800b94:	84 c0                	test   %al,%al
  800b96:	74 03                	je     800b9b <strncpy+0x31>
			src++;
  800b98:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b9b:	ff 45 fc             	incl   -0x4(%ebp)
  800b9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ba4:	72 d9                	jb     800b7f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ba6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bbb:	74 30                	je     800bed <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bbd:	eb 16                	jmp    800bd5 <strlcpy+0x2a>
			*dst++ = *src++;
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	8d 50 01             	lea    0x1(%eax),%edx
  800bc5:	89 55 08             	mov    %edx,0x8(%ebp)
  800bc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bce:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bd1:	8a 12                	mov    (%edx),%dl
  800bd3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bd5:	ff 4d 10             	decl   0x10(%ebp)
  800bd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bdc:	74 09                	je     800be7 <strlcpy+0x3c>
  800bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be1:	8a 00                	mov    (%eax),%al
  800be3:	84 c0                	test   %al,%al
  800be5:	75 d8                	jne    800bbf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bed:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf3:	29 c2                	sub    %eax,%edx
  800bf5:	89 d0                	mov    %edx,%eax
}
  800bf7:	c9                   	leave  
  800bf8:	c3                   	ret    

00800bf9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bfc:	eb 06                	jmp    800c04 <strcmp+0xb>
		p++, q++;
  800bfe:	ff 45 08             	incl   0x8(%ebp)
  800c01:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	8a 00                	mov    (%eax),%al
  800c09:	84 c0                	test   %al,%al
  800c0b:	74 0e                	je     800c1b <strcmp+0x22>
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	8a 10                	mov    (%eax),%dl
  800c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	38 c2                	cmp    %al,%dl
  800c19:	74 e3                	je     800bfe <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	8a 00                	mov    (%eax),%al
  800c20:	0f b6 d0             	movzbl %al,%edx
  800c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c26:	8a 00                	mov    (%eax),%al
  800c28:	0f b6 c0             	movzbl %al,%eax
  800c2b:	29 c2                	sub    %eax,%edx
  800c2d:	89 d0                	mov    %edx,%eax
}
  800c2f:	5d                   	pop    %ebp
  800c30:	c3                   	ret    

00800c31 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c34:	eb 09                	jmp    800c3f <strncmp+0xe>
		n--, p++, q++;
  800c36:	ff 4d 10             	decl   0x10(%ebp)
  800c39:	ff 45 08             	incl   0x8(%ebp)
  800c3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c43:	74 17                	je     800c5c <strncmp+0x2b>
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	84 c0                	test   %al,%al
  800c4c:	74 0e                	je     800c5c <strncmp+0x2b>
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8a 10                	mov    (%eax),%dl
  800c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c56:	8a 00                	mov    (%eax),%al
  800c58:	38 c2                	cmp    %al,%dl
  800c5a:	74 da                	je     800c36 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c60:	75 07                	jne    800c69 <strncmp+0x38>
		return 0;
  800c62:	b8 00 00 00 00       	mov    $0x0,%eax
  800c67:	eb 14                	jmp    800c7d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8a 00                	mov    (%eax),%al
  800c6e:	0f b6 d0             	movzbl %al,%edx
  800c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	0f b6 c0             	movzbl %al,%eax
  800c79:	29 c2                	sub    %eax,%edx
  800c7b:	89 d0                	mov    %edx,%eax
}
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 04             	sub    $0x4,%esp
  800c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c88:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c8b:	eb 12                	jmp    800c9f <strchr+0x20>
		if (*s == c)
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c95:	75 05                	jne    800c9c <strchr+0x1d>
			return (char *) s;
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	eb 11                	jmp    800cad <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c9c:	ff 45 08             	incl   0x8(%ebp)
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	84 c0                	test   %al,%al
  800ca6:	75 e5                	jne    800c8d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ca8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cad:	c9                   	leave  
  800cae:	c3                   	ret    

00800caf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	83 ec 04             	sub    $0x4,%esp
  800cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cbb:	eb 0d                	jmp    800cca <strfind+0x1b>
		if (*s == c)
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cc5:	74 0e                	je     800cd5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cc7:	ff 45 08             	incl   0x8(%ebp)
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	84 c0                	test   %al,%al
  800cd1:	75 ea                	jne    800cbd <strfind+0xe>
  800cd3:	eb 01                	jmp    800cd6 <strfind+0x27>
		if (*s == c)
			break;
  800cd5:	90                   	nop
	return (char *) s;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <memset>:

int i=0;
void *
memset(void *v, int c, uint32 n)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 10             	sub    $0x10,%esp


	i++;
  800ce1:	a1 28 30 80 00       	mov    0x803028,%eax
  800ce6:	40                   	inc    %eax
  800ce7:	a3 28 30 80 00       	mov    %eax,0x803028

	char *p;
	int m;

	p = v;
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cf2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf5:	89 45 f8             	mov    %eax,-0x8(%ebp)


	while (--m >= 0){
  800cf8:	eb 0e                	jmp    800d08 <memset+0x2d>

		*p++ = c;
  800cfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cfd:	8d 50 01             	lea    0x1(%eax),%edx
  800d00:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d06:	88 10                	mov    %dl,(%eax)

	p = v;
	m = n;


	while (--m >= 0){
  800d08:	ff 4d f8             	decl   -0x8(%ebp)
  800d0b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d0f:	79 e9                	jns    800cfa <memset+0x1f>

		*p++ = c;
	}

	return v;
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d14:	c9                   	leave  
  800d15:	c3                   	ret    

00800d16 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d28:	eb 16                	jmp    800d40 <memcpy+0x2a>
		*d++ = *s++;
  800d2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d2d:	8d 50 01             	lea    0x1(%eax),%edx
  800d30:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d36:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d39:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d3c:	8a 12                	mov    (%edx),%dl
  800d3e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d40:	8b 45 10             	mov    0x10(%ebp),%eax
  800d43:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d46:	89 55 10             	mov    %edx,0x10(%ebp)
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	75 dd                	jne    800d2a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    

00800d52 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d67:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d6a:	73 50                	jae    800dbc <memmove+0x6a>
  800d6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	01 d0                	add    %edx,%eax
  800d74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d77:	76 43                	jbe    800dbc <memmove+0x6a>
		s += n;
  800d79:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d85:	eb 10                	jmp    800d97 <memmove+0x45>
			*--d = *--s;
  800d87:	ff 4d f8             	decl   -0x8(%ebp)
  800d8a:	ff 4d fc             	decl   -0x4(%ebp)
  800d8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d90:	8a 10                	mov    (%eax),%dl
  800d92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d95:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d97:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800da0:	85 c0                	test   %eax,%eax
  800da2:	75 e3                	jne    800d87 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800da4:	eb 23                	jmp    800dc9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800da6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da9:	8d 50 01             	lea    0x1(%eax),%edx
  800dac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800daf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800db8:	8a 12                	mov    (%edx),%dl
  800dba:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc2:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc5:	85 c0                	test   %eax,%eax
  800dc7:	75 dd                	jne    800da6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dcc:	c9                   	leave  
  800dcd:	c3                   	ret    

00800dce <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800de0:	eb 2a                	jmp    800e0c <memcmp+0x3e>
		if (*s1 != *s2)
  800de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de5:	8a 10                	mov    (%eax),%dl
  800de7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	38 c2                	cmp    %al,%dl
  800dee:	74 16                	je     800e06 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	0f b6 d0             	movzbl %al,%edx
  800df8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	0f b6 c0             	movzbl %al,%eax
  800e00:	29 c2                	sub    %eax,%edx
  800e02:	89 d0                	mov    %edx,%eax
  800e04:	eb 18                	jmp    800e1e <memcmp+0x50>
		s1++, s2++;
  800e06:	ff 45 fc             	incl   -0x4(%ebp)
  800e09:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e12:	89 55 10             	mov    %edx,0x10(%ebp)
  800e15:	85 c0                	test   %eax,%eax
  800e17:	75 c9                	jne    800de2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e26:	8b 55 08             	mov    0x8(%ebp),%edx
  800e29:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2c:	01 d0                	add    %edx,%eax
  800e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e31:	eb 15                	jmp    800e48 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	0f b6 d0             	movzbl %al,%edx
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	0f b6 c0             	movzbl %al,%eax
  800e41:	39 c2                	cmp    %eax,%edx
  800e43:	74 0d                	je     800e52 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e45:	ff 45 08             	incl   0x8(%ebp)
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e4e:	72 e3                	jb     800e33 <memfind+0x13>
  800e50:	eb 01                	jmp    800e53 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e52:	90                   	nop
	return (void *) s;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e56:	c9                   	leave  
  800e57:	c3                   	ret    

00800e58 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e6c:	eb 03                	jmp    800e71 <strtol+0x19>
		s++;
  800e6e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	3c 20                	cmp    $0x20,%al
  800e78:	74 f4                	je     800e6e <strtol+0x16>
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	3c 09                	cmp    $0x9,%al
  800e81:	74 eb                	je     800e6e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8a 00                	mov    (%eax),%al
  800e88:	3c 2b                	cmp    $0x2b,%al
  800e8a:	75 05                	jne    800e91 <strtol+0x39>
		s++;
  800e8c:	ff 45 08             	incl   0x8(%ebp)
  800e8f:	eb 13                	jmp    800ea4 <strtol+0x4c>
	else if (*s == '-')
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	3c 2d                	cmp    $0x2d,%al
  800e98:	75 0a                	jne    800ea4 <strtol+0x4c>
		s++, neg = 1;
  800e9a:	ff 45 08             	incl   0x8(%ebp)
  800e9d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea8:	74 06                	je     800eb0 <strtol+0x58>
  800eaa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eae:	75 20                	jne    800ed0 <strtol+0x78>
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	3c 30                	cmp    $0x30,%al
  800eb7:	75 17                	jne    800ed0 <strtol+0x78>
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	40                   	inc    %eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	3c 78                	cmp    $0x78,%al
  800ec1:	75 0d                	jne    800ed0 <strtol+0x78>
		s += 2, base = 16;
  800ec3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ec7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ece:	eb 28                	jmp    800ef8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ed0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed4:	75 15                	jne    800eeb <strtol+0x93>
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	3c 30                	cmp    $0x30,%al
  800edd:	75 0c                	jne    800eeb <strtol+0x93>
		s++, base = 8;
  800edf:	ff 45 08             	incl   0x8(%ebp)
  800ee2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ee9:	eb 0d                	jmp    800ef8 <strtol+0xa0>
	else if (base == 0)
  800eeb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eef:	75 07                	jne    800ef8 <strtol+0xa0>
		base = 10;
  800ef1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	3c 2f                	cmp    $0x2f,%al
  800eff:	7e 19                	jle    800f1a <strtol+0xc2>
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	3c 39                	cmp    $0x39,%al
  800f08:	7f 10                	jg     800f1a <strtol+0xc2>
			dig = *s - '0';
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	0f be c0             	movsbl %al,%eax
  800f12:	83 e8 30             	sub    $0x30,%eax
  800f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f18:	eb 42                	jmp    800f5c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	3c 60                	cmp    $0x60,%al
  800f21:	7e 19                	jle    800f3c <strtol+0xe4>
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	3c 7a                	cmp    $0x7a,%al
  800f2a:	7f 10                	jg     800f3c <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	0f be c0             	movsbl %al,%eax
  800f34:	83 e8 57             	sub    $0x57,%eax
  800f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f3a:	eb 20                	jmp    800f5c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	3c 40                	cmp    $0x40,%al
  800f43:	7e 39                	jle    800f7e <strtol+0x126>
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	3c 5a                	cmp    $0x5a,%al
  800f4c:	7f 30                	jg     800f7e <strtol+0x126>
			dig = *s - 'A' + 10;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	0f be c0             	movsbl %al,%eax
  800f56:	83 e8 37             	sub    $0x37,%eax
  800f59:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f62:	7d 19                	jge    800f7d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f64:	ff 45 08             	incl   0x8(%ebp)
  800f67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f6e:	89 c2                	mov    %eax,%edx
  800f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f73:	01 d0                	add    %edx,%eax
  800f75:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f78:	e9 7b ff ff ff       	jmp    800ef8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f7d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f82:	74 08                	je     800f8c <strtol+0x134>
		*endptr = (char *) s;
  800f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f87:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f90:	74 07                	je     800f99 <strtol+0x141>
  800f92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f95:	f7 d8                	neg    %eax
  800f97:	eb 03                	jmp    800f9c <strtol+0x144>
  800f99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f9c:	c9                   	leave  
  800f9d:	c3                   	ret    

00800f9e <ltostr>:

void
ltostr(long value, char *str)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fa4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fb6:	79 13                	jns    800fcb <ltostr+0x2d>
	{
		neg = 1;
  800fb8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fc5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fc8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fd3:	99                   	cltd   
  800fd4:	f7 f9                	idiv   %ecx
  800fd6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdc:	8d 50 01             	lea    0x1(%eax),%edx
  800fdf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe2:	89 c2                	mov    %eax,%edx
  800fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe7:	01 d0                	add    %edx,%eax
  800fe9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fec:	83 c2 30             	add    $0x30,%edx
  800fef:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ff1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff9:	f7 e9                	imul   %ecx
  800ffb:	c1 fa 02             	sar    $0x2,%edx
  800ffe:	89 c8                	mov    %ecx,%eax
  801000:	c1 f8 1f             	sar    $0x1f,%eax
  801003:	29 c2                	sub    %eax,%edx
  801005:	89 d0                	mov    %edx,%eax
  801007:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80100a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80100d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801012:	f7 e9                	imul   %ecx
  801014:	c1 fa 02             	sar    $0x2,%edx
  801017:	89 c8                	mov    %ecx,%eax
  801019:	c1 f8 1f             	sar    $0x1f,%eax
  80101c:	29 c2                	sub    %eax,%edx
  80101e:	89 d0                	mov    %edx,%eax
  801020:	c1 e0 02             	shl    $0x2,%eax
  801023:	01 d0                	add    %edx,%eax
  801025:	01 c0                	add    %eax,%eax
  801027:	29 c1                	sub    %eax,%ecx
  801029:	89 ca                	mov    %ecx,%edx
  80102b:	85 d2                	test   %edx,%edx
  80102d:	75 9c                	jne    800fcb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80102f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801036:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801039:	48                   	dec    %eax
  80103a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80103d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801041:	74 3d                	je     801080 <ltostr+0xe2>
		start = 1 ;
  801043:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80104a:	eb 34                	jmp    801080 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80104c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801052:	01 d0                	add    %edx,%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801059:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105f:	01 c2                	add    %eax,%edx
  801061:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801064:	8b 45 0c             	mov    0xc(%ebp),%eax
  801067:	01 c8                	add    %ecx,%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80106d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801070:	8b 45 0c             	mov    0xc(%ebp),%eax
  801073:	01 c2                	add    %eax,%edx
  801075:	8a 45 eb             	mov    -0x15(%ebp),%al
  801078:	88 02                	mov    %al,(%edx)
		start++ ;
  80107a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80107d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801083:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801086:	7c c4                	jl     80104c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801088:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	01 d0                	add    %edx,%eax
  801090:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801093:	90                   	nop
  801094:	c9                   	leave  
  801095:	c3                   	ret    

00801096 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80109c:	ff 75 08             	pushl  0x8(%ebp)
  80109f:	e8 49 fa ff ff       	call   800aed <strlen>
  8010a4:	83 c4 04             	add    $0x4,%esp
  8010a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010aa:	ff 75 0c             	pushl  0xc(%ebp)
  8010ad:	e8 3b fa ff ff       	call   800aed <strlen>
  8010b2:	83 c4 04             	add    $0x4,%esp
  8010b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010c6:	eb 17                	jmp    8010df <strcconcat+0x49>
		final[s] = str1[s] ;
  8010c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ce:	01 c2                	add    %eax,%edx
  8010d0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	01 c8                	add    %ecx,%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010dc:	ff 45 fc             	incl   -0x4(%ebp)
  8010df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010e5:	7c e1                	jl     8010c8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010f5:	eb 1f                	jmp    801116 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fa:	8d 50 01             	lea    0x1(%eax),%edx
  8010fd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801100:	89 c2                	mov    %eax,%edx
  801102:	8b 45 10             	mov    0x10(%ebp),%eax
  801105:	01 c2                	add    %eax,%edx
  801107:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	01 c8                	add    %ecx,%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801113:	ff 45 f8             	incl   -0x8(%ebp)
  801116:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801119:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80111c:	7c d9                	jl     8010f7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80111e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801121:	8b 45 10             	mov    0x10(%ebp),%eax
  801124:	01 d0                	add    %edx,%eax
  801126:	c6 00 00             	movb   $0x0,(%eax)
}
  801129:	90                   	nop
  80112a:	c9                   	leave  
  80112b:	c3                   	ret    

0080112c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80112f:	8b 45 14             	mov    0x14(%ebp),%eax
  801132:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801138:	8b 45 14             	mov    0x14(%ebp),%eax
  80113b:	8b 00                	mov    (%eax),%eax
  80113d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801144:	8b 45 10             	mov    0x10(%ebp),%eax
  801147:	01 d0                	add    %edx,%eax
  801149:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80114f:	eb 0c                	jmp    80115d <strsplit+0x31>
			*string++ = 0;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8d 50 01             	lea    0x1(%eax),%edx
  801157:	89 55 08             	mov    %edx,0x8(%ebp)
  80115a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	84 c0                	test   %al,%al
  801164:	74 18                	je     80117e <strsplit+0x52>
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	0f be c0             	movsbl %al,%eax
  80116e:	50                   	push   %eax
  80116f:	ff 75 0c             	pushl  0xc(%ebp)
  801172:	e8 08 fb ff ff       	call   800c7f <strchr>
  801177:	83 c4 08             	add    $0x8,%esp
  80117a:	85 c0                	test   %eax,%eax
  80117c:	75 d3                	jne    801151 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	84 c0                	test   %al,%al
  801185:	74 5a                	je     8011e1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801187:	8b 45 14             	mov    0x14(%ebp),%eax
  80118a:	8b 00                	mov    (%eax),%eax
  80118c:	83 f8 0f             	cmp    $0xf,%eax
  80118f:	75 07                	jne    801198 <strsplit+0x6c>
		{
			return 0;
  801191:	b8 00 00 00 00       	mov    $0x0,%eax
  801196:	eb 66                	jmp    8011fe <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801198:	8b 45 14             	mov    0x14(%ebp),%eax
  80119b:	8b 00                	mov    (%eax),%eax
  80119d:	8d 48 01             	lea    0x1(%eax),%ecx
  8011a0:	8b 55 14             	mov    0x14(%ebp),%edx
  8011a3:	89 0a                	mov    %ecx,(%edx)
  8011a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8011af:	01 c2                	add    %eax,%edx
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011b6:	eb 03                	jmp    8011bb <strsplit+0x8f>
			string++;
  8011b8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	84 c0                	test   %al,%al
  8011c2:	74 8b                	je     80114f <strsplit+0x23>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	0f be c0             	movsbl %al,%eax
  8011cc:	50                   	push   %eax
  8011cd:	ff 75 0c             	pushl  0xc(%ebp)
  8011d0:	e8 aa fa ff ff       	call   800c7f <strchr>
  8011d5:	83 c4 08             	add    $0x8,%esp
  8011d8:	85 c0                	test   %eax,%eax
  8011da:	74 dc                	je     8011b8 <strsplit+0x8c>
			string++;
	}
  8011dc:	e9 6e ff ff ff       	jmp    80114f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011e1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e5:	8b 00                	mov    (%eax),%eax
  8011e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011f9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    

00801200 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  801206:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80120a:	74 06                	je     801212 <str2lower+0x12>
  80120c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801210:	75 07                	jne    801219 <str2lower+0x19>
		return NULL;
  801212:	b8 00 00 00 00       	mov    $0x0,%eax
  801217:	eb 4d                	jmp    801266 <str2lower+0x66>
	}
	char *ref=dst;
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  80121f:	eb 33                	jmp    801254 <str2lower+0x54>
			if(*src>=65&&*src<=90){
  801221:	8b 45 0c             	mov    0xc(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 40                	cmp    $0x40,%al
  801228:	7e 1a                	jle    801244 <str2lower+0x44>
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 5a                	cmp    $0x5a,%al
  801231:	7f 11                	jg     801244 <str2lower+0x44>
				*dst=*src+32;
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	83 c0 20             	add    $0x20,%eax
  80123b:	88 c2                	mov    %al,%dl
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	88 10                	mov    %dl,(%eax)
  801242:	eb 0a                	jmp    80124e <str2lower+0x4e>
			}
			else{
				*dst=*src;
  801244:	8b 45 0c             	mov    0xc(%ebp),%eax
  801247:	8a 10                	mov    (%eax),%dl
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	88 10                	mov    %dl,(%eax)
			}
			src++;
  80124e:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  801251:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	84 c0                	test   %al,%al
  80125b:	75 c4                	jne    801221 <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  801263:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801266:	c9                   	leave  
  801267:	c3                   	ret    

00801268 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	57                   	push   %edi
  80126c:	56                   	push   %esi
  80126d:	53                   	push   %ebx
  80126e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8b 55 0c             	mov    0xc(%ebp),%edx
  801277:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80127a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80127d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801280:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801283:	cd 30                	int    $0x30
  801285:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801288:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80128b:	83 c4 10             	add    $0x10,%esp
  80128e:	5b                   	pop    %ebx
  80128f:	5e                   	pop    %esi
  801290:	5f                   	pop    %edi
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    

00801293 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 04             	sub    $0x4,%esp
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80129f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	52                   	push   %edx
  8012ab:	ff 75 0c             	pushl  0xc(%ebp)
  8012ae:	50                   	push   %eax
  8012af:	6a 00                	push   $0x0
  8012b1:	e8 b2 ff ff ff       	call   801268 <syscall>
  8012b6:	83 c4 18             	add    $0x18,%esp
}
  8012b9:	90                   	nop
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <sys_cgetc>:

int
sys_cgetc(void)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	6a 00                	push   $0x0
  8012c9:	6a 01                	push   $0x1
  8012cb:	e8 98 ff ff ff       	call   801268 <syscall>
  8012d0:	83 c4 18             	add    $0x18,%esp
}
  8012d3:	c9                   	leave  
  8012d4:	c3                   	ret    

008012d5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 00                	push   $0x0
  8012e4:	52                   	push   %edx
  8012e5:	50                   	push   %eax
  8012e6:	6a 05                	push   $0x5
  8012e8:	e8 7b ff ff ff       	call   801268 <syscall>
  8012ed:	83 c4 18             	add    $0x18,%esp
}
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	56                   	push   %esi
  8012f6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012f7:	8b 75 18             	mov    0x18(%ebp),%esi
  8012fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801300:	8b 55 0c             	mov    0xc(%ebp),%edx
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	56                   	push   %esi
  801307:	53                   	push   %ebx
  801308:	51                   	push   %ecx
  801309:	52                   	push   %edx
  80130a:	50                   	push   %eax
  80130b:	6a 06                	push   $0x6
  80130d:	e8 56 ff ff ff       	call   801268 <syscall>
  801312:	83 c4 18             	add    $0x18,%esp
}
  801315:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801318:	5b                   	pop    %ebx
  801319:	5e                   	pop    %esi
  80131a:	5d                   	pop    %ebp
  80131b:	c3                   	ret    

0080131c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80131f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	52                   	push   %edx
  80132c:	50                   	push   %eax
  80132d:	6a 07                	push   $0x7
  80132f:	e8 34 ff ff ff       	call   801268 <syscall>
  801334:	83 c4 18             	add    $0x18,%esp
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	ff 75 0c             	pushl  0xc(%ebp)
  801345:	ff 75 08             	pushl  0x8(%ebp)
  801348:	6a 08                	push   $0x8
  80134a:	e8 19 ff ff ff       	call   801268 <syscall>
  80134f:	83 c4 18             	add    $0x18,%esp
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 09                	push   $0x9
  801363:	e8 00 ff ff ff       	call   801268 <syscall>
  801368:	83 c4 18             	add    $0x18,%esp
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 0a                	push   $0xa
  80137c:	e8 e7 fe ff ff       	call   801268 <syscall>
  801381:	83 c4 18             	add    $0x18,%esp
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 0b                	push   $0xb
  801395:	e8 ce fe ff ff       	call   801268 <syscall>
  80139a:	83 c4 18             	add    $0x18,%esp
}
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 0c                	push   $0xc
  8013ae:	e8 b5 fe ff ff       	call   801268 <syscall>
  8013b3:	83 c4 18             	add    $0x18,%esp
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	ff 75 08             	pushl  0x8(%ebp)
  8013c6:	6a 0d                	push   $0xd
  8013c8:	e8 9b fe ff ff       	call   801268 <syscall>
  8013cd:	83 c4 18             	add    $0x18,%esp
}
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 0e                	push   $0xe
  8013e1:	e8 82 fe ff ff       	call   801268 <syscall>
  8013e6:	83 c4 18             	add    $0x18,%esp
}
  8013e9:	90                   	nop
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 11                	push   $0x11
  8013fb:	e8 68 fe ff ff       	call   801268 <syscall>
  801400:	83 c4 18             	add    $0x18,%esp
}
  801403:	90                   	nop
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 12                	push   $0x12
  801415:	e8 4e fe ff ff       	call   801268 <syscall>
  80141a:	83 c4 18             	add    $0x18,%esp
}
  80141d:	90                   	nop
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <sys_cputc>:


void
sys_cputc(const char c)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	83 ec 04             	sub    $0x4,%esp
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80142c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	50                   	push   %eax
  801439:	6a 13                	push   $0x13
  80143b:	e8 28 fe ff ff       	call   801268 <syscall>
  801440:	83 c4 18             	add    $0x18,%esp
}
  801443:	90                   	nop
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 14                	push   $0x14
  801455:	e8 0e fe ff ff       	call   801268 <syscall>
  80145a:	83 c4 18             	add    $0x18,%esp
}
  80145d:	90                   	nop
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	ff 75 0c             	pushl  0xc(%ebp)
  80146f:	50                   	push   %eax
  801470:	6a 15                	push   $0x15
  801472:	e8 f1 fd ff ff       	call   801268 <syscall>
  801477:	83 c4 18             	add    $0x18,%esp
}
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80147f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	52                   	push   %edx
  80148c:	50                   	push   %eax
  80148d:	6a 18                	push   $0x18
  80148f:	e8 d4 fd ff ff       	call   801268 <syscall>
  801494:	83 c4 18             	add    $0x18,%esp
}
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80149c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	52                   	push   %edx
  8014a9:	50                   	push   %eax
  8014aa:	6a 16                	push   $0x16
  8014ac:	e8 b7 fd ff ff       	call   801268 <syscall>
  8014b1:	83 c4 18             	add    $0x18,%esp
}
  8014b4:	90                   	nop
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	52                   	push   %edx
  8014c7:	50                   	push   %eax
  8014c8:	6a 17                	push   $0x17
  8014ca:	e8 99 fd ff ff       	call   801268 <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	83 ec 04             	sub    $0x4,%esp
  8014db:	8b 45 10             	mov    0x10(%ebp),%eax
  8014de:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014e1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014e4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	6a 00                	push   $0x0
  8014ed:	51                   	push   %ecx
  8014ee:	52                   	push   %edx
  8014ef:	ff 75 0c             	pushl  0xc(%ebp)
  8014f2:	50                   	push   %eax
  8014f3:	6a 19                	push   $0x19
  8014f5:	e8 6e fd ff ff       	call   801268 <syscall>
  8014fa:	83 c4 18             	add    $0x18,%esp
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801502:	8b 55 0c             	mov    0xc(%ebp),%edx
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	52                   	push   %edx
  80150f:	50                   	push   %eax
  801510:	6a 1a                	push   $0x1a
  801512:	e8 51 fd ff ff       	call   801268 <syscall>
  801517:	83 c4 18             	add    $0x18,%esp
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80151f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801522:	8b 55 0c             	mov    0xc(%ebp),%edx
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	51                   	push   %ecx
  80152d:	52                   	push   %edx
  80152e:	50                   	push   %eax
  80152f:	6a 1b                	push   $0x1b
  801531:	e8 32 fd ff ff       	call   801268 <syscall>
  801536:	83 c4 18             	add    $0x18,%esp
}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80153e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	52                   	push   %edx
  80154b:	50                   	push   %eax
  80154c:	6a 1c                	push   $0x1c
  80154e:	e8 15 fd ff ff       	call   801268 <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 1d                	push   $0x1d
  801567:	e8 fc fc ff ff       	call   801268 <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	6a 00                	push   $0x0
  801579:	ff 75 14             	pushl  0x14(%ebp)
  80157c:	ff 75 10             	pushl  0x10(%ebp)
  80157f:	ff 75 0c             	pushl  0xc(%ebp)
  801582:	50                   	push   %eax
  801583:	6a 1e                	push   $0x1e
  801585:	e8 de fc ff ff       	call   801268 <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	50                   	push   %eax
  80159e:	6a 1f                	push   $0x1f
  8015a0:	e8 c3 fc ff ff       	call   801268 <syscall>
  8015a5:	83 c4 18             	add    $0x18,%esp
}
  8015a8:	90                   	nop
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	50                   	push   %eax
  8015ba:	6a 20                	push   $0x20
  8015bc:	e8 a7 fc ff ff       	call   801268 <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
}
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 02                	push   $0x2
  8015d5:	e8 8e fc ff ff       	call   801268 <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 03                	push   $0x3
  8015ee:	e8 75 fc ff ff       	call   801268 <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 04                	push   $0x4
  801607:	e8 5c fc ff ff       	call   801268 <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <sys_exit_env>:


void sys_exit_env(void)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 21                	push   $0x21
  801620:	e8 43 fc ff ff       	call   801268 <syscall>
  801625:	83 c4 18             	add    $0x18,%esp
}
  801628:	90                   	nop
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801631:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801634:	8d 50 04             	lea    0x4(%eax),%edx
  801637:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	52                   	push   %edx
  801641:	50                   	push   %eax
  801642:	6a 22                	push   $0x22
  801644:	e8 1f fc ff ff       	call   801268 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
	return result;
  80164c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80164f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801652:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801655:	89 01                	mov    %eax,(%ecx)
  801657:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	c9                   	leave  
  80165e:	c2 04 00             	ret    $0x4

00801661 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	ff 75 10             	pushl  0x10(%ebp)
  80166b:	ff 75 0c             	pushl  0xc(%ebp)
  80166e:	ff 75 08             	pushl  0x8(%ebp)
  801671:	6a 10                	push   $0x10
  801673:	e8 f0 fb ff ff       	call   801268 <syscall>
  801678:	83 c4 18             	add    $0x18,%esp
	return ;
  80167b:	90                   	nop
}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <sys_rcr2>:
uint32 sys_rcr2()
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 23                	push   $0x23
  80168d:	e8 d6 fb ff ff       	call   801268 <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 04             	sub    $0x4,%esp
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016a3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	50                   	push   %eax
  8016b0:	6a 24                	push   $0x24
  8016b2:	e8 b1 fb ff ff       	call   801268 <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ba:	90                   	nop
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <rsttst>:
void rsttst()
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 26                	push   $0x26
  8016cc:	e8 97 fb ff ff       	call   801268 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d4:	90                   	nop
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 04             	sub    $0x4,%esp
  8016dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016e3:	8b 55 18             	mov    0x18(%ebp),%edx
  8016e6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016ea:	52                   	push   %edx
  8016eb:	50                   	push   %eax
  8016ec:	ff 75 10             	pushl  0x10(%ebp)
  8016ef:	ff 75 0c             	pushl  0xc(%ebp)
  8016f2:	ff 75 08             	pushl  0x8(%ebp)
  8016f5:	6a 25                	push   $0x25
  8016f7:	e8 6c fb ff ff       	call   801268 <syscall>
  8016fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ff:	90                   	nop
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <chktst>:
void chktst(uint32 n)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	ff 75 08             	pushl  0x8(%ebp)
  801710:	6a 27                	push   $0x27
  801712:	e8 51 fb ff ff       	call   801268 <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
	return ;
  80171a:	90                   	nop
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <inctst>:

void inctst()
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 28                	push   $0x28
  80172c:	e8 37 fb ff ff       	call   801268 <syscall>
  801731:	83 c4 18             	add    $0x18,%esp
	return ;
  801734:	90                   	nop
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <gettst>:
uint32 gettst()
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 29                	push   $0x29
  801746:	e8 1d fb ff ff       	call   801268 <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 2a                	push   $0x2a
  801762:	e8 01 fb ff ff       	call   801268 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
  80176a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80176d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801771:	75 07                	jne    80177a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801773:	b8 01 00 00 00       	mov    $0x1,%eax
  801778:	eb 05                	jmp    80177f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80177a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 2a                	push   $0x2a
  801793:	e8 d0 fa ff ff       	call   801268 <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
  80179b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80179e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017a2:	75 07                	jne    8017ab <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a9:	eb 05                	jmp    8017b0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 2a                	push   $0x2a
  8017c4:	e8 9f fa ff ff       	call   801268 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
  8017cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017cf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017d3:	75 07                	jne    8017dc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8017da:	eb 05                	jmp    8017e1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 2a                	push   $0x2a
  8017f5:	e8 6e fa ff ff       	call   801268 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
  8017fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801800:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801804:	75 07                	jne    80180d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801806:	b8 01 00 00 00       	mov    $0x1,%eax
  80180b:	eb 05                	jmp    801812 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80180d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	ff 75 08             	pushl  0x8(%ebp)
  801822:	6a 2b                	push   $0x2b
  801824:	e8 3f fa ff ff       	call   801268 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
	return ;
  80182c:	90                   	nop
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801833:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801836:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801839:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	6a 00                	push   $0x0
  801841:	53                   	push   %ebx
  801842:	51                   	push   %ecx
  801843:	52                   	push   %edx
  801844:	50                   	push   %eax
  801845:	6a 2c                	push   $0x2c
  801847:	e8 1c fa ff ff       	call   801268 <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
}
  80184f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801857:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	52                   	push   %edx
  801864:	50                   	push   %eax
  801865:	6a 2d                	push   $0x2d
  801867:	e8 fc f9 ff ff       	call   801268 <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801874:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801877:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	6a 00                	push   $0x0
  80187f:	51                   	push   %ecx
  801880:	ff 75 10             	pushl  0x10(%ebp)
  801883:	52                   	push   %edx
  801884:	50                   	push   %eax
  801885:	6a 2e                	push   $0x2e
  801887:	e8 dc f9 ff ff       	call   801268 <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	ff 75 10             	pushl  0x10(%ebp)
  80189b:	ff 75 0c             	pushl  0xc(%ebp)
  80189e:	ff 75 08             	pushl  0x8(%ebp)
  8018a1:	6a 0f                	push   $0xf
  8018a3:	e8 c0 f9 ff ff       	call   801268 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ab:	90                   	nop
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	50                   	push   %eax
  8018bd:	6a 2f                	push   $0x2f
  8018bf:	e8 a4 f9 ff ff       	call   801268 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	ff 75 0c             	pushl  0xc(%ebp)
  8018d5:	ff 75 08             	pushl  0x8(%ebp)
  8018d8:	6a 30                	push   $0x30
  8018da:	e8 89 f9 ff ff       	call   801268 <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  8018e2:	90                   	nop
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	ff 75 0c             	pushl  0xc(%ebp)
  8018f1:	ff 75 08             	pushl  0x8(%ebp)
  8018f4:	6a 31                	push   $0x31
  8018f6:	e8 6d f9 ff ff       	call   801268 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  8018fe:	90                   	nop
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    
  801901:	66 90                	xchg   %ax,%ax
  801903:	90                   	nop

00801904 <__udivdi3>:
  801904:	55                   	push   %ebp
  801905:	57                   	push   %edi
  801906:	56                   	push   %esi
  801907:	53                   	push   %ebx
  801908:	83 ec 1c             	sub    $0x1c,%esp
  80190b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80190f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801913:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801917:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80191b:	89 ca                	mov    %ecx,%edx
  80191d:	89 f8                	mov    %edi,%eax
  80191f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801923:	85 f6                	test   %esi,%esi
  801925:	75 2d                	jne    801954 <__udivdi3+0x50>
  801927:	39 cf                	cmp    %ecx,%edi
  801929:	77 65                	ja     801990 <__udivdi3+0x8c>
  80192b:	89 fd                	mov    %edi,%ebp
  80192d:	85 ff                	test   %edi,%edi
  80192f:	75 0b                	jne    80193c <__udivdi3+0x38>
  801931:	b8 01 00 00 00       	mov    $0x1,%eax
  801936:	31 d2                	xor    %edx,%edx
  801938:	f7 f7                	div    %edi
  80193a:	89 c5                	mov    %eax,%ebp
  80193c:	31 d2                	xor    %edx,%edx
  80193e:	89 c8                	mov    %ecx,%eax
  801940:	f7 f5                	div    %ebp
  801942:	89 c1                	mov    %eax,%ecx
  801944:	89 d8                	mov    %ebx,%eax
  801946:	f7 f5                	div    %ebp
  801948:	89 cf                	mov    %ecx,%edi
  80194a:	89 fa                	mov    %edi,%edx
  80194c:	83 c4 1c             	add    $0x1c,%esp
  80194f:	5b                   	pop    %ebx
  801950:	5e                   	pop    %esi
  801951:	5f                   	pop    %edi
  801952:	5d                   	pop    %ebp
  801953:	c3                   	ret    
  801954:	39 ce                	cmp    %ecx,%esi
  801956:	77 28                	ja     801980 <__udivdi3+0x7c>
  801958:	0f bd fe             	bsr    %esi,%edi
  80195b:	83 f7 1f             	xor    $0x1f,%edi
  80195e:	75 40                	jne    8019a0 <__udivdi3+0x9c>
  801960:	39 ce                	cmp    %ecx,%esi
  801962:	72 0a                	jb     80196e <__udivdi3+0x6a>
  801964:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801968:	0f 87 9e 00 00 00    	ja     801a0c <__udivdi3+0x108>
  80196e:	b8 01 00 00 00       	mov    $0x1,%eax
  801973:	89 fa                	mov    %edi,%edx
  801975:	83 c4 1c             	add    $0x1c,%esp
  801978:	5b                   	pop    %ebx
  801979:	5e                   	pop    %esi
  80197a:	5f                   	pop    %edi
  80197b:	5d                   	pop    %ebp
  80197c:	c3                   	ret    
  80197d:	8d 76 00             	lea    0x0(%esi),%esi
  801980:	31 ff                	xor    %edi,%edi
  801982:	31 c0                	xor    %eax,%eax
  801984:	89 fa                	mov    %edi,%edx
  801986:	83 c4 1c             	add    $0x1c,%esp
  801989:	5b                   	pop    %ebx
  80198a:	5e                   	pop    %esi
  80198b:	5f                   	pop    %edi
  80198c:	5d                   	pop    %ebp
  80198d:	c3                   	ret    
  80198e:	66 90                	xchg   %ax,%ax
  801990:	89 d8                	mov    %ebx,%eax
  801992:	f7 f7                	div    %edi
  801994:	31 ff                	xor    %edi,%edi
  801996:	89 fa                	mov    %edi,%edx
  801998:	83 c4 1c             	add    $0x1c,%esp
  80199b:	5b                   	pop    %ebx
  80199c:	5e                   	pop    %esi
  80199d:	5f                   	pop    %edi
  80199e:	5d                   	pop    %ebp
  80199f:	c3                   	ret    
  8019a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019a5:	89 eb                	mov    %ebp,%ebx
  8019a7:	29 fb                	sub    %edi,%ebx
  8019a9:	89 f9                	mov    %edi,%ecx
  8019ab:	d3 e6                	shl    %cl,%esi
  8019ad:	89 c5                	mov    %eax,%ebp
  8019af:	88 d9                	mov    %bl,%cl
  8019b1:	d3 ed                	shr    %cl,%ebp
  8019b3:	89 e9                	mov    %ebp,%ecx
  8019b5:	09 f1                	or     %esi,%ecx
  8019b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019bb:	89 f9                	mov    %edi,%ecx
  8019bd:	d3 e0                	shl    %cl,%eax
  8019bf:	89 c5                	mov    %eax,%ebp
  8019c1:	89 d6                	mov    %edx,%esi
  8019c3:	88 d9                	mov    %bl,%cl
  8019c5:	d3 ee                	shr    %cl,%esi
  8019c7:	89 f9                	mov    %edi,%ecx
  8019c9:	d3 e2                	shl    %cl,%edx
  8019cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019cf:	88 d9                	mov    %bl,%cl
  8019d1:	d3 e8                	shr    %cl,%eax
  8019d3:	09 c2                	or     %eax,%edx
  8019d5:	89 d0                	mov    %edx,%eax
  8019d7:	89 f2                	mov    %esi,%edx
  8019d9:	f7 74 24 0c          	divl   0xc(%esp)
  8019dd:	89 d6                	mov    %edx,%esi
  8019df:	89 c3                	mov    %eax,%ebx
  8019e1:	f7 e5                	mul    %ebp
  8019e3:	39 d6                	cmp    %edx,%esi
  8019e5:	72 19                	jb     801a00 <__udivdi3+0xfc>
  8019e7:	74 0b                	je     8019f4 <__udivdi3+0xf0>
  8019e9:	89 d8                	mov    %ebx,%eax
  8019eb:	31 ff                	xor    %edi,%edi
  8019ed:	e9 58 ff ff ff       	jmp    80194a <__udivdi3+0x46>
  8019f2:	66 90                	xchg   %ax,%ax
  8019f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019f8:	89 f9                	mov    %edi,%ecx
  8019fa:	d3 e2                	shl    %cl,%edx
  8019fc:	39 c2                	cmp    %eax,%edx
  8019fe:	73 e9                	jae    8019e9 <__udivdi3+0xe5>
  801a00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a03:	31 ff                	xor    %edi,%edi
  801a05:	e9 40 ff ff ff       	jmp    80194a <__udivdi3+0x46>
  801a0a:	66 90                	xchg   %ax,%ax
  801a0c:	31 c0                	xor    %eax,%eax
  801a0e:	e9 37 ff ff ff       	jmp    80194a <__udivdi3+0x46>
  801a13:	90                   	nop

00801a14 <__umoddi3>:
  801a14:	55                   	push   %ebp
  801a15:	57                   	push   %edi
  801a16:	56                   	push   %esi
  801a17:	53                   	push   %ebx
  801a18:	83 ec 1c             	sub    $0x1c,%esp
  801a1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a33:	89 f3                	mov    %esi,%ebx
  801a35:	89 fa                	mov    %edi,%edx
  801a37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a3b:	89 34 24             	mov    %esi,(%esp)
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	75 1a                	jne    801a5c <__umoddi3+0x48>
  801a42:	39 f7                	cmp    %esi,%edi
  801a44:	0f 86 a2 00 00 00    	jbe    801aec <__umoddi3+0xd8>
  801a4a:	89 c8                	mov    %ecx,%eax
  801a4c:	89 f2                	mov    %esi,%edx
  801a4e:	f7 f7                	div    %edi
  801a50:	89 d0                	mov    %edx,%eax
  801a52:	31 d2                	xor    %edx,%edx
  801a54:	83 c4 1c             	add    $0x1c,%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5f                   	pop    %edi
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    
  801a5c:	39 f0                	cmp    %esi,%eax
  801a5e:	0f 87 ac 00 00 00    	ja     801b10 <__umoddi3+0xfc>
  801a64:	0f bd e8             	bsr    %eax,%ebp
  801a67:	83 f5 1f             	xor    $0x1f,%ebp
  801a6a:	0f 84 ac 00 00 00    	je     801b1c <__umoddi3+0x108>
  801a70:	bf 20 00 00 00       	mov    $0x20,%edi
  801a75:	29 ef                	sub    %ebp,%edi
  801a77:	89 fe                	mov    %edi,%esi
  801a79:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a7d:	89 e9                	mov    %ebp,%ecx
  801a7f:	d3 e0                	shl    %cl,%eax
  801a81:	89 d7                	mov    %edx,%edi
  801a83:	89 f1                	mov    %esi,%ecx
  801a85:	d3 ef                	shr    %cl,%edi
  801a87:	09 c7                	or     %eax,%edi
  801a89:	89 e9                	mov    %ebp,%ecx
  801a8b:	d3 e2                	shl    %cl,%edx
  801a8d:	89 14 24             	mov    %edx,(%esp)
  801a90:	89 d8                	mov    %ebx,%eax
  801a92:	d3 e0                	shl    %cl,%eax
  801a94:	89 c2                	mov    %eax,%edx
  801a96:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a9a:	d3 e0                	shl    %cl,%eax
  801a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aa4:	89 f1                	mov    %esi,%ecx
  801aa6:	d3 e8                	shr    %cl,%eax
  801aa8:	09 d0                	or     %edx,%eax
  801aaa:	d3 eb                	shr    %cl,%ebx
  801aac:	89 da                	mov    %ebx,%edx
  801aae:	f7 f7                	div    %edi
  801ab0:	89 d3                	mov    %edx,%ebx
  801ab2:	f7 24 24             	mull   (%esp)
  801ab5:	89 c6                	mov    %eax,%esi
  801ab7:	89 d1                	mov    %edx,%ecx
  801ab9:	39 d3                	cmp    %edx,%ebx
  801abb:	0f 82 87 00 00 00    	jb     801b48 <__umoddi3+0x134>
  801ac1:	0f 84 91 00 00 00    	je     801b58 <__umoddi3+0x144>
  801ac7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801acb:	29 f2                	sub    %esi,%edx
  801acd:	19 cb                	sbb    %ecx,%ebx
  801acf:	89 d8                	mov    %ebx,%eax
  801ad1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ad5:	d3 e0                	shl    %cl,%eax
  801ad7:	89 e9                	mov    %ebp,%ecx
  801ad9:	d3 ea                	shr    %cl,%edx
  801adb:	09 d0                	or     %edx,%eax
  801add:	89 e9                	mov    %ebp,%ecx
  801adf:	d3 eb                	shr    %cl,%ebx
  801ae1:	89 da                	mov    %ebx,%edx
  801ae3:	83 c4 1c             	add    $0x1c,%esp
  801ae6:	5b                   	pop    %ebx
  801ae7:	5e                   	pop    %esi
  801ae8:	5f                   	pop    %edi
  801ae9:	5d                   	pop    %ebp
  801aea:	c3                   	ret    
  801aeb:	90                   	nop
  801aec:	89 fd                	mov    %edi,%ebp
  801aee:	85 ff                	test   %edi,%edi
  801af0:	75 0b                	jne    801afd <__umoddi3+0xe9>
  801af2:	b8 01 00 00 00       	mov    $0x1,%eax
  801af7:	31 d2                	xor    %edx,%edx
  801af9:	f7 f7                	div    %edi
  801afb:	89 c5                	mov    %eax,%ebp
  801afd:	89 f0                	mov    %esi,%eax
  801aff:	31 d2                	xor    %edx,%edx
  801b01:	f7 f5                	div    %ebp
  801b03:	89 c8                	mov    %ecx,%eax
  801b05:	f7 f5                	div    %ebp
  801b07:	89 d0                	mov    %edx,%eax
  801b09:	e9 44 ff ff ff       	jmp    801a52 <__umoddi3+0x3e>
  801b0e:	66 90                	xchg   %ax,%ax
  801b10:	89 c8                	mov    %ecx,%eax
  801b12:	89 f2                	mov    %esi,%edx
  801b14:	83 c4 1c             	add    $0x1c,%esp
  801b17:	5b                   	pop    %ebx
  801b18:	5e                   	pop    %esi
  801b19:	5f                   	pop    %edi
  801b1a:	5d                   	pop    %ebp
  801b1b:	c3                   	ret    
  801b1c:	3b 04 24             	cmp    (%esp),%eax
  801b1f:	72 06                	jb     801b27 <__umoddi3+0x113>
  801b21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b25:	77 0f                	ja     801b36 <__umoddi3+0x122>
  801b27:	89 f2                	mov    %esi,%edx
  801b29:	29 f9                	sub    %edi,%ecx
  801b2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b2f:	89 14 24             	mov    %edx,(%esp)
  801b32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b36:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b3a:	8b 14 24             	mov    (%esp),%edx
  801b3d:	83 c4 1c             	add    $0x1c,%esp
  801b40:	5b                   	pop    %ebx
  801b41:	5e                   	pop    %esi
  801b42:	5f                   	pop    %edi
  801b43:	5d                   	pop    %ebp
  801b44:	c3                   	ret    
  801b45:	8d 76 00             	lea    0x0(%esi),%esi
  801b48:	2b 04 24             	sub    (%esp),%eax
  801b4b:	19 fa                	sbb    %edi,%edx
  801b4d:	89 d1                	mov    %edx,%ecx
  801b4f:	89 c6                	mov    %eax,%esi
  801b51:	e9 71 ff ff ff       	jmp    801ac7 <__umoddi3+0xb3>
  801b56:	66 90                	xchg   %ax,%ax
  801b58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b5c:	72 ea                	jb     801b48 <__umoddi3+0x134>
  801b5e:	89 d9                	mov    %ebx,%ecx
  801b60:	e9 62 ff ff ff       	jmp    801ac7 <__umoddi3+0xb3>
