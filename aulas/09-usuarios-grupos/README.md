# Encontro 09: Usuários e Grupos no Linux

> Slides: SOA_Encontro_09 (Prof. Diego Pereira)
>
> **Ideia central:** todo processo roda em nome de uma **identidade**. Antes de falar de permissões (Aula 10), é preciso saber **quem** são essas identidades e **como agrupá-las**.

```
processos → serviços → software → usuários → grupos → permissões
```

## 1. Usuário: nome para humanos, número para o sistema

**Conta de usuário** = identidade reconhecida pelo sistema operacional.

```
nome do usuário → UID → identidade usada pelo Linux
     ana        → 1001
```

O nome (`ana`) é amigável. O Linux trabalha com o **número** (**UID**, *User Identifier*).

| Comando | Responde | Exemplo de saída |
|---|---|---|
| `whoami` | quem está usando este terminal? | `aluno` |
| `id` | UID, grupo primário e todos os grupos | `uid=1000(aluno) gid=1000(aluno) groups=1000(aluno),27(sudo)` |
| `id ana` | o mesmo, para outro usuário | |
| `groups` / `groups ana` | só os nomes dos grupos | `ana : ana desenvolvimento` |

Lendo a saída do `id`:
```
uid=1000(aluno)  gid=1000(aluno)  groups=1000(aluno),27(sudo)
└─ quem é        └─ grupo primário └─ todos os grupos (primário + suplementares)
```

> O **prompt** (`aluno@server-soa:~$`) ajuda, mas quem **confirma** a identidade é o comando.

## 2. root, usuário comum e contas de serviço

| Tipo | UID | Para quê |
|---|---|---|
| **root** | **0** | administrador; privilégio total |
| **Usuário comum** | normalmente **1000+** | atividades do dia a dia, privilégio limitado |
| **Conta de serviço** | normalmente **1 a 999** (`daemon`, `www-data`, `nobody` = 65534) | um serviço roda com conta própria → **isolamento** |

- Prática segura: trabalhar como usuário comum e usar `sudo` **só quando necessário**.
- Contas de serviço costumam ter shell `/usr/sbin/nologin`: **não devem ter login interativo**.
- Em `ps aux`, a 1ª coluna (`USER`) mostra a identidade de cada processo: `usuário → executa → processo → permissões`.

## 3. Os três arquivos de contas

### `/etc/passwd`: informações gerais (todo mundo pode ler)

```
ana:x:1001:1001:Ana:/home/ana:/bin/bash
 │  │  │    │    │      │         └─ SHELL (interpretador)
 │  │  │    │    │      └─ HOME (diretório pessoal)
 │  │  │    │    └─ GECOS (nome completo/comentário; pode ficar vazio)
 │  │  │    └─ GID do grupo PRIMÁRIO
 │  │  └─ UID
 │  └─ x = a senha NÃO está aqui, está em /etc/shadow
 └─ nome da conta
```
Formato: `usuario:x:UID:GID:GECOS:HOME:SHELL` (7 campos separados por `:`).

### `/etc/shadow`: dados sensíveis de senha (só root lê)

```bash
sudo head /etc/shadow
ana:$y$j9T$...:19740:0:99999:7:::
```
A senha da Ana **não é a letra x**. O `x` indica que o hash da senha fica em `/etc/shadow`, que usuário comum não consegue ler.

### `/etc/group`: grupos e membros

```
desenvolvimento:x:1003:ana,bruno
      │         │  │      └─ membros SUPLEMENTARES (separados por vírgula)
      │         │  └─ GID
      │         └─ x (senha de grupo, raramente usada)
      └─ nome do grupo
```
Formato: `grupo:x:GID:membros`.

> ⚠️ Não edite esses arquivos à mão em laboratório. Use `useradd`, `usermod`, `groupadd`, `gpasswd`…

### Consultando: `grep` × `getent`

```bash
grep "^ana:" /etc/passwd       # procura no arquivo (^ = começo da linha)
getent passwd ana              # consulta a base de contas configurada no sistema
getent group sudo              # o mesmo para grupos
```
Para contas locais, os dois funcionam. `getent` é mais geral (também enxerga contas vindas de rede, como LDAP).

## 4. Grupo primário × grupos suplementares

**Grupo** = identidade coletiva que reúne usuários. Em vez de dar acesso pessoa por pessoa, dá-se ao grupo.

| | **Grupo primário** | **Grupos suplementares** |
|---|---|---|
| Quantos | **exatamente 1** por usuário | 0 ou vários |
| Onde fica | campo GID do `/etc/passwd` | lista de membros do `/etc/group` |
| Para quê | vira o grupo dos arquivos que o usuário cria | dar acesso extra (equipes, projetos) |
| Padrão no Debian | um grupo com o mesmo nome do usuário (`ana`) | nenhum |
| Alterar com | `usermod -g grupo usuario` | `gpasswd -a` / `usermod -aG` |

```
$ id ana
uid=1001(ana) gid=1001(ana) groups=1001(ana),1003(desenvolvimento),1004(projeto-web)
             └ primário: ana └ suplementares: desenvolvimento, projeto-web
```

## 5. Criando e removendo

### Grupos

```bash
sudo groupadd desenvolvimento
getent group desenvolvimento      # desenvolvimento:x:1003:   (sem membros ainda)
sudo groupdel desenvolvimento     # verifique antes se ainda é usado!
```

### Usuários

```bash
sudo useradd -m -s /bin/bash ana   # -m cria o /home/ana · -s define o shell
sudo passwd ana                     # define a senha (não aparece enquanto digita: é normal)
getent passwd ana                   # ana:x:1001:1001::/home/ana:/bin/bash
ls -ld /home/ana                    # confere que o home existe
```

> Sem `-m`, o `useradd` do Debian **não cria** o home. Sem `-s /bin/bash`, o shell fica `/bin/sh`.
> (Existe também o `adduser`, interativo, do Debian. A aula usa `useradd`.)

**Removendo usuário:**
```bash
sudo userdel bruno        # remove a conta, MAS mantém /home/bruno
sudo userdel -r bruno     # remove a conta E o home (e o spool de e-mail)
```
"userdel sempre remove /home" é **falso**: só com `-r`.

## 6. `gpasswd`: colocar e tirar gente do grupo

```bash
sudo gpasswd -a ana desenvolvimento   # -a = add    → Adding user ana to group desenvolvimento
sudo gpasswd -d ana desenvolvimento   # -d = delete → Removing user ana from group desenvolvimento
```
Ordem: `gpasswd -a USUÁRIO GRUPO` (usuário primeiro).

Ciclo administrativo: **altere → consulte → confirme.**
```bash
sudo groupadd projeto-web
sudo gpasswd -a ana projeto-web
getent group projeto-web     # projeto-web:x:1004:ana
sudo gpasswd -d ana projeto-web
getent group projeto-web     # projeto-web:x:1004:
```

### `gpasswd` × `usermod`

| | `gpasswd` | `usermod` |
|---|---|---|
| Foco | no **grupo** | na **conta** do usuário |
| Adicionar ao grupo | `gpasswd -a ana grupo` | `usermod -aG grupo ana` |
| Remover do grupo | `gpasswd -d ana grupo` | (não tem opção direta) |
| Outros usos | | mudar shell (`-s`), grupo primário (`-g`) |

> ⚠️ **Cuidado com `usermod -G` sem `-a`**: ele **substitui** toda a lista de grupos suplementares. `usermod -G desenvolvimento ana` tira a Ana de `projeto-web`, `sudo` etc. Sempre `-aG` (a = *append*, acrescentar).
>
> Atenção também à ordem: `usermod -aG GRUPO USUÁRIO` (grupo primeiro), ao contrário do `gpasswd`.

### Verificando

| Comando | Pergunta respondida |
|---|---|
| `id ana` / `groups ana` | **de quais grupos a Ana participa?** (visão do usuário) |
| `getent group projeto-web` | **quem é membro do projeto-web?** (visão do grupo) |

> 💡 **Pegadinha prática (não está no slide):** depois de entrar num grupo, o usuário precisa **sair e logar de novo** para a sessão dele "enxergar" o grupo novo. Se a Ana já estava logada, `id` (sem nome) na sessão dela ainda mostra os grupos antigos; `id ana` já mostra o novo.

## 7. Erros conceituais comuns

| Afirmação | Verdade |
|---|---|
| "/etc/passwd contém as senhas" | **Falso**: o `x` aponta para `/etc/shadow` (hash, não texto). |
| "`-g` e `-G` são iguais" | **Falso**: `-g` = primário; `-G` = suplementares. |
| "`usermod -G` sempre adiciona" | **Perigoso**: sem `-a`, substitui. |
| "`userdel` sempre remove /home" | **Falso**: só com `-r`. |
| "Grupo é só uma lista de nomes" | **Incompleto**: grupo tem **GID**. |

## 8. Síntese

| Necessidade | Ferramenta |
|---|---|
| Usuário atual | `whoami` |
| UID/GID/grupos | `id` |
| Grupos do usuário | `groups` |
| Consultar usuário/grupo | `getent passwd` / `getent group` |
| Criar/remover usuário | `useradd -m -s /bin/bash` / `userdel [-r]` |
| Definir senha | `passwd` |
| Criar/remover grupo | `groupadd` / `groupdel` |
| Adicionar/remover membro | `gpasswd -a` / `gpasswd -d` |
| Alterar conta | `usermod` |

```
Usuário → UID · Grupo → GID · Associação → gpasswd · Verificação → id/groups/getent · Permissão → Aula 10
```

---

## 🧪 Prática guiada (slides 27–28)

```
desenvolvimento: ana, bruno
suporte:         carlos
projeto-web:     ana, carlos
```

<details><summary><b>Solução</b></summary>

```bash
sudo groupadd desenvolvimento
sudo groupadd suporte
sudo groupadd projeto-web

sudo useradd -m -s /bin/bash ana
sudo useradd -m -s /bin/bash bruno
sudo useradd -m -s /bin/bash carlos
sudo passwd ana          # repita para bruno e carlos se for logar com eles

sudo gpasswd -a ana desenvolvimento
sudo gpasswd -a ana projeto-web
sudo gpasswd -a bruno desenvolvimento
sudo gpasswd -a carlos suporte
sudo gpasswd -a carlos projeto-web

# verificação obrigatória
id ana ; id bruno ; id carlos
getent group projeto-web    # projeto-web:x:....:ana,carlos
```
</details>

### Exercício rápido (slide 29)

Bruno entrou no Projeto Web e Carlos saiu. Quais comandos?

<details><summary><b>Solução</b></summary>

```bash
sudo gpasswd -a bruno projeto-web
sudo gpasswd -d carlos projeto-web
getent group projeto-web    # projeto-web:x:....:ana,bruno
```
> Esse é o estado usado na Aula 10: **ana e bruno** em `projeto-web`, **carlos fora**.
</details>

## 🧭 Desafio final (slide 30)

```
Ana     → Desenvolvimento, Portal Web
Bruno   → Desenvolvimento
Carlos  → Suporte, Portal Web
Daniela → Suporte
```
Requisitos: criar grupos e usuários (com `/bin/bash`), definir senhas, usar `gpasswd`, **remover temporariamente um usuário de um grupo e adicioná-lo de novo**, apresentar UID, GID, HOME, SHELL e grupos.
**Entrega:** tabela de usuários + comandos utilizados + verificação com `id`/`groups`/`getent`.

<details><summary><b>Solução</b></summary>

Nomes de grupo sem espaço nem acento: `desenvolvimento`, `suporte`, `portal-web`.

```bash
# 1. grupos
sudo groupadd desenvolvimento      # se já existir da prática, dá erro "already exists": tudo bem
sudo groupadd suporte
sudo groupadd portal-web

# 2. usuários
for u in ana bruno carlos daniela; do sudo useradd -m -s /bin/bash "$u"; done

# 3. senhas (uma por vez, interativo)
sudo passwd ana ; sudo passwd bruno ; sudo passwd carlos ; sudo passwd daniela

# 4. grupos suplementares
sudo gpasswd -a ana desenvolvimento
sudo gpasswd -a ana portal-web
sudo gpasswd -a bruno desenvolvimento
sudo gpasswd -a carlos suporte
sudo gpasswd -a carlos portal-web
sudo gpasswd -a daniela suporte

# 5. remover temporariamente e readicionar (ex.: carlos)
sudo gpasswd -d carlos portal-web
getent group portal-web             # carlos sumiu
sudo gpasswd -a carlos portal-web
getent group portal-web             # carlos voltou

# 6. evidências
for u in ana bruno carlos daniela; do getent passwd "$u"; id "$u"; done
getent group desenvolvimento suporte portal-web
```

Tabela de entrega (os números **mudam** de máquina para máquina; copie os da sua):

| Usuário | UID | GID primário | HOME | SHELL | Grupos suplementares |
|---|---|---|---|---|---|
| ana | 1001 | 1001 (ana) | /home/ana | /bin/bash | desenvolvimento, portal-web |
| bruno | 1002 | 1002 (bruno) | /home/bruno | /bin/bash | desenvolvimento |
| carlos | 1003 | 1003 (carlos) | /home/carlos | /bin/bash | suporte, portal-web |
| daniela | 1004 | 1004 (daniela) | /home/daniela | /bin/bash | suporte |

O script [`laboratorio.sh`](laboratorio.sh) faz tudo isso (menos as senhas) e gera a tabela automaticamente.
</details>

## ✅ Interpretando saídas (slide 31)

1. `uid=1001(ana) gid=1001(ana) groups=1001(ana),1003(desenvolvimento),1004(projeto-web)`: UID? grupo primário? suplementares?
2. `bruno:x:1002:1005:Bruno:/home/bruno:/bin/bash`: conta, UID, GID primário, HOME, SHELL?

<details><summary><b>Respostas</b></summary>

1. UID **1001**; primário **ana**; suplementares **desenvolvimento** e **projeto-web**.
2. Conta **bruno**; UID **1002**; GID primário **1005**; HOME **/home/bruno**; SHELL **/bin/bash**.
</details>

---

## Exercícios extras

1. Qual o UID do root? Por que ele é especial?
2. Em `www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin`, essa conta é de uma pessoa? Ela consegue logar?
3. Um usuário comum roda `cat /etc/shadow`. O que acontece? Por quê?
4. Como listar **só os nomes** de todas as contas do sistema?
5. Ana está em `desenvolvimento` e `projeto-web`. Alguém roda `sudo usermod -G suporte ana`. Quais grupos suplementares ela tem agora?
6. Qual a diferença entre `id ana` e `getent group projeto-web`?
7. Você criou `sudo useradd joao` (sem opções). Que problema vai notar?
8. Você adicionou a Ana ao `projeto-web`, mas na sessão dela `id` não mostra o grupo. Por quê? O que fazer?
9. Qual comando remove o usuário `teste` **e** a pasta pessoal dele?
10. Qual a diferença entre `usermod -g dev ana` e `usermod -aG dev ana`?

<details><summary><b>Respostas</b></summary>

1. **0**. O Linux trata UID 0 como administrador: ele passa por cima das permissões normais.
2. Não, é uma **conta de serviço** (servidor web). Shell `nologin` → **não tem login interativo**.
3. `Permission denied`: `/etc/shadow` guarda os hashes das senhas e só o root lê. Precisa de `sudo`.
4. `cut -d: -f1 /etc/passwd` (campo 1, separador `:`).
5. **Só `suporte`**: `-G` sem `-a` **substituiu** a lista. O certo seria `usermod -aG suporte ana`.
6. `id ana` parte do **usuário** (todos os grupos dela). `getent group projeto-web` parte do **grupo** (todos os membros dele).
7. Sem `-m` o `/home/joao` **não é criado**; sem `-s` o shell fica `/bin/sh`. Também está sem senha. Corrija com `sudo usermod -s /bin/bash joao`, `sudo mkdir /home/joao && sudo chown joao:joao /home/joao` (ou remova e recrie com `-m -s /bin/bash`) e `sudo passwd joao`.
8. A sessão carrega os grupos **no login**. Ela precisa sair (`exit`) e entrar de novo (ou `newgrp projeto-web`, `su - ana`).
9. `sudo userdel -r teste`
10. `-g dev` muda o grupo **primário** para `dev`. `-aG dev` **acrescenta** `dev` como suplementar, sem mexer no resto.
</details>

> 📝 **Observação sobre os slides:** os números de UID/GID variam entre slides (ex.: `desenvolvimento` aparece com GID 1002 e 1003; no slide 18 a Ana tem GID 1002, nos outros 1001). Não é erro de conceito: **cada máquina gera números próprios** conforme a ordem de criação. Na prova, leia os números que a questão der.
