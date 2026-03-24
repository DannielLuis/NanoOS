; NanoOS Bootloader Mínimo Funcional
; 512 bytes boot sector

BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

; salvar drive
    mov [BOOT_DRIVE], dl
    mov [0x7DFE], dl

; print msg
    mov si, msg
    call print

; carregar stage2 (1 setor, loader ocupa 1 setor no momento)
    mov ax, 0x0800   ; segmento destino (0x8000)
    mov es, ax
    xor bx, bx       ; offset 0x0000
    mov ah, 0x02     ; função ler setor
    mov al, 1        ; número de setores = 1
    mov ch, 0        ; cilindro 0
    mov cl, 2        ; setor 2 (boot=1, loader=2)
    mov dh, 0        ; cabeça 0
    mov dl, [BOOT_DRIVE]
    int 0x13
    jc disk_error

; sinal visual de sucesso: já leu stage2, antes de saltar
    mov si, stage2_ok_msg
    call print

; pular para stage2
    jmp 0x0800:0x0000

stage2_ok_msg db "stage2 loaded...\r\n",0

; =========================
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

disk_error:
    mov si, disk_msg
    call print
    jmp $

BOOT_DRIVE db 0
msg db "NanoOS boot", 0
disk_msg db "Disk error", 0

times 510-($-$$) db 0
dw 0xAA55