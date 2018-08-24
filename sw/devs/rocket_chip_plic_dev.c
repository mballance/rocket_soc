/*
 * rocket_chip_plic_dev.c
 *
 *  Created on: Aug 23, 2018
 *      Author: ballance
 */
#include "rocket_chip_plic_dev.h"
#include <stdio.h>

typedef struct rocket_chip_plic_priority_regs_s {
	uint32_t		priority[512];
} rocket_chip_plic_priority_regs_t;

typedef struct rocket_chip_plic_pending_regs_s {
	uint32_t		pending[512/32];
} rocket_chip_plic_pending_regs_t;

typedef struct rocket_chip_plic_enable_s {
	uint32_t		enable[512/32];
	uint32_t		pad[16];
} rocket_chip_plic_enable_t;

typedef struct rocket_chip_plic_enable_regs_s {
	rocket_chip_plic_enable_t		enable[4];
} rocket_chip_plic_enable_regs_t;

typedef struct rocket_chip_plic_context_s {
	uint32_t		threshold;
	uint32_t		claim;
	uint32_t		pad[(0x1000-2)/sizeof(uint32_t)];
} rocket_chip_plic_context_t;

typedef struct rocket_chip_plic_context_regs_s {
	rocket_chip_plic_context_t		context[4];
} rocket_chip_plic_context_regs_t;

void rocket_chip_plic_dev_init(uex_dev_t *devh) {
	rocket_chip_plic_dev_t *dev = (rocket_chip_plic_dev_t *)devh;
	int i;

	fprintf(stdout, "--> rocket_chip_plic_dev_init\n");
	fflush(stdout);

	dev->priority = (rocket_chip_plic_priority_regs_t *)uex_ioremap(
			devh->addr, sizeof(rocket_chip_plic_priority_regs_t), 0);
	dev->pending = (rocket_chip_plic_pending_regs_t *)uex_ioremap(
			devh->addr+0x1000, sizeof(rocket_chip_plic_pending_regs_t), 0);
	dev->enable = (rocket_chip_plic_enable_regs_t *)uex_ioremap(
			devh->addr+0x2000, sizeof(rocket_chip_plic_enable_regs_t), 0);
	dev->context = (rocket_chip_plic_context_regs_t *)uex_ioremap(
			devh->addr+0x200000, sizeof(rocket_chip_plic_context_regs_t), 0);

	//
	for (i=0; i<1; i++) {
		int irq;
		uex_iowrite32(0, (dev->base.addr + 0x200000 + i*0x1000));

		// Disable all interrupts initially
		for (irq=0; irq<512; irq++) {
		}
	}

	fprintf(stdout, "<-- rocket_chip_plic_dev_init\n");
	fflush(stdout);
}

void rocket_chip_plic_dev_en_irq(uint32_t devid, uint32_t irq, uint32_t en) {
	rocket_chip_plic_dev_t *dev = (rocket_chip_plic_dev_t *)uex_get_device(devid);
	uint32_t enable;

	// Write <en> in the priority field
	fprintf(stdout, "enable_irq=%d: priority_addr=%p\n", irq, (dev->base.addr+4*irq));
	uex_iowrite32(en, (dev->base.addr + 4*irq));

	// Enable the interrupt to HART0
	fprintf(stdout, "enable irq=%d: enable_addr=%p\n", irq,
			&dev->enable->enable[0].enable[irq/32]);
	enable = uex_ioread32(&dev->enable->enable[0].enable[irq/32]);
	if (en) {
		enable |= (1 << (irq%32));
	} else {
		enable &= ~(1 << (irq%32));
	}
	uex_iowrite32(enable, &dev->enable->enable[0].enable[irq/32]);

}

uint32_t rocket_chip_plic_dev_claim(uint32_t devid) {
	uint32_t claim;
	rocket_chip_plic_dev_t *dev = (rocket_chip_plic_dev_t *)uex_get_device(devid);

	claim = uex_ioread32(dev->base.addr + 0x200000 + 0*0x1000 + 0x04);

	return claim;
}

void rocket_chip_plic_dev_ack(uint32_t devid, uint32_t irq) {
	rocket_chip_plic_dev_t *dev = (rocket_chip_plic_dev_t *)uex_get_device(devid);

	uex_iowrite32(irq, dev->base.addr + 0x200000 + 0*0x1000 + 0x04);
}

