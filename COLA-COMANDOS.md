# 🧾 Cola de comandos (Encontros 01 a 04, 09 e 10)

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

## Texto e relatórios (revisão das listas)
```bash
cut -d: -f1 /etc/passwd          # 1ª coluna (nomes), separador :
cut -d: -f1 /etc/passwd | sort   # | passa a saída adiante; sort ordena
grep "/bin/bash$" /etc/passwd    # linhas que terminam com /bin/bash
grep -c "nologin$" /etc/passwd   # conta as linhas que casam
wc -l < /etc/passwd              # conta linhas (só o número)
echo "TITULO" > rel.txt          # > cria/substitui
date >> rel.txt                  # >> acrescenta
uptime | tee -a rel.txt          # tela + acrescenta no arquivo
echo "x" | sudo tee /srv/arq     # gravar onde só root escreve (sudo + > não funciona)
ps aux                           # todos os processos
ps aux | grep bash | grep -v grep
ps -p 1                          # processo de PID 1
```

## Usuários e grupos (Encontro 09)
```bash
whoami ; id ; id ana ; groups ana
getent passwd ana                       # usuario:x:UID:GID:GECOS:HOME:SHELL
getent group projeto-web                # grupo:x:GID:membros
sudo head /etc/shadow                   # hashes de senha (só root)
sudo groupadd projeto-web               # cria grupo
sudo groupdel projeto-web               # remove grupo
sudo useradd -m -s /bin/bash ana        # cria usuário com home e Bash
sudo passwd ana                         # define senha
sudo userdel ana                        # remove conta (mantém /home)
sudo userdel -r ana                     # remove conta E home
sudo gpasswd -a ana projeto-web         # adiciona ao grupo (usuário, grupo)
sudo gpasswd -d ana projeto-web         # remove do grupo
sudo usermod -aG projeto-web ana        # adiciona (grupo, usuário): SEMPRE com -a
sudo usermod -g grupo ana               # muda o grupo PRIMÁRIO
sudo usermod -s /bin/bash ana           # muda o shell
```

## Permissões (Encontro 10)
```bash
ls -l arquivo                           # permissões do arquivo
ls -ld diretorio                        # permissões do próprio diretório
chmod u+x script.sh                     # simbólico: u g o a / + - = / r w x
chmod u=rw,g=r,o= doc.txt               # = define exatamente  (≡ 640)
chmod 640 doc.txt                       # octal: r=4 w=2 x=1 (dono grupo outros)
sudo chown ana relatorio.txt            # muda dono
sudo chown ana:projeto-web relatorio.txt  # dono e grupo
sudo chgrp projeto-web relatorio.txt    # muda grupo
umask                                   # máscara atual (0022 → 644/755)
umask 027                               # arquivos 640, diretórios 750
sudo -u ana ls /srv/projeto-web         # testa um comando como outro usuário
```

| Octal | 600 | 640 | 644 | 750 | 755 | 770 |
|---|---|---|---|---|---|---|
| Simbólico | `rw-------` | `rw-r-----` | `rw-r--r--` | `rwxr-x---` | `rwxr-xr-x` | `rwxrwx---` |
