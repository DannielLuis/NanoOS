; ATA Driver for NanoOS
; Este arquivo implementa um driver básico para acessar
; discos ATA usando o protocolo PIO.
; Ele inclui funções para ler setores do disco e detectar
; a presença de um disco ATA.

; eax = LBA
; edi = destino
ata_read_sector:

    pushad

    mov ebx, eax   ; salvar LBA

.wait_bsy:
    mov dx, 0x1F7
    in al, dx
    test al, 0x80
    jnz .wait_bsy

    ; setores = 1
    mov dx, 0x1F2
    mov al, 1
    out dx, al

    ; LBA 0-7
    mov eax, ebx
    mov dx, 0x1F3
    out dx, al

    ; LBA 8-15
    mov dx, 0x1F4
    mov al, ah
    out dx, al

    ; LBA 16-23
    shr eax, 16
    mov dx, 0x1F5
    out dx, al

    ; LBA 24-27 + drive
    mov dx, 0x1F6
    mov al, 0xE0
    or al, ah
    out dx, al

    ; comando READ
    mov dx, 0x1F7
    mov al, 0x20
    out dx, al

.wait_drq:
    in al, dx
    test al, 0x08
    jz .wait_drq

    ; checar erro
    test al, 0x01
    jnz .error

    ; ler 256 words (512 bytes)
    mov dx, 0x1F0
    mov ecx, 256

.read:
    in ax, dx
    mov [edi], ax
    add edi, 2
    loop .read

    popad
    ret

.error:
    popad
    ret


.wait:
    mov dx, 0x1F7
    in al, dx
    test al, 0x80        ; BSY
    jnz .wait

    ; enviar LBA
    mov dx, 0x1F2
    mov al, 1
    out dx, al           ; setores = 1

    mov dx, 0x1F3
    mov al, al           ; LBA low
    out dx, al

    mov dx, 0x1F4
    mov al, ah           ; LBA mid
    out dx, al

    shr eax, 16

    mov dx, 0x1F5
    mov al, al           ; LBA high
    out dx, al

    mov dx, 0x1F6
    mov al, 0xE0         ; master + LBA
    or al, ah
    out dx, al

    ; comando read
    mov dx, 0x1F7
    mov al, 0x20
    out dx, al

;.wait2:
  ;  in al, dx
  ;  test al, 8           ; DRQ
  ;  jz .wait2

  ;  ; ler dados
   ; mov dx, 0x1F0
  ;  mov ecx, 256

;.read:
  ;  in ax, dx
  ;  mov [edi], ax
  ;  add edi, 2
   ; loop .read

  ;  popad
  ;  ret



load_fs:

    ;mov edi, 0x5000      ; buffer do FS
    mov edi, buffer_fs    ; buffer do FS
    mov eax, 20          ; LBA inicial

    mov ecx, 2           ; setores

.loop:
    push eax
    push ecx

    call ata_read_sector

    add edi, 512

    pop ecx
    pop eax

    inc eax
    loop .loop

    ret



fs_find:

    mov esi, buffer_fs
    mov ecx, 64

.next_entry:

    cmp byte [esi], 0
    je .not_found

    push esi
    push ecx

    mov edi, shell_name
    mov ecx, 12

.compare:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne .fail

    inc esi
    inc edi
    dec ecx
    jnz .compare

    ; encontrado
    pop ecx
    pop esi

    mov al, [esi+12]
    mov ah, [esi+13]
    ret

.fail:
    pop ecx
    pop esi

    add esi, 16
    dec ecx
    jnz .next_entry

.not_found:
    xor ax, ax
    ret


fs_find_b:

    ;mov esi, 0x5000 ; buffer onde o FS foi carregado
    mov esi, buffer_fs
    mov ecx, 64

.loop:

    cmp byte [esi], 0
    je .not_found

    push esi
    push ecx

    ;mov edi, kernel_name
    mov edi, shell_name
    mov ecx, 12

.compare:
    mov al, [esi]
    cmp al, [edi]
    jne .next

    inc esi
    inc edi
    loop .compare

    ; encontrado
    pop ecx
    pop esi

    mov al, [esi+12]   ; LBA
    mov ah, [esi+13]   ; SIZE

    ret

.next:
    pop ecx
    pop esi

    add esi, 16
    loop .loop

.not_found:
    xor ax, ax
    ret



load_file:

    ; AL = LBA
    ; AH = SIZE
    ; EDI = destino

    ;movzx eax, al
    ;movzx ecx, ah

    mov eax, 80
    mov ecx, 10

.loop:
    push eax
    push ecx

    call ata_read_sector

    add edi, 512

    pop ecx
    pop eax

    inc eax
    loop .loop

    ret









; FS_START = 20
; FS_SECTORS = 2

;FS_START equ 20
;FS_START equ 10
;FS_SECTORS equ 2






; Função para detectar se um disco ATA está presente
; Retorna 0 se não houver disco, 1 se houver
;ata_detect:
  ;  pushad

  ;  mov dx, 0x1F7
  ;  in al, dx
  ;  test al, 0x80        ; BSY
  ;  jnz .no_disk

  ;  mov al, 0xA0         ; master
  ;  out dx, al

  ;  in al, dx
  ;  test al, 0x40        ; LBA support
  ;  jz .no_disk

  ;  mov eax, 1           ; disco presente
  ;  jmp .done

;.no_disk:
  ;  xor eax, eax         ; sem disco

;.done:
  ;  popad
  ;  ret