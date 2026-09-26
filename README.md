# `nova`

This folder contains the `nova` commands. It has not been installed into
your command path.

Running `nova init`, `nova init ts`, or `nova init py` inside a directory creates:

```text
.gitignore
.plans/
└── PROGRESS.md
.sandbox/
```

- TypeScript gets a minimal `package.json`; Python gets a minimal `pyproject.toml`. The normalized folder name becomes the package name.

## Commands

```sh
nova init          # shared project files
nova init ts       # TypeScript project ignores
nova init py       # Python project ignores
nova new web-app ts
nova new data-tool py
nova doctor
nova --help
```

## Run w/o install

```sh
./bin/nova init ts
./bin/nova new web-app ts
./bin/nova doctor
./bin/nova --help
```

## Install

```sh
mkdir -p "$HOME/.local/bin" "$HOME/.local/share"
```

> This creates conventional per-user directories for commands and their files.

```sh
cp -R . "$HOME/.local/share/nova"
```

> This copies the command and its supporting files into a permanent location.

```sh
ln -s "$HOME/.local/share/nova/bin/nova" "$HOME/.local/bin/nova"
```

> This makes the `nova` command available from the command dir.

```sh
grep -Fq '$HOME/.local/bin' "$HOME/.zshrc" || printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.zshrc"
```

> This ensures your shell can find the `nova` command without duplicating the PATH setting.

```sh
source "$HOME/.zshrc"
```

> This applies the updated command path to the current terminal session.

```sh
nova init ts
```

> This initializes the TypeScript project currently open in your terminal.
