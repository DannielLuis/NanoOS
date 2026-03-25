[org 0x8000]
[bits 16]

jmp start    ; pular para o início


start:

    cli

    ; ===== carregar info do boot.asm =====
    mov al, [0x7E00]       ; boot drive
    mov [BOOT_DRIVE], al

    mov al, [0x7E01]       ; kernel sector
    mov [KERNEL_SECTOR], al

    
    ; ===== print "L" =====
    mov ah, 0x0E
    mov al, 'L'
    int 0x10


    ; ===== print loader_msg =====
    mov si, loader_msg
    call print

    ; ===== carregar kernel =====
    call load_kernel
    mov si, msg_loaded
    call print

    ; ===== detectar memória =====
    call detect_memory
    mov si, msg0
    call print

    ; ===== ativar A20 =====
    call enable_a20
    mov si, msg1
    call print

    ; ===== carregar GDT =====
    call load_gdt
    mov si, msg2
    call print

    ; ===== entrar em protected mode =====
    call enter_protected_mode
    ;; mov si, msg3
    ;; call print

hang:
    jmp hang


; =====================
; rotina de print simples
; =====================

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


; =====================
; mensagens
; =====================
;msg0 db " loader memory map",0
msg0 db " loader",0

msg1 db " A20",0
msg2 db " GDT",0
msg3 db " PMODE",0
loader_msg db "NanoOS loader",0
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