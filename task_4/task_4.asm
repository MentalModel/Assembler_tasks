assume CS:cseg, DS:DSeg, SS:sseg 

sseg segment stack
	db 256 dup (?)
sseg ends 

dseg segment

		Mode_6 = 6 ; 640 X 200, 2 colors 
		Mode_13 = 0Dh ; 320 X 200, 16 colors 
		Mode_14 = 0Eh ; 640 X 200, 16 colors 
		Mode_15 = 0Fh ; 640 X 350, 2 colors 
		Mode_16 = 10h ; 640 X 350, 16 colors 
		Mode_17 = 11h ; 640 X 480, 2 colors 
		Mode_18 = 12h ; 640 X 480, 16 colors 
		Mode_19 = 13h ; 320 X 200, 256 colors 
		Mode_6A = 6Ah ; 800 X 600, 16 colors 
		
		saveMode db ?; Сохранить текущий видео режим
		color db 10 ; номер цвета

		int_0Ch dw ?, ?

		
dseg ends

cseg segment

include OutInt.inc

main:
	mov ax, dseg
	mov ds, ax				; load data to data segment
	mov es, ax
	
	
	; Получить текущий видео режим

	mov ah,0Fh
	int 10h
	mov saveMode,al

	; Переключиться в графический режим

	mov ah,0 ; установка видео режима
	mov al, Mode_16 ; номер режима
	int 10h 
	
	
	
	mov ah, 02h
	mov dh, 40
	mov dl, 40
	int 10h
	
	mov al, 35
	mov ah, 09h
	mov bh, 0
	mov bl, color
	mov cx, 15
	int 10h
	


	
	; Get OLD vector of interruption
	mov ax, 3510h
	int 21h
	
	; -------------------------------
	
	; Save vector of standart Program ... in RAM
	mov int_0Ch, bx
	mov int_0Ch + 2, es
	; ------------------------------------------
	jmp miss
	
	NewRealization proc 
		push bp
		mov bp, sp
		sub sp, 12
		
		max_circle equ word ptr[bp-2]
		symbol_color equ byte ptr[bp-4]
		symbol equ byte ptr[bp-6]
		ext_index equ byte ptr[bp-8]
		int_index equ byte ptr[bp-10]
		kostul equ byte ptr[bp-12]
		
		mov max_circle, 10
		mov symbol, 35
		mov ext_index, 0
		mov int_index, 0
		mov kostul, 0
		
		;--------------------------------------------------
		ext_loop:
			mov int_index, 0
		
			int_loop:
				
				;-------set position ------
				mov ah, 02h
				mov dh,	ext_index
				mov dl, int_index
				mov bh, 0
				Pushf
				call dword ptr int_0Ch
				;---------------------------
				
				
				; ---- get random colour------------------------
				; ch = hours (0-23), cl = minutes (0-60), dh = seconds(0-59), dl=seconds/100 (0-99)		
				mov ah, 2ch			; random
				int 21h

				mov al, dl
				and al, 15					; normalize color
				cmp kostul, al
				
				jne miss_kostul
			
				inc al
				and al, 15
				
				
				miss_kostul:
					mov kostul, al
					mov symbol_color, al		; random color 
					;-----------------------------------------
					
					;-----------------------------paint symbol -----------------------------------
					;AL = Character, 
					;BH = Page Number, BL = Color, CX = Number of times to print character
					mov al, symbol
					mov ah, 09h
					mov bl, symbol_color
					mov bh, 0
					mov cx, 1
					
					
					Pushf
					call dword ptr int_0Ch
				;------------------------------------------------------------------------------
			
				inc int_index
				cmp int_index, 10
			jl int_loop
			
			inc ext_index
			cmp ext_index, 10
		jl ext_loop
		
		;--------------------------------------------------	
		mov sp, bp				; clean stack after our actions
		pop bp
		iret
	NewRealization endp
	
	jmp endsss
	
miss:
	; Put our vector in table of interruption without using 21h
	cli         			; запретить внешние прерывания
	push ds    				; сохранить DS
	push cs
	pop ds   				; (CS)-> DS
	lea dx, NewRealization
	mov ax, 2510h
	int 21h
	pop ds     				;восстановить DS
	sti          			; разрешить прерывания
	;---------------------------------------------------------------
	
	;comment #
	mov al, 35
	mov bh, 0
	mov bl, color
	mov cx, 20
	
	mov ah, 09h
	;mov dh, 1
	int 10h
	
	;#
	
	endsss:
	


	
	; Come back of old vector in the table
	cli
	push ds
	mov dx, int_0Ch
	mov ds, int_0Ch + 2
	mov ax, 2510h
	int 21h
	pop ds
	sti  
	;---------------------------------------------------------------

	
	; Ожидаем нажатия клавиши
	mov ah,0
	int 16h
	
	; Возврат в прежний видео режим
	mov ah,0 ; установить видео режим 
	mov al,saveMode ; сохраненный видео режим
	int 10h 

	
	; Выход из программы
	MOV ax, 4c00h
	INT 21h	

cseg ends
end main