    .thumb
    .syntax unified

    .section .text

    .global _spin_lock
# c代码中函数声明为 void _spin_lock(Lock *lock);
# r0 需要上锁的变量的地址
# 数值0 表示未上锁
# 数值1 表示已上锁
# 见《cortex-m3权威指南》13.3.1 或arm官网的ldrex-strex示例
_spin_lock:
# 给变量赋值为1 上锁 提出循环优化
    mov r1, #1
_spin_lock_loop:
    ldrex r2, [r0]
# 判断是否上锁
# 变量为1 已经上锁 继续判断 从而实现自旋等待
    cmp r2, #0
    bne _spin_lock_loop
# 未上锁 尝试赋值上锁
# strex是保证互斥的关键 必须消耗ldrex产生的标志信息才能赋值
# 但ldrex的标志信息不会叠加 只保留最新的
# 标志信息存放在监视器中 每个核心都有本地监视器 多核心有全局监视器
# 可以设想 在多任务环境中 一个进程消耗了标志信息 导致其他进程无法赋值
# 可以总结 有两种情况导致strex失败
# 1: 在执行strex之前切换进程 该锁被其他进程上锁
# 2: 在执行strex之前切换进程 其他进程对另一把锁赋值上锁消耗ldrex标志信息
# 因此strex失败后判断是哪种情况 尝试重新赋值 在此期间会再次执行ldrex
# 多核且配有缓存 strex应该写通缓存直接落实到内存 使用关键字volatile修饰表示锁的变量
    strex r2, r1, [r0]
    cmp r2, #0
    bne _spin_lock_loop
    bx lr
    
    .global _spin_unlock
# c代码中函数声明为 void _spin_unlock(Lock *lock);
_spin_unlock:
    mov r1, #0
    str r1, [r0]
    bx lr

    .end
