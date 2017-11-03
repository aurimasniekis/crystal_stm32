TARGET     = main
TARGET_CR  = main.cr

# Take a look into $(CUBE_DIR)/Drivers/BSP for available BSPs
# name needed in upper case and lower case
BOARD      = STM32F446ZE-Nucleo
BOARD_UC   = STM32F4xx_Nucleo_144
BOARD_LC   = stm32f4xx_nucleo_144
BOARD_FD   = NODE_F446ZE
BSP_BASE   = $(BOARD_LC)

OCDFLAGS   = -f board/stm32f4discovery.cfg
GDBFLAGS   =

#EXAMPLE   = Templates
EXAMPLE    = Examples/GPIO/GPIO_IOToggle

# MCU family and type in various capitalizations o_O
MCU_FAMILY = stm32f4xx
MCU_LC     = stm32f446xx
MCU_MC     = STM32F446xx
MCU_UC     = STM32F446ZE

# path of the ld-file inside the example directories
LDFILE     = $(EXAMPLE)/SW4STM32/$(BOARD_UC)/$(MCU_UC)Tx_FLASH.ld
#LDFILE     = $(EXAMPLE)/TrueSTUDIO/$(BOARD_UC)/$(MCU_UC)_FLASH.ld

# Your C files from the /src directory
SRCS       = main_c.c
SRCS      += system_$(MCU_FAMILY).c
SRCS      += stm32f4xx_it.c

# Basic HAL libraries
SRCS      += stm32f4xx_hal_rcc.c stm32f4xx_hal_rcc_ex.c stm32f4xx_hal.c stm32f4xx_hal_cortex.c stm32f4xx_hal_gpio.c stm32f4xx_hal_pwr_ex.c $(BSP_BASE).c

# Directories
OCD_DIR      = /usr/share/openocd/scripts

CUBE_DIR     = STM32CubeF4

BSP_DIR    	 = $(CUBE_DIR)/Drivers/BSP/$(BOARD_UC)
HAL_DIR    	 = $(CUBE_DIR)/Drivers/STM32F4xx_HAL_Driver
CMSIS_DIR  	 = $(CUBE_DIR)/Drivers/CMSIS

DEV_DIR    	 = $(CMSIS_DIR)/Device/ST/STM32F4xx

CRYSTAL_PATH = /Users/aniekis/Projects/Home/Desktop/Crystal/crystal-embed/bin

# that's it, no need to change anything below this line!

###############################################################################
# Toolchain

PREFIX     = arm-none-eabi
CRYSTAL    = $(CRYSTAL_PATH)/crystal
CC         = $(PREFIX)-gcc
AR         = $(PREFIX)-ar
OBJCOPY    = $(PREFIX)-objcopy
OBJDUMP    = $(PREFIX)-objdump
SIZE       = $(PREFIX)-size
GDB        = $(PREFIX)-gdb

OCD        = openocd

###############################################################################
# Options

# Defines
DEFS       = -D$(MCU_MC) -DUSE_HAL_DRIVER

# Debug specific definitions for semihosting
DEFS       += -DUSE_DBPRINTF

# Include search paths (-I)
INCS       = -Isrc
INCS      += -I$(BSP_DIR)
INCS      += -I$(CMSIS_DIR)/Include
INCS      += -I$(DEV_DIR)/Include
INCS      += -I$(HAL_DIR)/Inc

# Library search paths
LIBS       = -L$(CMSIS_DIR)/Lib

# Compiler flags
CFLAGS     = -Wall -g -std=c99 -Os
CFLAGS    += -mlittle-endian -mcpu=cortex-m4 -march=armv7e-m -mthumb
CFLAGS    += -mfpu=fpv4-sp-d16 -mfloat-abi=softfp
CFLAGS    += -ffunction-sections -fdata-sections
CFLAGS    += $(INCS) $(DEFS)

