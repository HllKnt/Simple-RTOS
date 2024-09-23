## rtos-for-cortex-m3
这是一份学习实时操作系统的练手项目，目标架构为cortex-m3。cortex-m3一般用于低成本平台，用作学习用途具有很高的性价比，很多硬件外设教学使用的stm32f103c8t6最小系统板，正是cortex-m3架构。如果学完外设后，不想浪费手中的板子，不如物尽其用，给它写个rtos。^_^

学无止境，从0x0000-0000开始写rtos，或许是学习FreeRTOS、RT-Thread等成熟项目的最好途径。

cortex-m3支持多核cpu、支持cache、支持mpu，作为一个开端，不宜复杂，因此不考虑这些功能。
项目尽可能少地使用汇编，具有一定的可移植性。诸如上下文切换、互斥锁等功能，依赖架构的底层实现；而像进程调度、堆区内存分配与回收等功能，则与架构无关，需要将二者区分记录。除此之外，还有许多准备工作，如搭建交叉编译环境、调试等等工作，也将会一一记录。

### 准备工作
- [x] [交叉编译](./doc/cross-compilation.md)
- [x] [调试](./doc/debug.md)

### cortex-m3
- [x] [启动流程](./doc/setup.md)
- [x] [上下文切换](./doc/content_switch.md)
- [x] [互斥访问](./doc/mutex.md)

### 通用功能
- [x] [创建&销毁进程](./doc/tasks.md)
- [x] [进程调度](./doc/schedule.md)
- [x] [堆区内存分配](./doc/heap.md)

特别感谢：
 
- [从头写一个RISC-V OS](https://github.com/plctlab/riscv-operating-system-mooc.git) 
中科大的课程，相当详细
- [Cortex-M3权威指南](https://github.com/lisider/my_book/blob/master/Architecture/arm/armv7-cortex-M/M3/Cortex-M3%E6%9D%83%E5%A8%81%E6%8C%87%E5%8D%97.pdf)
很全面的Cortex-M3硬件资料
- [ARM架构及汇编](https://www.bilibili.com/video/BV1zU4y1S763/?spm_id_from=333.999.0.0&vd_source=c2cb85e4357b8c437504cac1ff43026a)
ARM汇编官方手册的重点解读
- [Linker Script初探 - GNU Linker Ld手冊略讀](http://wen00072.github.io/blog/2014/03/14/study-on-the-linker-script/)
官方手册的解读
