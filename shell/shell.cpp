#include <stdint.h>

extern void vga_print(const char*);

static char buffer[128];
static uint32_t pos = 0;

void shell_prompt()
{
    vga_print("\n> ");
    pos = 0;
}

void shell_put(char c)
{
    if (pos < 127)
    {
        buffer[pos++] = c;
    }
}

void shell_execute()
{
    buffer[pos] = 0;

    if (buffer[0] == 0)
    {
        shell_prompt();
        return;
    }

    vga_print("\ncmd: ");
    vga_print(buffer);

    shell_prompt();
}

extern "C"
void shell_init()
{
    vga_print("\nNanoOS shell");
    shell_prompt();
}