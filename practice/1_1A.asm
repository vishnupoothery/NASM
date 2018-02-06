section .bss
value : resw 1
result : resw 1
noOfDigits : resb 1
_temp : resb 1
temp : resb 1

section .data

section .text

exit:
	mov eax,1
	mov ebx,0
	int 80h

read:
	pusha
	mov word[result],0
	loopread:
		mov eax,3
		mov ebx,0
		mov ecx,_temp
		mov edx,1
		int 80h
		cmp byte[_temp],10
		je _endReading
		sub byte[_temp],30h
		mov ax,word[result]
		mov bx,10
		mul bx
		mov bl,byte[_temp]
		mov bh,0
		add ax,bx
		mov word[result],ax
		jmp loopread
	_endReading:
		popa
		ret
