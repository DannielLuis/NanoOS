[bits 16]

;FS_START equ 20
FS_START equ 10
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
    mov al, 1                   ; ler 1 setor por vez
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

   ; mov dword [kernel_lba], [al+1]   ; LBA start
   ; mov dword [kernel_lba], 0
   ; mov [kernel_lba], [si+12]   ; LBA start

    inc al
    mov [kernel_lba], al
   ; mov [kernel_size], ah
   ; mov [kernel_lba], 1Eh
  ;  mov [kernel_size], 2

  ;  mov si, msg_fs_ok
  ;  call print
  ;  call newline

   ; jmp load_kernel_sectors

   ; jmp $

    jmp testando


.next:
    pop cx
    pop si

    add si, 16
    loop .find

    jmp disk_error

testando:
  ;  pusha

  ;  mov ax, 0x1000      ; segmento onde o kernel será carregado
    mov ax, KERNEL_LOAD_SEG ; segmento onde o kernel será carregado
    mov es, ax          ; definir ES para o segmento destino
    xor bx, bx          ; offset = 0

    mov ah, 0x02        ; ler setor
    mov al, 3           ; 1 setor
    mov ch, 0           ; cilindro 0
 ;   mov cl, 30          ; setor onde você colocou o kernel
   ; mov cl, 16          ; setor onde você colocou o kernel
    mov cl, [kernel_lba] ; setor onde o kernel está localizado (LBA)
    mov dh, 0           ; cabeça 0
    mov dl, [BOOT_DRIVE]



   ; kernel_lba
   ; kernel_size


    ;mov ax, 0x1000  ; segmento de código do kernel
 ;   mov ax, KERNEL_LOAD_SEG  ; segmento de código do kernel --- IGNORE ---
 ;   mov ds, ax      ; segmento de dados do kernel
 ;   mov es, ax      ; segmento extra (para leitura do kernel)

 ;   mov si, 0x0000  ; offset de entrada do kernel

 ;   mov al, [si]    ; primeiro byte do kernel (deve ser 0x7F, 'ELF')
;    call print_hex  ; imprimir em hexadecimal para debug
 ;   call newline    ; nova linha

 ;   pusha
 ;   mov al, [si+1]  ; segundo byte do kernel (deve ser 'E')
;    call print_hex  ; imprimir em hexadecimal para debug
 ;   call newline    ; nova linha
 ;   popa

  ;  mov al, [si+2]  ; terceiro byte do kernel (deve ser 'L')
   ; call print_hex  ; imprimir em hexadecimal para debug
    ;call newline    ; nova linha

  ;  mov al, kernel_size
   ; call print_hex  ; imprimir em hexadecimal para debug
   ; call newline    ; nova linha

   ; mov si, msg_fs_ok
   ; mov si, kernel_size
   ; call print

  ;  mov si, msg_fs_ok
 ;   call print

    ;mov al, kernel_lba
    ;mov al, [kernel_lba]
    ;mov al, 2

   ; mov si, 0x001E    
    ;mov ax, 0x00001E
   ; mov al, [si]
    
 ;   mov si, kernel_lba
 ;   mov al, [si]
 ;   call print_hex  ; imprimir em hexadecimal para debug
 ;   call newline    ; nova linha


 ;   jmp $



   ; mov bx, FS_ADDR
 ;   mov bx, KERNEL_LOAD_OFF

 ;   mov ax, KERNEL_LOAD_SEG
  ;  mov es, ax          ; definir ES para o segmento destino


 ;  ; mov al, [kernel_lba]
 ;   xor ah, ah
 ;   mov bl, al        ; LBA → BL

  ;  jmp $

 ;   call lba_to_chs_b

   ; mov si, msg_fs_ok
  ;  call print
 ;   call newline

  ;  mov ah, 0x02
  ;  mov al, 1
 ;   mov dl, [BOOT_DRIVE]

    ;mov si, msg_fs_ok
   ; call print
   ; call newline

    int 0x13
    jc disk_error

    mov si, msg_fs_ok
    call print
    call newline

  ;  ret
.done:
    popa
    clc
    ret

lba_to_chs_b:

    ; entrada: BL = LBA
    ; saída:
    ; CH = cilindro
    ; CL = setor
    ; DH = cabeça

 ;   mov si, msg_fs_ok
  ;  call print
  ;  call newline

    xor ax, ax
    mov al, bl

    xor dx, dx
    div byte [spt]      ; AX / 18

    mov cl, dl          ; resto
    inc cl              ; setor começa em 1

    xor dx, dx
    div byte [heads]    ; dividir por 2

    mov dh, dl          ; cabeça
    mov ch, al          ; cilindro

  ;  mov si, msg_fs_ok
  ;  call print
   ; call newline

    ret



