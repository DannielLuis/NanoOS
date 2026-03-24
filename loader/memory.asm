[bits 16]

MEMORY_MAP_ADDR  equ 0x5000
MEMORY_MAP_COUNT equ 0x4FF0

detect_memory:

    pusha

    mov ax, 0
    mov es, ax

    mov di, MEMORY_MAP_ADDR

    xor ebx, ebx

    mov byte [MEMORY_MAP_COUNT], 0

.next:

    mov eax, 0xE820
    mov edx, 0x534D4150
    mov ecx, 20

    int 0x15

    jc .done

    cmp eax, 0x534D4150
    jne .done

    add di, 20

    inc byte [MEMORY_MAP_COUNT]

    cmp ebx, 0
    jne .next

.done:

    popa
    ret