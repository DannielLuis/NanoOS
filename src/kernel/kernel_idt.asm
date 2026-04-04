; ==========================================
; NanoOS - KERNEL IDT + IRQ + KEYBOARD
; 32-bit Protected Mode
; ==========================================

[bits 32]

; ==========================================
; IDT TABLE
; ==========================================

idt_start:
times 256 dq 0
idt_end:

idt_descriptor:
    dw idt_end - idt_start - 1
    dd idt_start

; ==========================================
; API
; ==========================================

idt_init:
    call pic_remap
    call idt_setup_exceptions
    call idt_setup_irq

    call idt_setup_syscall

    lidt [idt_descriptor]
    sti
    ret

; ==========================================
; SET GATE
; ==========================================

idt_set_gate:
    ; eax = handler
    ; ebx = index
    ; cx  = selector
    ; dl  = flags

    push edi
    push edx

    mov edi, idt_start
    mov edx, ebx
    shl edx, 3
    add edi, edx

    mov word [edi], ax
    mov word [edi + 2], cx
    mov byte [edi + 4], 0
    mov byte [edi + 5], dl
    shr eax, 16
    mov word [edi + 6], ax

    pop edx
    pop edi
    ret

; ==========================================
; PIC REMAP (0x20–0x2F)
; ==========================================

pic_remap:
    mov al, 0x11
    out 0x20, al
    out 0xA0, al

    mov al, 0x20
    out 0x21, al
    mov al, 0x28
    out 0xA1, al

    mov al, 0x04
    out 0x21, al
    mov al, 0x02
    out 0xA1, al

    mov al, 0x01
    out 0x21, al
    out 0xA1, al

    mov al, 0x0
    out 0x21, al
    out 0xA1, al
    ret

; ==========================================
; DEFAULT EXCEPTION HANDLER
; ==========================================

isr_exception:
    cli
.hang:
    hlt
    jmp .hang

; ==========================================
; EXCEPTIONS (0–31)
; ==========================================

idt_setup_exceptions:
    mov ecx, 32
    xor ebx, ebx

.loop:
    mov eax, isr_exception
    mov cx, 0x08
    mov dl, 0x8E
    call idt_set_gate

    inc ebx
    loop .loop
    ret

; ==========================================
; IRQ HANDLERS
; ==========================================

irq0:
    call pic_eoi_master
    iretd

irq1:
    pusha

    in al, 0x60
    call keyboard_handler

    call pic_eoi_master

    popa
    iretd

irq_default:
    call pic_eoi_master
    iretd

; ==========================================
; IRQ SETUP (0x20–0x2F)
; ==========================================

idt_setup_irq:

    ; IRQ0 - Timer
    mov eax, irq0
    mov ebx, 0x20
    mov cx, 0x08
    mov dl, 0x8E
    call idt_set_gate

    ; IRQ1 - Keyboard
    mov eax, irq1
    mov ebx, 0x21
    mov cx, 0x08
    mov dl, 0x8E
    call idt_set_gate

    ; Rest IRQs
    mov ecx, 14
    mov ebx, 0x22

.loop:
    mov eax, irq_default
    mov cx, 0x08
    mov dl, 0x8E
    call idt_set_gate

    inc ebx
    loop .loop

    ret

; ==========================================
; PIC EOI
; ==========================================

pic_eoi_master:
    mov al, 0x20
    out 0x20, al
    ret

; ==========================================
; KEYBOARD DRIVER (SIMPLES)
; ==========================================

keyboard_handler:
    ; AL = scancode

    cmp al, 0x80
    ja .ignore

    movzx eax, al
    mov al, [scancode_table + eax]

    cmp al, 0
    je .ignore

    mov ebx, kb_write
    mov [kb_buffer + ebx], al

    inc ebx
    and ebx, 255
    mov [kb_write], ebx

.ignore:
    ret

; ==========================================
; GET CHAR (bloqueante)
; ==========================================

keyboard_getchar:

.wait:
    mov eax, kb_read
    cmp eax, [kb_write]
    je .wait

    mov bl, [kb_buffer + eax]

    inc eax
    and eax, 255
    mov [kb_read], eax

    mov al, bl
    ret

; ==========================================
; DATA
; ==========================================

kb_buffer times 256 db 0
kb_read   dd 0
kb_write  dd 0

; ==========================================
; SCANCODE TABLE (US)
; ==========================================

scancode_table:
db 0,27,'1','2','3','4','5','6','7','8','9','0','-','=',8
db 9,'q','w','e','r','t','y','u','i','o','p','[',']',13
db 0,'a','s','d','f','g','h','j','k','l',';',"'",'`',0
db '\','z','x','c','v','b','n','m',',','.','/',0
times 128 db 0













; ==========================================
; VGA TEXT MODE (0xB8000)
; ==========================================

VIDEO_MEM     equ 0xB8000
WHITE_ON_BLACK equ 0x0F

cursor_pos dd 0



; ================================
; Rotina para imprimir um caractere na tela
; ================================
putc:
    push eax
    push ebx
    push edx

    mov ebx, [cursor_pos]
    mov edx, VIDEO_MEM

    mov byte [edx + ebx], al
    mov byte [edx + ebx + 1], WHITE_ON_BLACK

    add ebx, 2
    mov [cursor_pos], ebx

    pop edx
    pop ebx
    pop eax
    ret



; ==========================================
; NanoOS - SYSCALL (INT 0x80)
; Kernel-side implementation
; ==========================================

;[bits 32]

; ==========================================
; SYSCALL IDs
; ==========================================

SYS_WRITE   equ 1
SYS_GETCHAR equ 2

; ==========================================
; IDT REGISTRATION (CALL INSIDE idt_init)
; ==========================================
; adicionar isso no seu idt_init:

; call idt_setup_syscall

idt_setup_syscall:
    mov eax, isr80
    mov ebx, 0x80
    mov cx, 0x08
    mov dl, 0xEE ; 0x8E    ; use 0xEE se for ring3 no futuro
    call idt_set_gate
    ret

; ==========================================
; SYSCALL HANDLER
; ==========================================
isr80:
    cli

    mov byte [0xB8000], 'X'
    mov byte [0xB8001], 0x0F

.hang:
    jmp .hang

    
isr80_h:
    push eax
    pusha

    mov eax, [esp + 36]   ; syscall ID (ajuste se necessário)

    cmp eax, SYS_WRITE
    je .sys_write

    cmp eax, SYS_GETCHAR
    je .sys_getchar

    jmp .done

; ==========================================
; SYS_WRITE
; EBX = ponteiro string (null-terminated)
; ==========================================

.sys_write:
    mov esi, ebx

.write_loop:
    lodsb
    test al, al
    jz .done

    call putc
    jmp .write_loop

; ==========================================
; SYS_GETCHAR
; retorno: AL
; ==========================================

.sys_getchar:
    call keyboard_getchar
    movzx eax, al
    jmp .done

; ==========================================
; EXIT
; ==========================================

.done:
    popa
    add esp, 4 ; limpar o argumento da pilha
    iretd


; ==========================================
; DEPENDÊNCIAS (já devem existir no kernel)
; ==========================================
; putc: imprime char em AL
; keyboard_getchar: retorna char em AL