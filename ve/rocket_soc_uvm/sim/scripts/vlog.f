
+incdir+${SIM_DIR_A}/../tb
+incdir+${SIM_DIR_A}/../tests
+define+PRINTF_COND=0
+define+RANDOMIZE_REG_INIT
// +define+RANDOMIZE_MEM_INIT

-f ${STD_PROTOCOL_IF}/rtl/axi4/axi4.f

${SIM_DIR_A}/../tb/rocket_soc_env_pkg.sv

${SIM_DIR_A}/../tests/rocket_soc_tests_pkg.sv

${SIM_DIR_A}/../tb/rocket_soc_tb.sv

${ROCKET_SOC}/chisel/rocket-chip/vsrc/plusarg_reader.v
${ROCKET_SOC}/chisel/rocket-chip/vsrc/AsyncResetReg.v
${ROCKET_SOC}/chisel/rocket-chip/vsrc/ClockDivider2.v
${ROCKET_SOC}/chisel/rocket-chip/vsrc/ClockDivider3.v
${ROCKET_SOC}/output/ExampleRocketTop.v

${AMBA_SYS_IP}/rtl/axi4/axi4_sram/axi4_sram.sv
${AMBA_SYS_IP}/rtl/axi4/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv
-f ${STD_PROTOCOL_IF}/rtl/memory/memory.f
-f ${MEMORY_PRIMITIVES}/rtl/sim/sim.f
-f ${MEMORY_PRIMITIVES}/rtl/rtl_w.f



