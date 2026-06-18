SDK_PREFIX ?= arm-none-eabi-
CC = $(SDK_PREFIX)gcc
OBJCOPY = $(SDK_PREFIX)objcopy
QEMU ?= qemu-system-gnuarmeclipse
GDB ?= gdb-multiarch
TARGET = firmware
CPU = cortex-m4
BOARD = STM32F4-Discovery
MCU = STM32F407VG
TCP_ADDR = 1234

all: $(TARGET).bin

start.o: start.S
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU) -mthumb -Wall start.S -o start.o

$(TARGET).elf: start.o lscript.ld
	$(CC) start.o -mcpu=$(CPU) -mthumb -Wall --specs=nosys.specs -nostdlib -lgcc -T./lscript.ld -o $(TARGET).elf

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary -F elf32-littlearm $(TARGET).elf $(TARGET).bin

qemu: $(TARGET).bin
	$(QEMU) --verbose --verbose --board $(BOARD) --mcu $(MCU) -d unimp,guest_errors --image $(TARGET).bin --semihosting-config enable=on,target=native -gdb tcp::$(TCP_ADDR) -S

gdb:
	$(GDB) $(TARGET).elf -ex="target extended-remote:$(TCP_ADDR)"

clean:
	rm -f *.o *.elf *.bin
