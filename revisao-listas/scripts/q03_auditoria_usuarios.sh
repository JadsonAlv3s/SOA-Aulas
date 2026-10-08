#!/bin/bash
# Lista I · Q03: auditoria básica de contas a partir de /etc/passwd.
# Uso: bash q03_auditoria_usuarios.sh   (não precisa de sudo)

SAIDA=~/auditoria-usuarios.txt

echo "AUDITORIA DE USUARIOS" > "$SAIDA"            # > cria/zera o arquivo

echo "TOTAL DE CONTAS:" >> "$SAIDA"                # >> acrescenta no final
wc -l < /etc/passwd >> "$SAIDA"                    # "<" faz o wc mostrar só o número

echo "USUARIOS ORDENADOS:" >> "$SAIDA"
cut -d: -f1 /etc/passwd | sort >> "$SAIDA"

echo "USUARIOS COM BASH:" >> "$SAIDA"
grep "/bin/bash$" /etc/passwd | cut -d: -f1 >> "$SAIDA"   # $ = fim da linha (campo SHELL)

echo "TOTAL COM BASH:" >> "$SAIDA"
grep -c "/bin/bash$" /etc/passwd >> "$SAIDA"              # -c = conta as linhas

echo "TOTAL COM NOLOGIN:" >> "$SAIDA"
grep -c "nologin$" /etc/passwd >> "$SAIDA"

cat "$SAIDA"
