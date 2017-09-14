
BOOTROM_SRC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

SRC_DIRS += $(BOOTROM_SRC_DIR)

BOOTROM_OBJS=bootrom.o bootrom_main.o

else # Rules

bootrom/bootrom.img : bootrom.bin
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)dd if=$^ of=$@ bs=128 count=1
	
%.bin : %.elf
	$(Q)$(OBJCOPY) -O binary $< $@
	
bootrom.elf : $(BOOTROM_OBJS)
	$(Q)$(LD) -T$(BOOTROM_SRC_DIR)/bootrom.ld $^ -nostdlib -static -no-gcc-sections -o $@

endif
