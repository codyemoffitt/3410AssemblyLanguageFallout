; Program 4, Fallout
; author:  Cody Moffitt
; class: 3410
; due date:  12/02/2015

.386
.MODEL FLAT

INCLUDE debug.h
INCLUDE strutils.h

MAX_ARRAY EQU 1000

; params for get_index_proc
index			EQU [ebp + 20] ; index to find 
str_len			EQU [ebp + 16] ; length of strings 
str_2			EQU [ebp + 12] ; address of string to copy into 
str_1			EQU [ebp + 8]  ; address of string to copy from

; params for swap_strings_proc, num_matches_proc, and shift_proc
maxNumStrings	   EQU [ebp + 24] ;or num matches
index2 			   EQU [ebp + 20] ; Second string to swap's index
index1 			   EQU [ebp + 16] ; First string to swap's index
swap_length		   EQU [ebp + 12] ; Length of string 
passwordString_add EQU [ebp + 8]  ; Address of the string containing the passwords

; params for fallout_hack_proc
hack_matches		   EQU [ebp + 24] ; The number of matches Fallout says you had
hack_choice 		   EQU [ebp + 20] ; The chosen test password's index 
hack_amount			   EQU [ebp + 16] ; The number of passwords 
hack_pass_length	   EQU [ebp + 12] ; Length of individual password strings
hackPasswordString_add EQU [ebp + 8]  ; Address of the string containing the passwords 

; params for print_passwords_proc
amount			EQU [ebp + 16] ; Number of passwords to print 
prt_len			EQU [ebp + 12] ; Length of individual password strings
passwords		EQU [ebp + 8]  ; Address of the string containing the passwords

PUBLIC swap_strings_proc
PUBLIC num_matches_proc
PUBLIC get_index_proc
PUBLIC print_passwords_proc
PUBLIC shift_proc

.DATA
temp         		BYTE    MAX_ARRAY DUP(?) ;temporary storage for print passwords, makes it slightly easier

.CODE


; This procedure swaps two strings
; It takes a two indices, and finds the addresses to swap using these
; It uses the end of the passwordString array for temporary storage for the swap
swap_strings_proc  PROC   NEAR32

        push   ebp           
        mov    ebp, esp     
        push   eax         
		push   ebx
		push   ecx 
		push   edx
		push   	edi               
        push   	esi
        pushfd                 
		
		
		
		mov eax, index1
		sub eax, 1
		mov edi, passwordString_add
		mov esi, passwordString_add
		mov ecx, 0 
		mov ebx, swap_length 
		sub ebx, 2 
		
		;; Get index1
		_swapaddLoop1:
		cmp ecx, eax
		jge _endSwapAddLoop1
		add esi, ebx 
		add ecx, 1
		jmp _swapaddLoop1
		_endSwapAddLoop1:
		
		; Get maximum spot + length, a swap space 
		mov eax, maxNumStrings
		mov ecx, 0 
		mov ebx, swap_length 
		sub ebx, 2 
		_swapaddLoop2:
		cmp ecx, eax
		jge _endSwapAddLoop2
		add edi, ebx 
		add ecx, 1
		jmp _swapaddLoop2
		_endSwapAddLoop2:

		mov ecx, swap_length
		sub ecx, 2 
		cld
		rep movsb
		
		mov eax, index2
		sub eax, 1
		mov edi, passwordString_add
		mov esi, passwordString_add
		mov ecx, 0 
		mov ebx, swap_length 
		sub ebx, 2 
		
		;; Get index2
		_swapaddLoop3:
		cmp ecx, eax
		jge _endSwapAddLoop3
		add esi, ebx 
		add ecx, 1
		jmp _swapaddLoop3
		_endSwapAddLoop3:
		
		; Get index1
		mov eax, index1
		sub eax, 1
		mov ecx, 0 
		mov ebx, swap_length 
		sub ebx, 2 
		_swapaddLoop4:
		cmp ecx, eax
		jge _endSwapAddLoop4
		add edi, ebx 
		add ecx, 1
		jmp _swapaddLoop4
		_endSwapAddLoop4:

		mov ecx, swap_length
		sub ecx, 2 
		cld 
		rep movsb
		
		mov eax, index2
		sub eax, 1
		mov edi, passwordString_add
		mov esi, passwordString_add
		mov ecx, 0 
		mov ebx, swap_length 
		sub ebx, 2 
		
		;; Get index2
		_swapaddLoop5:
		cmp ecx, eax
		jge _endSwapAddLoop5
		add edi, ebx 
		add ecx, 1
		jmp _swapaddLoop5
		_endSwapAddLoop5:
		
		; Get maximum spot + length, a swap space 
		mov eax, maxNumStrings
		mov ecx, 0 
		mov ebx, swap_length 
		sub ebx, 2 
		_swapaddLoop6:
		cmp ecx, eax
		jge _endSwapAddLoop6
		add esi, ebx 
		add ecx, 1
		jmp _swapaddLoop6
		_endSwapAddLoop6:

		mov ecx, swap_length
		sub ecx, 2 
		cld
		rep movsb

        popfd  
		pop esi
		pop edi
        pop edx 
		pop ecx
		pop ebx 
		pop eax             
        mov    esp, ebp       
        pop    ebp            
        ret    20             

swap_strings_proc     ENDP

; This procedure shifts a string from one index to another.
; It works by swapping the string place by place until it reaches its destination
; This retains the order of the strings
shift_proc  PROC   NEAR32

        push   ebp           
        mov    ebp, esp     
        push   eax         
		push   ebx
		push   ecx 
		push   edx
		push   	edi               
        push   	esi
        pushfd                 
		
		; outputD index1
		; outputD index2 
		; ; loop to move index1 to index2, swapping along the way 
		
		mov ecx, index1 
		mov ebx, ecx ; The temporary target to swap to, always one more than ecx 
		inc ebx 
		
		_shiftLoop:
		cmp ecx, index2
		jge _endShiftLoop
		push maxNumStrings
		push ecx   
		push ebx  
		push swap_length
		push passwordString_add
		call swap_strings_proc
		inc ecx 
		inc ebx 
		jmp _shiftLoop
		_endShiftLoop:
		
		

        popfd  
		pop esi
		pop edi
        pop edx 
		pop ecx
		pop ebx 
		pop eax             
        mov    esp, ebp       
        pop    ebp  
        ret    20		

shift_proc     ENDP

; This procedure provides the number of exact character matches between two strings, given each of their indices 
num_matches_proc  PROC   NEAR32

        push   ebp           
        mov    ebp, esp     
        push   eax         
		push   ebx
		push   ecx 
		;push   edx
		push   	edi               
        push   	esi
        pushfd                 
		
		;outputD index1 
		;outputD index2
		
		mov eax, index1
		sub eax, 1
		mov edi, passwordString_add
		mov esi, passwordString_add
		mov ecx, 0
		mov ebx, swap_length 
		sub ebx, 2 
		
		dec eax 
		;; Get index1
		_swapaddLoop1:
		cmp ecx, eax
		jg _endSwapAddLoop1
		add esi, ebx 
		add ecx, 1
		jmp _swapaddLoop1
		_endSwapAddLoop1:
		
		mov eax, index2
		sub eax, 1
		mov ecx, 0 
		mov ebx, swap_length 
		sub ebx, 2 
		
		;; Get index2
		_swapaddLoop3:
		cmp ecx, eax
		je _endSwapAddLoop3
		add edi, ebx 
		add ecx, 1
		jmp _swapaddLoop3
		_endSwapAddLoop3:
		
		mov ecx, swap_length 
		sub ecx, 2
		
		mov eax, 0 
		_countMatchesLoop:
		cld
		repne    cmpsb
        je     _incrementKeepGoing
		
		_incrementKeepGoing:
		  jnz _noMatch ; test last char
		  inc eax  
	    _noMatch:
		  cmp ecx, 0 
		  jne _countMatchesLoop
		
		_endCountMatchesLoop:
		mov edx, eax ; store matches in edx 

        popfd  
		pop esi
		pop edi
        ;pop edx 
		pop ecx
		pop ebx 
		pop eax             
        mov    esp, ebp       
        pop    ebp            
        ret    16
                   
