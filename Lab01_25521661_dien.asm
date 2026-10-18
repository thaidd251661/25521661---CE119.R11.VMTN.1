# Ký hiệu $s*: 
# $s0 = Tổng tiền, $s1 = Điện năng còn lại (x), $s2 = Con trỏ mảng Ngưỡng
# $s3 = Con trỏ mảng Giá, $s4 = Mốc cận dưới của bậc hiện tại.
         .data
msg_in:		.asciiz "Nhap so kWh ( 0 ... 9999 ): "
msg_err: 	.asciiz "Gia tri khong hop le! Xin moi nhap lai \n"
msg_out:	.asciiz "Tong tien la: "
msg_vnd:	.asciiz " dong\n"

thresholds:	.word 50, 100, 200, 300, 400, 9999
prices:		.word 1620, 1680, 1970, 2520, 2870, 3020
	.text
	.globl main
main:
nhap_lieu:
	# Nhap so dien
	la $a0,msg_in
	li $v0, 4
	syscall
	
	# Đoc gia tri $v0 va chuyen vao $s1 
	li $v0, 5
	syscall
	move $s1, $v0
	
	# Kiem tra hop le
	sltiu $t0, $s1, 10000		# t0 = 1 neu x hop le ( 0 - 9999 )
	bne $t0, $zero, khoi_tao	# Hop le -> khoi tao
	li $v0, 4 			# Khong hop le
	la $a0, msg_err
	syscall
	
	j nhap_lieu
	
khoi_tao:
	li $s0, 0 			# Tong tien = 0 
	la $s2, thresholds		
	la $s3, prices 
	li $s4, 0			# Can duoi ban dau = 0

Loop:
	blez $s1, End
	
	# Doc threshold va price cua bac hien tai 
	lw $t1, 0($s2)			# Can tren bac hien tai
	lw $t2, 0($s3)			# Gia cua bac hien tai 
	
	# Tinh suc chua
	sub $t3, $t1, $s4
	
	# Xac dinh so dien can phai tinh tien
	move $t4, $s1 			# Gia su Amount = Dien con lai 
	ble $s1, $t3, tinh_tien	# Neu so dien con lai <= suc chua thi tinh tien luon
	move $t4, $t3			# Khong thi da tinh full bac

tinh_tien:
	mul $t5, $t4, $t2
	add $s0, $s0, $t5	
	# Cap nhat thong so
	sub $s1, $s1, $t4
	move $s4, $t1
	
	addi $s2, $s2, 4
	addi $s3, $s3, 4
	
	j Loop

End:
	la $a0, msg_out
	li $v0, 4
	syscall
	
	move $a0, $s0
	li $v0, 1 
	syscall 
	
	la $a0, msg_vnd
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
