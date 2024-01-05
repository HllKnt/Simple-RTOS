MEMORY
{
    flash (rx) : ORIGIN = 0x08000000, LENGTH = 0x00800000 
    sram (rwx) : ORIGIN = 0X20000000, LENGTH = 0x00002000
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
    .bss (NOLOAD):
    {
        *(.bss)
        . = ALIGN(4);
    } >sram
    bss_start_address = ADDR(.bss);
    bss_end_address = bss_start_address + SIZEOF(.bss);
    heap_start = .;
    stack_start = ORIGIN(sram) + LENGTH(sram);
    heap_size = 2048;
    stack_size = 4096;
    heap_end = heap_start + heap_size;
    stack_end = stack_start - stack_size;
}

ASSERT(heap_end < stack_end, "Not enough memory capacity");
