#!/usr/bin/env bash

# Keep installation inside a function so a partial curl download cannot start it.
install_nova() {
  set -euo pipefail

  if (( $# != 0 )); then
    printf 'Usage: bash install.sh\n' >&2
    return 2
  fi

  local repository='https://github.com/vladvuc/nova.git'
  local install_dir="${NOVA_INSTALL_DIR:-$HOME/.local/share/nova}"
  local bin_dir="${NOVA_BIN_DIR:-$HOME/.local/bin}"
  local executable="$install_dir/bin/nova"
  local link="$bin_dir/nova"
  local existing_origin
  local checkout_root

  if ! command -v git >/dev/null 2>&1; then
    printf 'Git is required. Install Git, then run the installer again.\n' >&2
    return 1
  fi

  # Absolute paths keep the command link valid from any working directory.
  if [[ "$install_dir" != /* || "$bin_dir" != /* ]]; then
    printf 'NOVA_INSTALL_DIR and NOVA_BIN_DIR must be absolute paths.\n' >&2
    return 1
  fi

  if [[ -e "$link" || -L "$link" ]]; then
    if [[ ! -L "$link" || "$(readlink "$link")" != "$executable" ]]; then
      printf 'Install stopped: %s already exists and belongs to another installation.\n' "$link" >&2
      printf 'Move it yourself before retrying; no files were replaced.\n' >&2
      return 1
    fi
  fi

  if [[ -e "$install_dir" || -L "$install_dir" ]]; then
    if [[ ! -d "$install_dir" || ! -e "$install_dir/.git" ]]; then
      printf 'Install stopped: %s exists without Nova Git metadata.\n' "$install_dir" >&2
      printf 'Back it up or choose another NOVA_INSTALL_DIR before retrying.\n' >&2
      return 1
    fi
    checkout_root="$(git -C "$install_dir" rev-parse --show-toplevel)"
    existing_origin="$(git -C "$install_dir" remote get-url origin)"
    if [[ "$(cd -P "$checkout_root" && pwd)" != "$(cd -P "$install_dir" && pwd)" ]]; then
      printf 'Install stopped: %s is not a repository root.\n' "$install_dir" >&2
      return 1
    fi
    case "$existing_origin" in
      https://github.com/vladvuc/nova|https://github.com/vladvuc/nova.git|git@github.com:vladvuc/nova.git)
        printf 'Using existing Nova installation in %s\n' "$install_dir"
        ;;
      *)
        printf 'Install stopped: %s is not a checkout of vladvuc/nova.\n' "$install_dir" >&2
        return 1
        ;;
    esac
  else
    mkdir -p "$(dirname "$install_dir")" "$bin_dir"
    git clone --branch main --single-branch "$repository" "$install_dir"
  fi

  if [[ ! -x "$executable" || ! -d "$install_dir/commands" || ! -d "$install_dir/templates" ]]; then
    printf 'Install stopped: Nova is incomplete or its entry point is not executable.\n' >&2
    return 1
  fi

  mkdir -p "$bin_dir"
  if [[ ! -L "$link" ]]; then
    ln -s "$executable" "$link"
  fi

  printf '\nNova installed: %s\n' "$link"
  case ":$PATH:" in
    *":$bin_dir:"*)
      printf 'Run: nova --help\n'
      ;;
    *)
      printf '\nAdd this line to your shell startup file (~/.zshrc or ~/.bashrc):\n'
      printf 'export PATH=%q:"$PATH"\n' "$bin_dir"
      printf 'Then open a new terminal, or run that line in the current one.\n'
      ;;
  esac
  printf 'For future updates, run: nova update\n'
}

install_nova "$@"
