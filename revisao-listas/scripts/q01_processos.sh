#!/bin/bash
# Lista II · Q01: inventário de processos.
# Uso: bash q01_processos.sh   (não precisa de sudo)

SAIDA=~/relatorio-processos.txt

echo "INVENTARIO DE PROCESSOS" > "$SAIDA"

echo "HOSTNAME:" >> "$SAIDA"
hostname >> "$SAIDA"

echo "DATA:" >> "$SAIDA"
date >> "$SAIDA"

echo "USUARIO:" >> "$SAIDA"
whoami >> "$SAIDA"

echo "PRIMEIROS PROCESSOS:" >> "$SAIDA"
ps aux | head -n 15 >> "$SAIDA"

echo "PROCESSOS BASH:" >> "$SAIDA"
ps aux | grep bash | grep -v grep >> "$SAIDA"      # grep -v grep tira a linha do próprio grep

echo "TOTAL DE PROCESSOS BASH:" >> "$SAIDA"
ps aux | grep bash | grep -v grep | wc -l >> "$SAIDA"

echo "PID 1:" >> "$SAIDA"
ps -p 1 >> "$SAIDA"

cat "$SAIDA"
