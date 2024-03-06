#include "block.h"
#include "lock.h"
#include "heap.h"

#define NULL 0

static struct Block *select_best(struct Block *block, uint32_t size) {
    struct Block *best = NULL, *iterator = block;
    for (; iterator != NULL; iterator = iterator->forward) 
        if (iterator->status == FREE && iterator->size >= size && (best == NULL || best->size > iterator->size))
            best = iterator;
    return best;
}

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
