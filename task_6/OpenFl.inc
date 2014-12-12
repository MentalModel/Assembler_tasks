OpenFileToRead proc

	pusha
	start_parse_command_line:
	
		xor cx, cx
		mov cl, es:80h ;read command line arguments
		cmp cl, 0
		je sommeError

		mov si, 81h
		xor bx, bx
		mov lenArgs, cx
		
		read_input_parameters:
			
			mov al, es:[si]
			cmp al, 44
			jne missSaveDelimPosition
			mov delimPos, bx
			mov parameters[bx], al
			inc bx
			inc si
			loop read_input_parameters
			
			
			missSaveDelimPosition:
			cmp al, 10
			je parameters_have_been_read
			
			mov parameters[bx], al
			inc bx
			inc si	
			loop read_input_parameters
			
		parameters_have_been_read:
			mov parameters[bx], 24h

	popa
	mov ah, 62h 		; get segment address of PSP
	int 21h
	push bx
	pop es				; and put in ds
	sommeError:
		ret
OpenFileToRead  endp