
ROCKET_SOC_SW_UEX_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

SRC_DIRS += $(ROCKET_SOC_SW_UEX_DIR)

ROCKET_SOC_SW_UEX = $(notdir $(wildcard $(ROCKET_SOC_SW_UEX_DIR)/*.c))

else # Rules

librocket_soc_uex.o : $(ROCKET_SOC_SW_UEX:.c=.o)
	$(Q)$(LD) -r -o $@ $(ROCKET_SOC_SW_UEX:.c=.o)

endif

