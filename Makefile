
OUTNAME = kernel

ARMGNU ?= arm-none-eabi
#ARMGNU ?= arm-linux-gnu

AOPS = --warn --fatal-warnings -mcpu=arm1176jzf-s -march=armv6
COPS0 = -Wall -O1 -nostdlib -nostartfiles -ffreestanding 
COPS1 = -Wall -O2 -nostdlib -nostartfiles -ffreestanding 
COPS2 = -Wall -O3 -nostdlib -nostartfiles -ffreestanding 
COPS3 = -Wall -O2 -nostdlib -nostartfiles -ffreestanding -mcpu=arm1176jzf-s 
COPS4 = -Wall -O2 -nostdlib -nostartfiles -ffreestanding -mcpu=arm1176jzf-s -mtune=arm1176jzf-s
COPS5 = -Wall -O3 -nostdlib -nostartfiles -ffreestanding -mcpu=arm1176jzf-s -mtune=arm1176jzf-s
COPS = $(COPS5)

all : $(OUTNAME).hex $(OUTNAME).bin

clean :
	rm -f *.o
	rm -f *.bin
	rm -f *.hex
	rm -f *.elf
	rm -f *.list
	rm -f *.img

# The names of all object files that must be generated. Deduced from the 
# assembly code files in source.
#AOBJECTS := $(patsubst %.S,%.o,$(wildcard *.S))
#COBJECTS := $(patsubst %.c,%.o,$(wildcard *.c))


OBJECTS = \
	kalloc.o\
	main.o\
	spinlock.o\
	string.o\
	vectors.o\
	entry.o
#	vm.o\

# Rule to make the object files.
%.o: %.S
	$(ARMGNU)-gcc $(COPS) -fno-pic -nostdinc -I./include -c $< -o $@
#$(ARMGNU)-as $(AOPS) -I ./include $< -o $@
#$(CC) $(CFLAGS) -fno-pic -nostdinc -I. -c entryother.S

%.o: %.c
	$(ARMGNU)-gcc $(COPS) -I ./include -c $< -o $@

$(OUTNAME).elf : kernel.ld $(OBJECTS)
	$(ARMGNU)-ld $(OBJECTS) -T kernel.ld -o $(OUTNAME).elf
	$(ARMGNU)-objdump -D $(OUTNAME).elf > $(OUTNAME).list

$(OUTNAME).bin : $(OUTNAME).elf
	$(ARMGNU)-objcopy $(OUTNAME).elf -O binary $(OUTNAME).bin

$(OUTNAME).hex : $(OUTNAME).elf
	$(ARMGNU)-objcopy $(OUTNAME).elf -O ihex $(OUTNAME).hex








