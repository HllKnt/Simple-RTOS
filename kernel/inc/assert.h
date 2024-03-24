#ifndef MY_ASSERT_H
#define MY_ASSERT_H

#define assert_failed(e) (sizeof(struct{int:-!!(e);}))
#endif // !DEBUG
