; =========================
; IDT (FIXA EM MEMÓRIA)
; =========================

IDT_BASE equ 0x80000

idt_descriptor:
    dw 256*8 - 1        ; 256 entradas * 8 bytes
    dd IDT_BASE         ; endereço fixo

; ---------------------------------
; ZERAR IDT (IMPORTANTE)
; ---------------------------------
idt_clear:
    mov edi, IDT_BASE
    mov ecx, 256*2      ; 256 entradas de 8 bytes = 512 dwords
    xor eax, eax

.clear_loop:
    stosd
    loop .clear_loop

    ret

; ---------------------------------
; SETAR GATE
; ---------------------------------
idt_set_gate:
    ; eax = handler
    ; ebx = index

    mov edx, IDT_BASE
    mov ecx, ebx
    shl ecx, 3
    add edx, ecx

    mov word [edx], ax          ; offset low
    mov word [edx + 2], 0x08    ; code segment
    mov byte [edx + 4], 0
    mov byte [edx + 5], 10001110b ; present, ring0, interrupt gate
    shr eax, 16
    mov word [edx + 6], ax      ; offset high

    ret

; ---------------------------------
; INIT
; ---------------------------------
idt_init:
    call idt_clear
    lidt [idt_descriptor]
    ret