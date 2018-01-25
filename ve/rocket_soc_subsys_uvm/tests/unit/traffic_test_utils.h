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
		void 		*addr,
		uint32_t 	line_off,
		uint32_t 	num_iterations);

void queue_true_share(
		uint8_t			core,
		uint8_t			pair_core,
		void			*addr,
		uint32_t		size,
		uint32_t		num_iterations);

void launch(void);


#ifdef __cplusplus
}
#endif

//    	attributes queue_true_share {
//    		action_stmt = "fprintf(stdout, \"queue_true_share %d <-> %d start=%d size=%d, num_iterations=%d\n\",
//    			(*${item})[\"${inst_parent}.core\"],
//    			(*${item})[\"${inst_parent}.pair_core\"],
//    			(*${item})[\"${inst_parent}.start\"],
//    			(*${item})[\"${inst_parent}.size\"],
//    			(*${item})[\"${inst_parent}.num_iterations\"]);";
//    	}
//    	attributes queue_fill_data {
//    		action_stmt = "fprintf(stdout, \"queue_fill_data core=%d start=%d size=%d num_iterations=%d\n\",
//    			(*${item})[\"${inst_parent}.core\"],
//    			(*${item})[\"${inst_parent}.start\"],
//    			(*${item})[\"${inst_parent}.size\"],
//    			(*${item})[\"${inst_parent}.num_iterations\"]);
//    			";
//    	}
//    	attributes queue_read_accum {
//    		action_stmt = "fprintf(stdout, \"queue_read_accum core=%d start=%d size=%d num_iterations=%d\n\",
//    			(*${item})[\"${inst_parent}.core\"],
//    			(*${item})[\"${inst_parent}.start\"],
//    			(*${item})[\"${inst_parent}.size\"],
//    			(*${item})[\"${inst_parent}.num_iterations\"]);
//    			";



