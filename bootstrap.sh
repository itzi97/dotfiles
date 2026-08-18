#!/usr/bin/env bash
#
# Bootstrap this machine: enable repos, install packages, then apply dotfiles
# via dotbot.
#
#   ./bootstrap.sh                 # auto-detect machine profile from hostname
#   ./bootstrap.sh desktop         # force a profile
#   ./bootstrap.sh thinkpad --dry-run
#   ./bootstrap.sh --skip-packages
#   ./bootstrap.sh --with gaming   # add a bundle for this run only
#
# Idempotent: safe to run repeatedly. Each phase is stamped by the content
# hash of its input file(s) and skipped when nothing has changed.
#
# PHASES, in order — the order matters and is the whole point of the repo phase:
#   1. repos     packages/repos.<distro>.txt   enable sources
#   2. packages  common + <distro> + bundles   install from them
#   3. aur       packages/aur.txt              Arch only
#   4. flatpak   packages/flatpak.txt          Tier 2 GUI apps (ADR-0012)
#   5. dotbot    install.conf.yaml + machines/<profile>.yaml

set -Eeuo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTBOT_DIR="${BASEDIR}/dotbot"
DOTBOT_BIN="${DOTBOT_DIR}/bin/dotbot"
BASE_CONFIG="${BASEDIR}/install.conf.yaml"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"

PROFILE=""
SKIP_PACKAGES=0
DOTBOT_ARGS=()
EXTRA_BUNDLES=()

die() { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }
info() { printf '\033[36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[33mwarn:\033[0m %s\n' "$*" >&2; }

# ---------------------------------------------------------------- arguments
while (($#)); do
  case "$1" in
    --skip-packages) SKIP_PACKAGES=1 ;;
    --with)          shift; [[ -n "${1:-}" ]] || die "--with needs a bundle name"
                     EXTRA_BUNDLES+=("$1") ;;
    -n|--dry-run)    DOTBOT_ARGS+=(--dry-run); SKIP_PACKAGES=1 ;;
    -v|--verbose)    DOTBOT_ARGS+=(-v) ;;
    -h|--help)       sed -n '2,20p' "${BASH_SOURCE[0]}" | sed 's/^# \?//'; exit 0 ;;
    -*)              die "unknown option: $1" ;;
    *)               PROFILE="$1" ;;
  esac
  shift
done

# ------------------------------------------------- package manager detection
# Detect by BINARY, not by /etc/os-release ID. This is deliberate: CachyOS
# reports ID=cachyos (not arch), so `[ "$ID" = arch ]` silently never fires.
detect_pkg_manager() {
  if command -v pacman >/dev/null 2>&1; then echo pacman
  elif command -v dnf   >/dev/null 2>&1; then echo dnf
  else echo unsupported
  fi
}

PKG_MANAGER="$(detect_pkg_manager)"
case "$PKG_MANAGER" in
  pacman) PKG_LIST="${BASEDIR}/packages/cachyos.txt"
          REPO_LIST="${BASEDIR}/packages/repos.cachyos.txt" ;;
  dnf)    PKG_LIST="${BASEDIR}/packages/fedora.txt"
          REPO_LIST="${BASEDIR}/packages/repos.fedora.txt" ;;
  *)      warn "no supported package manager found; will only link dotfiles" ;;
esac
COMMON_LIST="${BASEDIR}/packages/common.txt"
AUR_LIST="${BASEDIR}/packages/aur.txt"
FLATPAK_LIST="${BASEDIR}/packages/flatpak.txt"
BUNDLE_DIR="${BASEDIR}/packages/bundles"
AUR_HELPER="paru"

# ------------------------------------------------------- profile resolution
if [[ -z "$PROFILE" ]]; then
  case "$(hostname -s 2>/dev/null || echo unknown)" in
    *desktop*|*cachy*) PROFILE=desktop ;;
    *think*|*pad*)     PROFILE=thinkpad ;;
    *)
      case "$PKG_MANAGER" in
        pacman) PROFILE=desktop ;;
        dnf)    PROFILE=thinkpad ;;
        *)      die "cannot determine machine profile; pass one explicitly (desktop|thinkpad)" ;;
      esac
      warn "profile guessed from package manager: ${PROFILE}"
      ;;
  esac
