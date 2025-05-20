;===============================================
; Computes R0 * R1 and stores result in R2
;===============================================

; Note: This program assumes R0 and R1 already 
; contain the values to be multiplied

multiply:
    ; Direct multiplication using MUL instruction
    MUL R2, R0, R1        ; R2 = R0 * R1
    
    ; Program is complete, halt or loop
    JUMP end

;-----------------------------------------------
; Alternative implementation without using MUL
; (In case we want to implement multiplication manually)
;-----------------------------------------------

multiply_manual:
    ; Initialize result
    ADDI R2, R0, 0        ; R2 = 0 (accumulator)
    ADDI R3, R0, 0        ; R3 = 0 (counter)
    ADDI R4, R1, 0        ; R4 = R1 (preserve original value)
    ADDI R5, R0, 0        ; R5 = 0 (constant zero)
    
    ; Check if either operand is zero
    CMPEQ R6, R0, R5      ; R6 = (R0 == 0) ? 1 : 0
    BEQ R6, R5, check_r1  ; If R0 != 0, continue to check R1
    JUMP end              ; If R0 == 0, result is zero, goto end
    
check_r1:
    CMPEQ R6, R4, R5      ; R6 = (R4 == 0) ? 1 : 0
    BEQ R6, R5, mult_loop ; If R1 != 0, start multiplication
    JUMP end              ; If R1 == 0, result is zero, goto end

mult_loop:
    ; Check if we're done
    CMPEQ R6, R3, R4      ; R6 = (R3 == R4) ? 1 : 0
    BEQ R6, R5, mult_step ; If not done, continue
    JUMP end              ; If done, goto end
    
mult_step:
    ADD R2, R2, R0        ; R2 = R2 + R0
    ADDI R3, R3, 1        ; R3 = R3 + 1
    JUMP mult_loop        ; Repeat

end:
    ; End of program (infinite loop)
    JUMP end
