; ******************************************************
; BASIC .ASM template file for AVR
; ******************************************************

.include "C:\VMLAB\include\Tn15def.inc"

; Define here the variables
;
.def temp   = r16
.def times	= r17
.equ times_count = 19
; Define here Reset and interrupt vectors, if any
;
;.org 0
;	rjmp RESET				; Reset Handler
;.org T0OVaddr				; Timer0 Overflow Interrupt Vector Address
;	rjmp TIM0_OVF 			; Timer0 Overflow Handler
		
reset:		
   rjmp start
   reti      ; Addr $01
   reti      ; Addr $02
   reti      ; Addr $03
   reti      ; Addr $04
   rjmp TIM0_OVF      ; Addr $05
   reti      ; Addr $06        Use 'rjmp myVector'
   reti      ; Addr $07        to define a interrupt vector
   reti      ; Addr $08

; Program starts here after Reset
;
start:
   nop       ; Initialize here ports, stack pointer,
   nop       ; cleanup RAM, etc.
   nop       ;
   nop       ;
	
	ldi temp, (1<<CS02)|(1<<CS00)  ; Set prescaler to (1 0 1) CK/1024
	out TCCR0, temp

	ldi temp, (1<<TOIE0) ; Timer 0 Overflow Interrupt Enable
	out TIMSK,temp	

	ldi temp, (1<<SE) 	; Sleep Enable
	out MCUCR, temp
	
	ldi  times, 0
	
	SEI			;Global Interrupt Enable
	
forever:
   nop
   nop       ; Infinite loop.
   nop       ; Define your main system
   nop       ; behaviour here
   sleep
   nop
rjmp forever


;---------------- TIMER0 OVERFLOW ------------------------------
TIM0_OVF:
	cli			;Global Interrupt Disable	
	inc times	
					;If times count is lower than 30 - go bye bye
	ldi temp,times_count
	cp times,temp
	brlo byebye
					;Else,time has passsed, reset times and do what you have to.
	ldi  times,0 	
	
byebye:	
	;sleep
	sei
	reti
	
