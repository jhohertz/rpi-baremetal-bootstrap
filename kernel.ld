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
	*/
        . = 0x80000000;
	.init : AT(0x0000) {
		*(.init)
	}
	
        . = 0x80004000;
        PROVIDE(pgtbl_base = .);
	.pgtbl : AT(0x4000) {
                FILL(0x00000000)
                LONG(0xdeadbeef)
                . = 0x2000;
                LONG(0x12345678)
                 
	}

	/* 
	* We allow room for the ATAGs and the stack and then start our code at
	* 0x8000.
	*/
        . = 0x80008000;
	.text : AT(0x8000) {
		*(.text)
	}
        PROVIDE(etext = .);
	
	/* 
	* Next we put the data.
	*/
        PROVIDE(data = .);
	.data : {
		*(.data)
	}
        PROVIDE(edata = .);

        .bss : {
                *(.bss)
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
