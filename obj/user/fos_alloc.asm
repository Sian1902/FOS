
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 22 11 00 00       	call   801172 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 a0 1d 80 00       	push   $0x801da0
  800061:	e8 18 03 00 00       	call   80037e <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 b3 1d 80 00       	push   $0x801db3
  8000be:	e8 bb 02 00 00       	call   80037e <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 c4 10 00 00       	call   8011a0 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 88 10 00 00       	call   801172 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 b3 1d 80 00       	push   $0x801db3
  800114:	e8 65 02 00 00       	call   80037e <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 6e 10 00 00       	call   8011a0 <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013e:	e8 d4 14 00 00       	call   801617 <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	01 c0                	add    %eax,%eax
  80014d:	01 d0                	add    %edx,%eax
  80014f:	01 c0                	add    %eax,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	c1 e0 02             	shl    $0x2,%eax
  800156:	01 d0                	add    %edx,%eax
  800158:	01 c0                	add    %eax,%eax
  80015a:	01 d0                	add    %edx,%eax
  80015c:	c1 e0 02             	shl    $0x2,%eax
  80015f:	01 d0                	add    %edx,%eax
  800161:	c1 e0 02             	shl    $0x2,%eax
  800164:	01 d0                	add    %edx,%eax
  800166:	c1 e0 02             	shl    $0x2,%eax
  800169:	01 d0                	add    %edx,%eax
  80016b:	c1 e0 05             	shl    $0x5,%eax
  80016e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800173:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 20 30 80 00       	mov    0x803020,%eax
  80017d:	8a 40 5c             	mov    0x5c(%eax),%al
  800180:	84 c0                	test   %al,%al
  800182:	74 0d                	je     800191 <libmain+0x59>
		binaryname = myEnv->prog_name;
  800184:	a1 20 30 80 00       	mov    0x803020,%eax
  800189:	83 c0 5c             	add    $0x5c,%eax
  80018c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800191:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800195:	7e 0a                	jle    8001a1 <libmain+0x69>
		binaryname = argv[0];
  800197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 0c             	pushl  0xc(%ebp)
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	e8 89 fe ff ff       	call   800038 <_main>
  8001af:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b2:	e8 6d 12 00 00       	call   801424 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	68 d8 1d 80 00       	push   $0x801dd8
  8001bf:	e8 8d 01 00 00       	call   800351 <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001cc:	8b 90 84 da 01 00    	mov    0x1da84(%eax),%edx
  8001d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d7:	8b 80 74 da 01 00    	mov    0x1da74(%eax),%eax
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	52                   	push   %edx
  8001e1:	50                   	push   %eax
  8001e2:	68 00 1e 80 00       	push   $0x801e00
  8001e7:	e8 65 01 00 00       	call   800351 <cprintf>
  8001ec:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f4:	8b 88 98 da 01 00    	mov    0x1da98(%eax),%ecx
  8001fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ff:	8b 90 94 da 01 00    	mov    0x1da94(%eax),%edx
  800205:	a1 20 30 80 00       	mov    0x803020,%eax
  80020a:	8b 80 90 da 01 00    	mov    0x1da90(%eax),%eax
  800210:	51                   	push   %ecx
  800211:	52                   	push   %edx
  800212:	50                   	push   %eax
  800213:	68 28 1e 80 00       	push   $0x801e28
  800218:	e8 34 01 00 00       	call   800351 <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800220:	a1 20 30 80 00       	mov    0x803020,%eax
  800225:	8b 80 9c da 01 00    	mov    0x1da9c(%eax),%eax
  80022b:	83 ec 08             	sub    $0x8,%esp
  80022e:	50                   	push   %eax
  80022f:	68 80 1e 80 00       	push   $0x801e80
  800234:	e8 18 01 00 00       	call   800351 <cprintf>
  800239:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	68 d8 1d 80 00       	push   $0x801dd8
  800244:	e8 08 01 00 00       	call   800351 <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024c:	e8 ed 11 00 00       	call   80143e <sys_enable_interrupt>

	// exit gracefully
	exit();
  800251:	e8 19 00 00 00       	call   80026f <exit>
}
  800256:	90                   	nop
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	6a 00                	push   $0x0
  800264:	e8 7a 13 00 00       	call   8015e3 <sys_destroy_env>
  800269:	83 c4 10             	add    $0x10,%esp
}
  80026c:	90                   	nop
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <exit>:

void
exit(void)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800275:	e8 cf 13 00 00       	call   801649 <sys_exit_env>
}
  80027a:	90                   	nop
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800283:	8b 45 0c             	mov    0xc(%ebp),%eax
  800286:	8b 00                	mov    (%eax),%eax
  800288:	8d 48 01             	lea    0x1(%eax),%ecx
  80028b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028e:	89 0a                	mov    %ecx,(%edx)
  800290:	8b 55 08             	mov    0x8(%ebp),%edx
  800293:	88 d1                	mov    %dl,%cl
  800295:	8b 55 0c             	mov    0xc(%ebp),%edx
  800298:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80029c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029f:	8b 00                	mov    (%eax),%eax
  8002a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a6:	75 2c                	jne    8002d4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002a8:	a0 24 30 80 00       	mov    0x803024,%al
  8002ad:	0f b6 c0             	movzbl %al,%eax
  8002b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b3:	8b 12                	mov    (%edx),%edx
  8002b5:	89 d1                	mov    %edx,%ecx
  8002b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ba:	83 c2 08             	add    $0x8,%edx
  8002bd:	83 ec 04             	sub    $0x4,%esp
  8002c0:	50                   	push   %eax
  8002c1:	51                   	push   %ecx
  8002c2:	52                   	push   %edx
  8002c3:	e8 03 10 00 00       	call   8012cb <sys_cputs>
  8002c8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	8b 40 04             	mov    0x4(%eax),%eax
  8002da:	8d 50 01             	lea    0x1(%eax),%edx
  8002dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002e3:	90                   	nop
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    

008002e6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f6:	00 00 00 
	b.cnt = 0;
  8002f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800300:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800303:	ff 75 0c             	pushl  0xc(%ebp)
  800306:	ff 75 08             	pushl  0x8(%ebp)
  800309:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80030f:	50                   	push   %eax
  800310:	68 7d 02 80 00       	push   $0x80027d
  800315:	e8 11 02 00 00       	call   80052b <vprintfmt>
  80031a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80031d:	a0 24 30 80 00       	mov    0x803024,%al
  800322:	0f b6 c0             	movzbl %al,%eax
  800325:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80032b:	83 ec 04             	sub    $0x4,%esp
  80032e:	50                   	push   %eax
  80032f:	52                   	push   %edx
  800330:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800336:	83 c0 08             	add    $0x8,%eax
  800339:	50                   	push   %eax
  80033a:	e8 8c 0f 00 00       	call   8012cb <sys_cputs>
  80033f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800342:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800349:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80034f:	c9                   	leave  
  800350:	c3                   	ret    

00800351 <cprintf>:

int cprintf(const char *fmt, ...) {
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800357:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80035e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800364:	8b 45 08             	mov    0x8(%ebp),%eax
  800367:	83 ec 08             	sub    $0x8,%esp
  80036a:	ff 75 f4             	pushl  -0xc(%ebp)
  80036d:	50                   	push   %eax
  80036e:	e8 73 ff ff ff       	call   8002e6 <vcprintf>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800379:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800384:	e8 9b 10 00 00       	call   801424 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800389:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	ff 75 f4             	pushl  -0xc(%ebp)
  800398:	50                   	push   %eax
  800399:	e8 48 ff ff ff       	call   8002e6 <vcprintf>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003a4:	e8 95 10 00 00       	call   80143e <sys_enable_interrupt>
	return cnt;
  8003a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003ac:	c9                   	leave  
  8003ad:	c3                   	ret    

008003ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	53                   	push   %ebx
  8003b2:	83 ec 14             	sub    $0x14,%esp
  8003b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003cc:	77 55                	ja     800423 <printnum+0x75>
  8003ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003d1:	72 05                	jb     8003d8 <printnum+0x2a>
  8003d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d6:	77 4b                	ja     800423 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003de:	8b 45 18             	mov    0x18(%ebp),%eax
  8003e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e6:	52                   	push   %edx
  8003e7:	50                   	push   %eax
  8003e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8003eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8003ee:	e8 31 17 00 00       	call   801b24 <__udivdi3>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	83 ec 04             	sub    $0x4,%esp
  8003f9:	ff 75 20             	pushl  0x20(%ebp)
  8003fc:	53                   	push   %ebx
  8003fd:	ff 75 18             	pushl  0x18(%ebp)
  800400:	52                   	push   %edx
  800401:	50                   	push   %eax
  800402:	ff 75 0c             	pushl  0xc(%ebp)
  800405:	ff 75 08             	pushl  0x8(%ebp)
  800408:	e8 a1 ff ff ff       	call   8003ae <printnum>
  80040d:	83 c4 20             	add    $0x20,%esp
  800410:	eb 1a                	jmp    80042c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800412:	83 ec 08             	sub    $0x8,%esp
  800415:	ff 75 0c             	pushl  0xc(%ebp)
  800418:	ff 75 20             	pushl  0x20(%ebp)
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	ff d0                	call   *%eax
  800420:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800423:	ff 4d 1c             	decl   0x1c(%ebp)
  800426:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80042a:	7f e6                	jg     800412 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80042f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800437:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80043a:	53                   	push   %ebx
  80043b:	51                   	push   %ecx
  80043c:	52                   	push   %edx
  80043d:	50                   	push   %eax
  80043e:	e8 f1 17 00 00       	call   801c34 <__umoddi3>
  800443:	83 c4 10             	add    $0x10,%esp
  800446:	05 b4 20 80 00       	add    $0x8020b4,%eax
  80044b:	8a 00                	mov    (%eax),%al
  80044d:	0f be c0             	movsbl %al,%eax
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	ff 75 0c             	pushl  0xc(%ebp)
  800456:	50                   	push   %eax
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	ff d0                	call   *%eax
  80045c:	83 c4 10             	add    $0x10,%esp
}
  80045f:	90                   	nop
  800460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800463:	c9                   	leave  
  800464:	c3                   	ret    

00800465 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800468:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80046c:	7e 1c                	jle    80048a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	8d 50 08             	lea    0x8(%eax),%edx
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	89 10                	mov    %edx,(%eax)
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	83 e8 08             	sub    $0x8,%eax
  800483:	8b 50 04             	mov    0x4(%eax),%edx
  800486:	8b 00                	mov    (%eax),%eax
  800488:	eb 40                	jmp    8004ca <getuint+0x65>
	else if (lflag)
  80048a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80048e:	74 1e                	je     8004ae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	8d 50 04             	lea    0x4(%eax),%edx
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	89 10                	mov    %edx,(%eax)
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	83 e8 04             	sub    $0x4,%eax
  8004a5:	8b 00                	mov    (%eax),%eax
  8004a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ac:	eb 1c                	jmp    8004ca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	8d 50 04             	lea    0x4(%eax),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	89 10                	mov    %edx,(%eax)
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	83 e8 04             	sub    $0x4,%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004ca:	5d                   	pop    %ebp
  8004cb:	c3                   	ret    

