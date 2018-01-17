section .bss
value: resw 1
result: resw 1
temp: resb 1
digit: resb 1
noOfDigits: resb 1
matrix: resw 1
n: resb 1

section .data
_space: db ' '
_ls: equ $-_space
_nl: db ' ',0Ah
_nll: equ $-_nl
msg1: db 'Enter size of matrix : '
len1: equ $-msg1
msg2: db 'Enter values for matrix',0Ah
len2: equ $-msg2

section .text
global _start:
_start:
    

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

prints:
    pusha
    mov eax,4
    mov ebx,1
    mov ecx,_space
    mov edx,_ls
    int 80h
    popa
    ret

printl:
    pusha
    mov eax,4
    mov ebx,1
    mov ecx,_nl
    mov edx,_nll
    int 80h
    popa
    ret