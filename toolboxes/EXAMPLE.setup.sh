#!/usr/bin/env bash
# EXAMPLE — not run by tbx.
#
# tbx runs toolboxes/<boxname>.setup.sh, and there is no box called "EXAMPLE",
# so this file is inert. Copy the pattern you need into e.g. uni.setup.sh.
#
# ---------------------------------------------------------------------------
# Contract
# ---------------------------------------------------------------------------
#   - Runs INSIDE the box, before the package list is installed. Its job is to
#     make that list installable: enable a repo, add a key, register a COPR.
#   - Runs on EVERY sync, so it must be idempotent. Assume it has already run.
#   - It is hashed into the sync stamp, so editing it re-triggers a sync.
#   - A non-zero exit ABORTS before the package install. Fail loudly rather
#     than leaving packages that "mysteriously" won't resolve.
#   - `sudo` works and needs no password.
#   - $HOME is the host's unless the box sets tbx-home.
#
# Why this exists: three separate things needed a repo enabled before a package
# name would resolve — typst's COPR, RStudio's vendor RPM, and Claude Desktop's
# apt repo — and a flat package list cannot express "do this first". Three
# instances was enough.

set -Eeuo pipefail

# ---------------------------------------------------------------------------
# Pattern 1 — enable a COPR (Fedora images)
# ---------------------------------------------------------------------------
# `dnf copr enable -y` is idempotent; it no-ops if already enabled.
#
#   sudo dnf install -y 'dnf5-command(copr)'
#   sudo dnf copr enable -y claaj/typst

# ---------------------------------------------------------------------------
# Pattern 2 — a vendor RPM that isn't in any repo (e.g. RStudio)
# ---------------------------------------------------------------------------
# Guard on the binary, not on the RPM name, so a version bump doesn't reinstall
# and a partial install still gets repaired.
#
# Pin the version explicitly. A "latest" URL means the box you rebuild in March
# is not the box you built in September, which defeats the point of the list
# being the artefact.
#
#   RSTUDIO_VER="<fill in>"           # confirm at posit.co/download/rstudio-desktop/
#   RSTUDIO_RPM="rstudio-${RSTUDIO_VER}-x86_64.rpm"
#   if ! command -v rstudio >/dev/null 2>&1; then
#     tmp="$(mktemp -d)"
#     curl -fsSL -o "${tmp}/${RSTUDIO_RPM}" \
#       "https://download1.rstudio.org/electron/rhel8/x86_64/${RSTUDIO_RPM}"
#     sudo dnf install -y "${tmp}/${RSTUDIO_RPM}"
#     rm -rf "$tmp"
#   fi
#
# NOTE: R and RStudio must live on the SAME side of the container boundary.
# RStudio on the host cannot see an R that exists only in this box — it reports
# no R installation, and the cause is invisible from the error.

# ---------------------------------------------------------------------------
# Pattern 3 — an apt repo (non-Fedora image; set `# tbx-pm: apt` in the list)
# ---------------------------------------------------------------------------
# This is the Claude Desktop case: Anthropic's Linux build is Ubuntu 22.04+ /
# Debian 12+ only, from its own apt repo, so the box needs
# `# tbx-image: ubuntu:24.04` and `# tbx-pm: apt` alongside this.
#
# Verify the key fingerprint by hand the first time. A setup hook that pipes a
# key straight into a keyring is a supply-chain decision, not a convenience —
# see ADR-0016.
#
#   if [[ ! -f /etc/apt/keyrings/<vendor>.gpg ]]; then
#     sudo install -d -m 0755 /etc/apt/keyrings
#     curl -fsSL "https://<vendor>/gpg" \
#       | sudo gpg --dearmor -o /etc/apt/keyrings/<vendor>.gpg
#   fi
#   echo "deb [signed-by=/etc/apt/keyrings/<vendor>.gpg] https://<vendor>/apt stable main" \
#     | sudo tee /etc/apt/sources.list.d/<vendor>.list >/dev/null
#   sudo apt-get update -qq

echo "EXAMPLE.setup.sh is a template and does nothing." >&2
