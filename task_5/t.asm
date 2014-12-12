cseg segment
assume CS:cseg
	.286
	.287
org 100h
main:
	jmp start
	x dd 3.00
	cur_x dd 0
	shift_x dd 1.24
	y dd 5.0
	seven dd 7.0
	one dd 1.0
	three dd 3.0
	five dd 5.0
	constantha dd -13434
	minus_25 dd -25.0
	
	
	include OutInt.inc
	
	start:
		xor ax, ax
		xor bx, bx
		xor cx, cx
		
		finit
		fld x
	check_x:

		ftst			 
		fstsw ax		 		
		sahf			   		
		jae x_not_less_zero	 	; if x >= 0
	
	; x < 0
	x_less_zero:
		fcom minus_25
		fstsw ax
		sahf
		jb error_state			; x < -25
	
										;st(0) = x
		;fld x							
	x_more_m5_less_zero:				;x^3*sin(1/x^2), x in [-5, 0)
		fld st(0)				
		fmul st(1), st				
		fld one						
		FDIVR ST(2), ST				
		fld st(2)					
		FXCH ST(1)				
										
		fptan							
		fld st(3)						
		
		fmul st, st(4)					
		fmul st, st(4) 					
		fmul st, st(1)					
		FFREE ST(0)                          
		FFREE ST(1)                         
		FFREE ST(2)                        
		FFREE ST(3)                       
		FXCH ST(4)
		FSTP x
		FFREE ST(3)                          
		FFREE ST(4) 
		fld x
		fadd shift_x								

		jmp check_x
												
	

	x_not_less_zero:						;                     x >= 0 			
		fcom three									
		fstsw ax
		sahf
		ja x_more_three						;x>3
	
	x_less_three:							;st(0) = x
		fld five							;st(0) = 5 st(1) = x
		fmul st, st(1)						;st(0) = 5x st(1) = x
		fld seven							;st(0) = 7 st(1) = 5x st(2) = x
		fadd st, st(1)
		FFREE ST(0)                   
		FFREE ST(1) 
		FXCH ST(2)
		FSTP x		
		FFREE ST(1)  
		fld x
		fadd shift_x								; x is growing		
		
		jmp check_x
	
	
	x_more_three:								;st(0) = x
		FSTP cur_x
		FLDZ									;st(0) = 0 st(1) = x
		FFREE ST(0)                           
		FFREE ST(1) 
		jmp check_x
	
	error_state:
		FSTP cur_x
		FLDPI
		jmp full_exit
			
		;return to os
	full_exit:
		MOV AX, 4c00h
		INT 21h	
cseg ends
end main