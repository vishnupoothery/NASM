section .bss
value		: resw 1
result		: resw 1
_temp		: resb 1
temp		: resw 1
noOfDigits	: resw 1
i			: resw 1
n			: resw 1
f1			: resw 1
f2			: resw 1
f3			: resw 1

section .data
msg1		: db 'Enter n : '
len1		: equ $-msg1
nl			: db ' ',0Ah
nll			: equ $-nl
space		: db ' '
sl			: equ $-space

section .text
global _start:
_start:
	mov eax,4
	mov ebx,1
	mov ecx,msg1
	mov edx,len1
	int 80h
	call read
	mov ax,word[result]
	mov word[n],ax
	mov word[f1],0
	mov word[f2],1
	mov word[i],1
	call fib
	call printl
end:
	mov eax,1
	mov ebx,0
	int 80h
	
fib:
	pusha
	mov ax,word[i]
	cmp ax,word[n]
	jg endFib
	mov ax,word[i]
	cmp ax,1
	je _pOne
	mov ax,word[i]
	cmp ax,2
	je _pTwo
	mov ax,word[f1]
	add ax,word[f2]
	mov word[f3],ax
	mov word[value],ax
	mov ax,word[f2]
	mov word[f1],ax
	mov ax,word[f3]
	mov word[f2],ax
	call print
	call prints
	inc word[i]
	call fib
	jmp endFib
	_pOne:
		mov ax,word[f1]
		mov word[value],ax
		call print
		call prints
		inc word[i]
		call fib
		jmp endFib
	_pTwo:
		mov ax,word[f2]
		mov word[value],ax
		call print
		call prints
		inc word[i]
		call fib
	endFib:
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
	mov byte[_temp],0
	add byte[_temp],30h
	mov eax,4
	mov ebx,1
	mov ecx,_temp
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
