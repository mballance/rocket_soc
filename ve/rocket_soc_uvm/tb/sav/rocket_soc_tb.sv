/****************************************************************************
 * rocket_soc_tb.sv
 ****************************************************************************/

/**
 * Module: rocket_soc_tb
 * 
 * TODO: Add module documentation
 */
`include "uvm_macros.svh"
module rocket_soc_tb;
	import uvm_pkg::*;
	import rocket_soc_tests_pkg::*;
	
	reg clk = 0;
	reg reset = 1;
	reg[15:0] reset_cnt = 0;
	reg[15:0] reset_point = 1000;
	
	initial begin
		forever begin
			#10ns;
			clk <= ~clk;
		end
	end
	
	always @(posedge clk) begin
		if (reset_cnt == reset_point) begin
			reset <= 0;
		end else begin
			reset_cnt <= reset_cnt + 1;
		end
	end

	RocketSocTB u_tb(
			.clock(clk),
			.reset(reset)
		);
//	rocket_soc u_dut(clk);

	
	initial begin
		run_test();
	end

endmodule

