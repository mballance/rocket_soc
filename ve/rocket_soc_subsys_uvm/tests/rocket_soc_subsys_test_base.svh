
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
	


	/**
	 * Function: report_phase
	 *
	 * Override from class 
	 */
	virtual function void report_phase(input uvm_phase phase);
		uvm_report_server svr = get_report_server();
		int n_errors = svr.get_severity_count(UVM_ERROR);
		string testname;
	
		if (!$value$plusargs("TESTNAME=%s", testname)) begin
			`uvm_fatal(get_name(), "+TESTNAME not set");
		end else begin
			if (n_errors == 0) begin
				`uvm_info(get_name(), $sformatf("PASS: %0s", testname), UVM_LOW);
			end else begin
				`uvm_info(get_name(), $sformatf("FAIL: %0s - %0d errors", 
						testname, n_errors), UVM_LOW);
			end
		end

	endfunction

	
endclass

