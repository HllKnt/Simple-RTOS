#ifndef BLOCK_H
#define BLOCK_H
#include "stdint.h"

struct Block {
    struct Block *back, *forward;
    char status;
    uint32_t size;
};
enum BlockStatus {FREE, ALLOCATED};

struct Block *BlockInit(uint32_t start, uint32_t size);
uint32_t split(struct Block *target, uint32_t required_size);
uint32_t merge(struct Block *target);
#endif // !BLOCK_H
