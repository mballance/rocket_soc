
UNIT_TEST_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))
	UNIT_TEST_SRC = $(notdir $(wildcard $(UNIT_TEST_DIR)/*.cpp))
	UNIT_TEST_SRC_C = $(notdir $(wildcard $(UNIT_TEST_DIR)/*.c))
	
	SRC_DIRS += $(UNIT_TEST_DIR)

else # Rules

unit_test.o : $(UNIT_TEST_SRC:.cpp=.o) $(UNIT_TEST_SRC_C:.c=.o)
	$(Q)$(LD) -r -o $@ $^

endif
