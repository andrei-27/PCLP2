%include "../include/io.mac"

struc avg
    .quo: resw 1
    .remain: resw 1
endstruc

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

    ;; Hint: you can use these global arrays
section .data
    prio_result dd 0, 0, 0, 0, 0
    time_result dd 0, 0, 0, 0, 0

section .text
    global run_procs
    extern printf

run_procs:
    ;; DO NOT MODIFY

    push ebp
    mov ebp, esp
    pusha

    xor ecx, ecx

clean_results:
    mov dword [time_result + 4 * ecx], dword 0
    mov dword [prio_result + 4 * ecx],  0

    inc ecx
    cmp ecx, 5
    jne clean_results

    mov ecx, [ebp + 8]      ; processes
    mov ebx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ; proc_avg
    ;; DO NOT MODIFY
   
    ;; Your code starts here
    push eax
    mov edx, ecx
    mov ecx, ebx - 1

iter:
    push eax
    push edx

    ; calculate offset
    xor edx, edx
    mov eax, ecx
    mov edx, 5
    mul edx
    mov esi, eax

    pop edx
    pop eax

    
    sub esi, 5
    mov edi, esi
    add edi, edx

    push ebx
    xor ebx, ebx
    mov bl, byte [edi + proc.prio]
    mov esi, ebx
    pop ebx

    ; nr_elem++
    inc dword [prio_result + 4 * esi - 4]
    
    push esi
    mov si, [edi + 3]
    pop edi
    
    ; add time
    add dword [time_result + 4 * edi - 4], esi

    loop iter

    pop ebx
    mov ecx, 5

; construct the array proc_avg
; for each prio
process_data:
    cmp ecx, 0
    jle end

    ; calculate from the local array
    mov eax, [time_result + 4 * ecx - 4]
    mov edx, [prio_result + 4 * ecx - 4]

    cmp edx, 0
    je no_data ; no elements
    
    push ebx
    mov ebx, edx
    xor edx, edx
    div bx
    pop ebx

    mov word [ebx + 4 * ecx - 4], ax
    mov word [ebx + 4 * ecx + 2 - 4], dx
    sub ecx, 1
    jmp process_data

; just put 0
no_data:
    mov word [ebx + 4 * ecx - 4], 0
    mov word [ebx + 4 * ecx + 2 - 4], 0
    sub ecx, 1
    jmp process_data


end:
    
    ;; Your code ends here

    ;; DO NOT MODIFY
    
    popa
    leave
    ret
    ;; DO NOT MODIFY