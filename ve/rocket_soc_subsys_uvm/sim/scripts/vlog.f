
+define+PRINTF_COND=0
+define+RANDOMIZE_REG_INIT

+incdir+${ROCKET_SOC}/ve/rocket_soc_subsys_uvm/tb
+incdir+${ROCKET_SOC}/ve/rocket_soc_subsys_uvm/tests


-f ${ROCKET_SOC}/ve/rocket_soc_uvm/sim/scripts/rocket_soc_uvm.f

${ROCKET_SOC}/ve/rocket_soc_subsys_uvm/tb/rocket_soc_subsys_env_pkg.sv

${ROCKET_SOC}/ve/rocket_soc_subsys_uvm/tests/rocket_soc_subsys_tests_pkg.sv

${ROCKET_SOC}/ve/rocket_soc_subsys_uvm/tb/SyncRocketTile.sv
${ROCKET_SOC}/ve/rocket_soc_subsys_uvm/tb/rocket_soc_subsys_tb.sv

