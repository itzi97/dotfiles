# dotfiles

Managed with [dotbot](https://github.com/anishathalye/dotbot). Symlink-based, so
**the file in `~/.config` is the file in this repo** — edit it, reload, done.
No apply step.

## Fresh machine

    git clone --recursive <url> ~/.dotfiles
    cd ~/.dotfiles
    ./bootstrap.sh

That installs packages for the detected distro and links everything. Re-running is
safe; package installation is skipped unless a package list changed.

    ./bootstrap.sh --dry-run        # show what would happen, change nothing
    ./bootstrap.sh desktop          # force a machine profile
    ./bootstrap.sh --skip-packages  # links only

## Layout

    install.conf.yaml       shared links, applied on every machine
    machines/desktop.yaml   CachyOS desktop only
    machines/thinkpad.yaml  Fedora ThinkPad only
    packages/common.txt     names identical on Arch and Fedora
    packages/cachyos.txt    Arch-family repo names
    packages/fedora.txt     Fedora repo names
    packages/aur.txt        AUR only; ignored entirely on Fedora
    config/                 shared config trees
    local/<machine>/        per-machine fragments, included by shared configs
    desktop/                desktop-only config (Hyprland)
    scripts/                standalone helper scripts, called by functions
    dotbot/                 submodule

## Shell

**fish is the interactive shell; bash is the login shell.** `~/.bashrc` ends with a guarded
`exec fish`. This is not a quirk — fish can't read `/etc/profile.d/*.sh`, so letting bash
log in first is what keeps PATH correct. See ADR-0010.

    config/shell/bashrc       login + rescue shell. Thin on purpose. Hands off to fish
    config/shell/exports.sh   bash-side environment
    config/shell/aliases.sh   bash-side aliases
    config/fish/config.fish   the real shell config
    local/<machine>/local.sh    per-machine, bash    } mirrors —
    local/<machine>/local.fish  per-machine, fish    } keep in step

The two-language duplication is the accepted cost. Keep the bash side minimal rather than
trying to keep them equal: bash is what you land in when fish is broken, and that's all.

Typing `bash` from inside fish stays in bash — the `FISH_LAUNCHED` guard is exported so the
handoff can't loop. A bare TTY login reads `~/.bash_profile`, not `~/.bashrc`, so it lands
in bash too. Both are deliberate.

## How machine differences work

No templating engine. Two mechanisms instead:

1. **Whole files that differ** → listed in `machines/<profile>.yaml` rather than
   `install.conf.yaml`. Hyprland exists only on the desktop, so it is linked only there.
2. **Values that differ inside a shared file** → the shared file `include`s a small
   per-machine fragment from `local/<machine>/`, using each tool's own native include:
   `include ./local.conf` (kitty), `[include] path = local` (git),
   `. local.sh` (shell), `pcall(require, "local")` (neovim).

Mechanism 2 matters: those includes keep working even with no dotfile manager present,
so a machine half-set-up is still a working machine.

## Adding a new dotfile

1. Move the real file into `config/`.
2. Add a `~/dest: source` line to `install.conf.yaml` (or a machine profile).
3. `./bootstrap.sh --dry-run` to check, then `./bootstrap.sh`.
4. Commit. Same day — uncommitted tweaks are how drift starts.

## Adding a package

Append to the right list in `packages/`. Next `./bootstrap.sh` detects the changed
hash and installs it. Separate lists exist because names diverge:
`fd` vs `fd-find`, `python-pipx` vs `pipx`, `ttf-jetbrains-mono` vs `jetbrains-mono-fonts`.

**AUR:** `packages/aur.txt` is Arch-only and skipped on Fedora. On first use, if no AUR
helper is present, `bootstrap.sh` builds `paru` from source (it will use an existing `yay`
instead of installing a second helper). Already-installed AUR packages are filtered out
before `paru` is called, so re-runs are quiet. Keep this list short — every AUR package is
source you're trusting and a potential build failure on a machine you need working.

## Package manager detection

Detection is by **binary**, not by `/etc/os-release`:

    command -v pacman  ->  packages/cachyos.txt (+ aur.txt)
    command -v dnf     ->  packages/fedora.txt

This is deliberate. CachyOS reports `ID=cachyos`, not `arch`, so a check like
`[ "$ID" = arch ]` silently never fires. Neither Arch nor Fedora sets `ID_LIKE`, so that's
no help either. Testing for the package manager is simpler and correct on every derivative.

## CD ripping (desktop only)

Carried over from the old stow repo. Four files, one workflow — they assume each
other's paths, so treat them as a unit:

    config/abcde/abcde.conf                      -> ~/.abcde.conf
    config/fish/functions/rip-cd.fish            abcde -> tag -> cover -> file
    config/fish/functions/audit-library.fish     wrapper around the script below
    scripts/audit_library.py                     library consistency check

    abcde rips to ~/Music/staging (flat)
      -> rip-cd reads ~/Music/abcde.*/ for metadata + cover, prompts, tags with eyeD3
      -> moves to ~/Music/mp3/<Artist>/<Year> - <Album>/  and deletes the workdir

These are **fish** functions and stay that way — see ADR-0009. Fish is installed for
them alone; the login shell is still bash. Linked from `machines/desktop.yaml`, not
`install.conf.yaml`, because the ThinkPad has no optical drive. Making them shared is a
matter of moving those three link lines and the packages into `install.conf.yaml` /
`common.txt` — but `lame` needs RPM Fusion on Fedora, which `bootstrap.sh` won't enable.

Both fish functions are linked **file-by-file**, never `~/.config/fish` as a directory:
fish writes `fish_variables` and generated completions into that directory, and a
directory-level symlink would drop all of it into this repo.

## Rules

- **No secrets in this repo, ever.** They live in ProtonPass. Not encrypted-in-repo — absent.
- Commit config changes the same day you make them.
- `force: false` everywhere: dotbot will refuse to clobber a real file rather than
  silently eat it. Resolve conflicts by hand.
