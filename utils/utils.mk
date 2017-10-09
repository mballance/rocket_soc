
UTILS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

DTC_BUILD := dtc.build

dtc.build : 
	$(Q)cp -r $(UTILS_DIR)/dtc .
	$(Q)$(MAKE) -C dtc
	$(Q)touch $@

else # Rules

endif

