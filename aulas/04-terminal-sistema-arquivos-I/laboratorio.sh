#!/bin/bash
# Laboratório principal do Encontro 04: cria a estrutura ~/soa e confere.
# Uso na VM Debian:  bash laboratorio.sh
# (Na prova/aula, faça À MÃO com cd/mkdir/touch. Este script serve para conferir.)

BASE="$HOME/soa"

mkdir -p "$BASE"/aulas/aula0{1,2,3,4} \
         "$BASE"/projetos/servidor-web/{configuracoes,logs,scripts} \
         "$BASE"/backups "$BASE"/documentos

touch "$BASE"/README.txt \
      "$BASE"/documentos/comandos.txt "$BASE"/documentos/notas.txt \
      "$BASE"/backups/backup.log

# Conferência: todo item esperado precisa existir.
esperados=(
  aulas/aula01 aulas/aula02 aulas/aula03 aulas/aula04
  projetos/servidor-web/configuracoes projetos/servidor-web/logs projetos/servidor-web/scripts
  backups documentos
  README.txt documentos/comandos.txt documentos/notas.txt backups/backup.log
)
faltando=0
for item in "${esperados[@]}"; do
  if [ -e "$BASE/$item" ]; then
    echo "OK       $item"
  else
    echo "FALTANDO $item"; faltando=1
  fi
done

echo
if command -v tree >/dev/null; then tree "$BASE"; else ls -R "$BASE"; fi
[ "$faltando" -eq 0 ] && echo "Estrutura completa." || { echo "Estrutura incompleta."; exit 1; }
