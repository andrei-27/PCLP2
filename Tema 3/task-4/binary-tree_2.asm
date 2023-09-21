extern array_idx_2

section .text
    global inorder_intruders

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_intruders(struct node *node, struct node *parent, int *array)
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista
;
;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;
;        array  -> adresa vectorului unde se vor salva valorile din noduri;

inorder_intruders:
    enter 0, 0
    pusha

    mov ebx, [ebp + 8]   ; nod
    mov eax, [ebp + 12]  ; parent
    mov esi, [ebp + 16]  ; vector

    ; node == NULL
    cmp ebx, 0
    je end_inorder_intruders

    ; Procesam subarborele stang
    mov ecx, [ebx + 4]
    push esi                ; vector
    push ebx                ; parent
    push ecx                ; subarborele stang
    call inorder_intruders
    add esp, 12

    push esi

    mov esi, [ebx + 4]
    mov edi, [ebx + 8]

    cmp esi, 0
    je no_left

    ; Exista subarborele stang
    mov edx, [ebx]
    mov esi, [esi]
    
    cmp edx, esi
    jg no_left

    pop edi

    ; Trebuie adaugata valoarea subarborelui stang in vector
    mov ecx, dword [array_idx_2]

    mov [edi + ecx * 4], esi         ; (arr + 4 * poz) = node->left->value
    inc dword [array_idx_2]          ; poz++

    mov esi, edi
    jmp next

no_left:
    pop esi

next:
    mov edi, [ebx + 8]

    cmp edi, 0
    je end_verif

    ; Exista subarborele drept
    mov edx, [ebx]
    mov edi, [edi]

    cmp edx, edi
    jl end_verif

    ; Trebuie adaugata valoarea subarborelui drept in vector
    mov ecx, dword [array_idx_2]
    mov [esi+ecx*4], edi             ; (arr + 4 * poz) = node->right->value
    inc dword [array_idx_2]          ; poz++

; Procesam subarborele drept
end_verif:
    mov ecx, [ebx + 8]
    push esi                ; vector
    push ebx                ; parent
    push ecx                ; subarborele drept
    call inorder_intruders
    add esp, 12

end_inorder_intruders:
    popa
    leave
    ret
