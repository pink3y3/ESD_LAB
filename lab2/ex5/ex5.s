;Write a program to add two 128 bit numbers stored in code segment and store the result in data segment.
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
		LDR R2,=RESULT
		
		LDR R3,[R0],#4
		LDR R4,[R1],#4
		ADDS R5, R3,R4
		STR R5,[R2],#4
		
		LDR R3,[R0],#4
		LDR R4,[R1],#4
		ADCS R5,R3,R4
		STR R5,[R2],#4
		
		LDR R3,[R0],#4
		LDR R4,[R1],#4
		ADCS R5,R3,R4
		STR R5,[R2],#4
		
		LDR R3,[R0],#4
		LDR R4,[R1],#4
		ADCS R5,R3,R4
		STR R5,[R2],#4
		
		
STOP	B STOP
		ALIGN
		
NUM1    DCD 0x11111111,0x22222222,0x33333333,0x44444444
NUM2    DCD 0xAAAAAAAA,0xBBBBBBBB,0xCCCCCCCC,0xDDDDDDDD

        AREA DATASEG, DATA, READWRITE
RESULT  DCD 0,0,0,0

        END;
		

		