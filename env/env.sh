
if test "x$SIMSCRIPTS_PROJECT_ENV" = "xtrue"; then
	export ROCKET_SOC=`dirname $SIMSCRIPTS_DIR`
fi

uname_o=`uname -o`

if test "$uname_o" = "Cygwin"; then
	ROCKET_SOC=`cygpath -w $ROCKET_SOC | sed -e 's%\\\\%/%g'`
fi

export STD_PROTOCOL_IF=$ROCKET_SOC/subprojects/std_protocol_if
export AMBA_SYS_IP=$ROCKET_SOC/subprojects/amba_sys_ip
export WB_SYS_IP=$ROCKET_SOC/subprojects/wb_sys_ip
export OC_WB_IP=$ROCKET_SOC/subprojects/oc_wb_ip
export MEMORY_PRIMITIVES=$ROCKET_SOC/subprojects/memory_primitives
export CHISELLIB=$ROCKET_SOC/subprojects/chisellib
export SV_BFMS=$ROCKET_SOC/ve/sv_bfms
export UEX=$ROCKET_SOC/subprojects/uex
export BMK=$ROCKET_SOC/subprojects/bmk
export VMON=$ROCKET_SOC/subprojects/vmon

#export SV_BFMS=$WB_SYS_IP/ve/sv_bfms
#export MEMORY_PRIMITIVES=$WB_SYS_IP/memory_primitives

