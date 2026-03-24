[bits 32]
;;[org 0x100000]
[org 0x10000]

MEMORY_MAP      equ 0x5000
MEMORY_COUNT    equ 0x4FF0

kernel_start:

    cli

    mov edi, 0xB8000

    mov eax, 0x0720074B
    mov [edi], eax

   ; mov esi, 0x4FF0
  ;  mov al, [esi]

  ;  add al, 'h'

  ;  mov ah, 0x07
   ; mov [edi+4], ax

    xor ecx, ecx
    mov cl, [MEMORY_COUNT]

    mov esi, MEMORY_MAP

    xor ebx, ebx    ; total low

loop_entries:

    cmp ecx, 0
    je done

    mov eax, [esi+16]   ; type

    cmp eax, 1
    jne next

    mov eax, [esi+8]    ; length low
    add ebx, eax

next:

    ;add esi, 24
    add esi, 20
    dec ecx
    jmp loop_entries


done:

    ; mostrar total RAM em MB (low / 1MB)

    mov eax, ebx
    shr eax, 20

    add al, '0'

    mov ah, 0x07
    mov [edi+4], ax

    call pmm_init

hang:
    jmp hang


%include "pmm.asm"