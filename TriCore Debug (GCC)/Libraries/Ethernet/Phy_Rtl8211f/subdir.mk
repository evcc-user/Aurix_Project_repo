################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Libraries/Ethernet/Phy_Rtl8211f/IfxGeth_Phy_Rtl8211f.c 

C_DEPS += \
./Libraries/Ethernet/Phy_Rtl8211f/IfxGeth_Phy_Rtl8211f.d 

OBJS += \
./Libraries/Ethernet/Phy_Rtl8211f/IfxGeth_Phy_Rtl8211f.o 


# Each subdirectory must supply rules for building sources it contributes
Libraries/Ethernet/Phy_Rtl8211f/%.o: ../Libraries/Ethernet/Phy_Rtl8211f/%.c Libraries/Ethernet/Phy_Rtl8211f/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: AURIX GCC Compiler'
	tricore-elf-gcc -std=c99 "@C:/Users/admin/AURIX-v1.10.10-workspace/V6_V4_TCPIP/TriCore Debug (GCC)/AURIX_GCC_Compiler-Include_paths__-I_.opt" -O0 -g3 -Wall -c -fmessage-length=0 -fno-common -fstrict-volatile-bitfields -fdata-sections -ffunction-sections -mtc162 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-Libraries-2f-Ethernet-2f-Phy_Rtl8211f

clean-Libraries-2f-Ethernet-2f-Phy_Rtl8211f:
	-$(RM) ./Libraries/Ethernet/Phy_Rtl8211f/IfxGeth_Phy_Rtl8211f.d ./Libraries/Ethernet/Phy_Rtl8211f/IfxGeth_Phy_Rtl8211f.o

.PHONY: clean-Libraries-2f-Ethernet-2f-Phy_Rtl8211f

