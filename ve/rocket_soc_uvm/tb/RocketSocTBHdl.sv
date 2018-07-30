/****************************************************************************
 * RocketSocHvlTB.sv
 ****************************************************************************/
//`timescale 1ns/1ns

/**
 * Module: RocketSocTBHdl
 * 
 * TODO: Add module documentation
 */
module RocketSocTBHdl(input clock);
	reg      reset_r = 1;
	reg[7:0] reset_cnt_r = 0;
	parameter reset_cnt = 100;
	wire	 reset = reset_r;
`ifdef HAVE_HDL_CLOCK_GENERATOR
	reg      clock_r = 0;
	parameter clk_period = 10;
	
	assign clock = clock_r;

	// tbx clkgen inactive_negedge
	initial begin
		clock_r = 0;
		forever 
			#10ns clock_r = ~clock_r;
	end	
`endif /* HAVE_HDL_CLOCK_GENERATOR */
	
	always @(posedge clock) begin
		if (reset_cnt_r == reset_cnt) begin
			reset_r <= 0;
		end else begin
			reset_r <= 1;
			reset_cnt_r <= reset_cnt_r + 1;
		end
	end
	
	RocketSocTB tb(.clock(clock), .reset(reset));
	
	wire [31:0]		ADR = tb.u_dut.periph_ic.io_m_0_req_ADR;
	wire [31:0]		DAT_W = tb.u_dut.periph_ic.io_m_0_req_DAT_W;
	wire 			CYC = tb.u_dut.periph_ic.io_m_0_req_CYC;
	wire 			ERR = 0; // tb.u_dut.periph_ic.io_m_0_req_ERR;
	wire [3:0]		SEL = tb.u_dut.periph_ic.io_m_0_req_SEL;
	wire 			ACK = tb.u_dut.periph_ic.io_m_0_rsp_ACK;
	wire 			WE = tb.u_dut.periph_ic.io_m_0_req_WE;
	wire 			STB = tb.u_dut.periph_ic.io_m_0_req_STB;

	wb_vmon_monitor #(
			.WB_ADDR_WIDTH(32),
			.WB_DATA_WIDTH(32),
			.ADDRESS('h6000_1000)) u_vmon_monitor(
			.clk_i(clock),
			.rst_i(reset),
			.ADR(ADR),
			.DAT_W(DAT_W),
			.CYC(CYC),
			.ERR(ERR),
			.SEL(SEL),
			.ACK(ACK),
			.STB(STB),
			.WE(WE)
		);
	
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


