[bits 32]

BITMAP_ADDR equ 0x200000

TOTAL_PAGES dd 0

pmm_init:

    mov eax, ebx
    shr eax, 12

    mov [TOTAL_PAGES], eax

    mov edi, BITMAP_ADDR

    mov ecx, eax
    shr ecx, 3

    xor eax, eax

clear_bitmap:

    mov [edi], al
    inc edi
    loop clear_bitmap

    ret