; Selection Sort with RESULT variable

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
        MOV R1,#5            ; Number of elements
        MOV R2,R0            ; R2 = source address
        MOV R3,R6            ; R3 = destination address

COPY
        LDR R4,[R2]
        STR R4,[R3]
        ADD R2,R2,#4
        ADD R3,R3,#4
        SUBS R1,R1,#1
        BNE COPY

        ; Selection sort RESULT
        MOV R1,#5            ; Number of elements

OUTER
        MOV R2,R6            ; R2 = address of current element
        MOV R3,R2            ; R3 = address of minimum element
        ADD R4,R2,#4         ; R4 = address of next element

        MOV R5,R1
        SUB R5,R5,#1         ; Number of comparisons

INNER
        LDR R7,[R3]          ; R7 = current minimum
        LDR R8,[R4]          ; R8 = next element

        CMP R8,R7
        BHS NOSWAP           ; If next >= minimum, no change

        MOV R3,R4            ; R3 = address of new minimum

NOSWAP
        ADD R4,R4,#4         ; Move to next element
        SUB R5,R5,#1
        CMP R5,#0
        BNE INNER

        ; Swap current element with minimum element
        LDR R7,[R2]
        LDR R8,[R3]

        STR R8,[R2]
        STR R7,[R3]

        ADD R6,R6,#4         ; Move to next position
        SUB R1,R1,#1
        CMP R1,#1
        BHI OUTER

STOP
        B STOP


        AREA data, DATA, READWRITE

NUM
        DCD 5,2,8,1,4

RESULT
        DCD 0,0,0,0,0

        END