;transfer 10 32-bit numbers from one memory to another when the src and dst are overlapping

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

		LDR R0,=SRC
		LDR R1,=DST
		MOV R2,#10
		CMP R1,R0
		BLS FORWARD_COPY
		
BACKWARD_COPY
		ADD R0,R0,#36
		ADD R1,R1,#36

B_LOOP
		LDR R3,[R0],#-4
		STR R3,[R1],#-4
		SUBS R2,R2,#1
		BNE B_LOOP
		B STOP
		
FORWARD_COPY
F_LOOP
		LDR R3,[R0],#4
		STR R3,[R1],#4
		SUBS R2,R2,#1
		BNE F_LOOP
		
STOP	B STOP
		ALIGN
		
SRC     DCD     11, 12, 13, 14, 15, 16, 17, 18, 19, 20
        ALIGN

        AREA    Data_Storage, DATA, READWRITE
        ALIGN                     

DST     SPACE   40                  

        END