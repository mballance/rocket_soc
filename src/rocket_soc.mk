
ROCKET_SOC_SRC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ROCKET_CHIP_DIR := $(ROCKET_SOC_SRC_DIR)/../chisel/rocket-chip

ifneq (1,$(RULES))

ROCKET_CHIP_LIB := rocket_chip.jar
HARDFLOAT_LIB := hardfloat.jar
HARDFLOAT_SRC := $(shell find $(ROCKET_CHIP_DIR)/hardfloat/src -name '*.scala')
ROCKET_CHIP_SRC := $(shell find $(ROCKET_CHIP_DIR)/src -name '*.scala')
ROCKET_SOC_LIB := rocket_soc.jar
ROCKET_SOC_SRC := $(wildcard $(ROCKET_SOC_SRC_DIR)/rocket_soc/*.scala)

ROCKET_SOC_LIBS = $(ROCKET_CHIP_LIB) $(ROCKET_SOC_LIB) $(HARDFLOAT_LIB) $(CHISELLIB)

else # Rules
	
$(ROCKET_SOC_LIB) : $(ROCKET_CHIP_LIB) $(CHISELLIB) $(ROCKET_SOC_SRC)
	$(Q)$(CHISELC) -o $@ $(ROCKET_SOC_SRC) -L$(ROCKET_CHIP_LIB) -L$(CHISELLIB)

$(HARDFLOAT_LIB) : $(HARDFLOAT_SRC)	
	$(Q)$(CHISELC) -o $@ $(HARDFLOAT_SRC) -L$(HARDFLOAT_LIB)
	
$(ROCKET_CHIP_LIB) : $(ROCKET_CHIP_SRC) $(HARDFLOAT_LIB)
	$(Q)$(CHISELC) -o $@ $(ROCKET_CHIP_SRC) -L$(HARDFLOAT_LIB)

ExampleRocketTop.v : $(ROCKET_SOC_LIBS) 
	$(Q)$(CHISELG) $(foreach l,$(ROCKET_SOC_LIBS),-L$(l)) \
		rocket_soc.RocketCoreGen +BOOTROM_DIR=`pwd`

endif
