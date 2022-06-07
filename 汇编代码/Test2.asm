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
	##000,输入个数,t1存储，t2存地址
    #################################################################
case0:
	lw $v0,-928($zero)
	beq $26,$t9,case0
	add $a2,$0,$0
	add $a3,$0,$0
	jal delay
	add $t1,$v0,$zero #取出数,数组大小
    sw $t1,164($zero) #164存数组大小
	add $t0,$zero,$zero #t0计数器
	nor $t9,$t9,$zero
	andi $t9,$t9,1 
loop_000:
	##输入
	lw $v0,-928($zero)
	beq $26,$t9,loop_000	
	add $a2,$0,$0
	add $a3,$0,$0
	jal delay
	sw $v0,0($t2) #t2存0x0000，存数据的地址
    sw $v0,40($t2)
	addi $t0,$t0,1
	addi $t2,$t2,4
	nor $t9,$t9,$zero
	andi $t9,$t9,1
	bne $t0,$t1,loop_000 #t0循环次数,t1输入的个数
	addi $t0,$zero,0
	addi $s0,$t1,0          # 把数组大小保存到s0
	addi $t1,$zero,0

    ####################################################################
 ## 001
	addi $t2,$0,40 	#清空，t2存0x0028,数据集1的起始位置
	
  #调用排序函数  a0地址，a1数组大小
  addi $a0, $t2,0
  addi $a1, $s0,0
  j sort_001
       # 把s0寄存器置零，作为读数个数的计数器
    #排序函数
sort_001:
  add $s2, $a0,$0
  addi $s3, $a1,0
  addi $s0, $zero,0

  forOut_001:
    slt $t0, $s0, $s3      # 如果i<n，则t0=1
    beq $t0, $zero,dead_loop  # 如果t0=0，退出外层循环
    addi $s1, $s0, -1       # j = i - 1

  forIn_001:
    slti $t0, $s1, 0        # 如果s1<0，则t0=1
    bne $t0, $zero, exit2_001   # 如果t0!=0，跳转到exit2
    sll $t1, $s1, 2         # $tl = j*4
    add $t2, $s2, $t1		# $t2存了arr[j]的地址
    lw $t3, 0($t2)            # 取出arr[j]的数据到$t3
    lw $t4, 4($t2)            # 取出arr[j+1]的数据到$t4
    slt $t0, $t4, $t3      # 如果arr[j]<arr[j+1], 则t0=1
    beq $t0, $zero, exit2_001   # 不满足上面条件，跳转到exit2退出内层循环
    addi $a0, $s2,0           # 把数组地址这个参数传给swap函数
    addi $a1, $s1,0           # 另一个参数j也传过去
    j swap_001
    continue_001_1:
    addi $s1, $s1, -1       # j--
    j forIn_001

  exit2_001:
    addi $s0, $s0, 1        # i++
    j forOut_001                # 跳至外层循环

  swap_001:
    sll $t0, $a1, 2     # j左移两位放到t0中

    add $t0, $a0, $t0  # 基址值加上偏移量arr[j]的地址
    lw $t1, 0($t0)        # 把arr[j]的值放入t1中
    lw $t2, 4($t0)        # 把arr[j+1]的值放入t2中
    sw $t1, 4($t0)        # arr[j]=arr[j+1]
    sw $t2, 0($t0)        # arr[j+1]=arr[j]
  
    j continue_001_1       # 返回调用前的地址处

## 000 001 end
    #####################################################
    ## 010
