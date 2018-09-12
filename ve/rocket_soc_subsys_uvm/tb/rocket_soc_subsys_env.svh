
class rocket_soc_subsys_env extends uvm_env;
	`uvm_component_utils(rocket_soc_subsys_env)
	
	localparam NUM_ADDR_BITS=40;
	localparam NUM_DATA_BITS=64;
	localparam NUM_TAG_BITS=7;
	
	typedef hella_cache_master_agent #(NUM_ADDR_BITS, NUM_DATA_BITS, NUM_TAG_BITS) 
		hella_cache_master_agent_t;
	
	hella_cache_master_agent_t			m_core0;
	event_agent							m_core0_irq;
	hella_cache_master_agent_t			m_core1;
	event_agent							m_core1_irq;
	hella_cache_master_agent_t			m_core2;
	event_agent							m_core2_irq;
	hella_cache_master_agent_t			m_core3;
	event_agent							m_core3_irq;
	
	vmon_client_agent					m_vmon_agent;
	vmon_m2h_if							m_m2h;
	uvmdev_vmon_ep_client				m_ep1_client;
	uart_serial_agent					uart0;
	

	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	/**
	 * Function: build_phase
	 *
	 * Override from class uvm_component
	 */
	virtual function void build_phase(input uvm_phase phase);
		typedef virtual wb_vmon_monitor_if #(32,32) wb_vmon_monitor_if_t;
		wb_vmon_monitor_if_t vmon_if;
		super.build_phase(phase);
	
		m_core0 = hella_cache_master_agent_t::type_id::create("m_core0", this);
		m_core0_irq = event_agent::type_id::create("m_core0_irq", this);
		m_core1 = hella_cache_master_agent_t::type_id::create("m_core1", this);
		m_core1_irq = event_agent::type_id::create("m_core1_irq", this);
		m_core2 = hella_cache_master_agent_t::type_id::create("m_core2", this);
		m_core2_irq = event_agent::type_id::create("m_core2_irq", this);
		m_core3 = hella_cache_master_agent_t::type_id::create("m_core3", this);
		m_core3_irq = event_agent::type_id::create("m_core3_irq", this);
		
		m_vmon_agent = vmon_client_agent::type_id::create("m_vmon_agent", this);
		m_m2h = new();
		
		uart0 = uart_serial_agent::type_id::create("uart0", this);
		
		uvm_config_db #(wb_vmon_monitor_if_t)::get(this, "*", "vmon_if", vmon_if);
		vmon_if.api = m_m2h;
		
		m_ep1_client = new();
	endfunction

	/**
	 * Function: connect_phase
	 *
	 * Override from class uvm_component
	 */
	virtual function void connect_phase(input uvm_phase phase);
		super.connect_phase(phase);
		m_vmon_agent.m_client.add_m2h_if(m_m2h);
		m_vmon_agent.m_client.set_ep_listener(1, m_ep1_client);
	endfunction
	
	
endclass
