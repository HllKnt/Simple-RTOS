#include "system.h"
#include "task.h"

void task1() {
}

void task2() {
    while (1);
}

void task3() {
    while (1);
}

int main (int argc, char *argv[]) {
    create_task(1, 0x100, 0, task1,  RUNNING, LOW);
    create_task(2, 0x100, 0, task2,  RUNNING, LOW);
    create_task(3, 0x100, 0, task3,  RUNNING, LOW);
    return 0;
}
