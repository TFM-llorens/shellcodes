[BITS 32]

_start:
    call geteip

geteip:
    pop edx
    lea edx, [edx - 5]

push edx                        ; Guardo EDX 

push dword [edx + aKernel32]      ; Prepara la pila para llamar a la funcion                        
call get_module_base
mov esi, eax                    ; Guardo el resultado

add esp, 4
pop edx

push dword [edx + aLoadLibraryA]
push esi
call get_function_from_module



; -----------------------------------
; GET_MODULE_BASE
; -----------------------------------
; void* get_module_base(uint32_t hash_name)
;   hash_name: [esp + 4]
;   return: eax = HMODULE || null
get_module_base:
    mov ebx, [esp + 4]

    mov edi, fs:[0x30]              ; edi = _PEB
    mov edi, [edi + 0x0C]           ; edi = _PEB_LDR_DATA
    mov edi, [edi + 0x0C]           ; edi = InLoadOrderModuleList
    mov esi, edi                    ; ESI = iterador

    next_module:
        ; puntero a UNICODE_STRING.Buffer del módulo
        mov edx, [esi + 0x2c + 0x04]   
        
        push ebx
        push edi
        push esi  
        
        push 2
        push edx
        call create_hash
        
        add esp, 8
        pop esi
        pop edi
        pop ebx
        
        cmp eax, ebx
        je .equal             

        ; siguiente nodo en la lista
        mov esi, [esi]              ; ESI = Flink = siguiente nodo           
        cmp esi, edi
        jne next_module

    .equal:
        mov eax, [esi + 0x18]
        ret

    .end:
        ; asumo que siempre lo encuentra

;-----------------------------------
; GET_FUNCTION_FROM_MODULE
;-----------------------------------
; void* get_function_from_module(uint32_t module_base, uint32_t hash_api)
; hash_api: [esp + 8]
; module_base: [esp + 4]
; return: eax 
get_function_from_module:
    mov ebx, [esp + 4]      ; BaseDll
    
    mov esi, [ebx + 0x3c]   ; esi = Offset to NtHeader
    lea esi, [ebx + esi]    ; esi = NtHeader
    mov esi, [esi + 0x78]   ; esi = Offset to _IMAGE_EXPORT_DIRECTORY
    lea esi, [ebx + esi]    ; esi = _IMAGE_EXPORT_DIRECTORY

    mov edi, [esi + 0x20]           ; edi = Offset to array of names
    lea edi, [ebx + edi]            ; edi = direccion del primer Offset al primer name
    
    mov ecx, [esi + 0x24]
    lea ecx, [ebx + ecx]

    fun_loop:        
        mov edx, [edi]
        lea edx, [ebx + edx]        ; esi = string name funcion

        push ebx
        push edi
        push ecx

        push 1
        push edx 
        call create_hash
        
        add esp, 8

        pop ecx
        pop edi
        pop ebx
        
        cmp eax, [esp + 8]
        je .equal

        add ecx, 2
        add edi, 4
        jne fun_loop

    .equal:
        mov ecx, [ecx + 2]      ; ordinal
        and ecx, 0x0000FFFF
        imul ecx, ecx, 4        ; ordinal * tam palabra
        sub ecx, 4              ; vamos al inicio de la ultima palabra
        
        mov edx, [esi + 0x1C]           ; offset to AddressOfFunctions
        add ecx, edx                    ; rva + ordinal
        lea ecx, [ebx + ecx]            

        mov ecx, [ecx]              ; rva a la funcion
        lea eax, [ebx + ecx]        ; image base + rva

        ret

; ---------------------------------------
; CREATE_HASH_UTF_16
; ---------------------------------------
; uint32_t create_hash(void* str, int bytes_for_character)
;   bytes_for_character: [ESP + 8]      = 1 o 2 bytes cada caracter
;   str: [ESP + 4]                      = puntero a string null-terminated
; return: EAX = hash de 32 bits
; ---------------------------------------
create_hash:
    mov edx, [ESP + 4]
    xor eax, eax           ; result = 0

.next_char:
    mov bl, [edx]          ; cargar siguiente carácter
    cmp bl, 0              ; fin de string?
    je .done

    cmp bl, 'A'
    jb .skip_lower
    cmp bl, 'Z'
    ja .skip_lower
    or bl, 0x20            ; setea bit 5 → minúscula

.skip_lower:
    rol eax, 7             ; result = rol(result,7)
    movzx ebx, bl          ; extender BL a 32 bits
    xor eax, ebx           ; result ^= char
    add edx, [ESP + 8]     ; siguiente carácter
    jmp .next_char

.done:
    ret



; -------------------------
; ALMACEN
SCSTRINGS:
    aKernel32:
        dd 0x4b1ffe8e
    aLoadLibraryA:
        dd 0xC8E88006


