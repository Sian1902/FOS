
obj/user/tst_syscalls_1:     file format elf32-i386


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
  800031:	e8 8a 00 00 00       	call   8000c0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the correct implementation of system calls
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	rsttst();
  80003e:	e8 d1 16 00 00       	call   801714 <rsttst>
	void * ret = sys_sbrk(10);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 0a                	push   $0xa
  800048:	e8 b8 18 00 00       	call   801905 <sys_sbrk>
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (ret != (void*)-1)
  800053:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  800057:	74 14                	je     80006d <_main+0x35>
		panic("tst system calls #1 failed: sys_sbrk is not handled correctly");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 c0 1b 80 00       	push   $0x801bc0
  800061:	6a 0a                	push   $0xa
  800063:	68 fe 1b 80 00       	push   $0x801bfe
  800068:	e8 98 01 00 00       	call   800205 <_panic>
	sys_allocate_user_mem(100,10);
  80006d:	83 ec 08             	sub    $0x8,%esp
  800070:	6a 0a                	push   $0xa
  800072:	6a 64                	push   $0x64
  800074:	e8 c3 18 00 00       	call   80193c <sys_allocate_user_mem>
  800079:	83 c4 10             	add    $0x10,%esp
	sys_free_user_mem(100, 10);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	6a 0a                	push   $0xa
  800081:	6a 64                	push   $0x64
  800083:	e8 98 18 00 00       	call   801920 <sys_free_user_mem>
  800088:	83 c4 10             	add    $0x10,%esp
	int ret2 = gettst();
  80008b:	e8 fe 16 00 00       	call   80178e <gettst>
  800090:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret2 != 2)
  800093:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800097:	74 14                	je     8000ad <_main+0x75>
		panic("tst system calls #1 failed: sys_allocate_user_mem and/or sys_free_user_mem are not handled correctly");
  800099:	83 ec 04             	sub    $0x4,%esp
  80009c:	68 14 1c 80 00       	push   $0x801c14
  8000a1:	6a 0f                	push   $0xf
  8000a3:	68 fe 1b 80 00       	push   $0x801bfe
  8000a8:	e8 58 01 00 00       	call   800205 <_panic>
	cprintf("Congratulations... tst system calls #1 completed successfully");
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 7c 1c 80 00       	push   $0x801c7c
  8000b5:	e8 08 04 00 00       	call   8004c2 <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
}
  8000bd:	90                   	nop
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000c6:	e8 6b 15 00 00       	call   801636 <sys_getenvindex>
  8000cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000d1:	89 d0                	mov    %edx,%eax
  8000d3:	01 c0                	add    %eax,%eax
  8000d5:	01 d0                	add    %edx,%eax
  8000d7:	01 c0                	add    %eax,%eax
  8000d9:	01 d0                	add    %edx,%eax
  8000db:	c1 e0 02             	shl    $0x2,%eax
  8000de:	01 d0                	add    %edx,%eax
  8000e0:	01 c0                	add    %eax,%eax
  8000e2:	01 d0                	add    %edx,%eax
  8000e4:	c1 e0 02             	shl    $0x2,%eax
  8000e7:	01 d0                	add    %edx,%eax
  8000e9:	c1 e0 02             	shl    $0x2,%eax
  8000ec:	01 d0                	add    %edx,%eax
  8000ee:	c1 e0 02             	shl    $0x2,%eax
  8000f1:	01 d0                	add    %edx,%eax
  8000f3:	c1 e0 05             	shl    $0x5,%eax
  8000f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000fb:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800100:	a1 20 30 80 00       	mov    0x803020,%eax
  800105:	8a 40 5c             	mov    0x5c(%eax),%al
  800108:	84 c0                	test   %al,%al
  80010a:	74 0d                	je     800119 <libmain+0x59>
		binaryname = myEnv->prog_name;
  80010c:	a1 20 30 80 00       	mov    0x803020,%eax
  800111:	83 c0 5c             	add    $0x5c,%eax
  800114:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800119:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80011d:	7e 0a                	jle    800129 <libmain+0x69>
		binaryname = argv[0];
  80011f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800122:	8b 00                	mov    (%eax),%eax
  800124:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800129:	83 ec 08             	sub    $0x8,%esp
  80012c:	ff 75 0c             	pushl  0xc(%ebp)
  80012f:	ff 75 08             	pushl  0x8(%ebp)
  800132:	e8 01 ff ff ff       	call   800038 <_main>
  800137:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80013a:	e8 04 13 00 00       	call   801443 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 d4 1c 80 00       	push   $0x801cd4
  800147:	e8 76 03 00 00       	call   8004c2 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80014f:	a1 20 30 80 00       	mov    0x803020,%eax
  800154:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  80015a:	a1 20 30 80 00       	mov    0x803020,%eax
  80015f:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  800165:	83 ec 04             	sub    $0x4,%esp
  800168:	52                   	push   %edx
  800169:	50                   	push   %eax
  80016a:	68 fc 1c 80 00       	push   $0x801cfc
  80016f:	e8 4e 03 00 00       	call   8004c2 <cprintf>
  800174:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800177:	a1 20 30 80 00       	mov    0x803020,%eax
  80017c:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  800182:	a1 20 30 80 00       	mov    0x803020,%eax
  800187:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  80018d:	a1 20 30 80 00       	mov    0x803020,%eax
  800192:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  800198:	51                   	push   %ecx
  800199:	52                   	push   %edx
  80019a:	50                   	push   %eax
  80019b:	68 24 1d 80 00       	push   $0x801d24
  8001a0:	e8 1d 03 00 00       	call   8004c2 <cprintf>
  8001a5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ad:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	50                   	push   %eax
  8001b7:	68 7c 1d 80 00       	push   $0x801d7c
  8001bc:	e8 01 03 00 00       	call   8004c2 <cprintf>
  8001c1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	68 d4 1c 80 00       	push   $0x801cd4
  8001cc:	e8 f1 02 00 00       	call   8004c2 <cprintf>
  8001d1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001d4:	e8 84 12 00 00       	call   80145d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001d9:	e8 19 00 00 00       	call   8001f7 <exit>
}
  8001de:	90                   	nop
  8001df:	c9                   	leave  
  8001e0:	c3                   	ret    

008001e1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001e1:	55                   	push   %ebp
  8001e2:	89 e5                	mov    %esp,%ebp
  8001e4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	6a 00                	push   $0x0
  8001ec:	e8 11 14 00 00       	call   801602 <sys_destroy_env>
  8001f1:	83 c4 10             	add    $0x10,%esp
}
  8001f4:	90                   	nop
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    

008001f7 <exit>:

void
exit(void)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001fd:	e8 66 14 00 00       	call   801668 <sys_exit_env>
}
  800202:	90                   	nop
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80020b:	8d 45 10             	lea    0x10(%ebp),%eax
  80020e:	83 c0 04             	add    $0x4,%eax
  800211:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800214:	a1 28 31 80 00       	mov    0x803128,%eax
  800219:	85 c0                	test   %eax,%eax
  80021b:	74 16                	je     800233 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80021d:	a1 28 31 80 00       	mov    0x803128,%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 90 1d 80 00       	push   $0x801d90
  80022b:	e8 92 02 00 00       	call   8004c2 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800233:	a1 00 30 80 00       	mov    0x803000,%eax
  800238:	ff 75 0c             	pushl  0xc(%ebp)
  80023b:	ff 75 08             	pushl  0x8(%ebp)
  80023e:	50                   	push   %eax
  80023f:	68 95 1d 80 00       	push   $0x801d95
  800244:	e8 79 02 00 00       	call   8004c2 <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80024c:	8b 45 10             	mov    0x10(%ebp),%eax
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	ff 75 f4             	pushl  -0xc(%ebp)
  800255:	50                   	push   %eax
  800256:	e8 fc 01 00 00       	call   800457 <vcprintf>
  80025b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	6a 00                	push   $0x0
  800263:	68 b1 1d 80 00       	push   $0x801db1
  800268:	e8 ea 01 00 00       	call   800457 <vcprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800270:	e8 82 ff ff ff       	call   8001f7 <exit>

	// should not return here
	while (1) ;
  800275:	eb fe                	jmp    800275 <_panic+0x70>

