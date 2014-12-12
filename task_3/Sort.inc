include Print.inc

QSort proc
	push bp
	mov bp, sp
	sub sp, 12					; we'll have 6 local variables
	
	push ax
	push bx
	push cx
	push dx
		
	left equ word ptr[bp+4]
	right equ word ptr[bp+6]
	size_of_list equ word ptr[bp+8]
	
	i equ word ptr[bp-2]
	j equ word ptr[bp-4]
	median equ word ptr[bp-6]
	list_i equ word ptr[bp-8]		; we will save list[i] to swap(list[i], list[j])
	list_j equ word ptr[bp-10]		; ....list[j] .....
	
	; OUTPUT TEMP RESULTS
	;---------------------------
	lea bx, list
	push bx
	mov ax, size_of_list
	push ax
	call PrintArray
	;---------------------------
	
	mov cx, left					; cx = first_index
	mov i, cx						; i = low(list)
	
	mov cx, right					; cx = last_index
	mov j, cx						; j = high(list)
	
	mov bx, i					
	add bx, j					
	shr bx, 1						; bx = (i + j) / 2
	shl bx, 1						; list[bx] = list[(i+j)/2]
	mov ax, list[bx]				; ax = list[(i+j)/2]
	mov median, ax					; median = list[(i+j)/2]
	
	do:
		inc_i_circle:
			mov bx, i 		
			shl bx, 1						
			mov ax, list[bx]				; ax = list[i]

			mov list_i, ax					
			cmp ax, median			; list[i] < m  ?
			jge inc_j_circle					; not -> break
			inc i 				; else i++
			jmp inc_i_circle				; -> new iteration
		
		inc_j_circle:
			mov bx, j 						; bx = j
			shl bx, 1						; bx *= size(word)
			mov ax, list[bx]				; ax = list[j]
			mov list_j, ax				
			cmp ax, median					; list[j] > m  ?
			jle after_circles				; not -> break
			dec j 			
			jmp inc_j_circle
		
		after_circles:
			mov ax, i			
			cmp ax, j
			jg check
		
		swap:
			mov bx, i		
			shl bx, 1					
			mov ax, list_j
			mov list[bx], ax				; list[i] = list[j]
			
			mov bx, j		
			shl bx, 1				
			mov ax, list_i
			mov list[bx], ax				; list[j] = list[i]
			inc i
			dec j				
			
		check:
			mov bx, i
			cmp bx, j			; i > j ?
			jle do

	mov ax, left
	cmp ax, j				; first_index < j ?
	jge last				; else go to condition 2
	
	recurs_1:
		lea bx, list
		push bx
		mov ax, size_of_list
		push ax
		mov ax, j
		push ax					
		mov dx, left		
		push dx				
		call QSort				
	last:
		mov ax, right			
		cmp ax, i				; last_index > i  ?
		jle end_recursion
	
	recurs_2:
		lea bx, list
		push bx
		mov ax, size_of_list
		push ax
		mov ax, right
		push ax				
		mov dx, i
		push dx					
		call QSort
	
	end_recursion:
		pop dx
		pop cx
		pop bx
		pop ax
		
		mov sp, bp				; clean stack after our actions
		pop bp
		ret 8					; 4 input parameters
QSort endp