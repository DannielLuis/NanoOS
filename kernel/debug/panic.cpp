#include <stdint.h>

extern void console_print(const char*);

extern "C"
void panic(const char* msg)
{
    console_print("PANIC: ");
    console_print(msg);

    while (1)
    {
        asm("cli");
        asm("hlt");
    }
}