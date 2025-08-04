ARCH       ?= aarch64-none-elf
CC         := $(ARCH)-gcc
LD         := $(ARCH)-ld
AR         := $(ARCH)-ar
OBJCOPY    := $(ARCH)-objcopy

CFLAGS_BASE  ?= -g -O0 -nostdlib -ffreestanding \
                -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables \
                -Wall -Wextra -Wno-unused-parameter -Wno-address-of-packed-member -mcpu=cortex-a72
CONLY_FLAGS_BASE ?= -std=c17
LDFLAGS_BASE ?=

LOAD_ADDR      ?= 0x41000000
XHCI_CTX_SIZE  ?= 32
QEMU           ?= true
MODE           ?= virtual

export ARCH CC LD AR OBJCOPY CFLAGS_BASE CONLY_FLAGS_BASE LDFLAGS_BASE LOAD_ADDR XHCI_CTX_SIZE QEMU

OS      := $(shell uname)
FS_DIR := fs/redos/user

BOOTFS := /media/bootfs

help:
	@printf "Hello World\n"
	@echo $(MAKE)

all: kernel
	@echo "Build complete."
	./fs.sh

kernel:
	$(MAKE) -C kernel LOAD_ADDR=$(LOAD_ADDR) XHCI_CTX_SIZE=$(XHCI_CTX_SIZE) QEMU=$(QEMU)

virtual:
	$(MAKE) LOAD_ADDR=0x80000 XHCI_CTX_SIZE=64 QEMU=true all

run:
	$(MAKE) $(MODE)
	./run_$(MODE).sh

prepare-fs:
	@echo "making fs dir"
	@mkdir -p $(FS_DIR)
	