case2: #转成有符号数 
	addi $t2,$0,0 #清空，t2存0x0000
    lw $s0,164($zero)
	loop_010:
	##输入,直接从内存取出
	lw $t3,0($t2) #t3拿出数据集0中的数据
	andi $t4,$t3,255 #数据8bit，t4复制t3的值  
	srl $t4,$t4,7 #t4仅保留符号位
	bne $t4,$zero,negative #如果符号位不等于0，则为负数；否则为正数，补码为原码，直接存储
	sw $t3,80($t2) # 0x0000 + 80，数据集2存储的位置
	sw $t3,120($t2)
	continue_010_1:
	addi $t0,$t0,1
	addi $t2,$t2,4
	bne $t0,$s0,loop_010
	addi $t0,$zero,0
    ## 011 case4 有符号数排序
	#清空寄存器
	addi $t0,$zero,0
	addi $t2,$0,120 	#清空，
	
  #调用排序函数  a0地址，a1数组大小
  addi $a0, $t2,0
  addi $a1, $s0,0
  j sort
       # 把s0寄存器置零，作为读数个数的计数器
#排序函数
sort:
    add $s2, $a0,$0
    addi $s3, $a1,0
    addi $s0, $zero,0

  forOut:
    slt $t0, $s0, $s3      # 如果i<n，则t0=1
    beq $t0, $zero,dead_loop   # 如果t0=0，跳转到exit1退出外层循环
    addi $s1, $s0, -1       # j = i - 1

  forIn:
    slti $t0, $s1, 0        # 如果s1<0，则t0=1
    bne $t0, $zero, exit2   # 如果t0!=0，跳转到exit2
    sll $t1, $s1, 2         # $tl = j*4
    add $t2, $s2, $t1		# $t2存了arr[j]的地址
    lw $t3, 0($t2)            # 取出arr[j]的数据到$t3
    lw $t4, 4($t2)            # 取出arr[j+1]的数据到$t4
    slt $t0, $t4, $t3      # 如果arr[j]<arr[j+1], 则t0=1
    beq $t0, $zero, exit2   # 不满足上面条件，跳转到exit2退出内层循环
    addi $a0, $s2,0           # 把数组地址这个参数传给swap函数
    addi $a1, $s1,0           # 另一个参数j也传过去
    j swap
     continue_011_1:
    addi $s1, $s1, -1       # j--
    j forIn

  exit2:
    addi $s0, $s0, 1        # i++
    j forOut                # 跳至外层循环

  swap:
    sll $t0, $a1, 2     # j左移两位放到t0中
    add $t0, $a0, $t0  # 基址值加上偏移量arr[j]的地址
    lw $t1, 0($t0)        # 把arr[j]的值放入t1中
    lw $t2, 4($t0)        # 把arr[j+1]的值放入t2中
    sw $t1, 4($t0)        # arr[j]=arr[j+1]
    sw $t2, 0($t0)        # arr[j+1]=arr[j]
    j continue_011_1             # 返回调用前的地址处

negative:
	andi $t4,$t3,127 #拿出低7bit的数据（除去符号位）
	nor $t5,$t4,$zero #与0 nor 全部取反
	addi $t6,$t5,1
	sw $t6,80($t2)
	sw $t6,120($t2)
	j continue_010_1
## 010 011 end
####################################################################
## 100 strat
case4:
    lw $s0,164($zero)
	# t1存数组大小，来找到最大的值
	add $t1,$zero,$s0
	addi $s0,$zero,1 # 把s0寄存器置1，作为读数个数的计数器
	addi $t2,$0,40 # 数据集1的起始
	lw $t3,0($t2)
	loop_100:
	addi $t2,$t2,4
	addi $s0,$s0,1
	bne $s0,$t1,loop_100
	lw $t4,0($t2)
	sub $t5,$t4,$t3
	#输出
output_100:	sw $t5,-912($zero)
		j output_100
###################################################################
## 101 strat
case5:
    lw $s0,164($zero)
	# t1存数组大小，来找到最大的值
	add $t1,$zero,$s0
	addi $s0,$zero,1 # 把s0寄存器置1，作为读数个数的计数器
	addi $t2,$zero,120 # 数据集3的起始
	lw $t3,0($t2)
	loop_101:
	addi $t2,$t2,4
	addi $s0,$s0,1
	bne $s0,$t1,loop_101
	lw $t4,0($t2)
	sub $t5,$t4,$t3
	
	#输出
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