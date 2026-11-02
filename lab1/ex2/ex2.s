;transfer 10 32-bit numbers from one memory to another when the src and dst are non-overlapping

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

		LDR R0,=SRC
		LDR R1,=DST
		MOV R2,#10	
LOOP
		LDR R3,[R0],#4
		STR R3,[R1],#4
		SUBS R1,R1,#1
		BNE LOOP
		
STOP
		B STOP
		ALIGN

SRC		DCD 1,2,3,4,5,6,7,8,9,10
		ALIGN
		
		AREA mydata, DATA, READWRITE
		ALIGN
		
DST		DCD 0,0,0,0,0,0,0,0,0,0
		END
		