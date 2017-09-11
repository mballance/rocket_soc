/**
 * Filelist: sve.F
 */

+incdir+${UVM_HOME}/src
${UVM_HOME}/src/uvm_pkg.sv

-f ${MEMORY_PRIMITIVES}/rtl/rtl_w.f
-f ${MEMORY_PRIMITIVES}/rtl/sim/sim.f
-f ${AMBA_SYS_IP}/sve.f

./output/ExampleRocketTop.v

-F ./ve/rocket_soc_uvm/sve.F
