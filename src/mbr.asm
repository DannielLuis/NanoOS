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
; copiar MBR para outro lugar (segurança)
; =========================
  ;  mov si, 0x7C00
   ; mov di, 0x0600
   ; mov cx, 512
  ;  rep movsb

    push ds
    push es

    xor ax, ax
    mov ds, ax
    mov es, ax

    mov si, 0x7C00
    mov di, 0x0600
    mov cx, 512
    rep movsb

    pop es
    pop ds





   ; jmp 0x0000:0x0600
   ; jmp 0x0000:0x0600 + (mbr_main - start)
    jmp 0x0000:(0x0600 + (mbr_main - start))


; =========================
; procurar partição ativa
; =========================
; =========================
; execução continua aqui
; =========================
mbr_main:

    mov si, partition_table
    mov cx, 4                  ; 4 entradas

find_active:
    cmp byte [si], 0x80        ; bootável?
    je load_partition

    add si, 16                 ; próxima entrada
    loop find_active

; nenhum ativo
    mov si, msg_no_active
    call print
    jmp $


; =========================
; carregar boot da partição
; =========================
load_partition:

    ; LBA start (offset 8 da entry)
    mov bx, si
    add bx, 8

    mov eax, [bx]              ; LBA inicial

    ; usar INT 13h extensões (LBA)
    mov dl, [BOOT_DRIVE]

    mov si, dap
    mov word [si], 0x0010      ; tamanho DAP
    mov word [si+2], 1         ; setores
    mov word [si+4], 0x7C00    ; offset destino
    mov word [si+6], 0x0000    ; segmento destino
    mov dword [si+8], eax      ; LBA baixo
    mov dword [si+12], 0       ; LBA alto


  ;  mov ah, 0x41
  ;  mov bx, 0x55AA
  ;  int 0x13
  ;  jc disk_error

  ;  cmp bx, 0xAA55
   ; jne disk_error




    mov ah, 0x42
    int 0x13
    jc disk_error

    jmp 0x0000:0x7C00


disk_error:
    mov si, msg_disk_error
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


; =========================
; DAP (Disk Address Packet)
; =========================
dap:
    times 16 db 0


; =========================
; dados
; =========================
BOOT_DRIVE db 0

msg_no_active db "No active partition",0
msg_disk_error db "Disk error",0


; =========================
; tabela de partições (OBRIGATORIO)
; =========================
;partition_table:
   ; times 64 db 0
partition_table:

    ; =========================
    ; PARTIÇÃO 1
    ; =========================
    db 0x80              ; bootável

    db 0x00, 0x02, 0x00  ; CHS início (ignorar)

    db 0x83              ; tipo (Linux genérico)

    db 0xFF, 0xFF, 0xFF  ; CHS fim (ignorar)

    dd 1                 ; LBA início (setor 1 !!!)

    dd 20479             ; tamanho (resto do disco)

    ; =========================
    ; PARTIÇÕES 2–4 (vazias)
    ; =========================
    times 16*3 db 0

times 510-($-$$) db 0
dw 0xAA55