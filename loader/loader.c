#include <stdint.h>

void print(const char* s)
{
    volatile char* v = (volatile char*)0xB8000;

    while (*s)
    {
        *v++ = *s++;
        *v++ = 0x07;
    }
}

void loader_main()
{
    print("NanoOS loader");

    while (1)
    {
    }
}

