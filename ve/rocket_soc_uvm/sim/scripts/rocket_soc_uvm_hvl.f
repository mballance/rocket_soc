

+incdir+${ROCKET_SOC}/ve/rocket_soc_uvm/tb
+incdir+${ROCKET_SOC}/ve/rocket_soc_uvm/tests

-f ${SV_BFMS}/uart/uvm/uvm.f

-f ${VMON}/src/client/sv/vmon_sv_client_hvl.f
-f ${VMON}/src/client/sv/vmon_sv_client_uvm.f
${VMON}/src/client/sv/wb_vmon_monitor.sv

${ROCKET_SOC}/ve/rocket_soc_uvm/tb/RocketSocTBEnvBasePkg.sv
${ROCKET_SOC}/ve/rocket_soc_uvm/tb/rocket_soc_env_pkg.sv
${ROCKET_SOC}/ve/rocket_soc_uvm/tests/rocket_soc_tests_pkg.sv
${ROCKET_SOC}/ve/rocket_soc_uvm/tb/RocketSocTBHvl.sv

