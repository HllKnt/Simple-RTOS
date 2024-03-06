#ifndef MALLOC_H
#define MALLOC_H
#include "heap.h"

void *my_malloc(struct Heap *heap, uint32_t size);
void my_free(struct Heap *heap, void *element);
#endif // !MALLOC_H
