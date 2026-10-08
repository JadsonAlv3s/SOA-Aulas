# Encontro 10: Permissões e Controle de Acesso

> Slides: SOA_Encontro_10 (Prof. Diego Pereira)
>
> **Ideia central:** **interpretar antes de modificar.** Pertencer a um grupo **não garante** acesso: o recurso também precisa **conceder** permissão a esse grupo.

```
Aula 09: usuários e grupos  →  Aula 10: permissões  →  controle de acesso
```

## 1. O modelo: 3 categorias × 3 permissões

| Quem | Letra | | O quê | Letra |
|---|---|---|---|---|
| **dono** (user) | `u` | | **ler** (read) | `r` |
| **grupo** (group) | `g` | | **escrever** (write) | `w` |
| **outros** (others) | `o` | | **executar / atravessar** (execute) | `x` |
| todos (all) | `a` | | | |

Todo arquivo tem **um dono** e **um grupo**. Quem não é nenhum dos dois cai em **outros**.

### Como o Linux decide qual bloco vale para você

```
Você é o dono?            → sim → usa o bloco do DONO   (e para por aqui)
Não. Está no grupo dele?  → sim → usa o bloco do GRUPO  (e para por aqui)
Não.                              → usa o bloco de OUTROS
```
Só **um** bloco vale, o primeiro que casar. (O root, UID 0, passa por cima dessa regra.)

## 2. Lendo o `ls -l`

```
-rw-r--r-- 1 aluno aluno 0 out 1 10:30 relatorio.txt
│└┬┘└┬┘└┬┘   └dono └grupo
│ │  │  └ outros: r--
│ │  └ grupo:  r--
│ └ dono:     rw-
└ tipo: - arquivo comum · d diretório
```

- Os **10 primeiros caracteres** = 1 de tipo + 3 blocos de 3.
- `ls -l arquivo` mostra o arquivo; `ls -ld diretorio` mostra **o próprio diretório** (sem o `-d`, mostraria o conteúdo dele).

## 3. `r w x` mudam de sentido em diretórios

| | **Arquivo** | **Diretório** |
|---|---|---|
| `r` | ler o conteúdo (`cat`) | **listar** os nomes (`ls`) |
| `w` | alterar o conteúdo | **criar, remover, renomear** entradas dentro dele |
| `x` | executar (`./script.sh`) | **atravessar/entrar** (`cd`, acessar o que está dentro) |

> Em diretório, `x` **não** é "executar o diretório". É a **chave da porta**: sem ela você não entra nem chega aos arquivos lá dentro, mesmo que eles tenham permissão.

Para abrir `/srv/projeto-web/relatorio.txt` você precisa de `x` em `/`, em `/srv` e em `/srv/projeto-web`, **e** de `r` no arquivo.

**Pegadinha:** `drwxr-----` → o grupo tem `r` mas **não** tem `x`: consegue ver os nomes (com erros), mas não entra nem abre nada. **Diretório quase sempre precisa de `r` e `x` juntos.**

> 💡 Apagar um arquivo depende do `w` do **diretório**, não do arquivo.

### Exemplos de interpretação

```
-rw-r----- 1 ana projeto-web 2048 out 1 10:00 dados.txt
```
Ana lê e escreve · membros de `projeto-web` só leem · outros, nada.

```
drwxrwx--- 2 root projeto-web 4096 out 1 10:00 projeto-web
```
root e membros de `projeto-web` entram, listam, criam e apagam · outros, nada.

## 4. `chmod`: alterar permissões

### Modo simbólico: `quem` `operação` `permissão`

| Quem | Operação | Permissão |
|---|---|---|
| `u` `g` `o` `a` | `+` adiciona · `-` remove · `=` define exatamente | `r` `w` `x` |

```bash
chmod u+x script.sh            # dono ganha execução
chmod g+w relatorio.txt        # grupo ganha escrita
chmod o-r documento.txt        # outros perdem leitura
chmod u=rw,g=r,o= doc.txt      # exatamente: rw- r-- ---  (o= → nada para outros)
```
`+`/`-` mexem só no que você citou. `=` zera o bloco e coloca exatamente o que você pediu.

