

pic_remap:

    mov al, 0x11
    out 0x20, al
    call io_wait
    out 0xA0, al
    call io_wait

    mov al, 0x20
    out 0x21, al
    call io_wait

    mov al, 0x28
    out 0xA1, al
    call io_wait

    mov al, 0x04
    out 0x21, al
    call io_wait

    mov al, 0x02
    out 0xA1, al
    call io_wait

    mov al, 0x01
    out 0x21, al
    call io_wait
    out 0xA1, al
    call io_wait

    mov al, 0x00
    out 0x21, al
    call io_wait
    out 0xA1, al
    call io_wait

    ret


io_wait:
    mov al, 0
    out 0x80, al
    ret




    
pic_remap_dddd:
    mov al, 0x11
    out 0x20, al
    out 0xA0, al

    mov al, 0x20
    out 0x21, al
    mov al, 0x28
    out 0xA1, al

    mov al, 0x04
    out 0x21, al
    mov al, 0x02
    out 0xA1, al

    mov al, 0x01
    out 0x21, al
    out 0xA1, al

    mov al, 0x00
    out 0x21, al
    out 0xA1, al

    ret