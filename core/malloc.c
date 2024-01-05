#include "../inc/type.h"
#include "../inc/lock.h"

static enum {FREE, ALLOCATED} Status;
static struct Block {
    struct Block *back, *forward;
    char status;
    uint32_t size;
} *heap;

extern uint32_t _heap_start, _heap_end;
void init_heap_as_block() {
    heap = (struct Block *)_heap_start;
    heap->back = NULL;
    heap->forward = NULL;
    heap->status = FREE;
    heap->size = _heap_end - _heap_start - sizeof(struct Block);
}

static void split(struct Block *block, uint32_t required_size) {
    // 计算分裂后的block的地址
    // block的地址必须4字节对齐
    // (required_size + fragment_size) % 4 == 0
    uint8_t fragment_size = (4 - required_size % 4) % 4;
    // 如果分配后剩余的大小不足以存放一个块则不分裂
    if (block->size - required_size - fragment_size - sizeof(struct Block) <= 0) return;
    // 剩余块的地址
    struct Block *remainder = (struct Block *)((uint32_t)block + sizeof(struct Block) + required_size + fragment_size);
    // 初始化剩余块
    remainder->status = FREE;
    // 维护分裂后各个block的size
    remainder->size = block->size - required_size - fragment_size - sizeof(struct Block);
    block->size = required_size + fragment_size;
    // 维护链表
    // 边界情况
    // boundary | F:this | boundary
    // boundary | F:this | A
    // A | F:this | boundary
    // 一般情况
    // A | F:this | A
    // 分裂后仅有
    // A:this | F:remainder | A/boundary
    remainder->back = block;
    remainder->forward = block->forward;
    block->forward = remainder;
    if (remainder->forward != NULL) remainder->forward->back = block;
}

static void merge(struct Block *block) {
    struct Block *back = block->back;
    struct Block *forward = block->forward;
    // 维护合并后的size
    // 先前向合并
    if (forward != NULL && forward->status == FREE)
        block->size += forward->size + sizeof(struct Block);
    // 再后向合并
    if (back != NULL && back->status == FREE)
        back->size += block->size + sizeof(struct Block); 
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
    if (back != NULL && forward == NULL && back->status == FREE) {
        back->forward = forward;
    } else if (back == NULL && forward != NULL && forward->status == FREE) {
        block->forward = forward->forward;
        if (forward->forward != NULL) forward->forward->back = block;
    } 
    // 边界情况处理完毕 处理一般情况
    if (back == NULL || forward == NULL) return;
    if (back->status == FREE && forward->status == FREE) {
        back->forward = forward->forward;
        if (forward->forward != NULL) forward->forward->back = back;
    } else if (back->status == ALLOCATED && forward->status == FREE) {
        block->forward = forward->forward;
        if (forward->forward != NULL) forward->forward->back = block;
    } else if (back->status == FREE && forward->status == ALLOCATED) {
        back->forward = forward;
        forward->back = back;
    }
}

static Lock lock_of_heap = unlocked;

void *malloc(uint32_t size) {
    struct Block *better = NULL, *iterator = heap;
    // Block结构体按照4字节对齐且本身的地址4字节对齐 分配的地址紧随其后必定4字节对齐 仅需检查大小即可
    _spin_lock(&lock_of_heap);
    for (; iterator != NULL; iterator = iterator->forward) 
        if (iterator->status == FREE && iterator->size >= size && (better == NULL || better->size > iterator->size))
            better = iterator;
    if (better == NULL) while (1);
    better->status = ALLOCATED;
    split(better, size);
    _spin_unlock(&lock_of_heap); 
    return (void *)((uint32_t)better + sizeof(struct Block));
}

void free(void *pointer) {
    struct Block *block = (struct Block *)((uint32_t)pointer - sizeof(struct Block));
    block->status = FREE;
    _spin_lock(&lock_of_heap);
    merge(block);
    _spin_unlock(&lock_of_heap);
}
