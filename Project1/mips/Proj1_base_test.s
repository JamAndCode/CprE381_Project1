
# ALL COMMANDS GOGOGO

# data section
.data
tmp:.word   0 : 19
	  
.text
main:
la   $11, tmp        # load address of array
 
adds:
addi  $1,  $0,  1
addi $3, $0, 3
addiu  $2,  $0,  -2
add  $3, $1, $3
addu $2, $1, $2

#logicals
and  $4, $1, $2
andi $5, $3, 1
nor  $6, $3, $2
xor  $7, $1, $2
xori $8, $1, 2
or   $9, $1, $3
ori  $10, $3, 4

#load, store, and load
#can you tell I wrote these last?
lui  $19, 5
sw   $20, 8($11)
lw   $21, 8($11)

#set on less than
slt  $11, $4, $5
slti $12, $6, 1

#shifts
sll $13, $3, 3 
srl $14, $4, 2
sra $15, $5, 1

#subtracts
sub $16, $15, $14
subu $17, $14, $15

noJumpyHere:
addi $t5, $0, 0
addi $t6, $0, 1
addi $t7, $t6, 0

beq $t5, $t6, noJumpyHere
bne $t6, $t7 yesJumpyHere

yesJumpyHere:
bne $t6, $t7, noJumpyHere
beq $t5, $0, jumpTimePart2
addi $t8 $0, 100

jumpTimePart2:
jal jumpjumpjump
j exit

jumpjumpjump:
jr $ra

exit:
li $v0, 10 
syscall  #woooooooooo
