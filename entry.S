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
#include <mmu.h>

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


ldr r2, =V2P_WO(textstart)

/*
* Set the GPIO function select.
*/
ldr r1,=0x20200000
mov r0,#1
lsl r0,#18
str r0,[r1,#4]

mov pc, r2

.section .text
.globl textstart
textstart:

/* STILL not using virtual addresses yet we MUST get a pre-mapped MMU */
/* table up and running before branching to the real kernel startup   */

/* setup the ttbr0 to start */
adr r0, __pgtbl_startup_loc

ldmia   r0, {r3, r5, r6}		@ offset marker, virt page table, virt 'notmain'
sub     r0, r0, r3                      @ virt->phys offset
add     r5, r5, r0                      @ phys pgtbl_base

mov     r0, #0
mcr     p15, 0, r0, c2, c0, 2		@ set ttbcr to only use ttbr0

mvn	r0, #0
mcr     p15, 0, r0, c3, c0, 0		@ set domain access control register

orr     r5, r5, #TTBR_FLAGS		@ add flags
mcr     p15, 0, r5, c2, c0, 0		@ set ttbr0 (level 1 page table base)

mov     r0, #0
mcr     p15, 0, r0, c7, c7, 0		@ flush the l1 caches
mcr     p15, 0, r0, c8, c7, 0		@ flush the tlb


@ after this stanza, the universe around us is no more, replaced, by a new existance 
mrc     p15, 0, r0, c1, c0, 0		@ get current config register
ldr     r1, =MMU_START_CR		@ ARMv6 page tables, instruction cache, datacache, and mmu enable
orr	r0, r0, r1			@ apply to current
mcr     p15, 0, r0, c1, c0, 0		@ set modified config register

/* 
* turn led on
ldr r7,=0xa0200000
mov r0,#1
lsl r0,#16
str r0,[r7,#40]
*/

ldr sp, =0x00007FFF			@ setup a stack pointer

b notmain
@mov     pc, r6				@ leap into the virtual world, to the real start of our kernel

.align
__pgtbl_startup_loc:
  .long .
  .long pgtbl_startup
  .long notmain


