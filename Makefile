#######################################################################
# Makefile for volt-ampere characteristic

OUTPATH = build
PROJECT = $(OUTPATH)/vac

################

# Sources

SOURCES_S =

SOURCES_C = $(wildcard app/src/*.c)

OBJS = $(SOURCES_S:.s=.o) $(SOURCES_C:.c=.o)

# Includes and Defines

INCLUDES = -Iapp/inc

DEFINES =
#-DQJ -DLOMO -DAPPA

# Compiler/Assembler/Linker/etc

CC = gcc
AS = as
AR = ar
LD = gcc
NM = nm
OBJCOPY = objcopy
OBJDUMP = objdump
READELF = readelf
SIZE = size
GDB = gdb
RM = rm -f

# Compiler options

MCUFLAGS =

DEBUG_OPTIMIZE_FLAGS = -O0 -ggdb -gdwarf-2
# DEBUG_OPTIMIZE_FLAGS = -O3

CFLAGS = -Wall -Wextra --pedantic
CFLAGS_EXTRA = -std=gnu99

CFLAGS += $(DEFINES) $(MCUFLAGS) $(DEBUG_OPTIMIZE_FLAGS) $(CFLAGS_EXTRA) $(INCLUDES)

LDFLAGS = $(MCUFLAGS) -lpthread -lgpib

.PHONY: dirs all clean

all: dirs $(PROJECT).bin $(PROJECT).asm

dirs: ${OUTPATH}

${OUTPATH}:
	mkdir -p ${OUTPATH}

clean:
	$(RM) $(OBJS) $(PROJECT).elf $(PROJECT).bin $(PROJECT).asm
	rm -rf ${OUTPATH}

$(PROJECT).elf: $(OBJS)
%.o: %.c Makefile

%.elf:
	$(LD) $(OBJS) $(LDFLAGS) -o $@
	$(SIZE) -A $@

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

%.asm: %.elf
	$(OBJDUMP) -dwh $< > $@
