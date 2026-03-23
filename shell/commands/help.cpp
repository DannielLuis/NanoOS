#include <stdint.h>

extern void vga_print(const char*);

extern "C"
void cmd_help()
{
    vga_print("\nhelp");
}