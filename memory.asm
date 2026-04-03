
; mem.asm - Gerenciamento de memória

; Este arquivo contém funções relacionadas à 
; detecção e gerenciamento de memória.

MEMORY_MAP_ADDR    equ 0x1000 ; endereço onde o mapa de memória é armazenado

;MEMORY_MAP_COUNT   equ 0x1000


MEMORY_MAP_COUNT   equ 0x5FF0 ; pode ser 0x4FF0 dependendo do local onde o mapa é armazenado
;MEMORY_MAP_COUNT   equ 0x4FF0
;MEMORY_MAP_ADDR  equ 0x9000
;MEMORY_MAP_COUNT equ 0x8FF0










; ================================
; Configuração
; ================================
;MEMORY_MAP_ADDR    equ 0x6000
;MEMORY_MAP_COUNT   equ 0x5FF0

FALLBACK_RAM_SIZE  equ 0x02000000    ; 32MB total

; ================================
; Inicialização do sistema de memória
; ================================
init_memory:

    pushad

    ; =============================================================
    ; Simula uma detecção de memória (substitua por detecção real usando E820)
    ; Para teste, vamos assumir que temos 64MB de RAM começando em 1MB
    ; Você deve substituir isso por uma detecção real usando a função E820 do BIOS
    ; ou por um mapa de memória pré-definido (fallback) se a detecção falhar.
    mov byte [MEMORY_MAP_COUNT], 0

    ; Exemplo de mapa de memória (substitua por detecção real)
    ; Base: 1MB, Tamanho: 64MB, Tipo: Usável
  ;  mov dword [memory_entries + 0], 0x00100000   ; base low
  ;  mov dword [memory_entries + 4], 0x00000000   ; base high
  ;  mov dword [memory_entries + 8], 0x04000000   ; length low (64MB)
  ;  mov dword [memory_entries + 12], 0x00000000   ; length high
  ;  mov dword [memory_entries + 16], 1            ; type = utilizável

    ; =============================================================

    ; carregar count vindo do loader
    movzx eax, byte [MEMORY_MAP_COUNT]

    cmp eax, 0
    je .use_fallback

    ; =========================
    ; USAR E820
    ; =========================
    mov esi, msg_mem_e820
    call log_info

    call detect_memory_pm
    jmp .done

.use_fallback:

    ; =========================
    ; FALLBACK MANUAL (32MB)
    ; =========================
    mov esi, msg_mem_fallback
    call log_warn

    call build_fallback_map

    call calculate_total_ram

.done:

    call calculate_total_ram

    popad
    ret



; ================================
; Construir mapa manual
; ================================
build_fallback_map:

    pushad

    mov edi, memory_entries

    ; =========================
    ; REGIÃO 1: memória baixa
    ; =========================
   ; mov dword [edi + 0],  0x00000000   ; base low
   ; mov dword [edi + 4],  0x00000000   ; base high
   ; mov dword [edi + 8],  0x0009FC00   ; length low
   ; mov dword [edi + 12], 0x00000000   ; length high
   ; mov dword [edi + 16], 1            ; type = usable

    ; =========================
    ; REGIÃO 1: IVT + BDA (RESERVADO)
    ; =========================
    mov dword [edi + 0],  0x00000000
    mov dword [edi + 4],  0x00000000
    mov dword [edi + 8],  0x00000500
    mov dword [edi + 12], 0x00000000
    mov dword [edi + 16], 2              ; reservado

    ; =========================
    ; REGIÃO 2: memória alta (1MB → 32MB)
    ; =========================
   ; mov dword [edi + 20], 0x00100000   ; base low
   ; mov dword [edi + 24], 0x00000000   ; base high
   ; mov dword [edi + 28], 0x01F00000   ; length low (31MB)
   ; mov dword [edi + 32], 0x00000000   ; length high
   ; mov dword [edi + 36], 1            ; type = usable

    ; =========================
    ; REGIÃO 2: RAM utilizável baixa
    ; =========================
    mov dword [edi + 20], 0x00000500
    mov dword [edi + 24], 0x00000000
    mov dword [edi + 28], 0x0009F700     ; até ~0x9FC00
    mov dword [edi + 32], 0x00000000
    mov dword [edi + 36], 1              ; utilizável

    ; =========================
    ; REGIÃO 3: BIOS/VGA (RESERVADO)
    ; =========================
    mov dword [edi + 40], 0x000A0000
    mov dword [edi + 44], 0x00000000
    mov dword [edi + 48], 0x00060000     ; até 1MB
    mov dword [edi + 52], 0x00000000
    mov dword [edi + 56], 2              ; reservado

    ; =========================
    ; REGIÃO 4: RAM alta (1MB → 32MB)
    ; =========================
    mov dword [edi + 60], 0x00100000
    mov dword [edi + 64], 0x00000000
    mov dword [edi + 68], 0x01F00000
    mov dword [edi + 72], 0x00000000
    mov dword [edi + 76], 1              ; utilizável

    mov dword [memory_entry_count], 4

    ; total de entradas = 2
   ; mov dword [memory_entry_count], 2

    popad
    ret



