[bits 16]


; ================================
; rotina de print simples
; ================================

print:
    mov ah, 0x0E
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop

.done:
    ret


;clear_screen:
;    mov ax, 0x0003   ; modo texto 80x25
;    int 0x10
;    ret

clear_screen:
    mov ax, 0x0600
    mov bh, 0x07
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10
    ret

set_cursor_top:
    mov ah, 0x02
    mov bh, 0x00    ; página 0
    mov dh, 0x00    ; linha 0
    mov dl, 0x00    ; coluna 0
    int 0x10
    ret

newline:
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    ret


delay_1s:
    push ax
    push cx
    push dx

    mov ah, 0x86
    mov cx, 0x000F
    mov dx, 0x4240   ; ~1.000.000 us
    int 0x15

    ;pop dx
   ; pop cx
   ; pop ax
  ;  ret
    jc .error   ; se falhar

.done:
    pop dx
    pop cx
    pop ax
    ret

.error:
    ; fallback simples (loop)
    mov cx, 0xFFFF
.loop:
    loop .loop
    jmp .done


delay:
    mov cx, 0xFFFF
.delay_loop:
    loop .delay_loop
    ret


delay_m:
    mov cx, 0xFFFF
.outer:
    push cx
    mov cx, 0xFFFF
.inner:
    loop .inner
    pop cx
    loop .outer
    ret