/****************************************************************************
 * rocket_soc_subsys_par_test.svh
 ****************************************************************************/

/**
 * Class: rocket_soc_subsys_par_test
 * 
 * TODO: Add class documentation
 */
class rocket_soc_subsys_par_test extends rocket_soc_subsys_test_base;
	`uvm_component_utils(rocket_soc_subsys_par_test)

	function new(string name="rocket_soc_subsys_par_test", uvm_component parent=null);
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
		seq_t seq[4];
		phase.raise_objection(this, "Main");
		
		foreach (seq[i]) begin
			seq[i] = seq_t::type_id::create();
		end

		for (int unsigned addr='h60000000; addr<'h6000_0100; addr+=4) begin
			foreach (seq[i]) begin
				seq[i].addr = addr;
				seq[i].cmd = seq_item_t::M_XRD;
				seq[i].typ = seq_item_t::MT_B;
			end
		
			fork
				seq[0].start(m_env.m_core0.m_seqr);
				seq[1].start(m_env.m_core0.m_seqr);
				seq[2].start(m_env.m_core0.m_seqr);
				seq[3].start(m_env.m_core0.m_seqr);
			join
		end
		
		phase.drop_objection(this, "Main");
	endtask
	

endclass


