#include "stdint.h"
#include "lock.h"
#include "page.h"

extern char stack_page[], heap_page[];
extern const uint32_t _heap_page_size, _stack_page_size;
extern const uint32_t _heap_page_amount, _stack_page_amount;
extern const uint32_t _heap_start, _stack_start;

enum {FREE = 0, ALLOCATED = 1}; 

static uint32_t heap_page_last_reset = 0, stack_page_last_reset = 0;
static Lock heap_page_lock = UNLOCKED, stack_page_lock = UNLOCKED;


struct Object {
    enum AllocateObject type;
    char *page;
    uint32_t page_amount, page_size, start;
    Lock *lock;
    uint32_t *last_reset_capacity;
};

static struct Object select_object(enum AllocateObject allocate_object) {
    struct Object ans;
    switch (allocate_object) {
        case HEAP_PAGE:
            ans.type = HEAP_PAGE;
            ans.page = heap_page;
            ans.page_size = _heap_page_size;
            ans.page_amount = _heap_page_amount;
            ans.start = _heap_start;
            ans.lock = &heap_page_lock;
            ans.last_reset_capacity = &heap_page_last_reset;
        break;
        case STACK_PAGE:
            ans.type = STACK_PAGE;
            ans.page = stack_page;
            ans.page_size = _stack_page_size;
            ans.page_amount = _stack_page_amount;
            ans.start = _stack_start;
            ans.lock = &stack_page_lock;
            ans.last_reset_capacity = &stack_page_last_reset;
        break;
    }
    return ans;
}

static struct Pages figure(struct Object object, uint32_t start_page, uint32_t requirement) {
    struct Pages ans;
    ans.page_size = requirement;
    ans.start_page = start_page + 1 - requirement;
    ans.memory_size = requirement * object.page_size;
    if (object.type == HEAP_PAGE)
        ans.start = object.start + ans.start_page * object.page_size;
    else if (object.type == STACK_PAGE)
        ans.start = object.start - ans.start_page * object.page_size;
    return ans;
}

static void allocate(struct Object object, struct Pages target) {
    for (uint32_t i = target.start_page;
            i < target.start_page + target.page_size;
            i++)
        object.page[i] = ALLOCATED;
    uint32_t cnt = 0;
    for (uint32_t i = target.start_page + target.page_size;
            i < object.page_amount && object.page[i] == FREE;
            i++)
        cnt++;
    *(object.last_reset_capacity) = cnt;
}

struct Pages allocate_page(enum AllocateObject allocate_object, uint32_t size) {
    struct Object object = select_object(allocate_object);
    uint32_t requirement = size / object.page_size;
    requirement += (size % object.page_size > 0) ? 1 : 0;
    struct Pages ans = {0, 0, 0, 0};
    if (requirement == 0) return ans;
    while (ans.page_size < requirement) {
        uint32_t cnt = 0;
        _spin_lock(object.lock);
        for (uint32_t i = 0; i < object.page_amount; i++) {
            if (object.page[i] == FREE) cnt++;
            else cnt = 0;
            if (cnt >= requirement) {
                ans = figure(object, i, requirement);
                break;
            }
        }
        if (ans.page_size < requirement) {
            _spin_unlock(object.lock);
            while (*(object.last_reset_capacity) < requirement);
        }
    }
    allocate(object, ans);
    _spin_unlock(object.lock);
    return ans;
}

void free_page(enum AllocateObject allocate_object, struct Pages target) {
    struct Object object = select_object(allocate_object);
    _spin_lock(object.lock);
    for (uint32_t i = target.start_page;
            i < target.start_page + target.page_size;
            i++)
        object.page[i] = FREE;
    uint32_t cnt = 0, max = 0;
    for (uint32_t i = 0; i < object.page_amount; i++) {
        if (object.page[i] == FREE) cnt++;
        else {
            max = (max > cnt) ? max : cnt;
            cnt = 0;
        }
    }
    *(object.last_reset_capacity) = max;
    _spin_unlock(object.lock);
}
