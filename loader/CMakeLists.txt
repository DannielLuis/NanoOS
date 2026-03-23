enable_language(ASM_NASM)

set(CMAKE_ASM_NASM_OBJECT_FORMAT elf32)

file(GLOB ASM_SRC
    *.asm
)

file(GLOB C_SRC
    *.c
)

set(SRC
    ${ASM_SRC}
    ${C_SRC}
)

add_executable(loader.elf ${SRC})

set_target_properties(loader.elf PROPERTIES
   # LINK_FLAGS "-T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld -m elf_i386"
    LINK_FLAGS "-T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld -Wl,-m,elf_i386"
)





#[[
file(GLOB LOADER_SRC
    *.asm
    *.c
)

add_executable(loader.elf ${LOADER_SRC})

set_target_properties(loader.elf PROPERTIES
    LINK_FLAGS "-T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld"
)]]