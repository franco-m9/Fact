# Franco Marcoccia - 7/19/2018
# dpfact.s - revised code with the addition of driver to
#	test factorial using double precision
# Register use:
#	$a0 parameter for fact, L1 and syscall
#	$v0 syscall parameter
#	$t0-$t1 temportary storage/calculations
#	$s6-$s7 the variable n and the factorial value
#	$f0,$f12 for double storage 

dpfact:	li	$t0, 1		# initialize product to 1.0
	mtc1	$t0, $f0
	cvt.d.w	$f0, $f0

again:	slti	$t0, $a0, 2		# test for n < 2
	bne	$t0, $zero,done	# if n < 2, return

	mtc1	$a0, $f2		# move n to floating register
	cvt.d.w	$f2, $f2		# and convert to double precision

	mul.d	$f0, $f0, $f2	# multiply product by n
	
	addi	$a0, $a0, -1	# decrease n
	j	again		# and loop

done:	jr	$ra		# return to calling routine

main:
	la	$a0, msg1	# print msg1 with no request
	li	$v0, 4		
	syscall
	
loop:				# loop to run untill negative number input
	la	$a0, nreq	# request value of n
	li	$v0, 4	
	syscall
	
	li	$v0, 5		# read in the value entered for n
	syscall

	slt	$t1, $v0, $zero	# stores a 1 if value read < 0
	bne	$t1, $zero, Exit	# branches out to Exit:	
	addu	$a0, $zero, $v0	# also saves the value of n in another reg
	addu	$s6, $zero, $v0
	
	jal	dpfact		# jumps to fact function
	addu	$s7, $zero, $v0	# saves the value of funct 
	addu	$a0, $zero, $s6	# displays value from funct

	li	$v0, 1		
	syscall

	la	$a0, res	# displays message between numbers stored
	li	$v0, 4
	syscall

	mov.d	$f12, $f0	# stores value from funct to $a0

	li	$v0, 3
	syscall

	la	$a0, endl	# endline display
	li	$v0, 4
	syscall

	j	loop		# jumps to loop due to not being negative

Exit:	la $a0, msg2		# displays the goodbye message
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