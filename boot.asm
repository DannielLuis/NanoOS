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

; print msg
    mov si, msg
    call print


; =========================
; carregar stage2
; =========================

    xor ax, ax
    mov es, ax          ; <<< IMPORTANTE

    mov bx, 0x8000      ; destino
    mov dh, 5           ; setores para ler
   ;; mov dh, 10           ; setores para ler
   ;; mov dh, 2           ; setores para ler

    call disk_load


;mov ax, 0x8000
;mov ds, ax
;mov si, 0
;lodsb
;mov ah,0x0E
;int 0x10
mov si, test_msg
call print

mov bx, 0x8000
mov al, [bx]

mov ah, 0x0E
int 0x10

; =========================
; testar se carregou
; =========================

    mov si, ok_msg
    call print


; =========================
; pular para stage2
; =========================
;mov ax, 0x8000
;mov ds, ax
;mov si, 0
;lodsb
;mov ah,0x0E
;int 0x10

mov [0x7E00], dl         ; BOOT_DRIVE
mov byte [0x7E01], 7     ; KERNEL_SECTOR (TEMPORÁRIO vindo do script)

    jmp 0x0000:0x8000
   ;jmp 0x0800:0x0000



; =========================
; disk_load
; =========================
disk_load:

    push ax
    push bx
    push cx
    push dx
    push es

    xor ax, ax
    mov es, ax

    mov bx, 0x8000

    mov ah, 0x02
   ;; mov al, dh
   ;; mov al, 1
    mov al, 5

    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [BOOT_DRIVE]

    int 0x13

    jc disk_error

    pop es
    pop dx
    pop cx
    pop bx
    pop ax

    ret

;disk_load:

  ;  pusha

  ;  mov ah, 0x02    ; INT13 read
  ;  mov al, dh      ; setores
  ;  mov ch, 0       ; cilindro
  ;  mov cl, 2       ; setor começa em 2
  ;  mov dh, 0       ; cabeça
  ;  mov dl, [BOOT_DRIVE]

  ;  int 0x13

  ;  jc disk_error

   ; popa
  ;  ret


disk_error:

    mov si, msg_error
    call print

    jmp $



; =========================
; print string
; =========================

print:
.loop:
    lodsb
    cmp al, 0
    je .done

    mov ah, 0x0E
    int 0x10

    jmp .loop

;.next:

 ;   lodsb
  ;  or al, al
   ; jz .done

  ;  mov ah, 0x0E
  ;  int 0x10

  ;  jmp .next

.done:
    ret



; =========================

BOOT_DRIVE db 0

msg db "NanoOS boot", 0
ok_msg db " stage2 loaded",0
msg_error db "Disk error",0
test_msg db " check:",0

times 510-($-$$) db 0
dw 0xAA55