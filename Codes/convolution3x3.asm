%include "asm_io.inc"

;kernel with 3x3 matrix


segment .data
    ARRAY_LENGTH db 100
    ii dq 0
    jj dq 0
    kk dq 0
    counter dq 0
    n dq 0
    nConv dq 0
    nSquareConv dq 0
    nSquare dq 0

    result_array dd 4000000 DUP(0)
    
    dot_product_result             dq 0
    parallel_dot_product_result    dq 0 
    temp_array                        dd 16 DUP(0)

    array dd 4000000 DUP(0)
    dot_array dd 36 DUP(0)
    generatedArray dd 4000000 DUP(0)
    kernel dd 100 DUP(0)

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

    call read_int   ;call a function to read size of the input matrix
    mov [n], eax    ;mov the input number from eax register to a variable
    
    ;input number convolution is nConv = n + 2
    mov ebx, eax    
    add ebx, 2  
    mov [nConv], ebx
    
    ;calculating the power two of the number convolution
    imul ebx, ebx
    mov [nSquareConv], ebx

    ;calculating the power two of the number
    imul eax, eax
    mov [nSquare], eax

    mov ebx, 0
    ;loop for getting the first input matrix
    input_loop1:
        mov ecx, [nSquare]  ;set the counter
        cmp ebx, ecx    ;check for the loop condition
        jge input_loop1_end ;jump to the end of the loop if the condition is met

        call read_float ;call function to read floating points number
        mov array[ebx*4], eax  ;move the floating point number to array1

        add ebx, 1  ;increment the counter
        jmp input_loop1 ;jump back to the start point of the first loop

    input_loop1_end:

    mov ebx, 0
    ;loop for getting the kernel matrix
    input_loop2:
        mov ecx, 9  ;set the counter (bcz size of the kernel is 3x3)
        cmp ebx, ecx    ;check for the loop condition
        jge input_loop2_end ;jump to the end of the loop if the condition is met

        call read_float ;call function to read floating points
        mov kernel[ebx*4], eax  ;move the floating point number to kernel

        add ebx, 1 ;increment the counter
        jmp input_loop2 ;jump back to the starting point of the loop

    input_loop2_end:

    mov ebx, 0  ;counter for outer matrix
    mov eax, 0  ;counter for inner matrix
    mov r13, 1
    mov [ii], r13   ;set the counter (i) to 1
    mov [jj], r13   ;set the counter (j) to 1

    ;method for creating the array from input matrix for convolution use
    create_array_loop:
        mov ecx, [nSquare]  ;set the counter to number power to two
        cmp eax, ecx    ;check the loop condition
        jge end_loop    ;jump to the end of the loop if the condition is met

        ;method for creating the lower row of the generated array
        mov r13, [jj]
        mov r15, [n]
        cmp r13, [n]    ;check for the lower row condition
        jne right_row   ;jump to the right row label if not equal
        mov r15, [ii]
        mov r14, [nConv]
        add r13, 1
        imul r13, r14
        add r13, r15

        mov r12, array[eax*4] ;move the element of array into r12 register
        mov generatedArray[r13*4], r12   ;move element to the new array


        ;label to check if the right row is created or not
        right_row:
        mov r15, [ii]
        mov r14, [n]
        cmp r14, r15    ;check for the right row condition
        jne continue_loop

        ;method for creating the right row of the generated array
        mov r15, [ii]
        mov r14, [nConv]
        mov r13, [jj]
        imul r13, r14
        add r13, r15
        sub eax, 1

        mov r12, array[eax*4] ;move the element of array into r12 register
        mov generatedArray[r13*4], r12  ;move element to the new array
        add eax, 1  ;increment the counter
        sub r13, 1  ;decrement the counter
        mov generatedArray[r13*4], r12  ;move element to the new array
        add r13, 1

        mov r13, 1
        mov [ii], r13
        ;increment the counter (jj)
        mov r13, [jj]
        add r13, 1
        mov [jj], r13
        add eax, 1
        jmp create_array_loop ;jump back to the beggining of the loop
        
        ;lable to continue the loop
        continue_loop: 

        ;calculating the index for the input array
        mov r15, [ii]   ;load the counter into r15 register
        mov r14, [nConv]    ;load the number convolution to r14 register
        mov r13, [jj]
        imul r13, r14
        add r13, r15

        mov r12, array[eax*4] ;move the element of array into r12 register
        mov generatedArray[r13*4], r12  ;move element to the new array

        ;method for creating the left row of the generated array
        cmp r15, 1  ;check the condition for left row
        jne left_row    ;jump to left row label if not equal
        sub r13, 1
        mov generatedArray[r13*4], r12 ;move element to the new array
        add r13, 1
        mov generatedArray[r13*4], r12 ;move element to the new array

        ;method for creating the upper row of the generated array
        left_row:
        mov r15, [jj]
        cmp r15, 1  ;check the condition for upper row
        jne increment_counter
        mov r13, [ii]
        mov r12, array[eax*4] ;move the element of array into r12 register
        mov generatedArray[r13*4], r12

        
        ;label for incrementing the counters
        increment_counter:

        ;increment the counter (ii)
        mov r13, [ii]
        add r13, 1
        mov [ii], r13

        add eax, 1  ;increment the counter (eax)
        jmp create_array_loop ;jump back to the first of the loop

    end_loop:

    ;creating the four corners of the generated matrix
    ;left top corner
    mov r12, 0
    mov eax, array[r12]
    mov generatedArray[r12], eax ;move element to the new array

    ;right top corner
    mov r12, [n]
    sub r12, 1
    mov eax, array[r12*4]
    mov r12, [nConv]
    sub r12, 1
    mov generatedArray[r12*4], eax ;move element to the new array

    ;right bottom corner
    mov r12, [nSquare]
    sub r12, [n]
    mov eax, array[r12*4]
    mov r12, [nSquareConv]
    sub r12, [nConv]
    mov generatedArray[r12*4], eax ;move element to the new array

    ;left bottom corner
    mov r12, [nSquare]
    sub r12, 1
    mov eax, array[r12*4]
    mov r12, [nSquareConv]
    sub r12, 1
    mov generatedArray[r12*4], eax ;move element to the new array

    ;az inja code kasra bara convolution shoro mishe

    mov ebx, 0 ; counter for n^2
        mov r12, 0 ; counter for n
        mov r13, 0 ; counter for n'^2
        mov r14, 0 ; counter for n'
        mov r15, 0
        mov r13, [nConv] ;move number of convolution into r13 register
        inc r13 ;increment counter
        jmp conv    ;jump to the convolution function

    conv_end:   

    ;print the result of the convolution    
    mov ebx, 0  ;set the counter for printing result loop
    mov r12, 0
    ;loop for printing the cross product
    print_result_new:
        mov ecx, [nSquare]  ;set the counter
        cmp ebx, ecx    ;check for the loop condition
        jge print_result_end_new    ;jump to the end of the loop if the condition is met
        mov r13, [n]    
        cmp r13, r12    
        jg continue_new
        mov r12, 0
        call print_nl   ;call a function to print a new line

    continue_new:
        mov edi, result_array[ebx*4]    ;move the elemnt to edi register for printing 
        call print_float    ;call a function to print the floating point number
        mov rdi, 32 ;move the white space character to rdi register for printing
        call print_char ;call a function to print the white space character

        ;increment counters
        add ebx, 1  
        add r12, 1
        jmp print_result_new    ;jump back to beggining of the printing result loop

    print_result_end_new:
        call print_nl




    add rsp, 8

	pop r15
	pop r14
	pop r13
	pop r12
    pop rbx
    pop rbp

	ret

    conv:
        mov ecx, [nSquare]  ;move number power to two into ecx register
        mov ebx, [counter]  ;move counter variable into ebx register
        cmp ebx, ecx    ;check the loop condition 
        jge conv_end    ;jump to the end of the convolution loop if the condition is met

        mov r15, 0  ;reset the counter

        sub r13, [nConv]
        dec r13 ;decrement the counter
        mov eax, generatedArray[r13*4]  ;move the element that is going to be multiplied into eax register
        mov dot_array[r15*4], eax   ;move the mentioned element into dot_array
        
        mov edx, 0  ;reset the counter
        conv_loop:
        cmp edx, 2  ;check the loop condition
        je continue_conv_loop   ;jump to the beggining of the convolution function

        inc r13     ;increment the counter
        inc r15     ;increment the counter
        mov eax, generatedArray[r13*4]  ;move the element that is going to be multiplied into eax register
        mov dot_array[r15*4], eax ;move the mentioned element into dot_array
        inc edx     ;increment the loop counter
        jmp conv_loop   ;jump to the beggining of the first convolution loop

        continue_conv_loop:
        dec r13     ;decrement the counter  
        inc r15     ;increment the counter

        add r13, [nConv]
        dec r13
        mov eax, generatedArray[r13*4] ;move the element that is going to be multiplied into eax register
        mov dot_array[r15*4], eax ;move the mentioned element into dot_array
        
        mov edx, 0  ;reset the counter
        conv_loop2:
        cmp edx, 2  ;check the loop condition
        je continue_conv_loop2  ;jump to continue the conv function if the condition is met

        inc r13     ;increment the counter
        inc r15     ;increment the counter
        mov eax, generatedArray[r13*4]  ;move the element that is going to be multiplied into eax register
        mov dot_array[r15*4], eax ;move the mentioned element into dot_array
        inc edx     ;increment the loop counter
        jmp conv_loop2  ;jump to the beggining of the second convolution loop
        
        continue_conv_loop2:
        dec r13     ;decrement the counter
        inc r15     ;increment the counter

        add r13, [nConv]
        dec r13     ;decrement the counter
        mov eax, generatedArray[r13*4] ;move the element that is going to be multiplied into eax register
        mov dot_array[r15*4], eax ;move the mentioned element into dot_array
        

        mov edx, 0  ;reset the counter
        conv_loop3:
        cmp edx, 2  ;check the loop condition
        je continue_conv_loop3  ;jump to continue the conv function if the condition is met

        inc r13     ;increment the counter
        inc r15     ;increment the counter
        mov eax, generatedArray[r13*4]  ;move the element that is going to be multiplied into eax register
        mov dot_array[r15*4], eax ;move the mentioned element into dot_array
        inc edx     ;increment the loop counter
        jmp conv_loop3
        
        continue_conv_loop3:
        
        dec r13     ;decrement the counter

        sub r13, [nConv]

        ;save contents of registers
        push r12
        push r13
        push r14
        push r15

        mov r12, 9  ;move 9 to r12 because the kernel is 3x3
        mov r13, 0  ;reset the counter
        mov r14, 0  ;reset the counter
        mov r15, 0  ;reset the counter

        mov eax, 0  ;reset the counter
        mov [parallel_dot_product_result], eax

        jmp parallel_dot_product

        ;label for finishing the parallel dot product
        finish_parallel_dot_product:

        mov eax, [parallel_dot_product_result]  ;move the result of the dot product to eax register
        mov result_array[ebx*4], eax    ;move the final result into the result array

        ;label for finishing the dot product
        finish_dot_product:

        pop r15
        pop r14
        pop r13
        pop r12

        inc r12 ;increment the counter
        mov rcx, [n]
        cmp r12, rcx    ;check the loop condition
        jne loop_not_finished_new   ;jump to the label that the convolution is not finished yet
        mov r12, 0
        add r13, 2
        inc r14 ;increment the counter
        ;label for not finishing the convolution
        loop_not_finished_new : 
        inc r13 ;increment the counter
        mov ebx, [counter]  
        add ebx, 1
        mov [counter], ebx
        jmp conv    ;jump to the beggining of the convolution function


parallel_dot_product:

    parallel_multiply_array:
        mov r14, 0  ;reset the counter
        mov r15, 0  ;reset the counter

        movups xmm0, dot_array[r13*4]   ;move the element from array to xmm0 register
        movups xmm1, kernel[r13*4]  ;move the element from kernel to xmm0 register

        add r13, 4  ;add the counter with 4

        dpps xmm0, xmm1, 0xF1   ;multiply contents of the register in parallel form
        movups [temp_array], xmm0
        mov ecx, temp_array[0] ;move the content to the ecx register
        mov eax, [parallel_dot_product_result]  ;move the content to eax register
        movd xmm0, eax  ;move eax to xmm0 register to add floating points
        movd xmm1, ecx  ;move ecx to xmm1 register to add floating points
        addss xmm0, xmm1    ;add the contents of two array
        movd eax, xmm0
        mov [parallel_dot_product_result], eax  ;store the result in the final array
        
        cmp r12, r13    ;check the loop condition
        jg parallel_multiply_array ;jump back to the beggining of the loop

    jmp finish_parallel_dot_product
