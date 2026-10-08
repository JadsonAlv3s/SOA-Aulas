#!/bin/bash
# 06 · Relatório geral: junta identidade, contas, processos e máquina,
#      mostrando na tela E gravando no arquivo (tee).
# Uso: bash 06_relatorio_geral.sh

SAIDA=~/rel-06-geral.txt

echo "RELATORIO GERAL - $(hostname) - $(date)" | tee "$SAIDA"   # tee sem -a = começa do zero

echo "== QUEM RODOU ==" | tee -a "$SAIDA"
id | tee -a "$SAIDA"

echo "== CONTAS ==" | tee -a "$SAIDA"
echo "Total de contas:      $(wc -l < /etc/passwd)" | tee -a "$SAIDA"
echo "Contas com Bash:      $(grep -c '/bin/bash$' /etc/passwd)" | tee -a "$SAIDA"
echo "Contas com nologin:   $(grep -c 'nologin$' /etc/passwd)" | tee -a "$SAIDA"

echo "== PROCESSOS ==" | tee -a "$SAIDA"
echo "Total de processos:   $(ps -e --no-headers | wc -l)" | tee -a "$SAIDA"
echo "Processos do root:    $(ps -u root --no-headers | wc -l)" | tee -a "$SAIDA"
echo "Meus processos:       $(ps -u "$(whoami)" --no-headers | wc -l)" | tee -a "$SAIDA"
echo "PID 1:                $(ps -p 1 -o comm=)" | tee -a "$SAIDA"

echo "== MAQUINA ==" | tee -a "$SAIDA"
echo "Kernel:               $(uname -r)" | tee -a "$SAIDA"
echo "Nucleos:              $(nproc)" | tee -a "$SAIDA"
free -h | grep Mem | tee -a "$SAIDA"
df -h / | tail -n 1 | tee -a "$SAIDA"
uptime | tee -a "$SAIDA"
