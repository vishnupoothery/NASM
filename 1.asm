section .bss
value: resw 1
result: resw 1
temp: resb 1
digit: resb 1
noOfDigits: resb 1
matrix: resw 100
n: resb 1
i: resb 1
j: resb 1

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
    mov eax,4
    mov ebx,1
    mov ecx,msg1
    mov edx,len1
    int 80h

    call read
    mov ax,word[result]
    mov byte[n],al
    mov al,byte[n]
    mul al
    mov byte[temp],al
    mov ebx,matrix

loop1:
    cmp byte[temp],0
    je loopEnd
    call read
    mov ax,word[result]
    mov word[ebx],ax
    dec byte[temp]
    add ebx,2
    jmp loop1
    loopEnd:

    call printMatrix

exit:
    mov eax,1
    mov ebx,0
    int 80h

printMatrix:
    pusha
    mov ebx,matrix
    mov al,byte[n]
    mov byte[i],al

    ploop1:
        cmp byte[i],0
        je endPloop1
        mov al,byte[n]
        mov byte[j],al
        ploop2:
            cmp byte[j],0
            je endPloop2

            mov ax,word[ebx]
            push ebx
            mov word[value],ax
            call print
            call prints
            pop ebx
            add ebx,2
            dec byte[j]
            jmp ploop2
        endPloop2:
            call printl
            dec byte[i]
            jmp ploop1
        endPloop1:
    popa
    ret


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