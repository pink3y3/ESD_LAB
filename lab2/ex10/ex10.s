;find gcd of two numbers

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
		
LOOP
		CMP R1,R2
		BEQ STORE
		BLO SUB1
		SUBS R1,R1,R2
		B LOOP
		
SUB1
		SUBS R2,R2,R1
		B LOOP
		
STORE
		LDR R3,=RESULT
		STR R1,[R3]
		
STOP
        B STOP

		ALIGN

NUM1    DCD 12
NUM2    DCD 18

        AREA DATASEG, DATA, READWRITE
RESULT  DCD 0

        END;