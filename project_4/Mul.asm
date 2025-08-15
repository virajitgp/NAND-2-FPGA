	;===============================================
	; Computes R0 * R1 and stores result in R2
	;===============================================

	; Program to calculate R2 = 3 * 2 (This will now work)

	LDI R0, 3; Load the value 3 into R0
	LDI R1, 2; Load the counter 2 into R1
	SUB R2, R2, R2; Clear R2 to 0 for the result
	SUB R15, R15, R15; Clear R15 to 0, we'll use it for comparison

LOOP_CHECK:
	;     Check if our counter R1 is zero. CMPEQ now sets Z flag correctly.
	CMPEQ R15, R1, R15; Sets Z flag to 1 if R1 == 0
	BZ    DONE; If Z flag is set, jump to DONE

	;    If we are here, the counter is not zero, so we do the work
	ADD  R2, R2, R0; Add the value to our result (R2 = R2 + 3)
	ADDI R1, R1, 15; Decrement the counter (R1 = R1 - 1)
	JMP  LOOP_CHECK; Go back to the check at the top of the loop

DONE:
	;   Halt the CPU by jumping to the same spot forever.
	JMP DONE
