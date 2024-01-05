    .thumb
    .syntax unified

    .section ._vector_table

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
# 其他硬件的中断 由厂商规定
    .rept 32
    .word 0
    .endr

    .section .text

    .type reset_handler, function
    .type nmi_handler, function
    .type hardfault_handler, function
    .type memmange_handler, function
    .type busfault_handler, function
    .type usagefault_handler, function
    .type svc_handler, function
    .type debugmon_handler, function
    .type pendsv_handler, function
    .type systick_handler, function

    .weak reset_handler
    .weak nmi_handler
    .weak hardfault_handler
    .weak memmange_handler
    .weak busfault_handler
    .weak usagefault_handler
    .weak svc_handler
    .weak debugmon_handler
    .weak pendsv_handler
    .weak systick_handler

    reset_handler:
    nmi_handler:
    hardfault_handler:
    memmange_handler:
    busfault_handler:
    usagefault_handler:
    svc_handler:
    debugmon_handler:
    pendsv_handler:
    systick_handler:
    b .

    .end
