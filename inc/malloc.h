#ifndef MALLOC_H
#define MALLOC_H
#include "./type.h"

void init_heap_as_block();
void *malloc(uint32_t size);
void free(void *pointer);
#endif // !MALLOC_H
