################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
"../Libraries/iLLD/TC39B/Tricore/Ccu6/PwmBc/IfxCcu6_PwmBc.c" 

COMPILED_SRCS += \
"Libraries/iLLD/TC39B/Tricore/Ccu6/PwmBc/IfxCcu6_PwmBc.src" 

C_DEPS += \
"./Libraries/iLLD/TC39B/Tricore/Ccu6/PwmBc/IfxCcu6_PwmBc.d" 

OBJS += \
"Libraries/iLLD/TC39B/Tricore/Ccu6/PwmBc/IfxCcu6_PwmBc.o" 


# Each subdirectory must supply rules for building sources it contributes
"Libraries/iLLD/TC39B/Tricore/Ccu6/PwmBc/IfxCcu6_PwmBc.src":"../Libraries/iLLD/TC39B/Tricore/Ccu6/PwmBc/IfxCcu6_PwmBc.c" "Libraries/iLLD/TC39B/Tricore/Ccu6/PwmBc/subdir.mk"
	cctc -cs --dep-file="$*.d" --misrac-version=2004 -D__CPU__=tc39xb "-fC:/Users/admin/AURIX-v1.10.10-workspace/V6_V4_TCPIP/TriCore Release (TASKING)/TASKING_C_C___Compiler-Include_paths__-I_.opt" --iso=99 --c++14 --language=+volatile --exceptions --anachronisms --fp-model=3 -O0 --tradeoff=4 --compact-max-size=200 -g -Wc-w544 -Wc-w557 -Ctc39xb -Y0 -N0 -Z0 -o "$@" "$<"
"Libraries/iLLD/TC39B/Tricore/Ccu6/PwmBc/IfxCcu6_PwmBc.o":"Libraries/iLLD/TC39B/Tricore/Ccu6/PwmBc/IfxCcu6_PwmBc.src" "Libraries/iLLD/TC39B/Tricore/Ccu6/PwmBc/subdir.mk"
	astc -Og -Os --no-warnings= --error-limit=42 -o  "$@" "$<"

clean: clean-Libraries-2f-iLLD-2f-TC39B-2f-Tricore-2f-Ccu6-2f-PwmBc

clean-Libraries-2f-iLLD-2f-TC39B-2f-Tricore-2f-Ccu6-2f-PwmBc:
	-$(RM) ./Libraries/iLLD/TC39B/Tricore/Ccu6/PwmBc/IfxCcu6_PwmBc.d ./Libraries/iLLD/TC39B/Tricore/Ccu6/PwmBc/IfxCcu6_PwmBc.o ./Libraries/iLLD/TC39B/Tricore/Ccu6/PwmBc/IfxCcu6_PwmBc.src

.PHONY: clean-Libraries-2f-iLLD-2f-TC39B-2f-Tricore-2f-Ccu6-2f-PwmBc

