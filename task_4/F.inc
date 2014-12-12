	MyFuckingFunction proc 

		push ax
		push bx
		push cx
		push dx
		
		mov al, 0Ah
		xchg cx, dx	
		jmp dword ptr vectorInter
		iret
	MyFuckingFunction endp