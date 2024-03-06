#ifndef HEAP_H
#define HEAP_H
#include "block.h"
#include "lock.h"

struct Heap {
    struct Block *block;
    Lock lock;
    uint32_t last_rest_capacity;
};

void HeapInit(struct Heap *self, uint32_t start, uint32_t size);
#endif // !DEBUG
