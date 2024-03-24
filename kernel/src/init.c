#include "heap.h"
#include "list.h"
#include "page.h"
#include "assert.h"

struct Heap *kernel_heap;

#define kernel_heap_size 0x2800
#define kernel_stack_size 0x800

void kernel_init() {
    assert_failed(kernel_heap_size <= 0);
    assert_failed(kernel_stack_size <= 0);
    struct Pages kernel_heap_page = allocate_page(HEAP_PAGE, kernel_heap_size);
    allocate_page(STACK_PAGE, kernel_stack_size);
    static struct Heap heap;
    HeapInit(&heap, kernel_heap_page.start, kernel_heap_page.memory_size);
    kernel_heap = &heap;
    extern struct List task_list;
    extern struct List timer_list;
    ListInit(&task_list);
    ListInit(&timer_list);
    extern void create_daemon();
    create_daemon();
}
