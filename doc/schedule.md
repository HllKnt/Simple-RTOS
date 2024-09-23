## 进程调度
进程调度策略为：最高优先级获取时间，同优先级轮转分配时间。与FreeRTOS一致。
```
static struct Chain *select_best(struct Chain *start, struct Chain *end) {
    struct Chain *ans = NULL;
    if (start == NULL || end == NULL) return ans;
    extern struct List task_list;
    for (struct Chain *iterator = start; iterator != end; iterator = iterator->forward) {
        struct Task *task = iterator->element;
        if (task->status == RUNNING &&
                (ans == NULL || ((struct Task *)ans->element)->priority < task->priority))
            ans = iterator;
    }
    return ans;
}

// 优先级+轮转调度
void select_next_task() {
    extern struct List task_list;
    if (last_task == NULL || ((struct Task *)last_task->element)->status != RUNNING) {
        next_task = select_best(task_list.head->forward, task_list.tail);
        return;
    }
    struct Chain *left = select_best(task_list.head->forward, last_task);
    struct Chain *right = select_best(last_task->forward, task_list.tail);
    if (left != NULL && right != NULL) {
        struct Task *left_task = left->element, *right_task = right->element;
        next_task = (right_task->priority >= left_task->priority) ? right : left;
    } else if (left != NULL) {
        next_task = left;
    } else if (right != NULL) {
        next_task = right;
    } else next_task = NULL;
    if (next_task == NULL ||
            ((struct Task *)next_task->element)->priority < ((struct Task *)last_task->element)->priority)
        next_task = last_task;
}
```
通过维护`last_task`和`next_task`，再调用：
```
// 委托函数指针执行 保证r4-r11寄存器内容不变
void (*pendsv_handle)();
void select_pendsv_handle() {
    extern void _system_wake();
    extern void _system_switch_task();
    extern void _system_keep_sleep();
    extern void _system_save_task_then_sleep();
    if (next_task != NULL) {
        if (last_task != NULL)
            pendsv_handle = _system_switch_task;
        else pendsv_handle = _system_wake;
    } else {
        if (last_task != NULL)
            pendsv_handle = _system_save_task_then_sleep;
        else pendsv_handle = _system_keep_sleep;
    }
}
```
