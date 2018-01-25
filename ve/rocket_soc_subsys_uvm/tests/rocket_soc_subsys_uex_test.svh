
class rocket_soc_subsys_uex_test 
		extends rocket_soc_subsys_test_base
		implements uex_sys_main;
	`uvm_component_utils(rocket_soc_subsys_uex_test)

	string						m_googletest;
	uex_sys						m_sys;
	
	function new(string name, uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Now, create the UEX sys
		m_sys = new("rocket_soc", this);
		
	
	endfunction
	
	function void connect_phase(uvm_phase phase);
		rocket_soc_subsys_mem_services	core;
		super.connect_phase(phase);
		core = new(m_env.m_core0.get_api(), null);
		m_sys.add_core(core);
		core = new(m_env.m_core1.get_api(), null);
		m_sys.add_core(core);
		core = new(m_env.m_core2.get_api(), null);
		m_sys.add_core(core);
		core = new(m_env.m_core3.get_api(), null);
		m_sys.add_core(core);
	endfunction
	
	virtual task main();
		run_all_tests(m_googletest);
	endtask
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this, "Main");

		if (!$value$plusargs("GOOGLETEST=%s", m_googletest)) begin
			`uvm_fatal (get_name(), "No GOOGLETEST specified");
		end else begin
			m_sys.run();
		end
		
		phase.drop_objection(this, "Main");
			
	endtask
	

	
endclass

