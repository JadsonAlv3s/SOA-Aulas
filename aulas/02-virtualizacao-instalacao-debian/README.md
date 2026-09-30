# Encontro 02: Virtualização e instalação do Debian 13

> Slides: SOA_Encontro_02 (Prof. Diego Pereira)

## 1. Por que virtualizar?

| Sem virtualização | Com VirtualBox |
|---|---|
| Formatar o computador físico | Ambiente **isolado** |
| Alterar partições reais | **Reinstalação simples** |
| Substituir o sistema principal | **Padronização** da turma |
| Depender de hardware específico | **Snapshots** para voltar com segurança |

**Virtualização** = criar um computador virtual dentro do computador físico.

## 2. Host, guest e hypervisor

| Termo | O que é | Na disciplina |
|---|---|---|
| **Host** (hospedeiro) | O sistema do computador físico | Windows/Linux do aluno |
| **Hypervisor** | O software que cria e executa as VMs | **VirtualBox**, um hypervisor **tipo 2** |
| **Guest** (convidado) | O sistema que roda dentro da VM | **Debian 13** |
| **VM** | A máquina virtual em si | SOA-Debian13 |

```
Host  →  VirtualBox (hypervisor tipo 2)  →  Guest (Debian 13)
```

- **Tipo 2** = roda **em cima de um SO host** (VirtualBox, VMware Workstation).
- **Tipo 1** (bare-metal, só para comparação) = roda **direto no hardware** (VMware ESXi, Proxmox, Hyper-V).
- O Debian trata a VM **como um computador próprio**. O VirtualBox apresenta **hardware virtual** (CPU, RAM, disco, placas de rede) em cima do hardware físico.
- **Pergunta-chave do slide:** o Debian sabe que o disco dele é um arquivo no host? **Não.** Ele enxerga um "disco físico". Na verdade é um **arquivo de disco virtual** (ex.: `.vdi`) no computador hospedeiro.

## 3. Padrão da VM da disciplina (decore!)

| Item | Valor |
|---|---|
| Nome da VM | **SOA-Debian13** |
| Hostname | **server-soa** |
| Sistema | Debian GNU/Linux 13 (trixie) |
| Instalação | **netinst** |
| CPU | **2 vCPUs** |
| Memória | **2048 MB** |
| Disco | **20 GB dinâmico** |
| Interface 1 | **NAT** |
| Interface 2 | **Rede Interna** (`soa-lab`) |
| Interface gráfica | **nenhuma** (instalação mínima) |

**Disco dinâmico** = o arquivo no host cresce conforme o uso, até o limite de 20 GB, em vez de ocupar os 20 GB logo de início.

## 4. ISO netinst

**netinst** = imagem **pequena**, que traz só a base do instalador. O resto dos pacotes é **baixado pela Internet** (de um *mirror* Debian) durante a instalação.

```
ISO netinst  →  Internet (mirror Debian)  →  sistema instalado conforme a seleção
```

Por isso a instalação **depende da Interface 1 (NAT)**.

## 5. As duas interfaces de rede

| | Interface 1: **NAT** | Interface 2: **Rede Interna** |
|---|---|---|
| Para quê | Internet e repositórios | Comunicação **entre VMs** (laboratório) |
| Caminho | Guest → NAT → Host → Internet | server-soa ↔ `soa-lab` ↔ cliente-soa |
| Usos | baixar/atualizar pacotes, acessar mirrors, testar conectividade externa | SSH, servidor web, banco de dados, SFTP/SCP, diagnóstico de rede |
| Teste | `ping -c 4 debian.org`, `sudo apt update` | configurada em aulas futuras |

- A Rede Interna **não depende da rede física** do laboratório.
- **Durante a instalação, a interface principal deve ser a NAT.**

## 6. Criando a VM no VirtualBox

1. Nova VM → Nome **SOA-Debian13** → ISO netinst → Tipo **Linux** → Versão **Debian (64-bit)**
2. **Instalação não assistida: pular/desabilitar**, porque a instalação manual é usada para fins didáticos
3. Recursos: 2 vCPUs, 2048 MB, disco de 20 GB dinâmico
4. Rede: Adaptador 1 = NAT, Adaptador 2 = Rede Interna `soa-lab`

**Checklist antes do boot:** ISO netinst ✓ · 2 vCPUs ✓ · 2048 MB ✓ · disco de 20 GB ✓ · Adaptador 1 NAT ✓ · Adaptador 2 Rede Interna soa-lab ✓

## 7. Roteiro do instalador (modo texto)

```
Boot ISO → Idioma → Rede → Usuário → Disco → Pacotes → GRUB → Reiniciar
```

