## 堆区内存
### 最小单位——块
```
struct Block {
    struct Block *back, *forward;
    char status;
    uint32_t size;
};
enum BlockStatus {FREE, ALLOCATED};
```
堆区的管理单位以链表形式存在，堆区分配内存或回收内存后，需要更新该链表。
```
uint32_t split(struct Block *target, uint32_t required_size) {
    // 计算分裂后的剩余块的地址 必须单字对齐
    // (required_size + fragment_size) % 4 == 0
    uint8_t fragment_size = (4 - (required_size % 4)) % 4;
    // 如果分配后剩余的大小不足以存放一个块则不分裂
    if (target->size - required_size - fragment_size - sizeof(struct Block) <= 0) return 0;
    // 剩余块的地址
    struct Block *remainder = (struct Block *)((uint32_t)target + sizeof(struct Block) + required_size + fragment_size);
    // 初始化剩余块
    remainder->status = FREE;
    // 维护分裂后各个target的size
    remainder->size = target->size - required_size - fragment_size - sizeof(struct Block);
    target->size = required_size + fragment_size;
    // 维护链表
    // 边界情况
    // boundary | F:this | boundary
    // boundary | F:this | A
    // A | F:this | boundary
    // 一般情况
    // A | F:this | A
    // 分裂后仅有
    // A:this | F:remainder | A/boundary
    remainder->back = target;
    remainder->forward = target->forward;
    target->forward = remainder;
    if (remainder->forward != NULL) remainder->forward->back = target;
    return remainder->size;
}
```
```
uint32_t merge(struct Block *target) {
    struct Block *prev = target->back;
    struct Block *next = target->forward;
    // 维护合并后的size
    // 先前向合并
    if (next != NULL && next->status == FREE)
        target->size += next->size + sizeof(struct Block);
    // 再后向合并
    if (prev != NULL && prev->status == FREE)
        prev->size += target->size + sizeof(struct Block); 
    uint32_t ret = (prev != NULL) ? prev->size : target->size;
    // 维护链表
    // 边界情况
    // F | A:this | boundary
    // A | A:this | boundary --nothing
    // boundary | A:this | F | A/boundary
    // boundary | A:this | A --nothing
    // boundary | A:this | boundary --nothing
    // 一般情况
    // F | A:this | F | A/boundary
    // A | A:this | F | A/boundary
    // F | A:this | A
    // A | A:this | A --nothing
    if (prev != NULL && next == NULL && prev->status == FREE) {
        prev->forward = next;
    } else if (prev == NULL && next != NULL && next->status == FREE) {
        target->forward = next->forward;
        if (next->forward != NULL) next->forward->back = target;
    } 
    // 边界情况处理完毕 处理一般情况
    if (prev == NULL || next == NULL) return ret;
    if (prev->status == FREE && next->status == FREE) {
        prev->forward = next->forward;
        if (next->forward != NULL) next->forward->back = prev;
    } else if (prev->status == ALLOCATED && next->status == FREE) {
        target->forward = next->forward;
        if (next->forward != NULL) next->forward->back = target;
    } else if (prev->status == FREE && next->status == ALLOCATED) {
        prev->forward = next;
        next->back = prev;
    }
    return ret;
}
```
### 堆区分配
设计的分配支持多线程共享堆区
```
struct Heap {
    struct Block *block;
    Lock lock;
    uint32_t last_rest_capacity;
};
```
`lock`保证互斥访问，`last_rest_capacity`涉及多线程分配算法
```
static struct Block *select_best(struct Block *block, uint32_t size) {
    struct Block *best = NULL, *iterator = block;
    for (; iterator != NULL; iterator = iterator->forward) 
        if (iterator->status == FREE && iterator->size >= size && (best == NULL || best->size > iterator->size))
            best = iterator;
    return best;
}
```
使用最佳适配算法，有效利用有限的内存资源
```
void *my_malloc(struct Heap *heap, uint32_t size) {
    struct Block *best = NULL;
    while (best == NULL) {
        _spin_lock(&(heap->lock));
        best = select_best(heap->block, size); 
        if (best == NULL) {
            _spin_unlock(&(heap->lock));
            while (heap->last_rest_capacity < size);
        }
    }
    best->status = ALLOCATED;
    heap->last_rest_capacity = split(best, size);
    _spin_unlock(&(heap->lock));
    return (void *)((uint32_t)best + sizeof(struct Block));
}

void my_free(struct Heap *heap, void *element) {
    struct Block *target = (struct Block *)((uint32_t)element - sizeof(struct Block));
    _spin_lock(&(heap->lock));
    target->status = FREE;
    heap->last_rest_capacity = merge(target);
    _spin_unlock(&(heap->lock));
}
```
成功分配内存或回收内存维护`last_rest_capacity`，假如存在分配失败的进程，通过检查需求的大小和`last_rest_capacity`的值，此时`last_rest_capacity`一定是最大的内存块容量，如果满足需求的大小，则分配内存。

