.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 58
# =======================================================
dot:
    # Prologue

loop_start:
	li t1, 1
	blt a2, t1, exit_1
    blt a3, t1, exit_2
    blt a4, t1, exit_2
	mv t0, x0
    mv t1, x0
    mv t6, x0
    slli t2, a3, 2
    slli t3, a4, 2

loop_continue:
	bge t0, a2, loop_end
    

    lw t4, 0(a0)
    lw t5, 0(a1)
    mul t4, t4, t5
    add t6, t6, t4 # sum
    
    add a0, a0, t2
    add a1, a1, t3
    addi t0, t0, 1
	j loop_continue

loop_end:
	mv a0, t6

    # Epilogue
    ret
exit_1:
	li a1, 57
    call exit2
exit_2:
	li a1, 58
    call exit2