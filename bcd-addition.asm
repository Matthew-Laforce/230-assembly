; bcd-addition.asm
;
; CSC 230: Spring 2024
; Matthew Laforce
; V01019219
;
; Code provided for Assignment #1
;
; Mike Zastre (2022-Sept-22)
;
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; Your task: Two packed-BCD numbers are provided in R16
; and R17. You are to add the two numbers together, such
; the the rightmost two BCD "digits" are stored in R25
; while the carry value (0 or 1) is stored R24.
;
; For example, we know that 94 + 9 equals 103. If
; the digits are encoded as BCD, we would have
;   *  0x94 in R16
;   *  0x09 in R17
; with the result of the addition being:
;   * 0x03 in R25
;   * 0x01 in R24
;
; Similarly, we know than 35 + 49 equals 84. If 
; the digits are encoded as BCD, we would have
;   * 0x35 in R16
;   * 0x49 in R17
; with the result of the addition being:
;   * 0x84 in R25
;   * 0x00 in R24
;

; ANY SIGNIFICANT IDEAS YOU FIND ON THE WEB THAT HAVE HELPED
; YOU DEVELOP YOUR SOLUTION MUST BE CITED AS A COMMENT (THAT
; IS, WHAT THE IDEA IS, PLUS THE URL).



    .cseg
    .org 0

	; Some test cases below for you to try. And as usual
	; your solution is expected to work with values other
	; than those provided here.
	;
	; Your code will always be tested with legal BCD
	; values in r16 and r17 (i.e. no need for error checking).

	; 94 + 9 = 03, carry = 1
	; ldi r16, 0x94
	; ldi r17, 0x09

	; 86 + 79 = 65, carry = 1
	ldi r16, 0x86
	ldi r17, 0x79

	; 35 + 49 = 84, carry = 0
	; ldi r16, 0x35
	; ldi r17, 0x49

	; 32 + 41 = 73, carry = 0
	; ldi r16, 0x32
	; ldi r17, 0x41

; ==== END OF "DO NOT TOUCH" SECTION ==========

; **** BEGINNING OF "STUDENT CODE" SECTION **** 
; =================================================================
;
; My approach for adding the BCD values will be to use the method
; covered in class- split the values up into nibbles, add the
; nibbles from least to greatest, and handle the carries. 
; 
; The first "chunk" of code just sets up some variables- there's 
; not much going on there aside from the isolation of the big and 
; small nibbles, and the naming of a constant 6 and 10 for handling 
; and detecting carries respectively. 
;
; The second "chunk" handles the main logic, adding the small 
; nibbles first; if their sum exceeds 9, raise it by 6, erase the 
; "extra", and pass the carry to the big nibbles. The big nibbles
; are handled similarly, except carries go to R24.
;
; Finally, it formats the answer and sticks it in R25.
;
; Define and set some registers to extract nibbles
	.def temp1 = R18
	ldi temp1, 0b11110000
	.def temp2 = R19
	ldi temp2, 0b00001111
; Prepare the big/small nibbles of firstVal
	.def firstBig = R20
	mov firstBig, R16
	and firstBig, temp1
	swap firstBig
	.def firstSmall = R21
	mov firstSmall, R16
	and firstSmall, temp2
; Then the big/small nibbles of secondVal
	.def secondBig = R22
	mov secondBig, R17
	and secondBig, temp1
	swap secondBig
	.def secondSmall = R23
	mov secondSmall, R17
	and secondSmall, temp2
; Name registers R24 and R25
	.def carry = R24
	ldi carry, 0
	.def solution = R25
	ldi solution, 0
; Reuse R16 for comparing nibbles to "10" for carry checks
	.def carryCheck = R16
	ldi carryCheck, 0b00001010
; Reuse R17 for adding "6" in case of carries
	.def addSix = R17
	ldi addSix, 0b00000110
;
; =================================================================
;
; Now into the main logic of the code.
	add firstSmall, secondSmall
	cp firstSmall, carryCheck
	brlo noSmallCarry
		; This section is only reached if the small nibble sum 
		; exceeds 10. If so, add 6 and increment a big nibble.
		inc firstBig
		add firstSmall, addSix
		and firstSmall, temp2
		;
	noSmallCarry:
	add firstBig, secondBig
	cp firstBig, carryCheck
	brlo noBigCarry
		; This section is reached if the sum of the big nibbles
		; exceeds 10. If so, add 6 and increment "carry" register.
		inc carry
		add firstBig, addSix
		and firstBig, temp2
		;
	noBigCarrY:
	; Now simply swap the big nibble back into position, add the
	; nibbles, and move the sum into "solution".
	swap firstBig
	add firstBig, firstSmall
	mov solution, firstBig
; Done
;
; =================================================================
; **** END OF "STUDENT CODE" SECTION ********** 

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
bcd_addition_end:
	rjmp bcd_addition_end



; ==== END OF "DO NOT TOUCH" SECTION ==========