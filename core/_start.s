    .thumb
    .syntax unified

    .section .text

    .type reset_handler, function
    .global reset_handler
reset_handler:
# 屏蔽中断 nmi和hardfault除外
    cpsid i
    bl _init_memory
# 初始化进程调度相关的硬件 pendsv systick
    bl _init_critical_hardware
# 初始化 堆区 进程 其他硬件 
    bl main
# 跳转执行用户代码 开启中断
    b _run_task

# 初始化期间可能发生nmi软件中断 为最严重的错误服务 如有必要在这实现
    .type nmi_handler, function
    .global nmi_handler
nmi_handler:
    b .

# 初始化期间可能发生硬件中断 如有必要在这实现
    .type hardfault_handler, function 
    .global hardfault_handler
hardfault_handler:
    b .

    .end
