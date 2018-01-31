section .data
name : db 'Vishnu Poothery',0Ah
len_name : equ $-name
address : db 'Thridivam House',0Ah,'East Nallur',0Ah,'Feroke P.O',0Ah,'Calicut',0Ah
len_address : equ $-address

section .text
global _start:
_start:
	mov ecx,name
	mov edx,len_name
	call print_string
	mov ecx,address
	mov edx,len_address
	call print_string
	mov eax,1
	mov ebx,0
	int 80h
	
	print_string:
		mov eax,4
		mov ebx,1
		int 80h
		ret
