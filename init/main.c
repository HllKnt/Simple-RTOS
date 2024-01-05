#include "../inc/system.h"

extern void task1();
extern void task2();
extern void task3();

int main()
{
    init_heap_as_block();
    init_task_list();
    create_task(task1);
    create_task(task2);
    create_task(task3);
    set_first_task(); 
    return 0;
}
