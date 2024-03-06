#include "stdint.h"
#include "page.h"
#include "list.h"
#include "task.h"
#include "malloc.h"
#include "heap.h"

#define NULL 0

struct List task_list;

void task_list_init() {
    ListInit(&task_list);
}

static void ready_to_entry(struct Task * task);
struct Task *create_task(uint8_t id,
        uint32_t stack_size,
        uint32_t heap_size,
        void(*entry)(),
        TaskStatus status,
        TaskPriority priority) {
    extern struct Heap *sys_heap;
    struct Task *task = my_malloc(sys_heap, sizeof(struct Task));
    task->id = id;
    task->entry = entry;
    task->status = status;
    task->priority = priority;
    task->stack_page = allocate_page(STACK_PAGE, stack_size);
    task->heap_page = allocate_page(HEAP_PAGE, heap_size);
    task->stack_ptr = (uint32_t *)(task->stack_page.start);
    HeapInit(&task->heap, task->heap_page.start, task->heap_page.memory_size);
    ready_to_entry(task);
    task_list.insert(&task_list, task);
    return task;
}

static void ready_to_entry(struct Task *task) {
    task->stack_ptr -= 2;
    task->stack_ptr[0] = (uint32_t)task;
    task->stack_ptr -= 8;
    extern void _call_exit();
    task->stack_ptr[5] = (uint32_t)_call_exit;
    task->stack_ptr[6] = (uint32_t)task->entry;
    task->stack_ptr[7] = 0x41000000;
}

void ready_to_exit(struct Task *task) {
    task->status = DEAD;
}

void set_task_status(struct Task *task, TaskStatus task_status) {
    task->status = task_status;
}

void set_task_priority(struct Task *task, TaskPriority task_priority) {
    task->priority = task_priority;
}
