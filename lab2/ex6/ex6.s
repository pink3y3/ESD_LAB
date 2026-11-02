;Write a program to subtract two 128 bit numbers
		AREA RESET, DATA, READONLY
        EXPORT __Vectors

__Vectors
        DCD 0x10001000
        DCD Reset_Handler

        ALIGN
        AREA mycode, CODE, READONLY
        ENTRY
        EXPORT Reset_Handler

Reset_Handler

		LDR R0,=NUM1
		LDR R1,=NUM2
		LDR R2,=RES
		MOV R6,#4
		LDR R3,[R0],#4
		LDR R4,[R1],#4
		SUBS R5,R3,R4
		STR R5,[R2],#4
		SUBS R6,#1
		
LOOP
		LDR R3,[R0],#4
		LDR R4,[R1],#4
		SBCS R5,R3,R4
		STR R5,[R2],#4
		SUBS R6,#1
		BNE LOOP
		
STOP	B STOP


NUM1    DCD 0x44444444, 0x33333333, 0x22222222, 0x11111111
NUM2    DCD 0x11111111, 0x11111111, 0x11111111, 0x11111111

        AREA DATASEG, DATA, READWRITE
RES		DCD 0, 0, 0, 0

        END	
		