
obj/user/tst_syscalls_2_slave1:     file format elf32-i386


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
  800031:	e8 30 00 00 00       	call   800066 <libmain>
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
	//[1] NULL (0) address
	sys_allocate_user_mem(0,10);
  80003e:	83 ec 08             	sub    $0x8,%esp
  800041:	6a 0a                	push   $0xa
  800043:	6a 00                	push   $0x0
  800045:	e8 90 18 00 00       	call   8018da <sys_allocate_user_mem>
  80004a:	83 c4 10             	add    $0x10,%esp
	inctst();
  80004d:	e8 bd 16 00 00       	call   80170f <inctst>
	panic("tst system calls #2 failed: sys_allocate_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800052:	83 ec 04             	sub    $0x4,%esp
  800055:	68 60 1b 80 00       	push   $0x801b60
  80005a:	6a 0a                	push   $0xa
  80005c:	68 e2 1b 80 00       	push   $0x801be2
  800061:	e8 45 01 00 00       	call   8001ab <_panic>

00800066 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800066:	55                   	push   %ebp
  800067:	89 e5                	mov    %esp,%ebp
  800069:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006c:	e8 60 15 00 00       	call   8015d1 <sys_getenvindex>
  800071:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800074:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800077:	89 d0                	mov    %edx,%eax
  800079:	01 c0                	add    %eax,%eax
  80007b:	01 d0                	add    %edx,%eax
  80007d:	01 c0                	add    %eax,%eax
  80007f:	01 d0                	add    %edx,%eax
  800081:	c1 e0 02             	shl    $0x2,%eax
  800084:	01 d0                	add    %edx,%eax
  800086:	01 c0                	add    %eax,%eax
  800088:	01 d0                	add    %edx,%eax
  80008a:	c1 e0 02             	shl    $0x2,%eax
  80008d:	01 d0                	add    %edx,%eax
  80008f:	c1 e0 02             	shl    $0x2,%eax
  800092:	01 d0                	add    %edx,%eax
  800094:	c1 e0 02             	shl    $0x2,%eax
  800097:	01 d0                	add    %edx,%eax
  800099:	c1 e0 05             	shl    $0x5,%eax
  80009c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a1:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ab:	8a 40 5c             	mov    0x5c(%eax),%al
  8000ae:	84 c0                	test   %al,%al
  8000b0:	74 0d                	je     8000bf <libmain+0x59>
		binaryname = myEnv->prog_name;
  8000b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b7:	83 c0 5c             	add    $0x5c,%eax
  8000ba:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000c3:	7e 0a                	jle    8000cf <libmain+0x69>
		binaryname = argv[0];
  8000c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c8:	8b 00                	mov    (%eax),%eax
  8000ca:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000cf:	83 ec 08             	sub    $0x8,%esp
  8000d2:	ff 75 0c             	pushl  0xc(%ebp)
  8000d5:	ff 75 08             	pushl  0x8(%ebp)
  8000d8:	e8 5b ff ff ff       	call   800038 <_main>
  8000dd:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000e0:	e8 f9 12 00 00       	call   8013de <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 18 1c 80 00       	push   $0x801c18
  8000ed:	e8 76 03 00 00       	call   800468 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fa:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  800100:	a1 20 30 80 00       	mov    0x803020,%eax
  800105:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  80010b:	83 ec 04             	sub    $0x4,%esp
  80010e:	52                   	push   %edx
  80010f:	50                   	push   %eax
  800110:	68 40 1c 80 00       	push   $0x801c40
  800115:	e8 4e 03 00 00       	call   800468 <cprintf>
  80011a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80011d:	a1 20 30 80 00       	mov    0x803020,%eax
  800122:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  800128:	a1 20 30 80 00       	mov    0x803020,%eax
  80012d:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  800133:	a1 20 30 80 00       	mov    0x803020,%eax
  800138:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  80013e:	51                   	push   %ecx
  80013f:	52                   	push   %edx
  800140:	50                   	push   %eax
  800141:	68 68 1c 80 00       	push   $0x801c68
  800146:	e8 1d 03 00 00       	call   800468 <cprintf>
  80014b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80014e:	a1 20 30 80 00       	mov    0x803020,%eax
  800153:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  800159:	83 ec 08             	sub    $0x8,%esp
  80015c:	50                   	push   %eax
  80015d:	68 c0 1c 80 00       	push   $0x801cc0
  800162:	e8 01 03 00 00       	call   800468 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	68 18 1c 80 00       	push   $0x801c18
  800172:	e8 f1 02 00 00       	call   800468 <cprintf>
  800177:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80017a:	e8 79 12 00 00       	call   8013f8 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80017f:	e8 19 00 00 00       	call   80019d <exit>
}
  800184:	90                   	nop
  800185:	c9                   	leave  
  800186:	c3                   	ret    

00800187 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80018d:	83 ec 0c             	sub    $0xc,%esp
  800190:	6a 00                	push   $0x0
  800192:	e8 06 14 00 00       	call   80159d <sys_destroy_env>
  800197:	83 c4 10             	add    $0x10,%esp
}
  80019a:	90                   	nop
  80019b:	c9                   	leave  
  80019c:	c3                   	ret    

0080019d <exit>:

void
exit(void)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001a3:	e8 5b 14 00 00       	call   801603 <sys_exit_env>
}
  8001a8:	90                   	nop
  8001a9:	c9                   	leave  
  8001aa:	c3                   	ret    

008001ab <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001b1:	8d 45 10             	lea    0x10(%ebp),%eax
  8001b4:	83 c0 04             	add    $0x4,%eax
  8001b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001ba:	a1 28 31 80 00       	mov    0x803128,%eax
  8001bf:	85 c0                	test   %eax,%eax
  8001c1:	74 16                	je     8001d9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001c3:	a1 28 31 80 00       	mov    0x803128,%eax
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	50                   	push   %eax
  8001cc:	68 d4 1c 80 00       	push   $0x801cd4
  8001d1:	e8 92 02 00 00       	call   800468 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001d9:	a1 00 30 80 00       	mov    0x803000,%eax
  8001de:	ff 75 0c             	pushl  0xc(%ebp)
  8001e1:	ff 75 08             	pushl  0x8(%ebp)
  8001e4:	50                   	push   %eax
  8001e5:	68 d9 1c 80 00       	push   $0x801cd9
  8001ea:	e8 79 02 00 00       	call   800468 <cprintf>
  8001ef:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8001fb:	50                   	push   %eax
  8001fc:	e8 fc 01 00 00       	call   8003fd <vcprintf>
  800201:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800204:	83 ec 08             	sub    $0x8,%esp
  800207:	6a 00                	push   $0x0
  800209:	68 f5 1c 80 00       	push   $0x801cf5
  80020e:	e8 ea 01 00 00       	call   8003fd <vcprintf>
  800213:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800216:	e8 82 ff ff ff       	call   80019d <exit>

	// should not return here
	while (1) ;
  80021b:	eb fe                	jmp    80021b <_panic+0x70>

0080021d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800223:	a1 20 30 80 00       	mov    0x803020,%eax
  800228:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  80022e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800231:	39 c2                	cmp    %eax,%edx
  800233:	74 14                	je     800249 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800235:	83 ec 04             	sub    $0x4,%esp
  800238:	68 f8 1c 80 00       	push   $0x801cf8
  80023d:	6a 26                	push   $0x26
  80023f:	68 44 1d 80 00       	push   $0x801d44
  800244:	e8 62 ff ff ff       	call   8001ab <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800249:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800250:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800257:	e9 c5 00 00 00       	jmp    800321 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80025c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80025f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800266:	8b 45 08             	mov    0x8(%ebp),%eax
  800269:	01 d0                	add    %edx,%eax
  80026b:	8b 00                	mov    (%eax),%eax
  80026d:	85 c0                	test   %eax,%eax
  80026f:	75 08                	jne    800279 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800271:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800274:	e9 a5 00 00 00       	jmp    80031e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800279:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800280:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800287:	eb 69                	jmp    8002f2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800289:	a1 20 30 80 00       	mov    0x803020,%eax
  80028e:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  800294:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800297:	89 d0                	mov    %edx,%eax
  800299:	01 c0                	add    %eax,%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	c1 e0 03             	shl    $0x3,%eax
  8002a0:	01 c8                	add    %ecx,%eax
  8002a2:	8a 40 04             	mov    0x4(%eax),%al
  8002a5:	84 c0                	test   %al,%al
  8002a7:	75 46                	jne    8002ef <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ae:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  8002b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002b7:	89 d0                	mov    %edx,%eax
  8002b9:	01 c0                	add    %eax,%eax
  8002bb:	01 d0                	add    %edx,%eax
  8002bd:	c1 e0 03             	shl    $0x3,%eax
  8002c0:	01 c8                	add    %ecx,%eax
  8002c2:	8b 00                	mov    (%eax),%eax
  8002c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002cf:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002db:	8b 45 08             	mov    0x8(%ebp),%eax
  8002de:	01 c8                	add    %ecx,%eax
  8002e0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002e2:	39 c2                	cmp    %eax,%edx
  8002e4:	75 09                	jne    8002ef <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002e6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002ed:	eb 15                	jmp    800304 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002ef:	ff 45 e8             	incl   -0x18(%ebp)
  8002f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f7:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  8002fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800300:	39 c2                	cmp    %eax,%edx
  800302:	77 85                	ja     800289 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800304:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800308:	75 14                	jne    80031e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80030a:	83 ec 04             	sub    $0x4,%esp
  80030d:	68 50 1d 80 00       	push   $0x801d50
  800312:	6a 3a                	push   $0x3a
  800314:	68 44 1d 80 00       	push   $0x801d44
  800319:	e8 8d fe ff ff       	call   8001ab <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80031e:	ff 45 f0             	incl   -0x10(%ebp)
  800321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800324:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800327:	0f 8c 2f ff ff ff    	jl     80025c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80032d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800334:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80033b:	eb 26                	jmp    800363 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80033d:	a1 20 30 80 00       	mov    0x803020,%eax
  800342:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  800348:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80034b:	89 d0                	mov    %edx,%eax
  80034d:	01 c0                	add    %eax,%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	c1 e0 03             	shl    $0x3,%eax
  800354:	01 c8                	add    %ecx,%eax
  800356:	8a 40 04             	mov    0x4(%eax),%al
  800359:	3c 01                	cmp    $0x1,%al
  80035b:	75 03                	jne    800360 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80035d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800360:	ff 45 e0             	incl   -0x20(%ebp)
  800363:	a1 20 30 80 00       	mov    0x803020,%eax
  800368:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  80036e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800371:	39 c2                	cmp    %eax,%edx
  800373:	77 c8                	ja     80033d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800378:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80037b:	74 14                	je     800391 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	68 a4 1d 80 00       	push   $0x801da4
  800385:	6a 44                	push   $0x44
  800387:	68 44 1d 80 00       	push   $0x801d44
  80038c:	e8 1a fe ff ff       	call   8001ab <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800391:	90                   	nop
  800392:	c9                   	leave  
  800393:	c3                   	ret    

