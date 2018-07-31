/*
 * app_startup.c
 *
 *  Created on: Jun 20, 2018
 *      Author: ballance
 */
#include "bmk.h"
#include "vmon_monitor.h"
#include <stdlib.h>

// Entry routine that is called once all cores are active
static void app_bmk_main(void) {
	vmon_monitor_tracepoint(20000);

	main();

	vmon_monitor_endtest(0);
}

extern unsigned char _end;
static unsigned char *heap_end = 0;

static unsigned int malloc_lock_var = 0;

void __malloc_lock(void) {
	bmk_atomics_lock(&malloc_lock_var);
}

void __malloc_unlock(void) {
	bmk_atomics_unlock(&malloc_lock_var);
}

void *_sbrk(unsigned int incr) {
	unsigned char *prev_heap_end;

	if (!heap_end) {
		heap_end = &_end;
	}
	prev_heap_end = heap_end;

	heap_end += incr;

	return prev_heap_end;
}

// Routine called by BMK to initialize cores
// Declare this weak to allow tests to override
__attribute__((weak))void app_bmk_level0_main(void) {
	volatile unsigned int *sp;
    unsigned int val = 27;

	// TODO:
	vmon_monitor_tracepoint(10000);
	sp = (unsigned int *)malloc(1024*16); // 16k stack should be fine

	sp[0] = 0;

	bmk_atomics_lock((bmk_atomic_t *)sp);

	vmon_monitor_tracepoint(val);

	bmk_set_bmk_main_func(&app_bmk_main);

	vmon_monitor_tracepoint(11000);

}



