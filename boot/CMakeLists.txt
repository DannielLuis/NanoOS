add_custom_target(boot_bin
    COMMAND nasm -f bin ${CMAKE_CURRENT_SOURCE_DIR}/boot.asm -o boot.bin
)