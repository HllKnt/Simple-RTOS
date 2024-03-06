#ifndef TASK_H
#define TASK_H
#include "stdint.h"
#include "page.h"
#include "heap.h"

typedef enum {
    CREATED, RUNNING, SLEEP, DEAD
} TaskStatus;

typedef enum {
    LOW, MEDIUM, HIGH, TIME_CRITICAL
} TaskPriority;

struct Task {
    char id;
    TaskStatus status;
    TaskPriority priority;
    void (*entry)();
    uint32_t cpu_register[8]; // r4-r11
    uint32_t *stack_ptr; // sp
    struct Pages stack_page, heap_page;
    struct Heap heap;
};

struct Task *create_task(uint8_t id,
        uint32_t stack_size,
        uint32_t heap_size,
        void(*entry)(),
        TaskStatus status,
        TaskPriority priority);
struct Task *search_task(uint8_t id);
void set_task_status(struct Task *task, TaskStatus task_status);
void set_task_priority(struct Task *task, TaskPriority task_priority);
#endif // !TASK_H
