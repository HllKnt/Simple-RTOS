#include "malloc.h"
#include "list.h"

static struct Chain *insert(struct List *self, void *element) {
    extern struct Heap *kernel_heap;
    struct Chain *addition = my_malloc(kernel_heap, sizeof(struct Chain));
    addition->element = element;
    struct Chain *prev = self->tail->back, *next = self->tail;
    addition->back = prev;
    addition->forward = next;
    prev->forward = addition;
    next->back = addition;
    return addition;
}

static void delete(struct Chain *extra) {
    struct Chain *prev = extra->back, *next = extra->forward;
    prev->forward = next;
    next->back = prev;
    extern struct Heap *kernel_heap;
    my_free(kernel_heap, extra);
}

#define NULL 0

void ListInit(struct List *self) {
    extern struct Heap *kernel_heap;
    self->head = my_malloc(kernel_heap, sizeof(struct Chain));
    self->tail = my_malloc(kernel_heap, sizeof(struct Chain));
    self->head->back = NULL;
    self->head->forward = self->tail;
    self->tail->forward = NULL;
    self->tail->back = self->head;
    self->insert = insert;
    self->delete = delete;
}
