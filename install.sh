#!/bin/sh
# Install the standalone Vixel client. No Node, npm, Python, Bun or sudo required.
set -eu
version='0.5.7'
origin=''
download_base=''
prefix=''
upgrade=false
while [ "$#" -gt 0 ]; do
  case "$1" in
    --base-url) origin="$2"; shift 2 ;;
    --download-base-url) download_base="$2"; shift 2 ;;
    --prefix) prefix="$2"; shift 2 ;;
    --upgrade) upgrade=true; shift ;;
    *) echo 'Usage: sh install.sh --base-url https://your-platform [--download-base-url https://download-host/release] --prefix /your/install [--upgrade]' >&2; exit 2 ;;
  esac
done
if [ -z "$prefix" ]; then prefix="${HOME:?Use --prefix when HOME is unavailable}/.local"; fi
case "$origin" in https://*|http://localhost:*|http://127.0.0.1:*) ;; *) echo 'Specify HTTPS or an explicit loopback --base-url.' >&2; exit 2 ;; esac
case "$origin" in *'?'*|*'#'*|*'@'*|*' '*|*'\'*) echo 'Use a platform origin without credentials, query or fragment.' >&2; exit 2 ;; esac
origin=${origin%/}
if [ -z "$download_base" ]; then download_base="$origin/downloads"; fi
case "$download_base" in https://*|http://localhost:*|http://127.0.0.1:*) ;; *) echo 'Downloads require HTTPS or an explicit loopback URL.' >&2; exit 2 ;; esac
case "$download_base" in *'?'*|*'#'*|*'@'*|*' '*|*'\'*) echo 'Download URL must not contain credentials, query or fragment.' >&2; exit 2 ;; esac
download_base=${download_base%/}
redirect_protocols='=https'
case "$download_base" in http://localhost:*|http://127.0.0.1:*) redirect_protocols='=http,https' ;; esac
case "$(uname -s)" in Darwin) os=darwin ;; Linux) os=linux ;; *) echo 'Unsupported OS; Windows uses install.ps1.' >&2; exit 2 ;; esac
case "$(uname -m)" in arm64|aarch64) arch=arm64 ;; x86_64|amd64) arch=x64 ;; *) echo 'Unsupported architecture.' >&2; exit 2 ;; esac
filename="vixel-${version}-${os}-${arch}.tar.gz"
for required in curl tar mktemp; do command -v "$required" >/dev/null || exit 2; done
if command -v shasum >/dev/null; then checksum() { shasum -a 256 "$1" | cut -d ' ' -f 1; }
elif command -v sha256sum >/dev/null; then checksum() { sha256sum "$1" | cut -d ' ' -f 1; }
else echo 'SHA-256 utility required; refusing unverified install.' >&2; exit 2; fi
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
# No credentials are sent to the artifact host. Platform OAuth stays on origin.
curl -fsSL --max-redirs 5 --proto '=http,https' --proto-redir "$redirect_protocols" --max-time 300 "$download_base/$filename" -o "$tmp/archive"
curl -fsSL --max-redirs 5 --proto '=http,https' --proto-redir "$redirect_protocols" --max-time 30 "$download_base/vixel-${version}-checksums.txt" -o "$tmp/checksums"
expected=$(awk -v name="$filename" '$2 == name {print $1}' "$tmp/checksums")
actual=$(checksum "$tmp/archive")
[ -n "$expected" ] && [ "$actual" = "$expected" ] || { echo 'Checksum mismatch; nothing installed.' >&2; exit 1; }
[ "$(tar -tzf "$tmp/archive")" = 'vixel' ] || { echo 'Unexpected archive members.' >&2; exit 1; }
tar -xzf "$tmp/archive" -C "$tmp"
[ -f "$tmp/vixel" ] && [ ! -L "$tmp/vixel" ] || exit 1
mkdir -p "$prefix/bin"
dest="$prefix/bin/vixel"
[ ! -L "$dest" ] || { echo 'Existing symlink preserved; choose another prefix.' >&2; exit 1; }
binary_hash=$(checksum "$tmp/vixel")
installed_hash=""
if [ -f "$dest" ]; then installed_hash=$(checksum "$dest"); fi
if [ -e "$dest" ] && [ "$installed_hash" != "$binary_hash" ] && [ "$upgrade" != true ]; then
  echo 'A different Vixel binary exists. Review the upgrade, then rerun with --upgrade.' >&2; exit 1
fi
if [ ! -e "$dest" ] || [ "$installed_hash" != "$binary_hash" ]; then
  staged=$(mktemp "$prefix/bin/.vixel-install.XXXXXX")
  cp "$tmp/vixel" "$staged"; chmod 755 "$staged"; mv -f "$staged" "$dest"
fi
"$dest" version
printf '\nInstalled: %s\nNext: run this executable with setup --directory YOUR_AGENT_FOLDER --base-url %s\n' "$dest" "$origin"
