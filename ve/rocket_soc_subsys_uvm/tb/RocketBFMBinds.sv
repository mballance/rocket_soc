/****************************************************************************
 * RocketBFMBinds.sv
 ****************************************************************************/

/**
 * Module: RocketBFMBinds
 * 
 * TODO: Add module documentation
 */
module RocketBFMBinds;

	bind Rocket :RocketSocTB.u_dut.u_core.ExampleRocketSystem.tile.core
		RocketBFM #("*m_core0*") core0(.*);
	bind Rocket :RocketSocTB.u_dut.u_core.ExampleRocketSystem.tile_1.core
		RocketBFM #("*m_core1*") core1(.*);
	bind Rocket :RocketSocTB.u_dut.u_core.ExampleRocketSystem.tile_2.core
		RocketBFM #("*m_core2*") core2(.*);
	bind Rocket :RocketSocTB.u_dut.u_core.ExampleRocketSystem.tile_3.core
		RocketBFM #("*m_core3*") core3(.*);

endmodule


