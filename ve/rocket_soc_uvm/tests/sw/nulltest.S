
#define UART_BASE 0x60000000

// Empty file

	li a0, UART_BASE
	lw a1, 0(a0)
	lw a1, 4(a0)
	lw a1, 8(a0)
	lw a1, 12(a0)
	lw a1, 16(a0)
	lw a1, 20(a0)
	lw a1, 24(a0)
	lw a1, 28(a0)
	lw a1, 32(a0)
	lw a1, 36(a0)
	lw a1, 40(a0)

1:
	j	1b

