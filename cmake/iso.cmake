add_custom_target(iso

    COMMAND mkdir -p iso/boot/grub

    COMMAND cp kernel.elf iso/boot/
    COMMAND cp grub.cfg iso/boot/grub/

    COMMAND grub-mkrescue -o NanoOS.iso iso

)