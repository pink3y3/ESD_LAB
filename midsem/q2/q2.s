;convert 2-digit ascii into 2 hd and then do it for 5 2-digit hd numbers in ascii to their hs values

		AREA RESET, DATA, READONLY
		EXPORT __Vectors
__Vectors
		DCD 0x10001000 ; stack pointer value when stack is empty
		DCD Reset_Handler ; reset vector
		ALIGN
		AREA mycode, CODE, READONLY
		ENTRY
		EXPORT Reset_Handler
		
Reset_Handler

		LDR R0,=NUMS
		LDR R1,=RES
		MOV R2,#5
		
LOOP
		LDRB R3,[R0],#1
		LDRB R4,[R0],#1
		
		CMP R3,#'9'
		SUBLS R5,R3,#0X30
		SUBHI R5,R3,#0X37
		
		CMP R4,#'9'
		SUBLS R6,R4,#0X30
		SUBHI R6,R4,#0X37
		
		LSL R5,R5,#4
		ADDS R5,R5,R6
		STRB R5,[R1],#1
		SUBS R2,R2,#1
		BNE LOOP
		
STOP
        B STOP

NUMS
        DCB "2A","4F","10","B3","C7"
		ALIGN
        AREA data, DATA, READWRITE

RES
        SPACE 5
        END
		