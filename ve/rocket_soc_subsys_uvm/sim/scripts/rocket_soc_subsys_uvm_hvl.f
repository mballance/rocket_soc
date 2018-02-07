
+incdir+${ROCKET_SOC}/ve/rocket_soc_subsys_uvm/tb
+incdir+${ROCKET_SOC}/ve/rocket_soc_subsys_uvm/tests

-f ${SV_BFMS}/api/sv/sv.f
-f ${UEX}/impl/sv/uex_sv.f

+incdir+${SV_BFMS}/hella_cache_master/uvm
${SV_BFMS}/hella_cache_master/hella_cache_master_api_pkg.sv
${SV_BFMS}/hella_cache_master/uvm/hella_cache_master_agent_pkg.sv

${ROCKET_SOC}/subprojects/googletest_uvm/src/googletest_uvm_pkg.sv

-f ${ROCKET_SOC}/ve/rocket_soc_uvm/sim/scripts/rocket_soc_uvm_hvl.f

${ROCKET_SOC}/ve/rocket_soc_subsys_uvm/tb/rocket_soc_subsys_env_pkg.sv

${ROCKET_SOC}/ve/rocket_soc_subsys_uvm/tests/rocket_soc_subsys_tests_pkg.sv


// ${ROCKET_SOC}/ve/rocket_soc_subsys_uvm/tb/Rocket.sv
// ${ROCKET_SOC}/ve/rocket_soc_subsys_uvm/tb/RocketBFM.sv
// ${ROCKET_SOC}/ve/rocket_soc_subsys_uvm/tb/RocketBFMBinds.sv
// ${ROCKET_SOC}/ve/rocket_soc_subsys_uvm/tb/rocket_soc_subsys_tb.sv

