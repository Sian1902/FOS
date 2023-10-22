
obj/user/tst_syscalls_2_slave3:     file format elf32-i386


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
  800031:	e8 36 00 00 00       	call   80006c <libmain>
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
	//[2] Invalid Range (Cross USER_LIMIT)
	sys_free_user_mem(USER_LIMIT - PAGE_SIZE, PAGE_SIZE + 10);
  80003e:	83 ec 08             	sub    $0x8,%esp
  800041:	68 0a 10 00 00       	push   $0x100a
  800046:	68 00 f0 7f ef       	push   $0xef7ff000
  80004b:	e8 28 18 00 00       	call   801878 <sys_free_user_mem>
  800050:	83 c4 10             	add    $0x10,%esp
	inctst();
  800053:	e8 72 16 00 00       	call   8016ca <inctst>
	panic("tst system calls #2 failed: sys_free_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 20 1b 80 00       	push   $0x801b20
  800060:	6a 0a                	push   $0xa
  800062:	68 9e 1b 80 00       	push   $0x801b9e
  800067:	e8 45 01 00 00       	call   8001b1 <_panic>

0080006c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80006c:	55                   	push   %ebp
  80006d:	89 e5                	mov    %esp,%ebp
  80006f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800072:	e8 15 15 00 00       	call   80158c <sys_getenvindex>
  800077:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80007a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007d:	89 d0                	mov    %edx,%eax
  80007f:	01 c0                	add    %eax,%eax
  800081:	01 d0                	add    %edx,%eax
  800083:	01 c0                	add    %eax,%eax
  800085:	01 d0                	add    %edx,%eax
  800087:	c1 e0 02             	shl    $0x2,%eax
  80008a:	01 d0                	add    %edx,%eax
  80008c:	01 c0                	add    %eax,%eax
  80008e:	01 d0                	add    %edx,%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	01 d0                	add    %edx,%eax
  800095:	c1 e0 02             	shl    $0x2,%eax
  800098:	01 d0                	add    %edx,%eax
  80009a:	c1 e0 02             	shl    $0x2,%eax
  80009d:	01 d0                	add    %edx,%eax
  80009f:	c1 e0 05             	shl    $0x5,%eax
  8000a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a7:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b1:	8a 40 5c             	mov    0x5c(%eax),%al
  8000b4:	84 c0                	test   %al,%al
  8000b6:	74 0d                	je     8000c5 <libmain+0x59>
		binaryname = myEnv->prog_name;
  8000b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000bd:	83 c0 5c             	add    $0x5c,%eax
  8000c0:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000c9:	7e 0a                	jle    8000d5 <libmain+0x69>
		binaryname = argv[0];
  8000cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ce:	8b 00                	mov    (%eax),%eax
  8000d0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000d5:	83 ec 08             	sub    $0x8,%esp
  8000d8:	ff 75 0c             	pushl  0xc(%ebp)
  8000db:	ff 75 08             	pushl  0x8(%ebp)
  8000de:	e8 55 ff ff ff       	call   800038 <_main>
  8000e3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000e6:	e8 ae 12 00 00       	call   801399 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 d4 1b 80 00       	push   $0x801bd4
  8000f3:	e8 76 03 00 00       	call   80046e <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800100:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  800106:	a1 20 30 80 00       	mov    0x803020,%eax
  80010b:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  800111:	83 ec 04             	sub    $0x4,%esp
  800114:	52                   	push   %edx
  800115:	50                   	push   %eax
  800116:	68 fc 1b 80 00       	push   $0x801bfc
  80011b:	e8 4e 03 00 00       	call   80046e <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800123:	a1 20 30 80 00       	mov    0x803020,%eax
  800128:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  80012e:	a1 20 30 80 00       	mov    0x803020,%eax
  800133:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  800139:	a1 20 30 80 00       	mov    0x803020,%eax
  80013e:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  800144:	51                   	push   %ecx
  800145:	52                   	push   %edx
  800146:	50                   	push   %eax
  800147:	68 24 1c 80 00       	push   $0x801c24
  80014c:	e8 1d 03 00 00       	call   80046e <cprintf>
  800151:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800154:	a1 20 30 80 00       	mov    0x803020,%eax
  800159:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  80015f:	83 ec 08             	sub    $0x8,%esp
  800162:	50                   	push   %eax
  800163:	68 7c 1c 80 00       	push   $0x801c7c
  800168:	e8 01 03 00 00       	call   80046e <cprintf>
  80016d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	68 d4 1b 80 00       	push   $0x801bd4
  800178:	e8 f1 02 00 00       	call   80046e <cprintf>
  80017d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800180:	e8 2e 12 00 00       	call   8013b3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800185:	e8 19 00 00 00       	call   8001a3 <exit>
}
  80018a:	90                   	nop
  80018b:	c9                   	leave  
  80018c:	c3                   	ret    

0080018d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80018d:	55                   	push   %ebp
  80018e:	89 e5                	mov    %esp,%ebp
  800190:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	6a 00                	push   $0x0
  800198:	e8 bb 13 00 00       	call   801558 <sys_destroy_env>
  80019d:	83 c4 10             	add    $0x10,%esp
}
  8001a0:	90                   	nop
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <exit>:

void
exit(void)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001a9:	e8 10 14 00 00       	call   8015be <sys_exit_env>
}
  8001ae:	90                   	nop
  8001af:	c9                   	leave  
  8001b0:	c3                   	ret    

008001b1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001b7:	8d 45 10             	lea    0x10(%ebp),%eax
  8001ba:	83 c0 04             	add    $0x4,%eax
  8001bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001c0:	a1 18 31 80 00       	mov    0x803118,%eax
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	74 16                	je     8001df <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001c9:	a1 18 31 80 00       	mov    0x803118,%eax
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	50                   	push   %eax
  8001d2:	68 90 1c 80 00       	push   $0x801c90
  8001d7:	e8 92 02 00 00       	call   80046e <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001df:	a1 00 30 80 00       	mov    0x803000,%eax
  8001e4:	ff 75 0c             	pushl  0xc(%ebp)
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	50                   	push   %eax
  8001eb:	68 95 1c 80 00       	push   $0x801c95
  8001f0:	e8 79 02 00 00       	call   80046e <cprintf>
  8001f5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8001fb:	83 ec 08             	sub    $0x8,%esp
  8001fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800201:	50                   	push   %eax
  800202:	e8 fc 01 00 00       	call   800403 <vcprintf>
  800207:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	6a 00                	push   $0x0
  80020f:	68 b1 1c 80 00       	push   $0x801cb1
  800214:	e8 ea 01 00 00       	call   800403 <vcprintf>
  800219:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80021c:	e8 82 ff ff ff       	call   8001a3 <exit>

	// should not return here
	while (1) ;
  800221:	eb fe                	jmp    800221 <_panic+0x70>

00800223 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800229:	a1 20 30 80 00       	mov    0x803020,%eax
  80022e:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  800234:	8b 45 0c             	mov    0xc(%ebp),%eax
  800237:	39 c2                	cmp    %eax,%edx
  800239:	74 14                	je     80024f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80023b:	83 ec 04             	sub    $0x4,%esp
  80023e:	68 b4 1c 80 00       	push   $0x801cb4
  800243:	6a 26                	push   $0x26
  800245:	68 00 1d 80 00       	push   $0x801d00
  80024a:	e8 62 ff ff ff       	call   8001b1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80024f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800256:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80025d:	e9 c5 00 00 00       	jmp    800327 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800262:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026c:	8b 45 08             	mov    0x8(%ebp),%eax
  80026f:	01 d0                	add    %edx,%eax
  800271:	8b 00                	mov    (%eax),%eax
  800273:	85 c0                	test   %eax,%eax
  800275:	75 08                	jne    80027f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800277:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80027a:	e9 a5 00 00 00       	jmp    800324 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80027f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800286:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80028d:	eb 69                	jmp    8002f8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80028f:	a1 20 30 80 00       	mov    0x803020,%eax
  800294:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  80029a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80029d:	89 d0                	mov    %edx,%eax
  80029f:	01 c0                	add    %eax,%eax
  8002a1:	01 d0                	add    %edx,%eax
  8002a3:	c1 e0 03             	shl    $0x3,%eax
  8002a6:	01 c8                	add    %ecx,%eax
  8002a8:	8a 40 04             	mov    0x4(%eax),%al
  8002ab:	84 c0                	test   %al,%al
  8002ad:	75 46                	jne    8002f5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002af:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b4:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  8002ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002bd:	89 d0                	mov    %edx,%eax
  8002bf:	01 c0                	add    %eax,%eax
  8002c1:	01 d0                	add    %edx,%eax
  8002c3:	c1 e0 03             	shl    $0x3,%eax
  8002c6:	01 c8                	add    %ecx,%eax
  8002c8:	8b 00                	mov    (%eax),%eax
  8002ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002d5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002da:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 c8                	add    %ecx,%eax
  8002e6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002e8:	39 c2                	cmp    %eax,%edx
  8002ea:	75 09                	jne    8002f5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002ec:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002f3:	eb 15                	jmp    80030a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002f5:	ff 45 e8             	incl   -0x18(%ebp)
  8002f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002fd:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  800303:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800306:	39 c2                	cmp    %eax,%edx
  800308:	77 85                	ja     80028f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80030a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80030e:	75 14                	jne    800324 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 0c 1d 80 00       	push   $0x801d0c
  800318:	6a 3a                	push   $0x3a
  80031a:	68 00 1d 80 00       	push   $0x801d00
  80031f:	e8 8d fe ff ff       	call   8001b1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800324:	ff 45 f0             	incl   -0x10(%ebp)
  800327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80032d:	0f 8c 2f ff ff ff    	jl     800262 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800333:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80033a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800341:	eb 26                	jmp    800369 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800343:	a1 20 30 80 00       	mov    0x803020,%eax
  800348:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  80034e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800351:	89 d0                	mov    %edx,%eax
  800353:	01 c0                	add    %eax,%eax
  800355:	01 d0                	add    %edx,%eax
  800357:	c1 e0 03             	shl    $0x3,%eax
  80035a:	01 c8                	add    %ecx,%eax
  80035c:	8a 40 04             	mov    0x4(%eax),%al
  80035f:	3c 01                	cmp    $0x1,%al
  800361:	75 03                	jne    800366 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800363:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800366:	ff 45 e0             	incl   -0x20(%ebp)
  800369:	a1 20 30 80 00       	mov    0x803020,%eax
  80036e:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  800374:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800377:	39 c2                	cmp    %eax,%edx
  800379:	77 c8                	ja     800343 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80037b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800381:	74 14                	je     800397 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800383:	83 ec 04             	sub    $0x4,%esp
  800386:	68 60 1d 80 00       	push   $0x801d60
  80038b:	6a 44                	push   $0x44
  80038d:	68 00 1d 80 00       	push   $0x801d00
  800392:	e8 1a fe ff ff       	call   8001b1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800397:	90                   	nop
  800398:	c9                   	leave  
  800399:	c3                   	ret    

