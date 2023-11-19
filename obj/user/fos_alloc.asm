
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
  80004b:	e8 2d 11 00 00       	call   80117d <malloc>
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
  8000d7:	e8 cf 10 00 00       	call   8011ab <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 93 10 00 00       	call   80117d <malloc>
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
  80012d:	e8 79 10 00 00       	call   8011ab <free>
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
  80013e:	e8 df 14 00 00       	call   801622 <sys_getenvindex>
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
  8001b2:	e8 78 12 00 00       	call   80142f <sys_disable_interrupt>
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
  80024c:	e8 f8 11 00 00       	call   801449 <sys_enable_interrupt>

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
  800264:	e8 85 13 00 00       	call   8015ee <sys_destroy_env>
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
  800275:	e8 da 13 00 00       	call   801654 <sys_exit_env>
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
  8002c3:	e8 0e 10 00 00       	call   8012d6 <sys_cputs>
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
  80033a:	e8 97 0f 00 00       	call   8012d6 <sys_cputs>
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
  800384:	e8 a6 10 00 00       	call   80142f <sys_disable_interrupt>
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
  8003a4:	e8 a0 10 00 00       	call   801449 <sys_enable_interrupt>
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
  8003ee:	e8 3d 17 00 00       	call   801b30 <__udivdi3>
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
  80043e:	e8 fd 17 00 00       	call   801c40 <__umoddi3>
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

