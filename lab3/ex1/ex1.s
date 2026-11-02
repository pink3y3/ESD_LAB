;convert a 2 digit hexadecimal number into unpacked ascii

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

		LDR R0,=NUM
		LDR R1,=RESULT
		LDRB R1,[R0] ; LOAD JUST FIRST BYTE - 8 BITS - 2 HD
		
		AND R2,R1,#0xF0 ; extract upper hd
		LSR R2,R2,#4
		CMP R2,#9
		ADDHI R2,R2,#7
		ADD R2,R2,#0x30
		STRB R2,[R3]
		
		AND R2,R1,#0x0F
		CMP R2,#9
		ADDHI R2,R2,#7
		ADD R2,R2,#0x30
		STRB R2,[R3,#1]
		
STOP 
		B STOP
		
NUM		DCB 0x3A
		AREA data, DATA, READWRITE
		
RESULT	
		SPACE 2
		END
		

		