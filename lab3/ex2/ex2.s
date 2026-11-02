;convert 2-digit BCD into equivalent HD 

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
	
		LDR R0,=NUM
		LDR R1,=RESULT
		LDRB R2,[R0]
		
		AND R4,R2,#0x0F
		AND R5,R2,#0xF0
		
		LSR R5,R5,#4
		MOV R6,#10
		MLA R5,R5,R6,R4
		STR R5,[R1]
		
STOP 
		B STOP
		
NUM		DCB 0x38
		AREA data, DATA, READWRITE
		
RESULT	
		SPACE 4
		END
		