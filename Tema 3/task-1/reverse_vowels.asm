section .text
	global reverse_vowels

;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place

reverse_vowels:
    push ebp
	push esp
	pop ebp
    pusha

	push dword [ebp + 8]
	pop edx					; string

	push -1
	pop ecx
	
; Calculam lungimea stringului
len:
	inc ecx
	cmp byte [edx + ecx], 0
	jne len
	
	push ecx

	push -1
	pop edi
	pop esi

; Bagam in stiva vocalele in ordine
iter:
	inc edi
	cmp edi, esi
	je end_push
	
	cmp byte [edx + edi], 'a'
	je push_vowel
	cmp byte [edx + edi], 'e'
	je push_vowel
	cmp byte [edx + edi], 'i'
	je push_vowel
	cmp byte [edx + edi], 'o'
	je push_vowel
	cmp byte [edx + edi], 'u'
	je push_vowel
	
	jmp iter

push_vowel:
	add edx, edi
	push dword [edx]
	sub edx, edi
	jmp iter

end_push:
	push 0
	pop ecx
	push -1
	pop edi

; Parcurgem stringul si inlocuim vocalele cu cele de pe stiva
reverse:
	inc edi
	inc ecx
	cmp edi, esi
	je end

	cmp byte [edx + edi], 'a'
	je rev_vowel
	cmp byte [edx + edi], 'e'
	je rev_vowel
	cmp byte [edx + edi], 'i'
	je rev_vowel
	cmp byte [edx + edi], 'o'
	je rev_vowel
	cmp byte [edx + edi], 'u'
	je rev_vowel

	jmp reverse

rev_vowel:
	push edx
	pop eax

	; Luam de pe stiva vocala si o punem in locul celei din string prin operatii pe biti
	add eax, edi
	pop ebx
	and ebx, 0xFF
	push eax
	push dword[eax]
	pop eax

	xor al, al
	or ebx, eax
	pop eax
	push ebx
	pop dword[eax]
	
	jmp reverse

end:
	popa
	push esp
	pop ebp
	pop ebp
	ret