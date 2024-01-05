TARGET = babyOS

SRC = \
	_vector_table.s \
	_start.s \
	_memory.s \
	_critical_hardware.s \
	_lock.s \
	_task.s \
	malloc.c \
	task.c \
	sched.c \
	main.c \
	task1.c \
	task2.c \
	task3.c \

SRC_PATH = ../core
SRC_PATH += ../init
SRC_PATH += ../user
vpath %.s ${SRC_PATH}
vpath %.c ${SRC_PATH}
OBJS := $(addsuffix .o, $(basename ${SRC}))
OUTPUT_PATH = ./object
