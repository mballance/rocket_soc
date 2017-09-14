
include $(ROCKET_SOC)/src/rocket_soc.mk
include $(ROCKET_SOC)/subprojects/chisellib/rules_defs.mk
include $(ROCKET_SOC)/chiselscripts/mkfiles/rules_defs.mk

ifneq (1,$(RULES))

BUILD_PRECOMPILE_TARGETS += ExampleRocketTop.v bootrom.build

else # Rules

ExampleRocketTop.v : bootrom.build

bootrom.build : 
	$(Q)$(MAKE) -f $(SIM_DIR)/scripts/embedded.mk
	
rocket_soc_uvm.mk : bootrom.build

endif
