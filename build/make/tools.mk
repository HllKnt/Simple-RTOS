CROSS_COMPILE = ~/arm-toolchain/bin/arm-none-eabi-
CC = ${CROSS_COMPILE}gcc
AS = ${CROSS_COMPILE}as
LD = ${CROSS_COMPILE}ld
GDB = gdb-multiarch
READELF = ${CROSS_COMPILE}readelf
OBJDUMP = ${CROSS_COMPILE}objdump
OBJCOPY = ${CROSS_COMPILE}objcopy

QEMU = qemu-system-arm 
