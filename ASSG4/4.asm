section .bss
string : resw 100
temp : resw 1
i : resw 1
j : resw 1

section .data
stringLength : dw 0
nl : db ' ',0Ah
nll : equ $-nl
msg1 : db 'Enter String :',0Ah
len1 : equ $-msg1

section .text
global _start:
_start:
	mov eax,4
	mov ebx,1
	mov ecx,msg1
	mov edx,len1
	int 80h
	mov ebx,string
	readString:
		push ebx
		mov eax,3
		mov ebx,0
		mov ecx,temp
		mov edx,1
		int 80h
		pop ebx
		cmp word[temp],10
		je endReading
		cmp word[temp],90
		jg mayBeSmall
		cmp word[temp],64
		jg capConfirm
		jmp cont
	capConfirm:
		add word[temp],1
		cmp word[temp],90
		jg overFlow
		jmp cont
	mayBeSmall:
		cmp word[temp],122
		jg cont
		cmp word[temp],97
		jb cont
		add word[temp],1
		cmp word[temp],122
		jg overFlow
		jmp cont
	overFlow:
		sub word[temp],26
	cont:
		inc word[stringLength]
		mov ax,word[temp]
		mov word[ebx],ax
		add ebx,2
		jmp readString
	endReading:
	mov ebx,string
	printString:
		cmp word[stringLength],0
		je endPrinting
		push ebx
		mov ax,word[ebx]
		mov word[temp],ax
		mov eax,4
		mov ebx,1
		mov ecx,temp
		mov edx,1
		int 80h
		pop ebx
		dec word[stringLength]
		add ebx,2
		jmp printString
	endPrinting:
	call printl
end:
	mov eax,1
	mov ebx,0
	int 80h
printl:
	pusha
	mov eax,4
	mov ebx,1
	mov ecx,nl
	mov edx,nll
	int 80h
	popa
	ret
