;divide a 32 bit number by 16 bit number

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
		LDR R0,=NUM2
		LDRH R2,[R0]
		MOV R3,#0
		
LOOP
		CMP R1,R2
		BLO DONE
		SUB R1,R1,R2
		ADD R3,R3,#1
		B LOOP
		
DONE 
		LDR R4,=RES
		STR R3,[R4]
		STR R1,[R4,#4]
		
STOP 	B STOP

NUM1 	DCD 0x20
NUM2 	DCD 0X0005

		AREA data, DATA, READWRITE
		
RES		DCD 0,0