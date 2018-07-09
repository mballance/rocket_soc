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

TEST(rocket_soc_subsys,basic_mem_access) {
	uex_init();

	for (uint32_t i=0; i<16; i++) {
		uint32_t val;
		uex_iowrite32((i+1), (void *)0x60000000);
//		val = uex_ioread32((void *)0x60000000);

//		if (val != (i+1)) {
//			fprintf(stdout, "Error: expect 0x%08x receive 0x%08x\n",
//					(i+1), val);
//		}
	}
	fprintf(stdout, "Hello from rocket_soc_subsys::api_mem_test\n");

}

TEST(rocket_soc_subsys,false_share_4) {
	int active_cores = 4;

	uex_init();

	for (int i=0; i<active_cores; i++) {
		queue_false_share(i, (void *)0x80000000, 4*i, 1000);
	}

	launch_traffic();
}

TEST(rocket_soc_subsys,true_share_4) {
	int active_cores = 4;

	for (int i=0; i<active_cores/2; i++) {
		uint32_t addr_v = 0x80000000 + 0x1000*i;
//		queue_true_share(2*i, 2*i+1, (void *)addr_v, 0x1000/4, 10);
	}

	launch_traffic();
}

