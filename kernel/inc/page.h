#ifndef PAGE_H
#define PAGE_H
#include "stdint.h"

struct Pages {
    uint32_t page_size, start_page, memory_size, start;
};
enum AllocateObject {HEAP_PAGE, STACK_PAGE};

struct Pages allocate_page(enum AllocateObject allocate_object, uint32_t size);
void free_page(enum AllocateObject allocate_object, struct Pages target);
#endif // !PAGE_H
