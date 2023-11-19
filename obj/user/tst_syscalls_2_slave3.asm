
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
  80004b:	e8 7c 18 00 00       	call   8018cc <sys_free_user_mem>
  800050:	83 c4 10             	add    $0x10,%esp
	inctst();
  800053:	e8 c8 16 00 00       	call   801720 <inctst>
	panic("tst system calls #2 failed: sys_free_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 80 1b 80 00       	push   $0x801b80
  800060:	6a 0a                	push   $0xa
  800062:	68 fe 1b 80 00       	push   $0x801bfe
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
  800072:	e8 6b 15 00 00       	call   8015e2 <sys_getenvindex>
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
  8000e6:	e8 04 13 00 00       	call   8013ef <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 34 1c 80 00       	push   $0x801c34
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
  800116:	68 5c 1c 80 00       	push   $0x801c5c
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
  800147:	68 84 1c 80 00       	push   $0x801c84
  80014c:	e8 1d 03 00 00       	call   80046e <cprintf>
  800151:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800154:	a1 20 30 80 00       	mov    0x803020,%eax
  800159:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  80015f:	83 ec 08             	sub    $0x8,%esp
  800162:	50                   	push   %eax
  800163:	68 dc 1c 80 00       	push   $0x801cdc
  800168:	e8 01 03 00 00       	call   80046e <cprintf>
  80016d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	68 34 1c 80 00       	push   $0x801c34
  800178:	e8 f1 02 00 00       	call   80046e <cprintf>
  80017d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800180:	e8 84 12 00 00       	call   801409 <sys_enable_interrupt>

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
  800198:	e8 11 14 00 00       	call   8015ae <sys_destroy_env>
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
  8001a9:	e8 66 14 00 00       	call   801614 <sys_exit_env>
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
  8001c0:	a1 28 31 80 00       	mov    0x803128,%eax
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	74 16                	je     8001df <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001c9:	a1 28 31 80 00       	mov    0x803128,%eax
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	50                   	push   %eax
  8001d2:	68 f0 1c 80 00       	push   $0x801cf0
  8001d7:	e8 92 02 00 00       	call   80046e <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001df:	a1 00 30 80 00       	mov    0x803000,%eax
  8001e4:	ff 75 0c             	pushl  0xc(%ebp)
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	50                   	push   %eax
  8001eb:	68 f5 1c 80 00       	push   $0x801cf5
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
  80020f:	68 11 1d 80 00       	push   $0x801d11
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
  80023e:	68 14 1d 80 00       	push   $0x801d14
  800243:	6a 26                	push   $0x26
  800245:	68 60 1d 80 00       	push   $0x801d60
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
  800313:	68 6c 1d 80 00       	push   $0x801d6c
  800318:	6a 3a                	push   $0x3a
  80031a:	68 60 1d 80 00       	push   $0x801d60
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
  800386:	68 c0 1d 80 00       	push   $0x801dc0
  80038b:	6a 44                	push   $0x44
  80038d:	68 60 1d 80 00       	push   $0x801d60
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
  8003e0:	e8 b1 0e 00 00       	call   801296 <sys_cputs>
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
  800457:	e8 3a 0e 00 00       	call   801296 <sys_cputs>
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
  8004a1:	e8 49 0f 00 00       	call   8013ef <sys_disable_interrupt>
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
  8004c1:	e8 43 0f 00 00       	call   801409 <sys_enable_interrupt>
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
  80050b:	e8 f4 13 00 00       	call   801904 <__udivdi3>
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
  80055b:	e8 b4 14 00 00       	call   801a14 <__umoddi3>
  800560:	83 c4 10             	add    $0x10,%esp
  800563:	05 34 20 80 00       	add    $0x802034,%eax
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
  8006b6:	8b 04 85 58 20 80 00 	mov    0x802058(,%eax,4),%eax
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
  800797:	8b 34 9d a0 1e 80 00 	mov    0x801ea0(,%ebx,4),%esi
  80079e:	85 f6                	test   %esi,%esi
  8007a0:	75 19                	jne    8007bb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007a2:	53                   	push   %ebx
  8007a3:	68 45 20 80 00       	push   $0x802045
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
  8007bc:	68 4e 20 80 00       	push   $0x80204e
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
  8007e9:	be 51 20 80 00       	mov    $0x802051,%esi
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

int i=0;
void *
memset(void *v, int c, uint32 n)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 10             	sub    $0x10,%esp


	i++;
  800ce4:	a1 28 30 80 00       	mov    0x803028,%eax
  800ce9:	40                   	inc    %eax
  800cea:	a3 28 30 80 00       	mov    %eax,0x803028

	char *p;
	int m;

	p = v;
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cf5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf8:	89 45 f8             	mov    %eax,-0x8(%ebp)


	while (--m >= 0){
  800cfb:	eb 0e                	jmp    800d0b <memset+0x2d>

		*p++ = c;
  800cfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d00:	8d 50 01             	lea    0x1(%eax),%edx
  800d03:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d09:	88 10                	mov    %dl,(%eax)

	p = v;
	m = n;


	while (--m >= 0){
  800d0b:	ff 4d f8             	decl   -0x8(%ebp)
  800d0e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d12:	79 e9                	jns    800cfd <memset+0x1f>

		*p++ = c;
	}

	return v;
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d2b:	eb 16                	jmp    800d43 <memcpy+0x2a>
		*d++ = *s++;
  800d2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d30:	8d 50 01             	lea    0x1(%eax),%edx
  800d33:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d39:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d3f:	8a 12                	mov    (%edx),%dl
  800d41:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d43:	8b 45 10             	mov    0x10(%ebp),%eax
  800d46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d49:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	75 dd                	jne    800d2d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d6d:	73 50                	jae    800dbf <memmove+0x6a>
  800d6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d72:	8b 45 10             	mov    0x10(%ebp),%eax
  800d75:	01 d0                	add    %edx,%eax
  800d77:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d7a:	76 43                	jbe    800dbf <memmove+0x6a>
		s += n;
  800d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d82:	8b 45 10             	mov    0x10(%ebp),%eax
  800d85:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d88:	eb 10                	jmp    800d9a <memmove+0x45>
			*--d = *--s;
  800d8a:	ff 4d f8             	decl   -0x8(%ebp)
  800d8d:	ff 4d fc             	decl   -0x4(%ebp)
  800d90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d93:	8a 10                	mov    (%eax),%dl
  800d95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d98:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da0:	89 55 10             	mov    %edx,0x10(%ebp)
  800da3:	85 c0                	test   %eax,%eax
  800da5:	75 e3                	jne    800d8a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800da7:	eb 23                	jmp    800dcc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800da9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dac:	8d 50 01             	lea    0x1(%eax),%edx
  800daf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800db2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dbb:	8a 12                	mov    (%edx),%dl
  800dbd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc5:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	75 dd                	jne    800da9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dcf:	c9                   	leave  
  800dd0:	c3                   	ret    

00800dd1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800de3:	eb 2a                	jmp    800e0f <memcmp+0x3e>
		if (*s1 != *s2)
  800de5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de8:	8a 10                	mov    (%eax),%dl
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	38 c2                	cmp    %al,%dl
  800df1:	74 16                	je     800e09 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800df3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df6:	8a 00                	mov    (%eax),%al
  800df8:	0f b6 d0             	movzbl %al,%edx
  800dfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	0f b6 c0             	movzbl %al,%eax
  800e03:	29 c2                	sub    %eax,%edx
  800e05:	89 d0                	mov    %edx,%eax
  800e07:	eb 18                	jmp    800e21 <memcmp+0x50>
		s1++, s2++;
  800e09:	ff 45 fc             	incl   -0x4(%ebp)
  800e0c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e15:	89 55 10             	mov    %edx,0x10(%ebp)
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	75 c9                	jne    800de5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e21:	c9                   	leave  
  800e22:	c3                   	ret    

00800e23 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e29:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2f:	01 d0                	add    %edx,%eax
  800e31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e34:	eb 15                	jmp    800e4b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	8a 00                	mov    (%eax),%al
  800e3b:	0f b6 d0             	movzbl %al,%edx
  800e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e41:	0f b6 c0             	movzbl %al,%eax
  800e44:	39 c2                	cmp    %eax,%edx
  800e46:	74 0d                	je     800e55 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e48:	ff 45 08             	incl   0x8(%ebp)
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e51:	72 e3                	jb     800e36 <memfind+0x13>
  800e53:	eb 01                	jmp    800e56 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e55:	90                   	nop
	return (void *) s;
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e68:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e6f:	eb 03                	jmp    800e74 <strtol+0x19>
		s++;
  800e71:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	3c 20                	cmp    $0x20,%al
  800e7b:	74 f4                	je     800e71 <strtol+0x16>
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	3c 09                	cmp    $0x9,%al
  800e84:	74 eb                	je     800e71 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8a 00                	mov    (%eax),%al
  800e8b:	3c 2b                	cmp    $0x2b,%al
  800e8d:	75 05                	jne    800e94 <strtol+0x39>
		s++;
  800e8f:	ff 45 08             	incl   0x8(%ebp)
  800e92:	eb 13                	jmp    800ea7 <strtol+0x4c>
	else if (*s == '-')
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3c 2d                	cmp    $0x2d,%al
  800e9b:	75 0a                	jne    800ea7 <strtol+0x4c>
		s++, neg = 1;
  800e9d:	ff 45 08             	incl   0x8(%ebp)
  800ea0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eab:	74 06                	je     800eb3 <strtol+0x58>
  800ead:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eb1:	75 20                	jne    800ed3 <strtol+0x78>
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	3c 30                	cmp    $0x30,%al
  800eba:	75 17                	jne    800ed3 <strtol+0x78>
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	40                   	inc    %eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	3c 78                	cmp    $0x78,%al
  800ec4:	75 0d                	jne    800ed3 <strtol+0x78>
		s += 2, base = 16;
  800ec6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eca:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ed1:	eb 28                	jmp    800efb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ed3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed7:	75 15                	jne    800eee <strtol+0x93>
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	3c 30                	cmp    $0x30,%al
  800ee0:	75 0c                	jne    800eee <strtol+0x93>
		s++, base = 8;
  800ee2:	ff 45 08             	incl   0x8(%ebp)
  800ee5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800eec:	eb 0d                	jmp    800efb <strtol+0xa0>
	else if (base == 0)
  800eee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef2:	75 07                	jne    800efb <strtol+0xa0>
		base = 10;
  800ef4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	3c 2f                	cmp    $0x2f,%al
  800f02:	7e 19                	jle    800f1d <strtol+0xc2>
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	3c 39                	cmp    $0x39,%al
  800f0b:	7f 10                	jg     800f1d <strtol+0xc2>
			dig = *s - '0';
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	0f be c0             	movsbl %al,%eax
  800f15:	83 e8 30             	sub    $0x30,%eax
  800f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1b:	eb 42                	jmp    800f5f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	3c 60                	cmp    $0x60,%al
  800f24:	7e 19                	jle    800f3f <strtol+0xe4>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 7a                	cmp    $0x7a,%al
  800f2d:	7f 10                	jg     800f3f <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	0f be c0             	movsbl %al,%eax
  800f37:	83 e8 57             	sub    $0x57,%eax
  800f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f3d:	eb 20                	jmp    800f5f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 40                	cmp    $0x40,%al
  800f46:	7e 39                	jle    800f81 <strtol+0x126>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 5a                	cmp    $0x5a,%al
  800f4f:	7f 30                	jg     800f81 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	0f be c0             	movsbl %al,%eax
  800f59:	83 e8 37             	sub    $0x37,%eax
  800f5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f62:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f65:	7d 19                	jge    800f80 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f67:	ff 45 08             	incl   0x8(%ebp)
  800f6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f71:	89 c2                	mov    %eax,%edx
  800f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f76:	01 d0                	add    %edx,%eax
  800f78:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f7b:	e9 7b ff ff ff       	jmp    800efb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f80:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f85:	74 08                	je     800f8f <strtol+0x134>
		*endptr = (char *) s;
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f93:	74 07                	je     800f9c <strtol+0x141>
  800f95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f98:	f7 d8                	neg    %eax
  800f9a:	eb 03                	jmp    800f9f <strtol+0x144>
  800f9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f9f:	c9                   	leave  
  800fa0:	c3                   	ret    

00800fa1 <ltostr>:

void
ltostr(long value, char *str)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fa7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fb9:	79 13                	jns    800fce <ltostr+0x2d>
	{
		neg = 1;
  800fbb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fc8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fcb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fd6:	99                   	cltd   
  800fd7:	f7 f9                	idiv   %ecx
  800fd9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdf:	8d 50 01             	lea    0x1(%eax),%edx
  800fe2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe5:	89 c2                	mov    %eax,%edx
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	01 d0                	add    %edx,%eax
  800fec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fef:	83 c2 30             	add    $0x30,%edx
  800ff2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ff4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ffc:	f7 e9                	imul   %ecx
  800ffe:	c1 fa 02             	sar    $0x2,%edx
  801001:	89 c8                	mov    %ecx,%eax
  801003:	c1 f8 1f             	sar    $0x1f,%eax
  801006:	29 c2                	sub    %eax,%edx
  801008:	89 d0                	mov    %edx,%eax
  80100a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80100d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801010:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801015:	f7 e9                	imul   %ecx
  801017:	c1 fa 02             	sar    $0x2,%edx
  80101a:	89 c8                	mov    %ecx,%eax
  80101c:	c1 f8 1f             	sar    $0x1f,%eax
  80101f:	29 c2                	sub    %eax,%edx
  801021:	89 d0                	mov    %edx,%eax
  801023:	c1 e0 02             	shl    $0x2,%eax
  801026:	01 d0                	add    %edx,%eax
  801028:	01 c0                	add    %eax,%eax
  80102a:	29 c1                	sub    %eax,%ecx
  80102c:	89 ca                	mov    %ecx,%edx
  80102e:	85 d2                	test   %edx,%edx
  801030:	75 9c                	jne    800fce <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801032:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801039:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103c:	48                   	dec    %eax
  80103d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801040:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801044:	74 3d                	je     801083 <ltostr+0xe2>
		start = 1 ;
  801046:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80104d:	eb 34                	jmp    801083 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80104f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801052:	8b 45 0c             	mov    0xc(%ebp),%eax
  801055:	01 d0                	add    %edx,%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80105c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	01 c2                	add    %eax,%edx
  801064:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106a:	01 c8                	add    %ecx,%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801070:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	01 c2                	add    %eax,%edx
  801078:	8a 45 eb             	mov    -0x15(%ebp),%al
  80107b:	88 02                	mov    %al,(%edx)
		start++ ;
  80107d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801080:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801089:	7c c4                	jl     80104f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80108b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80108e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801091:	01 d0                	add    %edx,%eax
  801093:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801096:	90                   	nop
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80109f:	ff 75 08             	pushl  0x8(%ebp)
  8010a2:	e8 49 fa ff ff       	call   800af0 <strlen>
  8010a7:	83 c4 04             	add    $0x4,%esp
  8010aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	e8 3b fa ff ff       	call   800af0 <strlen>
  8010b5:	83 c4 04             	add    $0x4,%esp
  8010b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010c9:	eb 17                	jmp    8010e2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d1:	01 c2                	add    %eax,%edx
  8010d3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	01 c8                	add    %ecx,%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010df:	ff 45 fc             	incl   -0x4(%ebp)
  8010e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010e8:	7c e1                	jl     8010cb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010f8:	eb 1f                	jmp    801119 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fd:	8d 50 01             	lea    0x1(%eax),%edx
  801100:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801103:	89 c2                	mov    %eax,%edx
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	01 c2                	add    %eax,%edx
  80110a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80110d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801110:	01 c8                	add    %ecx,%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801116:	ff 45 f8             	incl   -0x8(%ebp)
  801119:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80111f:	7c d9                	jl     8010fa <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801121:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801124:	8b 45 10             	mov    0x10(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	c6 00 00             	movb   $0x0,(%eax)
}
  80112c:	90                   	nop
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801132:	8b 45 14             	mov    0x14(%ebp),%eax
  801135:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80113b:	8b 45 14             	mov    0x14(%ebp),%eax
  80113e:	8b 00                	mov    (%eax),%eax
  801140:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801147:	8b 45 10             	mov    0x10(%ebp),%eax
  80114a:	01 d0                	add    %edx,%eax
  80114c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801152:	eb 0c                	jmp    801160 <strsplit+0x31>
			*string++ = 0;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8d 50 01             	lea    0x1(%eax),%edx
  80115a:	89 55 08             	mov    %edx,0x8(%ebp)
  80115d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	84 c0                	test   %al,%al
  801167:	74 18                	je     801181 <strsplit+0x52>
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	0f be c0             	movsbl %al,%eax
  801171:	50                   	push   %eax
  801172:	ff 75 0c             	pushl  0xc(%ebp)
  801175:	e8 08 fb ff ff       	call   800c82 <strchr>
  80117a:	83 c4 08             	add    $0x8,%esp
  80117d:	85 c0                	test   %eax,%eax
  80117f:	75 d3                	jne    801154 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	84 c0                	test   %al,%al
  801188:	74 5a                	je     8011e4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80118a:	8b 45 14             	mov    0x14(%ebp),%eax
  80118d:	8b 00                	mov    (%eax),%eax
  80118f:	83 f8 0f             	cmp    $0xf,%eax
  801192:	75 07                	jne    80119b <strsplit+0x6c>
		{
			return 0;
  801194:	b8 00 00 00 00       	mov    $0x0,%eax
  801199:	eb 66                	jmp    801201 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80119b:	8b 45 14             	mov    0x14(%ebp),%eax
  80119e:	8b 00                	mov    (%eax),%eax
  8011a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8011a3:	8b 55 14             	mov    0x14(%ebp),%edx
  8011a6:	89 0a                	mov    %ecx,(%edx)
  8011a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011af:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b2:	01 c2                	add    %eax,%edx
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011b9:	eb 03                	jmp    8011be <strsplit+0x8f>
			string++;
  8011bb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	84 c0                	test   %al,%al
  8011c5:	74 8b                	je     801152 <strsplit+0x23>
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	0f be c0             	movsbl %al,%eax
  8011cf:	50                   	push   %eax
  8011d0:	ff 75 0c             	pushl  0xc(%ebp)
  8011d3:	e8 aa fa ff ff       	call   800c82 <strchr>
  8011d8:	83 c4 08             	add    $0x8,%esp
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	74 dc                	je     8011bb <strsplit+0x8c>
			string++;
	}
  8011df:	e9 6e ff ff ff       	jmp    801152 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011e4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e8:	8b 00                	mov    (%eax),%eax
  8011ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011fc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  801209:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80120d:	74 06                	je     801215 <str2lower+0x12>
  80120f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801213:	75 07                	jne    80121c <str2lower+0x19>
		return NULL;
  801215:	b8 00 00 00 00       	mov    $0x0,%eax
  80121a:	eb 4d                	jmp    801269 <str2lower+0x66>
	}
	char *ref=dst;
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  801222:	eb 33                	jmp    801257 <str2lower+0x54>
			if(*src>=65&&*src<=90){
  801224:	8b 45 0c             	mov    0xc(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	3c 40                	cmp    $0x40,%al
  80122b:	7e 1a                	jle    801247 <str2lower+0x44>
  80122d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	3c 5a                	cmp    $0x5a,%al
  801234:	7f 11                	jg     801247 <str2lower+0x44>
				*dst=*src+32;
  801236:	8b 45 0c             	mov    0xc(%ebp),%eax
  801239:	8a 00                	mov    (%eax),%al
  80123b:	83 c0 20             	add    $0x20,%eax
  80123e:	88 c2                	mov    %al,%dl
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	88 10                	mov    %dl,(%eax)
  801245:	eb 0a                	jmp    801251 <str2lower+0x4e>
			}
			else{
				*dst=*src;
  801247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124a:	8a 10                	mov    (%eax),%dl
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	88 10                	mov    %dl,(%eax)
			}
			src++;
  801251:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  801254:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	84 c0                	test   %al,%al
  80125e:	75 c4                	jne    801224 <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  801266:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801269:	c9                   	leave  
  80126a:	c3                   	ret    

0080126b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	57                   	push   %edi
  80126f:	56                   	push   %esi
  801270:	53                   	push   %ebx
  801271:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80127d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801280:	8b 7d 18             	mov    0x18(%ebp),%edi
  801283:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801286:	cd 30                	int    $0x30
  801288:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80128b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80128e:	83 c4 10             	add    $0x10,%esp
  801291:	5b                   	pop    %ebx
  801292:	5e                   	pop    %esi
  801293:	5f                   	pop    %edi
  801294:	5d                   	pop    %ebp
  801295:	c3                   	ret    

00801296 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	83 ec 04             	sub    $0x4,%esp
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012a2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	52                   	push   %edx
  8012ae:	ff 75 0c             	pushl  0xc(%ebp)
  8012b1:	50                   	push   %eax
  8012b2:	6a 00                	push   $0x0
  8012b4:	e8 b2 ff ff ff       	call   80126b <syscall>
  8012b9:	83 c4 18             	add    $0x18,%esp
}
  8012bc:	90                   	nop
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <sys_cgetc>:

int
sys_cgetc(void)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 00                	push   $0x0
  8012ca:	6a 00                	push   $0x0
  8012cc:	6a 01                	push   $0x1
  8012ce:	e8 98 ff ff ff       	call   80126b <syscall>
  8012d3:	83 c4 18             	add    $0x18,%esp
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	6a 00                	push   $0x0
  8012e3:	6a 00                	push   $0x0
  8012e5:	6a 00                	push   $0x0
  8012e7:	52                   	push   %edx
  8012e8:	50                   	push   %eax
  8012e9:	6a 05                	push   $0x5
  8012eb:	e8 7b ff ff ff       	call   80126b <syscall>
  8012f0:	83 c4 18             	add    $0x18,%esp
}
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	56                   	push   %esi
  8012f9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012fa:	8b 75 18             	mov    0x18(%ebp),%esi
  8012fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801300:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801303:	8b 55 0c             	mov    0xc(%ebp),%edx
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	56                   	push   %esi
  80130a:	53                   	push   %ebx
  80130b:	51                   	push   %ecx
  80130c:	52                   	push   %edx
  80130d:	50                   	push   %eax
  80130e:	6a 06                	push   $0x6
  801310:	e8 56 ff ff ff       	call   80126b <syscall>
  801315:	83 c4 18             	add    $0x18,%esp
}
  801318:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80131b:	5b                   	pop    %ebx
  80131c:	5e                   	pop    %esi
  80131d:	5d                   	pop    %ebp
  80131e:	c3                   	ret    

