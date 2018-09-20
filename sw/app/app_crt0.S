/****************************************************************************
 * app_crt0.S
 *
 *
 ****************************************************************************/


#define MEM_BASE 0x80000000
#define MMIO_BASE 0x60000000

#define TRACEPOINT(x)

// TODO:
// - Setup new stack
// - Save old stack pointer to new stack
//
// SP=X2 (top-down stack)

.section .data
lock_word: .word 0

.section .app_crt0, "ax", @progbits
.globl _app_entry
_app_entry:

// Save stack space and store the link address
addi	sp, sp, -24
sd		gp, 16(sp)
sd		ra, 8(sp)
sd		s0, 0(sp)
addi	s0, sp, 24

// Initialize the global pointer
.option push
.option norelax
la gp, __global_pointer$
.option pop

TRACEPOINT(1000)

//la		t0, lock_word
//lr.w	t1, (t0)
//addi	t1, t1, 1
//sc.w	t0, t1, (t0)

TRACEPOINT(2000)
  /* clear application's BSS */
  la t1, __bss_start
  la t2, __bss_end

  bge t1, t2, zero_loop_end

zero_loop:
  sw zero, 0(t1)
  addi t1, t1, 4
  ble t1, t2, zero_loop
zero_loop_end:

TRACEPOINT(3000)

/*  jal x1, __libc_init_array */
/*  call    __libc_init_array */

  /* Call the initialization function */
  jal ra, app_bmk_level0_main

TRACEPOINT(4000)

  // Return back to BMK who will call back the real main
  nop
  ld		gp, 16(sp)
  ld		ra, 8(sp)
  ld		s0, 0(sp)
  addi		sp, sp, 24
  ret
  nop

/**
 * This function exists to properly initialize
 * the 'gp' before re-entering application C code
 */
.globl app_bmk_main_wrapper
app_bmk_main_wrapper:
// Initialize the global pointer
.option push
.option norelax
la gp, __global_pointer$
.option pop
  jal app_bmk_main

// TODO: will need a wrapper for non-C0 code
// entering into application space

TRACEPOINT(5000)
1:
	j 1b


