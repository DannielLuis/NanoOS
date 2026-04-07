; =========================================
; Arquivo: src/kernel/interrupts.asm
; Descrição: Configuração de interrupções
; =========================================
interrupts_init_kk:

    call idt_init
    call pic_remap

    ; ISR
    mov eax, isr0
    mov ebx, 0
    call idt_set_gate

    mov eax, isr1
    mov ebx, 1
    call idt_set_gate






interrupts_init:

    call idt_init
    call pic_remap

; ISR 0–31
    mov eax, isr0
    mov ebx, 0
    call idt_set_gate

    mov eax, isr1
    mov ebx, 1
    call idt_set_gate

    mov eax, isr2
    mov ebx, 2
    call idt_set_gate

    mov eax, isr3
    mov ebx, 3
    call idt_set_gate

    mov eax, isr4
    mov ebx, 4
    call idt_set_gate

    mov eax, isr5
    mov ebx, 5
    call idt_set_gate

    mov eax, isr6
    mov ebx, 6
    call idt_set_gate

    mov eax, isr7
    mov ebx, 7
    call idt_set_gate

    mov eax, isr8
    mov ebx, 8
    call idt_set_gate

    mov eax, isr9
    mov ebx, 9
    call idt_set_gate

    mov eax, isr10
    mov ebx, 10
    call idt_set_gate

    mov eax, isr11
    mov ebx, 11
    call idt_set_gate

    mov eax, isr12
    mov ebx, 12
    call idt_set_gate

    mov eax, isr13
    mov ebx, 13
    call idt_set_gate

    mov eax, isr14
    mov ebx, 14
    call idt_set_gate

    mov eax, isr15
    mov ebx, 15
    call idt_set_gate

    mov eax, isr16
    mov ebx, 16
    call idt_set_gate

    mov eax, isr17
    mov ebx, 17
    call idt_set_gate

    mov eax, isr18
    mov ebx, 18
    call idt_set_gate

    mov eax, isr19
    mov ebx, 19
    call idt_set_gate

    mov eax, isr20
    mov ebx, 20
    call idt_set_gate

    mov eax, isr21
    mov ebx, 21
    call idt_set_gate

    mov eax, isr22
    mov ebx, 22
    call idt_set_gate

    mov eax, isr23
    mov ebx, 23
    call idt_set_gate

    mov eax, isr24
    mov ebx, 24
    call idt_set_gate

    mov eax, isr25
    mov ebx, 25
    call idt_set_gate

    mov eax, isr26
    mov ebx, 26
    call idt_set_gate

    mov eax, isr27
    mov ebx, 27
    call idt_set_gate

    mov eax, isr28
    mov ebx, 28
    call idt_set_gate

    mov eax, isr29
    mov ebx, 29
    call idt_set_gate

    mov eax, isr30
    mov ebx, 30
    call idt_set_gate

    mov eax, isr31
    mov ebx, 31
    call idt_set_gate

; syscall
    mov eax, isr128
    mov ebx, 128
    call idt_set_gate

; IRQ
    mov eax, irq0
    mov ebx, 32
    call idt_set_gate

    mov eax, irq1
    mov ebx, 33
    call idt_set_gate

    mov eax, irq2
    mov ebx, 34
    call idt_set_gate

    mov eax, irq3
    mov ebx, 35
    call idt_set_gate

    mov eax, irq4
    mov ebx, 36
    call idt_set_gate

    mov eax, irq5
    mov ebx, 37
    call idt_set_gate

    mov eax, irq6
    mov ebx, 38
    call idt_set_gate

    mov eax, irq7
    mov ebx, 39
    call idt_set_gate

    mov eax, irq8
    mov ebx, 40
    call idt_set_gate

    mov eax, irq9
    mov ebx, 41
    call idt_set_gate

    mov eax, irq10
    mov ebx, 42
    call idt_set_gate

    mov eax, irq11
    mov ebx, 43
    call idt_set_gate

    mov eax, irq12
    mov ebx, 44
    call idt_set_gate

    mov eax, irq13
    mov ebx, 45
    call idt_set_gate

    mov eax, irq14
    mov ebx, 46
    call idt_set_gate

    mov eax, irq15
    mov ebx, 47
    call idt_set_gate

    sti
    ret










   ; mov eax, isr128
  ;  mov ebx, 128
  ;  call idt_set_gate

    ; ...

    ; IRQ
  ;  mov eax, irq0
  ;  mov ebx, 32
  ;  call idt_set_gate

  ;  mov eax, irq1
  ;  mov ebx, 33
  ;  call idt_set_gate

  ;  ret