0080039a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a3:	8b 00                	mov    (%eax),%eax
  8003a5:	8d 48 01             	lea    0x1(%eax),%ecx
  8003a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ab:	89 0a                	mov    %ecx,(%edx)
  8003ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b0:	88 d1                	mov    %dl,%cl
  8003b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bc:	8b 00                	mov    (%eax),%eax
  8003be:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c3:	75 2c                	jne    8003f1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003c5:	a0 24 30 80 00       	mov    0x803024,%al
  8003ca:	0f b6 c0             	movzbl %al,%eax
  8003cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d0:	8b 12                	mov    (%edx),%edx
  8003d2:	89 d1                	mov    %edx,%ecx
  8003d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d7:	83 c2 08             	add    $0x8,%edx
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	50                   	push   %eax
  8003de:	51                   	push   %ecx
  8003df:	52                   	push   %edx
  8003e0:	e8 5b 0e 00 00       	call   801240 <sys_cputs>
  8003e5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f4:	8b 40 04             	mov    0x4(%eax),%eax
  8003f7:	8d 50 01             	lea    0x1(%eax),%edx
  8003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fd:	89 50 04             	mov    %edx,0x4(%eax)
}
  800400:	90                   	nop
  800401:	c9                   	leave  
  800402:	c3                   	ret    

00800403 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80040c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800413:	00 00 00 
	b.cnt = 0;
  800416:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80041d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800420:	ff 75 0c             	pushl  0xc(%ebp)
  800423:	ff 75 08             	pushl  0x8(%ebp)
  800426:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80042c:	50                   	push   %eax
  80042d:	68 9a 03 80 00       	push   $0x80039a
  800432:	e8 11 02 00 00       	call   800648 <vprintfmt>
  800437:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80043a:	a0 24 30 80 00       	mov    0x803024,%al
  80043f:	0f b6 c0             	movzbl %al,%eax
  800442:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	50                   	push   %eax
  80044c:	52                   	push   %edx
  80044d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800453:	83 c0 08             	add    $0x8,%eax
  800456:	50                   	push   %eax
  800457:	e8 e4 0d 00 00       	call   801240 <sys_cputs>
  80045c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80045f:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800466:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <cprintf>:

int cprintf(const char *fmt, ...) {
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800474:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80047b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	ff 75 f4             	pushl  -0xc(%ebp)
  80048a:	50                   	push   %eax
  80048b:	e8 73 ff ff ff       	call   800403 <vcprintf>
  800490:	83 c4 10             	add    $0x10,%esp
  800493:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800496:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800499:	c9                   	leave  
  80049a:	c3                   	ret    

0080049b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80049b:	55                   	push   %ebp
  80049c:	89 e5                	mov    %esp,%ebp
  80049e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8004a1:	e8 f3 0e 00 00       	call   801399 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004a6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b5:	50                   	push   %eax
  8004b6:	e8 48 ff ff ff       	call   800403 <vcprintf>
  8004bb:	83 c4 10             	add    $0x10,%esp
  8004be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004c1:	e8 ed 0e 00 00       	call   8013b3 <sys_enable_interrupt>
	return cnt;
  8004c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	53                   	push   %ebx
  8004cf:	83 ec 14             	sub    $0x14,%esp
  8004d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004de:	8b 45 18             	mov    0x18(%ebp),%eax
  8004e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e9:	77 55                	ja     800540 <printnum+0x75>
  8004eb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004ee:	72 05                	jb     8004f5 <printnum+0x2a>
  8004f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004f3:	77 4b                	ja     800540 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004f8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004fb:	8b 45 18             	mov    0x18(%ebp),%eax
  8004fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800503:	52                   	push   %edx
  800504:	50                   	push   %eax
  800505:	ff 75 f4             	pushl  -0xc(%ebp)
  800508:	ff 75 f0             	pushl  -0x10(%ebp)
  80050b:	e8 a4 13 00 00       	call   8018b4 <__udivdi3>
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	83 ec 04             	sub    $0x4,%esp
  800516:	ff 75 20             	pushl  0x20(%ebp)
  800519:	53                   	push   %ebx
  80051a:	ff 75 18             	pushl  0x18(%ebp)
  80051d:	52                   	push   %edx
  80051e:	50                   	push   %eax
  80051f:	ff 75 0c             	pushl  0xc(%ebp)
  800522:	ff 75 08             	pushl  0x8(%ebp)
  800525:	e8 a1 ff ff ff       	call   8004cb <printnum>
  80052a:	83 c4 20             	add    $0x20,%esp
  80052d:	eb 1a                	jmp    800549 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	ff 75 0c             	pushl  0xc(%ebp)
  800535:	ff 75 20             	pushl  0x20(%ebp)
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	ff d0                	call   *%eax
  80053d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800540:	ff 4d 1c             	decl   0x1c(%ebp)
  800543:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800547:	7f e6                	jg     80052f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800549:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80054c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800554:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800557:	53                   	push   %ebx
  800558:	51                   	push   %ecx
  800559:	52                   	push   %edx
  80055a:	50                   	push   %eax
  80055b:	e8 64 14 00 00       	call   8019c4 <__umoddi3>
  800560:	83 c4 10             	add    $0x10,%esp
  800563:	05 d4 1f 80 00       	add    $0x801fd4,%eax
  800568:	8a 00                	mov    (%eax),%al
  80056a:	0f be c0             	movsbl %al,%eax
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	ff 75 0c             	pushl  0xc(%ebp)
  800573:	50                   	push   %eax
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	ff d0                	call   *%eax
  800579:	83 c4 10             	add    $0x10,%esp
}
  80057c:	90                   	nop
  80057d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800585:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800589:	7e 1c                	jle    8005a7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80058b:	8b 45 08             	mov    0x8(%ebp),%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	8d 50 08             	lea    0x8(%eax),%edx
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	89 10                	mov    %edx,(%eax)
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	83 e8 08             	sub    $0x8,%eax
  8005a0:	8b 50 04             	mov    0x4(%eax),%edx
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	eb 40                	jmp    8005e7 <getuint+0x65>
	else if (lflag)
  8005a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005ab:	74 1e                	je     8005cb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	8d 50 04             	lea    0x4(%eax),%edx
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	89 10                	mov    %edx,(%eax)
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	83 e8 04             	sub    $0x4,%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c9:	eb 1c                	jmp    8005e7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ce:	8b 00                	mov    (%eax),%eax
  8005d0:	8d 50 04             	lea    0x4(%eax),%edx
  8005d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d6:	89 10                	mov    %edx,(%eax)
  8005d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	83 e8 04             	sub    $0x4,%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005e7:	5d                   	pop    %ebp
  8005e8:	c3                   	ret    

008005e9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005ec:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005f0:	7e 1c                	jle    80060e <getint+0x25>
		return va_arg(*ap, long long);
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	8d 50 08             	lea    0x8(%eax),%edx
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	89 10                	mov    %edx,(%eax)
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	83 e8 08             	sub    $0x8,%eax
  800607:	8b 50 04             	mov    0x4(%eax),%edx
  80060a:	8b 00                	mov    (%eax),%eax
  80060c:	eb 38                	jmp    800646 <getint+0x5d>
	else if (lflag)
  80060e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800612:	74 1a                	je     80062e <getint+0x45>
		return va_arg(*ap, long);
  800614:	8b 45 08             	mov    0x8(%ebp),%eax
  800617:	8b 00                	mov    (%eax),%eax
  800619:	8d 50 04             	lea    0x4(%eax),%edx
  80061c:	8b 45 08             	mov    0x8(%ebp),%eax
  80061f:	89 10                	mov    %edx,(%eax)
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	8b 00                	mov    (%eax),%eax
  800626:	83 e8 04             	sub    $0x4,%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	99                   	cltd   
  80062c:	eb 18                	jmp    800646 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80062e:	8b 45 08             	mov    0x8(%ebp),%eax
  800631:	8b 00                	mov    (%eax),%eax
  800633:	8d 50 04             	lea    0x4(%eax),%edx
  800636:	8b 45 08             	mov    0x8(%ebp),%eax
  800639:	89 10                	mov    %edx,(%eax)
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	8b 00                	mov    (%eax),%eax
  800640:	83 e8 04             	sub    $0x4,%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	99                   	cltd   
}
  800646:	5d                   	pop    %ebp
  800647:	c3                   	ret    

