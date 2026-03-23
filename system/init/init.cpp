#include <stdint.h>

extern void vga_print(const char*);
extern "C" void shell_init();

extern "C"
void system_init()
{
    vga_print("\nSystem init");

    shell_init();
}