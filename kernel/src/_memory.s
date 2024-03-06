    .thumb
    .syntax unified

    .section .data

    .global _heap_start
    .global _heap_page_size
    .global _heap_page_amount
    .global _stack_start
    .global _stack_page_size
    .global _stack_page_amount

_heap_start:
    .word heap_start
_heap_page_size:
    .word heap_page_size
_heap_page_amount:
    .word heap_page_amount
_stack_start:
    .word stack_start
_stack_page_size:
    .word stack_page_size
_stack_page_amount:
    .word stack_page_amount

    .section .text

    .type _memory_init, function
    .global _memory_init
# _rodata_init _data_init _bss_init 有先后顺序 与链接脚本同步 低地址在前
_memory_init:
    push {lr}
    bl _rodata_init
    bl _data_init
    bl _bss_init
    pop {pc}

    .type _rodata_init, function
# 从flash加载至sram
_rodata_init:
# rodata_load_address flash中的rodata section起始位置
    ldr r0, =rodata_load_address
# rodata_start_address sram中的起始地址
    ldr r1, =rodata_start_address
    ldr r2, =rodata_end_address
# 无rodata section内容 直接返回
    cmp r1, r2
    it pl
    bxpl lr
1:
    ldmia r0!, {r3-r12}
    stmia r1!, {r3-r12}
    cmp r1, r2
    bmi 1b 
    bx lr

    .type _data_init, function
# 从flash加载至sram
_data_init:
# data_load_address flash中的data section起始位置
    ldr r0, =data_load_address
# data_start_address sram中的起始地址
    ldr r1, =data_start_address
    ldr r2, =data_end_address
# 无data section内容 直接返回
    cmp r1, r2
    it pl
    bxpl lr
2:
    ldmia r0!, {r3-r12}
    stmia r1!, {r3-r12}
    cmp r1, r2
    bmi 2b 
    bx lr

    .type _bss_init, function
# 将指定的sram区域赋值为0
_bss_init:
    ldr r0, =bss_start_address
    ldr r1, =bss_end_address
# 无bss section内容 直接返回
    cmp r0, r1
    it pl
    bxpl lr
    mov r2, #0
    mov r3, #0
    mov r4, #0
    mov r5, #0
    mov r6, #0
    mov r7, #0
    mov r8, #0
    mov r9, #0
    mov r10, #0
    mov r11, #0
    mov r12, #0
3:
    stmia r0!, {r2-r12}
    cmp r0, r1
    bmi 3b 
    bx lr 

    .end
