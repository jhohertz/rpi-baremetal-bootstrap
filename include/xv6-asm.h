

#define PAGE_DIR_OFFSET 0x4000

#ifdef __ASSEMBLY__

/* handy macros for assembly work */

        .macro  disable_irq
        cpsid   i
        .endm

        .macro  enable_irq
        cpsie   i
        .endm

#endif
