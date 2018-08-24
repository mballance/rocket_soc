/****************************************************************************
 * rocket_chip_plic_dev.h
 ****************************************************************************/
#ifndef INCLUDED_ROCKET_CHIP_PLIC_DEV_H
#define INCLUDED_ROCKET_CHIP_PLIC_DEV_H
#include <uex.h>

#ifdef __cplusplus
extern "C" {
#endif

struct rocket_chip_plic_priority_regs_s;
struct rocket_chip_plic_pending_regs_s;
struct rocket_chip_plic_enable_regs_s;
struct rocket_chip_plic_context_regs_s;

typedef struct rocket_chip_plic_dev_s {
	uex_dev_t									base;
	struct rocket_chip_plic_priority_regs_s		*priority;
	struct rocket_chip_plic_pending_regs_s		*pending;
	struct rocket_chip_plic_enable_regs_s		*enable;
	struct rocket_chip_plic_context_regs_s		*context;

} rocket_chip_plic_dev_t;

#define ROCKET_CHIP_PLIC_DEV_STATIC_INIT(__name, __base_addr) { \
	.base = UEX_DEV_STATIC_INIT(__name, __base_addr, rocket_chip_plic_dev_init) \
}

void rocket_chip_plic_dev_init(uex_dev_t *devh);

void rocket_chip_plic_dev_en_irq(uint32_t devid, uint32_t irq, uint32_t en);

uint32_t rocket_chip_plic_dev_claim(uint32_t devid);

void rocket_chip_plic_dev_ack(uint32_t devid, uint32_t irq);

#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_ROCKET_CHIP_PLIC_DEV_H */


