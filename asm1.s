.data
SORT_RESULTS:				.asciiz	"Sort Results: "
LESS:								.asciiz "LESS"
SAME:								.asciiz "SAME"
MORE:								.asciiz "MORE"
CUR_VALUES:					.asciiz "Cur Values: "

.text
.globl studentMain
studentMain:
	addiu					$sp, $sp,		-24
	sw						$fp, 0($sp)
	sw						$ra, 4($sp)
	addiu					$fp, $sp,		20

	la						$s0, sort																						# s0 = &sort
	lw						$s0, 0($s0)																					# s0 = sort
	la						$s1, compare																				# s1 = &compare
	lw						$s1, 0($s1)																					# s1 = compare
	la						$s2, swap																						# s2 = &swap
	lw						$s2, 0($s2)																					# s2 = swap
	la						$s3, print																					# s3 = &print
	lw						$s3, 0($s3)																					# s3 = print

	la						$s4, alpha																					# s4 = &alpha
	lw						$s4, 0($s4)																					# s4 = alpha
	la						$s5, bravo																					# s5 = &bravo
	lw						$s5, 0($s5)																					# s5 = bravo
	la						$s6, charlie																				# s6 = &charlie
	lw						$s6, 0($s6)																					# s6 = charlie
	
	CHECK_SORT:
		bne					$s0, $zero, SORT																		# if sort variable != 0 (contains a 1) then we need to branch to execute the sorting algorithm
	CHECK_COMPARE:
		bne					$s1, $zero, COMPARE_BRAVO_CHARLIE										# if compare variable != 0 (contains a 1) then we need to branch to execute the compare instructions
	CHECK_SWAP:
		bne					$s2, $zero, SWAP																		# if swap variable != 0 (contains a 1) then we need to branch to execute the swap instructions
	CHECK_PRINT:
		bne					$s3, $zero, PRINT																		# if print variable != 0 (contains a 1) then we need to branch to execute the print instructions
	j							DONE																								# If print has not been called then jump to the end of program, (print has a j DONE at the end of it)

	SORT:
		WHILE:
			slt				$t0, $s5,		$s4																			# t0 = bravo < alpha
			bne				$t0, $zero,	ALPHA_GREATER_THAN_BRAVO								# if (alpha < bravo) swap
			slt				$t0, $s6,		$s5																			# t0 = charlie < bravo
			bne				$t0, $zero, BRAVO_GREATER_THAN_CHARLIE							# if (bravo > charlie) swap
			j					ELSE																								# if no swaping needed exit loop
		
			ALPHA_GREATER_THAN_BRAVO:
				add			$t3, $zero, $s4																			# int temp = alpha
				add			$s4, $zero, $s5																			# alpha = bravo
				add			$s5, $zero, $t3																			# bravo = alpha
				j				WHILE

			BRAVO_GREATER_THAN_CHARLIE:
				add			$t3, $zero, $s5																			# int temp = bravo
				add			$s5, $zero, $s6																			# bravo = charlier
				add			$s6, $zero, $t3																			# charlie = bravo
				j				WHILE
		
			ELSE:
				j				EXIT_LOOP																						# exit loop


		EXIT_LOOP:
			addi			$v0, $zero, 4																				# Set the syscall to print a string
			la				$a0, SORT_RESULTS																		# Pass the "Sort Results:" text into a0, the argument for our syscall
			syscall
		
			addi			$v0, $zero, 1																				# Set the syscall to print a number
			add				$a0, $zero, $s4																			# Pass alpha's value into the argument for our syscall
			syscall

			addi			$v0, $zero, 11																			# Set the syscall to print a character
			addi			$a0, $zero, 32																			# Pass a space character into the argument for our syscall, a0, which is what will be printed
			syscall

			addi			$v0, $zero, 1																				# Set the syscall to print a number
			add				$a0, $zero, $s5																			# Pass bravo's value into the argument for our syscall
			syscall

			addi			$v0, $zero, 11																			# Set the syscall to print a character
			addi			$a0, $zero, 32																			# Pass a space character into the argument for our syscall, a0, which is what will be printed
			syscall

			addi			$v0, $zero, 1																				# Set the syscall to print a number
			add				$a0, $zero, $s6																			# Pass charlie's value into the argument for our syscall
			syscall
			
			addi			$v0, $zero, 11																			# Set the syscall to print a character
			addi			$a0, $zero, 10																			# Pass a new line character into the argument for our syscall, a0, which is what will be printed
			syscall

			j					CHECK_COMPARE																				# Jump to the next execution task that might be executed

	COMPARE_BRAVO_CHARLIE:
	
		la					$s5, bravo																					# s5 = &bravo
		lw					$s5, 0($s5)																					# s5 = bravo
		la					$s6, charlie																				# s6 = &charlie
		lw					$s6, 0($s6)																					# s6 = charlie
		slt					$t0, $s5,		$s6																			# t0 = bravo < charlie
		bne					$t0, $zero, COMPARE_BRAVO_LESS_THAN_CHARLIE					# if (bravo < charlie) skip ahead
		slt					$t0, $s6,		$s5																			# t0 = charlie > bravo
		bne					$t0, $zero, COMPARE_BRAVO_GREATER_THAN_CHARLIE			# if (bravo > charlie) skip ahead
	
		addi				$v0, $zero, 4																				# tell syscall to print text
		la					$a0, SAME																						# pass it the string "SAME"
		syscall
		j						NEWLINE

		COMPARE_BRAVO_LESS_THAN_CHARLIE:
			addi		$v0, $zero,		4																				# tell syscall to print text
			la			$a0, LESS																							# pass it the string "LESS"
			syscall
			j				NEWLINE																								# prints new line before exiting compare

		COMPARE_BRAVO_GREATER_THAN_CHARLIE:
			addi		$v0, $zero,		4																				# tell syscall to print text
			la			$a0, MORE																							# pass it the string "MORE"
			syscall
			j				NEWLINE																								# prints new line before exiting compare

		NEWLINE:
			addi		$v0, $zero,		11																			# tell syscall to print a character
			addi		$a0, $zero,		10																			# pass it a new line character
			syscall
	
		j					CHECK_SWAP																						# Jump to next execution task that might be executed

	SWAP:
		la				$s4, alpha																						# s4 = &alpha
		lw				$s4, 0($s4)																						# s4 = alpha
		la				$s5, bravo																						# s5 = &bravo
		lw				$s5, 0($s5)																						# s5 = bravo
		la				$s6, charlie																					# s6 = &charlie
		lw				$s6, 0($s6)																						# s6 = charlie
		la				$s7, delta																						# s7 = &delta
		lw				$s7, 0($s7)																						# s7 = delta
		
		add				$t0, $zero,		$s4																			# int temp = alpha
		add				$s4, $zero,		$s5																			# alpha = bravo 
		add				$s5, $zero,		$t0																			# bravo = alpha

		add				$t1, $zero,		$s6																			# int temp = charlie 
		add				$s6, $zero,		$s7																			# charlie = delta
		add				$s7, $zero,		$t1																			# delta = charlie

		la				$t0, alpha																						# t0 = &alpha
		la				$t1, bravo																						# t1 = &bravo
		la				$t2, charlie																					# t2 = &charlie
		la				$t3, delta																						# t3 = &delta

		sw				$s4, 0($t0)																						# store the value of alpha back into alpha's space in memory
		sw				$s5, 0($t1)																						# store the value of bravo back into bravo's space in memory
		sw				$s6, 0($t2)																						# store the value of charlie back into charlie's space in memory
		sw				$s7, 0($t3)																						# store the value of delta back into delta's space in memory

		j					CHECK_PRINT																						# Jump to next execution task that might be executed


	PRINT:
		la				$t4, alpha																						# t4 = &alpha
		lw				$t4, 0($t4)																						# t4 = alpha

		la				$t5, bravo																						# t5 = &bravo
		lw				$t5, 0($t5)																						# t5 = bravo

		la				$t6, charlie																					# t6 = &charlie
		lw				$t6, 0($t6)																						# t6 = charlie
		
		la				$t7, delta																						# t7 = &delta
		lw				$t7, 0($t7)																						# t7 = delta

		addi			$v0, $zero,		4																				# Tell the syscall to print a string
		la				$a0, CUR_VALUES																				# Pass in the asciiz variable CUR_VALUES to be printed: "Cur Values: "
		syscall

		addi			$v0, $zero,		1																				# Tell the syscall to print a number
		add				$a0, $zero,		$t4																			# Pass in the value of alpha to be printed
		syscall

		addi			$v0, $zero,		11																			# Tell the syscall to print a character
		addi			$a0, $zero,		32																			# Pass in a space character to be printed
		syscall

		addi			$v0, $zero,		1																				# Tell the syscall to print a number
		add				$a0, $zero,		$t5																			# Pass in the value of bravo to be printed
		syscall

		addi			$v0, $zero,		11																			# Tell the syscall to print a character
		addi			$a0, $zero,		32																			# Pass in a space character to be printed
		syscall

		addi			$v0, $zero,		1																				# Tell the syscall to print a number
		add				$a0, $zero,		$t6																			# Pass in the value of charlie to be printed
		syscall

		addi			$v0, $zero,		11																			# Tell the syscall to print a character
		addi			$a0, $zero,		32																			# Pass in a space character to be printed
		syscall

		addi			$v0, $zero,		1																				# Tell the syscall to print a number
		add				$a0, $zero,		$t7																			# Pass in the value of delta to be printed
		syscall

		addi			$v0, $zero,		11																			# Tell the syscall to print a character
		addi			$a0, $zero,		10																			# Pass in a new line character to be printed
		syscall

		


		j					DONE																									# Jump to the end of our programs instructions





DONE:
	lw					$ra, 4($sp)
	lw					$fp, 0($sp)
	addiu				$sp, $sp,			24
	jr					$ra

