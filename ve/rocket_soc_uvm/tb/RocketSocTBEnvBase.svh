/****************************************************************************
 * RocketSocTBEnvBase.svh
 ****************************************************************************/

/**
 * Class: RocketSocTBEnvBase
 * 
 * TODO: Add class documentation
 */
class RocketSocTBEnvBase extends uvm_env;
	`uvm_component_utils(RocketSocTBEnvBase)
	
	uart_serial_agent			uart0;

	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction

	/**
	 * Function: build_phase
	 *
	 * Override from class 
	 */
	virtual function void build_phase(input uvm_phase phase);
		uart0 = uart_serial_agent::type_id::create("uart0", this);

	endfunction

	/**
	 * Function: connect_phase
	 *
	 * Override from class 
	 */
	virtual function void connect_phase(input uvm_phase phase);

	endfunction

	


endclass


