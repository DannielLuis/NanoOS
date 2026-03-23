add_custom_target(boot
    COMMAND nasm -f bin ${CMAKE_SOURCE_DIR}/boot/boot.asm -o boot.bin
)