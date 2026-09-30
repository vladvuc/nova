#!/usr/bin/env bash

set -euo pipefail

readonly COMMANDS_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly NOVA_ROOT="$(cd -P "$COMMANDS_DIR/.." && pwd)"

# shellcheck source=../lib/gitignore.sh
source "$NOVA_ROOT/lib/gitignore.sh"
# shellcheck source=../lib/manifest.sh
source "$NOVA_ROOT/lib/manifest.sh"

project_type="${1:-base}"

if (( $# > 1 )); then
  "$NOVA_ROOT/commands/help.sh" >&2
  exit 2
fi

case "$project_type" in
  base|ts|py|astro)
    ;;
  *)
    "$NOVA_ROOT/commands/help.sh" >&2
    exit 2
    ;;
esac

mkdir -p .plans .sandbox
touch .plans/PROGRESS.md .plans/THINKPAD.md .gitignore

add_gitignore_template "$NOVA_ROOT/templates/base/gitignore"

case "$project_type" in
  ts)
    add_gitignore_template "$NOVA_ROOT/templates/typescript/gitignore"
    create_manifest "$NOVA_ROOT/templates/typescript/package.json" package.json
    ;;
  py)
    add_gitignore_template "$NOVA_ROOT/templates/python/gitignore"
    create_manifest "$NOVA_ROOT/templates/python/pyproject.toml" pyproject.toml
    ;;
  astro)
    source "$NOVA_ROOT/lib/astro.sh"
    init_astro_project
    ;;
esac

if [[ "$project_type" == base ]]; then
  printf 'Initialized project in %s\n' "$PWD"
else
  printf 'Initialized %s project in %s\n' "$project_type" "$PWD"
fi
