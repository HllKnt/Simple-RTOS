    .thumb
    .syntax unified

    .section .data

    .global _stack_start
    .global _stack_end
    .global _heap_start
    .global _heap_end

_stack_start:
    .long stack_start
_stack_end:
    .long stack_end
_heap_start:
    .long heap_start
_heap_end:
    .long heap_end

    .section .text

    .global _init_memory
# _init_rodata_section _init_data_section _init_bss_section 有先后顺序 低地址在前
# 暂不考虑mpu和mmu 整个sram无缓冲
_init_memory:
    push {lr}
    bl _init_rodata_section
    bl _init_data_section
    bl _init_bss_section
    pop {lr}
    bx lr

# 从flash加载至sram
_init_rodata_section:
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

# 从flash加载至sram
_init_data_section:
# data_load_address flash中的data section起始位置
    ldr r0, =data_load_address
# data_start_address sram中的起始地址
    ldr r1, =data_start_address
    ldr r2, =data_end_address
# 无data section内容 直接返回
    cmp r1, r2
    it pl
    bxpl lr
1:
    ldmia r0!, {r3-r12}
    stmia r1!, {r3-r12}
    cmp r1, r2
    bmi 1b 
    bx lr

# 将指定的sram区域赋值为0
_init_bss_section:
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
1:
    stmia r0!, {r2-r12}
    cmp r0, r1
    bmi 1b 
    bx lr 

    .end