0080131f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801322:	8b 55 0c             	mov    0xc(%ebp),%edx
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	52                   	push   %edx
  80132f:	50                   	push   %eax
  801330:	6a 07                	push   $0x7
  801332:	e8 34 ff ff ff       	call   80126b <syscall>
  801337:	83 c4 18             	add    $0x18,%esp
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	ff 75 0c             	pushl  0xc(%ebp)
  801348:	ff 75 08             	pushl  0x8(%ebp)
  80134b:	6a 08                	push   $0x8
  80134d:	e8 19 ff ff ff       	call   80126b <syscall>
  801352:	83 c4 18             	add    $0x18,%esp
}
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 09                	push   $0x9
  801366:	e8 00 ff ff ff       	call   80126b <syscall>
  80136b:	83 c4 18             	add    $0x18,%esp
}
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 0a                	push   $0xa
  80137f:	e8 e7 fe ff ff       	call   80126b <syscall>
  801384:	83 c4 18             	add    $0x18,%esp
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 0b                	push   $0xb
  801398:	e8 ce fe ff ff       	call   80126b <syscall>
  80139d:	83 c4 18             	add    $0x18,%esp
}
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 0c                	push   $0xc
  8013b1:	e8 b5 fe ff ff       	call   80126b <syscall>
  8013b6:	83 c4 18             	add    $0x18,%esp
}
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	ff 75 08             	pushl  0x8(%ebp)
  8013c9:	6a 0d                	push   $0xd
  8013cb:	e8 9b fe ff ff       	call   80126b <syscall>
  8013d0:	83 c4 18             	add    $0x18,%esp
}
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 0e                	push   $0xe
  8013e4:	e8 82 fe ff ff       	call   80126b <syscall>
  8013e9:	83 c4 18             	add    $0x18,%esp
}
  8013ec:	90                   	nop
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 11                	push   $0x11
  8013fe:	e8 68 fe ff ff       	call   80126b <syscall>
  801403:	83 c4 18             	add    $0x18,%esp
}
  801406:	90                   	nop
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 12                	push   $0x12
  801418:	e8 4e fe ff ff       	call   80126b <syscall>
  80141d:	83 c4 18             	add    $0x18,%esp
}
  801420:	90                   	nop
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <sys_cputc>:


