[BITS 32]

_start:
    call geteip

geteip:
    pop edx
    lea edx, [edx - 5]

lea edx, [EDX + aModule]
call create_hash_utf_8
mov ebx, eax 

; ---------------------------------------
; CREATE_HASH_UTF_8
; ---------------------------------------
; uint32_t create_hash_utf_8(char* str)
; str: EDX = puntero a string null-terminated
; return: EAX = hash de 32 bits
; ---------------------------------------
create_hash_utf_8:
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
    inc edx                ; siguiente carácter
    jmp .next_char

.done:
    ret

SCSTRINGS:
    aModule:
        db 'KERNEL32.DLL',0