fi

PROFILE_CONFIG="${BASEDIR}/machines/${PROFILE}.yaml"
[[ -f "$PROFILE_CONFIG" ]] || die "no such profile: ${PROFILE} (expected ${PROFILE_CONFIG})"

# Bundles the machine declares it wants, plus anything from --with.
#
# Declared in a file rather than passed as a flag on purpose: a rebuild that
# depends on remembering the right arguments is a memory test, not a rebuild
# (principle #4). The machine states what it is; --with is for trying
# something once.
BUNDLES_FILE="${BASEDIR}/machines/${PROFILE}.bundles"
BUNDLES=()
if [[ -f "$BUNDLES_FILE" ]]; then
  mapfile -t BUNDLES < <(sed -e 's/#.*//' -e 's/[[:space:]]*//g' -e '/^$/d' "$BUNDLES_FILE")
fi
((${#EXTRA_BUNDLES[@]})) && BUNDLES+=("${EXTRA_BUNDLES[@]}")

info "machine profile : ${PROFILE}"
info "package manager : ${PKG_MANAGER}"
((${#BUNDLES[@]})) && info "bundles         : ${BUNDLES[*]}"

# ----------------------------------------------------------------- packages
# Strip comments, inline comments and blank lines from a package list.
clean_list() {
  sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$1"
}

# Resolve a bundle name to its file, failing loudly. A typo in a .bundles file
# should stop the run — silently installing nothing is the failure mode this
# whole repo phase exists to prevent.
bundle_file() {
  local f="${BUNDLE_DIR}/${1}.txt"
  [[ -f "$f" ]] || die "no such bundle: ${1} (expected ${f})"
  printf '%s\n' "$f"
}

# Check every declared bundle exists, in the MAIN shell, before anything runs.
#
# Doing this lazily inside all_package_lists() looked fine and wasn't: that
# function is only ever called from `< <(…)` process substitution, so its
# `die` exits the subshell and the run continues happily — installing nothing
# from the bundle and reporting success. Found by testing `--with nope`
# (2026-08-18). Validation has to happen where it can actually stop the run.
validate_bundles() {
  local b
  for b in ${BUNDLES[@]+"${BUNDLES[@]}"}; do
    bundle_file "$b" >/dev/null
  done
}

# Every package list that feeds this machine, in order.
all_package_lists() {
  [[ -f "$COMMON_LIST" ]] && printf '%s\n' "$COMMON_LIST"
  [[ -n "${PKG_LIST:-}" && -f "$PKG_LIST" ]] && printf '%s\n' "$PKG_LIST"
  local b
  for b in ${BUNDLES[@]+"${BUNDLES[@]}"}; do bundle_file "$b"; done
  # AUR list only affects Arch, so switching distros does not invalidate the
  # stamp for the wrong reason.
  [[ "$PKG_MANAGER" == pacman && -f "$AUR_LIST" ]] && printf '%s\n' "$AUR_LIST"
  true
}

# Hash-stamp idempotency: only reinstall when list content actually changes.
#
# NOTE: each branch ends in `|| :` and the group ends in `true`. Without that,
# a false [[ ]] on the last line becomes the group's exit status, and
# `set -o pipefail` then fails the whole pipeline. This bit Fedora, where the
# pacman-only AUR branch is always false.
list_hash() {
  { local f
    while read -r f; do clean_list "$f" || :; done < <(all_package_lists)
    true
  } | sha256sum | cut -d' ' -f1
}

# --------------------------------------------------------------------- repos
# Enable package sources BEFORE installing anything from them.
#
# This exists because the failure without it is SILENT: `dnf install steam`
# with --skip-unavailable on a machine lacking RPM Fusion prints one line and
# carries on. The package list looks complete and the machine isn't. Four
# separate cases hit this on 2026-08-18 — starship's COPR, lame/RPM Fusion,
# typst, and Flathub itself.
enable_repos() {
  [[ -n "${REPO_LIST:-}" && -f "$REPO_LIST" ]] || return 0

  mkdir -p "$STATE_DIR"
  local stamp="${STATE_DIR}/repos.${PKG_MANAGER}.sha256"
  local want have
  want="$(clean_list "$REPO_LIST" | sha256sum | cut -d' ' -f1)"
  have="$(cat "$stamp" 2>/dev/null || true)"

  if [[ "$want" == "$have" ]]; then
    info "repos unchanged since last run — skipping"
    return 0
  fi

  local cmds=()
  mapfile -t cmds < <(clean_list "$REPO_LIST")
  ((${#cmds[@]})) || return 0

  info "enabling ${#cmds[@]} repo source(s) from $(basename "$REPO_LIST")"
  local c
  for c in "${cmds[@]}"; do
    printf '  %s\n' "$c"
    # Run as root via sudo -- these add repos and write to /etc.
    # `bash -c` because the lines may contain command substitution
    # (e.g. $(rpm -E %fedora)) that must expand on the target machine.
    sudo bash -c "$c" || die "repo command failed: $c"
  done

  printf '%s\n' "$want" > "$stamp"
  info "repo stamp updated"
}

# ---------------------------------------------------------------------- AUR
ensure_aur_helper() {
  command -v "$AUR_HELPER" >/dev/null 2>&1 && return 0
  if command -v yay >/dev/null 2>&1; then AUR_HELPER=yay; return 0; fi

  info "no AUR helper found — building ${AUR_HELPER} from source"
  command -v git >/dev/null 2>&1 || die "git is required to bootstrap ${AUR_HELPER}"
  sudo pacman -S --needed --noconfirm -- base-devel

  local tmp
  tmp="$(mktemp -d)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  git clone --depth 1 "https://aur.archlinux.org/${AUR_HELPER}.git" "$tmp/${AUR_HELPER}"
  ( cd "$tmp/${AUR_HELPER}" && makepkg -si --noconfirm )
  command -v "$AUR_HELPER" >/dev/null 2>&1 || die "${AUR_HELPER} bootstrap failed"
  info "${AUR_HELPER} installed"
}

install_aur_packages() {
  [[ "$PKG_MANAGER" == pacman ]] || return 0
  [[ -f "$AUR_LIST" ]] || return 0

  local pkgs=()
  mapfile -t pkgs < <(clean_list "$AUR_LIST" | sort -u)
  ((${#pkgs[@]})) || { info "no AUR packages listed — skipping"; return 0; }

  ensure_aur_helper

  local missing=() p
  for p in "${pkgs[@]}"; do
    "$AUR_HELPER" -Qi -- "$p" >/dev/null 2>&1 || missing+=("$p")
  done

  if ((${#missing[@]} == 0)); then
    info "all ${#pkgs[@]} AUR packages already installed"
    return 0
  fi

  info "installing ${#missing[@]} AUR package(s) via ${AUR_HELPER}"
  "$AUR_HELPER" -S --needed --noconfirm -- "${missing[@]}"
}

# ------------------------------------------------------------------ flatpak
# Tier 2 under ADR-0012. Without this phase a rebuild produces a working shell
# and toolchain and none of the actual applications — Obsidian, Signal,
# Spotify, Proton Mail. Stamped separately from the repo packages so a change
# to one doesn't re-run the other.
install_flatpaks() {
  [[ -f "$FLATPAK_LIST" ]] || return 0
  if ! command -v flatpak >/dev/null 2>&1; then
    warn "flatpak not installed — skipping $(basename "$FLATPAK_LIST")"
    return 0
  fi

  mkdir -p "$STATE_DIR"
  local stamp="${STATE_DIR}/flatpak.sha256"
  local want have
  want="$(clean_list "$FLATPAK_LIST" | sha256sum | cut -d' ' -f1)"
  have="$(cat "$stamp" 2>/dev/null || true)"

  if [[ "$want" == "$have" ]]; then
    info "flatpaks unchanged since last run — skipping"
    return 0
  fi

  local apps=()
  mapfile -t apps < <(clean_list "$FLATPAK_LIST" | sort -u)
  ((${#apps[@]})) || return 0

  info "installing ${#apps[@]} flatpak(s) from flathub"
  # --noninteractive so it never blocks on a prompt; per-app rather than one
  # transaction so a single unavailable ID doesn't abort the rest.
  local a failed=()
  for a in "${apps[@]}"; do
    flatpak install --noninteractive --or-update flathub "$a" \
      || { warn "  failed: $a"; failed+=("$a"); }
  done

  if ((${#failed[@]})); then
    warn "flatpak: ${#failed[@]} failed (${failed[*]}) — not stamping, will retry"
    return 0
  fi
  printf '%s\n' "$want" > "$stamp"
  info "flatpak stamp updated"
}

# ----------------------------------------------------------- repo packages
install_packages() {
  [[ "$PKG_MANAGER" == unsupported ]] && return 0

  mkdir -p "$STATE_DIR"
  local stamp="${STATE_DIR}/packages.${PKG_MANAGER}.sha256"
  local want have
  want="$(list_hash)"
  have="$(cat "$stamp" 2>/dev/null || true)"

  if [[ "$want" == "$have" ]]; then
    info "packages unchanged since last run — skipping"
    return 0
  fi

  local pkgs=() f
  mapfile -t pkgs < <( while read -r f; do
                         [[ "$f" == "$AUR_LIST" ]] && continue
                         clean_list "$f"
                       done < <(all_package_lists) | sort -u )

  if ((${#pkgs[@]} == 0)); then
    warn "repo package lists are empty"
    install_aur_packages
    printf '%s\n' "$want" > "$stamp"
    return 0
  fi

  info "installing ${#pkgs[@]} packages via ${PKG_MANAGER}"
  case "$PKG_MANAGER" in
    pacman)
      # --needed makes this idempotent even without the stamp.
      sudo pacman -S --needed --noconfirm -- "${pkgs[@]}"
      ;;
    dnf)
      # No `--` before the list: dnf5 rejects it where dnf4 accepted it.
      # --skip-unavailable so one renamed package doesn't block the rest —
      # which is exactly why the repo phase above has to run first.
      sudo dnf install -y --skip-unavailable "${pkgs[@]}"
      ;;
  esac

  # AUR after repo packages: AUR builds frequently need base-devel and
  # headers from the official repos.
  install_aur_packages

  # Only stamp on success: set -e means a failed install aborts before this,
  # so a broken build leaves the stamp untouched and the next run retries.
  printf '%s\n' "$want" > "$stamp"
  info "package stamp updated"
}

# ------------------------------------------------------------------- dotbot
ensure_dotbot() {
  if [[ ! -x "$DOTBOT_BIN" ]]; then
    if [[ -d "${BASEDIR}/.git" ]]; then
      info "fetching dotbot submodule"
      git -C "$BASEDIR" submodule update --init --recursive dotbot
    fi
  fi
  [[ -x "$DOTBOT_BIN" ]] || die "dotbot not found at ${DOTBOT_BIN}
Run: git submodule add https://github.com/anishathalye/dotbot dotbot"
  command -v python3 >/dev/null 2>&1 || die "python3 is required by dotbot"
  python3 -c 'import yaml' 2>/dev/null \
    || die "python3 PyYAML is required by dotbot (Fedora: python3-pyyaml, Arch: python-yaml)"
}

run_dotbot() {
  local config="$1"
  info "applying $(basename "$config")"
  "$DOTBOT_BIN" -d "$BASEDIR" -c "$config" "${DOTBOT_ARGS[@]+"${DOTBOT_ARGS[@]}"}"
}

# --------------------------------------------------------------------- main
main() {
  # Before anything else, including a dry run: a typo in a .bundles file
  # should stop the run rather than quietly shrink it.
  validate_bundles

  if ((SKIP_PACKAGES)); then
    info "skipping repo/package/flatpak phases (--skip-packages or --dry-run)"
  else
    enable_repos
    install_packages
    install_flatpaks
  fi

  ensure_dotbot
  run_dotbot "$BASE_CONFIG"
  run_dotbot "$PROFILE_CONFIG"

  info "done — profile '${PROFILE}' applied"
}

main
