
ROCKET_SOC_SUBSYS_UVM_SCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(PACKAGES_DIR)/packages.mk
include $(ROCKET_SOC)/ve/rocket_soc_uvm/sim/scripts/rocket_soc_uvm.mk
include $(PACKAGES_DIR)/googletest_uvm/src/googletest_uvm.mk
include $(ROCKET_SOC)/ve/rocket_soc_subsys_uvm/tests/unit/unit.mk
include $(PACKAGES_DIR)/uex/uex.mk
include $(PACKAGES_DIR)/uex/impl/sv/uex_env_sv.mk
include $(VMON)/src/monitor/vmon_monitor.mk


DPI_OBJS_LIBS += unit_test.o libuex.o libvmon_monitor.o
