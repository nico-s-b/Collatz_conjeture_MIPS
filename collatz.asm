.data
	prompt:	.asciiz "Ingrese un número: "
	mens:	.asciiz "Secuencia de Collatz\n"	
	space:	.asciiz " "
.text
main:
	#Imprimir bienvenida
	li $v0, 4
	la $a0, mens
	syscall
	#Solicitar entrada al usuario
	li $v0, 4
	la $a0, prompt
	syscall
	#Leer entrada del usuario
	li $v0, 5
	syscall
	#Guardar entrada en registro $t0
	move $t0, $v0

	#Guardar valores constantes 1, 2 y 3
	li $s1, 1	#guardar constante 1
	li $s2, 2	#guardar constante 2
	li $s3, 3	#guardar constante 3

	lui $s4, 0x1001  # Carga los 16 bits superiores de la dirección en $s4
	ori $s4, $s4, 0x00a0  # Completa los 16 bits inferiores de la dirección
	#Imprimir valor inicial
	li $v0, 1	#instrucción imprimir entero
	move $a0, $t0	#cargar valor
	syscall		
	sw $t0, 0($s4)	 #GUARDAR RESULTADO
	addi $s4, $s4, 4 #puntero a siguiente palabra
 	#Imprimir espacio
 	li $v0, 4	#instrucción imprimir texto
	la $a0, space	#cargar espacio
	syscall		
			
	jal collatz	#salto a collatz
	
	#Salir
	li $v0, 10	#Terminar programa
	syscall
collatz:
	#verificar si la entrada es 1
	beq $t0, $s1, end	#comparar con 1
	#Dividir por 2 entrada
	div $t0, $s2	#dividir por 2
	mfhi $t2	#resto
	#Ir a par si resto = 0, si no, a impar
	beq $t2, $zero par	#comparar resto
	j impar		#si no, ir a impar
par: 	
	#Mover cuociente de división anterior a $t0
	mflo $t0	#cargar cuociente a $t0
	#Imprimir entero
	li $v0, 1	#instrucción imprimir entero
	move $a0, $t0	#cargar entero
	syscall
	sw $t0, 0($s4)	 #GUARDAR RESULTADO
	addi $s4, $s4, 4 #puntero a siguiente palabra	
 	#Imprimir espacio
 	li $v0, 4	#instrucción imprimir texto
	la $a0, space	#cargar espacio
	syscall		
	#Siguiente llamado	
	j collatz	#salto a collatz
impar: 
	#Operación 3n+1
	mul $t1, $t0, $s3	#multiplicar por 3
	addi $t0, $t1, 1	#sumar 1
	#Imprimir entero
	li $v0, 1	#instrucción imprimir entero
	move $a0, $t0	#cargar entero
	syscall		
	sw $t0, 0($s4)	 #GUARDAR RESULTADO
	addi $s4, $s4, 4 #puntero a siguiente palabra	
 	#Imprimir espacio
	li $v0, 4	#instrucción imprimir texto
	la $a0, space	#cargar espacio
	syscall	
	#Siguiente llamado
	j collatz	#salto a collatz
end:	
	jr $ra		#retornar a main