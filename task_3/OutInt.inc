OutInt proc
	push ax
	push bx
	push cx
	push dx
	
	TEST AX, AX
	JNS start_getting_digits								; if (AX > 0) jmp start_getting_digits

	; if (AX < 0) then print('-') && AX = ABS(AX)
	
	MOV CX, AX
	MOV AH, 02h
	MOV DL, '-'
	INT 21h
	MOV AX, CX
	NEG AX													; AX = ABS(AX)
	
	start_getting_digits:
							XOR CX, CX						; let CX = 0; in CX will be the number of digits in AX
							MOV BX, 10						; let BX = 10 that means that the base of system of presentation numbers is decimal
	get_ordered_digit:
							XOR DX, DX						; let DX = 0
							DIV BX							; DX = AX div BX  -> in DX = last digit of number in AX
							PUSH DX							; put it in stack
							INC CX							; ++CX 
							TEST AX, AX						; if (AX == 0) break;
							JNZ get_ordered_digit			; else goto get_ordered_digit
							MOV AH, 02h						; print 
	print_digits:
							POP DX							; get ordered digit, convert it into char and print
							ADD DL, '0'
							INT 21h
	LOOP print_digits									; while (has_digit()) print
	pop dx
	pop cx
	pop bx
	pop ax
RET
OutInt endp