00800648 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800648:	55                   	push   %ebp
  800649:	89 e5                	mov    %esp,%ebp
  80064b:	56                   	push   %esi
  80064c:	53                   	push   %ebx
  80064d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800650:	eb 17                	jmp    800669 <vprintfmt+0x21>
			if (ch == '\0')
  800652:	85 db                	test   %ebx,%ebx
  800654:	0f 84 af 03 00 00    	je     800a09 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 0c             	pushl  0xc(%ebp)
  800660:	53                   	push   %ebx
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	ff d0                	call   *%eax
  800666:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800669:	8b 45 10             	mov    0x10(%ebp),%eax
  80066c:	8d 50 01             	lea    0x1(%eax),%edx
  80066f:	89 55 10             	mov    %edx,0x10(%ebp)
  800672:	8a 00                	mov    (%eax),%al
  800674:	0f b6 d8             	movzbl %al,%ebx
  800677:	83 fb 25             	cmp    $0x25,%ebx
  80067a:	75 d6                	jne    800652 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80067c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800680:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800687:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80068e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800695:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80069c:	8b 45 10             	mov    0x10(%ebp),%eax
  80069f:	8d 50 01             	lea    0x1(%eax),%edx
  8006a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8006a5:	8a 00                	mov    (%eax),%al
  8006a7:	0f b6 d8             	movzbl %al,%ebx
  8006aa:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006ad:	83 f8 55             	cmp    $0x55,%eax
  8006b0:	0f 87 2b 03 00 00    	ja     8009e1 <vprintfmt+0x399>
  8006b6:	8b 04 85 f8 1f 80 00 	mov    0x801ff8(,%eax,4),%eax
  8006bd:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006bf:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006c3:	eb d7                	jmp    80069c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006c5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006c9:	eb d1                	jmp    80069c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006cb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d5:	89 d0                	mov    %edx,%eax
  8006d7:	c1 e0 02             	shl    $0x2,%eax
  8006da:	01 d0                	add    %edx,%eax
  8006dc:	01 c0                	add    %eax,%eax
  8006de:	01 d8                	add    %ebx,%eax
  8006e0:	83 e8 30             	sub    $0x30,%eax
  8006e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e9:	8a 00                	mov    (%eax),%al
  8006eb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006ee:	83 fb 2f             	cmp    $0x2f,%ebx
  8006f1:	7e 3e                	jle    800731 <vprintfmt+0xe9>
  8006f3:	83 fb 39             	cmp    $0x39,%ebx
  8006f6:	7f 39                	jg     800731 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006fb:	eb d5                	jmp    8006d2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	83 c0 04             	add    $0x4,%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	83 e8 04             	sub    $0x4,%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800711:	eb 1f                	jmp    800732 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800713:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800717:	79 83                	jns    80069c <vprintfmt+0x54>
				width = 0;
  800719:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800720:	e9 77 ff ff ff       	jmp    80069c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800725:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80072c:	e9 6b ff ff ff       	jmp    80069c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800731:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800732:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800736:	0f 89 60 ff ff ff    	jns    80069c <vprintfmt+0x54>
				width = precision, precision = -1;
  80073c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80073f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800742:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800749:	e9 4e ff ff ff       	jmp    80069c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80074e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800751:	e9 46 ff ff ff       	jmp    80069c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	83 c0 04             	add    $0x4,%eax
  80075c:	89 45 14             	mov    %eax,0x14(%ebp)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	83 e8 04             	sub    $0x4,%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 0c             	pushl  0xc(%ebp)
  80076d:	50                   	push   %eax
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	ff d0                	call   *%eax
  800773:	83 c4 10             	add    $0x10,%esp
			break;
  800776:	e9 89 02 00 00       	jmp    800a04 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	83 c0 04             	add    $0x4,%eax
  800781:	89 45 14             	mov    %eax,0x14(%ebp)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	83 e8 04             	sub    $0x4,%eax
  80078a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80078c:	85 db                	test   %ebx,%ebx
  80078e:	79 02                	jns    800792 <vprintfmt+0x14a>
				err = -err;
  800790:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800792:	83 fb 64             	cmp    $0x64,%ebx
  800795:	7f 0b                	jg     8007a2 <vprintfmt+0x15a>
  800797:	8b 34 9d 40 1e 80 00 	mov    0x801e40(,%ebx,4),%esi
  80079e:	85 f6                	test   %esi,%esi
  8007a0:	75 19                	jne    8007bb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007a2:	53                   	push   %ebx
  8007a3:	68 e5 1f 80 00       	push   $0x801fe5
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	ff 75 08             	pushl  0x8(%ebp)
  8007ae:	e8 5e 02 00 00       	call   800a11 <printfmt>
  8007b3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007b6:	e9 49 02 00 00       	jmp    800a04 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007bb:	56                   	push   %esi
  8007bc:	68 ee 1f 80 00       	push   $0x801fee
  8007c1:	ff 75 0c             	pushl  0xc(%ebp)
  8007c4:	ff 75 08             	pushl  0x8(%ebp)
  8007c7:	e8 45 02 00 00       	call   800a11 <printfmt>
  8007cc:	83 c4 10             	add    $0x10,%esp
			break;
  8007cf:	e9 30 02 00 00       	jmp    800a04 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	83 c0 04             	add    $0x4,%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	83 e8 04             	sub    $0x4,%eax
  8007e3:	8b 30                	mov    (%eax),%esi
  8007e5:	85 f6                	test   %esi,%esi
  8007e7:	75 05                	jne    8007ee <vprintfmt+0x1a6>
				p = "(null)";
  8007e9:	be f1 1f 80 00       	mov    $0x801ff1,%esi
			if (width > 0 && padc != '-')
  8007ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f2:	7e 6d                	jle    800861 <vprintfmt+0x219>
  8007f4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007f8:	74 67                	je     800861 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	50                   	push   %eax
  800801:	56                   	push   %esi
  800802:	e8 0c 03 00 00       	call   800b13 <strnlen>
  800807:	83 c4 10             	add    $0x10,%esp
  80080a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80080d:	eb 16                	jmp    800825 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80080f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	ff 75 0c             	pushl  0xc(%ebp)
  800819:	50                   	push   %eax
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	ff d0                	call   *%eax
  80081f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800822:	ff 4d e4             	decl   -0x1c(%ebp)
  800825:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800829:	7f e4                	jg     80080f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80082b:	eb 34                	jmp    800861 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80082d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800831:	74 1c                	je     80084f <vprintfmt+0x207>
  800833:	83 fb 1f             	cmp    $0x1f,%ebx
  800836:	7e 05                	jle    80083d <vprintfmt+0x1f5>
  800838:	83 fb 7e             	cmp    $0x7e,%ebx
  80083b:	7e 12                	jle    80084f <vprintfmt+0x207>
					putch('?', putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	6a 3f                	push   $0x3f
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	ff d0                	call   *%eax
  80084a:	83 c4 10             	add    $0x10,%esp
  80084d:	eb 0f                	jmp    80085e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80084f:	83 ec 08             	sub    $0x8,%esp
  800852:	ff 75 0c             	pushl  0xc(%ebp)
  800855:	53                   	push   %ebx
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	ff d0                	call   *%eax
  80085b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80085e:	ff 4d e4             	decl   -0x1c(%ebp)
  800861:	89 f0                	mov    %esi,%eax
  800863:	8d 70 01             	lea    0x1(%eax),%esi
  800866:	8a 00                	mov    (%eax),%al
  800868:	0f be d8             	movsbl %al,%ebx
  80086b:	85 db                	test   %ebx,%ebx
  80086d:	74 24                	je     800893 <vprintfmt+0x24b>
  80086f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800873:	78 b8                	js     80082d <vprintfmt+0x1e5>
  800875:	ff 4d e0             	decl   -0x20(%ebp)
  800878:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80087c:	79 af                	jns    80082d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087e:	eb 13                	jmp    800893 <vprintfmt+0x24b>
				putch(' ', putdat);
  800880:	83 ec 08             	sub    $0x8,%esp
  800883:	ff 75 0c             	pushl  0xc(%ebp)
  800886:	6a 20                	push   $0x20
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	ff d0                	call   *%eax
  80088d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800890:	ff 4d e4             	decl   -0x1c(%ebp)
  800893:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800897:	7f e7                	jg     800880 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800899:	e9 66 01 00 00       	jmp    800a04 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a7:	50                   	push   %eax
  8008a8:	e8 3c fd ff ff       	call   8005e9 <getint>
  8008ad:	83 c4 10             	add    $0x10,%esp
  8008b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008bc:	85 d2                	test   %edx,%edx
  8008be:	79 23                	jns    8008e3 <vprintfmt+0x29b>
				putch('-', putdat);
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	ff 75 0c             	pushl  0xc(%ebp)
  8008c6:	6a 2d                	push   $0x2d
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d6:	f7 d8                	neg    %eax
  8008d8:	83 d2 00             	adc    $0x0,%edx
  8008db:	f7 da                	neg    %edx
  8008dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008e3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ea:	e9 bc 00 00 00       	jmp    8009ab <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 e8             	pushl  -0x18(%ebp)
  8008f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f8:	50                   	push   %eax
  8008f9:	e8 84 fc ff ff       	call   800582 <getuint>
  8008fe:	83 c4 10             	add    $0x10,%esp
  800901:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800904:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800907:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80090e:	e9 98 00 00 00       	jmp    8009ab <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	6a 58                	push   $0x58
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800923:	83 ec 08             	sub    $0x8,%esp
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	6a 58                	push   $0x58
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	ff d0                	call   *%eax
  800930:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800933:	83 ec 08             	sub    $0x8,%esp
  800936:	ff 75 0c             	pushl  0xc(%ebp)
  800939:	6a 58                	push   $0x58
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	ff d0                	call   *%eax
  800940:	83 c4 10             	add    $0x10,%esp
			break;
  800943:	e9 bc 00 00 00       	jmp    800a04 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	6a 30                	push   $0x30
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	ff 75 0c             	pushl  0xc(%ebp)
  80095e:	6a 78                	push   $0x78
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	ff d0                	call   *%eax
  800965:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800968:	8b 45 14             	mov    0x14(%ebp),%eax
  80096b:	83 c0 04             	add    $0x4,%eax
  80096e:	89 45 14             	mov    %eax,0x14(%ebp)
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	83 e8 04             	sub    $0x4,%eax
  800977:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800979:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800983:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80098a:	eb 1f                	jmp    8009ab <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	ff 75 e8             	pushl  -0x18(%ebp)
  800992:	8d 45 14             	lea    0x14(%ebp),%eax
  800995:	50                   	push   %eax
  800996:	e8 e7 fb ff ff       	call   800582 <getuint>
  80099b:	83 c4 10             	add    $0x10,%esp
  80099e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009a4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009ab:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b2:	83 ec 04             	sub    $0x4,%esp
  8009b5:	52                   	push   %edx
  8009b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009b9:	50                   	push   %eax
  8009ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8009bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8009c0:	ff 75 0c             	pushl  0xc(%ebp)
  8009c3:	ff 75 08             	pushl  0x8(%ebp)
  8009c6:	e8 00 fb ff ff       	call   8004cb <printnum>
  8009cb:	83 c4 20             	add    $0x20,%esp
			break;
  8009ce:	eb 34                	jmp    800a04 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	53                   	push   %ebx
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	ff d0                	call   *%eax
  8009dc:	83 c4 10             	add    $0x10,%esp
			break;
  8009df:	eb 23                	jmp    800a04 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009e1:	83 ec 08             	sub    $0x8,%esp
  8009e4:	ff 75 0c             	pushl  0xc(%ebp)
  8009e7:	6a 25                	push   $0x25
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	ff d0                	call   *%eax
  8009ee:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f1:	ff 4d 10             	decl   0x10(%ebp)
  8009f4:	eb 03                	jmp    8009f9 <vprintfmt+0x3b1>
  8009f6:	ff 4d 10             	decl   0x10(%ebp)
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	48                   	dec    %eax
  8009fd:	8a 00                	mov    (%eax),%al
  8009ff:	3c 25                	cmp    $0x25,%al
  800a01:	75 f3                	jne    8009f6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800a03:	90                   	nop
		}
	}
  800a04:	e9 47 fc ff ff       	jmp    800650 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a09:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a0d:	5b                   	pop    %ebx
  800a0e:	5e                   	pop    %esi
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a17:	8d 45 10             	lea    0x10(%ebp),%eax
  800a1a:	83 c0 04             	add    $0x4,%eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a20:	8b 45 10             	mov    0x10(%ebp),%eax
  800a23:	ff 75 f4             	pushl  -0xc(%ebp)
  800a26:	50                   	push   %eax
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	ff 75 08             	pushl  0x8(%ebp)
  800a2d:	e8 16 fc ff ff       	call   800648 <vprintfmt>
  800a32:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a35:	90                   	nop
  800a36:	c9                   	leave  
  800a37:	c3                   	ret    