; =========================
; carregar kernel via LBA
; =========================
load_kernel_sectors:
    pusha

    ;mov cl, [kernel_size]   ; quantidade de setores
    ;mov ch, [kernel_size]   ; usar CH como contador

    ;xor cx, cx
    ;mov cl, [kernel_size]
    ;mov si, cx

    ;mov si, 0
    ;mov cl, [kernel_size]   ; usar CL como contador
    ;mov si, cx 

   ; mov bl, [kernel_lba]    ; LBA (NÃO usar DL)

   ; mov ax, KERNEL_LOAD_SEG
   ; mov es, ax

   ; xor di, di              ; offset = 0

    xor cx, cx
    mov cl, [kernel_size]   ; contador correto

    mov bl, [kernel_lba]

    mov ax, KERNEL_LOAD_SEG
    mov es, ax

    xor bx, bx              ; offset = 0

.read_loop:

    cmp cl, 0
    ;cmp ch, 0
    ;cmp si, 0
    ;cmp cx, 0
    je .done

    ; LBA -> CHS
    mov al, bl
    ;xor ah, ah
    call lba_to_chs

   ; mov ax, KERNEL_LOAD_SEG ; segmento destino (0x1000, 0x2000, etc)
   ; mov es, ax ; definir ES para o segmento destino
    ;mov bx, di              ; offset destino (0x0000, 0x1000, etc)

    mov ah, 0x02
    mov al, 1                   ; ler 1 setor por vez
    ;mov al, cl                  ; ler todos os setores de uma vez (se possível)
    ;mov al, FS_SECTORS   ; ler o número de setores do FS (2 setores)
    mov dl, [BOOT_DRIVE]


    ;mov bx, di              ; destino correto

    int 0x13
    jc disk_error

    ; DEBUG (opcional)
    ;push si
   ; push cx
   ; push bx
   ; push dx
   ; mov si, msg_ok
   ; call print
  ;  call newline
    ;pop si
   ; pop dx
   ; pop bx
   ; pop cx

    ; próximo setor
    inc bl                  ; LBA++
    dec cl                  ; contador--
    ;dec ch                  ; contador--
    ;dec si                  ; contador--
    ;dec cx                  ; contador--

    ;add di, 512             ; avançar memória (CORRETO)
    
    add bx, 512
   ; jnc .ok
  ;  add ax, 0x20
 ;   mov es, ax
;.ok:
    ; ajuste de segmento (CRÍTICO)
    jnc .read_loop

    mov ax, es
    add ax, 0x1000     ; +64KB
    mov es, ax
    xor bx, bx

    jmp .read_loop

.done:
    popa
    clc
    ret
    


disk_error:
    popa
    stc

   ; jmp $

    ret

;lba_to_chs:

  ;  xor ah, ah        ; AX = LBA

   ; mov bl, 18        ; SPT
  ;  div bl            ; AL = LBA/SPT, AH = resto

  ;  mov cl, ah
  ;  inc cl            ; setor (1–18)

  ;  xor ah, ah
  ;  mov bl, 2         ; heads
   ; div bl            ; AL = cilindro, AH = head

   ; mov dh, ah        ; head
  ;  mov ch, al        ; cilindro

  ;  ret

lba_to_chs:

    ; entrada: BL = LBA
    ; saída:
    ; CH = cilindro
    ; CL = setor
    ; DH = cabeça

   ; xor ax, ax
 ;   mov al, bl

    xor dx, dx      ; DX = LBA
    div word [spt]  ; AL = LBA/SPT, AH = LBA%SPT

    mov cl, dl      ; setor = resto
    inc cl          ; setor começa em 1

    xor dx, dx      ; DX = LBA/SPT/heads
    div word [heads]    ; AL = cilindro, AH = cabeça

    mov dh, dl      ; cabeça
    mov ch, al      ;mov ch, ax      ; cilindro

    ret             ; entrada: AL = LBA
                    ; saída: CH, CL, DH


; entrada: AL = LBA
; saída: CH, CL, DH

;lba_to_chs:

 ;   xor ah, ah        ; AX = LBA
  ;  mov bl, 18        ; SPT

 ;   div bl            ; AL = LBA/SPT, AH = LBA%SPT

  ;  mov cl, ah
  ;  inc cl            ; sector (1–18)

   ; xor ah, ah
  ;  mov bl, 2         ; heads

  ;  div bl            ; AL = cylinder, AH = head

  ;  mov dh, ah        ; head
  ;  mov ch, al        ; cylinder

   ; ret




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

;kernel_lba  db 0
;kernel_size db 0

kernel_lba  db 30
kernel_size db 2
    
    
    
    
    