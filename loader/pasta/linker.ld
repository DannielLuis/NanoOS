ENTRY(start)

SECTIONS
{
    . = 0x0000;

    .text :
    {
        *(.text.start)
        *(.text*)
    }

    .rodata :
    {
        *(.rodata*)
    }

    .data :
    {
        *(.data*)
    }

    .bss :
    {
        *(.bss*)
    }
}