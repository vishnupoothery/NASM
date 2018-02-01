section .bss
value : resw 1
num : resw 1
result : resw 1
_temp : resb 1
noOfDigits : resb 1

section .data
nl : db ' ',0Ah
nll : equ $-nl

section .text
global _start:
_start:
	call read
	mov ax,word[result]
	mul ax
	mov word[value],ax
	call print
	call printl
	
Exit:
	mov eax,1
	mov ebx,1
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
		mov bx,0Ah
		mul bx
		mov bl,byte[_temp]
		mov bh,0
		add ax,bx
		mov word[result],ax
		jmp loopread
	_endReading:
		popa
		ret

print:
	pusha
	mov byte[noOfDigits],0
	cmp word[value],0
	jne _printer
	mov eax,4
	mov ebx,1
	mov ecx,30h
	mov edx,1
	int 80h
	jmp _endPrinting
	_printer:
		cmp word[value],0
		je _startPrinting
		mov ax,word[value]
		mov bx,10
		mov dx,0
		div bx
		push dx
		inc byte[noOfDigits]
		mov word[value],ax
		jmp _printer
	_startPrinting:
		cmp byte[noOfDigits],0
		je _endPrinting
		pop dx
		mov byte[_temp],dl
		add byte[_temp],30h
		mov eax,4
		mov ebx,1
		mov ecx,_temp
		mov edx,1
		int 80h
		dec byte[noOfDigits]
		jmp _startPrinting
	_endPrinting:
		popa
		ret
