#ifndef TIMER_H
#define TIMER_H
#include "task.h"

void apply_timer(struct Task *owner, uint32_t systick_interval_cnt);
#endif // !TIMER_H
