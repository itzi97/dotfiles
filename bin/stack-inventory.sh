#!/usr/bin/env bash
#
# stack-inventory — dump what is installed on this machine and where it came from.
# Read-only. Changes nothing. Output is the input to the ADR-0012 tiering exercise.
#
#   stack-inventory.sh [output-file]     # default: ~/stack-inventory.txt

set -Eeuo pipefail
out="${1:-$HOME/stack-inventory.txt}"

TMPD="$(mktemp -d)"
trap 'rm -rf "$TMPD"' EXIT

# --- dnf5 quirks, learned on Fedora 44 (2026-08-12) -------------------------
# The first version of this script produced two useless sections. Both causes
# are dnf5 behaviour changes, and both are easy to reintroduce:
#
#   1. `dnf repoquery` DEDUPLICATES identical output lines. A query printing
#      only %{from_repo} therefore collapses to one line per repo, and
#      `uniq -c` reports 1 for everything. Always include %{name} in the
#      format so every line is unique.
#   2. dnf5's --qf expands `\n` but NOT `\t`. The first attempt emitted a
#      literal backslash-t; the second attempt fixed that with a real tab but
#      dropped the `\n`, and without it dnf5 emits NO record separator at all —
#      every package ran together into one 70KB line. Both escapes matter and
#      they are not handled the same way. Sidestepped entirely below: a literal
#      `|` separator (needs no escaping) plus `\n` (the one escape dnf5 honours).
#   3. Packages laid down by the live-ISO installer carry a GENERATED repo id
#      — a 32-char hex string — not "anaconda", not "@System". A third-party
#      filter that doesn't exclude that id lets the entire base system through,
#      which is how a 12-line section became 1280 lines.
#
# Consequence of (3) worth remembering when reading the output: on a live-ISO
# install, `dnf history userinstalled` claims the whole base system. That list
# is not "things I chose". The base-install id is subtracted below to get a
# list that actually is.
#
# Because (2) has now bitten twice in two different ways, the query result is
# sanity-checked before anything is derived from it. A silently-collapsed query
# produced confident, wrong output last time; a loud WARNING in the file is the
# cheaper failure.
SEP='|'

dnf_from_repo() {
  # Package names cannot contain '|', so it is a safe separator.
  dnf repoquery --installed --qf "%{name}${SEP}%{from_repo}\n" 2>/dev/null
}

