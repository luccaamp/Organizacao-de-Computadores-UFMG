# Aluno: Lucca Alvarenga de Magalhães Pinto

# Problema 2 - Primos de Mersenne:
#   Fazer três procedimentos:
#    ● Procedimento "geramersenne", que recebe dois argumentos(a quantidade de números de mersenne a serem gerados) 
#      e um vetor onde os números serão armazenados.
#    ● Procedimento "eprimo", que recebe como argumento um número inteiro. Ele retorna 1 se não for primo,
#      e 0 se for primo.
#    ● Procedimento "primosmersenne", que retorna o enésimo primo de mersenne. O índice começa 
#      em 1 (M1=3, M2=7, M3=31, M4=127, M5=8.191, M6=131.071, M7=524.287). O procedimento "primosmersenne" chama 
#      internamente os procedimentos "geramersenne" e "eprimo".
#   Observações sobre a implementação abaixo:
#    ● Número Primo -> número natural maior que 1 que tem exatamente dois divisores positivos distintos: ele mesmo e 1. 
#      Essa definição exclui números negativos, zero, e o número 1.
#    ● O procedimento "geramersenne" no máximo consegue preencher um vetor de 31 posições, por isso no máximo
#      a quantidade de números de mersenne a serem gerados será o tamanho máximo do vetor que é 31.

# Registradores usados no main (definidos pelo enunciado):
# 	s0 (x8) -> quantidade de testes corretos
# 	a0 (x10) -> input para função, registrador de retorno
# 	ra (x1) -> endereço de retorno de função
# 	t0 (x5) -> resposta correta para teste

# Função eprimo:
#	Parâmetros:
#		-> a0 (número para verificar se é primo)
#	Registradores usados:
#		-> sp (alocar espaço na pilha) 
#		-> ra (endereço de retorno) 
# 		-> t1 (número para verificar se é primo)
# 		-> t2 (constante 1)
# 		-> t3 (armazena o divisor atual d)
# 		-> t4 (variável temporária)
# 		-> t5 (apenas para conferir valor final, printar)

# Função geramersenne: (no máximo consegue gerar até 31° número de mersenne)
# 	Parâmetros: 
#   	-> a1 (endereço base do vetor) 
#		-> a2 (quantidade de números de mersenne para gerar, no máximo tamanho do vetor)
# 	Registradores usados:
#		-> sp (alocar espaço na pilha) 
#		-> ra (endereço de retorno) 
#		-> t3 (índice i) 
#		-> t4 (constante 1)
#		-> t5, t6 (variáveis temporárias)

# Função primosmersenne: (no máximo consegue gerar até 7° primo de mersenne)
# 	Parâmetros:
#   	-> a0 (qual primo de mersenne deve ser achado)
# 	Registradores usados:
#		-> sp (alocar espaço na pilha) 
#		-> ra (endereço de retorno)
#   	-> a1 (endereço base do vetor) 
#		-> a2 (quantidade de números de mersenne para gerar, no máximo tamanho do vetor)
#   	-> a5 (índice i)
#   	-> a6 (contador de primos)
#   	-> a7 (qual primo de mersenne deve ser achado)
#   	-> t6 (resultado)

.data
##### R1 START MODIFIQUE AQUI START #####
#
# Este espaço é para você definir as suas constantes e vetores auxiliares.
#

vetor1: .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 # Primeiro vetor
tamanho1: .word 31 # tamanho do vetor1

M1: .word 3
M2: .word 7
M3: .word 31
M4: .word 127
M5: .word 8191
M6: .word 131071
M7: .word 524287

##### R1 END MODIFIQUE AQUI END #####

.text

