#include <stdio.h>
#include <string.h>
#include <windows.h>

// "";
// "";
// "";
// "";
unsigned char text[] = 
"\xe8\x00\x00\x00\x00\x5a\x8d\x52\xfb\x8d\x9a\x23\x00\x00\x00\x8d\x8a\x28\x00\x00\x00\x6a\x00\x53\x51\x6a\x00\xb8\x20\xad\x4e\x76\xff\xd0\xc3\x74\x65\x78\x74\x00\x74\x69\x74\x6c\x65\x00";
unsigned char zero[] = 
"\x6a\x00\x6a\x00\x6a\x00\x6a\x00\xb8\x20\xad\x4e\x76\xff\xd0\x74\x65\x78\x74\x00\x74\x69\x74\x6c\x65\x00";
unsigned char iter[] = 
"\xe8\x00\x00\x00\x00\x5a\x8d\x52\xfb\x64\xa1\x30\x00\x00\x00\x8b\x70\x0c\x8b\x76\x0c\x89\xf3\x8b\x7e\x18\x8b\x56\x24\x8b\x36\x39\xde\x75\xf4";


int main() {
    unsigned char *shellcode = iter;
    // Cuidao: Arrays y punteros no son lo mismo 
    size_t shellcode_len = sizeof(shellcode);
    printf("[+] Numero de bytes en el shellcode: %d\n", shellcode_len);
    shellcode_len = strlen((char*)shellcode);
    printf("[+] Numero de bytes en el shellcode: %d\n", shellcode_len);
    shellcode_len = sizeof(iter);
    printf("[+] Numero de bytes en el shellcode: %d\n", shellcode_len);

    // 2. Reservamos memoria RWX
    LPVOID exec = VirtualAlloc(

        NULL,
        shellcode_len,
        MEM_COMMIT | MEM_RESERVE,
        PAGE_EXECUTE_READWRITE
    );

    if (exec == NULL) {return -1;}

    // 3. Copiamos el shellcode
    RtlMoveMemory(exec, shellcode, shellcode_len);

    printf("[+] Shellcode copiado en %p\n", exec);
    printf("[+] Pulsar ENTER para ejecutar...\n");
    getchar();

    // 4. Ejecutamos convirtiendo el puntero a función
    ((void(*)())exec)();

    MessageBoxA(0, 0, 0, 0);
    return 0;
}