%include "boot_params.inc"

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
; print msg
; =========================
    mov si, msg
    call print


; =========================
; carregar stage2 (loader)
; =========================

    xor ax, ax
    mov es, ax          ; <<< IMPORTANTE

    mov bx, 0x8000      ; destino
   ; mov dh, 5           ; setores para ler
    mov dh, LOADER_SECTORS

    call disk_load


; =========================
; testar se carregou
; =========================

    mov si, ok_msg
    call print


; =========================
; passar info para loader
; =========================

    mov [0x7E00], dl
    mov byte [0x7E01], KERNEL_SECTOR


; =========================
; pular para stage2
; =========================
    jmp 0x0000:0x8000



; =========================
; disk_load
; =========================
disk_load:

    push ax
    push bx
    push cx
    push dx
    push es

    mov ah, 0x02
    mov al, dh

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

  ;  mov si, 0          ; contador
 ;   mov di, bx         ; offset destino (0x8000)

;.read_loop:

 ;   cmp si, LOADER_SECTORS
  ;  je .done

    ; calcular LBA (loader começa no setor 1)
 ;   mov ax, 1
 ;   add ax, si

 ;   call lba_to_chs

 ;   mov ah, 0x02
 ;   mov al, 1
 ;   mov dl, [BOOT_DRIVE]

 ;   mov bx, di

 ;   int 0x13
 ;   jc disk_error

    ; próximo setor
 ;   add di, 512
 ;   inc si

  ;  jmp .read_loop

;.done:
 ;   popa
 ;   ret
    

disk_error:

    mov si, msg_error
    call print

    jmp $


;SECTORS_PER_TRACK equ 18
;HEADS equ 2

;lba_to_chs:

 ;   xor dx, dx
 ;   div word [sectors]

 ;   mov cl, dl
  ;  inc cl

 ;   xor dx, dx
 ;   div word [heads]

  ;  mov dh, dl
  ;  mov ch, al

  ;  ret

;sectors dw SECTORS_PER_TRACK
;heads   dw HEADS
    
    
    
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


.done:
    ret



; =========================

BOOT_DRIVE db 0

msg db "NanoOS boot", 0
ok_msg db " stage2 loaded",0
msg_error db "Disk error",0


times 510-($-$$) db 0
dw 0xAA55