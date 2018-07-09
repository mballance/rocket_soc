
ROCKET_SOC_UVM_SCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(ROCKET_SOC)/src/rocket_soc.mk
include $(STD_PROTOCOL_IF)/src/std_protocol_if.mk
include $(CHISELLIB)/src/chisellib.mk
include $(WB_SYS_IP)/src/wb_sys_ip.mk
include $(OC_WB_IP)/src/oc_wb_ip.mk
include $(OC_WB_IP)/rtl/wb_uart/fw/wb_uart_fw.mk
include $(AMBA_SYS_IP)/src/amba_sys_ip.mk
include $(ROCKET_SOC)/chiselscripts/mkfiles/chiselscripts.mk
include $(ROCKET_SOC)/utils/utils.mk
include $(ROCKET_SOC)/ve/sv_bfms/src/sv_bfms.mk
include $(VMON)/src/client/vmon_client.mk
include $(VMON)/src/client/sv/vmon_dpi_client.mk

ifneq (1,$(RULES))

BUILD_PRECOMPILE_TARGETS += $(ROCKET_SOC_GEN_TB_SRC) embedded_sw

SW_IMAGES := $(call get_plusarg,SW_IMAGE,$(PLUSARGS))
SW_IMAGE := $(firstword $(SW_IMAGES))

DPI_OBJS_LIBS += libvmon_client_dpi.o libvmon_client.o

RUN_PRE_TARGETS += ram.hex

else # Rules

$(ROCKET_SOC_GEN_TB_SRC) : bootrom.build
rocket_soc_uvm.mk : bootrom.build

ifneq (,$(SW_IMAGE))
ifeq (true,$(USE_ALTLIB))
ram.hex : $(BUILD_DIR)/esw/$(SW_IMAGE)
	$(Q)riscv64-unknown-elf-objcopy $^ -O ihex ram.ihex
	$(Q)perl $(ROCKET_SOC)/synthscripts/bin/objcopy_ihex2quartus_filter.pl \
		-width 64 ram.ihex $@
else # Simulation model
ram.hex : $(BUILD_DIR)/esw/$(SW_IMAGE)
	$(Q)riscv64-unknown-elf-objcopy $^ -O verilog ram.vlog
	$(Q)perl $(MEMORY_PRIMITIVES)/bin/objcopyvl2vl.pl \
		-width 64 -offset 0x40000000 -le ram.vlog $@
endif
else # No software image
ram.hex :
	echo "0000000000000000" > $@
	echo "0000000000000000" >> $@
	echo "0000000000000000" >> $@
	echo "0000000000000000" >> $@
	echo "0000000000000000" >> $@
	echo "0000000000000000" >> $@
	echo "0000000000000000" >> $@
	echo "0000000000000000" >> $@
	echo "0000000000000000" >> $@
	echo "0000000000000000" >> $@
	echo "0000000000000000" >> $@
endif

bootrom.build : embedded_sw

embedded_sw :
	echo "SW_IMAGES=$(SW_IMAGES)"
	if test ! -d esw; then mkdir -p esw; fi
	$(Q)$(MAKE) -C esw VERBOSE=$(VERBOSE) \
		-f $(ROCKET_SOC_UVM_SCRIPTS_DIR)/embedded.mk bootrom.build $(SW_IMAGES)

endif
