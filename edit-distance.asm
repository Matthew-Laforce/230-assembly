; main.asm for edit-distance assignment
;
; CSC 230: Spring 2024
; Matthew Laforce
; V01019219
;
; Code provided for Assignment #1:
; Mike Zastre (2022-Sept-22)
;
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
;
; Your task: To compute the edit distance between two byte values,
; one in R16, the other in R17. If the first byte is:
;    0b10101111
; and the second byte is:
;    0b10011010
; then the edit distance -- that is, the number of corresponding
; bits whose values are not equal -- would be 4 (i.e., here bits 5, 4,
; 2 and 0 are different, where bit 0 is the least-significant bit).
; 
; Your solution must, of course, work for other values than those
; provided in the example above.
;
; In your code, store the computed edit distance value in R25.
;
; Your solution is free to modify the original values in R16
; and R17.
;
; ANY SIGNIFICANT IDEAS YOU FIND ON THE WEB THAT HAVE HELPED
; YOU DEVELOP YOUR SOLUTION MUST BE CITED AS A COMMENT (THAT
; IS, WHAT THE IDEA IS, PLUS THE URL).

    .cseg
    .org 0

; ==== END OF "DO NOT TOUCH" SECTION ==========
	ldi r16, 0xFF
	ldi r17, 0x00

; **** BEGINNING OF "STUDENT CODE" SECTION **** 
;
; =================================================================
;
; My approach to this code is fairly simple: it performs bitwise
; comparisons from smallest to largest bit using a loop with an 
; index that logically shifts left after each comparison.
; 
; When a non-match is found, solution is incremented. When the
; index is compared to 0 and equality is found, every bit has been 
; compared - so the loop breaks. 
;
; Name the initial registers, as well as some reusable "boxes"
	.def firstVal = R16
	.def secondVal = R17
	.def firstBox = R18
	.def secondBox = R19
; R20 is an index for pointing at bit position
	ldi r20, 0b00000001
	.def index=r20
; The solution goes in R25- I also use it as an accumulator
	clr r25
	.def distance=r25
; Now onto the actual comparisons.
	bitLoop:
	; On each loop, duplicate r16 and r17 into their "boxes"
		mov firstBox, firstVal
		mov secondBox, secondVal
	; Erase the extra bits then check equality
		and firstBox, index
		and secondBox, index
		cp firstBox, secondBox
		breq skipInc
			; This code is reached if the bits do not match.
			; Increments 'distance'.
			inc distance
		skipInc:
	; Handle the logic for the loop
		lsl index
		cpi index, 0
		brne bitLoop
; Done
;
; =================================================================
;
; **** END OF "STUDENT CODE" SECTION ********** 

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
edit_distance_stop:
    rjmp edit_distance_stop



; ==== END OF "DO NOT TOUCH" SECTION ==========