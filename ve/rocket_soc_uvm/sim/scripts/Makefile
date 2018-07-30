
include $(ROCKET_SOC)/packages/simscripts/mkfiles/plusargs.mk
PACKAGES_DIR := $(ROCKET_SOC)/packages

TIMEOUT := 100us

MK_INCLUDES += $(SIM_DIR)/scripts/rocket_soc_uvm.mk

TB=rocket_soc_tb
TB_MODULES_HDL=RocketSocTBHdl
TB_MODULES_HVL=RocketSocTBHvl rocket_soc_tests_pkg

SRC_DIRS += $(ROCKET_SOC)/ve/rocket_soc_uvm/tb/vl
ROCKET_SOC_VL_TB_SRC = $(notdir $(wildcard $(ROCKET_SOC)/ve/rocket_soc_uvm/tb/vl/*.cpp))

VL_TB_OBJS_LIBS += librocket_soc_uvm_tb.o


include $(ROCKET_SOC)/packages/simscripts/mkfiles/common_sim.mk


librocket_soc_uvm_tb.o : $(ROCKET_SOC_VL_TB_SRC:.cpp=.o)
	$(Q)$(LD) -r -o $@ $(ROCKET_SOC_VL_TB_SRC:.cpp=.o)
