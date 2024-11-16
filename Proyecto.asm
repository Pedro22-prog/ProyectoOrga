.data
    mensaje: .asciiz "Ingrese una clave de 5 letras distintas: "
    clave: .space 20
    matriz: .space 25  # Espacio para la matriz 5x5
    texto_original: .space 100  # Espacio para el texto leído del archivo
    texto_cifrado: .space 200  # Espacio para el texto cifrado (doble por caracteres especiales)
    caracteres_duplicados: .asciiz "**"
    caracter_final: .asciiz "#"

.text
.globl main

main:
    # Solicitar clave al usuario
    li $v0, 4
    la $a0, mensaje
    syscall

    li $v0, 8
    la $a0, clave
    li $a1, 20
    syscall

    # Leer texto desde un archivo (simulado)
    # Aquí se debería implementar la lógica para abrir y leer un archivo en MIPS
    # Por simplicidad, asumamos que el texto está cargado en texto_original

    # Inicializar la matriz de cifrado con la clave
    la $t0, matriz  # Dirección base de la matriz
    la $t1, clave   # Dirección base de la clave
    li $t2, 0  # Índice para la matriz
    li $t3, 0  # Índice para la clave

llenar_clave:
    lb $t4, 0($t1)  # Cargar un byte de la clave
    beqz $t4, llenar_alfabeto  # Si es el fin de la cadena, pasar al alfabeto

    sb $t4, 0($t0)  # Guardar el byte en la matriz
    addi $t0, $t0, 1  # Incrementar el puntero de la matriz
    addi $t1, $t1, 1  # Incrementar el puntero de la clave
    j llenar_clave

llenar_alfabeto:
    # Continuar llenando la matriz con el alfabeto
    li $t5, 'A'  # Comenzar con la letra 'A'

llenar_matriz:
    # Verificar si la letra está en la clave
    la $t1, clave
    li $t6, 0  # Bandera para verificar si la letra está en la clave

verificar_clave:
    lb $t7, 0($t1)
    beqz $t7, agregar_letra  # Si es el fin de la clave, agregar la letra
    beq $t5, $t7, siguiente_letra  # Si la letra está en la clave, pasar a la siguiente

    addi $t1, $t1, 1
    j verificar_clave

agregar_letra:
    sb $t5, 0($t0)  # Guardar la letra en la matriz
    addi $t0, $t0, 1  # Incrementar el puntero de la matriz

siguiente_letra:
    addi $t5, $t5, 1  # Pasar a la siguiente letra
    bne $t5, 'Z', llenar_matriz  # Continuar hasta la 'Z'

    # Procesar el texto para cifrar
    la $t0, texto_original
    la $t1, texto_cifrado

procesar_texto:
    lb $t4, 0($t0)  # Leer un carácter del texto original
    beqz $t4, cifrar_texto  # Fin del texto

    # Convertir a mayúsculas y eliminar espacios
    # Aquí se debería implementar lógica para convertir a mayúsculas y manejar espacios

    # Manejar duplicados
    lb $t5, 1($t0)  # Verificar siguiente letra
    beq $t4, $t5, manejar_duplicados

    sb $t4, 0($t1)  # Guardar la letra en el texto cifrado
    addi $t1, $t1, 1
    addi $t0, $t0, 1
    j procesar_texto

manejar_duplicados:
    la $t6, caracteres_duplicados
    lb $t7, 0($t6)
    sb $t7, 0($t1)
    addi $t1, $t1, 1
    lb $t7, 1($t6)
    sb $t7, 0($t1)
    addi $t1, $t1, 1
    addi $t0, $t0, 2  # Saltar el duplicado
    j procesar_texto

cifrar_texto:
    # Mostrar el texto cifrado
    li $v0, 4
    la $a0, texto_cifrado
    syscall

    # Terminar el programa
    li $v0, 10
    syscall