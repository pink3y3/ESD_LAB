; multiply two 32 bit numbers using repititive addition

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
        LDR R1,[R0]          ; R1 = first number
        LDR R0,=NUM2
        LDR R2,[R0]          ; R2 = second number
        MOV R3,#0            ; R3 = result

LOOP
        CMP R2,#0
        BEQ STORE

        ADD R3,R3,R1         ; result = result + first number
        SUB R2,R2,#1         ; decrease counter
        B LOOP

STORE
        LDR R4,=RESULT
        STR R3,[R4]

STOP
        B STOP

        ALIGN

NUM1    DCD 5
NUM2    DCD 3

        AREA DATASEG, DATA, READWRITE

RESULT  DCD 0

        END