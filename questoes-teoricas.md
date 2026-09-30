# Questões de autoteste (Encontros 01 a 04)

Responda antes de abrir.

<details><summary><b>1.</b> Qual a função de um sistema operacional?</summary>
Administrar os recursos computacionais (CPU/processos, memória, armazenamento, E/S) e oferecer uma interface entre hardware, aplicações e usuários, padronizando o acesso aos recursos.
</details>

<details><summary><b>2.</b> "Linux" é o sistema operacional completo?</summary>
Tecnicamente não: Linux é o <b>kernel</b>. O sistema completo é o <b>GNU/Linux</b> (ferramentas GNU + kernel Linux), embora no dia a dia se diga só "Linux".
</details>

<details><summary><b>3.</b> O que o kernel gerencia?</summary>
Processos, memória, dispositivos, arquivos e rede. Ele decide como os recursos são usados e protegidos.
</details>

<details><summary><b>4.</b> Diferença entre terminal e shell?</summary>
Terminal é a interface onde se digita. Shell (ex.: Bash) é o programa que interpreta os comandos.
</details>

<details><summary><b>5.</b> O que compõe uma distribuição?</summary>
Kernel Linux + ferramentas GNU + bibliotecas e serviços + gerenciador de pacotes (+ organização e comunidade). Ex.: Debian.
</details>

<details><summary><b>6.</b> Quais as 4 liberdades do software livre?</summary>
Executar, estudar, modificar e distribuir. "Livre" é sobre liberdade, não sobre preço.
</details>

<details><summary><b>7.</b> Ordene: Projeto GNU, kernel Linux, UNIX.</summary>
UNIX (1969) → Projeto GNU (1983) → Kernel Linux (1991).
</details>

<details><summary><b>8.</b> O que é host, guest e hypervisor?</summary>
Host = sistema do computador físico; guest = sistema dentro da VM (Debian); hypervisor = software que cria e executa as VMs (VirtualBox).
</details>

<details><summary><b>9.</b> Por que o VirtualBox é hypervisor tipo 2?</summary>
Porque roda sobre um sistema operacional host (Windows/Linux), e não diretamente no hardware (tipo 1).
</details>

<details><summary><b>10.</b> Por que a netinst depende da interface NAT?</summary>
A netinst traz só a base; os pacotes são baixados de um mirror Debian pela Internet, que a VM acessa pela NAT.
</details>

<details><summary><b>11.</b> Para que serve a Rede Interna?</summary>
Comunicação entre VMs num ambiente controlado (soa-lab), independente da rede física: SSH, web, banco de dados, SFTP/SCP, diagnóstico.
</details>

<details><summary><b>12.</b> Quais os recursos da VM padrão?</summary>
2 vCPUs, 2048 MB de RAM, disco de 20 GB dinâmico, Interface 1 NAT, Interface 2 Rede Interna, hostname server-soa, sem interface gráfica.
</details>

<details><summary><b>13.</b> Por que deixar a senha do root em branco?</summary>
Assim o root fica bloqueado para login e o usuário criado recebe sudo; o trabalho diário é como usuário comum, elevando privilégio só quando necessário.
</details>

<details><summary><b>14.</b> Qual a sequência de boot?</summary>
Firmware → GRUB → Kernel Linux → Debian → Login.
</details>

<details><summary><b>15.</b> Em <code>ana@server-soa:/var/log$</code>, quem, onde e com que privilégio?</summary>
Usuária <code>ana</code>, máquina <code>server-soa</code>, diretório <code>/var/log</code>, usuário comum (<code>$</code>).
</details>

<details><summary><b>16.</b> O que <code>sudo whoami</code> retorna e por quê?</summary>
<code>root</code>: o sudo executa aquele comando com privilégio de root, sem transformar a sessão em root.
</details>

<details><summary><b>17.</b> <code>cat /etc/os-release</code> × <code>uname -r</code>?</summary>
O primeiro informa a distribuição/versão (Debian 13); o segundo, a versão do kernel Linux.
</details>

<details><summary><b>18.</b> <code>lsblk</code> × <code>df -h</code>?</summary>
lsblk: dispositivos de bloco (discos, partições, pontos de montagem). df -h: espaço usado/livre de cada sistema de arquivos montado.
</details>

<details><summary><b>19.</b> <code>apt update</code> × <code>apt upgrade</code>?</summary>
update atualiza as listas de pacotes dos repositórios; upgrade instala as versões novas dos pacotes. Primeiro update, depois upgrade.
</details>

<details><summary><b>20.</b> Relacione o diretório: configurações, logs, dispositivos, home do root, processos.</summary>
/etc · /var (/var/log) · /dev · /root · /proc.
</details>

<details><summary><b>21.</b> Por que horário errado é problema em servidor?</summary>
Afeta logs, certificados, autenticação, banco de dados, tarefas agendadas e auditoria.
</details>

<details><summary><b>22.</b> Como desligar a VM corretamente?</summary>
<code>sudo systemctl poweroff</code> (reiniciar: <code>sudo systemctl reboot</code>). Fechar a janela é como puxar a tomada.
</details>

<details><summary><b>23.</b> O que é caminho absoluto e relativo?</summary>
Absoluto começa em <code>/</code> e funciona de qualquer lugar. Relativo não começa com <code>/</code> e é interpretado a partir do diretório atual.
</details>

<details><summary><b>24.</b> O que são <code>.</code>, <code>..</code>, <code>~</code> e <code>-</code> no <code>cd</code>?</summary>
Diretório atual, diretório pai, home do usuário e diretório anterior.
</details>

<details><summary><b>25.</b> Por que <code>ls</code> não mostra <code>.bashrc</code>?</summary>
Nomes iniciados com ponto são ocultos; é preciso <code>ls -a</code>.
</details>

<details><summary><b>26.</b> Para que serve o <code>-p</code> do mkdir?</summary>
Cria os diretórios intermediários que faltarem (sem ele, o mkdir falha) e não reclama se o diretório já existe.
</details>

<details><summary><b>27.</b> Por que o rmdir se recusar a apagar é bom?</summary>
Só remove diretórios vazios; é uma barreira contra apagar conteúdo por acidente.
</details>

<details><summary><b>28.</b> Por que <code>cd projeto linux</code> falha?</summary>
O espaço separa argumentos: o cd recebe dois. Use <code>cd "projeto linux"</code> ou <code>cd projeto\ linux</code>.
</details>

<details><summary><b>29.</b> Onde você está após: <code>cd /home/aluno/soa/aulas</code>, <code>cd ../projetos/servidor-web</code>, <code>cd ../../..</code>?</summary>
<code>/home/aluno</code>.
</details>

<details><summary><b>30.</b> O que <code>touch</code> faz num arquivo que já existe?</summary>
Atualiza as datas de acesso/modificação sem alterar o conteúdo.
</details>
