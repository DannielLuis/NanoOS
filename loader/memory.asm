[bits 16]

MEMORY_MAP_ADDR  equ 0x5000
MEMORY_MAP_COUNT equ 0x4FF0

detect_memory:

    pusha

    mov ax, 0
    mov es, ax

    mov di, MEMORY_MAP_ADDR

    xor ebx, ebx

    mov byte [MEMORY_MAP_COUNT], 0

.next:

    mov eax, 0xE820
    mov edx, 0x534D4150
    mov ecx, 20

    int 0x15



    jc .error              ; BIOS falhou

    cmp eax, 0x534D4150
    jne .error             ; assinatura inválida

    add di, 20
    inc byte [MEMORY_MAP_COUNT]

    cmp ebx, 0
    jne .next              ; continua loop

    ; terminou normalmente
    cmp byte [MEMORY_MAP_COUNT], 0
    je .error              ; nenhuma entrada = erro


   ; jc .done

 ;   cmp eax, 0x534D4150
  ;  jne .done

  ;  add di, 20

  ;  inc byte [MEMORY_MAP_COUNT]

  ;  cmp ebx, 0
  ;  jne .next

.success:
    popa
    clc                    ; sucesso
    ret

.error:
    popa
    stc                    ; erro
    ret

;.done:

 ;   popa
 ;   ret