void
sys_cputc(const char c)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	83 ec 04             	sub    $0x4,%esp
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80142f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	50                   	push   %eax
  80143c:	6a 13                	push   $0x13
  80143e:	e8 28 fe ff ff       	call   80126b <syscall>
  801443:	83 c4 18             	add    $0x18,%esp
}
  801446:	90                   	nop
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 14                	push   $0x14
  801458:	e8 0e fe ff ff       	call   80126b <syscall>
  80145d:	83 c4 18             	add    $0x18,%esp
}
  801460:	90                   	nop
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	ff 75 0c             	pushl  0xc(%ebp)
  801472:	50                   	push   %eax
  801473:	6a 15                	push   $0x15
  801475:	e8 f1 fd ff ff       	call   80126b <syscall>
  80147a:	83 c4 18             	add    $0x18,%esp
}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801482:	8b 55 0c             	mov    0xc(%ebp),%edx
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	52                   	push   %edx
  80148f:	50                   	push   %eax
  801490:	6a 18                	push   $0x18
  801492:	e8 d4 fd ff ff       	call   80126b <syscall>
  801497:	83 c4 18             	add    $0x18,%esp
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80149f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	52                   	push   %edx
  8014ac:	50                   	push   %eax
  8014ad:	6a 16                	push   $0x16
  8014af:	e8 b7 fd ff ff       	call   80126b <syscall>
  8014b4:	83 c4 18             	add    $0x18,%esp
}
  8014b7:	90                   	nop
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	52                   	push   %edx
  8014ca:	50                   	push   %eax
  8014cb:	6a 17                	push   $0x17
  8014cd:	e8 99 fd ff ff       	call   80126b <syscall>
  8014d2:	83 c4 18             	add    $0x18,%esp
}
  8014d5:	90                   	nop
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	83 ec 04             	sub    $0x4,%esp
  8014de:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014e4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014e7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	6a 00                	push   $0x0
  8014f0:	51                   	push   %ecx
  8014f1:	52                   	push   %edx
  8014f2:	ff 75 0c             	pushl  0xc(%ebp)
  8014f5:	50                   	push   %eax
  8014f6:	6a 19                	push   $0x19
  8014f8:	e8 6e fd ff ff       	call   80126b <syscall>
  8014fd:	83 c4 18             	add    $0x18,%esp
}
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801505:	8b 55 0c             	mov    0xc(%ebp),%edx
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	52                   	push   %edx
  801512:	50                   	push   %eax
  801513:	6a 1a                	push   $0x1a
  801515:	e8 51 fd ff ff       	call   80126b <syscall>
  80151a:	83 c4 18             	add    $0x18,%esp
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801522:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801525:	8b 55 0c             	mov    0xc(%ebp),%edx
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	51                   	push   %ecx
  801530:	52                   	push   %edx
  801531:	50                   	push   %eax
  801532:	6a 1b                	push   $0x1b
  801534:	e8 32 fd ff ff       	call   80126b <syscall>
  801539:	83 c4 18             	add    $0x18,%esp
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801541:	8b 55 0c             	mov    0xc(%ebp),%edx
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	52                   	push   %edx
  80154e:	50                   	push   %eax
  80154f:	6a 1c                	push   $0x1c
  801551:	e8 15 fd ff ff       	call   80126b <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 1d                	push   $0x1d
  80156a:	e8 fc fc ff ff       	call   80126b <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	6a 00                	push   $0x0
  80157c:	ff 75 14             	pushl  0x14(%ebp)
  80157f:	ff 75 10             	pushl  0x10(%ebp)
  801582:	ff 75 0c             	pushl  0xc(%ebp)
  801585:	50                   	push   %eax
  801586:	6a 1e                	push   $0x1e
  801588:	e8 de fc ff ff       	call   80126b <syscall>
  80158d:	83 c4 18             	add    $0x18,%esp
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	50                   	push   %eax
  8015a1:	6a 1f                	push   $0x1f
  8015a3:	e8 c3 fc ff ff       	call   80126b <syscall>
  8015a8:	83 c4 18             	add    $0x18,%esp
}
  8015ab:	90                   	nop
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	50                   	push   %eax
  8015bd:	6a 20                	push   $0x20
  8015bf:	e8 a7 fc ff ff       	call   80126b <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 02                	push   $0x2
  8015d8:	e8 8e fc ff ff       	call   80126b <syscall>
  8015dd:	83 c4 18             	add    $0x18,%esp
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 03                	push   $0x3
  8015f1:	e8 75 fc ff ff       	call   80126b <syscall>
  8015f6:	83 c4 18             	add    $0x18,%esp
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 04                	push   $0x4
  80160a:	e8 5c fc ff ff       	call   80126b <syscall>
  80160f:	83 c4 18             	add    $0x18,%esp
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <sys_exit_env>:


