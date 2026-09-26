#!/usr/bin/env bash

set -euo pipefail

readonly COMMANDS_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly NOVA_ROOT="$(cd -P "$COMMANDS_DIR/.." && pwd)"
readonly NOVA_REPOSITORY='https://github.com/vladvuc/nova.git'

if (( $# != 0 )); then
  printf 'Usage: nova update\n' >&2
  exit 2
fi

if ! command -v git >/dev/null 2>&1; then
  printf 'Git is required to update Nova. Install Git and try again.\n' >&2
  exit 1
fi

# Only operate on Nova's own checkout, never an enclosing project repository.
if [[ ! -e "$NOVA_ROOT/.git" ]]; then
  printf 'This Nova installation has no Git metadata: %s\n' "$NOVA_ROOT" >&2
  printf 'Back up this installation and reinstall with git clone (see README).\n' >&2
  exit 1
fi

checkout_root="$(git -C "$NOVA_ROOT" rev-parse --show-toplevel)"
if [[ "$(cd -P "$checkout_root" && pwd)" != "$NOVA_ROOT" ]]; then
  printf 'Update stopped: Nova must be the root of its own Git checkout.\n' >&2
  exit 1
fi

if [[ "$(git -C "$NOVA_ROOT" symbolic-ref --quiet --short HEAD || true)" != main ]]; then
  printf 'Update stopped: Nova must be on the main branch.\n' >&2
  exit 1
fi

if [[ -n "$(git -C "$NOVA_ROOT" status --porcelain --untracked-files=normal)" ]]; then
  printf 'Update stopped: Nova has local changes in %s\n' "$NOVA_ROOT" >&2
  printf 'Commit or move your changes before running nova update.\n' >&2
  exit 1
fi

printf 'Updating Nova in %s from GitHub (main)...\n' "$NOVA_ROOT"

# Replace this process before Git changes the updater itself on disk.
# Fast-forward only: conflicting histories fail without a merge or reset.
exec git -C "$NOVA_ROOT" -c merge.autoStash=false -c rebase.autoStash=false \
  pull --ff-only --no-rebase "$NOVA_REPOSITORY" main
