[BITS 32]

_start:
    call geteip

geteip:
    pop edi
    lea edi, [edi - 5]

lea eax, [EDI + StringBuffer]
; preparamos la pila
push 2      
push eax
call create_hash
mov ebx, eax 

lea eax, [EDI + aModule]
; preparamos la pila
push 1
push eax
call create_hash
mov ebx, eax 

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


StringBuffer:
    ; lo hago asi para que cada caracter ocupes 2bytes y sea unicode string
    dw 'K', 'E', 'R', 'N', 'E', 'L', '3', '2', '.', 'D', 'L', 'L', 0

UNICODE:
    ; Length = número de bytes usados (sin incluir null terminator)
    ; "hello.dll" tiene 9 caracteres -> 9*2 = 18 bytes
    dw 0x11             ; Length
    dw 0x22             ; MaximumLength (dejamos espacio para terminador)
    dd 0x33333333       ; Buffer (puntero al buffer UTF-16)

SCSTRINGS:
    aModule:
        db 'KERNEL32.DLL',0