int i=0;
void *
memset(void *v, int c, uint32 n)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 10             	sub    $0x10,%esp


	i++;
  800bc7:	a1 28 30 80 00       	mov    0x803028,%eax
  800bcc:	40                   	inc    %eax
  800bcd:	a3 28 30 80 00       	mov    %eax,0x803028

	char *p;
	int m;

	p = v;
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdb:	89 45 f8             	mov    %eax,-0x8(%ebp)


	while (--m >= 0){
  800bde:	eb 0e                	jmp    800bee <memset+0x2d>

		*p++ = c;
  800be0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be3:	8d 50 01             	lea    0x1(%eax),%edx
  800be6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800be9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bec:	88 10                	mov    %dl,(%eax)

	p = v;
	m = n;


	while (--m >= 0){
  800bee:	ff 4d f8             	decl   -0x8(%ebp)
  800bf1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bf5:	79 e9                	jns    800be0 <memset+0x1f>

		*p++ = c;
	}

	return v;
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c0e:	eb 16                	jmp    800c26 <memcpy+0x2a>
		*d++ = *s++;
  800c10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c13:	8d 50 01             	lea    0x1(%eax),%edx
  800c16:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c19:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c1f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c22:	8a 12                	mov    (%edx),%dl
  800c24:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c26:	8b 45 10             	mov    0x10(%ebp),%eax
  800c29:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c2c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c2f:	85 c0                	test   %eax,%eax
  800c31:	75 dd                	jne    800c10 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c36:	c9                   	leave  
  800c37:	c3                   	ret    

00800c38 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c4d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c50:	73 50                	jae    800ca2 <memmove+0x6a>
  800c52:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c55:	8b 45 10             	mov    0x10(%ebp),%eax
  800c58:	01 d0                	add    %edx,%eax
  800c5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c5d:	76 43                	jbe    800ca2 <memmove+0x6a>
		s += n;
  800c5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c62:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c65:	8b 45 10             	mov    0x10(%ebp),%eax
  800c68:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c6b:	eb 10                	jmp    800c7d <memmove+0x45>
			*--d = *--s;
  800c6d:	ff 4d f8             	decl   -0x8(%ebp)
  800c70:	ff 4d fc             	decl   -0x4(%ebp)
  800c73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c76:	8a 10                	mov    (%eax),%dl
  800c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c83:	89 55 10             	mov    %edx,0x10(%ebp)
  800c86:	85 c0                	test   %eax,%eax
  800c88:	75 e3                	jne    800c6d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c8a:	eb 23                	jmp    800caf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c8f:	8d 50 01             	lea    0x1(%eax),%edx
  800c92:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c98:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c9b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c9e:	8a 12                	mov    (%edx),%dl
  800ca0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ca2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca8:	89 55 10             	mov    %edx,0x10(%ebp)
  800cab:	85 c0                	test   %eax,%eax
  800cad:	75 dd                	jne    800c8c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cc6:	eb 2a                	jmp    800cf2 <memcmp+0x3e>
		if (*s1 != *s2)
  800cc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccb:	8a 10                	mov    (%eax),%dl
  800ccd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd0:	8a 00                	mov    (%eax),%al
  800cd2:	38 c2                	cmp    %al,%dl
  800cd4:	74 16                	je     800cec <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	0f b6 d0             	movzbl %al,%edx
  800cde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce1:	8a 00                	mov    (%eax),%al
  800ce3:	0f b6 c0             	movzbl %al,%eax
  800ce6:	29 c2                	sub    %eax,%edx
  800ce8:	89 d0                	mov    %edx,%eax
  800cea:	eb 18                	jmp    800d04 <memcmp+0x50>
		s1++, s2++;
  800cec:	ff 45 fc             	incl   -0x4(%ebp)
  800cef:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cf2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cf8:	89 55 10             	mov    %edx,0x10(%ebp)
  800cfb:	85 c0                	test   %eax,%eax
  800cfd:	75 c9                	jne    800cc8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d12:	01 d0                	add    %edx,%eax
  800d14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d17:	eb 15                	jmp    800d2e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 00                	mov    (%eax),%al
  800d1e:	0f b6 d0             	movzbl %al,%edx
  800d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d24:	0f b6 c0             	movzbl %al,%eax
  800d27:	39 c2                	cmp    %eax,%edx
  800d29:	74 0d                	je     800d38 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d2b:	ff 45 08             	incl   0x8(%ebp)
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d34:	72 e3                	jb     800d19 <memfind+0x13>
  800d36:	eb 01                	jmp    800d39 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d38:	90                   	nop
	return (void *) s;
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d3c:	c9                   	leave  
  800d3d:	c3                   	ret    

00800d3e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d4b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d52:	eb 03                	jmp    800d57 <strtol+0x19>
		s++;
  800d54:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	3c 20                	cmp    $0x20,%al
  800d5e:	74 f4                	je     800d54 <strtol+0x16>
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	3c 09                	cmp    $0x9,%al
  800d67:	74 eb                	je     800d54 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	3c 2b                	cmp    $0x2b,%al
  800d70:	75 05                	jne    800d77 <strtol+0x39>
		s++;
  800d72:	ff 45 08             	incl   0x8(%ebp)
  800d75:	eb 13                	jmp    800d8a <strtol+0x4c>
	else if (*s == '-')
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3c 2d                	cmp    $0x2d,%al
  800d7e:	75 0a                	jne    800d8a <strtol+0x4c>
		s++, neg = 1;
  800d80:	ff 45 08             	incl   0x8(%ebp)
  800d83:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8e:	74 06                	je     800d96 <strtol+0x58>
  800d90:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d94:	75 20                	jne    800db6 <strtol+0x78>
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3c 30                	cmp    $0x30,%al
  800d9d:	75 17                	jne    800db6 <strtol+0x78>
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	40                   	inc    %eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	3c 78                	cmp    $0x78,%al
  800da7:	75 0d                	jne    800db6 <strtol+0x78>
		s += 2, base = 16;
  800da9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dad:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800db4:	eb 28                	jmp    800dde <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800db6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dba:	75 15                	jne    800dd1 <strtol+0x93>
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	3c 30                	cmp    $0x30,%al
  800dc3:	75 0c                	jne    800dd1 <strtol+0x93>
		s++, base = 8;
  800dc5:	ff 45 08             	incl   0x8(%ebp)
  800dc8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dcf:	eb 0d                	jmp    800dde <strtol+0xa0>
	else if (base == 0)
  800dd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd5:	75 07                	jne    800dde <strtol+0xa0>
		base = 10;
  800dd7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	3c 2f                	cmp    $0x2f,%al
  800de5:	7e 19                	jle    800e00 <strtol+0xc2>
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	3c 39                	cmp    $0x39,%al
  800dee:	7f 10                	jg     800e00 <strtol+0xc2>
			dig = *s - '0';
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	0f be c0             	movsbl %al,%eax
  800df8:	83 e8 30             	sub    $0x30,%eax
  800dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dfe:	eb 42                	jmp    800e42 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	3c 60                	cmp    $0x60,%al
  800e07:	7e 19                	jle    800e22 <strtol+0xe4>
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	3c 7a                	cmp    $0x7a,%al
  800e10:	7f 10                	jg     800e22 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	8a 00                	mov    (%eax),%al
  800e17:	0f be c0             	movsbl %al,%eax
  800e1a:	83 e8 57             	sub    $0x57,%eax
  800e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e20:	eb 20                	jmp    800e42 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	8a 00                	mov    (%eax),%al
  800e27:	3c 40                	cmp    $0x40,%al
  800e29:	7e 39                	jle    800e64 <strtol+0x126>
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	3c 5a                	cmp    $0x5a,%al
  800e32:	7f 30                	jg     800e64 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 00                	mov    (%eax),%al
  800e39:	0f be c0             	movsbl %al,%eax
  800e3c:	83 e8 37             	sub    $0x37,%eax
  800e3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e45:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e48:	7d 19                	jge    800e63 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e4a:	ff 45 08             	incl   0x8(%ebp)
  800e4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e50:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e54:	89 c2                	mov    %eax,%edx
  800e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e59:	01 d0                	add    %edx,%eax
  800e5b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e5e:	e9 7b ff ff ff       	jmp    800dde <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e63:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e68:	74 08                	je     800e72 <strtol+0x134>
		*endptr = (char *) s;
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e70:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e72:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e76:	74 07                	je     800e7f <strtol+0x141>
  800e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7b:	f7 d8                	neg    %eax
  800e7d:	eb 03                	jmp    800e82 <strtol+0x144>
  800e7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e82:	c9                   	leave  
  800e83:	c3                   	ret    

00800e84 <ltostr>:

void
ltostr(long value, char *str)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
  800e87:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e91:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e9c:	79 13                	jns    800eb1 <ltostr+0x2d>
	{
		neg = 1;
  800e9e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eab:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800eae:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800eb9:	99                   	cltd   
  800eba:	f7 f9                	idiv   %ecx
  800ebc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ebf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec2:	8d 50 01             	lea    0x1(%eax),%edx
  800ec5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec8:	89 c2                	mov    %eax,%edx
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	01 d0                	add    %edx,%eax
  800ecf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ed2:	83 c2 30             	add    $0x30,%edx
  800ed5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ed7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eda:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800edf:	f7 e9                	imul   %ecx
  800ee1:	c1 fa 02             	sar    $0x2,%edx
  800ee4:	89 c8                	mov    %ecx,%eax
  800ee6:	c1 f8 1f             	sar    $0x1f,%eax
  800ee9:	29 c2                	sub    %eax,%edx
  800eeb:	89 d0                	mov    %edx,%eax
  800eed:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800ef0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ef8:	f7 e9                	imul   %ecx
  800efa:	c1 fa 02             	sar    $0x2,%edx
  800efd:	89 c8                	mov    %ecx,%eax
  800eff:	c1 f8 1f             	sar    $0x1f,%eax
  800f02:	29 c2                	sub    %eax,%edx
  800f04:	89 d0                	mov    %edx,%eax
  800f06:	c1 e0 02             	shl    $0x2,%eax
  800f09:	01 d0                	add    %edx,%eax
  800f0b:	01 c0                	add    %eax,%eax
  800f0d:	29 c1                	sub    %eax,%ecx
  800f0f:	89 ca                	mov    %ecx,%edx
  800f11:	85 d2                	test   %edx,%edx
  800f13:	75 9c                	jne    800eb1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1f:	48                   	dec    %eax
  800f20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f23:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f27:	74 3d                	je     800f66 <ltostr+0xe2>
		start = 1 ;
  800f29:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f30:	eb 34                	jmp    800f66 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	01 d0                	add    %edx,%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	01 c2                	add    %eax,%edx
  800f47:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4d:	01 c8                	add    %ecx,%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	01 c2                	add    %eax,%edx
  800f5b:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f5e:	88 02                	mov    %al,(%edx)
		start++ ;
  800f60:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f63:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f6c:	7c c4                	jl     800f32 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f6e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	01 d0                	add    %edx,%eax
  800f76:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f79:	90                   	nop
  800f7a:	c9                   	leave  
  800f7b:	c3                   	ret    

00800f7c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f82:	ff 75 08             	pushl  0x8(%ebp)
  800f85:	e8 49 fa ff ff       	call   8009d3 <strlen>
  800f8a:	83 c4 04             	add    $0x4,%esp
  800f8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	e8 3b fa ff ff       	call   8009d3 <strlen>
  800f98:	83 c4 04             	add    $0x4,%esp
  800f9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fac:	eb 17                	jmp    800fc5 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 c2                	add    %eax,%edx
  800fb6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	01 c8                	add    %ecx,%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fc2:	ff 45 fc             	incl   -0x4(%ebp)
  800fc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fcb:	7c e1                	jl     800fae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fcd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fd4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fdb:	eb 1f                	jmp    800ffc <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe0:	8d 50 01             	lea    0x1(%eax),%edx
  800fe3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fe6:	89 c2                	mov    %eax,%edx
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  800feb:	01 c2                	add    %eax,%edx
  800fed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	01 c8                	add    %ecx,%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800ff9:	ff 45 f8             	incl   -0x8(%ebp)
  800ffc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801002:	7c d9                	jl     800fdd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801004:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	01 d0                	add    %edx,%eax
  80100c:	c6 00 00             	movb   $0x0,(%eax)
}
  80100f:	90                   	nop
  801010:	c9                   	leave  
  801011:	c3                   	ret    

00801012 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801015:	8b 45 14             	mov    0x14(%ebp),%eax
  801018:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80101e:	8b 45 14             	mov    0x14(%ebp),%eax
  801021:	8b 00                	mov    (%eax),%eax
  801023:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80102a:	8b 45 10             	mov    0x10(%ebp),%eax
  80102d:	01 d0                	add    %edx,%eax
  80102f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801035:	eb 0c                	jmp    801043 <strsplit+0x31>
			*string++ = 0;
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8d 50 01             	lea    0x1(%eax),%edx
  80103d:	89 55 08             	mov    %edx,0x8(%ebp)
  801040:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	84 c0                	test   %al,%al
  80104a:	74 18                	je     801064 <strsplit+0x52>
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	0f be c0             	movsbl %al,%eax
  801054:	50                   	push   %eax
  801055:	ff 75 0c             	pushl  0xc(%ebp)
  801058:	e8 08 fb ff ff       	call   800b65 <strchr>
  80105d:	83 c4 08             	add    $0x8,%esp
  801060:	85 c0                	test   %eax,%eax
  801062:	75 d3                	jne    801037 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	8a 00                	mov    (%eax),%al
  801069:	84 c0                	test   %al,%al
  80106b:	74 5a                	je     8010c7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80106d:	8b 45 14             	mov    0x14(%ebp),%eax
  801070:	8b 00                	mov    (%eax),%eax
  801072:	83 f8 0f             	cmp    $0xf,%eax
  801075:	75 07                	jne    80107e <strsplit+0x6c>
		{
			return 0;
  801077:	b8 00 00 00 00       	mov    $0x0,%eax
  80107c:	eb 66                	jmp    8010e4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80107e:	8b 45 14             	mov    0x14(%ebp),%eax
  801081:	8b 00                	mov    (%eax),%eax
  801083:	8d 48 01             	lea    0x1(%eax),%ecx
  801086:	8b 55 14             	mov    0x14(%ebp),%edx
  801089:	89 0a                	mov    %ecx,(%edx)
  80108b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801092:	8b 45 10             	mov    0x10(%ebp),%eax
  801095:	01 c2                	add    %eax,%edx
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80109c:	eb 03                	jmp    8010a1 <strsplit+0x8f>
			string++;
  80109e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	84 c0                	test   %al,%al
  8010a8:	74 8b                	je     801035 <strsplit+0x23>
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	0f be c0             	movsbl %al,%eax
  8010b2:	50                   	push   %eax
  8010b3:	ff 75 0c             	pushl  0xc(%ebp)
  8010b6:	e8 aa fa ff ff       	call   800b65 <strchr>
  8010bb:	83 c4 08             	add    $0x8,%esp
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	74 dc                	je     80109e <strsplit+0x8c>
			string++;
	}
  8010c2:	e9 6e ff ff ff       	jmp    801035 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010c7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010cb:	8b 00                	mov    (%eax),%eax
  8010cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010df:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    

008010e6 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
  8010ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f0:	74 06                	je     8010f8 <str2lower+0x12>
  8010f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010f6:	75 07                	jne    8010ff <str2lower+0x19>
		return NULL;
  8010f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fd:	eb 4d                	jmp    80114c <str2lower+0x66>
	}
	char *ref=dst;
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(*src!='\0'){
  801105:	eb 33                	jmp    80113a <str2lower+0x54>
			if(*src>=65&&*src<=90){
  801107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	3c 40                	cmp    $0x40,%al
  80110e:	7e 1a                	jle    80112a <str2lower+0x44>
  801110:	8b 45 0c             	mov    0xc(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	3c 5a                	cmp    $0x5a,%al
  801117:	7f 11                	jg     80112a <str2lower+0x44>
				*dst=*src+32;
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	83 c0 20             	add    $0x20,%eax
  801121:	88 c2                	mov    %al,%dl
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	88 10                	mov    %dl,(%eax)
  801128:	eb 0a                	jmp    801134 <str2lower+0x4e>
			}
			else{
				*dst=*src;
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	8a 10                	mov    (%eax),%dl
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	88 10                	mov    %dl,(%eax)
			}
			src++;
  801134:	ff 45 0c             	incl   0xc(%ebp)
			dst++;
  801137:	ff 45 08             	incl   0x8(%ebp)
	//panic("process_command is not implemented yet");
	if(src==NULL||dst==NULL){
		return NULL;
	}
	char *ref=dst;
		while(*src!='\0'){
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	84 c0                	test   %al,%al
  801141:	75 c4                	jne    801107 <str2lower+0x21>
				*dst=*src;
			}
			src++;
			dst++;
		}
		*dst='\0';
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	c6 00 00             	movb   $0x0,(%eax)
		return ref;
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
	if(FirstTimeFlag)
  801151:	a1 04 30 80 00       	mov    0x803004,%eax
  801156:	85 c0                	test   %eax,%eax
  801158:	74 0a                	je     801164 <InitializeUHeap+0x16>
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80115a:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801161:	00 00 00 
	}
}
  801164:	90                   	nop
  801165:	5d                   	pop    %ebp
  801166:	c3                   	ret    

