#!/bin/bash
# 02 · Contas e UIDs: quem é root, quem é serviço, quem é pessoa (Aula 09).
# Uso: bash 02_uid_contas.sh

SAIDA=~/rel-02-uid-contas.txt

echo "CONTAS DO SISTEMA POR UID" > "$SAIDA"

echo "TOTAL DE CONTAS:" >> "$SAIDA"
wc -l < /etc/passwd >> "$SAIDA"

echo "NOME:UID ORDENADO PELO UID:" >> "$SAIDA"
# cut pega as colunas 1 (nome) e 3 (UID).
# sort -t: -k2 -n = separador ":", ordena pela 2ª coluna, como número.
cut -d: -f1,3 /etc/passwd | sort -t: -k2 -n >> "$SAIDA"

echo "CONTAS COM UID 0 (poder de root):" >> "$SAIDA"
cut -d: -f1,3 /etc/passwd | grep ":0$" >> "$SAIDA"   # deveria ser só o root!

echo "CONTAS DE PESSOAS (shell /bin/bash):" >> "$SAIDA"
grep "/bin/bash$" /etc/passwd | cut -d: -f1,3 >> "$SAIDA"

echo "CONTAS DE SERVICO (nologin):" >> "$SAIDA"
grep "nologin$" /etc/passwd | cut -d: -f1,3 >> "$SAIDA"

echo "TOTAL DE CONTAS DE SERVICO:" >> "$SAIDA"
grep -c "nologin$" /etc/passwd >> "$SAIDA"

cat "$SAIDA"
