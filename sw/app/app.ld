
MEMORY
{
	ram(rwx) : ORIGIN = 0x80000000, LENGTH = 0x00010000
}

SECTIONS
{
    /* default entry point */
	.text : {
		CREATE_OBJECT_SYMBOLS
		. += 0x1000; /* Reserve space for the ROM runtime */
		*(.app_crt0)
        *(.text .text.* .gnu.linkonce.t.*)
        *(.plt)
        *(.gnu.warning)
        *(.glue_7t) *(.glue_7)

        . = ALIGN(0x4);

        /* Static constructor / destructors */
        KEEP (*crtbegin.o(.ctors))
        KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
        KEEP (*(SORT(.ctors.*)))
        KEEP (*crtend.o(.ctors))
        KEEP (*crtbegin.o(.dtors))
        KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
        KEEP (*(SORT(.dtors.*)))
        KEEP (*crtend.o(.dtors))

        *(.rodata .rodata.* .gnu.linkonce.r.*)

        *(.init)
        *(.fini)
        . = ALIGN(0x4);
    } >ram
    
    .init_array : {
        __init_array_start = .;
        _init = .;
        *(.init_array)
        . = ALIGN(0x4);
    } >ram
    __init_array_end = .;

    _etext = .;

    .ramvec : {
        *(.ramvec)
        . = ALIGN(0x4);
    } >ram

    . = ALIGN(16);

    .data ALIGN(0x10): {
        . = ALIGN(0x4);
        __data_load = LOADADDR(.data);
        __data_start = .;
        KEEP(*(.jcr))
        *(.got.plt) *(.got)
        *(.shdata)
        *(.data .data.* .gnu.linkonce.d.*)
        . = ALIGN(4);
        _edata = .;
    } >ram

    .bss ALIGN(0x4): {
        _bss_start = .;
        *(.shbss)
        *(.bss .bss.* .gnu.linkonce.b.*)
        *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
    } >ram
   
/*    .heap_stack ALIGN(0x10): { */
    	PROVIDE(_heap_start = .);
    	. = 0x80010000;
    	PROVIDE(_stack_top = .);
/*    } >ram */
}
