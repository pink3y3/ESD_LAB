; convert 2-digit hex number into its equivalent bcd number

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
		LDRB R2,[R0]
		MOV R3,#0
		
LOOP
		CMP R2,#10
		BLO DONE
		SUB R2,R2,#10
		ADD R3,R3,#1
		B LOOP
DONE 	
		LSL R3,R3,#4 ;move tens digit to upper nibble
		ADD R3,R3,R2
		STRB R3,[R1]
		
STOP
        B STOP

NUM
        DCB 0x26               ; hexadecimal input
        AREA data, DATA, READWRITE

RESULT
        SPACE 1
        END		
		
		
		