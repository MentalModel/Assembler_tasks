include OutInt.inc
PrintArray proc
	push bp
	mov bp, sp
	
	push ax
	push cx
	push dx
	push si
	
	mov cx, word ptr[bp+6]
	xor di, di

	mov si, 0

	idx_circle:
		mov ax, pos[si]			; in consequence PrintArray elements in matrix, only adding size(word) to SI
		cmp ax, -1
		jz end_loop
		push cx
		call OutInt					; PrintArray another element in result_matrix
		pop cx
		
		mov dl, 20h		; put enter between each two elements in PrintArray
		mov ah, 2h
		int 21h
			
		inc di							; j++
		add si, 2						; SI += 2  -> get next element from result_matrix
		cmp di, cx						; do while (j < quantity)
	jl idx_circle
	

	end_loop:
	
	call NewLine

	pop si
	pop dx
	pop cx
	pop ax

	mov sp, bp									; clean stack after our actions
	pop bp
	ret 4
PrintArray endp

NewLine proc
	push bp
	mov bp, sp
	
	push ax
	push dx

	mov dl, 0Ah
	mov ah, 2h
	int 21h
	
	pop dx
	pop ax
	
	mov sp, bp									
	pop bp
	ret
NewLine endp