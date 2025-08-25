[BITS 32]

_start:
    call geteip

geteip:
    pop edx
    lea edx, [edx - 5]

; -------------------------
; BUSCAR MODULO
; buscamos en _PEB
mov eax, fs:[0x30]              ; EAX = _PEB
mov esi, [eax + 0x0C]           ; ESI = _PEB_LDR_DATA
mov esi, [esi + 0x0C]           ; ESI = InLoadOrderModuleList
mov ebx, esi                    ; guardamos el head de la lista


lea edi, [EDX + MODULES]        ; EAX = puntero donde guardaremos direcciones
next_module:
    ; puntero a UNICODE_STRING.Buffer del módulo
    mov eax, [esi + 0x2c + 0x04]      
    ; guardar en nuestro array
    mov [edi], eax
    add edi, 4                  ; avanzar al siguiente slot
 
    ; siguiente nodo en la lista
    mov esi, [esi]              ; ESI = Flink = siguiente nodo           
    cmp esi, ebx
    jne next_module

; -------------------------
; BUSCAR FUNCION

; -------------------------
; COMPARE STRING
; Entrada:
;   ESI -> puntero al primer string
;   EDI -> puntero al segundo string
; Salida:
;   ZF = 1 si son iguales, ZF = 0 si son diferentes
strcmp:

; -------------------------
; almacenamiento
MODULES:
    m1:
        dd 0x00000001
    m2:
        dd 0x00000002
    m3:
        dd 0x00000003
    m4:
        dd 0x00000004
    m5:
        dd 0x00000005