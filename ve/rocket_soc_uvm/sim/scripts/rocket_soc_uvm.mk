
ROCKET_SOC_UVM_SCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
# ROCKET_SOC ?= $(abspath $(ROCKET_SOC_UVM_SCRIPTS_DIR)/../../../..)

include $(PACKAGES_DIR)/packages.mk
#include $(ROCKET_SOC)/mkfiles/rocket_soc.mk
#include $(PACKAGES_DIR)/rocket-chip/mkfiles/rocket-chip.mk
#include $(PACKAGES_DIR)/berkeley-hardfloat/mkfiles/berkeley-hardfloat.mk
#include $(PACKAGES_DIR)/std_protocol_if/mkfiles/std_protocol_if.mk
#include $(PACKAGES_DIR)/chisellib/mkfiles/chisellib.mk
#include $(PACKAGES_DIR)/wb_sys_ip/mkfiles/wb_sys_ip.mk
#include $(PACKAGES_DIR)/oc_wb_ip/mkfiles/oc_wb_ip.mk
#include $(PACKAGES_DIR)/oc_wb_ip/rtl/wb_uart/fw/wb_uart_fw.mk
#include $(PACKAGES_DIR)/amba_sys_ip/mkfiles/amba_sys_ip.mk
#include $(PACKAGES_DIR)/chiselscripts/mkfiles/chiselscripts.mk
#include $(PACKAGES_DIR)/memory_primitives/mkfiles/memory_primitives.mk
# include $(ROCKET_SOC)/utils/utils.mk
#include $(PACKAGES_DIR)/sv_bfms/mkfiles/sv_bfms.mk
include $(PACKAGES_DIR)/vmon/src/client/vmon_client.mk
include $(PACKAGES_DIR)/vmon/src/client/sv/vmon_dpi_client.mk

ifneq (1,$(RULES))

BUILD_PRECOMPILE_TARGETS += $(ROCKET_SOC_GEN_TB_SRC) embedded_sw

SW_IMAGES := $(call get_plusarg,SW_IMAGE,$(PLUSARGS))
SW_IMAGE := $(firstword $(SW_IMAGES))

DPI_OBJS_LIBS += libvmon_client_dpi.o libvmon_client.o

RUN_PRE_TARGETS += ram.hex

else # Rules

$(ROCKET_SOC_GEN_TB_SRC) : esw/bootrom.build
rocket_soc_uvm.mk : esw/bootrom.build

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

esw/bootrom.build : embedded_sw

embedded_sw :
	echo "ROCKET_SOC_GEN_TB_SRC=$(ROCKET_SOC_GEN_TB_SRC)"
	echo "BUILD_PRECOMPILE_TARGETS=$(BUILD_PRECOMPILE_TARGETS)"
	echo "SW_IMAGES=$(SW_IMAGES)"
	if test ! -d esw; then mkdir -p esw; fi
	$(Q)$(MAKE) -C esw VERBOSE=$(VERBOSE) PACKAGES_DIR=$(PACKAGES_DIR) \
		-f $(ROCKET_SOC_UVM_SCRIPTS_DIR)/embedded.mk bootrom.build $(SW_IMAGES)

endif
