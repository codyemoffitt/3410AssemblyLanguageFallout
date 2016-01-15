; Program 3, Newtons Interpolating Polynomial
; author:  Cody Moffitt
; class: 3410
; due date:  11/04/2015

.NOLIST
.386


EXTRN compute_b_start : Near32

compute_b     MACRO n, m, array_address, loc 
							
							push array_address
							push m
							push n
							
							
							call compute_b_start
							fstp loc

						ENDM

.NOLISTMACRO
.LIST