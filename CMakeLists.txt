cmake_minimum_required(VERSION 3.20)

project(NanoOS C CXX ASM)

#set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/toolchain.cmake)

enable_language(ASM)

add_subdirectory(boot)
add_subdirectory(loader)
add_subdirectory(kernel)
add_subdirectory(hal)
add_subdirectory(subsystems)
add_subdirectory(shell)
add_subdirectory(system)


add_custom_target(disk ALL
    COMMAND ${CMAKE_COMMAND}
    -P ${CMAKE_SOURCE_DIR}/tools/disk.cmake
    DEPENDS
        loader.elf
        kernel.elf
)