008004cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004d3:	7e 1c                	jle    8004f1 <getint+0x25>
		return va_arg(*ap, long long);
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	8d 50 08             	lea    0x8(%eax),%edx
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	89 10                	mov    %edx,(%eax)
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	83 e8 08             	sub    $0x8,%eax
  8004ea:	8b 50 04             	mov    0x4(%eax),%edx
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	eb 38                	jmp    800529 <getint+0x5d>
	else if (lflag)
  8004f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f5:	74 1a                	je     800511 <getint+0x45>
		return va_arg(*ap, long);
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 50 04             	lea    0x4(%eax),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	89 10                	mov    %edx,(%eax)
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	83 e8 04             	sub    $0x4,%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	99                   	cltd   
  80050f:	eb 18                	jmp    800529 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800511:	8b 45 08             	mov    0x8(%ebp),%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	8d 50 04             	lea    0x4(%eax),%edx
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	89 10                	mov    %edx,(%eax)
  80051e:	8b 45 08             	mov    0x8(%ebp),%eax
  800521:	8b 00                	mov    (%eax),%eax
  800523:	83 e8 04             	sub    $0x4,%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	99                   	cltd   
}
  800529:	5d                   	pop    %ebp
  80052a:	c3                   	ret    

0080052b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	56                   	push   %esi
  80052f:	53                   	push   %ebx
  800530:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800533:	eb 17                	jmp    80054c <vprintfmt+0x21>
			if (ch == '\0')
  800535:	85 db                	test   %ebx,%ebx
  800537:	0f 84 af 03 00 00    	je     8008ec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80053d:	83 ec 08             	sub    $0x8,%esp
  800540:	ff 75 0c             	pushl  0xc(%ebp)
  800543:	53                   	push   %ebx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	ff d0                	call   *%eax
  800549:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80054c:	8b 45 10             	mov    0x10(%ebp),%eax
  80054f:	8d 50 01             	lea    0x1(%eax),%edx
  800552:	89 55 10             	mov    %edx,0x10(%ebp)
  800555:	8a 00                	mov    (%eax),%al
  800557:	0f b6 d8             	movzbl %al,%ebx
  80055a:	83 fb 25             	cmp    $0x25,%ebx
  80055d:	75 d6                	jne    800535 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80055f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800563:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80056a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800571:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800578:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057f:	8b 45 10             	mov    0x10(%ebp),%eax
  800582:	8d 50 01             	lea    0x1(%eax),%edx
  800585:	89 55 10             	mov    %edx,0x10(%ebp)
  800588:	8a 00                	mov    (%eax),%al
  80058a:	0f b6 d8             	movzbl %al,%ebx
  80058d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800590:	83 f8 55             	cmp    $0x55,%eax
  800593:	0f 87 2b 03 00 00    	ja     8008c4 <vprintfmt+0x399>
  800599:	8b 04 85 d8 20 80 00 	mov    0x8020d8(,%eax,4),%eax
  8005a0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005a2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005a6:	eb d7                	jmp    80057f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005a8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005ac:	eb d1                	jmp    80057f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b8:	89 d0                	mov    %edx,%eax
  8005ba:	c1 e0 02             	shl    $0x2,%eax
  8005bd:	01 d0                	add    %edx,%eax
  8005bf:	01 c0                	add    %eax,%eax
  8005c1:	01 d8                	add    %ebx,%eax
  8005c3:	83 e8 30             	sub    $0x30,%eax
  8005c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cc:	8a 00                	mov    (%eax),%al
  8005ce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005d1:	83 fb 2f             	cmp    $0x2f,%ebx
  8005d4:	7e 3e                	jle    800614 <vprintfmt+0xe9>
  8005d6:	83 fb 39             	cmp    $0x39,%ebx
  8005d9:	7f 39                	jg     800614 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005db:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005de:	eb d5                	jmp    8005b5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	83 c0 04             	add    $0x4,%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	83 e8 04             	sub    $0x4,%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005f4:	eb 1f                	jmp    800615 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005fa:	79 83                	jns    80057f <vprintfmt+0x54>
				width = 0;
  8005fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800603:	e9 77 ff ff ff       	jmp    80057f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800608:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80060f:	e9 6b ff ff ff       	jmp    80057f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800614:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800615:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800619:	0f 89 60 ff ff ff    	jns    80057f <vprintfmt+0x54>
				width = precision, precision = -1;
  80061f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800625:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80062c:	e9 4e ff ff ff       	jmp    80057f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800631:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800634:	e9 46 ff ff ff       	jmp    80057f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	83 c0 04             	add    $0x4,%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	83 e8 04             	sub    $0x4,%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	50                   	push   %eax
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	ff d0                	call   *%eax
  800656:	83 c4 10             	add    $0x10,%esp
			break;
  800659:	e9 89 02 00 00       	jmp    8008e7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	83 c0 04             	add    $0x4,%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	83 e8 04             	sub    $0x4,%eax
  80066d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80066f:	85 db                	test   %ebx,%ebx
  800671:	79 02                	jns    800675 <vprintfmt+0x14a>
				err = -err;
  800673:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800675:	83 fb 64             	cmp    $0x64,%ebx
  800678:	7f 0b                	jg     800685 <vprintfmt+0x15a>
  80067a:	8b 34 9d 20 1f 80 00 	mov    0x801f20(,%ebx,4),%esi
  800681:	85 f6                	test   %esi,%esi
  800683:	75 19                	jne    80069e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800685:	53                   	push   %ebx
  800686:	68 c5 20 80 00       	push   $0x8020c5
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	ff 75 08             	pushl  0x8(%ebp)
  800691:	e8 5e 02 00 00       	call   8008f4 <printfmt>
  800696:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800699:	e9 49 02 00 00       	jmp    8008e7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80069e:	56                   	push   %esi
  80069f:	68 ce 20 80 00       	push   $0x8020ce
  8006a4:	ff 75 0c             	pushl  0xc(%ebp)
  8006a7:	ff 75 08             	pushl  0x8(%ebp)
  8006aa:	e8 45 02 00 00       	call   8008f4 <printfmt>
  8006af:	83 c4 10             	add    $0x10,%esp
			break;
  8006b2:	e9 30 02 00 00       	jmp    8008e7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	83 c0 04             	add    $0x4,%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	83 e8 04             	sub    $0x4,%eax
  8006c6:	8b 30                	mov    (%eax),%esi
  8006c8:	85 f6                	test   %esi,%esi
  8006ca:	75 05                	jne    8006d1 <vprintfmt+0x1a6>
				p = "(null)";
  8006cc:	be d1 20 80 00       	mov    $0x8020d1,%esi
			if (width > 0 && padc != '-')
  8006d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d5:	7e 6d                	jle    800744 <vprintfmt+0x219>
  8006d7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006db:	74 67                	je     800744 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	50                   	push   %eax
  8006e4:	56                   	push   %esi
  8006e5:	e8 0c 03 00 00       	call   8009f6 <strnlen>
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006f0:	eb 16                	jmp    800708 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006f2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	50                   	push   %eax
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	ff d0                	call   *%eax
  800702:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800705:	ff 4d e4             	decl   -0x1c(%ebp)
  800708:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070c:	7f e4                	jg     8006f2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070e:	eb 34                	jmp    800744 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800710:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800714:	74 1c                	je     800732 <vprintfmt+0x207>
  800716:	83 fb 1f             	cmp    $0x1f,%ebx
  800719:	7e 05                	jle    800720 <vprintfmt+0x1f5>
  80071b:	83 fb 7e             	cmp    $0x7e,%ebx
  80071e:	7e 12                	jle    800732 <vprintfmt+0x207>
					putch('?', putdat);
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	6a 3f                	push   $0x3f
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	eb 0f                	jmp    800741 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	ff 75 0c             	pushl  0xc(%ebp)
  800738:	53                   	push   %ebx
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	ff d0                	call   *%eax
  80073e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800741:	ff 4d e4             	decl   -0x1c(%ebp)
  800744:	89 f0                	mov    %esi,%eax
  800746:	8d 70 01             	lea    0x1(%eax),%esi
  800749:	8a 00                	mov    (%eax),%al
  80074b:	0f be d8             	movsbl %al,%ebx
  80074e:	85 db                	test   %ebx,%ebx
  800750:	74 24                	je     800776 <vprintfmt+0x24b>
  800752:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800756:	78 b8                	js     800710 <vprintfmt+0x1e5>
  800758:	ff 4d e0             	decl   -0x20(%ebp)
  80075b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80075f:	79 af                	jns    800710 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800761:	eb 13                	jmp    800776 <vprintfmt+0x24b>
				putch(' ', putdat);
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	6a 20                	push   $0x20
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	ff d0                	call   *%eax
  800770:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800773:	ff 4d e4             	decl   -0x1c(%ebp)
  800776:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80077a:	7f e7                	jg     800763 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80077c:	e9 66 01 00 00       	jmp    8008e7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 e8             	pushl  -0x18(%ebp)
  800787:	8d 45 14             	lea    0x14(%ebp),%eax
  80078a:	50                   	push   %eax
  80078b:	e8 3c fd ff ff       	call   8004cc <getint>
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800796:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079f:	85 d2                	test   %edx,%edx
  8007a1:	79 23                	jns    8007c6 <vprintfmt+0x29b>
				putch('-', putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	6a 2d                	push   $0x2d
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	ff d0                	call   *%eax
  8007b0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b9:	f7 d8                	neg    %eax
  8007bb:	83 d2 00             	adc    $0x0,%edx
  8007be:	f7 da                	neg    %edx
  8007c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007c6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007cd:	e9 bc 00 00 00       	jmp    80088e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d8:	8d 45 14             	lea    0x14(%ebp),%eax
  8007db:	50                   	push   %eax
  8007dc:	e8 84 fc ff ff       	call   800465 <getuint>
  8007e1:	83 c4 10             	add    $0x10,%esp
  8007e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007ea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f1:	e9 98 00 00 00       	jmp    80088e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	ff 75 0c             	pushl  0xc(%ebp)
  8007fc:	6a 58                	push   $0x58
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	ff d0                	call   *%eax
  800803:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 0c             	pushl  0xc(%ebp)
  80080c:	6a 58                	push   $0x58
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	ff d0                	call   *%eax
  800813:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	ff 75 0c             	pushl  0xc(%ebp)
  80081c:	6a 58                	push   $0x58
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	ff d0                	call   *%eax
  800823:	83 c4 10             	add    $0x10,%esp
			break;
  800826:	e9 bc 00 00 00       	jmp    8008e7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	6a 30                	push   $0x30
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	6a 78                	push   $0x78
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 c0 04             	add    $0x4,%eax
  800851:	89 45 14             	mov    %eax,0x14(%ebp)
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	83 e8 04             	sub    $0x4,%eax
  80085a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80085c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800866:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80086d:	eb 1f                	jmp    80088e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 e8             	pushl  -0x18(%ebp)
  800875:	8d 45 14             	lea    0x14(%ebp),%eax
  800878:	50                   	push   %eax
  800879:	e8 e7 fb ff ff       	call   800465 <getuint>
  80087e:	83 c4 10             	add    $0x10,%esp
  800881:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800884:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800887:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80088e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800892:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800895:	83 ec 04             	sub    $0x4,%esp
  800898:	52                   	push   %edx
  800899:	ff 75 e4             	pushl  -0x1c(%ebp)
  80089c:	50                   	push   %eax
  80089d:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	ff 75 08             	pushl  0x8(%ebp)
  8008a9:	e8 00 fb ff ff       	call   8003ae <printnum>
  8008ae:	83 c4 20             	add    $0x20,%esp
			break;
  8008b1:	eb 34                	jmp    8008e7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	ff 75 0c             	pushl  0xc(%ebp)
  8008b9:	53                   	push   %ebx
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	ff d0                	call   *%eax
  8008bf:	83 c4 10             	add    $0x10,%esp
			break;
  8008c2:	eb 23                	jmp    8008e7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008c4:	83 ec 08             	sub    $0x8,%esp
  8008c7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ca:	6a 25                	push   $0x25
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	ff d0                	call   *%eax
  8008d1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d4:	ff 4d 10             	decl   0x10(%ebp)
  8008d7:	eb 03                	jmp    8008dc <vprintfmt+0x3b1>
  8008d9:	ff 4d 10             	decl   0x10(%ebp)
  8008dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008df:	48                   	dec    %eax
  8008e0:	8a 00                	mov    (%eax),%al
  8008e2:	3c 25                	cmp    $0x25,%al
  8008e4:	75 f3                	jne    8008d9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008e6:	90                   	nop
		}
	}
  8008e7:	e9 47 fc ff ff       	jmp    800533 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008ec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f0:	5b                   	pop    %ebx
  8008f1:	5e                   	pop    %esi
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fd:	83 c0 04             	add    $0x4,%eax
  800900:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800903:	8b 45 10             	mov    0x10(%ebp),%eax
  800906:	ff 75 f4             	pushl  -0xc(%ebp)
  800909:	50                   	push   %eax
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	e8 16 fc ff ff       	call   80052b <vprintfmt>
  800915:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800918:	90                   	nop
  800919:	c9                   	leave  
  80091a:	c3                   	ret    

