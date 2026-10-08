# Revisão das Listas I e II, explicada do zero

> Baseado nos slides "Aula de Revisão: resolução comentada das listas" (Aulas 01 a 10).
> **Para quem é:** quem ainda se perde no terminal. Tudo aqui está em linguagem simples, com comparações do dia a dia. Os scripts testados ficam em [`scripts/`](scripts/).

## 🗺️ A ideia que vale para todas as questões

Toda questão de script segue o mesmo caminho:

```
olhar  →  filtrar  →  organizar  →  controlar  →  provar (auditar)
```

Em português: **descubra a informação → separe só o que interessa → arrume num arquivo → faça a mudança → mostre que deu certo.**

Antes de escrever o script:
1. **Leia o enunciado** e sublinhe: qual arquivo, usuário, grupo ou processo?
2. **Ache um comando para cada pedaço** do que foi pedido.
3. **Teste um comando por vez** no terminal.
4. **Junte tudo num relatório** com títulos.
5. **Prove** com `ls`, `id`, `getent`, `cat` ou `wc`.

> Não decore o script. Entenda o caminho até ele.

---

## 🧰 Kit básico: as 4 "peças de encanamento"

Os scripts da revisão são, na prática, comandos ligados por estas peças:

| Símbolo | Nome | Comparação | Exemplo |
|---|---|---|---|
| `\|` | *pipe* (cano) | a saída de um comando **escorre** para o próximo | `cut -d: -f1 /etc/passwd \| sort` |
| `>` | redirecionar | **apaga** a folha e escreve do zero | `echo "TITULO" > relatorio.txt` |
| `>>` | acrescentar | escreve **no fim** da folha, sem apagar | `date >> relatorio.txt` |
| `tee` | "T" de encanamento | manda **para a tela e para o arquivo** ao mesmo tempo | `uptime \| tee -a relatorio.txt` |

> ⚠️ O erro mais comum: usar `>` em todas as linhas. Cada `>` **apaga** o que veio antes, e no fim só sobra a última informação.
> Regra prática: **`>` só na primeira linha** do relatório, **`>>` em todas as outras**.

E 4 "ferramentas de recorte" para texto:

| Comando | Faz o quê | Comparação |
|---|---|---|
| `grep palavra` | mostra só as **linhas** que contêm a palavra | marca-texto: destaca as linhas certas |
| `cut -d: -f1` | pega só uma **coluna** (aqui: a 1ª, separada por `:`) | tesoura: recorta uma coluna |
| `sort` | põe em **ordem alfabética** | |
| `wc -l` | **conta** linhas | contador |

> `grep` escolhe **linhas**; `cut` escolhe **colunas**. Se a questão pede "só os nomes", precisa dos dois.

---

## Q03 (Lista I): Auditoria de contas

**O que pede:** um relatório a partir de `/etc/passwd` com o total de contas, a lista de usuários, quem usa Bash e quantas contas têm `nologin`.

### Entendendo o arquivo

`/etc/passwd` é uma **planilha em texto**: cada linha é uma conta, e as colunas são separadas por `:`.

```
ana  :  x  :  1001  :  1001  :  Ana  :  /home/ana  :  /bin/bash
 1      2      3        4       5        6             7
nome  senha   UID      GID    nome     pasta         programa que
      (fica   (nº da   (nº do completo pessoal       abre quando
      noutro  pessoa)  grupo)                        ela entra
      lugar)
```

- Coluna 7 = `/bin/bash` → conta de **pessoa** (pode entrar e digitar comandos).
- Coluna 7 = `nologin` → conta de **serviço** (programa, não pessoa; não pode entrar).

### Comando por comando

| Pergunta | Comando | Tradução |
|---|---|---|
| Quantas contas? | `wc -l < /etc/passwd` | conte as linhas do arquivo |
| Quais os nomes? | `cut -d: -f1 /etc/passwd` | recorte a coluna 1 |
| Em ordem? | `cut -d: -f1 /etc/passwd \| sort` | recorte e ordene |
| Quem usa Bash? | `grep "/bin/bash$" /etc/passwd \| cut -d: -f1` | linhas que terminam em /bin/bash → só o nome |
| Quantos com nologin? | `grep -c "nologin$" /etc/passwd` | conte as linhas que terminam em nologin |

