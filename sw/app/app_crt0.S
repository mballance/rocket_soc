/****************************************************************************
 * app_crt0.S
 *
 *
 ****************************************************************************/

#define MEM_BASE 0x80000000
#define MMIO_BASE 0x60000000

// TODO:
// - Setup new stack
// - Save old stack pointer to new stack
//
// SP=X2 (top-down stack)

.section .app_crt0, "ax", @progbits
.globl _app_entry
_app_entry:

// TODO: save register state onto caller's stack
  mv  x1, x0
//  mv  x2, x1 // Don't smash stack from caller

// Setup stack
  la  x2, _stack_top
  add x2, x2, -8
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

  /* clear BSS */
  la x26, _bss_start
  la x27, _bss_end

  bge x26, x27, zero_loop_end

zero_loop:
  sw x0, 0(x26)
  addi x26, x26, 4
  ble x26, x27, zero_loop
zero_loop_end:


  call    __libc_init_array

  /* jump to main program entry point (argc = argv = 0) */
  addi x10, x0, 0
  addi x11, x0, 0
  jal x1, main

1:
	j 1b

  // TODO: Restore previous stack
  // Jump-return to caller


