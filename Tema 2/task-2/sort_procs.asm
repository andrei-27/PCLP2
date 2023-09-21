%include "../include/io.mac"

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

section .text
    global sort_procs
    extern printf

sort_procs:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov edx, [ebp + 8]      ; processes
    mov eax, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here

    mov ebx, -1
    sub eax, 1

; for i = 0, n - 1      (i = ebx)
;   for j = i + 1, n    (j = ecx)
;       if proc[i] > proc[j]
;           swap (proc[i], proc[j])
iter1:
    inc ebx
    mov ecx, ebx
    inc ecx
    cmp ebx, eax

    jge end
    push eax

iter2:
    pop eax

    cmp ecx, eax
    jg iter1
    
    push eax
    push edx

    ; calculate the offset for the first element
    mov eax, ebx
    mov esi, 5
    xor edx, edx
    mul esi
    mov esi, eax
    
    ; calculate the offset for the second element
    mov eax, ecx
    mov edi, 5
    xor edx, edx
    mul edi
    mov edi, eax

    pop edx
    inc ecx

    ; if proc[i].prio > proc[j].prio
    ;   swap (proc[i], proc[j])
    ; else if proc[i].prio < proc[j].prio
    ;   continue
    mov eax, [edx + esi + proc.prio]
    cmp al, [edx + edi + proc.prio]
    jg swap_val
    jl iter2

    ; if proc[i].time > proc[j].time
    ;   swap (proc[i], proc[j])
    ; else if proc[i].time < proc[j].time
    ;   continue
    mov eax, [edx + esi + proc.time]
    cmp ax, [edx + edi + proc.time]
    jg swap_val
    jl iter2

    ; if proc[i].pid > proc[j].pid
    ;   swap (proc[i], proc[j])
    mov eax, [edx + esi]
    cmp ax, [edx + edi]
    jg swap_val

    jmp iter2
    

swap_val:
    add esi, edx
    add edi, edx

    mov ax, word [esi] 
    xchg ax, word [edi]
    mov word [esi], ax
    
    mov al, [esi + proc.prio]
    xchg byte [edi + proc.prio], al
    mov byte [esi + proc.prio], al

    mov ax, word [esi + proc.time]
    xchg ax, word [edi + proc.time]
    mov word [esi + proc.time], ax
    
    jmp iter2

end:

    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY