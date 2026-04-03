[org 0x8000]
[bits 16]

jmp start    ; pular para o início


start:

    cli

    xor ax, ax
    mov ds, ax
    mov es, ax

    call header

    ; ===== carregar info do boot.asm =====
    mov al, [0x7E00]       ; boot drive
    mov [BOOT_DRIVE], al

 ;   mov al, [0x7E01]       ; kernel sector
 ;   mov [KERNEL_SECTOR], al

    
    ; ===== print "L" =====
  ;  mov ah, 0x0E
   ; mov al, 'L'
   ; int 0x10


    ; ===== print loader_msg =====
    ;mov si, msg_teste
    ;mov si, msg_space
    ;call print

    mov si, loader_msg
    call print

    call newline

    ; ===== carregar kernel =====
    ; Aqui precisarei fazer algum tipo de teste
    ; para saber se o kernel foi realmente carregado,
    ; a minha ideia é apos achar o kernel e carregar na ram,
    ; salvar uma informação em uma variavel ou direto em um
    ; endereço da ram, apos a call load_kernel ferificar se
    ; a informação é verdadeira ou falsa para depois descidir
    ; a mensagem log que sera mostrada, mas por enquanto ficara
    ; assim do jeito que esta.
  ;  call load_kernel
    ;mov si, msg_loaded
    ;call print

    ;call newline

  ;  mov si, msg_loading
  ;  call print

  ;  call load_kernel
 ;   jc .kernel_fail

 ;   mov si, msg_ok
 ;   call print
 ;   jmp .kernel_done

;.kernel_fail:
  ;  mov si, msg_fail
 ;   call print

;.kernel_done:
  ;  call newline





    
    
    
    
    
    
    
    

    

    ; ===== detectar memória =====
  ;  call detect_memory
  ;  mov si, msg_memory  ;msg0
 ;   call print

  ;  call newline


    mov si, msg_memory
    call print
    call newline

    call detect_memory
    jc .mem_fail

    mov si, msg_ok
    call print
    jmp .mem_done


.mem_fail:
    mov si, msg_fail
    call print

.mem_done:
    call newline
    
    
    
   ; call log_teste

   ; jmp $

    
    
    ; ===== carregar kernel =====
   ; mov si, msg_loading
   ; call print

    ;call find_kernel
    ;jc .kernel_fail


    call load_kernel
    jc .kernel_fail

    mov si, msg_ok
    call print
    jmp .kernel_done

.kernel_fail:
    mov si, msg_fail
    call print

.kernel_done:
    call newline
    
    
    
    
    

    
    
    
    
    

    ; ===== ativar A20 =====
    call enable_a20
    mov si, msg_a20     ;msg1
    call print

    call newline

    ; ===== carregar GDT =====
    call load_gdt
    mov si, msg_gdt     ;msg2
    call print

    call newline

    ;mov ax, 0x1000  ; segmento de código do kernel
  ;  mov ax, KERNEL_LOAD_SEG  ; segmento de código do kernel --- IGNORE ---
  ;  mov ds, ax      ; segmento de dados do kernel
  ;  mov es, ax      ; segmento extra (para leitura do kernel)

  ;  mov si, 0x0000  ; offset de entrada do kernel

  ;  mov al, [si]    ; primeiro byte do kernel (deve ser 0x7F, 'ELF')
  ;  call print_hex  ; imprimir em hexadecimal para debug
  ;  call newline    ; nova linha

  ;  mov al, [si+1]  ; segundo byte do kernel (deve ser 'E')
  ;  call print_hex  ; imprimir em hexadecimal para debug
  ;  call newline    ; nova linha

  ;  mov al, [si+2]  ; terceiro byte do kernel (deve ser 'L')
  ;  call print_hex  ; imprimir em hexadecimal para debug
  ;  call newline    ; nova linha

   ; jmp $




   ; call log_teste

   ; jmp $



 ;   mov si, MEMORY_MAP_ADDR

 ;   ;mov al, [si+16]
  ;  mov ax, [si+16]
 ;   call print_hex
 ;   call newline

  ;  mov si, MEMORY_MAP_ADDR

  ;  mov ax, [si]
  ;  call print_hex
  ;  call newline

 ;   mov ax, [si+8]
 ;   call print_hex
  ;  call newline

  ;  mov ax, [si+12]
  ;  call print_hex
  ;  call newline

  ;  mov ax, [si+16]
  ;  call print_hex
 ;   call newline

  ;  mov ax, [si+18]
  ;  call print_hex

   ; jmp $






  ;  mov si, MEMORY_MAP_ADDR    ; 0x6000
  ;  mov di, 0x9000             ; NOVO LOCAL SEGURO
  ;  mov cx, 512                ; copia 512 bytes (mais que suficiente)

;.copy:
  ;  mov al, [si]
  ;  mov [di], al
  ;  inc si
  ;  inc di
  ;  loop .copy

  ;  ;mov si, [0x9000]
  ;  ;mov ax, [si+16]
  ;  mov ax, [0x9000+16]
  ;  call print_hex

    call log_teste

   ; jmp $

    ; ===== entrar em protected mode =====
    call enter_protected_mode
    ;; mov si, msg3
    ;; call print

hang:
    jmp hang


