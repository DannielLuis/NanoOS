#include <stdint.h>

extern "C"
void cpu_halt()
{
    asm volatile("hlt");
}

extern "C"
void cpu_cli()
{
    asm volatile("cli");
}

extern "C"
void cpu_sti()
{
    asm volatile("sti");
}