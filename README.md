# Firmawork - Generic Bare-Metal Firmware

Hardware-independent bare-metal firmware written in C and Assembly.

## Features

- **Hardware Independent**: Generic code structure that can be adapted to any bare-metal hardware
- **C & Assembly**: Low-level assembly bootloader with C kernel
- **CMake Build System**: Cross-platform build configuration
- **No OS Dependencies**: Pure bare-metal, no Windows/Linux dependencies
- **Perfect for Learning**: Understand bootloader, protected mode, kernel basics

## Project Structure

```
firmawork/
├── src/                  # Source code
│   ├── boot.asm         # Assembly bootloader entry point
│   └── kernel.c         # C kernel/main code
├── include/             # Header files
├── build/               # Build output directory
├── linker.ld            # Generic linker script
├── CMakeLists.txt       # CMake build configuration
└── README.md            # This file
```

### [📂 View Source Code](https://github.com/YOUTOBER-1/firmawork/tree/src/src)

## Requirements

- C compiler (GCC or Clang)
- NASM assembler
- CMake 3.10 or higher
- objcopy (from binutils)
- QEMU (for testing)

## Quick Start

```bash
# Clone the repository
git clone https://github.com/YOUTOBER-1/firmawork.git
cd firmawork

# Create build directory
mkdir build
cd build

# Configure with CMake
cmake ..

# Build firmware
cmake --build .

# Run with QEMU
qemu-system-i386 -drive format=raw,file=firmware.bin
```

## Build Output

This will generate:
- `kernel.elf` - ELF executable
- `kernel.bin` - Raw kernel binary
- `boot.bin` - Bootloader binary
- `firmware.bin` - Complete firmware image (ready for QEMU/hardware)

## How It Works

1. **boot.asm** - 16-bit real mode bootloader
   - Loads kernel from disk (INT 0x13)
   - Enables A20 line
   - Sets up GDT
   - Switches to 32-bit protected mode
   - Jumps to kernel

2. **kernel.c** - 32-bit protected mode kernel
   - Writes "FIRMA WORK" to VGA memory
   - Halts CPU

## Adapting to Hardware

To adapt this firmware to specific hardware:

1. **Modify linker.ld** - Adjust memory layout and base address
2. **Update boot.asm** - Add hardware-specific initialization
3. **Extend kernel.c** - Add MMIO functions for your hardware
4. **Adjust CMakeLists.txt** - Update compiler flags if needed

## Memory Map

Default memory layout (adjust in linker.ld):
- **Code**: 0x100000 (1 MB)
- **Data**: Following code section
- **BSS**: Following data section
- **Stack**: 16KB at end

## Testing

```bash
# Build
cd build
cmake .. && cmake --build .

# Test with QEMU (displays "FIRMA WORK")
qemu-system-i386 -drive format=raw,file=firmware.bin

# Exit QEMU: Ctrl+A then X
```

## Use Cases

- 🎓 Learning OS development
- 🔧 Starting point for custom firmware
- 📚 Understanding bootloaders
- 🏗️ Building embedded systems

## References

- [OSDev.org - Bootloader](https://wiki.osdev.org/Bootloader)
- [OSDev.org - Protected Mode](https://wiki.osdev.org/Protected_Mode)
- [x86 Assembly Guide](https://www.nasm.us/)
- [CMake Documentation](https://cmake.org/cmake/help/latest/)

## License

MIT License - Feel free to use and modify for your hardware projects.

## Contributing

Suggestions and improvements are welcome! Feel free to open issues or submit pull requests.

---

**Made with ❤️ for OS enthusiasts and embedded developers**