# Crystal flags
CRFLAGS    = --cross-compile --target "thumbv7em-none-eabi" --prelude empty --release --no-debug

# Linker flags
LDFLAGS    = -Wl,--gc-sections -Wl,-Map=$(TARGET).map $(LIBS) -T$(MCU_LC).ld

# Enable Semihosting
LDFLAGS   += --specs=rdimon.specs -lc -lrdimon

# Source search paths
VPATH      = ./src
VPATH     += $(BSP_DIR)
VPATH     += $(HAL_DIR)/Src
VPATH     += $(DEV_DIR)/Source/


OBJS        = $(addprefix obj/,$(SRCS:.c=.o))
DEPS        = $(addprefix dep/,$(SRCS:.c=.d))
CRYSTAL_OBJ = $(addprefix obj/,$(TARGET_CR:.cr=.o))

# Prettify output
V = 0
ifeq ($V, 0)
	Q = @
	P = > /dev/null
endif

###################################################

.PHONY: all dirs program debug template clean

all: $(TARGET).bin

-include $(DEPS)

dirs: dep obj
dep obj src:
	@echo "[MKDIR]   $@"
	$Qmkdir -p $@

obj/%.o : %.c | dirs
	@echo "[CC]      $(notdir $<)"
	$Q$(CC) $(CFLAGS) -c -o $@ $< -MMD -MF dep/$(*F).d

$(CRYSTAL_OBJ) : $(TARGET_CR) | dirs
	$(CRYSTAL) build $(CRFLAGS) -o $(@:%.o=%) $+

$(TARGET).elf: $(OBJS) $(CRYSTAL_OBJ)
	@echo "[LD]      $(TARGET).elf"
	$Q$(CC) $(CFLAGS) $(LDFLAGS) src/startup_$(MCU_LC).s $^ -o $@
	@echo "[OBJDUMP] $(TARGET).lst"
	$Q$(OBJDUMP) -St $(TARGET).elf >$(TARGET).lst
	@echo "[SIZE]    $(TARGET).elf"
	$(SIZE) $(TARGET).elf

$(TARGET).bin: $(TARGET).elf
	@echo "[OBJCOPY] $(TARGET).bin"
	$Q$(OBJCOPY) -O binary $< $@

openocd:
	$(OCD) -s $(OCD_DIR) $(OCDFLAGS)

program: all
	# $(OCD) -s $(OCD_DIR) $(OCDFLAGS) -c "program $(TARGET).elf verify reset"
	cp $(TARGET).bin /Volumes/$(BOARD_FD)/

debug:
	@if ! nc -z localhost 3333; then \
		echo "\n\t[Error] OpenOCD is not running! Start it with: 'make openocd'\n"; exit 1; \
	else \
		$(GDB)  -ex "target extended localhost:3333" \
			-ex "monitor arm semihosting enable" \
			-ex "monitor reset halt" \
			-ex "load" \
			-ex "monitor reset init" \
			$(GDBFLAGS) $(TARGET).elf; \
	fi

template: src
	cp -ri $(CUBE_DIR)/Projects/$(BOARD)/$(EXAMPLE)/Src/* src
	cp -ri $(CUBE_DIR)/Projects/$(BOARD)/$(EXAMPLE)/Inc/* src
	cp -i $(DEV_DIR)/Source/Templates/gcc/startup_$(MCU_LC).s src
	cp -i $(CUBE_DIR)/Projects/$(BOARD)/$(LDFILE) $(MCU_LC).ld

clean:
	@echo "[RM]      $(TARGET).bin"; rm -f $(TARGET).bin
	@echo "[RM]      $(TARGET).elf"; rm -f $(TARGET).elf
	@echo "[RM]      $(TARGET).map"; rm -f $(TARGET).map
	@echo "[RM]      $(TARGET).lst"; rm -f $(TARGET).lst
	@echo "[RMDIR]   dep"          ; rm -fr dep
	@echo "[RMDIR]   obj"          ; rm -fr obj