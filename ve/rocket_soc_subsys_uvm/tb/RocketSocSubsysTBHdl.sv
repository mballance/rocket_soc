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
	
	wire [31:0]     ADR = tb.u_dut.u_wb_ic.io_m_1_req_ADR;
	wire [31:0]     DAT_W = tb.u_dut.u_wb_ic.io_m_1_req_DAT_W;
	wire            CYC = tb.u_dut.u_wb_ic.io_m_1_req_CYC;
	wire            ERR = 0; // tb.u_dut.periph_ic.io_m_0_req_ERR;
	wire [3:0]      SEL = tb.u_dut.u_wb_ic.io_m_1_req_SEL;
	wire            ACK = tb.u_dut.u_wb_ic.io_m_1_rsp_ACK;
	wire            WE = tb.u_dut.u_wb_ic.io_m_1_req_WE;
	wire            STB = tb.u_dut.u_wb_ic.io_m_1_req_STB;

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


