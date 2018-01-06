/****************************************************************************
 * Rocket.sv
 * 
 ****************************************************************************/

/**
 * Module: Rocket
 * 
 * TODO: Add module documentation
 */
module Rocket(
		input         clock,
		input         reset,
		input [1:0]   io_hartid,
		input         io_interrupts_debug,
		input         io_interrupts_mtip,
		input         io_interrupts_msip,
		input         io_interrupts_meip,
		input         io_interrupts_seip,
		output        io_imem_req_valid,
		output [39:0] io_imem_req_bits_pc,
		output        io_imem_req_bits_speculative,
		output        io_imem_sfence_valid,
		output        io_imem_sfence_bits_rs1,
		output        io_imem_sfence_bits_rs2,
		output [38:0] io_imem_sfence_bits_addr,
		output        io_imem_resp_ready,
		input         io_imem_resp_valid,
//		input         io_imem_resp_bits_btb_valid,
		input         io_imem_resp_bits_btb_taken,
		input         io_imem_resp_bits_btb_bridx,
		input  [4:0]  io_imem_resp_bits_btb_entry,
		input  [7:0]  io_imem_resp_bits_btb_bht_history,
//		input  [1:0]  io_imem_resp_bits_btb_bits_bht_value,
		input  [39:0] io_imem_resp_bits_pc,
		input  [31:0] io_imem_resp_bits_data,
		input         io_imem_resp_bits_xcpt_pf_inst,
		input         io_imem_resp_bits_xcpt_ae_inst,
		input         io_imem_resp_bits_replay,
		output        io_imem_btb_update_valid,
//		output        io_imem_btb_update_bits_prediction_valid,
//		output [4:0]  io_imem_btb_update_bits_prediction_bits_entry,
		output [4:0]  io_imem_btb_update_bits_prediction_entry,
//		output [7:0]  io_imem_btb_update_bits_prediction_bits_bht_history,
//		output [1:0]  io_imem_btb_update_bits_prediction_bits_bht_value,
		output [38:0] io_imem_btb_update_bits_pc,
		output        io_imem_btb_update_bits_isValid,
		output [38:0] io_imem_btb_update_bits_br_pc,
		output [1:0]  io_imem_btb_update_bits_cfiType,
		output        io_imem_bht_update_valid,
//		output [7:0]  io_imem_bht_update_bits_prediction_bits_bht_history,
		output [7:0]  io_imem_bht_update_bits_prediction_history,
//		output [1:0]  io_imem_bht_update_bits_prediction_bits_bht_value,
		output [38:0] io_imem_bht_update_bits_pc,
		output        io_imem_bht_update_bits_branch,
		output        io_imem_bht_update_bits_taken,
		output        io_imem_bht_update_bits_mispredict,
		output        io_imem_flush_icache,
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
		input         io_dmem_ordered,
		output [3:0]  io_ptw_ptbr_mode,
		output [15:0] io_ptw_ptbr_asid,
		output [43:0] io_ptw_ptbr_ppn,
		output        io_ptw_sfence_valid,
		output        io_ptw_sfence_bits_rs1,
		output [1:0]  io_ptw_status_dprv,
		output [1:0]  io_ptw_status_prv,
		output        io_ptw_status_mxr,
		output        io_ptw_status_sum,
		output        io_ptw_pmp_0_cfg_l,
		output [1:0]  io_ptw_pmp_0_cfg_a,
		output        io_ptw_pmp_0_cfg_x,
		output        io_ptw_pmp_0_cfg_w,
		output        io_ptw_pmp_0_cfg_r,
		output [29:0] io_ptw_pmp_0_addr,
		output [31:0] io_ptw_pmp_0_mask,
		output        io_ptw_pmp_1_cfg_l,
		output [1:0]  io_ptw_pmp_1_cfg_a,
		output        io_ptw_pmp_1_cfg_x,
		output        io_ptw_pmp_1_cfg_w,
		output        io_ptw_pmp_1_cfg_r,
		output [29:0] io_ptw_pmp_1_addr,
		output [31:0] io_ptw_pmp_1_mask,
		output        io_ptw_pmp_2_cfg_l,
		output [1:0]  io_ptw_pmp_2_cfg_a,
		output        io_ptw_pmp_2_cfg_x,
		output        io_ptw_pmp_2_cfg_w,
		output        io_ptw_pmp_2_cfg_r,
		output [29:0] io_ptw_pmp_2_addr,
		output [31:0] io_ptw_pmp_2_mask,
		output        io_ptw_pmp_3_cfg_l,
		output [1:0]  io_ptw_pmp_3_cfg_a,
		output        io_ptw_pmp_3_cfg_x,
		output        io_ptw_pmp_3_cfg_w,
		output        io_ptw_pmp_3_cfg_r,
		output [29:0] io_ptw_pmp_3_addr,
		output [31:0] io_ptw_pmp_3_mask,
		output        io_ptw_pmp_4_cfg_l,
		output [1:0]  io_ptw_pmp_4_cfg_a,
		output        io_ptw_pmp_4_cfg_x,
		output        io_ptw_pmp_4_cfg_w,
		output        io_ptw_pmp_4_cfg_r,
		output [29:0] io_ptw_pmp_4_addr,
		output [31:0] io_ptw_pmp_4_mask,
		output        io_ptw_pmp_5_cfg_l,
		output [1:0]  io_ptw_pmp_5_cfg_a,
		output        io_ptw_pmp_5_cfg_x,
		output        io_ptw_pmp_5_cfg_w,
		output        io_ptw_pmp_5_cfg_r,
		output [29:0] io_ptw_pmp_5_addr,
		output [31:0] io_ptw_pmp_5_mask,
		output        io_ptw_pmp_6_cfg_l,
		output [1:0]  io_ptw_pmp_6_cfg_a,
		output        io_ptw_pmp_6_cfg_x,
		output        io_ptw_pmp_6_cfg_w,
		output        io_ptw_pmp_6_cfg_r,
		output [29:0] io_ptw_pmp_6_addr,
		output [31:0] io_ptw_pmp_6_mask,
		output        io_ptw_pmp_7_cfg_l,
		output [1:0]  io_ptw_pmp_7_cfg_a,
		output        io_ptw_pmp_7_cfg_x,
		output        io_ptw_pmp_7_cfg_w,
		output        io_ptw_pmp_7_cfg_r,
		output [29:0] io_ptw_pmp_7_addr,
		output [31:0] io_ptw_pmp_7_mask,
		output [31:0] io_fpu_inst,
		output [63:0] io_fpu_fromint_data,
		output [2:0]  io_fpu_fcsr_rm,
		input         io_fpu_fcsr_flags_valid,
		input  [4:0]  io_fpu_fcsr_flags_bits,
		input  [63:0] io_fpu_store_data,
		input  [63:0] io_fpu_toint_data,
		output        io_fpu_dmem_resp_val,
		output [2:0]  io_fpu_dmem_resp_type,
		output [4:0]  io_fpu_dmem_resp_tag,
		output [63:0] io_fpu_dmem_resp_data,
		output        io_fpu_valid,
		input         io_fpu_fcsr_rdy,
		input         io_fpu_nack_mem,
		input         io_fpu_illegal_rm,
		output        io_fpu_killx,
		output        io_fpu_killm,
		input         io_fpu_dec_wen,
		input         io_fpu_dec_ren1,
		input         io_fpu_dec_ren2,
		input         io_fpu_dec_ren3,
		input         io_fpu_sboard_set,
		input         io_fpu_sboard_clr,
		input  [4:0]  io_fpu_sboard_clra,
		input         io_rocc_cmd_ready,
		input         io_rocc_interrupt
		);
	import hella_cache_master_agent_pkg::*;
	import uvm_pkg::*;
	
	// Stub out imem interface
	assign io_imem_req_valid = 0;
	assign io_imem_req_bits_pc = 0;
	assign io_imem_req_bits_speculative = 0;
	assign io_imem_sfence_valid = 0;
	assign io_imem_sfence_bits_rs1 = 0;
	assign io_imem_sfence_bits_rs2 = 0;
	assign io_imem_sfence_bits_addr = 0;
	assign io_imem_resp_ready = 1; // Always ready
	assign io_imem_btb_update_valid = 0;
