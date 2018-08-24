/*
 * rocket_soc_uex_devtree.c
 *
 *  Created on: Oct 22, 2017
 *      Author: ballance
 */

#include "rocket_soc_uex_devtree.h"

#include "../../../oc_wb_ip/rtl/wb_uart/fw/wb_uart_dev.h"
#include "rocket_soc_memmap.h"
#include "uex_dev_services.h"

static uex_devtree_t root_devtree = {
		.name = "dev",
		.parent = 0,
		.sibling = 0,
		.next = 0,
		.devices = {
				{
						.name = "uart0",
						.type = UEX_DEV_CHAR,
						.addr = (void *)ROCKET_SOC_UART0_BASE,
						.init = &wb_uart_uex_drv_init,
						.irqs = {0},
						.n_irqs = 1
				}
		}/*,
        {
                "PIC",
                (void *)MOR1KX_PIC_BASE,
                64,
                {},
                0
        },
        {
                "DMA0",
                (void *)MOR1KX_DMA0_BASE,
                256,
                {MOR1KX_DMA0_IRQ},
                1
        },
        {
                "FPIO0",
                (void *)MOR1KX_FPIO0_BASE,
                64,
                {MOR1KX_FPIO0_IRQ},
                1
        }
         */
};

void rocket_soc_devtree_init(void) {

    uex_devtree_init(root_devtree);

    wb_uart_uex_drv_init(
            &rocket_soc_devtree.uart0,
			ROCKET_SOC_UART0_BASE,
            14); // 115200baud

}



