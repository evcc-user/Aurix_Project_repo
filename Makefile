# Subbu Makefile for Jenkins CI/CD

# Toolchain paths
CC = "C:/Infineon/AURIX-Studio-1.10.10/tools/Compilers/tricore-gcc11/bin/tricore-elf-gcc.exe"
LD = "C:/Infineon/AURIX-Studio-1.10.10/tools/Compilers/tricore-gcc11/tricore-elf/bin/ld.exe"
OBJCOPY = "C:/Infineon/AURIX-Studio-1.10.10/tools/Compilers/tricore-gcc11/bin/tricore-elf-objcopy.exe"

include include_flags.mk

# Compiler and linker flags
CFLAGS= -mcpu=tc39xx -D__CPU__=tc39xb -O2 -Wall -fdata-sections -ffunction-sections \
       -Iinc -Isrc -DCPU_TC397 -DIFX_CFG_USE_STANDARD_INTERFACE=1 \
       $(AurixIncludePaths)

GCCFLAGS= -mcpu=tc39xx -Iinc -std=c99 -O3 -Wall -c -fmessage-length=0 -fno-common -fstrict-volatile-bitfields -fdata-sections -ffunction-sections -mtc162 -MMD -MP $(AurixIncludePaths)

LDFLAGS=-TLcf_Gnuc_Tricore_Tc.lsl -nostdlib

TARGET=build/aurix_firmware.elf
BUILD_DIR = build

SRC_DIRS = ./src \
Configurations/Debug \
Configurations \
FreeRtos \
FreeRtos/portable/memmory \
FreeRtos/portable/tricore \
. \
Libraries/Ethernet/Phy_Rtl8211f \
Libraries/Ethernet/lwip/port/src \
Libraries/Ethernet/lwip/src/api \
Libraries/Ethernet/lwip/src/core \
Libraries/Ethernet/lwip/src/core/ipv4 \
Libraries/Ethernet/lwip/src/core/ipv6 \
Libraries/Ethernet/lwip/src/netif \
Libraries/Ethernet/lwip/src/netif/ppp \
Libraries/Ethernet/lwip/src/netif/ppp/polarssl \
Libraries/Infra/Platform/Tricore/Compilers \
Libraries/Infra/Ssw/TC39B/Tricore \
Libraries/Service/CpuGeneric/If \
Libraries/Service/CpuGeneric/StdIf \
Libraries/Service/CpuGeneric/SysSe/Timer \
Libraries/Service/CpuGeneric/SysSe/Comm \
Libraries/UART \
Libraries/Service/CpuGeneric/SysSe/Bsp \
Libraries/iLLD/TC39B/Tricore/Asclin/Asc \
Libraries/iLLD/TC39B/Tricore/Asclin/Std \
Libraries/iLLD/TC39B/Tricore/Can/Can \
Libraries/iLLD/TC39B/Tricore/Can/Std \
Libraries/iLLD/TC39B/Tricore/Cpu/Irq \
Libraries/iLLD/TC39B/Tricore/Cpu/Std \
Libraries/iLLD/TC39B/Tricore/Cpu/Trap \
Libraries/iLLD/TC39B/Tricore/Dma/Dma \
Libraries/iLLD/TC39B/Tricore/Dma/Std \
Libraries/iLLD/TC39B/Tricore/Geth/Eth \
Libraries/iLLD/TC39B/Tricore/Geth/Std \
Libraries/iLLD/TC39B/Tricore/Gtm/Std \
Libraries/iLLD/TC39B/Tricore/Mtu/Std \
Libraries/iLLD/TC39B/Tricore/Pms/Std \
Libraries/iLLD/TC39B/Tricore/Port/Io \
Libraries/iLLD/TC39B/Tricore/Port/Std \
Libraries/iLLD/TC39B/Tricore/Qspi/SpiMaster \
Libraries/iLLD/TC39B/Tricore/Qspi/SpiSlave \
Libraries/iLLD/TC39B/Tricore/Qspi/Std \
Libraries/iLLD/TC39B/Tricore/Scu/Std \
Libraries/iLLD/TC39B/Tricore/Src/Std \
Libraries/iLLD/TC39B/Tricore/Stm/Std \
Libraries/iLLD/TC39B/Tricore/Stm/Timer \
Libraries/iLLD/TC39B/Tricore/_Impl \
Libraries/iLLD/TC39B/Tricore/_Lib/DataHandling \
Libraries/iLLD/TC39B/Tricore/_PinMap \
mbedtls_2_28_7/library 

# Deduplicate SRC_DIRS
SRC_DIRS := $(sort $(SRC_DIRS))

# Collect all .c files
SRC_ALL := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))

# Exclude risky files to prevent multiple definition errors
SRC_EXCLUDE := \
    $(filter %/_PinMap/%.c,$(SRC_ALL)) \
    $(filter %/Ifx_Ssw_Tc1.c,$(SRC_ALL)) \
    $(filter %/Ifx_Ssw_Tc0.c,$(SRC_ALL)) \
    $(filter %/CompilerGcc.c,$(SRC_ALL))

# Final source list after filtering exclusions
SRCS := $(filter-out $(SRC_EXCLUDE),$(SRC_ALL))

# Object file list
OBJS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRCS))

all: $(TARGET)

# Special case for rsa.c to avoid addi immediate overflow
build/mbedtls_2_28_7/library/rsa.o: mbedtls_2_28_7/library/rsa.c
	@mkdir -p $(dir $@)
	$(CC) $(GCCFLAGS) -O0 -fno-inline -fno-tree-vectorize -c $< -o $@


$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(GCCFLAGS) -c $< -o $@

$(TARGET): $(OBJS)
	$(CC) -T"Lcf_Gnuc_Tricore_Tc.lsl" -mcpu=tc39xx -nocrt0 -Wl,--gc-sections -mtc162 -o $@ $(OBJS)
	$(OBJCOPY) -O ihex $@ build/aurix_firmware.hex
	$(OBJCOPY) -O binary $@ build/aurix_firmware.bin

-include $(OBJS:.o=.d)

clean:
	rm -rf build/*

flash: $(TARGET)
	JLinkExe -device TC397 -if JTAG -speed 4000 -CommanderScript flash.jlink
