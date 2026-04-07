; ===============================
; Handlers de Interrupção
; ===============================
isr_handler:
    ; aqui posso debugar depois
    ret



irq_handler:
    cmp eax, 40
    jb .master

    mov al, 0x20
    out 0xA0, al

.master:
    mov al, 0x20
    out 0x20, al

    ret





irq_handler_j:
    mov eax, [esp + 4]

    cmp eax, 40
    jb .master_only

    mov al, 0x20
    out 0xA0, al

.master_only:
    mov al, 0x20
    out 0x20, al

    ret

irq_handler_K:
    ; EOI
  ;  mov al, 0x20
  ;  out 0x20, al
  ;  out 0xA0, al

  ;  ret

    mov eax, [esp + 32]   ; int number

    cmp eax, 40
    jb .master_only

    mov al, 0x20
    out 0xA0, al

    .master_only:
        mov al, 0x20
        out 0x20, al

        ret