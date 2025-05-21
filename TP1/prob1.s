# Aluno: Lucca Alvarenga de Magalhães Pinto

# Problema 1 - Mínimo múltiplo comum (MMC):
#   Procedimento "mmc" que calcula o mínimo múltiplo comum de dois números.
#    ● a0:primeiro número
#    ● a1:segundo número
#   Observações sobre a implementação abaixo:
#    ● Considerando, para todo x, mmc(0, x) = mmc(x, 0) = -1 (indefinido)
#    ● E como mmc é um valor absoluto vale que: para todo x e y, mmc(-x, -y) = mmc(-x, y) = mmc(x, -y) = mmc(x, y)

# Registradores usados no main (definidos pelo enunciado):
# 	s0 (x8) -> quantidade de testes corretos
# 	a0 (x10) -> primeiro número, registrador de retorno
# 	a1 (x11) -> segundo número
# 	ra (x1) -> endereço de retorno de função
# 	t0 (x5) -> resposta correta para teste

# Função eprimo:
#	Parâmetros:
#		-> a0 (primeiro número)
#		-> a1 (segundo número)
#	Registradores usados:
#		-> a2 (primeiro número) 
#		-> a3 (segundo número)
#		-> a4, a5, a6 (registradores temporários)

.data
##### R1 START MODIFIQUE AQUI START #####
#
# Este espaço é para você definir as suas constantes e vetores auxiliares.
#
vetor: .word 1 2 3 4 5 6 7 8 9 10
##### R1 END MODIFIQUE AQUI END #####

.text

add s0, zero, zero  # Quantidade de testes em que seu programa passou, s0 = 0, s0 <=> x8
addi a0, zero, 10	# a0 = 10, a0 <=> x10
addi a1, zero, 2	# a1 = 2, a1 <=> x11
jal ra, mmc		    # salto para mmc, salvando endereço de retorno em ra (x1)
addi t0, zero, 10   # t0 = 10, t0 <=> x5
bne a0,t0,teste2	# if(a0 != t0) -> teste 2, resposta errada vai para teste2
addi s0,s0,1		# s0 += 1 

teste2: addi a0, zero, 6	# a0 = 6
     addi a1, zero, 4		# a1 = 4
     jal ra, mmc			# salto para mmc, salvando endereço de retorno em ra (x1)
     addi t0, zero, 12		# t0 = 12
     bne a0,t0, FIM			# if(a0 != t0) -> teste 2, resposta errada vai para FIM 
     addi s0,s0,1			# s0 += 1
     beq zero,zero,FIM		# vai para FIM
     
##### R2 START MODIFIQUE AQUI START #####

mmc: 
    add a2, zero, a0 # m = a
    add a3, zero, a1 # n = b
    
    # Se a == 0 ou b == 0, então mmc é indefinido (-1)
    beq a2, zero, erro	# if(a == 0)->erro
    beq a3, zero, erro	# if(b == 0)->erro

loop:
    rem a2, a2, a3  # m = m % n
    add a4, zero, a2 # temp = m
    add a2, zero, a3 # m = n
    add a3, zero, a4 # n = temp
    bne a3, zero, loop # n != 0 -> loop
    
    div a5, a0, a2 # (a / m)
    mul a0, a5, a1 # (a / m) * b
    
    # mmc(-x, -y) = mmc(-x, y) = mmc(x, -y) = mmc(x, y)
    # se valor final for negativo, então multiplicamos por -1
    blt a0, zero, negativo	# if(a < 0)->negativo
	beq zero, zero, mmc_fim	# vai para mmc_fim

negativo:
	addi a6, zero, -1 # a6 = -1
	mul a0, a0, a6 # a0 = a0 * -1
    beq zero, zero, mmc_fim # vai para mmc_fim
    
erro:
	addi a0, zero, -1 # a0 = -1
    beq zero, zero, mmc_fim # vai para mmc_fim     
    
mmc_fim:
	add t6, zero, a0  # t6 = a0 (apenas para conferir valor, printar)
	jalr zero, 0(ra)  # Retorna para o endereço onde main foi chamado
    
##### R2 END MODIFIQUE AQUI END #####
 
FIM: addi t0, s0, 0		# t0 = s0 = testes corretos 

# Abaixo estão comentados 2 prints diferentes para printar
# o resultado da função mmc ou a quantidade de testes corretos,
# retire os cometários daquele que gostaria de printar (só é possível printar 1 por vez):

# impressão da quantidade de testes corretos, tire o comentário das 4 linhas abaixo (printar t0):
#add a0, zero, t0	# a0 = t0
#addi a1, a0, 0	    # a1 = a0
#addi a0, zero, 1	# a0 = 1
#ecall

# impressão do resultado da função mmc, tire o comentário das 4 linhas abaixo (printar t6):
#add a0, zero, t6	# a0 = t6
#addi a1, a0, 0	    # a1 = a0
#addi a0, zero, 1	# a0 = 1
#ecall