00800394 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80039a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039d:	8b 00                	mov    (%eax),%eax
  80039f:	8d 48 01             	lea    0x1(%eax),%ecx
  8003a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a5:	89 0a                	mov    %ecx,(%edx)
  8003a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8003aa:	88 d1                	mov    %dl,%cl
  8003ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003af:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003bd:	75 2c                	jne    8003eb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003bf:	a0 24 30 80 00       	mov    0x803024,%al
  8003c4:	0f b6 c0             	movzbl %al,%eax
  8003c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ca:	8b 12                	mov    (%edx),%edx
  8003cc:	89 d1                	mov    %edx,%ecx
  8003ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d1:	83 c2 08             	add    $0x8,%edx
  8003d4:	83 ec 04             	sub    $0x4,%esp
  8003d7:	50                   	push   %eax
  8003d8:	51                   	push   %ecx
  8003d9:	52                   	push   %edx
  8003da:	e8 a6 0e 00 00       	call   801285 <sys_cputs>
  8003df:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ee:	8b 40 04             	mov    0x4(%eax),%eax
  8003f1:	8d 50 01             	lea    0x1(%eax),%edx
  8003f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003fa:	90                   	nop
  8003fb:	c9                   	leave  
  8003fc:	c3                   	ret    

008003fd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800406:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80040d:	00 00 00 
	b.cnt = 0;
  800410:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800417:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80041a:	ff 75 0c             	pushl  0xc(%ebp)
  80041d:	ff 75 08             	pushl  0x8(%ebp)
  800420:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800426:	50                   	push   %eax
  800427:	68 94 03 80 00       	push   $0x800394
  80042c:	e8 11 02 00 00       	call   800642 <vprintfmt>
  800431:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800434:	a0 24 30 80 00       	mov    0x803024,%al
  800439:	0f b6 c0             	movzbl %al,%eax
  80043c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	50                   	push   %eax
  800446:	52                   	push   %edx
  800447:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80044d:	83 c0 08             	add    $0x8,%eax
  800450:	50                   	push   %eax
  800451:	e8 2f 0e 00 00       	call   801285 <sys_cputs>
  800456:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800459:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800460:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800466:	c9                   	leave  
  800467:	c3                   	ret    

00800468 <cprintf>:

int cprintf(const char *fmt, ...) {
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
  80046b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80046e:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800475:	8d 45 0c             	lea    0xc(%ebp),%eax
  800478:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	ff 75 f4             	pushl  -0xc(%ebp)
  800484:	50                   	push   %eax
  800485:	e8 73 ff ff ff       	call   8003fd <vcprintf>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800490:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800493:	c9                   	leave  
  800494:	c3                   	ret    

00800495 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800495:	55                   	push   %ebp
  800496:	89 e5                	mov    %esp,%ebp
  800498:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80049b:	e8 3e 0f 00 00       	call   8013de <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8004af:	50                   	push   %eax
  8004b0:	e8 48 ff ff ff       	call   8003fd <vcprintf>
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004bb:	e8 38 0f 00 00       	call   8013f8 <sys_enable_interrupt>
	return cnt;
  8004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004c3:	c9                   	leave  
  8004c4:	c3                   	ret    

008004c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
  8004c8:	53                   	push   %ebx
  8004c9:	83 ec 14             	sub    $0x14,%esp
  8004cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d8:	8b 45 18             	mov    0x18(%ebp),%eax
  8004db:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e3:	77 55                	ja     80053a <printnum+0x75>
  8004e5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e8:	72 05                	jb     8004ef <printnum+0x2a>
  8004ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004ed:	77 4b                	ja     80053a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ef:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004f2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fd:	52                   	push   %edx
  8004fe:	50                   	push   %eax
  8004ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800502:	ff 75 f0             	pushl  -0x10(%ebp)
  800505:	e8 ee 13 00 00       	call   8018f8 <__udivdi3>
  80050a:	83 c4 10             	add    $0x10,%esp
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	ff 75 20             	pushl  0x20(%ebp)
  800513:	53                   	push   %ebx
  800514:	ff 75 18             	pushl  0x18(%ebp)
  800517:	52                   	push   %edx
  800518:	50                   	push   %eax
  800519:	ff 75 0c             	pushl  0xc(%ebp)
  80051c:	ff 75 08             	pushl  0x8(%ebp)
  80051f:	e8 a1 ff ff ff       	call   8004c5 <printnum>
  800524:	83 c4 20             	add    $0x20,%esp
  800527:	eb 1a                	jmp    800543 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800529:	83 ec 08             	sub    $0x8,%esp
  80052c:	ff 75 0c             	pushl  0xc(%ebp)
  80052f:	ff 75 20             	pushl  0x20(%ebp)
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	ff d0                	call   *%eax
  800537:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80053a:	ff 4d 1c             	decl   0x1c(%ebp)
  80053d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800541:	7f e6                	jg     800529 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800543:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800546:	bb 00 00 00 00       	mov    $0x0,%ebx
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800551:	53                   	push   %ebx
  800552:	51                   	push   %ecx
  800553:	52                   	push   %edx
  800554:	50                   	push   %eax
  800555:	e8 ae 14 00 00       	call   801a08 <__umoddi3>
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	05 14 20 80 00       	add    $0x802014,%eax
  800562:	8a 00                	mov    (%eax),%al
  800564:	0f be c0             	movsbl %al,%eax
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	ff 75 0c             	pushl  0xc(%ebp)
  80056d:	50                   	push   %eax
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	ff d0                	call   *%eax
  800573:	83 c4 10             	add    $0x10,%esp
}
  800576:	90                   	nop
  800577:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80057a:	c9                   	leave  
  80057b:	c3                   	ret    

0080057c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80057f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800583:	7e 1c                	jle    8005a1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	8d 50 08             	lea    0x8(%eax),%edx
  80058d:	8b 45 08             	mov    0x8(%ebp),%eax
  800590:	89 10                	mov    %edx,(%eax)
  800592:	8b 45 08             	mov    0x8(%ebp),%eax
  800595:	8b 00                	mov    (%eax),%eax
  800597:	83 e8 08             	sub    $0x8,%eax
  80059a:	8b 50 04             	mov    0x4(%eax),%edx
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	eb 40                	jmp    8005e1 <getuint+0x65>
	else if (lflag)
  8005a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005a5:	74 1e                	je     8005c5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	8d 50 04             	lea    0x4(%eax),%edx
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	89 10                	mov    %edx,(%eax)
  8005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	83 e8 04             	sub    $0x4,%eax
  8005bc:	8b 00                	mov    (%eax),%eax
  8005be:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c3:	eb 1c                	jmp    8005e1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	8d 50 04             	lea    0x4(%eax),%edx
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	89 10                	mov    %edx,(%eax)
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	83 e8 04             	sub    $0x4,%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005e1:	5d                   	pop    %ebp
  8005e2:	c3                   	ret    

008005e3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005e3:	55                   	push   %ebp
  8005e4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005e6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005ea:	7e 1c                	jle    800608 <getint+0x25>
		return va_arg(*ap, long long);
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	8d 50 08             	lea    0x8(%eax),%edx
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	89 10                	mov    %edx,(%eax)
  8005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	83 e8 08             	sub    $0x8,%eax
  800601:	8b 50 04             	mov    0x4(%eax),%edx
  800604:	8b 00                	mov    (%eax),%eax
  800606:	eb 38                	jmp    800640 <getint+0x5d>
	else if (lflag)
  800608:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80060c:	74 1a                	je     800628 <getint+0x45>
		return va_arg(*ap, long);
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	8d 50 04             	lea    0x4(%eax),%edx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	89 10                	mov    %edx,(%eax)
  80061b:	8b 45 08             	mov    0x8(%ebp),%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	83 e8 04             	sub    $0x4,%eax
  800623:	8b 00                	mov    (%eax),%eax
  800625:	99                   	cltd   
  800626:	eb 18                	jmp    800640 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	8d 50 04             	lea    0x4(%eax),%edx
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	89 10                	mov    %edx,(%eax)
  800635:	8b 45 08             	mov    0x8(%ebp),%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	83 e8 04             	sub    $0x4,%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	99                   	cltd   
}
  800640:	5d                   	pop    %ebp
  800641:	c3                   	ret    

