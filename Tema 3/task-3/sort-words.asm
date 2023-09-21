global get_words
global compare_func
global sort

section .data
    separator db ' ,.?!', 0   ; separatorii de cuvinte
    word_len dd 0

section .text
    extern strncpy
    extern qsort
    extern strcmp
    extern strlen

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0
    pusha

    mov esi, [ebp + 8]      ; adresa vectorului de cuvinte
    mov edi, [ebp + 12]     ; numarul de cuvinte
    mov ecx, [ebp + 16]     ; dimensiunea unui cuvant


    ; Apelam qsort
    push dword compare      ; functia de compare pt qsort
    push ecx                ; dimensiunea elementului
    push edi                ; numarul de elemente
    push esi                ; adresa vectorului de cuvinte
    call qsort
    add esp, 16             ; eliberam stiva

    popa
    leave
    ret


compare:
    enter 0, 0
    ; Registrii callee saved
    push ebx
    push edi
    push esi

    mov esi, [ebp + 8] ; adresa primului cuvant
    mov edi, [ebp + 12] ; adresa celui de-al doilea cuvant    

    ; Aflam lungimile cuvintelor
    push dword [edi]
    call strlen
    add esp, 4

    mov ecx, eax
    push ecx

    push dword [esi]
    call strlen
    add esp, 4

    pop ecx
    mov edx, eax

    cmp ecx, edx
    jl edi_smaller
    cmp ecx, edx
    jg esi_smaller

    ; Au lungime identica si apelam strcmp
    push dword[edi]
	push dword[esi]
	call strcmp
	add esp, 8
    jmp compare_done

esi_smaller:
    mov eax, -1
    jmp compare_done

edi_smaller:
    mov eax, 1

; In acest punct avem in eax rezultatul comparatiei
compare_done:
    pop esi
    pop edi
    pop ebx
    leave
    ret


;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
    pusha

    mov esi, [ebp + 8]    ; textul
    mov edi, [ebp + 12]   ; vectorul de string-uri
    mov ecx, [ebp + 16]   ; numarul de cuvinte

    mov dword [word_len], 0

start_loop:
    mov al, byte [esi]      ; caracterul curent
    cmp al, 0               ; s-a terminat textul
    je end_loop

    mov edx, separator

scan_separator:
    mov bl, byte [edx]
    cmp bl, 0               ; s-au terminat separatorii
    je update_word
    cmp al, bl              ; este caracterul curent un separator?
    je update_word
    inc edx                 ; urmatorul separator
    jmp scan_separator


update_word:
    cmp al, bl
    jne continue_loop

    ; Adaugam cuvantul actual in vector

    mov ebx, dword [word_len]
    cmp ebx, 0              ; avem 2 separatori la rand
    je jump_to_next

    dec ecx                 ; scadem numarul de cuvinte
    mov ebx, [word_len]
    sub esi, ebx            ; ajungem la inceputul cuvantului

    ; Salvam ecx
    push ecx

    ; Copiem cuvantul din text în vector
    push ebx                ; numarul de litere de copiat
    push esi                ; sursa
    push dword [edi]        ; dest
    
    call strncpy
    add esp, 12

    mov ecx, dword [edi]
    mov byte [ecx + ebx], 0 ; punem \0 la finalul cuvantului

    pop ecx

    ; Trecem la urmatoarea pozitie din vector
    add edi, 4

    add esi, ebx
    mov dword [word_len], 0 ; word_length = 0
    inc esi
    jmp start_loop


continue_loop:
    inc esi                 ; s++
    inc dword[word_len]     ; word_length++
    jmp start_loop

jump_to_next:
    inc esi                 ; s++
    jmp start_loop

end_loop:
    mov ebx, dword[word_len]
    sub esi, ebx

    cmp ecx, 0
    jle end

    ; Salvam ecx
    push ecx

    ; Copiem cuvantul din text în vector
    push ebx                ; numarul de litere de copiat
    push esi                ; sursa
    push dword [edi]        ; dest
    
    call strncpy
    add esp, 12

    mov ecx, dword [edi]
    mov byte [ecx + ebx], 0 ; punem \0 la finalul cuvantului
    
    pop ecx

end:
    popa
    leave
    ret
