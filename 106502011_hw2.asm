.data
prompt_win:                 .asciiz "You win!"
prompt_lose:                .asciiz "You lose."
prompt_redundant_digits:    .asciiz "Warning: redundant digits\n"
prompt_user1_input:         .asciiz "User1 enter the number:\n"
prompt_start:               .asciiz "Start--------------------"
prompt_user2_guess:         .asciiz "User2 guess:\n"

.text
main:
User1_input:
#print user1_input
    li $v0, 4
    la $a0, prompt_user1_input
    syscall
#read user1's input
#user1's input is in $s1
    li $v0, 5
    syscall
    move $s1, $v0

#get user1 a in $t3, b in $t4, c in $t5, d in $t6
    li $t2, 1000
    div $s1, $t2
    mflo $t3
    mfhi $s1
    li $t2, 100
    div $s1, $t2
    mflo $t4
    mfhi $s1
    li $t2, 10
    div $s1, $t2
    mflo $t5
    mfhi $t6
#test redundancy
    beq $t3, $t4, Redundant1
    beq $t3, $t5, Redundant1
    beq $t3, $t6, Redundant1
    beq $t4, $t5, Redundant1
    beq $t4, $t6, Redundant1
    beq $t5, $t6, Redundant1

#print Start
    li $v0, 4
    la $a0, prompt_start

#build a counter for times that user2 guess, using $s0
    li $s0, 0

#an 8-times loop
Eighttimes_comparison:

#counter ++
    addi $s0, 1
#reset $t0, $t1 to 0
    move $t0, $zero
    move $t1, $zero

#print user2 input
    li $v0, 4
    la $a0, prompt_user2_guess
    syscall
#read user2's input
#user2's input is in $s2
    li $v0, 5
    syscall
    move $s2, $v0

#get user2 a($s3) + b($s4) + c($s5) + d($s6)
    li $t2, 1000
    div $s2, $t2
    mflo $s3
    mfhi $s2
    li $t2, 100
    div $s2, $t2
    mflo $s4
    mfhi $s2
    li $t2, 10
    div $s2, $t2
    mflo $s5
    mfhi $s6
#test redundancy
    beq $s3, $s4, Redundant2
    beq $s3, $s5, Redundant2
    beq $s3, $s6, Redundant2
    beq $s4, $s5, Redundant2
    beq $s4, $s6, Redundant2
    beq $s5, $s6, Redundant2

#a
    beq $s3, $t3, aIn_pos
    beq $s3, $t4, aNIn_pos
    beq $s3, $t5, aNIn_pos
    beq $s3, $t6, aNIn_pos
    j aOver
aIn_pos:
    addi $t0, 1
    j aOver
aNIn_pos:
    addi $t1, 1
    j aOver
aOver:
#b
    beq $s4, $t3, bNIn_pos
    beq $s4, $t4, bIn_pos
    beq $s4, $t5, bNIn_pos
    beq $s4, $t6, bNIn_pos
    j bOver
bIn_pos:
    addi $t0, 1
    j bOver
bNIn_pos:
    addi $t1, 1
    j bOver
bOver:
#c
    beq $s5, $t3, cNIn_pos
    beq $s5, $t4, cNIn_pos
    beq $s5, $t5, cIn_pos
    beq $s5, $t6, cNIn_pos
    j cOver
cIn_pos:
    addi $t0, 1
    j cOver
cNIn_pos:
    addi $t1, 1
    j cOver
cOver:
#d
    beq $s6, $t3, dNIn_pos
    beq $s6, $t4, dNIn_pos
    beq $s6, $t5, dNIn_pos
    beq $s6, $t6, dIn_pos
    j dOver
dIn_pos:
    addi $t0, 1
    j dOver
dNIn_pos:
    addi $t1, 1
    j dOver
dOver:

#print mAnB
#m(A) into $t0, n(B) into $t1
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 11
    li $a0, 'A'
    syscall
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 11
    li $a0, 'B'
    syscall
    j Print

#print nextline
Print:
    li $a0, 10
    li $v0, 11
    syscall
#test if 4A
    li $t2, 4
    beq $t0, $t2, Prompt_win
#terminate condition for Loop
    li $t2, 8
    beq $s0, $t2, Prompt_lose
Redundant2:
    li $v0, 4
    la $a0, prompt_redundant_digits
    syscall
#not ready to be terminated, keep looping
    bne $s0, $t2, Eighttimes_comparison

Redundant1:
    li $v0, 4
    la $a0, prompt_redundant_digits
    syscall
    j User1_input

Prompt_lose:
    li $v0, 4
    la $a0, prompt_lose
    syscall
    j Exit
Prompt_win:
    li $v0, 4
    la $a0, prompt_win
    syscall
    j Exit
Exit:
    li $v0, 10
    syscall
