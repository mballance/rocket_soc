

#define MMIO_BASE 0x60000000

.section .text.start, "ax", @progbits
.globl _start
_start:

  li a0, MMIO_BASE
  li a1, 5
1:
  sw a1, 0(a0)
  add a1, a1, 1
  j 1b

