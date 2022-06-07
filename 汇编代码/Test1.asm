.data
.text

main:	addi $t9,$zero,1
		addi $t1,$zero,1
		addi $a0,$0,32254
		addi $a1,$0,150
		beq $26,$0,main
		add $a2,$0,$0
		add $a3,$0,$0
		jal delay
		beq $27,$zero,case0
		beq $27,$t1,case1	
		addi $t1,$t1,1
		beq $27,$t1,case2
		addi $t1,$t1,1
		beq $27,$t1,case3
		addi $t1,$t1,1
		beq $27,$t1,case4
		addi $t1,$t1,1
		beq $27,$t1,case5
		addi $t1,$t1,1
		beq $27,$t1,case6
		addi $t1,$t1,1
		beq $27,$t1,case7

case0: 	lw $v0,-928($zero)
		beq $26,$t9,case0		
		add $t0,$zero,$v0
		add $t1,$zero,$t0
	binaryLoop:andi $t2,$t1,1 
		srl $t1,$t1,1
	    sll $t3,$t3,1
	    add $t3,$t3,$t2
	    bne $t1,$zero,binaryLoop
	binary:bne $t0,$t3,case2
	isPali:addi $t5,$zero,1
		sw $t5,-912($zero)
		j isPali
	notPali:addi $t5,$zero,0
	    sw $t5,-912($zero)
	    j notPali
		
case1: 	lw $v0,-928($0)
		beq $26,$t9,case1    
		add $a2,$0,$0
		add $a3,$0,$0
		jal delay
		add $t2,$v0,$zero
		sw $t2,0($0)
	print_a:sw $t2,-912($0) 
		beq $26,$0,print_a
		add $a2,$0,$0
		add $a3,$0,$0
		jal delay
		add $t2,$v0,$zero
		sw $t2,0($0)
	load_b:lw $v0,-928($0)
		beq $26,$0,load_b
		
		add $t3,$v0,$zero
		sw $t3,4($0)
	output_001:sw $t3,-912($0)
		j output_001

case2:  lw $t2,0($0)
		lw $t3,4($0)
		and $t4,$t2,$t3
		sw $t4,0($0)
output_010: sw $t4,-912($zero)
		j output_010

case3:  lw $t2,0($t0)
		lw $t3,4($0)
		or $t4,$t2,$t3
		sw $t4,0($0)
	output_011: sw $t4,-912($zero)
		j output_011

case4:  lw $t2,0($0)
		lw $t3,4($0)
		xor $t4,$t2,$t3
		sw $t4,0($0)
	output_100: sw $t4,-912($zero)
		j output_100

case5:  lw $t2,0($0)
		lw $t3,4($0)
		sllv $t4,$t2,$t3
		sw $t4,0($0)
	output_101: sw $t4,-912($zero)
		j output_101

case6:  lw $t2,0($0)
		lw $t3,4($0)
		srlv $t4,$t2,$t3
		sw $t4,0($0)
	output_110: sw $t4,-912($zero)
		j output_110

case7:  lw $t2,0($0)
		lw $t3,4($0)
		srav $t4,$t2,$t3
		sw $t4,0($0)
	output_111: sw $t4,-912($zero)
		j output_111

delay: 
	addi $a2,$a2,1
	bne $a2,$a0,delay
	addi $a3,$a3,1
	add $a2,$0,$0
	bne $a3,$a1,delay
	jr $31
		
		