# Exemplo de como fazer um teste para o procedimento geramersenne
# (tire o comentário das 4 linhas abaixo, e depois use o último printe ao final do código para ver o vetor com os números gerados):
#addi a2, zero, 31   # a2 = (quantidade de números de mersenne a serem gerados, no máximo será igual ao tamanho do vetor1 (31))
#la a1, vetor1        # a1 = endereço base do vetor1 (onde os números serão armazenados)
#jal ra, geramersenne # salto para geramersenne, salvando endereço de retorno em ra
#beq zero, zero, FIM	# vai para FIM

add s0, zero, zero	# s0 = 0
addi a0, zero, 4	# a0 = 4
jal ra, eprimo		# salto para eprimo, salvando endereço de retorno em ra
addi t0, zero, 1	# t0 = 1 = false 
bne a0, t0, teste2	# if(a0 != t0) -> teste2, resposta errada vai para teste2
addi s0, s0, 1		# s0 += 1

teste2: 
        addi a0, zero, 2	# a0 = 2
        jal ra, primosmersenne	# salto para primosmersenne, salvando endereço de retorno em ra
        lw t0, M2           # t0 = M2 = 7
        bne a0, t0, FIM		# if(a0 != t0) -> FIM, resposta errada vai para FIM
        addi s0, s0, 1		# s0 += 1
        beq zero, zero, FIM	# vai para FIM
     
##### R2 START MODIFIQUE AQUI START #####

geramersenne:
    addi sp, sp, -4      # aloca 4 bytes na pilha (1 registrador x 4 bytes)
    sw ra, 0(sp)         # salva ra (endereço de retorno)

    addi t3, zero, 1	# i = 1
    addi t4, zero, 1 	# t4 = 1, constante
    for:
    	bgt t3, a2, fim_for # if(i > quantidade)-> fim_loop
        sll t5, t4, t3   # 2^i, usando 1 << i
        addi t5, t5, -1  # t5 = (2^i - 1)
        
        addi t6, t3, -1 # t6 = (i - 1)
        slli t6, t6, 2  # t6 = (i - 1) * 4
        add t6, t6, a1  # calcula endereço atual vetor1[i-1]
        sw t5, 0(t6)    # armazena (2^i - 1) no vetor
        
        addi t3, t3, 1	# i++
    	j for	# volta para for
    fim_for:
        lw ra, 0(sp)       # restaura ra
        addi sp, sp, 4     # libera o espaço na pilha
 		jalr zero, 0(ra)   # retorna resultado da função
        

eprimo: # 1 -> false, 0 -> true
    addi sp, sp, -4    # aloca espaço na pilha para salvar ra
    sw ra, 0(sp)       # salva ra (endereço de retorno)
    
	add t1, zero, a0 # t1 = n
    
    # verifica se n <= 1
	addi t2, zero, 1 # t2 = 1, constante
    ble t1, t2, false # if(n <= 1)->false
    
	addi t3, zero, 2     # d = 2
    
    loop:
    # verifica se d * d > n
    mul t4, t3, t3     # t4 = d * d
    bgt t4, t1, true   # if(d * d > n)-> true

    rem t4, t1, t3      # t4 = n % d
    beq t4, zero, false # if(n % d == 0)-> false
    
    addi t3, t3, 1     # d++
    j loop             # volta para loop

    false:
        addi a0, zero, 1    # a0 = 0 (não é primo)
        j eprimo_end        # vai para eprimo_end

    true:
        addi a0, zero, 0     # a0 = 1 (é primo)    

    eprimo_end:
        lw ra, 0(sp)         # restaura ra
        addi sp, sp, 4       # libera o espaço na pilha
        add t5, zero, a0     # t5 = a0 (é primo) 
        jalr zero, 0(ra)	 # retorna resultado da função


