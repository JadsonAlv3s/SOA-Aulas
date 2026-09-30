# Encontro 04: Terminal e Sistema de Arquivos I

> Slides: SOA_Encontro_04 (Prof. Diego Pereira)
>
> **Ideia central:** no Linux, tudo começa em `/`, e todo comando é executado a partir de um **diretório atual**.

## 1. Raiz, diretório atual e home

| Conceito | O que é | Símbolo / comando |
|---|---|---|
| **Raiz** | ponto de partida de **toda** a árvore (no Windows cada unidade é uma raiz: `C:\`, `D:\`) | `/` |
| **Diretório atual** (de trabalho) | onde a sessão do shell está **agora**; muitos comandos usam esse lugar como referência | `.` / `pwd` |
| **Home** | diretório pessoal do usuário (`/home/aluno`) | `~` / `$HOME` |

## 2. Navegação: `pwd`, `ls`, `cd`

### `pwd`: Print Working Directory

Não "abre uma pasta": **imprime** o caminho completo do diretório atual. *Perdido? Pergunte primeiro: onde estou?*

### `ls`: lista conteúdo

```bash
ls            # conteúdo do diretório atual
ls /          # conteúdo da raiz, sem precisar entrar nela
ls /etc       # qualquer caminho
```

| Opção | Efeito |
|---|---|
| `-l` | listagem **longa**: permissões, nº de links, dono, grupo, tamanho, data, nome |
| `-a` | inclui **ocultos** (nomes que começam com `.`), inclusive `.` e `..` |
| `-la` | as duas coisas juntas |

```
drwxr-xr-x 3 aluno aluno 4096 set 02 .
drwxr-xr-x 4 root  root  4096 set 02 ..
-rw-r--r-- 1 aluno aluno 3526 set 02 .bashrc
│└──┬────┘   └─dono└─grupo tamanho  data  nome
│ permissões (vistas em aula própria)
└─ tipo: d = diretório, - = arquivo comum
```

### Arquivos ocultos

Nomes começando com `.` somem do `ls` simples. São muito usados para **configuração do usuário e de ferramentas**: `.bashrc`, `.profile`, `.ssh`.

### `cd`: muda o diretório atual

Depois de mudar, confirme com `pwd`.

## 3. Símbolos essenciais

| Símbolo | Significado | Exemplo |
|---|---|---|
| `/` | raiz | `cd /` |
| `.` | diretório atual | `cd .` (fica onde está) |
| `..` | diretório **superior** (pai) | `cd ..` / `cd ../..` (sobe 2) |
| `~` | home do usuário | `cd ~` (ou apenas `cd`) |
| `-` | diretório **anterior** | `cd -` (alterna entre os dois últimos) |

## 4. Caminho absoluto × relativo

| | **Absoluto** | **Relativo** |
|---|---|---|
| Começa com | `/` | qualquer outra coisa (nome, `.`, `..`) |
| Referência | a raiz | o **diretório atual** |
| Funciona de qualquer lugar? | **Sim** | Não, depende de onde você está |
| Exemplo | `/home/aluno/projetos/linux` | `projetos/linux` (estando em `/home/aluno`) |

> ~ (ex.: `~/soa/documentos`) é um atalho que o shell **expande** para `/home/aluno/soa/documentos`, ou seja, vira um caminho absoluto.

**Desafio do slide:** você está em `/home/aluno/soa/projetos/servidor-web/scripts` e quer ir para `/home/aluno/soa/documentos`.

```
scripts → .. → servidor-web → ../.. → projetos → ../../.. → soa → documentos
```
- Relativo: `cd ../../../documentos`
- Com home: `cd ~/soa/documentos`
- Absoluto: `cd /home/aluno/soa/documentos`

## 5. Criando: `mkdir` e `touch`

```bash
mkdir aula04                         # cria um diretório
mkdir documentos scripts backups     # vários de uma vez
mkdir -p projetos/linux/scripts      # -p cria os intermediários (3 níveis num comando)
touch README.txt                     # cria arquivo VAZIO
touch comandos.txt notas.txt teste.log
```

- **Sem `-p`**, o `mkdir` **falha** se algum diretório intermediário não existir (`No such file or directory`).
- **Com `-p`**, cria tudo o que faltar e **não dá erro** se já existir. Ótimo para scripts.
- `touch` no uso real **atualiza a data de acesso/modificação**; se o arquivo não existir, cria vazio.
- `tree projetos` mostra a árvore (em Debian mínimo, pode ser preciso `sudo apt install tree`).

## 6. Removendo com segurança: `rmdir`

```bash
mkdir teste && rmdir teste      # ok: estava vazio
mkdir teste && touch teste/arquivo.txt
rmdir teste
# rmdir: failed to remove 'teste': Directory not empty
```

`rmdir` só remove diretório **vazio**. Isso é uma **barreira de segurança** contra remoções acidentais. (Apagar com conteúdo, `rm -r`, fica para a Aula 05.)

## 7. Nomes importam

- **Sensível a maiúsculas/minúsculas:** `Documentos ≠ documentos`.
  > ⚠️ Se você treinar no Git Bash ou no WSL em pasta do Windows, `cd Documentos` pode funcionar, porque o NTFS não diferencia maiúsculas e minúsculas. No Debian (ext4) **falha**. Treine na VM.
- **Espaços** exigem aspas ou escape: `cd "projeto linux"` ou `cd projeto\ linux`. Sem isso, `cd projeto linux` recebe **dois argumentos** e dá erro.
- **Convenção recomendada:** `projeto-linux`, `servidor_web`, `aula04`, `backup01` (sem espaço, sem acento, minúsculas).

## 8. Ajuda: `man` e `--help`

```bash
man ls        man mkdir       # manual (↑↓ navegar, / pesquisar, q sair)
ls --help     mkdir --help    # resumo rápido
```

*Meta da disciplina: não decorar opções, mas saber descobrir, interpretar e aplicar.*

## 9. Erros comuns

| Comando | Erro | Causa | Correção |
|---|---|---|---|
| `cd Documentos` | No such file or directory | o diretório é `documentos` | respeitar a caixa |
| `cd projeto linux` | too many arguments | espaço não tratado | `cd "projeto linux"` |
| `rmdir teste` | Directory not empty | há conteúdo dentro | esvaziar antes (ou `rm -r` na Aula 05) |
| `mkdir a/b/c` | No such file or directory | `a` ou `a/b` não existem | `mkdir -p a/b/c` |

*Errar faz parte: leia a mensagem, verifique o contexto (`pwd`, `ls`) e corrija.*

---

## 🧪 Laboratório principal: `~/soa`

Crie **sem interface gráfica**, usando só `pwd`, `ls`, `cd`, `mkdir` e `touch`:

```
~/soa/
├── aulas/
│   ├── aula01/
│   ├── aula02/
│   ├── aula03/
│   └── aula04/
├── projetos/
│   └── servidor-web/
│       ├── configuracoes/
│       ├── logs/
│       └── scripts/
├── backups/
└── documentos/
```
Arquivos: `README.txt`, `comandos.txt`, `notas.txt`, `backup.log`.

<details><summary><b>Solução</b> (tente antes!)</summary>

Forma "passo a passo", do jeito da aula:
```bash
cd ~
mkdir soa
cd soa
mkdir aulas projetos backups documentos
cd aulas
mkdir aula01 aula02 aula03 aula04
cd ../projetos
mkdir servidor-web
cd servidor-web
mkdir configuracoes logs scripts
cd ~/soa
touch README.txt documentos/comandos.txt documentos/notas.txt backups/backup.log
ls -R
```

Forma compacta com `-p` (útil em script):
```bash
mkdir -p ~/soa/aulas/aula0{1,2,3,4} \
         ~/soa/projetos/servidor-web/{configuracoes,logs,scripts} \
         ~/soa/backups ~/soa/documentos
```
`{1,2,3,4}` é a **expansão de chaves** do Bash: vira `aula01 aula02 aula03 aula04`.

> O slide não diz onde cada arquivo fica. Uma escolha lógica: `README.txt` na raiz do projeto, `backup.log` em `backups/`, `comandos.txt` e `notas.txt` em `documentos/`. O script [`laboratorio.sh`](laboratorio.sh) cria tudo e confere.
</details>

## 🧭 Desafio sem roteiro

Depois de criar `~/soa`: **1.** vá para `/etc` · **2.** volte ao home · **3.** entre em `~/soa/projetos/servidor-web` · **4.** suba dois níveis · **5.** liste arquivos ocultos · **6.** descubra seu diretório atual.

<details><summary><b>Solução</b></summary>

```bash
cd /etc                          # 1
cd ~        # ou só: cd          # 2
cd ~/soa/projetos/servidor-web   # 3
cd ../..                         # 4 → agora em ~/soa
ls -a                            # 5
pwd                              # 6 → /home/aluno/soa
```
</details>

## ✅ Atividade de consolidação

1. Qual é seu diretório atual? · 2. Qual é seu diretório home? · 3. Como listar arquivos ocultos? · 4. O que significa `..`? · 5. O que representa `~`? · 6. Como criar três níveis em um comando? · 7. Como criar arquivo vazio? · 8. Por que `rmdir` pode falhar?

<details><summary><b>Respostas</b></summary>

1. `pwd`
2. `echo $HOME` (ou `cd ~; pwd`) → `/home/<usuario>`
3. `ls -a` (ou `ls -la`)
4. O diretório **superior** (pai) do atual.
5. O **home** do usuário atual.
6. `mkdir -p nivel1/nivel2/nivel3`
7. `touch arquivo.txt`
8. Porque o diretório **não está vazio** (`rmdir` só remove diretórios vazios). Também falha se o diretório não existir ou se faltar permissão.
</details>

---

## Exercícios extras (treino de caminhos)

Considere a árvore do laboratório com o usuário `aluno`. Responda **sem executar** e depois confira no terminal.

1. Você está em `/home/aluno/soa/aulas/aula03`. Qual o caminho **relativo** para `/home/aluno/soa/aulas/aula04`?
2. Você está em `/home/aluno/soa/projetos/servidor-web/logs`. Qual o relativo para `.../servidor-web/scripts`?
3. Você está em `/etc`. Rode `cd soa`. O que acontece? Por quê?
4. Você está em `/home/aluno/soa/backups`. Após `cd ../projetos/servidor-web/..`, onde você está?
5. Você está em `/home/aluno/soa`. Rode `cd /etc` e depois `cd -`. Onde você está?
6. Classifique como absoluto (A) ou relativo (R): `/var/log` · `../documentos` · `soa/aulas` · `./scripts` · `/` · `~/soa` (este último: o que o shell faz com ele?)
7. `mkdir soa/novo/dir` falhou com "No such file or directory". Dê duas formas de corrigir.
8. Como criar a pasta `meus projetos` (com espaço) e entrar nela? Qual nome seria melhor?
9. Crie `~/treino/{a,b,c}`, coloque um arquivo em `b` e tente `rmdir` em `a`, `b` e `c`. Quais funcionam?
10. Em `ls -la`, o que são as duas primeiras linhas (`.` e `..`)?

<details><summary><b>Respostas</b></summary>

1. `../aula04`
2. `../scripts`
3. Erro `No such file or directory`: `soa` é **relativo** e não existe dentro de `/etc`. O certo é `cd ~/soa` (ou o absoluto).
4. `/home/aluno/soa/projetos` (entrou em `servidor-web` e subiu um nível).
5. Em `/home/aluno/soa`: `cd -` volta ao diretório **anterior** (e imprime o caminho).
6. `/var/log` A · `../documentos` R · `soa/aulas` R · `./scripts` R · `/` A · `~/soa` o shell **expande** para `/home/aluno/soa`, que funciona de qualquer lugar (efeito de absoluto).
7. `mkdir -p soa/novo/dir`, ou criar nível por nível: `mkdir soa/novo` e depois `mkdir soa/novo/dir`.
8. `mkdir "meus projetos"` e `cd "meus projetos"` (ou `meus\ projetos`). Melhor: `meus-projetos` ou `meus_projetos`.
9. `mkdir -p ~/treino/{a,b,c}; touch ~/treino/b/x.txt; rmdir ~/treino/a ~/treino/b ~/treino/c`. Removem `a` e `c`; `b` falha (**Directory not empty**).
10. `.` é o próprio diretório atual; `..` é o diretório pai.
</details>
