; NanoOS kernel entry

BITS 32

global kernel_entry
extern kernel_main

kernel_entry:

    cli

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x9F000

    call kernel_main

.hang:
    hlt
    jmp .hang