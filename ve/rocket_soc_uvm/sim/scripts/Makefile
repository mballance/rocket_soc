
include $(SIMSCRIPTS_DIR)/mkfiles/plusargs.mk

TIMEOUT := 100us

MK_INCLUDES += $(SIM_DIR)/scripts/rocket_soc_uvm.mk

TB=rocket_soc_tb
TB_MODULES_HDL=RocketSocTBHdl
TB_MODULES_HVL=RocketSocTBHvl rocket_soc_tests_pkg

# VSIM_FLAGS += -ldflags -L${SIM_DIR_A}


include $(SIMSCRIPTS_DIR)/mkfiles/common_sim.mk

	
