
BOOTROM_SRC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(PACKAGES_DIR)/bmk/configs/riscv/bare/bare.mk

ifneq (1,$(RULES))

SRC_DIRS += $(BOOTROM_SRC_DIR)

DEVTREE_OBJS=rocket_soc_uex_devtree.o


#BOOTROM_OBJS=bootrom/bootrom.o bootrom/bootrom_main.o 
#BOOTROM_DEPS=libvmon_monitor.o

# BOOTROM_OBJS=libbmk_riscv.o libbmk.o
# BOOTROM_OBJS=bootrom.o bootrom_main.o
BOOTROM_OBJS=$(BMK_DEPS) libvmon_monitor.o bootrom_main.o

else # Rules

bootrom/bootrom.img : bootrom/bootrom.bin
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
#	$(Q)dd if=$^ of=$@ bs=128 count=1
	$(Q)dd if=$^ of=$@ bs=128 
	
bootrom/%.bin : bootrom/%.elf
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(OBJCOPY) -O binary $< $@
	
bootrom/bootrom.elf : $(BOOTROM_OBJS) $(BOOTROM_DEPS)
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(LD) -T$(BMK_DIR)/src/impl/sys/riscv/bmk_riscv.ld \
		$^ -nostdlib -static -no-gcc-sections -o $@

bootrom/bootrom.sym : bootrom/bootrom.elf
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(NM) bootrom/bootrom.elf | grep ' T ' | grep -v 'T _' | sed -e 's/\([0-9a-f][0-9a-f]*\) T \([a-zA-Z][a-zA-Z0-9_]*\)/\2 = 0x\1;/g' > $@

bootrom/%.o : %.c
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(CC) -c $(CFLAGS) -o $@ $^
	
bootrom/%.o : %.S
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(CC) -c $(CFLAGS) -o $@ $^

endif
