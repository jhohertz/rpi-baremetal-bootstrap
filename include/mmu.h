

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


