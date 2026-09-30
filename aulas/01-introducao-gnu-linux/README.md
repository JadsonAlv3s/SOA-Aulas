# Encontro 01: Introdução aos Sistemas Operacionais Abertos e ao GNU/Linux

> Slides: SOA_Encontro_01 (Prof. Diego Pereira)

## 1. O que é um Sistema Operacional

Um **Sistema Operacional (SO)** administra os recursos do computador e oferece uma interface entre o **hardware**, as **aplicações** e os **usuários**.

```
Usuário
   ↓
Aplicações
   ↓
Sistema Operacional
   ↓
Hardware
```

**Que problema ele resolve?** Sem o SO, cada programa teria que saber lidar sozinho com CPU, memória, disco, rede e permissões. O SO **padroniza o acesso aos recursos**, e com isso as aplicações ficam mais simples e **portáveis**.

### As 4 áreas que o SO gerencia

| Área | O que envolve |
|---|---|
| **Processamento** | CPU, processos, execução |
| **Memória** | RAM, memória virtual |
| **Armazenamento** | discos, partições, arquivos |
| **Entrada/Saída (E/S)** | rede, teclado, dispositivos |

Além disso, o SO cuida de **usuários, permissões, serviços, logs e segurança**.

## 2. Linha do tempo: do Unix ao GNU/Linux

| Ano | Marco |
|---|---|
| **1969** | **UNIX** (Bell Labs). Muitos conceitos do Linux vêm da tradição Unix. |
| **1983** | **Projeto GNU** (Richard Stallman): criar um sistema operacional livre. |
| **1991** | **Kernel Linux** (Linus Torvalds). |
| **1992+** | **GNU + Linux**: as ferramentas GNU juntas com o kernel Linux formam um sistema completo. |
| **Hoje** | **Distribuições** GNU/Linux (Debian, Ubuntu, Fedora...). |

## 3. Software livre

"Livre" tem a ver com **liberdade**, não com preço (*free as in freedom*, não *free beer*). As 4 liberdades:

1. **Executar** o programa para qualquer propósito
2. **Estudar** como funciona (exige acesso ao código-fonte)
3. **Modificar** o programa
4. **Distribuir** cópias, originais ou modificadas

O acesso ao código-fonte permite **estudar, auditar, adaptar e compartilhar** soluções.

## 4. Os conceitos que mais caem (não confunda!)

| Termo | O que é | Exemplo |
|---|---|---|
| **Linux** | Tecnicamente, **só o kernel** | Linux 6.12 |
| **Kernel** | O **núcleo** do SO. Gerencia processos, memória, dispositivos, arquivos e rede, e decide como os recursos são usados e protegidos. | Linux |
| **GNU** | O conjunto de **ferramentas e utilitários** do sistema | GNU Coreutils (`ls`, `cp`), Bash |
| **GNU/Linux** | O sistema completo: ferramentas GNU + kernel Linux | No dia a dia, muita gente chama de "Linux" |
| **Distribuição** | Kernel + ferramentas GNU + bibliotecas e serviços + **gerenciador de pacotes** + organização/comunidade | Debian, Ubuntu |
| **Shell** | O **programa que interpreta** os comandos | **Bash** (padrão da disciplina) |
| **Terminal** | A **interface** (a janela ou tela) onde você digita | tty1, GNOME Terminal |

> ⚠️ **Terminal ≠ Shell.** O terminal é a interface. O shell é o programa que interpreta os comandos. O caminho é: Terminal → Shell (Bash) → comandos e programas.

### Arquitetura em camadas

```
Usuário
Terminal / Shell
Aplicações e utilitários
Kernel Linux
Hardware
```

## 5. Por que Debian? Por que sem interface gráfica?

**Debian:** adequado ao estudo de administração, é base de várias distribuições (inclusive o Ubuntu), usa **APT e pacotes .deb**, tem boa documentação e comunidade e é muito presente em servidores. A disciplina usa **Debian 13, ISO netinst, modo texto**.

**Sem GUI:** a decisão é **didática**. Não é porque "Linux de verdade não tem interface gráfica". É para priorizar arquivos de configuração, serviços, processos, usuários, permissões, rede, logs e automação, que é o que se faz num servidor.

## 6. Ambiente padrão do laboratório

VirtualBox → Debian 13 netinst → sem interface gráfica, com duas interfaces de rede:
- **Interface 1: NAT** → Internet e pacotes
- **Interface 2: Rede Interna** → laboratório entre VMs

A mesma VM acompanha o estudante o semestre todo.

## 7. Primeiros comandos de observação

| Comando | Mostra |
|---|---|
| `whoami` | usuário atual |
| `pwd` | diretório atual |
| `cat /etc/os-release` | distribuição e versão |
| `uname -r` | versão do kernel |
| `echo $SHELL` | shell padrão do usuário |
| `hostname` | nome da máquina |

---

## Exercícios

**1. Atividade de consolidação do slide.** Classifique cada item em *hardware, kernel, shell, distribuição, pacotes, serviços* ou *virtualização*:
Debian · Linux · Bash · APT · GNU Coreutils · Nginx · PostgreSQL · VirtualBox · CPU · RAM · SSD

**2. Questões rápidas do slide:**
1. Linux é tecnicamente o quê?
2. Debian é kernel, shell ou distribuição?
3. Qual é a função do shell?
4. Por que utilizaremos Debian sem GUI?
5. O que significa "software livre"?

**3.** Um software gratuito cujo código-fonte é fechado é software livre? Justifique.

**4.** Coloque em ordem, de cima para baixo: Kernel Linux · Usuário · Hardware · Aplicações e utilitários · Terminal/Shell.

**5.** Verdadeiro ou falso:
- a) Terminal e shell são a mesma coisa.
- b) O kernel decide como a memória será usada pelos processos.
- c) Ubuntu e Debian usam kernels diferentes, por isso são distribuições diferentes.
- d) Uma distribuição normalmente inclui um gerenciador de pacotes.

<details><summary><b>Respostas</b></summary>

**1.**
| Categoria | Itens |
|---|---|
| Hardware | CPU, RAM, SSD |
| Kernel | Linux |
| Shell | Bash |
| Distribuição | Debian |
| Pacotes | APT (gerenciador de pacotes). GNU Coreutils é um pacote de utilitários (ferramentas GNU). |
| Serviços | Nginx (servidor web), PostgreSQL (banco de dados) |
| Virtualização | VirtualBox |

**2.**
1. O **kernel** (núcleo do sistema).
2. **Distribuição.**
3. **Interpretar os comandos** digitados e pedir ao sistema que execute a ação.
4. Decisão **didática**: priorizar a administração de servidores (configuração, serviços, usuários, rede, logs, automação) pelo terminal.
5. Software que garante as liberdades de **executar, estudar, modificar e distribuir**. Tem a ver com liberdade, não com preço.

**3.** Não. Sem acesso ao código-fonte não dá para **estudar** nem **modificar** o programa. Gratuito ≠ livre.

**4.** Usuário → Terminal/Shell → Aplicações e utilitários → Kernel Linux → Hardware.

**5.** a) F (terminal é a interface, o shell interpreta). b) V. c) F (os dois usam o kernel Linux; o que muda é a organização, os pacotes, as ferramentas e a comunidade). d) V.
</details>