void sys_exit_env(void)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 21                	push   $0x21
  801623:	e8 43 fc ff ff       	call   80126b <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
}
  80162b:	90                   	nop
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801634:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801637:	8d 50 04             	lea    0x4(%eax),%edx
  80163a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	52                   	push   %edx
  801644:	50                   	push   %eax
  801645:	6a 22                	push   $0x22
  801647:	e8 1f fc ff ff       	call   80126b <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
	return result;
  80164f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801652:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801655:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801658:	89 01                	mov    %eax,(%ecx)
  80165a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	c9                   	leave  
  801661:	c2 04 00             	ret    $0x4

00801664 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	ff 75 10             	pushl  0x10(%ebp)
  80166e:	ff 75 0c             	pushl  0xc(%ebp)
  801671:	ff 75 08             	pushl  0x8(%ebp)
  801674:	6a 10                	push   $0x10
  801676:	e8 f0 fb ff ff       	call   80126b <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
	return ;
  80167e:	90                   	nop
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <sys_rcr2>:
uint32 sys_rcr2()
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 23                	push   $0x23
  801690:	e8 d6 fb ff ff       	call   80126b <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	83 ec 04             	sub    $0x4,%esp
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016a6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	50                   	push   %eax
  8016b3:	6a 24                	push   $0x24
  8016b5:	e8 b1 fb ff ff       	call   80126b <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8016bd:	90                   	nop
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <rsttst>:
void rsttst()
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 26                	push   $0x26
  8016cf:	e8 97 fb ff ff       	call   80126b <syscall>
  8016d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d7:	90                   	nop
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	83 ec 04             	sub    $0x4,%esp
  8016e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016e6:	8b 55 18             	mov    0x18(%ebp),%edx
  8016e9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016ed:	52                   	push   %edx
  8016ee:	50                   	push   %eax
  8016ef:	ff 75 10             	pushl  0x10(%ebp)
  8016f2:	ff 75 0c             	pushl  0xc(%ebp)
  8016f5:	ff 75 08             	pushl  0x8(%ebp)
  8016f8:	6a 25                	push   $0x25
  8016fa:	e8 6c fb ff ff       	call   80126b <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801702:	90                   	nop
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <chktst>:
void chktst(uint32 n)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	ff 75 08             	pushl  0x8(%ebp)
  801713:	6a 27                	push   $0x27
  801715:	e8 51 fb ff ff       	call   80126b <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
	return ;
  80171d:	90                   	nop
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <inctst>:

