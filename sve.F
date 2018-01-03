/**
 * Filelist: sve.F
 */

+incdir+${UVM_HOME}/src
${UVM_HOME}/src/uvm_pkg.sv

-f ${MEMORY_PRIMITIVES}/rtl/rtl_w.f
-f ${MEMORY_PRIMITIVES}/rtl/sim/sim.f
-F ${STD_PROTOCOL_IF}/sve.F
-f ${AMBA_SYS_IP}/sve.f
-F ${ROCKET_SOC}/ve/ve_sve.F
-f ${ROCKET_SOC}/rtl/rocket_soc_rtl.f
-F ${ROCKET_SOC}/subprojects/subprojects_sve.F
-f ${RUNDIR}/rocket_soc_subsys_uvm/qs/RocketSocTB/RocketSocTB.f


// ${RUNDIR}/rocket_soc_uvm/qs/