{
  echo "### os"
  grep -E '^(NAME|VERSION)=' /etc/os-release
  echo "hostname: $(hostname -s 2>/dev/null || echo unknown)"

  if command -v dnf >/dev/null 2>&1; then
    dnf_from_repo | sort -u > "$TMPD/fromrepo" || true

    # --- sanity check the query before trusting any of it ------------------
    # rpm is the ground truth for "how many packages are installed". If the
    # repoquery came back with wildly fewer records than that, the format
    # string broke again and every section below it would be confident garbage.
    rpm_count="$(rpm -qa 2>/dev/null | wc -l)"
    fr_count="$(wc -l < "$TMPD/fromrepo")"
    dnf_ok=1
    if (( rpm_count > 0 )) && (( fr_count < rpm_count / 2 )); then
      dnf_ok=0
      echo -e "\n### !! WARNING — dnf repoquery returned $fr_count records for $rpm_count installed packages"
      echo "The --qf record separator has broken again (see the dnf5 notes at the top"
      echo "of this script). Every dnf section below is UNRELIABLE — do not tier from"
      echo "it. Raw first 200 bytes of the query result, for diagnosis:"
      head -c 200 "$TMPD/fromrepo"; echo
    fi

    # --- what was actually done to this machine ---------------------------
    # The single most useful section in this file, and the cheapest. On a
    # spin install the history is short, and it is a literal log of every
    # decision — including the ones that turned out to cost thousands of
    # packages. Read this before reading any package list.
    echo -e "\n### dnf — transaction history (every command run on this machine)"
    dnf history list 2>/dev/null || echo "  (unavailable)"

    # --- base image, from transaction 1 -----------------------------------
    # %{from_repo} records the LAST transaction to touch a package, so a few
    # weeks of updates destroy it as a base-install signal: by the third
    # capture on the ThinkPad, 4,571 of 6,375 packages had drifted to
    # "updates" and the subtraction removed only the not-yet-patched subset.
    #
    # Transaction 1 is stable. On a live-ISO install it is not even a
    # transaction on this hardware — it is the kiwi image build on Fedora's
    # builders (check the Description line: --installroot /builddir/...),
    # months before the machine was installed, because the ISO ships a
    # prebuilt rpmdb. That makes it exactly the set to subtract.
    #
    # NEVRA in `history info` always carries an epoch — name-EPOCH:VER-REL.ARCH
    # — so stripping at the last `-<digits>:` reliably recovers the name.
    dnf history info 1 2>/dev/null \
      | awk '$1=="Install"{print $2}' \
      | sed -E 's/-[0-9]+:.*$//' \
      | grep -E '^[a-zA-Z0-9]' | sort -u > "$TMPD/base_hist" || true

    # Fallback for netinstalls / missing history: the old from_repo heuristic.
    install_repo="$(awk -F'|' '$2 ~ /^[0-9a-f]{32}$/ {print $2; exit}' "$TMPD/fromrepo")"
    awk -F'|' -v r="${install_repo:-__none__}" '$2==r{print $1}' "$TMPD/fromrepo" \
      | sort -u > "$TMPD/base_repo"

    if [[ -s "$TMPD/base_hist" ]]; then
      cp "$TMPD/base_hist" "$TMPD/base"; base_src="dnf history transaction 1"
    else
      cp "$TMPD/base_repo" "$TMPD/base"; base_src="from_repo heuristic (weaker — see notes)"
    fi

    echo -e "\n### dnf — base install"
    if (( dnf_ok == 0 )); then
      echo "skipped — query unreliable, see warning above."
    else
      echo "base identified via: ${base_src}"
      # sed, not awk -F':' — the timestamp contains colons too.
      echo "transaction 1 began: $(dnf history info 1 2>/dev/null | sed -n 's/^Begin time *: *//p' | head -n1)"
      echo "packages in the base image:  $(wc -l < "$TMPD/base")"
      echo "(cross-check, from_repo method: $(wc -l < "$TMPD/base_repo"))"
      echo "these are the spin's contents, NOT choices. Subtracted below."
    fi

    { dnf history userinstalled 2>/dev/null \
        || dnf repoquery --userinstalled --qf '%{name}\n' 2>/dev/null; } \
      | grep -E '^[a-zA-Z0-9]' | awk '{print $1}' | sort -u > "$TMPD/userinstalled" || true

    echo -e "\n### dnf — explicitly installed, MINUS the base install"
    echo "(the short list. This is the one to read.)"
    echo "userinstalled: $(wc -l < "$TMPD/userinstalled")  base: $(wc -l < "$TMPD/base")"
    comm -23 "$TMPD/userinstalled" "$TMPD/base" || true

    echo -e "\n### dnf — installed package count per source repo"
    awk -F'|' '{print $2}' "$TMPD/fromrepo" | sort | uniq -c | sort -rn

    # @commandline means `dnf install ./some.rpm` — a hand-downloaded file with NO
    # repo behind it, so it will never be updated by `dnf upgrade`. That is the most
    # important category in this whole file and the first version filtered it out as
    # noise. It gets its own section.
    echo -e "\n### dnf — hand-installed RPMs (@commandline) — NO UPDATE PATH"
    awk -F'|' '$2=="@commandline"{print "  " $1}' "$TMPD/fromrepo" \
      | sort | { grep . || echo "  (none)"; }
    echo "  ^ these were installed from a downloaded .rpm. dnf upgrade will never"
    echo "    touch them. Check for a real repo, or diarise re-downloading them."

    echo -e "\n### dnf — NOT from the stock fedora repos (third-party, copr, hand-installed rpm)"
    awk -F'|' -v r="${install_repo:-__none__}" \
      '$2!=r && $2 !~ /^(fedora|updates|updates-testing|updates-archive|fedora-cisco-openh264|anaconda|@System)$/ {printf "%s\t%s\n", $2, $1}' \
      "$TMPD/fromrepo" | sort | { grep . || echo "  (none)"; }

    echo -e "\n### repos enabled"
    dnf repolist --enabled
  fi

  if command -v pacman >/dev/null 2>&1; then
    echo -e "\n### pacman — explicitly installed, from the official repos"
    pacman -Qqen
    echo -e "\n### pacman — foreign (AUR or hand-built)"
    pacman -Qqem
  fi

  echo -e "\n### flatpak"
  flatpak list --columns=application,origin,installation 2>/dev/null || echo "  (flatpak absent)"

  echo -e "\n### containers"
  distrobox list 2>/dev/null || true
  toolbox list  2>/dev/null || true
  podman ps -a --format '{{.Names}}\t{{.Image}}' 2>/dev/null || true

  echo -e "\n### language-level installs (the ones that rot quietly)"
  echo "-- pip --user:";    pip list --user 2>/dev/null || true
  echo "-- pipx:";          pipx list --short 2>/dev/null || true
  echo "-- npm -g:";        npm ls -g --depth=0 2>/dev/null || true
  echo "-- cargo:";         ls -1 ~/.cargo/bin 2>/dev/null || true
  echo "-- go:";            ls -1 ~/go/bin 2>/dev/null || true
  echo "-- ~/.local/bin:";  ls -1 ~/.local/bin 2>/dev/null || true
  # conda/mamba distributions install a whole userland into $HOME from a vendor .sh
  # and are invisible to every check above. They also run `conda init`, which appends
  # a block to ~/.bashrc — a file dotbot symlinks into the repo.
  echo "-- conda/mamba prefixes:"
  for c in ~/miniforge3 ~/miniconda3 ~/anaconda3 ~/mambaforge ~/.local/share/mamba; do
    [[ -d "$c" ]] && echo "   ${c/#$HOME/\~}  ($(du -sh "$c" 2>/dev/null | cut -f1))"
  done
  command -v conda >/dev/null 2>&1 && echo "   conda on PATH: $(command -v conda)"
  echo "-- conda envs:"; conda env list 2>/dev/null | sed 's/^/   /' || echo "   (conda not on PATH)"
  echo "-- shell rc files touched by installers:"
  # Only pass files that exist: with `set -o pipefail`, grep exits 2 on a missing
  # file even when it found a match, which made the fallback fire on a true positive.
  rcs=(); for f in ~/.bashrc ~/.bash_profile ~/.profile ~/.config/fish/config.fish; do
    [[ -f "$f" ]] && rcs+=("$f")
  done
  if ((${#rcs[@]})); then
    # `|| true` is load-bearing: no match means grep exits 1, and with pipefail +
    # set -e that aborted the whole script before the sections below it.
    grep -lE 'conda initialize|mamba|miniforge' "${rcs[@]}" 2>/dev/null \
      | sed "s|^$HOME|~|; s/^/   /" | { grep . || echo "   (none)"; } || true
  else
    echo "   (no rc files)"
  fi

  # --- the blind spot ---------------------------------------------------
  # Everything above asks a package manager what it knows about. Software
  # installed by a vendor's own installer — game launchers, AppImages placed
  # by Gear Lever, tarballs unpacked into $HOME — is invisible to all of it,
  # and by definition that is the software with no upgrade path and no
  # uninstall. The 2026-08-12 capture reported "AppImages: (none)" on a
  # machine that had Gear Lever installed and a game launcher in $HOME,
  # because it only ever looked in ~/Applications.
  #
  # User .desktop files are the reliable catch-all: anything that wants to
  # appear in the launcher has to write one, whatever it was installed by.
  # ~/Desktop is included deliberately: a hand-wired app may drop its launcher there
  # instead of in the applications dir, which is how the containerised Claude Desktop
  # entry was missed on the 2026-08-12 capture.
  echo -e "\n### user .desktop entries (catches installers no package manager knows about)"
  for dir in ~/.local/share/applications ~/Desktop; do
    [[ -d "$dir" ]] || continue
    for d in "$dir"/*.desktop; do
      [[ -e "$d" ]] || continue
      printf '%-48s %s\n' "${dir/#$HOME/\~}/$(basename "$d")" \
        "$(sed -n 's/^Exec=//p' "$d" | head -n1)"
    done
  done | { grep . || echo "  (none)"; }

  echo -e "\n### AppImages"
  for d in ~/Applications ~/AppImages ~/.local/share/AppImages ~/.local/bin; do
    [[ -d "$d" ]] || continue
    find "$d" -maxdepth 1 -iname '*.appimage' -printf '%p\n' 2>/dev/null
  done | sort -u | { grep . || echo "  (none found in the usual locations)"; }

  echo -e "\n### enabled user services"
  systemctl --user list-unit-files --state=enabled 2>/dev/null || true

  echo -e "\n### top-level entries in ~ (ALL, not just hidden)"
  # Was `-name '.*'` only, which hid every vendor installer that drops a
  # normally-named directory in $HOME — the exact thing worth catching.
  find ~ -maxdepth 1 -mindepth 1 -printf '%y %f\n' 2>/dev/null | sort -k2
} > "$out"

echo "wrote $out"
