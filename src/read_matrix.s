.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw s1, 0(sp)
    sw s2, 4(sp)
    sw s3, 8(sp)
    sw s4, 12(sp)
    sw s5, 16(sp)
    sw s6, 20(sp)
    sw ra, 24(sp)

    mv s1, a0
    mv s2, a1
    mv s3, a2

    # fopen
    mv a1, s1
    mv a2, x0
    jal fopen
    blt a0, x0, exit89
    mv s4, a0

    # fread rows
    mv a1, s4
    mv a2, s2
    li a3, 4
    addi sp, sp, -12
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    jal fread
    lw a3, 8(sp)
    lw a2, 4(sp)
    lw a1, 0(sp)
    addi sp, sp, 12
    bne a0, a3, exit91
    


    # fread cols
    mv a1, s4
    mv a2, s3
    li a3, 4
    addi, sp, sp, -4
    sw a3, 0(sp)
    jal fread
    lw a3, 0(sp)
    addi, sp, sp, 4
    bne a0, a3, exit91
    
    # malloc
    lw t1, 0(s2) # rows
    lw t2, 0(s3) # cols
    mul t1, t1, t2
    slli s6, t1, 2
    mv a0, s6
    jal malloc
    beq a0, x0, exit88
    mv s5, a0

    # fread matrix
    mv a1, s4
    mv a2, s5
    mv a3, s6
    addi sp, sp, -4
    sw a3, 0(sp)
    jal fread
    lw a3, 0(sp)
    addi sp, sp, 4
    bne a0, a3, exit91

    # fclose
    mv a1, s4
    jal fclose
    blt a0, x0, exit90

    mv a0, s5
   
    # Epilogue
    lw s1, 0(sp)
    lw s2, 4(sp)
    lw s3, 8(sp)
    lw s4, 12(sp)
    lw s5, 16(sp)
    lw s6, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret

exit88:
    li a1, 88
    call exit2
exit89:
    li a1, 89
    call exit2
exit90:
    li a1, 90
    call exit2
exit91:
    li a1, 91
    call exit2