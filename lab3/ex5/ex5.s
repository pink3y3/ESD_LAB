; Convert 32-bit number in unpacked form into packed form

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
        LDR R1,=RESULT

        LDRB R2,[R0]          ; Load first digit
        LDRB R3,[R0,#1]       ; Load second digit
        LDRB R4,[R0,#2]       ; Load third digit
        LDRB R5,[R0,#3]       ; Load fourth digit
        LDRB R6,[R0,#4]       ; Load fifth digit
        LDRB R7,[R0,#5]       ; Load sixth digit
        LDRB R8,[R0,#6]       ; Load seventh digit
        LDRB R9,[R0,#7]       ; Load eighth digit

        LSL R2,R2,#28
        LSL R3,R3,#24
        LSL R4,R4,#20
        LSL R5,R5,#16
        LSL R6,R6,#12
        LSL R7,R7,#8
        LSL R8,R8,#4

        ADD R2,R2,R3
        ADD R2,R2,R4
        ADD R2,R2,R5
        ADD R2,R2,R6
        ADD R2,R2,R7
        ADD R2,R2,R8
        ADD R2,R2,R9

        STR R2,[R1]

STOP
        B STOP

NUM
        DCB 0,0,0,0,0,0,2,0AH
        AREA data, DATA, READWRITE

RESULT
        SPACE 4
        END
