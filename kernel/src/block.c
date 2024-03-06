#include "block.h"

#define NULL 0

struct Block *BlockInit(uint32_t start, uint32_t size) {
    struct Block *block = (struct Block *)start;
    block->status = FREE;
    block->back = NULL;
    block->forward = NULL;
    block->size = size - sizeof(struct Block);
    return block;
}

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
