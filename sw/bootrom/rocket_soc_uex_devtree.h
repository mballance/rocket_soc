/*
 * rocket_soc_uex_device_tree.h
 *
 *  Created on: Oct 22, 2017
 *      Author: ballance
 */

#ifndef SW_BOOTROM_ROCKET_SOC_UEX_DEVTREE_H_
#define SW_BOOTROM_ROCKET_SOC_UEX_DEVTREE_H_
#include "uex.h"
// #include "wb_dma_uex_drv.h"
// #include "simple_pic_drv.h"
#include "wb_uart_uex_drv.h"
// #include "fpio_uex_drv.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct rocket_soc_devtree_s {
//    simple_pic_drv_t            pic;
//    wb_dma_uex_drv_t            dma0;
    wb_uart_uex_drv_t           uart0;
//    fpio_uex_drv_t              fpio0;

} rocket_soc_devtree_t;

extern rocket_soc_devtree_t     rocket_soc_devtree;

void rocket_soc_devtree_init(void);


#ifdef __cplusplus
}
#endif


#endif /* SW_BOOTROM_ROCKET_SOC_UEX_DEVTREE_H_ */
