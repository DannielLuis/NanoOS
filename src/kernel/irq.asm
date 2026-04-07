; =========================
; IRQ
; =========================

irq0:
    cli
    push 0
    push 32

   ; mov byte [0xB8000], 'T'
  ;  mov byte [0xB8001], 0x0F

    jmp irq_common

irq1:
    cli
    push 0
    push 33
    jmp irq_common

irq2:
    cli
    push 0
    push 34
    jmp irq_common

irq3:
    cli
    push 0
    push 35
    jmp irq_common

irq4:
    cli
    push 0
    push 36
    jmp irq_common

irq5:
    cli
    push 0
    push 37
    jmp irq_common

irq6:
    cli
    push 0
    push 38
    jmp irq_common

irq7:
    cli
    push 0
    push 39
    jmp irq_common

irq8:
    cli
    push 0
    push 40
    jmp irq_common

irq9:
    cli
    push 0
    push 41
    jmp irq_common

irq10:
    cli
    push 0
    push 42
    jmp irq_common

irq11:
    cli
    push 0
    push 43
    jmp irq_common

irq12:
    cli
    push 0
    push 44
    jmp irq_common

irq13:
    cli
    push 0
    push 45
    jmp irq_common

irq14:
    cli
    push 0
    push 46
    jmp irq_common

irq15:
    cli
    push 0
    push 47
    jmp irq_common

irq_common:
    pusha

    mov eax, [esp + 32]   ; int number
    ;push eax
    call irq_handler
    ;add esp, 4

    popa
    add esp, 8
    iret