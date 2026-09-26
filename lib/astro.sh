#!/usr/bin/env bash

is_astro_project() {
  [[ ! -d .astro ]] || return 0
  local config
  for config in astro.config.mjs astro.config.js astro.config.ts astro.config.mts; do
    [[ ! -e "$config" && ! -L "$config" ]] || return 0
  done

  command -v node >/dev/null 2>&1 || return 1
  [[ -f package.json ]] || return 1
  node -e '
    try {
      const fs = require("node:fs");
      const pkg = JSON.parse(fs.readFileSync("package.json", "utf8"));
      process.exit(pkg.dependencies?.astro || pkg.devDependencies?.astro ? 0 : 1);
    } catch { process.exit(1); }
  '
}

init_astro_project() {
  local template_dir="$NOVA_ROOT/templates/astro"

  add_gitignore_template "$template_dir/gitignore"
  create_manifest "$template_dir/package.json" package.json
  mkdir -p .astro
}
