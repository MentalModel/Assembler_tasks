; void CopyStr(char *source, char *destination, size_t source_length)

CopyStr proc

	push bp
	mov bp, sp
	
	push cx
	push dx							; in DI lies char *destination
	push si							; in SI lies char *source
	
	string_size equ word ptr[bp+8]
	mov cx, string_size
	;dec cx
	
	cld								; 0 -> (size_len - 1)
	for_every_char_copy:
		lodsb
		stosb
	loop for_every_char_copy
	
	pop si
	pop dx
	pop cx
	
	mov sp, bp
	pop bp
	ret 
CopyStr endp