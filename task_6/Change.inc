ChangeSubstrings proc

	push bp
	mov bp, sp
	sub sp, 2

	
	push ax
	push bx							
	push cx
	push dx							
	push si
	
	temp equ word ptr[bp-2]
	size_of_massive equ word ptr[bp+8]
	size_of_template_to_change equ word ptr[bp+10]
	
	dec size_of_template_to_change

	mov cx, size_of_massive
	mov si, 0
	
	f:
		mov bx, pos[si]
		cmp bx, -1
		jz exitLoop
		mov temp, si
		
		push size_of_template_to_change
		lea di, Buffer[bx]
		push di
		lea si, new_result
		push si
		call CopyStr
		mov si, temp
		add si, 2
	loop f	
	exitLoop:

	
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	
	mov sp, bp
	pop bp
	ret
ChangeSubstrings endp