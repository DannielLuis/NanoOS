BITS 16

;; Versão 2

global load_gdt

section .data

gdt_start:

dq 0

;dw 0xFFFF
;dw 0
;db 0
;db 10011010b
;db 11001111b
;db 0

;dw 0xFFFF
;dw 0
;db 0
;db 10010010b
;db 11001111b
;db 0

; code
dw 0xFFFF
dw 0x0000
db 0x00
db 10011010b
db 11001111b
db 0x00

; data
dw 0xFFFF
dw 0x0000
db 0x00
db 10010010b
db 11001111b
db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    ;;dd gdt_start
    dd gdt_start + 0x8000

section .text

load_gdt:
    lgdt [gdt_descriptor]
    ret