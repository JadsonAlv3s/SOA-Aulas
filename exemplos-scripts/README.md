# 📜 Exemplos de scripts: UID, PID, relatórios da máquina e processamento

> Mais scripts no estilo das listas, para treinar. Todos usam o mesmo padrão: **título → comando → `>>` arquivo**.
> Não sabe montar um script ainda? Leia antes o [COMO-CRIAR-SCRIPT.md](../COMO-CRIAR-SCRIPT.md).
> Todos foram testados num Debian 13 e **não precisam de sudo**.

| # | Script | Tema | Aulas |
|---|---|---|---|
| 01 | [`01_quem_sou.sh`](01_quem_sou.sh) | sua identidade: UID, GID, grupos, home | 09 |
| 02 | [`02_uid_contas.sh`](02_uid_contas.sh) | todas as contas ordenadas por UID: root, serviço, pessoa | 09 + Q03 |
| 03 | [`03_pid_processos.sh`](03_pid_processos.sh) | PID × UID: quem roda o quê | Q01 |
| 04 | [`04_ficha_maquina.sh`](04_ficha_maquina.sh) | ficha da máquina (resumo + detalhes) | 03 + Q09 |
| 05 | [`05_processamento.sh`](05_processamento.sh) | quem mais gasta CPU e memória | Q01 + Q09 |
| 06 | [`06_relatorio_geral.sh`](06_relatorio_geral.sh) | tudo junto, na tela e no arquivo | todas |

```bash
bash exemplos-scripts/01_quem_sou.sh      # e assim por diante
```

---

## 🧩 3 truques novos (explicados do zero)

Os scripts usam três coisas que não estavam nas listas. Todas são simples:

### 1. `$(comando)`: "troque pelo resultado"
O Bash **roda** o que está dentro de `$( )` e **cola o resultado** no lugar.
```bash
echo "Eu sou $(whoami)"          # → Eu sou aluno
echo "Hoje é $(date +%F)"        # → Hoje é 2026-10-08
```
Serve para montar frases com respostas dentro, ou nomes de arquivo como `rel-server-soa-2026-10-08.txt`.

### 2. Escolher as colunas do `ps` com `-o`
```bash
ps -eo pid,uid,user,comm         # -e todos · -o só estas colunas
ps -p 1 -o comm=                 # o "=" no fim tira a linha de título
```
| Coluna | É |
|---|---|
| `pid` | número do **processo** |
| `uid` | número do **usuário** dono |
| `user` | nome do usuário |
| `comm` | nome do programa |
| `%cpu` / `%mem` | quanto de CPU / memória ele usa |

### 3. `--sort` para ordenar processos
```bash
ps -eo pid,user,%cpu,comm --sort=-%cpu   # o "-" = do MAIOR para o menor
```

---

## 01 · Quem sou eu? (identidade)

**Pergunta:** quem está rodando os comandos e o que o sistema sabe sobre essa pessoa?

| Linha do script | Responde |
|---|---|
| `whoami` | meu nome |
| `id -u` | meu **UID** (só o número) |
| `id -g` | GID do meu grupo **primário** |
| `groups` | todos os meus grupos |
| `echo "$HOME"` / `echo "$SHELL"` | minha pasta e meu shell |
| `getent passwd "$(whoami)"` | minha linha no `/etc/passwd` |

Exemplo de saída:
```
UID (numero do usuario):
1000
MINHA LINHA NO /etc/passwd:
aluno:x:1000:1000::/home/aluno:/bin/bash
```
> Teste: rode `sudo bash 01_quem_sou.sh`. O UID vira **0** e o usuário vira **root**. O relatório vai para `/root/`, porque o `~` passa a ser o home do root.

---

## 02 · Contas por UID

**Pergunta:** quais contas existem, quem é o root, quem é serviço e quem é pessoa?

O comando principal:
```bash
cut -d: -f1,3 /etc/passwd | sort -t: -k2 -n
```
Traduzindo: pegue as colunas **1 (nome)** e **3 (UID)**, depois **ordene pelo 2º campo** (`-k2`), usando `:` como separador (`-t:`) e tratando como **número** (`-n`). Sem o `-n`, o `1000` viria antes do `2`, porque a ordem seria de texto.

Saída:
```
root:0          ← UID 0 = administrador
daemon:1        ← 1 a 999 = contas de serviço
www-data:33
aluno:1000      ← 1000+ = pessoas
nobody:65534    ← conta "ninguém", usada por serviços
```

> 🔒 **Uso de segurança:** a seção "CONTAS COM UID 0" deve mostrar **só o root**. Se aparecer outra conta com UID 0, ela tem poder de administrador. É uma coisa que um auditor procura de verdade.

---

## 03 · PID × UID

**Pergunta:** quais processos estão rodando, e em nome de quem?

| Linha | Responde |
|---|---|
| `echo $$` | o PID **do próprio script** (sim, ele também é um processo) |
| `ps -p 1 -o pid,uid,user,comm` | o processo nº 1 (na VM: `systemd`, sempre do root, UID 0) |
| `ps -eo pid,uid,user,comm \| head -n 15` | os 15 primeiros, com PID e UID lado a lado |
| `ps -e --no-headers \| wc -l` | quantos processos existem |
| `ps -u "$(whoami)"` | só os **meus** processos |
| `ps -eo user= \| sort \| uniq -c` | quantos processos **cada usuário** tem |

