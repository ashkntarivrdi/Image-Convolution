#!/bin/bash
nasm -f elf64 asm_io.asm && 
gcc -m64 -no-pie -std=c17 -c driver.c
nasm -f elf64 convolution5x5.asm &&
gcc -m64 -no-pie -std=c17 -o convolution5x5 driver.c convolution5x5.o asm_io.o &&
./convolution5x5
