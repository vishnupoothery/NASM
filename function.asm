section .bss
value: resw 1
result: resw 1
temp: resb 1
digit: resb 1
noOfDigits: resb 1

section .data

section .text
global _start:
_start:
call read
mov ax,word[result]
mov word[value],ax
call print

exit:
mov eax,1
mov ebx,0
int 80h


read:
pusha
mov word[result],0

_digitReader:

mov eax,3
mov ebx,0
mov ecx,digit
mov edx,1
int 80h

cmp byte[digit],0Ah
je _endReading

mov ax,word[result]
mov bx,0Ah
mul bx
sub byte[digit],30h
add al,byte[digit]
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

add word[value],30h

mov eax,4
mov ebx,1
mov ecx,value
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
mov byte[temp],dl
add byte[temp],30h
mov eax,4
mov ebx,1
mov ecx,temp
mov edx,1
int 80h
jmp _startPrinting

_endPrinting:
popa
ret
