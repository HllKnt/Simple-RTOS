#ifndef LOCK_H
#define LOCK_H
#include "stdint.h"

typedef uint32_t volatile Lock;
enum SpinLockStatus {UNLOCKED, LOCKED};
enum MutexLockStatus {MUTEX_LOCK_FAILED, MUTEX_LOCK_SUCCESSED};
void _spin_lock(Lock *lock);
void _spin_unlock(Lock *lock);
enum MutexLockStatus _mutex_lock(Lock *lock);
void _mutex_unlock(Lock *lock);
#endif // !LOCK_H