//	assign io_imem_btb_update_bits_prediction_valid = 0;
//	assign io_imem_btb_update_bits_prediction_bits_entry = 0;
//	assign io_imem_btb_update_bits_prediction_bits_bht_history = 0;
	assign io_imem_btb_update_bits_prediction_bits_history = 0;
//	assign io_imem_btb_update_bits_prediction_bits_bht_value = 0;
	assign io_imem_btb_update_bits_pc = 0;
	assign io_imem_btb_update_bits_isValid = 0;
	assign io_imem_btb_update_bits_br_pc = 0;
	assign io_imem_btb_update_bits_cfiType = 0;
	assign io_imem_bht_update_valid = 0;
	assign io_imem_bht_update_bits_prediction_bits_bht_history = 0;
	assign io_imem_bht_update_bits_prediction_bits_bht_value = 0;
	assign io_imem_bht_update_bits_pc = 0;
	assign io_imem_bht_update_bits_taken = 0;
	assign io_imem_bht_update_bits_mispredict = 0;
	assign io_imem_flush_icache = 0;

	assign io_ptw_ptbr_mode = 'hb;
	assign io_ptw_ptbr_asid = 0;
	assign io_ptw_ptbr_ppn = 'h78f4788e78f;
	assign io_ptw_sfence_valid = 0;
	assign io_ptw_sfence_bits_rs1 = 0;
	assign io_ptw_status_dprv = 3;
	assign io_ptw_status_prv = 3;
	assign io_ptw_status_mxr = 0;
	assign io_ptw_status_sum = 0;
	assign io_ptw_pmp_0_addr = 'h13104526;
	assign io_ptw_pmp_0_cfg_a = 0;
	assign io_ptw_pmp_0_cfg_l = 0;
	assign io_ptw_pmp_0_cfg_r = 1;
	assign io_ptw_pmp_0_cfg_w = 0;
	assign io_ptw_pmp_0_cfg_x = 0;
	assign io_ptw_pmp_0_mask = 3;
	assign io_ptw_pmp_1_addr = 'h143c3fa8;
	assign io_ptw_pmp_1_cfg_a = 0;
	assign io_ptw_pmp_1_cfg_l = 0;
	assign io_ptw_pmp_1_cfg_r = 0;
	assign io_ptw_pmp_1_cfg_x = 1;
	assign io_ptw_pmp_1_cfg_w = 1;
	assign io_ptw_pmp_1_mask = 3;
	assign io_ptw_pmp_2_addr = 'h2d93bcdb;
	assign io_ptw_pmp_2_cfg_l = 0;
	assign io_ptw_pmp_2_cfg_r = 0;
	assign io_ptw_pmp_2_cfg_a = 0;
	assign io_ptw_pmp_2_cfg_x = 0;
	assign io_ptw_pmp_2_cfg_w = 1;
	assign io_ptw_pmp_2_mask = 3;
	assign io_ptw_pmp_3_addr = 'hf38d91e;
	assign io_ptw_pmp_3_cfg_l= 0;
	assign io_ptw_pmp_3_cfg_a= 0;
	assign io_ptw_pmp_3_cfg_x= 1;
	assign io_ptw_pmp_3_cfg_w= 1;
	assign io_ptw_pmp_3_cfg_r= 0;
	assign io_ptw_pmp_3_mask= 3;
	assign io_ptw_pmp_4_addr= 'hd0a479a;
	assign io_ptw_pmp_4_cfg_l= 0;
	assign io_ptw_pmp_4_cfg_a= 0;
	assign io_ptw_pmp_4_cfg_x= 1;
	assign io_ptw_pmp_4_cfg_w= 0;
	assign io_ptw_pmp_4_cfg_r= 0;
	assign io_ptw_pmp_4_mask= 3;
	assign io_ptw_pmp_5_addr = 'h391bfdf2;
	assign io_ptw_pmp_5_cfg_l= 0;
	assign io_ptw_pmp_5_cfg_a= 0;
	assign io_ptw_pmp_5_cfg_x= 0;
	assign io_ptw_pmp_5_cfg_w= 0;
	assign io_ptw_pmp_5_cfg_r= 0;
	assign io_ptw_pmp_5_mask= 3;
	assign io_ptw_pmp_6_addr = 'hb5b0016;
	assign io_ptw_pmp_6_cfg_l= 0;
	assign io_ptw_pmp_6_cfg_a= 0;
	assign io_ptw_pmp_6_cfg_x= 1;
	assign io_ptw_pmp_6_cfg_w= 0;
	assign io_ptw_pmp_6_cfg_r= 0;
	assign io_ptw_pmp_6_mask= 3;
	assign io_ptw_pmp_7_addr= 'h5463e8a;
	assign io_ptw_pmp_7_cfg_l= 0;
	assign io_ptw_pmp_7_cfg_a= 0;
	assign io_ptw_pmp_7_cfg_x= 1;
	assign io_ptw_pmp_7_cfg_w= 0;
	assign io_ptw_pmp_7_cfg_r= 1;
	assign io_ptw_pmp_7_mask= 3;
	assign io_fpu_inst= 0;
	assign io_fpu_fromint_data= 0;
	assign io_fpu_fcsr_rm= 0;	

	assign io_fpu_dmem_resp_val = 0;
	assign io_fpu_dmem_resp_type = 0;
	assign io_fpu_dmem_resp_tag = 0;
	assign io_fpu_dmem_resp_data = 0;
	assign io_fpu_valid = 0;
	assign io_fpu_killx = 0;
	assign io_fpu_killm = 0;
	
endmodule



