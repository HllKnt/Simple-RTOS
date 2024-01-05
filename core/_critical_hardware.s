    .thumb
    .syntax unified

    .section .text

    .global _init_critical_hardware
_init_critical_hardware:
    push {lr}
    bl _init_pendsv_prority
    bl _init_systick_prority
    bl _init_systick
    pop {lr}
    bx lr

_init_pendsv_prority:
# pendsv的优先级寄存器
    ldr r0, =0xe000ed22
# 优先级设置为最低
    mov r1, #0xff
    strb r1, [r0]
    bx lr

_init_systick_prority:
# systick的优先级寄存器
    ldr r0, =0xe000ed23
# 优先级设置为最高
    mov r1, #0x00
    strb r1, [r0]
    bx lr

_init_systick:
# 重载数值寄存器
    ldr r0, =0xe000e014
    ldr r1, =0x100000
    str r1, [r0]
# 状态及控制寄存器
    ldr r0, =0xe000e010
    mov r1, #7
    str r1, [r0]
    bx lr

    .type systick_handler, function
    .global systick_handler
systick_handler:
    push {lr}
# 清除中断标志位
    ldr r0, =0xe000e010
    ldr r0, [r0]
# 进程调度
    bl schedule
# 判断是否需要切换进程
    ldr r0, =last_register_context
    ldr r0, [r0]
    ldr r1, =next_register_context
    ldr r1, [r1]
    cmp r0, r1
    it ne
    blne _call_pendsv_handler
    pop {lr}
    bx lr

    .type pendsv_handler, function
    .global pendsv_handler
pendsv_handler:
    push {lr}
    bl _switch_task
    pop {lr}
    bx lr

    .end
