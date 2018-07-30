#include <stdio.h>
#include "vmon_monitor.h"

// #include "rocket_soc_uex_devtree.h"

int main(void) {

	vmon_monitor_tracepoint(30000);

	vmon_monitor_msg("Hello from nulltest");

//	rocket_soc_devtree_init();

//	volatile unsigned int *addr = (volatile unsigned int *)0x60000000;
//
//	volatile uint8_t *uart = (uint8_t *)addr;
//	uint32_t val;
//
//	val = uart[3];
//	val |= 0x80;
//	uart[3] = val;
//
//	uart[1] = 0;
//	uart[0] = 14; // 115200
//
//	val &= ~0x80;
//	uart[3] = val;
//
//	do {
//		val = uart[5];
//	} while ((val & 0x40) == 0);
//
//	uart[0] = 0x55;

	return 1;
}