0080091b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800921:	8b 40 08             	mov    0x8(%eax),%eax
  800924:	8d 50 01             	lea    0x1(%eax),%edx
  800927:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80092d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800930:	8b 10                	mov    (%eax),%edx
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
  800935:	8b 40 04             	mov    0x4(%eax),%eax
  800938:	39 c2                	cmp    %eax,%edx
  80093a:	73 12                	jae    80094e <sprintputch+0x33>
		*b->buf++ = ch;
  80093c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	8d 48 01             	lea    0x1(%eax),%ecx
  800944:	8b 55 0c             	mov    0xc(%ebp),%edx
  800947:	89 0a                	mov    %ecx,(%edx)
  800949:	8b 55 08             	mov    0x8(%ebp),%edx
  80094c:	88 10                	mov    %dl,(%eax)
}
  80094e:	90                   	nop
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8d 50 ff             	lea    -0x1(%eax),%edx
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	01 d0                	add    %edx,%eax
  800968:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800972:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800976:	74 06                	je     80097e <vsnprintf+0x2d>
  800978:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80097c:	7f 07                	jg     800985 <vsnprintf+0x34>
		return -E_INVAL;
  80097e:	b8 03 00 00 00       	mov    $0x3,%eax
  800983:	eb 20                	jmp    8009a5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800985:	ff 75 14             	pushl  0x14(%ebp)
  800988:	ff 75 10             	pushl  0x10(%ebp)
  80098b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80098e:	50                   	push   %eax
  80098f:	68 1b 09 80 00       	push   $0x80091b
  800994:	e8 92 fb ff ff       	call   80052b <vprintfmt>
  800999:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80099c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009a5:	c9                   	leave  
  8009a6:	c3                   	ret    

008009a7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8009b0:	83 c0 04             	add    $0x4,%eax
  8009b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009bc:	50                   	push   %eax
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	ff 75 08             	pushl  0x8(%ebp)
  8009c3:	e8 89 ff ff ff       	call   800951 <vsnprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp
  8009cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009d1:	c9                   	leave  
  8009d2:	c3                   	ret    

008009d3 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009e0:	eb 06                	jmp    8009e8 <strlen+0x15>
		n++;
  8009e2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e5:	ff 45 08             	incl   0x8(%ebp)
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8a 00                	mov    (%eax),%al
  8009ed:	84 c0                	test   %al,%al
  8009ef:	75 f1                	jne    8009e2 <strlen+0xf>
		n++;
	return n;
  8009f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    

008009f6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a03:	eb 09                	jmp    800a0e <strnlen+0x18>
		n++;
  800a05:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a08:	ff 45 08             	incl   0x8(%ebp)
  800a0b:	ff 4d 0c             	decl   0xc(%ebp)
  800a0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a12:	74 09                	je     800a1d <strnlen+0x27>
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	8a 00                	mov    (%eax),%al
  800a19:	84 c0                	test   %al,%al
  800a1b:	75 e8                	jne    800a05 <strnlen+0xf>
		n++;
	return n;
  800a1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a20:	c9                   	leave  
  800a21:	c3                   	ret    

00800a22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a2e:	90                   	nop
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	8d 50 01             	lea    0x1(%eax),%edx
  800a35:	89 55 08             	mov    %edx,0x8(%ebp)
  800a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a3e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a41:	8a 12                	mov    (%edx),%dl
  800a43:	88 10                	mov    %dl,(%eax)
  800a45:	8a 00                	mov    (%eax),%al
  800a47:	84 c0                	test   %al,%al
  800a49:	75 e4                	jne    800a2f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4e:	c9                   	leave  
  800a4f:	c3                   	ret    

00800a50 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a63:	eb 1f                	jmp    800a84 <strncpy+0x34>
		*dst++ = *src;
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	8d 50 01             	lea    0x1(%eax),%edx
  800a6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800a6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a71:	8a 12                	mov    (%edx),%dl
  800a73:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a78:	8a 00                	mov    (%eax),%al
  800a7a:	84 c0                	test   %al,%al
  800a7c:	74 03                	je     800a81 <strncpy+0x31>
			src++;
  800a7e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a81:	ff 45 fc             	incl   -0x4(%ebp)
  800a84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a87:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a8a:	72 d9                	jb     800a65 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa1:	74 30                	je     800ad3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aa3:	eb 16                	jmp    800abb <strlcpy+0x2a>
			*dst++ = *src++;
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8d 50 01             	lea    0x1(%eax),%edx
  800aab:	89 55 08             	mov    %edx,0x8(%ebp)
  800aae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ab4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ab7:	8a 12                	mov    (%edx),%dl
  800ab9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800abb:	ff 4d 10             	decl   0x10(%ebp)
  800abe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac2:	74 09                	je     800acd <strlcpy+0x3c>
  800ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac7:	8a 00                	mov    (%eax),%al
  800ac9:	84 c0                	test   %al,%al
  800acb:	75 d8                	jne    800aa5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad9:	29 c2                	sub    %eax,%edx
  800adb:	89 d0                	mov    %edx,%eax
}
  800add:	c9                   	leave  
  800ade:	c3                   	ret    

00800adf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ae2:	eb 06                	jmp    800aea <strcmp+0xb>
		p++, q++;
  800ae4:	ff 45 08             	incl   0x8(%ebp)
  800ae7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8a 00                	mov    (%eax),%al
  800aef:	84 c0                	test   %al,%al
  800af1:	74 0e                	je     800b01 <strcmp+0x22>
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	8a 10                	mov    (%eax),%dl
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	8a 00                	mov    (%eax),%al
  800afd:	38 c2                	cmp    %al,%dl
  800aff:	74 e3                	je     800ae4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	8a 00                	mov    (%eax),%al
  800b06:	0f b6 d0             	movzbl %al,%edx
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	8a 00                	mov    (%eax),%al
  800b0e:	0f b6 c0             	movzbl %al,%eax
  800b11:	29 c2                	sub    %eax,%edx
  800b13:	89 d0                	mov    %edx,%eax
}
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b1a:	eb 09                	jmp    800b25 <strncmp+0xe>
		n--, p++, q++;
  800b1c:	ff 4d 10             	decl   0x10(%ebp)
  800b1f:	ff 45 08             	incl   0x8(%ebp)
  800b22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b29:	74 17                	je     800b42 <strncmp+0x2b>
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	84 c0                	test   %al,%al
  800b32:	74 0e                	je     800b42 <strncmp+0x2b>
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8a 10                	mov    (%eax),%dl
  800b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3c:	8a 00                	mov    (%eax),%al
  800b3e:	38 c2                	cmp    %al,%dl
  800b40:	74 da                	je     800b1c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b46:	75 07                	jne    800b4f <strncmp+0x38>
		return 0;
  800b48:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4d:	eb 14                	jmp    800b63 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	8a 00                	mov    (%eax),%al
  800b54:	0f b6 d0             	movzbl %al,%edx
  800b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5a:	8a 00                	mov    (%eax),%al
  800b5c:	0f b6 c0             	movzbl %al,%eax
  800b5f:	29 c2                	sub    %eax,%edx
  800b61:	89 d0                	mov    %edx,%eax
}
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 04             	sub    $0x4,%esp
  800b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b71:	eb 12                	jmp    800b85 <strchr+0x20>
		if (*s == c)
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8a 00                	mov    (%eax),%al
  800b78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b7b:	75 05                	jne    800b82 <strchr+0x1d>
			return (char *) s;
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	eb 11                	jmp    800b93 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b82:	ff 45 08             	incl   0x8(%ebp)
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8a 00                	mov    (%eax),%al
  800b8a:	84 c0                	test   %al,%al
  800b8c:	75 e5                	jne    800b73 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b93:	c9                   	leave  
  800b94:	c3                   	ret    

00800b95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	83 ec 04             	sub    $0x4,%esp
  800b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ba1:	eb 0d                	jmp    800bb0 <strfind+0x1b>
		if (*s == c)
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	8a 00                	mov    (%eax),%al
  800ba8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bab:	74 0e                	je     800bbb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bad:	ff 45 08             	incl   0x8(%ebp)
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8a 00                	mov    (%eax),%al
  800bb5:	84 c0                	test   %al,%al
  800bb7:	75 ea                	jne    800ba3 <strfind+0xe>
  800bb9:	eb 01                	jmp    800bbc <strfind+0x27>
		if (*s == c)
			break;
  800bbb:	90                   	nop
	return (char *) s;
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bbf:	c9                   	leave  
  800bc0:	c3                   	ret    

