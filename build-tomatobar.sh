#!/usr/bin/env bash
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="/Applications"
APP="TomatoBar.app"

cd "$SRC"

echo "==> building"
xcodebuild \
    -project TomatoBar.xcodeproj \
    -scheme TomatoBar \
    -configuration Release \
    -derivedDataPath ./.build \
    CODE_SIGN_STYLE=Manual \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGNING_REQUIRED=YES \
    CODE_SIGNING_ALLOWED=YES \
    DEVELOPMENT_TEAM="" \
    PROVISIONING_PROFILE_SPECIFIER="" \
    build

BUILT="./.build/Build/Products/Release/${APP}"
[ -d "$BUILT" ] || { echo "!! build product not found at $BUILT" >&2; exit 1; }

echo "==> installing to ${DEST}/${APP}"
osascript -e 'quit app "TomatoBar"' 2>/dev/null || true
sleep 1
rm -rf "${DEST:?}/${APP}"
cp -R "$BUILT" "${DEST}/${APP}"

open "${DEST}/${APP}"
echo "==> done"