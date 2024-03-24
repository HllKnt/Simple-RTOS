#include "heap.h"
#include "task.h"
#include "timer.h"
#include "list.h"
#include "page.h"
#include "malloc.h"
#include "schedule.h"

static void clean_dead_task() {
    extern struct List task_list;
    for (struct Chain *iterator = task_list.head->forward;
            iterator != task_list.tail;) {
        struct Chain *tmp = iterator;
        iterator = iterator->forward;
        struct Task *task = tmp->element;
        if (task->status == DEAD) {
            free_page(HEAP_PAGE, task->heap_page);
            free_page(STACK_PAGE, task->stack_page);
            task_list.delete(tmp);
            extern struct List timer_list;
            timer_list.delete(task->timer);
            extern struct Heap *kernel_heap;
            my_free(kernel_heap, task);
        }
    }
}

static struct Task *self;

static void daemon() {
    while (1) {
        clean_dead_task();
        set_task_status(self, SLEEP);
        _call_schedule();
    }
}

void create_daemon() {
    self = create_task(0, 0x400, 0, daemon, SLEEP, LOW);
    apply_timer(self, 100);
}
