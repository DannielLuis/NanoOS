#include <stdint.h>

static volatile uint16_t* vga = (uint16_t*)0xB8000;

static uint16_t pos = 0;

void putc(char c)
{
    vga[pos++] = (0x07 << 8) | c;
}

void print(const char* s)
{
    while (*s)
        putc(*s++);
}

extern "C"
void kernel_main()
{
    print("NanoOS kernel");

    while (1)
    {
        asm("hlt");
    }
}