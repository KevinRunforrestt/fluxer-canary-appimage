#!/bin/sh
# =============================================================================
# build.sh - Fluxer Canary AppImage (Anylinux methodology)
# =============================================================================
# Downloads Fluxer Canary tarball and packages it with quick-sharun.
# Based on pkgforge-dev/Discord-AppImage methodology.
# =============================================================================

set -eu

ARCH=$(uname -m)

# ---------------------------------------------------------------------------
# STEP 1: Install dependencies (Arch Linux)
# ---------------------------------------------------------------------------
echo "=== STEP 1: Install dependencies ==="

pacman -Syu --noconfirm libappindicator-gtk3 jq nodejs npm

if [ "$ARCH" = 'x86_64' ]; then
    pacman -Syu --noconfirm libva-intel-driver
fi

get-debloated-pkgs --add-common --prefer-nano intel-media-driver-mini

# ---------------------------------------------------------------------------
# STEP 2: Download Fluxer Canary tarball
# ---------------------------------------------------------------------------
echo ""
echo "=== STEP 2: Download Fluxer Canary ==="

FLUXER_URL="https://api.canary.fluxer.app/dl/desktop/canary/linux/x64/latest/tar_gz"
echo "Downloading from: $FLUXER_URL"

mkdir -p ./AppDir/bin
wget -q "$FLUXER_URL" -O - | tar xzf - --strip-components=1 -C ./AppDir/bin

# Extract version from directory name in the tarball
# Format: "Fluxer Canary-2026.824.124236-linux-x64"
VERSION=$(ls ./AppDir/bin/ 2>/dev/null | head -1 || echo "")
# Get version from tarball content - check for version pattern
if echo "$VERSION" | grep -qP '\d{4}\.\d+\.\d+'; then
    VERSION=$(echo "$VERSION" | grep -oP '\d{4}\.\d+\.\d+')
else
    # Fallback: extract from the binary itself
    VERSION="canary-$(date +%Y%m%d)"
fi
VERSION="${VERSION}-canary"
export VERSION
echo "Fluxer version: $VERSION"

# Make binaries and .so executable (quick-sharun needs +x for ldd)
chmod +x ./AppDir/bin/fluxer-canary ./AppDir/bin/fluxer_desktop_canary \
         ./AppDir/bin/chrome-sandbox ./AppDir/bin/chrome_crashpad_handler 2>/dev/null || true
chmod +x ./AppDir/bin/*.so* 2>/dev/null || true

echo "Files in AppDir/bin/: $(ls ./AppDir/bin/ | wc -l)"

# ---------------------------------------------------------------------------
# STEP 3: Create desktop file and icon
# ---------------------------------------------------------------------------
echo ""
echo "=== STEP 3: Create desktop file and icon ==="

# Use the icon bundled in Fluxer's resources
ICON_PATH=$(find ./AppDir/bin -name "256x256.png" -path "*/icons/*" | head -1)
if [ -z "$ICON_PATH" ]; then
    ICON_PATH=$(find ./AppDir/bin -name "icon.png" | head -1)
fi

cat > ./AppDir/fluxer.desktop <<EOF
[Desktop Entry]
Name=Fluxer Canary
Exec=fluxer-canary %U
Terminal=false
Type=Application
Icon=fluxer
StartupWMClass=fluxer-canary
GenericName=Internet Messenger
Categories=Network;
Keywords=fluxer;chat;electron;
Comment=Fluxer Canary desktop client
X-AppImage-Name=Fluxer
X-AppImage-Version=${VERSION}
X-AppImage-Arch=${ARCH}
EOF

# Copy icon to AppDir root (quick-sharun looks for it there)
cp "$ICON_PATH" ./AppDir/fluxer.png 2>/dev/null || true
cp "$ICON_PATH" ./AppDir/.DirIcon 2>/dev/null || true

echo "Desktop file and icon created"

# ---------------------------------------------------------------------------
# STEP 4: Package with quick-sharun
# ---------------------------------------------------------------------------
echo ""
echo "=== STEP 4: Package with quick-sharun ==="

export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook:fix-namespaces.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY:-Fluxer}|${GITHUB_REPOSITORY_NAME:-Fluxer}|latest|*${ARCH}.AppImage.zsync"
export DESKTOP="$(pwd)/AppDir/fluxer.desktop"
export ICON="$(pwd)/AppDir/fluxer.png"
export DEPLOY_PULSE=1
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1

# Deploy dependencies (same pattern as Discord-AppImage)
quick-sharun \
    ./AppDir/bin/*         \
    /usr/bin/jq            \
    /usr/lib/libatomic.so* \
    /usr/lib/libappindicator3.so*

# Generate AppImage
quick-sharun --make-appimage

echo ""
echo "=== Build complete ==="
echo "AppImage: $(ls -lh ./dist/*.AppImage | awk '{print $5, $9}')"
echo "Version: $VERSION"
echo "Zsync: $(ls ./dist/*.zsync 2>/dev/null || echo 'not found')"
