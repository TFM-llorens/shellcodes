[BITS 32]

_start:
    call geteip

geteip:
    pop edx
    lea edx, [edx - 5]

mov eax, 0x760A0000     ; BaseDll kernel32.dll
mov ebx, [eax + 0x3c]   ; ebx = Offset to NtHeader
lea ebx, [eax + ebx]    ; ebx = NtHeader
mov ebx, [ebx + 0x78]   ; ebx = Offset to _IMAGE_EXPORT_DIRECTORY
lea ebx, [eax + ebx]    ; ebx = _IMAGE_EXPORT_DIRECTORY


mov esi, 0x0                    ; esi = contador
mov edx, [ebx + 0x18]            ; edx = numero de funciones
mov edi, [ebx + 0x20]            ; edi = Offset to array of names
lea edi, [eax + edi]            ; edi = direccion del primer Offset al primer name
fun_loop:
    mov ecx, [edi]
    lea ecx, [eax + ecx]        ; ebx = string name funcion
    ; comparacion
    add edi, 4
    inc esi
    cmp edx, esi
    jne fun_loop

; -------------------------
; almacenamiento
MODULES:
    m1:
        dd 0x00000001 

; -------------------------
; EJEMPLO

; 75860000 + F8 + 78 = 75860170 ; DIRECCION DEL OFFSET TO _IMAGE_EXPORT_DIRECTORY

; 95b80 ; OFFSET TO _IMAGE_EXPORT_DIRECTORY

; 75860000 + 95b80 = 758F5B80 ; DIRECCION DE _IMAGE_EXPORT_DIRECTORY

; 758F5B80 + c = 758F5B8C ; DIRECCION DEL OFFSET TO Name

; 99c9e ; OFFSET TO Name

; 75860000 + 99c9e = 758F9C9E ; DIRECCION DEL Name