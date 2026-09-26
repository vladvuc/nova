#!/usr/bin/env bash

set -euo pipefail

readonly COMMANDS_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly NOVA_ROOT="$(cd -P "$COMMANDS_DIR/.." && pwd)"

if (( $# != 2 )); then
  "$NOVA_ROOT/commands/help.sh" >&2
  exit 2
fi

readonly project_name="$1"
readonly project_type="$2"

case "$project_name" in
  ''|.|..|-*|*/*)
    printf 'Invalid project name: %s\n' "$project_name" >&2
    exit 2
    ;;
esac

case "$project_type" in
  ts|py|astro)
    ;;
  *)
    printf 'Unknown stack: %s (expected ts, py, or astro)\n' "$project_type" >&2
    exit 2
    ;;
esac

if [[ -e "$project_name" ]]; then
  printf 'Project path already exists: %s\n' "$project_name" >&2
  exit 1
fi

mkdir "$project_name"
(
  cd "$project_name"
  "$NOVA_ROOT/commands/init.sh" "$project_type"
)

printf 'Created %s project: %s/%s\n' "$project_type" "$PWD" "$project_name"