00800642 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800642:	55                   	push   %ebp
  800643:	89 e5                	mov    %esp,%ebp
  800645:	56                   	push   %esi
  800646:	53                   	push   %ebx
  800647:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064a:	eb 17                	jmp    800663 <vprintfmt+0x21>
			if (ch == '\0')
  80064c:	85 db                	test   %ebx,%ebx
  80064e:	0f 84 af 03 00 00    	je     800a03 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	53                   	push   %ebx
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	ff d0                	call   *%eax
  800660:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800663:	8b 45 10             	mov    0x10(%ebp),%eax
  800666:	8d 50 01             	lea    0x1(%eax),%edx
  800669:	89 55 10             	mov    %edx,0x10(%ebp)
  80066c:	8a 00                	mov    (%eax),%al
  80066e:	0f b6 d8             	movzbl %al,%ebx
  800671:	83 fb 25             	cmp    $0x25,%ebx
  800674:	75 d6                	jne    80064c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800676:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80067a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800681:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800688:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80068f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800696:	8b 45 10             	mov    0x10(%ebp),%eax
  800699:	8d 50 01             	lea    0x1(%eax),%edx
  80069c:	89 55 10             	mov    %edx,0x10(%ebp)
  80069f:	8a 00                	mov    (%eax),%al
  8006a1:	0f b6 d8             	movzbl %al,%ebx
  8006a4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006a7:	83 f8 55             	cmp    $0x55,%eax
  8006aa:	0f 87 2b 03 00 00    	ja     8009db <vprintfmt+0x399>
  8006b0:	8b 04 85 38 20 80 00 	mov    0x802038(,%eax,4),%eax
  8006b7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006b9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006bd:	eb d7                	jmp    800696 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006bf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006c3:	eb d1                	jmp    800696 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006cf:	89 d0                	mov    %edx,%eax
  8006d1:	c1 e0 02             	shl    $0x2,%eax
  8006d4:	01 d0                	add    %edx,%eax
  8006d6:	01 c0                	add    %eax,%eax
  8006d8:	01 d8                	add    %ebx,%eax
  8006da:	83 e8 30             	sub    $0x30,%eax
  8006dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e3:	8a 00                	mov    (%eax),%al
  8006e5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006e8:	83 fb 2f             	cmp    $0x2f,%ebx
  8006eb:	7e 3e                	jle    80072b <vprintfmt+0xe9>
  8006ed:	83 fb 39             	cmp    $0x39,%ebx
  8006f0:	7f 39                	jg     80072b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006f5:	eb d5                	jmp    8006cc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	83 c0 04             	add    $0x4,%eax
  8006fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	83 e8 04             	sub    $0x4,%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80070b:	eb 1f                	jmp    80072c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80070d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800711:	79 83                	jns    800696 <vprintfmt+0x54>
				width = 0;
  800713:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80071a:	e9 77 ff ff ff       	jmp    800696 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80071f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800726:	e9 6b ff ff ff       	jmp    800696 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80072b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80072c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800730:	0f 89 60 ff ff ff    	jns    800696 <vprintfmt+0x54>
				width = precision, precision = -1;
  800736:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800739:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800743:	e9 4e ff ff ff       	jmp    800696 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800748:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80074b:	e9 46 ff ff ff       	jmp    800696 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	83 c0 04             	add    $0x4,%eax
  800756:	89 45 14             	mov    %eax,0x14(%ebp)
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	83 e8 04             	sub    $0x4,%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	50                   	push   %eax
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	ff d0                	call   *%eax
  80076d:	83 c4 10             	add    $0x10,%esp
			break;
  800770:	e9 89 02 00 00       	jmp    8009fe <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	83 c0 04             	add    $0x4,%eax
  80077b:	89 45 14             	mov    %eax,0x14(%ebp)
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	83 e8 04             	sub    $0x4,%eax
  800784:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800786:	85 db                	test   %ebx,%ebx
  800788:	79 02                	jns    80078c <vprintfmt+0x14a>
				err = -err;
  80078a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80078c:	83 fb 64             	cmp    $0x64,%ebx
  80078f:	7f 0b                	jg     80079c <vprintfmt+0x15a>
  800791:	8b 34 9d 80 1e 80 00 	mov    0x801e80(,%ebx,4),%esi
  800798:	85 f6                	test   %esi,%esi
  80079a:	75 19                	jne    8007b5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80079c:	53                   	push   %ebx
  80079d:	68 25 20 80 00       	push   $0x802025
  8007a2:	ff 75 0c             	pushl  0xc(%ebp)
  8007a5:	ff 75 08             	pushl  0x8(%ebp)
  8007a8:	e8 5e 02 00 00       	call   800a0b <printfmt>
  8007ad:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007b0:	e9 49 02 00 00       	jmp    8009fe <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007b5:	56                   	push   %esi
  8007b6:	68 2e 20 80 00       	push   $0x80202e
  8007bb:	ff 75 0c             	pushl  0xc(%ebp)
  8007be:	ff 75 08             	pushl  0x8(%ebp)
  8007c1:	e8 45 02 00 00       	call   800a0b <printfmt>
  8007c6:	83 c4 10             	add    $0x10,%esp
			break;
  8007c9:	e9 30 02 00 00       	jmp    8009fe <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	83 c0 04             	add    $0x4,%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	83 e8 04             	sub    $0x4,%eax
  8007dd:	8b 30                	mov    (%eax),%esi
  8007df:	85 f6                	test   %esi,%esi
  8007e1:	75 05                	jne    8007e8 <vprintfmt+0x1a6>
				p = "(null)";
  8007e3:	be 31 20 80 00       	mov    $0x802031,%esi
			if (width > 0 && padc != '-')
  8007e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ec:	7e 6d                	jle    80085b <vprintfmt+0x219>
  8007ee:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007f2:	74 67                	je     80085b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	50                   	push   %eax
  8007fb:	56                   	push   %esi
  8007fc:	e8 0c 03 00 00       	call   800b0d <strnlen>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800807:	eb 16                	jmp    80081f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800809:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	50                   	push   %eax
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	ff d0                	call   *%eax
  800819:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80081c:	ff 4d e4             	decl   -0x1c(%ebp)
  80081f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800823:	7f e4                	jg     800809 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800825:	eb 34                	jmp    80085b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800827:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80082b:	74 1c                	je     800849 <vprintfmt+0x207>
  80082d:	83 fb 1f             	cmp    $0x1f,%ebx
  800830:	7e 05                	jle    800837 <vprintfmt+0x1f5>
  800832:	83 fb 7e             	cmp    $0x7e,%ebx
  800835:	7e 12                	jle    800849 <vprintfmt+0x207>
					putch('?', putdat);
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	6a 3f                	push   $0x3f
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	ff d0                	call   *%eax
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	eb 0f                	jmp    800858 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	ff 75 0c             	pushl  0xc(%ebp)
  80084f:	53                   	push   %ebx
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	ff d0                	call   *%eax
  800855:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800858:	ff 4d e4             	decl   -0x1c(%ebp)
  80085b:	89 f0                	mov    %esi,%eax
  80085d:	8d 70 01             	lea    0x1(%eax),%esi
  800860:	8a 00                	mov    (%eax),%al
  800862:	0f be d8             	movsbl %al,%ebx
  800865:	85 db                	test   %ebx,%ebx
  800867:	74 24                	je     80088d <vprintfmt+0x24b>
  800869:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80086d:	78 b8                	js     800827 <vprintfmt+0x1e5>
  80086f:	ff 4d e0             	decl   -0x20(%ebp)
  800872:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800876:	79 af                	jns    800827 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800878:	eb 13                	jmp    80088d <vprintfmt+0x24b>
				putch(' ', putdat);
  80087a:	83 ec 08             	sub    $0x8,%esp
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	6a 20                	push   $0x20
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	ff d0                	call   *%eax
  800887:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80088a:	ff 4d e4             	decl   -0x1c(%ebp)
  80088d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800891:	7f e7                	jg     80087a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800893:	e9 66 01 00 00       	jmp    8009fe <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	ff 75 e8             	pushl  -0x18(%ebp)
  80089e:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a1:	50                   	push   %eax
  8008a2:	e8 3c fd ff ff       	call   8005e3 <getint>
  8008a7:	83 c4 10             	add    $0x10,%esp
  8008aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b6:	85 d2                	test   %edx,%edx
  8008b8:	79 23                	jns    8008dd <vprintfmt+0x29b>
				putch('-', putdat);
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	6a 2d                	push   $0x2d
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	ff d0                	call   *%eax
  8008c7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d0:	f7 d8                	neg    %eax
  8008d2:	83 d2 00             	adc    $0x0,%edx
  8008d5:	f7 da                	neg    %edx
  8008d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008e4:	e9 bc 00 00 00       	jmp    8009a5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f2:	50                   	push   %eax
  8008f3:	e8 84 fc ff ff       	call   80057c <getuint>
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800901:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800908:	e9 98 00 00 00       	jmp    8009a5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	6a 58                	push   $0x58
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80091d:	83 ec 08             	sub    $0x8,%esp
  800920:	ff 75 0c             	pushl  0xc(%ebp)
  800923:	6a 58                	push   $0x58
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	ff d0                	call   *%eax
  80092a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	ff 75 0c             	pushl  0xc(%ebp)
  800933:	6a 58                	push   $0x58
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	ff d0                	call   *%eax
  80093a:	83 c4 10             	add    $0x10,%esp
			break;
  80093d:	e9 bc 00 00 00       	jmp    8009fe <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	6a 30                	push   $0x30
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	ff d0                	call   *%eax
  80094f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	6a 78                	push   $0x78
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	ff d0                	call   *%eax
  80095f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800962:	8b 45 14             	mov    0x14(%ebp),%eax
  800965:	83 c0 04             	add    $0x4,%eax
  800968:	89 45 14             	mov    %eax,0x14(%ebp)
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 e8 04             	sub    $0x4,%eax
  800971:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800973:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800976:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80097d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800984:	eb 1f                	jmp    8009a5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	ff 75 e8             	pushl  -0x18(%ebp)
  80098c:	8d 45 14             	lea    0x14(%ebp),%eax
  80098f:	50                   	push   %eax
  800990:	e8 e7 fb ff ff       	call   80057c <getuint>
  800995:	83 c4 10             	add    $0x10,%esp
  800998:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80099e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009a5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ac:	83 ec 04             	sub    $0x4,%esp
  8009af:	52                   	push   %edx
  8009b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009b3:	50                   	push   %eax
  8009b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ba:	ff 75 0c             	pushl  0xc(%ebp)
  8009bd:	ff 75 08             	pushl  0x8(%ebp)
  8009c0:	e8 00 fb ff ff       	call   8004c5 <printnum>
  8009c5:	83 c4 20             	add    $0x20,%esp
			break;
  8009c8:	eb 34                	jmp    8009fe <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	53                   	push   %ebx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			break;
  8009d9:	eb 23                	jmp    8009fe <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 25                	push   $0x25
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009eb:	ff 4d 10             	decl   0x10(%ebp)
  8009ee:	eb 03                	jmp    8009f3 <vprintfmt+0x3b1>
  8009f0:	ff 4d 10             	decl   0x10(%ebp)
  8009f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f6:	48                   	dec    %eax
  8009f7:	8a 00                	mov    (%eax),%al
  8009f9:	3c 25                	cmp    $0x25,%al
  8009fb:	75 f3                	jne    8009f0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009fd:	90                   	nop
		}
	}
  8009fe:	e9 47 fc ff ff       	jmp    80064a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a03:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a07:	5b                   	pop    %ebx
  800a08:	5e                   	pop    %esi
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a11:	8d 45 10             	lea    0x10(%ebp),%eax
  800a14:	83 c0 04             	add    $0x4,%eax
  800a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a20:	50                   	push   %eax
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	ff 75 08             	pushl  0x8(%ebp)
  800a27:	e8 16 fc ff ff       	call   800642 <vprintfmt>
  800a2c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a2f:	90                   	nop
  800a30:	c9                   	leave  
  800a31:	c3                   	ret    

00800a32 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a38:	8b 40 08             	mov    0x8(%eax),%eax
  800a3b:	8d 50 01             	lea    0x1(%eax),%edx
  800a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a41:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a47:	8b 10                	mov    (%eax),%edx
  800a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4c:	8b 40 04             	mov    0x4(%eax),%eax
  800a4f:	39 c2                	cmp    %eax,%edx
  800a51:	73 12                	jae    800a65 <sprintputch+0x33>
		*b->buf++ = ch;
  800a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a56:	8b 00                	mov    (%eax),%eax
  800a58:	8d 48 01             	lea    0x1(%eax),%ecx
  800a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5e:	89 0a                	mov    %ecx,(%edx)
  800a60:	8b 55 08             	mov    0x8(%ebp),%edx
  800a63:	88 10                	mov    %dl,(%eax)
}
  800a65:	90                   	nop
  800a66:	5d                   	pop    %ebp
  800a67:	c3                   	ret    

