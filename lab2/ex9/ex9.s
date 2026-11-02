;sum of 'n' natural numbers using mla instruction

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
		LDR R2,=RESULT
		MLA R3,R1,R1,R1
		LSR R3,R3,#1
		STR R3,[R2]
		
STOP
        B STOP
		ALIGN

NUM1    DCD 10
        AREA DATASEG, DATA, READWRITE
		
RESULT  DCD 0
        END;
		