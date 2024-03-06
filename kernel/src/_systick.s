    .thumb
    .syntax unified

    .section .text

    .type _systick_init, function
    .global _systick_init
_systick_init:
# systick的优先级寄存器
    ldr r0, =0xe000ed23
# 优先级设置为最高
    mov r1, #0x00
    strb r1, [r0]
# 基址寄存器
    ldr r0, =0xe000e010
# 外部校准值寄存器 1ms读数
    ldr r1, [r0, #12]
    mov r2, #10
    mul r1, r2
# 重载数值寄存器
    str r1, [r0, #4]
# 状态及控制寄存器
    mov r1, #3
    str r1, [r0, #0]
    bx lr

    .type systick_handler, function
    .global systick_handler
systick_handler:
    push {lr}
# 清除中断标志位
    ldr r0, =0xe000e010
    ldr r0, [r0]
    bl timer_handle
    bl _call_pendsv_handle_schedule
    pop {pc}

    .end
