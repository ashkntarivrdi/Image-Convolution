%include "asm_io.inc"

segment .data
    n dq 0
    temp dq 0
    nExpanded dq 0
    nExpandedSquare dq 0
    nSquare dq 0
    array1 dd 1000000 DUP(0)
    array2 dd 1000000 DUP(0)
    array1_expanded dd 1000000 DUP(0)
    array2_expanded_transposed dd 1000000 DUP(0)
    cross_product_parallel_result dd 1000000 DUP(0)

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

    call read_int   ;call function to read the input number
    mov [n], eax    ;move the input number from eax register to a variable

    ;calculate input number power two and move to a variable
    imul eax, eax   
    mov [nSquare], eax

    mov ebx, 0
    ;loop for getting the first input matrix
    input_loop1:
        mov ecx, [nSquare]  ;set the counter
        cmp ebx, ecx    ;check for the loop condition
        jge input_loop1_end ;jump to the end of the loop if the condition is met

        call read_float ;call function to read floating points number
        mov array1[ebx*4], eax  ;move the floating point number to array1

        add ebx, 1  ;increment the counter
        jmp input_loop1 ;jump back to the start point of the first loop

    input_loop1_end:

    mov ebx, 0
    ;loop for getting the second input matrix
    input_loop2:
        mov ecx, [nSquare]  ;set the counter
        cmp ebx, ecx    ;check for the loop condition
        jge input_loop2_end ;jump to the end of the loop if the condition is met

        call read_float ;call funtion to read floating points
        mov array2[ebx*4], eax  ;move the floating point number to array2

        add ebx, 1  ;increment the counter
        jmp input_loop2 ;jump back to the starting point of the second loop

    input_loop2_end:        


    call expand_n   ;call a function to find the nearest number multiply to four
    
    ;calculate the power two of the expanded number
    mov r12, [nExpanded] 
    imul r12, r12
    mov [nExpandedSquare], r12

    call expand_array1  ;call a function to expand the first matrix
    call expand_and_transpose_array2    ;call a function to expand and transpose the second matrix
    call cross_product_parallel ;call a function to calculate the cross product of matrix1 and matrix 2 in a parallel mode

    mov ebx, 0  ;set the counter for printing result loop
    mov r12, 0
    ;loop for printing the cross product result
    print_result:
        mov ecx, [nSquare]  ;set the counter
        cmp ebx, ecx    ;check for the loop condition
        jge print_result_end    ;jump to the end of the loop if the condition is met
        mov r13, [n]
        cmp r13, r12
        jg continue
        mov r12, 0
        call print_nl   ;print a new line
    continue:
        mov edi, cross_product_parallel_result[ebx*4] ;move the element to edi register for printing
        call print_float    ;call a function to print the floating point number
        mov rdi, 32     ;move the space character to rdi register for printing
        call print_char ;call a function to print a character

        ;increment counters
        add ebx, 1
        add r12, 1
        jmp print_result ;jump back to the beggining of the loop

    print_result_end:

    add rsp, 8

	pop r15
	pop r14
	pop r13
	pop r12
    pop rbx
    pop rbp

	ret

expand_n:
    sub rsp, 8

    ;find the first number that is multiple to four
    mov r13, 3
    mov r14, 4

    mov rax, [n]
    mov [nExpanded], rax
    and rax, r13

    ;end the expansion if zero flag is set
    jz end_expansion

    sub rax, r14
    neg rax
    add [nExpanded], rax
    
    end_expansion:

    add rsp, 8
    ret


expand_array1:
    sub rsp, 8

    mov r12, 0 ;counter for the outer loop (i)
    first_loop_array1:
        ;check if the outer counter is reached to n or not
        mov rax, [n]
        cmp r12, rax
        je end_first_loop_array1

        mov r13, 0 ;counter for the inner loop (j)
        second_loop_array1:
            
            ;check if the counter is reached to n or not
            mov rax, [n] 
            cmp r13, rax
            je continue_first_loop_array1

            ;calculate the index for the prior array
            mov r14, [n]
            imul r14, r12
            add r14, r13

            ;calculate the index for the expanded version array
            mov r15, [nExpanded]
            imul r15, r12
            add r15, r13

            ;initialize the expanded array
            mov ebx, array1[r14*4]
            mov array1_expanded[r15*4], ebx

            ;increment inner counter
            add r13, 1 
            jmp second_loop_array1

        continue_first_loop_array1:
        ;increment outer counter
        add r12, 1
        jmp first_loop_array1


    end_first_loop_array1:        

    add rsp, 8
    ret



expand_and_transpose_array2:
    sub rsp, 8
    
    mov r12, 0 ;counter for the outer loop (i)
    first_loop:
        ;check if the outer counter is reached to n or not
        mov rax, [n]
        cmp r12, rax
        je end_first_loop

        mov r13, 0 ;counter for the inner loop (j)
        second_loop:
            
            ;check if the counter is reached to n or not
            mov rax, [n] 
            cmp r13, rax
            je continue_first_loop

            ;calculate the index for the prior array
            mov r14, [n]
            imul r14, r13
            add r14, r12

            ;calculate the index for the expanded version array
            mov r15, [nExpanded]
            imul r15, r12
            add r15, r13

            ;initialize the expanded array
            mov ebx, array2[r14*4]
            mov array2_expanded_transposed[r15*4], ebx

            ;increment inner counter
            add r13, 1 
            jmp second_loop

        continue_first_loop:
        ;increment outer counter
        add r12, 1
        jmp first_loop


    end_first_loop:

    add rsp, 8
    ret


cross_product_parallel:
    sub rsp, 8

    mov rax, [n]
    mov rdx, [nExpanded]
    mov r12, 0 ;counter for the first loop (i)
    first_cross_loop:
        cmp r12, rax
        jge end_cross_loop

        mov r13, 0 ;counter for the second loop (j)
        second_cross_loop:
            cmp r13, rax
            jge continue_cross_first_loop

            mov qword [temp], 0
            mov r14, 0 ;counter for the third loop (k)
            third_cross_loop:
                cmp r14, rdx
                jge continue_cross_second_loop
                ;generate expanded array1 index
                mov rbx, r12
                imul rbx, rdx
                add rbx, r14

                ;generate expanded array2 index
                mov rcx, r13
                imul rcx, rdx
                add rcx, r14

                movups xmm0, array1_expanded[rbx*4]  ;move four elements of the array1 to xmm0
                movups xmm1, array2_expanded_transposed[rcx*4] ;move four elements of the array2 to xmm1

                ;jaygozine dastore dpps
                mulps xmm0, xmm1
                haddps xmm0, xmm0
                haddps xmm0, xmm0
                ;

;                dpps xmm0, xmm1, 0xF1 ;multiply the the four elements in a parallel mode

                addss xmm0, [temp]
                movss [temp], xmm0

                add r14, 4 ;increment the index of array1 and array2
                jmp third_cross_loop

            continue_cross_second_loop:
            mov rbx, r12
            imul rbx, rax
            add rbx, r13

            movss xmm1, [temp]
            movss cross_product_parallel_result[rbx*4], xmm0

            add r13, 1 ;increment the second loop counter
            jmp second_cross_loop

        continue_cross_first_loop:
        add r12, 1 ;increment the first loop counter
        jmp first_cross_loop

    end_cross_loop:

    add rsp, 8
    ret