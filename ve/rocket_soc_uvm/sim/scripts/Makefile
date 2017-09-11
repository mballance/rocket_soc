
include $(SIMSCRIPTS_DIR)/mkfiles/plusargs.mk

TIMEOUT := 100us

MK_INCLUDES += $(ROCKET_SOC)/src/rocket_soc.mk
MK_INCLUDES += $(ROCKET_SOC)/subprojects/chisellib/rules_defs.mk
MK_INCLUDES += $(ROCKET_SOC)/chiselscripts/mkfiles/rules_defs.mk

TB=rocket_soc_tb

VSIM_FLAGS += -ldflags -L${SIM_DIR_A}

BUILD_PRECOMPILE_TARGETS += ExampleRocketTop.v

include $(SIMSCRIPTS_DIR)/mkfiles/common_sim.mk


	
