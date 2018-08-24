
ROCKET_SOC_SUBSYS_UVM_SCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(OC_WB_IP)/rtl/wb_uart/fw/wb_uart_fw.mk
include $(ROCKET_SOC)/ve/rocket_soc_uvm/sim/scripts/rocket_soc_uvm.mk
include $(PACKAGES_DIR)/googletest_uvm/src/googletest_uvm.mk
include $(ROCKET_SOC)/sw/uex/rocket_soc_uex.mk
include $(ROCKET_SOC)/sw/devs/rocket_soc_devs.mk

include $(OC_WB_IP)/rtl/wb_periph_subsys/fw/wb_periph_subsys_fw.mk
include $(OC_WB_IP)/rtl/wb_uart/fw/wb_uart_fw.mk
include $(OC_WB_IP)/rtl/wb_dma/fw/wb_dma_fw.mk
include $(OC_WB_IP)/rtl/simple_pic/fw/wb_simple_pic_fw.mk

include $(ROCKET_SOC)/ve/rocket_soc_subsys_uvm/tests/unit/unit.mk
include $(PACKAGES_DIR)/uex/uex.mk
include $(PACKAGES_DIR)/uex/impl/sv/uex_env_sv.mk
include $(VMON)/src/monitor/vmon_monitor.mk

include $(SV_BFMS)/uart/vmon/csrc/vmon_uart_agent.mk


DPI_OBJS_LIBS += unit_test.o libuex.o libvmon_monitor.o 
DPI_OBJS_LIBS += libwb_uart_fw.o libwb_dma_fw.o librocket_soc_uex.o
DPI_OBJS_LIBS += libwb_simple_pic_fw.o librocket_soc_devs.o libvmon_uart_agent.o

