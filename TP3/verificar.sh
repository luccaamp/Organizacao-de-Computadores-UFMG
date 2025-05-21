#!/bin/bash

# Verifica se o número correto de argumentos foi passado
if [ "$#" -ne 6 ]; then
    echo "Uso: ./verificar.sh <arquivo base> <tamanho total da cache (bytes)> <tamanho de cada linha (bytes)> <tamanho de cada grupo (unidades)> <caminho arquivo de entrada> <caminho arquivo de saída esperada>"
    echo "Ex: ./verificar.sh simulador2.py 4096 1024 4 ./input/4.txt ./output2/4.txt"
    exit 1
fi

# Lê os argumentos
ARQUIVO_BASE=$1
CACHE_SIZE=$2
LINE_SIZE=$3
GROUP_SIZE=$4
INPUT=$5
OUTPUT=$6

# Executa o "simulador.py" ou "simulador2.py" com os argumentos passados 
python3 "$ARQUIVO_BASE" "$CACHE_SIZE" "$LINE_SIZE" "$GROUP_SIZE" "$INPUT"

# Verifica se o output esperado existe
if [ ! -f "$OUTPUT" ]; then
    echo "Output esperado não encontrado em $OUTPUT"
    exit 1
fi

# Prepara os arquivos para comparação
sed 's/[[:space:]]//g' output.txt > output_clean.txt
sed 's/[[:space:]]//g' "$OUTPUT" > output_expected_clean.txt

# Compara o output gerado com o output esperado
if diff -q output_clean.txt output_expected_clean.txt; then
    echo "Os outputs são idênticos."
else
    echo "Diferença encontrada entre os outputs."
    diff output_clean.txt output_expected_clean.txt
fi

# Limpeza dos arquivos temporários
rm output_clean.txt output_expected_clean.txt
