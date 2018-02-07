/****************************************************************************
 * RocketSocSubsysTBHvl.sv
 ****************************************************************************/

/**
 * Module: RocketSocSubsysTBHvl
 * 
 * TODO: Add module documentation
 */
module RocketSocSubsysTBHvl;
	import hella_cache_master_agent_pkg::*;
	import uart_serial_agent_pkg::*;
	import uvm_pkg::*;

	parameter int NUM_ADDR_BITS = 40;
	parameter int NUM_DATA_BITS = 64;
	parameter int NUM_TAG_BITS = 7;
	typedef hella_cache_master_config #(NUM_ADDR_BITS, NUM_DATA_BITS, NUM_TAG_BITS) 
		hella_cache_master_cfg_t;
	
	initial begin
		automatic hella_cache_master_cfg_t core0_cfg = hella_cache_master_cfg_t::type_id::create();
		automatic hella_cache_master_cfg_t core1_cfg = hella_cache_master_cfg_t::type_id::create();
		automatic hella_cache_master_cfg_t core2_cfg = hella_cache_master_cfg_t::type_id::create();
		automatic hella_cache_master_cfg_t core3_cfg = hella_cache_master_cfg_t::type_id::create();
		automatic uart_serial_config uart0_cfg = uart_serial_config::type_id::create("uart0_cfg");
		
		core0_cfg.vif = RocketSocSubsysTBHdl.tb.u_dut.u_core.ExampleRocketSystem.tile.core.bfm.dmem_bfm.u_core;
		core1_cfg.vif = RocketSocSubsysTBHdl.tb.u_dut.u_core.ExampleRocketSystem.tile_1.core.bfm.dmem_bfm.u_core;
		core2_cfg.vif = RocketSocSubsysTBHdl.tb.u_dut.u_core.ExampleRocketSystem.tile_2.core.bfm.dmem_bfm.u_core;
		core3_cfg.vif = RocketSocSubsysTBHdl.tb.u_dut.u_core.ExampleRocketSystem.tile_3.core.bfm.dmem_bfm.u_core;

		uvm_config_db #(hella_cache_master_cfg_t)::set(uvm_top, "*m_core0*",
				hella_cache_master_cfg_t::report_id, core0_cfg);
		uvm_config_db #(hella_cache_master_cfg_t)::set(uvm_top, "*m_core1*",
				hella_cache_master_cfg_t::report_id, core1_cfg);
		uvm_config_db #(hella_cache_master_cfg_t)::set(uvm_top, "*m_core2*",
				hella_cache_master_cfg_t::report_id, core2_cfg);
		uvm_config_db #(hella_cache_master_cfg_t)::set(uvm_top, "*m_core3*",
				hella_cache_master_cfg_t::report_id, core3_cfg);
		
		uart0_cfg.vif = RocketSocSubsysTBHdl.tb.u_uart_bfm.bfm.u_core;
		uvm_config_db #(uart_serial_config)::set(uvm_top, "*uart0*",
				uart_serial_config::report_id, uart0_cfg);
		
		run_test();
	end	


	
endmodule


