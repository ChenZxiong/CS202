.data 0x0000
.text 0x0000
main:
	addi $t9,$zero,1
	addi $t1,$zero,1
	addi $a0,$0,32254
	addi $a1,$0,150
	beq $26,$0,main
	add $a2,$0,$0
	add $a3,$0,$0
	jal delay
    beq $27,$zero,case0
    beq $27,$t1,dead_loop
    addi $t1,$t1,1
    beq $27,$t1,case2
    addi $t1,$t1,1
    beq $27,$t1,dead_loop
    addi $t1,$t1,1
    beq $27,$t1,case4
    addi $t1,$t1,1
    beq $27,$t1,case5
    addi $t1,$t1,1
    beq $27,$t1,case6
    addi $t1,$t1,1
    beq $27,$t1,case7
	##000,�������,t1�洢��t2���ַ
    #################################################################
case0:
	lw $v0,-928($zero)
	beq $26,$t9,case0
	add $a2,$0,$0
	add $a3,$0,$0
	jal delay
	add $t1,$v0,$zero #ȡ����,�����С
    sw $t1,164($zero) #164�������С
	add $t0,$zero,$zero #t0������
	nor $t9,$t9,$zero
	andi $t9,$t9,1 
loop_000:
	##����
	lw $v0,-928($zero)
	beq $26,$t9,loop_000	
	add $a2,$0,$0
	add $a3,$0,$0
	jal delay
	sw $v0,0($t2) #t2��0x0000�������ݵĵ�ַ
    sw $v0,40($t2)
	addi $t0,$t0,1
	addi $t2,$t2,4
	nor $t9,$t9,$zero
	andi $t9,$t9,1
	bne $t0,$t1,loop_000 #t0ѭ������,t1����ĸ���
	addi $t0,$zero,0
	addi $s0,$t1,0          # �������С���浽s0
	addi $t1,$zero,0

    ####################################################################
 ## 001
	addi $t2,$0,40 	#��գ�t2��0x0028,���ݼ�1����ʼλ��
	
  #����������  a0��ַ��a1�����С
  addi $a0, $t2,0
  addi $a1, $s0,0
  j sort_001
       # ��s0�Ĵ������㣬��Ϊ���������ļ�����
    #������
sort_001:
  add $s2, $a0,$0
  addi $s3, $a1,0
  addi $s0, $zero,0

  forOut_001:
    slt $t0, $s0, $s3      # ���i<n����t0=1
    beq $t0, $zero,dead_loop  # ���t0=0���˳����ѭ��
    addi $s1, $s0, -1       # j = i - 1

  forIn_001:
    slti $t0, $s1, 0        # ���s1<0����t0=1
    bne $t0, $zero, exit2_001   # ���t0!=0����ת��exit2
    sll $t1, $s1, 2         # $tl = j*4
    add $t2, $s2, $t1		# $t2����arr[j]�ĵ�ַ
    lw $t3, 0($t2)            # ȡ��arr[j]�����ݵ�$t3
    lw $t4, 4($t2)            # ȡ��arr[j+1]�����ݵ�$t4
    slt $t0, $t4, $t3      # ���arr[j]<arr[j+1], ��t0=1
    beq $t0, $zero, exit2_001   # ������������������ת��exit2�˳��ڲ�ѭ��
    addi $a0, $s2,0           # �������ַ�����������swap����
    addi $a1, $s1,0           # ��һ������jҲ����ȥ
    j swap_001
    continue_001_1:
    addi $s1, $s1, -1       # j--
    j forIn_001

  exit2_001:
    addi $s0, $s0, 1        # i++
    j forOut_001                # �������ѭ��

  swap_001:
    sll $t0, $a1, 2     # j������λ�ŵ�t0��

    add $t0, $a0, $t0  # ��ֵַ����ƫ����arr[j]�ĵ�ַ
    lw $t1, 0($t0)        # ��arr[j]��ֵ����t1��
    lw $t2, 4($t0)        # ��arr[j+1]��ֵ����t2��
    sw $t1, 4($t0)        # arr[j]=arr[j+1]
    sw $t2, 0($t0)        # arr[j+1]=arr[j]
  
    j continue_001_1       # ���ص���ǰ�ĵ�ַ��

## 000 001 end
    #####################################################
    ## 010
case2: #ת���з����� 
	addi $t2,$0,0 #��գ�t2��0x0000
    lw $s0,164($zero)
	loop_010:
	##����,ֱ�Ӵ��ڴ�ȡ��
	lw $t3,0($t2) #t3�ó����ݼ�0�е�����
	andi $t4,$t3,255 #����8bit��t4����t3��ֵ  
	srl $t4,$t4,7 #t4����������λ
	bne $t4,$zero,negative #�������λ������0����Ϊ����������Ϊ����������Ϊԭ�룬ֱ�Ӵ洢
	sw $t3,80($t2) # 0x0000 + 80�����ݼ�2�洢��λ��
	sw $t3,120($t2)
	continue_010_1:
	addi $t0,$t0,1
	addi $t2,$t2,4
	bne $t0,$s0,loop_010
	addi $t0,$zero,0
    ## 011 case4 �з���������
	#��ռĴ���
	addi $t0,$zero,0
	addi $t2,$0,120 	#��գ�
	
  #����������  a0��ַ��a1�����С
  addi $a0, $t2,0
  addi $a1, $s0,0
  j sort
       # ��s0�Ĵ������㣬��Ϊ���������ļ�����
#������
sort:
    add $s2, $a0,$0
    addi $s3, $a1,0
    addi $s0, $zero,0

  forOut:
    slt $t0, $s0, $s3      # ���i<n����t0=1
    beq $t0, $zero,dead_loop   # ���t0=0����ת��exit1�˳����ѭ��
    addi $s1, $s0, -1       # j = i - 1

  forIn:
    slti $t0, $s1, 0        # ���s1<0����t0=1
    bne $t0, $zero, exit2   # ���t0!=0����ת��exit2
    sll $t1, $s1, 2         # $tl = j*4
    add $t2, $s2, $t1		# $t2����arr[j]�ĵ�ַ
    lw $t3, 0($t2)            # ȡ��arr[j]�����ݵ�$t3
    lw $t4, 4($t2)            # ȡ��arr[j+1]�����ݵ�$t4
    slt $t0, $t4, $t3      # ���arr[j]<arr[j+1], ��t0=1
    beq $t0, $zero, exit2   # ������������������ת��exit2�˳��ڲ�ѭ��
    addi $a0, $s2,0           # �������ַ�����������swap����
    addi $a1, $s1,0           # ��һ������jҲ����ȥ
    j swap
     continue_011_1:
    addi $s1, $s1, -1       # j--
    j forIn

  exit2:
    addi $s0, $s0, 1        # i++
    j forOut                # �������ѭ��

  swap:
    sll $t0, $a1, 2     # j������λ�ŵ�t0��
    add $t0, $a0, $t0  # ��ֵַ����ƫ����arr[j]�ĵ�ַ
    lw $t1, 0($t0)        # ��arr[j]��ֵ����t1��
    lw $t2, 4($t0)        # ��arr[j+1]��ֵ����t2��
    sw $t1, 4($t0)        # arr[j]=arr[j+1]
    sw $t2, 0($t0)        # arr[j+1]=arr[j]
    j continue_011_1             # ���ص���ǰ�ĵ�ַ��

negative:
	andi $t4,$t3,127 #�ó���7bit�����ݣ���ȥ����λ��
	nor $t5,$t4,$zero #��0 nor ȫ��ȡ��
	addi $t6,$t5,1
	sw $t6,80($t2)
	sw $t6,120($t2)
	j continue_010_1
## 010 011 end
####################################################################
## 100 strat
case4:
    lw $s0,164($zero)
	# t1�������С�����ҵ�����ֵ
	add $t1,$zero,$s0
	addi $s0,$zero,1 # ��s0�Ĵ�����1����Ϊ���������ļ�����
	addi $t2,$0,40 # ���ݼ�1����ʼ
	lw $t3,0($t2)
	loop_100:
	addi $t2,$t2,4
	addi $s0,$s0,1
	bne $s0,$t1,loop_100
	lw $t4,0($t2)
	sub $t5,$t4,$t3
	#���
output_100:	sw $t5,-912($zero)
		j output_100
###################################################################
## 101 strat
case5:
    lw $s0,164($zero)
	# t1�������С�����ҵ�����ֵ
	add $t1,$zero,$s0
	addi $s0,$zero,1 # ��s0�Ĵ�����1����Ϊ���������ļ�����
	addi $t2,$zero,120 # ���ݼ�3����ʼ
	lw $t3,0($t2)
	loop_101:
	addi $t2,$t2,4
	addi $s0,$s0,1
	bne $s0,$t1,loop_101
	lw $t4,0($t2)
	sub $t5,$t4,$t3
	
	#���
output_101:	sw $t5,-912($zero)
		j output_101
#################################################################3
#110
case6:addi $t9,$zero,1
	beq $26,$0,case6 
	  	  
