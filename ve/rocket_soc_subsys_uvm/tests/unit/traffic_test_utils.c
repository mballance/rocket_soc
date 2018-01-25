/*
 * traffic_test_utils.c
 *
 *  Created on: Jan 18, 2018
 *      Author: ballance
 */
#include "traffic_test_utils.h"
#include <string.h>
#include <stdio.h>

#ifndef MAX_CORES
#define MAX_CORES 16
#endif

#ifndef MAX_TASKS_PER_CORE
#define MAX_TASKS_PER_CORE 64
#endif


typedef struct closure_max_s {
	closure_base_t		base;
	uint64_t			params[64];
} closure_max_t;

static struct closure_pool_s {
	uint32_t			alloc_idx;
	closure_max_t		closures[MAX_CORES*MAX_TASKS_PER_CORE];
} closure_pool = {0};


typedef struct scenario_data_s {
	closure_base_t			*cores[MAX_CORES];
	uex_thread_t			threads[MAX_CORES];
} scenario_data_t;

static scenario_data_t scenario_data = {0};


closure_base_t *alloc_closure(closure_base_t *head) {
	closure_base_t *ret = 0;
	uint32_t i;

	for (i=0; i<1024; i++) {
		if (!closure_pool.closures[closure_pool.alloc_idx].base.busy) {
			ret = &closure_pool.closures[closure_pool.alloc_idx].base;
			ret->next = 0;
		}
		closure_pool.alloc_idx = ((closure_pool.alloc_idx+1) % 1024);
		if (ret) {
			break;
		}
	}

	if (head) {
		head->next = ret;
	}

	return ret;
}


// Core thread function
static int core_run(void *ud) {
	closure_base_t *c = (closure_base_t *)ud;

	while (c) {
		c->func(c);
		c->busy = 0;
		c = c->next;
	}

	return 0;
}

void run_false_share(void *addr, uint32_t line_off, uint32_t num_iterations) {
	uint32_t i;
	uint32_t *ptr = (uint32_t *)addr;

	for (i=0; i<num_iterations; i++) {
		uint32_t rdata;
		uex_iowrite32((i+1), &ptr[line_off]);
		rdata = uex_ioread32(&ptr[line_off]);

		if (rdata != i+1) {
			fprintf(stdout, "run_false_share: Read-back error 0x%08x != 0x%08x\n",
					rdata, (i+1));
		}
	}
}

typedef struct false_share_data_s {
	closure_base_t		base;
	void				*addr;
	uint32_t			line_off;
	uint32_t			num_iterations;
} false_share_data_t;

void run_false_share_c(closure_base_t *ud) {
	false_share_data_t *data = (false_share_data_t *)ud;

	run_false_share(data->addr, data->line_off, data->num_iterations);
}

void queue_false_share(uint8_t core, void *addr, uint32_t line_off, uint32_t num_iterations) {
	false_share_data_t *data;

	scenario_data.cores[core] = alloc_closure(scenario_data.cores[core]);
	data = (false_share_data_t *)scenario_data.cores[core];

	data->base.func = &run_false_share_c;
	data->addr = addr;
	data->line_off = line_off;
	data->num_iterations = num_iterations;
}

static void run_true_share(
		void *addr,
		uint32_t size,
		uint32_t num_iterations,
		uint8_t role,
		uex_mutex_t *pp_mutex1,
		uex_cond_t *pp_cond1,
		uex_mutex_t *pp_mutex2,
		uex_cond_t *pp_cond2,
		uint8_t *src_ready,
		uint8_t *dst_ready) {
	uint32_t *addr_p = (uint32_t *)addr;

	fprintf(stdout, "run_true_share: my_role=%d\n", role);

	if (role == 0) {
		// I'm the data sender
		for (uint32_t n=0; n<num_iterations; n++) {
			fprintf(stdout, "  writer iteration %d\n", n);
			for (uint32_t i=0; i<size; i++) {
				uex_iowrite32(n+i+1, &addr_p[i]);
			}

			// Now, trigger the waiter
			uex_mutex_lock(pp_mutex1);
			*src_ready = 1;
			uex_cond_signal(pp_cond1);
			uex_mutex_unlock(pp_mutex1);

			// Wait for ack from the reader
			uex_mutex_lock(pp_mutex2);
			while (!*dst_ready) {
				uex_cond_wait(pp_cond2, pp_mutex2);
			}
			*dst_ready = 0;
			uex_mutex_unlock(pp_mutex2);

			// read back
			for (uint32_t i=0; i<size; i++) {
				uint32_t rdata;
				rdata = uex_ioread32(&addr_p[i]);

				if (rdata != (n+i+1)) {
					fprintf(stdout, "Error: read-back %p = %d\n",
							&addr_p[i], rdata);
				}
			}
		}
	} else if (role == 1) {

		for (uint32_t n=0; n<num_iterations; n++) {
			fprintf(stdout, "  reader iteration %d\n", n);

			// Wait for the writer
			uex_mutex_lock(pp_mutex1);
			while (!*src_ready) {
				uex_cond_wait(pp_cond1, pp_mutex1);
			}
			*src_ready = 0; // got the message
			uex_mutex_unlock(pp_mutex1);

			// Read all the data back
			for (uint32_t i=0; i<size; i++) {
				uex_ioread32(&addr_p[i]);
			}

			// Send an ack to the writer
			uex_mutex_lock(pp_mutex2);
			*dst_ready = 1;
			uex_cond_signal(pp_cond2);
			uex_mutex_unlock(pp_mutex2);
		}

	} else {
		fprintf(stdout, "FATAL: unknown role %d\n", role);
	}

}

