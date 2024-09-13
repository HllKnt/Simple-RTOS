## babyKernel
内核编写与CPU架构紧密相关，需要掌握CPU通用寄存器和特殊功能寄存器的用处用法、CPU的中断动作、特殊的汇编指令等等，除此之外，还需要了解编译链接的过程、二者如何配合工作，总之相当复杂。而本项目恰如其名，这是一个极其简陋的内核，欠缺很多功能，实际上，是针对单核Cortex-M3的练手作业，更确切来讲，是针对正点原子战舰v3。在这个深坑摸爬打滚已有一阵子了，人还在坑里，但也有不少收获，留作分享，希望对后来者有所帮助。

同时，这也是一份回忆录，距离上次push快有半年时间，已经解决的问题容易被遗忘，章节可能比较跳跃，阅读体验可能不太丝滑。

### 记录架构相关的事项

- [x] [搭建交叉编译工具链](./doc/toolchain.md)
- [x] [Cortex-M3的启动流程](./doc/setup.md)
- [ ] Cortex-M3的ASM&C混合编程
- [ ] 上下文切换
- [ ] 进程调度
- [ ] 创建&销毁进程
- [ ] 互斥访问

### 以及架构无关的杂谈

- [ ] 堆区内存分配
- [ ] 链表&队列容器
- [ ] 缓冲区事件
- [ ] “死成”僵尸进程
- [ ] 中断服务程序应当无锁

特别感谢：
 
- [从头写一个RISC-V OS](https://github.com/plctlab/riscv-operating-system-mooc.git) 
中科大的课程，相当详细
- [Cortex-M3权威指南](https://github.com/lisider/my_book/blob/master/Architecture/arm/armv7-cortex-M/M3/Cortex-M3%E6%9D%83%E5%A8%81%E6%8C%87%E5%8D%97.pdf)
很全面的Cortex-M3硬件资料
- [ARM架构及汇编](https://www.bilibili.com/video/BV1zU4y1S763/?spm_id_from=333.999.0.0&vd_source=c2cb85e4357b8c437504cac1ff43026a)
ARM汇编官方手册的重点解读
- [Linker Script初探 - GNU Linker Ld手冊略讀](http://wen00072.github.io/blog/2014/03/14/study-on-the-linker-script/)
官方手册的解读
