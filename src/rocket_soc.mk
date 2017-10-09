
ROCKET_SOC_SRC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ROCKET_CHIP_DIR := $(ROCKET_SOC_SRC_DIR)/../subprojects/rocket-chip

ifneq (1,$(RULES))

ROCKET_CHIP_LIB := rocket_chip.jar
HARDFLOAT_LIB := hardfloat.jar
HARDFLOAT_SRC := $(shell find $(ROCKET_CHIP_DIR)/hardfloat/src -name '*.scala')
ROCKET_CHIP_SRC := \
	$(shell find $(ROCKET_CHIP_DIR)/src -name '*.scala') \
	$(wildcard $(ROCKET_CHIP_DIR)/macros/src/main/scala/*.scala)
	
ROCKET_SOC_LIB := rocket_soc.jar
ROCKET_SOC_SRC := \
	$(wildcard $(ROCKET_SOC_SRC_DIR)/rocket_soc/*.scala) \
	$(wildcard $(ROCKET_SOC_SRC_DIR)/rocket_soc/ve/*.scala)

ROCKET_CHIP_DEPS = $(HARDFLOAT_LIB) 
ROCKET_SOC_DEPS = $(ROCKET_CHIP_DEPS) $(ROCKET_CHIP_LIB) $(CHISELLIB_JAR) \
	$(OC_WB_IP_LIB) $(AMBA_SYS_IP_LIB) $(WB_SYS_IP_LIB) $(STD_PROTOCOL_IF_LIB) \
	$(SV_BFMS_JAR) 
ROCKET_SOC_LIBS = $(ROCKET_SOC_LIB) $(ROCKET_SOC_DEPS)
ROCKET_SOC_TB_LIBS = $(ROCKET_SOC_LIBS) $(SV_BFMS_JAR)

ROCKET_SOC_GEN_SRC := RocketSoc.v
ROCKET_SOC_GEN_TB_SRC := RocketSocTB.v

else # Rules
	
$(HARDFLOAT_LIB) : $(HARDFLOAT_SRC)	
	$(Q)$(CHISELC) -o $@ $(HARDFLOAT_SRC) -L$(HARDFLOAT_LIB)
	
$(ROCKET_CHIP_LIB) : $(ROCKET_CHIP_SRC) $(ROCKET_CHIP_DEPS) 
	$(Q)$(DO_CHISELC)
#	$(Q)$(CHISELC) -o $@ $(ROCKET_CHIP_SRC) $(foreach l,$(ROCKET_CHIP_DEPS),-L$(l))
	
$(ROCKET_SOC_LIB) : $(ROCKET_SOC_DEPS) $(ROCKET_SOC_SRC)
	$(Q)$(DO_CHISELC)
#	$(Q)$(CHISELC) -o $@ $(ROCKET_SOC_SRC) $(foreach l,$(ROCKET_SOC_DEPS),-L$(l))

$(ROCKET_SOC_GEN_SRC) : $(ROCKET_SOC_LIBS) 
	$(Q)$(DO_CHISELG) rocket_soc.RocketSocGen +BOOTROM_DIR=$(BUILD_DIR_A)
#	$(Q)$(CHISELG) $(foreach l,$(ROCKET_SOC_LIBS),-L$(l)) \
#		rocket_soc.RocketSocGen +BOOTROM_DIR=$(BUILD_DIR_A)
		
$(ROCKET_SOC_GEN_TB_SRC) : $(ROCKET_SOC_TB_LIBS) $(DTC_BUILD)
	$(Q)export PATH=./dtc:$(PATH) ; $(DO_CHISELG) rocket_soc.ve.RocketSocTBGen +BOOTROM_DIR=$(BUILD_DIR_A)
#	$(Q)$(CHISELG) $(foreach l,$(ROCKET_SOC_TB_LIBS),-L$(l)) \
#		rocket_soc.ve.RocketSocTBGen +BOOTROM_DIR=$(BUILD_DIR_A)

endif
