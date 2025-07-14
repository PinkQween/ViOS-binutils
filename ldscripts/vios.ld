ENTRY(c_start)
OUTPUT_FORMAT(elf32-i386)
OUTPUT_ARCH(i386)

SECTIONS
{
    . = 0x400000;
    .text : ALIGN(4096) { *(.text) *(.text.*) }
    .asm : ALIGN(4096) { *(.asm) }
    .rodata : ALIGN(4096) { *(.rodata) *(.rodata.*) }
    .data : ALIGN(4096) { *(.data) *(.data.*) }
    .bss : ALIGN(4096) { *(COMMON) *(.bss) *(.bss.*) }
    /DISCARD/ : { *(.comment) *(.note.*) }
}
