
GCC_ARCH=riscv64-unknown-elf

MK_INCLUDES += $(ROCKET_SOC)/sw/bootrom/bootrom.mk
MK_INCLUDES += $(SIMSCRIPTS_DIR)/mkfiles/common_tool_gcc.mk

include $(MK_INCLUDES)

RULES := 1

all : bootrom.build

bootrom.build : bootrom/bootrom.img
	$(Q)rm -f ExampleRocketTop.v
	$(Q)touch $@
	
include $(MK_INCLUDES)

	