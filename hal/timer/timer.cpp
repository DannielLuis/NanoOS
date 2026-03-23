#include <stdint.h>

extern void outb(uint16_t, uint8_t);

#define PIT_COMMAND 0x43
#define PIT_CHANNEL0 0x40

extern "C"
void timer_init(uint32_t freq)
{
    uint32_t divisor = 1193180 / freq;

    outb(PIT_COMMAND, 0x36);

    outb(PIT_CHANNEL0, divisor & 0xFF);
    outb(PIT_CHANNEL0, (divisor >> 8) & 0xFF);
}