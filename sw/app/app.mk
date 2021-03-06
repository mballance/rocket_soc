
SW_APP_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

LIBGCC=$(shell $(CC) -march=rv64imafd -print-libgcc-file-name)
LIBC=$(shell $(CC) -march=rv64imafd -print-file-name=libc.a)
#LIBCXX:=$(dir $(LIBGCC))/../../../../../or1k-elf/lib/compat-delay/libstdc++.a
#LIBOR1K:=$(dir $(LIBGCC))/../../../../../or1k-elf/lib/compat-delay/libor1k.a

SW_APP_CORE_LIB := app/libapp.o
SRC_DIRS += $(SW_APP_DIR)

else # Rules

app/libapp.o : app/app_crt0.o app/app_startup.o app/rocket_soc_app.o
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(LD) -r -o $@ app/app_crt0.o app/app_startup.o app/rocket_soc_app.o

app/%.o : %.c
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(CC) -c $(CFLAGS) -o $@ $^
	
app/%.o : %.S
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(CC) -c $(ASFLAGS) -o $@ $^
	
#app/%.elf : 
#	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
#	$(Q)echo "deps=$^"

endif

