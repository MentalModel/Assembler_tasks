ReadArgument proc


	;  readarg(pos, len, string)
	
	push bp
	mov bp, sp
	sub sp, 4
	;-----------------------------------------
	pusha
	
	quantity_of_symbols equ word ptr[bp-2]
	index_of_string equ byte ptr[bp-4]
	
	mov ax, quantity_of_symbols
	mov di, index_of_string
	lea si, string?

	xor bx, bx
	dec quantity_of_symbols

	read_argument:
		mov cl, es:[di]
		cmp cl, 44
		je ok
		mov filename[bx], cl

		dec si
		inc bx
		inc di
		cmp si, 0
		jg rd
	ok:
		mov filename[bx], '$'

	mov dx, offset filename
	mov ah, 09h
	int 21h
	
	error:
	
	popa
	;-----------------------------------------
	mov sp, bp
	pop bp
	ret 
	
ReadArgument endp