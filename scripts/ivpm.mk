
ROCKET_SOC_SCRIPTS_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
ROCKET_SOC_DIR := $(abspath $(ROCKET_SOC_SCRIPTS_DIR)/..)
PACKAGES_DIR ?= $(ROCKET_SOC_DIR)/packages
LIB_DIR = $(ROCKET_SOC_DIR)/lib

# Must support dual modes: 
# - build dependencies if this project is the active one
# - rely on the upper-level makefile to resolve dependencies if we're not
-include $(PACKAGES_DIR)/packages.mk
include $(ROCKET_SOC_DIR)/etc/ivpm.info

# include $(CHISELLIB_DIR)/src/chisellib.mk
include $(PACKAGES_DIR)/chiselscripts/mkfiles/chiselscripts.mk
include $(PACKAGES_DIR)/chisellib/mkfiles/chisellib.mk
include $(PACKAGES_DIR)/std_protocol_if/mkfiles/std_protocol_if.mk
include $(PACKAGES_DIR)/oc_wb_ip/mkfiles/oc_wb_ip.mk
include $(PACKAGES_DIR)/wb_sys_ip/mkfiles/wb_sys_ip.mk
include $(PACKAGES_DIR)/amba_sys_ip/mkfiles/amba_sys_ip.mk
include $(PACKAGES_DIR)/sv_bfms/mkfiles/sv_bfms.mk
include $(PACKAGES_DIR)/rocket-chip/mkfiles/rocket-chip.mk
include $(ROCKET_SOC_DIR)/mkfiles/rocket_soc.mk

ROCKET_SOC_SRC := \
  $(wildcard $(ROCKET_SOC_DIR)/src/rocket_soc/*.scala) \
  $(wildcard $(ROCKET_SOC_DIR)/src/rocket_soc/ic/*.scala) \
  $(wildcard $(ROCKET_SOC_DIR)/src/rocket_soc/ic/ve/*.scala) \
  $(wildcard $(ROCKET_SOC_DIR)/src/rocket_soc/ve/*.scala)

RULES := 1

ifeq (true,$(PHASE2))
build : $(ROCKET_SOC_JAR)

clean : 
	$(Q)rm -rf $(ROCKET_SOC_DIR)/build $(ROCKET_SOC_DIR)/lib

else
build : $(rocket_soc_deps)
	$(MAKE) -f $(ROCKET_SOC_SCRIPTS_DIR)/ivpm.mk PHASE2=true build

clean : $(rocket_soc_clean_deps)
	$(MAKE) -f $(ROCKET_SOC_SCRIPTS_DIR)/ivpm.mk PHASE2=true clean

endif

$(ROCKET_SOC_JAR) : $(ROCKET_SOC_SRC) $(ROCKET_SOC_DEPS)
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(DO_CHISELC)

release : build
	$(Q)rm -rf $(CHISELLIB_DIR)/build
	$(Q)mkdir -p $(CHISELLIB_DIR)/build/chisellib
	$(Q)cp -r \
          $(CHISELLIB_DIR)/lib \
          $(CHISELLIB_DIR)/etc \
          $(CHISELLIB_DIR)/build/chisellib
	$(Q)cd $(CHISELLIB_DIR)/build ; \
		tar czf chisellib-$(version).tar.gz chisellib
	$(Q)rm -rf $(CHISELLIB_DIR)/build/chisellib

include $(PACKAGES_DIR)/chiselscripts/mkfiles/chiselscripts.mk
include $(PACKAGES_DIR)/rocket-chip/mkfiles/rocket-chip.mk
include $(ROCKET_SOC_DIR)/mkfiles/rocket_soc.mk
-include $(PACKAGES_DIR)/packages.mk

