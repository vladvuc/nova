#!/usr/bin/env bash

project_name_from_directory() {
  local directory_name="${PWD##*/}"
  local project_name

  project_name="$(
    printf '%s' "$directory_name" |
      LC_ALL=C tr '[:upper:]' '[:lower:]' |
      sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//'
  )"

  printf '%s\n' "${project_name:-project}"
}

create_manifest() {
  local template="$1"
  local destination="$2"
  local project_name

  if [[ -e "$destination" || -L "$destination" ]]; then
    return
  fi

  project_name="$(project_name_from_directory)"
  sed "s/__PROJECT_NAME__/$project_name/g" "$template" > "$destination"
}
