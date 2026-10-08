#!/bin/bash
# Práticas guiadas e desafio do Encontro 10.
# Uso na VM Debian:  sudo bash laboratorio.sh
# Pré-requisito: grupo projeto-web e usuários ana, bruno e carlos (Aula 09).
# Se não existirem, o script cria, no estado final da Aula 09:
#   projeto-web = ana, bruno   ·   carlos fora
# (Faça À MÃO primeiro. Este script serve para conferir.)

if [ "$(id -u)" -ne 0 ]; then
  echo "Rode com sudo: sudo bash $0"; exit 1
fi

DONO="${SUDO_USER:-root}"
HOME_DONO=$(getent passwd "$DONO" | cut -d: -f6)

getent group projeto-web >/dev/null || groupadd projeto-web
for u in ana bruno carlos; do
  getent passwd "$u" >/dev/null || useradd -m -s /bin/bash "$u"
done
gpasswd -a ana projeto-web >/dev/null
gpasswd -a bruno projeto-web >/dev/null
gpasswd -d carlos projeto-web >/dev/null 2>&1   # carlos é o "usuário externo"

echo "== Prática 1: arquivos em $HOME_DONO/aula10 =="
mkdir -p "$HOME_DONO/aula10"
cd "$HOME_DONO/aula10" || exit 1
touch publico.txt privado.txt compartilhado.txt script.sh
chmod 644 publico.txt
chmod 600 privado.txt
chmod 755 script.sh
chown "$DONO": publico.txt privado.txt compartilhado.txt script.sh
chown "$DONO": "$HOME_DONO/aula10"
ls -l

echo
echo "== Prática 2 / desafio: /srv/projeto-web =="
mkdir -p /srv/projeto-web
chown root:projeto-web /srv/projeto-web
chmod 770 /srv/projeto-web
ls -ld /srv/projeto-web
getent group projeto-web

# Testa e mostra OK/FALHOU comparando com o esperado
testa() {  # testa <usuario> <esperado: pode|negado> <comando...>
  local u=$1 esperado=$2; shift 2
  if sudo -u "$u" "$@" >/dev/null 2>&1; then r=pode; else r=negado; fi
  [ "$r" = "$esperado" ] && st=OK || st=FALHOU
  printf "%-7s %-6s %-45s -> %s\n" "$st" "$u" "$*" "$r"
}

echo
echo "== Testes com usuários diferentes =="
testa ana    pode   touch /srv/projeto-web/teste-ana.txt
testa bruno  pode   ls /srv/projeto-web
testa carlos negado ls /srv/projeto-web
testa carlos negado touch /srv/projeto-web/teste-carlos.txt

echo
echo "== umask 027 =="
(
  cd "$(mktemp -d)" || exit 1
  umask 027
  touch teste.txt
  mkdir teste-dir
  stat -c '%a %A %n' teste.txt teste-dir    # esperado: 640 e 750
)
