; NanoOS stage2 entry

;; versão 2

BITS 16
; ORG 0x8000

global start

;;extern loader_main
extern enable_a20
extern load_gdt
extern enter_protected

section .text.start

start:

    ; ajustar segmentos para o loader em 0x0800:0
    mov ax, 0x0800
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x9F00

    ; mostrar mensagem direta no VGA (sem dependência de label)
    mov ax, 0xB800
    mov es, ax
    mov di, 0
    mov word [es:di], 'N' | 0x0700
    mov word [es:di+2], 'L' | 0x0700
    mov word [es:di+4], 'D' | 0x0700
    mov word [es:di+6], 'R' | 0x0700

    ; debug serial loader started
    mov dx, 0x3F8
    mov al, 'L'
    out dx, al
    mov al, 'o'
    out dx, al
    mov al, 'a'
    out dx, al
    mov al, 'd'
    out dx, al
    mov al, 'e'
    out dx, al
    mov al, 'r'
    out dx, al
    mov al, ' '
    out dx, al
    mov al, 's'
    out dx, al
    mov al, 't'
    out dx, al
    mov al, 'a'
    out dx, al
    mov al, 'r'
    out dx, al
    mov al, 't'
    out dx, al
    mov al, 'e'
    out dx, al
    mov al, 'd'
    out dx, al
    mov al, 0x0D
    out dx, al
    mov al, 0x0A
    out dx, al

    ; pegar drive do boot via 0x7DFE (bootloader salvou lá)
    push ds
    xor ax, ax
    mov ds, ax
    mov dl, [0x7DFE]
    pop ds
    ; Se o boot foi por floppy (DL=0), manter 0x00; se foi por HDD (DL=0x80), manter 0x80.
    ; Não sobrescrever com valor errado que causa falha em disco floppy.

    ; carregar kernel em 0x10000 (segmento 0x1000)
    mov ax, 0x1000
    mov es, ax
    xor bx, bx
    mov ah, 0x02
    mov al, 2        ; 2 setores (kernel ~555 bytes)
    mov ch, 0        ; cilindro 0 (LBA 20 em disco floppy)
    mov cl, 3        ; setor 3 (setor BIOS = 3)
    mov dh, 1        ; cabeça 1 (LBA 20 -> C=0,H=1,S=3)
    ; DL contém drive correto (floppy=0, hdd=0x80)
    int 0x13
    jc hang

    ; debug serial kernel loaded
    mov dx, 0x3F8
    mov al, 'K'
    out dx, al
    mov al, 'e'
    out dx, al
    mov al, 'r'
    out dx, al
    mov al, 'n'
    out dx, al
    mov al, 'e'
    out dx, al
    mov al, 'l'
    out dx, al
    mov al, ' '
    out dx, al
    mov al, 'l'
    out dx, al
    mov al, 'o'
    out dx, al
    mov al, 'a'
    out dx, al
    mov al, 'd'
    out dx, al
    mov al, 'e'
    out dx, al
    mov al, 'd'
    out dx, al
    mov al, 0x0D
    out dx, al
    mov al, 0x0A
    out dx, al

    ; mostrar que kernel foi lido
    mov ax, 0xB800
    mov es, ax
    mov di, 32
    mov word [es:di], 'K' | 0x0700
    mov word [es:di+2], 'O' | 0x0700
    mov word [es:di+4], 'D' | 0x0700
    mov word [es:di+6], 'E' | 0x0700

    ; debug: mostrar OK em VGA segunda coluna
    mov ax, 0xB800
    mov es, ax
    mov di, 16
    mov word [es:di], 'O' | 0x0700
    mov word [es:di+2], 'K' | 0x0700

    ; debug serial
    mov dx, 0x3F8
    mov al, 'L'
    out dx, al
    mov al, 'O'
    out dx, al
    mov al, 'A'
    out dx, al
    mov al, 'D'
    out dx, al
    mov al, 0x0D
    out dx, al
    mov al, 0x0A
    out dx, al

    ; ativar e entrar em protegido
    cli
    call enable_a20
    call load_gdt
    call enter_protected

hang:
    hlt
    jmp hang

.print_loop:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0x0E
    mov bh, 0
    mov bl, 0x07
    int 0x10
    jmp .print_loop
.done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret

section .data
loader_msg db "NanoOS loader",0
