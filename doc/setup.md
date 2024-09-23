## 启动流程
### 启动模式
Cortex-M3有三种启动模式，分别是从flash、sram、系统存储器启动，这三个的起始地址不同，选择启动模式会将地址重映射。同时，也应注意程序的烧录地址。

### 中断向量表
上电之后，Cortex-M3从重映射后的0x0000-0000处读取中断向量表，取前两项分别解析为栈地址和程序地址，设置msp和pc。Cortex-M3区分msp和psp，[Cortex-M3权威指南](https://github.com/lisider/my_book/blob/master/Architecture/arm/armv7-cortex-M/M3/Cortex-M3%E6%9D%83%E5%A8%81%E6%8C%87%E5%8D%97.pdf)中有详细介绍。
中断向量表分为两部分，前半部分有arm制定，后半部分由硬件厂商制定，因此，一般硬件厂商会提供相应的中断向量表。以下是前半部分
```
    .word stack_start
    .word reset_handler
    .word nmi_handler
    .word hardfault_handler
    .word memmange_handler
    .word busfault_handler
    .word usagefault_handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word svc_handler
    .word debugmon_handler
    .word 0
    .word pendsv_handler
    .word systick_handler
```

### reset_handler
上电后，从中断向量表中读取reset_handler作为pc的值，这是程序的起始地址，也可视为中断服务程序，cpu运行在handler模式。在这个中断服务程序中，将flash中的data段复制到sram中、初始化内核相关设置、再跳转到main函数，执行用户代码。秉承隐藏内核细节的原则，用户代码执行结束，main函数返回，再执行进程调度。以下是本项目的代码：
```
reset_handler:
# 屏蔽中断 nmi和hardfault除外
    cpsid i
# 初始化内存sram中的数据区
    bl _memory_init
# 初始化内核堆栈 以及进程链表 定时器链表
    bl kernel_init
# 设置和初始化外设 创建进程
    bl main
# 初始化 pendsv中断 进程上下文切换在此中断实现
    bl _pendsv_init
# 初始化 systick中断 进程调度在此中断实现 
    bl _systick_init
# 使用psp 
    mov r0, sp
    msr psp, r0
    sub sp, #32
    mov r0, #2
    msr control, r0
# 设置使用psp之后开启中断
    cpsie i
    b .
```
设置用户栈时额外留出32字节空间，用作在初始化阶段发生中断，中断结束后返回，继续初始化工作。这是历史版本的遗留，但考虑后续可能需要，依然保留下来。
