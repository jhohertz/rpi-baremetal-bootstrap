// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include <types.h>
#include <defs.h>
//#include "param.h"
#include <memlayout.h>
#include <mmu.h>
#include <spinlock.h>

void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file (the ld script provides this)

// some kind of chain list
struct run {
  struct run *next;
};

// kmem is the main structure, a freelist, and a lock
struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
} kmem;

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list. This happens from the end of
// code+data, to the end of the first 4MB of memory
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}

// called to init rest of memory, from 4MB to PHYSTOP
void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
    kfree(p);
}

//PAGEBREAK: 21
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
  struct run *r;	// list entry

  // panic if we didnt ask for a page aligned address, it's... below end?, or translated as virtual over PHYSTOP? (odd)
  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
    for(;;);	// panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  // take lock if needed
  if(kmem.use_lock)
    acquire(&kmem.lock);

  // free node is put at top of the free page (neat)
  r = (struct run*)v;
  // insert at front of the freelist
  r->next = kmem.freelist;
  kmem.freelist = r;

  // release lock if needed
  if(kmem.use_lock)
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  // pointer to the run
  struct run *r;

  // lock if needed
  if(kmem.use_lock)
    acquire(&kmem.lock);

  // get the freelist head
  r = kmem.freelist;
  if(r)
    // point head to next item
    kmem.freelist = r->next;

  // unlock if needed
  if(kmem.use_lock)
    release(&kmem.lock);

  return (char*)r;
}

