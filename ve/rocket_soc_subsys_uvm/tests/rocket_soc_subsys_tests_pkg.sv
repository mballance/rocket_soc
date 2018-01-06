

`include "uvm_macros.svh"
package rocket_soc_subsys_tests_pkg;
	import uvm_pkg::*;
	import rocket_soc_subsys_env_pkg::*;
	import hella_cache_master_agent_pkg::*;
	import sv_bfms_api_pkg::*;
	import googletest_uvm_pkg::*;
	
	`include "rocket_soc_subsys_test_base.svh"
    `include "rocket_soc_subsys_smoke_test.svh"
    `include "rocket_soc_subsys_par_test.svh"
    `include "rocket_soc_subsys_api_mem_test.svh"
    `include "rocket_soc_subsys_false_sharing.svh"
    `include "rocket_soc_subsys_false_sharing_stepped.svh"
    `include "rocket_soc_subsys_unit_test.svh"
	
endpackage
