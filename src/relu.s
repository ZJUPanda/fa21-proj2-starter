.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# ==============================================================================
relu:
    # Prologue
	li t1, 1
    blt a1, t1, exit_2
    add t0, x0, x0  
loop_start:
	beq t0, a1, loop_end
    slli t1, t0, 2 # t0*4
    addi t0, t0, 1
    add t1, a0, t1
    lw t2, 0(t1) # a1[t0]
    bge t2, x0, loop_continue
    sw x0, 0(t1) 

loop_continue:
	j loop_start

loop_end:
    # Epilogue
	ret
exit_2:
	li a1, 57
    call exit2