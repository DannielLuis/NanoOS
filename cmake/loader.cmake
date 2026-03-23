file(GLOB LOADER_SRC
    loader/*.asm
    loader/*.c
)

add_executable(loader.elf ${LOADER_SRC})

set_target_properties(loader.elf PROPERTIES
    LINK_FLAGS "-T ${CMAKE_SOURCE_DIR}/loader/linker.ld"
)