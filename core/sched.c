#include "../inc/type.h"
#include "../inc/task.h"

// last_register_context 由task.s维护
// next_register_context 由schedule()维护
uint32_t *last_register_context, *next_register_context;
    
// 轮转调度 设置next_register_context
void schedule() {
    static uint8_t current = 0;
    uint8_t next = (current + 1) % TASK_SIZE;
    for (; next < TASK_SIZE; next++) 
        if (task_list[next].status != dead) break;
    if (next >= TASK_SIZE) return;
    current = next;
    task_list[next].status = running;
    next_register_context = task_list[next].register_context;
}

void set_first_task() {
    task_list[0].status = running;
    next_register_context = task_list[0].register_context;
}
