
GCC_ARCH=riscv64-unknown-elf

MK_INCLUDES += $(SIMSCRIPTS_DIR)/mkfiles/common_tool_gcc.mk
MK_INCLUDES += $(ROCKET_SOC)/sw/bootrom/bootrom.mk
MK_INCLUDES += $(ROCKET_SOC)/sw/app/app.mk
MK_INCLUDES += $(ROCKET_SOC)/ve/rocket_soc_uvm/tests/sw/sw_tests.mk
MK_INCLUDES += $(ROCKET_SOC)/subprojects/vmon/src/monitor/vmon_monitor.mk
MK_INCLUDES += $(OC_WB_IP)/rtl/wb_uart/fw/wb_uart_fw.mk
MK_INCLUDES += $(UEX)/uex.mk
MK_INCLUDES += $(UEX)/impl/threading/uth/uex_threading_uth.mk
MK_INCLUDES += $(UEX)/impl/threading/uth/riscv/uex_threading_uth_riscv.mk

CFLAGS += -march=rv64imafd
ASFLAGS += -march=rv64imafd
CFLAGS += -g

# SRC_DIRS += $(ROCKET_SOC)/ve/rocket_soc_uvm/tests/sw

include $(MK_INCLUDES)

RULES := 1

all : bootrom.build 

bootrom.build : bootrom/bootrom.img
	$(Q)rm -f ExampleRocketTop.v
	$(Q)touch $@
	
	
app/%.elf : app/%.o $(SW_APP_CORE_LIB) # $(DEVTREE_OBJS)
	$(Q)echo "build app/$(*).elf from $^"
#	$(Q)$(CC) -Wl,-T,$(SW_APP_DIR)/app.ld -o $@ $^
	$(Q)$(CC) -print-file-name=libc.a
	$(Q)$(LD) -T $(SW_APP_DIR)/app.ld -o $@ $^ $(LIBGCC) $(LIBC)
	
include $(MK_INCLUDES)

	
