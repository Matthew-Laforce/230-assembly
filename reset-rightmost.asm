; reset-rightmost.asm
;
; CSC 230: Spring 2024
; Matthew Laforce
; V01019219
;
; Code provided for Assignment #1
; Mike Zastre (2022-Sept-22)
;
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; Your task: You are to take the bit sequence stored in R16,
; and to reset the rightmost contiguous sequence of set
; by storing this new value in R25. For example, given
; the bit sequence 0b01011100, resetting the right-most
; contigous sequence of set bits will produce 0b01000000.
; As another example, given the bit sequence 0b10110110,
; the result will be 0b10110000.
;
; Your solution must work, of course, for bit sequences other
; than those provided in the example. (How does your
; algorithm handle a value with no set bits? with all set bits?)

; ANY SIGNIFICANT IDEAS YOU FIND ON THE WEB THAT HAVE HELPED
; YOU DEVELOP YOUR SOLUTION MUST BE CITED AS A COMMENT (THAT
; IS, WHAT THE IDEA IS, PLUS THE URL).

    .cseg
    .org 0

; ==== END OF "DO NOT TOUCH" SECTION ==========
	ldi R16, 0b01011100
	; ldi R16, 0b10110110
	; ldi R16, 0b10000011
	; ldi R16, 0b11000001
	; ldi R16, 0b01010101
	; ldi R16, 0b10101010

; **** BEGINNING OF "STUDENT CODE" SECTION **** 
;
; =================================================================
; 
; The approach used here is essentially to loop through R16
; bit-by-bit, from least significant to most significant, branching 
; into different cases depending on what is found. 
; 
; Cases where R16 contains contiguous bits are identified by counting 
; "1"s then looking for some instance with at least 2 in a row. This
; is slightly complicated by the different ways this grouping can be
; broken: either by the presence of a subsequent 0, or by the ending
; of the byte. Both need to be considered. 
;
; It is also possible to get a number with no contiguous bytes, like
; 0b10101010. This can be tested for on reaching the end of the byte,
; by confirming whether or not contiguous bits have been located. 
; 
; Overall this causes the code to essentially split into 6 cases, 
; depending on whether you find a 0 or a 1, depending on whether the
; index has reached the end, and depending on whether or not 
; contiguous bits have been found. 
;
; This code is more complex than "A1-Part-A", and I have broken it
; into parts: the first part is just some declarations, while the
; second part is the logic of the code. 
;
;
; PART ONE -- DECLARATIONS:
; Name and set the default variables.
	.def seq = R16
	.def seqBox = R17
	.def solution = R25
	mov solution, seq
; Store the count of contiguous bits in 'contLength'.
	ldi r18, 0
	.def contLength=r18
; Copies of any contiguous bit sequences are created in 'contBit'.
	ldi r19, 0
	.def contBit=r19
; Bit position is tracked using 'index'.
	ldi r20, 1
	.def index=r20
; 'stop' is an end condition.
	ldi r21, 0b10000000
	.def stop=r21
;
; =================================================================
; 
; PART TWO -- LOGIC:
; Regardless of whether a 0 or 1 is found for some bit, each
; loop can branch into three cases:
;
; (1) Contiguous bits have been found, branch to "solve";
; (2) There are no contiguous bits, branch to "finishCode";
; (3) Reset [0] or increment [1] 'contLength'; lsl then loop. 
;
; So cases are split into 0 or 1, then sorted into the above. 
;
	loop:
		; Determine whether the bit in "index" is 0 or 1. 
		mov seqBox, seq
		and seqBox, index
		cp seqBox, index
		breq trueBit
		; Code in here runs if a bit is 0.
		; First check if contiguous bits were found.
			cpi contLength, 2
			brpl solve     ;(1)
		; Next, check if there are bits left.
			cp index, stop
			breq finishCode     ;(2)
		; If so, loop again.
			ldi contLength, 0
			ldi contBit, 0
			lsl index
			jmp loop     ;(3)
		;
		trueBit:
		; This code runs instead if a 1 is found.
			inc contLength
			or contBit, index
		; Branch to 'loopAgain' if there are bits left;
			cp index, stop
			brne loopAgain
		; Otherwise, check if contiguous bits were found.
			cpi contLength, 2
			brpl solve     ;(1)
			jmp finishCode     ;(2)
		; Handle cases where there are still bits.
			loopAgain:
				lsl index
				jmp loop     ;(3)
	solve:
		; If contiguous bits are found, the code branches here:
		; 'contBit' holds a copy of the rightmost contiguous bits,
		; while 'solution' holds the initial term- so, a logical
		; EOR erases the contiguous bits.
		eor solution, contBit
	finishCode:
		; If contiguous bits are NOT found, the code branches
		; here instead, resulting in the initial value being
		; returned. 
; Done
;
; =================================================================
;
; **** END OF "STUDENT CODE" SECTION ********** 

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
reset_rightmost_stop:
    rjmp reset_rightmost_stop

; ==== END OF "DO NOT TOUCH" SECTION ==========