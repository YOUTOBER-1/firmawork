[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CMake](https://img.shields.io/badge/CMake-3.10+-blue.svg)](https://cmake.org)
[![x86-64](https://img.shields.io/badge/Architecture-x86--64-red.svg)]()
[![Assembly](https://img.shields.io/badge/Languages-C%2FAssembly-green.svg)]()

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

### Stage 1: Bootloader (boot.asm)
- **Real Mode (16-bit)**
- Initializes CPU state (segment registers, stack)
- Loads kernel from disk using BIOS INT 0x13
- Enables A20 line (enables access to all memory)
- Loads GDT (Global Descriptor Table)
- Switches to Protected Mode (32-bit)
- Jumps to kernel entry point

### Stage 2: Kernel (kernel.c)
- **Protected Mode (32-bit)**
- Sets up segment registers for protected mode
- Initializes stack pointer
- Writes "FIRMA WORK" to VGA memory (0xB8000)
- Enters infinite halt loop

## Adapting to Hardware

To adapt this firmware to specific hardware:

1. **Modify linker.ld** - Adjust memory layout and base address
2. **Update boot.asm** - Add hardware-specific initialization
3. **Extend kernel.c** - Add MMIO functions for your hardware
4. **Adjust CMakeLists.txt** - Update compiler flags if needed

## Memory Map

Default memory layout (adjust in linker.ld):
- **Boot Sector**: 0x7C00 (512 bytes, loaded by BIOS)
- **Code**: 0x10000 (1 MB)
- **Data**: Following code section
- **BSS**: Following data section
- **Stack**: 0x90000 (grows downward)

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

- 🎓 Learning OS development from scratch
- 🔧 Starting point for custom firmware projects
- 📚 Understanding x86 bootloaders and protected mode
- 🏗️ Building embedded systems and kernels
- 🔬 Experimenting with low-level hardware interaction

## Architecture Details

### Boot Process Flow
```
BIOS → boot.asm (real mode) → GDT setup → Protected mode → kernel.c → Halt
```

### Compilation Pipeline
```
boot.asm → NASM → boot.bin
kernel.c → GCC → kernel.o → LD → kernel.elf → objcopy → kernel.bin
boot.bin + kernel.bin → firmware.bin (QEMU-ready image)
```

## References

- [OSDev.org - Bootloader](https://wiki.osdev.org/Bootloader)
- [OSDev.org - Protected Mode](https://wiki.osdev.org/Protected_Mode)
- [Intel 80386 Reference Manual](https://www.intel.com/)
- [x86 Assembly Guide - NASM](https://www.nasm.us/)
- [CMake Documentation](https://cmake.org/cmake/help/latest/)
- [GCC ARM Options](https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html)

## Troubleshooting

### Build fails with "nasm not found"
```bash
# Install NASM
sudo apt-get install nasm          # Ubuntu/Debian
brew install nasm                   # macOS
choco install nasm                  # Windows
```

### QEMU not found
```bash
# Install QEMU
sudo apt-get install qemu-system-x86    # Ubuntu/Debian
brew install qemu                       # macOS
choco install qemu                      # Windows
```

### "cmake: not found"
```bash
# Install CMake 3.10+
sudo apt-get install cmake              # Ubuntu/Debian
brew install cmake                      # macOS
choco install cmake                     # Windows
```

## License

MIT License - Feel free to use and modify for your hardware projects.

See [LICENSE](LICENSE) file for details.

## Contributing

Suggestions and improvements are welcome! Feel free to:
- 🐛 Report bugs
- 💡 Suggest features
- 🔧 Submit pull requests
- 📝 Improve documentation

## Author

Created by **YOUTOBER-1** for the OSdev community.

---

**Made with ❤️ for OS enthusiasts and embedded developers**

*Want to use Firmawork? Star ⭐ this repo to show your support!*
