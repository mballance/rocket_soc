
UNIT_TEST_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))
	UNIT_TEST_SRC = $(notdir $(wildcard $(UNIT_TEST_DIR)/*.cpp))
	
	SRC_DIRS += $(UNIT_TEST_DIR)

else # Rules

unit_test.o : $(UNIT_TEST_SRC:.cpp=.o)
	$(Q)$(LD) -r -o $@ $^

endif
