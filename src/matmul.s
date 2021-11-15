.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 59
# =======================================================
matmul:

    # Error checks
	li t1, 1
    blt a1, t1, exit_2
    blt a2, t1, exit_2
    blt a4, t1, exit_2
    blt a5, t1, exit_2
    bne a2, a4, exit_2
    # Prologue
    addi sp, sp, -24
    sw s1, 0(sp)
    sw s2, 4(sp)
    sw s3, 8(sp)
    sw s4, 12(sp)
    sw s5, 16(sp)
    sw s6, 20(sp)
    
    mv s1, a0
    mul s2, a1, a2
    slli s2, s2, 2
    add s2, a0, s2
    slli s3, a2, 2
    
    mv s5, a3
    slli s6, a5, 2
    add s6, a3, s6

    
outer_loop_start:
	bge s1, s2, outer_loop_end
    mv s5, a3
    
inner_loop_start:
	bge s5, s6, inner_loop_end
    
    addi sp, sp, -32
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw ra, 28(sp)
    
    mv a0, s1
    mv a1, s5
#     mv a2, a2
	li a3, 1
    mv a4, a5
    jal dot
   	mv t0, a0
    
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    
    sw t0, 0(a6)
    addi a6, a6, 4
    
    addi s5, s5, 4
	j inner_loop_start

inner_loop_end:
    add s1, s1, s3
    j outer_loop_start

outer_loop_end:
    # Epilogue
    lw s1, 0(sp)
    lw s2, 4(sp)
    lw s3, 8(sp)
    lw s4, 12(sp)
    lw s5, 16(sp)
    lw s6, 20(sp)
	addi sp, sp, 24
    ret

exit_2:
	li a1, 59
    j exit2