> Detalhes que melhoram a resposta (opcionais, mas corretos):
> - `wc -l /etc/passwd` mostra `23 /etc/passwd`; com `<` mostra só `23`.
> - O `$` no fim do padrão significa **"termina com"**: garante que o `/bin/bash` encontrado é a coluna do shell.
> - `grep -c` = `grep ... | wc -l` (conta direto).

📄 Script: [`scripts/q03_auditoria_usuarios.sh`](scripts/q03_auditoria_usuarios.sh)

---

## Q09 (Lista I): Relatório de diagnóstico do servidor

**O que pede:** uma "ficha médica" do servidor: identificação, processador, memória, disco, rede, sistema e há quanto tempo está ligado.

Aqui não há comando difícil. O desafio é **organizar** muitas respostas num arquivo legível.

| Seção | Comando | Responde |
|---|---|---|
| Identificação | `hostname` · `whoami` · `date` | nome da máquina · quem sou · data e hora |
| Processador | `lscpu` | que CPU é e quantos núcleos |
| Memória | `free -h` | quanta RAM tem e quanta está livre (`-h` = em GB/MB) |
| Armazenamento | `lsblk` · `df -h` | quais discos existem · quanto espaço sobra |
| Rede | `ip -br address` | quais placas de rede e seus IPs (`-br` = resumido) |
| Sistema | `cat /etc/os-release` · `uname -r` | qual Linux e versão · versão do kernel |
| Tempo ligado | `uptime` | há quanto tempo está ligado e a carga |

O formato é sempre: **título → comando → `>>` para o arquivo.**

```bash
echo "== MEMORIA ==" >> ~/diagnostico-servidor.txt
free -h            >> ~/diagnostico-servidor.txt
```

> ⚠️ **O script do slide está incompleto:** ele para em MEMÓRIA e pula ARMAZENAMENTO, REDE e SISTEMA, que o enunciado pede. A versão do repositório tem tudo.

📄 Script: [`scripts/q09_diagnostico.sh`](scripts/q09_diagnostico.sh)

---

## Q01 (Lista II): Inventário de processos

**O que pede:** uma "foto" dos programas rodando agora, achar os que são Bash e identificar o processo número 1.

### O que é processo

**Programa** = receita no livro. **Processo** = a receita **sendo feita** agora na cozinha. Cada processo ganha um número único, o **PID**.

| Sigla | É o número de… | Comparação |
|---|---|---|
| **PID** | um **processo** (programa rodando) | número da senha na fila do banco |
| **UID** | um **usuário** (pessoa/conta) | número do CPF |

> Não confunda: PID muda toda vez que o programa abre; UID é fixo da conta.

### Comandos

| Comando | Tradução |
|---|---|
| `ps aux` | liste **todos** os processos de todos os usuários |
| `ps aux \| head -n 15` | só as 15 primeiras linhas |
| `ps aux \| grep bash` | só as linhas com "bash" |
| `ps aux \| grep bash \| wc -l` | quantas são |
| `ps -p 1` | mostre o processo de PID 1 (na VM: `systemd`, o primeiro a ligar) |

Colunas que importam: **USER** (dono) · **PID** (número) · **%CPU** · **%MEM** · **COMMAND** (qual programa).

> **Pegadinha:** `ps aux | grep bash` às vezes mostra a **própria linha do grep** ("grep bash" contém "bash"). Para tirar: `| grep -v grep` (`-v` = "mostre o que **não** tem"). O professor aceita com ou sem.
> Pela mesma lógica, o próprio `ps` aparece na lista: ele também é um processo enquanto roda.

📄 Script: [`scripts/q01_processos.sh`](scripts/q01_processos.sh)

---

## Q05 (Lista II): Colocando pessoas nos grupos

**O que pede:**

| Grupo | Membros |
|---|---|
| desenvolvimento | ana, bruno |
| suporte | carlos |
| projeto-web | ana, carlos |

