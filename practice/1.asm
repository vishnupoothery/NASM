section .bss
value : resw 1
_temp : resb 1

section .data

section .text



input:
	pusha
	mov word[value], 0
	loopadd:
	mov eax, 3
	mov ebx, 0
	mov ecx, _temp
	mov edx, 1
	int 80h
	cmp byte[_temp], 10
	je end_read
	mov ax, word[value]
	mov bx, 10
	mul bx
	sub byte[_temp], 30h
	mov bl, byte[_temp]
	mov bh, 0
	add ax, bx
	mov word[value], ax
	jmp loopadd
	end_read:
	popa
	ret
