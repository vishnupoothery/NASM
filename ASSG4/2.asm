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
msg2 : db 'Palindrome',0Ah
len2 : equ $-msg2
msg3 : db 'Not palindrome',0Ah
len3 : equ $-msg3

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
		inc word[stringLength]
		mov ax,word[temp]
		mov word[ebx],ax
		add ebx,2
		jmp readString
	endReading:
	mov word[i],0
	mov ax,word[stringLength]
	mov word[j],ax
	dec word[j]
	loop1:
		movzx eax,word[i]
		movzx ebx,word[j]
		cmp ax,bx
		jnb _Palindrome
		mov cx,word[string+2*eax]
		mov dx,word[string+2*ebx]
		cmp cx,dx
		jne notPalindrome
		inc word[i]
		dec word[j]
		jmp loop1
	_Palindrome:
		mov eax,4
		mov ebx,1
		mov ecx,msg2
		mov edx,len2
		int 80h
		jmp end
	notPalindrome:
		mov eax,4
		mov ebx,1
		mov ecx,msg3
		mov edx,len3
		int 80h
	
end:
	mov eax,1
	mov ebx,0
	int 80h
