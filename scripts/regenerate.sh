#!/usr/bin/env bash
# Rewrites this repository's app from the `navree` command of a release.
#
#   scripts/regenerate.sh <version>          e.g. scripts/regenerate.sh 1.0.1
#
# It installs navree-cli at exactly that version from crates.io (set NAVREE_BIN to
# use a `navree` binary you already have, for example one built from a checkout),
# runs `navree new skeleton` in an empty folder, and replaces the app's files here.
# The files that belong to this repository are kept: .git/, .github/, scripts/, the
# licence files and the note above the README.
#
# Needs bash, cargo, git and rsync (Linux, macOS or WSL).
set -euo pipefail

version="${1:?usage: scripts/regenerate.sh <version>}"
root="$(cd "$(dirname "$0")/.." && pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

if [ -n "${NAVREE_BIN:-}" ]; then
  navree="$NAVREE_BIN"
else
  cargo install navree-cli --version "=${version}" --locked --root "$work/cli"
  navree="$work/cli/bin/navree"
fi

# An empty folder that is not inside a repository, so `navree new` starts a repository of its own.
mkdir "$work/new"
(cd "$work/new" && "$navree" new skeleton)
generated="$work/new/skeleton"
[ -f "$generated/Cargo.toml" ] || { echo "navree new did not write $generated/Cargo.toml" >&2; exit 1; }
rm -rf "$generated/.git" "$generated/target"

# The app's own README goes below the note.
cat "$root/scripts/README-header.md" "$generated/README.md" > "$work/README.md"
mv "$work/README.md" "$generated/README.md"

rsync -a --delete \
  --exclude '/.git/' --exclude '/.github/' --exclude '/scripts/' \
  --exclude '/LICENSE-MIT' --exclude '/LICENSE-APACHE' \
  "$generated"/ "$root"/

(cd "$root" && cargo generate-lockfile)
echo "The skeleton now holds the app that navree $version writes. Review it with: git status"
