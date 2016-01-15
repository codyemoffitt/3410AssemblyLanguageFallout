; Program 4, Fallout
; author:  Cody Moffitt
; class: 3410
; due date:  12/02/2015

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK  4096             ; reserve 4096-byte stack

MAX_ARRAY EQU 2000
LEN EQU 13
MAX EQU 20 

.DATA                    ; reserve storage for data

; Used throughout the program in general and for debugging
input_prompt			BYTE	"Enter a string: ", 0
num_passwords_string	BYTE	"The number of strings entered is ", 0
index_prompt			BYTE	"Enter the index for the test password (1-based): ", 0
match_prompt			BYTE	"Enter the number of exact character matches: ", 0 
passwords         		BYTE    MAX_ARRAY DUP(?)
input_string			BYTE	LEN DUP(?)
stringTerminator		BYTE	0

string1					BYTE	LEN DUP(?)
string2					BYTE	LEN DUP(?)

numPasswords			DWORD	0

doneString				BYTE	"Done", 0
start_sub				WORD	0
end_sub					WORD	13
numMatches				DWORD   0

goodPasses				DWORD	0

passwordChoice			DWORD	0 
numHackMatches			DWORD	0

tempLoop				DWORD 	0




INCLUDE io.h
INCLUDE debug.h
INCLUDE falloutprocs.h
INCLUDE strutils.h


.CODE                                    ; start of main program code


; Program start 			
_start:
	
	mov ecx, 0 ; track iteration
; Loop to gather the password strings 
_stringEntryLoop:
		
		output carriage
		output input_prompt
		input input_string, LEN
		output input_string
		
        cmp    input_string, 'x'        ; response = 'x' ? Time to quit gathering strings 
        je     _stringEntryDone             ; exit string entry loop if so

		append input_string, passwords ;append passwords
	
		cmp ecx, MAX
		je _stringEntryDone
		
		add ecx, 1  ; Increment cx for loop 
		jmp _stringEntryLoop

; String entry finished, start running the algorithms to help hack some computers in Fallout 3 		
_stringEntryDone:
	mov numPasswords, ecx ; Store the number of passwords collected
	output carriage
	output carriage
	
	; Display the number of passwords 
	output num_passwords_string
	outputD numPasswords
	output carriage
	
	; Print the collected passwords 
	print_passwords     passwords, numPasswords, LEN
	
	; Capture number of passwords in goodpasses for upcoming loop 
	mov goodpasses, ecx 
	
	; Zero everything out, just for good luck 
	mov ecx, 0 
	mov eax, 0 
	mov ebx, 0 
	mov edx, 0

	; The main algorithm's loop 
	_mainLoop:
	cmp ecx, 4 ;Quit the loop if we've done this four times
	jge _endMainLoop
	
	; Test to see if we've reached a point where there are no passwords or only 1 left, then quit the loop if so 
	mov edx, goodpasses
	cmp edx, 1 
	jle _endMainLoop
	
	; Get user input 
	 inputD	index_prompt, passwordChoice
	 outputD	passwordChoice
	 inputD  match_prompt, numHackMatches
	 outputD numHackMatches

	; Do the work
	fallout_hack passwords, LEN, goodpasses, passwordChoice, numHackMatches, goodpasses
	
	output carriage
	print_passwords  passwords, goodpasses, LEN
	
	
	inc ecx  
	jmp _mainLoop
	_endMainLoop:
	
	INVOKE ExitProcess, 0   ; exit with return code 0

PUBLIC _start                       ; make entry point public

            END                     ; end of source code
