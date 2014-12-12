cseg segment
assume CS:cseg
org 100h

main:
	jmp start
	list DW 4, 5, 3, 2, 6, 14, 1, 7, 13, 0, 24, 37, 66, 54, 99, 44, 52, 94, 32, 12, 87
	quantity DW ($ - list) / type(list)
	first_index dw 0
	
	include Sort.inc
	;include Print.inc
	start:

		lea bx, list			
		push bx							; put list in stack
		push quantity
		mov ax, quantity
		sub ax, 1
		push ax				
		push first_index				
		call QSort						; in C++ notation QSort(vector<int> &list, int left, int right)
	
		lea bx, list
		push bx
		push quantity
		call PrintArray
		
		;return to os
		MOV AX, 4c00h
		INT 21h	
cseg ends
end main