00800277 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80027d:	a1 20 30 80 00       	mov    0x803020,%eax
  800282:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  800288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028b:	39 c2                	cmp    %eax,%edx
  80028d:	74 14                	je     8002a3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80028f:	83 ec 04             	sub    $0x4,%esp
  800292:	68 b4 1d 80 00       	push   $0x801db4
  800297:	6a 26                	push   $0x26
  800299:	68 00 1e 80 00       	push   $0x801e00
  80029e:	e8 62 ff ff ff       	call   800205 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002b1:	e9 c5 00 00 00       	jmp    80037b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	8b 00                	mov    (%eax),%eax
  8002c7:	85 c0                	test   %eax,%eax
  8002c9:	75 08                	jne    8002d3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002cb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002ce:	e9 a5 00 00 00       	jmp    800378 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002e1:	eb 69                	jmp    80034c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e8:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  8002ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002f1:	89 d0                	mov    %edx,%eax
  8002f3:	01 c0                	add    %eax,%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	c1 e0 03             	shl    $0x3,%eax
  8002fa:	01 c8                	add    %ecx,%eax
  8002fc:	8a 40 04             	mov    0x4(%eax),%al
  8002ff:	84 c0                	test   %al,%al
  800301:	75 46                	jne    800349 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800303:	a1 20 30 80 00       	mov    0x803020,%eax
  800308:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  80030e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800311:	89 d0                	mov    %edx,%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	01 d0                	add    %edx,%eax
  800317:	c1 e0 03             	shl    $0x3,%eax
  80031a:	01 c8                	add    %ecx,%eax
  80031c:	8b 00                	mov    (%eax),%eax
  80031e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800321:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800324:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800329:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80032b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800335:	8b 45 08             	mov    0x8(%ebp),%eax
  800338:	01 c8                	add    %ecx,%eax
  80033a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80033c:	39 c2                	cmp    %eax,%edx
  80033e:	75 09                	jne    800349 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800340:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800347:	eb 15                	jmp    80035e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800349:	ff 45 e8             	incl   -0x18(%ebp)
  80034c:	a1 20 30 80 00       	mov    0x803020,%eax
  800351:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  800357:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80035a:	39 c2                	cmp    %eax,%edx
  80035c:	77 85                	ja     8002e3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80035e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800362:	75 14                	jne    800378 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800364:	83 ec 04             	sub    $0x4,%esp
  800367:	68 0c 1e 80 00       	push   $0x801e0c
  80036c:	6a 3a                	push   $0x3a
  80036e:	68 00 1e 80 00       	push   $0x801e00
  800373:	e8 8d fe ff ff       	call   800205 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800378:	ff 45 f0             	incl   -0x10(%ebp)
  80037b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800381:	0f 8c 2f ff ff ff    	jl     8002b6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800387:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80038e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800395:	eb 26                	jmp    8003bd <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800397:	a1 20 30 80 00       	mov    0x803020,%eax
  80039c:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  8003a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003a5:	89 d0                	mov    %edx,%eax
  8003a7:	01 c0                	add    %eax,%eax
  8003a9:	01 d0                	add    %edx,%eax
  8003ab:	c1 e0 03             	shl    $0x3,%eax
  8003ae:	01 c8                	add    %ecx,%eax
  8003b0:	8a 40 04             	mov    0x4(%eax),%al
  8003b3:	3c 01                	cmp    $0x1,%al
  8003b5:	75 03                	jne    8003ba <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003b7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ba:	ff 45 e0             	incl   -0x20(%ebp)
  8003bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c2:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  8003c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003cb:	39 c2                	cmp    %eax,%edx
  8003cd:	77 c8                	ja     800397 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003d5:	74 14                	je     8003eb <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003d7:	83 ec 04             	sub    $0x4,%esp
  8003da:	68 60 1e 80 00       	push   $0x801e60
  8003df:	6a 44                	push   $0x44
  8003e1:	68 00 1e 80 00       	push   $0x801e00
  8003e6:	e8 1a fe ff ff       	call   800205 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003eb:	90                   	nop
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8003fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ff:	89 0a                	mov    %ecx,(%edx)
  800401:	8b 55 08             	mov    0x8(%ebp),%edx
  800404:	88 d1                	mov    %dl,%cl
  800406:	8b 55 0c             	mov    0xc(%ebp),%edx
  800409:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80040d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800410:	8b 00                	mov    (%eax),%eax
  800412:	3d ff 00 00 00       	cmp    $0xff,%eax
  800417:	75 2c                	jne    800445 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800419:	a0 24 30 80 00       	mov    0x803024,%al
  80041e:	0f b6 c0             	movzbl %al,%eax
  800421:	8b 55 0c             	mov    0xc(%ebp),%edx
  800424:	8b 12                	mov    (%edx),%edx
  800426:	89 d1                	mov    %edx,%ecx
  800428:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042b:	83 c2 08             	add    $0x8,%edx
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	50                   	push   %eax
  800432:	51                   	push   %ecx
  800433:	52                   	push   %edx
  800434:	e8 b1 0e 00 00       	call   8012ea <sys_cputs>
  800439:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80043c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800445:	8b 45 0c             	mov    0xc(%ebp),%eax
  800448:	8b 40 04             	mov    0x4(%eax),%eax
  80044b:	8d 50 01             	lea    0x1(%eax),%edx
  80044e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800451:	89 50 04             	mov    %edx,0x4(%eax)
}
  800454:	90                   	nop
  800455:	c9                   	leave  
  800456:	c3                   	ret    

00800457 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
  80045a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800460:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800467:	00 00 00 
	b.cnt = 0;
  80046a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800471:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800474:	ff 75 0c             	pushl  0xc(%ebp)
  800477:	ff 75 08             	pushl  0x8(%ebp)
  80047a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800480:	50                   	push   %eax
  800481:	68 ee 03 80 00       	push   $0x8003ee
  800486:	e8 11 02 00 00       	call   80069c <vprintfmt>
  80048b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80048e:	a0 24 30 80 00       	mov    0x803024,%al
  800493:	0f b6 c0             	movzbl %al,%eax
  800496:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80049c:	83 ec 04             	sub    $0x4,%esp
  80049f:	50                   	push   %eax
  8004a0:	52                   	push   %edx
  8004a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a7:	83 c0 08             	add    $0x8,%eax
  8004aa:	50                   	push   %eax
  8004ab:	e8 3a 0e 00 00       	call   8012ea <sys_cputs>
  8004b0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004b3:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8004ba:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004c0:	c9                   	leave  
  8004c1:	c3                   	ret    

008004c2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8004c2:	55                   	push   %ebp
  8004c3:	89 e5                	mov    %esp,%ebp
  8004c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004c8:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8004cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	ff 75 f4             	pushl  -0xc(%ebp)
  8004de:	50                   	push   %eax
  8004df:	e8 73 ff ff ff       	call   800457 <vcprintf>
  8004e4:	83 c4 10             	add    $0x10,%esp
  8004e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004ed:	c9                   	leave  
  8004ee:	c3                   	ret    

008004ef <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8004ef:	55                   	push   %ebp
  8004f0:	89 e5                	mov    %esp,%ebp
  8004f2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8004f5:	e8 49 0f 00 00       	call   801443 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004fa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	83 ec 08             	sub    $0x8,%esp
  800506:	ff 75 f4             	pushl  -0xc(%ebp)
  800509:	50                   	push   %eax
  80050a:	e8 48 ff ff ff       	call   800457 <vcprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
  800512:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800515:	e8 43 0f 00 00       	call   80145d <sys_enable_interrupt>
	return cnt;
  80051a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80051d:	c9                   	leave  
  80051e:	c3                   	ret    

0080051f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80051f:	55                   	push   %ebp
  800520:	89 e5                	mov    %esp,%ebp
  800522:	53                   	push   %ebx
  800523:	83 ec 14             	sub    $0x14,%esp
  800526:	8b 45 10             	mov    0x10(%ebp),%eax
  800529:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800532:	8b 45 18             	mov    0x18(%ebp),%eax
  800535:	ba 00 00 00 00       	mov    $0x0,%edx
  80053a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80053d:	77 55                	ja     800594 <printnum+0x75>
  80053f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800542:	72 05                	jb     800549 <printnum+0x2a>
  800544:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800547:	77 4b                	ja     800594 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800549:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80054c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80054f:	8b 45 18             	mov    0x18(%ebp),%eax
  800552:	ba 00 00 00 00       	mov    $0x0,%edx
  800557:	52                   	push   %edx
  800558:	50                   	push   %eax
  800559:	ff 75 f4             	pushl  -0xc(%ebp)
  80055c:	ff 75 f0             	pushl  -0x10(%ebp)
  80055f:	e8 f4 13 00 00       	call   801958 <__udivdi3>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	ff 75 20             	pushl  0x20(%ebp)
  80056d:	53                   	push   %ebx
  80056e:	ff 75 18             	pushl  0x18(%ebp)
  800571:	52                   	push   %edx
  800572:	50                   	push   %eax
  800573:	ff 75 0c             	pushl  0xc(%ebp)
  800576:	ff 75 08             	pushl  0x8(%ebp)
  800579:	e8 a1 ff ff ff       	call   80051f <printnum>
  80057e:	83 c4 20             	add    $0x20,%esp
  800581:	eb 1a                	jmp    80059d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	ff 75 0c             	pushl  0xc(%ebp)
  800589:	ff 75 20             	pushl  0x20(%ebp)
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	ff d0                	call   *%eax
  800591:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800594:	ff 4d 1c             	decl   0x1c(%ebp)
  800597:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80059b:	7f e6                	jg     800583 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80059d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005ab:	53                   	push   %ebx
  8005ac:	51                   	push   %ecx
  8005ad:	52                   	push   %edx
  8005ae:	50                   	push   %eax
  8005af:	e8 b4 14 00 00       	call   801a68 <__umoddi3>
  8005b4:	83 c4 10             	add    $0x10,%esp
  8005b7:	05 d4 20 80 00       	add    $0x8020d4,%eax
  8005bc:	8a 00                	mov    (%eax),%al
  8005be:	0f be c0             	movsbl %al,%eax
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	ff 75 0c             	pushl  0xc(%ebp)
  8005c7:	50                   	push   %eax
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	ff d0                	call   *%eax
  8005cd:	83 c4 10             	add    $0x10,%esp
}
  8005d0:	90                   	nop
  8005d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005d4:	c9                   	leave  
  8005d5:	c3                   	ret    

008005d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005dd:	7e 1c                	jle    8005fb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	8d 50 08             	lea    0x8(%eax),%edx
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	89 10                	mov    %edx,(%eax)
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	83 e8 08             	sub    $0x8,%eax
  8005f4:	8b 50 04             	mov    0x4(%eax),%edx
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	eb 40                	jmp    80063b <getuint+0x65>
	else if (lflag)
  8005fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005ff:	74 1e                	je     80061f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	8d 50 04             	lea    0x4(%eax),%edx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	89 10                	mov    %edx,(%eax)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	83 e8 04             	sub    $0x4,%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	ba 00 00 00 00       	mov    $0x0,%edx
  80061d:	eb 1c                	jmp    80063b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	8b 00                	mov    (%eax),%eax
  800624:	8d 50 04             	lea    0x4(%eax),%edx
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	89 10                	mov    %edx,(%eax)
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	83 e8 04             	sub    $0x4,%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80063b:	5d                   	pop    %ebp
  80063c:	c3                   	ret    

0080063d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800640:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800644:	7e 1c                	jle    800662 <getint+0x25>
		return va_arg(*ap, long long);
  800646:	8b 45 08             	mov    0x8(%ebp),%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	8d 50 08             	lea    0x8(%eax),%edx
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	89 10                	mov    %edx,(%eax)
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	83 e8 08             	sub    $0x8,%eax
  80065b:	8b 50 04             	mov    0x4(%eax),%edx
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	eb 38                	jmp    80069a <getint+0x5d>
	else if (lflag)
  800662:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800666:	74 1a                	je     800682 <getint+0x45>
		return va_arg(*ap, long);
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	8d 50 04             	lea    0x4(%eax),%edx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	89 10                	mov    %edx,(%eax)
  800675:	8b 45 08             	mov    0x8(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	83 e8 04             	sub    $0x4,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	99                   	cltd   
  800680:	eb 18                	jmp    80069a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	89 10                	mov    %edx,(%eax)
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	99                   	cltd   
}
  80069a:	5d                   	pop    %ebp
  80069b:	c3                   	ret    

