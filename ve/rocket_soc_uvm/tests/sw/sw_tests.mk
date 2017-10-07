
SW_TESTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

SRC_DIRS += $(SW_TESTS_DIR)

else # Rules

endif