file(GLOB_RECURSE KERNEL_SRC
    kernel/*.cpp
    kernel/*.asm
)

add_executable(kernel.elf ${KERNEL_SRC})

set_target_properties(kernel.elf PROPERTIES
    LINK_FLAGS "-T ${CMAKE_SOURCE_DIR}/kernel/linker.ld"
)