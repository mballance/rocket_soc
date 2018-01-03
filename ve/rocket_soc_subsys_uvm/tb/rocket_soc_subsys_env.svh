
class rocket_soc_subsys_env extends uvm_env;
	`uvm_component_utils(rocket_soc_subsys_env)
	
	localparam NUM_ADDR_BITS=40;
	localparam NUM_DATA_BITS=64;
	localparam NUM_TAG_BITS=7;
	
	typedef hella_cache_master_agent #(NUM_ADDR_BITS, NUM_DATA_BITS, NUM_TAG_BITS) 
		hella_cache_master_agent_t;
	
	hella_cache_master_agent_t			m_core0;
	hella_cache_master_agent_t			m_core1;
	hella_cache_master_agent_t			m_core2;
	hella_cache_master_agent_t			m_core3;

	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	/**
	 * Function: build_phase
	 *
	 * Override from class uvm_component
	 */
	virtual function void build_phase(input uvm_phase phase);
		super.build_phase(phase);
	
		m_core0 = hella_cache_master_agent_t::type_id::create("m_core0", this);
		m_core1 = hella_cache_master_agent_t::type_id::create("m_core1", this);
		m_core2 = hella_cache_master_agent_t::type_id::create("m_core2", this);
		m_core3 = hella_cache_master_agent_t::type_id::create("m_core3", this);
	endfunction

	/**
	 * Function: connect_phase
	 *
	 * Override from class uvm_component
	 */
	virtual function void connect_phase(input uvm_phase phase);
		super.connect_phase(phase);
	endfunction
	
	
endclass
