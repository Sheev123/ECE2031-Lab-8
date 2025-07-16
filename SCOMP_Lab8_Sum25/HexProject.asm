; HexPeripheralTest.asm
        ORG     0

;Value Modes with and without Override

LOAD ValBinOverride
OUT HEX1

; TestValModes:
        ; ; HEX Mode value = &H123
        ; LOAD   ValHexNoOverride
        ; OUT     Hex1
		; OUT		Hex0

        ; LOAD   ValHexOverride
        ; OUT     Hex1

        ; CALL    Delay

        ; ; DEC Mode value = 10
        ; LOAD   ValDecNoOverride
        ; OUT     Hex0

        ; LOAD   ValDecOverride
        ; OUT     Hex1

        ; CALL    Delay

        ; ; BIN Mode value = 15
        ; LOAD   ValBinNoOverride
        ; OUT     Hex0

        ; LOAD   ValBinOverride
        ; OUT     Hex1

        ; CALL    Delay

; ;Full Control Mode
; ;Loop through digits 0 to 5 with one segment pattern

        ; LOADI   0
        ; STORE   DigitIndex

; DigitLoop:
        ; LOAD    DigitIndex
        ; ADDI    -6
        ; JZERO   Done

        ; ;shift digit index into bits 13:11
        ; LOAD    DigitIndex
        ; SHIFT   11
        ; STORE   TempDigitBits

        ; ; Load segment pattern(&B01010100)
        ; LOAD   SegmentPattern
        ; STORE   TempSegBits

        ; ;combine digit bits + segment bits
        ; LOAD    TempDigitBits
        ; ADD     TempSegBits
        ; STORE   TempCombined

        ; ; add mode bits (Mode = 11, override = 0)
        ; LOAD    FullCtrlModeBits
        ; ADD     TempCombined
        ; STORE   FullCtrlWord

        ; ;write to HEX0
        ; LOAD    FullCtrlWord
        ; OUT     Hex0

        ; CALL    Delay

        ; ;increment digit index and loop
        ; LOAD    DigitIndex
        ; ADDI    1
        ; STORE   DigitIndex
        ; JUMP    DigitLoop

; Done:
        ; JUMP    Done
; Delay:
        ; OUT     Timer
; WaitLoop:
        ; IN      Timer
        ; ADDI    -5
        ; JNEG    WaitLoop
        ; RETURN

;Test Values for Value test

ValHexNoOverride:     DW &B0000000000010001   ; MODE=00, override=0, value=&H123
ValHexOverride:       DW &B0010000100100011   ; MODE=00, override=1, value=&H123

ValDecNoOverride:     DW &B0100000000001010   ; MODE=01, override=0, value=10
ValDecOverride:       DW &B0110000000001010   ; MODE=01, override=1, value=10

ValBinNoOverride:     DW &B1000000000001111   ; MODE=10, override=0, value=15
ValBinOverride:       DW &B1010000000001111   ; MODE=10, override=1, value=15

;Segment Pattern for Full Control Test 
SegmentPattern:       DW &B0000000001010100   ;

;I/O Addresses
Hex0:         EQU 004
Hex1:         EQU 005
Timer:        EQU 002

;Temporary Registers
DigitIndex:     DW 0
TempDigitBits:  DW 0
TempSegBits:    DW 0
TempCombined:   DW 0
FullCtrlWord:   DW 0

;Constants
FullCtrlModeBits: DW &HC000
