%include "../include/io.mac"

;; defining constants, you can use these as immediate values in your code
LETTERS_COUNT EQU 26

section .data
    extern len_plain
    key dd 0
    notches dd 0
    pos dd 0
    plain dd 0
    letter dd 0
    enc dd 0
    enc_final dd 0

section .text
    global rotate_x_positions
    global get_position
    global enigma
    extern printf

; void rotate_x_positions(int x, int rotor, char config[10][26], int forward);
rotate_x_positions:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; x
    mov ebx, [ebp + 12] ; rotor
    mov ecx, [ebp + 16] ; config (address of first element in matrix)
    mov edx, [ebp + 20] ; forward
    ;; DO NOT MODIFY
    ;; TODO: Implement rotate_x_positions
    ;; FREESTYLE STARTS HERE

    ; get to the correct rotor
    push edx
    mov esi, ecx
    push eax
    mov eax, ebx
    mov ebx, 52
    xor edx, edx
    mul ebx
    add esi, eax
    pop eax

    pop edx

    cmp edx, 0
    je left_shift

; move 25 letters to the right one position and put the last one on the 1st
; position
right_shift:
    cmp eax, 0
    je end
    push esi

    add esi, LETTERS_COUNT - 1
    mov edi, esi
    xor ebx, ebx
    mov bl, [esi + LETTERS_COUNT]
    push ebx
    xor ebx, ebx
    mov bl, [esi]
    push ebx
    mov ecx, LETTERS_COUNT - 1
    dec esi

shift_one_pos_right:
    mov bl, [esi]
    mov [edi], bl
    mov bl, [esi + LETTERS_COUNT]
    mov [edi + LETTERS_COUNT], bl
    dec esi
    dec edi
    loop shift_one_pos_right

    pop ebx
    mov [edi], bl
    pop ebx
    mov [edi + LETTERS_COUNT], bl
    dec eax
    pop esi
    jmp right_shift

; move 25 letters to the left one position and put the first one on the last
; position
left_shift:
    cmp eax, 0
    je end
    push esi

    mov edi, esi
    xor ebx, ebx
    mov bl, [esi + LETTERS_COUNT]
    push ebx
    xor ebx, ebx
    mov bl, [esi]
    push ebx
    mov ecx, LETTERS_COUNT - 1
    inc esi

shift_one_pos_left:
    mov bl, [esi]
    mov [edi], bl
    mov bl, [esi + LETTERS_COUNT]
    mov [edi + LETTERS_COUNT], bl
    inc esi
    inc edi
    loop shift_one_pos_left

    pop ebx
    mov [edi], bl
    pop ebx
    mov [edi + LETTERS_COUNT], bl
    dec eax
    pop esi
    jmp left_shift


end:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

; void enigma(char *plain, char key[3], char notches[3], char config[10][26], char *enc);
enigma:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; plain (address of first element in string)
    mov ebx, [ebp + 12] ; key
    mov ecx, [ebp + 16] ; notches
    mov edx, [ebp + 20] ; config (address of first element in matrix)
    mov edi, [ebp + 24] ; enc
    ;; DO NOT MODIFY
    ;; TODO: Implement enigma
    ;; FREESTYLE STARTS HERE

    ; PRINTF32 `%p\n\x0`, edx, 10, 0


    ; C code that works


    ; void enigma(char *plain, char key[3], char notches[3], char config[10][26], char *enc)
; {
;     for (int i = 0 ; i < len_plain ; ++i) {
;         char c = plain[i];
;         int pos;
;         pos = get_position(c, config, 9);
;         if (key[1] == notches[1]) {
;             rotate_x_positions(1, 1, config, 0);
;             rotate_x_positions(1, 0, config, 0);
;             ++key[1];
;             ++key[0];
;         } else if (key[2] == notches[2]) {
;             rotate_x_positions(1, 1, config, 0);
;             ++key[1];
;         }
;         rotate_x_positions(1, 2, config, 0);
;         ++key[2];
;         for (int j = 2 ; j >= 0 ; --j) {
;             if (key[j] > 'Z')
;                 key[j] -= 26;
;             c = config[2 * j + 1][pos];
;             pos = get_position(c, config, 2 * j);
;         }
;         c = config[7][pos];
;         pos = get_position(c, config, 6);
;         for (int j = 0 ; j < 3 ; ++j) {
;             c = config[2 * j][pos];
;             pos = get_position(c, config, 2 * j + 1);
;         }
;         c = config[9][pos];
;         enc[i] = c;
;     }
; }







;     mov [key], ebx
;     mov [notches], ecx
;     mov [plain], eax
;     mov [enc], edi
;     mov [enc_final], edi
;     ; PRINTF32 `%p\n\x0`, edi, 10, 0

;     mov esi, 0

; each_letter:
;     cmp esi, [len_plain]
;     je finish
    
;     xor eax, eax
;     mov eax, [plain]
;     xor ebx, ebx
;     mov bl, byte [eax + esi] ; letter
;     mov [letter], bl
;     push eax

;     mov edi, 9

;     push edi
;     push edx
;     push ebx
;     call get_position
;     add esp, 12

;     mov [pos], eax

;     pop eax

;     ; if

;     mov ebx, key
;     push ecx
;     mov ecx, [ecx + 1]
;     cmp [ebx + 1], ecx
;     jne elif


;     mov ecx, 0
;     push ecx
;     push edx
;     mov ecx, 1
;     push ecx
;     mov ecx, 1
;     push ecx
;     call rotate_x_positions
;     add esp, 16

;     mov ecx, 0
;     push ecx
;     push edx
;     mov ecx, 0
;     push ecx
;     mov ecx, 1
;     push ecx
;     call rotate_x_positions
;     add esp, 16