log_teste:
    mov si, tamanho_da_entidade
    mov ax, [si]
    call print

    mov si, last_entry_size
    mov ax, [si]
    call print_hex

   ; mov al, ' '
   ; mov ah, 0x0E
   ; int 0x10
    call newline

    mov si, tamanho_da_lista
    mov ax, [si]
    call print

    mov si, MEMORY_MAP_COUNT
    mov ax, [si]
    call print_hex

   ; mov al, ' '
   ; mov ah, 0x0E
   ; int 0x10
    call newline
    call newline

  ;  mov al, '-'
  ;  mov ah, 0x0E
  ;  int 0x10

  ;  mov al, ' '
  ;  mov ah, 0x0E
  ;  int 0x10

    mov si, MEMORY_MAP_ADDR
    mov cl, [MEMORY_MAP_COUNT]

.loop:
    ; print base low
  ;  mov ax, [si]
  ;  call print_hex

    ; print length low
  ;  mov ax, [si+8]
  ;  call print_hex

    ; print type
  ;  mov ax, [si+16]
  ;  call print_hex

  ;  call newline

  ;  add si, 24
   ; dec cl
   ; jnz .loop









    ; base low
    ;mov si, di      ; ainda em teste
    mov ax, [si]
   ; mov [di], ax
   ; mov ax, [es:di] ; ainda em teste
    call print_hex

    ; base high
    mov ax, [si+4]
   ; mov [di+4], ax
    call print_hex

    mov al, ' '
    mov ah, 0x0E
    int 0x10

    ; length low
    mov ax, [si+8]
  ;  mov [di+8], ax
    call print_hex

    ; length high
    mov ax, [si+12]
  ;  mov [di+12], ax
    call print_hex

    mov al, ' '
    mov ah, 0x0E
    int 0x10

    ; type
  ;  mov ax, [si+16]
   ; call print_hex

  ;  mov ax, [si+24]
  ;  call print_hex


    mov ax, [si+16]     ; type
    mov [di+16], ax
    call print_hex

  ;  mov ax, [si+24]     ; tipo extra (se existir)
  ;  mov [di+24], ax
  ;  call print_hex





   ; mov eax, [es:di]
  ;  mov ax, [es:di]
  ;  mov ax, [si]
  ;  call print_hex

  ;  mov al, '-'
  ;  mov ah, 0x0E
  ;  int 0x10

    ; length low
  ;  mov eax, [es:di+8]
  ;  call print_hex

  ;  mov al, ' '
  ;  mov ah, 0x0E
  ;  int 0x10

    ; type
  ;  mov eax, [es:di+16]
  ;  call print_hex

  ;  mov al, ' '
  ;  mov ah, 0x0E
  ;  int 0x10

   ; ; type
  ;  mov eax, [es:di+20]
  ;  call print_hex




    ; base low
  ;  mov eax, [es:di]
  ;  call print_hex

  ;  mov al, '-'
  ;  mov ah, 0x0E
  ;  int 0x10

    ; length low
  ;  mov eax, [es:di+8]
  ;  call print_hex

  ;  mov al, ' '
  ;  mov ah, 0x0E
  ;  int 0x10

    ; type
  ;  mov eax, [es:di+16]
  ;  call print_hex

    call newline

   ; add si, 20  ; próxima entrada 24 ou 20 (dependendo do que o BIOS retornar)
    ;add si, 24  ; próxima entrada 24 ou 20 (dependendo do que o BIOS retornar)
    add si, [last_entry_size] ; próxima entrada (tamanho da última entrada retornada pelo BIOS)
    dec cl
    jnz .loop

    ret


tamanho_da_entidade db "tamanho da entidade: ", 0
tamanho_da_lista db "tamanho da lista: ", 0



header:
    call clear_screen
    call set_cursor_top

    mov si, line
    call print
    mov si, line
    call print

    ; título
    mov si, pre_title
    call print

    mov si, title
    call print

    call newline

    mov si, line
    call print
    mov si, line
    call print

    call newline
    call newline

    call delay
   ; call delay_1s

    ret


 
    
; ================================
; STRINGS
; ================================
pre_title db "                    ", 0
title db "NanoOS Loader v1.0 - Prototipo",0
;line  db "----------------------------------------", 0 ; 40
;line  db "────────────────────────────────────────",0
line db 40 dup(0xC4),0

 
 
msg_ok    db "OK", 0
msg_fail  db "FAIL", 0
 
msg_teste db " [ ] ", 0
msg_space db " ", 0

;msg_memory db "Detecting Memory ... ",0


; [ OK ]
; [ FAIL ]
; [ WARN ]

 
 
 
; =====================
; mensagens
; =====================
loader_msg db " Iniciando NanoOS loader", 0
msg_memory db " Detectando Memoria ... ", 0
msg_a20    db " A20 habilitada",0
msg_gdt    db " GDT carregado",0


;msg0 db " loader memory map",0
msg0 db " loader",0

msg1 db " A20",0
msg2 db " GDT",0
msg3 db " PMODE",0
msg_loaded db " kernel loaded",0


msg_loading db "Loading KERNEL ... ",0
;msg_ok      db "OK",0
;msg_fail    db "FAIL",0
 
 
 
 
 
 

 
 
 
 
 
 
 
 
; =====================
; variáveis passadas do boot
; =====================
KERNEL_SECTOR db 0
BOOT_DRIVE   db 0


; =====================
; include das rotinas do loader
; =====================
%include "loader/loader.inc"