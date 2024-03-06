#include "heap.h"
#include "task.h"
#include "timer.h"
#include "list.h"
#include "page.h"
#include "malloc.h"
#include "schedule.h"

struct Heap *sys_heap;
static struct Heap heap;

static void clean_dead_task() {
    extern struct List task_list;
    for (struct Chain *iterator = task_list.head->forward;
            iterator != task_list.tail;) {
        struct Chain *tmp = iterator;
        iterator = iterator->forward;
        struct Task *task = tmp->element;
        if (task->status == DEAD) {
            task_list.delete(tmp);
            free_page(HEAP_PAGE, task->heap_page);
            free_page(STACK_PAGE, task->stack_page);
            my_free(sys_heap, task);
        }
    }
}
// 缺少回收定时器链表资源

static struct Task *self;

static void daemon() {
    while (1) {
        clean_dead_task();
        set_task_status(self, SLEEP);
        _call_schedule();
    }
}

void start_daemon() {
    struct Pages sys_heap_page = allocate_page(HEAP_PAGE, 0x400);
    HeapInit(&heap, sys_heap_page.start, sys_heap_page.memory_size);
    sys_heap = &heap;
    allocate_page(STACK_PAGE, 0x300);
    extern void task_list_init();
    task_list_init();
    extern void timer_list_init();
    timer_list_init();
    self = create_task(0, 0x100, 0, daemon, SLEEP, LOW);
    apply_timer(self, 100);
}
