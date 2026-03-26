[bits 16]

%include "loader/memory.asm"
%include "loader/a20.asm"
%include "loader/gdt.asm"

%include "loader/disk.asm"

%INCLUDE "loader/screen.asm"

%include "loader/pmode.asm"

%include "loader/idt.asm"

;%include "disk.asm"
;%include "memory.asm"