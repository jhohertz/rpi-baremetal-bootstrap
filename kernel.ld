/******************************************************************************
*	kernel.ld
*	 by Alex Chadwick
*
*	A linker script for generation of raspberry pi kernel images.
******************************************************************************/

OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)


SECTIONS {


	/*
	* First and formost we need the .init section, containing the IVT.
	* Not really... loads @ 0x8000.. we have a 16k boot code bit here
	* We use a few words at most for now.
	*/
        . = 0x80008000;
	.init : AT(0x8000) {
		*(.init)
	}
	
        /* 16k for level 1 page tables */
        . = 0x8000c000;
        PROVIDE(pgtbl_startup = .);
	.pgtbl : AT(0xc000) {
                FILL(0x00000000)
                LONG(0x0000000e)
                LONG(0x0010000e)
                LONG(0x0020000e)
                LONG(0x0030000e)
                . = 0x2000;
                LONG(0x0000000e)
                LONG(0x0010000e)
                LONG(0x0020000e)
                LONG(0x0030000e)
                . = 0x2800;
                LONG(0x20000002)
                LONG(0x20100002)
                LONG(0x20200002)
                LONG(0x20300002)
	}

	/* 
	* We allow room for the ATAGs and the stack and then start our code at
	* 0x8000.
	* Again... not really, we load @ 0x8000, and ATAGs are just fine
	*/
        . = 0x80010000;
	.text : AT(0x10000) {
		*(.text)
	}
        PROVIDE(etext = .);

        .rodata : {
                *(.rodata .rodata.* .gnu.linkonce.r.*)
        }
	
	/* text and rodata get marked read only in the MMU, ensure a clean page boundary at the end */
	. = ALIGN(0x1000);

	/* 
	* Next we put the data.
	*/
        PROVIDE(data = .);
	.data : {
		*(.data)
	}
        PROVIDE(edata = .);

        .bss : {
                *(.bss) *(COMMON)
        }

        PROVIDE(end = .);


	/*
	* Finally comes everything else. A fun trick here is to put all other 
	* sections into this section, which will be discarded by default.
	*/
	/DISCARD/ : {
		*(*)
	}
}
