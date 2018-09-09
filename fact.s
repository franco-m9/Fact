# Franco Marcoccia - 05/31/18
# fact.s - sample code with the addition of driver to
#	test factorial
# Register use:
#	$a0 parameter for fact, L1 and syscall
#	$v0 syscall parameter
#	$t0-$t1 temportary storage/calculations
#	$s6-$s7 the variable n and the factorial value
fact:	slti	$t0, $a0, 1		# test for n < 1
	beq	$t0, $zero, L1	# if n >= 1, go to L1

	li	$v0, 1		# return 1
	jr	$ra		# return to instruction after jal

L1:	addi	$sp, $sp, -8	# adjust stack for 2 items
	sw	$ra, 4($sp)	# save the return address
	sw	$a0, 0($sp)	# save the argument n

	addi	$a0, $a0, -1	# n >= 1; argument gets (n – 1)
	jal	fact		# call fact with (n – 1)

	lw	$a0, 0($sp)	# return from jal: restore argument n
	lw	$ra, 4($sp)	# restore the return address
	addi	$sp, $sp, 8	# adjust stack pointer to pop 2 items

	mul	$v0, $a0, $v0	# return n * fact (n – 1)

	jr	$ra		# return to the caller

main:
	la	$a0, msg1	# print msg1 with no request
	li	$v0, 4		
	syscall
	
	loop:			# loop to run untill negative number input
	la	$a0, nreq	# request value of n
	li	$v0, 4	
	syscall
	
	li	$v0, 5		# read in the value entered for n
	syscall

	slt	$t1, $v0, $zero	# stores a 1 if value read < 0
	bne	$t1, $zero, Exit	# branches out to Exit:
	addu	$s6, $zero, $v0	# saves the value of n for future display	
	addu	$a0, $zero, $v0	# also saves the value of n in another reg

	jal	fact		# jumps to fact function
	addu	$s7, $zero, $v0	# saves the value of funct 
	addu	$a0, $zero, $s6	# displays value from funct

	li	$v0, 1		
	syscall

	la	$a0, res	# displays message between numbers stored
	li	$v0, 4
	syscall

	addu	$a0, $zero, $s7	# stores value from funct to $a0

	li	$v0, 1
	syscall

	la	$a0, endl	# endline display
	li	$v0, 4
	syscall

	j	loop		# jumps to loop due to not being negative

	Exit:	la $a0, msg2	# displays the goodbye message
	li	$v0, 4
	syscall

	li	$v0, 10		# exit program
	syscall
	
	.data
msg1:	.asciiz	"Welcome to the factorial tester!\n"
nreq:	.asciiz "Enter a value for n (or negative value to exit): "
res:	.asciiz "! is "
endl:	.asciiz "\n"
msg2:	.asciiz "Come back soon!\n"