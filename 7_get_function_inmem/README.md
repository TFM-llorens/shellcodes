## Pasos para cargar una funcion diamicamente

calcularemos los hash para las strings

modulo: kernel32.dll 
api: loadlibraryA

buscaresmos el basemodule de kernel32.dll

buscaremos la funcion loadlibratyA
buscaremos la funcion GetProcAddres


cargaremos otra dll: user32.dll



kernel32.dll -> GetProcAddress.

GetProcAddress(VirtualAlloc)