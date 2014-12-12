.386
assume CS:cseg, DS:DSeg, SS:sseg 

sseg segment stack use16
	db 256 dup (?)
sseg ends 

dseg segment use16

	parameters db 200 dup(0)
	parm_msg db 200 dup(0)
	result db 'Mental', '$'
	to_search_template_size dw ($ - result)/type(result)
	
	new_result db 'Model', '$'
	to_change_on_template_size dw ($ - new_result)/type(new_result)
	
	pos dw 300 dup(-1)
	size_of_array dw 300
	
	text_size dw 260

	ErrorStr DB 'Error','$'
	OkStr	 DB 'OK','$'
	Buffer   DB 500	DUP(0)
	
	path_to_inp db 200 dup(0)
	;path_to_inp db '4.txt', '$'
	path_to_outp db 200 dup(0)
	
	delimPos dw 0
	lenArgs dw 0
	i dw 0
    
dseg ends

cseg segment use16

include PrintStr.inc
include CopyStr.inc
include PosEq.inc
include Print.inc
include Change.inc
include OpenFl.inc
;include OutInt.inc

main:

	mov ax, dseg
	mov ds, ax
	xor ax, ax
	call OpenFileToRead
	
	;mov dx, offset parameters
	;mov ah, 09h
	;int 21h
		
	mov ax, dseg
	mov es, ax
	
	cld
	mov bx, delimPos
	dec bx
	push bx
	lea di, path_to_inp
	push di
	lea si, parameters[1]
	push si
	call CopyStr
	
	mov path_to_inp[bx], 24h
	
	cld
	mov bx, lenArgs
	sub bx, delimPos	
	
	push delimPos
	lea di, path_to_outp
	push di
	lea si, parameters[bx]
	push si
	call CopyStr
	
	mov path_to_outp[bx], 24h
	
	
	mov dx, offset path_to_inp
	mov ah,09h
    int 21h
	call NewLine
	
	mov dx, offset path_to_outp
	mov ah,09h
    int 21h
	call NewLine
	
	
	OpenFile:
		mov ah, 3dh
		mov al, 0
		mov dx, offset path_to_inp
		int 21h
		jc Error
		mov bx,ax					; дескриптор файла в ВХ
		jmp ReadFromFile
	
	ReadFromFile:
		mov ah,3fh					; функция чтения файла
		mov cx, text_size			; сколько читать
		mov dx, OFFSET Buffer   	; буфер
		int 21h						; выполнить
		jc Error
		jmp CloseFile
	
	
	CreateFile:
		mov ah, 3Ch
		mov dx, offset path_to_outp
		xor cx, cx
		int 21h
		mov bx,ax						;дескриптор файла в ВХ
		jmp WriteToFile

	WriteToFile:
		mov ah, 40h
		mov cx, text_size						;message Size
		mov dx, offset Buffer
		int 21h
		jmp CloseFileCreate
	
	Error:
		call NewLine
		mov dx, OFFSET ErrorStr
		mov ah, 09h
		int 21h		
		
	CloseFile:
		mov ah,3eh		
		int 21h
		
		;MOV AX, 4c00h
		;INT 21h	

	
	mov bx, text_size
	inc bx
	
	mov Buffer[bx], 24h
	mov dx, offset Buffer
	mov ah, 09h
	int 21h
	call NewLine
		
; GENERATE ALL SUBSTRINGS IN MASSIVE
	mov ax, pos
	push pos
	mov ax, to_search_template_size
	push ax									; template to search size
	push bx									; source size
	lea si, result
	push si
	lea di, Buffer
	push di
	call GetPosEq
;-------------------------------------------
; PRINT RESULT MASSIVE
	push size_of_array
	mov bx, offset pos
	push bx
	call PrintArray
;-------------------------------------------
; CHANGE STRING

	mov ax, to_change_on_template_size
	push ax
	push size_of_array
	lea si, pos
	lea di, Buffer
	push si
	push di
	call ChangeSubstrings
;-------------------------------------------
	call NewLine
	mov dx, offset Buffer
	mov ah,09h
    int 21h
	jmp CreateFile
	
	
	CloseFileCreate:
		mov ah,3eh		
		int 21h	
	
	
	GoToOS:
		MOV AX, 4c00h
		INT 21h	
		
cseg ends
end main