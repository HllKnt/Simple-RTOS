cmake_minimum_required(VERSION 3.22.1)

include(toolchain.cmake)
project(target C ASM)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)

add_subdirectory(kernel)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/init SRC)
file(GLOB ASM ${CMAKE_CURRENT_SOURCE_DIR}/init/*.s)
add_executable(target ${SRC} ${ASM})

target_link_libraries(target kernel)

add_custom_command(
    TARGET target
    POST_BUILD
    COMMAND ${OBJCOPY} -O binary target target.bin
    DEPENDS target
    WORKING_DIRECTORY ${EXECUTABLE_OUTPUT_PATH}
    )
