; Program to fill the screen, one pixel per keypress.

; --- Initialization ---
; R14 will be a temp register for shift values
LDI R14, 12
LDI R0, 8
SHL R0, R0, R14 ; R0 = 0x8000 (Video RAM start)

LDI R1, 12
SHL R1, R1, R14 ; R1 = 0xC000 (Keyboard buffer)

LDI R14, 4
LDI R2, 15
SHL R2, R2, R14
ADDI R2, R2, 15 ; R2 = 255 (White color)

; R15 will be our permanent 'zero' register for comparisons
SUB R15, R15, R15

; --- Main Loop ---
WAIT_FOR_KEY:
    ; Load the keyboard buffer into R3.
    LOAD R3, R1, 0
    
    ; Compare R3 to our zero register (R15).
    ; The result (1 or 0) is stored in R4, which we ignore.
    ; The important part is that this sets the Z flag correctly
    ; without changing R15.
    CMPEQ R4, R3, R15
    
    ; If Z flag is 1 (meaning R3 was 0), no key was pressed, so loop.
    BZ WAIT_FOR_KEY

; --- Key was pressed, so draw the pixel ---
DRAW_PIXEL:
    ; Write the color in R2 to the screen address in R0
    STORE R2, R0, 0
    
    ; Move to the next pixel on the screen
    ADDI R0, R0, 1
    
    ; Go back and wait for the next keypress
    JMP WAIT_FOR_KEY
