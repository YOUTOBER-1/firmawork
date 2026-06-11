# Firmawork - Generic Bare-Metal Firmware

Hardware-independent bare-metal firmware written in C and Assembly.

## Features

- **Hardware Independent**: Generic code structure that can be adapted to any bare-metal hardware
- **C & Assembly**: Low-level assembly bootloader with C kernel
- **CMake Build System**: Cross-platform build configuration
- **No OS Dependencies**: Pure bare-metal, no Windows/Linux dependencies

## Project Structure

```
firmawork/
├── src/
│   ├── boot.asm      # Assembly bootloader entry point
│   └── kernel.c      # C kernel/main code
├── include/          # Header files
├── build/            # Build output directory
├── linker.ld         # Generic linker script
├── CMakeLists.txt    # CMake build configuration
└── README.md         # This file
```

## Requirements

- C compiler (GCC or Clang)
- NASM assembler
- CMake 3.10 or higher
- objcopy (from binutils)

## Building

```bash
# Create build directory
mkdir build
cd build

# Configure with CMake
cmake ..

# Build firmware
cmake --build .
```

This will generate:
- `kernel.elf` - ELF executable
- `firmware.bin` - Raw binary image

## Adapting to Hardware

To adapt this firmware to specific hardware:

1. **Modify linker.ld** - Adjust memory layout and base address
2. **Update boot.asm** - Add hardware-specific initialization
3. **Extend kernel.c** - Add MMIO functions for your hardware
4. **Adjust CMakeLists.txt** - Update compiler flags if needed

## Memory Map

Default memory layout (adjust in linker.ld):
- Code: 0x100000
- Data: Following code section
- BSS: Following data section
- Stack: 16KB at end

## License

MIT License - Feel free to use and modify for your hardware projects.
