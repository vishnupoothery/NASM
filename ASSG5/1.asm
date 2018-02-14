section .data
msg1 :db "Enter String : "
size1:equ $ -msg1
msg2:db "Entered string :"
size2: equ $ -msg2
msg3:db "Maximum count of distinct lowercase letters between Caps  : "
size3: equ $-msg3
enter: db 0Ah


section .bss

string : resb 50
char   : resb 1
i      : resw 1
max    : resw 1
j      : resw 1
num    : resw 1
digi   : resw 1
nod    : resw 1
count  : resw 1
min_i  : resw 1
max_i  : resw 1
k      : resw 1
l      : resw 1


section .text
	global _start
	_start:
	mov word[max],0
	mov eax,4
	mov ebx,1
	mov ecx,msg1
	mov edx,size1
	int 80h
	mov ebx,string
	call input_string
	;the string has been input
	mov eax,4
	mov ebx,1
	mov ecx,msg2
	mov edx,size2
	int 80h
	mov ebx,string
	call output_string
	mov eax,4
	mov ebx,1
	mov ecx,enter
	mov edx,1
	int 80h
	;the function to check maximum no small letters between capital letters
	mov word[i],0
	traversal: 
		mov ax,word[i]
		mov bl,byte[string+eax]
		mov byte[char],bl
		cmp byte[char],0
		je end_of_function
		cmp byte[char],95
		jl firstupper
		inc word[i]
		jmp traversal
	firstupper:
		mov ax,word[i]
		mov word[min_i],ax
		mov word[j],ax
	next_upper:
		inc word[j]
		mov ax,word[j]
		mov bl,byte[string+eax]
		cmp bl,0
		je end_of_function
		cmp bl,95
		jg next_upper
		mov ax,word[j]
		mov word[max_i],ax
		call distinct_count
		mov ax,word[max_i]
		mov word[i],ax
		jmp traversal
	end_of_function:
	mov ax,word[max]
	mov word[num],ax
	mov eax,4
	mov ebx,1
	mov ecx,msg3
	mov edx,size3
	int 80h
	call output
	mov eax,4
	mov ebx,1
	mov ecx,enter
	mov edx,1
	int 80h
end:
	mov eax ,1
	mov ebx ,0
	int 80h
;functions used
;the function used to output a string
input_string:
	pusha
	mov word[i],0
	input_string_loop:
		pusha
		mov eax,3
		mov ebx,0
		mov ecx,char
		mov edx,1
		int 80h
		popa
		cmp byte[char],0Ah
		je input_string_end
		mov ax,word[i]
		mov cl,byte[char]
		mov byte[ebx+eax],cl
		inc word[i]
		jmp input_string_loop
	input_string_end:
	mov cl,0
	mov ax,word[i]
	mov byte[ebx+eax],cl
	popa
	ret
;the function used to output a string
output_string:
	pusha
	mov word[i],0
	output_string_loop:
		mov ax,word[i]
		mov cl,byte[ebx+eax]
		cmp cl,0
		je output_string_end
		mov byte[char],cl
		pusha
		mov eax,4
		mov ebx,1
		mov ecx,char
		mov edx,1
		int 80h
		popa
		inc word[i]
		jmp output_string_loop
	output_string_end:
	popa
	ret
output:
	pusha
	cmp word[num],0
	je zeroprint
	mov word[nod],0
	digisplitter:
		cmp word[num],0
		je printdigi
		inc word[nod]
		mov ax,word[num]
		mov dx,0
		mov bx,10
		div bx
		push dx
		mov word[num],ax
		jmp digisplitter
	printdigi:
		cmp word[nod],0
		je print_end
		dec word[nod]
		pop dx
		mov word[digi],dx
		add word[digi],30h
		pusha
		mov eax,4
		mov ebx,1
		mov ecx,digi
		mov edx,1
		int 80h
		popa
		jmp printdigi
	print_end:
	popa
	ret
zeroprint:
	add word[num],30h
	mov eax,4
	mov ebx,1
	mov ecx,num
	mov edx,1
	int 80h
	jmp print_end
;the function used to count distinct number of smaller case numbers between two indices
distinct_count:
	mov ax,word[min_i]
	mov word[k],ax
	inc word[k]
	mov word[count],0
	k_loop:
		 mov ax,word[max_i]
		 cmp word[k],ax
		 jnl end_of_distinct
		 mov ax,word[k]
		 mov bl,byte[string+eax]
		 mov byte[char],bl
		 mov ax,word[k]
		 mov word[l],ax
		 inc word[l]
	  l_loop:
		 mov ax,word[max_i]
		 cmp word[l],ax
		 jnl end_of_l_loop
	mov ax,word[l]
	mov bl,byte[string+eax]
	cmp byte[char],bl
	je next_k_loop
	inc word[l]
	jmp l_loop
	end_of_l_loop:
	inc word[count]
	inc word[k]
	jmp k_loop
	next_k_loop:
	inc word[k]
	jmp k_loop
	end_of_distinct:
	mov ax,word[count]
	cmp ax,word[max]
	jl the_begining_of_the_end
	mov word[max],ax
	the_begining_of_the_end:
	ret
