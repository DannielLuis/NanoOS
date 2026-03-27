[bits 32]


; ================================
; rotina de print simples
; ================================
clear_screen:
    mov edi, 0xB8000
    mov ecx, 80*25
    mov eax, 0x07200720

.loop:
    mov [edi], eax
    add edi, 4
    loop .loop

    mov dword [cursor_x], 0
    mov dword [cursor_y], 0

    ret


;clear_screen:
;    mov edi, 0xB8000
 ;   mov ecx, 80*25
 ;   mov eax, 0x07200720    ; ' ' com atributo

;.loop:
 ;   mov [edi], eax
  ;  add edi, 4
  ;  loop .loop

 ;   ret



update_cursor:

    mov eax, [cursor_y]
    imul eax, 80
    add eax, [cursor_x]

    mov bx, ax        ; posição 16-bit

    mov dx, 0x3D4
    mov al, 0x0F
    out dx, al

    mov dx, 0x3D5
    mov al, bl        ; low
    out dx, al

    mov dx, 0x3D4
    mov al, 0x0E
    out dx, al

    mov dx, 0x3D5
    mov al, bh        ; high
    out dx, al

    ret


print_char_pm:

    cmp al, 10
    je .newline

    mov edi, 0xB8000

    mov ebx, [cursor_y]
    imul ebx, 80
    add ebx, [cursor_x]
    shl ebx, 1

    add edi, ebx

    mov ah, 0x07
    mov [edi], ax

    inc dword [cursor_x]

    cmp dword [cursor_x], 80
    jl .done

    ;call update_cursor

.newline:
    mov dword [cursor_x], 0
    inc dword [cursor_y]

    ;call update_cursor

.done:
    call update_cursor
    ret



print_string_pm:
    push esi

.next:
    lodsb
    test al, al
    jz .done

    call print_char_pm
    jmp .next

.done:
    pop esi
    ret


log_info:
    push esi               ; salva mensagem

    mov esi, log_prefix
    call print_string_pm

    pop esi                ; restaura mensagem
    call print_string_pm

    call newline_pm
    ret


;log_info:
 ;   mov esi, log_prefix
  ;  call print_string_pm

   ; call print_string_pm
;    call newline_pm
 ;   ret


newline_pm:
    mov dword [cursor_x], 0
    inc dword [cursor_y]

  ;  cmp dword [cursor_y], 24
  ;  jle .ok
 ;   mov dword [cursor_y], 24
;.ok:

    call update_cursor
    ret




cursor_x dd 0
cursor_y dd 0

log_prefix db "[OK] ",0

