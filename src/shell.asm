; shell basico só para testar o sistema de arquivos 
;e o carregamento de arquivos

[bits 32]
[org 0x30000]

shell_main:
    ; Aqui vou colocar código de inicialização
    ; específico para o shell, se necessário
    ; Por exemplo, configurar o ambiente, carregar 
    ; drivers específicos, etc.

    ; Para este exemplo, vou apenas limpar a
    ; a tela e imprimir uma mensagem simples
   ; mov esi, shell_msg
   ; call print_string_pm
    call clear_screen
    call print_banner

    ; Loop infinito para manter o shell rodando
    .shell_loop:
        ; Aqui adicionar código para ler comandos do usuário,
        ; interpretar esses comandos e executar ações correspondentes.
        ; Por enquanto, vamos apenas manter o shell rodando.

        jmp .shell_loop


print_string_pm:
    ; Imprime a string apontada por ESI na tela usando o modo protegido
    ; Assumindo que a função de impressão já está configurada para modo protegido
    ; e que o cursor está sendo gerenciado corretamente.



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


; ================================
; Rotina para imprimir uma string na tela
; ================================
print_string:
.next:
    lodsb
    test al, al
    jz .done
    call putc
    jmp .next
.done:
    ret



; ================================
; Rotina adicionar nova linha
; ================================
newline:
    push eax
    push ebx

    mov eax, [cursor_pos]
    mov ebx, 160
    xor edx, edx
    div ebx
    inc eax
    mul ebx
    mov [cursor_pos], eax

    pop ebx
    pop eax
    ret



; ================================
; Rotina para limpar a tela
; ================================
clear_screen:
    push eax
    push ecx
    push edi

    mov edi, VIDEO_MEM
    mov ecx, 80*25

.clear:
    mov byte [edi], ' '
    mov byte [edi+1], WHITE_ON_BLACK
    add edi, 2
    loop .clear

    mov dword [cursor_pos], 0

    pop edi
    pop ecx
    pop eax
    ret



; ================================
; Rotina para imprimir o banner
; ================================
print_banner:
    mov esi, banner
    call print_string
    call newline
    ret


banner db "NanoOS Shell", 0
shell_msg db "Bem-vindo ao NanoOS Shell!", 0