;Lab 8 Game

ORG 0

    ADDI 0
    STORE Score
Reset:
	ADDI 0
    STORE Point
    STORE GuessNum
    STORE LSBNum
    STORE Counter
    OUT Hex0		   ;Display GuessNum
    IN Switches
    OUT LEDs
    JPOS ResetLoop
 ResetLoop:
	IN Switches
    OUT LEDs
    JPOS ResetLoop

CountLoop:
	LOAD GuessNum
    ADDI 1
    STORE GuessNum
    IN Switches
    SUB Bit9
    JNZ CountLoop
	
CalculateNum:
    LOAD GuessNum
    AND TwoFiveFive
    STORE GuessNum
    JPOS Skip
    ADDI 1
    STORE GuessNum

Skip:
    OUT Hex0			;Display GuessNum
    CALL FindLSB
    STORE GuessNumCounter
    JUMP WaitLoop


FindLSB:
	STORE LSBNum    	; Save original value
    LOADI 0             ; Counter = 0
    STORE Counter
LSB_Loop:
	LOAD LSBNum
    AND Bit0            ; Mask LSB
    JNZ LSB_Found       ; If LSB is 1 skip to LSB_Found
        
    LOAD LSBNum
    SHIFT -1			; Shift right
	STORE LSBNum

    LOAD Counter
    ADD Bit0             ; Increment counter
    STORE Counter
    JUMP LSB_Loop
LSB_Found:
    LOAD Counter  	    ; Result is in counter
    RETURN

WaitLoop:
	IN Switches
    JZERO Reset
    OUT LEDs
    SUB Bit9
    JZERO WaitLoop

Compare:
    IN Switches
    CALL FindLSB
    SUB GuessNumCounter
    JZERO Addpoint
    LOADI 0
    STORE Score
    OUT Hex1 			;Display Score
    JUMP Reset
 
AddPoint:
    LOAD Score
    ADDI 1
    STORE Score
    OUT Hex1 			;Display Score
    JUMP Reset

	
; Variables
GuessNum:        DW 0
GuessMask:	     DW 0
Score:		     DW 0
LSBNum:		     DW 0
Counter:	     DW 0
GuessNumCounter: DW 0
Point: 		     DW 0

; Useful values
Bit0:        DW &B0000000001
Bit9:        DW &B1000000000
TwoFiveFive:  DW 255

; IO address constants
Switches:    EQU 000
LEDs:        EQU 001
Timer:       EQU 002
Hex0:        EQU 004
Hex1:        EQU 005
