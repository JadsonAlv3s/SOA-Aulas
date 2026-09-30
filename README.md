# SOA-Aulas

Material de estudo de **Sistemas Operacionais Abertos** (TSI / IFRN Campus Parnamirim, Prof. Diego Pereira), organizado a partir dos slides dos encontros. Ambiente da disciplina: **VirtualBox + Debian 13 netinst, modo texto**.

## 🚀 Estudando para a prova? Siga esta ordem

1. **[RESUMO-PROVA.md](RESUMO-PROVA.md)**: os 4 encontros numa página, com checklist de véspera.
2. **[COLA-COMANDOS.md](COLA-COMANDOS.md)**: todos os comandos vistos, agrupados.
3. **[questoes-teoricas.md](questoes-teoricas.md)**: 30 perguntas de autoteste (respostas escondidas).
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

## ▶️ Scripts de conferência (rode na VM Debian)

```bash
bash aulas/03-configuracao-inicial-reconhecimento/relatorio-reconhecimento.sh   # relatório do servidor
bash aulas/04-terminal-sistema-arquivos-I/laboratorio.sh                        # cria e confere ~/soa
```

> Faça os laboratórios **à mão** primeiro; os scripts servem para conferir.
