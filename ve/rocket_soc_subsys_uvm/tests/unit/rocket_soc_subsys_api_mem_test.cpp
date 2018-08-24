/*
 * rocket_soc_subsys_api_mem_test.cpp
 *
 *  Created on: Jan 1, 2018
 *      Author: ballance
 */
#include "gtest/gtest.h"
#include "uex.h"
#include <stdio.h>
#include "traffic_test_utils.h"
#include "uex_rocket_soc_startup.h"
#include "vmon_monitor.h"

static int32_t unit_test_m2h(void *ud, uint8_t *data, uint32_t sz) {
	fprintf(stdout, "unit_test_m2h: sz=%d\n", sz);
	fflush(stdout);

	switch (sz) {
	case 1: uex_iowrite8(data[0], (uint8_t *)0x60001000); break;
	case 2: uex_iowrite16((data[0] | (data[1] << 8)), (uint16_t *)0x60001000); break;
	case 4: uex_iowrite32(
			( data[0] |
			(data[1] << 8) |
			(data[2] << 16) |
			(data[3] << 24)), (uint32_t *)0x60001000); break;
	default:
		break;
	}
	/*
	 */

	return sz;
}

TEST(rocket_soc_subsys,basic_mem_access) {
	// Initialize vmon, since the boot code would normally do that

	rocket_soc_startup();

	for (uint32_t i=0; i<16; i++) {
		uint32_t val;
//		uex_iowrite32((i+1), 0x60000000);
//		val = uex_ioread32((void *)0x60000000);

//		if (val != (i+1)) {
//			fprintf(stdout, "Error: expect 0x%08x receive 0x%08x\n",
//					(i+1), val);
//		}
	}
	fprintf(stdout, "Hello from rocket_soc_subsys::api_mem_test\n");

}

TEST(rocket_soc_subsys,uart_tx) {
	const char *msg = "Hello World!";
	int i;
	fprintf(stdout, "--> vmon_monitor_init\n");
	vmon_monitor_init();
	vmon_monitor_add_m2h_path(&unit_test_m2h, 0);
	fprintf(stdout, "<-- vmon_monitor_init\n");

//	fprintf(stdout, "--> vmon_monitor_tracepoint\n");
//	fflush(stdout);
//	vmon_monitor_tracepoint(10);
//	fprintf(stdout, "<-- vmon_monitor_tracepoint\n");
//	fflush(stdout);

	fprintf(stdout, "--> startup\n");
	fflush(stdout);
	rocket_soc_startup();
	fprintf(stdout, "<-- startup\n");
	fflush(stdout);

	for (i=0; i<16; i++) {
		const char *p = msg;
		while (*p) {
			fprintf(stdout, "--> tx %c\n", *p);
			fflush(stdout);
			wb_uart_dev_tx(periph_subsys_uart, *p);
			fprintf(stdout, "<-- tx %c\n", *p);
			fflush(stdout);
			p++;
		}
	}
}

TEST(rocket_soc_subsys,false_share_4) {
	int active_cores = 4;

	rocket_soc_startup();

	for (int i=0; i<active_cores; i++) {
		queue_false_share(i, 0x40000000, 4*i, 1000);
	}

	launch_traffic();
}

TEST(rocket_soc_subsys,true_share_4) {
	int active_cores = 4;

	for (int i=0; i<active_cores/2; i++) {
		uint32_t addr_v = 0x40000000 + 0x1000*i;
//		queue_true_share(2*i, 2*i+1, (void *)addr_v, 0x1000/4, 10);
	}

	launch_traffic();
}

