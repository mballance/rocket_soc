
int main(int argc, char **argv) {
	volatile unsigned int *addr = (volatile unsigned int *)0x60000000;

	*addr = 5;
	*addr = 6;

	return 1;
}

