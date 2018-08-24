
class rocket_soc_subsys_uex_test 
		extends rocket_soc_subsys_test_base
		implements uex_sys_main;
	`uvm_component_utils(rocket_soc_subsys_uex_test)
	
	class irq_listener extends uvm_subscriber #(event_seq_item);
		`uvm_component_utils(irq_listener);
		mailbox #(int unsigned)			m_irq_mb = new();
		rocket_soc_subsys_uex_test		m_test;
		
		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction
	
		virtual task run_phase(uvm_phase phase);
			int unsigned ev;
			
			forever begin
				m_irq_mb.get(ev);
				if (ev != 0) begin
					$display("IRQ: --> deliver %0d", ev);
					m_test.m_sys.uex_irq(0, ev);
					$display("IRQ: <-- deliver %0d", ev);
				end
			end
		endtask
		
		function void write(event_seq_item t);
			$display("IRQ: %0d", t.m_value);
			void'(m_irq_mb.try_put(t.m_value));
		endfunction
		
	endclass

	string						m_googletest;
	uex_sys						m_sys;
	irq_listener				m_irq_listener;
	
	function new(string name, uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Now, create the UEX sys
		m_sys = new("rocket_soc", this);
		
		m_irq_listener = irq_listener::type_id::create("m_irq_listener", this);
	
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

		m_irq_listener.m_test = this;
		m_env.m_core0_irq.m_mon_out_ap.connect(
				m_irq_listener.analysis_export);
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

