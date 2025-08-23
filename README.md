# shellcodes

```bash
nasm -f bin .\main.asm -o .\main.bin
cl loader.c /link user32.lib && .\loader.exe
```

```bash
nasm -f bin .\main.asm -o .\main.bin
sclauncher.exe -f="main.bin" -pe -o="main.exe"
```