00800a38 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	8b 40 08             	mov    0x8(%eax),%eax
  800a41:	8d 50 01             	lea    0x1(%eax),%edx
  800a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a47:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4d:	8b 10                	mov    (%eax),%edx
  800a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a52:	8b 40 04             	mov    0x4(%eax),%eax
  800a55:	39 c2                	cmp    %eax,%edx
  800a57:	73 12                	jae    800a6b <sprintputch+0x33>
		*b->buf++ = ch;
  800a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5c:	8b 00                	mov    (%eax),%eax
  800a5e:	8d 48 01             	lea    0x1(%eax),%ecx
  800a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a64:	89 0a                	mov    %ecx,(%edx)
  800a66:	8b 55 08             	mov    0x8(%ebp),%edx
  800a69:	88 10                	mov    %dl,(%eax)
}
  800a6b:	90                   	nop
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    

00800a6e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	01 d0                	add    %edx,%eax
  800a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a93:	74 06                	je     800a9b <vsnprintf+0x2d>
  800a95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a99:	7f 07                	jg     800aa2 <vsnprintf+0x34>
		return -E_INVAL;
  800a9b:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa0:	eb 20                	jmp    800ac2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa2:	ff 75 14             	pushl  0x14(%ebp)
  800aa5:	ff 75 10             	pushl  0x10(%ebp)
  800aa8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aab:	50                   	push   %eax
  800aac:	68 38 0a 80 00       	push   $0x800a38
  800ab1:	e8 92 fb ff ff       	call   800648 <vprintfmt>
  800ab6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ab9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800abc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aca:	8d 45 10             	lea    0x10(%ebp),%eax
  800acd:	83 c0 04             	add    $0x4,%eax
  800ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ad3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad9:	50                   	push   %eax
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	ff 75 08             	pushl  0x8(%ebp)
  800ae0:	e8 89 ff ff ff       	call   800a6e <vsnprintf>
  800ae5:	83 c4 10             	add    $0x10,%esp
  800ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800af6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800afd:	eb 06                	jmp    800b05 <strlen+0x15>
		n++;
  800aff:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b02:	ff 45 08             	incl   0x8(%ebp)
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8a 00                	mov    (%eax),%al
  800b0a:	84 c0                	test   %al,%al
  800b0c:	75 f1                	jne    800aff <strlen+0xf>
		n++;
	return n;
  800b0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b11:	c9                   	leave  
  800b12:	c3                   	ret    

00800b13 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b20:	eb 09                	jmp    800b2b <strnlen+0x18>
		n++;
  800b22:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b25:	ff 45 08             	incl   0x8(%ebp)
  800b28:	ff 4d 0c             	decl   0xc(%ebp)
  800b2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b2f:	74 09                	je     800b3a <strnlen+0x27>
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8a 00                	mov    (%eax),%al
  800b36:	84 c0                	test   %al,%al
  800b38:	75 e8                	jne    800b22 <strnlen+0xf>
		n++;
	return n;
  800b3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b3d:	c9                   	leave  
  800b3e:	c3                   	ret    

00800b3f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b4b:	90                   	nop
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8d 50 01             	lea    0x1(%eax),%edx
  800b52:	89 55 08             	mov    %edx,0x8(%ebp)
  800b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b58:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b5b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b5e:	8a 12                	mov    (%edx),%dl
  800b60:	88 10                	mov    %dl,(%eax)
  800b62:	8a 00                	mov    (%eax),%al
  800b64:	84 c0                	test   %al,%al
  800b66:	75 e4                	jne    800b4c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b68:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b6b:	c9                   	leave  
  800b6c:	c3                   	ret    

00800b6d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b80:	eb 1f                	jmp    800ba1 <strncpy+0x34>
		*dst++ = *src;
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8d 50 01             	lea    0x1(%eax),%edx
  800b88:	89 55 08             	mov    %edx,0x8(%ebp)
  800b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8e:	8a 12                	mov    (%edx),%dl
  800b90:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	8a 00                	mov    (%eax),%al
  800b97:	84 c0                	test   %al,%al
  800b99:	74 03                	je     800b9e <strncpy+0x31>
			src++;
  800b9b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b9e:	ff 45 fc             	incl   -0x4(%ebp)
  800ba1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ba7:	72 d9                	jb     800b82 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ba9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bbe:	74 30                	je     800bf0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bc0:	eb 16                	jmp    800bd8 <strlcpy+0x2a>
			*dst++ = *src++;
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8d 50 01             	lea    0x1(%eax),%edx
  800bc8:	89 55 08             	mov    %edx,0x8(%ebp)
  800bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bce:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bd4:	8a 12                	mov    (%edx),%dl
  800bd6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bd8:	ff 4d 10             	decl   0x10(%ebp)
  800bdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bdf:	74 09                	je     800bea <strlcpy+0x3c>
  800be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be4:	8a 00                	mov    (%eax),%al
  800be6:	84 c0                	test   %al,%al
  800be8:	75 d8                	jne    800bc2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf6:	29 c2                	sub    %eax,%edx
  800bf8:	89 d0                	mov    %edx,%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bff:	eb 06                	jmp    800c07 <strcmp+0xb>
		p++, q++;
  800c01:	ff 45 08             	incl   0x8(%ebp)
  800c04:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	74 0e                	je     800c1e <strcmp+0x22>
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	8a 10                	mov    (%eax),%dl
  800c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c18:	8a 00                	mov    (%eax),%al
  800c1a:	38 c2                	cmp    %al,%dl
  800c1c:	74 e3                	je     800c01 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	0f b6 d0             	movzbl %al,%edx
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	8a 00                	mov    (%eax),%al
  800c2b:	0f b6 c0             	movzbl %al,%eax
  800c2e:	29 c2                	sub    %eax,%edx
  800c30:	89 d0                	mov    %edx,%eax
}
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c37:	eb 09                	jmp    800c42 <strncmp+0xe>
		n--, p++, q++;
  800c39:	ff 4d 10             	decl   0x10(%ebp)
  800c3c:	ff 45 08             	incl   0x8(%ebp)
  800c3f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c46:	74 17                	je     800c5f <strncmp+0x2b>
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	84 c0                	test   %al,%al
  800c4f:	74 0e                	je     800c5f <strncmp+0x2b>
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	8a 10                	mov    (%eax),%dl
  800c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c59:	8a 00                	mov    (%eax),%al
  800c5b:	38 c2                	cmp    %al,%dl
  800c5d:	74 da                	je     800c39 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c63:	75 07                	jne    800c6c <strncmp+0x38>
		return 0;
  800c65:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6a:	eb 14                	jmp    800c80 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	0f b6 d0             	movzbl %al,%edx
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	8a 00                	mov    (%eax),%al
  800c79:	0f b6 c0             	movzbl %al,%eax
  800c7c:	29 c2                	sub    %eax,%edx
  800c7e:	89 d0                	mov    %edx,%eax
}
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	83 ec 04             	sub    $0x4,%esp
  800c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c8e:	eb 12                	jmp    800ca2 <strchr+0x20>
		if (*s == c)
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c98:	75 05                	jne    800c9f <strchr+0x1d>
			return (char *) s;
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	eb 11                	jmp    800cb0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c9f:	ff 45 08             	incl   0x8(%ebp)
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8a 00                	mov    (%eax),%al
  800ca7:	84 c0                	test   %al,%al
  800ca9:	75 e5                	jne    800c90 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb0:	c9                   	leave  
  800cb1:	c3                   	ret    

00800cb2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	83 ec 04             	sub    $0x4,%esp
  800cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cbe:	eb 0d                	jmp    800ccd <strfind+0x1b>
		if (*s == c)
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	8a 00                	mov    (%eax),%al
  800cc5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cc8:	74 0e                	je     800cd8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cca:	ff 45 08             	incl   0x8(%ebp)
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 00                	mov    (%eax),%al
  800cd2:	84 c0                	test   %al,%al
  800cd4:	75 ea                	jne    800cc0 <strfind+0xe>
  800cd6:	eb 01                	jmp    800cd9 <strfind+0x27>
		if (*s == c)
			break;
  800cd8:	90                   	nop
	return (char *) s;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cea:	8b 45 10             	mov    0x10(%ebp),%eax
  800ced:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cf0:	eb 0e                	jmp    800d00 <memset+0x22>
		*p++ = c;
  800cf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf5:	8d 50 01             	lea    0x1(%eax),%edx
  800cf8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfe:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d00:	ff 4d f8             	decl   -0x8(%ebp)
  800d03:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d07:	79 e9                	jns    800cf2 <memset+0x14>
		*p++ = c;

	return v;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d0c:	c9                   	leave  
  800d0d:	c3                   	ret    

00800d0e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d20:	eb 16                	jmp    800d38 <memcpy+0x2a>
		*d++ = *s++;
  800d22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d25:	8d 50 01             	lea    0x1(%eax),%edx
  800d28:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d31:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d34:	8a 12                	mov    (%edx),%dl
  800d36:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d38:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d41:	85 c0                	test   %eax,%eax
  800d43:	75 dd                	jne    800d22 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d48:	c9                   	leave  
  800d49:	c3                   	ret    

00800d4a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d62:	73 50                	jae    800db4 <memmove+0x6a>
  800d64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6a:	01 d0                	add    %edx,%eax
  800d6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d6f:	76 43                	jbe    800db4 <memmove+0x6a>
		s += n;
  800d71:	8b 45 10             	mov    0x10(%ebp),%eax
  800d74:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d77:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d7d:	eb 10                	jmp    800d8f <memmove+0x45>
			*--d = *--s;
  800d7f:	ff 4d f8             	decl   -0x8(%ebp)
  800d82:	ff 4d fc             	decl   -0x4(%ebp)
  800d85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d88:	8a 10                	mov    (%eax),%dl
  800d8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d95:	89 55 10             	mov    %edx,0x10(%ebp)
  800d98:	85 c0                	test   %eax,%eax
  800d9a:	75 e3                	jne    800d7f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d9c:	eb 23                	jmp    800dc1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da1:	8d 50 01             	lea    0x1(%eax),%edx
  800da4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800da7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800daa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dad:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800db0:	8a 12                	mov    (%edx),%dl
  800db2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800db4:	8b 45 10             	mov    0x10(%ebp),%eax
  800db7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dba:	89 55 10             	mov    %edx,0x10(%ebp)
  800dbd:	85 c0                	test   %eax,%eax
  800dbf:	75 dd                	jne    800d9e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dd8:	eb 2a                	jmp    800e04 <memcmp+0x3e>
		if (*s1 != *s2)
  800dda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddd:	8a 10                	mov    (%eax),%dl
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de2:	8a 00                	mov    (%eax),%al
  800de4:	38 c2                	cmp    %al,%dl
  800de6:	74 16                	je     800dfe <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800de8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	0f b6 d0             	movzbl %al,%edx
  800df0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	0f b6 c0             	movzbl %al,%eax
  800df8:	29 c2                	sub    %eax,%edx
  800dfa:	89 d0                	mov    %edx,%eax
  800dfc:	eb 18                	jmp    800e16 <memcmp+0x50>
		s1++, s2++;
  800dfe:	ff 45 fc             	incl   -0x4(%ebp)
  800e01:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e04:	8b 45 10             	mov    0x10(%ebp),%eax
  800e07:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e0a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	75 c9                	jne    800dda <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e16:	c9                   	leave  
  800e17:	c3                   	ret    

