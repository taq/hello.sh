#!/bin/sh
# verify.sh — Verifica a assinatura de um arquivo com a chave PÚBLICA.
#
# Uso:
#   ./verify.sh <arquivo> [chave_publica]
#
# Exemplos:
#   ./verify.sh hello.sh
#   ./verify.sh hello.sh minisign.pub
#
# Sai com código 0 se a assinatura for válida; !=0 se falhar.
# Precisa do arquivo <arquivo>.minisig ao lado do arquivo.

set -eu

file=${1:?uso: ./verify.sh <arquivo> [chave_publica]}
pubkey=${2:-minisign.pub}

if ! command -v minisign >/dev/null 2>&1; then
  echo "Minisign não encontrado." >&2
  echo "  FreeBSD: pkg install minisign" >&2
  echo "  Ubuntu:  apt install minisign   (repositorio universe)" >&2
  exit 1
fi

if [ ! -f "$pubkey" ]; then
  echo "Chave pública não encontrada: $pubkey" >&2
  exit 1
fi

if [ ! -f "${file}.minisig" ]; then
  echo "Assinatura não encontrada: ${file}.minisig" >&2
  exit 1
fi

minisign -V -m "$file" -p "$pubkey"
