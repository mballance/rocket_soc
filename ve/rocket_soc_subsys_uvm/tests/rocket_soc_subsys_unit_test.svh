/****************************************************************************
 * rocket_soc_subsys_unit_test.svh
 ****************************************************************************/

/**
 * Class: rocket_soc_subsys_unit_test
 * 
 * TODO: Add class documentation
 */
class rocket_soc_subsys_unit_test extends rocket_soc_subsys_test_base;
	`uvm_component_utils(rocket_soc_subsys_unit_test)

	function new(string name="rocket_soc_subsys_unit_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	/**
	 * Task: run_phase
	 *
	 * Override from class 
	 */
	task run_phase(input uvm_phase phase);
		string test;
		phase.raise_objection(this, "Main");
	
		if (!$value$plusargs("GOOGLETEST=%s", test)) begin
			`uvm_fatal (get_name(), "No GOOGLETEST specified");
		end
		
		run_all_tests(test);
		
		phase.drop_objection(this, "Main");
	endtask
	

endclass


