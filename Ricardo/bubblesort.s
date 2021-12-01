.data 
numbers: .word 8, 10, 0, 3, -9, 122, 100, 2, 5, 3, 4, 5 	#array for input
message: .asciiz "Sorted: "	                                #print message

.text
main:
	la $s7, numbers				# load address of input into $s7
	#lui $at, numbers
	#ori $s7, $at, disp

	li $s0, 0				# Set counter s0 = 0 for loop 1
	li $s6, 10 				# N - 1
	
	li $s1, 0 				# Set counter s1 = 0 for loop 2

	li $t3, 0				# Set counter s3 = 0 for printing
	li $t4, 11				# Number of inputs -1

	li $v0, 4,				#print message
	la $a0, message				#print message
	syscall

loop:
	sll $t7, $s1, 2				# t7 = s1 * 2
	add $t7, $s7, $t7 			# Add the address of numbers to t7

	lw $t0, 0($t7)  			# Load numbers[j]	
	lw $t1, 4($t7) 				# Load numbers[j+1]

	slt $t2, $t0, $t1			# If t0 < t1
	bne $t2, $zero, increment		# jump to increment if if t2 is not equal to 0

	sw $t1, 0($t7) 				# Swap
	sw $t0, 4($t7)				# Swap

increment:	

	addi $s1, $s1, 1			# t1 + 1
	sub $s5, $s6, $s0 			# s5 = s6 - s0

	bne  $s1, $s5, loop			# jump to loop if s1 (counter for second loop) does not equal 9
	addi $s0, $s0, 1 			# Else add 1 to s0
	li $s1, 0 				# Reset s1 to 0

	bne  $s0, $s6, loop			# Iterate back through loop with s1 = s1 + 1
	
print:
	beq $t3, $t4, final			# If t3 = t4 go to final
	
	lw $t5, 0($s7)				# Load from numbers
	
	li $v0, 1				# Print the number
	move $a0, $t5
	syscall

	li $a0, 32				# Print space
	li $v0, 11
	syscall
	
	addi $s7, $s7, 4			# Iterate over numbers 
	addi $t3, $t3, 1			# Increment counter

	j print

final:	
	li $v0, 10				# Finished
	syscall
