section .bss
result : resw 1
value : resw 1
_temp : resb 1
num : resw 1
noOfDigits : resb 1

section .data

section .text
global _start
_start:

	call read
	mov ax,word[result]
	mov word[value],ax
	call print
	
	mov eax,1
	mov ebx,0
	int 80h
	

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
		inc byte[noOfDigits]
		mov ax,word[value]
		mov dx,0
		mov bx,0Ah
		div bx
		push dx
		mov word[value],ax
		jmp _printer
	_startPrinting:
		cmp byte[noOfDigits],0
		je _endPrinting
		dec byte[noOfDigits]
		pop dx
		mov byte[_temp],dl
		add byte[_temp],30h
		mov eax,4
		mov ebx,1
		mov ecx,_temp
		mov edx,1
		int 80h
		jmp _startPrinting
	_endPrinting:
		popa
		ret
read:
	pusha
	mov word[result],0
	loopadd:
		mov eax,3
		mov ebx,0
		mov ecx,_temp
		mov edx,1
		int 80h
		cmp byte[_temp],10
		je end_read
		mov ax, word[result]
		mov bx, 10
		mul bx
		sub byte[_temp],30h
		mov bl,byte[_temp]
		mov bh,0
		add ax,bx
		mov word[result],ax
		jmp loopadd
		end_read:
		popa
		ret
