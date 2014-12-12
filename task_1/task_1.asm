assume CS:cseg, DS:DSeg, SS:sseg 

sseg segment stack
	db 256 dup (?)
sseg ends 

dseg segment
	list DW 1, 3, 5, -7
	quantity DW ($ - list) / type(list)
	last_idx_in_list DW ?
	tmp DW ?
	sum DW ?
dseg ends

cseg segment
include OutInt.inc

main:
	MOV AX, DSeg
	MOV DS, AX					; load data to data segment
	
	MOV CX, quantity			; the number of reiterations of our circle
	MOV SI, 0					; clean index register [our list starts from poSItion 0]
	MOV sum, 0					; let the sum equal zero
		
	MOV AX, quantity	
	SUB AX, 1					; AX = quantity - 1
	MOV BX, 2					; BX = 2
	MUL BX						; AX *= BX, that means AX = (quantity - 1) * 2
	MOV last_idx_in_list, AX 	; last = (quantity - 1) * 2, where 2 is the SIze of word

	cirle_on_list: 	MOV DX, list[SI]				; CALL ordered number on DX register
					MOV AX, DX						; save it to AX register
					MOV tmp, SI						; save current SI to change it without problems
					MOV SI, last_idx_in_list		; change SI to poINT on poSItion (quantity - i + 1)
					MOV DX, list[SI]				; DX = list[quantity - i + 1]
					MOV BX, DX						; .....
					MUL BX							; AX *= BX or in terms of our task: AX = lst[i] * lst[quantity - i + 1]
					ADD sum, AX						; sum += AX
					MOV SI, tmp						; give SI register it's current index
					ADD SI, 2						; increase SI on the SIze of word ( ++i in c++)
					SUB last_idx_in_list, 2			; decrease reverse iterator
	LOOP cirle_on_list								; if (!CX) break;

	MOV AX, sum										; AX = sum


CALL OutInt										; cout << AX << endl;
;return to os
MOV AX, 4c00h
INT 21h

cseg ends
end main

