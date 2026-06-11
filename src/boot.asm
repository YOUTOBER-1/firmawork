[bits 16]
org 0x7c00

_start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti

    ; Print A
    mov si, msg_a
    call print_string

    ; Setup load address: 0x1000:0x0000 = 0x10000 physical
    mov ax, 0x1000
    mov es, ax
    xor bx, bx

    ; Read disk
    mov ah, 0x02    ; Read function
    mov al, 1       ; Read 1 sector
    mov ch, 0       ; Cylinder 0
    mov cl, 2       ; Sector 2
    mov dh, 0       ; Head 0
    ; DL = boot drive (from BIOS)
    int 0x13
    jc error

    ; Print B (success)
    mov si, msg_b
    call print_string

    ; Enable A20
    in al, 0x92
    or al, 0x02
    out 0x92, al

    ; Load GDT
    cli
    lgdt [gdt_descriptor]

    ; Enter protected mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; Jump to 32-bit code
    jmp CODE_SEG:protected_mode

error:
    mov si, msg_e
    call print_string
    hlt
    jmp $

print_string:
    mov ah, 0x0e
.loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

msg_a db 'A', 0
msg_b db 'B', 0
msg_e db 'E', 0

; GDT
gdt_start:
    dq 0x0000000000000000
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ 0x08
DATA_SEG equ 0x10

[bits 32]
protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov esp, 0x90000

    ; Call kernel at 0x10000
    call 0x10000

    hlt
    jmp $

times 510-($-$$) db 0
dw 0xaa55