00800e18 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e21:	8b 45 10             	mov    0x10(%ebp),%eax
  800e24:	01 d0                	add    %edx,%eax
  800e26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e29:	eb 15                	jmp    800e40 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	0f b6 d0             	movzbl %al,%edx
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	0f b6 c0             	movzbl %al,%eax
  800e39:	39 c2                	cmp    %eax,%edx
  800e3b:	74 0d                	je     800e4a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e3d:	ff 45 08             	incl   0x8(%ebp)
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e46:	72 e3                	jb     800e2b <memfind+0x13>
  800e48:	eb 01                	jmp    800e4b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e4a:	90                   	nop
	return (void *) s;
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4e:	c9                   	leave  
  800e4f:	c3                   	ret    

00800e50 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e5d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e64:	eb 03                	jmp    800e69 <strtol+0x19>
		s++;
  800e66:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	3c 20                	cmp    $0x20,%al
  800e70:	74 f4                	je     800e66 <strtol+0x16>
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	3c 09                	cmp    $0x9,%al
  800e79:	74 eb                	je     800e66 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	3c 2b                	cmp    $0x2b,%al
  800e82:	75 05                	jne    800e89 <strtol+0x39>
		s++;
  800e84:	ff 45 08             	incl   0x8(%ebp)
  800e87:	eb 13                	jmp    800e9c <strtol+0x4c>
	else if (*s == '-')
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	3c 2d                	cmp    $0x2d,%al
  800e90:	75 0a                	jne    800e9c <strtol+0x4c>
		s++, neg = 1;
  800e92:	ff 45 08             	incl   0x8(%ebp)
  800e95:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea0:	74 06                	je     800ea8 <strtol+0x58>
  800ea2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ea6:	75 20                	jne    800ec8 <strtol+0x78>
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8a 00                	mov    (%eax),%al
  800ead:	3c 30                	cmp    $0x30,%al
  800eaf:	75 17                	jne    800ec8 <strtol+0x78>
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	40                   	inc    %eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	3c 78                	cmp    $0x78,%al
  800eb9:	75 0d                	jne    800ec8 <strtol+0x78>
		s += 2, base = 16;
  800ebb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ebf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ec6:	eb 28                	jmp    800ef0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ec8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecc:	75 15                	jne    800ee3 <strtol+0x93>
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	3c 30                	cmp    $0x30,%al
  800ed5:	75 0c                	jne    800ee3 <strtol+0x93>
		s++, base = 8;
  800ed7:	ff 45 08             	incl   0x8(%ebp)
  800eda:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ee1:	eb 0d                	jmp    800ef0 <strtol+0xa0>
	else if (base == 0)
  800ee3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee7:	75 07                	jne    800ef0 <strtol+0xa0>
		base = 10;
  800ee9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	3c 2f                	cmp    $0x2f,%al
  800ef7:	7e 19                	jle    800f12 <strtol+0xc2>
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	3c 39                	cmp    $0x39,%al
  800f00:	7f 10                	jg     800f12 <strtol+0xc2>
			dig = *s - '0';
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	0f be c0             	movsbl %al,%eax
  800f0a:	83 e8 30             	sub    $0x30,%eax
  800f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f10:	eb 42                	jmp    800f54 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	3c 60                	cmp    $0x60,%al
  800f19:	7e 19                	jle    800f34 <strtol+0xe4>
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3c 7a                	cmp    $0x7a,%al
  800f22:	7f 10                	jg     800f34 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	0f be c0             	movsbl %al,%eax
  800f2c:	83 e8 57             	sub    $0x57,%eax
  800f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f32:	eb 20                	jmp    800f54 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	3c 40                	cmp    $0x40,%al
  800f3b:	7e 39                	jle    800f76 <strtol+0x126>
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	3c 5a                	cmp    $0x5a,%al
  800f44:	7f 30                	jg     800f76 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f be c0             	movsbl %al,%eax
  800f4e:	83 e8 37             	sub    $0x37,%eax
  800f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f57:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f5a:	7d 19                	jge    800f75 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f5c:	ff 45 08             	incl   0x8(%ebp)
  800f5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f62:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f66:	89 c2                	mov    %eax,%edx
  800f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6b:	01 d0                	add    %edx,%eax
  800f6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f70:	e9 7b ff ff ff       	jmp    800ef0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f75:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f7a:	74 08                	je     800f84 <strtol+0x134>
		*endptr = (char *) s;
  800f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f82:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f84:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f88:	74 07                	je     800f91 <strtol+0x141>
  800f8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8d:	f7 d8                	neg    %eax
  800f8f:	eb 03                	jmp    800f94 <strtol+0x144>
  800f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f94:	c9                   	leave  
  800f95:	c3                   	ret    

00800f96 <ltostr>:

void
ltostr(long value, char *str)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fa3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800faa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fae:	79 13                	jns    800fc3 <ltostr+0x2d>
	{
		neg = 1;
  800fb0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fba:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fbd:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fc0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fcb:	99                   	cltd   
  800fcc:	f7 f9                	idiv   %ecx
  800fce:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd4:	8d 50 01             	lea    0x1(%eax),%edx
  800fd7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fda:	89 c2                	mov    %eax,%edx
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	01 d0                	add    %edx,%eax
  800fe1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fe4:	83 c2 30             	add    $0x30,%edx
  800fe7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fe9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fec:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff1:	f7 e9                	imul   %ecx
  800ff3:	c1 fa 02             	sar    $0x2,%edx
  800ff6:	89 c8                	mov    %ecx,%eax
  800ff8:	c1 f8 1f             	sar    $0x1f,%eax
  800ffb:	29 c2                	sub    %eax,%edx
  800ffd:	89 d0                	mov    %edx,%eax
  800fff:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801002:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801005:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80100a:	f7 e9                	imul   %ecx
  80100c:	c1 fa 02             	sar    $0x2,%edx
  80100f:	89 c8                	mov    %ecx,%eax
  801011:	c1 f8 1f             	sar    $0x1f,%eax
  801014:	29 c2                	sub    %eax,%edx
  801016:	89 d0                	mov    %edx,%eax
  801018:	c1 e0 02             	shl    $0x2,%eax
  80101b:	01 d0                	add    %edx,%eax
  80101d:	01 c0                	add    %eax,%eax
  80101f:	29 c1                	sub    %eax,%ecx
  801021:	89 ca                	mov    %ecx,%edx
  801023:	85 d2                	test   %edx,%edx
  801025:	75 9c                	jne    800fc3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801027:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80102e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801031:	48                   	dec    %eax
  801032:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801035:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801039:	74 3d                	je     801078 <ltostr+0xe2>
		start = 1 ;
  80103b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801042:	eb 34                	jmp    801078 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104a:	01 d0                	add    %edx,%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801051:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	01 c2                	add    %eax,%edx
  801059:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80105c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105f:	01 c8                	add    %ecx,%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106b:	01 c2                	add    %eax,%edx
  80106d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801070:	88 02                	mov    %al,(%edx)
		start++ ;
  801072:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801075:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80107b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80107e:	7c c4                	jl     801044 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801080:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801083:	8b 45 0c             	mov    0xc(%ebp),%eax
  801086:	01 d0                	add    %edx,%eax
  801088:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80108b:	90                   	nop
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801094:	ff 75 08             	pushl  0x8(%ebp)
  801097:	e8 54 fa ff ff       	call   800af0 <strlen>
  80109c:	83 c4 04             	add    $0x4,%esp
  80109f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	e8 46 fa ff ff       	call   800af0 <strlen>
  8010aa:	83 c4 04             	add    $0x4,%esp
  8010ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010be:	eb 17                	jmp    8010d7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c6:	01 c2                	add    %eax,%edx
  8010c8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	01 c8                	add    %ecx,%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010d4:	ff 45 fc             	incl   -0x4(%ebp)
  8010d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010da:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010dd:	7c e1                	jl     8010c0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010e6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010ed:	eb 1f                	jmp    80110e <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f2:	8d 50 01             	lea    0x1(%eax),%edx
  8010f5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010f8:	89 c2                	mov    %eax,%edx
  8010fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fd:	01 c2                	add    %eax,%edx
  8010ff:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	01 c8                	add    %ecx,%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80110b:	ff 45 f8             	incl   -0x8(%ebp)
  80110e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801111:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801114:	7c d9                	jl     8010ef <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801116:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801119:	8b 45 10             	mov    0x10(%ebp),%eax
  80111c:	01 d0                	add    %edx,%eax
  80111e:	c6 00 00             	movb   $0x0,(%eax)
}
  801121:	90                   	nop
  801122:	c9                   	leave  
  801123:	c3                   	ret    

