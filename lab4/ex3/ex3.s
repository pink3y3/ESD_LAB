; Factorial of an unsigned number using recursion

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

        LDR R0,=NUM
        LDR R0,[R0]
        BL FACTORIAL
        LDR R1,=RESULT
        STR R0,[R1]

STOP
        B STOP
		
FACTORIAL

        CMP R0,#1
        BLS BASE
        PUSH {R0,LR}
        SUB R0,R0,#1
        BL FACTORIAL
        POP {R1,LR}
        MUL R0,R1,R0
        BX LR
		
BASE
        MOV R0,#1
        BX LR
		
NUM
        DCD 5

        AREA data, DATA, READWRITE
		
RESULT
        DCD 0

        END