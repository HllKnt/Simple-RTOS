## 上下文切换
### 中断动作序列
- 进入中断：cpu自动将r0-r3、r12、lr、sp、xpsr的值push到当前进程栈；更新pc、lr、sp
- 退出中断：从当前栈，根据先前r0-r3、r12、lr、sp、xpsr存放的位置，为这些寄存器重新赋值。可以利用这机制，实现上下文切换，在当前栈填入上文信息，之后即可恢复上文寄存器内容。

根据lr的值不同，退出动作存在些许不同，如有无中断嵌套，lr的值有所不同。中断过程中lr的值应由架构自身维护，只存在几个合法值。

### ABI
关于使用cpu内的通用寄存器，C语言各个编译器存在一项编程约定。在介绍约定之前，有必要引入caller和callee的概念，二者的关系为caller调用callee，callee执行结束必定返回到caller。约定规定caller和callee必须维护的通用寄存器：
- r0-r3、r12由caller维护，callee可以随意使用，如果有内容需要保存，则在调用callee之前，将这些值push到栈中。
r0-r3通常用作传递参数，以及函数的返回结果
- r4-r11由callee维护，如果使用了这些寄存器，则在返回之前需要恢复

### pendSV
通过设置优先级，pendSV仅在无其他中断的情况下才能执行，保证用户进程不干扰中断。

### 上下文切换
根据中断动作可知，r0-r3、r12的值由架构维护，因此在上下文切换过程中，仅需维护r4-r11。此外，需要tcb进程控制块保存上下文数据。
一次上下文切换可分为保存和加载两个动作：
```
_save_context:
    push {lr}
    ldr r0, =last_task
    ldr r0, [r0]
    bl get_register_context
    stmia r0, {r4-r11}
    ldr r0, =last_task
    ldr r0, [r0]
    bl get_stack_context
    mrs r1, psp
    str r1, [r0]
    pop {pc}
```

```
_load_context:
    push {lr}
    ldr r0, =next_task
    ldr r0, [r0]
    bl get_register_context
    ldmia r0, {r4-r11}
    ldr r0, =next_task
    ldr r0, [r0]
    bl get_stack_context
    ldr r0, [r0]
    msr psp, r0
    pop {pc}
```
`get_stack_context`和`get_register_context`涉及tcb设计，由C语言编写，返回值存放在r0寄存器，表示上下文信息的内存地址。

`ldr r0, =number`和`ldr r0, [r0]`为`get_stack_context`和`get_register_context`准备参数。

`stmia r0, {r4-r11}`和`ldmia r0, {r4-r11}`维护r4-r11的值

`mrs r1, psp`和`str r1, [r0]`保存进程栈指针

`ldr r0, [r0]`和`msr psp, r0`加载进程栈指针，跳转至目标进程栈
