.data

so_not:     .word 15
cao_do:     .word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 64, 62, 62
do_dai:     .word 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1, 4

msg_space:  .asciiz " "
msg_nl:     .asciiz "\n"
msg_dukien: .asciiz "Tong du kien (ms): "
msg_doduoc: .asciiz "Thoi gian do duoc (ms): "

    .text
    .globl main
main:
    # 1. Do thoi gian bat dau (syscall 30)
    li $v0, 30
    syscall
    move $s7, $a0           # $s7 = Thoi gian bat dau (32-bit thap)

    # 2. Khoi tao cac thanh ghi va con tro
    la $s0, cao_do          # $s0 = Con tro mang cao do
    la $s1, do_dai          # $s1 = Con tro mang do dai
    lw $s2, so_not          # $s2 = Bien dem vong lap (15)
    li $s3, 0               # $s3 = Tong thoi gian du kien (khoi tao = 0)
    
    # Cac tham so ca nhan cua Sinh vien
    li $t8, 1               # a = 1 (So nua cung dich giong)
    li $t9, 210             # b = 6 -> 1 nhip = 150 + 10*6 = 210 ms

Loop:
    blez $s2, End_Loop      # Neu so_not <= 0 thi thoat vong lap

    # Doc du lieu not hien tai
    lw $t0, 0($s0)          # $t0 = Cao do goc
    lw $t1, 0($s1)          # $t1 = Do dai goc (don vi nhip)

    # Tinh toan thuc te
    add $t0, $t0, $t8       # Cao do thuc = Cao do goc + 1
    mul $t1, $t1, $t9       # Do dai thuc (ms) = Do dai goc * 210
    
    # Cong don vao Tong thoi gian du kien
    add $s3, $s3, $t1       

    move $a0, $t0
    li $v0, 1
    syscall

    la $a0, msg_space
    li $v0, 4
    syscall

    move $a0, $t1
    li $v0, 1
    syscall

    la $a0, msg_nl
    li $v0, 4
    syscall

    # Phat tieng MIDI (syscall 33)
    move $a0, $t0           # Cao do
    move $a1, $t1           # Do dai (ms)
    li $a2, 40              # Nhac cu (Theo bang la 40)
    li $a3, 100             # Am luong (Theo de la 100)
    li $v0, 31             
    syscall
    
    move $a0, $t1
    li $v0, 32
    syscall

    # Tang con tro va giam bien dem
    addi $s0, $s0, 4        # Nhay den cao do tiep theo
    addi $s1, $s1, 4        # Nhay den do dai tiep theo
    subi $s2, $s2, 1        # Giam so luong not con lai
    j Loop

End_Loop:
    # 3. Do thoi gian ket thuc (syscall 30)
    li $v0, 30
    syscall
    sub $s7, $a0, $s7       # $s7 = Thoi gian ket thuc - Thoi gian bat dau = Thoi gian do duoc

    # In ra: "Tong du kien (ms): "
    la $a0, msg_dukien
    li $v0, 4
    syscall
    
    # In ra so $s3 (Tong du kien)
    move $a0, $s3
    li $v0, 1
    syscall
    
    la $a0, msg_nl
    li $v0, 4
    syscall

    # In ra: "Thoi gian do duoc (ms): "
    la $a0, msg_doduoc
    li $v0, 4
    syscall
    
    # In ra so $s7 (Thoi gian do duoc)
    move $a0, $s7
    li $v0, 1
    syscall

    li $v0, 10
    syscall