00801167 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80116d:	83 ec 0c             	sub    $0xc,%esp
  801170:	ff 75 08             	pushl  0x8(%ebp)
  801173:	e8 79 07 00 00       	call   8018f1 <sys_sbrk>
  801178:	83 c4 10             	add    $0x10,%esp
}
  80117b:	c9                   	leave  
  80117c:	c3                   	ret    

0080117d <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801183:	e8 c6 ff ff ff       	call   80114e <InitializeUHeap>
	if (size == 0) return NULL ;
  801188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80118c:	75 07                	jne    801195 <malloc+0x18>
  80118e:	b8 00 00 00 00       	mov    $0x0,%eax
  801193:	eb 14                	jmp    8011a9 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801195:	83 ec 04             	sub    $0x4,%esp
  801198:	68 30 22 80 00       	push   $0x802230
  80119d:	6a 2d                	push   $0x2d
  80119f:	68 55 22 80 00       	push   $0x802255
  8011a4:	e8 9b 07 00 00       	call   801944 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8011b1:	83 ec 04             	sub    $0x4,%esp
  8011b4:	68 64 22 80 00       	push   $0x802264
  8011b9:	6a 3b                	push   $0x3b
  8011bb:	68 55 22 80 00       	push   $0x802255
  8011c0:	e8 7f 07 00 00       	call   801944 <_panic>

008011c5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 18             	sub    $0x18,%esp
  8011cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ce:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8011d1:	e8 78 ff ff ff       	call   80114e <InitializeUHeap>
	if (size == 0) return NULL ;
  8011d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011da:	75 07                	jne    8011e3 <smalloc+0x1e>
  8011dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e1:	eb 14                	jmp    8011f7 <smalloc+0x32>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  8011e3:	83 ec 04             	sub    $0x4,%esp
  8011e6:	68 88 22 80 00       	push   $0x802288
  8011eb:	6a 49                	push   $0x49
  8011ed:	68 55 22 80 00       	push   $0x802255
  8011f2:	e8 4d 07 00 00       	call   801944 <_panic>
	return NULL;
}
  8011f7:	c9                   	leave  
  8011f8:	c3                   	ret    

008011f9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8011ff:	e8 4a ff ff ff       	call   80114e <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801204:	83 ec 04             	sub    $0x4,%esp
  801207:	68 b0 22 80 00       	push   $0x8022b0
  80120c:	6a 57                	push   $0x57
  80120e:	68 55 22 80 00       	push   $0x802255
  801213:	e8 2c 07 00 00       	call   801944 <_panic>

00801218 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80121e:	e8 2b ff ff ff       	call   80114e <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT'23.MS2 - BONUS] [2] USER HEAP - realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801223:	83 ec 04             	sub    $0x4,%esp
  801226:	68 d4 22 80 00       	push   $0x8022d4
  80122b:	6a 78                	push   $0x78
  80122d:	68 55 22 80 00       	push   $0x802255
  801232:	e8 0d 07 00 00       	call   801944 <_panic>

00801237 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80123d:	83 ec 04             	sub    $0x4,%esp
  801240:	68 fc 22 80 00       	push   $0x8022fc
  801245:	68 8c 00 00 00       	push   $0x8c
  80124a:	68 55 22 80 00       	push   $0x802255
  80124f:	e8 f0 06 00 00       	call   801944 <_panic>

00801254 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80125a:	83 ec 04             	sub    $0x4,%esp
  80125d:	68 20 23 80 00       	push   $0x802320
  801262:	68 96 00 00 00       	push   $0x96
  801267:	68 55 22 80 00       	push   $0x802255
  80126c:	e8 d3 06 00 00       	call   801944 <_panic>

