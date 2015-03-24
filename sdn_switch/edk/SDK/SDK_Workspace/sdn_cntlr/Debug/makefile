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
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
ELFSIZE += \
sdn_cntlr.elf.size \

ELFCHECK += \
sdn_cntlr.elf.elfcheck \


# All Target
all: sdn_cntlr.elf secondary-outputs

# Tool invocations
sdn_cntlr.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: PowerPC g++ linker'
	powerpc-eabi-g++ -Wl,-T -Wl,../src/lscript.ld -L../../ppc_bsp/ppc405_0/lib -o "sdn_cntlr.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

sdn_cntlr.elf.size: sdn_cntlr.elf
	@echo 'Invoking: PowerPC Print Size'
	powerpc-eabi-size sdn_cntlr.elf  |tee "sdn_cntlr.elf.size"
	@echo 'Finished building: $@'
	@echo ' '

sdn_cntlr.elf.elfcheck: sdn_cntlr.elf
	@echo 'Invoking: Xilinx ELF Check'
	elfcheck sdn_cntlr.elf -hw ../../edk_hw_platform/system.xml -pe ppc405_0  |tee "sdn_cntlr.elf.elfcheck"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(CC_DEPS)$(CPP_DEPS)$(EXECUTABLES)$(ELFSIZE)$(CXX_DEPS)$(C_UPPER_DEPS)$(ELFCHECK)$(S_UPPER_DEPS) sdn_cntlr.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
