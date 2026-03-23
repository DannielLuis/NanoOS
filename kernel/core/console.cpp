#include <stdint.h>

static volatile uint16_t* vga = (uint16_t*)0xB8000;

static uint16_t x = 0;

void console_put(char c)
{
    vga[x++] = (0x0F << 8) | c;
}

void console_print(const char* s)
{
    while (*s)
        console_put(*s++);
}