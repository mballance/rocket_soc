
class rocket_soc_subsys_test_base extends uvm_test;
	
	`uvm_component_utils(rocket_soc_subsys_test_base)
	
	rocket_soc_subsys_env				m_env;
	
	function new(string name, uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		m_env = rocket_soc_subsys_env::type_id::create("m_env", this);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this, "Main");
	endtask
endclass

