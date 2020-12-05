.data
n_prime:    .asciiz"not prime"
prime:      .asciiz"Prime"
emirp:      .asciiz"emirp"


.text
main:
li $v0, 5                       #read an integer
syscall
move $t0, $v0                   #$t0 = input

test:                           #test wether the inputs are prime
                                #the number should be in $t0
li $t1, 1                       #set $s1 as divisor
move $t3, $t0                   #$t3 = $t1-1, used for branching
addi $t3, -1
loop:                           #loop for test
addi $t1, 1                     #$t1 is divisor
div $t0, $t1
mfhi $t2                        #move remainder into $t2
beq $t2, $zero, not_prime       #if remain equals to 0, j ‘not_prime’ label
blt $t1, $t3, loop
#run to here if $t0 is prime
#then test for emirp

reverse:
li $t2, 10                      #$t3 for divisor for $t0
div $t0, $t2
mflo $t3                        #ten-digits
mfhi $t4                        #digits
mul $t0, $t4, $t2               #$t0 = sum of the reversed number
add $t0, $t0, $t3

test2:                          #test wether the inputs are prime
#the number should be in $t0
li $t1, 1                       #set $s1 as divisor
move $t3, $t0                   #$t3 = $t1-1, used for branching
addi $t3, -1
loop2:                          #loop for test
addi $t1, 1
div $t0, $t1
mfhi $t2                        #move remainder into $t2
beq $t2, $zero, Prime           #if remain equals to 0, j ‘Prime’ label
blt $t1, $t3, loop2
#run to here if it’s emirp
j Emirp
Prime:
li $v0, 4
la $a0, prime
syscall                         #print ”Prime”
j exit

Emirp:
li $v0, 4
la $a0, emirp
syscall                         #print ”emirp”
j exit

not_prime:
li $v0, 4
la $a0, n_prime
syscall                         #print ”not prime”
j exit



exit:
li $v0, 10
syscall




