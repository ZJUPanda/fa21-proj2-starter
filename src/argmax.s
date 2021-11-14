.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -4
    sw s2, 0(sp)

loop_start:
    li t1, 1
    blt a1, t1, exit_2
    add t0, x0, t1 
    lw s2, 0(a0)
    addi t1, a0, 4
    mv a0, x0
    
loop_continue:
	beq t0, a1, loop_end
    lw t2, 0(t1) # a1[t0]
    addi t1, t1, 4
    blt s2, t2, refresh
    addi t0, t0, 1
	j loop_continue
    
loop_end:
    # Epilogue
    lw, s2, 0(sp)
    addi sp, sp, 4
    ret
exit_2:
	li a1, 57
    call exit2
    
refresh:
	# refresh the index and maximum value
    mv s2, t2
    mv a0, t0
    addi, t0, t0, 1
    j loop_continue