[org 0x8000]
[bits 16]

jmp start    ; pular para o início


start:

    cli

    call header

    ; ===== carregar info do boot.asm =====
 ;   mov al, [0x7E00]       ; boot drive
 ;   mov [BOOT_DRIVE], al

 ;   mov al, [0x7E01]       ; kernel sector
 ;   mov [KERNEL_SECTOR], al

    
    ; ===== print "L" =====
  ;  mov ah, 0x0E
   ; mov al, 'L'
   ; int 0x10


    ; ===== print loader_msg =====
    ;mov si, msg_teste
    ;mov si, msg_space
    ;call print

    mov si, loader_msg
    call print

    call newline

    ; ===== carregar kernel =====
    ; Aqui precisarei fazer algum tipo de teste
    ; para saber se o kernel foi realmente carregado,
    ; a minha ideia é apos achar o kernel e carregar na ram,
    ; salvar uma informação em uma variavel ou direto em um
    ; endereço da ram, apos a call load_kernel ferificar se
    ; a informação é verdadeira ou falsa para depois descidir
    ; a mensagem log que sera mostrada, mas por enquanto ficara
    ; assim do jeito que esta.
  ;  call load_kernel
    mov si, msg_loaded
    call print

    call newline

    ; ===== detectar memória =====
    call detect_memory
    mov si, msg_memory  ;msg0
    call print

    call newline


    ; ===== ativar A20 =====
  ;  call enable_a20
    mov si, msg_a20     ;msg1
    call print

    call newline

    ; ===== carregar GDT =====
  ;  call load_gdt
    mov si, msg_gdt     ;msg2
    call print

    call newline

    ; ===== entrar em protected mode =====
  ;  call enter_protected_mode
    ;; mov si, msg3
    ;; call print

hang:
    jmp hang


header:
    call clear_screen
    call set_cursor_top

    mov si, line
    call print
    mov si, line
    call print

    ; título
    mov si, pre_title
    call print

    mov si, title
    call print

    call newline

    mov si, line
    call print
    mov si, line
    call print

    call newline
    call newline

    call delay
   ; call delay_1s

    ret



; ================================
; STRINGS
; ================================
pre_title db "                    ", 0
title db "NanoOS Loader v1.0 - Prototipo",0
;line  db "----------------------------------------", 0 ; 40
;line  db "────────────────────────────────────────",0
line db 40 dup(0xC4),0

msg_ok db "OK",0
msg_teste db " [ ] ",0
msg_space db " ",0
 
 

; =====================
; mensagens
; =====================
loader_msg db " Iniciando NanoOS loader", 0
msg_memory db " Memoria detectada", 0
msg_a20    db " A20 habilitada",0
msg_gdt    db " GDT carregado",0


;msg0 db " loader memory map",0
msg0 db " loader",0

msg1 db " A20",0
msg2 db " GDT",0
msg3 db " PMODE",0
msg_loaded db " kernel loaded",0


; =====================
; variáveis passadas do boot
; =====================
KERNEL_SECTOR db 0
BOOT_DRIVE   db 0


; =====================
; include das rotinas do loader
; =====================
%include "loader/loader.inc"