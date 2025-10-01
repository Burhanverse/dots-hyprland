#!/bin/sh

OUTPUT=""
DEST="$HOME/.config/fastfetch/pkgscnt.txt"

# Create the directory if it doesn't exist
mkdir -p "$(dirname "$DEST")"

# Arch Linux family - prefer AUR helpers over pacman if available
if command -v yay >/dev/null 2>&1; then
    count=$(yay -Q 2>/dev/null | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (yay), "
elif command -v paru >/dev/null 2>&1; then
    count=$(paru -Q 2>/dev/null | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (paru), "
elif command -v pacman >/dev/null 2>&1; then
    count=$(pacman -Q 2>/dev/null | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (pacman), "
fi

# Debian/Ubuntu family - prefer apt over dpkg
if command -v apt >/dev/null 2>&1; then
    count=$(apt list --installed 2>/dev/null | tail -n +2 | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (apt), "
elif command -v dpkg >/dev/null 2>&1; then
    count=$(dpkg -l 2>/dev/null | grep '^ii' | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (dpkg), "
fi

# Red Hat family - prefer higher-level package managers over rpm
if command -v dnf >/dev/null 2>&1; then
    count=$(dnf list installed 2>/dev/null | tail -n +2 | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (dnf), "
elif command -v yum >/dev/null 2>&1; then
    count=$(yum list installed 2>/dev/null | tail -n +2 | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (yum), "
elif command -v rpm >/dev/null 2>&1; then
    count=$(rpm -qa 2>/dev/null | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (rpm), "
fi

# Flatpak
if command -v flatpak >/dev/null 2>&1; then
    count=$(flatpak list --columns=application 2>/dev/null | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (flatpak), "
fi

# Nix
if command -v nix-env >/dev/null 2>&1; then
    count=$(nix-env -q 2>/dev/null | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (nix), "
fi

# Snap
if command -v snap >/dev/null 2>&1; then
    count=$(snap list 2>/dev/null | tail -n +2 | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (snap), "
fi

# Homebrew
if command -v brew >/dev/null 2>&1; then
    count=$(brew list 2>/dev/null | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (brew), "
fi

# Cargo
if command -v cargo >/dev/null 2>&1; then
    count=$(cargo install --list 2>/dev/null | grep '^[a-zA-Z0-9_-]\+ v[0-9]' | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (cargo), "
fi

# Zypper (openSUSE)
if command -v zypper >/dev/null 2>&1; then
    count=$(zypper se --installed-only 2>/dev/null | grep '^i ' | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (zypper), "
fi

# Portage (Gentoo)
if command -v emerge >/dev/null 2>&1; then
    count=$(qlist -I 2>/dev/null | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (portage), "
fi

# APK (Alpine)
if command -v apk >/dev/null 2>&1; then
    count=$(apk info 2>/dev/null | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (apk), "
fi

# PKG (FreeBSD)
if command -v pkg >/dev/null 2>&1; then
    count=$(pkg info 2>/dev/null | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (pkg), "
fi

# Pip (Python packages)
if command -v pip >/dev/null 2>&1; then
    count=$(pip list 2>/dev/null | tail -n +3 | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (pip), "
fi

# NPM (Node.js packages)
if command -v npm >/dev/null 2>&1; then
    count=$(npm list -g --depth=0 2>/dev/null | grep -c '^[├└]')
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (npm), "
fi

# Gem (Ruby packages)
if command -v gem >/dev/null 2>&1; then
    count=$(gem list --local 2>/dev/null | wc -l)
    [ "$count" -gt 0 ] && OUTPUT="$OUTPUT$count (gem), "
fi

# Trim trailing comma and space
OUTPUT=$(echo "$OUTPUT" | sed 's/, $//')

# Write to file if OUTPUT is not empty
if [ -n "$OUTPUT" ]; then
    echo "$OUTPUT" > "$DEST"
fi
