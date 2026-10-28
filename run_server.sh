#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# Use the project runtime without changing the system Ruby or conda environment.
mise_bin="${MISE_BIN:-$HOME/.local/bin/mise}"
if [[ ! -x "$mise_bin" ]]; then
  echo "Ruby manager not found: $mise_bin. See env_install.md." >&2
  exit 1
fi
export BUNDLE_PATH="$PWD/vendor/bundle"
# The metadata plugin misreads SSH remotes containing an explicit :443 port.
export PAGES_REPO_NWO="${PAGES_REPO_NWO:-xcp1999/xcp1999.github.io}"
if [[ "${1:-}" == "build" ]]; then
  shift
  exec "$mise_bin" exec ruby@3.3.13 -- bundle _2.5.23_ exec jekyll build "$@"
fi
exec "$mise_bin" exec ruby@3.3.13 -- bundle _2.5.23_ exec jekyll serve --livereload --host 127.0.0.1 "$@"
