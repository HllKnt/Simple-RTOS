#ifndef LOCK_H
#define LOCK_H
#include "./type.h"

enum {unlocked, locked};
typedef uint32_t volatile Lock;
void _spin_lock(Lock *lock);
void _spin_unlock(Lock *lock);
#endif // !LOCK_H