00801271 <shrink>:

}
void shrink(uint32 newSize)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801277:	83 ec 04             	sub    $0x4,%esp
  80127a:	68 20 23 80 00       	push   $0x802320
  80127f:	68 9b 00 00 00       	push   $0x9b
  801284:	68 55 22 80 00       	push   $0x802255
  801289:	e8 b6 06 00 00       	call   801944 <_panic>

0080128e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801294:	83 ec 04             	sub    $0x4,%esp
  801297:	68 20 23 80 00       	push   $0x802320
  80129c:	68 a0 00 00 00       	push   $0xa0
  8012a1:	68 55 22 80 00       	push   $0x802255
  8012a6:	e8 99 06 00 00       	call   801944 <_panic>

008012ab <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
  8012ae:	57                   	push   %edi
  8012af:	56                   	push   %esi
  8012b0:	53                   	push   %ebx
  8012b1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012c0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012c3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012c6:	cd 30                	int    $0x30
  8012c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ce:	83 c4 10             	add    $0x10,%esp
  8012d1:	5b                   	pop    %ebx
  8012d2:	5e                   	pop    %esi
  8012d3:	5f                   	pop    %edi
  8012d4:	5d                   	pop    %ebp
  8012d5:	c3                   	ret    

008012d6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	83 ec 04             	sub    $0x4,%esp
  8012dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012e2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	52                   	push   %edx
  8012ee:	ff 75 0c             	pushl  0xc(%ebp)
  8012f1:	50                   	push   %eax
  8012f2:	6a 00                	push   $0x0
  8012f4:	e8 b2 ff ff ff       	call   8012ab <syscall>
  8012f9:	83 c4 18             	add    $0x18,%esp
}
  8012fc:	90                   	nop
  8012fd:	c9                   	leave  
  8012fe:	c3                   	ret    

008012ff <sys_cgetc>:

int
sys_cgetc(void)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801302:	6a 00                	push   $0x0
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 00                	push   $0x0
  80130c:	6a 01                	push   $0x1
  80130e:	e8 98 ff ff ff       	call   8012ab <syscall>
  801313:	83 c4 18             	add    $0x18,%esp
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80131b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	52                   	push   %edx
  801328:	50                   	push   %eax
  801329:	6a 05                	push   $0x5
  80132b:	e8 7b ff ff ff       	call   8012ab <syscall>
  801330:	83 c4 18             	add    $0x18,%esp
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	56                   	push   %esi
  801339:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80133a:	8b 75 18             	mov    0x18(%ebp),%esi
  80133d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801340:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801343:	8b 55 0c             	mov    0xc(%ebp),%edx
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	56                   	push   %esi
  80134a:	53                   	push   %ebx
  80134b:	51                   	push   %ecx
  80134c:	52                   	push   %edx
  80134d:	50                   	push   %eax
  80134e:	6a 06                	push   $0x6
  801350:	e8 56 ff ff ff       	call   8012ab <syscall>
  801355:	83 c4 18             	add    $0x18,%esp
}
  801358:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80135b:	5b                   	pop    %ebx
  80135c:	5e                   	pop    %esi
  80135d:	5d                   	pop    %ebp
  80135e:	c3                   	ret    

0080135f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801362:	8b 55 0c             	mov    0xc(%ebp),%edx
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	52                   	push   %edx
  80136f:	50                   	push   %eax
  801370:	6a 07                	push   $0x7
  801372:	e8 34 ff ff ff       	call   8012ab <syscall>
  801377:	83 c4 18             	add    $0x18,%esp
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	ff 75 0c             	pushl  0xc(%ebp)
  801388:	ff 75 08             	pushl  0x8(%ebp)
  80138b:	6a 08                	push   $0x8
  80138d:	e8 19 ff ff ff       	call   8012ab <syscall>
  801392:	83 c4 18             	add    $0x18,%esp
}
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 09                	push   $0x9
  8013a6:	e8 00 ff ff ff       	call   8012ab <syscall>
  8013ab:	83 c4 18             	add    $0x18,%esp
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 0a                	push   $0xa
  8013bf:	e8 e7 fe ff ff       	call   8012ab <syscall>
  8013c4:	83 c4 18             	add    $0x18,%esp
}
  8013c7:	c9                   	leave  
  8013c8:	c3                   	ret    

008013c9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 0b                	push   $0xb
  8013d8:	e8 ce fe ff ff       	call   8012ab <syscall>
  8013dd:	83 c4 18             	add    $0x18,%esp
}
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 0c                	push   $0xc
  8013f1:	e8 b5 fe ff ff       	call   8012ab <syscall>
  8013f6:	83 c4 18             	add    $0x18,%esp
}
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	ff 75 08             	pushl  0x8(%ebp)
  801409:	6a 0d                	push   $0xd
  80140b:	e8 9b fe ff ff       	call   8012ab <syscall>
  801410:	83 c4 18             	add    $0x18,%esp
}
  801413:	c9                   	leave  
  801414:	c3                   	ret    

00801415 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 0e                	push   $0xe
  801424:	e8 82 fe ff ff       	call   8012ab <syscall>
  801429:	83 c4 18             	add    $0x18,%esp
}
  80142c:	90                   	nop
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    

0080142f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 11                	push   $0x11
  80143e:	e8 68 fe ff ff       	call   8012ab <syscall>
  801443:	83 c4 18             	add    $0x18,%esp
}
  801446:	90                   	nop
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 12                	push   $0x12
  801458:	e8 4e fe ff ff       	call   8012ab <syscall>
  80145d:	83 c4 18             	add    $0x18,%esp
}
  801460:	90                   	nop
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <sys_cputc>:


void
sys_cputc(const char c)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 04             	sub    $0x4,%esp
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80146f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	50                   	push   %eax
  80147c:	6a 13                	push   $0x13
  80147e:	e8 28 fe ff ff       	call   8012ab <syscall>
  801483:	83 c4 18             	add    $0x18,%esp
}
  801486:	90                   	nop
  801487:	c9                   	leave  
  801488:	c3                   	ret    

00801489 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	6a 14                	push   $0x14
  801498:	e8 0e fe ff ff       	call   8012ab <syscall>
  80149d:	83 c4 18             	add    $0x18,%esp
}
  8014a0:	90                   	nop
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	ff 75 0c             	pushl  0xc(%ebp)
  8014b2:	50                   	push   %eax
  8014b3:	6a 15                	push   $0x15
  8014b5:	e8 f1 fd ff ff       	call   8012ab <syscall>
  8014ba:	83 c4 18             	add    $0x18,%esp
}
  8014bd:	c9                   	leave  
  8014be:	c3                   	ret    

