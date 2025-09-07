# Runtime Linking en Shellcodes (Windows)

Cada carpeta incluye un ejemplo aislado

---

## 📂 Estructura del proyecto

- [1_call_func](./1_call_func)  
  Ejemplo básico de cómo invocar funciones directamente desde shellcode.

- [2_list_modules](./2_list_modules)  
  Enumeración de los módulos cargados en memoria (PEB / LDR).

- [3_list_exports](./3_list_exports)  
  Enumeración de las funciones exportadas en un módulos.

- [4_strcmp](./4_strcmp)  
  Implementación manual para comparar cadenas.

- [5_get_module_base](./5_get_module_base)  
  Obtención de la dirección base de un módulo (ej. `kernel32.dll`) desde PEB.

- [6_str_obfuscation](./6_str_obfuscation)  
  Ejemplo de ofuscación de strings para evadir detecciones estáticas.

- [7_get_function_inmem](./7_get_function_inmem)  
  Obtener la direccion de memoria de una funcion (ej. `LoadLibratyA` en `kernel32.dll`)

---

## Compilación y uso

1. Ensamblar el shellcode en un binario
```bash
nasm -f bin .\main.asm -o .\main.bin
```

2. (Opcion 1) Convertir el shellcode en un ejecutable PE válido
```bash
sclauncher.exe -f="main.bin" -pe -o="main.exe"
```

3. (Opcion 2) Loader basico
-  Transforma el binario en un array de C: https://gchq.github.io/CyberChef/#recipe=From_Hex('Auto')To_Hex('%5C%5Cx',0)
```bash
cl loader.c
```


