
ROCKET_SOC_SUBSYS_UVM_SCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(ROCKET_SOC)/ve/rocket_soc_uvm/sim/scripts/rocket_soc_uvm.mk
include $(ROCKET_SOC)/subprojects/googletest_uvm/src/googletest_uvm.mk
include $(ROCKET_SOC)/ve/rocket_soc_subsys_uvm/tests/unit/unit.mk
include $(UEX)/uex.mk
include $(UEX)/impl/sv/uex_env_sv.mk

DPI_OBJS_LIBS += unit_test.o libuex.o
