/******************************************************************************
*	main.s
*	 by Alex Chadwick
*
*	A sample assembly code implementation of the ok02 operating system, that 
*	simply turns the OK LED on and off repeatedly.
*	Changes since OK01 are marked with NEW.
******************************************************************************/

#include <xv6-asm.h>
#include <memlayout.h>

/*
* .section is a diractive to our assembler telling it to place this code first.
* .globl is a directive to our assembler, that tells it to export this symbol
* to the elf file. Convention dictates that the symbol _start is used for the 
* entry point, so this all has the net effect of setting the entry point here.
* Ultimately, this is useless as the elf itself is not used in the final 
* result, and so the entry point really doesn't matter, but it aids clarity,
* allows simulators to run the elf, and also stops us getting a linker warning
* about having no entry point. 
*/
.p2align 2
.section .init
.globl _start
_start = V2P_WO(_start_2)
/* just leap right into .text area */
_start_2:
mov pc, #0x00008000

.section .text
.globl realstart
realstart:

b notmain


/* mov sp,#0x8000 */


