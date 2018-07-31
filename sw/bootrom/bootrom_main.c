/**
 * bootrom_main()
 */
#include <stdint.h>
#include <sys/types.h>
#include "vmon_monitor.h"
#include "bmk_sys_services.h"
//#include "wb_uart_regs.h"
//#include "rocket_soc_memmap.h"

void bootrom_main(uint32_t hartid) {
#ifdef UNDEFINED
	volatile wb_uart_regs_t *regs = (volatile wb_uart_regs_t *)ROCKET_SOC_UART0_BASE;

	// Initialize the UART
	regs->lcr |= 0x80; // Enable access to DLB
	regs->dlb2 = 0;
//	regs->dlb1 = 14; // 115200 @ 25mhz
	regs->dlb1 = 27; // 115200 @ 50mhz
	regs->lcr &= ~0x80; // Disable access to DLB

    vmon_monitor_init(&prv_vmon);
    vmon_monitor_add_h2m_path(&prv_vmon, &vmon_h2m_uart, 0);
    vmon_monitor_add_m2h_path(&prv_vmon, &vmon_m2h_uart, 0);

    vmon_monitor_run(&prv_vmon);
#endif
}

// Implementation for vmon atomics
void vmon_monitor_atomic_init(unsigned int *l) {
	bmk_atomics_init((bmk_atomic_t *)l);
}

void vmon_monitor_atomic_lock(unsigned int *l) {
	bmk_atomics_lock((bmk_atomic_t *)l);
}

void vmon_monitor_atomic_unlock(unsigned int *l) {
	bmk_atomics_unlock((bmk_atomic_t *)l);
}

// bootrom function for sending vmon data to the testbench
static int32_t bootrom_main_m2h(void *ud, uint8_t *data, uint32_t sz) {

	switch (sz) {
	case 1: *((uint8_t *)0x60001000) = data[0]; break;
	case 2: *((uint16_t *)0x60001000) = (data[0] | (data[1] << 8)); break;
	case 4: *((uint32_t *)0x60001000) = (
			data[0] |
			(data[1] << 8) |
			(data[2] << 16) |
			(data[3] << 24)); break;
	default:
		break;
	}

	return sz;
}

void bmk_core0_init(void) {
	vmon_monitor_init();

	vmon_monitor_add_m2h_path(&bootrom_main_m2h, 0);

	vmon_monitor_tracepoint(10);
	vmon_monitor_tracepoint(20);
	vmon_monitor_tracepoint(30);
	vmon_monitor_tracepoint(40);

	vmon_monitor_msg("Hello World!\n");

	// Set the entry point for the RAM application
	bmk_set_level0_main_func((bmk_main_f)0x40001000);
}