00801124 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801127:	8b 45 14             	mov    0x14(%ebp),%eax
  80112a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801130:	8b 45 14             	mov    0x14(%ebp),%eax
  801133:	8b 00                	mov    (%eax),%eax
  801135:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	01 d0                	add    %edx,%eax
  801141:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801147:	eb 0c                	jmp    801155 <strsplit+0x31>
			*string++ = 0;
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8d 50 01             	lea    0x1(%eax),%edx
  80114f:	89 55 08             	mov    %edx,0x8(%ebp)
  801152:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	84 c0                	test   %al,%al
  80115c:	74 18                	je     801176 <strsplit+0x52>
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be c0             	movsbl %al,%eax
  801166:	50                   	push   %eax
  801167:	ff 75 0c             	pushl  0xc(%ebp)
  80116a:	e8 13 fb ff ff       	call   800c82 <strchr>
  80116f:	83 c4 08             	add    $0x8,%esp
  801172:	85 c0                	test   %eax,%eax
  801174:	75 d3                	jne    801149 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	84 c0                	test   %al,%al
  80117d:	74 5a                	je     8011d9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80117f:	8b 45 14             	mov    0x14(%ebp),%eax
  801182:	8b 00                	mov    (%eax),%eax
  801184:	83 f8 0f             	cmp    $0xf,%eax
  801187:	75 07                	jne    801190 <strsplit+0x6c>
		{
			return 0;
  801189:	b8 00 00 00 00       	mov    $0x0,%eax
  80118e:	eb 66                	jmp    8011f6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801190:	8b 45 14             	mov    0x14(%ebp),%eax
  801193:	8b 00                	mov    (%eax),%eax
  801195:	8d 48 01             	lea    0x1(%eax),%ecx
  801198:	8b 55 14             	mov    0x14(%ebp),%edx
  80119b:	89 0a                	mov    %ecx,(%edx)
  80119d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a7:	01 c2                	add    %eax,%edx
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011ae:	eb 03                	jmp    8011b3 <strsplit+0x8f>
			string++;
  8011b0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	84 c0                	test   %al,%al
  8011ba:	74 8b                	je     801147 <strsplit+0x23>
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	0f be c0             	movsbl %al,%eax
  8011c4:	50                   	push   %eax
  8011c5:	ff 75 0c             	pushl  0xc(%ebp)
  8011c8:	e8 b5 fa ff ff       	call   800c82 <strchr>
  8011cd:	83 c4 08             	add    $0x8,%esp
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	74 dc                	je     8011b0 <strsplit+0x8c>
			string++;
	}
  8011d4:	e9 6e ff ff ff       	jmp    801147 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011d9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011da:	8b 45 14             	mov    0x14(%ebp),%eax
  8011dd:	8b 00                	mov    (%eax),%eax
  8011df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e9:	01 d0                	add    %edx,%eax
  8011eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011f1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011f6:	c9                   	leave  
  8011f7:	c3                   	ret    

008011f8 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	panic("process_command is not implemented yet");
  8011fe:	83 ec 04             	sub    $0x4,%esp
  801201:	68 50 21 80 00       	push   $0x802150
  801206:	68 3e 01 00 00       	push   $0x13e
  80120b:	68 77 21 80 00       	push   $0x802177
  801210:	e8 9c ef ff ff       	call   8001b1 <_panic>

00801215 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	57                   	push   %edi
  801219:	56                   	push   %esi
  80121a:	53                   	push   %ebx
  80121b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8b 55 0c             	mov    0xc(%ebp),%edx
  801224:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801227:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80122a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80122d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801230:	cd 30                	int    $0x30
  801232:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801235:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	5b                   	pop    %ebx
  80123c:	5e                   	pop    %esi
  80123d:	5f                   	pop    %edi
  80123e:	5d                   	pop    %ebp
  80123f:	c3                   	ret    

00801240 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	83 ec 04             	sub    $0x4,%esp
  801246:	8b 45 10             	mov    0x10(%ebp),%eax
  801249:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80124c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	6a 00                	push   $0x0
  801255:	6a 00                	push   $0x0
  801257:	52                   	push   %edx
  801258:	ff 75 0c             	pushl  0xc(%ebp)
  80125b:	50                   	push   %eax
  80125c:	6a 00                	push   $0x0
  80125e:	e8 b2 ff ff ff       	call   801215 <syscall>
  801263:	83 c4 18             	add    $0x18,%esp
}
  801266:	90                   	nop
  801267:	c9                   	leave  
  801268:	c3                   	ret    

00801269 <sys_cgetc>:

int
sys_cgetc(void)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80126c:	6a 00                	push   $0x0
  80126e:	6a 00                	push   $0x0
  801270:	6a 00                	push   $0x0
  801272:	6a 00                	push   $0x0
  801274:	6a 00                	push   $0x0
  801276:	6a 01                	push   $0x1
  801278:	e8 98 ff ff ff       	call   801215 <syscall>
  80127d:	83 c4 18             	add    $0x18,%esp
}
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801285:	8b 55 0c             	mov    0xc(%ebp),%edx
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	52                   	push   %edx
  801292:	50                   	push   %eax
  801293:	6a 05                	push   $0x5
  801295:	e8 7b ff ff ff       	call   801215 <syscall>
  80129a:	83 c4 18             	add    $0x18,%esp
}
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	56                   	push   %esi
  8012a3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012a4:	8b 75 18             	mov    0x18(%ebp),%esi
  8012a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	56                   	push   %esi
  8012b4:	53                   	push   %ebx
  8012b5:	51                   	push   %ecx
  8012b6:	52                   	push   %edx
  8012b7:	50                   	push   %eax
  8012b8:	6a 06                	push   $0x6
  8012ba:	e8 56 ff ff ff       	call   801215 <syscall>
  8012bf:	83 c4 18             	add    $0x18,%esp
}
  8012c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012c5:	5b                   	pop    %ebx
  8012c6:	5e                   	pop    %esi
  8012c7:	5d                   	pop    %ebp
  8012c8:	c3                   	ret    

008012c9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	52                   	push   %edx
  8012d9:	50                   	push   %eax
  8012da:	6a 07                	push   $0x7
  8012dc:	e8 34 ff ff ff       	call   801215 <syscall>
  8012e1:	83 c4 18             	add    $0x18,%esp
}
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	ff 75 0c             	pushl  0xc(%ebp)
  8012f2:	ff 75 08             	pushl  0x8(%ebp)
  8012f5:	6a 08                	push   $0x8
  8012f7:	e8 19 ff ff ff       	call   801215 <syscall>
  8012fc:	83 c4 18             	add    $0x18,%esp
}
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 09                	push   $0x9
  801310:	e8 00 ff ff ff       	call   801215 <syscall>
  801315:	83 c4 18             	add    $0x18,%esp
}
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 0a                	push   $0xa
  801329:	e8 e7 fe ff ff       	call   801215 <syscall>
  80132e:	83 c4 18             	add    $0x18,%esp
}
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 0b                	push   $0xb
  801342:	e8 ce fe ff ff       	call   801215 <syscall>
  801347:	83 c4 18             	add    $0x18,%esp
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 0c                	push   $0xc
  80135b:	e8 b5 fe ff ff       	call   801215 <syscall>
  801360:	83 c4 18             	add    $0x18,%esp
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	ff 75 08             	pushl  0x8(%ebp)
  801373:	6a 0d                	push   $0xd
  801375:	e8 9b fe ff ff       	call   801215 <syscall>
  80137a:	83 c4 18             	add    $0x18,%esp
}
  80137d:	c9                   	leave  
  80137e:	c3                   	ret    

0080137f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 0e                	push   $0xe
  80138e:	e8 82 fe ff ff       	call   801215 <syscall>
  801393:	83 c4 18             	add    $0x18,%esp
}
  801396:	90                   	nop
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 11                	push   $0x11
  8013a8:	e8 68 fe ff ff       	call   801215 <syscall>
  8013ad:	83 c4 18             	add    $0x18,%esp
}
  8013b0:	90                   	nop
  8013b1:	c9                   	leave  
  8013b2:	c3                   	ret    

008013b3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 12                	push   $0x12
  8013c2:	e8 4e fe ff ff       	call   801215 <syscall>
  8013c7:	83 c4 18             	add    $0x18,%esp
}
  8013ca:	90                   	nop
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <sys_cputc>:


void
sys_cputc(const char c)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	83 ec 04             	sub    $0x4,%esp
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013d9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	50                   	push   %eax
  8013e6:	6a 13                	push   $0x13
  8013e8:	e8 28 fe ff ff       	call   801215 <syscall>
  8013ed:	83 c4 18             	add    $0x18,%esp
}
  8013f0:	90                   	nop
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 14                	push   $0x14
  801402:	e8 0e fe ff ff       	call   801215 <syscall>
  801407:	83 c4 18             	add    $0x18,%esp
}
  80140a:	90                   	nop
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	ff 75 0c             	pushl  0xc(%ebp)
  80141c:	50                   	push   %eax
  80141d:	6a 15                	push   $0x15
  80141f:	e8 f1 fd ff ff       	call   801215 <syscall>
  801424:	83 c4 18             	add    $0x18,%esp
}
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80142c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	52                   	push   %edx
  801439:	50                   	push   %eax
  80143a:	6a 18                	push   $0x18
  80143c:	e8 d4 fd ff ff       	call   801215 <syscall>
  801441:	83 c4 18             	add    $0x18,%esp
}
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801449:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	52                   	push   %edx
  801456:	50                   	push   %eax
  801457:	6a 16                	push   $0x16
  801459:	e8 b7 fd ff ff       	call   801215 <syscall>
  80145e:	83 c4 18             	add    $0x18,%esp
}
  801461:	90                   	nop
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801467:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	52                   	push   %edx
  801474:	50                   	push   %eax
  801475:	6a 17                	push   $0x17
  801477:	e8 99 fd ff ff       	call   801215 <syscall>
  80147c:	83 c4 18             	add    $0x18,%esp
}
  80147f:	90                   	nop
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	83 ec 04             	sub    $0x4,%esp
  801488:	8b 45 10             	mov    0x10(%ebp),%eax
  80148b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80148e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801491:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	6a 00                	push   $0x0
  80149a:	51                   	push   %ecx
  80149b:	52                   	push   %edx
  80149c:	ff 75 0c             	pushl  0xc(%ebp)
  80149f:	50                   	push   %eax
  8014a0:	6a 19                	push   $0x19
  8014a2:	e8 6e fd ff ff       	call   801215 <syscall>
  8014a7:	83 c4 18             	add    $0x18,%esp
}
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	52                   	push   %edx
  8014bc:	50                   	push   %eax
  8014bd:	6a 1a                	push   $0x1a
  8014bf:	e8 51 fd ff ff       	call   801215 <syscall>
  8014c4:	83 c4 18             	add    $0x18,%esp
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	51                   	push   %ecx
  8014da:	52                   	push   %edx
  8014db:	50                   	push   %eax
  8014dc:	6a 1b                	push   $0x1b
  8014de:	e8 32 fd ff ff       	call   801215 <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	52                   	push   %edx
  8014f8:	50                   	push   %eax
  8014f9:	6a 1c                	push   $0x1c
  8014fb:	e8 15 fd ff ff       	call   801215 <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 1d                	push   $0x1d
  801514:	e8 fc fc ff ff       	call   801215 <syscall>
  801519:	83 c4 18             	add    $0x18,%esp
}
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	6a 00                	push   $0x0
  801526:	ff 75 14             	pushl  0x14(%ebp)
  801529:	ff 75 10             	pushl  0x10(%ebp)
  80152c:	ff 75 0c             	pushl  0xc(%ebp)
  80152f:	50                   	push   %eax
  801530:	6a 1e                	push   $0x1e
  801532:	e8 de fc ff ff       	call   801215 <syscall>
  801537:	83 c4 18             	add    $0x18,%esp
}
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	50                   	push   %eax
  80154b:	6a 1f                	push   $0x1f
  80154d:	e8 c3 fc ff ff       	call   801215 <syscall>
  801552:	83 c4 18             	add    $0x18,%esp
}
  801555:	90                   	nop
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	50                   	push   %eax
  801567:	6a 20                	push   $0x20
  801569:	e8 a7 fc ff ff       	call   801215 <syscall>
  80156e:	83 c4 18             	add    $0x18,%esp
}
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 02                	push   $0x2
  801582:	e8 8e fc ff ff       	call   801215 <syscall>
  801587:	83 c4 18             	add    $0x18,%esp
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 03                	push   $0x3
  80159b:	e8 75 fc ff ff       	call   801215 <syscall>
  8015a0:	83 c4 18             	add    $0x18,%esp
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 04                	push   $0x4
  8015b4:	e8 5c fc ff ff       	call   801215 <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_exit_env>:


