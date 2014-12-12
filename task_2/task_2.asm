assume CS:cseg, DS:DSeg, SS:sseg 

sseg segment stack
	db 256 dup (?)
sseg ends 

dseg segment
	matrix 				DW 1, 2, 3
						DW 4, 5, 6
						DW 7, 8, 9
			
	result_matrix		dw 3 dup(?)
						dw 3 dup(?)
						dw 3 dup(?)

	quantity dw 3
	
	j dw 0
	i dw 0
	new_line db 0Ah, 0Dh, '$'
	tabulation db 20h, '$'
dseg ends

cseg segment
include OutInt.inc

main:
	mov ax, dseg
	mov ds, ax				; load data to data segment

	lea bx, matrix
	lea si, matrix[bx]
	
	push bx
	push si
	lea bx, result_matrix
	push bx
	push quantity
	
	call Multiply
	
	
	Multiply proc near
		push bp
		mov bp, sp
		sub sp, 12						; new 6 local parameters :)
		

		and word ptr[bp - 2], 0			; i = 0  	->	word ptr[bp - 2]  
		and word ptr[bp - 4], 0			; j = 0		->	word ptr[bp - 4]  
		and word ptr[bp - 6], 0			; k = 0		->	word ptr[bp - 6]  
		and word ptr[bp - 8], 0			; sum = 0	->	word ptr[bp - 8]  
	
		mov cx, [bp + 4]				; cx = quantity of elements in row or column

		i_circle:
			and word ptr[bp-6], 0				; for (k = 0...  
			k_circle:
				and word ptr[bp-8], 0			; sum = 0
				and word ptr[bp-4], 0			; for(j = 0;...)
				j_circle:
					;---GETTING ELEMENT MATRIX[I][J]---	
					mov ax, word ptr[bp - 2]		; ax = i
					mov bx, word ptr[bp + 4]		; bx = quantity
					mul bx							; ax = ax * bx = i * quantity
					add ax, word ptr[bp-4]			; ax = i * quantity + j
					shl ax, 1						; ax = ax * 2 ('cause size of word == 2) 
					mov bx, ax						; save to bx 'cause mov ax, matrix[ax]  is an error
					mov ax, matrix[bx]				; ax = matrix[i][j] in C++ notation
					;----------------------------------
					
					mov word ptr[bp-10], ax			; save matrix[i][j] in local memory
			
					;---GETTING ELEMENT MATRIX[J][K]---	
					mov ax, word ptr[bp-4]			; ax = j
					mov bx, word ptr[bp + 4]		; bx = quantity
					mul bx							; ax = j * quantity
					add ax, word ptr[bp-6]			; ax = j * quantity + k
					shl ax, 1						; ax *= 2
					mov bx, ax						; ...the same idea
					mov ax, matrix[bx]				; ax = matrix[j][k] in C++ notation
					;----------------------------------
					; COUNT SUM IN CIRCLE (MULTIPLY ROW ON A COLUMN)
					mul word ptr[bp-10]				; ax = matrix[j][k] * matrix[i][j]
					add word ptr[bp-8], ax			; sum += ax
	
					inc word ptr[bp-4]				; ++j
					cmp word ptr[bp-4], cx			; do while (j < quantity)
				jl j_circle
				;---GETTING ELEMENT RESULT_MATRIX[I][K] USING THE PREVIOUS IDEAS(ABOVE)---	
				mov ax, word ptr[bp-2]  			; ax = i
				mov bx, cx							; bx = quantity
				mul bx								; ax = i * quantity
				add ax, word ptr[bp-6]				; ax = i * quantity + k
				shl ax, 1							; ax *= 2 
				mov bx, ax							; ...
				mov ax, word ptr[bp-8]				; get to register ax the SUM
				mov result_matrix[bx], ax 			; matrix_result[I][K] = sum
						
				inc word ptr[bp-6]					; k++
				cmp word ptr[bp-6], cx				; do while (k < quantity)
			jl k_circle
			inc word ptr[bp - 2]					; i++
			cmp word ptr[bp - 2], cx				; do while (i < quantity)
		jl i_circle
					
		mov sp, bp									; clean stack after our actions
		pop bp
	Multiply endp
	
	;---PRINT RESULT MATRIX----- (MAYBE I SHOULD DO ANOTHER FUNCTION)
	
	mov cx, quantity
	mov si, 0
	and i, 0								; for ( i = 0 ....)
	
	idx_circle:
		and j, 0							; for ( j = 0 ...) 
		jj_circle:	
			mov ax, result_matrix[si]		; in consequence print elements in matrix, only adding size(word) to SI
			
			push cx
			call OutInt						; print another element in result_matrix
			pop cx
			
			mov dx, offset tabulation		; put enter between each two elements in print
			mov ah, 9h
			int 21h
			
			inc j							; j++
			add si, 2						; SI += 2  -> get next element from result_matrix
			cmp j, cx						; do while (j < quantity)
		jl jj_circle
			
			mov dx, offset new_line			; print('\n')
			mov ah, 9h			
			int 21h
			
			inc i							; i++
			cmp i, cx						; do while (i< quantity)
	jl idx_circle
											;return to os
mov ax, 4c00h
int 21h

cseg ends
end main