00800bc1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bd3:	eb 0e                	jmp    800be3 <memset+0x22>
		*p++ = c;
  800bd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd8:	8d 50 01             	lea    0x1(%eax),%edx
  800bdb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bde:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800be3:	ff 4d f8             	decl   -0x8(%ebp)
  800be6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bea:	79 e9                	jns    800bd5 <memset+0x14>
		*p++ = c;

	return v;
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c03:	eb 16                	jmp    800c1b <memcpy+0x2a>
		*d++ = *s++;
  800c05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c08:	8d 50 01             	lea    0x1(%eax),%edx
  800c0b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c14:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c17:	8a 12                	mov    (%edx),%dl
  800c19:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c21:	89 55 10             	mov    %edx,0x10(%ebp)
  800c24:	85 c0                	test   %eax,%eax
  800c26:	75 dd                	jne    800c05 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c2b:	c9                   	leave  
  800c2c:	c3                   	ret    

00800c2d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c45:	73 50                	jae    800c97 <memmove+0x6a>
  800c47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	01 d0                	add    %edx,%eax
  800c4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c52:	76 43                	jbe    800c97 <memmove+0x6a>
		s += n;
  800c54:	8b 45 10             	mov    0x10(%ebp),%eax
  800c57:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c60:	eb 10                	jmp    800c72 <memmove+0x45>
			*--d = *--s;
  800c62:	ff 4d f8             	decl   -0x8(%ebp)
  800c65:	ff 4d fc             	decl   -0x4(%ebp)
  800c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6b:	8a 10                	mov    (%eax),%dl
  800c6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c70:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c72:	8b 45 10             	mov    0x10(%ebp),%eax
  800c75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c78:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7b:	85 c0                	test   %eax,%eax
  800c7d:	75 e3                	jne    800c62 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c7f:	eb 23                	jmp    800ca4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c84:	8d 50 01             	lea    0x1(%eax),%edx
  800c87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c93:	8a 12                	mov    (%edx),%dl
  800c95:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c97:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca0:	85 c0                	test   %eax,%eax
  800ca2:	75 dd                	jne    800c81 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ca7:	c9                   	leave  
  800ca8:	c3                   	ret    

00800ca9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cbb:	eb 2a                	jmp    800ce7 <memcmp+0x3e>
		if (*s1 != *s2)
  800cbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc0:	8a 10                	mov    (%eax),%dl
  800cc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	38 c2                	cmp    %al,%dl
  800cc9:	74 16                	je     800ce1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ccb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	0f b6 d0             	movzbl %al,%edx
  800cd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd6:	8a 00                	mov    (%eax),%al
  800cd8:	0f b6 c0             	movzbl %al,%eax
  800cdb:	29 c2                	sub    %eax,%edx
  800cdd:	89 d0                	mov    %edx,%eax
  800cdf:	eb 18                	jmp    800cf9 <memcmp+0x50>
		s1++, s2++;
  800ce1:	ff 45 fc             	incl   -0x4(%ebp)
  800ce4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ce7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ced:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf0:	85 c0                	test   %eax,%eax
  800cf2:	75 c9                	jne    800cbd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf9:	c9                   	leave  
  800cfa:	c3                   	ret    

00800cfb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d01:	8b 55 08             	mov    0x8(%ebp),%edx
  800d04:	8b 45 10             	mov    0x10(%ebp),%eax
  800d07:	01 d0                	add    %edx,%eax
  800d09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d0c:	eb 15                	jmp    800d23 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	0f b6 d0             	movzbl %al,%edx
  800d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d19:	0f b6 c0             	movzbl %al,%eax
  800d1c:	39 c2                	cmp    %eax,%edx
  800d1e:	74 0d                	je     800d2d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d20:	ff 45 08             	incl   0x8(%ebp)
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d29:	72 e3                	jb     800d0e <memfind+0x13>
  800d2b:	eb 01                	jmp    800d2e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d2d:	90                   	nop
	return (void *) s;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d31:	c9                   	leave  
  800d32:	c3                   	ret    

00800d33 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d40:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d47:	eb 03                	jmp    800d4c <strtol+0x19>
		s++;
  800d49:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	3c 20                	cmp    $0x20,%al
  800d53:	74 f4                	je     800d49 <strtol+0x16>
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3c 09                	cmp    $0x9,%al
  800d5c:	74 eb                	je     800d49 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	3c 2b                	cmp    $0x2b,%al
  800d65:	75 05                	jne    800d6c <strtol+0x39>
		s++;
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	eb 13                	jmp    800d7f <strtol+0x4c>
	else if (*s == '-')
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	3c 2d                	cmp    $0x2d,%al
  800d73:	75 0a                	jne    800d7f <strtol+0x4c>
		s++, neg = 1;
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d83:	74 06                	je     800d8b <strtol+0x58>
  800d85:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d89:	75 20                	jne    800dab <strtol+0x78>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	3c 30                	cmp    $0x30,%al
  800d92:	75 17                	jne    800dab <strtol+0x78>
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	40                   	inc    %eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	3c 78                	cmp    $0x78,%al
  800d9c:	75 0d                	jne    800dab <strtol+0x78>
		s += 2, base = 16;
  800d9e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800da2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800da9:	eb 28                	jmp    800dd3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800daf:	75 15                	jne    800dc6 <strtol+0x93>
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	3c 30                	cmp    $0x30,%al
  800db8:	75 0c                	jne    800dc6 <strtol+0x93>
		s++, base = 8;
  800dba:	ff 45 08             	incl   0x8(%ebp)
  800dbd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dc4:	eb 0d                	jmp    800dd3 <strtol+0xa0>
	else if (base == 0)
  800dc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dca:	75 07                	jne    800dd3 <strtol+0xa0>
		base = 10;
  800dcc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	3c 2f                	cmp    $0x2f,%al
  800dda:	7e 19                	jle    800df5 <strtol+0xc2>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	3c 39                	cmp    $0x39,%al
  800de3:	7f 10                	jg     800df5 <strtol+0xc2>
			dig = *s - '0';
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f be c0             	movsbl %al,%eax
  800ded:	83 e8 30             	sub    $0x30,%eax
  800df0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800df3:	eb 42                	jmp    800e37 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	3c 60                	cmp    $0x60,%al
  800dfc:	7e 19                	jle    800e17 <strtol+0xe4>
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	3c 7a                	cmp    $0x7a,%al
  800e05:	7f 10                	jg     800e17 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	0f be c0             	movsbl %al,%eax
  800e0f:	83 e8 57             	sub    $0x57,%eax
  800e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e15:	eb 20                	jmp    800e37 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	3c 40                	cmp    $0x40,%al
  800e1e:	7e 39                	jle    800e59 <strtol+0x126>
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	3c 5a                	cmp    $0x5a,%al
  800e27:	7f 30                	jg     800e59 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	0f be c0             	movsbl %al,%eax
  800e31:	83 e8 37             	sub    $0x37,%eax
  800e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e3a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e3d:	7d 19                	jge    800e58 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e3f:	ff 45 08             	incl   0x8(%ebp)
  800e42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e45:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e49:	89 c2                	mov    %eax,%edx
  800e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4e:	01 d0                	add    %edx,%eax
  800e50:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e53:	e9 7b ff ff ff       	jmp    800dd3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e58:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e5d:	74 08                	je     800e67 <strtol+0x134>
		*endptr = (char *) s;
  800e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e62:	8b 55 08             	mov    0x8(%ebp),%edx
  800e65:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e67:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e6b:	74 07                	je     800e74 <strtol+0x141>
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	f7 d8                	neg    %eax
  800e72:	eb 03                	jmp    800e77 <strtol+0x144>
  800e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <ltostr>:

void
ltostr(long value, char *str)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e86:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e91:	79 13                	jns    800ea6 <ltostr+0x2d>
	{
		neg = 1;
  800e93:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ea0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ea3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800eae:	99                   	cltd   
  800eaf:	f7 f9                	idiv   %ecx
  800eb1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800eb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb7:	8d 50 01             	lea    0x1(%eax),%edx
  800eba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebd:	89 c2                	mov    %eax,%edx
  800ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec2:	01 d0                	add    %edx,%eax
  800ec4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ec7:	83 c2 30             	add    $0x30,%edx
  800eca:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ecc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ecf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ed4:	f7 e9                	imul   %ecx
  800ed6:	c1 fa 02             	sar    $0x2,%edx
  800ed9:	89 c8                	mov    %ecx,%eax
  800edb:	c1 f8 1f             	sar    $0x1f,%eax
  800ede:	29 c2                	sub    %eax,%edx
  800ee0:	89 d0                	mov    %edx,%eax
  800ee2:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800ee5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ee8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800eed:	f7 e9                	imul   %ecx
  800eef:	c1 fa 02             	sar    $0x2,%edx
  800ef2:	89 c8                	mov    %ecx,%eax
  800ef4:	c1 f8 1f             	sar    $0x1f,%eax
  800ef7:	29 c2                	sub    %eax,%edx
  800ef9:	89 d0                	mov    %edx,%eax
  800efb:	c1 e0 02             	shl    $0x2,%eax
  800efe:	01 d0                	add    %edx,%eax
  800f00:	01 c0                	add    %eax,%eax
  800f02:	29 c1                	sub    %eax,%ecx
  800f04:	89 ca                	mov    %ecx,%edx
  800f06:	85 d2                	test   %edx,%edx
  800f08:	75 9c                	jne    800ea6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f14:	48                   	dec    %eax
  800f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f18:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f1c:	74 3d                	je     800f5b <ltostr+0xe2>
		start = 1 ;
  800f1e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f25:	eb 34                	jmp    800f5b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2d:	01 d0                	add    %edx,%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3a:	01 c2                	add    %eax,%edx
  800f3c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f42:	01 c8                	add    %ecx,%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	01 c2                	add    %eax,%edx
  800f50:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f53:	88 02                	mov    %al,(%edx)
		start++ ;
  800f55:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f58:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f61:	7c c4                	jl     800f27 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f63:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	01 d0                	add    %edx,%eax
  800f6b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f6e:	90                   	nop
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f77:	ff 75 08             	pushl  0x8(%ebp)
  800f7a:	e8 54 fa ff ff       	call   8009d3 <strlen>
  800f7f:	83 c4 04             	add    $0x4,%esp
  800f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f85:	ff 75 0c             	pushl  0xc(%ebp)
  800f88:	e8 46 fa ff ff       	call   8009d3 <strlen>
  800f8d:	83 c4 04             	add    $0x4,%esp
  800f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fa1:	eb 17                	jmp    800fba <strcconcat+0x49>
		final[s] = str1[s] ;
  800fa3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa9:	01 c2                	add    %eax,%edx
  800fab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	01 c8                	add    %ecx,%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fb7:	ff 45 fc             	incl   -0x4(%ebp)
  800fba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fc0:	7c e1                	jl     800fa3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fc2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fc9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fd0:	eb 1f                	jmp    800ff1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd5:	8d 50 01             	lea    0x1(%eax),%edx
  800fd8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fdb:	89 c2                	mov    %eax,%edx
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	01 c2                	add    %eax,%edx
  800fe2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	01 c8                	add    %ecx,%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fee:	ff 45 f8             	incl   -0x8(%ebp)
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ff7:	7c d9                	jl     800fd2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800ff9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fff:	01 d0                	add    %edx,%eax
  801001:	c6 00 00             	movb   $0x0,(%eax)
}
  801004:	90                   	nop
  801005:	c9                   	leave  
  801006:	c3                   	ret    

