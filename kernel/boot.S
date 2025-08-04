.section ".text.boot" // make sure that the Linker puts this at the start of the kernel image

.global _start

_start:
    // check that the processor ID is 0, to ensure we are using main core
    mrs x0, mpidr_el1 // copy the Multiprocessor Affinity Register into x0
    and x0, x0, #3 // clear all but lower 2 bits
    cbz x0, init // if x0 is 0, we are on core 0 and can proceed

hang:
    wfe // hang if we are not on core 0
    b hang

init:
    // set stack start below code
    ldr x0, =_start
    mv sp, x0

    // load registers with address of bss start and section size
    ldr x0, =__bss_start
    ldr w2, =__bss_size // number of 64-bit memory locations

clear_bss:
    // zero out bss section to start fresh on boot
    cbz w2, start // quit if size is 0
    str xzr, [x1], #8 // store 64-bit 0 read fro xzr in address specified by x1, then increment by 8 bytes for next loop
    sub w2, w2, #1 // decrement size
    cbnz w2, clear_bss // loop if size is not 0

start:
    bl main // jump to main() routine in kernel.c
    b hang // hang if main returns for some reason
