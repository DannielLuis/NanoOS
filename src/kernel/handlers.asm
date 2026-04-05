; ===============================
; Handlers de Interrupção
; ===============================
isr_handler:
    ; aqui posso debugar depois
    ret

irq_handler:
    ; EOI
    mov al, 0x20
    out 0x20, al
    out 0xA0, al

    ret