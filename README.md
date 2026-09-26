# `nova`

![Nova — a central node. Nova avantura](assets/nova-banner.svg)

Nova provides small commands for starting projects.

Running `nova init`, `nova init ts`, `nova init py`, or `nova init astro` inside a directory creates:

```text
.gitignore
.plans/
└── PROGRESS.md
.sandbox/

+ minimal dependencie file
```

## Commands

```sh
nova init          # shared project files
nova init ts       # TypeScript project ignores
nova init py       # Python project ignores
nova init astro    # Astro ignores, manifest, and .astro/
nova new web-app ts
nova new data-tool py
nova new my-site astro
nova doctor
nova update
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

Run on macOS or Linux with Bash, Git, and curl installed:

```sh
curl -fsSL https://raw.githubusercontent.com/vladvuc/nova/main/install.sh | bash
```

If `~/.local/bin` is not on your PATH. For the default installation, add this to `~/.zshrc` (zsh) or `~/.bashrc` (bash), then open a new terminal:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

Run `nova --help` to check the installation. You can also install directly from
this repository with `bash install.sh`.

## Update

```sh
nova update
```

Updates require a clean Git checkout on `main`.
