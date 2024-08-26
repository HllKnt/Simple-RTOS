## Cortex-M3启动流程
本章节仅介绍Cortex-M3如何启动，关于初始化堆栈、跳转至`main`函数等程序上的流程后续再开章节细讲。

### 中断向量表
上电之后，Cortex-M3从重映射后的0x0000-0000处读取中断向量表，取前两项分别解析为栈地址和程序地址，设置msp和pc。Cortex-M3区分msp和psp，[Cortex-M3权威指南](https://github.com/lisider/my_book/blob/master/Architecture/arm/armv7-cortex-M/M3/Cortex-M3%E6%9D%83%E5%A8%81%E6%8C%87%E5%8D%97.pdf)中有详细介绍，后续再细讲用处。
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
#### a-ba-a-ba
虽说从中断向量表启动，但是还有很多操作空间，即使0x0800-0000存放的是程序，Cortex-M3也可以正常执行，在`qemu-system-arm`上测试可行，实际怎样还没试过，不过这种的行为有些许"离经叛道"，就不多做尝试了。

### 启动模式
Cortex-M3有三种启动模式，分别是从flash、sram、系统存储器启动，这三个的起始地址不同，选择启动模式会将地址重映射。同时，也应注意程序的烧录地址。