num_matches_proc     ENDP

; This procedure copies the string at a given index to another addresses
; Its used to copy the chosen strings for print_passwords_proc to temp 
get_index_proc  PROC   NEAR32

        push   ebp           
        mov    ebp, esp     
        push   eax         
		push   ebx
		push   ecx 
		push   edx
		push   	edi               
        push   	esi
        pushf              
		
		mov eax, index 
		sub eax, 1
		
		mov edi, str_2
		mov esi, str_1 
		mov ecx, 0 
		mov ebx, str_len 
		sub ebx, 2
		
		_addLoop:
		cmp ecx, eax
		jge _endAddLoop
		add esi, ebx 
		add ecx, 1
		jmp _addLoop
		_endAddLoop:

		mov ecx, str_len
		sub ecx, 2
		cld
		rep movsb
		
        popf  
		pop esi
		pop edi
        pop edx 
		pop ecx
		pop ebx 
		pop eax             
        mov    esp, ebp       
        pop    ebp            
        ret    12              

get_index_proc     ENDP

; This procedure prints a given number of password strings in a formatted fashion
print_passwords_proc  PROC   NEAR32

        push   ebp           
        mov    ebp, esp     
        push   eax         
		push   ebx
		push   ecx 
		push   edx
		push   	edi               
        push   	esi
        pushfd              
		
		mov eax, amount
		mov ecx, 1 
		
		; Get the index, copy it into temp, and print it to the screen with a carriage 
		_printLoop:
		cmp ecx, eax
		jg _endPrintLoop
		push ecx
		pushd prt_len
		lea ebx, temp 
		push ebx 
		pushd passwords
		call get_index_proc
		output temp
		output carriage
		add ecx, 1
		jmp _printLoop
		
		_endPrintLoop:
        popfd  
		pop esi
		pop edi
        pop edx 
		pop ecx
		pop ebx 
		pop eax             
        mov    esp, ebp       
        pop    ebp            
        ret    12              

print_passwords_proc     ENDP

; This is the procedure that swaps strings around and finds matches, to return to the main program
; It takes the parameters entered by the user to determine how many strings have the exact character matches
; specified and to swap those strings (in order) to the front of the password string
fallout_hack_proc  PROC   NEAR32
	push   ebp           
	mov    ebp, esp     
	push   eax         
	;push   ebx
	push   ecx 
	push   edx
	push   	edi               
	push   	esi
	pushfd
	
	
	; Move the choice to the last position
		pushd  hack_amount
		pushd  hack_choice 
		pushd hack_pass_length
		pushd hackPasswordString_add
		call shift_proc

	mov ecx, 1 
	mov ebx, 1 ; We will start testing at one 
	mov eax, hack_amount ;The number of passwords to sort through
	
	; Loop through each password from index 1 to last index 
	_mainLoop:
	cmp ecx, hack_amount 
	je _endMainLoop
	
	; Get the number of matches with current "good" index and test password 
	pushd eax
	pushd ebx
	pushd hack_pass_length
	pushd hackPasswordString_add
	call num_matches_proc
	
	; If the number of matches is the same as passed into this proc, this is a good potential password 
	cmp edx, hack_matches
	jne _swap
	; We have to increase our "good" password index, so good passwords will stay at the top of the list 
	inc ebx 
	inc ecx 
	jmp _mainLoop
	
	; If the number of matches doesn't equal what this proc was given, we shift it down to the position of eax 
	_swap:
	pushd hack_amount
	pushd eax
	pushd ebx
	pushd hack_pass_length
	pushd hackPasswordString_add
	call shift_proc
	; If a swap occurred, our test password will move up one spot in the list
	; and our index should down one spot 
	dec eax 
	inc ecx 
	
	jmp _mainLoop
	_endMainLoop:

	; Return the number of good passwords in ebx, subtract 1 since ebx started at 1 
	dec ebx 
	
	popfd  
	pop esi
	pop edi
	pop edx 
	pop ecx
	;pop ebx 
	pop eax             
	mov    esp, ebp       
	pop    ebp            
	ret    20

fallout_hack_proc     ENDP

END
