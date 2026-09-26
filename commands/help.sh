#!/usr/bin/env bash

set -euo pipefail

cat <<'EOF'
Usage: nova init [ts|py]
       nova new <name> <ts|py>
       nova doctor
       nova --help

Commands:
  init    Initialize the current directory
  new     Create and initialize a new project directory
  doctor  Check the current project's setup
EOF