0080069c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80069c:	55                   	push   %ebp
  80069d:	89 e5                	mov    %esp,%ebp
  80069f:	56                   	push   %esi
  8006a0:	53                   	push   %ebx
  8006a1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a4:	eb 17                	jmp    8006bd <vprintfmt+0x21>
			if (ch == '\0')
  8006a6:	85 db                	test   %ebx,%ebx
  8006a8:	0f 84 af 03 00 00    	je     800a5d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	ff 75 0c             	pushl  0xc(%ebp)
  8006b4:	53                   	push   %ebx
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	ff d0                	call   *%eax
  8006ba:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c0:	8d 50 01             	lea    0x1(%eax),%edx
  8006c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8006c6:	8a 00                	mov    (%eax),%al
  8006c8:	0f b6 d8             	movzbl %al,%ebx
  8006cb:	83 fb 25             	cmp    $0x25,%ebx
  8006ce:	75 d6                	jne    8006a6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006d0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8006d4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006e9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f3:	8d 50 01             	lea    0x1(%eax),%edx
  8006f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8006f9:	8a 00                	mov    (%eax),%al
  8006fb:	0f b6 d8             	movzbl %al,%ebx
  8006fe:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800701:	83 f8 55             	cmp    $0x55,%eax
  800704:	0f 87 2b 03 00 00    	ja     800a35 <vprintfmt+0x399>
  80070a:	8b 04 85 f8 20 80 00 	mov    0x8020f8(,%eax,4),%eax
  800711:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800713:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800717:	eb d7                	jmp    8006f0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800719:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80071d:	eb d1                	jmp    8006f0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80071f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800726:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800729:	89 d0                	mov    %edx,%eax
  80072b:	c1 e0 02             	shl    $0x2,%eax
  80072e:	01 d0                	add    %edx,%eax
  800730:	01 c0                	add    %eax,%eax
  800732:	01 d8                	add    %ebx,%eax
  800734:	83 e8 30             	sub    $0x30,%eax
  800737:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80073a:	8b 45 10             	mov    0x10(%ebp),%eax
  80073d:	8a 00                	mov    (%eax),%al
  80073f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800742:	83 fb 2f             	cmp    $0x2f,%ebx
  800745:	7e 3e                	jle    800785 <vprintfmt+0xe9>
  800747:	83 fb 39             	cmp    $0x39,%ebx
  80074a:	7f 39                	jg     800785 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80074c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80074f:	eb d5                	jmp    800726 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	83 c0 04             	add    $0x4,%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	83 e8 04             	sub    $0x4,%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800765:	eb 1f                	jmp    800786 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800767:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80076b:	79 83                	jns    8006f0 <vprintfmt+0x54>
				width = 0;
  80076d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800774:	e9 77 ff ff ff       	jmp    8006f0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800779:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800780:	e9 6b ff ff ff       	jmp    8006f0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800785:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800786:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80078a:	0f 89 60 ff ff ff    	jns    8006f0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800790:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800793:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800796:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80079d:	e9 4e ff ff ff       	jmp    8006f0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007a2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007a5:	e9 46 ff ff ff       	jmp    8006f0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	83 c0 04             	add    $0x4,%eax
  8007b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	83 e8 04             	sub    $0x4,%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	ff 75 0c             	pushl  0xc(%ebp)
  8007c1:	50                   	push   %eax
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	ff d0                	call   *%eax
  8007c7:	83 c4 10             	add    $0x10,%esp
			break;
  8007ca:	e9 89 02 00 00       	jmp    800a58 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	83 c0 04             	add    $0x4,%eax
  8007d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	83 e8 04             	sub    $0x4,%eax
  8007de:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007e0:	85 db                	test   %ebx,%ebx
  8007e2:	79 02                	jns    8007e6 <vprintfmt+0x14a>
				err = -err;
  8007e4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007e6:	83 fb 64             	cmp    $0x64,%ebx
  8007e9:	7f 0b                	jg     8007f6 <vprintfmt+0x15a>
  8007eb:	8b 34 9d 40 1f 80 00 	mov    0x801f40(,%ebx,4),%esi
  8007f2:	85 f6                	test   %esi,%esi
  8007f4:	75 19                	jne    80080f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007f6:	53                   	push   %ebx
  8007f7:	68 e5 20 80 00       	push   $0x8020e5
  8007fc:	ff 75 0c             	pushl  0xc(%ebp)
  8007ff:	ff 75 08             	pushl  0x8(%ebp)
  800802:	e8 5e 02 00 00       	call   800a65 <printfmt>
  800807:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80080a:	e9 49 02 00 00       	jmp    800a58 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80080f:	56                   	push   %esi
  800810:	68 ee 20 80 00       	push   $0x8020ee
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	ff 75 08             	pushl  0x8(%ebp)
  80081b:	e8 45 02 00 00       	call   800a65 <printfmt>
  800820:	83 c4 10             	add    $0x10,%esp
			break;
  800823:	e9 30 02 00 00       	jmp    800a58 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	83 c0 04             	add    $0x4,%eax
  80082e:	89 45 14             	mov    %eax,0x14(%ebp)
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	83 e8 04             	sub    $0x4,%eax
  800837:	8b 30                	mov    (%eax),%esi
  800839:	85 f6                	test   %esi,%esi
  80083b:	75 05                	jne    800842 <vprintfmt+0x1a6>
				p = "(null)";
  80083d:	be f1 20 80 00       	mov    $0x8020f1,%esi
			if (width > 0 && padc != '-')
  800842:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800846:	7e 6d                	jle    8008b5 <vprintfmt+0x219>
  800848:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80084c:	74 67                	je     8008b5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80084e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	50                   	push   %eax
  800855:	56                   	push   %esi
  800856:	e8 0c 03 00 00       	call   800b67 <strnlen>
  80085b:	83 c4 10             	add    $0x10,%esp
  80085e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800861:	eb 16                	jmp    800879 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800863:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	50                   	push   %eax
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	ff d0                	call   *%eax
  800873:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800876:	ff 4d e4             	decl   -0x1c(%ebp)
  800879:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087d:	7f e4                	jg     800863 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80087f:	eb 34                	jmp    8008b5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800881:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800885:	74 1c                	je     8008a3 <vprintfmt+0x207>
  800887:	83 fb 1f             	cmp    $0x1f,%ebx
  80088a:	7e 05                	jle    800891 <vprintfmt+0x1f5>
  80088c:	83 fb 7e             	cmp    $0x7e,%ebx
  80088f:	7e 12                	jle    8008a3 <vprintfmt+0x207>
					putch('?', putdat);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	6a 3f                	push   $0x3f
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	ff d0                	call   *%eax
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	eb 0f                	jmp    8008b2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	ff 75 0c             	pushl  0xc(%ebp)
  8008a9:	53                   	push   %ebx
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	ff d0                	call   *%eax
  8008af:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008b2:	ff 4d e4             	decl   -0x1c(%ebp)
  8008b5:	89 f0                	mov    %esi,%eax
  8008b7:	8d 70 01             	lea    0x1(%eax),%esi
  8008ba:	8a 00                	mov    (%eax),%al
  8008bc:	0f be d8             	movsbl %al,%ebx
  8008bf:	85 db                	test   %ebx,%ebx
  8008c1:	74 24                	je     8008e7 <vprintfmt+0x24b>
  8008c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008c7:	78 b8                	js     800881 <vprintfmt+0x1e5>
  8008c9:	ff 4d e0             	decl   -0x20(%ebp)
  8008cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008d0:	79 af                	jns    800881 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008d2:	eb 13                	jmp    8008e7 <vprintfmt+0x24b>
				putch(' ', putdat);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	6a 20                	push   $0x20
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	ff d0                	call   *%eax
  8008e1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008e4:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008eb:	7f e7                	jg     8008d4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008ed:	e9 66 01 00 00       	jmp    800a58 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8008f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8008fb:	50                   	push   %eax
  8008fc:	e8 3c fd ff ff       	call   80063d <getint>
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800907:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80090a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800910:	85 d2                	test   %edx,%edx
  800912:	79 23                	jns    800937 <vprintfmt+0x29b>
				putch('-', putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	6a 2d                	push   $0x2d
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	ff d0                	call   *%eax
  800921:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800927:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80092a:	f7 d8                	neg    %eax
  80092c:	83 d2 00             	adc    $0x0,%edx
  80092f:	f7 da                	neg    %edx
  800931:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800934:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800937:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80093e:	e9 bc 00 00 00       	jmp    8009ff <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800943:	83 ec 08             	sub    $0x8,%esp
  800946:	ff 75 e8             	pushl  -0x18(%ebp)
  800949:	8d 45 14             	lea    0x14(%ebp),%eax
  80094c:	50                   	push   %eax
  80094d:	e8 84 fc ff ff       	call   8005d6 <getuint>
  800952:	83 c4 10             	add    $0x10,%esp
  800955:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800958:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80095b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800962:	e9 98 00 00 00       	jmp    8009ff <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	6a 58                	push   $0x58
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
  800974:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	ff 75 0c             	pushl  0xc(%ebp)
  80097d:	6a 58                	push   $0x58
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	ff d0                	call   *%eax
  800984:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800987:	83 ec 08             	sub    $0x8,%esp
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	6a 58                	push   $0x58
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	ff d0                	call   *%eax
  800994:	83 c4 10             	add    $0x10,%esp
			break;
  800997:	e9 bc 00 00 00       	jmp    800a58 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	6a 30                	push   $0x30
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	ff d0                	call   *%eax
  8009a9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 0c             	pushl  0xc(%ebp)
  8009b2:	6a 78                	push   $0x78
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	ff d0                	call   *%eax
  8009b9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8009bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bf:	83 c0 04             	add    $0x4,%eax
  8009c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c8:	83 e8 04             	sub    $0x4,%eax
  8009cb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8009cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8009d7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009de:	eb 1f                	jmp    8009ff <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8009e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e9:	50                   	push   %eax
  8009ea:	e8 e7 fb ff ff       	call   8005d6 <getuint>
  8009ef:	83 c4 10             	add    $0x10,%esp
  8009f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009f8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009ff:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a06:	83 ec 04             	sub    $0x4,%esp
  800a09:	52                   	push   %edx
  800a0a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a0d:	50                   	push   %eax
  800a0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a11:	ff 75 f0             	pushl  -0x10(%ebp)
  800a14:	ff 75 0c             	pushl  0xc(%ebp)
  800a17:	ff 75 08             	pushl  0x8(%ebp)
  800a1a:	e8 00 fb ff ff       	call   80051f <printnum>
  800a1f:	83 c4 20             	add    $0x20,%esp
			break;
  800a22:	eb 34                	jmp    800a58 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	53                   	push   %ebx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	ff d0                	call   *%eax
  800a30:	83 c4 10             	add    $0x10,%esp
			break;
  800a33:	eb 23                	jmp    800a58 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a35:	83 ec 08             	sub    $0x8,%esp
  800a38:	ff 75 0c             	pushl  0xc(%ebp)
  800a3b:	6a 25                	push   $0x25
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	ff d0                	call   *%eax
  800a42:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a45:	ff 4d 10             	decl   0x10(%ebp)
  800a48:	eb 03                	jmp    800a4d <vprintfmt+0x3b1>
  800a4a:	ff 4d 10             	decl   0x10(%ebp)
  800a4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a50:	48                   	dec    %eax
  800a51:	8a 00                	mov    (%eax),%al
  800a53:	3c 25                	cmp    $0x25,%al
  800a55:	75 f3                	jne    800a4a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800a57:	90                   	nop
		}
	}
  800a58:	e9 47 fc ff ff       	jmp    8006a4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a5d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a61:	5b                   	pop    %ebx
  800a62:	5e                   	pop    %esi
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a6b:	8d 45 10             	lea    0x10(%ebp),%eax
  800a6e:	83 c0 04             	add    $0x4,%eax
  800a71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a74:	8b 45 10             	mov    0x10(%ebp),%eax
  800a77:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7a:	50                   	push   %eax
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	ff 75 08             	pushl  0x8(%ebp)
  800a81:	e8 16 fc ff ff       	call   80069c <vprintfmt>
  800a86:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a89:	90                   	nop
  800a8a:	c9                   	leave  
  800a8b:	c3                   	ret    

00800a8c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a92:	8b 40 08             	mov    0x8(%eax),%eax
  800a95:	8d 50 01             	lea    0x1(%eax),%edx
  800a98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa1:	8b 10                	mov    (%eax),%edx
  800aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa6:	8b 40 04             	mov    0x4(%eax),%eax
  800aa9:	39 c2                	cmp    %eax,%edx
  800aab:	73 12                	jae    800abf <sprintputch+0x33>
		*b->buf++ = ch;
  800aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab0:	8b 00                	mov    (%eax),%eax
  800ab2:	8d 48 01             	lea    0x1(%eax),%ecx
  800ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab8:	89 0a                	mov    %ecx,(%edx)
  800aba:	8b 55 08             	mov    0x8(%ebp),%edx
  800abd:	88 10                	mov    %dl,(%eax)
}
  800abf:	90                   	nop
  800ac0:	5d                   	pop    %ebp
  800ac1:	c3                   	ret    

00800ac2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	01 d0                	add    %edx,%eax
  800ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800adc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ae3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ae7:	74 06                	je     800aef <vsnprintf+0x2d>
  800ae9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aed:	7f 07                	jg     800af6 <vsnprintf+0x34>
		return -E_INVAL;
  800aef:	b8 03 00 00 00       	mov    $0x3,%eax
  800af4:	eb 20                	jmp    800b16 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800af6:	ff 75 14             	pushl  0x14(%ebp)
  800af9:	ff 75 10             	pushl  0x10(%ebp)
  800afc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aff:	50                   	push   %eax
  800b00:	68 8c 0a 80 00       	push   $0x800a8c
  800b05:	e8 92 fb ff ff       	call   80069c <vprintfmt>
  800b0a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b10:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b16:	c9                   	leave  
  800b17:	c3                   	ret    

00800b18 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b1e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b21:	83 c0 04             	add    $0x4,%eax
  800b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b27:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b2d:	50                   	push   %eax
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	ff 75 08             	pushl  0x8(%ebp)
  800b34:	e8 89 ff ff ff       	call   800ac2 <vsnprintf>
  800b39:	83 c4 10             	add    $0x10,%esp
  800b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b42:	c9                   	leave  
  800b43:	c3                   	ret    

00800b44 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b51:	eb 06                	jmp    800b59 <strlen+0x15>
		n++;
  800b53:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b56:	ff 45 08             	incl   0x8(%ebp)
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8a 00                	mov    (%eax),%al
  800b5e:	84 c0                	test   %al,%al
  800b60:	75 f1                	jne    800b53 <strlen+0xf>
		n++;
	return n;
  800b62:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b74:	eb 09                	jmp    800b7f <strnlen+0x18>
		n++;
  800b76:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b79:	ff 45 08             	incl   0x8(%ebp)
  800b7c:	ff 4d 0c             	decl   0xc(%ebp)
  800b7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b83:	74 09                	je     800b8e <strnlen+0x27>
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8a 00                	mov    (%eax),%al
  800b8a:	84 c0                	test   %al,%al
  800b8c:	75 e8                	jne    800b76 <strnlen+0xf>
		n++;
	return n;
  800b8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    

00800b93 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b9f:	90                   	nop
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	8d 50 01             	lea    0x1(%eax),%edx
  800ba6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ba9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bac:	8d 4a 01             	lea    0x1(%edx),%ecx
  800baf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bb2:	8a 12                	mov    (%edx),%dl
  800bb4:	88 10                	mov    %dl,(%eax)
  800bb6:	8a 00                	mov    (%eax),%al
  800bb8:	84 c0                	test   %al,%al
  800bba:	75 e4                	jne    800ba0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bbf:	c9                   	leave  
  800bc0:	c3                   	ret    

00800bc1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bcd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd4:	eb 1f                	jmp    800bf5 <strncpy+0x34>
		*dst++ = *src;
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8d 50 01             	lea    0x1(%eax),%edx
  800bdc:	89 55 08             	mov    %edx,0x8(%ebp)
  800bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be2:	8a 12                	mov    (%edx),%dl
  800be4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	8a 00                	mov    (%eax),%al
  800beb:	84 c0                	test   %al,%al
  800bed:	74 03                	je     800bf2 <strncpy+0x31>
			src++;
  800bef:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bf2:	ff 45 fc             	incl   -0x4(%ebp)
  800bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bfb:	72 d9                	jb     800bd6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    

00800c02 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c12:	74 30                	je     800c44 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c14:	eb 16                	jmp    800c2c <strlcpy+0x2a>
			*dst++ = *src++;
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8d 50 01             	lea    0x1(%eax),%edx
  800c1c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c22:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c25:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c28:	8a 12                	mov    (%edx),%dl
  800c2a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c2c:	ff 4d 10             	decl   0x10(%ebp)
  800c2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c33:	74 09                	je     800c3e <strlcpy+0x3c>
  800c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	84 c0                	test   %al,%al
  800c3c:	75 d8                	jne    800c16 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c44:	8b 55 08             	mov    0x8(%ebp),%edx
  800c47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c4a:	29 c2                	sub    %eax,%edx
  800c4c:	89 d0                	mov    %edx,%eax
}
  800c4e:	c9                   	leave  
  800c4f:	c3                   	ret    

00800c50 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c53:	eb 06                	jmp    800c5b <strcmp+0xb>
		p++, q++;
  800c55:	ff 45 08             	incl   0x8(%ebp)
  800c58:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8a 00                	mov    (%eax),%al
  800c60:	84 c0                	test   %al,%al
  800c62:	74 0e                	je     800c72 <strcmp+0x22>
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	8a 10                	mov    (%eax),%dl
  800c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6c:	8a 00                	mov    (%eax),%al
  800c6e:	38 c2                	cmp    %al,%dl
  800c70:	74 e3                	je     800c55 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8a 00                	mov    (%eax),%al
  800c77:	0f b6 d0             	movzbl %al,%edx
  800c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	0f b6 c0             	movzbl %al,%eax
  800c82:	29 c2                	sub    %eax,%edx
  800c84:	89 d0                	mov    %edx,%eax
}
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c8b:	eb 09                	jmp    800c96 <strncmp+0xe>
		n--, p++, q++;
  800c8d:	ff 4d 10             	decl   0x10(%ebp)
  800c90:	ff 45 08             	incl   0x8(%ebp)
  800c93:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9a:	74 17                	je     800cb3 <strncmp+0x2b>
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8a 00                	mov    (%eax),%al
  800ca1:	84 c0                	test   %al,%al
  800ca3:	74 0e                	je     800cb3 <strncmp+0x2b>
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8a 10                	mov    (%eax),%dl
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	8a 00                	mov    (%eax),%al
  800caf:	38 c2                	cmp    %al,%dl
  800cb1:	74 da                	je     800c8d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb7:	75 07                	jne    800cc0 <strncmp+0x38>
		return 0;
  800cb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbe:	eb 14                	jmp    800cd4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	8a 00                	mov    (%eax),%al
  800cc5:	0f b6 d0             	movzbl %al,%edx
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	0f b6 c0             	movzbl %al,%eax
  800cd0:	29 c2                	sub    %eax,%edx
  800cd2:	89 d0                	mov    %edx,%eax
}
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    

00800cd6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	83 ec 04             	sub    $0x4,%esp
  800cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ce2:	eb 12                	jmp    800cf6 <strchr+0x20>
		if (*s == c)
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cec:	75 05                	jne    800cf3 <strchr+0x1d>
			return (char *) s;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	eb 11                	jmp    800d04 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cf3:	ff 45 08             	incl   0x8(%ebp)
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	84 c0                	test   %al,%al
  800cfd:	75 e5                	jne    800ce4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 04             	sub    $0x4,%esp
  800d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d12:	eb 0d                	jmp    800d21 <strfind+0x1b>
		if (*s == c)
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d1c:	74 0e                	je     800d2c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d1e:	ff 45 08             	incl   0x8(%ebp)
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	84 c0                	test   %al,%al
  800d28:	75 ea                	jne    800d14 <strfind+0xe>
  800d2a:	eb 01                	jmp    800d2d <strfind+0x27>
		if (*s == c)
			break;
  800d2c:	90                   	nop
	return (char *) s;
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <memset>:

int i=0;
void *
memset(void *v, int c, uint32 n)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp


	i++;
  800d38:	a1 28 30 80 00       	mov    0x803028,%eax
  800d3d:	40                   	inc    %eax
  800d3e:	a3 28 30 80 00       	mov    %eax,0x803028

	char *p;
	int m;

	p = v;
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d49:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4c:	89 45 f8             	mov    %eax,-0x8(%ebp)


	while (--m >= 0){
  800d4f:	eb 0e                	jmp    800d5f <memset+0x2d>

		*p++ = c;
  800d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d54:	8d 50 01             	lea    0x1(%eax),%edx
  800d57:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5d:	88 10                	mov    %dl,(%eax)

	p = v;
	m = n;


	while (--m >= 0){
  800d5f:	ff 4d f8             	decl   -0x8(%ebp)
  800d62:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d66:	79 e9                	jns    800d51 <memset+0x1f>

		*p++ = c;
	}

	return v;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d6b:	c9                   	leave  
  800d6c:	c3                   	ret    

00800d6d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d7f:	eb 16                	jmp    800d97 <memcpy+0x2a>
		*d++ = *s++;
  800d81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d84:	8d 50 01             	lea    0x1(%eax),%edx
  800d87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d93:	8a 12                	mov    (%edx),%dl
  800d95:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d97:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800da0:	85 c0                	test   %eax,%eax
  800da2:	75 dd                	jne    800d81 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da7:	c9                   	leave  
  800da8:	c3                   	ret    

00800da9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dc1:	73 50                	jae    800e13 <memmove+0x6a>
  800dc3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc9:	01 d0                	add    %edx,%eax
  800dcb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dce:	76 43                	jbe    800e13 <memmove+0x6a>
		s += n;
  800dd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ddc:	eb 10                	jmp    800dee <memmove+0x45>
			*--d = *--s;
  800dde:	ff 4d f8             	decl   -0x8(%ebp)
  800de1:	ff 4d fc             	decl   -0x4(%ebp)
  800de4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de7:	8a 10                	mov    (%eax),%dl
  800de9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dec:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df4:	89 55 10             	mov    %edx,0x10(%ebp)
  800df7:	85 c0                	test   %eax,%eax
  800df9:	75 e3                	jne    800dde <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dfb:	eb 23                	jmp    800e20 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e00:	8d 50 01             	lea    0x1(%eax),%edx
  800e03:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e0f:	8a 12                	mov    (%edx),%dl
  800e11:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e19:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	75 dd                	jne    800dfd <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e34:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e37:	eb 2a                	jmp    800e63 <memcmp+0x3e>
		if (*s1 != *s2)
  800e39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3c:	8a 10                	mov    (%eax),%dl
  800e3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	38 c2                	cmp    %al,%dl
  800e45:	74 16                	je     800e5d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	0f b6 d0             	movzbl %al,%edx
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	0f b6 c0             	movzbl %al,%eax
  800e57:	29 c2                	sub    %eax,%edx
  800e59:	89 d0                	mov    %edx,%eax
  800e5b:	eb 18                	jmp    800e75 <memcmp+0x50>
		s1++, s2++;
  800e5d:	ff 45 fc             	incl   -0x4(%ebp)
  800e60:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e69:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	75 c9                	jne    800e39 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e80:	8b 45 10             	mov    0x10(%ebp),%eax
  800e83:	01 d0                	add    %edx,%eax
  800e85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e88:	eb 15                	jmp    800e9f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	0f b6 d0             	movzbl %al,%edx
  800e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e95:	0f b6 c0             	movzbl %al,%eax
  800e98:	39 c2                	cmp    %eax,%edx
  800e9a:	74 0d                	je     800ea9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e9c:	ff 45 08             	incl   0x8(%ebp)
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ea5:	72 e3                	jb     800e8a <memfind+0x13>
  800ea7:	eb 01                	jmp    800eaa <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ea9:	90                   	nop
	return (void *) s;
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800eb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ebc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec3:	eb 03                	jmp    800ec8 <strtol+0x19>
		s++;
  800ec5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	8a 00                	mov    (%eax),%al
  800ecd:	3c 20                	cmp    $0x20,%al
  800ecf:	74 f4                	je     800ec5 <strtol+0x16>
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	3c 09                	cmp    $0x9,%al
  800ed8:	74 eb                	je     800ec5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	3c 2b                	cmp    $0x2b,%al
  800ee1:	75 05                	jne    800ee8 <strtol+0x39>
		s++;
  800ee3:	ff 45 08             	incl   0x8(%ebp)
  800ee6:	eb 13                	jmp    800efb <strtol+0x4c>
	else if (*s == '-')
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	3c 2d                	cmp    $0x2d,%al
  800eef:	75 0a                	jne    800efb <strtol+0x4c>
		s++, neg = 1;
  800ef1:	ff 45 08             	incl   0x8(%ebp)
  800ef4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800efb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eff:	74 06                	je     800f07 <strtol+0x58>
  800f01:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f05:	75 20                	jne    800f27 <strtol+0x78>
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3c 30                	cmp    $0x30,%al
  800f0e:	75 17                	jne    800f27 <strtol+0x78>
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	40                   	inc    %eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	3c 78                	cmp    $0x78,%al
  800f18:	75 0d                	jne    800f27 <strtol+0x78>
		s += 2, base = 16;
  800f1a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f1e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f25:	eb 28                	jmp    800f4f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2b:	75 15                	jne    800f42 <strtol+0x93>
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	3c 30                	cmp    $0x30,%al
  800f34:	75 0c                	jne    800f42 <strtol+0x93>
		s++, base = 8;
  800f36:	ff 45 08             	incl   0x8(%ebp)
  800f39:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f40:	eb 0d                	jmp    800f4f <strtol+0xa0>
	else if (base == 0)
  800f42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f46:	75 07                	jne    800f4f <strtol+0xa0>
		base = 10;
  800f48:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	3c 2f                	cmp    $0x2f,%al
  800f56:	7e 19                	jle    800f71 <strtol+0xc2>
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	3c 39                	cmp    $0x39,%al
  800f5f:	7f 10                	jg     800f71 <strtol+0xc2>
			dig = *s - '0';
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f be c0             	movsbl %al,%eax
  800f69:	83 e8 30             	sub    $0x30,%eax
  800f6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f6f:	eb 42                	jmp    800fb3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	3c 60                	cmp    $0x60,%al
  800f78:	7e 19                	jle    800f93 <strtol+0xe4>
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 7a                	cmp    $0x7a,%al
  800f81:	7f 10                	jg     800f93 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	0f be c0             	movsbl %al,%eax
  800f8b:	83 e8 57             	sub    $0x57,%eax
  800f8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f91:	eb 20                	jmp    800fb3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	3c 40                	cmp    $0x40,%al
  800f9a:	7e 39                	jle    800fd5 <strtol+0x126>
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	3c 5a                	cmp    $0x5a,%al
  800fa3:	7f 30                	jg     800fd5 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	0f be c0             	movsbl %al,%eax
  800fad:	83 e8 37             	sub    $0x37,%eax
  800fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fb9:	7d 19                	jge    800fd4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fbb:	ff 45 08             	incl   0x8(%ebp)
  800fbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fc5:	89 c2                	mov    %eax,%edx
  800fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fca:	01 d0                	add    %edx,%eax
  800fcc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fcf:	e9 7b ff ff ff       	jmp    800f4f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fd4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fd9:	74 08                	je     800fe3 <strtol+0x134>
		*endptr = (char *) s;
  800fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fde:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fe3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fe7:	74 07                	je     800ff0 <strtol+0x141>
  800fe9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fec:	f7 d8                	neg    %eax
  800fee:	eb 03                	jmp    800ff3 <strtol+0x144>
  800ff0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ff3:	c9                   	leave  
  800ff4:	c3                   	ret    

00800ff5 <ltostr>:

void
ltostr(long value, char *str)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ffb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801002:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801009:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80100d:	79 13                	jns    801022 <ltostr+0x2d>
	{
		neg = 1;
  80100f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80101c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80101f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80102a:	99                   	cltd   
  80102b:	f7 f9                	idiv   %ecx
  80102d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801030:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801033:	8d 50 01             	lea    0x1(%eax),%edx
  801036:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801039:	89 c2                	mov    %eax,%edx
  80103b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103e:	01 d0                	add    %edx,%eax
  801040:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801043:	83 c2 30             	add    $0x30,%edx
  801046:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801048:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801050:	f7 e9                	imul   %ecx
  801052:	c1 fa 02             	sar    $0x2,%edx
  801055:	89 c8                	mov    %ecx,%eax
  801057:	c1 f8 1f             	sar    $0x1f,%eax
  80105a:	29 c2                	sub    %eax,%edx
  80105c:	89 d0                	mov    %edx,%eax
  80105e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801061:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801064:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801069:	f7 e9                	imul   %ecx
  80106b:	c1 fa 02             	sar    $0x2,%edx
  80106e:	89 c8                	mov    %ecx,%eax
  801070:	c1 f8 1f             	sar    $0x1f,%eax
  801073:	29 c2                	sub    %eax,%edx
  801075:	89 d0                	mov    %edx,%eax
  801077:	c1 e0 02             	shl    $0x2,%eax
  80107a:	01 d0                	add    %edx,%eax
  80107c:	01 c0                	add    %eax,%eax
  80107e:	29 c1                	sub    %eax,%ecx
  801080:	89 ca                	mov    %ecx,%edx
  801082:	85 d2                	test   %edx,%edx
  801084:	75 9c                	jne    801022 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801086:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801090:	48                   	dec    %eax
  801091:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801094:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801098:	74 3d                	je     8010d7 <ltostr+0xe2>
		start = 1 ;
  80109a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010a1:	eb 34                	jmp    8010d7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a9:	01 d0                	add    %edx,%eax
  8010ab:	8a 00                	mov    (%eax),%al
  8010ad:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b6:	01 c2                	add    %eax,%edx
  8010b8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010be:	01 c8                	add    %ecx,%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ca:	01 c2                	add    %eax,%edx
  8010cc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010cf:	88 02                	mov    %al,(%edx)
		start++ ;
  8010d1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010d4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010dd:	7c c4                	jl     8010a3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010df:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e5:	01 d0                	add    %edx,%eax
  8010e7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010ea:	90                   	nop
  8010eb:	c9                   	leave  
  8010ec:	c3                   	ret    

008010ed <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
  8010f0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010f3:	ff 75 08             	pushl  0x8(%ebp)
  8010f6:	e8 49 fa ff ff       	call   800b44 <strlen>
  8010fb:	83 c4 04             	add    $0x4,%esp
  8010fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801101:	ff 75 0c             	pushl  0xc(%ebp)
  801104:	e8 3b fa ff ff       	call   800b44 <strlen>
  801109:	83 c4 04             	add    $0x4,%esp
  80110c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80110f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801116:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80111d:	eb 17                	jmp    801136 <strcconcat+0x49>
		final[s] = str1[s] ;
  80111f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801122:	8b 45 10             	mov    0x10(%ebp),%eax
  801125:	01 c2                	add    %eax,%edx
  801127:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	01 c8                	add    %ecx,%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801133:	ff 45 fc             	incl   -0x4(%ebp)
  801136:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801139:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80113c:	7c e1                	jl     80111f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80113e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801145:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80114c:	eb 1f                	jmp    80116d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80114e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801151:	8d 50 01             	lea    0x1(%eax),%edx
  801154:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801157:	89 c2                	mov    %eax,%edx
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	01 c2                	add    %eax,%edx
  80115e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801161:	8b 45 0c             	mov    0xc(%ebp),%eax
  801164:	01 c8                	add    %ecx,%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80116a:	ff 45 f8             	incl   -0x8(%ebp)
  80116d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801170:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801173:	7c d9                	jl     80114e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801175:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801178:	8b 45 10             	mov    0x10(%ebp),%eax
  80117b:	01 d0                	add    %edx,%eax
  80117d:	c6 00 00             	movb   $0x0,(%eax)
}
  801180:	90                   	nop
  801181:	c9                   	leave  
  801182:	c3                   	ret    

00801183 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801186:	8b 45 14             	mov    0x14(%ebp),%eax
  801189:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80118f:	8b 45 14             	mov    0x14(%ebp),%eax
  801192:	8b 00                	mov    (%eax),%eax
  801194:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	01 d0                	add    %edx,%eax
  8011a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011a6:	eb 0c                	jmp    8011b4 <strsplit+0x31>
			*string++ = 0;
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8d 50 01             	lea    0x1(%eax),%edx
  8011ae:	89 55 08             	mov    %edx,0x8(%ebp)
  8011b1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	84 c0                	test   %al,%al
  8011bb:	74 18                	je     8011d5 <strsplit+0x52>
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	0f be c0             	movsbl %al,%eax
  8011c5:	50                   	push   %eax
  8011c6:	ff 75 0c             	pushl  0xc(%ebp)
  8011c9:	e8 08 fb ff ff       	call   800cd6 <strchr>
  8011ce:	83 c4 08             	add    $0x8,%esp
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	75 d3                	jne    8011a8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	84 c0                	test   %al,%al
  8011dc:	74 5a                	je     801238 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	8b 00                	mov    (%eax),%eax
  8011e3:	83 f8 0f             	cmp    $0xf,%eax
  8011e6:	75 07                	jne    8011ef <strsplit+0x6c>
		{
			return 0;
  8011e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ed:	eb 66                	jmp    801255 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f2:	8b 00                	mov    (%eax),%eax
  8011f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8011f7:	8b 55 14             	mov    0x14(%ebp),%edx
  8011fa:	89 0a                	mov    %ecx,(%edx)
  8011fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801203:	8b 45 10             	mov    0x10(%ebp),%eax
  801206:	01 c2                	add    %eax,%edx
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80120d:	eb 03                	jmp    801212 <strsplit+0x8f>
			string++;
  80120f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	84 c0                	test   %al,%al
  801219:	74 8b                	je     8011a6 <strsplit+0x23>
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	0f be c0             	movsbl %al,%eax
  801223:	50                   	push   %eax
  801224:	ff 75 0c             	pushl  0xc(%ebp)
  801227:	e8 aa fa ff ff       	call   800cd6 <strchr>
  80122c:	83 c4 08             	add    $0x8,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	74 dc                	je     80120f <strsplit+0x8c>
			string++;
	}
  801233:	e9 6e ff ff ff       	jmp    8011a6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801238:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801239:	8b 45 14             	mov    0x14(%ebp),%eax
  80123c:	8b 00                	mov    (%eax),%eax
  80123e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801245:	8b 45 10             	mov    0x10(%ebp),%eax
  801248:	01 d0                	add    %edx,%eax
  80124a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801250:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801255:	c9                   	leave  
  801256:	c3                   	ret    

00801257 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  80125d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801261:	74 06                	je     801269 <str2lower+0x12>
  801263:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801267:	75 07                	jne    801270 <str2lower+0x19>
		return NULL;
  801269:	b8 00 00 00 00       	mov    $0x0,%eax
  80126e:	eb 4d                	jmp    8012bd <str2lower+0x66>
	}
	char *ref=dst;
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  801276:	eb 33                	jmp    8012ab <str2lower+0x54>
			if(*src>=65&&*src<=90){
  801278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	3c 40                	cmp    $0x40,%al
  80127f:	7e 1a                	jle    80129b <str2lower+0x44>
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	3c 5a                	cmp    $0x5a,%al
  801288:	7f 11                	jg     80129b <str2lower+0x44>
				*dst=*src+32;
  80128a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	83 c0 20             	add    $0x20,%eax
  801292:	88 c2                	mov    %al,%dl
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	88 10                	mov    %dl,(%eax)
  801299:	eb 0a                	jmp    8012a5 <str2lower+0x4e>
			}
			else{
				*dst=*src;
  80129b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129e:	8a 10                	mov    (%eax),%dl
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	88 10                	mov    %dl,(%eax)
			}
			src++;
  8012a5:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  8012a8:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	84 c0                	test   %al,%al
  8012b2:	75 c4                	jne    801278 <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	57                   	push   %edi
  8012c3:	56                   	push   %esi
  8012c4:	53                   	push   %ebx
  8012c5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012d4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012d7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012da:	cd 30                	int    $0x30
  8012dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012e2:	83 c4 10             	add    $0x10,%esp
  8012e5:	5b                   	pop    %ebx
  8012e6:	5e                   	pop    %esi
  8012e7:	5f                   	pop    %edi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    

008012ea <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	83 ec 04             	sub    $0x4,%esp
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 00                	push   $0x0
  801301:	52                   	push   %edx
  801302:	ff 75 0c             	pushl  0xc(%ebp)
  801305:	50                   	push   %eax
  801306:	6a 00                	push   $0x0
  801308:	e8 b2 ff ff ff       	call   8012bf <syscall>
  80130d:	83 c4 18             	add    $0x18,%esp
}
  801310:	90                   	nop
  801311:	c9                   	leave  
  801312:	c3                   	ret    

00801313 <sys_cgetc>:

int
sys_cgetc(void)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 01                	push   $0x1
  801322:	e8 98 ff ff ff       	call   8012bf <syscall>
  801327:	83 c4 18             	add    $0x18,%esp
}
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80132f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	52                   	push   %edx
  80133c:	50                   	push   %eax
  80133d:	6a 05                	push   $0x5
  80133f:	e8 7b ff ff ff       	call   8012bf <syscall>
  801344:	83 c4 18             	add    $0x18,%esp
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	56                   	push   %esi
  80134d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80134e:	8b 75 18             	mov    0x18(%ebp),%esi
  801351:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801354:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	56                   	push   %esi
  80135e:	53                   	push   %ebx
  80135f:	51                   	push   %ecx
  801360:	52                   	push   %edx
  801361:	50                   	push   %eax
  801362:	6a 06                	push   $0x6
  801364:	e8 56 ff ff ff       	call   8012bf <syscall>
  801369:	83 c4 18             	add    $0x18,%esp
}
  80136c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80136f:	5b                   	pop    %ebx
  801370:	5e                   	pop    %esi
  801371:	5d                   	pop    %ebp
  801372:	c3                   	ret    

00801373 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801376:	8b 55 0c             	mov    0xc(%ebp),%edx
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	52                   	push   %edx
  801383:	50                   	push   %eax
  801384:	6a 07                	push   $0x7
  801386:	e8 34 ff ff ff       	call   8012bf <syscall>
  80138b:	83 c4 18             	add    $0x18,%esp
}
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    

00801390 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	ff 75 0c             	pushl  0xc(%ebp)
  80139c:	ff 75 08             	pushl  0x8(%ebp)
  80139f:	6a 08                	push   $0x8
  8013a1:	e8 19 ff ff ff       	call   8012bf <syscall>
  8013a6:	83 c4 18             	add    $0x18,%esp
}
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    

008013ab <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 09                	push   $0x9
  8013ba:	e8 00 ff ff ff       	call   8012bf <syscall>
  8013bf:	83 c4 18             	add    $0x18,%esp
}
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    

008013c4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 0a                	push   $0xa
  8013d3:	e8 e7 fe ff ff       	call   8012bf <syscall>
  8013d8:	83 c4 18             	add    $0x18,%esp
}
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 0b                	push   $0xb
  8013ec:	e8 ce fe ff ff       	call   8012bf <syscall>
  8013f1:	83 c4 18             	add    $0x18,%esp
}
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 0c                	push   $0xc
  801405:	e8 b5 fe ff ff       	call   8012bf <syscall>
  80140a:	83 c4 18             	add    $0x18,%esp
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	ff 75 08             	pushl  0x8(%ebp)
  80141d:	6a 0d                	push   $0xd
  80141f:	e8 9b fe ff ff       	call   8012bf <syscall>
  801424:	83 c4 18             	add    $0x18,%esp
}
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 0e                	push   $0xe
  801438:	e8 82 fe ff ff       	call   8012bf <syscall>
  80143d:	83 c4 18             	add    $0x18,%esp
}
  801440:	90                   	nop
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 11                	push   $0x11
  801452:	e8 68 fe ff ff       	call   8012bf <syscall>
  801457:	83 c4 18             	add    $0x18,%esp
}
  80145a:	90                   	nop
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 12                	push   $0x12
  80146c:	e8 4e fe ff ff       	call   8012bf <syscall>
  801471:	83 c4 18             	add    $0x18,%esp
}
  801474:	90                   	nop
  801475:	c9                   	leave  
  801476:	c3                   	ret    

00801477 <sys_cputc>:


void
sys_cputc(const char c)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	83 ec 04             	sub    $0x4,%esp
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801483:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	50                   	push   %eax
  801490:	6a 13                	push   $0x13
  801492:	e8 28 fe ff ff       	call   8012bf <syscall>
  801497:	83 c4 18             	add    $0x18,%esp
}
  80149a:	90                   	nop
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 14                	push   $0x14
  8014ac:	e8 0e fe ff ff       	call   8012bf <syscall>
  8014b1:	83 c4 18             	add    $0x18,%esp
}
  8014b4:	90                   	nop
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	ff 75 0c             	pushl  0xc(%ebp)
  8014c6:	50                   	push   %eax
  8014c7:	6a 15                	push   $0x15
  8014c9:	e8 f1 fd ff ff       	call   8012bf <syscall>
  8014ce:	83 c4 18             	add    $0x18,%esp
}
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	52                   	push   %edx
  8014e3:	50                   	push   %eax
  8014e4:	6a 18                	push   $0x18
  8014e6:	e8 d4 fd ff ff       	call   8012bf <syscall>
  8014eb:	83 c4 18             	add    $0x18,%esp
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	52                   	push   %edx
  801500:	50                   	push   %eax
  801501:	6a 16                	push   $0x16
  801503:	e8 b7 fd ff ff       	call   8012bf <syscall>
  801508:	83 c4 18             	add    $0x18,%esp
}
  80150b:	90                   	nop
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801511:	8b 55 0c             	mov    0xc(%ebp),%edx
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	52                   	push   %edx
  80151e:	50                   	push   %eax
  80151f:	6a 17                	push   $0x17
  801521:	e8 99 fd ff ff       	call   8012bf <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	90                   	nop
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 04             	sub    $0x4,%esp
  801532:	8b 45 10             	mov    0x10(%ebp),%eax
  801535:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801538:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80153b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	6a 00                	push   $0x0
  801544:	51                   	push   %ecx
  801545:	52                   	push   %edx
  801546:	ff 75 0c             	pushl  0xc(%ebp)
  801549:	50                   	push   %eax
  80154a:	6a 19                	push   $0x19
  80154c:	e8 6e fd ff ff       	call   8012bf <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801559:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	52                   	push   %edx
  801566:	50                   	push   %eax
  801567:	6a 1a                	push   $0x1a
  801569:	e8 51 fd ff ff       	call   8012bf <syscall>
  80156e:	83 c4 18             	add    $0x18,%esp
}
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801576:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	51                   	push   %ecx
  801584:	52                   	push   %edx
  801585:	50                   	push   %eax
  801586:	6a 1b                	push   $0x1b
  801588:	e8 32 fd ff ff       	call   8012bf <syscall>
  80158d:	83 c4 18             	add    $0x18,%esp
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801595:	8b 55 0c             	mov    0xc(%ebp),%edx
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	52                   	push   %edx
  8015a2:	50                   	push   %eax
  8015a3:	6a 1c                	push   $0x1c
  8015a5:	e8 15 fd ff ff       	call   8012bf <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 1d                	push   $0x1d
  8015be:	e8 fc fc ff ff       	call   8012bf <syscall>
  8015c3:	83 c4 18             	add    $0x18,%esp
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	6a 00                	push   $0x0
  8015d0:	ff 75 14             	pushl  0x14(%ebp)
  8015d3:	ff 75 10             	pushl  0x10(%ebp)
  8015d6:	ff 75 0c             	pushl  0xc(%ebp)
  8015d9:	50                   	push   %eax
  8015da:	6a 1e                	push   $0x1e
  8015dc:	e8 de fc ff ff       	call   8012bf <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	50                   	push   %eax
  8015f5:	6a 1f                	push   $0x1f
  8015f7:	e8 c3 fc ff ff       	call   8012bf <syscall>
  8015fc:	83 c4 18             	add    $0x18,%esp
}
  8015ff:	90                   	nop
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	50                   	push   %eax
  801611:	6a 20                	push   $0x20
  801613:	e8 a7 fc ff ff       	call   8012bf <syscall>
  801618:	83 c4 18             	add    $0x18,%esp
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 02                	push   $0x2
  80162c:	e8 8e fc ff ff       	call   8012bf <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 03                	push   $0x3
  801645:	e8 75 fc ff ff       	call   8012bf <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 04                	push   $0x4
  80165e:	e8 5c fc ff ff       	call   8012bf <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <sys_exit_env>:


void sys_exit_env(void)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 21                	push   $0x21
  801677:	e8 43 fc ff ff       	call   8012bf <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
}
  80167f:	90                   	nop
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801688:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80168b:	8d 50 04             	lea    0x4(%eax),%edx
  80168e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	52                   	push   %edx
  801698:	50                   	push   %eax
  801699:	6a 22                	push   $0x22
  80169b:	e8 1f fc ff ff       	call   8012bf <syscall>
  8016a0:	83 c4 18             	add    $0x18,%esp
	return result;
  8016a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ac:	89 01                	mov    %eax,(%ecx)
  8016ae:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	c9                   	leave  
  8016b5:	c2 04 00             	ret    $0x4

008016b8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	ff 75 10             	pushl  0x10(%ebp)
  8016c2:	ff 75 0c             	pushl  0xc(%ebp)
  8016c5:	ff 75 08             	pushl  0x8(%ebp)
  8016c8:	6a 10                	push   $0x10
  8016ca:	e8 f0 fb ff ff       	call   8012bf <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d2:	90                   	nop
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 23                	push   $0x23
  8016e4:	e8 d6 fb ff ff       	call   8012bf <syscall>
  8016e9:	83 c4 18             	add    $0x18,%esp
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 04             	sub    $0x4,%esp
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016fa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	50                   	push   %eax
  801707:	6a 24                	push   $0x24
  801709:	e8 b1 fb ff ff       	call   8012bf <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
	return ;
  801711:	90                   	nop
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <rsttst>:
void rsttst()
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 26                	push   $0x26
  801723:	e8 97 fb ff ff       	call   8012bf <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
	return ;
  80172b:	90                   	nop
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 04             	sub    $0x4,%esp
  801734:	8b 45 14             	mov    0x14(%ebp),%eax
  801737:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80173a:	8b 55 18             	mov    0x18(%ebp),%edx
  80173d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801741:	52                   	push   %edx
  801742:	50                   	push   %eax
  801743:	ff 75 10             	pushl  0x10(%ebp)
  801746:	ff 75 0c             	pushl  0xc(%ebp)
  801749:	ff 75 08             	pushl  0x8(%ebp)
  80174c:	6a 25                	push   $0x25
  80174e:	e8 6c fb ff ff       	call   8012bf <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
	return ;
  801756:	90                   	nop
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <chktst>:
void chktst(uint32 n)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	ff 75 08             	pushl  0x8(%ebp)
  801767:	6a 27                	push   $0x27
  801769:	e8 51 fb ff ff       	call   8012bf <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
	return ;
  801771:	90                   	nop
}
  801772:	c9                   	leave  
  801773:	c3                   	ret    

00801774 <inctst>:

void inctst()
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 28                	push   $0x28
  801783:	e8 37 fb ff ff       	call   8012bf <syscall>
  801788:	83 c4 18             	add    $0x18,%esp
	return ;
  80178b:	90                   	nop
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <gettst>:
uint32 gettst()
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 29                	push   $0x29
  80179d:	e8 1d fb ff ff       	call   8012bf <syscall>
  8017a2:	83 c4 18             	add    $0x18,%esp
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 2a                	push   $0x2a
  8017b9:	e8 01 fb ff ff       	call   8012bf <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
  8017c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017c4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017c8:	75 07                	jne    8017d1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8017cf:	eb 05                	jmp    8017d6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 2a                	push   $0x2a
  8017ea:	e8 d0 fa ff ff       	call   8012bf <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
  8017f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8017f5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017f9:	75 07                	jne    801802 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017fb:	b8 01 00 00 00       	mov    $0x1,%eax
  801800:	eb 05                	jmp    801807 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 2a                	push   $0x2a
  80181b:	e8 9f fa ff ff       	call   8012bf <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
  801823:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801826:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80182a:	75 07                	jne    801833 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80182c:	b8 01 00 00 00       	mov    $0x1,%eax
  801831:	eb 05                	jmp    801838 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801833:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 2a                	push   $0x2a
  80184c:	e8 6e fa ff ff       	call   8012bf <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
  801854:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801857:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80185b:	75 07                	jne    801864 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80185d:	b8 01 00 00 00       	mov    $0x1,%eax
  801862:	eb 05                	jmp    801869 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801864:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	ff 75 08             	pushl  0x8(%ebp)
  801879:	6a 2b                	push   $0x2b
  80187b:	e8 3f fa ff ff       	call   8012bf <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
	return ;
  801883:	90                   	nop
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80188a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80188d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801890:	8b 55 0c             	mov    0xc(%ebp),%edx
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	6a 00                	push   $0x0
  801898:	53                   	push   %ebx
  801899:	51                   	push   %ecx
  80189a:	52                   	push   %edx
  80189b:	50                   	push   %eax
  80189c:	6a 2c                	push   $0x2c
  80189e:	e8 1c fa ff ff       	call   8012bf <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	52                   	push   %edx
  8018bb:	50                   	push   %eax
  8018bc:	6a 2d                	push   $0x2d
  8018be:	e8 fc f9 ff ff       	call   8012bf <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018cb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	6a 00                	push   $0x0
  8018d6:	51                   	push   %ecx
  8018d7:	ff 75 10             	pushl  0x10(%ebp)
  8018da:	52                   	push   %edx
  8018db:	50                   	push   %eax
  8018dc:	6a 2e                	push   $0x2e
  8018de:	e8 dc f9 ff ff       	call   8012bf <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	ff 75 10             	pushl  0x10(%ebp)
  8018f2:	ff 75 0c             	pushl  0xc(%ebp)
  8018f5:	ff 75 08             	pushl  0x8(%ebp)
  8018f8:	6a 0f                	push   $0xf
  8018fa:	e8 c0 f9 ff ff       	call   8012bf <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801902:	90                   	nop
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	50                   	push   %eax
  801914:	6a 2f                	push   $0x2f
  801916:	e8 a4 f9 ff ff       	call   8012bf <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	ff 75 0c             	pushl  0xc(%ebp)
  80192c:	ff 75 08             	pushl  0x8(%ebp)
  80192f:	6a 30                	push   $0x30
  801931:	e8 89 f9 ff ff       	call   8012bf <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801939:	90                   	nop
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	ff 75 08             	pushl  0x8(%ebp)
  80194b:	6a 31                	push   $0x31
  80194d:	e8 6d f9 ff ff       	call   8012bf <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801955:	90                   	nop
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <__udivdi3>:
  801958:	55                   	push   %ebp
  801959:	57                   	push   %edi
  80195a:	56                   	push   %esi
  80195b:	53                   	push   %ebx
  80195c:	83 ec 1c             	sub    $0x1c,%esp
  80195f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801963:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801967:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80196b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80196f:	89 ca                	mov    %ecx,%edx
  801971:	89 f8                	mov    %edi,%eax
  801973:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801977:	85 f6                	test   %esi,%esi
  801979:	75 2d                	jne    8019a8 <__udivdi3+0x50>
  80197b:	39 cf                	cmp    %ecx,%edi
  80197d:	77 65                	ja     8019e4 <__udivdi3+0x8c>
  80197f:	89 fd                	mov    %edi,%ebp
  801981:	85 ff                	test   %edi,%edi
  801983:	75 0b                	jne    801990 <__udivdi3+0x38>
  801985:	b8 01 00 00 00       	mov    $0x1,%eax
  80198a:	31 d2                	xor    %edx,%edx
  80198c:	f7 f7                	div    %edi
  80198e:	89 c5                	mov    %eax,%ebp
  801990:	31 d2                	xor    %edx,%edx
  801992:	89 c8                	mov    %ecx,%eax
  801994:	f7 f5                	div    %ebp
  801996:	89 c1                	mov    %eax,%ecx
  801998:	89 d8                	mov    %ebx,%eax
  80199a:	f7 f5                	div    %ebp
  80199c:	89 cf                	mov    %ecx,%edi
  80199e:	89 fa                	mov    %edi,%edx
  8019a0:	83 c4 1c             	add    $0x1c,%esp
  8019a3:	5b                   	pop    %ebx
  8019a4:	5e                   	pop    %esi
  8019a5:	5f                   	pop    %edi
  8019a6:	5d                   	pop    %ebp
  8019a7:	c3                   	ret    
  8019a8:	39 ce                	cmp    %ecx,%esi
  8019aa:	77 28                	ja     8019d4 <__udivdi3+0x7c>
  8019ac:	0f bd fe             	bsr    %esi,%edi
  8019af:	83 f7 1f             	xor    $0x1f,%edi
  8019b2:	75 40                	jne    8019f4 <__udivdi3+0x9c>
  8019b4:	39 ce                	cmp    %ecx,%esi
  8019b6:	72 0a                	jb     8019c2 <__udivdi3+0x6a>
  8019b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019bc:	0f 87 9e 00 00 00    	ja     801a60 <__udivdi3+0x108>
  8019c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c7:	89 fa                	mov    %edi,%edx
  8019c9:	83 c4 1c             	add    $0x1c,%esp
  8019cc:	5b                   	pop    %ebx
  8019cd:	5e                   	pop    %esi
  8019ce:	5f                   	pop    %edi
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    
  8019d1:	8d 76 00             	lea    0x0(%esi),%esi
  8019d4:	31 ff                	xor    %edi,%edi
  8019d6:	31 c0                	xor    %eax,%eax
  8019d8:	89 fa                	mov    %edi,%edx
  8019da:	83 c4 1c             	add    $0x1c,%esp
  8019dd:	5b                   	pop    %ebx
  8019de:	5e                   	pop    %esi
  8019df:	5f                   	pop    %edi
  8019e0:	5d                   	pop    %ebp
  8019e1:	c3                   	ret    
  8019e2:	66 90                	xchg   %ax,%ax
  8019e4:	89 d8                	mov    %ebx,%eax
  8019e6:	f7 f7                	div    %edi
  8019e8:	31 ff                	xor    %edi,%edi
  8019ea:	89 fa                	mov    %edi,%edx
  8019ec:	83 c4 1c             	add    $0x1c,%esp
  8019ef:	5b                   	pop    %ebx
  8019f0:	5e                   	pop    %esi
  8019f1:	5f                   	pop    %edi
  8019f2:	5d                   	pop    %ebp
  8019f3:	c3                   	ret    
  8019f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019f9:	89 eb                	mov    %ebp,%ebx
  8019fb:	29 fb                	sub    %edi,%ebx
  8019fd:	89 f9                	mov    %edi,%ecx
  8019ff:	d3 e6                	shl    %cl,%esi
  801a01:	89 c5                	mov    %eax,%ebp
  801a03:	88 d9                	mov    %bl,%cl
  801a05:	d3 ed                	shr    %cl,%ebp
  801a07:	89 e9                	mov    %ebp,%ecx
  801a09:	09 f1                	or     %esi,%ecx
  801a0b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a0f:	89 f9                	mov    %edi,%ecx
  801a11:	d3 e0                	shl    %cl,%eax
  801a13:	89 c5                	mov    %eax,%ebp
  801a15:	89 d6                	mov    %edx,%esi
  801a17:	88 d9                	mov    %bl,%cl
  801a19:	d3 ee                	shr    %cl,%esi
  801a1b:	89 f9                	mov    %edi,%ecx
  801a1d:	d3 e2                	shl    %cl,%edx
  801a1f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a23:	88 d9                	mov    %bl,%cl
  801a25:	d3 e8                	shr    %cl,%eax
  801a27:	09 c2                	or     %eax,%edx
  801a29:	89 d0                	mov    %edx,%eax
  801a2b:	89 f2                	mov    %esi,%edx
  801a2d:	f7 74 24 0c          	divl   0xc(%esp)
  801a31:	89 d6                	mov    %edx,%esi
  801a33:	89 c3                	mov    %eax,%ebx
  801a35:	f7 e5                	mul    %ebp
  801a37:	39 d6                	cmp    %edx,%esi
  801a39:	72 19                	jb     801a54 <__udivdi3+0xfc>
  801a3b:	74 0b                	je     801a48 <__udivdi3+0xf0>
  801a3d:	89 d8                	mov    %ebx,%eax
  801a3f:	31 ff                	xor    %edi,%edi
  801a41:	e9 58 ff ff ff       	jmp    80199e <__udivdi3+0x46>
  801a46:	66 90                	xchg   %ax,%ax
  801a48:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a4c:	89 f9                	mov    %edi,%ecx
  801a4e:	d3 e2                	shl    %cl,%edx
  801a50:	39 c2                	cmp    %eax,%edx
  801a52:	73 e9                	jae    801a3d <__udivdi3+0xe5>
  801a54:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a57:	31 ff                	xor    %edi,%edi
  801a59:	e9 40 ff ff ff       	jmp    80199e <__udivdi3+0x46>
  801a5e:	66 90                	xchg   %ax,%ax
  801a60:	31 c0                	xor    %eax,%eax
  801a62:	e9 37 ff ff ff       	jmp    80199e <__udivdi3+0x46>
  801a67:	90                   	nop

