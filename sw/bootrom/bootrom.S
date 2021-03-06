#define DRAM_BASE 0x80000000
#define APP_ENTRY 0x80001000
#define MMIO_BASE 0x60000000
// #include "bmk_config.h"

#define TRACEPOINT(x) \
  li t0, 0x60001000; \
  li t1, 0x02a5; \
  sh t1, 0(t0); \
  li t1, x; \
  sll t1, t1, 8; \
  ori t1, t1, 0x05; \
  sw t1, 0(t0);


.section .text.start, "ax", @progbits
.globl _start
_start:

/* Copied from libgloss */
.option push
.option norelax
/*
1:auipc gp, %pcrel_hi(__global_pointer$)
  addi  gp, gp, %pcrel_lo(1b)
 */
.option pop

  mv  x1, x0 // Zero out x1
  mv  x2, x1
  mv  x3, x1
  mv  x4, x1
  mv  x5, x1
  mv  x6, x1
  mv  x7, x1
  mv  x8, x1
  mv  x9, x1
  mv x10, x1
  mv x11, x1
  mv x12, x1
  mv x13, x1
  mv x14, x1
  mv x15, x1
  mv x16, x1
  mv x17, x1
  mv x18, x1
  mv x19, x1
  mv x20, x1
  mv x21, x1
  mv x22, x1
  mv x23, x1
  mv x24, x1
  mv x25, x1
  mv x26, x1
  mv x27, x1
  mv x28, x1
  mv x29, x1
  mv x30, x1
  mv x31, x1

  // Initialize stack
  la x2, _stack_top
  add x2, x2, -8

  csrr x9, mhartid // HW Thread ID (core)
  bne x9, x0, 2
  li a0, 1
  TRACEPOINT(100)
1:
  TRACEPOINT(200)
  j 1b


2: // non-primary core
	j	2b


/*
  li x1, 4
  sll x1, x1, x9 // 4, 8, 10, etc
  li x3, DRAM_BASE
  add x3, x3, x1 // 0x8000_0000, 0x8000_0004, ...
  li x4, 0x00eeaa00
  sll x1, x9, 24 
  add x4, x4, x1
  li x6, 0xdeadbeef

1:
	sw x4, 0(x3)
	lw x4, 0(x3)
	addi	x4, x4, 1
	j	1b
	addi	x0, x0, 0
	addi	x0, x0, 0
	addi	x0, x0, 0
	addi	x0, x0, 0
 */

/*
1:
	sw x4, 0(x3)
	lw x5, 0(x3)
	beq x4, x5, 2
	sw x6, 0(x3)
2:
	addi	x4, x4, 1
	j	1b
	addi	x0, x0, 0
	addi	x0, x0, 0
	addi	x0, x0, 0
	addi	x0, x0, 0
 */

  /* clear BSS */
  la x26, _bss_start
  la x27, _bss_end

  bge x26, x27, zero_loop_end

zero_loop:
  sw x0, 0(x26)
  addi x26, x26, 4
  ble x26, x27, zero_loop
zero_loop_end:

  mv  a0, x0 // hartid
  jal x1, bootrom_main

  j _start // back to the beginning if we return

/*
1:
  li a0, 1
  add a0, a0, 1
  j 1b
 */

  li a0, APP_ENTRY
  jr a0

  li a0, MMIO_BASE
  li a1, 0
  li a2, DRAM_BASE
1:
  lw a1, 0(a2)
  sw a1, 0(a0)
//  lw a3, 0(a2)
//  lw a1, 0(a0)
  add a1, a1, 1
  add a2, a2, 4
  j 1b

  # Clear the bss segment
/* TODO:
  la      a0, _edata
  la      a2, _end
  sub     a2, a2, a0
  li      a1, 0
  call    memset
 */

/*
  la      a0, __libc_fini_array   # Register global termination functions
  call    atexit                  #  to be called upon exit
  call    __libc_init_array       # Run global initialization functions
 */

  lw      a0, 0(sp)                  # a0 = argc
  addi    a1, sp, __SIZEOF_POINTER__ # a1 = argv
  li      a2, 0                      # a2 = envp = NULL
  call    bootrom_main
//  tail    exit
  .size  _start, .-_start

  .global _init
  .type   _init, @function
  .global _fini
  .type   _fini, @function

/*
  csrr a0, mhartid // HW Thread ID (core)
  li a0, MMIO_BASE
  li a1, 0
1:
  sw a1, 0(a0)
  add a1, a1, 1
  j 1b
  */


