
.globl PUT32
PUT32:
    str r1,[r0]
    bx lr

.globl GET32
GET32:
    ldr r0,[r0]
    bx lr

.globl dummy
dummy:
    bx lr


/* Clean and invalidate entire data cache */
.globl mmu_clean_invalidate_dcache
mmu_clean_invalidate_dcache:
    mov     r0, #0
    mcr     p15, 0, r0, c7, c14, 0
    bx lr

/* Clean and invalidate entire instruction cache */
.globl mmu_invalidate_icache
mmu_invalidate_icache:
    mov     r0, #0
    mcr     p15, 0, r0, c7, c5, 0
    bx lr

/* Clean and invalidate entire instruction cache */
.globl mmu_invalidate_all_cache
mmu_invalidate_all_cache:
    mov     r0, #0
    mcr     p15, 0, r0, c7, c7, 0
    bx lr

/* perform a data sync barrier operation */
.globl mmu_data_sync_barrier
mmu_data_sync_barrier:
    mov     r0, #0
    mcr     p15, 0, r0, c7, c10, 4
    bx lr

/* flush all unlocked TLB entries  */
.globl mmu_flush_tlb_unlocked
mmu_flush_tlb_unlocked:
    mov     r0, #0
    mcr     p15, 0, r0, c8, c7, 0
    bx lr

/* get the TTBCR  */
/* r0 = readval */
.globl mmu_get_ttbcr
mmu_get_ttbcr:
    mrc     p15, 0, r0, c2, c0, 2
    bx lr

/* set the TTBCR  */
/* r0 = writeval */
.globl mmu_set_ttbcr
mmu_set_ttbcr:
    mcr     p15, 0, r0, c2, c0, 2
    bx lr


/* get the CR  */
/* r0 = readval */
.globl mmu_get_cr
mmu_get_cr:
    mrc     p15, 0, r0, c1, c0, 0
    bx lr

/* set the CR  */
/* r0 = writeval */
.globl mmu_set_cr
mmu_set_cr:
    mcr     p15, 0, r0, c1, c0, 0
    bx lr

/* get the DACR  */
/* r0 = readval */
.globl mmu_get_dacr
mmu_get_dacr:
    mrc     p15, 0, r0, c3, c0, 0
    bx lr

/* set the DACR  */
/* r0 = writeval */
.globl mmu_set_dacr
mmu_set_dacr:
    mcr     p15, 0, r0, c3, c0, 0
    bx lr

/* get the TTBR0 */
/* r0 = readval */
.globl mmu_get_ttbr0
mmu_get_ttbr0:
    mrc     p15, 0, r0, c2, c0, 0
    bx lr

/* set the TTBR0 */
/* r0 = writeval */
.globl mmu_set_ttbr0
mmu_set_ttbr0:
    mcr     p15, 0, r0, c2, c0, 0
    bx lr

/* get the TTBR1 */
/* r0 = readval */
.globl mmu_get_ttbr1
mmu_get_ttbr1:
    mrc     p15, 0, r0, c2, c0, 1
    bx lr

/* set the TTBR1 */
/* r0 = writeval */
.globl mmu_set_ttbr1
mmu_set_ttbr1:
    mcr     p15, 0, r0, c2, c0, 1
    bx lr


.globl start_l1cache
start_l1cache:
    bl mmu_invalidate_all_cache
    bl mmu_flush_tlb_unlocked
    bl mmu_get_cr
    orr r0,r0,#0x1000 ;@ instruction
    orr r0,r0,#0x0004 ;@ data
    bl mmu_set_cr
    bx lr

.globl stop_l1cache
stop_l1cache:
    bl mmu_get_cr
    bic r0,r0,#0x1000 ;@ instruction
    bic r0,r0,#0x0004 ;@ data
    bl mmu_set_cr
    bx lr

