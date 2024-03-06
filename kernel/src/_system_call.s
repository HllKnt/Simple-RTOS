    .thumb
    .syntax unified

    .section .text 

    .type _call_schedule, function
    .global _call_schedule
_call_schedule:
    svc 0
    bx lr

    .type svc_handler, function
    .global svc_handler
svc_handler:
    push {lr}
    bl _call_pendsv_handle_schedule
    pop {pc}

    .type _call_exit, function
    .global _call_exit
_call_exit:
    pop {r0, r1}
    bl ready_to_exit
    bl _call_schedule

    .end
