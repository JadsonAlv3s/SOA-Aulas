# SOA-Aulas

Material de estudo de **Sistemas Operacionais Abertos** (TSI / IFRN Campus Parnamirim, Prof. Diego Pereira), organizado a partir dos slides dos encontros. Ambiente da disciplina: **VirtualBox + Debian 13 netinst, modo texto**.

## 🚀 Estudando para a prova? Siga esta ordem

1. **[RESUMO-PROVA.md](RESUMO-PROVA.md)**: os encontros numa página, com checklist de véspera.
   - 🆕 **[Revisão das Listas I e II, explicada do zero](revisao-listas/)**: as 5 questões comentadas em linguagem simples + scripts testados.
   - 🆕 **[COMO-CRIAR-SCRIPT.md](COMO-CRIAR-SCRIPT.md)**: passo a passo para montar um script do zero (com modelo e treino).
2. **[COLA-COMANDOS.md](COLA-COMANDOS.md)**: todos os comandos vistos, agrupados.
3. **[questoes-teoricas.md](questoes-teoricas.md)**: 50 perguntas de autoteste (respostas escondidas).
4. **Simulados:**
   - [Simulado 1: teórico](simulados/simulado-1-teorico.md) (múltipla escolha + discursivas, com gabarito)
   - [Simulado 2: prático](simulados/simulado-2-pratico.md) (faça na VM: reconhecimento, estrutura de diretórios e navegação)

## 📚 Encontros (explicação + exercícios com respostas)

| # | Tema | Arquivos |
|---|---|---|
| 01 | [Introdução aos SOs e ao GNU/Linux](aulas/01-introducao-gnu-linux/) (SO, kernel, GNU, distribuição, shell, software livre) | README |
| 02 | [Virtualização e instalação do Debian 13](aulas/02-virtualizacao-instalacao-debian/) (host/guest/hypervisor, NAT × Rede Interna, instalador) | README |
| 03 | [Configuração inicial e reconhecimento](aulas/03-configuracao-inicial-reconhecimento/) (prompt, sudo, inventário, diretórios, hostname, timezone, APT) | README + `relatorio-reconhecimento.sh` |
| 04 | [Terminal e Sistema de Arquivos I](aulas/04-terminal-sistema-arquivos-I/) (pwd, ls, cd, caminhos, mkdir, touch, rmdir) | README + `laboratorio.sh` |
| 05–08 | *ainda não adicionados* | |
| 09 | [Usuários e Grupos](aulas/09-usuarios-grupos/) (UID/GID, /etc/passwd, /etc/shadow, /etc/group, useradd, gpasswd, usermod) | README + `laboratorio.sh` |
| 10 | [Permissões e Controle de Acesso](aulas/10-permissoes-controle-acesso/) (ls -l, rwx, chmod simbólico/octal, chown, chgrp, umask, Permission denied) | README + `laboratorio.sh` |
| Rev. | [Revisão das Listas I e II](revisao-listas/) (Q03, Q09, Q01, Q05, Q10: grep/cut, relatórios, ps, grupos, /srv/projeto-web) | README + `scripts/` |

## ▶️ Scripts de conferência (rode na VM Debian)

```bash
bash aulas/03-configuracao-inicial-reconhecimento/relatorio-reconhecimento.sh   # relatório do servidor
bash aulas/04-terminal-sistema-arquivos-I/laboratorio.sh                        # cria e confere ~/soa
sudo bash aulas/09-usuarios-grupos/laboratorio.sh                               # desafio final da Aula 09
sudo bash aulas/10-permissoes-controle-acesso/laboratorio.sh                    # práticas + testes de acesso
bash revisao-listas/scripts/q03_auditoria_usuarios.sh                           # (e os demais qNN_*.sh)
```

> Faça os laboratórios **à mão** primeiro; os scripts servem para conferir.
