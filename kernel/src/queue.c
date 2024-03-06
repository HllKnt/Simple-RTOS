#include "stdint.h"
#include "malloc.h"
#include "queue.h"

static char is_empty(struct Queue *self) {
    return self->head == self->tail;
}

static char is_full(struct Queue *self) {
    return (self->head - self->tail + self->size) % self->size == 1;
}

static void *front(struct Queue *self) {
    while (is_empty(self));
    return self->data[self->head];
}

static void *back(struct Queue *self) {
    while (is_empty(self));
    return self->data[(self->tail + 1) % self->size];
}

static void push(struct Queue *self, void *element) {
    while (is_full(self));
    self->data[self->tail] = element;
    self->tail = (self->tail + 1) % self->size;
}

static void *pop(struct Queue *self) {
    while (is_empty(self));
    void *ans = self->data[self->head];
    self->head = (self->head + 1) % self->size;
    return ans;
}

void QueueInit(struct Queue *self, uint32_t size) {
    size++;
    self->size = size;
    self->head = 0;
    self->tail = 0;
    extern struct Heap *sys_heap;
    self->data = my_malloc(sys_heap, sizeof(void *) * size);
    self->is_empty = is_empty;
    self->is_full = is_full;
    self->front = front;
    self->back = back;
    self->push = push;
    self->pop = pop;
}
