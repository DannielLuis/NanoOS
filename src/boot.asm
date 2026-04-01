[org 0x7C00]
[bits 16]

start:

    cli

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    sti

    mov [BOOT_DRIVE], dl

; =========================
; mensagem
; =========================
    mov si, msg
    call print


; =========================
; carregar stage2 (loader)
; =========================

    xor ax, ax
    mov es, ax

    mov bx, 0x8000

    mov dh, LOADER_SECTORS

    call disk_load


; =========================
; debug OK
; =========================
    mov si, ok_msg
    call print


; =========================
; passar info
; =========================
    mov [0x7E00], dl
    mov byte [0x7E01], KERNEL_SECTOR


; =========================
; pular pro loader
; =========================
    jmp 0x0000:0x8000


; =============================================
; disk_load (versão segura)
; com DAP (mais moderna, suporta mais setores)
; LBA que o modelo moderno em vez de CHS
; =============================================
disk_load:

    push ax
    push bx
    push cx
    push dx
    push si

    mov dl, [BOOT_DRIVE]

    mov si, dap

    mov word [si], 0x0010     ; tamanho DAP
    mov word [si+2], 10        ; LOADER_SECTORS
    mov word [si+4], 0x8000   ; offset
    mov word [si+6], 0x0000   ; segmento

    mov dword [si+8], 2       ; LBA = 2 (loader começa aqui)
    mov dword [si+12], 0

    mov ah, 0x42
    int 0x13
    jc disk_error

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret


; =========================
; disk_load (VERSÃO SEGURA)
; =========================
disk_load_b:

    push ax
    push bx
    push cx
    push dx
    push es

    mov dl, [BOOT_DRIVE]

    mov ah, 0x02
    mov al, dh

    mov ch, 0
    mov dh, 0
    mov cl, 3        ; começa no setor 2 da PARTIÇÃO

    int 0x13
    jc disk_error

    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret


disk_error:
    mov si, msg_error
    call print
    jmp $


; =========================
; print
; =========================
print:
.loop:
    lodsb
    cmp al, 0
    je .done

    mov ah, 0x0E
    int 0x10

    jmp .loop
.done:
    ret

dap:
    times 16 db 0

; =========================
; dados
; =========================

LOADER_SECTORS equ 2
KERNEL_SECTOR equ 6

BOOT_DRIVE db 0

msg db "NanoOS VBR", 0
ok_msg db " stage2 loaded",0
msg_error db "Disk error",0


times 510-($-$$) db 0
dw 0xAA55