void inctst()
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 28                	push   $0x28
  80172f:	e8 37 fb ff ff       	call   80126b <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
	return ;
  801737:	90                   	nop
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <gettst>:
uint32 gettst()
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 29                	push   $0x29
  801749:	e8 1d fb ff ff       	call   80126b <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 2a                	push   $0x2a
  801765:	e8 01 fb ff ff       	call   80126b <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
  80176d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801770:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801774:	75 07                	jne    80177d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801776:	b8 01 00 00 00       	mov    $0x1,%eax
  80177b:	eb 05                	jmp    801782 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80177d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 2a                	push   $0x2a
  801796:	e8 d0 fa ff ff       	call   80126b <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
  80179e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8017a1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017a5:	75 07                	jne    8017ae <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ac:	eb 05                	jmp    8017b3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 2a                	push   $0x2a
  8017c7:	e8 9f fa ff ff       	call   80126b <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
  8017cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017d2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017d6:	75 07                	jne    8017df <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8017dd:	eb 05                	jmp    8017e4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 2a                	push   $0x2a
  8017f8:	e8 6e fa ff ff       	call   80126b <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
  801800:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801803:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801807:	75 07                	jne    801810 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801809:	b8 01 00 00 00       	mov    $0x1,%eax
  80180e:	eb 05                	jmp    801815 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801810:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	ff 75 08             	pushl  0x8(%ebp)
  801825:	6a 2b                	push   $0x2b
  801827:	e8 3f fa ff ff       	call   80126b <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
	return ;
  80182f:	90                   	nop
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801836:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801839:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80183c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	6a 00                	push   $0x0
  801844:	53                   	push   %ebx
  801845:	51                   	push   %ecx
  801846:	52                   	push   %edx
  801847:	50                   	push   %eax
  801848:	6a 2c                	push   $0x2c
  80184a:	e8 1c fa ff ff       	call   80126b <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80185a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	52                   	push   %edx
  801867:	50                   	push   %eax
  801868:	6a 2d                	push   $0x2d
  80186a:	e8 fc f9 ff ff       	call   80126b <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801877:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80187a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	6a 00                	push   $0x0
  801882:	51                   	push   %ecx
  801883:	ff 75 10             	pushl  0x10(%ebp)
  801886:	52                   	push   %edx
  801887:	50                   	push   %eax
  801888:	6a 2e                	push   $0x2e
  80188a:	e8 dc f9 ff ff       	call   80126b <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	ff 75 10             	pushl  0x10(%ebp)
  80189e:	ff 75 0c             	pushl  0xc(%ebp)
  8018a1:	ff 75 08             	pushl  0x8(%ebp)
  8018a4:	6a 0f                	push   $0xf
  8018a6:	e8 c0 f9 ff ff       	call   80126b <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ae:	90                   	nop
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	50                   	push   %eax
  8018c0:	6a 2f                	push   $0x2f
  8018c2:	e8 a4 f9 ff ff       	call   80126b <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	ff 75 08             	pushl  0x8(%ebp)
  8018db:	6a 30                	push   $0x30
  8018dd:	e8 89 f9 ff ff       	call   80126b <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  8018e5:	90                   	nop
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	ff 75 0c             	pushl  0xc(%ebp)
  8018f4:	ff 75 08             	pushl  0x8(%ebp)
  8018f7:	6a 31                	push   $0x31
  8018f9:	e8 6d f9 ff ff       	call   80126b <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801901:	90                   	nop
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

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
