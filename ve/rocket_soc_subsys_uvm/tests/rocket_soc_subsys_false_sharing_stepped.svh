/****************************************************************************
 * rocket_soc_subsys_false_sharing.svh
 ****************************************************************************/

/**
 * Class: rocket_soc_subsys_false_sharing_stepped
 * 
 * TODO: Add class documentation
 */
class rocket_soc_subsys_false_sharing_stepped extends rocket_soc_subsys_test_base;
	`uvm_component_utils(rocket_soc_subsys_false_sharing_stepped)

	function new(string name="rocket_soc_subsys_false_sharing_stepped", uvm_component parent=null);
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
	
	task test(
		string 				id, 
		bit[31:0] 			addr,
		sv_bfms_rw_api_if	api);
		
		for (int i=0; i<256; i++) begin
			bit[31:0] rdata;
			api.write32(addr, i);
			api.read32(addr, rdata);
			for (int j=0; j<8; j++) begin
			if (rdata != i) begin
				`uvm_error(get_name(), 
					$sformatf("%0s mismatch: write=%0d read=%0d",
						id, i, rdata));
			end else begin
				`uvm_info(get_name(), 
					$sformatf("%0s match: write=%0d read=%0d",
						id, i, rdata),
					UVM_LOW);
				break;
			end
			end
		end		
	endtask
	
	
	/**
	 * Task: run_phase
	 *
	 * Override from class 
	 */
	task run_phase(input uvm_phase phase);
		sv_bfms_rw_api_if api0, api1, api2, api3;
		
		phase.raise_objection(this, "Main");
		
		api0 = m_env.m_core0.get_api();
		api1 = m_env.m_core1.get_api();
		api2 = m_env.m_core2.get_api();
		api3 = m_env.m_core3.get_api();
		
		for (int i=0; i<16; i++) begin
			bit[31:0] rdata;
			$display("--> api3.write(%0d)", i);
			api3.write32('h8000_0018, 'h4000_0000+i);
			$display("<-- api3.write(%0d)", i);
			$display("--> api0.write(%0d)", i);
			api0.write32('h8000_0000, 'h1000_0000+i);
			$display("<-- api0.write(%0d)", i);
			$display("--> api1.write(%0d)", i);
			api1.write32('h8000_0008, 'h2000_0000+i);
			$display("<-- api1.write(%0d)", i);
			$display("--> api2.write(%0d)", i);
			api2.write32('h8000_0010, 'h3000_0000+i);
			$display("<-- api2.write(%0d)", i);
			
			$display("--> api0.read");
			api0.read32('h8000_0000, rdata);
			$display("<-- api0.read(%0d)", rdata);
			
			if (rdata != ('h1000_0000+i)) begin
				`uvm_error(get_name(), $sformatf("T0: write='h%08h read='h%08h",
						('h1000_0000+i), rdata));
			end
			$display("--> api1.read");
			api1.read32('h8000_0008, rdata);
			$display("<-- api1.read(%0d)", rdata);
			
			if (rdata != ('h2000_0000+i)) begin
				`uvm_error(get_name(), $sformatf("T1: write='h%08h read='h%08h",
						('h2000_0000+i), rdata));
			end
			$display("--> api2.read");
			api2.read32('h8000_0010, rdata);
			$display("<-- api2.read(%0d)", rdata);
			
			if (rdata != ('h3000_0000+i)) begin
				`uvm_error(get_name(), $sformatf("T2: write=%0d read=%0d",
						('h3000_0000+i), rdata));
			end
			$display("--> api3.read");
			api3.read32('h8000_0018, rdata);
			$display("<-- api3.read(%0d)", rdata);
			
			if (rdata != ('h4000_0000+i)) begin
				`uvm_error(get_name(), $sformatf("T3: write=%0d read=%0d",
						('h4000_0000+i), rdata));
			end
		end
		
		$display("NOTE: end of test");
		phase.drop_objection(this, "Main");
	endtask
	

endclass


