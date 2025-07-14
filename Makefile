# Variables
CC = gcc
ASM = nasm
CFLAGS = -Wall -Wextra -ffreestanding -O2 -mno-red-zone -m64 -Iinclude
LDFLAGS = -nostdlib -static -T scripts/linker.ld

OBJDIR = obj
BINDIR = bin

SRCS_C = \
    kernel/main.c \
    kernel/panic.c \
    kernel/printk.c \
    arch/x86_64/cpu/cpuid.c \
    arch/x86_64/irq/isr.c \
    arch/x86_64/mm/paging.c

SRCS_ASM = arch/x86_64/boot/head.S

OBJS_C = $(patsubst %.c,$(OBJDIR)/%.o,$(SRCS_C))
OBJS_ASM = $(patsubst %.S,$(OBJDIR)/%.o,$(SRCS_ASM))

KERNEL = $(BINDIR)/kernel.bin

.PHONY: all clean

all: $(KERNEL)

# Compilar C
$(OBJDIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# Compilar ASM
$(OBJDIR)/%.o: %.S
	@mkdir -p $(dir $@)
	$(ASM) -f elf64 $< -o $@

# Linkear kernel
$(KERNEL): $(OBJS_C) $(OBJS_ASM)
	@mkdir -p $(BINDIR)
	ld $(LDFLAGS) -o $@ $^

clean:
	rm -rf $(OBJDIR) $(BINDIR)

