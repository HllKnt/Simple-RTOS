## debug
调试分为仿真调试和实机调试，实机调试比较耗时，只在最后验证阶段烧录实机调试，一般使用qemu仿真即可。
需要以下工具：
- qemu-system-arm，仿真器
- arm-none-eabi-gdb，调试

实机调试还需要：
- st-link，包含st-util调试工具，st-flash烧录工具

### qemu-system-arm
qemu-system-arm的详细使用教程请参考[官方文档](https://www.qemu.org/docs/master/system/target-arm.html)

本项目调试请具体参考项目根目录[debug](../debug)文件夹
```
qemu-system-arm -nographic -M netduino2 -kernel ../build/bin/target.bin -s -S
```
其中 -nographic表示无图形界面，因为将在终端使用gdb调试；

-M netduino2为随便选择的cortex-m3架构的板子，因为不涉及外设，随便选择即可；

-kernel ***.bin为官方推荐用法，表示需要加载的程序，也可以使用.elf文件，但为了与现实一致，使用.bin文件更为合理；

-s -S表示后台运行，且开放端口以供gdb使用

### gdb
```
# display/z $r0
# display/z $r1
# display/z $r2
# display/z $r3
# display/z $r4
# display/z $r5
# display/z $r6
# display/z $r7
# display/z $r8
# display/z $r9
# display/z $r10
# display/z $r11
# display/z $r12
# display/z $sp
# display/z $lr
# display/z $pc
# display/z $xpsr

set disassemble-next-line on
b main
# qemu gdb default port 1234
# st-util gdb default port 4242
target remote : 4242
c
```
display/z $r0表示打印r0寄存器的值，其余同理；

set disassemble-next-line on表示汇编语句单步调试；

b main表示在main函数打断点；

target remote表示使用4242端口，这是由于gdb使用C/S架构，4242为st-util默认端口，1234为qemu-system-arm默认端口

较为常用的gdb功能有：
- p：打印变量
- x：查看内存

### st-link
st-link为st公司开源的烧录工具和调试工具，具体使用教程请参考[官方文档](https://github.com/stlink-org/stlink)

实机烧录调试不是本项目重点，而且调试工作与仿真调试区别不大，不做详细介绍。
