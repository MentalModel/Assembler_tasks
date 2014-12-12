assume CS:cseg, DS:DSeg, SS:sseg 

sseg segment stack
	db 256 dup (?)
sseg ends 

dseg segment
	list DW 4, 5, 3, 2, 6, 14, 1, 7, 13, 0, 24, 37, 66, 54, 99, 44, 52, 94, 32, 12, 87
	quantity DW ($ - list) / type(list)
	first_index dw 0
dseg ends

cseg segment

include Sort.inc
;include OutInt.inc
;include Print.inc

main:
	mov ax, dseg
	mov ds, ax				; load data to data segment
	
	lea bx, list			
	push bx							; put list in stack
	push quantity
	mov ax, quantity
	sub ax, 1
	push ax				
	push first_index				
	call QSort						; in C++ notation QSort(vector<int> &list, int left, int right)

	comment #
	lea bx, list
	push bx
	push quantity
	call PrintArray
	#
	MOV AX, 4c00h
	INT 21h	

cseg ends
end main