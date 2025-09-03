################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuCcu.c \
../Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuEru.c \
../Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuLbist.c \
../Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuRcu.c \
../Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuWdt.c 

C_DEPS += \
./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuCcu.d \
./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuEru.d \
./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuLbist.d \
./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuRcu.d \
./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuWdt.d 

OBJS += \
./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuCcu.o \
./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuEru.o \
./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuLbist.o \
./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuRcu.o \
./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuWdt.o 


# Each subdirectory must supply rules for building sources it contributes
Libraries/iLLD/TC39B/Tricore/Scu/Std/%.o: ../Libraries/iLLD/TC39B/Tricore/Scu/Std/%.c Libraries/iLLD/TC39B/Tricore/Scu/Std/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: AURIX GCC Compiler'
	tricore-elf-gcc -std=c99 "@C:/Users/admin/AURIX-v1.10.10-workspace/V6_V4_TCPIP/TriCore Release (GCC)/AURIX_GCC_Compiler-Include_paths__-I_.opt" -O3 -Wall -c -fmessage-length=0 -fno-common -fstrict-volatile-bitfields -fdata-sections -ffunction-sections -mtc162 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-Libraries-2f-iLLD-2f-TC39B-2f-Tricore-2f-Scu-2f-Std

clean-Libraries-2f-iLLD-2f-TC39B-2f-Tricore-2f-Scu-2f-Std:
	-$(RM) ./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuCcu.d ./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuCcu.o ./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuEru.d ./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuEru.o ./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuLbist.d ./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuLbist.o ./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuRcu.d ./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuRcu.o ./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuWdt.d ./Libraries/iLLD/TC39B/Tricore/Scu/Std/IfxScuWdt.o

.PHONY: clean-Libraries-2f-iLLD-2f-TC39B-2f-Tricore-2f-Scu-2f-Std

