    .thumb
    .syntax unified

    .section .text

    .global _run_task
# 被c代码调用 函数声明为：void _run_task();
# 设置栈指针和程序地址 跳转执行复位后的第一个进程
# question: 额外考虑 开启中断立刻触发中断 进入中断服务过久 触发任务调度跳转执行其他进程 
# 如何正确保存该段代码上文信息 使得可以返回继续执行
# answer: 需在开启中断之前设置使用psp 且保证该进程程序控制块中的sp与发生异常入栈后的sp一致
# 如果发生该情况 第一次异常会保存{r0-r3,r12,lr,pc,xpsr}至该进程栈区
# 数次进程调度后 加载该进程栈区的上下文即可恢复继续执行后续代码 需注意通用寄存器只恢复r0-r3,r12
_run_task:
# 维护last_register_context
# 获取last_register_context的地址
    ldr r0, =last_register_context
# 获取next_register_context的地址
    ldr r1, =next_register_context
# 获取next_register_context所指向的值
    ldr r1, [r1]
# *last_register_context = *next_register_context
    str r1, [r0]
# 获取栈指针
    ldr r1, [r1, #32]
# 获取程序入口地址
    ldr r2, [r1, #24]
# 模拟出栈 恢复栈指针 不修改对应pcb
    add r1, #32
# 设置psp的值
    msr psp, r1
# 使用psp 
    mov r3, #2
    msr control, r3
# 设置使用psp之后开启中断
    cpsie i
# 设置pc 跳转执行进程代码
    mov pc, r2

    .global _load_stack_context
# 被c代码调用 函数声明为：void _load_stack_context(uint32_t stack_address, void (*entry)(), uint32_t *register_context);
# 创建进程时提前构建栈区上下文 后续切换上下文不需要判断是否是第一次执行该进程
# 默认给定的栈指针符合双字对齐
_load_stack_context:
# r0 stack_address 
# r1 entry 
# r2 register_context
# 入栈之后栈指针位置
    sub r0, #32
# 设置寄存器上下文中的sp
    str r0, [r2, #32]
# 地址从低到高 栈区内容有：r0-r3,r12,lr,pc,xpsr
# 需要设置的有pc,xpsr
# 设置pc
    str r1, [r0, #24]
# 设置xpsr 
# 位9与双字对齐有关 此处为0
    ldr r3, =0x41000000
    str r3, [r0, #28]
    bx lr

    .global _call_pendsv_handler
_call_pendsv_handler:
# 手动在nvic控制器悬起pendsv
    ldr r0, =0x0e000ed04
    ldr r1, [r0]
    orr r1, #0x10000000
    str r1, [r0]
    bx lr
    
    .global _switch_task
# 在pendsv_handler中被调用
_switch_task:
# 维护last_register_context
# 获取last_register_context的地址
    ldr r0, =last_register_context
# 获取next_register_context的地址
    ldr r1, =next_register_context
# 获取last_register_context所指向的值
    ldr r2, [r0]
# 获取next_register_context所指向的值
    ldr r1, [r1]
# *last_register_context = *next_register_context
    str r1, [r0]
# 保存上文
# 获取psp
    mrs r12, psp
# 保存r4-r11,sp
    stmia r2, {r4-r12}
# 加载下文
# 加载r4-r12 并用r12表示psp
    ldmia r1, {r4-r12}
# 设置psp
    msr psp, r12
    bx lr

    .end
