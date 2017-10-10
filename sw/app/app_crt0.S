

#define MEM_BASE 0x80000000
#define MMIO_BASE 0x60000000

.section .app_crt0, "ax", @progbits
.globl _start
_start:

  li a0, MMIO_BASE
  li a1, 1
  li a2, 0xF000003F
  li a3, 0
  li a4, 0
1:
  sw a1, 0(a0)
//  lw a3, 0(a0)
  add a4, a4, a3
  add a1, a1, 1
  add a0, a0, 4
  and a0, a0, a2
  j 1b