00801007 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80100a:	8b 45 14             	mov    0x14(%ebp),%eax
  80100d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801013:	8b 45 14             	mov    0x14(%ebp),%eax
  801016:	8b 00                	mov    (%eax),%eax
  801018:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80101f:	8b 45 10             	mov    0x10(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80102a:	eb 0c                	jmp    801038 <strsplit+0x31>
			*string++ = 0;
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8d 50 01             	lea    0x1(%eax),%edx
  801032:	89 55 08             	mov    %edx,0x8(%ebp)
  801035:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	84 c0                	test   %al,%al
  80103f:	74 18                	je     801059 <strsplit+0x52>
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	0f be c0             	movsbl %al,%eax
  801049:	50                   	push   %eax
  80104a:	ff 75 0c             	pushl  0xc(%ebp)
  80104d:	e8 13 fb ff ff       	call   800b65 <strchr>
  801052:	83 c4 08             	add    $0x8,%esp
  801055:	85 c0                	test   %eax,%eax
  801057:	75 d3                	jne    80102c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	84 c0                	test   %al,%al
  801060:	74 5a                	je     8010bc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801062:	8b 45 14             	mov    0x14(%ebp),%eax
  801065:	8b 00                	mov    (%eax),%eax
  801067:	83 f8 0f             	cmp    $0xf,%eax
  80106a:	75 07                	jne    801073 <strsplit+0x6c>
		{
			return 0;
  80106c:	b8 00 00 00 00       	mov    $0x0,%eax
  801071:	eb 66                	jmp    8010d9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801073:	8b 45 14             	mov    0x14(%ebp),%eax
  801076:	8b 00                	mov    (%eax),%eax
  801078:	8d 48 01             	lea    0x1(%eax),%ecx
  80107b:	8b 55 14             	mov    0x14(%ebp),%edx
  80107e:	89 0a                	mov    %ecx,(%edx)
  801080:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
  80108a:	01 c2                	add    %eax,%edx
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801091:	eb 03                	jmp    801096 <strsplit+0x8f>
			string++;
  801093:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	84 c0                	test   %al,%al
  80109d:	74 8b                	je     80102a <strsplit+0x23>
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	0f be c0             	movsbl %al,%eax
  8010a7:	50                   	push   %eax
  8010a8:	ff 75 0c             	pushl  0xc(%ebp)
  8010ab:	e8 b5 fa ff ff       	call   800b65 <strchr>
  8010b0:	83 c4 08             	add    $0x8,%esp
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	74 dc                	je     801093 <strsplit+0x8c>
			string++;
	}
  8010b7:	e9 6e ff ff ff       	jmp    80102a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010bc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c0:	8b 00                	mov    (%eax),%eax
  8010c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cc:	01 d0                	add    %edx,%eax
  8010ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    

008010db <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  8010e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e5:	74 06                	je     8010ed <str2lower+0x12>
  8010e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010eb:	75 07                	jne    8010f4 <str2lower+0x19>
		return NULL;
  8010ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f2:	eb 4d                	jmp    801141 <str2lower+0x66>
	}
	char *ref=dst;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  8010fa:	eb 33                	jmp    80112f <str2lower+0x54>
			if(*src>=65&&*src<=90){
  8010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ff:	8a 00                	mov    (%eax),%al
  801101:	3c 40                	cmp    $0x40,%al
  801103:	7e 1a                	jle    80111f <str2lower+0x44>
  801105:	8b 45 0c             	mov    0xc(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 5a                	cmp    $0x5a,%al
  80110c:	7f 11                	jg     80111f <str2lower+0x44>
				*dst=*src+32;
  80110e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	83 c0 20             	add    $0x20,%eax
  801116:	88 c2                	mov    %al,%dl
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	88 10                	mov    %dl,(%eax)
  80111d:	eb 0a                	jmp    801129 <str2lower+0x4e>
			}
			else{
				*dst=*src;
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	8a 10                	mov    (%eax),%dl
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	88 10                	mov    %dl,(%eax)
			}
			src++;
  801129:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  80112c:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  80112f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	84 c0                	test   %al,%al
  801136:	75 c4                	jne    8010fc <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  80113e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801141:	c9                   	leave  
  801142:	c3                   	ret    

00801143 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
	if(FirstTimeFlag)
  801146:	a1 04 30 80 00       	mov    0x803004,%eax
  80114b:	85 c0                	test   %eax,%eax
  80114d:	74 0a                	je     801159 <InitializeUHeap+0x16>
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80114f:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801156:	00 00 00 
	}
}
  801159:	90                   	nop
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    

0080115c <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801162:	83 ec 0c             	sub    $0xc,%esp
  801165:	ff 75 08             	pushl  0x8(%ebp)
  801168:	e8 79 07 00 00       	call   8018e6 <sys_sbrk>
  80116d:	83 c4 10             	add    $0x10,%esp
}
  801170:	c9                   	leave  
  801171:	c3                   	ret    

00801172 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
  801175:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801178:	e8 c6 ff ff ff       	call   801143 <InitializeUHeap>
	if (size == 0) return NULL ;
  80117d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801181:	75 07                	jne    80118a <malloc+0x18>
  801183:	b8 00 00 00 00       	mov    $0x0,%eax
  801188:	eb 14                	jmp    80119e <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80118a:	83 ec 04             	sub    $0x4,%esp
  80118d:	68 30 22 80 00       	push   $0x802230
  801192:	6a 2d                	push   $0x2d
  801194:	68 55 22 80 00       	push   $0x802255
  801199:	e8 9b 07 00 00       	call   801939 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80119e:	c9                   	leave  
  80119f:	c3                   	ret    

008011a0 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8011a6:	83 ec 04             	sub    $0x4,%esp
  8011a9:	68 64 22 80 00       	push   $0x802264
  8011ae:	6a 3b                	push   $0x3b
  8011b0:	68 55 22 80 00       	push   $0x802255
  8011b5:	e8 7f 07 00 00       	call   801939 <_panic>

008011ba <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	83 ec 18             	sub    $0x18,%esp
  8011c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c3:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8011c6:	e8 78 ff ff ff       	call   801143 <InitializeUHeap>
	if (size == 0) return NULL ;
  8011cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011cf:	75 07                	jne    8011d8 <smalloc+0x1e>
  8011d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d6:	eb 14                	jmp    8011ec <smalloc+0x32>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  8011d8:	83 ec 04             	sub    $0x4,%esp
  8011db:	68 88 22 80 00       	push   $0x802288
  8011e0:	6a 49                	push   $0x49
  8011e2:	68 55 22 80 00       	push   $0x802255
  8011e7:	e8 4d 07 00 00       	call   801939 <_panic>
	return NULL;
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8011f4:	e8 4a ff ff ff       	call   801143 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8011f9:	83 ec 04             	sub    $0x4,%esp
  8011fc:	68 b0 22 80 00       	push   $0x8022b0
  801201:	6a 57                	push   $0x57
  801203:	68 55 22 80 00       	push   $0x802255
  801208:	e8 2c 07 00 00       	call   801939 <_panic>

0080120d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801213:	e8 2b ff ff ff       	call   801143 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT'23.MS2 - BONUS] [2] USER HEAP - realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801218:	83 ec 04             	sub    $0x4,%esp
  80121b:	68 d4 22 80 00       	push   $0x8022d4
  801220:	6a 78                	push   $0x78
  801222:	68 55 22 80 00       	push   $0x802255
  801227:	e8 0d 07 00 00       	call   801939 <_panic>

0080122c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801232:	83 ec 04             	sub    $0x4,%esp
  801235:	68 fc 22 80 00       	push   $0x8022fc
  80123a:	68 8c 00 00 00       	push   $0x8c
  80123f:	68 55 22 80 00       	push   $0x802255
  801244:	e8 f0 06 00 00       	call   801939 <_panic>

00801249 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80124f:	83 ec 04             	sub    $0x4,%esp
  801252:	68 20 23 80 00       	push   $0x802320
  801257:	68 96 00 00 00       	push   $0x96
  80125c:	68 55 22 80 00       	push   $0x802255
  801261:	e8 d3 06 00 00       	call   801939 <_panic>

00801266 <shrink>:

}
void shrink(uint32 newSize)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80126c:	83 ec 04             	sub    $0x4,%esp
  80126f:	68 20 23 80 00       	push   $0x802320
  801274:	68 9b 00 00 00       	push   $0x9b
  801279:	68 55 22 80 00       	push   $0x802255
  80127e:	e8 b6 06 00 00       	call   801939 <_panic>

00801283 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801289:	83 ec 04             	sub    $0x4,%esp
  80128c:	68 20 23 80 00       	push   $0x802320
  801291:	68 a0 00 00 00       	push   $0xa0
  801296:	68 55 22 80 00       	push   $0x802255
  80129b:	e8 99 06 00 00       	call   801939 <_panic>

008012a0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	57                   	push   %edi
  8012a4:	56                   	push   %esi
  8012a5:	53                   	push   %ebx
  8012a6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012b5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012b8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012bb:	cd 30                	int    $0x30
  8012bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012c3:	83 c4 10             	add    $0x10,%esp
  8012c6:	5b                   	pop    %ebx
  8012c7:	5e                   	pop    %esi
  8012c8:	5f                   	pop    %edi
  8012c9:	5d                   	pop    %ebp
  8012ca:	c3                   	ret    

008012cb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	83 ec 04             	sub    $0x4,%esp
  8012d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012d7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	52                   	push   %edx
  8012e3:	ff 75 0c             	pushl  0xc(%ebp)
  8012e6:	50                   	push   %eax
  8012e7:	6a 00                	push   $0x0
  8012e9:	e8 b2 ff ff ff       	call   8012a0 <syscall>
  8012ee:	83 c4 18             	add    $0x18,%esp
}
  8012f1:	90                   	nop
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 00                	push   $0x0
  801301:	6a 01                	push   $0x1
  801303:	e8 98 ff ff ff       	call   8012a0 <syscall>
  801308:	83 c4 18             	add    $0x18,%esp
}
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801310:	8b 55 0c             	mov    0xc(%ebp),%edx
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	52                   	push   %edx
  80131d:	50                   	push   %eax
  80131e:	6a 05                	push   $0x5
  801320:	e8 7b ff ff ff       	call   8012a0 <syscall>
  801325:	83 c4 18             	add    $0x18,%esp
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	56                   	push   %esi
  80132e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80132f:	8b 75 18             	mov    0x18(%ebp),%esi
  801332:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801335:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801338:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	56                   	push   %esi
  80133f:	53                   	push   %ebx
  801340:	51                   	push   %ecx
  801341:	52                   	push   %edx
  801342:	50                   	push   %eax
  801343:	6a 06                	push   $0x6
  801345:	e8 56 ff ff ff       	call   8012a0 <syscall>
  80134a:	83 c4 18             	add    $0x18,%esp
}
  80134d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801350:	5b                   	pop    %ebx
  801351:	5e                   	pop    %esi
  801352:	5d                   	pop    %ebp
  801353:	c3                   	ret    

