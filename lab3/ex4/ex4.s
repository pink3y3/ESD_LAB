; Convert 2-digit hexadecimal number in ASCII unpacked form
; into equivalent packed hexadecimal number

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

        LDRB R2,[R0]          ; Load first ASCII digit
        LDRB R3,[R0,#1]       ; Load second ASCII digit

        ; Convert first ASCII digit to hexadecimal
        CMP R2,#9
        SUBLS R2,R2,#0x30
        SUBHI R2,R2,#0x37

        ; Convert second ASCII digit to hexadecimal
        CMP R3,#9
        SUBLS R3,R3,#0x30
        SUBHI R3,R3,#0x37

        ; Pack the two hexadecimal digits
        LSL R2,R2,#4
        ADD R2,R2,R3

        STRB R2,[R1]

STOP
        B STOP

NUM
        DCB "2A"

        AREA data, DATA, READWRITE

RESULT
        SPACE 1

        END
```

For the input `"2A"`:

```text
ASCII '2' = 32H ? 02H
ASCII 'A' = 41H ? 0AH

02H << 4 = 20H
20H + 0AH = 2AH
```

So the final packed hexadecimal number is **2AH**, stored as one byte at `RESULT`.
