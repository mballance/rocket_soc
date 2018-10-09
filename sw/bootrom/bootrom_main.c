/**
 * bootrom_main()
 */
#include <stdint.h>
#include "vmon_monitor.h"
#include "bmk.h"
//#include "wb_uart_regs.h"
//#include "rocket_soc_memmap.h"

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
	uintptr_t addr = 0x61001000;
	volatile uint8_t *p8 = (uint8_t *)addr;
	volatile uint16_t *p16 = (uint16_t *)addr;
	volatile uint32_t *p32 = (uint32_t *)addr;

	switch (sz) {
	case 1:
		*p8 = data[0];
		break;
	case 2:
		*p16 = (data[0] | (data[1] << 8));
		break;
	case 3: {
		*p8 = data[0];
		*p16 = (data[1] | (data[2] << 8));
	} break;
	case 4:
		*p32 =
			data[0] |
			(data[1] << 8) |
			(data[2] << 16) |
			(data[3] << 24); break;
	default:
		break;
	}

	return sz;
}

void bmk_hardware_init(void) {
	vmon_monitor_init();
	vmon_monitor_add_m2h_path(&bootrom_main_m2h, 0);
}

// Implementation of bmk messaging and control
void bmk_sys_emit(const char *msg) {
	vmon_monitor_msg(msg);
}

void bmk_core0_init(void) {
	int i;

	// Set the entry point for the RAM application
	bmk_set_level0_main_func((bmk_main_f)0x40002000);
}


