enable_language(ASM_NASM)

set(CMAKE_ASM_NASM_OBJECT_FORMAT elf32)

file(GLOB_RECURSE SRC
    *.cpp
    *.asm
)

add_executable(kernel.elf ${SRC})

set_target_properties(kernel.elf PROPERTIES
    #LINK_FLAGS "-T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld -m elf_i386"
    LINK_FLAGS "-T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld"
)












#[[
file(GLOB_RECURSE KERNEL_SRC
    *.cpp
    *.asm
)

add_executable(kernel.elf ${KERNEL_SRC})

set_target_properties(kernel.elf PROPERTIES
    LINK_FLAGS "-T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld"
)]]