#!/bin/bash
# Lista I · Q09: relatório de diagnóstico do servidor.
# Uso: bash q09_diagnostico.sh   (não precisa de sudo)
# Inclui TODAS as seções pedidas no enunciado (o script do slide parava em MEMORIA).

SAIDA=~/diagnostico-servidor.txt

echo "RELATORIO DE DIAGNOSTICO" > "$SAIDA"

echo "== IDENTIFICACAO ==" >> "$SAIDA"
hostname >> "$SAIDA"
whoami >> "$SAIDA"
date >> "$SAIDA"

echo "== PROCESSADOR ==" >> "$SAIDA"
lscpu >> "$SAIDA"

echo "== MEMORIA ==" >> "$SAIDA"
free -h >> "$SAIDA"

echo "== ARMAZENAMENTO ==" >> "$SAIDA"
lsblk >> "$SAIDA"
df -h >> "$SAIDA"

echo "== REDE ==" >> "$SAIDA"
ip -br address >> "$SAIDA"

echo "== SISTEMA ==" >> "$SAIDA"
cat /etc/os-release >> "$SAIDA"
uname -r >> "$SAIDA"

echo "== TEMPO DE ATIVIDADE ==" >> "$SAIDA"
uptime | tee -a "$SAIDA"        # tee -a: mostra na tela E acrescenta no arquivo
