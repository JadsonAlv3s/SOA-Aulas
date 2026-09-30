# Simulado 1: teórico (Encontros 01 a 04)

**Tempo sugerido:** 40 min. Responda no papel e depois confira o gabarito no final.

## Parte A: múltipla escolha

**1.** Tecnicamente, "Linux" é:
a) uma distribuição · b) um shell · c) um kernel · d) um gerenciador de pacotes

**2.** Debian é:
a) kernel · b) distribuição · c) shell · d) hypervisor

**3.** Qual NÃO é uma das 4 liberdades do software livre?
a) executar · b) estudar · c) ser gratuito · d) distribuir

**4.** O VirtualBox, no ambiente da disciplina, é:
a) guest · b) host · c) hypervisor tipo 1 · d) hypervisor tipo 2

**5.** Qual interface a instalação netinst usa para baixar pacotes?
a) loopback · b) NAT · c) Rede Interna · d) nenhuma

**6.** O prompt `root@server-soa:/etc#` indica:
a) usuário comum no home · b) root em /etc · c) usuário "server-soa" · d) diretório root

**7.** Qual comando mostra a versão do kernel?
a) `cat /etc/os-release` · b) `uname -r` · c) `lscpu` · d) `hostname`

**8.** `sudo apt update`:
a) instala as versões novas dos pacotes · b) atualiza as listas de pacotes · c) atualiza o kernel · d) reinicia o sistema

**9.** Os arquivos de configuração do sistema ficam em:
a) /var · b) /usr · c) /etc · d) /dev

**10.** Estando em `/home/aluno`, qual comando é um caminho **relativo**?
a) `cd /etc` · b) `cd /home/aluno/soa` · c) `cd soa/aulas` · d) `cd /`

**11.** `rmdir backups` falhou com "Directory not empty". Isso significa que:
a) o diretório não existe · b) há conteúdo dentro · c) falta o `-p` · d) o nome está com a caixa errada

**12.** Qual comando cria `a/b/c` de uma vez, mesmo sem `a` existir?
a) `mkdir a/b/c` · b) `touch a/b/c` · c) `mkdir -p a/b/c` · d) `cd -p a/b/c`

## Parte B: discursivas

**13.** Explique a diferença entre terminal, shell e kernel.

**14.** Por que a disciplina usa Debian sem interface gráfica e sem "SSH server" na instalação?

**15.** Explique o papel de cada interface de rede da VM padrão.

**16.** Um colega fecha a janela do VirtualBox para desligar a VM. Qual o problema, e qual o comando correto?

**17.** Você está em `/home/aluno/soa/projetos/servidor-web/scripts`. Dê o comando relativo e o absoluto para ir a `/home/aluno/soa/aulas/aula04`.

**18.** `ping -c 4 debian.org` falha, mas `ping -c 4 8.8.8.8` funciona. Qual a hipótese mais provável?

---

<details><summary><b>Gabarito</b></summary>

1-c · 2-b · 3-c · 4-d · 5-b · 6-b · 7-b · 8-b · 9-c · 10-c · 11-b · 12-c

13. **Terminal** = interface onde se digita; **shell** (Bash) = programa que interpreta os comandos; **kernel** = núcleo do SO que gerencia processos, memória, dispositivos, arquivos e rede, executando de fato as ações.

14. Decisão **didática**: priorizar administração de servidores (configuração em arquivos, serviços, usuários, rede, logs, automação) pelo terminal. O SSH não é instalado porque será **instalado, configurado e testado como conteúdo** da disciplina.

15. **Interface 1 (NAT):** acesso à Internet via host, para baixar e atualizar pacotes (`apt`) e acessar mirrors. **Interface 2 (Rede Interna `soa-lab`):** comunicação entre VMs do laboratório (SSH, web, banco de dados), sem depender da rede física.

16. É como tirar o computador da tomada: pode corromper arquivos e deixar o sistema num estado inconsistente. Correto: `sudo systemctl poweroff` (ou `sudo systemctl reboot` para reiniciar).

17. Relativo: `cd ../../../aulas/aula04`. Absoluto: `cd /home/aluno/soa/aulas/aula04` (ou `cd ~/soa/aulas/aula04`).

18. Há rota e conectividade (o IP responde), mas o **DNS** não está resolvendo nomes.
</details>
