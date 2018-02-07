/****************************************************************************
 * RocketSocHvlTB.sv
 ****************************************************************************/
//`timescale 1ns/1ns

module RocketSocTBClkGen(output clock, output reset);
	reg clock_r = 0;
	reg reset_r = 1;
	parameter reset_cnt = 100;
	
	assign clock = clock_r;
	assign reset = reset_r;
	
	initial begin
		repeat (reset_cnt*2) begin
			#10ns;
			clock_r <= ~clock_r;
		end
		
		reset_r <= 0;
		
		forever begin
			#10ns;
			clock_r <= ~clock_r;
		end
	end	
endmodule

/**
 * Module: RocketSocTBHdl
 * 
 * TODO: Add module documentation
 */
module RocketSocTBHdl;
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
	
//	import uvm_pkg::uvm_config_db;

//	initial begin
//		// Cannot pass config
//		automatic uart_serial_config uart0_cfg = uart_serial_config::type_id::create("uart0_cfg");
//
//		// Must pass virtual-interface handle
//		uart0_cfg.vif = RocketSocTB.u_uart_bfm.bfm.u_core;
//		uvm_config_db #(uart_serial_config)::set(uvm_top, "*uart0*",
//				uart_serial_config::report_id, uart0_cfg);
//		uart_config_db #(virtual uart_serial_bfm_core)::set(null,
//				"*uart0*", uart_serial_bfm.BFM_ID,
//				RocketSocTB.u_uart_bfm.bfm.u_core);
//		
//		run_test();
//	end

	// Connect the clock generator to the HDL TB
//	bind RocketSocTB RocketSocTBClkGen RocketSocTbClkGen_inst(.clock(clock), .reset(reset));

endmodule


