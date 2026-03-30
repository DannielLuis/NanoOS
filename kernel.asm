[bits 32]
[org 0x10000]

jmp kernel_start   ; <-- GARANTE posição 0


;%include "screen.asm"


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

    ; ================================
    ; linha superior
    ; ================================
    mov dword [cursor_y], 0
    call draw_line
 ;;;;;;;   mov esi, line80
 ;;;;;;;;   call print_string_pm


    ; ================================
    ; título
    ; ================================
    mov esi, title
    mov eax, 30    ;31    ;25   ; posição X (centralizado manual)
    mov ebx, 1    ;0    linha
    call print_at


    ; ================================
    ; linha inferior
    ; ================================
  ;  mov eax, 25        ; posição X (centralizado manual)
 ;   mov ebx, 4    ;0    linha
    ; dword é usado para garantir que estamos 
    ; escrevendo um valor de 32 bits
    mov dword [cursor_y], 2 ; linha 2
  ;  call set_cursor
    call draw_line



    call newline_pm
    call newline_pm


    mov esi, msg_a
    call print_string_pm


    call newline_pm
    call newline_pm


  ;  mov esi, msg_b
  ;  call print_string_pm

   ; call newline_pm


  ;  mov eax, 0        ; posição X
   ; mov ebx, 10       ; posição Y
  ;  mov dword [cursor_x], 0
  ;  mov dword [cursor_y], 20
   ; call set_cursor

 ;;;;;;;   call update_cursor


    mov esi, msg_b
    call log_info
    
    mov esi, msg1
    call log_ok

    mov esi, msg2
    call log_warn

    mov esi, msg3
    call log_err


  ;  mov eax, 0        ; posição X
   ; mov ebx, 10       ; posição Y
  ;  mov dword [cursor_y], 20
  ;  call set_cursor

.loop:
    hlt
    jmp .loop



;section .data




; ================================
; Mensagens de log
; ================================
title db "NanoOS Kernel v1.0", 0

msg_a   db " NanoOS Kernel iniciado" , 0
msg_b   db "Sistema de logs OK" , 0

msg1    db "Inicializando kernel...", 0
msg2    db "IDT sem handlers ...",0
msg3    db "Falha ao carregar driver", 0






; =================================
; Incluindo outros arquivos
; =================================
%include "pmm.asm"
%include "screen.asm"
    
    
    
    
    
    
    
    
    

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