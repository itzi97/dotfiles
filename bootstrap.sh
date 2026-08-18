#!/usr/bin/env bash
#
# Bootstrap this machine: install packages, then apply dotfiles via dotbot.
#
#   ./bootstrap.sh                 # auto-detect machine profile from hostname
#   ./bootstrap.sh desktop         # force a profile
#   ./bootstrap.sh thinkpad --dry-run
#   ./bootstrap.sh --skip-packages
#
# Idempotent: safe to run repeatedly. Package installation is skipped unless
# the relevant package list has changed since the last successful run.

set -Eeuo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTBOT_DIR="${BASEDIR}/dotbot"
DOTBOT_BIN="${DOTBOT_DIR}/bin/dotbot"
BASE_CONFIG="${BASEDIR}/install.conf.yaml"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"

PROFILE=""
SKIP_PACKAGES=0
DOTBOT_ARGS=()

die() { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }
info() { printf '\033[36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[33mwarn:\033[0m %s\n' "$*" >&2; }

# ---------------------------------------------------------------- arguments
while (($#)); do
  case "$1" in
    --skip-packages) SKIP_PACKAGES=1 ;;
    -n|--dry-run)    DOTBOT_ARGS+=(--dry-run); SKIP_PACKAGES=1 ;;
    -v|--verbose)    DOTBOT_ARGS+=(-v) ;;
    -h|--help)       sed -n '2,12p' "${BASH_SOURCE[0]}" | sed 's/^# \?//'; exit 0 ;;
    -*)              die "unknown option: $1" ;;
    *)               PROFILE="$1" ;;
  esac
  shift
done

# ------------------------------------------------- package manager detection
# Detect by BINARY, not by /etc/os-release ID. This is deliberate: CachyOS
# reports ID=cachyos (not arch), so `[ "$ID" = arch ]` silently never fires.
# Testing for the package manager is both simpler and correct on every
# Arch or Fedora derivative.
detect_pkg_manager() {
  if command -v pacman >/dev/null 2>&1; then echo pacman
  elif command -v dnf   >/dev/null 2>&1; then echo dnf
  else echo unsupported
  fi
}

PKG_MANAGER="$(detect_pkg_manager)"
case "$PKG_MANAGER" in
  pacman) PKG_LIST="${BASEDIR}/packages/cachyos.txt" ;;
  dnf)    PKG_LIST="${BASEDIR}/packages/fedora.txt" ;;
  *)      warn "no supported package manager found; will only link dotfiles" ;;
esac
COMMON_LIST="${BASEDIR}/packages/common.txt"
AUR_LIST="${BASEDIR}/packages/aur.txt"
AUR_HELPER="paru"

# ------------------------------------------------------- profile resolution
if [[ -z "$PROFILE" ]]; then
  case "$(hostname -s 2>/dev/null || echo unknown)" in
    *desktop*|*cachy*) PROFILE=desktop ;;
    *think*|*pad*)     PROFILE=thinkpad ;;
    *)
      # Fall back to the package manager, which is a decent proxy given
      # desktop=CachyOS and thinkpad=Fedora.
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

info "machine profile : ${PROFILE}"
info "package manager : ${PKG_MANAGER}"

# ----------------------------------------------------------------- packages
# Strip comments, inline comments and blank lines from a package list.
clean_list() {
  sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$1"
}

# Hash-stamp idempotency, borrowed from chezmoi's run_onchange_ pattern:
# only reinstall when the list content actually changes.
list_hash() {
  # NOTE: each branch ends in `|| :` and the group ends in `true`. Without
  # that, a false [[ ]] on the last line becomes the group's exit status,
  # and `set -o pipefail` then fails the whole pipeline. This bit Fedora,
  # where the pacman-only AUR branch is always false.
  { [[ -f "$COMMON_LIST" ]] && clean_list "$COMMON_LIST" || :
    [[ -n "${PKG_LIST:-}" && -f "$PKG_LIST" ]] && clean_list "$PKG_LIST" || :
    # AUR list only affects the hash on Arch, so switching distros does not
    # invalidate the stamp for the wrong reason.
    [[ "$PKG_MANAGER" == pacman && -f "$AUR_LIST" ]] && clean_list "$AUR_LIST" || :
    true
  } | sha256sum | cut -d' ' -f1
}

# ---------------------------------------------------------------------- AUR
# Bootstrap paru from source, but only if no AUR helper is already present.
# Guarded so this never runs on a machine that already has one, and never
# on Fedora.
ensure_aur_helper() {
  command -v "$AUR_HELPER" >/dev/null 2>&1 && return 0
  # Respect an existing yay rather than installing a second helper.
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

  # Only ask the helper for what is actually missing. paru --needed already
  # does this, but filtering first keeps the output readable and avoids
  # touching packages that are present.
  local missing=()
  local p
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

  local pkgs=()
  mapfile -t pkgs < <( { [[ -f "$COMMON_LIST" ]] && clean_list "$COMMON_LIST"
                         [[ -f "$PKG_LIST" ]]    && clean_list "$PKG_LIST"; } | sort -u )

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
      # dnf is idempotent for already-installed packages.
      #
      # No `--` before the list: dnf5 rejects it ("Unknown argument \"--\" for
      # command install") where dnf4 accepted it. Found the hard way in tbx on
      # 2026-08-12, and this line had the identical bug — it had simply never
      # run, because bootstrap has never run on a Fedora machine.
      # --skip-unavailable so one renamed package doesn't block the rest; the
      # pacman branch keeps its `--`, which pacman does accept.
      sudo dnf install -y --skip-unavailable "${pkgs[@]}"
      ;;
  esac

  # AUR after repo packages: AUR builds frequently need base-devel and
  # headers from the official repos.
  install_aur_packages

  # Only stamp on success: set -e means a failed install aborts before this,
  # so a broken AUR build leaves the stamp untouched and the next run retries.
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
}

run_dotbot() {
  local config="$1"
  info "applying $(basename "$config")"
  "$DOTBOT_BIN" -d "$BASEDIR" -c "$config" "${DOTBOT_ARGS[@]+"${DOTBOT_ARGS[@]}"}"
}

# --------------------------------------------------------------------- main
main() {
  if ((SKIP_PACKAGES)); then
    info "skipping package installation (--skip-packages)"
  else
    install_packages
  fi

  ensure_dotbot
  run_dotbot "$BASE_CONFIG"
  run_dotbot "$PROFILE_CONFIG"

  info "done — profile '${PROFILE}' applied"
}

main