00801354 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	52                   	push   %edx
  801364:	50                   	push   %eax
  801365:	6a 07                	push   $0x7
  801367:	e8 34 ff ff ff       	call   8012a0 <syscall>
  80136c:	83 c4 18             	add    $0x18,%esp
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	ff 75 0c             	pushl  0xc(%ebp)
  80137d:	ff 75 08             	pushl  0x8(%ebp)
  801380:	6a 08                	push   $0x8
  801382:	e8 19 ff ff ff       	call   8012a0 <syscall>
  801387:	83 c4 18             	add    $0x18,%esp
}
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	6a 09                	push   $0x9
  80139b:	e8 00 ff ff ff       	call   8012a0 <syscall>
  8013a0:	83 c4 18             	add    $0x18,%esp
}
  8013a3:	c9                   	leave  
  8013a4:	c3                   	ret    

008013a5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 0a                	push   $0xa
  8013b4:	e8 e7 fe ff ff       	call   8012a0 <syscall>
  8013b9:	83 c4 18             	add    $0x18,%esp
}
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 0b                	push   $0xb
  8013cd:	e8 ce fe ff ff       	call   8012a0 <syscall>
  8013d2:	83 c4 18             	add    $0x18,%esp
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 0c                	push   $0xc
  8013e6:	e8 b5 fe ff ff       	call   8012a0 <syscall>
  8013eb:	83 c4 18             	add    $0x18,%esp
}
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	ff 75 08             	pushl  0x8(%ebp)
  8013fe:	6a 0d                	push   $0xd
  801400:	e8 9b fe ff ff       	call   8012a0 <syscall>
  801405:	83 c4 18             	add    $0x18,%esp
}
  801408:	c9                   	leave  
  801409:	c3                   	ret    

0080140a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 0e                	push   $0xe
  801419:	e8 82 fe ff ff       	call   8012a0 <syscall>
  80141e:	83 c4 18             	add    $0x18,%esp
}
  801421:	90                   	nop
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 11                	push   $0x11
  801433:	e8 68 fe ff ff       	call   8012a0 <syscall>
  801438:	83 c4 18             	add    $0x18,%esp
}
  80143b:	90                   	nop
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 12                	push   $0x12
  80144d:	e8 4e fe ff ff       	call   8012a0 <syscall>
  801452:	83 c4 18             	add    $0x18,%esp
}
  801455:	90                   	nop
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <sys_cputc>:


void
sys_cputc(const char c)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	83 ec 04             	sub    $0x4,%esp
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801464:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	50                   	push   %eax
  801471:	6a 13                	push   $0x13
  801473:	e8 28 fe ff ff       	call   8012a0 <syscall>
  801478:	83 c4 18             	add    $0x18,%esp
}
  80147b:	90                   	nop
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 14                	push   $0x14
  80148d:	e8 0e fe ff ff       	call   8012a0 <syscall>
  801492:	83 c4 18             	add    $0x18,%esp
}
  801495:	90                   	nop
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	50                   	push   %eax
  8014a8:	6a 15                	push   $0x15
  8014aa:	e8 f1 fd ff ff       	call   8012a0 <syscall>
  8014af:	83 c4 18             	add    $0x18,%esp
}
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	52                   	push   %edx
  8014c4:	50                   	push   %eax
  8014c5:	6a 18                	push   $0x18
  8014c7:	e8 d4 fd ff ff       	call   8012a0 <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	52                   	push   %edx
  8014e1:	50                   	push   %eax
  8014e2:	6a 16                	push   $0x16
  8014e4:	e8 b7 fd ff ff       	call   8012a0 <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	90                   	nop
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	52                   	push   %edx
  8014ff:	50                   	push   %eax
  801500:	6a 17                	push   $0x17
  801502:	e8 99 fd ff ff       	call   8012a0 <syscall>
  801507:	83 c4 18             	add    $0x18,%esp
}
  80150a:	90                   	nop
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	8b 45 10             	mov    0x10(%ebp),%eax
  801516:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801519:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80151c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	6a 00                	push   $0x0
  801525:	51                   	push   %ecx
  801526:	52                   	push   %edx
  801527:	ff 75 0c             	pushl  0xc(%ebp)
  80152a:	50                   	push   %eax
  80152b:	6a 19                	push   $0x19
  80152d:	e8 6e fd ff ff       	call   8012a0 <syscall>
  801532:	83 c4 18             	add    $0x18,%esp
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80153a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	52                   	push   %edx
  801547:	50                   	push   %eax
  801548:	6a 1a                	push   $0x1a
  80154a:	e8 51 fd ff ff       	call   8012a0 <syscall>
  80154f:	83 c4 18             	add    $0x18,%esp
}
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801557:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80155a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	51                   	push   %ecx
  801565:	52                   	push   %edx
  801566:	50                   	push   %eax
  801567:	6a 1b                	push   $0x1b
  801569:	e8 32 fd ff ff       	call   8012a0 <syscall>
  80156e:	83 c4 18             	add    $0x18,%esp
}
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801576:	8b 55 0c             	mov    0xc(%ebp),%edx
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	52                   	push   %edx
  801583:	50                   	push   %eax
  801584:	6a 1c                	push   $0x1c
  801586:	e8 15 fd ff ff       	call   8012a0 <syscall>
  80158b:	83 c4 18             	add    $0x18,%esp
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 1d                	push   $0x1d
  80159f:	e8 fc fc ff ff       	call   8012a0 <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	6a 00                	push   $0x0
  8015b1:	ff 75 14             	pushl  0x14(%ebp)
  8015b4:	ff 75 10             	pushl  0x10(%ebp)
  8015b7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ba:	50                   	push   %eax
  8015bb:	6a 1e                	push   $0x1e
  8015bd:	e8 de fc ff ff       	call   8012a0 <syscall>
  8015c2:	83 c4 18             	add    $0x18,%esp
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	50                   	push   %eax
  8015d6:	6a 1f                	push   $0x1f
  8015d8:	e8 c3 fc ff ff       	call   8012a0 <syscall>
  8015dd:	83 c4 18             	add    $0x18,%esp
}
  8015e0:	90                   	nop
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	50                   	push   %eax
  8015f2:	6a 20                	push   $0x20
  8015f4:	e8 a7 fc ff ff       	call   8012a0 <syscall>
  8015f9:	83 c4 18             	add    $0x18,%esp
}
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 02                	push   $0x2
  80160d:	e8 8e fc ff ff       	call   8012a0 <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 03                	push   $0x3
  801626:	e8 75 fc ff ff       	call   8012a0 <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 04                	push   $0x4
  80163f:	e8 5c fc ff ff       	call   8012a0 <syscall>
  801644:	83 c4 18             	add    $0x18,%esp
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sys_exit_env>:


void sys_exit_env(void)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 21                	push   $0x21
  801658:	e8 43 fc ff ff       	call   8012a0 <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
}
  801660:	90                   	nop
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801669:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80166c:	8d 50 04             	lea    0x4(%eax),%edx
  80166f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	52                   	push   %edx
  801679:	50                   	push   %eax
  80167a:	6a 22                	push   $0x22
  80167c:	e8 1f fc ff ff       	call   8012a0 <syscall>
  801681:	83 c4 18             	add    $0x18,%esp
	return result;
  801684:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801687:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168d:	89 01                	mov    %eax,(%ecx)
  80168f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	c9                   	leave  
  801696:	c2 04 00             	ret    $0x4

00801699 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	ff 75 10             	pushl  0x10(%ebp)
  8016a3:	ff 75 0c             	pushl  0xc(%ebp)
  8016a6:	ff 75 08             	pushl  0x8(%ebp)
  8016a9:	6a 10                	push   $0x10
  8016ab:	e8 f0 fb ff ff       	call   8012a0 <syscall>
  8016b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b3:	90                   	nop
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 23                	push   $0x23
  8016c5:	e8 d6 fb ff ff       	call   8012a0 <syscall>
  8016ca:	83 c4 18             	add    $0x18,%esp
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 04             	sub    $0x4,%esp
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016db:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	50                   	push   %eax
  8016e8:	6a 24                	push   $0x24
  8016ea:	e8 b1 fb ff ff       	call   8012a0 <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f2:	90                   	nop
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <rsttst>:
void rsttst()
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 26                	push   $0x26
  801704:	e8 97 fb ff ff       	call   8012a0 <syscall>
  801709:	83 c4 18             	add    $0x18,%esp
	return ;
  80170c:	90                   	nop
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 04             	sub    $0x4,%esp
  801715:	8b 45 14             	mov    0x14(%ebp),%eax
  801718:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80171b:	8b 55 18             	mov    0x18(%ebp),%edx
  80171e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801722:	52                   	push   %edx
  801723:	50                   	push   %eax
  801724:	ff 75 10             	pushl  0x10(%ebp)
  801727:	ff 75 0c             	pushl  0xc(%ebp)
  80172a:	ff 75 08             	pushl  0x8(%ebp)
  80172d:	6a 25                	push   $0x25
  80172f:	e8 6c fb ff ff       	call   8012a0 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
	return ;
  801737:	90                   	nop
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <chktst>:
void chktst(uint32 n)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	ff 75 08             	pushl  0x8(%ebp)
  801748:	6a 27                	push   $0x27
  80174a:	e8 51 fb ff ff       	call   8012a0 <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
	return ;
  801752:	90                   	nop
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <inctst>:

