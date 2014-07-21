

#define TTBR_C           (1 << 0)
#define TTBR_S           (1 << 1)
#define TTBR_IMP         (1 << 2)
#define TTBR_RGN_NC      (0 << 3)
#define TTBR_RGN_WBWA    (1 << 3)
#define TTBR_RGN_WT      (2 << 3)
#define TTBR_RGN_WB      (3 << 3)

#define TTBR_FLAGS       TTBR_RGN_WBWA
#define MMU_START_CR	0x00801005

#define PGSIZE          4096    // bytes mapped by a page

#define PGROUNDUP(sz)  (((sz)+PGSIZE-1) & ~(PGSIZE-1))
#define PGROUNDDOWN(a) (((a)) & ~(PGSIZE-1))


#define PDE_CT		(1 << 0)	// Like the PTE, we (save for boot) ignore sections, really, so we use this as a "Present" bit
					// If we ever do use sections, it's a bad semantic to keep, as it will be clear for sections
#define PDE_SECTION	(2 << 0)	// Not likely to be used much, but here for completion, may be useful for moving off boot tables
#define PDE_NS		(1 << 3)	// Not likely to use. 
#define PDE_DOMAINSHIFT 5		// Not sure about these either, they sound deprecated in later ARM architectures.

// we ignore the 64kb page type, just 4kb armv6
#define PTE_XN		(1 << 0)	// Executable
#define PTE_P		(1 << 1)	// We treat this like a 'present' bit, since we ignore 64kb pages
#define PTE_B		(1 << 2)	// Bufferable
#define PTE_C		(1 << 3)	// Cacheable
#define PTE_AP0		(1 << 4)	// Access Protection Bit 0
#define PTE_AP1		(1 << 5)	// Access Protection Bit 1
#define PTE_TEX0	(1 << 6)	// Type Extension Bit 0
#define PTE_TEX1	(1 << 7)	// Type Extension Bit 1
#define PTE_TEX2	(1 << 8)	// Type Extension Bit 2
#define PTE_APX		(1 << 9)	// Access Protection Bit X
#define PTE_S		(1 << 10)	// Shared
#define PTE_NG		(1 << 11)	// Not-Global

// A virtual address 'la' has a three-part structure as follows:
//
// +--------12------+-------8--------+---------12----------+
// | Page Directory |   Page Table   | Offset within Page  |
// |      Index     |      Index     |                     |
// +----------------+----------------+---------------------+
//  \--- PDX(va) --/ \--- PTX(va) --/ 

// page directory index
#define PDX(va)         (((uint)(va) >> PDXSHIFT) & 0xFFF)    // mask to 4096

// page table index
#define PTX(va)         (((uint)(va) >> PTXSHIFT) & 0xFF)    // mask to 256

#define PTXSHIFT        12      // offset of PTX in a linear address
#define PDXSHIFT        20      // offset of PDX in a linear address

// construct virtual address from indexes and offset
#define PGADDR(d, t, o) ((uint)((d) << PDXSHIFT | (t) << PTXSHIFT | (o)))

// Address in first level directory, entry to level 2 table
#define PTE_ADDR(pde)   ((uint)(pde) & ~0x3FF)

// Address of page, in the page table entry
#define PAGE_ADDR(pte)   ((uint)(pte) & ~0xFFF)

#ifndef __ASSEMBLER__
typedef uint pte_t;
#endif


