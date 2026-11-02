; multiply two 16-bit numbers

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
		LDRH R1,[R0]
		LDR R0,=NUM2
		LDRH R2,[R0]
		LDR R3,=PROD
		MUL R4,R1,R2
		STR R4,[R3]
		
STOP	B STOP

NUM1 	DCD 0x1234
NUM2 	DCD 0x5678

		AREA data, DATA, READWRITE
		
PROD	DCD 0
		
		END