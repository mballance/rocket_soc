/****************************************************************************
 * rocket_soc_subsys_false_sharing.svh
 ****************************************************************************/

/**
 * Class: rocket_soc_subsys_false_sharing
 * 
 * TODO: Add class documentation
 */
class rocket_soc_subsys_false_sharing extends rocket_soc_subsys_test_base;
	`uvm_component_utils(rocket_soc_subsys_false_sharing)

	function new(string name="rocket_soc_subsys_false_sharing", uvm_component parent=null);
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
		sv_bfms_rw_api_if api0, api1, api2, api3;
		int data;
		
		phase.raise_objection(this, "Main");
		
		api0 = m_env.m_core0.get_api();
		api1 = m_env.m_core1.get_api();
		api2 = m_env.m_core2.get_api();
		api3 = m_env.m_core3.get_api();
	
		fork
			begin
				for (int i=0; i<256; i++) begin
					bit[31:0] rdata;
					api0.write32('h8000_0000, i);
					api0.read32('h8000_0000, rdata);
					if (rdata != i) begin
						`uvm_error(get_name(), 
							$sformatf("T0 mismatch: write=%0d read=%0d",
								i, rdata));
					end
				end
			end
			begin
				for (int i=0; i<256; i++) begin
					bit[31:0] rdata;
					api1.write32('h8000_0004, i);
					for (int j=0; j<8; j++) begin
						api1.read32('h8000_0004, rdata);
						if (rdata != i) begin
							`uvm_error(get_name(), 
								$sformatf("T1 mismatch: j=%0d write=%0d read=%0d",
									j, i, rdata));
						end else begin
							`uvm_info(get_name(), 
								$sformatf("T1 match: j=%0d write=%0d read=%0d",
									j, i, rdata),
								UVM_LOW);
						end
					end
				end
			end
		join
		
		phase.drop_objection(this, "Main");
	endtask
	

endclass


