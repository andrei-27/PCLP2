section .text
    global inorder_fixing

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_fixing(struct node *node, struct node *parent)
;       functia va parcurge in inordine arborele binar de cautare, modificand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista.
;
;       Unde este nevoie de modificari se va aplica algoritmul:
;           - daca nodul actual este fiul stang, va primi valoare tatalui - 1,
;                altfel spus: node->value = parent->value - 1;
;           - daca nodul actual este fiul drept, va primi valoare tatalui + 1,
;                altfel spus: node->value = parent->value + 1;

;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;

inorder_fixing:
    enter 0, 0
    pusha

    mov ebx, [ebp + 8]   ; nod
    mov eax, [ebp + 12]  ; parent

    ; node == NULL
    cmp ebx, 0
    je end_fixing

    ; Procesam subarborele stang
    mov ecx, [ebx + 4]
    push ebx            ; parent
    push ecx            ; subarborele stang
    call inorder_fixing
    add esp, 8

    mov esi, [ebx + 4]
    mov edi, [ebx + 8]

    cmp esi, 0
    je next

    ; Exista subarborele stang
    mov edx, [ebx]
    
    cmp edx, dword [esi]
    jg next

    ; Trebuie sa punem in subarbore valoarea parintelui - 1
    dec edx
    mov dword [esi], edx

next:
    mov edi, [ebx + 8]

    cmp edi, 0
    je end_verif

    ; Exista subarborele drept

    mov edx, [ebx]

    cmp edx, dword [edi]
    jl end_verif

    ; Trebuie sa punem in subarbore valoarea parintelui + 1
    inc edx
    mov dword [edi], edx

; Procesam subarborele drept
end_verif:
    mov ecx, [ebx + 8]
    push ebx            ; parent
    push ecx            ; subarborele stang
    call inorder_fixing
    add esp, 8

end_fixing:
    popa
    leave
    ret
