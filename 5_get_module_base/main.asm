[BITS 32]

_start:
    call geteip

geteip:
    pop edx
    lea edx, [edx - 5]

push edx                        ; Guardo EDX 

lea eax, [edx + aKernel32]      ; Prepara la pila para llamar a la funcion
push eax                        
call get_module_base

mov esi, eax                    ; Guardo el resultado
pop eax                         
pop edx                         ; recupero EDX
; Nota: como no estoy gestioando ebp el strack frame no se destruye y eax sigue estando en la pila

; -----------------------------------
; GET_MODULE_BASE
; -----------------------------------
; void* get_module_base(char* name)
; name: [esp + 4]
; return: eax = HMODULE || null
get_module_base:
    mov ecx, [esp + 4]

    mov ebx, fs:[0x30]              ; EBX = _PEB
    mov ebx, [ebx + 0x0C]           ; EBX = _PEB_LDR_DATA
    mov ebx, [ebx + 0x0C]           ; EBX = InLoadOrderModuleList
    mov edx, ebx                    ; EDX = iterador

    next_module:
        ; puntero a UNICODE_STRING.Buffer del módulo
        mov edi, [edx + 0x2c + 0x04]      

        call str_cmp
        cmp eax, 1
        je .equal             

        ; siguiente nodo en la lista
        mov edx, [edx]              ; EDX = Flink = siguiente nodo           
        cmp edx, ebx
        jne next_module

    .equal:
        mov eax, [edx + 0x18]
        ret

    .end:
        ; asumo que siempre lo encuentra

;-----------------------------------
; STR_CMP
;-----------------------------------
; bool str_cmp(char* a, char16_t* b)
; a: ecx
; b: edi
; return: AL = 1 si iguales, 0 si distintos
str_cmp:
    xor eax, eax          ; AL = 0, asumimos distintos
.compare_loop:
    mov al, [ecx]         ; byte de ASCII
    mov bl, [edi]         ; palabra de Unicode
    cmp al, bl             ; comparamos con byte bajo de Unicode
    jne .not_equal
    cmp al, 0             ; fin de ASCII?
    je .equal             ; ambos terminadores -> iguales
    inc ecx               ; siguiente byte ASCII
    add edi, 2            ; siguiente palabra Unicode
    jmp .compare_loop

.not_equal:
    xor al, al            ; AL = 0
    ret

.equal:
    mov al, 1             ; AL = 1
    ret


; -------------------------
; ALMACEN
SCSTRINGS:
    aKernel32:
        db 'KERNEL32.DLL',0
