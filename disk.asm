;[bits 32]
;[bits 16]

;load_kernel:

    ; aqui vamos só simular por enquanto
    ; int13 aqui

 ;   ret

[bits 16]

;;KERNEL_SECTOR equ 5   ; <<< AJUSTE MANUAL POR ENQUANTO
KERNEL_SECTOR equ 3   ; <<< AJUSTE MANUAL POR ENQUANTO

load_kernel:

  ;  mov bx, 0x0000
 ;   mov es, bx

   ; mov bx, 0x0000

  ;  mov ax, 0x1000
  ;  mov es, ax
  ;  xor bx, bx

  ;  mov ah, 0x02
  ;  mov al, 20

  ;  mov ch, 0
  ;  mov cl, 2
 ;   mov dh, 0
  ;  mov dl, 0x80

    mov ax,0x1000
    mov es,ax
    xor bx,bx

    mov ah,0x02        ; BIOS read sectors
    mov al,20          ; setores do kernel

    mov ch,0           ; cilindro
    ;;mov cl,3           ; setor inicial
    mov cl, KERNEL_SECTOR

    mov dh,0           ; cabeça
    mov dl,0x00        ; drive (floppy)

    int 0x13

    jc disk_error

    ret

disk_error:
    jmp $

