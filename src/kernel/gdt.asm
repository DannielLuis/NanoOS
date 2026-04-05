; =========================
; GDT
; =========================

gdt_start:

gdt_null:
    dq 0

gdt_code:
    dw 0xFFFF       ; limit
    dw 0x0000       ; base low
    db 0x00         ; base mid
    db 10011010b    ; access
    db 11001111b    ; granularity
    db 0x00         ; base high

gdt_data:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

gdt_init:
    lgdt [gdt_descriptor]

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp 0x08:flush_cs
flush_cs:
    ret