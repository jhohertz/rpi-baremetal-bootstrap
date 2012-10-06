
// this is all just temporary....

extern void PUT32 ( unsigned int, unsigned int );
extern unsigned int GET32 ( unsigned int );
extern void dummy ( unsigned int );
extern char end[]; // first address after kernel loaded from ELF file
extern char pgtbl_startup[]; // first address after kernel loaded from ELF file

#define GPFSEL1 0xa0200004
#define GPSET0  0xa020001C
#define GPCLR0  0xa0200028


int notmain(void) {

    unsigned int ra;

    ra=GET32(GPFSEL1);
    ra&=~(7<<18);
    ra|=1<<18;
    PUT32(GPFSEL1,ra);

    while(1)
    {
        PUT32(GPSET0,1<<16);
        for(ra=0;ra<0x100000;ra++) dummy(ra);
        PUT32(GPCLR0,1<<16);
        for(ra=0;ra<0x100000;ra++) dummy(ra);
    }
    return(0);

}