msg_mem_e820     db "Usando mapa E820",0
msg_mem_fallback db "Fallback memoria (32MB)",0
;msg_total_ram    db "Total RAM: ",0
















; ================================
; Detectar memória usando o mapa de 
; memória fornecido pelo BIOS
; ================================
detect_memory_pm:

    pushad

    ;mov esi, 0x5000                 ; endereço do mapa

    ;movzx ecx, byte [0x4FF0]        ; quantidade de entradas

    xor ebx, ebx                    ; obrigatório começar com 0
    xor edi, edi                    ; índice de escrita no buffer interno
    xor edx, edx                    ; total de RAM (low)
    mov esi, MEMORY_MAP_ADDR         ; endereço do mapa
    movzx ecx, byte [MEMORY_MAP_COUNT]        ; quantidade de entradas

   ; mov esi, 0x6000                ; endereço do mapa
   ; movzx ecx, byte [0x5FF0]        ; quantidade de entradas

    ; =========================
    ; LOG (opcional)
    ; =========================
    
   ; mov esi, msg_memory
   ; call log_info

    mov edi, memory_entries         ; buffer interno
    xor ebx, ebx                    ; contador válido


   ; movzx eax, byte [MEMORY_MAP_COUNT]
    ;movzx eax, byte [MEMORY_MAP_ADDR+MEMORY_MAP_COUNT]
  ;  movzx eax, byte [MEMORY_MAP_ADDR]
  ;  call print_hex_pm_prefix
   ; call newline_pm

.loop:

    cmp ecx, 0
    je .done

 ;   movzx eax, byte [MEMORY_MAP_COUNT]
  ;  call print_hex_pm_prefix
   ; call newline_pm

    ; base low
    mov eax, [esi]
    mov [edi], eax

    ; base high
    mov eax, [esi+4]
    mov [edi+4], eax

    ; length low
    mov eax, [esi+8]
    mov [edi+8], eax

    ; length high
    mov eax, [esi+12]
    mov [edi+12], eax

    ; type
    mov eax, [esi+16]
    mov [edi+16], eax

    ; =========================
    ; LOG (opcional)
    ; =========================

    push esi
    call log_memory_entry   ; log de cada entrada (opcional)
    pop esi

    ; =========================

   ; add esi, 20
   ; add edi, 20
    add esi, 24
    add edi, 24

    dec ecx
    inc ebx

    jmp .loop

.done:

    mov [memory_entry_count], ebx

    popad
    ret



; ================================
; Log de cada entrada (opcional)
; ================================
log_memory_entry:

    pushad

    ; tipo
   ; mov eax, [esi+16]

   ; call print_hex_pm   ; <-- CRÍTICO (implemente se não tiver)
   ; call newline_pm
    ;mov eax, [esi+12]  ; length high
    ; pega só o type
    mov eax, [esi+16] ; type
    call print_hex_pm_prefix
    call newline_pm

   ; cmp eax, 1   ; tipo 1 = utilizável
  ;  jne .usable

    ; região reservada
    cmp eax, 2
    jne .not_usable

  ;  mov esi, msg_mem_ok
   ; call log_ok
    jmp .done

.usable:
    mov esi, msg_mem_ok
    call log_ok

.not_usable:
    mov esi, msg_mem_reserved
    call log_warn

.done:
    popad
    ret



; ================================
; Calcula RAM total
; ================================
calculate_total_ram:

    pushad

    mov esi, memory_entries
    mov ecx, [memory_entry_count]

    xor edx, edx        ; total low
    xor ebx, ebx        ; total high

.loop:

    cmp ecx, 0
    je .done

    mov eax, [esi+16]   ; type
    cmp eax, 1
    jne .next

    ; somar length
    add edx, [esi+8]
    adc ebx, [esi+12]

.next:
    add esi, 20
   ; add esi, 24
   ; add edi, 24
    dec ecx
    jmp .loop

.done:

    ; log total (simplificado)
    mov esi, msg_total_ram
    call log_info

    popad
    ret



; ================================
; Buffer para mapa de memória
; ================================
;memory_entries:
   ; times 64 db 0      ; até 64 entradas

; ================================
; Imprime um número em hexadecimal (8 dígitos)
; ================================

; cada entrada tem 4 campos de 8 bytes 
; (base, length) + 1 campo de 4 bytes (type) = 20 bytes por entrada
;memory_entries:
  ;  times 64 dq 0  

memory_entry_count dd 0


; ================================
; Detecção de memória usando int 0x15,
; função 0xE820 (alternativa)
; ================================
msg_mem_ok       db "Regiao de memoria utilizavel",0
msg_mem_reserved db "Regiao reservada",0



msg_total_ram db "Total RAM: ",0

memory_entries:
    times 64 db 0      ; até 64 entradas