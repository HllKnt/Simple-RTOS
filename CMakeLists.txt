cmake_minimum_required(VERSION 3.22.1)

include(toolchain.cmake)
project(ship C ASM)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)

add_subdirectory(kernel)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/init SRC)
file(GLOB ASM ${CMAKE_CURRENT_SOURCE_DIR}/init/*.s)
add_executable(ship ${SRC} ${ASM})

target_link_libraries(ship kernel)

add_custom_command(
    TARGET ship
    POST_BUILD
    COMMAND ${OBJCOPY} -O binary ship ship.bin
    DEPENDS ship
    WORKING_DIRECTORY ${EXECUTABLE_OUTPUT_PATH}
    )
