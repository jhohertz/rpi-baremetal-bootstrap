// Mutual exclusion spin locks.

#include <types.h>
#include <defs.h>
//#include "param.h"
//#include "x86.h"
//#include "memlayout.h"
//#include "mmu.h"
#include <proc.h>
#include <spinlock.h>

extern struct cpu *cpu;

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
  lk->locked = 0;
}

// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    for(;;)  // panic("acquire");

  // take the spinlock
  _spinlock_take(&lk->locked);
}

// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    for(;;)  // panic("release");

  // release the spinlock
  _spinlock_give(&lk->locked);

  popcli();
}

// Check whether this lock is held.
int
holding(struct spinlock *lock)
{
  return lock->locked;
}


// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  uint idisable;
  idisable = _checki();
  _cli();
  if(cpu->ncli++ == 0)
    cpu->intena = idisable;
}

void
popcli(void)
{
  if(!_checki())
    for(;;);      // panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    for(;;);      // panic("popcli");
  if(cpu->ncli == 0 && (!cpu->intena))
    _sti();
}

