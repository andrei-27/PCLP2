section .data
	back db "..", 0
	dot db ".", 0
	slash db "/", 0

section .text
	extern strcmp
	extern strlen
	global pwd

;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories

pwd:
	enter 0, 0
    pusha

    mov edx, [ebp + 8]      ; directories
    mov ecx, [ebp + 12]     ; nr
	mov esi, [ebp + 16]     ; output_string

	push esi
	xor ebx, ebx
	xor edi, edi
	dec ecx

; Iteram prin vector
iter:
	cmp ecx, 0
	jl end

	push ebx
	push edx
	mov eax, ecx
	mov ebx, 4
	mul ebx
	pop edx
	add eax, edx
	mov eax, [eax]
	
	mov ebx, dot
	
	pusha

	push eax
	push ebx
	call strcmp
	add esp, 8

	test eax, eax			
	jnz no_curr
	; daca este punct trecem la urmatorul element din vector
	popa
	pop ebx
	dec ecx
	jmp iter


no_curr:
	popa
	push edx
	mov eax, ecx
	mov ebx, 4
	mul ebx
	pop edx
	add eax, edx
	mov eax, [eax]

	mov ebx, back
	pusha

	push eax
	push ebx
	call strcmp
	add esp, 8

	test eax, eax
	jz we_have_back
	popa
	pop ebx

	cmp edi, 0
	je push_dir
	
	; Daca numarul de .. de pana acum e > 0 atunci nu punem folderul actual in stiva
	dec edi
	dec ecx
	jmp iter

; Adaugam in stiva folderul actual
push_dir:
	inc ebx
	push eax
	dec ecx
	jmp iter

; Incrementam contorul de ..
we_have_back:
	popa
	pop ebx
	inc edi
	dec ecx
	jmp iter

end:
	; Avem in ebx numarul de foldere si in stiva folderele care constituie pathul
	mov edx, esi
	mov ecx, ebx
	xor ebx, ebx

create_path:
	mov eax, '/'
	mov byte [esi], al
	inc esi
	pop eax			; luam un folder
	push ecx
	push edx
	push eax

	push eax
	call strlen
	add esp, 4

	mov edi, eax
	pop eax
	pop edx
	
	mov ecx, 0

; Il adaugam in path
copy_one_byte:
	cmp ecx, edi
	je after
    mov bl, byte [eax]
    mov byte [esi], bl
    inc eax
	inc ecx
    inc esi
    jmp copy_one_byte

after:
	pop ecx
	loop create_path

	mov eax, '/'
	mov byte [esi], al
	pop esi

	popa
	leave
	ret
