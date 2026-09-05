#!/bin/sh

# Exercism downloads gradle wrapper with no execution permission.
# This entrypoint adds execution permission to all gradle wrappers.

for subdir in /home/exercist/exercism/java/*; do
  if [[ -d "$subdir" && -f "$subdir/gradlew" ]]; then
    chmod +x "$subdir/gradlew"
  fi

  if [[ -d "$subdir" && -f "$subdir/gradlew.bat" ]]; then
    chmod +x "$subdir/gradlew.bat"
  fi
done

exec "$@"
