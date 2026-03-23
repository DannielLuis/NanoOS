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

    cli

    call enable_a20
    call load_gdt
    call enter_protected

;;    jmp $


hang:
    jmp hang
