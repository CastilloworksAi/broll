# broll 🎬

[![ci](https://github.com/CastilloworksAi/broll/actions/workflows/ci.yml/badge.svg)](https://github.com/CastilloworksAi/broll/actions/workflows/ci.yml)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**Instant terminal B-roll for screen recordings.** The "watch me type code" shot,
ASCII title cards, and ambient effects — with zero video editing.

This is the b-roll engine behind a lot of faceless tech content. Hit record,
run a command, get a clean shot.

```bash
broll type --demo          # realistic "typing" animation, no file needed
broll type myscript.sh     # type out a real file, like a human coding
broll banner "SHIP IT"     # big ASCII title card
broll rain --secs 10       # ambient matrix rain, auto-stops
```

The `type` and `banner` effects are **pure bash** — no dependencies, works on a
fresh machine. Ambient effects use `cmatrix`/`pipes` if you have them.

---

## Quick start

```bash
git clone https://github.com/CastilloworksAi/broll.git
cd broll
./install.sh            # puts `broll` on PATH; grabs toilet/figlet/cmatrix if it can
broll type --demo
```

`./install.sh` is idempotent and the extras are optional — if no package
manager is found, `type` and `banner` still work.

## The shots

### `broll type` — the typing animation
Types text into the terminal character-by-character with human-like jitter, so
it reads as real coding, not a robot. Perfect for the first half of a "here's
how it works" reel.

```bash
broll type --demo                 # built-in sample
broll type install.sh             # type a real file
broll type readme.md --wpm 220    # slower, more deliberate
broll type snippet.py --loop      # repeat forever (long takes) — Ctrl-C to stop
```

### `broll banner` — title cards
```bash
broll banner "PART 2"             # uses toilet/figlet if installed
broll banner "broseph.ai"         # falls back to a clean ASCII box otherwise
```

### `broll rain` — ambient background
```bash
broll rain                        # 15s of matrix/pipes, then clears
broll rain --secs 8               # custom length
```

## Flags

| Flag | Effect |
|---|---|
| `--wpm N` | Typing speed (default 320; higher = faster) |
| `--loop` | Repeat the `type` effect until Ctrl-C |
| `--secs N` | Duration for ambient effects (default 15) |
| `--print` | Dump text instantly instead of animating (scripting/tests) |

Set `BROLL_PLAIN=1` to force `banner` to use the plain ASCII box even when
`toilet`/`figlet` are installed.

## Why pure bash?

Because b-roll tools that need a 2GB install aren't b-roll tools, they're
homework. `type` and `banner` lean on nothing but bash + coreutils so they run
anywhere you can open a terminal. The fancy ambient stuff is optional sugar.

## Development

```bash
bash tests/test.sh    # uses --print, so it's instant and deterministic
```

CI runs the suite plus `shellcheck`.

## License

MIT — see [LICENSE](LICENSE).
