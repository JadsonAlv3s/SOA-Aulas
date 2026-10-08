#!/bin/bash
# 04 · Ficha da máquina: resumo curto + detalhes (Q09 da Lista I, versão resumida).
# Uso: bash 04_ficha_maquina.sh

SAIDA=~/rel-04-maquina-$(hostname)-$(date +%F).txt   # ex.: rel-04-maquina-server-soa-2026-10-08.txt

echo "FICHA DA MAQUINA" > "$SAIDA"
echo "Gerado em: $(date) por $(whoami)" >> "$SAIDA"

echo "== RESUMO ==" >> "$SAIDA"
echo "Hostname:      $(hostname)" >> "$SAIDA"
echo "Sistema:       $(grep PRETTY_NAME /etc/os-release | cut -d= -f2)" >> "$SAIDA"
echo "Kernel:        $(uname -r)" >> "$SAIDA"
echo "Arquitetura:   $(uname -m)" >> "$SAIDA"
echo "CPUs (nucleos): $(nproc)" >> "$SAIDA"
echo "Ligado:        $(uptime -p)" >> "$SAIDA"

echo "== PROCESSADOR ==" >> "$SAIDA"
lscpu | grep -E "Model name|^CPU\(s\)|Architecture" >> "$SAIDA"

echo "== MEMORIA ==" >> "$SAIDA"
free -h >> "$SAIDA"

echo "== DISCOS ==" >> "$SAIDA"
lsblk >> "$SAIDA"

echo "== ESPACO NA RAIZ (/) ==" >> "$SAIDA"
df -h / >> "$SAIDA"

echo "== REDE ==" >> "$SAIDA"
ip -br address >> "$SAIDA"

echo "== TEMPO LIGADO E CARGA ==" >> "$SAIDA"
uptime | tee -a "$SAIDA"

echo
echo "Relatorio salvo em: $SAIDA"