primosmersenne:
	# a0 -> n° primo de mersenne para procurar
    la a1, vetor1        # a1 = endereço base do vetor1
    lw a2, tamanho1      # a2 = tamanho do vetor 
    
    # empilha registrador ra para salvar endereço de retorno
    addi sp, sp, -4      # aloca espaço na pilha para salvar ra
    sw ra, 0(sp)         # salva ra
    
	jal ra, geramersenne
    
    add a5, zero, zero # i = 0
    add a6, zero, zero # count = 0
    add a7, zero, a0 # a7 = a0 = n
    add t6, zero, zero # t6 = 0
    
    while: 
    	bgt a5, a2, while_end	# if (i > tamanho do vetor) -> while_end
        # a0 = vetor[i]
        slli a0, a5, 2 # a0 = a5 * 4, a0 = i * 4
        add a0, a0, a1 # calcula endereço atual vetor[i]
        lw a0, 0(a0)   # carrega o valor de vetor[i] para a0
        
        add t6, zero, a0 # t6 = a0
        
    	jal ra, eprimo # eprimo(vetor[i])
        addi a5, a5, 1 # i++
        
        beq a0, zero, contador # if(eprimo(vetor[i]) == 0)-> é primo
        j while   # volta para while
    
    contador:
        addi a6, a6, 1	# count++
        beq a6, a7, return # if (count == n) -> return
        j while   # volta para while
        
    while_end:
    	addi a0, zero, -1  # a0 = -1, não encontrou
        j return        # vai para pm_end
        
    return:
        lw ra, 0(sp)          # restaura ra
        addi sp, sp, 4        # libera o espaço na pilha
        add a0, zero, t6 	  # a0 = t6 
        jalr zero, 0(ra)      # retorna resultado da função
    
##### R2 END MODIFIQUE AQUI END #####
 
FIM: add t0, zero, s0		# t0 = s0 = testes corretos 

# Abaixo estão comentados 4 prints diferentes para printar
# cada uma das respostas, retire os cometários daquele que 
# gostaria de printar (só é possível printar 1 por vez):

# impressão da quantidade de testes corretos, tire o comentário das 4 linhas abaixo (printar t0):
#add a0, zero, t0	# a0 = t0
#addi a1, a0, 0	    # a1 = a0
#addi a0, zero, 1	# a0 = 1
#ecall

# impressão do resultado da função primosmersenne, tire o comentário das 4 linhas abaixo (printar t6):
#add a0, zero, t6	# a0 = t6
#addi a1, a0, 0	    # a1 = a0
#addi a0, zero, 1	# a0 = 1
#ecall

# impressão do resultado da função eprimo (printar t5):
# (lembre que eprimo é chamada várias vezes durante primosmersenne, para verificar um valor sozinho de eprimo
# faça apenas 1 teste apenas usando essa função, e depois printe ela aqui )
# tire o comentário das 4 linhas abaixo:
#add a0, zero, t5	# a0 = t5
#addi a1, a0, 0	    # a1 = a0
#addi a0, zero, 1	# a0 = 1
#ecall

# impressão do vetor final após geramersenne, tire o comentário das linhas abaixo:
#    la t0, vetor1         # Carrega o endereço base de vetor1 para o loop de impressão
#    lw t1, tamanho1       # Carrega o tamanho do vetor para o loop de impressão
#    li t2, 0              # Inicializa `t2` como índice para o loop de impressão
#    print_loop:
#        bge t2, t1, end_print # Se i >= n, fim da impressão
#        slli t3, t2, 2        # Multiplica i por 4 para calcular endereço de vetor1[i]
#        add t4, t0, t3        # Calcula endereço de vetor1[i]
#        lw a1, 0(t4)          # Carrega vetor1[i] em a1
#        addi a0, zero, 1      # a0 = 1 (para syscall imprimir inteiro)
#        ecall                 # Imprime o valor de vetor1[i]
#        li a1, 32             # Código ASCII para espaço
#        addi a0, zero, 11     # a0 = 11 (para syscall imprimir caractere)
#        ecall                 # Imprime o espaço
#        addi t2, t2, 1        # i++
#        j print_loop          # Repetir o loop de impressão
#    end_print:
#        li a0, 10             # a0 = 10 (para syscall terminar)
#        ecall                 # Termina o programa
