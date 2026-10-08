# 🛠️ Como criar um script, passo a passo

> Para quem nunca escreveu um script. Usa só o que foi visto nas aulas e nas listas.
> Faça na **VM Debian**, no terminal.

## O que é um script?

Um **script** é um arquivo de texto com uma **lista de comandos**, um por linha. Em vez de digitar 10 comandos toda vez, você escreve uma vez e roda o arquivo. O Bash lê de cima para baixo e executa cada linha.

> Comparação: digitar comandos no terminal é cozinhar falando cada passo em voz alta. O script é a **receita escrita**: qualquer um pode repetir e o resultado sai igual.

---

## Os 8 passos

```
1 entender → 2 testar no terminal → 3 criar o arquivo → 4 escrever
→ 5 salvar → 6 dar permissão → 7 rodar → 8 conferir
```

Vamos montar, do zero, o script da **Q03 (auditoria de usuários)** como exemplo.

### Passo 1: Entender o que a questão pede

Leia o enunciado e transforme em uma **lista de perguntas**, uma por linha:

> "Gerar um relatório a partir de /etc/passwd com o total de contas, os usuários, os usuários com Bash e as contas com nologin."

| # | Pergunta | De onde vem a resposta? |
|---|---|---|
| 1 | Quantas contas existem? | `/etc/passwd` |
| 2 | Quais são os nomes? | `/etc/passwd`, coluna 1 |
| 3 | Quem usa Bash? | `/etc/passwd`, coluna 7 |
| 4 | Quantas têm nologin? | `/etc/passwd`, coluna 7 |

E o resultado vai para onde? Para um arquivo: `~/auditoria-usuarios.txt`.

### Passo 2: Testar cada comando no terminal (antes do script!)

Ache **um comando para cada pergunta** e teste **um por vez**. Só passa para o próximo quando o atual mostrar o que você quer.

```bash
wc -l < /etc/passwd                           # 1 → mostra um número, ex.: 23
cut -d: -f1 /etc/passwd | sort                # 2 → lista de nomes em ordem
grep "/bin/bash$" /etc/passwd | cut -d: -f1   # 3 → root, aluno, ...
grep -c "nologin$" /etc/passwd                # 4 → mostra um número
```

> Se um comando der erro aqui, ele também vai dar erro no script. **Conserte agora**, é mais fácil.
> Não lembra o que um comando faz? `man cut` ou `cut --help` (Aula 04).

### Passo 3: Criar o arquivo do script

Organize num lugar seu (Aula 04) e abra um arquivo novo no editor `nano`:

```bash
mkdir -p ~/scripts
cd ~/scripts
nano auditoria.sh
```

- O nome termina em **`.sh`** (é convenção, ajuda a saber que é script).
- Sem espaço nem acento no nome (Aula 04): `auditoria.sh`, não `Auditoria Usuários.sh`.

> O `nano` abre uma tela de edição. Embaixo aparecem os atalhos: `^O` = **Ctrl+O** (salvar), `^X` = **Ctrl+X** (sair).

### Passo 4: Escrever o script

Digite dentro do nano:

```bash
#!/bin/bash
# Auditoria de usuários a partir de /etc/passwd (Lista I - Q03)

echo "AUDITORIA DE USUARIOS" > ~/auditoria-usuarios.txt

echo "TOTAL DE CONTAS:" >> ~/auditoria-usuarios.txt
wc -l < /etc/passwd >> ~/auditoria-usuarios.txt

echo "USUARIOS ORDENADOS:" >> ~/auditoria-usuarios.txt
cut -d: -f1 /etc/passwd | sort >> ~/auditoria-usuarios.txt

echo "USUARIOS COM BASH:" >> ~/auditoria-usuarios.txt
grep "/bin/bash$" /etc/passwd | cut -d: -f1 >> ~/auditoria-usuarios.txt

echo "TOTAL COM NOLOGIN:" >> ~/auditoria-usuarios.txt
grep -c "nologin$" /etc/passwd >> ~/auditoria-usuarios.txt
```

O que cada parte faz:

| Linha | Para que serve |
|---|---|
| `#!/bin/bash` | **Sempre a 1ª linha** (chama-se *shebang*). Diz: "use o Bash para ler este arquivo". |
| `# texto` | **Comentário**: o Bash ignora. Serve para você (e o professor) entender o script. |
| `echo "TITULO"` | Escreve um **título** no relatório, para ficar legível. |
| `> arquivo` | Na **primeira** escrita: cria o arquivo do zero (apaga o relatório antigo). |
| `>> arquivo` | Em **todas as outras**: acrescenta no final. |
| linha em branco | Só organização. Separe cada bloco "título + comando". |

> 🧩 **O padrão de todo relatório das listas é sempre o mesmo:**
> ```
> echo "TITULO"   >> arquivo
> comando         >> arquivo
> ```
> É só repetir esse par para cada pergunta do Passo 1.

> ⚠️ **O erro nº 1:** usar `>` em todas as linhas. Cada `>` apaga o que veio antes e o relatório termina só com a última informação. **`>` uma vez só, no começo.**

### Passo 5: Salvar e sair do nano

- **Ctrl+O** → aparece `File Name to Write: auditoria.sh` → **Enter** (salvou).
- **Ctrl+X** (saiu, voltou ao terminal).

Confira que o arquivo existe e tem o conteúdo certo:
```bash
ls -l auditoria.sh
cat auditoria.sh
```

### Passo 6: Dar permissão de execução (Aula 10)

Arquivo novo **nasce sem `x`** (a base de arquivo é 666, lembra da umask?):

```bash
ls -l auditoria.sh       # -rw-rw-r--   ← sem x, não executa
chmod u+x auditoria.sh   # dono ganha execução (ou: chmod 755 auditoria.sh)
ls -l auditoria.sh       # -rwxrw-r--   ← agora o dono pode
```

### Passo 7: Rodar

Duas formas:

```bash
./auditoria.sh           # precisa do x do Passo 6. O ./ = "o arquivo daqui deste diretório"
bash auditoria.sh        # funciona mesmo sem x: você manda o Bash ler o arquivo
```

> Por que `./`? Sem ele, o Bash procura o comando só nas pastas do sistema (`/usr/bin`…) e responde `command not found`.

Se o script tiver comandos de administração (`gpasswd`, `chown`, `mkdir /srv/...`), coloque `sudo` **dentro do script**, na frente de cada um desses comandos, como nas questões Q05 e Q10. Assim você roda o script normal e só o necessário usa privilégio (Aula 10: *sudo só quando necessário*).

### Passo 8: Conferir o resultado (a "evidência")

O script não mostrou nada na tela? É normal: tudo foi para o arquivo. Veja:

```bash
cat ~/auditoria-usuarios.txt
```

Compare com o Passo 1: **cada pergunta tem título e resposta?** Se sim, terminou.

> Quer ver na tela **e** gravar ao mesmo tempo? Troque `>> arquivo` por `| tee -a arquivo` (Q09).

---

## 🧯 Deu erro? Tabela de socorro

| Mensagem | Causa | Como resolver |
|---|---|---|
| `bash: ./auditoria.sh: Permission denied` | falta o `x` | `chmod u+x auditoria.sh` (ou rode com `bash auditoria.sh`) |
| `auditoria.sh: command not found` | esqueceu o `./` | `./auditoria.sh` |
| `No such file or directory` ao rodar | você não está na pasta do script | `cd ~/scripts` (confira com `pwd` e `ls`) |
| `cannot execute: required file not found` (ou `/bin/bash^M: bad interpreter`) | o arquivo foi escrito **no Windows** (fim de linha diferente) | escreva no nano da VM, ou converta: `sed -i 's/\r$//' auditoria.sh` |
| Relatório só tem a última informação | usou `>` em vez de `>>` | só a 1ª escrita usa `>` |
| `Permission denied` ao gravar em `/srv` ou `/etc` | `sudo echo ... > arquivo` não funciona | `echo "texto" \| sudo tee arquivo` (Q10) |
| `cut: you must specify a list of...` / resultado estranho | erro de digitação no comando | teste a linha sozinha no terminal (Passo 2) |
| Uma linha falhou, mas o resto rodou | o Bash continua mesmo após erro | leia a mensagem, corrija a linha e rode de novo |

**Para achar a linha com problema:** rode `bash -x auditoria.sh`. O `-x` mostra cada comando (com `+` na frente) antes de executá-lo, então você vê exatamente onde parou.

---

## 📋 Modelo para copiar

Serve para **qualquer** questão de relatório das listas. Troque o que está em MAIÚSCULAS:

```bash
#!/bin/bash
# O QUE ESTE SCRIPT FAZ (Lista X - Qnn)

# --- ações (se a questão pedir para mudar algo; use sudo aqui) ---
# sudo COMANDO_QUE_ALTERA

# --- relatório ---
echo "TITULO DO RELATORIO" > ~/NOME-DO-RELATORIO.txt

echo "PERGUNTA 1:" >> ~/NOME-DO-RELATORIO.txt
COMANDO_1 >> ~/NOME-DO-RELATORIO.txt

echo "PERGUNTA 2:" >> ~/NOME-DO-RELATORIO.txt
COMANDO_2 >> ~/NOME-DO-RELATORIO.txt

# ... repita o par título + comando para cada pergunta

cat ~/NOME-DO-RELATORIO.txt     # mostra o resultado no final
```

> Repare que **ações vêm antes do relatório**: primeiro você muda (cria grupo, ajusta permissão), depois prova que mudou (`id`, `getent`, `ls -ld`). É o ciclo *altere → consulte → confirme* da Aula 09.

### Atalho opcional: guardar o nome do arquivo numa variável

Repetir `~/auditoria-usuarios.txt` em toda linha cansa e facilita erro de digitação. Dá para guardar o nome uma vez (sem espaço em volta do `=`) e usar `"$SAIDA"`:

```bash
SAIDA=~/auditoria-usuarios.txt
echo "AUDITORIA DE USUARIOS" > "$SAIDA"
wc -l < /etc/passwd >> "$SAIDA"
```
Os scripts prontos em [`revisao-listas/scripts/`](revisao-listas/scripts/) usam esse jeito. As duas formas estão certas.

---

## ✍️ Agora você: treino guiado

Use os 8 passos para criar **`auditoria-projeto-web.sh`**, que gera `~/auditoria-projeto-web.txt` provando a configuração da Aula 10.

**Pergunta da questão:** "A pasta `/srv/projeto-web` está certa? Quem é do grupo? A Ana e o Carlos têm acesso?"

<details><summary><b>Dica: a lista do Passo 1</b></summary>

| # | Pergunta | Comando |
|---|---|---|
| 1 | Em que máquina, quando e quem rodou? | `hostname`, `date`, `whoami` |
| 2 | Dono, grupo e permissão da pasta? | `ls -ld /srv/projeto-web` |
| 3 | Quem é membro do grupo? | `getent group projeto-web` |
| 4 | Quais grupos a ana tem? | `id ana` |
| 5 | Quais grupos o carlos tem? | `id carlos` |
</details>

<details><summary><b>Solução</b> (tente antes!)</summary>

```bash
#!/bin/bash
# Auditoria do diretório compartilhado /srv/projeto-web (Aula 10)

echo "AUDITORIA PROJETO WEB" > ~/auditoria-projeto-web.txt

echo "MAQUINA, DATA E USUARIO:" >> ~/auditoria-projeto-web.txt
hostname >> ~/auditoria-projeto-web.txt
date >> ~/auditoria-projeto-web.txt
whoami >> ~/auditoria-projeto-web.txt

echo "DIRETORIO:" >> ~/auditoria-projeto-web.txt
ls -ld /srv/projeto-web >> ~/auditoria-projeto-web.txt

echo "MEMBROS DO GRUPO:" >> ~/auditoria-projeto-web.txt
getent group projeto-web >> ~/auditoria-projeto-web.txt

echo "ANA:" >> ~/auditoria-projeto-web.txt
id ana >> ~/auditoria-projeto-web.txt

echo "CARLOS:" >> ~/auditoria-projeto-web.txt
id carlos >> ~/auditoria-projeto-web.txt

cat ~/auditoria-projeto-web.txt
```

```bash
chmod u+x auditoria-projeto-web.sh
./auditoria-projeto-web.sh
```

**Interpretação para entregar:** `ls -ld` mostra `drwxrwx--- root projeto-web`; o `getent` mostra que ana está no grupo e carlos não. Logo, ana usa o bloco do **grupo** (`rwx`) e carlos cai em **outros** (`---`): só a ana acessa.
</details>

### Mais treinos (mesmo método)

1. **Q01 da Lista II:** relatório de processos (`ps aux | head -n 15`, `ps aux | grep bash`, `ps -p 1`).
2. **Q09 da Lista I:** ficha do servidor (`hostname`, `lscpu`, `free -h`, `lsblk`, `df -h`, `ip -br address`, `cat /etc/os-release`, `uname -r`, `uptime`).
3. **Desafio da Aula 09:** um script que cria os grupos e usuários com `sudo` e depois registra `id` de cada um e `getent group` de cada grupo.

Confira suas versões com as do repositório: [`revisao-listas/scripts/`](revisao-listas/scripts/) e [`aulas/09-usuarios-grupos/laboratorio.sh`](aulas/09-usuarios-grupos/laboratorio.sh).
