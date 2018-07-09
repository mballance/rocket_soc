/*
 * traffic_test_utils.h
 *
 *  Created on: Jan 18, 2018
 *      Author: ballance
 */
#include "uex.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct closure_base_s {
	void (*func)(struct closure_base_s *);
	struct closure_base_s		*next;
	uint32_t					busy;
} closure_base_t;


void queue_false_share(
		uint8_t 	core,
		uint64_t 	addr,
		uint32_t 	line_off,
		uint32_t 	num_iterations);

void queue_true_share(
		uint8_t			core,
		uint8_t			pair_core,
		uint64_t		addr,
		uint32_t		size,
		uint32_t		num_iterations);

void queue_fill_data(
		uint8_t			core,
		uint64_t		addr,
		uint32_t		size,
		uint32_t		num_iterations);

void queue_read_accum(
		uint8_t			core,
		uint64_t		addr,
		uint32_t		size,
		uint32_t		num_iterations);

void launch_traffic(void);


#ifdef __cplusplus
}
#endif




