; IODemo.asm
; Produces a "bouncing" animation on the LEDs.
; The LED pattern is initialized with the switch state.

ORG 0

	; Get and store the switch values
	IN     Switches
	OUT LEDs
    STORE Pattern
    JUMP CheckerInit
CheckSwitches:
	IN Switches
    STORE Pattern
	LOAD Counter
    JZERO CheckerInit
	OUT    LEDs
	
Left:
	; Slow down the loop so humans can watch it.
	CALL   Delay

	; Check if the left place is 1 and if so, switch direction
	LOAD   Pattern
	AND    Bit9         ; bit mask
	JNZ    Right        ; bit9 is 1; go right
	
	LOAD   Pattern
	SHIFT  1
	STORE  Pattern
	OUT    LEDs

	JUMP   Left
	
Right:
	; Slow down the loop so humans can watch it.
	CALL   Delay

	; Check if the right place is 1 and if so, switch direction
	LOAD   Pattern
	AND    Bit0         ; bit mask
	JNZ    Left         ; bit0 is 1; go left
	
	LOAD   Pattern
	SHIFT  -1
	STORE  Pattern
	OUT    LEDs
	
	JUMP   Right
	
; To make things happen on a human timescale, the timer is
; used to delay for half a second.
Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -5
	JNEG   WaitingLoop
	RETURN

CheckerInit:
	LOADI 3
    STORE Counter
    LOADI 10
    STORE LoopCounter
    LOAD Pattern
    STORE PatternCheck    

CheckerLoop:
    LOAD PatternCheck
    AND Bit0
    JNZ LEDFound
    LOAD PatternCheck
    SHIFT -1
    STORE PatternCheck
    LOAD LoopCounter
    ADDI -1
    STORE LoopCounter
    JZERO CheckSwitches
    JUMP CheckerLoop
    
LEDFound:
	LOAD Counter
    ADDI -1
    STORE Counter
    JZERO CheckSwitches
    LOAD PatternCheck
    SHIFT -1
    STORE PatternCheck
    LOAD LoopCounter
    ADDI -1
    STORE LoopCounter
    JUMP CheckerLoop


; Variables
Pattern:      DW 0
PatternCheck: DW 0
Counter: 	  DW 3
LoopCounter:  DW 0

; Useful values
Bit0:      DW &B0000000001
Bit9:      DW &B1000000000

; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