00801a68 <__umoddi3>:
  801a68:	55                   	push   %ebp
  801a69:	57                   	push   %edi
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	83 ec 1c             	sub    $0x1c,%esp
  801a6f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a73:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a87:	89 f3                	mov    %esi,%ebx
  801a89:	89 fa                	mov    %edi,%edx
  801a8b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a8f:	89 34 24             	mov    %esi,(%esp)
  801a92:	85 c0                	test   %eax,%eax
  801a94:	75 1a                	jne    801ab0 <__umoddi3+0x48>
  801a96:	39 f7                	cmp    %esi,%edi
  801a98:	0f 86 a2 00 00 00    	jbe    801b40 <__umoddi3+0xd8>
  801a9e:	89 c8                	mov    %ecx,%eax
  801aa0:	89 f2                	mov    %esi,%edx
  801aa2:	f7 f7                	div    %edi
  801aa4:	89 d0                	mov    %edx,%eax
  801aa6:	31 d2                	xor    %edx,%edx
  801aa8:	83 c4 1c             	add    $0x1c,%esp
  801aab:	5b                   	pop    %ebx
  801aac:	5e                   	pop    %esi
  801aad:	5f                   	pop    %edi
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    
  801ab0:	39 f0                	cmp    %esi,%eax
  801ab2:	0f 87 ac 00 00 00    	ja     801b64 <__umoddi3+0xfc>
  801ab8:	0f bd e8             	bsr    %eax,%ebp
  801abb:	83 f5 1f             	xor    $0x1f,%ebp
  801abe:	0f 84 ac 00 00 00    	je     801b70 <__umoddi3+0x108>
  801ac4:	bf 20 00 00 00       	mov    $0x20,%edi
  801ac9:	29 ef                	sub    %ebp,%edi
  801acb:	89 fe                	mov    %edi,%esi
  801acd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ad1:	89 e9                	mov    %ebp,%ecx
  801ad3:	d3 e0                	shl    %cl,%eax
  801ad5:	89 d7                	mov    %edx,%edi
  801ad7:	89 f1                	mov    %esi,%ecx
  801ad9:	d3 ef                	shr    %cl,%edi
  801adb:	09 c7                	or     %eax,%edi
  801add:	89 e9                	mov    %ebp,%ecx
  801adf:	d3 e2                	shl    %cl,%edx
  801ae1:	89 14 24             	mov    %edx,(%esp)
  801ae4:	89 d8                	mov    %ebx,%eax
  801ae6:	d3 e0                	shl    %cl,%eax
  801ae8:	89 c2                	mov    %eax,%edx
  801aea:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aee:	d3 e0                	shl    %cl,%eax
  801af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801af8:	89 f1                	mov    %esi,%ecx
  801afa:	d3 e8                	shr    %cl,%eax
  801afc:	09 d0                	or     %edx,%eax
  801afe:	d3 eb                	shr    %cl,%ebx
  801b00:	89 da                	mov    %ebx,%edx
  801b02:	f7 f7                	div    %edi
  801b04:	89 d3                	mov    %edx,%ebx
  801b06:	f7 24 24             	mull   (%esp)
  801b09:	89 c6                	mov    %eax,%esi
  801b0b:	89 d1                	mov    %edx,%ecx
  801b0d:	39 d3                	cmp    %edx,%ebx
  801b0f:	0f 82 87 00 00 00    	jb     801b9c <__umoddi3+0x134>
  801b15:	0f 84 91 00 00 00    	je     801bac <__umoddi3+0x144>
  801b1b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b1f:	29 f2                	sub    %esi,%edx
  801b21:	19 cb                	sbb    %ecx,%ebx
  801b23:	89 d8                	mov    %ebx,%eax
  801b25:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b29:	d3 e0                	shl    %cl,%eax
  801b2b:	89 e9                	mov    %ebp,%ecx
  801b2d:	d3 ea                	shr    %cl,%edx
  801b2f:	09 d0                	or     %edx,%eax
  801b31:	89 e9                	mov    %ebp,%ecx
  801b33:	d3 eb                	shr    %cl,%ebx
  801b35:	89 da                	mov    %ebx,%edx
  801b37:	83 c4 1c             	add    $0x1c,%esp
  801b3a:	5b                   	pop    %ebx
  801b3b:	5e                   	pop    %esi
  801b3c:	5f                   	pop    %edi
  801b3d:	5d                   	pop    %ebp
  801b3e:	c3                   	ret    
  801b3f:	90                   	nop
  801b40:	89 fd                	mov    %edi,%ebp
  801b42:	85 ff                	test   %edi,%edi
  801b44:	75 0b                	jne    801b51 <__umoddi3+0xe9>
  801b46:	b8 01 00 00 00       	mov    $0x1,%eax
  801b4b:	31 d2                	xor    %edx,%edx
  801b4d:	f7 f7                	div    %edi
  801b4f:	89 c5                	mov    %eax,%ebp
  801b51:	89 f0                	mov    %esi,%eax
  801b53:	31 d2                	xor    %edx,%edx
  801b55:	f7 f5                	div    %ebp
  801b57:	89 c8                	mov    %ecx,%eax
  801b59:	f7 f5                	div    %ebp
  801b5b:	89 d0                	mov    %edx,%eax
  801b5d:	e9 44 ff ff ff       	jmp    801aa6 <__umoddi3+0x3e>
  801b62:	66 90                	xchg   %ax,%ax
  801b64:	89 c8                	mov    %ecx,%eax
  801b66:	89 f2                	mov    %esi,%edx
  801b68:	83 c4 1c             	add    $0x1c,%esp
  801b6b:	5b                   	pop    %ebx
  801b6c:	5e                   	pop    %esi
  801b6d:	5f                   	pop    %edi
  801b6e:	5d                   	pop    %ebp
  801b6f:	c3                   	ret    
  801b70:	3b 04 24             	cmp    (%esp),%eax
  801b73:	72 06                	jb     801b7b <__umoddi3+0x113>
  801b75:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b79:	77 0f                	ja     801b8a <__umoddi3+0x122>
  801b7b:	89 f2                	mov    %esi,%edx
  801b7d:	29 f9                	sub    %edi,%ecx
  801b7f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b83:	89 14 24             	mov    %edx,(%esp)
  801b86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b8a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b8e:	8b 14 24             	mov    (%esp),%edx
  801b91:	83 c4 1c             	add    $0x1c,%esp
  801b94:	5b                   	pop    %ebx
  801b95:	5e                   	pop    %esi
  801b96:	5f                   	pop    %edi
  801b97:	5d                   	pop    %ebp
  801b98:	c3                   	ret    
  801b99:	8d 76 00             	lea    0x0(%esi),%esi
  801b9c:	2b 04 24             	sub    (%esp),%eax
  801b9f:	19 fa                	sbb    %edi,%edx
  801ba1:	89 d1                	mov    %edx,%ecx
  801ba3:	89 c6                	mov    %eax,%esi
  801ba5:	e9 71 ff ff ff       	jmp    801b1b <__umoddi3+0xb3>
  801baa:	66 90                	xchg   %ax,%ax
  801bac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bb0:	72 ea                	jb     801b9c <__umoddi3+0x134>
  801bb2:	89 d9                	mov    %ebx,%ecx
  801bb4:	e9 62 ff ff ff       	jmp    801b1b <__umoddi3+0xb3>
