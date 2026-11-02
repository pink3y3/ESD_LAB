;You are given two hexadecimal numbers n1 and n2 stored in code memory.
;calculate the sum of the products of every corresponding digit of the two numbers.
;Store the result in data memory.

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
		LDR R1,=NUM2
		LDR R2,=RES
		LDR R3,[R0]
		LDR R4,[R1]
		MOV R5,#0

LOOP
		AND R6,R3,#0X0F
		AND R7,R4,#0X0F
		
		MUL R8,R6,R7
		ADD R5,R5,R8
		
		LSR R3,R3,#4
		LSR R4,R4,#4
		
		CMP R3,#0
		BNE LOOP
		
		STR R5,[R2]
		
STOP 
		B STOP
		
NUM1	DCD 0x38
NUM2 	DCD 0X12
		AREA data, DATA, READWRITE
		
RES		DCD 0
		END
		
		
		
		
		