%include "../include/io.mac"

section .data

section .text
	global checkers
    extern printf

checkers:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; table

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE

    ; calculate the offset for the lines
    push eax
    mov esi, 8
    mul esi
    add eax, ebx

    mov esi, ecx
    add esi, eax
    pop eax

    cmp eax, 1
    jl check_up

    cmp eax, 6
    jg check_down

    cmp ebx, 1
    jl right

    cmp ebx, 6
    jg left

    mov byte [esi - 9], 1
    mov byte [esi + 7], 1
    mov byte [esi - 7], 1
    mov byte [esi + 9], 1
    jmp end

left:
    mov byte [esi - 9], 1
    mov byte [esi + 7], 1
    jmp end


right:
    mov byte [esi - 7], 1
    mov byte [esi + 9], 1
    jmp end

check_up:
    cmp ebx, 1
    jl corner1
    cmp ebx, 6
    jg corner2
    jmp just_up

check_down:
    cmp ebx, 1
    jl corner4
    cmp ebx, 6
    jg corner3
    jmp just_down
    
corner1:
    mov byte [esi + 9], 1
    jmp end

corner2:
    mov byte [esi + 7], 1
    jmp end

corner3:
    mov byte [esi - 9], 1
    jmp end

corner4:
    mov byte [esi - 7], 1
    jmp end

just_up:
    mov byte [esi + 7], 1
    mov byte [esi + 9], 1
    jmp end

just_down:
    mov byte [esi - 7], 1
    mov byte [esi - 9], 1
    jmp end

end:

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY