.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 92
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)

    mv s1, a0
    mv s2, a1
    mv s3, a2
    mv s4, a3

    # fopen
    mv a1, s1
    li a2, 1
    jal fopen
    blt a0, x0, exit89
    mv s5, a0

    # fwrite rows and rols
    mv a1, s5
    addi sp, sp, -8
    sw s3, 0(sp)
    sw s4, 4(sp)
    mv a2, sp
    li a3, 2
    li a4, 4
    addi sp, sp, -4
    sw a3, 0(sp)
    jal fwrite
    lw a3, 0(sp)
    addi sp, sp, 4
    bne a0, a3, exit92
    lw s3, 0(sp)
    lw s4, 4(sp)
    addi, sp, sp, 8

    # fwrite data
    mv a1, s5
    mv a2, s2
    mul t0, s3, s4
    mv a3, t0
    li a4, 4
    addi sp, sp, -4
    sw a3, 0(sp)
    jal fwrite
    lw a3, 0(sp)
    addi sp, sp, 4
    bne a0, a3, exit92

    # fclose
    mv a1, s5
    jal fclose
    blt a0, x0, exit90

    # Epilogue
    lw ra, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    addi, sp, sp, 24

    ret



exit89:
    li a1, 89
    call exit2
exit90:
    li a1, 90
    call exit2
exit92:
    li a1, 92
    call exit2