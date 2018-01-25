/****************************************************************************
 * rocket_soc_subsys_mem_services.svh
 ****************************************************************************/

/**
 * Class: rocket_soc_subsys_mem_services
 * 
 * TODO: Add class documentation
 */
class rocket_soc_subsys_mem_services extends uex_delegating_mem_services;
	
	sv_bfms_rw_api_if			m_api;

	function new(sv_bfms_rw_api_if api, uex_mem_alloc_services mem_alloc);
		super.new(null, mem_alloc);
		m_api = api;
	endfunction

	virtual task iowrite8(
		byte unsigned data, 
		longint unsigned addr);
		m_api.write8(addr, data);
	endtask
	
	virtual task ioread8(
		output byte unsigned data, 
		input longint unsigned addr);
		m_api.read8(addr, data);
	endtask
	
	virtual task iowrite16(
		shortint unsigned data, 
		longint unsigned addr);
		m_api.write16(addr, data);
	endtask
	
	virtual task ioread16(
		output shortint unsigned data, 
		input longint unsigned addr);
		m_api.read16(addr, data);
	endtask
	
	virtual task iowrite32(
		int unsigned data, 
		longint unsigned addr);
		m_api.write32(addr, data);
	endtask
	
	virtual task ioread32(
		output int unsigned data, 
		input longint unsigned addr);
		m_api.read32(addr, data);
	endtask
	
	virtual task iowrite64(
		longint unsigned data, 
		longint unsigned addr);
		$display("TODO: iowrite64");
	endtask
	
	virtual task ioread64(
		output longint unsigned data, 
		input longint unsigned addr);
		$display("TODO: ioread32");
	endtask	
	
endclass


