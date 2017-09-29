
include $(ROCKET_SOC)/src/rocket_soc.mk
include $(STD_PROTOCOL_IF)/src/std_protocol_if.mk
include $(CHISELLIB)/src/chisellib.mk
include $(WB_SYS_IP)/src/wb_sys_ip.mk
include $(OC_WB_IP)/src/oc_wb_ip.mk
include $(AMBA_SYS_IP)/src/amba_sys_ip.mk
include $(ROCKET_SOC)/chiselscripts/mkfiles/chiselscripts.mk
include $(ROCKET_SOC)/ve/sv_bfms/src/sv_bfms.mk

ifneq (1,$(RULES))

BUILD_PRECOMPILE_TARGETS += $(ROCKET_SOC_GEN_TB_SRC) bootrom.build

SW_IMAGES := $(call get_plusarg,SW_IMAGE,$(PLUSARGS))
SW_IMAGE := $(firstword $(SW_IMAGES))

RUN_PRE_TARGETS += ram.hex

else # Rules

$(ROCKET_SOC_GEN_TB_SRC) : bootrom.build
rocket_soc_uvm.mk : bootrom.build

ifneq (,$(SW_IMAGE))
ifeq (true,$(USE_ALTLIB))
ram.hex : $(BUILD_DIR)/$(SW_IMAGE)
	$(Q)riscv64-unknown-elf-objcopy $^ -O ihex ram.ihex
	$(Q)perl $(ROCKET_SOC)/synthscripts/bin/objcopy_ihex2quartus_filter.pl \
		-width 64 ram.ihex $@
else # Simulation model
ram.hex : $(BUILD_DIR)/$(SW_IMAGE)
	$(Q)riscv64-unknown-elf-objcopy $^ -O verilog ram.vlog
	$(Q)perl $(MEMORY_PRIMITIVES)/bin/objcopyvl2vl.pl \
		-width 64 -offset 0x80000000 -le ram.vlog $@
endif
else # No software image
ram.hex :
	echo "0000000200000001" > $@
	echo "0000000400000003" >> $@
	echo "0000000600000005" >> $@
	echo "0000000800000007" >> $@
	echo "0000000a00000009" >> $@
	echo "0000000c0000000b" >> $@
	echo "0000000e0000000d" >> $@
	echo "000000100000000f" >> $@
	echo "0000001200000011" >> $@
	echo "0000001400000013" >> $@
	echo "0000001600000015" >> $@
endif

bootrom.build :
	echo "SW_IMAGES=$(SW_IMAGES)"
	$(Q)$(MAKE) -f $(SIM_DIR)/scripts/embedded.mk bootrom.build $(SW_IMAGES)

endif
