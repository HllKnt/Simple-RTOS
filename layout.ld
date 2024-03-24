MEMORY
{
    flash (rx) : ORIGIN = 0x08000000, LENGTH = 0x00080000 
    sram (rwx) : ORIGIN = 0X20000000, LENGTH = 0x00010000
}

SECTIONS
{
    .text : 
    {
        *(._vector_table) 
        *(.text) 
        . = ALIGN(4);
    } >flash
    .rodata :
    {
        *(.rodata)
        . = ALIGN(4);
    } >sram AT>flash
    rodata_load_address = LOADADDR(.rodata);
    rodata_start_address = ADDR(.rodata);
    rodata_end_address = rodata_start_address + SIZEOF(.rodata);
    .data : 
    {
        *(.data) 
        . = ALIGN(4);
    } >sram AT>flash
    data_load_address = LOADADDR(.data);
    data_start_address = ADDR(.data);
    data_end_address = data_start_address + SIZEOF(.data);
    heap_size = 0x7800;
    stack_size = 0x7800;
    heap_page_size = 0x400;
    stack_page_size = 0x400;
    heap_page_amount = heap_size / heap_page_size;
    stack_page_amount = stack_size / stack_page_size;
    .bss (NOLOAD):
    {
        *(.bss)
        . = ALIGN(4);
        heap_page = .;
        . += heap_page_amount;
        . = ALIGN(4);
        stack_page = .;
        . += stack_page_amount;
        . = ALIGN(4);
    } >sram
    bss_start_address = ADDR(.bss);
    bss_end_address = bss_start_address + SIZEOF(.bss);
    heap_start = .;
    stack_start = ORIGIN(sram) + LENGTH(sram);
    heap_end = heap_start + heap_size;
    stack_end = stack_start - stack_size;
}

ASSERT(heap_end < stack_end, "Not enough memory capacity");
