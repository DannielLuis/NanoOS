[bits 32]
;;[org 0x100000]
[org 0x10000]

jmp kernel_start   ; <-- GARANTE posição 0

%include "screen.asm"

;MEMORY_MAP      equ 0x5000
;MEMORY_COUNT    equ 0x4FF0


kernel_start:

    cli

    ; =================================
 ;   mov edi, 0xB8000
 ;   mov eax, 0x0720074B
 ;   mov [edi], eax

    ; =================================
  ;  mov esi, 0x4FF0
  ;  mov al, [esi]

  ;  add al, 'h'

  ;  mov ah, 0x07
   ; mov [edi+4], ax


    ; =================================
    ;mov edi, 0xB8000
    ;mov eax, 0x07200758   ; 'X'
    ;mov [edi], eax


    ; =================================
 ;   xor ecx, ecx
 ;   mov cl, [MEMORY_COUNT]

  ;  mov esi, MEMORY_MAP

  ;  xor ebx, ebx    ; total low

    ;jmp hang
    ;jmp $


    ; ================================
    ; Tela de logs
    ; ================================
    call clear_screen     ; Limpa a tela
    call update_cursor    ; atualiza o cursor

    ; linha superior
    mov dword [cursor_y], 0
    call draw_line
 ;;;;;;;   mov esi, line80
 ;;;;;;;;   call print_string_pm


   ; call newline_pm


    ; título
    mov esi, title
    mov eax, 30    ;31    ;25        ; posição X (centralizado manual)
    mov ebx, 1    ;0    linha
    call print_at



 ;   call newline_pm



    ; linha inferior
  ;  mov eax, 25        ; posição X (centralizado manual)
 ;   mov ebx, 4    ;0    linha
    mov dword [cursor_y], 2
  ;  call set_cursor
    call draw_line

;;;;;;;    mov esi, line80
;;;;;    call print_string_pm








    call newline_pm
    call newline_pm


    mov esi, msg1
    call print_string_pm


    call newline_pm


    mov esi, msg2
    call print_string_pm

   ; call newline_pm


    mov eax, 0        ; posição X
    mov ebx, 10       ; posição Y
  ;  mov dword [cursor_x], 0
  ;  mov dword [cursor_y], 20
    call set_cursor

    call update_cursor

.loop:
    hlt
    jmp .loop



msg1   db " NanoOS Kernel iniciado" , 0
msg2   db " Sistema de logs OK" , 0











loop_entries:

    cmp ecx, 0
    je done

    mov eax, [esi+16]   ; type

    cmp eax, 1
    jne next

    mov eax, [esi+8]    ; length low
    add ebx, eax

next:

    ;add esi, 24
    add esi, 20
    dec ecx
    jmp loop_entries

done:

    ; =========================
    ; TESTE 1 — RAM total (EBX vindo do E820)
    ; =========================

    mov eax, ebx
    shr eax, 20            ; MB

    add al, '0'

    mov ah, 0x07
    mov [edi+4], ax        ; posição 1


    ; =========================
    ; TESTE 2 — RAM em páginas (antes do PMM)
    ; =========================

    mov eax, ebx
    shr eax, 12            ; páginas

    add al, '0'

    mov ah, 0x07
    mov [edi+6], ax        ; posição 2


    ; =========================
    ; INIT PMM
    ; =========================

    call pmm_init


    ; =========================
    ; TESTE 3 — TOTAL_PAGES
    ; =========================

    mov eax, [TOTAL_PAGES]

    shr eax, 8             ; só pra caber em 1 dígito

    add al, '0'

    mov ah, 0x07
    mov [edi+8], ax        ; posição 3


    ; =========================
    ; TESTE 4 — alloc_page
    ; =========================

  ;  call pmm_alloc_page
  ;  call pmm_alloc_page

   ; mov eax, eax           ; endereço retornado

  ;  shr eax, 12            ; índice da página

  ;  add al, '0'

   ; mov ah, 0x07
  ;  mov [edi+10], ax       ; posição 4

    ; =========================
; TESTE 4 — alloc_page HEX
; =========================

call pmm_alloc_page
call pmm_alloc_page

mov eax, eax

shr eax, 12

mov bl, al

; high nibble
mov al, bl
shr al, 4
call print_hex_digit

mov ah, 7
mov [edi+10], ax

; low nibble
mov al, bl
and al, 0x0F
call print_hex_digit

mov ah, 7
mov [edi+12], ax


print_hex_digit:

    cmp al, 9
    jbe .num

    add al, 7

.num:
    add al, '0'
    ret

hang:
    jmp hang


%include "pmm.asm"
;%include "screen.asm"
    
    
    
    
    
    
    
    
    

;kernel_start:

  ;  cli

    ; =========================
    ; TESTE MÍNIMO
    ; =========================
 ;;   mov edi, 0xB8000
  ;  mov eax, 0x07200758    ; 'X'
  ;  mov [edi], eax

  ;  mov edi, 0xB8000

 ;   mov eax, 0x0720074B    ; 'k'
 ;   mov [edi], eax

  ;  jmp $

;mov edi, 0xB8000
;mov eax, 0x07204B4F   ; "OK"
;mov [edi], eax

;.loop:
 ;   hlt
 ;   jmp .loop