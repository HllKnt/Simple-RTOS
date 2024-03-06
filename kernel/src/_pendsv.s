    .thumb
    .syntax unified

    .section .text

    .type _pendsv_init, function
    .global _pendsv_init
_pendsv_init:
# pendsv的优先级寄存器
    ldr r0, =0xe000ed22
# 优先级设置为最低
    mov r1, #0xff
    strb r1, [r0]
    bx lr

    .type pendsv_handler, function
    .global pendsv_handler
pendsv_handler:
    push {lr}
    bl select_next_task
    bl select_pendsv_handle
    ldr r0, =pendsv_handle
    ldr r0, [r0]
    blx r0
    ldr r0, =last_task
    ldr r1, =next_task
    ldr r1, [r1]
    str r1, [r0]
    pop {pc}

    .end
