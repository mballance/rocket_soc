
GCC_ARCH=riscv64-unknown-elf

MK_INCLUDES += $(ROCKET_SOC)/sw/bootrom/bootrom.mk
MK_INCLUDES += $(ROCKET_SOC)/sw/app/app.mk
MK_INCLUDES += $(ROCKET_SOC)/ve/rocket_soc_uvm/tests/sw/sw_tests.mk
MK_INCLUDES += $(SIMSCRIPTS_DIR)/mkfiles/common_tool_gcc.mk

CFLAGS += -march=rv64imafd
ASFLAGS += -march=rv64imafd

# SRC_DIRS += $(ROCKET_SOC)/ve/rocket_soc_uvm/tests/sw

include $(MK_INCLUDES)

RULES := 1

all : bootrom.build 

bootrom.build : bootrom/bootrom.img
	$(Q)rm -f ExampleRocketTop.v
	$(Q)touch $@
	
	
app/%.elf : app/%.o $(SW_APP_CORE_LIB)
	$(Q)echo "build app/$(*).elf from $^"
	$(Q)$(LD) -T $(SW_APP_DIR)/app.ld -o $@ $^
	
include $(MK_INCLUDES)

	