008014bf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	52                   	push   %edx
  8014cf:	50                   	push   %eax
  8014d0:	6a 18                	push   $0x18
  8014d2:	e8 d4 fd ff ff       	call   8012ab <syscall>
  8014d7:	83 c4 18             	add    $0x18,%esp
}
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	52                   	push   %edx
  8014ec:	50                   	push   %eax
  8014ed:	6a 16                	push   $0x16
  8014ef:	e8 b7 fd ff ff       	call   8012ab <syscall>
  8014f4:	83 c4 18             	add    $0x18,%esp
}
  8014f7:	90                   	nop
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	52                   	push   %edx
  80150a:	50                   	push   %eax
  80150b:	6a 17                	push   $0x17
  80150d:	e8 99 fd ff ff       	call   8012ab <syscall>
  801512:	83 c4 18             	add    $0x18,%esp
}
  801515:	90                   	nop
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	83 ec 04             	sub    $0x4,%esp
  80151e:	8b 45 10             	mov    0x10(%ebp),%eax
  801521:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801524:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801527:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	6a 00                	push   $0x0
  801530:	51                   	push   %ecx
  801531:	52                   	push   %edx
  801532:	ff 75 0c             	pushl  0xc(%ebp)
  801535:	50                   	push   %eax
  801536:	6a 19                	push   $0x19
  801538:	e8 6e fd ff ff       	call   8012ab <syscall>
  80153d:	83 c4 18             	add    $0x18,%esp
}
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801545:	8b 55 0c             	mov    0xc(%ebp),%edx
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	52                   	push   %edx
  801552:	50                   	push   %eax
  801553:	6a 1a                	push   $0x1a
  801555:	e8 51 fd ff ff       	call   8012ab <syscall>
  80155a:	83 c4 18             	add    $0x18,%esp
}
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801562:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801565:	8b 55 0c             	mov    0xc(%ebp),%edx
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	51                   	push   %ecx
  801570:	52                   	push   %edx
  801571:	50                   	push   %eax
  801572:	6a 1b                	push   $0x1b
  801574:	e8 32 fd ff ff       	call   8012ab <syscall>
  801579:	83 c4 18             	add    $0x18,%esp
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801581:	8b 55 0c             	mov    0xc(%ebp),%edx
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	52                   	push   %edx
  80158e:	50                   	push   %eax
  80158f:	6a 1c                	push   $0x1c
  801591:	e8 15 fd ff ff       	call   8012ab <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 1d                	push   $0x1d
  8015aa:	e8 fc fc ff ff       	call   8012ab <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	6a 00                	push   $0x0
  8015bc:	ff 75 14             	pushl  0x14(%ebp)
  8015bf:	ff 75 10             	pushl  0x10(%ebp)
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	50                   	push   %eax
  8015c6:	6a 1e                	push   $0x1e
  8015c8:	e8 de fc ff ff       	call   8012ab <syscall>
  8015cd:	83 c4 18             	add    $0x18,%esp
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	50                   	push   %eax
  8015e1:	6a 1f                	push   $0x1f
  8015e3:	e8 c3 fc ff ff       	call   8012ab <syscall>
  8015e8:	83 c4 18             	add    $0x18,%esp
}
  8015eb:	90                   	nop
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	50                   	push   %eax
  8015fd:	6a 20                	push   $0x20
  8015ff:	e8 a7 fc ff ff       	call   8012ab <syscall>
  801604:	83 c4 18             	add    $0x18,%esp
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 02                	push   $0x2
  801618:	e8 8e fc ff ff       	call   8012ab <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 03                	push   $0x3
  801631:	e8 75 fc ff ff       	call   8012ab <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 04                	push   $0x4
  80164a:	e8 5c fc ff ff       	call   8012ab <syscall>
  80164f:	83 c4 18             	add    $0x18,%esp
}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <sys_exit_env>:


void sys_exit_env(void)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 21                	push   $0x21
  801663:	e8 43 fc ff ff       	call   8012ab <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
}
  80166b:	90                   	nop
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801674:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801677:	8d 50 04             	lea    0x4(%eax),%edx
  80167a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	52                   	push   %edx
  801684:	50                   	push   %eax
  801685:	6a 22                	push   $0x22
  801687:	e8 1f fc ff ff       	call   8012ab <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
	return result;
  80168f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801692:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801695:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801698:	89 01                	mov    %eax,(%ecx)
  80169a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	c9                   	leave  
  8016a1:	c2 04 00             	ret    $0x4

008016a4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	ff 75 10             	pushl  0x10(%ebp)
  8016ae:	ff 75 0c             	pushl  0xc(%ebp)
  8016b1:	ff 75 08             	pushl  0x8(%ebp)
  8016b4:	6a 10                	push   $0x10
  8016b6:	e8 f0 fb ff ff       	call   8012ab <syscall>
  8016bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8016be:	90                   	nop
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 23                	push   $0x23
  8016d0:	e8 d6 fb ff ff       	call   8012ab <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	83 ec 04             	sub    $0x4,%esp
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016e6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	50                   	push   %eax
  8016f3:	6a 24                	push   $0x24
  8016f5:	e8 b1 fb ff ff       	call   8012ab <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8016fd:	90                   	nop
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <rsttst>:
void rsttst()
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 26                	push   $0x26
  80170f:	e8 97 fb ff ff       	call   8012ab <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
	return ;
  801717:	90                   	nop
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
  80171d:	83 ec 04             	sub    $0x4,%esp
  801720:	8b 45 14             	mov    0x14(%ebp),%eax
  801723:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801726:	8b 55 18             	mov    0x18(%ebp),%edx
  801729:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80172d:	52                   	push   %edx
  80172e:	50                   	push   %eax
  80172f:	ff 75 10             	pushl  0x10(%ebp)
  801732:	ff 75 0c             	pushl  0xc(%ebp)
  801735:	ff 75 08             	pushl  0x8(%ebp)
  801738:	6a 25                	push   $0x25
  80173a:	e8 6c fb ff ff       	call   8012ab <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
	return ;
  801742:	90                   	nop
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <chktst>:
void chktst(uint32 n)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	ff 75 08             	pushl  0x8(%ebp)
  801753:	6a 27                	push   $0x27
  801755:	e8 51 fb ff ff       	call   8012ab <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
	return ;
  80175d:	90                   	nop
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <inctst>:

void inctst()
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 28                	push   $0x28
  80176f:	e8 37 fb ff ff       	call   8012ab <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
	return ;
  801777:	90                   	nop
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <gettst>:
uint32 gettst()
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 29                	push   $0x29
  801789:	e8 1d fb ff ff       	call   8012ab <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 2a                	push   $0x2a
  8017a5:	e8 01 fb ff ff       	call   8012ab <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
  8017ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017b0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017b4:	75 07                	jne    8017bd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8017bb:	eb 05                	jmp    8017c2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
  8017c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 2a                	push   $0x2a
  8017d6:	e8 d0 fa ff ff       	call   8012ab <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
  8017de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8017e1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017e5:	75 07                	jne    8017ee <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ec:	eb 05                	jmp    8017f3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 2a                	push   $0x2a
  801807:	e8 9f fa ff ff       	call   8012ab <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
  80180f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801812:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801816:	75 07                	jne    80181f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801818:	b8 01 00 00 00       	mov    $0x1,%eax
  80181d:	eb 05                	jmp    801824 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80181f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 2a                	push   $0x2a
  801838:	e8 6e fa ff ff       	call   8012ab <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
  801840:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801843:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801847:	75 07                	jne    801850 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801849:	b8 01 00 00 00       	mov    $0x1,%eax
  80184e:	eb 05                	jmp    801855 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801850:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	ff 75 08             	pushl  0x8(%ebp)
  801865:	6a 2b                	push   $0x2b
  801867:	e8 3f fa ff ff       	call   8012ab <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
	return ;
  80186f:	90                   	nop
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801876:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801879:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	6a 00                	push   $0x0
  801884:	53                   	push   %ebx
  801885:	51                   	push   %ecx
  801886:	52                   	push   %edx
  801887:	50                   	push   %eax
  801888:	6a 2c                	push   $0x2c
  80188a:	e8 1c fa ff ff       	call   8012ab <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80189a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	52                   	push   %edx
  8018a7:	50                   	push   %eax
  8018a8:	6a 2d                	push   $0x2d
  8018aa:	e8 fc f9 ff ff       	call   8012ab <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018b7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	6a 00                	push   $0x0
  8018c2:	51                   	push   %ecx
  8018c3:	ff 75 10             	pushl  0x10(%ebp)
  8018c6:	52                   	push   %edx
  8018c7:	50                   	push   %eax
  8018c8:	6a 2e                	push   $0x2e
  8018ca:	e8 dc f9 ff ff       	call   8012ab <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	ff 75 10             	pushl  0x10(%ebp)
  8018de:	ff 75 0c             	pushl  0xc(%ebp)
  8018e1:	ff 75 08             	pushl  0x8(%ebp)
  8018e4:	6a 0f                	push   $0xf
  8018e6:	e8 c0 f9 ff ff       	call   8012ab <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ee:	90                   	nop
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
    // 24oct , Hamed , return pointer-comment: panic line
    return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	50                   	push   %eax
  801900:	6a 2f                	push   $0x2f
  801902:	e8 a4 f9 ff ff       	call   8012ab <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    //return NULL;
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	ff 75 0c             	pushl  0xc(%ebp)
  801918:	ff 75 08             	pushl  0x8(%ebp)
  80191b:	6a 30                	push   $0x30
  80191d:	e8 89 f9 ff ff       	call   8012ab <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801925:	90                   	nop
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
    // 23oct-10pm , Hamed , calling syscall-commented panic line-added return
    syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	ff 75 0c             	pushl  0xc(%ebp)
  801934:	ff 75 08             	pushl  0x8(%ebp)
  801937:	6a 31                	push   $0x31
  801939:	e8 6d f9 ff ff       	call   8012ab <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
    //panic("not implemented yet");
    return ;
  801941:	90                   	nop
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80194a:	8d 45 10             	lea    0x10(%ebp),%eax
  80194d:	83 c0 04             	add    $0x4,%eax
  801950:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801953:	a1 38 31 80 00       	mov    0x803138,%eax
  801958:	85 c0                	test   %eax,%eax
  80195a:	74 16                	je     801972 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80195c:	a1 38 31 80 00       	mov    0x803138,%eax
  801961:	83 ec 08             	sub    $0x8,%esp
  801964:	50                   	push   %eax
  801965:	68 30 23 80 00       	push   $0x802330
  80196a:	e8 e2 e9 ff ff       	call   800351 <cprintf>
  80196f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801972:	a1 00 30 80 00       	mov    0x803000,%eax
  801977:	ff 75 0c             	pushl  0xc(%ebp)
  80197a:	ff 75 08             	pushl  0x8(%ebp)
  80197d:	50                   	push   %eax
  80197e:	68 35 23 80 00       	push   $0x802335
  801983:	e8 c9 e9 ff ff       	call   800351 <cprintf>
  801988:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80198b:	8b 45 10             	mov    0x10(%ebp),%eax
  80198e:	83 ec 08             	sub    $0x8,%esp
  801991:	ff 75 f4             	pushl  -0xc(%ebp)
  801994:	50                   	push   %eax
  801995:	e8 4c e9 ff ff       	call   8002e6 <vcprintf>
  80199a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80199d:	83 ec 08             	sub    $0x8,%esp
  8019a0:	6a 00                	push   $0x0
  8019a2:	68 51 23 80 00       	push   $0x802351
  8019a7:	e8 3a e9 ff ff       	call   8002e6 <vcprintf>
  8019ac:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8019af:	e8 bb e8 ff ff       	call   80026f <exit>

	// should not return here
	while (1) ;
  8019b4:	eb fe                	jmp    8019b4 <_panic+0x70>

008019b6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019bc:	a1 20 30 80 00       	mov    0x803020,%eax
  8019c1:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  8019c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ca:	39 c2                	cmp    %eax,%edx
  8019cc:	74 14                	je     8019e2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8019ce:	83 ec 04             	sub    $0x4,%esp
  8019d1:	68 54 23 80 00       	push   $0x802354
  8019d6:	6a 26                	push   $0x26
  8019d8:	68 a0 23 80 00       	push   $0x8023a0
  8019dd:	e8 62 ff ff ff       	call   801944 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019f0:	e9 c5 00 00 00       	jmp    801aba <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8019f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	01 d0                	add    %edx,%eax
  801a04:	8b 00                	mov    (%eax),%eax
  801a06:	85 c0                	test   %eax,%eax
  801a08:	75 08                	jne    801a12 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a0a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a0d:	e9 a5 00 00 00       	jmp    801ab7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a12:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a19:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a20:	eb 69                	jmp    801a8b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a22:	a1 20 30 80 00       	mov    0x803020,%eax
  801a27:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  801a2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a30:	89 d0                	mov    %edx,%eax
  801a32:	01 c0                	add    %eax,%eax
  801a34:	01 d0                	add    %edx,%eax
  801a36:	c1 e0 03             	shl    $0x3,%eax
  801a39:	01 c8                	add    %ecx,%eax
  801a3b:	8a 40 04             	mov    0x4(%eax),%al
  801a3e:	84 c0                	test   %al,%al
  801a40:	75 46                	jne    801a88 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a42:	a1 20 30 80 00       	mov    0x803020,%eax
  801a47:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  801a4d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a50:	89 d0                	mov    %edx,%eax
  801a52:	01 c0                	add    %eax,%eax
  801a54:	01 d0                	add    %edx,%eax
  801a56:	c1 e0 03             	shl    $0x3,%eax
  801a59:	01 c8                	add    %ecx,%eax
  801a5b:	8b 00                	mov    (%eax),%eax
  801a5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a68:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	01 c8                	add    %ecx,%eax
  801a79:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a7b:	39 c2                	cmp    %eax,%edx
  801a7d:	75 09                	jne    801a88 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801a7f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a86:	eb 15                	jmp    801a9d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a88:	ff 45 e8             	incl   -0x18(%ebp)
  801a8b:	a1 20 30 80 00       	mov    0x803020,%eax
  801a90:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  801a96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a99:	39 c2                	cmp    %eax,%edx
  801a9b:	77 85                	ja     801a22 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801aa1:	75 14                	jne    801ab7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801aa3:	83 ec 04             	sub    $0x4,%esp
  801aa6:	68 ac 23 80 00       	push   $0x8023ac
  801aab:	6a 3a                	push   $0x3a
  801aad:	68 a0 23 80 00       	push   $0x8023a0
  801ab2:	e8 8d fe ff ff       	call   801944 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801ab7:	ff 45 f0             	incl   -0x10(%ebp)
  801aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ac0:	0f 8c 2f ff ff ff    	jl     8019f5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801acd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ad4:	eb 26                	jmp    801afc <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801ad6:	a1 20 30 80 00       	mov    0x803020,%eax
  801adb:	8b 88 6c da 01 00    	mov    0x1da6c(%eax),%ecx
  801ae1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ae4:	89 d0                	mov    %edx,%eax
  801ae6:	01 c0                	add    %eax,%eax
  801ae8:	01 d0                	add    %edx,%eax
  801aea:	c1 e0 03             	shl    $0x3,%eax
  801aed:	01 c8                	add    %ecx,%eax
  801aef:	8a 40 04             	mov    0x4(%eax),%al
  801af2:	3c 01                	cmp    $0x1,%al
  801af4:	75 03                	jne    801af9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801af6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801af9:	ff 45 e0             	incl   -0x20(%ebp)
  801afc:	a1 20 30 80 00       	mov    0x803020,%eax
  801b01:	8b 90 7c d5 01 00    	mov    0x1d57c(%eax),%edx
  801b07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b0a:	39 c2                	cmp    %eax,%edx
  801b0c:	77 c8                	ja     801ad6 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b11:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b14:	74 14                	je     801b2a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b16:	83 ec 04             	sub    $0x4,%esp
  801b19:	68 00 24 80 00       	push   $0x802400
  801b1e:	6a 44                	push   $0x44
  801b20:	68 a0 23 80 00       	push   $0x8023a0
  801b25:	e8 1a fe ff ff       	call   801944 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b2a:	90                   	nop
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    
  801b2d:	66 90                	xchg   %ax,%ax
  801b2f:	90                   	nop

