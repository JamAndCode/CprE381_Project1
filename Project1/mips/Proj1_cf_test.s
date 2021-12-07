.data #no data, we die like men
.text
main:
	addi $t1, $0, 0
	j	theFirstLayer
	
theFirstLayer:
	addi $t1, $1, 5
	addi $t2, $1, 20
	bne $t1, $t2, theSecondLayer
	addi $t3, $0, 25
	add $t4, $t3, $0
	beq $t3, $t4, finish
	
theSecondLayer:
	slt $t5, $t1, $t2
	slti $t6, $t1, 6
	jal whereAmI
	j theFirstLayer
	addi $1, $0, 2059 #never called, just for funsies
	
whereAmI:
	addi $t1, $0, 1
	jr $ra
	
finish:
li $v0, 10 
syscall  #still dont understand why it cant just read my mind
