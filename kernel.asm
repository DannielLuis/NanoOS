[bits 32]
;;[org 0x100000]
[org 0x10000]

kernel_start:

    cli

    mov edi, 0xB8000

    mov eax, 0x0720074B
    mov [edi], eax

hang:
    jmp hang