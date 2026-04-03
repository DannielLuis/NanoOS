[bits 16]

;MEMORY_MAP_ADDR  equ 0x5000
;MEMORY_MAP_COUNT equ 0x4FF0

;MEMORY_MAP_ADDR    equ 0x1000 ; endereço onde o mapa de memória é armazenado
;MEMORY_MAP_COUNT   equ 0x5FF0 ;pode ser 0x4FF0 dependendo do local onde o mapa é armazenado
;MEMORY_MAP_COUNT   equ 0x4FF0

;MEMORY_MAP_ADDR  equ 0x9000
;MEMORY_MAP_COUNT equ 0x8FF0


MEMORY_MAP_ADDR    equ 0x6000 
MEMORY_MAP_COUNT   equ 0x4FF0 

last_entry_size equ 24 ; pode ser 20 dependendo do que o BIOS retornar

detect_memory:

    pusha

    xor ebx, ebx                ; obrigatório começar com 0
    mov di, MEMORY_MAP_ADDR

    mov ax, 0
    mov es, ax              ; segmento 0 para acessar o buffer

    mov byte [MEMORY_MAP_COUNT], 0

.next:

    mov eax, 0xE820
    mov edx, 0x534D4150 ; 'SMAP'
    mov ecx, 24
    ;mov ecx, 20

    int 0x15
    jc .error

    cmp eax, 0x534D4150 ; verificar assinatura
    jne .error

    ; DEBUG (opcional)
    mov eax, [es:di+16]
    call print_hex


    mov [last_entry_size], ecx ; salvar o tamanho da última entrada para calcular o próximo endereço

    cmp ecx, 20 ; dependendo do que o BIOS retornar, pode ser 20 ou 24
   ; je .entry_20 ; se for 20, salva o tamanho e continua
   ; cmp ecx, 24
   ; jne .entry_24 ; se for 24, salva o tamanho e continua
   ; jmp .error ; se for um tamanho inesperado, trata como erro
    jb .error ; se for menor que 20, é um erro
    ja .error ; se for maior que 24, é um erro

   ; mov byte [MEMORY_MAP_COUNT], byte [MEMORY_MAP_COUNT] + 1 ; contar entrada válida

    ;; LOG DEBUG
   ; mov si, passed
   ; mov ax, [si]
   ; call print


    ; ignorar entradas vazias
    cmp dword [es:di+8], 0
    jne .valid

    cmp dword [es:di+12], 0
    je .skip

.valid:

    inc byte [MEMORY_MAP_COUNT]

    ;add di, cx
    ;add di, 24                 ; próxima entrada
    add di, [last_entry_size] ; próxima entrada (tamanho da última entrada retornada pelo BIOS)
    jmp .cont

.entry_20:
    mov byte [last_entry_size], 20
    jmp .cont

.entry_24:
    mov byte [last_entry_size], 24
    jmp .cont

.skip:
    ;add di, cx
   ; add di, 20                 ; próxima entrada
    add di, [last_entry_size] ; próxima entrada (tamanho da última entrada retornada pelo BIOS)

.cont:
    cmp ebx, 0
    jne .next

    ; DEBUG (opcional)
  ;  mov eax, [es:di+16]
   ; call print_hex

  ;  inc byte [MEMORY_MAP_COUNT]

  ;  add di, 24                 ; próxima entrada
  ;  ;add di, 20                 ; próxima entrada

  ;  cmp ebx, 0
  ;  jne .next

  ;  ; terminou

 ;   cmp byte [MEMORY_MAP_COUNT], 0
  ;  je .error


.success:
    popa
    clc
    ret

.error:
    popa
    stc
    ret


passed db "passed", 0

detect_memory_b:

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







;[bits 16]

;MEMORY_MAP_ADDR equ 0x5000
;MEMORY_MAP_COUNT equ 0x4FF0

;detect_memory:

  ;  pusha

  ;  xor ebx, ebx
  ;  mov di, MEMORY_MAP_ADDR

  ;  mov byte [MEMORY_MAP_COUNT], 0

;.next:

  ;  mov eax, 0xE820
  ;  mov edx, 0x534D4150
  ;  mov ecx, 24

  ;  ;;mov es, word 0
  ;  ;;mov edi, di
  ;  mov ax, 0
  ;  mov es, ax
  ;  mov bx, di
    
  ;  int 0x15

  ;  jc .done

  ;  cmp eax, 0x534D4150
  ;  jne .done

  ;  add di, 24

  ;  inc byte [MEMORY_MAP_COUNT]

  ;  cmp ebx, 0
  ;  jne .next

;.done:

  ;  popa
  ;  ret