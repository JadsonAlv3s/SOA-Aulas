#!/bin/bash
# 03 · PID x UID: cada processo tem um PID e roda em nome de um UID.
# Uso: bash 03_pid_processos.sh

SAIDA=~/rel-03-pid.txt

echo "RELATORIO DE PROCESSOS (PID e UID)" > "$SAIDA"

echo "PID DESTE PROPRIO SCRIPT:" >> "$SAIDA"
echo $$ >> "$SAIDA"                  # $$ = PID do processo atual (o script)

echo "PROCESSO PID 1 (o primeiro a ligar):" >> "$SAIDA"
ps -p 1 -o pid,uid,user,comm >> "$SAIDA"

echo "PRIMEIROS 15 PROCESSOS (PID, UID, USUARIO, PROGRAMA):" >> "$SAIDA"
ps -eo pid,uid,user,comm | head -n 15 >> "$SAIDA"

echo "TOTAL DE PROCESSOS:" >> "$SAIDA"
ps -e --no-headers | wc -l >> "$SAIDA"    # --no-headers tira a linha de título

echo "MEUS PROCESSOS ($(whoami)):" >> "$SAIDA"
ps -u "$(whoami)" -o pid,uid,user,comm >> "$SAIDA"

echo "PROCESSOS DO ROOT (UID 0) - quantidade:" >> "$SAIDA"
ps -u root --no-headers | wc -l >> "$SAIDA"

echo "QUANTOS PROCESSOS CADA USUARIO TEM:" >> "$SAIDA"
# user= tira o título; sort agrupa nomes iguais; uniq -c conta cada grupo.
ps -eo user= | sort | uniq -c >> "$SAIDA"

cat "$SAIDA"