;     mov ecx, key

;     inc byte [ecx + 1]
;     inc byte [ecx]

; 	pop ecx
;     jmp after_if



; elif:
;     pop ecx

;     mov ebx, key
;     push ecx
;     mov ecx, [ecx + 2]
;     cmp [ebx + 2], ecx
;     jne after_if

;     mov ecx, 0
;     push ecx
;     push edx
;     mov ecx, 1
;     push ecx
;     mov ecx, 1
;     push ecx
;     call rotate_x_positions
;     add esp, 16

;     mov ecx, key

;     inc byte [ecx + 1]
;     pop ecx


; after_if:
;     push ecx


;     mov ecx, 0
;     push ecx
;     push edx
;     mov ecx, 2
;     push ecx
;     mov ecx, 1
;     push ecx
;     call rotate_x_positions
;     add esp, 16

;     mov ecx, key

;     inc byte [ecx + 2]

;     pop ecx


;     mov ebx, key
;     cmp byte [ebx], 'Z'
;     jle no0
;     sub byte [ebx], 26
; no0:
;     cmp byte [ebx + 1], 'Z'
;     jle no1
;     sub byte [ebx + 1], 26
; no1:
;     cmp byte [ebx + 2], 'Z'
;     jle no2
;     sub byte [ebx + 2], 26

; no2:
;     mov ecx, 2
;     push esi
;     xor esi, esi ; letter
;     ; PRINTF32 `%c \x0`, [letter], 10, 0
; rotor_1st_pass:
;     push eax
;     push ebx
;     push edx
;     mov ebx, 2
;     mov eax, ecx
;     mul ebx
;     mov ebx, 26
;     inc eax
;     mul ebx

;     pop edx
;     add eax, edx
;     add eax, [pos]
    

;     mov esi, [eax]

;     mov eax, ecx
;     add eax, ecx
    
    

;     push eax
;     push edx
;     push esi
;     call get_position
;     add esp, 12

;     mov [pos], eax

;     pop ebx
;     pop eax
;     dec ecx
;     cmp ecx, 0
;     jge rotor_1st_pass
    
;     pop esi

;     push esi
;     xor esi, esi
;     push eax
;     push edx
;     mov eax, 7
;     mov ebx, 26
;     mul ebx
;     add eax, [pos]
;     pop edx

;     add eax, edx
;     mov esi, [eax]

;     mov [letter], esi

    
;     mov eax, 6
    
;     push eax
;     push edx
;     push esi
;     call get_position
;     add esp, 12

;     mov [pos], eax

;     pop eax
;     pop esi


;     mov ecx, 0
;     push esi
;     xor esi, esi ; letter
;     ; PRINTF32 ` ~ %c \x0`, [letter], 10, 0
; rotor_2nd_pass:
;     ; PRINTF32 ` ~ %c \x0`, [letter], 10, 0
;     push eax
;     push ebx
;     push edx
;     mov ebx, 2
;     mov eax, ecx
;     mul ebx
;     mov ebx, 26
;     mul ebx

;     pop edx
;     add eax, [pos]
;     add eax, edx
;     mov esi, [eax]
;     mov [letter], esi

;     mov eax, ecx
;     add eax, ecx
;     inc eax

;     push eax
;     push edx
;     push esi
;     call get_position
;     add esp, 12

;     mov [pos], eax

;     pop ebx
;     pop eax
;     inc ecx
;     cmp ecx, 3
;     jle rotor_2nd_pass

;     ; PRINTF32 ` ~ %c \x0`, [letter], 10, 0

;     pop esi


;     push esi
;     xor esi, esi
;     push eax
;     push edx
;     mov eax, 9
;     mov ebx, 26
;     mul ebx
;     pop edx
;     add eax, [pos]

;     add eax, edx

;     mov esi, [eax]
;     mov ebx, esi

;     mov [letter], esi
;     PRINTF32 `%c \n\x0`, [letter], 10, 0
;     pop eax
;     pop esi


;     mov ebx, key
;     mov ecx, notches
;     pop eax
;     pop ebx


;     push eax
;     mov edi, [enc]
;     mov eax, edi
;     ; and eax, 0xFF
;     add eax, esi
;     push ebx
;     xor ebx, ebx
;     mov ebx, [letter]
;     mov [eax], bl
;     pop ebx
;     mov edi, [enc]
;     pop eax
    
;     inc esi
;     ; PRINTF32 `%c\n\x0`, [letter], 10, 0
;     jmp each_letter


; get_position:
;     push ebp
;     mov ebp, esp
;     push ebx
;     push ecx
;     push edx
;     push esi
;     push edi

;     mov eax, [ebp + 8]  ; letter
;     mov ebx, [ebp + 12] ; config
;     mov ecx, [ebp + 16] ; matrix_row

    
    
;     mov dl, al
;     xor eax, eax
;     mov al, dl
    
;     push eax
;     mov eax, ecx
;     mov ecx, 26
;     mul ecx
;     mov ecx, eax
;     pop eax
;     add ebx, ecx ; the start of the line of interest in the config
;     mov edx, 0
;     xor edi, edi
;     mov edi, 0
    

; iter:
;     xor ecx, ecx
;     mov cl, byte [ebx + edi]
;     cmp al, cl
;     je end_get_position
;     inc edi
;     jmp iter


; end_get_position:
;     xor eax, eax
;     mov eax, edi
        
;     pop edi
;     pop esi
;     pop edx
;     pop ecx
;     pop ebx
;     leave
;     ret


; finish:
;     mov edi, [enc_final]
    ; add edi, [len_plain]
    ; mov edi, 0
    
    ; PRINTF32 `%c\n\x0`, [edi + 6], 10, 0
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY