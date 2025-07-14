ENTRY(_start)

SECTIONS
{
    /* Origen físico donde se cargará el kernel */
    . = 0x100000;

    .text :
    {
        *(.text.entry)      /* Código de arranque en ASM */
        *(.text*)           /* Código C */
    }

    .rodata :
    {
        *(.rodata*)
    }

    .data :
    {
        *(.data*)
    }

    .bss :
    {
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        __bss_end = .;
    }

    /DISCARD/ :
    {
        *(.eh_frame)
    }
}

