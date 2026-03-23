; NanoOS stage2 entry

;; versão 2

BITS 16
; ORG 0x8000

global start

;;extern loader_main
extern enable_a20
extern load_gdt
extern enter_protected

section .text

start:

    ; carregar kernel para 0x100000
    mov ax, 0x1000
    mov es, ax
    xor bx, bx
    mov ah, 0x02
    mov al, 1        ; 1 setor
    mov ch, 0        ; cilindro
    mov cl, 21       ; setor 21
    mov dh, 0        ; cabeça
    mov dl, [0x7DFE]        ; drive floppy
    int 0x13
    jc hang

    cli

    call enable_a20
    call load_gdt
    call enter_protected

;;    jmp $


hang:
    jmp hang
