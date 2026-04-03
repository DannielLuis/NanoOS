[bits 32]


; ================================
; rotina de print simples
; ================================
;clear_screen:
  ;  mov edi, 0xB8000
  ;  mov ecx, 80*25
  ;  mov eax, 0x07200720
 ;  ; mov ax, 0x0720

;.loop:
  ;  mov [edi], eax
 ;   add edi, 4
 ;  ; add edi, 2
 ;   loop .loop

  ;  mov dword [cursor_x], 0
 ;   mov dword [cursor_y], 0

  ;  ret



; ================================
; Rotina para limpar a tela
; ================================
clear_screen:
    mov edi, 0xB8000
    mov ecx, 80*25
    mov ax, 0x0720

.loop:
    mov [edi], ax
    add edi, 2
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


;print_char_pm:

 ;   cmp al, 10
 ;   je .newline

 ;   mov edi, 0xB8000

 ;   mov ebx, [cursor_y]
 ;   imul ebx, 80
 ;   add ebx, [cursor_x]
 ;   shl ebx, 1

 ;   add edi, ebx

 ;  ; mov ah, 0x07
 ;  ; mov [edi], ax
  ;  mov ah, [current_color]   ; ← COR DINÂMICA
 ;   mov [edi], ax

 ;   inc dword [cursor_x]

  ;  cmp dword [cursor_x], 80
  ;  jl .done

  ;  ;call update_cursor

;.newline:
 ;   mov dword [cursor_x], 0
 ;   inc dword [cursor_y]

  ;  ;call update_cursor

;.done:
  ;  call update_cursor
  ;  ret
print_char_pm:

    cmp al, 10
    je .do_newline

    ; 🔴 CHECAR LIMITE ANTES
    cmp dword [cursor_x], 80
    jl .write

    mov dword [cursor_x], 0
    inc dword [cursor_y]

.write:

    mov edi, 0xB8000

    mov ebx, [cursor_y]
    imul ebx, 80
    add ebx, [cursor_x]
    shl ebx, 1

    add edi, ebx

    mov ah, [current_color]
    mov [edi], ax

    inc dword [cursor_x]

    jmp .done

.do_newline:
    mov dword [cursor_x], 0
    inc dword [cursor_y]

.done:
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
   ; call update_cursor
    ret



print_hex_pm_:

    pushad

    mov ebx, eax

    mov ecx, 8

.next:
    mov eax, ebx
    shr eax, 28        ; pega nibble mais alto
    call hex_digit_pm_

    shl ebx, 4         ; avança
    loop .next

    popad
    ret


hex_digit_pm_:

    cmp al, 9
    jbe .num

    add al, 'A' - 10
    jmp .out

.num:
    add al, '0'

.out:
    call print_char_pm
    ret


print_hex_pm_prefix_:

    push eax

    mov al, '0'
    call print_char_pm
    mov al, 'x'
    call print_char_pm

    pop eax
    call print_hex_pm

    ret




print_hex_pm:

    pushad

    mov ecx, 8              ; 8 dígitos hex (32 bits)

.next:

    mov ebx, eax
    shr ebx, 28             ; pega nibble mais alto (4 bits)

    cmp bl, 9
    jbe .num

    add bl, 'A' - 10
    jmp .print

.num:
    add bl, '0'

.print:
    mov al, bl
    call print_char_pm

    shl eax, 4              ; próximo nibble
    loop .next

    popad
    ret



print_hex_pm_prefix:

    pushad

  ;  mov al, '0'
   ; call print_char_pm
   ; mov al, 'x'
   ; call print_char_pm
    mov ebx, eax        ; ✔ salva valor original

    push ebx            ; ✔ empilha para usar na impressão

    mov [teste], eax  ; ebx

    mov al, '0'
    call print_char_pm
    mov al, 'x'
    call print_char_pm

    mov eax, ebx        ; ✔ restaura valor

    mov eax, [teste]      ; ✔ ou pega direto da variável

    pop ebx             ; ✔ desempilha para usar na impressão
    mov eax, ebx        ; ✔ valor para impressão

    mov ecx, 8            ; 8 dígitos hex (32 bits)

.next:

    mov ebx, eax ; ✔ usa EBX para manipular o valor sem alterar EAX
    shr ebx, 28            ; pega nibble mais alto (4 bits)

    cmp bl, 9  ; comparação deve ser feita com BL (parte baixa de BX)
    jbe .num

    add bl, 'A' - 10
    jmp .print

.num:
    add bl, '0'

.print:
    mov al, bl
    call print_char_pm

    shl eax, 4
    loop .next

    popad
    ret



newline_pm:
    push esi               ; salva mensagem
    push eax
    push ebx

    mov dword [cursor_x], 0
    inc dword [cursor_y]

  ;  cmp dword [cursor_y], 24
  ;  jle .ok
 ;   mov dword [cursor_y], 24
;.ok:
 
 
    cmp dword [cursor_y], 24
    jle .ok
    mov dword [cursor_y], 24
.ok:
    call update_cursor
    pop esi
    pop ebx
    pop eax
    ret



draw_line:
   ; mov edi, 0xB8000
    ;mov ecx, 80
   ; mov eax, 0x07202D    ; '-' cinza
    
    mov eax, [cursor_y]
    imul eax, 80
    shl eax, 1            ; *2 (cada char = 2 bytes)

    add eax, 0xB8000
    mov edi, eax

    mov ecx, 80
    ;mov ax, 0x072D        ; '-'
    mov ax, 0x07C4         ; linha continua sem divisão
    ;mov ax, line

.loop:
    mov [edi], ax
    add edi, 2
    loop .loop
    ret



set_cursor:
    mov [cursor_x], eax
    mov [cursor_y], ebx
    ret



set_color:
    mov [current_color], al
    ret



print_at:

    ; entrada:
    ; ESI = string
    ; EAX = x
    ; EBX = y

    push eax
    push ebx

    call set_cursor
    call print_string_pm

    pop ebx
    pop eax
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



log_ok:
    push esi
    
    ; prefixo verde
    mov al, 0x0A
    call set_color

    mov esi, str_ok
    call print_string_pm

    ; mensagem branca
    mov al, 0x07
    call set_color
    
    pop esi
    call print_string_pm

   ; jmp $
    call newline_pm
    ret

log_warn:
    push esi
  
    mov al, 0x0E
    call set_color

    mov esi, str_warn
    call print_string_pm

    mov al, 0x07
    call set_color

    pop esi
    call print_string_pm

    call newline_pm
    ret

log_err:
    push esi

    mov al, 0x0C
    call set_color

    mov esi, str_err
    call print_string_pm

    mov al, 0x07
    call set_color

    pop esi
    call print_string_pm

    call newline_pm
    ret



; ================================
; Variáveis de dados
; ================================
cursor_x dd 0
cursor_y dd 0

current_color db 0x07

teste dd 0


; ================================
; Mensagens de log
; ================================
str_ok      db "[  OK  ] ", 0
str_warn    db "[ WARN ] ", 0
str_err     db "[ ERRO ] ", 0
log_prefix  db "[  OK  ] ", 0


;str_ok   db "[OK] ",0
;log_prefix db "[OK] ",0
;title db "NanoOS Kernel v1.0", 0
;line db 40 dup(0xC4), 0
;line80 db 80 dup(0xC4), 0


;str_ok   db "[OK] ",0
;str_warn db "[WARN] ",0
;str_err  db "[ERR] ",0