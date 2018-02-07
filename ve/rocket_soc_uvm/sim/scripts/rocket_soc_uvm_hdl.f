

-f ${STD_PROTOCOL_IF}/rtl/axi4/axi4.f

${ROCKET_SOC}/subprojects/rocket-chip/vsrc/plusarg_reader.v
${ROCKET_SOC}/subprojects/rocket-chip/vsrc/AsyncResetReg.v
${ROCKET_SOC}/subprojects/rocket-chip/vsrc/ClockDivider2.v
${ROCKET_SOC}/subprojects/rocket-chip/vsrc/ClockDivider3.v

-f ${BUILD_DIR_A}/RocketSocTB/RocketSocTB.f

-f ${OC_WB_IP}/rtl/wb_uart/rtl.f

${AMBA_SYS_IP}/rtl/axi4/axi4_sram/axi4_sram.sv
${AMBA_SYS_IP}/rtl/axi4/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv

-f ${STD_PROTOCOL_IF}/rtl/memory/memory.f
-f ${STD_PROTOCOL_IF}/rtl/wb/wb.f
-f ${STD_PROTOCOL_IF}/rtl/axi4/axi4.f
-f ${MEMORY_PRIMITIVES}/rtl/sim/sim.f
-f ${MEMORY_PRIMITIVES}/rtl/rtl_w.f

-f ${SV_BFMS}/uart/sv.f

${ROCKET_SOC}/ve/rocket_soc_uvm/tb/RocketSocTBHdl.sv


