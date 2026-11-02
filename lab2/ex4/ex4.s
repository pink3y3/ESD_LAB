;add ten 32 bit numbers stored in code segment and store the result in data segment

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
		MOV R1,#10
		MOV R2,#0
		
LOOP
		LDR R3,[R0],#4
		ADDS R2,R2,R3
		SUBS R1,#1
		BNE LOOP
		
		LDR R4,=SUM
		STR R2,[R4]
		
STOP	B STOP
		ALIGN
		
NUM1	DCD 10,20,30,40,50,60,70,80,90,100

		AREA DATASEG, DATA, READWRITE
		
SUM	DCD 0
		END