00800a68 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a77:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	01 d0                	add    %edx,%eax
  800a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a8d:	74 06                	je     800a95 <vsnprintf+0x2d>
  800a8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a93:	7f 07                	jg     800a9c <vsnprintf+0x34>
		return -E_INVAL;
  800a95:	b8 03 00 00 00       	mov    $0x3,%eax
  800a9a:	eb 20                	jmp    800abc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a9c:	ff 75 14             	pushl  0x14(%ebp)
  800a9f:	ff 75 10             	pushl  0x10(%ebp)
  800aa2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aa5:	50                   	push   %eax
  800aa6:	68 32 0a 80 00       	push   $0x800a32
  800aab:	e8 92 fb ff ff       	call   800642 <vprintfmt>
  800ab0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ab3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800abc:	c9                   	leave  
  800abd:	c3                   	ret    

00800abe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ac4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ac7:	83 c0 04             	add    $0x4,%eax
  800aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800acd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad3:	50                   	push   %eax
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	ff 75 08             	pushl  0x8(%ebp)
  800ada:	e8 89 ff ff ff       	call   800a68 <vsnprintf>
  800adf:	83 c4 10             	add    $0x10,%esp
  800ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ae8:	c9                   	leave  
  800ae9:	c3                   	ret    

00800aea <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800af0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800af7:	eb 06                	jmp    800aff <strlen+0x15>
		n++;
  800af9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800afc:	ff 45 08             	incl   0x8(%ebp)
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8a 00                	mov    (%eax),%al
  800b04:	84 c0                	test   %al,%al
  800b06:	75 f1                	jne    800af9 <strlen+0xf>
		n++;
	return n;
  800b08:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b0b:	c9                   	leave  
  800b0c:	c3                   	ret    

00800b0d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b1a:	eb 09                	jmp    800b25 <strnlen+0x18>
		n++;
  800b1c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b1f:	ff 45 08             	incl   0x8(%ebp)
  800b22:	ff 4d 0c             	decl   0xc(%ebp)
  800b25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b29:	74 09                	je     800b34 <strnlen+0x27>
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	84 c0                	test   %al,%al
  800b32:	75 e8                	jne    800b1c <strnlen+0xf>
		n++;
	return n;
  800b34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b37:	c9                   	leave  
  800b38:	c3                   	ret    

00800b39 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b45:	90                   	nop
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8d 50 01             	lea    0x1(%eax),%edx
  800b4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b52:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b55:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b58:	8a 12                	mov    (%edx),%dl
  800b5a:	88 10                	mov    %dl,(%eax)
  800b5c:	8a 00                	mov    (%eax),%al
  800b5e:	84 c0                	test   %al,%al
  800b60:	75 e4                	jne    800b46 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b62:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b7a:	eb 1f                	jmp    800b9b <strncpy+0x34>
		*dst++ = *src;
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8d 50 01             	lea    0x1(%eax),%edx
  800b82:	89 55 08             	mov    %edx,0x8(%ebp)
  800b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b88:	8a 12                	mov    (%edx),%dl
  800b8a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8f:	8a 00                	mov    (%eax),%al
  800b91:	84 c0                	test   %al,%al
  800b93:	74 03                	je     800b98 <strncpy+0x31>
			src++;
  800b95:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b98:	ff 45 fc             	incl   -0x4(%ebp)
  800b9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b9e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ba1:	72 d9                	jb     800b7c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ba3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ba6:	c9                   	leave  
  800ba7:	c3                   	ret    

00800ba8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bb8:	74 30                	je     800bea <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bba:	eb 16                	jmp    800bd2 <strlcpy+0x2a>
			*dst++ = *src++;
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8d 50 01             	lea    0x1(%eax),%edx
  800bc2:	89 55 08             	mov    %edx,0x8(%ebp)
  800bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bcb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bce:	8a 12                	mov    (%edx),%dl
  800bd0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bd2:	ff 4d 10             	decl   0x10(%ebp)
  800bd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bd9:	74 09                	je     800be4 <strlcpy+0x3c>
  800bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 d8                	jne    800bbc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bea:	8b 55 08             	mov    0x8(%ebp),%edx
  800bed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf0:	29 c2                	sub    %eax,%edx
  800bf2:	89 d0                	mov    %edx,%eax
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bf9:	eb 06                	jmp    800c01 <strcmp+0xb>
		p++, q++;
  800bfb:	ff 45 08             	incl   0x8(%ebp)
  800bfe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	84 c0                	test   %al,%al
  800c08:	74 0e                	je     800c18 <strcmp+0x22>
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8a 10                	mov    (%eax),%dl
  800c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	38 c2                	cmp    %al,%dl
  800c16:	74 e3                	je     800bfb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	0f b6 d0             	movzbl %al,%edx
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8a 00                	mov    (%eax),%al
  800c25:	0f b6 c0             	movzbl %al,%eax
  800c28:	29 c2                	sub    %eax,%edx
  800c2a:	89 d0                	mov    %edx,%eax
}
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    

00800c2e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c31:	eb 09                	jmp    800c3c <strncmp+0xe>
		n--, p++, q++;
  800c33:	ff 4d 10             	decl   0x10(%ebp)
  800c36:	ff 45 08             	incl   0x8(%ebp)
  800c39:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c40:	74 17                	je     800c59 <strncmp+0x2b>
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	8a 00                	mov    (%eax),%al
  800c47:	84 c0                	test   %al,%al
  800c49:	74 0e                	je     800c59 <strncmp+0x2b>
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	8a 10                	mov    (%eax),%dl
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	38 c2                	cmp    %al,%dl
  800c57:	74 da                	je     800c33 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5d:	75 07                	jne    800c66 <strncmp+0x38>
		return 0;
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c64:	eb 14                	jmp    800c7a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	8a 00                	mov    (%eax),%al
  800c6b:	0f b6 d0             	movzbl %al,%edx
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	8a 00                	mov    (%eax),%al
  800c73:	0f b6 c0             	movzbl %al,%eax
  800c76:	29 c2                	sub    %eax,%edx
  800c78:	89 d0                	mov    %edx,%eax
}
  800c7a:	5d                   	pop    %ebp
  800c7b:	c3                   	ret    

00800c7c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	83 ec 04             	sub    $0x4,%esp
  800c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c85:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c88:	eb 12                	jmp    800c9c <strchr+0x20>
		if (*s == c)
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c92:	75 05                	jne    800c99 <strchr+0x1d>
			return (char *) s;
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	eb 11                	jmp    800caa <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c99:	ff 45 08             	incl   0x8(%ebp)
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8a 00                	mov    (%eax),%al
  800ca1:	84 c0                	test   %al,%al
  800ca3:	75 e5                	jne    800c8a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ca5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800caa:	c9                   	leave  
  800cab:	c3                   	ret    

00800cac <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	83 ec 04             	sub    $0x4,%esp
  800cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cb8:	eb 0d                	jmp    800cc7 <strfind+0x1b>
		if (*s == c)
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cc2:	74 0e                	je     800cd2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cc4:	ff 45 08             	incl   0x8(%ebp)
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	84 c0                	test   %al,%al
  800cce:	75 ea                	jne    800cba <strfind+0xe>
  800cd0:	eb 01                	jmp    800cd3 <strfind+0x27>
		if (*s == c)
			break;
  800cd2:	90                   	nop
	return (char *) s;
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    

00800cd8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ce4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cea:	eb 0e                	jmp    800cfa <memset+0x22>
		*p++ = c;
  800cec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cef:	8d 50 01             	lea    0x1(%eax),%edx
  800cf2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cfa:	ff 4d f8             	decl   -0x8(%ebp)
  800cfd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d01:	79 e9                	jns    800cec <memset+0x14>
		*p++ = c;

	return v;
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d1a:	eb 16                	jmp    800d32 <memcpy+0x2a>
		*d++ = *s++;
  800d1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1f:	8d 50 01             	lea    0x1(%eax),%edx
  800d22:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d28:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d2e:	8a 12                	mov    (%edx),%dl
  800d30:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d32:	8b 45 10             	mov    0x10(%ebp),%eax
  800d35:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d38:	89 55 10             	mov    %edx,0x10(%ebp)
  800d3b:	85 c0                	test   %eax,%eax
  800d3d:	75 dd                	jne    800d1c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d42:	c9                   	leave  
  800d43:	c3                   	ret    

