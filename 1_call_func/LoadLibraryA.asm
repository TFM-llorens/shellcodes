[BITS 32]

_start:
    call geteip

geteip:
    pop edx
    lea edx, [edx - 5]

lea ebx, [EDX + aText]
push ebx            ; lpLibFileName = puntero a 'user32.dll'

; HMODULE LoadLibraryA(
;   [in] LPCSTR lpLibFileName
; );
mov ecx, 0x76251C60 ; GetProcAddress
call ecx

test eax, eax
jz  fail
mov esi, eax

fail:
    ret

SCSTRINGS:
    aText:
        db 'user32.dll',0
