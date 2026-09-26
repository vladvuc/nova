#!/usr/bin/env bash

set -euo pipefail

readonly COMMANDS_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly NOVA_ROOT="$(cd -P "$COMMANDS_DIR/.." && pwd)"

if (( $# != 0 )); then
  "$NOVA_ROOT/commands/help.sh" >&2
  exit 2
fi

problems=0

check_path() {
  local path="$1"

  if [[ -e "$path" ]]; then
    printf '[ok] %s\n' "$path"
  else
    printf '[missing] %s\n' "$path"
    problems=$((problems + 1))
  fi
}

check_command() {
  local command_name="$1"

  if command -v "$command_name" >/dev/null 2>&1; then
    printf '[ok] %s is installed\n' "$command_name"
  else
    printf '[missing] %s is not installed\n' "$command_name"
    problems=$((problems + 1))
  fi
}

printf 'Nova doctor\n'
check_path .plans
check_path .plans/PROGRESS.md
check_path .sandbox
check_path .gitignore

if [[ -f .gitignore ]] && grep -Fqx 'node_modules/' .gitignore; then
  printf '[ok] TypeScript stack detected\n'
  check_path package.json
  check_command node
  check_command npm
elif [[ -f .gitignore ]] && grep -Fqx '__pycache__/' .gitignore; then
  printf '[ok] Python stack detected\n'
  check_path pyproject.toml
  check_command python3
else
  printf '[ok] Base stack detected\n'
fi

if (( problems > 0 )); then
  printf 'Found %d problem(s).\n' "$problems"
  exit 1
fi

printf 'Project is ready.\n'