00801b30 <__udivdi3>:
  801b30:	55                   	push   %ebp
  801b31:	57                   	push   %edi
  801b32:	56                   	push   %esi
  801b33:	53                   	push   %ebx
  801b34:	83 ec 1c             	sub    $0x1c,%esp
  801b37:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b3b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b43:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b47:	89 ca                	mov    %ecx,%edx
  801b49:	89 f8                	mov    %edi,%eax
  801b4b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b4f:	85 f6                	test   %esi,%esi
  801b51:	75 2d                	jne    801b80 <__udivdi3+0x50>
  801b53:	39 cf                	cmp    %ecx,%edi
  801b55:	77 65                	ja     801bbc <__udivdi3+0x8c>
  801b57:	89 fd                	mov    %edi,%ebp
  801b59:	85 ff                	test   %edi,%edi
  801b5b:	75 0b                	jne    801b68 <__udivdi3+0x38>
  801b5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b62:	31 d2                	xor    %edx,%edx
  801b64:	f7 f7                	div    %edi
  801b66:	89 c5                	mov    %eax,%ebp
  801b68:	31 d2                	xor    %edx,%edx
  801b6a:	89 c8                	mov    %ecx,%eax
  801b6c:	f7 f5                	div    %ebp
  801b6e:	89 c1                	mov    %eax,%ecx
  801b70:	89 d8                	mov    %ebx,%eax
  801b72:	f7 f5                	div    %ebp
  801b74:	89 cf                	mov    %ecx,%edi
  801b76:	89 fa                	mov    %edi,%edx
  801b78:	83 c4 1c             	add    $0x1c,%esp
  801b7b:	5b                   	pop    %ebx
  801b7c:	5e                   	pop    %esi
  801b7d:	5f                   	pop    %edi
  801b7e:	5d                   	pop    %ebp
  801b7f:	c3                   	ret    
  801b80:	39 ce                	cmp    %ecx,%esi
  801b82:	77 28                	ja     801bac <__udivdi3+0x7c>
  801b84:	0f bd fe             	bsr    %esi,%edi
  801b87:	83 f7 1f             	xor    $0x1f,%edi
  801b8a:	75 40                	jne    801bcc <__udivdi3+0x9c>
  801b8c:	39 ce                	cmp    %ecx,%esi
  801b8e:	72 0a                	jb     801b9a <__udivdi3+0x6a>
  801b90:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b94:	0f 87 9e 00 00 00    	ja     801c38 <__udivdi3+0x108>
  801b9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b9f:	89 fa                	mov    %edi,%edx
  801ba1:	83 c4 1c             	add    $0x1c,%esp
  801ba4:	5b                   	pop    %ebx
  801ba5:	5e                   	pop    %esi
  801ba6:	5f                   	pop    %edi
  801ba7:	5d                   	pop    %ebp
  801ba8:	c3                   	ret    
  801ba9:	8d 76 00             	lea    0x0(%esi),%esi
  801bac:	31 ff                	xor    %edi,%edi
  801bae:	31 c0                	xor    %eax,%eax
  801bb0:	89 fa                	mov    %edi,%edx
  801bb2:	83 c4 1c             	add    $0x1c,%esp
  801bb5:	5b                   	pop    %ebx
  801bb6:	5e                   	pop    %esi
  801bb7:	5f                   	pop    %edi
  801bb8:	5d                   	pop    %ebp
  801bb9:	c3                   	ret    
  801bba:	66 90                	xchg   %ax,%ax
  801bbc:	89 d8                	mov    %ebx,%eax
  801bbe:	f7 f7                	div    %edi
  801bc0:	31 ff                	xor    %edi,%edi
  801bc2:	89 fa                	mov    %edi,%edx
  801bc4:	83 c4 1c             	add    $0x1c,%esp
  801bc7:	5b                   	pop    %ebx
  801bc8:	5e                   	pop    %esi
  801bc9:	5f                   	pop    %edi
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    
  801bcc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bd1:	89 eb                	mov    %ebp,%ebx
  801bd3:	29 fb                	sub    %edi,%ebx
  801bd5:	89 f9                	mov    %edi,%ecx
  801bd7:	d3 e6                	shl    %cl,%esi
  801bd9:	89 c5                	mov    %eax,%ebp
  801bdb:	88 d9                	mov    %bl,%cl
  801bdd:	d3 ed                	shr    %cl,%ebp
  801bdf:	89 e9                	mov    %ebp,%ecx
  801be1:	09 f1                	or     %esi,%ecx
  801be3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801be7:	89 f9                	mov    %edi,%ecx
  801be9:	d3 e0                	shl    %cl,%eax
  801beb:	89 c5                	mov    %eax,%ebp
  801bed:	89 d6                	mov    %edx,%esi
  801bef:	88 d9                	mov    %bl,%cl
  801bf1:	d3 ee                	shr    %cl,%esi
  801bf3:	89 f9                	mov    %edi,%ecx
  801bf5:	d3 e2                	shl    %cl,%edx
  801bf7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bfb:	88 d9                	mov    %bl,%cl
  801bfd:	d3 e8                	shr    %cl,%eax
  801bff:	09 c2                	or     %eax,%edx
  801c01:	89 d0                	mov    %edx,%eax
  801c03:	89 f2                	mov    %esi,%edx
  801c05:	f7 74 24 0c          	divl   0xc(%esp)
  801c09:	89 d6                	mov    %edx,%esi
  801c0b:	89 c3                	mov    %eax,%ebx
  801c0d:	f7 e5                	mul    %ebp
  801c0f:	39 d6                	cmp    %edx,%esi
  801c11:	72 19                	jb     801c2c <__udivdi3+0xfc>
  801c13:	74 0b                	je     801c20 <__udivdi3+0xf0>
  801c15:	89 d8                	mov    %ebx,%eax
  801c17:	31 ff                	xor    %edi,%edi
  801c19:	e9 58 ff ff ff       	jmp    801b76 <__udivdi3+0x46>
  801c1e:	66 90                	xchg   %ax,%ax
  801c20:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c24:	89 f9                	mov    %edi,%ecx
  801c26:	d3 e2                	shl    %cl,%edx
  801c28:	39 c2                	cmp    %eax,%edx
  801c2a:	73 e9                	jae    801c15 <__udivdi3+0xe5>
  801c2c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c2f:	31 ff                	xor    %edi,%edi
  801c31:	e9 40 ff ff ff       	jmp    801b76 <__udivdi3+0x46>
  801c36:	66 90                	xchg   %ax,%ax
  801c38:	31 c0                	xor    %eax,%eax
  801c3a:	e9 37 ff ff ff       	jmp    801b76 <__udivdi3+0x46>
  801c3f:	90                   	nop

