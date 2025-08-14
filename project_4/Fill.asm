;===============================================
; Continuously fills screen with black if key 
; is pressed, or white otherwise
;===============================================

; Memory-mapped I/O addresses
KEYBOARD_STATUS: .equ 0xF000   ; Keyboard status register
SCREEN_START:    .equ 0xE000   ; Start of screen memory
SCREEN_SIZE:     .equ 4096     ; 64x64 pixels (4096 words)

; Define constants
WHITE:  .equ 0x0000
BLACK:  .equ 0xFFFF

    ; Initialize registers
    ADDI R3, R0, KEYBOARD_STATUS  ; R3 = address of keyboard status
    ADDI R4, R0, SCREEN_START     ; R4 = start address of screen memory
    ADDI R5, R0, SCREEN_SIZE      ; R5 = screen size (pixel count)
    ADDI R6, R0, 1                ; R6 = 1 (constant for comparison)

;main_loop:
    ; Check keyboard status
    LOAD R1, R3, 0                ; R1 = keyboard status
    AND  R1, R1, R6               ; Isolate bit 0 (key pressed status)
    
    ; Set color based on keyboard status
    ADDI R2, R0, WHITE            ; Default color = WHITE
    CMPEQ R7, R1, R6              ; Check if key is pressed (R1 == 1)
    BNE R7, R6, set_pixels        ; If not pressed, keep R2 = WHITE
    ADDI R2, R0, BLACK            ; If pressed, R2 = BLACK

;set_pixels:
    ; Initialize counter and screen position
    ADDI R7, R0, 0                ; R7 = pixel counter (0 to SCREEN_SIZE-1)
    ADDI R1, R4, 0                ; R1 = current screen position

;fill_screen:
    ; Fill current pixel with color in R2
    STORE R2, R1, 0               ; Store color at current position
    
    ; Move to next pixel
    ADDI R1, R1, 1                ; Advance to next pixel address
    ADDI R7, R7, 1                ; Increment counter
    
    ; Check if we've filled the entire screen
    CMPLT R3, R7, R5              ; R3 = (R7 < R5) ? 1 : 0
    BEQ R3, R0, main_loop         ; If R3 == 0 (done), go back to main loop
    JUMP fill_screen              ; Otherwise, continue filling
