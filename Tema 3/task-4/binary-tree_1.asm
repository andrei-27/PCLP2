extern array_idx_1

section .text
    global inorder_parc

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_parc(struct node *node, int *array);
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor in vectorul array.
;    @params:
;        node  -> nodul actual din arborele de cautare;
;        array -> adresa vectorului unde se vor salva valorile din noduri;

inorder_parc:
    enter 0, 0
    pusha

    mov ebx, [ebp + 8]   ; nod
    mov eax, [ebp + 12]  ; vector

    ; node == NULL
    cmp ebx, 0
    je end_inorder_parc

    ; Procesam subarborele stang
    mov ecx, [ebx + 4]   
    push eax            ; vector
    push ecx            ; subarborele stang
    call inorder_parc
    add esp, 8

    ; Salvam nodul curent in vector
    mov edx, [ebx]
    mov ecx, dword [array_idx_1]
    mov [eax + ecx * 4], edx         ; (arr + 4 * poz) = node->value
    inc dword [array_idx_1]          ; poz++

    ; Procesam subarborele drept
    mov ecx, [ebx + 8] 
    push eax            ; vector
    push ecx            ; subarborele drept
    call inorder_parc
    add esp, 8

end_inorder_parc:
    popa
    leave
    ret
