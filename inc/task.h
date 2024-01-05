#ifndef TASK_H
#define TASK_H
#include "./type.h"

enum {running, created, dead};
struct Task {
    char status;
    void (*entry)();
    uint32_t register_context[9]; // r4-r11,sp
    uint32_t stack_address;
};

#define TASK_SIZE 3
extern struct Task task_list[TASK_SIZE];

void init_task_list();
void create_task(void (*entry)());
#endif // !TASK_H
