#!/usr/bin/env bash

set -euo pipefail

cat <<'EOF'
Usage: nova init [ts|py|astro]
       nova new <name> <ts|py|astro>
       nova doctor
       nova update
       nova --help

Commands:
  init    Initialize the current directory
  new     Create and initialize a new project directory
  doctor  Check the current project's setup
  update  Update Nova from GitHub (main)
EOF
