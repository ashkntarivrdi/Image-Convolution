%include "asm_io.inc"

segment .data
    ARRAY_LENGTH db 100
    ii dq 0
    jj dq 0
    kk dq 0
    n dq 0
    iterative_loop_counter dq 0
    temp dq 0
    startTime dq 0
    endTime dq 0
    nSquare dq 0
    array1 dd 4000000 DUP(0)
    array2 dd 4000000 DUP(0)
    cross_product_result dd 4000000 DUP(0)


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
        

    call sys_gettimeofday_ms
    mov [startTime], rax
    ; mov qword [iterative_loop_counter], 100000
    ; iterative_loop:

        call normal_cross_product
        ; dec qword [iterative_loop_counter]
        ; jge iterative_loop
    
    call sys_gettimeofday_ms
    mov [endTime], rax

    ; mov ebx, 0  ;set the counter for printing result loop
    ; mov r12, 0
    ; ;loop for printing the cross product result
    ; print_result:
    ;     mov ecx, [nSquare]  ;set the counter
    ;     cmp ebx, ecx    ;check for the loop condition
    ;     jge print_result_end    ;jump to the end of the loop if the condition is met
    ;     mov r13, [n]
    ;     cmp r13, r12
    ;     jg continue
    ;     mov r12, 0
    ;     call print_nl   ;print a new line
    ; continue:
    ;     mov edi, cross_product_result[ebx*4] ;move the element to edi register for printing
    ;     call print_float    ;call a function to print the floating point number
    ;     mov rdi, 32     ;move the space character to rdi register for printing
    ;     call print_char ;call a function to print a character

    ;     ;increment counters
    ;     add ebx, 1
    ;     add r12, 1
    ;     jmp print_result ;jump back to the beggining of the loop

    ; print_result_end:
    call print_nl

    mov r12, [startTime]
    mov r13, [endTime]
    sub r13, r12
    mov rdi, r13
    call print_int
    call print_nl

    add rsp, 8

	pop r15
	pop r14
	pop r13
	pop r12
    pop rbx
    pop rbp

	ret


normal_cross_product:
    sub rsp, 8


    mov eax, 0       ;register for elements of first array
    mov ebx, 0       ;register for elements of second array
    mov r12, [n]

    mov r13, [ii]   ;load counter for the first loop (i)
    mov r14, [jj]   ;load counter for the second loop (j)
    mov r15, [kk]   ;load counter for the third loop (k)

    multiply_loop1:
        mov qword [jj], 0
        ;mov r14, 0  ;reset the counter (j)
        multiply_loop2:
            mov qword [kk], 0
            ;mov r15, 0  ;reset the counter (k)
            multiply_loop3:
                ;calculating the array1 index
                mov rcx, r12
                mov r13, [ii]
                imul rcx, r13
                mov r15, [kk]
                add rcx, r15
                mov eax, array1[rcx*4]

                ;calculating the array2 index
                mov rcx, r12
                mov r15, [kk]
                imul rcx, r15 
                mov r14, [jj]
                add rcx, r14
                mov ebx, array2[rcx*4]

                mov rcx, r12
                mov r13, [ii]
                imul rcx, r13
                mov r14, [jj]
                add rcx, r14
                movd xmm0, eax  ;move the array1 element into the xmm0
                movd xmm1, ebx  ;move the array2 element into the xmm1
                mulss xmm0, xmm1    ;multiply elements of array1 and array2
                movd eax, xmm0  ;move the result back into the eax register
                
                
                mov ebx, cross_product_result[rcx*4]

                ;move eax and ebx into SSE registers and add them together
                movd xmm0, eax 
                movd xmm1, ebx
                addss xmm0, xmm1
                movd eax, xmm0
              
                mov cross_product_result[rcx*4], eax

                ;inc r15 ;increment the counter (k)
                add qword [kk], 1
                mov r15, [kk]
                cmp r12, r15    ;check the third loop condition
                jg multiply_loop3   ;jump back to the third loop if the condition is met

            ;inc r14 ;increment the counter (j)
            add qword [jj], 1
            mov r14, [jj]
            cmp r12, r14    ;check the second loop condition
            jg multiply_loop2   ;jump back to the second loop if the condition is met

        ;inc r13 ;increment the counter (i)
        add qword [ii], 1
        mov r13, [ii]
        cmp r12, r13    ;check the first loop condition
        jg multiply_loop1 ;jump back to the first loop if the condition is met

        mov ebx, 0


    add rsp, 8
    ret



sys_gettimeofday_ms:

    push rbp                                        
    push rbx                                        
    push r12                                        
    push r13                                      
    push r14                                        
    push r15

    sub rsp, 8

    mov rax, 96
    lea rdi, [rsp - 16]
    xor esi, esi
    syscall
    mov ecx, 1000
    mov rax, [rdi + 8]
    xor edx, edx
    div rcx
    mov rdx, [rdi]
    imul rdx, rcx
    add rax, rdx

    add rsp, 8

    pop r15  
    pop r14  
    pop r13  
    pop r12  
    pop rbx  
    pop rbp  

    ret




    ; call sys_gettimeofday_ms                    ;| --> Store function start time
    ; mov r12, rax                                ;|

    ; mov r13, 1000000                            ;| --> Loops 1000000 times in order to compare multiplication times
    ; cornometer_loop:                            ;|

    ; call multiply_v1_and_transpose              ;  --> Call multiply subroutine

    ; dec r13
    ; jge cornometer_loop

    ; call sys_gettimeofday_ms                    ;| --> Get end time and calculate duration then print it
    ; mov rdi, rax                                ;|
    ; sub rdi, r12                                ;|
    ; call print_int                              ;|
    ; call print_nl                               ;|

