BITS 16

;; Versão 2

global enter_protected
global pmode_start

;;extern gdt_descriptor
extern loader_main

section .text

enter_protected:

    cli

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:pmode_start


BITS 32

pmode_start:

    mov ax, 0x10

    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ;;mov esp, 0x90000
    mov esp, 0x9FC00

    ;; call loader_main
    jmp 0x1000b0

;;    jmp $


hang:
    jmp hang