.section ".text.boot" // make sure that the Linker puts this at the start of the kernel image

.global _start

_start:
    // check that the processor ID is 0, to ensure we are using main core
    mrs x0, mpidr_el1 // copy the Multiprocessor Affinity Register into x0
    and x0, x0, #3 // clear all but lower 2 bits
    cbz x0, setup_vars // if x0 is 0, we are on core 0 and can proceed

hang:
    wfe // hang if we are not on core 0
    b hang

setup_vars:
    // load registers with addresses of bss start and end
    ldr x5, =__bss_start
    lrd x6, =__bss_end

clear_bss:
    // zero out bss section to start fresh on boot

