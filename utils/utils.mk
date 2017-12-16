
UTILS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

ifneq (Msys,$(uname_o))
DTC_BUILD := dtc.build
endif

dtc.build : 
	$(Q)cp -r $(UTILS_DIR)/dtc .
	$(Q)cp /usr/include/fnmatch.h dtc
	$(Q)$(MAKE) CFLAGS="-fPIC -Wno-error=format-extra-args" -C dtc
	$(Q)touch $@

else # Rules

endif

