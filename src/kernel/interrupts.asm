; =========================================
; Arquivo: src/kernel/interrupts.asm
; Descrição: Configuração de interrupções
; =========================================
interrupts_init:

    call idt_init
    call pic_remap

    ; ISR
    mov eax, isr0
    mov ebx, 0
    call idt_set_gate

    mov eax, isr1
    mov ebx, 1
    call idt_set_gate

    ; ...

    ; IRQ
    mov eax, irq0
    mov ebx, 32
    call idt_set_gate

    mov eax, irq1
    mov ebx, 33
    call idt_set_gate

    ret