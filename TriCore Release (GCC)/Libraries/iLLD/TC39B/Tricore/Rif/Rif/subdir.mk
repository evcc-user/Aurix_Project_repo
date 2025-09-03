################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Libraries/iLLD/TC39B/Tricore/Rif/Rif/IfxRif_Rif.c 

C_DEPS += \
./Libraries/iLLD/TC39B/Tricore/Rif/Rif/IfxRif_Rif.d 

OBJS += \
./Libraries/iLLD/TC39B/Tricore/Rif/Rif/IfxRif_Rif.o 


# Each subdirectory must supply rules for building sources it contributes
Libraries/iLLD/TC39B/Tricore/Rif/Rif/%.o: ../Libraries/iLLD/TC39B/Tricore/Rif/Rif/%.c Libraries/iLLD/TC39B/Tricore/Rif/Rif/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: AURIX GCC Compiler'
	tricore-elf-gcc -std=c99 "@C:/Users/admin/AURIX-v1.10.10-workspace/V6_V4_TCPIP/TriCore Release (GCC)/AURIX_GCC_Compiler-Include_paths__-I_.opt" -O3 -Wall -c -fmessage-length=0 -fno-common -fstrict-volatile-bitfields -fdata-sections -ffunction-sections -mtc162 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-Libraries-2f-iLLD-2f-TC39B-2f-Tricore-2f-Rif-2f-Rif

clean-Libraries-2f-iLLD-2f-TC39B-2f-Tricore-2f-Rif-2f-Rif:
	-$(RM) ./Libraries/iLLD/TC39B/Tricore/Rif/Rif/IfxRif_Rif.d ./Libraries/iLLD/TC39B/Tricore/Rif/Rif/IfxRif_Rif.o

.PHONY: clean-Libraries-2f-iLLD-2f-TC39B-2f-Tricore-2f-Rif-2f-Rif