Lendo a saída:
```
  PID   UID USER     COMMAND
    1     0 root     systemd
  852  1000 aluno    bash
  901  1000 aluno    ps
```
- Os **PIDs** são todos diferentes: cada processo tem o seu.
- O **UID 1000** se repete: o mesmo usuário (aluno) tem vários processos.

> `uniq -c` conta linhas iguais **seguidas**. Por isso vem depois do `sort`, que junta os nomes iguais.

---

## 04 · Ficha da máquina

**Pergunta:** que máquina é esta? (é a Q09 com um **resumo** no topo)

O resumo usa `$( )` para montar uma linha por informação:
```bash
echo "Kernel:        $(uname -r)" >> "$SAIDA"
echo "CPUs (nucleos): $(nproc)"   >> "$SAIDA"
echo "Ligado:        $(uptime -p)" >> "$SAIDA"
```

| Comando novo | Faz |
|---|---|
| `nproc` | número de núcleos de CPU, só o número |
| `uptime -p` | tempo ligado "bonito" (`up 2 hours, 5 minutes`) |
| `grep PRETTY_NAME /etc/os-release \| cut -d= -f2` | só o nome do sistema (`"Debian GNU/Linux 13 (trixie)"`) |
| `lscpu \| grep -E "Model name\|^CPU\(s\)"` | só as linhas do modelo e da quantidade de CPUs (`-E` permite o `\|` = "ou") |
| `df -h /` | espaço só da partição raiz |

O nome do arquivo inclui máquina e data: `rel-04-maquina-server-soa-2026-10-08.txt`. Assim, rodar em dias diferentes **não apaga** o relatório anterior.

---

## 05 · Processamento

**Pergunta:** a máquina está sobrecarregada? Quem está gastando recursos?

```bash
nproc                                                   # quantos núcleos
uptime                                                  # carga média
ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -n 6 # top 5 de CPU
ps -eo pid,user,%cpu,%mem,comm --sort=-%mem | head -n 6 # top 5 de memória
```

**Como ler a carga média** (`load average: 0.15, 0.30, 0.25`): são as médias do último **1, 5 e 15 minutos**. Compare com o `nproc`:
- carga **menor** que o nº de núcleos → máquina com folga;
- carga **maior** → tem processo esperando na fila.

> Por que `head -n 6` para mostrar 5? Porque a 1ª linha é o título (`PID USER %CPU…`).

---

## 06 · Relatório geral (tela + arquivo)

Junta tudo em números curtos, usando `tee`:
```bash
echo "RELATORIO GERAL" | tee "$SAIDA"        # tee SEM -a: começa o arquivo do zero (igual >)
echo "Total de processos: $(ps -e --no-headers | wc -l)" | tee -a "$SAIDA"   # -a: acrescenta (igual >>)
```
Você vê o relatório na tela enquanto ele é gravado.

| Escreve no arquivo | Mostra na tela? | Apaga o anterior? |
|---|---|---|
| `> arq` | não | **sim** |
| `>> arq` | não | não |
| `\| tee arq` | **sim** | **sim** |
| `\| tee -a arq` | **sim** | não |

---

## ✍️ Exercícios (modifique os scripts)

1. No **01**, acrescente uma seção "QUANTIDADE DE GRUPOS" que mostra só o número de grupos do usuário.
2. No **02**, mostre só as contas com UID **a partir de 1000** (pessoas), ordenadas.
3. No **03**, mostre só os processos do **root**, com PID e programa.
4. No **03**, descubra qual é o PID do seu terminal atual **sem** rodar script.
5. No **05**, mude para mostrar o **top 10** de CPU.
6. No **04**, acrescente uma linha no resumo com a **memória total**.
7. Crie um script `07_usuario.sh` que recebe um nome de usuário e mostra o `id` e a linha do `/etc/passwd` **dele**.

<details><summary><b>Respostas</b></summary>

1. ```bash
   echo "QUANTIDADE DE GRUPOS:" >> "$SAIDA"
   id -G | wc -w >> "$SAIDA"        # id -G = números dos grupos; wc -w conta palavras
   ```
2. Ordene e corte a partir da linha certa, ou filtre por UID de 4+ dígitos:
   ```bash
   cut -d: -f1,3 /etc/passwd | grep -E ":[0-9]{4}$" | sort -t: -k2 -n
   ```
   (`[0-9]{4}$` = exatamente 4 dígitos no fim, ou seja, de 1000 a 9999. O `nobody`, com 65534, fica de fora, e deve mesmo, porque é conta de serviço.)
3. ```bash
   ps -u root -o pid,comm
   ```
4. `echo $$` direto no terminal (é o PID do Bash que você está usando). Confirme com `ps -p $$`.
5. Troque `head -n 6` por `head -n 11`.
6. ```bash
   echo "Memoria total: $(free -h | grep Mem | tr -s ' ' | cut -d' ' -f2)" >> "$SAIDA"
   ```
   `tr -s ' '` junta vários espaços seguidos em um só. Aí o `cut` com separador espaço pega a 2ª coluna (a 1ª é `Mem:`). Resultado: `15Gi`.
   Mais simples e também aceito: `free -h | grep Mem >> "$SAIDA"` (a linha inteira).
7. `$1` é o **primeiro valor** escrito depois do nome do script:
   ```bash
   #!/bin/bash
   # Uso: bash 07_usuario.sh ana
   echo "USUARIO: $1"
   id "$1"
   getent passwd "$1"
   ```
   Rodando `bash 07_usuario.sh root` → mostra `uid=0(root)…` e `root:x:0:0:root:/root:/bin/bash`.
</details>
