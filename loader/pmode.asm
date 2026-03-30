enter_protected_mode:

    cli

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:protected_mode_start


[bits 32]

protected_mode_start:

    mov ax, 0x10

    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x90000

    cli     ; desabilitar interrupções antes de configurar a IDT
    
    ;call load_idt
    lidt [idt_descriptor]
    
    ;jmp $

   ; mov dword [0xB8000], 0x0720074C   ; 'L'
   ; mov eax, [0x10000]
   ; mov dword [0xB8004], eax

   ; mov edi, 0xB8000
   ; mov eax, 0x0720074B
   ; mov [edi], eax

    ; Pular para o kernel em 0x10000 (carregado no real mode)
    ; 0x08 é o seletor de código do kernel na GDT
    jmp 0x08:0x10000    ; pular para o kernel em 0x10000 (carregado no real mode)
    ;jmp $

    






















    
    
    
;protected_mode_start:

 ;   mov ax, 0x10

 ;   mov ds, ax
 ;   mov es, ax
 ;   mov fs, ax
 ;   mov gs, ax
  ;  mov ss, ax

 ;   mov esp, 0x90000
 ; ;  mov ebp, esp

 ;   mov al,'P'
 ;   mov ah,0x0E
  ;  int 0x10   ; ← isso vai travar, mas queremos ver se chegou

  ;  call load_kernel

   ; call load_idt
    
   ; mov dword [0xB8000], 0x0720074C   ; 'L'
    
  ;  mov eax, [0x10000]
    
  ;  mov dword [0x10000], 0x0720074B   ; 'K'
    ;mov eax, [0x10000]
    
    
    
 ;   mov edi, 0xB8000

  ;  mov eax, 0x0720074B
  ;  mov [edi], eax
    
   ;; jmp 0x100000
   ;; jmp 0x10000
    
   ; mov esi, 0x10000
   ; mov edi, 0xB8000

   ; mov al, [esi]       ; primeiro byte do kernel
   ; mov ah, 0x074
   ; mov [edi], ax
    
    
  ;  jmp 0x08:0x10000
  ;  jmp $
    
;hang:
   ; jmp hang
    
    
    
    
    