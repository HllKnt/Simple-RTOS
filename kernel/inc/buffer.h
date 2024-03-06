#ifndef BUFFER_H
#define BUFFER_H
#include "stdint.h"

struct Unit {
    uint8_t *data;
    uint32_t size, len;
};

struct Buffer {
    struct Unit **units;
    uint32_t size, head, tail;
    char (*is_empty)(struct Buffer *self);
    char (*is_full)(struct Buffer *self);
    struct Unit *(*ready_read)(struct Buffer *self);
    void (*finish_read)(struct Buffer *self);
    struct Unit *(*ready_write)(struct Buffer *self);
    void (*finish_write)(struct Buffer *self);
    void (*export)(struct Buffer *self, struct Buffer *other);
};
void BufferInit(struct Buffer *self, uint32_t buffer_size, uint32_t unit_size);
#endif // !BUFFER_H