void sys_exit_env(void)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 21                	push   $0x21
  8015cd:	e8 43 fc ff ff       	call   801215 <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	90                   	nop
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015de:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015e1:	8d 50 04             	lea    0x4(%eax),%edx
  8015e4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	52                   	push   %edx
  8015ee:	50                   	push   %eax
  8015ef:	6a 22                	push   $0x22
  8015f1:	e8 1f fc ff ff       	call   801215 <syscall>
  8015f6:	83 c4 18             	add    $0x18,%esp
	return result;
  8015f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801602:	89 01                	mov    %eax,(%ecx)
  801604:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	c9                   	leave  
  80160b:	c2 04 00             	ret    $0x4

0080160e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	ff 75 10             	pushl  0x10(%ebp)
  801618:	ff 75 0c             	pushl  0xc(%ebp)
  80161b:	ff 75 08             	pushl  0x8(%ebp)
  80161e:	6a 10                	push   $0x10
  801620:	e8 f0 fb ff ff       	call   801215 <syscall>
  801625:	83 c4 18             	add    $0x18,%esp
	return ;
  801628:	90                   	nop
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_rcr2>:
uint32 sys_rcr2()
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 23                	push   $0x23
  80163a:	e8 d6 fb ff ff       	call   801215 <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	83 ec 04             	sub    $0x4,%esp
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801650:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	50                   	push   %eax
  80165d:	6a 24                	push   $0x24
  80165f:	e8 b1 fb ff ff       	call   801215 <syscall>
  801664:	83 c4 18             	add    $0x18,%esp
	return ;
  801667:	90                   	nop
}
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <rsttst>:
void rsttst()
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 26                	push   $0x26
  801679:	e8 97 fb ff ff       	call   801215 <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
	return ;
  801681:	90                   	nop
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 04             	sub    $0x4,%esp
  80168a:	8b 45 14             	mov    0x14(%ebp),%eax
  80168d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801690:	8b 55 18             	mov    0x18(%ebp),%edx
  801693:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801697:	52                   	push   %edx
  801698:	50                   	push   %eax
  801699:	ff 75 10             	pushl  0x10(%ebp)
  80169c:	ff 75 0c             	pushl  0xc(%ebp)
  80169f:	ff 75 08             	pushl  0x8(%ebp)
  8016a2:	6a 25                	push   $0x25
  8016a4:	e8 6c fb ff ff       	call   801215 <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ac:	90                   	nop
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <chktst>:
void chktst(uint32 n)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	ff 75 08             	pushl  0x8(%ebp)
  8016bd:	6a 27                	push   $0x27
  8016bf:	e8 51 fb ff ff       	call   801215 <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c7:	90                   	nop
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <inctst>:

void inctst()
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 28                	push   $0x28
  8016d9:	e8 37 fb ff ff       	call   801215 <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e1:	90                   	nop
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <gettst>:
uint32 gettst()
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 29                	push   $0x29
  8016f3:	e8 1d fb ff ff       	call   801215 <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 2a                	push   $0x2a
  80170f:	e8 01 fb ff ff       	call   801215 <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
  801717:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80171a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80171e:	75 07                	jne    801727 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801720:	b8 01 00 00 00       	mov    $0x1,%eax
  801725:	eb 05                	jmp    80172c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801727:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 2a                	push   $0x2a
  801740:	e8 d0 fa ff ff       	call   801215 <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
  801748:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80174b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80174f:	75 07                	jne    801758 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801751:	b8 01 00 00 00       	mov    $0x1,%eax
  801756:	eb 05                	jmp    80175d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801758:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 2a                	push   $0x2a
  801771:	e8 9f fa ff ff       	call   801215 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
  801779:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80177c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801780:	75 07                	jne    801789 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801782:	b8 01 00 00 00       	mov    $0x1,%eax
  801787:	eb 05                	jmp    80178e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801789:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 2a                	push   $0x2a
  8017a2:	e8 6e fa ff ff       	call   801215 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
  8017aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017ad:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017b1:	75 07                	jne    8017ba <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b8:	eb 05                	jmp    8017bf <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	ff 75 08             	pushl  0x8(%ebp)
  8017cf:	6a 2b                	push   $0x2b
  8017d1:	e8 3f fa ff ff       	call   801215 <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d9:	90                   	nop
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	6a 00                	push   $0x0
  8017ee:	53                   	push   %ebx
  8017ef:	51                   	push   %ecx
  8017f0:	52                   	push   %edx
  8017f1:	50                   	push   %eax
  8017f2:	6a 2c                	push   $0x2c
  8017f4:	e8 1c fa ff ff       	call   801215 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801804:	8b 55 0c             	mov    0xc(%ebp),%edx
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	52                   	push   %edx
  801811:	50                   	push   %eax
  801812:	6a 2d                	push   $0x2d
  801814:	e8 fc f9 ff ff       	call   801215 <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801821:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801824:	8b 55 0c             	mov    0xc(%ebp),%edx
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	6a 00                	push   $0x0
  80182c:	51                   	push   %ecx
  80182d:	ff 75 10             	pushl  0x10(%ebp)
  801830:	52                   	push   %edx
  801831:	50                   	push   %eax
  801832:	6a 2e                	push   $0x2e
  801834:	e8 dc f9 ff ff       	call   801215 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	ff 75 10             	pushl  0x10(%ebp)
  801848:	ff 75 0c             	pushl  0xc(%ebp)
  80184b:	ff 75 08             	pushl  0x8(%ebp)
  80184e:	6a 0f                	push   $0xf
  801850:	e8 c0 f9 ff ff       	call   801215 <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
	return ;
  801858:	90                   	nop
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801861:	83 ec 04             	sub    $0x4,%esp
  801864:	68 84 21 80 00       	push   $0x802184
  801869:	68 54 01 00 00       	push   $0x154
  80186e:	68 98 21 80 00       	push   $0x802198
  801873:	e8 39 e9 ff ff       	call   8001b1 <_panic>

00801878 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80187e:	83 ec 04             	sub    $0x4,%esp
  801881:	68 84 21 80 00       	push   $0x802184
  801886:	68 5b 01 00 00       	push   $0x15b
  80188b:	68 98 21 80 00       	push   $0x802198
  801890:	e8 1c e9 ff ff       	call   8001b1 <_panic>

00801895 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80189b:	83 ec 04             	sub    $0x4,%esp
  80189e:	68 84 21 80 00       	push   $0x802184
  8018a3:	68 61 01 00 00       	push   $0x161
  8018a8:	68 98 21 80 00       	push   $0x802198
  8018ad:	e8 ff e8 ff ff       	call   8001b1 <_panic>
  8018b2:	66 90                	xchg   %ax,%ax