00800d44 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d59:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d5c:	73 50                	jae    800dae <memmove+0x6a>
  800d5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d61:	8b 45 10             	mov    0x10(%ebp),%eax
  800d64:	01 d0                	add    %edx,%eax
  800d66:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d69:	76 43                	jbe    800dae <memmove+0x6a>
		s += n;
  800d6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d71:	8b 45 10             	mov    0x10(%ebp),%eax
  800d74:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d77:	eb 10                	jmp    800d89 <memmove+0x45>
			*--d = *--s;
  800d79:	ff 4d f8             	decl   -0x8(%ebp)
  800d7c:	ff 4d fc             	decl   -0x4(%ebp)
  800d7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d82:	8a 10                	mov    (%eax),%dl
  800d84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d87:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d89:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8f:	89 55 10             	mov    %edx,0x10(%ebp)
  800d92:	85 c0                	test   %eax,%eax
  800d94:	75 e3                	jne    800d79 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d96:	eb 23                	jmp    800dbb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d9b:	8d 50 01             	lea    0x1(%eax),%edx
  800d9e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800da1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800da4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800daa:	8a 12                	mov    (%edx),%dl
  800dac:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dae:	8b 45 10             	mov    0x10(%ebp),%eax
  800db1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db4:	89 55 10             	mov    %edx,0x10(%ebp)
  800db7:	85 c0                	test   %eax,%eax
  800db9:	75 dd                	jne    800d98 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dd2:	eb 2a                	jmp    800dfe <memcmp+0x3e>
		if (*s1 != *s2)
  800dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd7:	8a 10                	mov    (%eax),%dl
  800dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	38 c2                	cmp    %al,%dl
  800de0:	74 16                	je     800df8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f b6 d0             	movzbl %al,%edx
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	0f b6 c0             	movzbl %al,%eax
  800df2:	29 c2                	sub    %eax,%edx
  800df4:	89 d0                	mov    %edx,%eax
  800df6:	eb 18                	jmp    800e10 <memcmp+0x50>
		s1++, s2++;
  800df8:	ff 45 fc             	incl   -0x4(%ebp)
  800dfb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800e01:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e04:	89 55 10             	mov    %edx,0x10(%ebp)
  800e07:	85 c0                	test   %eax,%eax
  800e09:	75 c9                	jne    800dd4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e18:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1e:	01 d0                	add    %edx,%eax
  800e20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e23:	eb 15                	jmp    800e3a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 00                	mov    (%eax),%al
  800e2a:	0f b6 d0             	movzbl %al,%edx
  800e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e30:	0f b6 c0             	movzbl %al,%eax
  800e33:	39 c2                	cmp    %eax,%edx
  800e35:	74 0d                	je     800e44 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e37:	ff 45 08             	incl   0x8(%ebp)
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e40:	72 e3                	jb     800e25 <memfind+0x13>
  800e42:	eb 01                	jmp    800e45 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e44:	90                   	nop
	return (void *) s;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e57:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e5e:	eb 03                	jmp    800e63 <strtol+0x19>
		s++;
  800e60:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	3c 20                	cmp    $0x20,%al
  800e6a:	74 f4                	je     800e60 <strtol+0x16>
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	3c 09                	cmp    $0x9,%al
  800e73:	74 eb                	je     800e60 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3c 2b                	cmp    $0x2b,%al
  800e7c:	75 05                	jne    800e83 <strtol+0x39>
		s++;
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	eb 13                	jmp    800e96 <strtol+0x4c>
	else if (*s == '-')
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8a 00                	mov    (%eax),%al
  800e88:	3c 2d                	cmp    $0x2d,%al
  800e8a:	75 0a                	jne    800e96 <strtol+0x4c>
		s++, neg = 1;
  800e8c:	ff 45 08             	incl   0x8(%ebp)
  800e8f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9a:	74 06                	je     800ea2 <strtol+0x58>
  800e9c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ea0:	75 20                	jne    800ec2 <strtol+0x78>
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	3c 30                	cmp    $0x30,%al
  800ea9:	75 17                	jne    800ec2 <strtol+0x78>
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	40                   	inc    %eax
  800eaf:	8a 00                	mov    (%eax),%al
  800eb1:	3c 78                	cmp    $0x78,%al
  800eb3:	75 0d                	jne    800ec2 <strtol+0x78>
		s += 2, base = 16;
  800eb5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eb9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ec0:	eb 28                	jmp    800eea <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ec2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec6:	75 15                	jne    800edd <strtol+0x93>
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	8a 00                	mov    (%eax),%al
  800ecd:	3c 30                	cmp    $0x30,%al
  800ecf:	75 0c                	jne    800edd <strtol+0x93>
		s++, base = 8;
  800ed1:	ff 45 08             	incl   0x8(%ebp)
  800ed4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800edb:	eb 0d                	jmp    800eea <strtol+0xa0>
	else if (base == 0)
  800edd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee1:	75 07                	jne    800eea <strtol+0xa0>
		base = 10;
  800ee3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	3c 2f                	cmp    $0x2f,%al
  800ef1:	7e 19                	jle    800f0c <strtol+0xc2>
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	3c 39                	cmp    $0x39,%al
  800efa:	7f 10                	jg     800f0c <strtol+0xc2>
			dig = *s - '0';
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	0f be c0             	movsbl %al,%eax
  800f04:	83 e8 30             	sub    $0x30,%eax
  800f07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f0a:	eb 42                	jmp    800f4e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	8a 00                	mov    (%eax),%al
  800f11:	3c 60                	cmp    $0x60,%al
  800f13:	7e 19                	jle    800f2e <strtol+0xe4>
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	8a 00                	mov    (%eax),%al
  800f1a:	3c 7a                	cmp    $0x7a,%al
  800f1c:	7f 10                	jg     800f2e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	0f be c0             	movsbl %al,%eax
  800f26:	83 e8 57             	sub    $0x57,%eax
  800f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f2c:	eb 20                	jmp    800f4e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 40                	cmp    $0x40,%al
  800f35:	7e 39                	jle    800f70 <strtol+0x126>
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	3c 5a                	cmp    $0x5a,%al
  800f3e:	7f 30                	jg     800f70 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	0f be c0             	movsbl %al,%eax
  800f48:	83 e8 37             	sub    $0x37,%eax
  800f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f51:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f54:	7d 19                	jge    800f6f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f56:	ff 45 08             	incl   0x8(%ebp)
  800f59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f60:	89 c2                	mov    %eax,%edx
  800f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f65:	01 d0                	add    %edx,%eax
  800f67:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f6a:	e9 7b ff ff ff       	jmp    800eea <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f6f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f74:	74 08                	je     800f7e <strtol+0x134>
		*endptr = (char *) s;
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f82:	74 07                	je     800f8b <strtol+0x141>
  800f84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f87:	f7 d8                	neg    %eax
  800f89:	eb 03                	jmp    800f8e <strtol+0x144>
  800f8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f8e:	c9                   	leave  
  800f8f:	c3                   	ret    

00800f90 <ltostr>:

void
ltostr(long value, char *str)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f9d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fa4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa8:	79 13                	jns    800fbd <ltostr+0x2d>
	{
		neg = 1;
  800faa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fb7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fba:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fc5:	99                   	cltd   
  800fc6:	f7 f9                	idiv   %ecx
  800fc8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fce:	8d 50 01             	lea    0x1(%eax),%edx
  800fd1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd4:	89 c2                	mov    %eax,%edx
  800fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd9:	01 d0                	add    %edx,%eax
  800fdb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fde:	83 c2 30             	add    $0x30,%edx
  800fe1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fe3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800feb:	f7 e9                	imul   %ecx
  800fed:	c1 fa 02             	sar    $0x2,%edx
  800ff0:	89 c8                	mov    %ecx,%eax
  800ff2:	c1 f8 1f             	sar    $0x1f,%eax
  800ff5:	29 c2                	sub    %eax,%edx
  800ff7:	89 d0                	mov    %edx,%eax
  800ff9:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800ffc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fff:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801004:	f7 e9                	imul   %ecx
  801006:	c1 fa 02             	sar    $0x2,%edx
  801009:	89 c8                	mov    %ecx,%eax
  80100b:	c1 f8 1f             	sar    $0x1f,%eax
  80100e:	29 c2                	sub    %eax,%edx
  801010:	89 d0                	mov    %edx,%eax
  801012:	c1 e0 02             	shl    $0x2,%eax
  801015:	01 d0                	add    %edx,%eax
  801017:	01 c0                	add    %eax,%eax
  801019:	29 c1                	sub    %eax,%ecx
  80101b:	89 ca                	mov    %ecx,%edx
  80101d:	85 d2                	test   %edx,%edx
  80101f:	75 9c                	jne    800fbd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801021:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801028:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102b:	48                   	dec    %eax
  80102c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80102f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801033:	74 3d                	je     801072 <ltostr+0xe2>
		start = 1 ;
  801035:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80103c:	eb 34                	jmp    801072 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80103e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	01 d0                	add    %edx,%eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80104b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801051:	01 c2                	add    %eax,%edx
  801053:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801056:	8b 45 0c             	mov    0xc(%ebp),%eax
  801059:	01 c8                	add    %ecx,%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80105f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801062:	8b 45 0c             	mov    0xc(%ebp),%eax
  801065:	01 c2                	add    %eax,%edx
  801067:	8a 45 eb             	mov    -0x15(%ebp),%al
  80106a:	88 02                	mov    %al,(%edx)
		start++ ;
  80106c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80106f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801075:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801078:	7c c4                	jl     80103e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80107a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	01 d0                	add    %edx,%eax
  801082:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801085:	90                   	nop
  801086:	c9                   	leave  
  801087:	c3                   	ret    

00801088 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80108e:	ff 75 08             	pushl  0x8(%ebp)
  801091:	e8 54 fa ff ff       	call   800aea <strlen>
  801096:	83 c4 04             	add    $0x4,%esp
  801099:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80109c:	ff 75 0c             	pushl  0xc(%ebp)
  80109f:	e8 46 fa ff ff       	call   800aea <strlen>
  8010a4:	83 c4 04             	add    $0x4,%esp
  8010a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b8:	eb 17                	jmp    8010d1 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c0:	01 c2                	add    %eax,%edx
  8010c2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	01 c8                	add    %ecx,%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010ce:	ff 45 fc             	incl   -0x4(%ebp)
  8010d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d7:	7c e1                	jl     8010ba <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010e7:	eb 1f                	jmp    801108 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	8d 50 01             	lea    0x1(%eax),%edx
  8010ef:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010f2:	89 c2                	mov    %eax,%edx
  8010f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f7:	01 c2                	add    %eax,%edx
  8010f9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ff:	01 c8                	add    %ecx,%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801105:	ff 45 f8             	incl   -0x8(%ebp)
  801108:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80110e:	7c d9                	jl     8010e9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801110:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	01 d0                	add    %edx,%eax
  801118:	c6 00 00             	movb   $0x0,(%eax)
}
  80111b:	90                   	nop
  80111c:	c9                   	leave  
  80111d:	c3                   	ret    

0080111e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801121:	8b 45 14             	mov    0x14(%ebp),%eax
  801124:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80112a:	8b 45 14             	mov    0x14(%ebp),%eax
  80112d:	8b 00                	mov    (%eax),%eax
  80112f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	01 d0                	add    %edx,%eax
  80113b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801141:	eb 0c                	jmp    80114f <strsplit+0x31>
			*string++ = 0;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8d 50 01             	lea    0x1(%eax),%edx
  801149:	89 55 08             	mov    %edx,0x8(%ebp)
  80114c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	84 c0                	test   %al,%al
  801156:	74 18                	je     801170 <strsplit+0x52>
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	0f be c0             	movsbl %al,%eax
  801160:	50                   	push   %eax
  801161:	ff 75 0c             	pushl  0xc(%ebp)
  801164:	e8 13 fb ff ff       	call   800c7c <strchr>
  801169:	83 c4 08             	add    $0x8,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	75 d3                	jne    801143 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	84 c0                	test   %al,%al
  801177:	74 5a                	je     8011d3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801179:	8b 45 14             	mov    0x14(%ebp),%eax
  80117c:	8b 00                	mov    (%eax),%eax
  80117e:	83 f8 0f             	cmp    $0xf,%eax
  801181:	75 07                	jne    80118a <strsplit+0x6c>
		{
			return 0;
  801183:	b8 00 00 00 00       	mov    $0x0,%eax
  801188:	eb 66                	jmp    8011f0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80118a:	8b 45 14             	mov    0x14(%ebp),%eax
  80118d:	8b 00                	mov    (%eax),%eax
  80118f:	8d 48 01             	lea    0x1(%eax),%ecx
  801192:	8b 55 14             	mov    0x14(%ebp),%edx
  801195:	89 0a                	mov    %ecx,(%edx)
  801197:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80119e:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a1:	01 c2                	add    %eax,%edx
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a8:	eb 03                	jmp    8011ad <strsplit+0x8f>
			string++;
  8011aa:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	84 c0                	test   %al,%al
  8011b4:	74 8b                	je     801141 <strsplit+0x23>
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	8a 00                	mov    (%eax),%al
  8011bb:	0f be c0             	movsbl %al,%eax
  8011be:	50                   	push   %eax
  8011bf:	ff 75 0c             	pushl  0xc(%ebp)
  8011c2:	e8 b5 fa ff ff       	call   800c7c <strchr>
  8011c7:	83 c4 08             	add    $0x8,%esp
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	74 dc                	je     8011aa <strsplit+0x8c>
			string++;
	}
  8011ce:	e9 6e ff ff ff       	jmp    801141 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011d3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d7:	8b 00                	mov    (%eax),%eax
  8011d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e3:	01 d0                	add    %edx,%eax
  8011e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011eb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011f0:	c9                   	leave  
  8011f1:	c3                   	ret    

