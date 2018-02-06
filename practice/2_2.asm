section .bss
value : resw 1
result : resw 1
_temp : resb 1
noOfDigits : resb 1
n : resw 1
counter : resw 1
array : resw 100

section .data
even : db 0
odd : db 0

section .text
global _start:
_start:
	call read
	mov ax,word[result]
	mov word[n],ax
	mov word[counter],ax
	mov ebx,array
	loopInput:
		cmp word[counter],0
		je endLoopInput
		call read
		mov ax,word[result]
		mov word[ebx],ax
		add ebx,2
		dec word[counter]
		jmp loopInput
	endLoopInput:
	mov ebx,array
	mov ax,word[n]
	mov word[counter],ax
	loop1:
		cmp word[counter],0
		je endLoop1
		push ebx
		mov ax,word[ebx]
		mov bx,2
		mov dx,0
		div bx
		cmp dx,0
		je isEven
		inc byte[odd]
		jmp cont
		isEven:
		inc byte[even]
		cont:
		dec word[counter]
		pop ebx
		add ebx,2
		jmp loop1
	endLoop1:
	movzx ax,byte[even]
	mov word[value],ax
	call print
	movzx ax,byte[odd]
	mov word[value],ax
	call print

end:
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
		je _loopend
		sub byte[_temp],30h
		mov ax,word[result]
		mov bx,10
		mul bx
		mov bl,byte[_temp]
		mov bh,0
		add ax,bx
		mov word[result],ax
		jmp loopread
	_loopend:
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
		inc byte[noOfDigits]
		mov ax,word[value]
		mov bx,10
		mov dx,0
		div bx
		push dx
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
