cmake_minimum_required(VERSION 3.10)
project(Firmawork C ASM)

# Build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Include directories
include_directories(${CMAKE_SOURCE_DIR}/include)

# Compile boot.asm to raw binary
add_custom_command(
    OUTPUT boot.bin
    COMMAND nasm -f bin ${CMAKE_SOURCE_DIR}/src/boot.asm -o boot.bin
    DEPENDS ${CMAKE_SOURCE_DIR}/src/boot.asm
    VERBATIM
)

# Compile C source to object file (32-bit, freestanding, no standard library)
add_custom_command(
    OUTPUT kernel.o
    COMMAND ${CMAKE_C_COMPILER} -c ${CMAKE_SOURCE_DIR}/src/kernel.c -o kernel.o 
        -m32 
        -ffreestanding 
        -nostdlib 
        -nostdinc
        -fno-builtin
        -fno-stack-protector 
        -fno-asynchronous-unwind-tables
        -O1
        -Wall
    DEPENDS ${CMAKE_SOURCE_DIR}/src/kernel.c
    VERBATIM
)

# Link kernel to PE ELF (32-bit with text base at 0x10000, suppress warnings)
add_custom_command(
    OUTPUT kernel.elf
    COMMAND ${CMAKE_C_COMPILER} -m32 -nostdlib -ffreestanding -Wl,-Ttext=0x10000 -Wl,--entry=kernel_main -Wl,--image-base=0x10000 kernel.o -o kernel.elf
    DEPENDS kernel.o
    VERBATIM
)

# Convert ELF to raw binary (only text and data sections)
add_custom_command(
    OUTPUT kernel.bin
    COMMAND objcopy -O binary -j .text -j .data kernel.elf kernel_raw.bin
    COMMAND ${CMAKE_COMMAND} -E echo "Padding kernel to 512 bytes..."
    COMMAND powershell -Command "$bytes = [System.IO.File]::ReadAllBytes('kernel_raw.bin'); $padded = New-Object byte[] 512; [Array]::Copy($bytes, $padded, $bytes.Length); [System.IO.File]::WriteAllBytes('kernel.bin', $padded)"
    DEPENDS kernel.elf
    VERBATIM
)

# Combine boot sector and kernel (pad kernel to full sector)
add_custom_command(
    OUTPUT firmware.bin
    COMMAND ${CMAKE_COMMAND} -E copy boot.bin firmware.bin
    COMMAND ${CMAKE_COMMAND} -E cat kernel.bin >> firmware.bin
    DEPENDS boot.bin kernel.bin
    VERBATIM
)

add_custom_target(firmware ALL DEPENDS firmware.bin)

# Print build info
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "ASM Compiler: nasm")
