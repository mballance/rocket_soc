
RULES := 1

all : bootrom.build

bootrom.build : 
#	$(Q)mkdir -p bootrom
	cp -r $(ROCKET_SOC)/output/bootrom .
#	$(Q)$(MAKE) -C bootrom #-f $(ROCKET_SOC_SRC_DIR)/bootrom/Makefile
	$(MAKE) -C bootrom
	$(Q)touch $@
	