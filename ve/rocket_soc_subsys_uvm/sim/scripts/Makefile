
include $(PACKAGES_DIR)/packages.mk
include $(PACKAGES_DIR)/simscripts/mkfiles/plusargs.mk

TIMEOUT := 100ms

MK_INCLUDES += $(SIM_DIR)/scripts/rocket_soc_subsys_uvm.mk


TB=rocket_soc_subsys_tb
TB_MODULES_HDL=RocketSocSubsysTBHdl 
TB_MODULES_HVL=RocketSocSubsysTBHvl rocket_soc_subsys_tests_pkg

include $(PACKAGES_DIR)/simscripts/mkfiles/common_sim.mk


	
