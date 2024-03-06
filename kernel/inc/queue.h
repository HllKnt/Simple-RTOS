#ifndef QUEUE_H
#define QUEUE_H
#include "stdint.h"

struct Queue {
    void **data;
    uint32_t head, tail, size;
    char (*is_empty)(struct Queue *self);
    char (*is_full)(struct Queue *self);
    void *(*front)(struct Queue *self);
    void *(*back)(struct Queue *self);
    void (*push)(struct Queue *self, void *element);
    void *(*pop)(struct Queue *self);
};
void QueueInit(struct Queue *self, uint32_t size);
#endif // !QUEUE_H
