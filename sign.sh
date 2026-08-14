#!/bin/sh
# sign.sh — Assina um arquivo com minisign (assinatura OFFLINE).
#
# Uso:
#   ./sign.sh <arquivo> [chave_secreta]
#
# Exemplos:
#   ./sign.sh hello.sh
#   ./sign.sh hello.sh ~/.minisign/minisign.key
#
# Gera <arquivo>.minisig ao lado do arquivo.

# Interrompe a execução imediatamente em caso de erro em comandos (-e) ou uso de variáveis não definidas (-u)
set -eu

file=${1:?uso: ./sign.sh <arquivo> [chave_secreta]}
seckey=${2:-}

if ! command -v minisign >/dev/null 2>&1; then
  echo "Minisign não encontrado!" >&2
  echo "  FreeBSD: pkg install minisign" >&2
  echo "  Ubuntu:  apt install minisign   (repositório universe)" >&2
  exit 1
fi

if [ ! -f "$file" ]; then
  echo "Arquivo não existe: $file" >&2
  exit 1
fi

# Comentário "confiável" (também é assinado): fica visível na verificação.
comment="Assinado em $(date -u '+%Y-%m-%dT%H:%M:%SZ')"

if [ -n "$seckey" ]; then
  minisign -S -s "$seckey" -t "$comment" -m "$file"
else
  minisign -S -t "$comment" -m "$file"
fi

echo
echo "OK -> assinatura gerada: ${file}.minisig"
