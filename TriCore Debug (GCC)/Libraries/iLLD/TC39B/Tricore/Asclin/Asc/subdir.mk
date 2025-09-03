################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Libraries/iLLD/TC39B/Tricore/Asclin/Asc/IfxAsclin_Asc.c 

C_DEPS += \
./Libraries/iLLD/TC39B/Tricore/Asclin/Asc/IfxAsclin_Asc.d 

OBJS += \
./Libraries/iLLD/TC39B/Tricore/Asclin/Asc/IfxAsclin_Asc.o 


# Each subdirectory must supply rules for building sources it contributes
Libraries/iLLD/TC39B/Tricore/Asclin/Asc/%.o: ../Libraries/iLLD/TC39B/Tricore/Asclin/Asc/%.c Libraries/iLLD/TC39B/Tricore/Asclin/Asc/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: AURIX GCC Compiler'
	tricore-elf-gcc -std=c99 "@C:/Users/admin/AURIX-v1.10.10-workspace/V6_V4_TCPIP/TriCore Debug (GCC)/AURIX_GCC_Compiler-Include_paths__-I_.opt" -O0 -g3 -Wall -c -fmessage-length=0 -fno-common -fstrict-volatile-bitfields -fdata-sections -ffunction-sections -mtc162 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-Libraries-2f-iLLD-2f-TC39B-2f-Tricore-2f-Asclin-2f-Asc

clean-Libraries-2f-iLLD-2f-TC39B-2f-Tricore-2f-Asclin-2f-Asc:
	-$(RM) ./Libraries/iLLD/TC39B/Tricore/Asclin/Asc/IfxAsclin_Asc.d ./Libraries/iLLD/TC39B/Tricore/Asclin/Asc/IfxAsclin_Asc.o

.PHONY: clean-Libraries-2f-iLLD-2f-TC39B-2f-Tricore-2f-Asclin-2f-Asc

