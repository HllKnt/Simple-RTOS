#include "task.h"
#include "list.h"
#include "malloc.h"

struct Timer {
    struct Task *owner;
    uint32_t cnt, limit;
};

struct List timer_list;

void timer_list_init() {
    ListInit(&timer_list); 
}

void apply_timer(struct Task *owner, uint32_t systick_interval_cnt) {
    extern struct Heap *kernel_heap;
    struct Timer *timer = my_malloc(kernel_heap, sizeof(struct Timer));
    timer->owner = owner;
    timer->limit = systick_interval_cnt;
    timer->cnt = 0;
    owner->timer = timer_list.insert(&timer_list, timer);
}

void timer_handle() {
    for (struct Chain *iterator = timer_list.head->forward;
            iterator != timer_list.tail;
            iterator = iterator->forward) {
        struct Timer *timer = iterator->element;
        if (timer->owner->status != DEAD && ++(timer->cnt) >= timer->limit) {
            timer->cnt = 0;
            set_task_status(timer->owner, RUNNING);
        }
    }
}
