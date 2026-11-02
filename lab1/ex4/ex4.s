;reverse an array of ten 32-bit numbers in memory

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

        LDR R0, =SRC
        MOV R2, #5
        MOV R1, #36

LOOP
        LDR R3, [R0]
        LDR R4, [R0, R1]
        STR R3, [R0, R1]
        STR R4, [R0]

        ADD R0, R0, #4
        SUB R1, R1, #4

        SUBS R2, R2, #1
        BNE LOOP

STOP
        B STOP

        AREA Data_Storage, DATA, READWRITE
        ALIGN

SRC
        DCD 11, 12, 13, 14, 15, 16, 17, 18, 19, 20

        END