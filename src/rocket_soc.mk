
ROCKET_SOC_SRC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ROCKET_CHIP_DIR := $(ROCKET_SOC_SRC_DIR)/../chisel/rocket-chip

ifneq (1,$(RULES))

ROCKET_CHIP_LIB := rocket_chip.jar
ROCKET_CHIP_SRC := $(shell find $(ROCKET_CHIP_DIR)/src $(ROCKET_CHIP_DIR)/hardfloat/src -name '*.scala')
ROCKET_SOC_LIB := rocket_soc.jar
ROCKET_SOC_SRC := $(wildcard $(ROCKET_SOC_SRC_DIR)/rocket_soc/*.scala)

ROCKET_SOC_LIBS = $(ROCKET_CHIP_LIB) $(ROCKET_SOC_LIB) $(CHISELLIB)

else # Rules

bootrom : 
	cp -r $(ROCKET_SOC_SRC_DIR)/../chisel/rocket-chip/bootrom .
	
$(ROCKET_SOC_LIB) : $(ROCKET_CHIP_LIB) $(CHISELLIB) $(ROCKET_SOC_SRC)
	$(Q)$(CHISELC) -o $@ $(ROCKET_SOC_SRC) -L$(ROCKET_CHIP_LIB) -L$(CHISELLIB)
	
$(ROCKET_CHIP_LIB) : $(ROCKET_CHIP_SRC)
	$(Q)$(CHISELC) -o $@ $(ROCKET_CHIP_SRC)

$(ROCKET_CHIP_LIB) : 
ExampleRocketTop.v : $(ROCKET_SOC_LIBS) bootrom
	$(Q)$(CHISELG) $(foreach l,$(ROCKET_SOC_LIBS),-L$(l)) \
		rocket_soc.RocketCoreGen +BOOTROM_DIR=`pwd`

endif
