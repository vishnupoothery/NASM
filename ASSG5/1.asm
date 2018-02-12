section .bss
value : resw 1
_temp : resw 1
string : resw 100
temp : resw 1
num : resw 1
i : resw 1
j : resw 1
stringLength : resw 1

section .data
msg1 : db 'Enter your string :',0Ah
len1 : equ $-msg1
nl : db ' ',0Ah
nll : equ $-nl

global _start:
_start:
	mov eax,4
	mov ebx,1
	mov ecx,msg1
	mov edx,len1
	int 80h
	mov ebx,string
	mov word[stringLength],0
	readString:
		push ebx
		mov eax,3
		mov ebx,1
		mov ecx,temp
		mov edx,1
		int 80h
		pop ebx
		cmp word[temp],10
		je endReading
		mov ax,word[temp]
		inc word[stringLength]
		mov word[ebx],ax
		add ebx,2
		jmp readString
	endReading:
		add ebx,2
		mov word[ebx],0

end:
	mov eax,1
	mov ebx,0
	int 80h
