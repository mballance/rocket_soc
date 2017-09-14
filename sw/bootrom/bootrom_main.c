/**
 * bootrom_main()
 */
#include <stdint.h>

void bootrom_main(uint32_t hartid) {
	volatile uint32_t *ptr = (volatile uint32_t *)0x60000000;
	uint32_t i = 0;

	while (1) {
		*ptr = i++;
	}

}
