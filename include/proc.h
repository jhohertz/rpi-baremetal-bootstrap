
struct cpu {
  //struct context *scheduler;   // swtch() here to enter scheduler
  //struct taskstate ts;         // Used by x86 to find stack for interrupt
  int ncli;                    // Depth of pushcli nesting.
  int intena;                  // Were interrupts enabled before pushcli?
  
  // Cpu-local storage variables; see below
  //struct proc *proc;           // The currently-running process.
};
