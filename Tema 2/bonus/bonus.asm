%include "../include/io.mac"

section .data

section .text
    global bonus
    extern printf

bonus:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; board

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE

    push eax
    mov esi, ecx
    add esi, 4
    cmp eax, 4
    jl under
    sub esi, 8


under:
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

    mov ecx, ebx
    mov edx, eax

    cmp edx, 4
    jne not_4

    ; add to all corners (x = 4)
    sub ecx, 1
    mov byte [esi + 1], 1
    shl byte [esi + 1], 2
    add byte [esi + 1], 1
    shl byte [esi + 1], cl

    mov byte [esi + 7], 1
    shl byte [esi + 7], 2
    add byte [esi + 7], 1
    shl byte [esi + 7], cl

    jmp end

not_4:
    cmp edx, 3
    jne not_34

    ; add to all corners (x = 3)
    dec ecx
    dec esi
    mov byte [esi], 1
    shl byte [esi], 2
    add byte [esi], 1
    shl byte [esi], cl

    sub esi, 6
    mov byte [esi], 1
    shl byte [esi], 2
    add byte [esi], 1
    shl byte [esi], cl
    
    jmp end


not_34:
    ; add to all corners (all the remaining cases where we have 4 1's)
    dec ecx
    dec esi
    mov byte [esi], 1
    shl byte [esi], 2
    add byte [esi], 1
    shl byte [esi], cl

    add esi, 2
    mov byte [esi], 1
    shl byte [esi], 2
    add byte [esi], 1
    shl byte [esi], cl

    jmp end

left:
    ; add to the left (y >= 5)
    dec esi
    mov ecx, ebx
    dec ecx
    mov byte [esi], 1
    shl byte [esi], cl
    add esi, 2
    add byte [esi], 1
    shl byte [esi], cl
    jmp end


right:
    ; add to the right (y <= 1)
    dec esi
    mov ecx, ebx
    inc ecx
    mov byte [esi], 1
    shl byte [esi], cl
    add esi, 2
    add byte [esi], 1
    shl byte [esi], cl
    jmp end


check_up:
    cmp ebx, 1
    jl corner1
    cmp ebx, 6
    jg corner2
    jmp up

check_down:
    cmp ebx, 1
    jl corner4
    cmp ebx, 6
    jg corner3
    jmp down
    

up:
    ; add to the top (x <= 1)
    inc esi
    mov ecx, ebx
    dec ecx
    mov byte [esi], 1
    shl byte [esi], 2
    add byte [esi], 1
    shl byte [esi], cl
    jmp end

down:
    ; add to the bottom (x >= 6)
    dec esi
    mov ecx, ebx
    dec ecx
    mov byte [esi], 1
    shl byte [esi], 2
    add byte [esi], 1
    shl byte [esi], cl
    jmp end

corner1:
    ; add only to the corner1
    inc esi
    mov ecx, ebx
    inc ecx
    mov byte [esi], 1
    shl byte [esi], cl
    jmp end

corner2:
    ; add only to the corner2
    inc esi
    mov ecx, ebx
    dec ecx
    mov byte [esi], 1
    shl byte [esi], cl
    jmp end

corner3:
    ; add only to the corner3
    dec esi
    mov ecx, ebx
    dec ecx
    mov byte [esi], 1
    shl byte [esi], cl
    jmp end

corner4:
    ; add only to the corner4
    dec esi
    mov ecx, ebx
    inc ecx
    mov byte [esi], 1
    shl byte [esi], cl
    jmp end


end:

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY