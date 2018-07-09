
include $(ROCKET_SOC)/packages/simscripts/mkfiles/plusargs.mk
PACKAGES_DIR := $(ROCKET_SOC)/packages

TIMEOUT := 100us

MK_INCLUDES += $(SIM_DIR)/scripts/rocket_soc_uvm.mk

TB=rocket_soc_tb
TB_MODULES_HDL=RocketSocTBHdl
TB_MODULES_HVL=RocketSocTBHvl rocket_soc_tests_pkg

BUILD_PRECOMPILE_TARGETS += ivpm_build

ivpm_build :
	$(Q)$(MAKE) -C $(ROCKET_SOC)/scripts -f ivpm.mk build


# VSIM_FLAGS += -ldflags -L${SIM_DIR_A}


include $(ROCKET_SOC)/packages/simscripts/mkfiles/common_sim.mk


