
BOOTROM_SRC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

SRC_DIRS += $(BOOTROM_SRC_DIR)

BOOTROM_OBJS=bootrom/bootrom.o bootrom/bootrom_main.o

else # Rules

bootrom/bootrom.img : bootrom/bootrom.bin
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)dd if=$^ of=$@ bs=128 count=1
	
bootrom/%.bin : bootrom/%.elf
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(OBJCOPY) -O binary $< $@
	
bootrom/bootrom.elf : $(BOOTROM_OBJS)
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(LD) -T$(BOOTROM_SRC_DIR)/bootrom.ld $^ -nostdlib -static -no-gcc-sections -o $@
	
bootrom/%.o : %.c
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(CC) -c $(CFLAGS) -o $@ $^
	
bootrom/%.o : %.S
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(CC) -c $(CFLAGS) -o $@ $^

endif
