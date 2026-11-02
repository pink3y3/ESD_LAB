;BCD MULTIPLICATION

		AREA RESET, DATA, READONLY
        EXPORT __Vectors

__Vectors
        DCD 0x10001000
        DCD Reset_Handler

        ALIGN
        AREA MYCODE, CODE, READONLY
        ENTRY
        EXPORT Reset_Handler

Reset_Handler

        ; Load BCD number 1 = 25
        LDR R0,=NUM1
        LDRB R1,[R0]

        ; Convert BCD 25 to binary
        ; R2 = tens digit
        MOV R2,R1
        LSR R2,R2,#4

        ; R3 = ones digit
        AND R3,R1,#0x0F

        ; 10 × tens + ones
        MOV R4,#10
        MUL R2,R2,R4
        ADD R1,R2,R3        ; R1 = 25

        ; Load BCD number 2 = 12
        LDR R0,=NUM2
        LDRB R2,[R0]

        ; Convert BCD 12 to binary
        MOV R3,R2
        LSR R3,R3,#4

        AND R4,R2,#0x0F

        MOV R5,#10
        MUL R3,R3,R5
        ADD R2,R3,R4        ; R2 = 12

        ; Multiply
        MUL R6,R1,R2        ; R6 = 25 × 12 = 300


        ; Convert 300 to BCD

        MOV R7,#100
        MOV R8,#0           ; hundreds digit

HUNDREDS
        CMP R6,R7
        BLO TENS
        SUB R6,R6,R7
        ADD R8,R8,#1
        B HUNDREDS

TENS
        MOV R7,#10
        MOV R9,#0           ; tens digit

TENS_LOOP
        CMP R6,R7
        BLO ONES
        SUB R6,R6,R7
        ADD R9,R9,#1
        B TENS_LOOP

ONES
        ; R6 = ones digit

        ; Construct BCD result
        ; hundreds in bits 8-11
        ; tens in bits 4-7
        ; ones in bits 0-3

        LSL R8,R8,#8
        LSL R9,R9,#4

        ADD R10,R8,R9
        ADD R10,R10,R6

        ; Store BCD result
        LDR R0,=RESULT
        STR R10,[R0]

STOP
        B STOP

        ALIGN

NUM1    DCB 0x25
NUM2    DCB 0x12

        AREA DATASEG, DATA, READWRITE

RESULT  DCD 0

        END