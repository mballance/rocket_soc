
#include "gtest/gtest.h"
#include "uex.h"
#include "vmon_monitor.h"
#include "wb_uart_regs.h"

// static vmon_monitor_t		mon;

static int32_t m2h(void *addr, uint8_t *data, uint32_t sz) {
	wb_uart_regs_t *uart = (wb_uart_regs_t *)addr;
	uint8_t val;
	for (uint32_t i=0; i<sz; i++) {
		do {
			val = uex_ioread8(&uart->lsr);
		} while ((val & 0x40) == 0);

		uex_iowrite8(data[i], &uart->thr);
	}
	return sz;
}

static int32_t h2m(void *addr, uint8_t *data, uint32_t sz) {
	wb_uart_regs_t *uart = (wb_uart_regs_t *)addr;
	uint8_t val;
	uint32_t idx = 0;

	for (uint32_t i=0; i<sz; i++) {
		do {
			val = uex_ioread8(&uart->lsr);
		} while (i == 0 && (val & 1) == 0);

		if ((val & 1) != 0) {
			data[idx++] = uex_ioread8(&uart->rbr);
		} else {
			break;
		}
	}

	return idx;
}

static void init_vmon() {
	wb_uart_regs_t *uart = (wb_uart_regs_t *)0x60000000;
	wb_uart_lcr_u lcr;
	uint8_t val = 0;

//	vmon_monitor_init(&mon);

	// Initialize UART
	lcr.val = uex_ioread8(&uart->lcr);
	lcr.fields.dlab = 1;
	uex_iowrite8(lcr.val, &uart->lcr);
	uex_iowrite8(0, &uart->dlb2);
	uex_iowrite8(27, &uart->dlb1);

	lcr.fields.dlab = 0;
	uex_iowrite8(lcr.val, &uart->lcr);

	{
		uint8_t data = 0x5A;
		m2h(uart, &data, 1);
	}

//	vmon_monitor_add_m2h_path(&mon, &m2h, uart);
//	vmon_monitor_add_h2m_path(&mon, &h2m, uart);
}

TEST(rocket_soc_subsyste_uex_vmon_tests,smoke) {
	uex_init();

//	init_vmon();

//	vmon_monitor_run(&mon);
}
