;Write an assembly language program to find LCM of two numbers
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
		LDR R1,[R0]
		LDR R0,=NUM2
		LDR R2,[R0]
		MOV R3,#1
		
UP
		MUL R4,R3,R1
		MOV R5,R4
		
MOD
		CMP R5,R2
		BLO CHECK
		SUB R5,R5,R2
		B MOD
		
CHECK
		CMP R5,#0
		BEQ STORE
		ADD R3,R3,#1
		B UP

STORE 
		LDR R6,=RESULT
		STR R4,[R6]
		
STOP
        B STOP

		ALIGN

NUM1    DCD 12
NUM2    DCD 18

        AREA DATASEG, DATA, READWRITE
RESULT  DCD 0

        END;
		
		