# `nova`

This folder contains the draft `nova` command. It has not been installed into
your command path.

```text
nova/
├── bin/
│   └── nova
├── commands/
│   ├── doctor.sh
│   ├── help.sh
│   ├── init.sh
│   └── new.sh
├── lib/
│   └── gitignore.sh
└── templates/
    ├── base/
    ├── python/
    └── typescript/
```

Running `nova init`, `nova init ts`, or `nova init py` inside a directory creates:

```text
.gitignore
.plans/
└── PROGRESS.md
.sandbox/
```

All variants add shared macOS, environment, editor, log, and workspace ignores.
The `ts` variant also covers Node.js, TypeScript, React tooling, and Astro, while
the `py` variant covers Python caches, environments, test tools, and build output.
Existing files are preserved and only missing `.gitignore` lines are added, so
the command is safe to run more than once.

```sh
nova init          # shared project files
nova init ts       # TypeScript project ignores
nova init py       # Python project ignores
nova new web-app ts
nova new data-tool py
nova doctor
nova --help
```

`nova new` requires a project name and stack. It creates a new directory and
initializes the Nova files inside it. It does not initialize a Git repository.

`nova doctor` checks the Nova project files and verifies that the detected
stack's runtime is installed. It does not require or inspect Git.

## Try it without installing

```sh
./bin/nova init ts
./bin/nova new web-app ts
./bin/nova doctor
./bin/nova --help
```

## Install it later

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

> This makes the `nova` command available from the conventional command directory.

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
