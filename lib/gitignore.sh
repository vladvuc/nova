#!/usr/bin/env bash

add_gitignore_entry() {
  local entry="$1"

  if ! grep -Fqx -- "$entry" .gitignore; then
    printf '%s\n' "$entry" >> .gitignore
  fi
}

add_gitignore_template() {
  local template="$1"
  local entry

  while IFS= read -r entry || [[ -n "$entry" ]]; do
    add_gitignore_entry "$entry"
  done < "$template"
}