| Etapa | Decisão | Por quê |
|---|---|---|
| Idioma | Português do Brasil | |
| Teclado | **ABNT2** | testar `/ : - _ \|` |
| Rede principal | **Interface NAT** | é a que tem Internet para o netinst |
| Hostname | **server-soa** | |
| Senha do root | **deixar em branco** | o root fica bloqueado e o **usuário comum recebe sudo** |
| Particionamento | Assistido → usar disco inteiro → **todos os arquivos em uma partição** | simples; armazenamento é estudado depois |
| Software | **só "standard system utilities"** | sem desktop, sem web server, **sem SSH server** (o SSH é instalado depois, como conteúdo) |
| GRUB | instalar no disco | carregador de boot |

> ⚠️ "Qual disco será apagado?" **O disco virtual de 20 GB**, não o disco físico do computador.

## 8. Primeiro boot

```
Firmware → GRUB → Kernel Linux → Debian → Login
```

- Ao reiniciar, **remova/desmonte a ISO** se necessário (senão o instalador abre de novo).
- **GRUB** = o *bootloader*, que carrega o kernel.

### O prompt

```
joao@server-soa:~$
 │      │      │ └─ $ = usuário comum  (# = root)
 │      │      └─── ~ = diretório home
 │      └────────── hostname
 └───────────────── usuário
```

## 9. Validação da instalação

```bash
whoami; hostname; cat /etc/os-release; uname -r   # usuário, host, distribuição, kernel
lscpu; free -h; lsblk; df -h                       # CPU, memória, disco
ip -br address; ip addr                            # interfaces de rede
ping -c 4 debian.org     # testa NAT e DNS
sudo whoami              # deve retornar root
sudo apt update          # atualiza a lista de pacotes
sudo apt upgrade         # atualiza os pacotes
```

**Regra de ouro:** privilégio administrativo só quando necessário.

## 10. Snapshot

Ao final, crie o snapshot **"00 - Debian 13 Base"**. Snapshots evitam reinstalações completas quando uma prática quebra a VM. A evolução prevista é: Debian base → Configuração inicial → Usuários e permissões → Armazenamento → Rede → Serviços.

---

## Exercícios

1. Explique host, guest e hypervisor usando o seu próprio computador como exemplo.
2. Qual a diferença entre hypervisor tipo 1 e tipo 2? Em qual o VirtualBox se encaixa?
3. Por que a ISO netinst precisa de Internet durante a instalação? Qual interface fornece essa Internet?
4. Para que servem a interface NAT e a Rede Interna? Dê dois usos de cada uma.
5. O que acontece com o root quando a senha dele é deixada em branco no instalador?
6. Por que o "SSH server" **não** é marcado na seleção de software?
7. Ao escolher "usar disco inteiro", qual disco é apagado?
8. Interprete o prompt `maria@server-soa:~$`.
9. Liste os comandos para conferir: kernel, memória, discos, espaço livre, interfaces e se o sudo funciona.
10. O que é um snapshot e por que criar um ao final da instalação?
11. **Relatório da atividade:** monte uma tabela com Nome, Usuário Linux, Hostname, Distribuição e versão, Kernel, CPUs, Memória, Disco e Quantidade de interfaces, indicando o comando usado em cada linha.

<details><summary><b>Respostas</b></summary>

1. **Host** = o Windows/Linux do seu PC; **hypervisor** = o VirtualBox; **guest** = o Debian 13 dentro da VM.
2. Tipo 1 roda direto no hardware (ESXi, Proxmox). Tipo 2 roda sobre um SO host. O VirtualBox é **tipo 2**.
3. A netinst traz só a base, e os demais pacotes vêm de um mirror Debian pela rede. Quem fornece a Internet é a **Interface 1 (NAT)**.
4. **NAT:** baixar pacotes, `apt update/upgrade`, acessar mirrors, testar conectividade externa. **Rede Interna:** comunicação entre VMs; SSH, web, banco de dados, SFTP/SCP, diagnóstico de rede.
5. A conta root fica **sem senha (bloqueada para login)** e o **primeiro usuário criado entra no grupo sudo**.
6. Porque a disciplina vai **instalar, configurar e testar** cada serviço como conteúdo. A instalação é mínima de propósito.
7. O **disco virtual de 20 GB**, não o disco físico.
8. Usuário `maria`, hostname `server-soa`, diretório atual `~` (home), `$` = usuário comum.
9. `uname -r`, `free -h`, `lsblk`, `df -h`, `ip -br address`, `sudo whoami` (deve responder `root`).
10. Um "ponto de restauração" do estado da VM. Permite voltar a um estado conhecido sem reinstalar tudo se uma prática quebrar o sistema.
11.
| Item | Comando |
|---|---|
| Nome (da VM) | visto no VirtualBox (SOA-Debian13) |
| Usuário Linux | `whoami` |
| Hostname | `hostname` |
| Distribuição e versão | `cat /etc/os-release` |
| Kernel | `uname -r` |
| CPUs | `lscpu` (ou `nproc`) |
| Memória | `free -h` |
| Disco | `lsblk` / `df -h` |
| Quantidade de interfaces | `ip -br address` (lo + NAT + Rede Interna = 3) |
</details>
