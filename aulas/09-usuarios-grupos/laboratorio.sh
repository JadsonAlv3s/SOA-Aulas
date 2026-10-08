#!/bin/bash
# Desafio final do Encontro 09: cria grupos/usuários, associa com gpasswd,
# remove e readiciona um membro e gera a tabela de evidências.
# Uso na VM Debian:  sudo bash laboratorio.sh
# (Faça À MÃO primeiro. Este script serve para conferir.)
# Senhas NÃO são definidas aqui: rode  sudo passwd <usuario>  depois.

if [ "$(id -u)" -ne 0 ]; then
  echo "Rode com sudo: sudo bash $0"; exit 1
fi

RELATORIO="${SUDO_USER:+/home/$SUDO_USER/}desafio-aula09.txt"

# 1. Grupos (getent evita erro se já existirem)
for g in desenvolvimento suporte portal-web; do
  getent group "$g" >/dev/null || groupadd "$g"
done

# 2. Usuários com home e Bash
for u in ana bruno carlos daniela; do
  getent passwd "$u" >/dev/null || useradd -m -s /bin/bash "$u"
done

# 3. Grupos suplementares
gpasswd -a ana desenvolvimento
gpasswd -a ana portal-web
gpasswd -a bruno desenvolvimento
gpasswd -a carlos suporte
gpasswd -a carlos portal-web
gpasswd -a daniela suporte

# 4. Remoção temporária e readição
gpasswd -d carlos portal-web
echo "Sem carlos:  $(getent group portal-web)"
gpasswd -a carlos portal-web
echo "Com carlos:  $(getent group portal-web)"

# 5. Evidências
{
  echo "DESAFIO AULA 09 - $(hostname) - $(date)"
  echo
  printf "%-8s %-5s %-16s %-15s %-10s %s\n" USUARIO UID "GID(primario)" HOME SHELL GRUPOS
  for u in ana bruno carlos daniela; do
    IFS=: read -r nome _ uid gid _ home shell <<< "$(getent passwd "$u")"
    printf "%-8s %-5s %-16s %-15s %-10s %s\n" \
      "$nome" "$uid" "$gid($(id -gn "$u"))" "$home" "$shell" "$(id -Gn "$u")"
  done
  echo
  echo "== id =="
  for u in ana bruno carlos daniela; do id "$u"; done
  echo
  echo "== groups =="
  for u in ana bruno carlos daniela; do groups "$u"; done
  echo
  echo "== getent group =="
  getent group desenvolvimento suporte portal-web
} | tee "$RELATORIO"

[ -n "$SUDO_USER" ] && chown "$SUDO_USER": "$RELATORIO"
echo
echo "Relatório salvo em $RELATORIO"
