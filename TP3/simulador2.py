import sys

# Classe para ler o arquivo de acessos à memória
class memoryAccessFileReader:

    def __init__(self, memoryAccessFilePath):
        # Inicializa o caminho do arquivo de acesso à memória
        self.memoryAccessFilePath = memoryAccessFilePath

    def read(self):
        # Lê o arquivo de acessos à memória e converte os endereços de hexadecimal para decimal
        decMemoryAccess = []
        with open(self.memoryAccessFilePath, "r") as file:
            for line in file:
                hex = line.strip()
                dec = int(hex, 16)
                decMemoryAccess.append(dec)
        return decMemoryAccess


# Classe que representa uma linha na cache
class Line:

    def __init__(self, index, tag):
        # Inicializa o índice da linha, o tag associado a linha e o bit de validade
        self.index = index
        self.tag = tag
        self.valid = 0  # (0 = inválido, 1 = válido)
    
    def doTagsMatch(self, tagThatIsBeingSearched):
        # Verifica se o tag da linha corresponde ao tag fornecido
        return self.valid and self.tag == tagThatIsBeingSearched
    
    def update(self, newTag):
        # Atualiza o tag da linha e o bit de validade
        self.tag = newTag
        self.valid = 1
    
    def __str__(self):
        # Retorna uma string da linha
        if not self.valid and self.tag == 0:
            return "{:03d}".format(self.index) + " " + str(self.valid)
        return "{:03d}".format(self.index) + " " + str(self.valid) + " " + "0x{:08X}".format(self.tag)


# Classe que representa um grupo na cache (conjunto de linhas)
class Group:

    def __init__(self, index, lines):
        # Inicializa o índice do grupo, as linhas que compõem o grupo e o indicador da próxima linha a ser substituída
        self.index = index
        self.lines = lines
        self.nextLineToBeReplaced = 0
    
    def isHit(self, tag):
        # Verifica se há uma linha no grupo cujo tag corresponde ao tag fornecido. True -> se houver hit, False -> se houver miss
        return any(line.doTagsMatch(tag) for line in self.lines)

    def isBlockInGroup(self, tag):
        # Verifica se o bloco com o tag especificado está no grupo (hit). Se não houver hit, substitui a linha indicada por 'nextLineToBeReplaced' com novo tag
        isHit = self.isHit(tag)
        if not isHit:
            # Substitui linha de acordo com FIFO (First In First Out)
            self.lines[self.nextLineToBeReplaced].update(tag)
            self.nextLineToBeReplaced = (self.nextLineToBeReplaced + 1) % len(self.lines)
        return isHit
    
    def __str__(self):
        # Retorna uma string das linhas no grupo
        return "\n".join(str(line) for line in self.lines)


# Classe que representa a cache
class Cache:

    def __init__(self, cacheSize, lineSize, groupSize):
        # Inicializa o tamanho da cache, tamanho de linha, tamanho do grupo, e calcula número de linhas e grupos na cache
        self.cacheSize = cacheSize
        self.lineSize = lineSize
        self.groupSize = groupSize
        self.numLines = int(cacheSize // lineSize)
        self.numGroups = int(cacheSize // groupSize)
        self.numLinesPerGroup = int(self.numLines // self.numGroups)
        self.groups = []
        self.hits = 0
        self.misses = 0

        # Inicializa as linhas da cache, distribuindo-as pelos grupos
        currentLineIndex = 0
        for i in range(self.numGroups):
            lines = [Line(currentLineIndex + j, 0) for j in range(self.numLinesPerGroup)]
            currentLineIndex += self.numLinesPerGroup
            self.groups.append(Group(i, lines))
    
    def accessMemory(self, memoryAccess):
        # Verifica se o endereço de memória está presente na cache
        memoryGroupIndex = (memoryAccess // self.lineSize) % self.numGroups
        cacheGroupIndex = memoryGroupIndex % self.numGroups
        tag = memoryAccess // (self.lineSize * self.numGroups)
        if self.groups[cacheGroupIndex].isBlockInGroup(tag):
            self.hits += 1
        else:
            self.misses += 1
    
    def __str__(self):
        # Retorna uma string do estado atual da cache
        return "================\nIDX V ** ADDR **\n" + "\n".join(str(group) for group in self.groups)    


if __name__ == "__main__":
    # Verifica se o número de arumentos passados está correto
    if len(sys.argv) != 5:
        print("Use: python3 simulador.py <cache size (bytes)> <line size (bytes)> <number of lines per group> <path/to/memory/access/file>")
        exit(1)
    
    # Lê os argumentos
    cacheSize = int(sys.argv[1])
    lineSize = int(sys.argv[2])
    groupSize = int(sys.argv[3]) * lineSize
    memoryAccessFilePath = sys.argv[4]

    if cacheSize % lineSize != 0:
        print("O tamanho da cache deve ser múltiplo do tamanho da linha")
        exit(1)
    
    if cacheSize % groupSize != 0:
        print("O tamanho da cache deve ser múltiplo do tamanho do grupo")
        exit(1)
    
    if cacheSize < groupSize:
        print("O tamanho da cache deve ser pelo menos tão grande quanto o tamanho do grupo")
        exit(1)

    # leitura do arquivo de acessos à memória
    memoryAccessFile = memoryAccessFileReader(memoryAccessFilePath)
    decMemoryAccess = memoryAccessFile.read()

    cache = Cache(cacheSize, lineSize, groupSize)

    with open("output.txt", "w") as file:
        # escreve a cache após cada acesso
        for memoryAccess in decMemoryAccess:
            cache.accessMemory(memoryAccess)
            file.write(str(cache) + "\n")

        # escreve os resultados de acertos e erros
        file.write("\n")
        file.write("#hits: " + str(cache.hits) + "\n")
        file.write("#miss: " + str(cache.misses))