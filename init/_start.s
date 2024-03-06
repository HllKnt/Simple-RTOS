    .thumb
    .syntax unified


    .section .text

    .type reset_handler, function
    .global reset_handler
reset_handler:
# 屏蔽中断 nmi和hardfault除外
    cpsid i
# 主要设置cpu频率
    #bl SystemInit
# 初始化内存sram中的数据区
    bl _memory_init
# 初始化系统堆区 进程链表 定时器链表 开启守护进程维护系统堆区
    bl start_daemon
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

# 一般是上访成硬件错误
# 查看出错之前的栈 或许可以追踪出错代码的地址
    .type hardfault_handler, function 
    .global hardfault_handler
hardfault_handler:
    mrs r0, psp
    b .

    .end
