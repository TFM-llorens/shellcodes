#include <windows.h>
#include <stdio.h>

int main() {
    // 1. Obtener el handle de kernel32.dll (ya cargada en el proceso)
    HMODULE hKernel32 = GetModuleHandleA("kernel32.dll");
    if (!hKernel32) {
        printf("Error: no se pudo obtener kernel32.dll\n");
        return 1;
    }

    // 2. Obtener la dirección de VirtualAlloc
    FARPROC pFunc = GetProcAddress(hKernel32, "VirtualAlloc");
    if (!pFunc) {
        printf("Error: no se pudo resolver VirtualAlloc\n");
        return 1;
    }

    // 3. Hacer cast al tipo correcto de función
    LPVOID (WINAPI *pVirtualAlloc)(
        LPVOID, SIZE_T, DWORD, DWORD
    ) = (LPVOID(WINAPI*)(LPVOID, SIZE_T, DWORD, DWORD)) pFunc;

    // 4. Usar la función como si fuera normal
    LPVOID mem = pVirtualAlloc(NULL, 4096, MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE);
    if (mem) {
        printf("Memoria reservada en %p\n", mem);
    } else {
        printf("Error al reservar memoria\n");
    }

    return 0;
}
