#!/usr/bin/env bash
# Dependency-light tests for broll. Uses --print to avoid real-time animation.
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
B="$ROOT/broll"
pass=0; fail=0
c_grn=$'\033[32m'; c_red=$'\033[31m'; c_reset=$'\033[0m'
ok()  { printf '%s✓%s %s\n' "$c_grn" "$c_reset" "$1"; pass=$((pass+1)); }
bad() { printf '%s✗%s %s\n' "$c_red" "$c_reset" "$1"; fail=$((fail+1)); }
contains(){ case "$3" in *"$2"*) ok "$1";; *) bad "$1 (missing '$2')";; esac; }
b(){ "$B" "$@" 2>/dev/null; }

echo "== syntax =="
for f in "$ROOT/broll" "$ROOT/install.sh" "$ROOT/tests/test.sh"; do
  if bash -n "$f"; then ok "bash -n $(basename "$f")"; else bad "bash -n $(basename "$f")"; fi
done

echo "== cli basics =="
contains "version" "1.0.0"      "$(b --version)"
contains "help"    "broll type" "$(b --help)"

echo "== type effect =="
contains "demo types sample" "git clone" "$(b type --demo --print)"
tmp="$(mktemp)"; printf 'hello from a file\nsecond line\n' > "$tmp"; trap 'rm -f "$tmp"' EXIT
contains "types a file"      "hello from a file" "$(b type "$tmp" --print)"
contains "types file line 2" "second line"       "$(b type "$tmp" --print)"
if b type /no/such/file --print >/dev/null 2>&1; then bad "missing file should fail"; else ok "missing file exits nonzero"; fi
# speed flag is accepted (parse-level)
if b type --demo --print --wpm 500 >/dev/null 2>&1; then ok "--wpm accepted"; else bad "--wpm rejected"; fi

echo "== banner =="
contains "banner echoes text" "SHIP IT" "$(b banner 'SHIP IT' --print)"
# forced plain box (BROLL_PLAIN=1) always contains the literal text
out="$(BROLL_PLAIN=1 b banner 'SHIP IT' 2>/dev/null || true)"
contains "plain banner renders text" "SHIP IT" "$out"

echo "== list & errors =="
contains "list shows type" "type" "$(b list)"
if b frobnicate >/dev/null 2>&1; then bad "unknown command should fail"; else ok "unknown command exits nonzero"; fi

echo "== installer dry-run =="
if "$ROOT/install.sh" --check >/dev/null 2>&1; then ok "install.sh --check clean"; else bad "install.sh --check failed"; fi

echo
printf 'passed %d, failed %d\n' "$pass" "$fail"
[[ $fail -eq 0 ]]
