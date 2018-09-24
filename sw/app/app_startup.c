/*
 * app_startup.c
 *
 *  Created on: Jun 20, 2018
 *      Author: ballance
 */
#include "bmk.h"
#include "vmon_monitor.h"
#include "rocket_soc_app.h"
#include <stdlib.h>
#include <stdint.h>

void app_bmk_main_wrapper(void);

// Entry routine that is called once all cores are active
void app_bmk_main(void) {
	rocket_soc_app_pre_main();

	main();

	rocket_soc_app_post_main();

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
	unsigned int *sp = 0;

	vmon_monitor_msg("Level0_main");
//	bmk_info_low("Level0_main");

	// TODO:
	// Probably should
	sp = (unsigned int *)malloc(1024*16); // 16k stack should be fine
	bmk_init_core(0, sp, 1024*16);

	// Call the initialization hook
	rocket_soc_app_init();

	bmk_set_bmk_main_func(&app_bmk_main_wrapper);
}



