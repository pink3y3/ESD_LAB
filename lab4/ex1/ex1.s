; Bubble Sort with RESULT variable

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

        LDR R0,=NUM          ; R0 = address of input array
        LDR R6,=RESULT       ; R6 = address of result array

        ; Copy NUM into RESULT
        MOV R1,#5
        MOV R2,R0
        MOV R3,R6

COPY
        LDR R4,[R2],#4
        STR R4,[R3],#4
        SUBS R1,R1,#1
        BNE COPY
        MOV R1,#5

OUTER
        MOV R2,R6
        MOV R3,R1
        SUB R3,R3,#1

INNER
        LDR R4,[R2]
        LDR R5,[R2,#4]

        CMP R4,R5
        BLS NOSWAP

        STR R5,[R2]
        STR R4,[R2,#4]

NOSWAP
        ADD R2,R2,#4
        SUB R3,R3,#1
        CMP R3,#0
        BNE INNER

        SUB R1,R1,#1
        CMP R1,#1
        BHI OUTER

STOP
        B STOP


NUM
        DCD 5,2,8,1,4
		

        AREA data, DATA, READWRITE

RESULT
        DCD 0,0,0,0,0

        END