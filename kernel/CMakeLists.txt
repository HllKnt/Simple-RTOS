cmake_minimum_required(VERSION 3.22.1)

project(kernel C ASM)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/src SRC)
file(GLOB ASM ${CMAKE_CURRENT_SOURCE_DIR}/src/*.s)
add_library(kernel STATIC ${SRC} ${ASM})
target_include_directories(kernel PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/inc)
