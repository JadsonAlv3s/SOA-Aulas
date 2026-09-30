# Encontro 03: Configuração inicial e reconhecimento do Debian

> Slides: SOA_Encontro_03 (Prof. Diego Pereira)
>
> **Ideia central:** *antes de administrar, colete evidências do sistema.* Descobrir antes de alterar.

## 1. Login, prompt e logout

```
Debian GNU/Linux 13 server-soa tty1
server-soa login: usuario
Password: ********          ← não aparece nada enquanto você digita (é normal)
usuario@server-soa:~$ _
```

| Parte do prompt | Significado |
|---|---|
| `usuario` | usuário logado |
| `server-soa` | hostname |
| `~` | diretório atual (aqui, o home) |
| `$` | **usuário comum** |
| `#` | sessão **administrativa/root** |

- `exit`: encerra a sessão (logout).
- `tty1`: o terminal (console) virtual número 1.

## 2. Quem sou eu?

```bash
whoami     # usuario
id         # uid=1000(usuario) gid=1000(usuario) grupos=...
```

| Campo | Significado |
|---|---|
| **UID** | identificador numérico do usuário (root = **0**; usuários comuns começam em **1000** no Debian) |
| **GID** | grupo **primário** |
| **grupos** | grupos extras, dos quais o usuário herda permissões (ex.: `sudo`) |

## 3. Usuário comum × root × sudo

| Usuário comum | root |
|---|---|
| tarefas cotidianas | administração |
| acesso limitado | acesso privilegiado (total) |
| menor risco | **alto impacto** |

**Regra:** não trabalhar permanentemente como root.

**sudo** = executar **uma** ação administrativa sem virar root permanentemente.

```bash
whoami        # usuario
sudo whoami   # root  ← só esse comando rodou como root
```

Não use sudo por hábito; use quando houver necessidade administrativa.

## 4. Identificando o sistema

| Pergunta | Comando | Exemplo de resposta |
|---|---|---|
| Qual distribuição/versão? | `cat /etc/os-release` | Debian GNU/Linux 13 (trixie) |
| Qual kernel? | `uname -r` | 6.12.x-amd64 |
| Tudo do kernel | `uname -a` | nome, host, versão, arquitetura... |
| Qual arquitetura? | `uname -m` | **x86_64** (= amd64) |
| CPU | `lscpu` | 2 CPUs, "Hypervisor vendor: KVM/Oracle" (ambiente convidado) |

> ⚠️ **Debian é a distribuição; Linux é o kernel.** `/etc/os-release` responde sobre a distribuição e `uname -r` responde sobre o kernel.

## 5. Recursos: memória, uptime, disco e rede

```bash
free -h      # memória: total · used · free · available   (-h = human-readable: MiB/GiB)
uptime       # tempo ligado · nº de usuários · carga média (load average de 1, 5 e 15 min)
lsblk        # dispositivos de bloco: discos e partições (ex.: sda, sda1)
df -h        # espaço usado/livre por sistema de arquivos montado
ip -br address   # interfaces em formato resumido (brief)
ip addr          # interfaces com todos os detalhes
```

**Armazenamento:** Dispositivo (`sda`) → Partição (`sda1`) → Sistema de arquivos (ext4) → **Ponto de montagem** (`/`).

- `lsblk` responde: qual é o disco virtual? quais partições existem? onde a raiz `/` está montada?
- `df -h` responde: quanto espaço está disponível?

> 💡 `free`: olhe o **available**, não o *free*. O Linux usa RAM livre como cache, e o *available* é o que realmente pode ser usado.

**Interfaces esperadas:** `lo` (loopback, 127.0.0.1, a própria máquina), **interface 1 = NAT** (tem IP e Internet) e **interface 2 = Rede Interna** (ainda sem IP; é configurada em aulas futuras). Não memorize nomes como `enp0s3`: entenda a **função** de cada uma.

## 6. Estrutura de diretórios

No Linux não existe `C:\`, `D:\`: há **uma única árvore** que começa em `/`.

| Diretório | Conteúdo |
|---|---|
| `/` | raiz do sistema |
| `/home` | diretórios dos usuários (`/home/aluno`) |
| `/root` | home **do root** (≠ `/`!) |
| `/etc` | **configurações** (arquivos de texto) |
| `/var` | dados **variáveis** (logs em `/var/log`, cache, filas) |
| `/tmp` | temporários |
| `/usr` | programas e recursos (`/usr/bin`) |
| `/dev` | **dispositivos** (`/dev/sda`) |
| `/proc` | informações do **kernel e processos** (virtual, gerado em memória) |
| `/bin` `/boot` | binários essenciais / kernel e arquivos de boot (GRUB) |

```bash
pwd            # onde estou
echo $HOME     # meu home
cd ~           # ir para o home
ls /           # listar a raiz
```

### `/etc`: configuração em arquivos de texto

```bash
ls /etc
cat /etc/hostname
cat /etc/os-release
```

Boas práticas: **ler antes de alterar → entender o formato → fazer backup.**

## 7. Configurações administrativas

### Hostname

```bash
hostname                                    # mostra
hostnamectl                                 # mostra detalhes (hostname, SO, kernel, arquitetura, virtualização)
cat /etc/hostname                           # arquivo onde ele fica
sudo hostnamectl set-hostname server-soa    # altera (ação administrativa → sudo)
```

### Data, hora e timezone

```bash
date
timedatectl
timedatectl list-timezones | grep Fortaleza
sudo timedatectl set-timezone America/Fortaleza
```

Horário errado em servidor afeta **logs, certificados, autenticação, banco de dados, tarefas agendadas e auditoria**. Timezone do laboratório: **America/Fortaleza**.

### APT: gerenciamento de pacotes

```
Debian → pacotes .deb → dpkg (instala o .deb) → APT (resolve dependências, baixa dos repositórios)
```

```bash
sudo apt update           # atualiza as LISTAS (índices) de pacotes dos repositórios
apt list --upgradable     # mostra o que pode ser atualizado
sudo apt upgrade          # atualiza os PACOTES instalados
```

> ⚠️ **update ≠ upgrade.** Primeiro `update` (atualiza as listas), depois `upgrade` (atualiza os pacotes). Sem `update`, o `upgrade` não sabe que existem versões novas.

### Reiniciar, desligar e sair

| Comando | Ação |
|---|---|
| `exit` | encerra a sessão |
| `sudo systemctl reboot` | reinicia |
| `sudo systemctl poweroff` | desliga |

Evite fechar a janela da VM como forma normal de desligar: é como tirar o computador da tomada.

## 8. Pedindo ajuda

```bash
man uname          # manual completo
uname --help       # resumo das opções
```

Dentro do `man`: `↑ ↓` navegar · `PageUp/PageDown` páginas · `/` pesquisar · `q` sair.

## 9. Diagnóstico: há Internet?

```bash
ping -c 4 debian.org    # -c 4 = envia 4 pacotes e para
```

Raciocínio em etapas, **uma hipótese por vez**:

```
interface existe? → possui endereço? → há rota? → DNS resolve? → destino responde?
   ip -br a           ip -br a          ip route    ping debian.org   ping
```

> 💡 Se `ping 8.8.8.8` funciona e `ping debian.org` não, o problema é **DNS**.

## 10. Snapshot

Ao final: snapshot **"01 - Configuração Inicial"** (depois do "00 - Debian 13 Base").

---

## Exercícios

1. Interprete `diego@server-soa:~$`: usuário, hostname, diretório, é root?, qual símbolo indica usuário comum?
2. Interprete `root@server-soa:/etc#`.
3. Qual a diferença entre `whoami` e `id`?
4. Qual comando mostra a distribuição e qual mostra o kernel? Por que são diferentes?
5. Como descobrir a arquitetura? O que significa `x86_64`?
6. Qual a diferença entre `lsblk` e `df -h`?
7. Explique a diferença entre `apt update` e `apt upgrade`. Qual vem primeiro?
8. Por que `apt update` precisa de `sudo` e `apt list --upgradable` não?
9. Qual a diferença entre `/` e `/root`? E entre `/root` e `/home`?
10. Em qual diretório ficam as configurações? E os logs?
11. Troque o timezone para America/Fortaleza e confira o resultado.
12. `ping -c 4 debian.org` falhou. Liste, em ordem, as hipóteses a testar.
13. **Desafio (relatório de reconhecimento):** preencha Hostname, Distribuição, Versão, Kernel, Arquitetura, CPUs, Memória, Disco, Espaço livre, Interfaces, Timezone, Uptime e Usuário atual, **com o comando usado em cada item**.

<details><summary><b>Respostas</b></summary>

1. Usuário `diego`; hostname `server-soa`; diretório `~` (home, `/home/diego`); **não** é root; `$` indica usuário comum.
2. Usuário **root**, hostname `server-soa`, diretório `/etc`, `#` = sessão root (cuidado!).
3. `whoami` mostra só o nome do usuário. `id` mostra UID, GID e os grupos.
4. `cat /etc/os-release` (distribuição) e `uname -r` (kernel). Debian é a distribuição; Linux é o kernel que ela usa.
5. `uname -m` (ou `lscpu`). `x86_64` = processador de 64 bits da família x86, também chamado amd64.
6. `lsblk` mostra **dispositivos e partições** (a estrutura: disco → partições → ponto de montagem). `df -h` mostra o **espaço usado/livre** dos sistemas de arquivos montados.
7. `update` atualiza as **listas/índices** dos repositórios; `upgrade` atualiza os **pacotes instalados**. O `update` vem primeiro.
8. `update` **altera** arquivos do sistema (os índices em `/var/lib/apt`), então precisa de privilégio. `list --upgradable` só **lê**.
9. `/` é a raiz de toda a árvore; `/root` é o home do usuário root. `/home` guarda os homes dos usuários comuns (`/home/aluno`), e o root tem o dele separado em `/root`.
10. Configurações em `/etc`; logs em `/var/log`.
11. `sudo timedatectl set-timezone America/Fortaleza` e depois `timedatectl` (ou `date`).
12. A interface existe? (`ip -br a`) → Tem endereço IP? → Há rota padrão? (`ip route`) → O DNS resolve? (`ping 8.8.8.8` funciona mas `ping debian.org` não = DNS) → O destino responde?
13.
| Item | Comando |
|---|---|
| Hostname | `hostname` / `hostnamectl` |
| Distribuição e versão | `cat /etc/os-release` |
| Kernel | `uname -r` |
| Arquitetura | `uname -m` |
| CPUs | `lscpu` |
| Memória | `free -h` |
| Disco | `lsblk` |
| Espaço livre | `df -h` |
| Interfaces | `ip -br a` |
| Timezone | `timedatectl` |
| Uptime | `uptime` |
| Usuário atual | `whoami` |
| Diretório home / shell | `echo $HOME` / `echo $SHELL` |
| sudo funcionando | `sudo whoami` → root |
| Internet | `ping -c 4 debian.org` |

Há um script que gera esse relatório automaticamente em [`relatorio-reconhecimento.sh`](relatorio-reconhecimento.sh). Rode com `bash relatorio-reconhecimento.sh` na VM.
</details>
