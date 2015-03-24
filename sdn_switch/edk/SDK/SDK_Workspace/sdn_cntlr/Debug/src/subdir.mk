################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

CC_SRCS += \
../src/main.cc \
../src/sdn_cntlr_classes.cc 

OBJS += \
./src/main.o \
./src/sdn_cntlr_classes.o 

CC_DEPS += \
./src/main.d \
./src/sdn_cntlr_classes.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cc
	@echo 'Building file: $<'
	@echo 'Invoking: PowerPC g++ compiler'
	powerpc-eabi-g++ -Wall -O0 -g3 -c -fmessage-length=0 -I../../ppc_bsp/ppc405_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


