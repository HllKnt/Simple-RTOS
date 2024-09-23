## 创建&消耗进程
### 创建
- 分配堆栈资源
- 在进程调度管理的进程链表中加入该进程tcb

```
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
    struct Chain *timer;
};
```
进程控制块记录进程所有信息，其中较为关键的`TaskStatus`和`TaskPriority`与进程调度有关。
在本项目中，还需虚构上下文信息，即在自身的进程栈模拟进入中断后的情形，如此一来，上下文切换部分代码可以保持简洁。

### 销毁
销毁进程的方式与FreeRTOS的做法类似，额外创建守护进程，销毁标记为`DEAD`的进程。
进程控制块本身是一项内存资源，且由进程链表保存，如果由自身回收的过程中发生进程调度，则会存在内存泄漏或竞争访问，可以分类讨论：
- 先回收，再从进程链表中删除：回收结束，发生调度，调度过程中将访问`task->status`，此时内存已被回收，存在竞争访问
- 先从进程链表中删除，再回收：删除结束，发生调度，由于不存在进程控制块，将永远不会再次执行回收，存在内存泄漏
