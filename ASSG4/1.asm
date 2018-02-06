section .bss
value : resw 1
_temp : resb 1
string : resb 1
temp : resb 1
num : resw 1
noOfDigits : resw 1

section .data
vowelCount : dw 0
msg1 : db 'Enter your string : ',0Ah
len1 : equ $-msg1
msg2 : db 'No of vowels : '
len2 : equ $-msg2
nl : db ' ',0Ah
nll : equ $-nl

section .text
global _start:
_start:
	mov eax,4
	mov ebx,1
	mov ecx,msg1
	mov edx,len1
	int 80h
	mov word[noOfDigits],0
	mov ebx,string
	readString:
		push ebx
		mov eax,3
		mov ebx,0
		mov ecx,temp
		mov edx,1
		int 80h
		cmp byte[temp],10
		je endReadString
		inc word[noOfDigits]
		mov al,byte[temp]
		pop ebx
		mov byte[ebx],al
		cmp al,'A'
		je vowel
		cmp al,'a'
		je vowel
		cmp al,'E'
		je vowel
		cmp al,'e'
		je vowel
		cmp al,'I'
		je vowel
		cmp al,'i'
		je vowel
		cmp al,'O'
		je vowel
		cmp al,'o'
		je vowel
		cmp al,'U'
		je vowel
		cmp al,'u'
		je vowel
		jmp cont
	vowel:
		inc word[vowelCount]
	cont:
		add ebx,1
		jmp readString
	endReadString:
	mov ax,word[vowelCount]
	mov word[value],ax
	mov eax,4
	mov ebx,1
	mov ecx,msg2
	mov edx,len2
	int 80h
	call print
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
