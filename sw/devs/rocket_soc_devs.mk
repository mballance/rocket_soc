
ROCKET_SOC_DEVS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

ROCKET_SOC_DEVS_SRC = $(notdir $(wildcard $(ROCKET_SOC_DEVS_DIR)/*.c))

SRC_DIRS += $(ROCKET_SOC_DEVS_DIR)

else # Rules

librocket_soc_devs.o : $(ROCKET_SOC_DEVS_SRC:.c=.o)
	$(Q)$(LD) -r -o $@ $(ROCKET_SOC_DEVS_SRC:.c=.o)

endif

