#include <stdint.h>

extern void vga_print(const char*);

extern "C"
void app_test()
{
    vga_print("\napp test");
}