typedef struct true_share_msg_data_s {
	uex_mutex_t			pp_mutex1;
	uex_cond_t			pp_cond1;
	uex_mutex_t			pp_mutex2;
	uex_cond_t			pp_cond2;
	uint8_t				src_ready;
	uint8_t				dst_ready;
} true_share_msg_data_t;

typedef struct true_share_data_s {
	closure_base_t			base;
	void					*addr;
	uint32_t				size;
	uint32_t				num_iterations;
	true_share_msg_data_t	*msg_data_p;
	true_share_msg_data_t	msg_data;
	uint8_t					role;
} true_share_data_t;

static void run_true_share_c(closure_base_t *ud) {
	true_share_data_t *data = (true_share_data_t *)ud;

	fprintf(stdout, "run_true_share_c: p=%p role=%d\n", data, data->role);

	run_true_share(
			data->addr,
			data->size,
			data->num_iterations,
			data->role,
			&data->msg_data_p->pp_mutex1,
			&data->msg_data_p->pp_cond1,
			&data->msg_data_p->pp_mutex2,
			&data->msg_data_p->pp_cond2,
			&data->msg_data_p->src_ready,
			&data->msg_data_p->dst_ready);
}

void queue_true_share(
		uint8_t 		core,
		uint8_t 		pair_core,
		void			*addr,
		uint32_t		size,
		uint32_t		num_iterations) {
	true_share_data_t *data1;
	true_share_data_t *data2;
	scenario_data.cores[core] = alloc_closure(scenario_data.cores[core]);
	data1 = (true_share_data_t *)scenario_data.cores[core];
	scenario_data.cores[pair_core] = alloc_closure(scenario_data.cores[pair_core]);
	data2 = (true_share_data_t *)scenario_data.cores[pair_core];

	data1->base.func = &run_true_share_c;
	data2->base.func = &run_true_share_c;

	data1->addr = data2->addr = addr;
	data1->size = data2->size = size;
	data1->num_iterations = data2->num_iterations = num_iterations;
	data1->msg_data_p = &data1->msg_data;
	data2->msg_data_p = &data1->msg_data;

	data1->role = 0;
	data2->role = 1;

	uex_mutex_init(&data1->msg_data.pp_mutex1);
	uex_mutex_init(&data1->msg_data.pp_mutex2);
	uex_cond_init(&data1->msg_data.pp_cond1);
	uex_cond_init(&data1->msg_data.pp_cond2);

	data1->msg_data.src_ready = 0;
	data1->msg_data.dst_ready = 0;

	fprintf(stdout, "queue_true_share: role0=%d role1=%d p0=%p p1=%p\n",
			data1->role, data2->role, data1, data2);
}

void launch(void) {
	int i;

	for (i=0; i<MAX_CORES; i++) {
		if (scenario_data.cores[i]) {
			uex_cpu_set_t cpuset;
			UEX_CPU_ZERO(cpuset);
			UEX_CPU_SET(cpuset, i);
			scenario_data.threads[i] = uex_thread_create_affinity(
					&core_run, scenario_data.cores[i], &cpuset);
		}
	}

	for (i=0; i<MAX_CORES; i++) {
		if (scenario_data.cores[i]) {
			uex_thread_join(scenario_data.threads[i]);
		}
	}

	// Finally, reset everything
	memset(&scenario_data, 0, sizeof(scenario_data_t));
}