008011f2 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  8011f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011fc:	74 06                	je     801204 <str2lower+0x12>
  8011fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801202:	75 07                	jne    80120b <str2lower+0x19>
		return NULL;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	eb 4d                	jmp    801258 <str2lower+0x66>
	}
	char *ref=dst;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  801211:	eb 33                	jmp    801246 <str2lower+0x54>
			if(*src>=65&&*src<=90){
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 40                	cmp    $0x40,%al
  80121a:	7e 1a                	jle    801236 <str2lower+0x44>
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 5a                	cmp    $0x5a,%al
  801223:	7f 11                	jg     801236 <str2lower+0x44>
				*dst=*src+32;
  801225:	8b 45 0c             	mov    0xc(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	83 c0 20             	add    $0x20,%eax
  80122d:	88 c2                	mov    %al,%dl
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	88 10                	mov    %dl,(%eax)
  801234:	eb 0a                	jmp    801240 <str2lower+0x4e>
			}
			else{
				*dst=*src;
  801236:	8b 45 0c             	mov    0xc(%ebp),%eax
  801239:	8a 10                	mov    (%eax),%dl
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	88 10                	mov    %dl,(%eax)
			}
			src++;
  801240:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  801243:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  801246:	8b 45 0c             	mov    0xc(%ebp),%eax
  801249:	8a 00                	mov    (%eax),%al
  80124b:	84 c0                	test   %al,%al
  80124d:	75 c4                	jne    801213 <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  801255:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801258:	c9                   	leave  
  801259:	c3                   	ret    

0080125a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	57                   	push   %edi
  80125e:	56                   	push   %esi
  80125f:	53                   	push   %ebx
  801260:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8b 55 0c             	mov    0xc(%ebp),%edx
  801269:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80126c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80126f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801272:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801275:	cd 30                	int    $0x30
  801277:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80127a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80127d:	83 c4 10             	add    $0x10,%esp
  801280:	5b                   	pop    %ebx
  801281:	5e                   	pop    %esi
  801282:	5f                   	pop    %edi
  801283:	5d                   	pop    %ebp
  801284:	c3                   	ret    

00801285 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 04             	sub    $0x4,%esp
  80128b:	8b 45 10             	mov    0x10(%ebp),%eax
  80128e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801291:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	6a 00                	push   $0x0
  80129a:	6a 00                	push   $0x0
  80129c:	52                   	push   %edx
  80129d:	ff 75 0c             	pushl  0xc(%ebp)
  8012a0:	50                   	push   %eax
  8012a1:	6a 00                	push   $0x0
  8012a3:	e8 b2 ff ff ff       	call   80125a <syscall>
  8012a8:	83 c4 18             	add    $0x18,%esp
}
  8012ab:	90                   	nop
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012b1:	6a 00                	push   $0x0
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 01                	push   $0x1
  8012bd:	e8 98 ff ff ff       	call   80125a <syscall>
  8012c2:	83 c4 18             	add    $0x18,%esp
}
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    

008012c7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	6a 00                	push   $0x0
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	52                   	push   %edx
  8012d7:	50                   	push   %eax
  8012d8:	6a 05                	push   $0x5
  8012da:	e8 7b ff ff ff       	call   80125a <syscall>
  8012df:	83 c4 18             	add    $0x18,%esp
}
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	56                   	push   %esi
  8012e8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012e9:	8b 75 18             	mov    0x18(%ebp),%esi
  8012ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	56                   	push   %esi
  8012f9:	53                   	push   %ebx
  8012fa:	51                   	push   %ecx
  8012fb:	52                   	push   %edx
  8012fc:	50                   	push   %eax
  8012fd:	6a 06                	push   $0x6
  8012ff:	e8 56 ff ff ff       	call   80125a <syscall>
  801304:	83 c4 18             	add    $0x18,%esp
}
  801307:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80130a:	5b                   	pop    %ebx
  80130b:	5e                   	pop    %esi
  80130c:	5d                   	pop    %ebp
  80130d:	c3                   	ret    

0080130e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801311:	8b 55 0c             	mov    0xc(%ebp),%edx
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	52                   	push   %edx
  80131e:	50                   	push   %eax
  80131f:	6a 07                	push   $0x7
  801321:	e8 34 ff ff ff       	call   80125a <syscall>
  801326:	83 c4 18             	add    $0x18,%esp
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	ff 75 0c             	pushl  0xc(%ebp)
  801337:	ff 75 08             	pushl  0x8(%ebp)
  80133a:	6a 08                	push   $0x8
  80133c:	e8 19 ff ff ff       	call   80125a <syscall>
  801341:	83 c4 18             	add    $0x18,%esp
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 09                	push   $0x9
  801355:	e8 00 ff ff ff       	call   80125a <syscall>
  80135a:	83 c4 18             	add    $0x18,%esp
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 0a                	push   $0xa
  80136e:	e8 e7 fe ff ff       	call   80125a <syscall>
  801373:	83 c4 18             	add    $0x18,%esp
}
  801376:	c9                   	leave  
  801377:	c3                   	ret    

00801378 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 0b                	push   $0xb
  801387:	e8 ce fe ff ff       	call   80125a <syscall>
  80138c:	83 c4 18             	add    $0x18,%esp
}
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 0c                	push   $0xc
  8013a0:	e8 b5 fe ff ff       	call   80125a <syscall>
  8013a5:	83 c4 18             	add    $0x18,%esp
}
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	ff 75 08             	pushl  0x8(%ebp)
  8013b8:	6a 0d                	push   $0xd
  8013ba:	e8 9b fe ff ff       	call   80125a <syscall>
  8013bf:	83 c4 18             	add    $0x18,%esp
}
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    

008013c4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 0e                	push   $0xe
  8013d3:	e8 82 fe ff ff       	call   80125a <syscall>
  8013d8:	83 c4 18             	add    $0x18,%esp
}
  8013db:	90                   	nop
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 11                	push   $0x11
  8013ed:	e8 68 fe ff ff       	call   80125a <syscall>
  8013f2:	83 c4 18             	add    $0x18,%esp
}
  8013f5:	90                   	nop
  8013f6:	c9                   	leave  
  8013f7:	c3                   	ret    

008013f8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 12                	push   $0x12
  801407:	e8 4e fe ff ff       	call   80125a <syscall>
  80140c:	83 c4 18             	add    $0x18,%esp
}
  80140f:	90                   	nop
  801410:	c9                   	leave  
  801411:	c3                   	ret    

00801412 <sys_cputc>:


void
sys_cputc(const char c)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	83 ec 04             	sub    $0x4,%esp
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80141e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	50                   	push   %eax
  80142b:	6a 13                	push   $0x13
  80142d:	e8 28 fe ff ff       	call   80125a <syscall>
  801432:	83 c4 18             	add    $0x18,%esp
}
  801435:	90                   	nop
  801436:	c9                   	leave  
  801437:	c3                   	ret    

00801438 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 14                	push   $0x14
  801447:	e8 0e fe ff ff       	call   80125a <syscall>
  80144c:	83 c4 18             	add    $0x18,%esp
}
  80144f:	90                   	nop
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	ff 75 0c             	pushl  0xc(%ebp)
  801461:	50                   	push   %eax
  801462:	6a 15                	push   $0x15
  801464:	e8 f1 fd ff ff       	call   80125a <syscall>
  801469:	83 c4 18             	add    $0x18,%esp
}
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801471:	8b 55 0c             	mov    0xc(%ebp),%edx
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	52                   	push   %edx
  80147e:	50                   	push   %eax
  80147f:	6a 18                	push   $0x18
  801481:	e8 d4 fd ff ff       	call   80125a <syscall>
  801486:	83 c4 18             	add    $0x18,%esp
}
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80148e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	52                   	push   %edx
  80149b:	50                   	push   %eax
  80149c:	6a 16                	push   $0x16
  80149e:	e8 b7 fd ff ff       	call   80125a <syscall>
  8014a3:	83 c4 18             	add    $0x18,%esp
}
  8014a6:	90                   	nop
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	52                   	push   %edx
  8014b9:	50                   	push   %eax
  8014ba:	6a 17                	push   $0x17
  8014bc:	e8 99 fd ff ff       	call   80125a <syscall>
  8014c1:	83 c4 18             	add    $0x18,%esp
}
  8014c4:	90                   	nop
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014d3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014d6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	6a 00                	push   $0x0
  8014df:	51                   	push   %ecx
  8014e0:	52                   	push   %edx
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	50                   	push   %eax
  8014e5:	6a 19                	push   $0x19
  8014e7:	e8 6e fd ff ff       	call   80125a <syscall>
  8014ec:	83 c4 18             	add    $0x18,%esp
}
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	52                   	push   %edx
  801501:	50                   	push   %eax
  801502:	6a 1a                	push   $0x1a
  801504:	e8 51 fd ff ff       	call   80125a <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801511:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801514:	8b 55 0c             	mov    0xc(%ebp),%edx
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	51                   	push   %ecx
  80151f:	52                   	push   %edx
  801520:	50                   	push   %eax
  801521:	6a 1b                	push   $0x1b
  801523:	e8 32 fd ff ff       	call   80125a <syscall>
  801528:	83 c4 18             	add    $0x18,%esp
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801530:	8b 55 0c             	mov    0xc(%ebp),%edx
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	52                   	push   %edx
  80153d:	50                   	push   %eax
  80153e:	6a 1c                	push   $0x1c
  801540:	e8 15 fd ff ff       	call   80125a <syscall>
  801545:	83 c4 18             	add    $0x18,%esp
}
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 1d                	push   $0x1d
  801559:	e8 fc fc ff ff       	call   80125a <syscall>
  80155e:	83 c4 18             	add    $0x18,%esp
}
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	6a 00                	push   $0x0
  80156b:	ff 75 14             	pushl  0x14(%ebp)
  80156e:	ff 75 10             	pushl  0x10(%ebp)
  801571:	ff 75 0c             	pushl  0xc(%ebp)
  801574:	50                   	push   %eax
  801575:	6a 1e                	push   $0x1e
  801577:	e8 de fc ff ff       	call   80125a <syscall>
  80157c:	83 c4 18             	add    $0x18,%esp
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	50                   	push   %eax
  801590:	6a 1f                	push   $0x1f
  801592:	e8 c3 fc ff ff       	call   80125a <syscall>
  801597:	83 c4 18             	add    $0x18,%esp
}
  80159a:	90                   	nop
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	50                   	push   %eax
  8015ac:	6a 20                	push   $0x20
  8015ae:	e8 a7 fc ff ff       	call   80125a <syscall>
  8015b3:	83 c4 18             	add    $0x18,%esp
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 02                	push   $0x2
  8015c7:	e8 8e fc ff ff       	call   80125a <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 03                	push   $0x3
  8015e0:	e8 75 fc ff ff       	call   80125a <syscall>
  8015e5:	83 c4 18             	add    $0x18,%esp
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 04                	push   $0x4
  8015f9:	e8 5c fc ff ff       	call   80125a <syscall>
  8015fe:	83 c4 18             	add    $0x18,%esp
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <sys_exit_env>:


