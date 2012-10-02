

#define PAGE_DIR_SIZE   0x4000
#define PAGE_DIR_OFFSET 0x4000
#define TEXT_OFFSET     0x8000
#define KERNEL_BASE	0x80000000

#ifdef __ASSEMBLY__

/* handy macros for assembly work */

        .macro  disable_irq
        cpsid   i
        .endm

        .macro  enable_irq
        cpsie   i
        .endm

#endif
