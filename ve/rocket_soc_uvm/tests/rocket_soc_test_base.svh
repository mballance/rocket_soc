
// Receive path for vmon
class rocket_soc_vmon_m2h extends vmon_m2h_if;
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
class rocket_soc_vmon_h2m extends vmon_h2m_if;

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

class rocket_soc_test_base extends uvm_test;
	
	`uvm_component_utils(rocket_soc_test_base)
	
	rocket_soc_env				m_env;
	vmon_client					m_vmon_client;
	
	function new(string name, uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		m_env = rocket_soc_env::type_id::create("m_env", this);
		
		m_vmon_client = new();
	endfunction

	/**
	 * Function: connect_phase
	 *
	 * Override from class 
	 */
	virtual function void connect_phase(input uvm_phase phase);
		rocket_soc_vmon_m2h m2h = new(m_env.uart0);
		rocket_soc_vmon_h2m h2m = new(m_env.uart0);
		
		m_vmon_client.add_m2h_if(m2h);
		m_vmon_client.add_h2m_if(h2m);

	endfunction
	
	virtual task connect_to_sw();
		bit ok;
		
		m_vmon_client.connect(ok);
		
		$display("OK=%0d", ok);
	endtask

	/**
	 * Task: run_phase
	 *
	 * Override from class 
	 */
	virtual task run_phase(input uvm_phase phase);
		
		phase.raise_objection(this, "Main");
		
		connect_to_sw();
		
	endtask

	
	
endclass

