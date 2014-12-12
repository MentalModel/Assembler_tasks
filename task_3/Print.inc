include OutInt.inc
PrintArray proc
	push bp
	mov bp, sp
	
	;sub sp, 4
	;tabulation equ word ptr[bp-2]
	;new_line equ word ptr[bp-4]
	;mov tabulation, 20h
	;mov new_line, 0A0Dh
	
	tabulation db 20h, '$'
	new_line db 0Ah, 0Dh, '$'
	
	push ax
	push cx
	push dx
	push si

	mov cx, left
	xor di, di

	mov si, 0

	idx_circle:
		mov ax, list[si]			; in consequence PrintArray elements in matrix, only adding size(word) to SI
		push cx
		call OutInt					; PrintArray another element in result_matrix
		pop cx
		
		mov dx, offset tabulation		; put enter between each two elements in PrintArray
		mov ah, 9h
		int 21h
			
		inc di							; j++
		add si, 2						; SI += 2  -> get next element from result_matrix
		cmp di, cx						; do while (j < quantity)
	jl idx_circle
		
	mov dx, offset new_line
	mov ah, 9h
	int 21h

	pop si
	pop dx
	pop cx
	pop ax

	mov sp, bp									; clean stack after our actions
	pop bp
	ret 4
PrintArray endp