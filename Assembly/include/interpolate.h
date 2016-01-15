; Program 3, Newtons Interpolating Polynomial
; author:  Cody Moffitt
; class: 3410
; due date:  11/04/2015

.NOLIST
.386


EXTRN interpolate_proc : Near32


interpolate    MACRO desX, degree, array_address, loc 
							
							push array_address
							push degree
							push desX
							
							
							call interpolate_proc
							fstp loc

						ENDM

.NOLISTMACRO
.LIST