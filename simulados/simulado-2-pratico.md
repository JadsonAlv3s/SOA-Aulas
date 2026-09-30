# Simulado 2: prático (faça na VM)

**Tempo sugerido:** 45 min. Use só os comandos vistos até o Encontro 04. Anote **cada comando** que usar: a entrega da disciplina sempre pede "informação + comando utilizado".

## Parte 1: reconhecimento (Encontro 03)

Descubra e anote (valor + comando):
1. usuário atual e seus grupos
2. hostname
3. distribuição e versão
4. kernel e arquitetura
5. quantidade de CPUs e memória disponível
6. tamanho do disco e espaço livre em `/`
7. nomes das interfaces e quais têm IP
8. timezone e há quanto tempo a máquina está ligada
9. se o sudo funciona e se há Internet

## Parte 2: estrutura de diretórios (Encontro 04)

Crie, a partir do home, a estrutura abaixo. Use **pelo menos uma vez** `mkdir -p` e **pelo menos uma vez** um caminho relativo com `..`.

```
~/empresa/
├── ti/
│   ├── servidores/
│   │   ├── web/
│   │   └── banco/
│   └── suporte/
├── rh/
│   └── contratos/
└── financeiro/
    └── 2026/
```
Arquivos vazios: `~/empresa/LEIA-ME.txt`, `ti/servidores/web/nginx.conf`, `rh/contratos/modelo.txt`, `financeiro/2026/relatorio.csv`.

## Parte 3: navegação

Partindo de `~/empresa/ti/servidores/web`, **sem usar caminho absoluto nem `~`**:
10. vá para `~/empresa/ti/suporte`
11. vá para `~/empresa/financeiro/2026`
12. volte ao diretório anterior com um único símbolo
13. confirme onde está

## Parte 4: erros propositais

14. Rode `rmdir ~/empresa/rh/contratos`. Leia o erro, explique e depois remova o diretório `~/empresa/ti/suporte`, que está vazio.
15. Crie o diretório `Relatorios Antigos` dentro de `financeiro` e entre nele. Depois diga que nome seria melhor.
16. Rode `cd ~/empresa/Financeiro`. Por que falha?

---

<details><summary><b>Solução</b></summary>

**Parte 1:** `whoami`, `id` · `hostname` · `cat /etc/os-release` · `uname -r`, `uname -m` · `lscpu`, `free -h` · `lsblk`, `df -h` · `ip -br a` · `timedatectl`, `uptime` · `sudo whoami`, `ping -c 4 debian.org`. (O script [`../aulas/03-configuracao-inicial-reconhecimento/relatorio-reconhecimento.sh`](../aulas/03-configuracao-inicial-reconhecimento/relatorio-reconhecimento.sh) confere tudo.)

**Parte 2** (uma solução possível):
```bash
cd ~
mkdir -p empresa/ti/servidores/web empresa/ti/servidores/banco
cd empresa
mkdir ti/suporte rh financeiro
mkdir -p rh/contratos financeiro/2026
touch LEIA-ME.txt ti/servidores/web/nginx.conf rh/contratos/modelo.txt financeiro/2026/relatorio.csv
cd ti/servidores/web
cd ../../../rh          # uso de .. para conferir
ls
```

**Parte 3:**
```bash
cd ~/empresa/ti/servidores/web     # ponto de partida
cd ../../suporte                   # 10 → ~/empresa/ti/suporte
cd ../../financeiro/2026           # 11 → ~/empresa/financeiro/2026
cd -                               # 12 → volta para ~/empresa/ti/suporte
pwd                                # 13
```

**Parte 4:**
14. `rmdir: failed to remove ... Directory not empty`, porque `contratos` tem `modelo.txt`. `rmdir ~/empresa/ti/suporte` funciona (vazio).
15. `mkdir ~/empresa/financeiro/"Relatorios Antigos"` e `cd ~/empresa/financeiro/Relatorios\ Antigos`. Melhor: `relatorios-antigos`.
16. O Linux diferencia maiúsculas e minúsculas: o diretório é `financeiro`, não `Financeiro`.
</details>
