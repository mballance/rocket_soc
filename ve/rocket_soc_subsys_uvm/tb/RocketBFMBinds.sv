/****************************************************************************
 * RocketBFMBinds.sv
 ****************************************************************************/

/**
 * Module: RocketBFMBinds
 * 
 * TODO: Add module documentation
 */
module RocketBFMBinds;
	
	bind Rocket :RocketSocTB.u_dut.u_core.RocketSocCoreanon1.tile.rocket.core
		RocketBFM #("*m_core0*") core0(.*);
	bind Rocket :RocketSocTB.u_dut.u_core.RocketSocCoreanon1.tile_1.rocket.core
		RocketBFM #("*m_core1*") core1(.*);
	bind Rocket :RocketSocTB.u_dut.u_core.RocketSocCoreanon1.tile_2.rocket.core
		RocketBFM #("*m_core2*") core2(.*);
	bind Rocket :RocketSocTB.u_dut.u_core.RocketSocCoreanon1.tile_3.rocket.core
		RocketBFM #("*m_core3*") core3(.*);

endmodule


