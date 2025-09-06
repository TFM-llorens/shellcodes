
del ".\main.bin"
del ".\main.exe"

nasm -f bin .\main.asm -o .\main.bin
sclauncher.exe -f="main.bin" -pe -o="main.exe"

