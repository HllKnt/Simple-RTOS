#include "block.h"
#include "lock.h"
#include "heap.h"

void HeapInit(struct Heap *self, uint32_t start, uint32_t size) {
    self->block = BlockInit(start, size);
    self->lock = UNLOCKED;
    self->last_rest_capacity = self->block->size;
}
