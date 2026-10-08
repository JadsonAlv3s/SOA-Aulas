#!/bin/bash
# Lista II · Q05: associa usuários aos grupos e registra a verificação.
# Uso: bash q05_grupos.sh   (o próprio script chama sudo)
# Pré-requisito: usuários ana, bruno, carlos e grupos desenvolvimento,
# suporte, projeto-web já criados (Aula 09).

sudo gpasswd -a ana desenvolvimento
sudo gpasswd -a ana projeto-web
sudo gpasswd -a bruno desenvolvimento
sudo gpasswd -a carlos suporte
sudo gpasswd -a carlos projeto-web

SAIDA=~/associacoes-grupos.txt

echo "ASSOCIACOES DOS USUARIOS" > "$SAIDA"

echo "ANA:" >> "$SAIDA"
id ana >> "$SAIDA"

echo "BRUNO:" >> "$SAIDA"
id bruno >> "$SAIDA"

echo "CARLOS:" >> "$SAIDA"
id carlos >> "$SAIDA"

echo "GRUPO PROJETO-WEB:" >> "$SAIDA"
getent group projeto-web >> "$SAIDA"

cat "$SAIDA"
