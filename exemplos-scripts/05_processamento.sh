#!/bin/bash
# 05 · Processamento: quem está gastando CPU e memória agora?
# Uso: bash 05_processamento.sh

SAIDA=~/rel-05-processamento.txt

echo "RELATORIO DE PROCESSAMENTO" > "$SAIDA"
date >> "$SAIDA"

echo "NUCLEOS DE CPU:" >> "$SAIDA"
nproc >> "$SAIDA"

echo "CARGA MEDIA (1, 5 e 15 minutos):" >> "$SAIDA"
uptime >> "$SAIDA"
# Regra prática: carga menor que o nº de núcleos = folga.

echo "TOP 5 PROCESSOS QUE MAIS USAM CPU:" >> "$SAIDA"
# --sort=-%cpu ordena do maior para o menor (o "-" inverte).
# head -n 6 = título + 5 processos.
ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -n 6 >> "$SAIDA"

echo "TOP 5 PROCESSOS QUE MAIS USAM MEMORIA:" >> "$SAIDA"
ps -eo pid,user,%cpu,%mem,comm --sort=-%mem | head -n 6 >> "$SAIDA"

echo "MEMORIA DA MAQUINA:" >> "$SAIDA"
free -h >> "$SAIDA"

cat "$SAIDA"
