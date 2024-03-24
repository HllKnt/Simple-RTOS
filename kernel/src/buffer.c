#include "stdint.h"
#include "buffer.h"
#include "malloc.h"

static char is_empty(struct Buffer *self) {
    return self->head == self->tail;
}

static struct Unit *ready_read(struct Buffer *self) {
    if (is_empty(self)) return 0;
    return self->units[self->head]; 
}

static void finish_read(struct Buffer *self) {
    if (is_empty(self)) return;
    self->head = (self->head + 1) % self->size;
}

static char is_full(struct Buffer *self) {
    return (self->size + self->head - self->tail) % self->size == 1;
}

static struct Unit *ready_write(struct Buffer *self) {
    if (is_full(self)) return 0;
    return self->units[self->tail];
}

static void finish_write(struct Buffer *self) {
    if (is_full(self)) return;
    self->tail = (self->tail + 1) % self->size; 
}

static void export(struct Buffer *self, struct Buffer *other) {
    while (!is_empty(self) && !is_full(other)) {
        struct Unit *tmp = self->units[self->head];
        self->units[self->head] = other->units[other->tail];
        other->units[other->tail] = tmp;
        self->head = (self->head + 1) % self->size;
        other->tail = (other->tail + 1) % other->size;
    }
}

void BufferInit(struct Buffer *self, uint32_t buffer_size, uint32_t unit_size) {
    extern struct Heap *kernel_heap;
    buffer_size++;
    self->units = my_malloc(kernel_heap, sizeof(struct Unit *) * buffer_size);
    self->size = buffer_size;
    self->head = 0;
    self->tail = 0;
    for (uint32_t i = 0; i < buffer_size; i++) {
        self->units[i] = my_malloc(kernel_heap, sizeof(struct Unit));
        self->units[i]->data = my_malloc(kernel_heap, unit_size);
        self->units[i]->size = unit_size;
        self->units[i]->len = 0;
    }
    self->is_full = is_full;
    self->is_empty = is_empty;
    self->ready_read = ready_read;
    self->finish_read = finish_read;
    self->ready_write = ready_write;
    self->finish_write = finish_write;
    self->export = export;
}
