.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 72
    # - If malloc fails, this function terminates the program with exit code 88
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0, 5
    bne a0, t0, exit72

    addi sp, sp, -44
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw ra, 40(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2



	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    lw a0, 4(s1)
    addi sp, sp, -8
    add a1, sp, x0    
    addi a2, sp, 4
    jal read_matrix
    mv s3, a0 # m0

    # Load pretrained m1
    lw a0, 8(s1)
    addi sp, sp, -8
    add a1, sp, x0    
    addi a2, sp, 4
    jal read_matrix
    mv s4, a0 # m1


    # Load input matrix
    lw a0, 12(s1)
    addi sp, sp, -8
    add a1, sp, x0    
    addi a2, sp, 4
    jal read_matrix
    mv s5, a0 # input


    # =====================================
    # RUN LAYERS
    # =====================================
    
    # 1. LINEAR LAYER:    m0 * input
    # malloc
    lw t1, 16(sp)
    lw t2, 4(sp)
    mul t1, t1, t2
    slli a0, t1, 2 # bytesize
    addi sp, sp, -4
    sw t1, 0(sp)
    jal malloc
    mv s6, a0

    mv a0, s3
    lw a1, 20(sp) # m0.rows
    lw a2, 24(sp) # m0.cols
    mv a3, s5
    lw a4, 4(sp) # input.rows
    lw a5, 8(sp) # input.cols
    mv a6, s6
    jal matmul


    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    mv a0, s6
    lw a1, 0(sp)
    jal relu
    mv s8, a0

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    # malloc
    lw t1, 12(sp)
    lw t2, 8(sp)
    mul t1, t1, t2
    slli a0, t1, 2 # bytesize
    addi sp, sp, -4
    sw t1, 0(sp)
    jal malloc
    mv s7, a0

    mv a0, s4
    lw a1, 16(sp) # m1.rows
    lw a2, 20(sp) # m1.cols
    mv a3, s8
    lw a4, 24(sp) # m0.rows
    lw a5, 12(sp) # input.cols
    mv a6, s7
    jal matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    ebreak
    
    lw a0, 16(s1)
    mv a1, s7
    lw a2, 16(sp)
    lw a3, 12(sp)
    jal write_matrix
    
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s7
    lw a1, 0(sp)
    jal argmax
    mv s9, a0
    addi sp, sp, 32

    # Print classification
    bne s2, x0, print_nothing
    mv a1, s9
    jal print_int

    # Print newline afterwards for clarity
    li a1, '\n'
    jal print_char

print_nothing:

    # free
    mv a0, s3
    jal free    
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free

    mv a0, s9

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw ra, 40(sp)
    addi, sp, sp, 44

    ret


exit88:
    li a1, 88
    call exit2
exit72:
    li a1, 72
    call exit2