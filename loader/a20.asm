BITS 16

global enable_a20

section .text

enable_a20:

    in al, 0x92
    or al, 00000010b
    out 0x92, al

    ret