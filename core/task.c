#include "../inc/type.h"
#include "../inc/task.h"

struct Task task_list[TASK_SIZE];

extern uint32_t _stack_start, _stack_end;
void init_task_list() {
    static const uint32_t system_stack_size = 1024, user_stack_size = 1024;
    for (uint8_t i = 0; i < TASK_SIZE; i++) {
        task_list[i].status = dead;
        task_list[i].stack_address = _stack_start - system_stack_size - i * user_stack_size;
    }
}

// 提前加载栈区上下文信息 栈区栈指针保存在pcb 简化切换进程的代码
extern void _load_stack_context(uint32_t stack_address, void (*entry)(), uint32_t *register_context);
void create_task(void (*entry)()) {
    uint8_t i = 0;
    while (i < TASK_SIZE && task_list[i].status != dead) i++;
    if (i >= TASK_SIZE) while (1);
    task_list[i].status = created;
    task_list[i].entry = entry;
    _load_stack_context(task_list[i].stack_address, task_list[i].entry, task_list[i].register_context);
}
