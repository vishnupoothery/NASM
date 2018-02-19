section .bss
value		: resw 1
result		: resw 1
_temp		: resb 1
temp		: resw 1
noOfDigits	: resw 1
i			: resw 1
sum			: resw 1

section .data
msg1		: db 'Enter number '
len1		: equ $-msg1
nl			: db ' ',0Ah
nll			: equ $-nl
space		: db ' '
sl			: equ $-space

section .text
global _start:
_start:
	mov word[sum],0
	mov word[i],1
	call function
	mov ax,word[sum]
	mov word[value],ax
	call print
	call printl
	
end:
	mov eax,1
	mov ebx,0
	int 80h
	
function:
	pusha
	mov ax,word[i]
	cmp ax,10
	jg endFunction
	call printPrompt
	call read
	mov ax,word[result]
	mul ax
	add word[sum],ax
	inc word[i]
	call function
	endFunction:	
	popa
	ret
	
printPrompt:
	pusha
	mov eax,4
	mov ebx,1
	mov ecx,msg1
	mov edx,len1
	int 80h
	mov ax,word[i]
	mov word[value],ax
	call print
	call printl
	popa
	ret
printl:
	pusha
	mov eax,4
	mov ebx,1
	mov ecx,nl
	mov edx,nll
	int 80h
	popa
	ret
prints:
	pusha
	mov eax,4
	mov ebx,1
	mov ecx,space
	mov edx,sl
	int 80h
	popa
	ret
read:
    pusha
    mov word[result],0
    _digitReader:
        mov eax,3
        mov ebx,0
        mov ecx,_temp
        mov edx,1
        int 80h
        cmp byte[_temp],0Ah
        je _endReading
        mov ax,word[result]
        mov bx,0Ah
        mul bx
        sub byte[_temp],30h
        add al,byte[_temp]
        mov ah,0
        mov word[result],ax
        jmp _digitReader
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
