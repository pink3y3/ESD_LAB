;add two 32-bit numbers

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
		
		LDR R0,=NUM1
		LDR R1,[R0]
		LDR R2,=NUM2
		LDR R3,[R2]
		LDR R4,=SUM
		ADDS R5,R1,R3
		STR R5,[R4]
		
STOP 	
		B STOP
		
NUM1	DCD 0x12345678
NUM2	DCD 0xABCDEF12
		
		AREA data, DATA, READWRITE
		
SUM 	DCD 0
		END