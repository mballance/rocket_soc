/****************************************************************************
 * SyncRocketTile.sv
 ****************************************************************************/
 
/**
 * Module: SyncRocketTile
 * 
 * TODO: Add module documentation
 */
module SyncRocketTile(
		input         clock,
		input         reset,
		input         io_master_0_a_ready,
		output        io_master_0_a_valid,
		output [2:0]  io_master_0_a_bits_opcode,
		output [2:0]  io_master_0_a_bits_param,
		output [3:0]  io_master_0_a_bits_size,
		output [1:0]  io_master_0_a_bits_source,
		output [31:0] io_master_0_a_bits_address,
		output [7:0]  io_master_0_a_bits_mask,
		output [63:0] io_master_0_a_bits_data,
		output        io_master_0_b_ready,
		input         io_master_0_b_valid,
		input  [2:0]  io_master_0_b_bits_opcode,
		input  [1:0]  io_master_0_b_bits_param,
		input  [3:0]  io_master_0_b_bits_size,
		input  [1:0]  io_master_0_b_bits_source,
		input  [31:0] io_master_0_b_bits_address,
		input  [7:0]  io_master_0_b_bits_mask,
		input         io_master_0_c_ready,
		output        io_master_0_c_valid,
		output [2:0]  io_master_0_c_bits_opcode,
		output [2:0]  io_master_0_c_bits_param,
		output [3:0]  io_master_0_c_bits_size,
		output [1:0]  io_master_0_c_bits_source,
		output [31:0] io_master_0_c_bits_address,
		output [63:0] io_master_0_c_bits_data,
		output        io_master_0_c_bits_error,
		output        io_master_0_d_ready,
		input         io_master_0_d_valid,
		input  [2:0]  io_master_0_d_bits_opcode,
		input  [1:0]  io_master_0_d_bits_param,
		input  [3:0]  io_master_0_d_bits_size,
		input  [1:0]  io_master_0_d_bits_source,
		input  [1:0]  io_master_0_d_bits_sink,
		input  [2:0]  io_master_0_d_bits_addr_lo,
		input  [63:0] io_master_0_d_bits_data,
		input         io_master_0_d_bits_error,
		input         io_master_0_e_ready,
		output        io_master_0_e_valid,
		output [1:0]  io_master_0_e_bits_sink,
		input         io_asyncInterrupts_0_0,
		input         io_periphInterrupts_0_0,
		input         io_periphInterrupts_0_1,
		input         io_periphInterrupts_0_2,
		input         io_periphInterrupts_0_3,
		input         io_hartid,
		input  [31:0] io_resetVector
		);

	initial begin
		$display("Hello from SyncRocketTile");
	end

endmodule


