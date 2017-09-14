#define DRAM_BASE 0x80000000
#define MMIO_BASE 0x60000000

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

  li a0, MMIO_BASE
  li a1, 0
1:
  sw a1, 0(a0)
  add a1, a1, 1
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


