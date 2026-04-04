; ==========================================
; NanoOS - IDT (32-bit Protected Mode)
; Sem linker / tudo interno
; ==========================================

[bits 32]

idt_start:
times 256 dq 0
idt_end:

idt_descriptor:
    dw idt_end - idt_start - 1
    dd idt_start

idt_init:
    call idt_setup
    lidt [idt_descriptor]
    ret

idt_set_gate:
    push edi
    push edx

    mov edi, idt_start
    mov edx, ebx
    shl edx, 3
    add edi, edx

    mov word [edi], ax
    mov word [edi + 2], cx
    mov byte [edi + 4], 0
    mov byte [edi + 5], dl
    shr eax, 16
    mov word [edi + 6], ax

    pop edx
    pop edi
    ret

; ==================================
; DEFAULT HANDLER (SAFE)
; ==================================

isr_default:
    cli
.hang:
    hlt
    jmp .hang

; ==================================
; SETUP (0–31 EXCEPTIONS)
; ==================================

idt_setup:
    mov ecx, 32
    xor ebx, ebx

.loop:
    mov eax, isr_default
    mov cx, 0x08
    mov dl, 0x8E
    call idt_set_gate

    inc ebx
    loop .loop

    ret









;[bits 32]

;idt_start:
;times 256 dq 0
;idt_end:

;idt_descriptor:
  ;  dw idt_end - idt_start - 1
  ;  dd idt_start


;load_idt:

   ; lidt [idt_descriptor]

  ;  ret
