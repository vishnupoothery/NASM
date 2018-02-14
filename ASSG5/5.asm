section .data
msg1 :db "ENTER THE STRING : "
size1:equ $ -msg1
msg2:db "THE ENTERED STRING :"
size2: equ $ -msg2
msg3:db "ENTER THE WORD TO BE SEARCHED FOR  : "
size3: equ $-msg3
msg4:db "ENTER THE REPLACEMENT  : "
size4: equ $-msg4
enter: db 0Ah
section .bss

string : resb 50
replacement  : resb 50
ele    : resb 50
char   : resb 1
i      : resw 1
j      : resw 1
l      : resw 1
num    : resw 1
digi   : resw 1
nod    : resw 1
strlen : resw 1
k      : resw 1
max    : resw 1
min    : resw 1
max_i  : resw 1
min_i  : resw 1
count  : resw 1
newstring: resb 50
section .text

global _start
_start:


mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,size1
int 80h

mov ebx,string

call input_string

mov ax,word[i]
dec ax
mov ebx,string

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

mov eax,4
mov ebx,1
mov ecx,msg3
mov edx,size3
int 80h

mov ebx,ele
call input_string

mov ax,word[i]
mov word[max],ax

mov eax,4
mov ebx,1
mov ecx,msg4
mov edx,size4
int 80h

mov ebx,replacement
call input_string

;the function to find and replace a word with another word

mov word[i],0
mov word[j],0
mov word[count],0


traversal:

mov word[count],0
mov ax,word[j]
mov word[i],ax

mov ax,word[i]
mov bl,byte[string+eax]
cmp bl,0
je the_end

the_word_loop:


mov ax,word[j]
mov bl,byte[string+eax]

cmp bl,48
jl compare
inc word[count]
inc word[j]
jmp the_word_loop

compare:

inc word[j]
mov ax,word[max]
cmp word[count],ax
je check_word

jmp traversal

check_word:
mov word[l],0
mov ax,word[i]
mov word[k],ax

really_equal:

mov ax,word[k]
mov bl,byte[string+eax]
mov ax,word[l]
mov cl,byte[ele+eax]

cmp bl,cl
jne traversal

inc word[k]
inc word[l]
mov ax,word[l]
mov bl,byte[ele+eax] 
cmp bl,0
je replaceword

jmp really_equal


replaceword:

mov word[l],0

the_first_loop:

mov ax,word[l]

cmp word[i],ax
je addnew_word
mov bl,byte[string+eax]
mov byte[newstring+eax],bl
inc word[l]

jmp the_first_loop

addnew_word:

mov word[k],0

the_copy_word:

mov ax,word[k]
mov bl,byte[replacement+eax]
cmp bl,0
je finish_add_word

mov ax,word[l]
mov byte[newstring+eax],bl
inc word[k]
inc word[l]

jmp the_copy_word

finish_add_word:

mov bl,32
mov ax,word[l]
mov byte[newstring+eax],bl
inc word[l]

mov ax,word[j]
mov word[k],ax

the_rest:

mov ax,word[l]
mov word[j],ax

mov ax,word[k]
mov bl,byte[string+eax]

cmp bl,0
je please_end

mov ax,word[l]
mov byte[newstring+eax],bl

inc word[k]
inc word[l]

jmp the_rest

please_end:

mov bl,0
mov ax,word[l]
mov byte[newstring+eax],bl

mov word[k],0

pasting:

mov ax,word[k]
mov bl,byte[newstring+eax]
cmp bl,0
je finaly_the_end

mov ax,word[k]
mov byte[string+eax],bl
inc word[k]

jmp pasting

finaly_the_end:

mov bl,0
mov ax,word[k]
mov byte[string+eax],bl

mov word[j],0



jmp traversal


the_end:

mov ebx,string
call output_string



mov eax,4
mov ebx,1
mov ecx,enter
mov edx,1
int 80h

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

