;Read an array of 5 16 bit hexadecimal numbers.
;sum the digits of the 16 bit hd and read that sum and write it as bcd 

		AREA RESET, DATA, READONLY
		EXPORT __Vectors
__Vectors
		DCD 0x10001000 ; stack pointer value when stack is empty
		DCD Reset_Handler ; reset vector
		ALIGN
		AREA mycode, CODE, READONLY
		ENTRY
		EXPORT Reset_Handler
		
Reset_Handler

		LDR R0,=NUMS
		LDR R1,=RES
		MOV R2,#5
		MOV R5,#0
		
LOOP
		LDRH R3,[R0],#2
		
		AND R5,R3,#0X000F
		AND R6,R3,#0X00F0
		LSR R6,R6,#4
		
		AND R7,R3,#0X0F00
		LSR R7,R7,#8
		AND R8,R3,#0XF000
		LSR R8,R8,#12
		
		ADDS R9,R5,R6
		ADDS R9,R9,R7
		ADDS R9,R9,R8
		
		MOV R10,#0
		
BCD_LOOP
		CMP R9,#10
		BLO BCD_DONE
		SUB R9,R9,#10
		ADD R10,R10,#1
		B BCD_LOOP
		
BCD_DONE 
		LSL R10,R10,#4
		ADD R9,R9,R10
		STRB R9,[R1],#1

		SUBS R2,R2,#1
		BNE LOOP
		

STOP
        B STOP

NUMS
        DCW 0X12,0XE,0X23,0X9,0X1
		ALIGN
        AREA data, DATA, READWRITE

RES
        SPACE 5
        END
		

