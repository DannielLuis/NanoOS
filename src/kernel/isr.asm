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


; =========================
; SYSCALL ISR (int 0x80)
; =========================
isr128:
    cli

    push 0          ; dummy error
    push 128        ; interrupt number

    jmp isr_common

; ... repete até 31

isr_common:
    pusha

    mov eax, [esp + 32]   ; int number (posição após pusha)

    cmp eax, 128
    je .syscall_handler

    call isr_handler
    jmp .end

    .syscall_handler:
        call syscall_dispatch

    .end:
        popa
        add esp, 8
        sti
        iret



; =========================
; SYSCALL DISPATCH
; =========================
syscall_dispatch:

    ; eax = syscall number (já salvo no stack via pusha)
    ; mas é preciso recuperar registradores originais

    mov eax, [esp + 28]   ; eax original
    mov ebx, [esp + 24]
    mov ecx, [esp + 20]
    mov edx, [esp + 16]
    mov esi, [esp + 12]
    mov edi, [esp + 8]

    cmp eax, syscall_count
    jae .invalid

    mov edx, syscall_table
    mov eax, [edx + eax*4]

    call eax
    jmp .done

    .invalid:
        mov eax, -1

    .done:
        mov [esp + 28], eax   ; retorno para caller
        ret



; =========================
; SYSCALL TABLE
; =========================
syscall_table:
    dd sys_write
    dd sys_getpid
    dd sys_exit

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
sys_write:
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