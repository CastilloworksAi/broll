#!/usr/bin/env bash
# install.sh — put `broll` on your PATH and (optionally) install the extras
# that power ambient effects (toilet, figlet, cmatrix). The `type` and `banner`
# effects work with no extras at all.
#
#   ./install.sh            link broll + install extras if a package manager is found
#   ./install.sh --check    show what would happen, change nothing
#
# https://github.com/CastilloworksAi/broll   (MIT)
set -euo pipefail

DRYRUN=0
[[ "${1:-}" == "--check" || "${1:-}" == "--dry-run" ]] && DRYRUN=1

c_reset=$'\033[0m'; c_grn=$'\033[32m'; c_dim=$'\033[2m'
ok()  { printf '%s✓%s %s\n' "$c_grn" "$c_reset" "$*"; }
run() { if [[ $DRYRUN -eq 1 ]]; then printf '%swould run:%s %s\n' "$c_dim" "$c_reset" "$*"; else eval "$*"; fi; }
have(){ command -v "$1" >/dev/null 2>&1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINDIR="${HOME}/.local/bin"
EXTRAS="toilet figlet cmatrix"

if have apt-get;  then for p in $EXTRAS; do have "$p" || run "sudo apt-get install -y $p"; done
elif have brew;   then for p in $EXTRAS; do have "$p" || run "brew install $p"; done
elif have dnf;    then for p in $EXTRAS; do have "$p" || run "sudo dnf install -y $p"; done
elif have pacman; then for p in $EXTRAS; do have "$p" || run "sudo pacman -S --noconfirm $p"; done
else echo "No package manager found — that's fine, 'type' and 'banner' still work."; fi

run "mkdir -p '$BINDIR'"
run "ln -sf '$SCRIPT_DIR/broll' '$BINDIR/broll'"
run "chmod +x '$SCRIPT_DIR/broll'"
ok "linked broll -> $BINDIR/broll"

case ":$PATH:" in
  *":$BINDIR:"*) ok "$BINDIR is on your PATH" ;;
  *) printf '\nAdd to your shell rc:\n  export PATH="%s:$PATH"\n' "$BINDIR" ;;
esac

if [[ $DRYRUN -eq 0 ]]; then
  printf '\nTry it:  %sbroll type --demo%s\n' "$c_dim" "$c_reset"
fi
