# 🧾 Cola de comandos (Encontros 01 a 04)

## Identificação
```bash
whoami                 # usuário atual
id                     # UID, GID e grupos
hostname               # nome da máquina
hostnamectl            # hostname + SO + kernel + arquitetura + virtualização
cat /etc/hostname      # arquivo do hostname
cat /etc/os-release    # distribuição e versão
uname -r               # versão do kernel
uname -m               # arquitetura (x86_64)
uname -a               # todas as informações do kernel
echo $SHELL            # shell do usuário (/bin/bash)
echo $HOME             # diretório home
```

## Recursos
```bash
lscpu                  # CPU (nº de CPUs, modelo, virtualização)
free -h                # memória (total, used, free, available)
uptime                 # tempo ligado, usuários, carga média
lsblk                  # discos e partições
df -h                  # espaço usado/livre por ponto de montagem
ip -br address         # interfaces (resumo)   = ip -br a
ip addr                # interfaces (detalhado)
ping -c 4 debian.org   # testa conectividade e DNS (4 pacotes)
```

## Administração (sudo)
```bash
sudo whoami                                   # deve responder root
sudo hostnamectl set-hostname server-soa
date ; timedatectl
timedatectl list-timezones | grep Fortaleza
sudo timedatectl set-timezone America/Fortaleza
sudo apt update                               # atualiza as LISTAS
apt list --upgradable                         # o que dá para atualizar
sudo apt upgrade                              # atualiza os PACOTES
exit                                          # encerra a sessão
sudo systemctl reboot                         # reinicia
sudo systemctl poweroff                       # desliga
```

## Navegação e arquivos
```bash
pwd                    # onde estou
ls  ls -l  ls -a  ls -la   ls /etc
cd /etc                # absoluto
cd projetos/linux      # relativo
cd ..   cd ../..       # sobe 1 / 2 níveis
cd ~    cd             # home
cd -                   # diretório anterior
mkdir dir              # cria diretório
mkdir -p a/b/c         # cria com intermediários
touch arq.txt          # arquivo vazio
rmdir dir              # remove diretório VAZIO
cd "projeto linux"     # nome com espaço (ou projeto\ linux)
```

## Ajuda
```bash
man comando            # ↑↓ navegar · PgUp/PgDn · / pesquisar · q sair
comando --help
```
