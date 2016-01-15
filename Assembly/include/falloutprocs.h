; Program 4, Fallout
; author:  Cody Moffitt
; class: 3410
; due date:  12/02/2015

.NOLIST
.386


EXTRN swap_strings_proc : Near32
EXTRN num_matches_proc : Near32
EXTRN get_index_proc : Near32
EXTRN print_passwords_proc : Near32
EXTRN fallout_hack_proc : Near32


; Macro to swap two strings at the given indices 
swap_strings     MACRO passwordString, index1, index2, length, maxNumStrings, xtra 
					IFB <passwordString> ;if the first parameter is blank
						.ERR <missing "passwordString" operand in swap_strings>	
					ELSEIFB <index1>
						.ERR <missing "index1" operand in swap_strings>	
					ELSEIFB <index2>
						.ERR <missing "index2" operand in swap_strings>	
					ELSEIFB <length>
						.ERR <missing "length" operand in swap_strings>	
					ELSEIFB <maxNumStrings>
						.ERR <missing "maxNumStrings" operand in swap_strings>	
					ELSEIFNB <xtra>
						.ERR <extra operand(s) in swap_strings>
					ELSE
						push ebx
							pushd maxNumStrings
							pushd index2 
							pushd index1 
							pushd length
							lea ebx, passwordString
							push ebx
							
							call swap_strings_proc
						pop ebx
					ENDIF
					
				ENDM

; Macro to find the number of matches between two strings at the given indices 				
num_matches     MACRO passwordString, index1, index2, length, matches, xtra
					IFB <passwordString> ;if the first parameter is blank
						.ERR <missing "passwordString" operand in num_matches>	
					ELSEIFB <index1>
						.ERR <missing "index1" operand in num_matches>	
					ELSEIFB <index2>
						.ERR <missing "index2" operand in num_matches>	
					ELSEIFB <length>
						.ERR <missing "length" operand in num_matches>	
					ELSEIFB <matches>
						.ERR <missing "matches" operand in num_matches>	
					ELSEIFB <maxNumStrings>
						.ERR <missing "maxNumStrings" operand in num_matches>	
					ELSEIFNB <xtra>
						.ERR <extra operand(s) in num_matches>
					ELSE	
						push ebx
						push edx 
							pushd matches
							pushd index2 
							pushd index1 
							pushd length
							lea ebx, passwordString
							push ebx
							
							call num_matches_proc
							mov matches, edx 
						pop edx 
						pop ebx
					ENDIF
				ENDM

; Copies the string at a given index to the other index
get_index     	MACRO string_1, string_2, length, index, xtra
					IFB <string_1> ;if the first parameter is blank
						.ERR <missing "string_1" operand in get_index>	
					ELSEIFB <string_2>
						.ERR <missing "string_2" operand in get_index>	
					ELSEIFB <index2>
						.ERR <missing "index2" operand in get_index>	
					ELSEIFB <length>
						.ERR <missing "length" operand in get_index>	
					ELSEIFB <index>
						.ERR <missing "index" operand in get_index>	
					ELSEIFNB <xtra>
						.ERR <extra operand(s) in get_index>
					ELSE	
						push ebx
							pushd index
							pushd length
							lea ebx, string_2
							push ebx
							lea ebx, string_1
							push ebx

							call get_index_proc
						pop ebx
					ENDIF
				ENDM

; Prints the amount of passwords you specify				
print_passwords     MACRO passwords, amount, length, xtra
						IFB <passwords> ;if the first parameter is blank
							.ERR <missing "passwords" operand in print_passwords>	
						ELSEIFB <amount>
							.ERR <missing "amount" operand in print_passwords>	
						ELSEIFB <length>
							.ERR <missing "length" operand in print_passwords>	
						ELSEIFNB <xtra>
							.ERR <extra operand(s) in print_passwords>
						ELSE
						
							push eax 
							push ebx
							push ecx 
							push edx 
							
								pushd amount 
								pushd length
								lea ebx, passwords
								push ebx
								call print_passwords_proc
							pop edx 
							pop ecx 
							pop ebx
							pop eax 
						
						ENDIF
					ENDM
					
; The main macro of the program. It employs the other procs to do its dark bidding. I pretty much hate it at this point.			
fallout_hack    MACRO passwords, length, amount, choice, num_hack_matches, goodpasses, xtra
					IFB <passwords> ;if the first parameter is blank
						.ERR <missing "passwords" operand in fallout_hack>	
					ELSEIFB <length>
						.ERR <missing "length" operand in fallout_hack>	
					ELSEIFB <amount>
						.ERR <missing "amount" operand in fallout_hack>	
					ELSEIFB <choice>
						.ERR <missing "choice" operand in fallout_hack>	
					ELSEIFB <num_hack_matches>
						.ERR <missing "num_hack_matches" operand in fallout_hack>	
					ELSEIFB <goodpasses>
						.ERR <missing "goodpasses" operand in fallout_hack>	
					ELSEIFNB <xtra>
						.ERR <extra operand(s) in fallout_hack>
					ELSE
						push ebx

							pushd num_hack_matches
							pushd choice
							pushd amount 
							pushd length
							lea ebx, passwords
							push ebx
							call fallout_hack_proc
							mov goodpasses, ebx ; return number of matches in ebx 
							 
					ENDIF
				ENDM
						

.NOLISTMACRO
.LIST