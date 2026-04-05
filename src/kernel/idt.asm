; =========================
; IDT
; =========================

idt_start:
times 256 dq 0
idt_end:

idt_descriptor:
    dw idt_end - idt_start - 1
    dd idt_start

idt_set_gate:
    ; eax = handler
    ; ebx = index

    mov edx, idt_start
    mov ecx, ebx
    shl ecx, 3
    add edx, ecx

    mov word [edx], ax
    mov word [edx + 2], 0x08
    mov byte [edx + 4], 0
    mov byte [edx + 5], 10001110b
    shr eax, 16
    mov word [edx + 6], ax

    ret

idt_init:
    lidt [idt_descriptor]
    ret