### Modo octal: some `r=4`, `w=2`, `x=1`

| Nº | Permissão | Conta |
|---|---|---|
| 0 | `---` | |
| 1 | `--x` | 1 |
| 2 | `-w-` | 2 |
| 3 | `-wx` | 2+1 |
| 4 | `r--` | 4 |
| 5 | `r-x` | 4+1 |
| 6 | `rw-` | 4+2 |
| 7 | `rwx` | 4+2+1 |

Três dígitos = **dono, grupo, outros**, nessa ordem.

| Octal | Simbólico | Uso típico |
|---|---|---|
| **600** | `rw-------` | arquivo privado (só o dono) |
| **640** | `rw-r-----` | configuração: dono escreve, grupo lê |
| **644** | `rw-r--r--` | arquivo "público" (todos leem) |
| **750** | `rwxr-x---` | script: dono roda/edita, grupo roda |
| **755** | `rwxr-xr-x` | script/diretório que todos usam |
| **770** | `rwxrwx---` | diretório de equipe |
| ~~777~~ | `rwxrwxrwx` | **evite**: qualquer um faz tudo |

`chmod u=rw,g=r,o= arquivo` **≡** `chmod 640 arquivo` → `-rw-r-----`.

**Truque para converter na prova:** quebre em blocos de 3 e some.
`rwx r-x ---` → `4+2+1 | 4+0+1 | 0` → **750**.

## 5. `chown` e `chgrp`: alterar dono e grupo

```bash
sudo chgrp projeto-web relatorio.txt          # muda só o grupo
sudo chown ana relatorio.txt                  # muda só o dono
sudo chown ana:projeto-web relatorio.txt      # muda dono e grupo de uma vez
```
Mudar dono exige `sudo`. (O dono pode fazer `chgrp` para um grupo do qual ele mesmo participa.)

| Comando | Mexe em |
|---|---|
| `chmod` | **permissões** (`rwx`) |
| `chown` | **dono** (e opcionalmente grupo) |
| `chgrp` | **grupo** |

> Não confunda **propriedade** (de quem é) com **permissão** (o que cada um pode fazer).

## 6. Cenário completo: `/srv/projeto-web`

```bash
sudo mkdir -p /srv/projeto-web
sudo chown root:projeto-web /srv/projeto-web
sudo chmod 770 /srv/projeto-web
ls -ld /srv/projeto-web
# drwxrwx--- 2 root projeto-web 4096 ... /srv/projeto-web
```

Estado dos grupos (fim da Aula 09): **ana e bruno** em `projeto-web`, **carlos fora**.

| Usuário | Bloco aplicado | Acesso |
|---|---|---|
| ana | grupo (`rwx`) | ✅ entra, lista, cria |
| bruno | grupo (`rwx`) | ✅ entra, lista, cria |
| carlos | outros (`---`) | ❌ Permission denied |

**Diagnóstico:** compare `id ana` (grupos dela) com `ls -ld /srv/projeto-web` (grupo do diretório e o que ele concede).

## 7. *Permission denied*: investigue antes do `sudo`

```
whoami → id → ls -l arquivo / ls -ld diretório → interpretar → corrigir o mínimo
```
1. **Quem sou?** `whoami`
2. **Em que grupos estou?** `id`
3. **De quem é o recurso e o que ele concede?** `ls -l` / `ls -ld` (inclusive dos diretórios do caminho)
4. **Qual bloco vale para mim?** (dono → grupo → outros)
5. **Corrija só o necessário:** pôr o usuário no grupo, ou ajustar grupo/permissão do recurso.

> ❌ `chmod 777` "resolve" abrindo para **todo mundo**: é tapar o problema com um risco maior.
> ❌ `sudo` como reflexo esconde a causa. `sudo` é para **ação administrativa autorizada**, não para "fazer o erro sumir".

## 8. `umask`: permissões padrão de arquivos novos

Todo arquivo nasce a partir de uma **base**, e a `umask` **tira** permissões dela:

| | Base | `umask 022` | `umask 027` |
|---|---|---|---|
| Arquivo | 666 (`rw-rw-rw-`) | **644** | **640** |
| Diretório | 777 (`rwxrwxrwx`) | **755** | **750** |

```bash
umask            # mostra a atual (ex.: 0022)
umask 027        # vale só para esta sessão do shell
touch teste.txt && mkdir teste-dir
ls -l teste.txt ; ls -ld teste-dir     # -rw-r----- e drwxr-x---
```
- Arquivo **nunca** nasce com `x` (base 666): por isso script precisa de `chmod +x`.
- Parece subtração (666 − 027 → 640), mas é uma **máscara de bits**: cada bit ligado na umask **desliga** aquela permissão. Ex.: `umask 077` em arquivo → 600 (não "-11").

## 9. Erros comuns

| Mito | Verdade |
|---|---|
| "rwx tem sempre o mesmo significado" | Muda entre arquivo e diretório. |
| "chmod muda o dono" | Muda **permissões**. Dono é `chown`. |
| "chown muda permissões" | Muda **dono/grupo**. |
| "Pertencer ao grupo garante acesso" | O recurso precisa ser **daquele grupo** e **conceder** permissão a ele. |
| "777 resolve qualquer problema" | Abre para todos: inseguro. |
| "sudo é a primeira solução" | Primeiro diagnosticar. |

## 10. Quadro-síntese

| Necessidade | Comando |
|---|---|
| Ver permissões de arquivo | `ls -l` |
| Ver permissões de diretório | `ls -ld` |
| Alterar permissões | `chmod` |
| Alterar dono | `chown` |
| Alterar grupo | `chgrp` |
| Identificar usuário/grupos | `id` / `groups` |
| Permissões padrão | `umask` |
| Ação administrativa | `sudo` |

---

## 🧪 Prática guiada 1: arquivos (slide 32)

Em `~/aula10`, crie `publico.txt`, `privado.txt`, `compartilhado.txt` e `script.sh` e deixe: `publico.txt` → 644, `privado.txt` → 600, `script.sh` → 755.

<details><summary><b>Solução</b></summary>

```bash
mkdir ~/aula10 && cd ~/aula10
touch publico.txt privado.txt compartilhado.txt script.sh
ls -l                     # tudo nasce -rw-r--r-- (umask 022)
chmod 644 publico.txt     # -rw-r--r--
chmod 600 privado.txt     # -rw-------
chmod 755 script.sh       # -rwxr-xr-x
ls -l
```
O slide não define `compartilhado.txt`. Uma escolha coerente: `sudo chgrp projeto-web compartilhado.txt && chmod 660 compartilhado.txt` (dono e grupo leem e escrevem).
</details>

## 🧪 Prática guiada 2 e desafio: `/srv/projeto-web` (slides 33–34)

Requisitos: dono `root`, grupo `projeto-web`, permissão `770`, verificar com `ls -ld` e **testar com usuários diferentes**. Entregar: comando + saída + interpretação.

<details><summary><b>Solução</b></summary>

```bash
# estado dos grupos
getent group projeto-web            # projeto-web:x:....:ana,bruno

# criar e configurar
sudo mkdir -p /srv/projeto-web
sudo chown root:projeto-web /srv/projeto-web
sudo chmod 770 /srv/projeto-web
ls -ld /srv/projeto-web             # drwxrwx--- 2 root projeto-web ...

# testar como membro (ana)
sudo -u ana touch /srv/projeto-web/teste-ana.txt     # funciona
sudo -u ana ls -l /srv/projeto-web                   # funciona

# testar como externo (carlos)
id carlos                                             # sem projeto-web
sudo -u carlos ls /srv/projeto-web                    # Permission denied
```
Interpretação: ana está em `projeto-web` → recebe o bloco do **grupo** (`rwx`). carlos não é dono nem membro → recebe **outros** (`---`).

> `sudo -u ana comando` roda o comando **como a ana** (alternativa: `su - ana`, que pede a senha dela). Como é uma sessão nova, já vale o grupo recém-adicionado.

O script [`laboratorio.sh`](laboratorio.sh) faz as duas práticas e os testes.
</details>

## ✅ Questões de interpretação (slide 35)

1. `-rwxr-x--- 1 ana desenvolvimento 1024 arquivo.sh`: dono, grupo, octal?
2. `drwxr----- 2 root projeto-web ...`: um membro do grupo consegue entrar?

<details><summary><b>Respostas</b></summary>

1. Dono **ana**, grupo **desenvolvimento**, octal **750**.
2. **Não normalmente.** O grupo tem `r--` mas não `x`: pode até ver nomes, mas não atravessa o diretório. Correção: `sudo chmod g+x` (→ 750).
</details>

---

## Exercícios extras

1. Converta para octal: `rw-rw-r--` · `r--------` · `rwxr-xr--`
2. Converta para simbólico: `711` · `664` · `500`
3. `chmod 640 notas.txt` e `chmod u=rw,g=r,o= notas.txt` dão o mesmo resultado?
4. Um arquivo é `-rw-r--r-- ana ana`. Ana roda `./arquivo` e recebe *Permission denied*. Corrija com o mínimo.
5. `---rwxrwx 1 ana dev`. A Ana (que é do grupo `dev`) consegue ler o arquivo?
6. Com `umask 077`, que permissão terá um arquivo novo? E um diretório?
7. Bruno é dono de `bruno.txt` (`-rw-r--r--`) dentro de `/srv/projeto-web` (770). Ana (grupo `projeto-web`) consegue **apagar** o arquivo do Bruno? E **editar**?
8. Qual comando faz `relatorio.txt` passar a ser da `ana` e do grupo `projeto-web`?
9. Carlos recebe *Permission denied* em `/srv/projeto-web`. Escreva a sequência de diagnóstico e a correção mínima, supondo que ele deva ter acesso.
10. Por que `chmod 777 /srv/projeto-web` é uma má correção para a questão 9?

<details><summary><b>Respostas</b></summary>

1. `664` · `400` · `754`
2. `rwx--x--x` · `rw-rw-r--` · `r-x------`
3. Sim: os dois resultam em `-rw-r-----`.
4. Falta `x` para o dono: `chmod u+x arquivo` (não precisa abrir para grupo/outros).
5. **Não.** Ela é a **dona**, então vale só o bloco do dono (`---`), mesmo estando no grupo. O Linux para no primeiro bloco que casa.
6. Arquivo **600** (`rw-------`); diretório **700** (`rwx------`).
7. **Apagar: sim.** Apagar depende do `w` do **diretório** (770 → o grupo tem `w`). **Editar: não.** Editar depende do `w` do **arquivo**, e para ela vale o bloco "outros" (`r--`), pois o grupo do arquivo é `bruno`, não `projeto-web`.
8. `sudo chown ana:projeto-web relatorio.txt`
9. `whoami` → `id carlos` (não tem `projeto-web`) → `ls -ld /srv/projeto-web` (`drwxrwx--- root projeto-web`) → ele cai em "outros" (`---`). Correção mínima: `sudo gpasswd -a carlos projeto-web` e ele loga de novo.
10. Dá acesso total a **qualquer** usuário do sistema (inclusive contas de serviço), não só ao Carlos. Resolve o sintoma criando um problema de segurança.
</details>

> 💡 **Curiosidade (fora da aula, ajuda a entender o exercício 7):** em diretório de equipe, cada arquivo novo fica com o **grupo primário** de quem criou (`ana`, `bruno`…), não com `projeto-web`. Por isso, na prática, admins usam `chmod g+s` (setgid) no diretório para os arquivos herdarem o grupo. Esse assunto não caiu nos slides.
