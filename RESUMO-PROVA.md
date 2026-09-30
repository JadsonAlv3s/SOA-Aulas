# 📌 Resumo para a prova: Sistemas Operacionais Abertos (Encontros 01 a 04)

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

## 5. ✅ Checklist de véspera

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

Treine: [questões](questoes-teoricas.md) · [simulados](simulados/) · [cola de comandos](COLA-COMANDOS.md).
