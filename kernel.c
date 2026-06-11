// Minimal kernel - no libc, no dependencies

// VGA memory address
#define VGA_MEMORY ((unsigned short*)0xB8000)
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

// Entry point - must be first function
void kernel_main(void) {
    // Clear screen first
    unsigned short* vga = VGA_MEMORY;
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga[i] = 0x0F20;  // White space on black
    }
    
    // String directly inline
    char text[] = {'F','I','R','M',' ','A',' ','W','O','R','K','\0'};
    
    // Write at center: X=34, Y=12
    vga = VGA_MEMORY + (12 * VGA_WIDTH + 34);
    
    for (int i = 0; text[i] != '\0'; i++) {
        *vga = (unsigned short)text[i] | 0x0F00;
        vga++;
    }
    
    // Halt forever
    while (1) {
        __asm__ volatile("hlt");
    }
}
