[org 0x8000]
;;[org 0]
[bits 16]

jmp start

;;%include "loader.inc"

;;jmp start

start:

    cli
    
    mov ah,0x0E
    mov al,'L'
    int 0x10

    mov si, loader_msg
    call print

   ; cli

    call load_kernel

    mov si,msg_loaded
    call print

    mov si, msg0
    call print

    call enable_a20

    mov si, msg1
    call print

    call load_gdt

    mov si, msg2
    call print

    call enter_protected_mode

   ;; mov si, msg3
   ;; call print

hang:
    jmp hang


; =====================
; print
; =====================

print:
    mov ah, 0x0E
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop

;.next:
 ;   lodsb
 ;   or al, al
  ;  jz .done

 ;   mov ah, 0x0E
  ;  int 0x10

  ;  jmp .next

.done:
    ret


msg0 db " loader",0
msg1 db " A20",0
msg2 db " GDT",0
msg3 db " PMODE",0
loader_msg db "NanoOS loader",0
msg_loaded db " kernel loaded",0

%include "loader/loader.inc"