void inctst()
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 28                	push   $0x28
  801764:	e8 37 fb ff ff       	call   8012a0 <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
	return ;
  80176c:	90                   	nop
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <gettst>:
uint32 gettst()
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 29                	push   $0x29
  80177e:	e8 1d fb ff ff       	call   8012a0 <syscall>
  801783:	83 c4 18             	add    $0x18,%esp
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 2a                	push   $0x2a
  80179a:	e8 01 fb ff ff       	call   8012a0 <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
  8017a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017a5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017a9:	75 07                	jne    8017b2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b0:	eb 05                	jmp    8017b7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 2a                	push   $0x2a
  8017cb:	e8 d0 fa ff ff       	call   8012a0 <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
  8017d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8017d6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017da:	75 07                	jne    8017e3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e1:	eb 05                	jmp    8017e8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 2a                	push   $0x2a
  8017fc:	e8 9f fa ff ff       	call   8012a0 <syscall>
  801801:	83 c4 18             	add    $0x18,%esp
  801804:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801807:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80180b:	75 07                	jne    801814 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80180d:	b8 01 00 00 00       	mov    $0x1,%eax
  801812:	eb 05                	jmp    801819 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801814:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 2a                	push   $0x2a
  80182d:	e8 6e fa ff ff       	call   8012a0 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
  801835:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801838:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80183c:	75 07                	jne    801845 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80183e:	b8 01 00 00 00       	mov    $0x1,%eax
  801843:	eb 05                	jmp    80184a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801845:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	ff 75 08             	pushl  0x8(%ebp)
  80185a:	6a 2b                	push   $0x2b
  80185c:	e8 3f fa ff ff       	call   8012a0 <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
	return ;
  801864:	90                   	nop
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80186b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80186e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801871:	8b 55 0c             	mov    0xc(%ebp),%edx
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	6a 00                	push   $0x0
  801879:	53                   	push   %ebx
  80187a:	51                   	push   %ecx
  80187b:	52                   	push   %edx
  80187c:	50                   	push   %eax
  80187d:	6a 2c                	push   $0x2c
  80187f:	e8 1c fa ff ff       	call   8012a0 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80188f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	52                   	push   %edx
  80189c:	50                   	push   %eax
  80189d:	6a 2d                	push   $0x2d
  80189f:	e8 fc f9 ff ff       	call   8012a0 <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018ac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b5:	6a 00                	push   $0x0
  8018b7:	51                   	push   %ecx
  8018b8:	ff 75 10             	pushl  0x10(%ebp)
  8018bb:	52                   	push   %edx
  8018bc:	50                   	push   %eax
  8018bd:	6a 2e                	push   $0x2e
  8018bf:	e8 dc f9 ff ff       	call   8012a0 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	ff 75 10             	pushl  0x10(%ebp)
  8018d3:	ff 75 0c             	pushl  0xc(%ebp)
  8018d6:	ff 75 08             	pushl  0x8(%ebp)
  8018d9:	6a 0f                	push   $0xf
  8018db:	e8 c0 f9 ff ff       	call   8012a0 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e3:	90                   	nop
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	50                   	push   %eax
  8018f5:	6a 2f                	push   $0x2f
  8018f7:	e8 a4 f9 ff ff       	call   8012a0 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	ff 75 0c             	pushl  0xc(%ebp)
  80190d:	ff 75 08             	pushl  0x8(%ebp)
  801910:	6a 30                	push   $0x30
  801912:	e8 89 f9 ff ff       	call   8012a0 <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  80191a:	90                   	nop
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	ff 75 0c             	pushl  0xc(%ebp)
  801929:	ff 75 08             	pushl  0x8(%ebp)
  80192c:	6a 31                	push   $0x31
  80192e:	e8 6d f9 ff ff       	call   8012a0 <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801936:	90                   	nop
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80193f:	8d 45 10             	lea    0x10(%ebp),%eax
  801942:	83 c0 04             	add    $0x4,%eax
  801945:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801948:	a1 38 31 80 00       	mov    0x803138,%eax
  80194d:	85 c0                	test   %eax,%eax
  80194f:	74 16                	je     801967 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801951:	a1 38 31 80 00       	mov    0x803138,%eax
  801956:	83 ec 08             	sub    $0x8,%esp
  801959:	50                   	push   %eax
  80195a:	68 30 23 80 00       	push   $0x802330
  80195f:	e8 ed e9 ff ff       	call   800351 <cprintf>
  801964:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801967:	a1 00 30 80 00       	mov    0x803000,%eax
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	ff 75 08             	pushl  0x8(%ebp)
  801972:	50                   	push   %eax
  801973:	68 35 23 80 00       	push   $0x802335
  801978:	e8 d4 e9 ff ff       	call   800351 <cprintf>
  80197d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801980:	8b 45 10             	mov    0x10(%ebp),%eax
  801983:	83 ec 08             	sub    $0x8,%esp
  801986:	ff 75 f4             	pushl  -0xc(%ebp)
  801989:	50                   	push   %eax
  80198a:	e8 57 e9 ff ff       	call   8002e6 <vcprintf>
  80198f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801992:	83 ec 08             	sub    $0x8,%esp
  801995:	6a 00                	push   $0x0
  801997:	68 51 23 80 00       	push   $0x802351
  80199c:	e8 45 e9 ff ff       	call   8002e6 <vcprintf>
  8019a1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8019a4:	e8 c6 e8 ff ff       	call   80026f <exit>

	// should not return here
	while (1) ;
  8019a9:	eb fe                	jmp    8019a9 <_panic+0x70>

008019ab <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8019b6:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  8019bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bf:	39 c2                	cmp    %eax,%edx
  8019c1:	74 14                	je     8019d7 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	68 54 23 80 00       	push   $0x802354
  8019cb:	6a 26                	push   $0x26
  8019cd:	68 a0 23 80 00       	push   $0x8023a0
  8019d2:	e8 62 ff ff ff       	call   801939 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019e5:	e9 c5 00 00 00       	jmp    801aaf <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8019ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	01 d0                	add    %edx,%eax
  8019f9:	8b 00                	mov    (%eax),%eax
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	75 08                	jne    801a07 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8019ff:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a02:	e9 a5 00 00 00       	jmp    801aac <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a0e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a15:	eb 69                	jmp    801a80 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a17:	a1 20 30 80 00       	mov    0x803020,%eax
  801a1c:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  801a22:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a25:	89 d0                	mov    %edx,%eax
  801a27:	01 c0                	add    %eax,%eax
  801a29:	01 d0                	add    %edx,%eax
  801a2b:	c1 e0 03             	shl    $0x3,%eax
  801a2e:	01 c8                	add    %ecx,%eax
  801a30:	8a 40 04             	mov    0x4(%eax),%al
  801a33:	84 c0                	test   %al,%al
  801a35:	75 46                	jne    801a7d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a37:	a1 20 30 80 00       	mov    0x803020,%eax
  801a3c:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  801a42:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a45:	89 d0                	mov    %edx,%eax
  801a47:	01 c0                	add    %eax,%eax
  801a49:	01 d0                	add    %edx,%eax
  801a4b:	c1 e0 03             	shl    $0x3,%eax
  801a4e:	01 c8                	add    %ecx,%eax
  801a50:	8b 00                	mov    (%eax),%eax
  801a52:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a55:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a5d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a62:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	01 c8                	add    %ecx,%eax
  801a6e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a70:	39 c2                	cmp    %eax,%edx
  801a72:	75 09                	jne    801a7d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801a74:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a7b:	eb 15                	jmp    801a92 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a7d:	ff 45 e8             	incl   -0x18(%ebp)
  801a80:	a1 20 30 80 00       	mov    0x803020,%eax
  801a85:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  801a8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a8e:	39 c2                	cmp    %eax,%edx
  801a90:	77 85                	ja     801a17 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a92:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a96:	75 14                	jne    801aac <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801a98:	83 ec 04             	sub    $0x4,%esp
  801a9b:	68 ac 23 80 00       	push   $0x8023ac
  801aa0:	6a 3a                	push   $0x3a
  801aa2:	68 a0 23 80 00       	push   $0x8023a0
  801aa7:	e8 8d fe ff ff       	call   801939 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801aac:	ff 45 f0             	incl   -0x10(%ebp)
  801aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ab5:	0f 8c 2f ff ff ff    	jl     8019ea <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801abb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ac2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ac9:	eb 26                	jmp    801af1 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801acb:	a1 20 30 80 00       	mov    0x803020,%eax
  801ad0:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  801ad6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ad9:	89 d0                	mov    %edx,%eax
  801adb:	01 c0                	add    %eax,%eax
  801add:	01 d0                	add    %edx,%eax
  801adf:	c1 e0 03             	shl    $0x3,%eax
  801ae2:	01 c8                	add    %ecx,%eax
  801ae4:	8a 40 04             	mov    0x4(%eax),%al
  801ae7:	3c 01                	cmp    $0x1,%al
  801ae9:	75 03                	jne    801aee <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801aeb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aee:	ff 45 e0             	incl   -0x20(%ebp)
  801af1:	a1 20 30 80 00       	mov    0x803020,%eax
  801af6:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  801afc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aff:	39 c2                	cmp    %eax,%edx
  801b01:	77 c8                	ja     801acb <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b06:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b09:	74 14                	je     801b1f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b0b:	83 ec 04             	sub    $0x4,%esp
  801b0e:	68 00 24 80 00       	push   $0x802400
  801b13:	6a 44                	push   $0x44
  801b15:	68 a0 23 80 00       	push   $0x8023a0
  801b1a:	e8 1a fe ff ff       	call   801939 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b1f:	90                   	nop
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    
  801b22:	66 90                	xchg   %ax,%ax

