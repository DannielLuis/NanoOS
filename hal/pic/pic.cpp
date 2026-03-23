#include <stdint.h>

extern void outb(uint16_t, uint8_t);

#define PIC1 0x20
#define PIC2 0xA0

#define PIC1_COMMAND PIC1
#define PIC1_DATA (PIC1+1)

#define PIC2_COMMAND PIC2
#define PIC2_DATA (PIC2+1)


extern "C"
void pic_remap()
{
    outb(PIC1_COMMAND, 0x11);
    outb(PIC2_COMMAND, 0x11);

    outb(PIC1_DATA, 0x20);
    outb(PIC2_DATA, 0x28);

    outb(PIC1_DATA, 4);
    outb(PIC2_DATA, 2);

    outb(PIC1_DATA, 0x01);
    outb(PIC2_DATA, 0x01);

    outb(PIC1_DATA, 0);
    outb(PIC2_DATA, 0);
}