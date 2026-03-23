#include <stdint.h>

static volatile uint16_t* vga = (uint16_t*)0xB8000;

static uint16_t pos = 0;

extern "C"
void vga_put(char c)
{
    vga[pos++] = (0x07 << 8) | c;
}

extern "C"
void vga_print(const char* s)
{
    while (*s)
        vga_put(*s++);
}