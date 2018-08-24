/*
 * uex_startup.c
 *
 *  Created on: Aug 17, 2018
 *      Author: ballance
 */
#include "uex_rocket_soc_startup.h"
#include "vmon_uart_agent.h"
#include <stdio.h>


//// - Statically creating storage for each device
//// - Specifying key device information (init function, base address, etc)
//typedef struct wb_periph_subsys_s {
//	wb_uart_uex_drv_t			uart;
//	wb_dma_uex_drv_t			dma;
//
//} wb_periph_subsys_t;

typedef struct rocket_soc_s {
	wb_periph_subsys_t			periph_subsys;
	rocket_chip_plic_dev_t		plic;
} rocket_soc_t;

static rocket_soc_t rocket_soc_devs = {
		.periph_subsys = WB_PERIPH_SUBSYS_DEV_STATIC_INIT("periph_subsys", 0x60000000),
		.plic = ROCKET_CHIP_PLIC_DEV_STATIC_INIT("plic", 0x0C000000)
};

// List of devices in the system
static uex_dev_t *devices[] = {
		WB_PERIPH_SUBSYS_DEVICES(rocket_soc_devs.periph_subsys),
		&rocket_soc_devs.plic.base
};

static void rocket_soc_isr(void *ud) {
	uint32_t claim;
	fprintf(stdout, "--> rocket_soc_isr\n");
	fflush(stdout);

	// Assume we're running on hart0
	claim = rocket_chip_plic_dev_claim(plic);
	fprintf(stdout, "  claim=%d\n", claim);
	fflush(stdout);
	if (claim == 1) {
		uint32_t i;
		// peripheral subsystem
		uint32_t pending = wb_simple_pic_dev_get_pending(periph_subsys_pic);
		fprintf(stdout, "pending=0x%08x\n", pending);
		fflush(stdout);
		for (i=0; i<32; i++) {
			if (pending & (1 << i)) {
				switch (i) {
				case 0:
					uex_trigger_irq(periph_subsys_dma);
					break;
				case 1:
					uex_trigger_irq(periph_subsys_uart);
					break;
				default:
					fprintf(stdout, "Error: unknown PIC interrupt %d\n", i);
					fflush(stdout);
					break;
				}
				wb_simple_pic_dev_clr_pending(periph_subsys_pic, i);
			}
		}
	} else {
		fprintf(stdout, "Error: unexpected claim=%d\n", claim);
		fflush(stdout);
	}
	rocket_chip_plic_dev_ack(plic, claim);

	fprintf(stdout, "<-- rocket_soc_isr\n");
	fflush(stdout);

}



// - Device tree generator creates
//   - Enum for C, SV, and PSS environments encoding device mapping
//   - C static structures to build up device tree
//   - SV class that constructs the device tree
//   - PSS component tree with initialization of device IDs
//
//
// - Assume all drives follows prescribed format
// - Assume all device components extend pvm::device_c
// - TEMP: Assume all device actions extend pvm::device_a
//
// - Who should setup mapping to interrupts?
//
// - Assume

void rocket_soc_startup(void) {

	// Initialize the core
	uex_init(devices, sizeof(devices)/sizeof(uex_dev_t *));

	uex_set_irq_handler(&rocket_soc_isr, 0);

	// Enable interrupts
	wb_simple_pic_dev_en_irq(periph_subsys_pic, 0, 1);
	wb_simple_pic_dev_en_irq(periph_subsys_pic, 1, 1);

	rocket_chip_plic_dev_en_irq(plic, 1, 1);
//	rocket_chip_plic_dev_en_irq(plic, 2, 1);

	uart_agent_dev_tx(1, 5, 20);
}



