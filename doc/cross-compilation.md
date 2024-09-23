## 交叉编译
- 编译器套件使用`arm-none-eabi-gcc`
- 项目构建使用`CMake`

编译器套件选择gcc，有以下考虑：
- arm自家的编译器收费，总不能逮着Keil白嫖。Keil好歹作为IDE，屏蔽了很多底层操作，对学习有一定阻碍
- gcc教程更为丰富，通用性更强

裸机开发的构建工具多使用make，由于需求类型固定，很少需要更改Makefile，而本项目使用CMake则有以下几点考虑：
- CMake可以轻易得到clangd支持
- CMake入门难度大，但后续使用更为方便
- CMake可以用在较大型项目开发

至于编辑器就看个人喜好了。
<strike>
非常推荐NeoVim，LunarVim一键配置，轻松入门
</strike>

### toolchain
更为完整的配置文件请参考[toolchain-arm-none-eabi.cmake](https://github.com/jobroe/cmake-arm-embedded/blob/master/toolchain-arm-none-eabi.cmake)。

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
`include(CMakeForceCompiler)`CMake包含交叉编译相关的必要组件。

`set(CMAKE_SYSTEM_NAME Generic);set(CMAKE_SYSTEM_PROCESSOR arm)`分别指定开发裸机以及处理器架构。

`set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)`为了过CMake在编译之前的测试。

`set(CMAKE_C_COMPILER "arm-none-eabi-gcc")`设置编译器。

`add_compile_options(-mcpu=cortex-m3 -g)`详细设置架构。

`set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/layout.ld)`设置链接脚本，不同的板子的sram和flash容量不一致，需要设置加载地址和运行地址。硬件厂商提供配套链接脚本，但在学习阶段，更推荐自行实现。

`set(CMAKE_EXE_LINKER_FLAGS "-mcpu=cortex-m3 -specs=nosys.specs -T${LINKER_SCRIPT}")`设置链接器使用指定的链接脚本，这种设置方式是重新赋值，因此再次设置其他相关选项。其中-specs=nosys.specs表示不链接newlib，本项目不使用newlib

`set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER);set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY);set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)`设置查找库的路径，避免链接到host系统库

### .bin/.hex
调试需要包含调试信息的`.elf`文件，也需要`.bin`或`.hex`格式的烧录文件，需要在编译链接之后执行`arm-none-eabi-objcopy`生成相关文件。
```
add_custom_command(
    TARGET target
    POST_BUILD
    COMMAND ${OBJCOPY} -O binary target target.bin
    DEPENDS target
    WORKING_DIRECTORY ${EXECUTABLE_OUTPUT_PATH}
    )
```
