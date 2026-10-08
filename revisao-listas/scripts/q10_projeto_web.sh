#!/bin/bash
# Lista II · Q10: diretório compartilhado /srv/projeto-web + auditoria.
# Uso: bash q10_projeto_web.sh   (o próprio script chama sudo)
# Pré-requisito: grupo projeto-web com ana e bruno (Aula 09).

getent group projeto-web

sudo mkdir -p /srv/projeto-web
sudo chown root:projeto-web /srv/projeto-web
sudo chmod 770 /srv/projeto-web

# sudo echo ... > arquivo FALHA: quem abre o arquivo é o seu shell, sem privilégio.
# Por isso o texto passa pelo "sudo tee", que roda como root e grava.
echo "Area compartilhada da equipe Projeto Web" | \
  sudo tee /srv/projeto-web/README.txt > /dev/null

SAIDA=~/auditoria-projeto-web.txt

echo "AUDITORIA PROJETO WEB" > "$SAIDA"
hostname >> "$SAIDA"
date >> "$SAIDA"
whoami >> "$SAIDA"

ls -ld /srv/projeto-web >> "$SAIDA"
# Correção em relação ao slide: o diretório é 770 e o seu usuário normalmente
# NÃO está em projeto-web, então "ls -l" sem sudo daria Permission denied.
sudo ls -l /srv/projeto-web >> "$SAIDA"

getent group projeto-web >> "$SAIDA"
id ana >> "$SAIDA"
id bruno >> "$SAIDA"

cat "$SAIDA"
