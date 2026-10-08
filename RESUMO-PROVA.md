# 📌 Resumo para a prova: Sistemas Operacionais Abertos (Encontros 01 a 04, 09 e 10)

> Baseado nos slides do Prof. Diego Pereira (IFRN Parnamirim). O fio condutor da disciplina: **descobrir antes de alterar**, **consultar o sistema em vez de supor** e **privilégio só quando necessário**.

## 1. Conceitos (Encontro 01)

- **SO**: administra recursos (CPU/processos, memória, armazenamento, E/S) e faz a interface entre hardware, aplicações e usuário. Também cuida de usuários, permissões, serviços, logs e segurança.
- **Linux = kernel** (núcleo: processos, memória, dispositivos, arquivos, rede).
- **GNU** = ferramentas e utilitários. **GNU + Linux = GNU/Linux** (o sistema completo).
- **Distribuição** = kernel + ferramentas GNU + bibliotecas/serviços + **gerenciador de pacotes** + comunidade. **Debian é distribuição.**
- **Shell** = interpretador de comandos (**Bash**). **Terminal** = a interface. **Terminal ≠ Shell.**
- **Software livre** = 4 liberdades: **executar, estudar, modificar, distribuir**. É sobre liberdade, não preço.
- Linha do tempo: **1969 UNIX → 1983 GNU → 1991 kernel Linux → 1992+ GNU/Linux → distribuições**.
- Sem GUI: decisão **didática** (foco em administração de servidores).

```
Usuário → Terminal/Shell → Aplicações/utilitários → Kernel Linux → Hardware
```

## 2. Virtualização e instalação (Encontro 02)

- **Host** (seu PC) → **Hypervisor tipo 2** (VirtualBox, roda sobre um SO) → **Guest** (Debian 13).
- O disco da VM é um **arquivo** no host, mas o Debian o enxerga como disco físico.
- **Padrão da VM:** `SOA-Debian13`, hostname `server-soa`, Debian 13 **netinst**, **2 vCPUs, 2048 MB, 20 GB dinâmico**, sem GUI.
- **Interface 1 NAT** = Internet/pacotes (a netinst depende dela). **Interface 2 Rede Interna `soa-lab`** = comunicação entre VMs (SSH, web, BD).
- Instalador: Boot ISO → Idioma → **Rede (NAT)** → Usuário → Disco → Pacotes → **GRUB** → Reiniciar.
  - **Senha do root em branco** → usuário comum com **sudo**.
  - Particionamento assistido, disco inteiro, **uma partição** (apaga só o disco **virtual**).
  - Software: **só "standard system utilities"** (sem desktop, **sem SSH**; ele vem depois).
- Boot: **Firmware → GRUB → Kernel → Debian → Login**. Remova a ISO ao reiniciar.
- Snapshots: **"00 - Debian 13 Base"** → **"01 - Configuração Inicial"**.

## 3. Reconhecimento e configuração (Encontro 03)

**Prompt** `usuario@server-soa:~$`: usuário @ hostname : diretório, e o símbolo final. **`$` = comum, `#` = root.**

| Pergunta | Comando |
|---|---|
| Quem sou? | `whoami` / `id` (UID, GID, grupos) |
| Nome da máquina | `hostname` / `hostnamectl` / `cat /etc/hostname` |
| Distribuição/versão | `cat /etc/os-release` |
| Kernel | `uname -r` (`uname -a` = tudo) |
| Arquitetura | `uname -m` → x86_64/amd64 |
| CPU | `lscpu` |
| Memória | `free -h` (olhe o *available*) |
| Tempo ligado / carga | `uptime` |
| Discos e partições | `lsblk` |
| Espaço livre | `df -h` |
| Interfaces | `ip -br a` / `ip addr` |
| Data/timezone | `date` / `timedatectl` |
| Home / shell | `echo $HOME` / `echo $SHELL` |
| Internet | `ping -c 4 debian.org` |

**Administrar** (com `sudo`):
- `sudo hostnamectl set-hostname server-soa`
- `sudo timedatectl set-timezone America/Fortaleza`
- `sudo apt update` (**listas**) → `apt list --upgradable` → `sudo apt upgrade` (**pacotes**). **update ≠ upgrade.**
- `exit` (sair) · `sudo systemctl reboot` · `sudo systemctl poweroff` (não feche a janela da VM).
- Pacotes: Debian → **.deb** → **dpkg** → **APT**.

**Diretórios:** `/` raiz · `/home` usuários · `/root` home do root · `/etc` **configuração** · `/var` dados variáveis (logs) · `/tmp` temporários · `/usr` programas · `/dev` dispositivos · `/proc` kernel e processos.

**Troubleshooting de rede:** interface existe? → tem endereço? → há rota? → DNS resolve? → destino responde? *Uma hipótese por vez.*

## 4. Terminal e sistema de arquivos (Encontro 04)

| Comando | Faz |
|---|---|
| `pwd` | mostra onde estou |
| `ls` / `ls -l` / `ls -a` / `ls -la` | lista / longa / com ocultos / as duas |
| `cd caminho` | muda de diretório |
| `mkdir dir` / `mkdir -p a/b/c` | cria / cria os intermediários |
| `touch arq` | cria arquivo vazio (ou atualiza a data) |
| `rmdir dir` | remove diretório **vazio** (senão: *Directory not empty*) |
| `man cmd` / `cmd --help` | ajuda (`/` pesquisa, `q` sai) |

| Símbolo | `/` raiz | `.` atual | `..` pai | `~` home | `-` anterior |
|---|---|---|---|---|---|

- **Absoluto** começa com `/` e funciona de qualquer lugar. **Relativo** parte do diretório atual.
- Ocultos começam com `.` (`.bashrc`, `.profile`, `.ssh`).
- **Caixa importa** (`Documentos ≠ documentos`). **Espaço** → `"projeto linux"` ou `projeto\ linux`. Prefira `projeto-linux`.

**Clássico da prova:** em `/home/aluno/soa/projetos/servidor-web/scripts`, ir a `/home/aluno/soa/documentos` → `cd ../../../documentos` ou `cd ~/soa/documentos`.

## 5. Usuários e grupos (Encontro 09)

- Usuário = identidade; o sistema usa o **UID** (número). **root = UID 0**. Comuns: 1000+. Contas de **serviço** (`www-data`, `daemon`) usam `nologin`.
- `whoami` (quem sou) · `id` (UID, GID primário, grupos) · `groups` · `getent passwd` / `getent group`.
- **`/etc/passwd`** = `usuario:x:UID:GID:GECOS:HOME:SHELL` (o `x` = senha está no **`/etc/shadow`**, só root lê). **`/etc/group`** = `grupo:x:GID:membros`.
- **Primário** (1, campo GID do passwd) × **suplementares** (vários, /etc/group).
- `useradd -m -s /bin/bash ana` · `passwd ana` · `userdel [-r]` (só `-r` apaga o home) · `groupadd` / `groupdel`.
- `gpasswd -a USUÁRIO GRUPO` adiciona · `gpasswd -d` remove. `usermod -aG GRUPO USUÁRIO` também adiciona; **`-G` sem `-a` substitui tudo**. `-g` = primário.
- Ciclo: **altere → consulte (`id` / `getent group`) → confirme.** Grupo novo só vale na sessão após novo login.

## 6. Permissões (Encontro 10)

- `ls -l`: `-rwxr-x---  ana  dev` → tipo (`-` arquivo, `d` diretório) + **dono | grupo | outros**.
- Regra: é dono? usa o bloco do dono. Senão, está no grupo? usa o do grupo. Senão, **outros**. Só um bloco vale.
- **Arquivo:** r ler · w alterar · x executar. **Diretório:** r listar · w criar/apagar · **x entrar/atravessar**.
- **Octal:** r=4 w=2 x=1. 600 privado · 640 config · 644 público · 750/755 script · **770 pasta de equipe**.
- **Simbólico:** `chmod u+x`, `g+w`, `o-r`, `u=rw,g=r,o=` (≡ 640).
- `chmod` = permissões · `chown dono[:grupo]` = dono · `chgrp` = grupo.
- **umask** tira permissões da base (arquivo 666, dir 777): 022 → 644/755 · 027 → 640/750.
- *Permission denied* → `whoami` → `id` → `ls -l` / `ls -ld` → correção mínima. **Nunca 777, nem sudo no reflexo.**
- Cenário: `mkdir -p /srv/projeto-web` → `chown root:projeto-web` → `chmod 770` → `ls -ld` → `drwxrwx--- root projeto-web`. Quem está fora do grupo cai em "outros" (`---`).

## 7. Revisão das listas (scripts)

- Padrão de relatório: **`>` na 1ª linha, `>>` nas outras**, `tee -a` para tela + arquivo.
- `grep` escolhe **linhas**, `cut -d: -f1` escolhe **colunas**, `sort` ordena, `wc -l` conta.
- `sudo echo x > /srv/arq` falha → `echo x | sudo tee /srv/arq`.
- PID = processo · UID = usuário. `ps aux | grep bash` pode mostrar o próprio grep.
- Guia em linguagem simples: [revisao-listas/](revisao-listas/).

## 8. ✅ Checklist de véspera

- [ ] Sei diferenciar kernel, GNU, distribuição, shell e terminal.
- [ ] Sei as 4 liberdades do software livre.
- [ ] Sei host/guest/hypervisor tipo 2 e o papel de NAT × Rede Interna.
- [ ] Sei os valores da VM padrão (2 vCPU, 2048 MB, 20 GB, server-soa).
- [ ] Sei por que a senha do root fica em branco e por que o SSH não é instalado.
- [ ] Leio qualquer prompt (`$` × `#`).
- [ ] Sei o comando para cada item do relatório de reconhecimento.
- [ ] Sei a diferença update × upgrade.
- [ ] Sei o que há em `/etc`, `/var`, `/home`, `/root`, `/dev`, `/proc`.
- [ ] Monto caminhos relativos com `..` sem errar e crio `~/soa` de cabeça.
- [ ] Leio uma linha do `/etc/passwd` e uma saída do `id` campo por campo.
- [ ] Sei primário × suplementar, `gpasswd -a/-d` e o perigo do `usermod -G`.
- [ ] Converto octal ↔ simbólico sem errar (750, 640, 770…).
- [ ] Sei o que `x` significa em diretório.
- [ ] Sei aplicar umask 022/027.
- [ ] Sei montar `/srv/projeto-web` (root:projeto-web, 770) e dizer quem acessa.
- [ ] Sei a diferença entre `>`, `>>` e `tee`.

Treine: [questões](questoes-teoricas.md) · [simulados](simulados/) · [cola de comandos](COLA-COMANDOS.md).
