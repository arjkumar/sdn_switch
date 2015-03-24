################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
ELFSIZE += \
packet_tx.elf.size \

ELFCHECK += \
packet_tx.elf.elfcheck \


# All Target
all: packet_tx.elf secondary-outputs

# Tool invocations
packet_tx.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: MicroBlaze gcc linker'
	mb-gcc -Wl,--no-relax -Wl,-T -Wl,../src/lscript.ld -L../../mb_bsp/microblaze_0/lib -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.50.a -mno-xl-soft-mul -o "packet_tx.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

packet_tx.elf.size: packet_tx.elf
	@echo 'Invoking: MicroBlaze Print Size'
	mb-size packet_tx.elf  |tee "packet_tx.elf.size"
	@echo 'Finished building: $@'
	@echo ' '

packet_tx.elf.elfcheck: packet_tx.elf
	@echo 'Invoking: Xilinx ELF Check'
	elfcheck packet_tx.elf -hw ../../edk_hw_platform/system.xml -pe microblaze_0  |tee "packet_tx.elf.elfcheck"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES)$(ELFSIZE)$(ELFCHECK)$(S_UPPER_DEPS) packet_tx.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