void sys_exit_env(void)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 21                	push   $0x21
  801612:	e8 43 fc ff ff       	call   80125a <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
}
  80161a:	90                   	nop
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801623:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801626:	8d 50 04             	lea    0x4(%eax),%edx
  801629:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	52                   	push   %edx
  801633:	50                   	push   %eax
  801634:	6a 22                	push   $0x22
  801636:	e8 1f fc ff ff       	call   80125a <syscall>
  80163b:	83 c4 18             	add    $0x18,%esp
	return result;
  80163e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801641:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801644:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801647:	89 01                	mov    %eax,(%ecx)
  801649:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	c9                   	leave  
  801650:	c2 04 00             	ret    $0x4

00801653 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	ff 75 10             	pushl  0x10(%ebp)
  80165d:	ff 75 0c             	pushl  0xc(%ebp)
  801660:	ff 75 08             	pushl  0x8(%ebp)
  801663:	6a 10                	push   $0x10
  801665:	e8 f0 fb ff ff       	call   80125a <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
	return ;
  80166d:	90                   	nop
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <sys_rcr2>:
uint32 sys_rcr2()
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 23                	push   $0x23
  80167f:	e8 d6 fb ff ff       	call   80125a <syscall>
  801684:	83 c4 18             	add    $0x18,%esp
}
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 04             	sub    $0x4,%esp
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801695:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	50                   	push   %eax
  8016a2:	6a 24                	push   $0x24
  8016a4:	e8 b1 fb ff ff       	call   80125a <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ac:	90                   	nop
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <rsttst>:
void rsttst()
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 26                	push   $0x26
  8016be:	e8 97 fb ff ff       	call   80125a <syscall>
  8016c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c6:	90                   	nop
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016d5:	8b 55 18             	mov    0x18(%ebp),%edx
  8016d8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016dc:	52                   	push   %edx
  8016dd:	50                   	push   %eax
  8016de:	ff 75 10             	pushl  0x10(%ebp)
  8016e1:	ff 75 0c             	pushl  0xc(%ebp)
  8016e4:	ff 75 08             	pushl  0x8(%ebp)
  8016e7:	6a 25                	push   $0x25
  8016e9:	e8 6c fb ff ff       	call   80125a <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f1:	90                   	nop
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <chktst>:
void chktst(uint32 n)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	ff 75 08             	pushl  0x8(%ebp)
  801702:	6a 27                	push   $0x27
  801704:	e8 51 fb ff ff       	call   80125a <syscall>
  801709:	83 c4 18             	add    $0x18,%esp
	return ;
  80170c:	90                   	nop
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <inctst>:

void inctst()
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 28                	push   $0x28
  80171e:	e8 37 fb ff ff       	call   80125a <syscall>
  801723:	83 c4 18             	add    $0x18,%esp
	return ;
  801726:	90                   	nop
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <gettst>:
uint32 gettst()
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 29                	push   $0x29
  801738:	e8 1d fb ff ff       	call   80125a <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 2a                	push   $0x2a
  801754:	e8 01 fb ff ff       	call   80125a <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
  80175c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80175f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801763:	75 07                	jne    80176c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801765:	b8 01 00 00 00       	mov    $0x1,%eax
  80176a:	eb 05                	jmp    801771 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80176c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 2a                	push   $0x2a
  801785:	e8 d0 fa ff ff       	call   80125a <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
  80178d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801790:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801794:	75 07                	jne    80179d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801796:	b8 01 00 00 00       	mov    $0x1,%eax
  80179b:	eb 05                	jmp    8017a2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80179d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 2a                	push   $0x2a
  8017b6:	e8 9f fa ff ff       	call   80125a <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
  8017be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017c1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017c5:	75 07                	jne    8017ce <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8017cc:	eb 05                	jmp    8017d3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 2a                	push   $0x2a
  8017e7:	e8 6e fa ff ff       	call   80125a <syscall>
  8017ec:	83 c4 18             	add    $0x18,%esp
  8017ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017f2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017f6:	75 07                	jne    8017ff <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8017fd:	eb 05                	jmp    801804 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	ff 75 08             	pushl  0x8(%ebp)
  801814:	6a 2b                	push   $0x2b
  801816:	e8 3f fa ff ff       	call   80125a <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
	return ;
  80181e:	90                   	nop
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801825:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801828:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80182b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	6a 00                	push   $0x0
  801833:	53                   	push   %ebx
  801834:	51                   	push   %ecx
  801835:	52                   	push   %edx
  801836:	50                   	push   %eax
  801837:	6a 2c                	push   $0x2c
  801839:	e8 1c fa ff ff       	call   80125a <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	52                   	push   %edx
  801856:	50                   	push   %eax
  801857:	6a 2d                	push   $0x2d
  801859:	e8 fc f9 ff ff       	call   80125a <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801866:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	6a 00                	push   $0x0
  801871:	51                   	push   %ecx
  801872:	ff 75 10             	pushl  0x10(%ebp)
  801875:	52                   	push   %edx
  801876:	50                   	push   %eax
  801877:	6a 2e                	push   $0x2e
  801879:	e8 dc f9 ff ff       	call   80125a <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	ff 75 10             	pushl  0x10(%ebp)
  80188d:	ff 75 0c             	pushl  0xc(%ebp)
  801890:	ff 75 08             	pushl  0x8(%ebp)
  801893:	6a 0f                	push   $0xf
  801895:	e8 c0 f9 ff ff       	call   80125a <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
	return ;
  80189d:	90                   	nop
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018a6:	83 ec 04             	sub    $0x4,%esp
  8018a9:	68 90 21 80 00       	push   $0x802190
  8018ae:	68 54 01 00 00       	push   $0x154
  8018b3:	68 a4 21 80 00       	push   $0x8021a4
  8018b8:	e8 ee e8 ff ff       	call   8001ab <_panic>

008018bd <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018c3:	83 ec 04             	sub    $0x4,%esp
  8018c6:	68 90 21 80 00       	push   $0x802190
  8018cb:	68 5b 01 00 00       	push   $0x15b
  8018d0:	68 a4 21 80 00       	push   $0x8021a4
  8018d5:	e8 d1 e8 ff ff       	call   8001ab <_panic>

008018da <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018e0:	83 ec 04             	sub    $0x4,%esp
  8018e3:	68 90 21 80 00       	push   $0x802190
  8018e8:	68 61 01 00 00       	push   $0x161
  8018ed:	68 a4 21 80 00       	push   $0x8021a4
  8018f2:	e8 b4 e8 ff ff       	call   8001ab <_panic>
  8018f7:	90                   	nop