008018b4 <__udivdi3>:
  8018b4:	55                   	push   %ebp
  8018b5:	57                   	push   %edi
  8018b6:	56                   	push   %esi
  8018b7:	53                   	push   %ebx
  8018b8:	83 ec 1c             	sub    $0x1c,%esp
  8018bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018cb:	89 ca                	mov    %ecx,%edx
  8018cd:	89 f8                	mov    %edi,%eax
  8018cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018d3:	85 f6                	test   %esi,%esi
  8018d5:	75 2d                	jne    801904 <__udivdi3+0x50>
  8018d7:	39 cf                	cmp    %ecx,%edi
  8018d9:	77 65                	ja     801940 <__udivdi3+0x8c>
  8018db:	89 fd                	mov    %edi,%ebp
  8018dd:	85 ff                	test   %edi,%edi
  8018df:	75 0b                	jne    8018ec <__udivdi3+0x38>
  8018e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8018e6:	31 d2                	xor    %edx,%edx
  8018e8:	f7 f7                	div    %edi
  8018ea:	89 c5                	mov    %eax,%ebp
  8018ec:	31 d2                	xor    %edx,%edx
  8018ee:	89 c8                	mov    %ecx,%eax
  8018f0:	f7 f5                	div    %ebp
  8018f2:	89 c1                	mov    %eax,%ecx
  8018f4:	89 d8                	mov    %ebx,%eax
  8018f6:	f7 f5                	div    %ebp
  8018f8:	89 cf                	mov    %ecx,%edi
  8018fa:	89 fa                	mov    %edi,%edx
  8018fc:	83 c4 1c             	add    $0x1c,%esp
  8018ff:	5b                   	pop    %ebx
  801900:	5e                   	pop    %esi
  801901:	5f                   	pop    %edi
  801902:	5d                   	pop    %ebp
  801903:	c3                   	ret    
  801904:	39 ce                	cmp    %ecx,%esi
  801906:	77 28                	ja     801930 <__udivdi3+0x7c>
  801908:	0f bd fe             	bsr    %esi,%edi
  80190b:	83 f7 1f             	xor    $0x1f,%edi
  80190e:	75 40                	jne    801950 <__udivdi3+0x9c>
  801910:	39 ce                	cmp    %ecx,%esi
  801912:	72 0a                	jb     80191e <__udivdi3+0x6a>
  801914:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801918:	0f 87 9e 00 00 00    	ja     8019bc <__udivdi3+0x108>
  80191e:	b8 01 00 00 00       	mov    $0x1,%eax
  801923:	89 fa                	mov    %edi,%edx
  801925:	83 c4 1c             	add    $0x1c,%esp
  801928:	5b                   	pop    %ebx
  801929:	5e                   	pop    %esi
  80192a:	5f                   	pop    %edi
  80192b:	5d                   	pop    %ebp
  80192c:	c3                   	ret    
  80192d:	8d 76 00             	lea    0x0(%esi),%esi
  801930:	31 ff                	xor    %edi,%edi
  801932:	31 c0                	xor    %eax,%eax
  801934:	89 fa                	mov    %edi,%edx
  801936:	83 c4 1c             	add    $0x1c,%esp
  801939:	5b                   	pop    %ebx
  80193a:	5e                   	pop    %esi
  80193b:	5f                   	pop    %edi
  80193c:	5d                   	pop    %ebp
  80193d:	c3                   	ret    
  80193e:	66 90                	xchg   %ax,%ax
  801940:	89 d8                	mov    %ebx,%eax
  801942:	f7 f7                	div    %edi
  801944:	31 ff                	xor    %edi,%edi
  801946:	89 fa                	mov    %edi,%edx
  801948:	83 c4 1c             	add    $0x1c,%esp
  80194b:	5b                   	pop    %ebx
  80194c:	5e                   	pop    %esi
  80194d:	5f                   	pop    %edi
  80194e:	5d                   	pop    %ebp
  80194f:	c3                   	ret    
  801950:	bd 20 00 00 00       	mov    $0x20,%ebp
  801955:	89 eb                	mov    %ebp,%ebx
  801957:	29 fb                	sub    %edi,%ebx
  801959:	89 f9                	mov    %edi,%ecx
  80195b:	d3 e6                	shl    %cl,%esi
  80195d:	89 c5                	mov    %eax,%ebp
  80195f:	88 d9                	mov    %bl,%cl
  801961:	d3 ed                	shr    %cl,%ebp
  801963:	89 e9                	mov    %ebp,%ecx
  801965:	09 f1                	or     %esi,%ecx
  801967:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80196b:	89 f9                	mov    %edi,%ecx
  80196d:	d3 e0                	shl    %cl,%eax
  80196f:	89 c5                	mov    %eax,%ebp
  801971:	89 d6                	mov    %edx,%esi
  801973:	88 d9                	mov    %bl,%cl
  801975:	d3 ee                	shr    %cl,%esi
  801977:	89 f9                	mov    %edi,%ecx
  801979:	d3 e2                	shl    %cl,%edx
  80197b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80197f:	88 d9                	mov    %bl,%cl
  801981:	d3 e8                	shr    %cl,%eax
  801983:	09 c2                	or     %eax,%edx
  801985:	89 d0                	mov    %edx,%eax
  801987:	89 f2                	mov    %esi,%edx
  801989:	f7 74 24 0c          	divl   0xc(%esp)
  80198d:	89 d6                	mov    %edx,%esi
  80198f:	89 c3                	mov    %eax,%ebx
  801991:	f7 e5                	mul    %ebp
  801993:	39 d6                	cmp    %edx,%esi
  801995:	72 19                	jb     8019b0 <__udivdi3+0xfc>
  801997:	74 0b                	je     8019a4 <__udivdi3+0xf0>
  801999:	89 d8                	mov    %ebx,%eax
  80199b:	31 ff                	xor    %edi,%edi
  80199d:	e9 58 ff ff ff       	jmp    8018fa <__udivdi3+0x46>
  8019a2:	66 90                	xchg   %ax,%ax
  8019a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019a8:	89 f9                	mov    %edi,%ecx
  8019aa:	d3 e2                	shl    %cl,%edx
  8019ac:	39 c2                	cmp    %eax,%edx
  8019ae:	73 e9                	jae    801999 <__udivdi3+0xe5>
  8019b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019b3:	31 ff                	xor    %edi,%edi
  8019b5:	e9 40 ff ff ff       	jmp    8018fa <__udivdi3+0x46>
  8019ba:	66 90                	xchg   %ax,%ax
  8019bc:	31 c0                	xor    %eax,%eax
  8019be:	e9 37 ff ff ff       	jmp    8018fa <__udivdi3+0x46>
  8019c3:	90                   	nop

008019c4 <__umoddi3>:
  8019c4:	55                   	push   %ebp
  8019c5:	57                   	push   %edi
  8019c6:	56                   	push   %esi
  8019c7:	53                   	push   %ebx
  8019c8:	83 ec 1c             	sub    $0x1c,%esp
  8019cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019e3:	89 f3                	mov    %esi,%ebx
  8019e5:	89 fa                	mov    %edi,%edx
  8019e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019eb:	89 34 24             	mov    %esi,(%esp)
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	75 1a                	jne    801a0c <__umoddi3+0x48>
  8019f2:	39 f7                	cmp    %esi,%edi
  8019f4:	0f 86 a2 00 00 00    	jbe    801a9c <__umoddi3+0xd8>
  8019fa:	89 c8                	mov    %ecx,%eax
  8019fc:	89 f2                	mov    %esi,%edx
  8019fe:	f7 f7                	div    %edi
  801a00:	89 d0                	mov    %edx,%eax
  801a02:	31 d2                	xor    %edx,%edx
  801a04:	83 c4 1c             	add    $0x1c,%esp
  801a07:	5b                   	pop    %ebx
  801a08:	5e                   	pop    %esi
  801a09:	5f                   	pop    %edi
  801a0a:	5d                   	pop    %ebp
  801a0b:	c3                   	ret    
  801a0c:	39 f0                	cmp    %esi,%eax
  801a0e:	0f 87 ac 00 00 00    	ja     801ac0 <__umoddi3+0xfc>
  801a14:	0f bd e8             	bsr    %eax,%ebp
  801a17:	83 f5 1f             	xor    $0x1f,%ebp
  801a1a:	0f 84 ac 00 00 00    	je     801acc <__umoddi3+0x108>
  801a20:	bf 20 00 00 00       	mov    $0x20,%edi
  801a25:	29 ef                	sub    %ebp,%edi
  801a27:	89 fe                	mov    %edi,%esi
  801a29:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a2d:	89 e9                	mov    %ebp,%ecx
  801a2f:	d3 e0                	shl    %cl,%eax
  801a31:	89 d7                	mov    %edx,%edi
  801a33:	89 f1                	mov    %esi,%ecx
  801a35:	d3 ef                	shr    %cl,%edi
  801a37:	09 c7                	or     %eax,%edi
  801a39:	89 e9                	mov    %ebp,%ecx
  801a3b:	d3 e2                	shl    %cl,%edx
  801a3d:	89 14 24             	mov    %edx,(%esp)
  801a40:	89 d8                	mov    %ebx,%eax
  801a42:	d3 e0                	shl    %cl,%eax
  801a44:	89 c2                	mov    %eax,%edx
  801a46:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a4a:	d3 e0                	shl    %cl,%eax
  801a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a50:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a54:	89 f1                	mov    %esi,%ecx
  801a56:	d3 e8                	shr    %cl,%eax
  801a58:	09 d0                	or     %edx,%eax
  801a5a:	d3 eb                	shr    %cl,%ebx
  801a5c:	89 da                	mov    %ebx,%edx
  801a5e:	f7 f7                	div    %edi
  801a60:	89 d3                	mov    %edx,%ebx
  801a62:	f7 24 24             	mull   (%esp)
  801a65:	89 c6                	mov    %eax,%esi
  801a67:	89 d1                	mov    %edx,%ecx
  801a69:	39 d3                	cmp    %edx,%ebx
  801a6b:	0f 82 87 00 00 00    	jb     801af8 <__umoddi3+0x134>
  801a71:	0f 84 91 00 00 00    	je     801b08 <__umoddi3+0x144>
  801a77:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a7b:	29 f2                	sub    %esi,%edx
  801a7d:	19 cb                	sbb    %ecx,%ebx
  801a7f:	89 d8                	mov    %ebx,%eax
  801a81:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a85:	d3 e0                	shl    %cl,%eax
  801a87:	89 e9                	mov    %ebp,%ecx
  801a89:	d3 ea                	shr    %cl,%edx
  801a8b:	09 d0                	or     %edx,%eax
  801a8d:	89 e9                	mov    %ebp,%ecx
  801a8f:	d3 eb                	shr    %cl,%ebx
  801a91:	89 da                	mov    %ebx,%edx
  801a93:	83 c4 1c             	add    $0x1c,%esp
  801a96:	5b                   	pop    %ebx
  801a97:	5e                   	pop    %esi
  801a98:	5f                   	pop    %edi
  801a99:	5d                   	pop    %ebp
  801a9a:	c3                   	ret    
  801a9b:	90                   	nop
  801a9c:	89 fd                	mov    %edi,%ebp
  801a9e:	85 ff                	test   %edi,%edi
  801aa0:	75 0b                	jne    801aad <__umoddi3+0xe9>
  801aa2:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa7:	31 d2                	xor    %edx,%edx
  801aa9:	f7 f7                	div    %edi
  801aab:	89 c5                	mov    %eax,%ebp
  801aad:	89 f0                	mov    %esi,%eax
  801aaf:	31 d2                	xor    %edx,%edx
  801ab1:	f7 f5                	div    %ebp
  801ab3:	89 c8                	mov    %ecx,%eax
  801ab5:	f7 f5                	div    %ebp
  801ab7:	89 d0                	mov    %edx,%eax
  801ab9:	e9 44 ff ff ff       	jmp    801a02 <__umoddi3+0x3e>
  801abe:	66 90                	xchg   %ax,%ax
  801ac0:	89 c8                	mov    %ecx,%eax
  801ac2:	89 f2                	mov    %esi,%edx
  801ac4:	83 c4 1c             	add    $0x1c,%esp
  801ac7:	5b                   	pop    %ebx
  801ac8:	5e                   	pop    %esi
  801ac9:	5f                   	pop    %edi
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    
  801acc:	3b 04 24             	cmp    (%esp),%eax
  801acf:	72 06                	jb     801ad7 <__umoddi3+0x113>
  801ad1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ad5:	77 0f                	ja     801ae6 <__umoddi3+0x122>
  801ad7:	89 f2                	mov    %esi,%edx
  801ad9:	29 f9                	sub    %edi,%ecx
  801adb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801adf:	89 14 24             	mov    %edx,(%esp)
  801ae2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ae6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801aea:	8b 14 24             	mov    (%esp),%edx
  801aed:	83 c4 1c             	add    $0x1c,%esp
  801af0:	5b                   	pop    %ebx
  801af1:	5e                   	pop    %esi
  801af2:	5f                   	pop    %edi
  801af3:	5d                   	pop    %ebp
  801af4:	c3                   	ret    
  801af5:	8d 76 00             	lea    0x0(%esi),%esi
  801af8:	2b 04 24             	sub    (%esp),%eax
  801afb:	19 fa                	sbb    %edi,%edx
  801afd:	89 d1                	mov    %edx,%ecx
  801aff:	89 c6                	mov    %eax,%esi
  801b01:	e9 71 ff ff ff       	jmp    801a77 <__umoddi3+0xb3>
  801b06:	66 90                	xchg   %ax,%ax
  801b08:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b0c:	72 ea                	jb     801af8 <__umoddi3+0x134>
  801b0e:	89 d9                	mov    %ebx,%ecx
  801b10:	e9 62 ff ff ff       	jmp    801a77 <__umoddi3+0xb3>
