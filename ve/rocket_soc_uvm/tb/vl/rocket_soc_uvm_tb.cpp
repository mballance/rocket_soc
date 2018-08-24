/*
 * rocket_soc_uvm_tb.cpp
 *
 *  Created on: Jul 29, 2018
 *      Author: ballance
 */
#include <stdio.h>
#include "VRocketSocTBHdl.h"

static double timestamp = 0;
double sc_time_stamp() {
	return timestamp;
}

extern "C" {
  unsigned int uart_serial_bfm_register(const char *path) {
	  fprintf(stdout, "uart_serial_bfm_register %s\n", path);
	  return 0;
  }

  int uart_serial_bfm_reset(unsigned int id) {
	  fprintf(stdout, "uart_serial_bfm_reset\n");
	  return 0;
  }

  int uart_serial_bfm_tx_done(unsigned int id) {
	  fprintf(stdout, "uart_serial_bfm_tx_done\n");
	  return 0;
  }

  int uart_serial_bfm_rx_done(unsigned int id, unsigned char data) {
	  fprintf(stdout, "uart_serial_bfm_rx_done\n");
	  return 0;
  }

  unsigned int wb_vmon_monitor_register(const char *path) {
	  fprintf(stdout, "wb_vmon_monitor_register %s\n", path);
	  return 0;
  }

  int wb_vmon_monitor_write(unsigned int id, unsigned long long data, unsigned int size) {
	  fprintf(stdout, "wb_vmon_monitor_write %llx %d\n", data, size);
	  return 0;
  }

}

int main(int argc, char **argv) {
	fprintf(stdout, "Hello from rocket_soc_uvm_tb\n");

	VRocketSocTBHdl *top = new VRocketSocTBHdl();

	Verilated::commandArgs(argc, argv);

	for (int i=0; i<10000; i++) {
		top->clock = !top->clock;
		timestamp += 5;

		top->eval();
	}

	delete top;


}



