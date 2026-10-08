#!/bin/bash
# 01 · Quem sou eu? Identidade do usuário que rodou o script (Aula 09).
# Uso: bash 01_quem_sou.sh

SAIDA=~/rel-01-quem-sou.txt

echo "RELATORIO DE IDENTIDADE" > "$SAIDA"

echo "USUARIO (whoami):" >> "$SAIDA"
whoami >> "$SAIDA"

echo "UID (numero do usuario):" >> "$SAIDA"
id -u >> "$SAIDA"                   # -u = só o UID

echo "GID PRIMARIO:" >> "$SAIDA"
id -g >> "$SAIDA"                   # -g = só o GID do grupo primário

echo "TODOS OS GRUPOS:" >> "$SAIDA"
groups >> "$SAIDA"

echo "ID COMPLETO:" >> "$SAIDA"
id >> "$SAIDA"

echo "HOME E SHELL:" >> "$SAIDA"
echo "$HOME" >> "$SAIDA"
echo "$SHELL" >> "$SAIDA"

echo "MINHA LINHA NO /etc/passwd:" >> "$SAIDA"
getent passwd "$(whoami)" >> "$SAIDA"   # $(whoami) é trocado pelo seu nome

cat "$SAIDA"
