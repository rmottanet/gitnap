#!/usr/bin/env bash


function format_pullrequest() {
  local content
  local section="$1"  # Título ou corpo
  local file="pr"     # Nome do arquivo

  # Lê o arquivo
  content=$(cat "$file")

  # Extrai a seção desejada
  if [[ "$section" == "title" ]]; then
    content=$(head -n 1 "$file")
  else
    content=$(tail -n +2 "$file")
  fi

  # Escapa aspas duplas e quebras de linha
  escaped_content=$(echo "$content" | sed "s/'/\\'/g; s/$/\\\n/g; s/\n//g;" | tr -d '\n')

  # Retorna o conteúdo formatado
  echo "$escaped_content"
 
  return 0
}