### O que é grupo

Pense em **crachás de equipe**. Em vez de liberar uma sala pessoa por pessoa, a empresa libera para "quem tem o crachá do Projeto Web". Para dar acesso a alguém novo, basta dar o crachá.

### Comandos

```bash
sudo gpasswd -a ana desenvolvimento     # -a = add: dá o crachá
sudo gpasswd -d ana desenvolvimento     # -d = delete: tira o crachá
```
Ordem: **`gpasswd -a PESSOA GRUPO`**.

### Conferindo (dois pontos de vista)

| Comando | Pergunta |
|---|---|
| `id ana` | "Quais crachás a **Ana** tem?" |
| `getent group projeto-web` | "Quem tem o crachá do **projeto-web**?" |

> ⚠️ **Perigo:** `usermod -G grupo ana` (sem o `a`) **tira todos os outros crachás** da Ana e deixa só esse. O seguro é `usermod -aG` (a = acrescentar) ou o `gpasswd -a`.

📄 Script: [`scripts/q05_grupos.sh`](scripts/q05_grupos.sh)

---

## Q10 (Lista II): A pasta da equipe Projeto Web

**O que pede:** criar `/srv/projeto-web` com dono `root`, grupo `projeto-web` e permissão `770`, e provar que ficou certo.

### Em 4 passos

| # | Comando | Tradução |
|---|---|---|
| 1 | `sudo mkdir -p /srv/projeto-web` | crie a pasta |
| 2 | `sudo chown root:projeto-web /srv/projeto-web` | dono = root, grupo = projeto-web |
| 3 | `sudo chmod 770 /srv/projeto-web` | defina quem pode o quê |
| 4 | `ls -ld /srv/projeto-web` | mostre como ficou (prova) |

### Decifrando o 770

Cada número é uma **chave**, e cada pessoa cai em **uma** de três filas: **dono**, **grupo** ou **outros**.

```
     7        7        0
   dono     grupo    outros
   rwx      rwx      ---
```

| Letra | Valor | Em arquivo | Em pasta |
|---|---|---|---|
| `r` | 4 | ler | ver o que tem dentro |
| `w` | 2 | alterar | criar/apagar coisas dentro |
| `x` | 1 | executar | **entrar** na pasta |

7 = 4+2+1 = tudo · 0 = nada.

Resultado esperado:
```
drwxrwx---  root  projeto-web  /srv/projeto-web
```
- **root** (dono): tudo.
- **membros do projeto-web** (ana, bruno): tudo.
- **qualquer outro** (ex.: carlos, que não tem o crachá): **nada**.

> **Pergunta clássica:** Carlos não está no `projeto-web`. Qual fila vale para ele? **Outros (`---`)** → *Permission denied*.

### Duas pegadinhas do script

1. **`sudo` + `>` não funciona junto.**
   `sudo echo "texto" > /srv/projeto-web/README.txt` falha: o `sudo` vale para o `echo`, mas quem abre o arquivo para escrever (`>`) é o **seu** terminal, sem poder de admin. Solução: `echo "texto" | sudo tee /srv/projeto-web/README.txt`.
2. **`ls -ld` × `ls -l`:** `ls -ld pasta` mostra **a pasta em si** (dono, permissões). `ls -l pasta` mostra **o que tem dentro**.

> ⚠️ **Correção no script do slide:** ele faz `ls -l /srv/projeto-web` **sem sudo**. Como a pasta é 770 e o usuário do laboratório (`aluno`) normalmente **não** está no `projeto-web`, isso dá *Permission denied* (testado num Debian 13). A versão do repositório usa `sudo ls -l`.

📄 Script: [`scripts/q10_projeto_web.sh`](scripts/q10_projeto_web.sh)

---

## 🚫 Deu *Permission denied*. E agora?

**Não** comece com `chmod 777` (abre a porta para todo mundo) nem com `sudo` no automático. Investigue como um detetive:

```
erro → whoami → id → ls -l / ls -ld → comparar → corrigir só o necessário
```

