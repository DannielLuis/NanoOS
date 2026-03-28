[bits 16]

FS_START equ 20
FS_SECTORS equ 2
FS_ADDR  equ 0x5000

KERNEL_LOAD_SEG equ 0x1000
KERNEL_LOAD_OFF equ 0x0000

; =========================
; load_kernel
; =========================
load_kernel:

    pusha

    ; =========================
    ; garantir segmentos corretos
    ; =========================
    xor ax, ax  ; limpar ax
    mov ds, ax  ; ds = 0
    mov es, ax  ; es = 0

    ; =========================
    ; DEBUG: lendo FS
    ; =========================
    mov si, msg_fs_read
    call print
    ;call newline

    ; =========================
    ; ler FS via CHS
    ; =========================
    ; Carregar FS (setor 20)
    ; =========================
    mov bx, FS_ADDR

    mov ax, FS_START
    call lba_to_chs

    mov ah, 0x02
    mov al, 1
    mov dl, [BOOT_DRIVE]

    int 0x13
    ;jc disk_error
    jc .fs_fail

    ; =========================
    ; DEBUG: lendo FS
    ; =========================
    mov si, msg_ok
    call print
    jmp .fs_done


.fs_fail:
    mov si, msg_fail
    call print

    popa
    stc

    jmp $

   ; ret

.fs_done:
    call newline

    ; =========================
    ; Conteudo do  Mini-FS
    ; =========================
    mov si, msg_fs    ; [ Mini-FS ]
    call print

    call newline

   ; mov si, msg_fs_space    ; Tabulação de 4 espaços
   ; call print

    ;mov si, msg_fs_ok
    ;call print

    mov si, FS_ADDR
    ;mov cx, 1   ; só 1 entrada por enquanto
    ;mov cx, 4   ; só 1 entrada por enquanto
    ;mov cx, 16  ; 16 entradas (256 bytes)

    mov cx, 64   ; 64 entradas (1024 bytes)

.fs_loop:
    cmp byte [si], 0
    ;je .fs_end
    je .done_fs

    push si ; salvar ponteiro da entrada atual
    mov si, msg_fs_space    ; Tabulação de 4 espaços
    call print
    pop si  ; restaurar ponteiro da entrada atual

    ; imprimir nome (12 bytes)
    mov di, 12

.print_name:
    mov al, [si]
    call print_char
    inc si
    dec di
    jnz .print_name

    ; espaço
    mov al, ' '
    call print_char

    ; LBA
    mov al, [si]
    xor ah, ah
    call print_hex

    ; espaço
    mov al, ' '
    call print_char

    ; SIZE
    mov al, [si+1]
    xor ah, ah
    call print_hex

    call newline

    add si, 4   ; pular resto da entrada
    loop .fs_loop

.done_fs:

    ; =========================
    ; Log do Mini-FS lido
    ; =========================
    mov si, msg_fs_ok
    call print
    call newline

    ; =========================
    ; procurar KERNEL
    ; =========================
    mov si, FS_ADDR
    mov cx, 16

.find:

    push si
    push cx

    mov di, kernel_name
    mov cx, 12

.compare:
    mov al, [si]
    cmp al, [di]
    jne .next

    inc si
    inc di
    loop .compare

    ; encontrado
    pop cx
    pop si

    mov al, [si+12]
    mov ah, [si+13]

    mov [kernel_lba], al
    mov [kernel_size], ah

    mov si, msg_fs_ok
    call print
    call newline

    jmp load_kernel_sectors

.next:
    pop cx
    pop si

    add si, 16
    loop .find

    jmp disk_error


; =========================
; carregar kernel via LBA
; =========================
load_kernel_sectors:

   ; mov cl, [kernel_size]   ; quantidade de setores
    mov ch, [kernel_size]   ; usar CH como contador
    mov bl, [kernel_lba]    ; LBA (NÃO usar DL)

    mov ax, KERNEL_LOAD_SEG
    mov es, ax

    xor di, di              ; offset = 0

.read_loop:

    ;cmp cl, 0
    cmp ch, 0
    je .done

    ; LBA -> CHS
    mov al, bl
    xor ah, ah
    call lba_to_chs

    mov ah, 0x02
    mov al, 1
    mov dl, [BOOT_DRIVE]

    mov bx, di              ; destino correto

    int 0x13
    jc disk_error

    ; DEBUG (opcional)
    mov si, msg_ok
    call print
    call newline

    ; próximo setor
    inc bl                  ; LBA++
    dec cl                  ; contador--

    add di, 512             ; avançar memória (CORRETO)
    jmp .read_loop

.done:
    popa
    clc
    ret
    


disk_error:
    popa
    stc

    jmp $

    ret



lba_to_chs:

    xor dx, dx
    div word [spt]

    mov cl, dl
    inc cl

    xor dx, dx
    div word [heads]

    mov dh, dl
    mov ch, al

    ret



print_hex:
    push ax
    push bx

    mov bx, ax

    mov al, bh
    call print_hex_byte

    mov al, bl
    call print_hex_byte

    pop bx
    pop ax
    ret

print_hex_byte:
    push ax

    shr al, 4
    call hex_digit

    pop ax
    and al, 0x0F
    call hex_digit

    ret

hex_digit:
    cmp al, 9
    jbe .num
    add al, 'A' - 10
    jmp .out
.num:
    add al, '0'
.out:
    mov ah, 0x0E
    int 0x10
    ret


print_char:
    mov ah, 0x0E
    int 0x10
    ret
    


    
SECTORS_PER_TRACK equ 18
HEADS equ 2

spt   dw SECTORS_PER_TRACK
heads dw HEADS



msg_fs_read     db " Mini-FS encontrado ... ", 0
msg_fs          db " [ Mini-FS ]", 0
msg_fs_space    db " -    ", 0

msg_fs_ok db "[FS OK]", 0
;msg_fs_read     db " [ FS READ ] ",0


kernel_name db "KERNEL      "

kernel_lba  db 0
kernel_size db 0
    
    
    
    
    