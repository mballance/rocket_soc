
ROCKET_SOC_SUBSYS_UVM_SCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(ROCKET_SOC)/ve/rocket_soc_uvm/sim/scripts/rocket_soc_uvm.mk
include $(ROCKET_SOC)/subprojects/googletest_uvm/src/googletest_uvm.mk
include $(ROCKET_SOC)/ve/rocket_soc_subsys_uvm/tests/unit/unit.mk

DPI_OBJS_LIBS += unit_test.o