| Passo | Pergunta |
|---|---|
| `whoami` | Quem sou eu? |
| `id` | Quais crachás (grupos) eu tenho? |
| `ls -l arquivo` / `ls -ld pasta` | De quem é e o que ele libera? |
| comparar | Eu sou o dono? Estou no grupo? Senão, sou "outros". |
| corrigir | Dar o crachá (`gpasswd -a`) **ou** ajustar o recurso (`chgrp`/`chmod`). |

> Ter o crachá não basta: a pasta tem que ser **daquele grupo** e o grupo precisa ter a permissão.

| Comando | Muda |
|---|---|
| `chmod` | as **permissões** (o que cada fila pode fazer) |
| `chown` | o **dono** |
| `chgrp` | o **grupo** |

---

## 🧾 Mapa dos comandos revisados

| Área | Comandos |
|---|---|
| Recortar texto | `grep` · `cut` · `sort` · `wc` |
| Encanamento | `\|` · `>` · `>>` · `tee` |
| Sistema | `hostname` · `free` · `lsblk` · `df` · `ip` · `uptime` |
| Processos | `ps` |
| Usuários | `whoami` · `id` · `groups` |
| Grupos | `gpasswd` · `getent` |
| Permissões | `chmod` · `chown` · `chgrp` · `ls -l` |

> **Mensagem central:** administrar Linux é juntar ferramentas pequenas para **descobrir, agir e provar**.

---

## ✅ Perguntas finais (com respostas simples)

<details><summary><b>1.</b> Por que <code>cut -d: -f1 /etc/passwd</code> retorna nomes de usuários?</summary>

Porque `/etc/passwd` é uma tabela com colunas separadas por `:` e o **nome** é a 1ª coluna. `-d:` diz "o separador é `:`" e `-f1` diz "quero a coluna 1".
</details>

<details><summary><b>2.</b> Qual a diferença entre <code>></code> e <code>>></code>?</summary>

`>` **apaga** o arquivo e escreve do zero. `>>` **acrescenta** no final, mantendo o que já existia.
</details>

<details><summary><b>3.</b> Qual a diferença entre PID e UID?</summary>

PID é o número de um **processo** (programa rodando agora). UID é o número de um **usuário** (conta). Um usuário (1 UID) pode ter vários processos (vários PIDs).
</details>

<details><summary><b>4.</b> Qual a diferença entre <code>id ana</code> e <code>getent group projeto-web</code>?</summary>

`id ana` olha a partir da **pessoa**: todos os grupos da Ana. `getent group projeto-web` olha a partir do **grupo**: todos os membros dele.
</details>

<details><summary><b>5.</b> Em <code>chmod 770</code>, por que quem está fora do grupo não acessa?</summary>

Porque o último dígito (o da fila "outros") é **0** = `---` = nenhuma permissão. Quem não é dono nem do grupo cai nessa fila.
</details>

---

## 🔎 O que foi corrigido em relação aos slides

| Slide | Problema | Correção no repositório |
|---|---|---|
| Q09 (script) | Faltam as seções ARMAZENAMENTO, REDE e SISTEMA pedidas no enunciado | Script completo |
| Q10 (script) | `ls -l /srv/projeto-web` sem `sudo` → *Permission denied* para quem não está no grupo | `sudo ls -l` |
| Q03 (script) | `grep "/bin/bash"` casa o texto em qualquer coluna | `grep "/bin/bash$"` (só no fim = coluna SHELL). O do slide também é aceito. |
| Q01 (script) | contagem de Bash inclui a linha do próprio `grep` | `grep -v grep` (opcional, como o slide diz) |

Os 5 scripts foram executados num container **Debian 13 (trixie)** e produziram o resultado esperado.

### Como rodar na VM

```bash
bash revisao-listas/scripts/q03_auditoria_usuarios.sh
bash revisao-listas/scripts/q09_diagnostico.sh
bash revisao-listas/scripts/q01_processos.sh
bash revisao-listas/scripts/q05_grupos.sh        # precisa dos usuários/grupos da Aula 09
bash revisao-listas/scripts/q10_projeto_web.sh   # idem
```
