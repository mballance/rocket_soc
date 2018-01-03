
include $(SIMSCRIPTS_DIR)/mkfiles/plusargs.mk

TIMEOUT := 100us

MK_INCLUDES += $(ROCKET_SOC)/ve/rocket_soc_uvm/sim/scripts/rocket_soc_uvm.mk
MK_INCLUDES += $(ROCKET_SOC)/subprojects/googletest_uvm/src/googletest_uvm.mk
MK_INCLUDES += $(SIM_DIR)/../tests/unit/unit.mk

DPI_OBJS_LIBS += unit_test.o

TB=rocket_soc_subsys_tb
TB_MODULES=RocketSocTB RocketSocTBHvl RocketBFMBinds rocket_soc_subsys_tests_pkg

include $(SIMSCRIPTS_DIR)/mkfiles/common_sim.mk


	
