%include "asm_io.inc"

segment .data
    ARRAY_LENGTH db 100
    ii dq 0
    jj dq 0
    kk dq 0
    n dq 0
    nSquare dq 0
    array1 dd 100 DUP(0)
    array2 dd 100 DUP(0)
    result dd 100 DUP(0) 

segment .text

global asm_main

asm_main:

	push rbp
    push rbx
    push r12
    push r13
    push r14
    push r15

    sub rsp, 8

    call read_int
    mov [n], eax

    imul eax, eax
    mov [nSquare], eax

    mov edi, [nSquare]
    ;call print_int

    mov ebx, 0

    input_loop1:
        mov ecx, [nSquare]
        cmp ebx, ecx
        jge input_loop1_end

        call read_float
        mov array1[ebx*4], eax
        mov edi, ebx        

        add ebx, 1
        jmp input_loop1

    input_loop1_end:
        ;mov edi, array1[8]
        ;call print_float
        ;call print_nl

    mov ebx, 0

    input_loop2:
        mov ecx, [nSquare]
        cmp ebx, ecx
        jge input_loop2_end

        call read_float
        mov array2[ebx*4], eax
        mov edi, ebx        

        add ebx, 1
        jmp input_loop2

    input_loop2_end:
        ;mov edi, array2[8]
        ;call print_float
        ;call print_nl

    mov eax, 0               ;register for elements of first array
    mov ebx, 0               ;register for elements of second array
    mov r12, [n]

    mov r13, [ii]
    mov r14, [jj]
    mov r15, [kk]

    multiply_loop1:
        mov r14, 0
        multiply_loop2:
            mov r15, 0
            multiply_loop3:
                mov rcx, r12
                imul rcx, r13 
                add rcx, r15
                mov eax, array1[rcx*4]

                mov rcx, r12
                imul rcx, r15 
                add rcx, r14
                mov ebx, array2[rcx*4]

                mov rcx, r12
                imul rcx, r13
                add rcx, r14
                movd xmm0, eax
                movd xmm1, ebx
                mulss xmm0, xmm1
                movd eax, xmm0

                
                
                mov ebx, result[rcx*4]

                movd xmm0, eax
                movd xmm1, ebx
                addss xmm0, xmm1
                movd eax, xmm0

                ;add eax, ebx
              
                mov result[rcx*4], eax

                

                inc r15
                cmp r12, r15
                jg multiply_loop3

            inc r14
            cmp r12, r14
            jg multiply_loop2
        
        inc r13
        cmp r12, r13
        jg multiply_loop1


        mov ebx, 0

    print_result:
        mov ecx, [nSquare]
        cmp ebx, ecx
        jge print_result_end
        mov edi, result[ebx*4]
        call print_float
        mov edi, ebx        

        add ebx, 1
        jmp print_result

    print_result_end:

;    call read_float
;    mov array1[8] , rax
;    mov rdi, array1[8]
 ;   call print_float
    ;# call read_float
    ;# mov edi, eax
    ;# call print_float

    add rsp, 8

	pop r15
	pop r14
	pop r13
	pop r12
    pop rbx
    pop rbp

	ret
