// Mutual exclusion lock.
struct spinlock {
  uint locked;       // Is the lock held?
  
  // For debugging:
  char *name;        // Name of lock.
};

extern void _spinlock_take( uint* );
extern void _spinlock_give( uint* );