00801c40 <__umoddi3>:
  801c40:	55                   	push   %ebp
  801c41:	57                   	push   %edi
  801c42:	56                   	push   %esi
  801c43:	53                   	push   %ebx
  801c44:	83 ec 1c             	sub    $0x1c,%esp
  801c47:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c4b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c53:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c5b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c5f:	89 f3                	mov    %esi,%ebx
  801c61:	89 fa                	mov    %edi,%edx
  801c63:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c67:	89 34 24             	mov    %esi,(%esp)
  801c6a:	85 c0                	test   %eax,%eax
  801c6c:	75 1a                	jne    801c88 <__umoddi3+0x48>
  801c6e:	39 f7                	cmp    %esi,%edi
  801c70:	0f 86 a2 00 00 00    	jbe    801d18 <__umoddi3+0xd8>
  801c76:	89 c8                	mov    %ecx,%eax
  801c78:	89 f2                	mov    %esi,%edx
  801c7a:	f7 f7                	div    %edi
  801c7c:	89 d0                	mov    %edx,%eax
  801c7e:	31 d2                	xor    %edx,%edx
  801c80:	83 c4 1c             	add    $0x1c,%esp
  801c83:	5b                   	pop    %ebx
  801c84:	5e                   	pop    %esi
  801c85:	5f                   	pop    %edi
  801c86:	5d                   	pop    %ebp
  801c87:	c3                   	ret    
  801c88:	39 f0                	cmp    %esi,%eax
  801c8a:	0f 87 ac 00 00 00    	ja     801d3c <__umoddi3+0xfc>
  801c90:	0f bd e8             	bsr    %eax,%ebp
  801c93:	83 f5 1f             	xor    $0x1f,%ebp
  801c96:	0f 84 ac 00 00 00    	je     801d48 <__umoddi3+0x108>
  801c9c:	bf 20 00 00 00       	mov    $0x20,%edi
  801ca1:	29 ef                	sub    %ebp,%edi
  801ca3:	89 fe                	mov    %edi,%esi
  801ca5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ca9:	89 e9                	mov    %ebp,%ecx
  801cab:	d3 e0                	shl    %cl,%eax
  801cad:	89 d7                	mov    %edx,%edi
  801caf:	89 f1                	mov    %esi,%ecx
  801cb1:	d3 ef                	shr    %cl,%edi
  801cb3:	09 c7                	or     %eax,%edi
  801cb5:	89 e9                	mov    %ebp,%ecx
  801cb7:	d3 e2                	shl    %cl,%edx
  801cb9:	89 14 24             	mov    %edx,(%esp)
  801cbc:	89 d8                	mov    %ebx,%eax
  801cbe:	d3 e0                	shl    %cl,%eax
  801cc0:	89 c2                	mov    %eax,%edx
  801cc2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cc6:	d3 e0                	shl    %cl,%eax
  801cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ccc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cd0:	89 f1                	mov    %esi,%ecx
  801cd2:	d3 e8                	shr    %cl,%eax
  801cd4:	09 d0                	or     %edx,%eax
  801cd6:	d3 eb                	shr    %cl,%ebx
  801cd8:	89 da                	mov    %ebx,%edx
  801cda:	f7 f7                	div    %edi
  801cdc:	89 d3                	mov    %edx,%ebx
  801cde:	f7 24 24             	mull   (%esp)
  801ce1:	89 c6                	mov    %eax,%esi
  801ce3:	89 d1                	mov    %edx,%ecx
  801ce5:	39 d3                	cmp    %edx,%ebx
  801ce7:	0f 82 87 00 00 00    	jb     801d74 <__umoddi3+0x134>
  801ced:	0f 84 91 00 00 00    	je     801d84 <__umoddi3+0x144>
  801cf3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801cf7:	29 f2                	sub    %esi,%edx
  801cf9:	19 cb                	sbb    %ecx,%ebx
  801cfb:	89 d8                	mov    %ebx,%eax
  801cfd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d01:	d3 e0                	shl    %cl,%eax
  801d03:	89 e9                	mov    %ebp,%ecx
  801d05:	d3 ea                	shr    %cl,%edx
  801d07:	09 d0                	or     %edx,%eax
  801d09:	89 e9                	mov    %ebp,%ecx
  801d0b:	d3 eb                	shr    %cl,%ebx
  801d0d:	89 da                	mov    %ebx,%edx
  801d0f:	83 c4 1c             	add    $0x1c,%esp
  801d12:	5b                   	pop    %ebx
  801d13:	5e                   	pop    %esi
  801d14:	5f                   	pop    %edi
  801d15:	5d                   	pop    %ebp
  801d16:	c3                   	ret    
  801d17:	90                   	nop
  801d18:	89 fd                	mov    %edi,%ebp
  801d1a:	85 ff                	test   %edi,%edi
  801d1c:	75 0b                	jne    801d29 <__umoddi3+0xe9>
  801d1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d23:	31 d2                	xor    %edx,%edx
  801d25:	f7 f7                	div    %edi
  801d27:	89 c5                	mov    %eax,%ebp
  801d29:	89 f0                	mov    %esi,%eax
  801d2b:	31 d2                	xor    %edx,%edx
  801d2d:	f7 f5                	div    %ebp
  801d2f:	89 c8                	mov    %ecx,%eax
  801d31:	f7 f5                	div    %ebp
  801d33:	89 d0                	mov    %edx,%eax
  801d35:	e9 44 ff ff ff       	jmp    801c7e <__umoddi3+0x3e>
  801d3a:	66 90                	xchg   %ax,%ax
  801d3c:	89 c8                	mov    %ecx,%eax
  801d3e:	89 f2                	mov    %esi,%edx
  801d40:	83 c4 1c             	add    $0x1c,%esp
  801d43:	5b                   	pop    %ebx
  801d44:	5e                   	pop    %esi
  801d45:	5f                   	pop    %edi
  801d46:	5d                   	pop    %ebp
  801d47:	c3                   	ret    
  801d48:	3b 04 24             	cmp    (%esp),%eax
  801d4b:	72 06                	jb     801d53 <__umoddi3+0x113>
  801d4d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d51:	77 0f                	ja     801d62 <__umoddi3+0x122>
  801d53:	89 f2                	mov    %esi,%edx
  801d55:	29 f9                	sub    %edi,%ecx
  801d57:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d5b:	89 14 24             	mov    %edx,(%esp)
  801d5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d62:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d66:	8b 14 24             	mov    (%esp),%edx
  801d69:	83 c4 1c             	add    $0x1c,%esp
  801d6c:	5b                   	pop    %ebx
  801d6d:	5e                   	pop    %esi
  801d6e:	5f                   	pop    %edi
  801d6f:	5d                   	pop    %ebp
  801d70:	c3                   	ret    
  801d71:	8d 76 00             	lea    0x0(%esi),%esi
  801d74:	2b 04 24             	sub    (%esp),%eax
  801d77:	19 fa                	sbb    %edi,%edx
  801d79:	89 d1                	mov    %edx,%ecx
  801d7b:	89 c6                	mov    %eax,%esi
  801d7d:	e9 71 ff ff ff       	jmp    801cf3 <__umoddi3+0xb3>
  801d82:	66 90                	xchg   %ax,%ax
  801d84:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d88:	72 ea                	jb     801d74 <__umoddi3+0x134>
  801d8a:	89 d9                	mov    %ebx,%ecx
  801d8c:	e9 62 ff ff ff       	jmp    801cf3 <__umoddi3+0xb3>
