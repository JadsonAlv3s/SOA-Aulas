#!/bin/bash
# Relatório de reconhecimento do servidor (Encontro 03).
# Uso na VM Debian:  bash relatorio-reconhecimento.sh
# Cada linha mostra o valor encontrado e o comando que o produziu.

linha() { printf '%-15s %-45s [%s]\n' "$1:" "$2" "$3"; }

echo "RELATÓRIO DE RECONHECIMENTO — $(date '+%d/%m/%Y %H:%M')"
echo "--------------------------------------------------------------------------"
. /etc/os-release
linha "Hostname"      "$(hostname)"                                 "hostname"
linha "Distribuição"  "$NAME"                                       "cat /etc/os-release"
linha "Versão"        "$VERSION"                                    "cat /etc/os-release"
linha "Kernel"        "$(uname -r)"                                 "uname -r"
linha "Arquitetura"   "$(uname -m)"                                 "uname -m"
linha "CPUs"          "$(lscpu | awk -F: '/^CPU\(s\)/{gsub(/ /,"",$2); print $2}')" "lscpu"
linha "Memória"       "$(free -h | awk '/^Mem/{print $2" total, "$7" disponível"}')" "free -h"
linha "Disco"         "$(lsblk -dno NAME,SIZE,TYPE | awk '$3=="disk"{printf "%s %s ", $1, $2}')" "lsblk"
linha "Espaço em /"   "$(df -h / | awk 'NR==2{print $4" livre de "$2}')" "df -h"
linha "Interfaces"    "$(ip -br address | awk '{printf "%s(%s) ", $1, $3}')" "ip -br address"
linha "Timezone"      "$(timedatectl show -p Timezone --value 2>/dev/null)" "timedatectl"
linha "Uptime"        "$(uptime -p)"                                "uptime"
linha "Usuário atual" "$(whoami)"                                   "whoami"
linha "Home"          "$HOME"                                       "echo \$HOME"
linha "Shell"         "$SHELL"                                      "echo \$SHELL"
if sudo -n true 2>/dev/null; then sudo_ok="sim ($(sudo whoami))"; else sudo_ok="pede senha: teste com 'sudo whoami'"; fi
linha "sudo"          "$sudo_ok"                                    "sudo whoami"
if ping -c 2 -W 2 debian.org >/dev/null 2>&1; then net="ok"; else net="FALHOU"; fi
linha "Internet"      "$net"                                        "ping -c 4 debian.org"
