ARCH       ?= aarch64-none-elf
CC         := $(ARCH)-gcc
LD         := $(ARCH)-ld
AR         := $(ARCH)-ar
OBJCOPY    := $(ARCH)-objcopy

help:
	@printf "Hello World\n"
	@echo $(MAKE)
	