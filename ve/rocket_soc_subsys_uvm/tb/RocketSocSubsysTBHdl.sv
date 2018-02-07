/****************************************************************************
 * RocketSocSubsysTBHdl.sv
 ****************************************************************************/

/**
 * Module: RocketSocSubsysTBHdl
 * 
 * TODO: Add module documentation
 */
module RocketSocSubsysTBHdl;
	reg      clock_r = 0;
	reg      reset_r = 1;
	reg[7:0] reset_cnt_r = 0;
	parameter reset_cnt = 100;
	parameter clk_period = 10;
	
	assign clock = clock_r;
	assign reset = reset_r;

	// tbx clkgen inactive_negedge
	initial begin
		clock_r = 0;
		forever 
			#10ns clock_r = ~clock_r;
	end	
	
	always @(posedge clock) begin
		if (reset_cnt_r == reset_cnt) begin
			reset_r <= 0;
		end else begin
			reset_r <= 1;
			reset_cnt_r <= reset_cnt_r + 1;
		end
	end
	
	RocketSocTB tb(.clock(clock), .reset(reset));	

	bind Rocket RocketBFM bfm(.*);
//	bind Rocket :tb.u_dut.u_core.ExampleRocketSystem.tile.core
//		RocketBFM core0(.*);
//	bind Rocket :tb.u_dut.u_core.ExampleRocketSystem.tile_1.core
//		RocketBFM core1(.*);
//	bind Rocket :tb.u_dut.u_core.ExampleRocketSystem.tile_2.core
//		RocketBFM core2(.*);
//	bind Rocket :tb.u_dut.u_core.ExampleRocketSystem.tile_3.core
//		RocketBFM core3(.*);
	
endmodule


