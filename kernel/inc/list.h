#ifndef LIST_H
#define LIST_H
struct Chain {
    struct Chain *back, *forward;
    void *element;
};

struct List {
    struct Chain *head, *tail;
    struct Chain *(*insert)(struct List *self, void *element);
    void (*delete)(struct Chain *extra);
};

void ListInit(struct List *self);
#endif // !LIST_H
