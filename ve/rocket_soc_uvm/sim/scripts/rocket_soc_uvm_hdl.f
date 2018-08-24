

${BUILD_DIR_A}/plusarg_reader.v
${BUILD_DIR_A}/AsyncResetReg.v
// ${ROCKET_SOC}/subprojects/rocket-chip/vsrc/ClockDivider2.v
// ${ROCKET_SOC}/subprojects/rocket-chip/vsrc/ClockDivider3.v

-f ${VMON}/src/client/sv/vmon_sv_client_hdl.f

-f ${BUILD_DIR_A}/RocketSocTB/RocketSocTB.f

-f ${WB_SYS_IP}/rtl/adapters/adapters.f
${WB_SYS_IP}/rtl/interconnects/wb_interconnect_2x1.sv
${WB_SYS_IP}/rtl/interconnects/wb_interconnect_1x3.sv
${WB_SYS_IP}/rtl/interconnects/wb_interconnect_NxN.sv

-f ${OC_WB_IP}/rtl/wb_uart/rtl.f
-f ${OC_WB_IP}/rtl/wb_dma/rtl/verilog/rtl.f
-f ${OC_WB_IP}/rtl/wb_periph_subsys/wb_periph_subsys.f
-f ${OC_WB_IP}/rtl/simple_pic/rtl/rtl.f

${AMBA_SYS_IP}/rtl/axi4/axi4_sram/axi4_sram.sv
${AMBA_SYS_IP}/rtl/axi4/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv

-f ${STD_PROTOCOL_IF}/rtl/memory/memory.f
-f ${STD_PROTOCOL_IF}/rtl/wb/wb.f
-f ${STD_PROTOCOL_IF}/rtl/axi4/axi4.f
-f ${MEMORY_PRIMITIVES}/rtl/sim/sim.f
-f ${MEMORY_PRIMITIVES}/rtl/rtl_w.f

-f ${SV_BFMS}/uart/sv.f

${ROCKET_SOC}/ve/rocket_soc_uvm/tb/RocketSocTBHdl.sv


