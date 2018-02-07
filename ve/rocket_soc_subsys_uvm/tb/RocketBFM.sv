/****************************************************************************
 * Rocket.sv
 * 
 ****************************************************************************/

/**
 * Module: Rocket
 * 
 * TODO: Add module documentation
 */
module RocketBFM (
		input         clock,
		input         reset,
		input         io_interrupts_debug,
		input         io_interrupts_mtip,
		input         io_interrupts_msip,
		input         io_interrupts_meip,
		input         io_interrupts_seip,
		input         io_dmem_req_ready,
		output        io_dmem_req_valid,
		output [39:0] io_dmem_req_bits_addr,
		output [6:0]  io_dmem_req_bits_tag,
		output [4:0]  io_dmem_req_bits_cmd,
		output [2:0]  io_dmem_req_bits_typ,
		output        io_dmem_req_bits_phys,
		output        io_dmem_s1_kill,
		output [63:0] io_dmem_s1_data_data,
		output [7:0]  io_dmem_s1_data_mask,
		input         io_dmem_s2_nack,
		input         io_dmem_resp_valid,
		input  [6:0]  io_dmem_resp_bits_tag,
		input  [2:0]  io_dmem_resp_bits_typ,
		input  [63:0] io_dmem_resp_bits_data,
		input         io_dmem_resp_bits_replay,
		input         io_dmem_resp_bits_has_data,
		input  [63:0] io_dmem_resp_bits_data_word_bypass,
		input         io_dmem_replay_next,
		input         io_dmem_s2_xcpt_ma_ld,
		input         io_dmem_s2_xcpt_ma_st,
		input         io_dmem_s2_xcpt_pf_ld,
		input         io_dmem_s2_xcpt_pf_st,
		input         io_dmem_s2_xcpt_ae_ld,
		input         io_dmem_s2_xcpt_ae_st,
		output        io_dmem_invalidate_lr,
		input         io_dmem_ordered
		);
	
	assign io_dmem_req_bits_phys = 0; // ??
	assign io_dmem_invalidate_lr = 0;

	parameter int NUM_ADDR_BITS = 40;
	parameter int NUM_DATA_BITS = 64;
	parameter int NUM_TAG_BITS = 7;

	// How do we bind across HDL/HVL?
	hella_cache_master_bfm #(
		.NUM_ADDR_BITS  (NUM_ADDR_BITS ), 
		.NUM_DATA_BITS  (NUM_DATA_BITS ), 
		.NUM_TAG_BITS   (NUM_TAG_BITS  )
		) dmem_bfm (
		.clock          (clock						), 
		.reset          (reset						), 
		.req_addr       (io_dmem_req_bits_addr		), 
		.req_ready      (io_dmem_req_ready			), 
		.req_valid      (io_dmem_req_valid			), 
		.req_tag        (io_dmem_req_bits_tag		), 
		.req_cmd        (io_dmem_req_bits_cmd		), 
		.req_typ        (io_dmem_req_bits_typ		), 
		.req_data       (io_dmem_s1_data_data		), 
		.req_data_mask  (io_dmem_s1_data_mask		), 
		.req_kill		(io_dmem_s1_kill			),
		.rsp_valid      (io_dmem_resp_valid			), 
		.rsp_nack		(io_dmem_s2_nack			),
		.rsp_tag        (io_dmem_resp_bits_tag		), 
		.rsp_typ        (io_dmem_resp_bits_typ		), 
		.rsp_data       (io_dmem_resp_bits_data		));
	

endmodule



