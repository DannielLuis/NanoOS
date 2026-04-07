; =========================
; ISR (CPU exceptions)
; =========================

isr0:
    cli
    push 0
    push 0
    jmp isr_common

isr1:
    cli
    push 0
    push 1
    jmp isr_common

isr2:
    cli
    push 0
    push 2
    jmp isr_common

isr3:
    cli
    push 0
    push 3
    jmp isr_common

isr4:
    cli
    push 0
    push 4
    jmp isr_common

isr5:
    cli
    push 0
    push 5
    jmp isr_common

isr6:
    cli
    push 0
    push 6
    jmp isr_common

isr7:
    cli
    push 0
    push 7
    jmp isr_common

; COM ERROR CODE (CPU já empurra)
isr8:
    cli
    push 8
    jmp isr_common

isr9:
    cli
    push 0
    push 9
    jmp isr_common

isr10:
    cli
    push 10
    jmp isr_common

isr11:
    cli
    push 11
    jmp isr_common

isr12:
    cli
    push 12
    jmp isr_common

isr13:
    cli
    push 13
    jmp isr_common

isr14:
    cli
    push 14
    jmp isr_common

isr15:
    cli
    push 0
    push 15
    jmp isr_common

isr16:
    cli
    push 0
    push 16
    jmp isr_common

isr17:
    cli
    push 17
    jmp isr_common

isr18:
    cli
    push 0
    push 18
    jmp isr_common

isr19:
    cli
    push 0
    push 19
    jmp isr_common

isr20:
    cli
    push 0
    push 20
    jmp isr_common

isr21:
    cli
    push 0
    push 21
    jmp isr_common

isr22:
    cli
    push 0
    push 22
    jmp isr_common

isr23:
    cli
    push 0
    push 23
    jmp isr_common

isr24:
    cli
    push 0
    push 24
    jmp isr_common

isr25:
    cli
    push 0
    push 25
    jmp isr_common

isr26:
    cli
    push 0
    push 26
    jmp isr_common

isr27:
    cli
    push 0
    push 27
    jmp isr_common

isr28:
    cli
    push 0
    push 28
    jmp isr_common

isr29:
    cli
    push 0
    push 29
    jmp isr_common

isr30:
    cli
    push 0
    push 30
    jmp isr_common

isr31:
    cli
    push 0
    push 31
    jmp isr_common

; =========================
; SYSCALL ISR (int 0x80)
; =========================
isr128:
    cli

    push 0      ; dummy error code (syscalls não geram código de erro)
    push 128    ; interrupt number

  ;  mov byte [0xB8000], 'S'
  ;  mov byte [0xB8001], 0x0F

    jmp isr_common

; COMMON
isr_common:
    pusha

    mov eax, [esp + 32]   ; int number (posição após pusha)
   ; mov eax, [esp + 36]

  ;  mov byte [0xB8000], 'C'
   ; mov byte [0xB8001], 0x0F

    cmp eax, 128
    ;je .syscall_handler
    je .syscall

    call isr_handler
    jmp .end

    ;.syscall:
    ;  call syscall_dispatch
    .syscall:
        mov eax, esp
        push eax
        call syscall_dispatch
        add esp, 4

    .end:
        popa
        add esp, 8
        iret


; =========================
; SYSCALL DISPATCH
; =========================
syscall_dispatch:

    mov esi, [esp + 4]   ; ponteiro stack original

    mov eax, [esi + 28]
    mov ebx, [esi + 16]
    mov ecx, [esi + 24]
    mov edx, [esi + 20]
    mov esi, [esi + 4]
    mov edi, [esi + 0]

    ;mov edi, [esi + 0]
    ;mov esi, [esi + 4]

    cmp eax, syscall_count
    jae .invalid

    mov edx, syscall_table
    mov eax, [edx + eax*4]

    call eax
    jmp .done

.invalid:
    mov eax, -1

.done:
    mov esi, [esp + 4]
    mov [esi + 28], eax   ; retorno em eax original
    ret


syscall_dispatch_:

    ; eax = syscall number (já salvo no stack via pusha)
    ; mas é preciso recuperar registradores originais

  ;  mov eax, [esp + 28]   ; eax original
   ; mov ebx, [esp + 24]
  ;  mov ecx, [esp + 20]
   ; mov edx, [esp + 16]
  ;  mov esi, [esp + 12]
   ; mov edi, [esp + 8]
    
    mov eax, [esp + 32]
    mov ebx, [esp + 28]
    mov ecx, [esp + 24]
    mov edx, [esp + 20]
    mov esi, [esp + 16]
    mov edi, [esp + 12]

    cmp eax, syscall_count
    jae .invalid

    mov edx, syscall_table
    mov eax, [edx + eax*4]

    call eax
    jmp .done

    .invalid:
        mov eax, -1

    .done:
        ;mov [esp + 28], eax   ; retorno para caller
        mov [esp + 32], eax
        ret



; =========================
; SYSCALL TABLE
; =========================
syscall_table:
    dd sys_write    ; sys_write_ - 0
    dd sys_getpid   ; sys_getpid - 1
    dd sys_exit     ; sys_exit   - 2
    dd print_at

syscall_count equ ($ - syscall_table) / 4



; ===========================
; Implementação das syscalls
; ===========================

; ===================================================
; SYSCALL: sys_write
; EBX = ponteiro string (null-terminated)
; print string simples por enquanto
; usando int 0x10 para evitar dependência de driver
; ===================================================
sys_write_ggg:
    ; ebx = ponteiro string

.print:
    mov al, [ebx]
    cmp al, 0
    je .done

    mov ah, 0x0E
    int 0x10

    inc ebx
    jmp .print

.done:
    mov eax, 0
    ret

cursor_pos dd 0

sys_write_:
  ;  mov edi, 0xB8000
  ;  mov ah, 0x07
   ; mov [edi], ax
    mov byte [0xB8000], 'W' ; 'T'
    mov byte [0xB8001], 0x0F

    ret

sys_write:
    mov edi, [cursor_pos]
    add edi, 0xB8000

    mov ah, 0x0F

.print:
    ;mov al, [ebx]
    mov al, [ebx]
    cmp al, 0
    je .done

    cmp al, 10
    je .newline

    mov [edi], ax
    add edi, 2

    inc ebx
    jmp .print

.newline:
    mov eax, edi
    sub eax, 0xB8000

    mov edx, 0
    mov ecx, 160
    div ecx

    inc eax
    mul ecx
    add eax, 0xB8000

    mov edi, eax

    inc ebx
    jmp .print

.done:
    mov eax, edi
    sub eax, 0xB8000
    mov [cursor_pos], eax

    mov eax, 0
    ret


; ===================================================
; SYSCALL: sys_getpid
; Retorna um PID fictício (exemplo)
; ===================================================
sys_getpid:
    mov eax, 1
    ret


; ===================================================
; SYSCALL: sys_exit
; Termina o processo atual (ainda não implementado)
; ===================================================
sys_exit:
.halt:
    cli
    hlt
    jmp .halt