008018f8 <__udivdi3>:
  8018f8:	55                   	push   %ebp
  8018f9:	57                   	push   %edi
  8018fa:	56                   	push   %esi
  8018fb:	53                   	push   %ebx
  8018fc:	83 ec 1c             	sub    $0x1c,%esp
  8018ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801903:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801907:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80190b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80190f:	89 ca                	mov    %ecx,%edx
  801911:	89 f8                	mov    %edi,%eax
  801913:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801917:	85 f6                	test   %esi,%esi
  801919:	75 2d                	jne    801948 <__udivdi3+0x50>
  80191b:	39 cf                	cmp    %ecx,%edi
  80191d:	77 65                	ja     801984 <__udivdi3+0x8c>
  80191f:	89 fd                	mov    %edi,%ebp
  801921:	85 ff                	test   %edi,%edi
  801923:	75 0b                	jne    801930 <__udivdi3+0x38>
  801925:	b8 01 00 00 00       	mov    $0x1,%eax
  80192a:	31 d2                	xor    %edx,%edx
  80192c:	f7 f7                	div    %edi
  80192e:	89 c5                	mov    %eax,%ebp
  801930:	31 d2                	xor    %edx,%edx
  801932:	89 c8                	mov    %ecx,%eax
  801934:	f7 f5                	div    %ebp
  801936:	89 c1                	mov    %eax,%ecx
  801938:	89 d8                	mov    %ebx,%eax
  80193a:	f7 f5                	div    %ebp
  80193c:	89 cf                	mov    %ecx,%edi
  80193e:	89 fa                	mov    %edi,%edx
  801940:	83 c4 1c             	add    $0x1c,%esp
  801943:	5b                   	pop    %ebx
  801944:	5e                   	pop    %esi
  801945:	5f                   	pop    %edi
  801946:	5d                   	pop    %ebp
  801947:	c3                   	ret    
  801948:	39 ce                	cmp    %ecx,%esi
  80194a:	77 28                	ja     801974 <__udivdi3+0x7c>
  80194c:	0f bd fe             	bsr    %esi,%edi
  80194f:	83 f7 1f             	xor    $0x1f,%edi
  801952:	75 40                	jne    801994 <__udivdi3+0x9c>
  801954:	39 ce                	cmp    %ecx,%esi
  801956:	72 0a                	jb     801962 <__udivdi3+0x6a>
  801958:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80195c:	0f 87 9e 00 00 00    	ja     801a00 <__udivdi3+0x108>
  801962:	b8 01 00 00 00       	mov    $0x1,%eax
  801967:	89 fa                	mov    %edi,%edx
  801969:	83 c4 1c             	add    $0x1c,%esp
  80196c:	5b                   	pop    %ebx
  80196d:	5e                   	pop    %esi
  80196e:	5f                   	pop    %edi
  80196f:	5d                   	pop    %ebp
  801970:	c3                   	ret    
  801971:	8d 76 00             	lea    0x0(%esi),%esi
  801974:	31 ff                	xor    %edi,%edi
  801976:	31 c0                	xor    %eax,%eax
  801978:	89 fa                	mov    %edi,%edx
  80197a:	83 c4 1c             	add    $0x1c,%esp
  80197d:	5b                   	pop    %ebx
  80197e:	5e                   	pop    %esi
  80197f:	5f                   	pop    %edi
  801980:	5d                   	pop    %ebp
  801981:	c3                   	ret    
  801982:	66 90                	xchg   %ax,%ax
  801984:	89 d8                	mov    %ebx,%eax
  801986:	f7 f7                	div    %edi
  801988:	31 ff                	xor    %edi,%edi
  80198a:	89 fa                	mov    %edi,%edx
  80198c:	83 c4 1c             	add    $0x1c,%esp
  80198f:	5b                   	pop    %ebx
  801990:	5e                   	pop    %esi
  801991:	5f                   	pop    %edi
  801992:	5d                   	pop    %ebp
  801993:	c3                   	ret    
  801994:	bd 20 00 00 00       	mov    $0x20,%ebp
  801999:	89 eb                	mov    %ebp,%ebx
  80199b:	29 fb                	sub    %edi,%ebx
  80199d:	89 f9                	mov    %edi,%ecx
  80199f:	d3 e6                	shl    %cl,%esi
  8019a1:	89 c5                	mov    %eax,%ebp
  8019a3:	88 d9                	mov    %bl,%cl
  8019a5:	d3 ed                	shr    %cl,%ebp
  8019a7:	89 e9                	mov    %ebp,%ecx
  8019a9:	09 f1                	or     %esi,%ecx
  8019ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019af:	89 f9                	mov    %edi,%ecx
  8019b1:	d3 e0                	shl    %cl,%eax
  8019b3:	89 c5                	mov    %eax,%ebp
  8019b5:	89 d6                	mov    %edx,%esi
  8019b7:	88 d9                	mov    %bl,%cl
  8019b9:	d3 ee                	shr    %cl,%esi
  8019bb:	89 f9                	mov    %edi,%ecx
  8019bd:	d3 e2                	shl    %cl,%edx
  8019bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019c3:	88 d9                	mov    %bl,%cl
  8019c5:	d3 e8                	shr    %cl,%eax
  8019c7:	09 c2                	or     %eax,%edx
  8019c9:	89 d0                	mov    %edx,%eax
  8019cb:	89 f2                	mov    %esi,%edx
  8019cd:	f7 74 24 0c          	divl   0xc(%esp)
  8019d1:	89 d6                	mov    %edx,%esi
  8019d3:	89 c3                	mov    %eax,%ebx
  8019d5:	f7 e5                	mul    %ebp
  8019d7:	39 d6                	cmp    %edx,%esi
  8019d9:	72 19                	jb     8019f4 <__udivdi3+0xfc>
  8019db:	74 0b                	je     8019e8 <__udivdi3+0xf0>
  8019dd:	89 d8                	mov    %ebx,%eax
  8019df:	31 ff                	xor    %edi,%edi
  8019e1:	e9 58 ff ff ff       	jmp    80193e <__udivdi3+0x46>
  8019e6:	66 90                	xchg   %ax,%ax
  8019e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019ec:	89 f9                	mov    %edi,%ecx
  8019ee:	d3 e2                	shl    %cl,%edx
  8019f0:	39 c2                	cmp    %eax,%edx
  8019f2:	73 e9                	jae    8019dd <__udivdi3+0xe5>
  8019f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019f7:	31 ff                	xor    %edi,%edi
  8019f9:	e9 40 ff ff ff       	jmp    80193e <__udivdi3+0x46>
  8019fe:	66 90                	xchg   %ax,%ax
  801a00:	31 c0                	xor    %eax,%eax
  801a02:	e9 37 ff ff ff       	jmp    80193e <__udivdi3+0x46>
  801a07:	90                   	nop

00801a08 <__umoddi3>:
  801a08:	55                   	push   %ebp
  801a09:	57                   	push   %edi
  801a0a:	56                   	push   %esi
  801a0b:	53                   	push   %ebx
  801a0c:	83 ec 1c             	sub    $0x1c,%esp
  801a0f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a13:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a27:	89 f3                	mov    %esi,%ebx
  801a29:	89 fa                	mov    %edi,%edx
  801a2b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a2f:	89 34 24             	mov    %esi,(%esp)
  801a32:	85 c0                	test   %eax,%eax
  801a34:	75 1a                	jne    801a50 <__umoddi3+0x48>
  801a36:	39 f7                	cmp    %esi,%edi
  801a38:	0f 86 a2 00 00 00    	jbe    801ae0 <__umoddi3+0xd8>
  801a3e:	89 c8                	mov    %ecx,%eax
  801a40:	89 f2                	mov    %esi,%edx
  801a42:	f7 f7                	div    %edi
  801a44:	89 d0                	mov    %edx,%eax
  801a46:	31 d2                	xor    %edx,%edx
  801a48:	83 c4 1c             	add    $0x1c,%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5f                   	pop    %edi
  801a4e:	5d                   	pop    %ebp
  801a4f:	c3                   	ret    
  801a50:	39 f0                	cmp    %esi,%eax
  801a52:	0f 87 ac 00 00 00    	ja     801b04 <__umoddi3+0xfc>
  801a58:	0f bd e8             	bsr    %eax,%ebp
  801a5b:	83 f5 1f             	xor    $0x1f,%ebp
  801a5e:	0f 84 ac 00 00 00    	je     801b10 <__umoddi3+0x108>
  801a64:	bf 20 00 00 00       	mov    $0x20,%edi
  801a69:	29 ef                	sub    %ebp,%edi
  801a6b:	89 fe                	mov    %edi,%esi
  801a6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a71:	89 e9                	mov    %ebp,%ecx
  801a73:	d3 e0                	shl    %cl,%eax
  801a75:	89 d7                	mov    %edx,%edi
  801a77:	89 f1                	mov    %esi,%ecx
  801a79:	d3 ef                	shr    %cl,%edi
  801a7b:	09 c7                	or     %eax,%edi
  801a7d:	89 e9                	mov    %ebp,%ecx
  801a7f:	d3 e2                	shl    %cl,%edx
  801a81:	89 14 24             	mov    %edx,(%esp)
  801a84:	89 d8                	mov    %ebx,%eax
  801a86:	d3 e0                	shl    %cl,%eax
  801a88:	89 c2                	mov    %eax,%edx
  801a8a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a8e:	d3 e0                	shl    %cl,%eax
  801a90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a94:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a98:	89 f1                	mov    %esi,%ecx
  801a9a:	d3 e8                	shr    %cl,%eax
  801a9c:	09 d0                	or     %edx,%eax
  801a9e:	d3 eb                	shr    %cl,%ebx
  801aa0:	89 da                	mov    %ebx,%edx
  801aa2:	f7 f7                	div    %edi
  801aa4:	89 d3                	mov    %edx,%ebx
  801aa6:	f7 24 24             	mull   (%esp)
  801aa9:	89 c6                	mov    %eax,%esi
  801aab:	89 d1                	mov    %edx,%ecx
  801aad:	39 d3                	cmp    %edx,%ebx
  801aaf:	0f 82 87 00 00 00    	jb     801b3c <__umoddi3+0x134>
  801ab5:	0f 84 91 00 00 00    	je     801b4c <__umoddi3+0x144>
  801abb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801abf:	29 f2                	sub    %esi,%edx
  801ac1:	19 cb                	sbb    %ecx,%ebx
  801ac3:	89 d8                	mov    %ebx,%eax
  801ac5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ac9:	d3 e0                	shl    %cl,%eax
  801acb:	89 e9                	mov    %ebp,%ecx
  801acd:	d3 ea                	shr    %cl,%edx
  801acf:	09 d0                	or     %edx,%eax
  801ad1:	89 e9                	mov    %ebp,%ecx
  801ad3:	d3 eb                	shr    %cl,%ebx
  801ad5:	89 da                	mov    %ebx,%edx
  801ad7:	83 c4 1c             	add    $0x1c,%esp
  801ada:	5b                   	pop    %ebx
  801adb:	5e                   	pop    %esi
  801adc:	5f                   	pop    %edi
  801add:	5d                   	pop    %ebp
  801ade:	c3                   	ret    
  801adf:	90                   	nop
  801ae0:	89 fd                	mov    %edi,%ebp
  801ae2:	85 ff                	test   %edi,%edi
  801ae4:	75 0b                	jne    801af1 <__umoddi3+0xe9>
  801ae6:	b8 01 00 00 00       	mov    $0x1,%eax
  801aeb:	31 d2                	xor    %edx,%edx
  801aed:	f7 f7                	div    %edi
  801aef:	89 c5                	mov    %eax,%ebp
  801af1:	89 f0                	mov    %esi,%eax
  801af3:	31 d2                	xor    %edx,%edx
  801af5:	f7 f5                	div    %ebp
  801af7:	89 c8                	mov    %ecx,%eax
  801af9:	f7 f5                	div    %ebp
  801afb:	89 d0                	mov    %edx,%eax
  801afd:	e9 44 ff ff ff       	jmp    801a46 <__umoddi3+0x3e>
  801b02:	66 90                	xchg   %ax,%ax
  801b04:	89 c8                	mov    %ecx,%eax
  801b06:	89 f2                	mov    %esi,%edx
  801b08:	83 c4 1c             	add    $0x1c,%esp
  801b0b:	5b                   	pop    %ebx
  801b0c:	5e                   	pop    %esi
  801b0d:	5f                   	pop    %edi
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    
  801b10:	3b 04 24             	cmp    (%esp),%eax
  801b13:	72 06                	jb     801b1b <__umoddi3+0x113>
  801b15:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b19:	77 0f                	ja     801b2a <__umoddi3+0x122>
  801b1b:	89 f2                	mov    %esi,%edx
  801b1d:	29 f9                	sub    %edi,%ecx
  801b1f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b23:	89 14 24             	mov    %edx,(%esp)
  801b26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b2a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b2e:	8b 14 24             	mov    (%esp),%edx
  801b31:	83 c4 1c             	add    $0x1c,%esp
  801b34:	5b                   	pop    %ebx
  801b35:	5e                   	pop    %esi
  801b36:	5f                   	pop    %edi
  801b37:	5d                   	pop    %ebp
  801b38:	c3                   	ret    
  801b39:	8d 76 00             	lea    0x0(%esi),%esi
  801b3c:	2b 04 24             	sub    (%esp),%eax
  801b3f:	19 fa                	sbb    %edi,%edx
  801b41:	89 d1                	mov    %edx,%ecx
  801b43:	89 c6                	mov    %eax,%esi
  801b45:	e9 71 ff ff ff       	jmp    801abb <__umoddi3+0xb3>
  801b4a:	66 90                	xchg   %ax,%ax
  801b4c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b50:	72 ea                	jb     801b3c <__umoddi3+0x134>
  801b52:	89 d9                	mov    %ebx,%ecx
  801b54:	e9 62 ff ff ff       	jmp    801abb <__umoddi3+0xb3>
