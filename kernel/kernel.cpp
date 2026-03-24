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

static inline void outb(uint16_t port, uint8_t val)
{
    asm volatile("outb %0, %1" : : "a"(val), "Nd"(port));
}

void serial_putc(char c)
{
    outb(0x3F8, c);
}

void serial_print(const char* s)
{
    while (*s)
        serial_putc(*s++);
}

extern "C"
void kernel_main()
{
    // Base funcional: apenas halt
    while (1)
    {
        asm("hlt");
    }
}