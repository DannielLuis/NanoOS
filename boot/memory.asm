; NanoOS memory routines

BITS 16

mem_enable_a20:

    in al, 0x92
    or al, 00000010b
    out 0x92, al

    ret


mem_check:

    mov ax, 0x0000
    mov es, ax

    mov di, 0x0500

    mov byte [es:di], 0xAA
    cmp byte [es:di], 0xAA
    jne mem_fail

    ret

mem_fail:

    mov si, mem_msg
    call print
    jmp $

mem_msg db "Memory error",0