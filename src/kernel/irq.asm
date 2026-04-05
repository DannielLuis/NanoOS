; =========================
; IRQ
; =========================

irq0:
    cli
    push 0
    push 32
    jmp irq_common

irq1:
    cli
    push 0
    push 33
    jmp irq_common

; ... até irq15

irq_common:
    pusha

    call irq_handler

    popa
    add esp, 8

    sti
    iret