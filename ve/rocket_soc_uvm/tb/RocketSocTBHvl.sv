/****************************************************************************
 * RocketSocHvlTB.sv
 ****************************************************************************/
`include "uvm_macros.svh"

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
 * Module: RocketSocHvlTB
 * 
 * TODO: Add module documentation
 */
module RocketSocTBHvl;
	import uvm_pkg::*;
	import uart_serial_agent_pkg::*;

	initial begin
		automatic uart_serial_config uart0_cfg = uart_serial_config::type_id::create("uart0_cfg");

		uart0_cfg.vif = RocketSocTB.u_uart_bfm.bfm.u_core;
		uvm_config_db #(uart_serial_config)::set(uvm_top, "*uart0*",
				uart_serial_config::report_id, uart0_cfg);
		
		run_test();
	end

	// Connect the clock generator to the HDL TB
	bind RocketSocTB RocketSocTBClkGen RocketSocTbClkGen_inst(.clock(clock), .reset(reset));

endmodule


