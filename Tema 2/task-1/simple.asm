%include "../include/io.mac"

; CONSTANTS
LETTERS_COUNT EQU 26

section .text
    global simple
    extern printf

simple:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

    ;; DO NOT MODIFY
   
    ;; Your code starts here

    xor eax, eax

; loop to encode the string
iter:
    mov al, byte [esi + ecx - 1]
    add al, dl
    cmp al, 'Z'
    jle skip ; skip substracting 26
    sub al, LETTERS_COUNT

skip:
    mov byte[edi + ecx - 1], al ; move the encrypted letter to the enc_string
    loop iter

    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