input_110_1: lw $v0,-928($zero)
	  beq $26,$t9,input_110_1               
	  add $a2,$0,$0
	  add $a3,$0,$0
	  jal delay
	  add $t2,$v0,$zero		   
	  
input_110_2: lw $v0,-928($zero)
	  beq $26,$zero,input_110_2  				  	
	  add $a2,$0,$0
	  add $a3,$0,$0
	  jal delay
	  add $t3,$v0,$zero	
	  beq $t3,$0,choice
	  
count_110:addi $t0,$t0,4
	  addi $t3,$t3,-1
	  bne $t3,$zero,count_110          

choice:addi $t4,$zero,1
	  addi $t5,$zero,2
	  addi $t6,$zero,3
	  
	  beq $t2,$t4,DS1
	  beq $t2,$t5,DS2
	  beq $t2,$t6,DS3
	  
DS1:  lw $t0,40($t0)
	  andi $t3,$t0,255         
	  j end_110
DS2:  lw $t0,80($t0)
	  andi $t3,$t0,255
	  j end_110
DS3:  lw $t0,120($t0)
	  andi $t3,$t0,255
	  j end_110
end_110:
	  sw $t3,-912($zero)
	  j end_110

#110 end
#################################################################
#111
case7:
	 addi $t2,$t0,80
	  addi $t9,$zero,1
input_111_1:lw $v0,-928($zero)	  	
	  beq $26,$t9,input_111_1
	  
	  add $t3,$v0,$zero		 
	  add $t4,$zero,$t3       
	  
count_111: beq $t4,$0,next
	  addi $t0,$t0,4
	  addi $t2,$t2,4
	  addi $t4,$t4,-1
	  j count_111          
	 
next: lw $t0,0($t0)
         lw $t2,0($t2)	
	  
      andi $t4,$t0,255
	  add $t0,$zero,$t4        #t0??8bit?????0
	  
	  andi $t4,$t2,255
	  add $t2,$zero,$t4        #t2??8bit?????2
	  
	  add $t4,$zero,$t3        
	  sll $t5,$t4,8			   
	  add $t5,$t5,$t0   #????????0
	  
	  addi $t4,$zero,2
	  sll $t6,$t4,4
	  add $t6,$t6,$t3
	  sll $t6,$t6,8
	  add $t6,$t6,$t2     #????????2   
	  
	  addi $t3,$zero,32254  
	  
Type1:add $t4,$zero,$t3
F1:	  addi $t7,$zero,1000
	  addi $t4,$t4,-1
	  beq $t4,$zero,Type2
Out1: sw $t5,-912($zero)
	  beq $t7,$zero,F1
	  addi $t7,$t7,-1
	  j Out1
	  
Type2:add $t4,$zero,$t3
F2:	  addi $t7,$zero,1000
	  addi $t4,$t4,-1
	  beq $t4,$zero,Type1
Out2: sw $t6,-912($zero)
	  beq $t7,$zero,F2
	  addi $t7,$t7,-1
	  j Out2

#111 end
###################################################################
delay: 
	addi $a2,$a2,1
	bne $a2,$a0,delay
	addi $a3,$a3,1
	add $a2,$0,$0
	bne $a3,$a1,delay
	jr $31

dead_loop:
    add $zero,$zero,$zero
    # addi $t8,$zero,7
    #     sw $t8,-912($zero)
    # lw $t8,0($zero)
    # sw $t8,-912($zero)
    # lw $t8,4($zero)
    # sw $t8,-912($zero)
    # lw $t8,8($zero)
    # sw $t8,-912($zero)
    # lw $t8,12($zero)
    # sw $t8,-912($zero)
    #     sw $zero,-912($zero)
    # lw $t8,40($zero)
    # sw $t8,-912($zero)
    # lw $t8,44($zero)
    # sw $t8,-912($zero)
    # lw $t8,48($zero)
    # sw $t8,-912($zero)
    # lw $t8,52($zero)
    # sw $t8,-912($zero)
    #     sw $zero,-912($zero)
    # lw $t8,80($zero)
    # sw $t8,-912($zero)
    # lw $t8,84($zero)
    # sw $t8,-912($zero)
    # lw $t8,88($zero)
    # sw $t8,-912($zero)
    # lw $t8,92($zero)
    # sw $t8,-912($zero)
    #     sw $zero,-912($zero)
    # lw $t8,120($zero)
    # sw $t8,-912($zero)
    # lw $t8,124($zero)
    # sw $t8,-912($zero)
    # lw $t8,128($zero)
    # sw $t8,-912($zero)
    # lw $t8,132($zero)
    # sw $t8,-912($zero)
    #     sw $zero,-912($zero)
    j dead_loop