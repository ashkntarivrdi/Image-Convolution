#!/bin/bash
nasm -f elf64 asm_io.asm && 
gcc -m64 -no-pie -std=c17 -c driver.c
nasm -f elf64 convolution3x3.asm &&
gcc -m64 -no-pie -std=c17 -o convolution3x3 driver.c convolution3x3.o asm_io.o &&
./convolution3x3
