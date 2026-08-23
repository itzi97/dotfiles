# CLAUDE.md — working in this repo

Instructions for Claude Code when operating on `~/.dotfiles`.

The *reasoning* behind this stack lives elsewhere: `~/Documents/00_Claude_Spaces/personal-stack-space/`,
in numbered ADRs. This file is the working method, not the decisions. If a change here
implies a decision, it belongs in an ADR over there.

---

## What this repo is

A dotbot repo driving two machines. Nothing is templated or generated — every file is
the real config, symlinked into place.

| Path | Role |
|---|---|
| `install.conf.yaml` | Links applied on **every** machine |
| `machines/<profile>.yaml` | Links applied on one machine. Runs after the shared config |
| `machines/<profile>.bundles` | Optional package bundles this machine wants |
| `local/<machine>/*` | Machine-specific config fragments, included by the shared configs natively |
| `packages/common.txt` | Package names **identical** on Arch and Fedora |
| `packages/{fedora,cachyos}.txt` | Names that differ, or distro-only |
| `packages/repos.<distro>.txt` | Commands run **as root, before** the package pass, to enable sources |
| `packages/bundles/<name>.txt` | Opt-in package groups (e.g. gaming) |
| `packages/flatpak.txt` | Tier 2 GUI applications |
| `toolboxes/<name>.txt` | distrobox package lists, built by `bin/tbx` |
| `bin/` | Scripts linked onto `$PATH` |

`bootstrap.sh` runs: repos → packages → AUR → flatpak → dotbot. Each phase is
hash-stamped and skipped when its input hasn't changed.

---

## Hard rules

**No secrets. Ever.** Passphrases, keys and tokens live in ProtonPass. The repo may
reference a path, never a value. The restic password and the SSH private key are
deliberately absent; keep it that way. Commit email is a GitHub noreply address on
purpose — don't "fix" it to a real one.

**`force: false` in dotbot stays.** It refuses to clobber real files instead of eating
them. A conflict on a fresh machine gets resolved by hand. This is deliberate.

**If a config needs a package, the package goes in a list — never a bare `dnf install`.**
Installing by hand leaves a config whose dependency exists on exactly one machine, and
it's also the only thing that tests the list. `common.txt` unless the name genuinely
differs; writing "Fedora: same name" in a comment means it's in the wrong file.

**A package needing a repo still goes in the list**, with the enabling command added to
`packages/repos.<distro>.txt`. The list stays the complete statement of intent.

**Comments here are load-bearing.** They record *why*, often including what was tried
and failed. Do not condense, tidy or "clean up" comments. If one is wrong, correct it and
say what was wrong — the wrong version is frequently the useful part.

---

## Working method

### Measure. Do not reason from plausibility.

This is the most important line in this file. On 2026-08-18 the following were each
asserted confidently and were each wrong: that `typst` was in Fedora's repos; that
`starship` was in Fedora's repos; that a multipart ETag was the unstable HTTP header
(twice, in opposite directions); that `~/.config/git/config` was supplying the commit
email.

Every one was settled by a single command:

```
dnf history info 1          # which packages came from the install image
conda list --revisions      # what was ever installed into this env
curl -sIL <url>  ×3         # which header actually varies
git config --show-origin    # which file a setting really comes from
```

Package managers, git and HTTP all record what they did. **Ask them.** One command beats
an hour of plausible reasoning, and plausible reasoning lost every single time.

### Never hand over an untested script.

Every script written here that wasn't tested first had a bug: a `--dry-run` that
installed seven packages and recorded success; a `sed` whose delimiter appeared in its
own pattern; a bundle typo that wasn't fatal because `die` ran inside a process
substitution; `fetch.fsck.fsckobjects`, a git key that doesn't exist.

Before handing anything over: `bash -n`, then exercise it against mocks or a temp
directory — including the failure paths. "It looks right" is not a test.

### Guards must be code, not comments.

A block of commands with `# only run this if the previous step worked` above it is not
a guard; bash runs it regardless. That mistake deleted a 562 MB directory before its
prerequisite had succeeded. Either put the check in an `if`, or hand over one command at
a time.

### One command at a time for anything destructive.

Removals, `rm -rf`, `dnf remove`, anything touching shell startup files. The user reads
each one before running it, which is the actual safety mechanism.

### Fail loudly. Never fail silently in the safe direction.

A check that reports "fine" when it couldn't actually check is worse than no check —
it manufactures false confidence. `pkgwatch` exits non-zero and prints `UNKNOWN` rather
than "up to date"; `stack-inventory.sh` prints a warning banner and refuses to derive
when its query looks implausible; `tbx` verifies with `rpm -q --whatprovides` instead of
trusting `dnf`'s exit code. Match that behaviour in anything new.

### Surgical changes.

Every changed line should trace to what was asked. Don't refactor adjacent code, don't
restyle, don't fix unrelated things you noticed — mention them instead. Match the
existing style even where you'd do it differently.

---

## Known traps in this specific repo

**dnf5 is not dnf4.** Three differences bit this repo in one day:
- `dnf install -y -- pkg` — dnf5 rejects the `--` separator
- `--qf` expands `\n` but **not** `\t`, and omitting `\n` yields no record separator at
  all, running every package onto one line
- `repoquery` deduplicates identical output lines, so a format string without `%{name}`
  collapses and every count comes back as 1

**Two configs, one setting.** Git reads `~/.gitconfig` *and* `~/.config/git/config`, and
the former wins. A missing `[include]` target is silently ignored. Check
`git config --show-origin` before concluding anything about git config.

**`$PATH` shadowing from exported container binaries.** `tbx` exports binaries to
`~/.local/bin`, which precedes `/usr/bin`. Export binaries that are *leaving* the host;
never export an interpreter the host resolves through `env`. Exporting `python3` made
dotbot run inside the container and fail on a dependency that was installed on the host
all along.

**`bootstrap.sh` had never run** before 2026-08-18 and carried three latent bugs. Treat
anything in `bin/` that hasn't demonstrably executed — `backup-local`, `backup-verify` —
as equally unproven.

---

## Before finishing

- Config changed → committed and pushed. This repo is the only off-machine copy of it.
- A decision was made → it belongs in an ADR in the Space, not in a comment here.
- Something turned out different from what a comment claimed → fix the comment **and**
  record what was wrong.
