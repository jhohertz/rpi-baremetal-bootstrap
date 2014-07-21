
This was a start at porting [MIT's xv6 teaching OS](http://pdos.csail.mit.edu/6.828/2012/xv6.html) to the [Raspberry Pi](http://www.raspberrypi.org/). 

The effort stalled when I got to the VM details. XV6 makes use of the nice way the x86 VM tables all map nicely into 4k blocks. ARM has a mix of sizes needed, and I didn't have time to sort out the details at the time. I could have done it in a simple but vastly wasteful way, but didn't want to do that.

When I came back to it, it there were a [couple](https://code.google.com/p/xv6-rpi/) [other](https://github.com/david50407/xv6-rpi) efforts that had sprung up and done the job already.

I don't plan to do anything with this, but it is a useful example of bare metal programming the Pi.

All it does, is map it's code into the kernel area at the top half of the memory area, sets the bottom half as user space memory, jump into the "kernel", and blink the LED on the Pi.

Some bits of xv6 were ported, those things at the "leaf" ends of the dependency graphs, as I was intending to build inward from that perspective, and downward from the bootstrap,


