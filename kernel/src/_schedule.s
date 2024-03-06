    .thumb
    .syntax unified

    .section .text

    .type _call_pendsv_handle_schedule, function
    .global _call_pendsv_handle_schedule
_call_pendsv_handle_schedule:
# 手动在nvic控制器悬起pendsv
    ldr r0, =0x0e000ed04
    ldr r1, [r0]
    orr r1, #0x10000000
    str r1, [r0]
    bx lr

    .type _save_context, function
_save_context:
    push {lr}
    ldr r0, =last_task
    ldr r0, [r0]
    bl get_register_context
    stmia r0, {r4-r11}
    ldr r0, =last_task
    ldr r0, [r0]
    bl get_stack_context
    mrs r1, psp
    str r1, [r0]
    pop {pc}

    .type _load_context, function
_load_context:
    push {lr}
    ldr r0, =next_task
    ldr r0, [r0]
    bl get_register_context
    ldmia r0, {r4-r11}
    ldr r0, =next_task
    ldr r0, [r0]
    bl get_stack_context
    ldr r0, [r0]
    msr psp, r0
    pop {pc}

    .type _system_switch_task, function
    .global _system_switch_task
_system_switch_task:
    push {lr}
    bl _save_context
    bl _load_context
    pop {pc}

    .type _system_wake, function
    .global _system_wake
_system_wake:
    push {lr}
    bl _load_context
    pop {pc}

    .type _system_keep_sleep, function
    .global _system_keep_sleep
_system_keep_sleep:
    ldr r0, =_system_sleep_stack_button
    msr psp, r0
    bx lr

    .type _system_save_task_then_sleep, function
    .global _system_save_task_then_sleep
_system_save_task_then_sleep:
    push {lr}
    bl _save_context
    bl _system_keep_sleep
    pop {pc}

    .type _sleep, function
_sleep:
    wfi
    b _sleep

    .section .data

    .align 3
_system_sleep_stack_button:
    .rept 6
    .long 0
    .endr
    .long _sleep
    .long 0x41000000
_system_sleep_stack_top:

    .end
