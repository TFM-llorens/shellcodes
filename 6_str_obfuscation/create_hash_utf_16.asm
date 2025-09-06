[BITS 32]

_start:
    call geteip

geteip:
    pop edx
    lea edx, [edx - 5]


;-----------------------------------
; INI STRING
mov word [EDX + UNICODE], 18
mov word [EDX + UNICODE + 2], 20
lea edi ,[EDX + StringBuffer]
mov dword [EDX + UNICODE + 4], edi

lea edx, [EDX + UNICODE]
call create_hash_utf_16
mov ebx, eax 

; ---------------------------------------
; CREATE_HASH_UTF_16
; ---------------------------------------
; uint32_t create_hash_utf_16(UNICODE_STRING* str)
; str: EDX = puntero a string null-terminated
; return: EAX = hash de 32 bits
; ---------------------------------------
create_hash_utf_16:
    mov edx, [edx + 4]
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
    add edx, 2             ; siguiente carácter
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