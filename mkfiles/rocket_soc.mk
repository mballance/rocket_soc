
ROCKET_SOC_MKFILES_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ROCKET_SOC_DIR := $(abspath $(ROCKET_SOC_MKFILES_DIR)/..)

ROCKET_SOC := $(ROCKET_SOC_DIR)

ROCKET_SOC_NCORES ?= 4
export ROCKET_SOC

ifneq (1,$(RULES))

ROCKET_SOC_JAR := $(ROCKET_SOC_DIR)/lib/rocket_soc.jar

ROCKET_SOC_DEPS = $(ROCKET_CHIP_JARS) $(CHISELLIB_JARS) \
	$(OC_WB_IP_JARS) $(AMBA_SYS_IP_JARS) $(WB_SYS_IP_JARS) \
    $(VMON_JARS) $(STD_PROTOCOL_IF_JARS) $(SV_BFMS_JARS) 
ROCKET_SOC_JARS = $(ROCKET_SOC_JAR) $(ROCKET_SOC_DEPS)
ROCKET_SOC_TB_JARS = $(ROCKET_SOC_JARS) $(SV_BFMS_JARS)

ROCKET_SOC_GEN_SRC := RocketSoc.v
ROCKET_SOC_GEN_TB_SRC := RocketSocTB/RocketSocTB.f

#ROCKET_SOC_SRC = \
#  $(wildcard $(ROCKET_SOC_DIR)/src/rocket_soc/*.scala) \
#  $(wildcard $(ROCKET_SOC_DIR)/src/rocket_soc/ic/*.scala) \
#  $(wildcard $(ROCKET_SOC_DIR)/src/rocket_soc/ic/ve/*.scala) \
#  $(wildcard $(ROCKET_SOC_DIR)/src/rocket_soc/ve/*.scala)

else # Rules
	
$(ROCKET_SOC_GEN_SRC) : $(ROCKET_SOC_JARS) 
	$(Q)$(DO_CHISELG) rocket_soc.RocketSocGen +BOOTROM_DIR=$(BUILD_DIR_A)
#	$(Q)$(CHISELG) $(foreach l,$(ROCKET_SOC_LIBS),-L$(l)) \
#		rocket_soc.RocketSocGen +BOOTROM_DIR=$(BUILD_DIR_A)
		
$(ROCKET_SOC_GEN_TB_SRC) : $(ROCKET_SOC_JARS)
	$(Q)export PATH="$(PACKAGES_DIR)/ivpm-dtc/linux_x86_64:$(PATH)" ; $(DO_CHISELG) \
		-outdir RocketSocTB \
		rocket_soc.ve.RocketSocTBGen \
		+BOOTROM_DIR=$(BUILD_DIR_A)/esw \
		+NCORES=$(ROCKET_SOC_NCORES)

endif