00801b24 <__udivdi3>:
  801b24:	55                   	push   %ebp
  801b25:	57                   	push   %edi
  801b26:	56                   	push   %esi
  801b27:	53                   	push   %ebx
  801b28:	83 ec 1c             	sub    $0x1c,%esp
  801b2b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b2f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b3b:	89 ca                	mov    %ecx,%edx
  801b3d:	89 f8                	mov    %edi,%eax
  801b3f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b43:	85 f6                	test   %esi,%esi
  801b45:	75 2d                	jne    801b74 <__udivdi3+0x50>
  801b47:	39 cf                	cmp    %ecx,%edi
  801b49:	77 65                	ja     801bb0 <__udivdi3+0x8c>
  801b4b:	89 fd                	mov    %edi,%ebp
  801b4d:	85 ff                	test   %edi,%edi
  801b4f:	75 0b                	jne    801b5c <__udivdi3+0x38>
  801b51:	b8 01 00 00 00       	mov    $0x1,%eax
  801b56:	31 d2                	xor    %edx,%edx
  801b58:	f7 f7                	div    %edi
  801b5a:	89 c5                	mov    %eax,%ebp
  801b5c:	31 d2                	xor    %edx,%edx
  801b5e:	89 c8                	mov    %ecx,%eax
  801b60:	f7 f5                	div    %ebp
  801b62:	89 c1                	mov    %eax,%ecx
  801b64:	89 d8                	mov    %ebx,%eax
  801b66:	f7 f5                	div    %ebp
  801b68:	89 cf                	mov    %ecx,%edi
  801b6a:	89 fa                	mov    %edi,%edx
  801b6c:	83 c4 1c             	add    $0x1c,%esp
  801b6f:	5b                   	pop    %ebx
  801b70:	5e                   	pop    %esi
  801b71:	5f                   	pop    %edi
  801b72:	5d                   	pop    %ebp
  801b73:	c3                   	ret    
  801b74:	39 ce                	cmp    %ecx,%esi
  801b76:	77 28                	ja     801ba0 <__udivdi3+0x7c>
  801b78:	0f bd fe             	bsr    %esi,%edi
  801b7b:	83 f7 1f             	xor    $0x1f,%edi
  801b7e:	75 40                	jne    801bc0 <__udivdi3+0x9c>
  801b80:	39 ce                	cmp    %ecx,%esi
  801b82:	72 0a                	jb     801b8e <__udivdi3+0x6a>
  801b84:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b88:	0f 87 9e 00 00 00    	ja     801c2c <__udivdi3+0x108>
  801b8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b93:	89 fa                	mov    %edi,%edx
  801b95:	83 c4 1c             	add    $0x1c,%esp
  801b98:	5b                   	pop    %ebx
  801b99:	5e                   	pop    %esi
  801b9a:	5f                   	pop    %edi
  801b9b:	5d                   	pop    %ebp
  801b9c:	c3                   	ret    
  801b9d:	8d 76 00             	lea    0x0(%esi),%esi
  801ba0:	31 ff                	xor    %edi,%edi
  801ba2:	31 c0                	xor    %eax,%eax
  801ba4:	89 fa                	mov    %edi,%edx
  801ba6:	83 c4 1c             	add    $0x1c,%esp
  801ba9:	5b                   	pop    %ebx
  801baa:	5e                   	pop    %esi
  801bab:	5f                   	pop    %edi
  801bac:	5d                   	pop    %ebp
  801bad:	c3                   	ret    
  801bae:	66 90                	xchg   %ax,%ax
  801bb0:	89 d8                	mov    %ebx,%eax
  801bb2:	f7 f7                	div    %edi
  801bb4:	31 ff                	xor    %edi,%edi
  801bb6:	89 fa                	mov    %edi,%edx
  801bb8:	83 c4 1c             	add    $0x1c,%esp
  801bbb:	5b                   	pop    %ebx
  801bbc:	5e                   	pop    %esi
  801bbd:	5f                   	pop    %edi
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    
  801bc0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bc5:	89 eb                	mov    %ebp,%ebx
  801bc7:	29 fb                	sub    %edi,%ebx
  801bc9:	89 f9                	mov    %edi,%ecx
  801bcb:	d3 e6                	shl    %cl,%esi
  801bcd:	89 c5                	mov    %eax,%ebp
  801bcf:	88 d9                	mov    %bl,%cl
  801bd1:	d3 ed                	shr    %cl,%ebp
  801bd3:	89 e9                	mov    %ebp,%ecx
  801bd5:	09 f1                	or     %esi,%ecx
  801bd7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bdb:	89 f9                	mov    %edi,%ecx
  801bdd:	d3 e0                	shl    %cl,%eax
  801bdf:	89 c5                	mov    %eax,%ebp
  801be1:	89 d6                	mov    %edx,%esi
  801be3:	88 d9                	mov    %bl,%cl
  801be5:	d3 ee                	shr    %cl,%esi
  801be7:	89 f9                	mov    %edi,%ecx
  801be9:	d3 e2                	shl    %cl,%edx
  801beb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bef:	88 d9                	mov    %bl,%cl
  801bf1:	d3 e8                	shr    %cl,%eax
  801bf3:	09 c2                	or     %eax,%edx
  801bf5:	89 d0                	mov    %edx,%eax
  801bf7:	89 f2                	mov    %esi,%edx
  801bf9:	f7 74 24 0c          	divl   0xc(%esp)
  801bfd:	89 d6                	mov    %edx,%esi
  801bff:	89 c3                	mov    %eax,%ebx
  801c01:	f7 e5                	mul    %ebp
  801c03:	39 d6                	cmp    %edx,%esi
  801c05:	72 19                	jb     801c20 <__udivdi3+0xfc>
  801c07:	74 0b                	je     801c14 <__udivdi3+0xf0>
  801c09:	89 d8                	mov    %ebx,%eax
  801c0b:	31 ff                	xor    %edi,%edi
  801c0d:	e9 58 ff ff ff       	jmp    801b6a <__udivdi3+0x46>
  801c12:	66 90                	xchg   %ax,%ax
  801c14:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c18:	89 f9                	mov    %edi,%ecx
  801c1a:	d3 e2                	shl    %cl,%edx
  801c1c:	39 c2                	cmp    %eax,%edx
  801c1e:	73 e9                	jae    801c09 <__udivdi3+0xe5>
  801c20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c23:	31 ff                	xor    %edi,%edi
  801c25:	e9 40 ff ff ff       	jmp    801b6a <__udivdi3+0x46>
  801c2a:	66 90                	xchg   %ax,%ax
  801c2c:	31 c0                	xor    %eax,%eax
  801c2e:	e9 37 ff ff ff       	jmp    801b6a <__udivdi3+0x46>
  801c33:	90                   	nop

00801c34 <__umoddi3>:
  801c34:	55                   	push   %ebp
  801c35:	57                   	push   %edi
  801c36:	56                   	push   %esi
  801c37:	53                   	push   %ebx
  801c38:	83 ec 1c             	sub    $0x1c,%esp
  801c3b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c47:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c4f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c53:	89 f3                	mov    %esi,%ebx
  801c55:	89 fa                	mov    %edi,%edx
  801c57:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c5b:	89 34 24             	mov    %esi,(%esp)
  801c5e:	85 c0                	test   %eax,%eax
  801c60:	75 1a                	jne    801c7c <__umoddi3+0x48>
  801c62:	39 f7                	cmp    %esi,%edi
  801c64:	0f 86 a2 00 00 00    	jbe    801d0c <__umoddi3+0xd8>
  801c6a:	89 c8                	mov    %ecx,%eax
  801c6c:	89 f2                	mov    %esi,%edx
  801c6e:	f7 f7                	div    %edi
  801c70:	89 d0                	mov    %edx,%eax
  801c72:	31 d2                	xor    %edx,%edx
  801c74:	83 c4 1c             	add    $0x1c,%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5e                   	pop    %esi
  801c79:	5f                   	pop    %edi
  801c7a:	5d                   	pop    %ebp
  801c7b:	c3                   	ret    
  801c7c:	39 f0                	cmp    %esi,%eax
  801c7e:	0f 87 ac 00 00 00    	ja     801d30 <__umoddi3+0xfc>
  801c84:	0f bd e8             	bsr    %eax,%ebp
  801c87:	83 f5 1f             	xor    $0x1f,%ebp
  801c8a:	0f 84 ac 00 00 00    	je     801d3c <__umoddi3+0x108>
  801c90:	bf 20 00 00 00       	mov    $0x20,%edi
  801c95:	29 ef                	sub    %ebp,%edi
  801c97:	89 fe                	mov    %edi,%esi
  801c99:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c9d:	89 e9                	mov    %ebp,%ecx
  801c9f:	d3 e0                	shl    %cl,%eax
  801ca1:	89 d7                	mov    %edx,%edi
  801ca3:	89 f1                	mov    %esi,%ecx
  801ca5:	d3 ef                	shr    %cl,%edi
  801ca7:	09 c7                	or     %eax,%edi
  801ca9:	89 e9                	mov    %ebp,%ecx
  801cab:	d3 e2                	shl    %cl,%edx
  801cad:	89 14 24             	mov    %edx,(%esp)
  801cb0:	89 d8                	mov    %ebx,%eax
  801cb2:	d3 e0                	shl    %cl,%eax
  801cb4:	89 c2                	mov    %eax,%edx
  801cb6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cba:	d3 e0                	shl    %cl,%eax
  801cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cc4:	89 f1                	mov    %esi,%ecx
  801cc6:	d3 e8                	shr    %cl,%eax
  801cc8:	09 d0                	or     %edx,%eax
  801cca:	d3 eb                	shr    %cl,%ebx
  801ccc:	89 da                	mov    %ebx,%edx
  801cce:	f7 f7                	div    %edi
  801cd0:	89 d3                	mov    %edx,%ebx
  801cd2:	f7 24 24             	mull   (%esp)
  801cd5:	89 c6                	mov    %eax,%esi
  801cd7:	89 d1                	mov    %edx,%ecx
  801cd9:	39 d3                	cmp    %edx,%ebx
  801cdb:	0f 82 87 00 00 00    	jb     801d68 <__umoddi3+0x134>
  801ce1:	0f 84 91 00 00 00    	je     801d78 <__umoddi3+0x144>
  801ce7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ceb:	29 f2                	sub    %esi,%edx
  801ced:	19 cb                	sbb    %ecx,%ebx
  801cef:	89 d8                	mov    %ebx,%eax
  801cf1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cf5:	d3 e0                	shl    %cl,%eax
  801cf7:	89 e9                	mov    %ebp,%ecx
  801cf9:	d3 ea                	shr    %cl,%edx
  801cfb:	09 d0                	or     %edx,%eax
  801cfd:	89 e9                	mov    %ebp,%ecx
  801cff:	d3 eb                	shr    %cl,%ebx
  801d01:	89 da                	mov    %ebx,%edx
  801d03:	83 c4 1c             	add    $0x1c,%esp
  801d06:	5b                   	pop    %ebx
  801d07:	5e                   	pop    %esi
  801d08:	5f                   	pop    %edi
  801d09:	5d                   	pop    %ebp
  801d0a:	c3                   	ret    
  801d0b:	90                   	nop
  801d0c:	89 fd                	mov    %edi,%ebp
  801d0e:	85 ff                	test   %edi,%edi
  801d10:	75 0b                	jne    801d1d <__umoddi3+0xe9>
  801d12:	b8 01 00 00 00       	mov    $0x1,%eax
  801d17:	31 d2                	xor    %edx,%edx
  801d19:	f7 f7                	div    %edi
  801d1b:	89 c5                	mov    %eax,%ebp
  801d1d:	89 f0                	mov    %esi,%eax
  801d1f:	31 d2                	xor    %edx,%edx
  801d21:	f7 f5                	div    %ebp
  801d23:	89 c8                	mov    %ecx,%eax
  801d25:	f7 f5                	div    %ebp
  801d27:	89 d0                	mov    %edx,%eax
  801d29:	e9 44 ff ff ff       	jmp    801c72 <__umoddi3+0x3e>
  801d2e:	66 90                	xchg   %ax,%ax
  801d30:	89 c8                	mov    %ecx,%eax
  801d32:	89 f2                	mov    %esi,%edx
  801d34:	83 c4 1c             	add    $0x1c,%esp
  801d37:	5b                   	pop    %ebx
  801d38:	5e                   	pop    %esi
  801d39:	5f                   	pop    %edi
  801d3a:	5d                   	pop    %ebp
  801d3b:	c3                   	ret    
  801d3c:	3b 04 24             	cmp    (%esp),%eax
  801d3f:	72 06                	jb     801d47 <__umoddi3+0x113>
  801d41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d45:	77 0f                	ja     801d56 <__umoddi3+0x122>
  801d47:	89 f2                	mov    %esi,%edx
  801d49:	29 f9                	sub    %edi,%ecx
  801d4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d4f:	89 14 24             	mov    %edx,(%esp)
  801d52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d56:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d5a:	8b 14 24             	mov    (%esp),%edx
  801d5d:	83 c4 1c             	add    $0x1c,%esp
  801d60:	5b                   	pop    %ebx
  801d61:	5e                   	pop    %esi
  801d62:	5f                   	pop    %edi
  801d63:	5d                   	pop    %ebp
  801d64:	c3                   	ret    
  801d65:	8d 76 00             	lea    0x0(%esi),%esi
  801d68:	2b 04 24             	sub    (%esp),%eax
  801d6b:	19 fa                	sbb    %edi,%edx
  801d6d:	89 d1                	mov    %edx,%ecx
  801d6f:	89 c6                	mov    %eax,%esi
  801d71:	e9 71 ff ff ff       	jmp    801ce7 <__umoddi3+0xb3>
  801d76:	66 90                	xchg   %ax,%ax
  801d78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d7c:	72 ea                	jb     801d68 <__umoddi3+0x134>
  801d7e:	89 d9                	mov    %ebx,%ecx
  801d80:	e9 62 ff ff ff       	jmp    801ce7 <__umoddi3+0xb3>
