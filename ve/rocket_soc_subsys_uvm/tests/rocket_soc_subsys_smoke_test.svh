/****************************************************************************
 * rocket_soc_subsys_smoke_test.svh
 ****************************************************************************/

/**
 * Class: rocket_soc_subsys_smoke_test
 * 
 * TODO: Add class documentation
 */
class rocket_soc_subsys_smoke_test extends rocket_soc_subsys_test_base;
	`uvm_component_utils(rocket_soc_subsys_smoke_test)

	function new(string name="rocket_soc_subsys_smoke_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	typedef hella_cache_master_access_seq #(
		rocket_soc_subsys_env::NUM_ADDR_BITS, 
		rocket_soc_subsys_env::NUM_DATA_BITS, 
		rocket_soc_subsys_env::NUM_TAG_BITS) seq_t;
	typedef hella_cache_master_seq_item #(
		rocket_soc_subsys_env::NUM_ADDR_BITS, 
		rocket_soc_subsys_env::NUM_DATA_BITS, 
		rocket_soc_subsys_env::NUM_TAG_BITS) seq_item_t;
	
	/**
	 * Task: run_phase
	 *
	 * Override from class 
	 */
	task run_phase(input uvm_phase phase);
		seq_t seq = seq_t::type_id::create();
		phase.raise_objection(this, "Main");

`ifndef UNDEFINED
		for (int unsigned addr='h60000000; addr<'h6000_0010; addr+=4) begin
			seq.addr = addr;
			seq.cmd = seq_item_t::M_XRD;
			seq.typ = seq_item_t::MT_B;
			
			seq.start(m_env.m_core.m_seqr);
		end
		
		phase.drop_objection(this, "Main");
`endif
	endtask
	

endclass


