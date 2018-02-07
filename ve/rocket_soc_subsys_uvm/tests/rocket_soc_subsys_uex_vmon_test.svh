
// Receive path for vmon
class rocket_soc_vmon_m2h implements vmon_m2h_if;
	uart_serial_agent			m_serial_agent;

	function new (uart_serial_agent agent);
		m_serial_agent = agent;
	endfunction

	/**
	 * Task: recv
	 *
	 * Override from class vmon_m2h_if
	 */
	virtual task recv(
		output byte unsigned 	data[64], 
		input int 				size, 
		input int 				timeout, 
		output int 				ret);
		bit[7:0]		c;
		bit				valid;
	
		$display("%0t: recv timeout=%0d", $time, timeout);
		m_serial_agent.getc(c, valid, timeout);
		$display("%0t: c=%0d valid=%0d", $time, c, valid);
	
		data[0] = c;
		ret = (valid)?1:0;
	endtask

	
endclass

// Transmit path for vmon
class rocket_soc_vmon_h2m implements vmon_h2m_if;

	uart_serial_agent			m_serial_agent;

	function new (uart_serial_agent agent);
		m_serial_agent = agent;
	endfunction

	/**
	 * Task: send
	 *
	 * Override from class vmon_h2m_if
	 */
	virtual task send(
		input byte unsigned 	data[64], 
		input int 				size, 
		output int 				ret);
		m_serial_agent.putc(data[0]);
		ret = 1;
	endtask
	
endclass

class rocket_soc_subsys_uex_vmon_test extends rocket_soc_subsys_uex_test;
	`uvm_component_utils(rocket_soc_subsys_uex_vmon_test)
	
	vmon_client					m_vmon_client;

	function new(string name, uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		m_vmon_client = new();
	endfunction
	
	function void connect_phase(uvm_phase phase);
		rocket_soc_vmon_m2h m2h = new(m_env.uart0);
		rocket_soc_vmon_h2m h2m = new(m_env.uart0);
		super.connect_phase(phase);
		
		m_vmon_client.add_m2h_if(m2h);
		m_vmon_client.add_h2m_if(h2m);
	endfunction
	
	task run_phase(uvm_phase phase);
		bit ok;
		phase.raise_objection(this, "Main");

		if (!$value$plusargs("GOOGLETEST=%s", m_googletest)) begin
			`uvm_fatal (get_name(), "No GOOGLETEST specified");
		end
	
		fork
			m_sys.run();
		join_none
		
		m_vmon_client.connect(ok);
		
		$display("OK=%0d", ok);
	
		// Tell the client to exit
		m_vmon_client.exit();
		
		phase.drop_objection(this, "Main");
			
	endtask
	

	
endclass

