; void PrintStr(char *s, size_t length)

PrintStr proc

	push bp
	mov bp, sp
	sub sp, 4
	
	push ax
	push cx
	push dx
	push si
	
	
	string equ word ptr[bp+4]
	string_len equ word ptr[bp+6]
	
	lea si, string
	mov cx, string_len
	dec cx
	
	cld
	for_every_char:
		lodsb
		mov dl, al
		mov ah, 02h
		int 21h
	loop for_every_char
	
	pop si
	pop dx
	pop cx
	pop ax
	
	mov sp, bp
	pop bp
	
	ret 4
OutInt endp