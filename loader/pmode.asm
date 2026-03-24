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
  ;  mov ebp, esp

  ;  mov al,'P'
 ;   mov ah,0x0E
  ;  int 0x10   ; ← isso vai travar, mas queremos ver se chegou

  ;  call load_kernel

   ;; jmp 0x100000
   ;; jmp 0x10000
    jmp 0x08:0x10000

;hang:
   ; jmp hang