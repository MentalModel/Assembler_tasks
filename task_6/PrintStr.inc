; void PrintStr(char *s, size_t length)

PrintStr proc

	push bp
	mov bp, sp
	
	push ax
	push cx
	push dx
	push si							; in SI lies char *s
	
	string_size equ word ptr[bp+6]
	mov cx, string_size
	;dec cx
	
	cld								; 0 -> (size_len - 1)
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
	
	ret 
PrintStr endp