; =========================
; ISR (CPU exceptions)
; =========================

isr0:
    cli
    push 0
    push 0
    jmp isr_common

isr1:
    cli
    push 0
    push 1
    jmp isr_common

; ... repete até 31

isr_common:
    pusha

    call isr_handler

    popa
    add esp, 8

    sti
    iret