; void GetPosEq(char *source, char *destination, size_t source_length, size_t template_length, size_t &eq_pos)

GetPosEq proc

	push bp
	mov bp, sp
	sub sp, 6

	
	
	push ax
	push bx							; in bx lies eq_pos array
	push cx
	push dx							; in DI lies char *destination
	push si							; in SI lies char *source
	
	position_array equ word ptr[bp-2]
	
	size_of_text equ word ptr[bp+8]
	template_size equ word ptr[bp+10]
	
	dec size_of_text
	dec template_size
	
	xor bx, bx
	and word ptr[bp-6], 0
	search_substrings:
		lea di, Buffer[bx]
		cld
		
		mov cx, size_of_text
		sub cx, bx
		cmp cx, template_size
		js done
		
		mov ah, 0
		mov al, result[0]
		
		repne scasb
		jne done
		
		mov bx, size_of_text
		sub bx, cx
		dec bx

		lea si, result
		lea di, Buffer[bx]
		
		cld
		mov cx, template_size
		repe cmpsb
		je equal
		inc bx
	jmp search_substrings
	
	equal:
		mov word ptr[bp-4], bx			;save bx before change
		mov ax, word ptr[bp-4]			; ax = bx
		
		mov bx, word ptr[bp-6]

		mov pos[bx], ax
		mov bx, ax
		
		add bx, template_size
		add word ptr[bp-6], 2
		jmp search_substrings
	
	done:
	
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	
	mov sp, bp
	pop bp
	ret
GetPosEq endp