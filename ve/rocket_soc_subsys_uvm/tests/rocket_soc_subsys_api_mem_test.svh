/****************************************************************************
 * rocket_soc_subsys_api_mem_test.svh
 ****************************************************************************/

/**
 * Class: rocket_soc_subsys_api_mem_test
 * 
 * TODO: Add class documentation
 */
class rocket_soc_subsys_api_mem_test extends rocket_soc_subsys_test_base;
	`uvm_component_utils(rocket_soc_subsys_api_mem_test)

	function new(string name="rocket_soc_subsys_api_mem_test", uvm_component parent=null);
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
		sv_bfms_rw_api_if api;
		int data;
		
		phase.raise_objection(this, "Main");
		
		api = m_env.m_core.get_api();
		
		for (int unsigned addr='h8000_0000; addr<'h8000_0100; addr+=4) begin
			bit[31:0] rdata;
			bit[31:0] wdata = 'h55aaee00+(data & 'hff);
			api.write32(addr, wdata);
			api.read32(addr, rdata);
			
			$display("Note: 'h%08h write='h%08h read='h%08h", addr, wdata, rdata);
			
			if (rdata != wdata) begin
				`uvm_error(get_name(), 
					$sformatf("Error: miscompare %0d vs %0d", wdata, rdata));
			end
			data = ((data+1) & 'hFF);
		end

		data=1;
		for (int unsigned addr='h8000_0000; addr<'h8000_0100; addr+=1) begin
			bit[7:0] rdata;
			api.write8(addr, data);
			api.read8(addr, rdata);
			
			if (data != rdata) begin
				`uvm_error(get_name(), 
					$sformatf("Error: miscompare %0d vs %0d", data, rdata));
			end
			data = ((data+1) & 'hFF);
		end
		
		phase.drop_objection(this, "Main");
	endtask
	

endclass


