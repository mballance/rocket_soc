/*
 * uex_rocket_soc_startup.h
 *
 *  Created on: Aug 17, 2018
 *      Author: ballance
 */

#ifndef INCLUDED_ROCKET_SOC_STARTUP_H
#define INCLUDED_ROCKET_SOC_STARTUP_H
#include "wb_periph_subsys.h"
#include "rocket_chip_plic_dev.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
	uart_agent,
	WB_PERIPH_SUBSYS_DEVID(periph_subsys),
	plic,
	sys_dma
} rocket_soc_devid_e;

void rocket_soc_startup(void);


#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_ROCKET_SOC_STARTUP_H */
