section .bss
name : resb 100
len : equ $-name

section .text
global _start:
_start:
	mov eax,3
	mov ebx,0
	mov ecx,name
	mov edx,len
	int 80h
	mov eax,4
	mov ebx,1
	mov ecx,name
	mov edx,len
	int 80h
	mov eax,1
	mov ebx,0
	int 80h
