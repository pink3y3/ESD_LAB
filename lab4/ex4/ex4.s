; Linear search in an array of ten 32-bit numbers

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

        LDR R0,=NUMS          ; R0 = address of array
        LDR R1,=KEY           ; R1 = address of key
        LDR R2,[R1]           ; R2 = key value
        MOV R3,#10            ; R3 = number of elements

LOOP
        LDR R4,[R0],#4        ; Load one element and move to next
        CMP R4,R2             ; Compare element with key
        BEQ FOUND             ; If equal, key is found

        SUBS R3,R3,#1         ; Decrease counter
        BNE LOOP              ; Repeat if elements remain

NOTFOUND
        B STOP

FOUND
        B STOP

STOP
        B STOP


NUMS
        DCD 1,2,3,4,5,6,7,8,9,10

KEY
        DCD 3

        AREA data, DATA, READWRITE

        END