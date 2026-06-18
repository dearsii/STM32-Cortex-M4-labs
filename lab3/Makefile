SDK_PREFIX ?= arm-none-eabi-
CC = $(SDK_PREFIX)gcc
OBJCOPY = $(SDK_PREFIX)objcopy
QEMU ?= qemu-system-gnuarmeclipse
GDB ?= gdb-multiarch
CPU = cortex-m4
BOARD = STM32F4-Discovery
MCU = STM32F407VG
TCP_ADDR = 1234
LAB2_VARIANT ?= 1
BOOT_VARIANT ?= 1

all: firmware.bin

kernel.elf: kernel.S print.S kernel.ld
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU) -mthumb -Wall -DLAB2_VARIANT=$(LAB2_VARIANT) kernel.S -o kernel.o
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU) -mthumb -Wall print.S -o print.o
	$(CC) kernel.o print.o -mcpu=$(CPU) -mthumb -Wall --specs=nosys.specs -nostdlib -lgcc -T./kernel.ld -o kernel.elf

kernel.bin: kernel.elf
	$(OBJCOPY) -O binary -F elf32-littlearm kernel.elf kernel.bin

start.o: start.S
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU) -mthumb -Wall start.S -o start.o

bootloader.o: bootloader.S kernel.bin
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU) -mthumb -Wall -DBOOT_VARIANT=$(BOOT_VARIANT) bootloader.S -o bootloader.o

boot_print.o: print.S
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU) -mthumb -Wall print.S -o boot_print.o

firmware.elf: start.o bootloader.o boot_print.o bootloader.ld
	$(CC) start.o bootloader.o boot_print.o -mcpu=$(CPU) -mthumb -Wall --specs=nosys.specs -nostdlib -lgcc -T./bootloader.ld -o firmware.elf

firmware.bin: firmware.elf
	$(OBJCOPY) -O binary -F elf32-littlearm firmware.elf firmware.bin

qemu: firmware.bin
	$(QEMU) --verbose --verbose --board $(BOARD) --mcu $(MCU) -d unimp,guest_errors --image firmware.bin --semihosting-config enable=on,target=native -gdb tcp::$(TCP_ADDR) -S

gdb:
	$(GDB) firmware.elf -ex="target extended-remote:$(TCP_ADDR)"

clean:
	rm -f *.o *.elf *.bin
