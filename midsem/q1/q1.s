;a) Write a function to convert a 2 digit hexadecimal no. to ascii values

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

		LDR R4,=NUMS
		LDR R5,=RES
		MOV R6,#10
		
LOOP
		LDRB R2,[R4],#1
		AND R3,R2,#0xF0
		LSR R3,R3,#4
		CMP R3,#9
		ADDHI R3,R3,#7
		ADD R3,R3,#0x30
		STRB R3,[R5],#1
		
		AND R3,R2,#0x0F
		CMP R3,#9
		ADDHI R3,R3,#7
		ADD R3,R3,#0x30
		STRB R3,[R5],#1
		
		SUBS R6,R6,#1
		BNE LOOP
		
;USING THIS CONVERT AN ARRAY OF 10 2-DIGIT HD NUMBERS INTO ASCII CHARACTERS
		
STOP	B STOP

NUMS	DCB 0X10,0X4A,0X0A,0X0E,0X23,0X12,0X19,0X31,0X4D,0X2B
		ALIGN
		AREA data, DATA, READWRITE
		
RES		SPACE 20
		END