## 工具
- 项目构建使用`CMake`
- 编译器使用`arm-none-eabi-gcc`
- 仿真调试使用`qemu-system-arm`
- 烧录及调试使用`st-link`

### 交叉编译
对于初学者而言，在CMake中设置交叉编译环境的最大问题可能是不知道配置编译器、链接器的变量名，至少官方教程没有特别的篇章讲arm裸机开发的交叉编译设置，所以，只好翻相关项目的`toolchain.cmake`。幸运的是，可以找到比较完整的[toolchain-arm-none-eabi.cmake](https://github.com/jobroe/cmake-arm-embedded/blob/master/toolchain-arm-none-eabi.cmake)。

以下是本项目的`toolchain.cmake`
```
include(CMakeForceCompiler)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_C_COMPILER "arm-none-eabi-gcc")
add_compile_options(-mcpu=cortex-m3 -g)
set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/layout.ld)
set(CMAKE_EXE_LINKER_FLAGS "-mcpu=cortex-m3 -specs=nosys.specs -T${LINKER_SCRIPT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
```
`include(CMakeForceCompiler)`可以认为是CMake包含交叉编译相关的必要组件。

`set(CMAKE_SYSTEM_NAME Generic);set(CMAKE_SYSTEM_PROCESSOR arm)`分别指定开发裸机以及处理器架构。

`set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)`CMake在编译之前有一个测试，为了过测试添加这句。

`set(CMAKE_C_COMPILER "arm-none-eabi-gcc")`设置编译器。

`add_compile_options(-mcpu=cortex-m3 -g)`详细设置处理器架构和指令集，指定cortex-m3处理器之后默认选择thumb指令集。

`set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/layout.ld)`设置链接脚本，不同的板子的sram和flash容量不一致，裸机开发需要设置加载地址和运行地址。可以参考硬件厂商提供的链接脚本自己编写，了解链接环节的工作。

`set(CMAKE_EXE_LINKER_FLAGS "-mcpu=cortex-m3 -specs=nosys.specs -T${LINKER_SCRIPT}")`设置链接器使用指定的链接脚本，这种设置方式是重新赋值，因此再次设置其他相关选项。可以在编译器选项中设置，为了强调每个环节的工作，单独设置。

`set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER);set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY);set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)`设置查找库的路径，避免链接到host系统库

#### 一些小坑
- 默认链接`newlib`，而使用`newlib`有一定的移植工作，本项目不需要`newlib`，选项`-specs=nosys.specs`设置不链接`newlib`相关的库。
- 以及上面提到的CMake测试环节。
- host使用archlinux，印象里官方库的arm-none-eabi-gcc有点问题，但忘了是啥问题了，解决了就忘了。^_^

### 调试
调试需要包含调试信息的`.elf`文件，为了与实际保持一致，也需要`.bin`或`.hex`格式的烧录文件，以下命令指在编译链接之后执行`arm-none-eabi-objcopy`生成相关文件。
```
add_custom_command(
    TARGET target
    POST_BUILD
    COMMAND ${OBJCOPY} -O binary target target.bin
    DEPENDS target
    WORKING_DIRECTORY ${EXECUTABLE_OUTPUT_PATH}
    )
```
每次改完程序重新烧录过于麻烦，因此用`qemu-system-arm`代替，网上已经有很多`qemu-system-arm`的教程，就不过多介绍了，具体调试可以查看项目根目录下的debug文件夹。

### 烧录

- 烧录：`st-flash`
- 调试：`st-util`

概率出现无法连接的bug，最好加上`--connect-under-reset`。
具体使用教程参考[st-link](https://github.com/stlink-org/stlink.git)。

新版本会识别山寨芯片，所以...支持正版吧。
