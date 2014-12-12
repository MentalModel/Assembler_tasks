assume CS:cseg, DS:DSeg, SS:sseg 

sseg segment stack
	db 256 dup (?)
sseg ends 

dseg segment
		OkStr	 DB 'OK','$'

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
		currentX dw 100 ; координата X
		currentY dw 100 ; координата Y
		color db 1 ; номер цвета

dseg ends

cseg segment

include OutInt.inc

main:
	mov ax, dseg
	mov ds, ax				; load data to data segment
	mov es, ax
	
	xor ax, ax
	mov ah, 2ch
	int 21h
	
	xor ax, ax
	mov al, dl
	and al, 15
	;call OutInt

	mov cx,001eH ; старшее слово числа микросекунд паузы
mov dx,8480H ; младшее слово числа микросекунд паузы
mov ax,8400h ; функция 86h
int 15h ; пауза
	
	
	MOV ax, 4c00h
	INT 21h	

cseg ends
end main